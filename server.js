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
const { DB, saveDb } = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'saturn_secret_2024';
const ADMIN_ROUTE_SECRET = process.env.ADMIN_ROUTE_SECRET || 'saturn_secret_hash_2026';
const DYNAMIC_ADMIN_PATH = '/' + crypto.createHash('sha256').update(ADMIN_ROUTE_SECRET).digest('hex');

console.log(`\n[SEGURANÇA] URL administrativa: http://localhost:${PORT}${DYNAMIC_ADMIN_PATH}\n`);

app.set('trust proxy', 1);
app.use(helmet({ contentSecurityPolicy: false }));
app.use(express.json({ limit: '5mb' })); // Aumentado para uploads múltiplos
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 5, message: { error: 'Muitas tentativas.' } });
const apiLimiter = rateLimit({ windowMs: 1 * 60 * 1000, max: 150, message: { error: 'Muitas requisições.' } });

DB.scripts = DB.scripts || [];
DB.admins = DB.admins || [];
DB.versions = DB.versions || [];
DB.logs = DB.logs || [];

// --------------------- FUNÇÕES AUXILIARES ---------------------
function logEvent(action, details, req) {
  DB.logs.push({
    id: Date.now(),
    action,
    details: String(details),
    ip: req?.ip || 'unknown',
    user_agent: req?.get('User-Agent') || '',
    created_at: new Date().toISOString()
  });
  if (DB.logs.length > 2000) DB.logs = DB.logs.slice(-2000);
  saveDb();
}

function generateShortId() {
  return crypto.randomBytes(4).toString('hex');
}

// --------------------- AUTH ---------------------
function auth(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Acesso negado.' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.clearCookie('token');
    res.status(401).json({ error: 'Sessão expirada.' });
  }
}

app.post('/api/auth/login', loginLimiter, (req, res) => {
  const { username, password } = req.body;
  const admin = DB.admins.find(a => a.username === username);
  if (!admin || !bcrypt.compareSync(password, admin.password_hash))
    return res.status(401).json({ error: 'Credenciais inválidas' });

  const token = jwt.sign({ id: admin.id, username }, JWT_SECRET, { expiresIn: '8h' });
  res.cookie('token', token, { httpOnly: true, secure: true, sameSite: 'lax', path: '/' });
  logEvent('LOGIN_SUCCESS', username, req);
  res.json({ success: true, redirectPath: `${DYNAMIC_ADMIN_PATH}/dashboard` });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax', path: '/' });
  res.json({ success: true, redirectPath: DYNAMIC_ADMIN_PATH });
});

app.get('/api/auth/me', auth, (req, res) => res.json({ username: req.user.username }));

// --------------------- STATS ---------------------
app.get('/api/stats', auth, (req, res) => {
  const totalScripts = DB.scripts.length;
  const onlineScripts = DB.scripts.filter(s => s.status === 'online').length;
  const totalExecutions = DB.scripts.reduce((acc, s) => acc + (s.executions || 0), 0);
  const today = new Date().toISOString().split('T')[0];
  const executionsToday = DB.logs.filter(l => l.action === 'SCRIPT_EXEC' && l.created_at?.startsWith(today)).length;
  const recentLogs = DB.logs.slice(-10).reverse();

  res.json({ totalScripts, onlineScripts, totalExecutions, executionsToday, recentLogs });
});

app.get('/api/stats/executions', auth, (req, res) => {
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
  res.json(data);
});

// --------------------- SCRIPTS API ---------------------
app.use('/api/scripts', apiLimiter);
app.get('/api/scripts', auth, (req, res) => res.json(DB.scripts));

app.post('/api/scripts', auth, (req, res) => {
  const { name, content, status } = req.body;
  if (!name || !name.trim() || !content) return res.status(400).json({ error: 'Dados inválidos.' });

  const script = {
    id: uuidv4(),
    name: name.trim(),
    content,
    status: status === 'offline' ? 'offline' : 'online',
    executions: 0,
    short_id: generateShortId(),
    created_at: new Date().toISOString()
  };
  DB.scripts.push(script);
  saveDb();
  logEvent('SCRIPT_CREATED', script.name, req);
  res.status(201).json(script);
});

app.post('/api/scripts/bulk', auth, (req, res) => {
  const { scripts } = req.body;
  if (!Array.isArray(scripts)) return res.status(400).json({ error: 'Array esperado.' });

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
      created_at: new Date().toISOString()
    };
    DB.scripts.push(script);
    created.push(script);
  }
  saveDb();
  logEvent('BULK_CREATED', `${created.length} scripts`, req);
  res.status(201).json(created);
});

app.put('/api/scripts/:id', auth, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });

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
  if (name) script.name = name.trim();
  if (content) script.content = content;
  if (status) script.status = status;

  saveDb();
  logEvent('SCRIPT_UPDATED', script.name, req);
  res.json(script);
});

