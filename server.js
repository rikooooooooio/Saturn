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
   CONFIGURAÇÕES
   ============================================================ */
const JWT_SECRET = process.env.JWT_SECRET || 'astro_secret_2024';
const ADMIN_ROUTE_SECRET = process.env.ADMIN_ROUTE_SECRET || 'astro_secret_hash_2026';
const DYNAMIC_ADMIN_PATH = '/' + crypto.createHash('sha256').update(ADMIN_ROUTE_SECRET).digest('hex');
const DISCORD_WEBHOOK_URL = process.env.DISCORD_WEBHOOK_URL || '';
const MAINTENANCE_MODE = process.env.MAINTENANCE_MODE === 'true';

console.log(`\n[SEGURANÇA] URL administrativa: http://localhost:${PORT}${DYNAMIC_ADMIN_PATH}\n`);
if (DISCORD_WEBHOOK_URL) console.log('[DISCORD] Webhook configurada.');
else console.log('[DISCORD] Nenhuma webhook.');

/* ============================================================
   SEGURANÇA BÁSICA
   ============================================================ */
app.set('trust proxy', 1);
app.use(helmet({ contentSecurityPolicy: false, crossOriginEmbedderPolicy: false }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

/* ============================================================
   RATE LIMIT
   ============================================================ */
const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 8, message: { error: 'Muitas tentativas.' } });
const apiLimiter = rateLimit({ windowMs: 1 * 60 * 1000, max: 250, message: { error: 'Muitas requisições.' } });
const loaderLimiter = rateLimit({ windowMs: 1 * 60 * 1000, max: 150, message: 'Rate limit exceeded.' });

/* ============================================================
   BANCO DE DADOS
   ============================================================ */
DB.scripts = DB.scripts || [];
DB.admins = DB.admins || [];
DB.versions = DB.versions || [];

/* ============================================================
   FUNÇÕES AUXILIARES
   ============================================================ */
function generateShortId() {
  return crypto.randomBytes(4).toString('hex');
}

function sendChangelogWebhook({ title, description, banner, thumbnail, scriptName }) {
  if (!DISCORD_WEBHOOK_URL) return;
  const embed = {
    title: title || `${scriptName} foi atualizado!`,
    description: description || 'Veja as novidades abaixo.',
    color: 0x6366f1,
    timestamp: new Date().toISOString(),
    footer: { text: 'Astro Storage' }
  };
  if (banner) embed.image = { url: banner };
  if (thumbnail) embed.thumbnail = { url: thumbnail };
  axios.post(DISCORD_WEBHOOK_URL, { embeds: [embed] }, { timeout: 5000 }).catch(e => console.error('[DISCORD]', e.message));
}

function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Token ausente' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax', path: '/' });
    res.status(401).json({ error: 'Sessão expirada' });
  }
}

/* ============================================================
   AUTENTICAÇÃO
   ============================================================ */
app.post('/api/auth/login', loginLimiter, (req, res) => {
  const { username, password } = req.body;
  const admin = DB.admins.find(a => a.username === username);
  if (!admin || !bcrypt.compareSync(password, admin.password_hash))
    return res.status(401).json({ error: 'Credenciais inválidas' });
  const token = jwt.sign({ id: admin.id, username, role: admin.role || 'admin' }, JWT_SECRET, { expiresIn: '8h' });
  res.cookie('token', token, { httpOnly: true, secure: true, sameSite: 'lax', path: '/', maxAge: 8 * 60 * 60 * 1000 });
  res.json({ success: true, redirectPath: `${DYNAMIC_ADMIN_PATH}/dashboard` });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax', path: '/' });
  res.json({ success: true, redirectPath: DYNAMIC_ADMIN_PATH });
});

app.get('/api/auth/me', authMiddleware, (req, res) => res.json({ username: req.user.username }));

/* ============================================================
   ROTA PÚBLICA DE SCRIPTS (PÁGINA INICIAL)
   ============================================================ */
app.get('/api/public/scripts', (req, res) => {
  const scripts = DB.scripts.map(s => ({
    id: s.id,
    name: s.name,
    status: s.status,
    image: s.image || '',
    short_id: s.short_id,
    version: s.version || '1.0.0',
    updated_at: s.updated_at
  }));
  res.json(scripts);
});

/* ============================================================
   SCRIPTS (CRUD) — SEM CRIPTOGRAFIA
   ============================================================ */
app.use('/api/scripts', apiLimiter);

app.get('/api/scripts', authMiddleware, (req, res) => {
  res.json(DB.scripts.map(s => ({
    id: s.id,
    name: s.name,
    status: s.status,
    sandbox: s.sandbox || false,
    executions: s.executions || 0,
    short_id: s.short_id,
    version: s.version || '1.0.0',
    created_at: s.created_at,
    updated_at: s.updated_at
  })));
});

