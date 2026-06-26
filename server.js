require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { v4: uuidv4 } = require('uuid');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const axios = require('axios');
const { DB, saveDb } = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

/* ============================================================
   CONFIGURAÇÕES E VARIÁVEIS DE AMBIENTE
   ============================================================ */
const JWT_SECRET = process.env.JWT_SECRET || 'saturn_secret_2024';
const ADMIN_ROUTE_SECRET = process.env.ADMIN_ROUTE_SECRET || 'saturn_secret_hash_2026';
const DYNAMIC_ADMIN_PATH = '/' + crypto.createHash('sha256').update(ADMIN_ROUTE_SECRET).digest('hex');
const DISCORD_WEBHOOK_URL = process.env.DISCORD_WEBHOOK_URL || '';
const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY || 'default_encryption_key_2024';
const LOADER_USER_AGENT_BLOCK = process.env.LOADER_USER_AGENT_BLOCK !== 'false'; // padrão true

console.log(`\n[SEGURANÇA] URL administrativa: http://localhost:${PORT}${DYNAMIC_ADMIN_PATH}\n`);
if (DISCORD_WEBHOOK_URL) {
  console.log('[DISCORD] Notificações via webhook ativadas.');
} else {
  console.log('[DISCORD] Nenhuma webhook configurada (logs locais apenas).');
}

/* ============================================================
   SEGURANÇA BÁSICA
   ============================================================ */
app.set('trust proxy', 1);
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false
}));
app.use(express.json({ limit: '10mb' })); // Permite payloads maiores para upload de scripts grandes
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

/* ============================================================
   LIMITADORES DE REQUISIÇÃO (RATE LIMIT)
   ============================================================ */
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5,
  message: { error: 'Muitas tentativas de login. Tente novamente mais tarde.' }
});

const apiLimiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  max: 200,
  message: { error: 'Muitas requisições. Aguarde um instante.' }
});

const loaderLimiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  max: 100,
  message: 'Rate limit exceeded.'
});

/* ============================================================
   INICIALIZAÇÃO DO BANCO DE DADOS EM MEMÓRIA
   ============================================================ */
DB.scripts = DB.scripts || [];
DB.admins = DB.admins || [];
DB.versions = DB.versions || [];
DB.logs = DB.logs || [];

/* ============================================================
   FUNÇÕES AUXILIARES
   ============================================================ */

/**
 * Registra um log local (armazenado em DB.logs)
 */
function logLocal(action, details, req) {
  const entry = {
    id: Date.now(),
    action,
    details: String(details),
    ip: req?.ip || 'unknown',
    user_agent: req?.get('User-Agent') || '',
    created_at: new Date().toISOString()
  };
  DB.logs.push(entry);
  // Limita a 2000 entradas
  if (DB.logs.length > 2000) {
    DB.logs = DB.logs.slice(-2000);
  }
  saveDb();
}

/**
 * Envia um embed para o Discord via webhook (se configurado)
 */
async function sendDiscordEmbed(title, description, fields = [], color = 0x6366f1) {
  if (!DISCORD_WEBHOOK_URL) return;
  try {
    await axios.post(DISCORD_WEBHOOK_URL, {
      embeds: [{
        title,
        description,
        color,
        fields,
        timestamp: new Date().toISOString(),
        footer: { text: 'Saturn Storage' }
      }]
    }, { timeout: 5000 });
  } catch (err) {
    console.error('[DISCORD] Erro ao enviar webhook:', err.message);
  }
}

/**
 * Registra uma ação importante tanto no log local quanto no Discord.
 */
async function logEvent(action, details, req, extraFields = []) {
  // Log local
  logLocal(action, details, req);

  // Log Discord (embed)
  const fields = [
    { name: 'Ação', value: action, inline: true },
    { name: 'IP', value: req?.ip || 'N/A', inline: true },
    { name: 'Data', value: new Date().toLocaleString('pt-BR'), inline: true },
    { name: 'Detalhes', value: String(details).substring(0, 1024) || 'N/A' }
  ];
  if (extraFields.length) {
    fields.push(...extraFields);
  }
  await sendDiscordEmbed('📢 Nova Atividade', `**${action}**`, fields);
}

