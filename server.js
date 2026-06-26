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
   VALIDAÇÃO DE AMBIENTE
   ============================================================ */
if (!process.env.JWT_SECRET) {
  console.warn('⚠️  JWT_SECRET não definido – usando fallback inseguro.');
}
if (!process.env.ADMIN_USER || !process.env.ADMIN_PASS) {
  console.warn('⚠️  ADMIN_USER/ADMIN_PASS ausentes – usando credenciais padrão.');
}

const JWT_SECRET = process.env.JWT_SECRET || 'fallback_jwt_secret_change_me';
const ADMIN_ROUTE_SECRET = process.env.ADMIN_ROUTE_SECRET || 'saturn_secret_hash_2026';
const DYNAMIC_ADMIN_PATH = '/' + crypto.createHash('sha256').update(ADMIN_ROUTE_SECRET).digest('hex');
const DISCORD_WEBHOOK_URL = process.env.DISCORD_WEBHOOK_URL || '';
const MAINTENANCE_MODE = process.env.MAINTENANCE_MODE === 'true';
const ENABLE_COMPRESSION = process.env.ENABLE_COMPRESSION !== 'false'; // padrão true

console.log(`\n🔐 [SEGURANÇA] URL administrativa: http://localhost:${PORT}${DYNAMIC_ADMIN_PATH}`);
console.log(`🔐 [SEGURANÇA] Guarde essa URL – ela é ofuscada e impossível de adivinhar.\n`);
if (DISCORD_WEBHOOK_URL) console.log('📢 [DISCORD] Notificações ativadas.');
else console.log('📢 [DISCORD] Nenhuma webhook configurada.');

/* ============================================================
   CONFIGURAÇÕES DE SEGURANÇA
   ============================================================ */
app.set('trust proxy', 1);
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false,
  crossOriginOpenerPolicy: { policy: 'same-origin-allow-popups' },
  crossOriginResourcePolicy: { policy: 'cross-origin' },
  dnsPrefetchControl: { allow: true }
}));

// Headers de segurança adicionais
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'no-referrer-when-downgrade');
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
  next();
});

// ID único por requisição para rastreamento
app.use((req, res, next) => {
  req.requestId = crypto.randomUUID().slice(0, 8);
  res.setHeader('X-Request-ID', req.requestId);
  next();
});

/* ============================================================
   MIDDLEWARE DE LOG
   ============================================================ */
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    const level = res.statusCode >= 400 ? '⚠️ ' : '✅';
    console.log(`${level} [${new Date().toISOString()}] ${req.method} ${req.originalUrl} → ${res.statusCode} (${duration}ms) [${req.requestId}]`);
  });
  next();
});

/* ============================================================
   PARSING DE CORPO
   ============================================================ */
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());

// Sanitização básica de entrada (remove caracteres perigosos)
app.use((req, res, next) => {
  if (req.body && typeof req.body === 'object') {
    for (const key in req.body) {
      if (typeof req.body[key] === 'string' && key !== 'content') {
        req.body[key] = req.body[key].replace(/[<>]/g, '');
      }
    }
  }
  next();
});

/* ============================================================
   ARQUIVOS ESTÁTICOS
   ============================================================ */
app.use(express.static(path.join(__dirname, 'public'), {
  maxAge: '1h',
  etag: true,
  lastModified: true
}));

/* ============================================================
   RATE LIMIT (MÚLTIPLOS NÍVEIS)
   ============================================================ */
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 300,
  message: { error: 'Muitas requisições globais. Aguarde.' },
  standardHeaders: true,
  legacyHeaders: false
});

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 8,
  message: { error: 'Muitas tentativas de login. Tente novamente em 15 minutos.' },
  skipSuccessfulRequests: true,
  standardHeaders: true
});

const apiLimiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  max: 250,
  message: { error: 'Limite de API atingido. Aguarde um instante.' }
});

const loaderLimiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  max: 150,
  message: 'Rate limit exceeded.',
  standardHeaders: true
});

app.use('/api/', apiLimiter);
app.use('/api/auth/login', loginLimiter);
app.use('/api/load/', loaderLimiter);

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