app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  res.json(script);
});

app.post('/api/scripts', authMiddleware, (req, res) => {
  const { name, content, status, sandbox } = req.body;
  if (!name || !content) return res.status(400).json({ error: 'Nome e conteúdo obrigatórios' });
  const script = {
    id: uuidv4(),
    name: name.trim(),
    content,
    status: status || 'online',
    sandbox: sandbox === true,
    executions: 0,
    short_id: generateShortId(),
    version: '1.0.0',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };
  DB.scripts.push(script);
  saveDb();
  res.status(201).json(script);
});

app.put('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  DB.versions.push({
    id: uuidv4(),
    script_id: script.id,
    name: script.name,
    content: script.content,
    status: script.status,
    sandbox: script.sandbox || false,
    created_at: new Date().toISOString()
  });
  const { name, content, status, sandbox } = req.body;
  if (name !== undefined) script.name = name.trim();
  if (content !== undefined) script.content = content;
  if (status !== undefined) script.status = status;
  if (sandbox !== undefined) script.sandbox = sandbox;
  script.updated_at = new Date().toISOString();
  saveDb();
  res.json(script);
});

app.delete('/api/scripts/:id', authMiddleware, (req, res) => {
  const idx = DB.scripts.findIndex(s => s.id === req.params.id);
  if (idx === -1) return res.status(404).json({ error: 'Script não encontrado' });
  DB.scripts.splice(idx, 1);
  DB.versions = DB.versions.filter(v => v.script_id !== req.params.id);
  saveDb();
  res.json({ success: true });
});

app.post('/api/scripts/:id/duplicate', authMiddleware, (req, res) => {
  const original = DB.scripts.find(s => s.id === req.params.id);
  if (!original) return res.status(404).json({ error: 'Script não encontrado' });
  const duplicated = { ...original, id: uuidv4(), name: original.name + ' (cópia)', executions: 0, short_id: generateShortId(), created_at: new Date().toISOString(), updated_at: new Date().toISOString() };
  DB.scripts.push(duplicated);
  saveDb();
  res.status(201).json(duplicated);
});

app.post('/api/scripts/bulk', authMiddleware, (req, res) => {
  const { scripts } = req.body;
  if (!Array.isArray(scripts) || scripts.length === 0) return res.status(400).json({ error: 'Array obrigatório' });
  const created = [];
  for (const s of scripts) {
    if (!s.name || !s.content) continue;
    const script = {
      id: uuidv4(),
      name: s.name.trim(),
      content: s.content,
      status: 'online',
      sandbox: false,
      executions: 0,
      short_id: generateShortId(),
      version: '1.0.0',
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };
    DB.scripts.push(script);
    created.push(script);
  }
  if (created.length === 0) return res.status(400).json({ error: 'Nenhum válido' });
  saveDb();
  res.status(201).json(created);
});

app.get('/api/scripts/:id/versions', authMiddleware, (req, res) => {
  const versions = DB.versions.filter(v => v.script_id === req.params.id).sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
  res.json(versions);
});

app.post('/api/scripts/:id/restore', authMiddleware, (req, res) => {
  const { versionId } = req.body;
  const version = DB.versions.find(v => v.id === versionId);
  if (!version || version.script_id !== req.params.id) return res.status(404).json({ error: 'Versão não encontrada' });
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  DB.versions.push({ id: uuidv4(), script_id: script.id, name: script.name, content: script.content, status: script.status, sandbox: script.sandbox || false, created_at: new Date().toISOString() });
  script.name = version.name;
  script.content = version.content;
  script.status = version.status;
  script.sandbox = version.sandbox;
  script.updated_at = new Date().toISOString();
  saveDb();
  res.json(script);
});

/* ============================================================
   CHANGELOG VIA WEBHOOK
   ============================================================ */
app.post('/api/scripts/:id/changelog', authMiddleware, async (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  const { title, description, banner, thumbnail } = req.body;
  await sendChangelogWebhook({ title, description, banner, thumbnail, scriptName: script.name });
  res.json({ success: true });
});

/* ============================================================
   EXPORT / IMPORT
   ============================================================ */
app.get('/api/export', authMiddleware, (req, res) => {
  res.json({ scripts: DB.scripts, versions: DB.versions });
});

app.post('/api/import', authMiddleware, (req, res) => {
  const { scripts, versions } = req.body;
  if (!Array.isArray(scripts)) return res.status(400).json({ error: 'Formato inválido' });
  DB.scripts = scripts;
  DB.versions = Array.isArray(versions) ? versions : [];
  saveDb();
  res.json({ success: true, imported: DB.scripts.length });
});