/**
 * Gera um ID curto (8 caracteres hex) para encurtar URLs.
 */
function generateShortId() {
  return crypto.randomBytes(4).toString('hex');
}

/**
 * Middleware de autenticação (verifica cookie JWT).
 */
function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) {
    return res.status(401).json({ error: 'Acesso negado. Token ausente.' });
  }
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch (err) {
    res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax', path: '/' });
    return res.status(401).json({ error: 'Sessão expirada. Faça login novamente.' });
  }
}

/* ============================================================
   ROTAS DE AUTENTICAÇÃO
   ============================================================ */
app.post('/api/auth/login', loginLimiter, async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Usuário e senha são obrigatórios.' });
  }

  const admin = DB.admins.find(a => a.username === username);
  if (!admin || !bcrypt.compareSync(password, admin.password_hash)) {
    await logLocal('LOGIN_FAILED', `Tentativa falha para usuário: ${username}`, req);
    return res.status(401).json({ error: 'Credenciais inválidas.' });
  }

  const token = jwt.sign(
    { id: admin.id, username: admin.username, role: admin.role || 'admin' },
    JWT_SECRET,
    { expiresIn: '8h' }
  );

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    path: '/',
    maxAge: 8 * 60 * 60 * 1000
  });

  await logEvent('LOGIN_SUCCESS', `Usuário ${username} autenticado.`, req);
  return res.json({
    success: true,
    redirectPath: `${DYNAMIC_ADMIN_PATH}/dashboard`
  });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token', {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    path: '/'
  });
  return res.json({
    success: true,
    redirectPath: DYNAMIC_ADMIN_PATH
  });
});

app.get('/api/auth/me', authMiddleware, (req, res) => {
  return res.json({
    username: req.user.username,
    role: req.user.role
  });
});

/* ============================================================
   ROTAS DE SCRIPTS (CRUD, BULK, VERSÕES, ETC.)
   ============================================================ */
app.use('/api/scripts', apiLimiter);

// Listar todos os scripts (sem conteúdo sensível)
app.get('/api/scripts', authMiddleware, (req, res) => {
  const scripts = DB.scripts.map(s => ({
    id: s.id,
    name: s.name,
    status: s.status,
    executions: s.executions || 0,
    short_id: s.short_id,
    created_at: s.created_at,
    updated_at: s.updated_at
  }));
  return res.json(scripts);
});

// Obter um script completo
app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) {
    return res.status(404).json({ error: 'Script não encontrado.' });
  }
  return res.json(script);
});

// Criar novo script
app.post('/api/scripts', authMiddleware, async (req, res) => {
  const { name, content, status } = req.body;
  if (!name || !name.trim() || !content) {
    return res.status(400).json({ error: 'Nome e conteúdo são obrigatórios.' });
  }

  const script = {
    id: uuidv4(),
    name: name.trim(),
    content,
    status: status === 'offline' ? 'offline' : 'online',
    executions: 0,
    short_id: generateShortId(),
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };

  DB.scripts.push(script);
  saveDb();

  await logEvent('SCRIPT_CREATED', `Script "${script.name}" criado.`, req, [
    { name: 'ID', value: script.id, inline: true },
    { name: 'Status', value: script.status, inline: true }
  ]);
  return res.status(201).json(script);
});

// Upload em massa de múltiplos scripts
app.post('/api/scripts/bulk', authMiddleware, async (req, res) => {
  const { scripts } = req.body;
  if (!Array.isArray(scripts) || scripts.length === 0) {
    return res.status(400).json({ error: 'Envie um array de scripts com nome e conteúdo.' });
  }

  const created = [];
  for (const s of scripts) {
    if (!s.name || !s.content) continue;
    const script = {
      id: uuidv4(),
      name: s.name.trim(),
      content: s.content,
      status: 'online',
      executions: 0,
      short_id: generateShortId(),
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };
    DB.scripts.push(script);
    created.push(script);
  }

  if (created.length === 0) {
    return res.status(400).json({ error: 'Nenhum script válido foi enviado.' });
  }

  saveDb();
  await logEvent('BULK_CREATED', `${created.length} scripts criados em massa.`, req);
  return res.status(201).json(created);
});