/**
 * Valida se uma string é um UUID v4 válido
 */
function isValidUUID(str) {
  const regex = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return regex.test(str);
}

/**
 * Sanitiza nome de script (remove caracteres especiais perigosos)
 */
function sanitizeScriptName(name) {
  return name.replace(/[^a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ _\-\.\[\]\(\)]/g, '').substring(0, 100);
}

/**
 * Envia embed para o Discord
 */
async function sendChangelogWebhook({ title, description, banner, thumbnail, scriptName }) {
  if (!DISCORD_WEBHOOK_URL) return;
  const embed = {
    title: title || `📢 ${scriptName} foi atualizado!`,
    description: description || 'Veja as novidades abaixo.',
    color: 0x6366f1,
    timestamp: new Date().toISOString(),
    footer: { text: 'Saturn Storage' }
  };
  if (banner && isValidUrl(banner)) embed.image = { url: banner };
  if (thumbnail && isValidUrl(thumbnail)) embed.thumbnail = { url: thumbnail };
  try {
    await axios.post(DISCORD_WEBHOOK_URL, { embeds: [embed] }, { timeout: 5000 });
    console.log(`📢 Changelog enviado para Discord: ${scriptName}`);
  } catch (err) {
    console.error('❌ [DISCORD] Erro:', err.message);
  }
}

function isValidUrl(str) {
  try {
    new URL(str);
    return true;
  } catch {
    return false;
  }
}

/**
 * Middleware de autenticação JWT
 */
function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Token de autenticação ausente.' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch (err) {
    res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax', path: '/' });
    return res.status(401).json({ error: 'Sessão expirada. Faça login novamente.' });
  }
}

/**
 * Cache simples em memória para estatísticas (TTL de 30 segundos)
 */
const cache = {};
function getCached(key, ttlMs = 30000) {
  const entry = cache[key];
  if (entry && Date.now() - entry.timestamp < ttlMs) return entry.data;
  return null;
}
function setCache(key, data) {
  cache[key] = { data, timestamp: Date.now() };
}
function clearCache() {
  Object.keys(cache).forEach(k => delete cache[k]);
}

/* ============================================================
   HEALTH CHECK
   ============================================================ */
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    uptime: process.uptime(),
    memoryUsage: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + ' MB',
    timestamp: new Date().toISOString(),
    scripts: DB.scripts.length,
    version: '5.0.0'
  });
});

app.get('/api/ping', (req, res) => res.json({ pong: true, requestId: req.requestId }));

/* ============================================================
   AUTENTICAÇÃO
   ============================================================ */
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: 'Usuário e senha são obrigatórios.' });
  }

  if (typeof username !== 'string' || typeof password !== 'string') {
    return res.status(400).json({ error: 'Formato de dados inválido.' });
  }

  if (username.length > 50 || password.length > 100) {
    return res.status(400).json({ error: 'Credenciais muito longas.' });
  }

  const admin = DB.admins.find(a => a.username === username);
  if (!admin) {
    console.warn(`🔐 Login falhou: usuário "${username}" não encontrado.`);
    return res.status(401).json({ error: 'Credenciais inválidas.' });
  }

  if (!admin.password_hash || !bcrypt.compareSync(password, admin.password_hash)) {
    console.warn(`🔐 Login falhou: senha incorreta para "${username}".`);
    return res.status(401).json({ error: 'Credenciais inválidas.' });
  }

  const token = jwt.sign(
    { id: admin.id, username, role: admin.role || 'admin' },
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

  console.log(`✅ Login bem-sucedido: ${username}`);
  res.json({ success: true, redirectPath: `${DYNAMIC_ADMIN_PATH}/dashboard` });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token', {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    path: '/'
  });
  res.json({ success: true, redirectPath: DYNAMIC_ADMIN_PATH });
});

app.get('/api/auth/me', authMiddleware, (req, res) => {
  res.json({ username: req.user.username, role: req.user.role || 'admin' });
});

/* ============================================================
   ROTA PÚBLICA DE SCRIPTS
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
   SCRIPTS (CRUD COMPLETO)
   ============================================================ */