app.delete('/api/scripts/:id', auth, (req, res) => {
  DB.scripts = DB.scripts.filter(s => s.id !== req.params.id);
  DB.versions = DB.versions.filter(v => v.script_id !== req.params.id);
  saveDb();
  logEvent('SCRIPT_DELETED', req.params.id, req);
  res.json({ success: true });
});

app.get('/api/scripts/:id/versions', auth, (req, res) => {
  const versions = DB.versions.filter(v => v.script_id === req.params.id).sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
  res.json(versions);
});

app.post('/api/scripts/:id/restore', auth, (req, res) => {
  const { versionId } = req.body;
  const version = DB.versions.find(v => v.id === versionId);
  if (!version) return res.status(404).json({ error: 'Versão não encontrada.' });

  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado.' });

  // Salva estado atual antes de restaurar
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
  saveDb();
  logEvent('VERSION_RESTORED', script.name, req);
  res.json(script);
});

// --------------------- EXPORT/IMPORT ---------------------
app.get('/api/export', auth, (req, res) => {
  res.json({ scripts: DB.scripts, versions: DB.versions, logs: DB.logs });
});

app.post('/api/import', auth, (req, res) => {
  if (!req.body.scripts || !Array.isArray(req.body.scripts)) return res.status(400).json({ error: 'Formato inválido' });
  DB.scripts = req.body.scripts;
  DB.versions = req.body.versions || [];
  DB.logs = req.body.logs || [];
  saveDb();
  res.json({ success: true, imported: DB.scripts.length });
});

// --------------------- LOGS ---------------------
app.get('/api/logs', auth, (req, res) => {
  const limit = parseInt(req.query.limit) || 50;
  const logs = DB.logs.slice(-limit).reverse();
  res.json(logs);
});

// --------------------- FEEDBACK ---------------------
app.post('/api/report', (req, res) => {
  const { script_id, error, hwid } = req.body;
  logEvent('SCRIPT_ERROR', `Script: ${script_id} | Erro: ${error} | HWID: ${hwid || 'N/A'}`, req);
  res.json({ received: true });
});

// --------------------- ENCURTADOR ---------------------
app.get('/s/:shortId', (req, res) => {
  const script = DB.scripts.find(s => s.short_id === req.params.shortId);
  if (!script) return res.status(404).send('Link não encontrado.');

  const userAgent = req.get('User-Agent') || '';
  const isBrowser = /Mozilla|Chrome|Safari|Edge|Firefox|Opera/i.test(userAgent);

  if (isBrowser) {
    return res.redirect(`/get/${script.id}`);
  }
  // Se não for navegador, redireciona direto para o loader
  return res.redirect(`/api/load/${script.id}`);
});

// --------------------- LOADER ---------------------
app.get('/api/load/:id', apiLimiter, (req, res) => {
  const userAgent = req.get('User-Agent') || '';
  const isBrowser = /Mozilla|Chrome|Safari|Edge|Firefox|Opera/i.test(userAgent);

  if (isBrowser) {
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  const script = DB.scripts.find(s => s.id === req.params.id && s.status === 'online');
  if (!script) return res.status(404).send('-- Erro: Script indisponível.');

  script.executions = (script.executions || 0) + 1;
  saveDb();
  logEvent('SCRIPT_EXEC', script.name, req);
  res.type('text/plain').send(script.content);
});

// --------------------- PÁGINA DE STATUS PÚBLICA ---------------------
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

// --------------------- PÁGINA DE KEY (GET) ---------------------
app.get('/get/:scriptId', (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.scriptId && s.status === 'online');
  if (!script) return res.status(404).send('Script não encontrado.');
  res.sendFile(path.join(__dirname, 'public', 'get.html'));
});

// --------------------- ROTAS DINÂMICAS DO PAINEL ---------------------
app.get(DYNAMIC_ADMIN_PATH, (req, res) => res.sendFile(path.join(__dirname, 'public/admin/login.html')));
app.get(`${DYNAMIC_ADMIN_PATH}/dashboard`, (req, res) => res.sendFile(path.join(__dirname, 'public/admin/dashboard.html')));
app.get('/admin', (req, res) => res.status(404).send('Cannot GET /admin'));
app.get('/admin/dashboard', (req, res) => res.status(404).send('Cannot GET /admin/dashboard'));
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));

// --------------------- ADMIN INICIAL ---------------------
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';
if (!DB.admins.find(a => a.username === ADMIN_USER)) {
  DB.admins.push({ id: 1, username: ADMIN_USER, password_hash: bcrypt.hashSync(ADMIN_PASS, 10) });
  saveDb();
  console.log(`✅ Admin registrado: ${ADMIN_USER}`);
}

app.listen(PORT, '0.0.0.0', () => console.log(`🪐 Rodando na porta ${PORT}`));