// Atualizar script (com histórico de versões)
app.put('/api/scripts/:id', authMiddleware, async (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) {
    return res.status(404).json({ error: 'Script não encontrado.' });
  }

  // Salva versão anterior
  DB.versions.push({
    id: uuidv4(),
    script_id: script.id,
    name: script.name,
    content: script.content,
    status: script.status,
    created_at: new Date().toISOString()
  });

  const { name, content, status } = req.body;
  if (name !== undefined) script.name = name.trim();
  if (content !== undefined) script.content = content;
  if (status !== undefined) script.status = status;
  script.updated_at = new Date().toISOString();

  saveDb();
  await logEvent('SCRIPT_UPDATED', `Script "${script.name}" atualizado.`, req);
  return res.json(script);
});

// Excluir script
app.delete('/api/scripts/:id', authMiddleware, async (req, res) => {
  const index = DB.scripts.findIndex(s => s.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ error: 'Script não encontrado.' });
  }

  const removed = DB.scripts.splice(index, 1)[0];
  // Remove versões relacionadas
  DB.versions = DB.versions.filter(v => v.script_id !== req.params.id);
  saveDb();

  await logEvent('SCRIPT_DELETED', `Script "${removed.name}" excluído.`, req);
  return res.json({ success: true });
});

// Duplicar script
app.post('/api/scripts/:id/duplicate', authMiddleware, async (req, res) => {
  const original = DB.scripts.find(s => s.id === req.params.id);
  if (!original) {
    return res.status(404).json({ error: 'Script não encontrado.' });
  }

  const duplicated = {
    ...original,
    id: uuidv4(),
    name: original.name + ' (cópia)',
    executions: 0,
    short_id: generateShortId(),
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };
  DB.scripts.push(duplicated);
  saveDb();

  await logEvent('SCRIPT_DUPLICATED', `Script "${original.name}" duplicado.`, req);
  return res.status(201).json(duplicated);
});

// Histórico de versões de um script
app.get('/api/scripts/:id/versions', authMiddleware, (req, res) => {
  const versions = DB.versions
    .filter(v => v.script_id === req.params.id)
    .sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
  return res.json(versions);
});

// Restaurar uma versão anterior
app.post('/api/scripts/:id/restore', authMiddleware, async (req, res) => {
  const { versionId } = req.body;
  const version = DB.versions.find(v => v.id === versionId);
  if (!version || version.script_id !== req.params.id) {
    return res.status(404).json({ error: 'Versão não encontrada.' });
  }

  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) {
    return res.status(404).json({ error: 'Script não encontrado.' });
  }

  // Salva o estado atual como uma nova versão antes de restaurar
  DB.versions.push({
    id: uuidv4(),
    script_id: script.id,
    name: script.name,
    content: script.content,
    status: script.status,
    created_at: new Date().toISOString()
  });

  script.name = version.name;
  script.content = version.content;
  script.status = version.status;
  script.updated_at = new Date().toISOString();
  saveDb();

  await logEvent('VERSION_RESTORED', `Script "${script.name}" restaurado para versão de ${new Date(version.created_at).toLocaleString('pt-BR')}.`, req);
  return res.json(script);
});

/* ============================================================
   EXPORTAÇÃO / IMPORTAÇÃO DE DADOS
   ============================================================ */
app.get('/api/export', authMiddleware, (req, res) => {
  const data = {
    scripts: DB.scripts,
    versions: DB.versions,
    logs: DB.logs
  };
  return res.json(data);
});

app.post('/api/import', authMiddleware, async (req, res) => {
  const { scripts, versions, logs } = req.body;
  if (!Array.isArray(scripts)) {
    return res.status(400).json({ error: 'Formato inválido: esperado array "scripts".' });
  }

  DB.scripts = scripts;
  DB.versions = Array.isArray(versions) ? versions : [];
  DB.logs = Array.isArray(logs) ? logs : [];
  saveDb();

  await logEvent('DATA_IMPORTED', `${DB.scripts.length} scripts importados.`, req);
  return res.json({
    success: true,
    imported: DB.scripts.length
  });
});