/**
 * GET /api/scripts
 * Lista todos os scripts (admin)
 */
app.get('/api/scripts', authMiddleware, (req, res) => {
  const scripts = DB.scripts.map(s => ({
    id: s.id,
    name: s.name,
    status: s.status,
    sandbox: s.sandbox || false,
    executions: s.executions || 0,
    short_id: s.short_id,
    version: s.version || '1.0.0',
    created_at: s.created_at,
    updated_at: s.updated_at
  }));
  res.json(scripts);
});

/**
 * GET /api/scripts/:id
 * Obtém um script completo pelo ID
 */
app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });

  const script = DB.scripts.find(s => s.id === id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado.' });

  res.json(script);
});

/**
 * POST /api/scripts
 * Cria um novo script
 */
app.post('/api/scripts', authMiddleware, (req, res) => {
  const { name, content, status, sandbox } = req.body;

  if (!name || !content) {
    return res.status(400).json({ error: 'Nome e conteúdo são obrigatórios.' });
  }

  if (typeof name !== 'string' || typeof content !== 'string') {
    return res.status(400).json({ error: 'Nome e conteúdo devem ser texto.' });
  }

  if (content.length > 500000) {
    return res.status(400).json({ error: 'Conteúdo muito grande (máx. 500KB).' });
  }

  const validStatuses = ['online', 'offline', 'maintenance', 'development'];
  const finalStatus = validStatuses.includes(status) ? status : 'online';

  const script = {
    id: uuidv4(),
    name: sanitizeScriptName(name.trim()),
    content,
    status: finalStatus,
    sandbox: sandbox === true,
    executions: 0,
    short_id: generateShortId(),
    version: '1.0.0',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };

  DB.scripts.push(script);
  saveDb();
  clearCache();
  console.log(`📜 Script criado: "${script.name}" (${script.id})`);
  res.status(201).json(script);
});

/**
 * PUT /api/scripts/:id
 * Atualiza um script existente (com histórico de versões)
 */
app.put('/api/scripts/:id', authMiddleware, (req, res) => {
  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });

  const script = DB.scripts.find(s => s.id === id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado.' });

  // Salva versão anterior no histórico
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

  if (name !== undefined) {
    if (typeof name !== 'string' || name.trim().length === 0)
      return res.status(400).json({ error: 'Nome inválido.' });
    script.name = sanitizeScriptName(name.trim());
  }

  if (content !== undefined) {
    if (typeof content !== 'string' || content.length > 500000)
      return res.status(400).json({ error: 'Conteúdo inválido ou muito grande.' });
    script.content = content;
  }

  if (status !== undefined) {
    const validStatuses = ['online', 'offline', 'maintenance', 'development'];
    if (!validStatuses.includes(status))
      return res.status(400).json({ error: 'Status inválido.' });
    script.status = status;
  }

  if (sandbox !== undefined) {
    script.sandbox = sandbox === true;
  }

  script.updated_at = new Date().toISOString();
  saveDb();
  clearCache();
  console.log(`✏️ Script atualizado: "${script.name}"`);
  res.json(script);
});

/**
 * DELETE /api/scripts/:id
 * Remove um script permanentemente
 */
app.delete('/api/scripts/:id', authMiddleware, (req, res) => {
  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });

  const idx = DB.scripts.findIndex(s => s.id === id);
  if (idx === -1) return res.status(404).json({ error: 'Script não encontrado.' });

  const removed = DB.scripts.splice(idx, 1)[0];
  DB.versions = DB.versions.filter(v => v.script_id !== id);
  saveDb();
  clearCache();
  console.log(`🗑️ Script excluído: "${removed.name}"`);
  res.json({ success: true, message: `Script "${removed.name}" excluído.` });
});

/**
 * POST /api/scripts/:id/duplicate
 * Duplica um script existente
 */
app.post('/api/scripts/:id/duplicate', authMiddleware, (req, res) => {
  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });

  const original = DB.scripts.find(s => s.id === id);
  if (!original) return res.status(404).json({ error: 'Script não encontrado.' });

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
  clearCache();
  console.log(`📄 Script duplicado: "${duplicated.name}"`);
  res.status(201).json(duplicated);
});