/* ============================================================
   ESTATÍSTICAS
   ============================================================ */
app.get('/api/stats', authMiddleware, (req, res) => {
  const total = DB.scripts.length;
  const online = DB.scripts.filter(s => s.status === 'online').length;
  const exec = DB.scripts.reduce((a, s) => a + (s.executions || 0), 0);
  res.json({ totalScripts: total, onlineScripts: online, totalExecutions: exec, executionsToday: 0 });
});

/* ============================================================
   LOADER — CORRIGIDO ERRO 403
   Agora permite User-Agent do Roblox mesmo que contenha "Mozilla"
   ============================================================ */
app.get('/api/load/:id', loaderLimiter, (req, res) => {
  if (MAINTENANCE_MODE) return res.status(503).send('Em manutenção.');

  const ua = (req.get('User-Agent') || '').toLowerCase();

  // Permite explicitamente User-Agents que contenham "roblox"
  if (ua.includes('roblox')) {
    // Continua normalmente
  } else {
    // Bloqueia apenas navegadores comuns (que não sejam Roblox)
    const isBrowser = /mozilla|chrome|safari|edge|firefox|opera/i.test(ua);
    if (isBrowser) {
      return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
    }
  }

  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script || script.status !== 'online') return res.status(404).send('Script indisponível.');

  if (script.sandbox) {
    const token = req.cookies?.token;
    try { jwt.verify(token, JWT_SECRET); } catch { return res.status(403).send('Acesso restrito.'); }
  }

  script.executions = (script.executions || 0) + 1;
  saveDb();
  res.type('text/plain').send(script.content);
});

/* ============================================================
   LINK CURTO
   ============================================================ */
app.get('/s/:shortId', (req, res) => {
  const script = DB.scripts.find(s => s.short_id === req.params.shortId);
  if (!script) return res.status(404).send('Link não encontrado.');
  return res.redirect(`/api/load/${script.id}`);
});

/* ============================================================
   PÁGINAS
   ============================================================ */
app.get('/status', (req, res) => {
  const online = DB.scripts.filter(s => s.status === 'online').length;
  const total = DB.scripts.length;
  const exec = DB.scripts.reduce((a, s) => a + (s.executions || 0), 0);
  res.send(`<!DOCTYPE html><html lang="pt"><head><meta charset="UTF-8"><title>Astro Status</title><style>body{background:#0a0a0a;color:#fff;font-family:Inter,sans-serif;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}.card{background:#111;border:1px solid #1f1f1f;border-radius:16px;padding:2.5rem;text-align:center;max-width:400px;width:90%}h1{margin-bottom:.5rem}p{color:#a0a0a0}.stat{font-size:2rem;font-weight:800;margin:.5rem 0}.dot{display:inline-block;width:10px;height:10px;background:#10b981;border-radius:50%;margin-right:.5rem}</style></head><body><div class="card"><h1>Astro</h1><p>Sistema operacional</p><div class="stat"><span class="dot"></span>${online} / ${total} scripts online</div><p>${exec} execuções totais</p></div></body></html>`);
});

app.get('/get/:scriptId', (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.scriptId && s.status === 'online');
  if (!script) return res.status(404).send('Script não encontrado.');
  res.sendFile(path.join(__dirname, 'public', 'get.html'));
});

app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get(DYNAMIC_ADMIN_PATH, (req, res) => res.sendFile(path.join(__dirname, 'public/admin/login.html')));
app.get(`${DYNAMIC_ADMIN_PATH}/dashboard`, authMiddleware, (req, res) => res.sendFile(path.join(__dirname, 'public/admin/dashboard.html')));
app.get('/admin', (req, res) => res.status(404).send('Cannot GET /admin'));

/* ============================================================
   ADMIN INICIAL
   ============================================================ */
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';
if (!DB.admins.find(a => a.username === ADMIN_USER)) {
  DB.admins.push({ id: 1, username: ADMIN_USER, password_hash: bcrypt.hashSync(ADMIN_PASS, 10), role: 'master' });
  saveDb();
  console.log(`✅ Admin: ${ADMIN_USER}`);
}

/* ============================================================
   TRATAMENTO DE ERROS
   ============================================================ */
app.use((err, req, res, next) => {
  console.error('❌ Erro:', err);
  if (res.headersSent) return next(err);
  res.status(500).json({ error: 'Erro interno.' });
});

/* ============================================================
   INICIALIZAÇÃO
   ============================================================ */
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🪐 Astro Storage rodando na porta ${PORT}`);
  console.log(`🔗 Admin URL: ${DYNAMIC_ADMIN_PATH}`);
});