/* ============================================================
   LOGS DE EXECUÇÃO (CONSULTA)
   ============================================================ */
app.get('/api/logs', authMiddleware, (req, res) => {
  const limit = parseInt(req.query.limit) || 50;
  const logs = DB.logs.slice(-limit).reverse();
  return res.json(logs);
});

/* ============================================================
   ESTATÍSTICAS (DASHBOARD)
   ============================================================ */
app.get('/api/stats', authMiddleware, (req, res) => {
  const totalScripts = DB.scripts.length;
  const onlineScripts = DB.scripts.filter(s => s.status === 'online').length;
  const totalExecutions = DB.scripts.reduce((acc, s) => acc + (s.executions || 0), 0);
  const today = new Date().toISOString().split('T')[0];
  const executionsToday = DB.logs.filter(l => l.action === 'SCRIPT_EXEC' && l.created_at?.startsWith(today)).length;
  const recentLogs = DB.logs.slice(-10).reverse();

  return res.json({
    totalScripts,
    onlineScripts,
    totalExecutions,
    executionsToday,
    recentLogs
  });
});

// Dados para gráfico de execuções diárias
app.get('/api/stats/executions', authMiddleware, (req, res) => {
  const days = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    days.push(d.toISOString().split('T')[0]);
  }
  const data = days.map(day => ({
    date: day,
    count: DB.logs.filter(l => l.action === 'SCRIPT_EXEC' && l.created_at?.startsWith(day)).length
  }));
  return res.json(data);
});

/* ============================================================
   FEEDBACK DE ERRO (OPCIONAL)
   ============================================================ */
app.post('/api/report', async (req, res) => {
  const { script_id, error, hwid } = req.body;
  if (!script_id || !error) {
    return res.status(400).json({ error: 'script_id e error são obrigatórios.' });
  }
  await logEvent('SCRIPT_ERROR_REPORT', `Script ID: ${script_id} | Erro: ${error} | HWID: ${hwid || 'N/A'}`, req);
  return res.json({ received: true });
});

/* ============================================================
   ENCURTADOR DE URLS (LINK CURTO)
   ============================================================ */
app.get('/s/:shortId', (req, res) => {
  const script = DB.scripts.find(s => s.short_id === req.params.shortId);
  if (!script) {
    return res.status(404).send('Link não encontrado.');
  }

  const userAgent = (req.get('User-Agent') || '').toLowerCase();
  const isBrowser = /mozilla|chrome|safari|edge|firefox|opera/i.test(userAgent);

  if (isBrowser) {
    // Redireciona para a página de key (que mostra uma interface amigável)
    return res.redirect(`/get/${script.id}`);
  }
  // Caso contrário, redireciona para o loader direto
  return res.redirect(`/api/load/${script.id}`);
});

/* ============================================================
   LOADER PÚBLICO (PROTEÇÃO CONTRA NAVEGADORES)
   ============================================================ */