/**
 * POST /api/scripts/bulk
 * Cria múltiplos scripts a partir de um array
 */
app.post('/api/scripts/bulk', authMiddleware, (req, res) => {
  const { scripts } = req.body;

  if (!Array.isArray(scripts) || scripts.length === 0) {
    return res.status(400).json({ error: 'Envie um array de scripts com nome e conteúdo.' });
  }

  if (scripts.length > 50) {
    return res.status(400).json({ error: 'Máximo de 50 scripts por vez.' });
  }

  const created = [];
  for (const s of scripts) {
    if (!s.name || !s.content) continue;
    if (typeof s.name !== 'string' || typeof s.content !== 'string') continue;
    if (s.content.length > 500000) continue;

    const script = {
      id: uuidv4(),
      name: sanitizeScriptName(s.name.trim()),
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

  if (created.length === 0) {
    return res.status(400).json({ error: 'Nenhum script válido foi enviado.' });
  }

  saveDb();
  clearCache();
  console.log(`📦 ${created.length} scripts criados em massa.`);
  res.status(201).json(created);
});

/**
 * GET /api/scripts/:id/versions
 * Lista o histórico de versões de um script
 */
app.get('/api/scripts/:id/versions', authMiddleware, (req, res) => {
  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });

  const versions = DB.versions
    .filter(v => v.script_id === id)
    .sort((a, b) => new Date(b.created_at) - new Date(a.created_at));

  res.json(versions);
});

/**
 * POST /api/scripts/:id/restore
 * Restaura uma versão anterior do script
 */
app.post('/api/scripts/:id/restore', authMiddleware, (req, res) => {
  const { id } = req.params;
  const { versionId } = req.body;

  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });
  if (!versionId || !isValidUUID(versionId)) return res.status(400).json({ error: 'ID da versão inválido.' });

  const version = DB.versions.find(v => v.id === versionId);
  if (!version || version.script_id !== id)
    return res.status(404).json({ error: 'Versão não encontrada.' });

  const script = DB.scripts.find(s => s.id === id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado.' });

  // Salva o estado atual antes de restaurar
  DB.versions.push({
    id: uuidv4(),
    script_id: script.id,
    name: script.name,
    content: script.content,
    status: script.status,
    sandbox: script.sandbox || false,
    created_at: new Date().toISOString()
  });

  script.name = version.name;
  script.content = version.content;
  script.status = version.status;
  script.sandbox = version.sandbox;
  script.updated_at = new Date().toISOString();

  saveDb();
  clearCache();
  console.log(`🔄 Script "${script.name}" restaurado para versão de ${new Date(version.created_at).toLocaleString('pt-BR')}.`);
  res.json(script);
});

/* ============================================================
   CHANGELOG VIA WEBHOOK
   ============================================================ */
app.post('/api/scripts/:id/changelog', authMiddleware, async (req, res) => {
  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).json({ error: 'ID inválido.' });

  const script = DB.scripts.find(s => s.id === id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado.' });

  const { title, description, banner, thumbnail } = req.body;
  await sendChangelogWebhook({
    title: title?.substring(0, 200),
    description: description?.substring(0, 2000),
    banner: banner?.substring(0, 500),
    thumbnail: thumbnail?.substring(0, 500),
    scriptName: script.name
  });

  res.json({ success: true, message: 'Changelog enviado ao Discord!' });
});

/* ============================================================
   EXPORTAÇÃO / IMPORTAÇÃO
   ============================================================ */
app.get('/api/export', authMiddleware, (req, res) => {
  res.json({
    scripts: DB.scripts,
    versions: DB.versions,
    exported_at: new Date().toISOString()
  });
});