app.get('/api/load/:id', loaderLimiter, (req, res) => {
  const userAgent = (req.get('User-Agent') || '').toLowerCase();
  const isBrowser = /mozilla|chrome|safari|edge|firefox|opera/i.test(userAgent);

  if (LOADER_USER_AGENT_BLOCK && isBrowser) {
    // Exibe uma página de bloqueio estilizada
    return res.status(403).send(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title>403 Forbidden</title>
        <style>
          body { background-color: #0b0b0b; color: #555; font-family: monospace; padding: 50px; text-align: center; }
          h1 { color: #dd3333; font-size: 2rem; margin-bottom: 10px; }
          p { font-size: 1rem; }
          .container { max-width: 600px; margin: 100px auto; border: 1px solid #222; padding: 40px; border-radius: 8px; background: #111; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>HTTP Error 403 - Forbidden</h1>
          <p>Access to the requested infrastructure resource is strictly prohibited.</p>
          <hr style="border-color: #222; margin: 20px 0;">
          <p style="color: #333; font-size: 0.8rem;">Saturn Security Protocol Node v4.0</p>
        </div>
      </body>
      </html>
    `);
  }

  const script = DB.scripts.find(s => s.id === req.params.id && s.status === 'online');
  if (!script) {
    return res.status(404).send('-- Erro: Script indisponível ou em manutenção.');
  }

  script.executions = (script.executions || 0) + 1;
  saveDb();

  // Log da execução (silencioso para não encher o Discord, mas registra localmente)
  logLocal('SCRIPT_EXEC', `Script "${script.name}" executado`, req);

  res.type('text/plain');
  return res.send(script.content);
});

/* ============================================================
   PÁGINA DE STATUS PÚBLICA
   ============================================================ */
app.get('/status', (req, res) => {
  const onlineScripts = DB.scripts.filter(s => s.status === 'online').length;
  const totalScripts = DB.scripts.length;
  const totalExecutions = DB.scripts.reduce((acc, s) => acc + (s.executions || 0), 0);
  const html = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Saturn Status</title>
  <style>
    body { background:#0a0a0a; color:#fff; font-family:'Inter',sans-serif; display:flex; align-items:center; justify-content:center; min-height:100vh; margin:0; }
    .card { background:#111; border:1px solid #1f1f1f; border-radius:16px; padding:2.5rem; text-align:center; max-width:400px; width:90%; }
    h1 { margin-bottom:0.5rem; }
    p { color:#a0a0a0; }
    .stat { font-size:2rem; font-weight:800; margin:0.5rem 0; }
    .dot { display:inline-block; width:10px; height:10px; background:#10b981; border-radius:50%; margin-right:0.5rem; }
  </style>
</head>
<body>
  <div class="card">
    <h1>🪐 Saturn</h1>
    <p>Sistema operacional</p>
    <div class="stat"><span class="dot"></span>${onlineScripts} / ${totalScripts} scripts online</div>
    <p>${totalExecutions} execuções totais</p>
  </div>
</body>
</html>`;
  res.send(html);
});

/* ============================================================
   PÁGINA DE KEY (INTERFACE PARA VISUALIZAÇÃO DE SCRIPT)
   ============================================================ */
app.get('/get/:scriptId', (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.scriptId && s.status === 'online');
  if (!script) {
    return res.status(404).send('Script não encontrado.');
  }
  // Servir um HTML simples (já existente em public/get.html se quiser customizar)
  res.sendFile(path.join(__dirname, 'public', 'get.html'));
});

/* ============================================================
   PÁGINAS ESTÁTICAS
   ============================================================ */
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Rota administrativa dinâmica (segurança)
app.get(DYNAMIC_ADMIN_PATH, (req, res) => {
  res.sendFile(path.join(__dirname, 'public/admin/login.html'));
});

app.get(`${DYNAMIC_ADMIN_PATH}/dashboard`, authMiddleware, (req, res) => {
  res.sendFile(path.join(__dirname, 'public/admin/dashboard.html'));
});

// Ocultar rotas antigas
app.get('/admin', (req, res) => res.status(404).send('Cannot GET /admin'));
app.get('/admin/dashboard', (req, res) => res.status(404).send('Cannot GET /admin/dashboard'));

/* ============================================================
   INICIALIZAÇÃO DO ADMIN PADRÃO
   ============================================================ */
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';
if (!DB.admins.find(a => a.username === ADMIN_USER)) {
  DB.admins.push({
    id: 1,
    username: ADMIN_USER,
    password_hash: bcrypt.hashSync(ADMIN_PASS, 10),
    role: 'master'
  });
  saveDb();
  console.log(`✅ Admin padrão registrado: ${ADMIN_USER}`);
}

/* ============================================================
   TRATAMENTO DE ERROS GLOBAL
   ============================================================ */
app.use((err, req, res, next) => {
  console.error('❌ Erro não tratado:', err);
  if (res.headersSent) return next(err);
  res.status(500).json({ error: 'Erro interno do servidor.' });
});

/* ============================================================
   INICIALIZAÇÃO DO SERVIDOR
   ============================================================ */
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🪐 Saturn Storage rodando na porta ${PORT}`);
  console.log(`🔗 URL administrativa: ${DYNAMIC_ADMIN_PATH}`);
  console.log(`📊 Página de status: /status`);
});