app.post('/api/import', authMiddleware, (req, res) => {
  const { scripts, versions } = req.body;

  if (!Array.isArray(scripts)) {
    return res.status(400).json({ error: 'Campo "scripts" deve ser um array.' });
  }

  if (scripts.length > 1000) {
    return res.status(400).json({ error: 'Máximo de 1000 scripts por importação.' });
  }

  DB.scripts = scripts;
  DB.versions = Array.isArray(versions) ? versions.slice(0, 5000) : [];
  saveDb();
  clearCache();
  console.log(`📥 ${DB.scripts.length} scripts importados.`);
  res.json({ success: true, imported: DB.scripts.length });
});

/* ============================================================
   ESTATÍSTICAS
   ============================================================ */
app.get('/api/stats', authMiddleware, (req, res) => {
  const cached = getCached('stats', 15000);
  if (cached) return res.json(cached);

  const total = DB.scripts.length;
  const online = DB.scripts.filter(s => s.status === 'online').length;
  const offline = DB.scripts.filter(s => s.status === 'offline').length;
  const maintenance = DB.scripts.filter(s => s.status === 'maintenance').length;
  const development = DB.scripts.filter(s => s.status === 'development').length;
  const totalExec = DB.scripts.reduce((acc, s) => acc + (s.executions || 0), 0);
  const sandboxCount = DB.scripts.filter(s => s.sandbox).length;

  const data = {
    totalScripts: total,
    onlineScripts: online,
    offlineScripts: offline,
    maintenanceScripts: maintenance,
    developmentScripts: development,
    sandboxScripts: sandboxCount,
    totalExecutions: totalExec,
    versionsCount: DB.versions.length,
    adminsCount: DB.admins.length,
    generatedAt: new Date().toISOString()
  };

  setCache('stats', data);
  res.json(data);
});

/* ============================================================
   LOADER PÚBLICO
   ============================================================ */
app.get('/api/load/:id', (req, res) => {
  // Modo manutenção
  if (MAINTENANCE_MODE) {
    return res.status(503).send('🛠️ Serviço em manutenção programada. Tente novamente mais tarde.');
  }

  // Bloqueia navegadores comuns
  const ua = (req.get('User-Agent') || '').toLowerCase();
  if (/mozilla|chrome|safari|edge|firefox|opera/i.test(ua)) {
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  const { id } = req.params;
  if (!isValidUUID(id)) return res.status(400).send('ID inválido.');

  const script = DB.scripts.find(s => s.id === id);
  if (!script) return res.status(404).send('Script não encontrado.');

  if (script.sandbox) {
    const token = req.cookies?.token;
    try {
      const user = jwt.verify(token, JWT_SECRET);
      if (user.role !== 'admin' && user.role !== 'master') throw new Error();
    } catch {
      return res.status(403).send('🔒 Acesso restrito ao administrador (modo sandbox).');
    }
  }

  if (script.status !== 'online') {
    return res.status(404).send(`Script "${script.name}" está ${script.status}.`);
  }

  script.executions = (script.executions || 0) + 1;
  saveDb();
  clearCache();

  res.type('text/plain');
  res.send(script.content);
});

/* ============================================================
   LINK CURTO
   ============================================================ */
app.get('/s/:shortId', (req, res) => {
  const { shortId } = req.params;

  if (!shortId || shortId.length !== 8) {
    return res.status(400).send('Link curto inválido.');
  }

  const script = DB.scripts.find(s => s.short_id === shortId);
  if (!script) return res.status(404).send('Link não encontrado.');

  // Redireciona diretamente para o loader
  return res.redirect(301, `/api/load/${script.id}`);
});

/* ============================================================
   PÁGINAS ESTÁTICAS
   ============================================================ */
app.get('/status', (req, res) => {
  const online = DB.scripts.filter(s => s.status === 'online').length;
  const total = DB.scripts.length;
  const exec = DB.scripts.reduce((a, s) => a + (s.executions || 0), 0);
  res.send(`<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Saturn — Status</title>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body { background:#0a0a0a; color:#fff; font-family:'Inter',-apple-system,sans-serif; display:flex; align-items:center; justify-content:center; min-height:100vh; }
    .card { background:#111; border:1px solid #1f1f1f; border-radius:16px; padding:2.5rem; text-align:center; max-width:420px; width:90%; }
    h1 { font-size:1.8rem; margin-bottom:0.5rem; }
    p { color:#a0a0a0; }
    .stat { font-size:2rem; font-weight:800; margin:0.5rem 0; }
    .dot { display:inline-block; width:10px; height:10px; background:#10b981; border-radius:50%; margin-right:0.5rem; }
    .footer { margin-top:1rem; font-size:0.8rem; color:#444; }
  </style>
</head>
<body>
  <div class="card">
    <h1>🪐 Saturn</h1>
    <p>Sistema operacional</p>
    <div class="stat"><span class="dot"></span>${online} / ${total} scripts online</div>
    <p>${exec} execuções totais</p>
    <div class="footer">v5.0.0 — &copy; 2026</div>
  </div>
</body>
</html>`);
});

app.get('/get/:scriptId', (req, res) => {
  const { scriptId } = req.params;
  if (!isValidUUID(scriptId)) return res.status(400).send('ID inválido.');

  const script = DB.scripts.find(s => s.id === scriptId && s.status === 'online');
  if (!script) return res.status(404).send('Script não encontrado ou offline.');

  res.sendFile(path.join(__dirname, 'public', 'get.html'));
});

app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get(DYNAMIC_ADMIN_PATH, (req, res) => res.sendFile(path.join(__dirname, 'public/admin/login.html')));
app.get(`${DYNAMIC_ADMIN_PATH}/dashboard`, authMiddleware, (req, res) => res.sendFile(path.join(__dirname, 'public/admin/dashboard.html')));

// Rota antiga retorna 404
app.get('/admin', (req, res) => res.status(404).send('Cannot GET /admin'));
app.get('/admin/dashboard', (req, res) => res.status(404).send('Cannot GET /admin/dashboard'));

/* ============================================================
   TRATAMENTO DE ROTAS NÃO ENCONTRADAS (404)
   ============================================================ */
app.use((req, res) => {
  res.status(404).json({ error: 'Rota não encontrada.', path: req.originalUrl });
});

/* ============================================================
   TRATAMENTO DE ERROS GLOBAL
   ============================================================ */
app.use((err, req, res, next) => {
  console.error(`❌ [${req.requestId}] Erro não tratado:`, err);

  if (res.headersSent) return next(err);

  const statusCode = err.status || 500;
  const message = statusCode === 500 ? 'Erro interno do servidor.' : err.message;

  res.status(statusCode).json({
    error: message,
    requestId: req.requestId,
    timestamp: new Date().toISOString()
  });
});

/* ============================================================
   ADMIN INICIAL
   ============================================================ */
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';

if (!DB.admins.find(a => a.username === ADMIN_USER)) {
  const hash = bcrypt.hashSync(ADMIN_PASS, 10);
  DB.admins.push({ id: 1, username: ADMIN_USER, password_hash: hash, role: 'master' });
  saveDb();
  console.log(`👤 Admin master criado: ${ADMIN_USER}`);
} else {
  console.log(`👤 Admin master já existe: ${ADMIN_USER}`);
}

/* ============================================================
   INICIALIZAÇÃO DO SERVIDOR
   ============================================================ */
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n${'='.repeat(50)}`);
  console.log(`🪐 Saturn Storage v5.0.0`);
  console.log(`📡 Rodando em: http://0.0.0.0:${PORT}`);
  console.log(`🔗 Admin URL:  http://localhost:${PORT}${DYNAMIC_ADMIN_PATH}`);
  console.log(`📊 Status:     http://localhost:${PORT}/status`);
  console.log(`❤️  Health:     http://localhost:${PORT}/api/health`);
  console.log(`${'='.repeat(50)}\n`);
});

// Timeout global para requests (30 segundos)
server.timeout = 30000;

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 Sinal SIGTERM recebido. Finalizando servidor...');
  saveDb();
  server.close(() => {
    console.log('✅ Servidor finalizado.');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('🛑 Sinal SIGINT recebido. Finalizando servidor...');
  saveDb();
  server.close(() => {
    console.log('✅ Servidor finalizado.');
    process.exit(0);
  });
});