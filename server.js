require('dotenv').config();

const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { z } = require('zod');
const rateLimit = require('express-rate-limit');
const { DB, saveDb } = require('./database');

// -------------------------------------------------------
// ENV CHECK (SEM QUEBRAR SILENCIOSO)
// -------------------------------------------------------
const REQUIRED_ENVS = ['JWT_SECRET', 'ADMIN_USER', 'ADMIN_PASS'];

for (const env of REQUIRED_ENVS) {
  if (!process.env[env]) {
    console.error(`❌ Missing env var: ${env}`);
    process.exit(1);
  }
}

const JWT_SECRET = process.env.JWT_SECRET;
const RESET_SECRET = process.env.RESET_SECRET || 'reset_admin_secret_2024';

const app = express();
const PORT = process.env.PORT || 10000;

// 🔥 FIX RENDER PROXY + RATE LIMIT BUG
app.set('trust proxy', 1);

// -------------------------------------------------------
// MIDDLEWARES
// -------------------------------------------------------
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true, limit: '1mb' }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// -------------------------------------------------------
// RATE LIMIT (FIXED FOR PROXY)
// -------------------------------------------------------
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  message: { error: 'Muitas requisições, tente novamente mais tarde' }
});

app.use('/api/', globalLimiter);

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
  message: { error: 'Muitas tentativas de login, tente novamente em 15 minutos' }
});

const loaderLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 30,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
});

// -------------------------------------------------------
// SECURITY LOG
// -------------------------------------------------------
function securityLog(action, details, ip = 'unknown') {
  const entry = {
    id: Date.now(),
    action,
    details,
    ip,
    created_at: new Date().toISOString()
  };

  DB.securityLogs.push(entry);
  if (DB.securityLogs.length > 1000) DB.securityLogs.shift();

  saveDb();
  console.log(`[SECURITY] ${action}: ${details} (IP: ${ip})`);
}

// -------------------------------------------------------
// VALIDATION
// -------------------------------------------------------
const scriptCreateSchema = z.object({
  name: z.string().min(1).max(100),
  content: z.string().min(1).max(50000),
  status: z.enum(['online', 'offline', 'maintenance', 'development']).default('online'),
  tags: z.array(z.string().max(30)).max(10).default([])
});

const keyCreateSchema = z.object({
  scriptId: z.string().optional(),
  hwid: z.string().max(100).optional().default(''),
  expiresAt: z.string().datetime().optional()
});

// -------------------------------------------------------
// AUTH
// -------------------------------------------------------
app.post('/api/auth/login', loginLimiter, (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: 'Preencha todos os campos' });
  }

  const admin = DB.admins.find(a => a.username === username);

  if (!admin || !bcrypt.compareSync(password, admin.password_hash)) {
    securityLog('LOGIN_FAILED', `User: ${username}`, req.ip);
    return res.status(401).json({ error: 'Credenciais inválidas' });
  }

  const token = jwt.sign(
    { id: admin.id, username: admin.username, role: admin.role || 'admin' },
    JWT_SECRET,
    { expiresIn: '8h' }
  );

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    path: '/',
    maxAge: 8 * 60 * 60 * 1000
  });

  securityLog('LOGIN_SUCCESS', username, req.ip);

  res.json({ success: true });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token');
  res.json({ success: true });
});

app.get('/api/auth/me', (req, res) => {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Não autenticado' });

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    res.json(decoded);
  } catch {
    res.status(401).json({ error: 'Token inválido' });
  }
});

function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Acesso negado' });

  try {
    req.admin = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Token inválido' });
  }
}

// -------------------------------------------------------
// ADMIN ROUTES FIX (CAN NOT GET /admin FIX)
// -------------------------------------------------------
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html'));
});

app.get('/admin/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html'));
});

app.get('/admin/dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin', 'dashboard.html'));
});

// -------------------------------------------------------
// RESET ADMIN
// -------------------------------------------------------
app.get('/api/reset-admin', (req, res) => {
  const { secret } = req.query;

  if (secret !== RESET_SECRET) {
    securityLog('RESET_FAIL', 'Invalid secret', req.ip);
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const user = process.env.ADMIN_USER;
  const pass = process.env.ADMIN_PASS;

  const hash = bcrypt.hashSync(pass, 10);

  DB.admins = DB.admins.filter(a => a.username !== user);
  DB.admins.push({
    id: Date.now(),
    username: user,
    password_hash: hash,
    role: 'master'
  });

  saveDb();

  res.json({ success: true });
});

// -------------------------------------------------------
// LOADER
// -------------------------------------------------------
app.get('/api/load/:scriptId', loaderLimiter, (req, res) => {
  const key = req.query.key;

  if (!key) return res.status(403).send('No key');

  const keyData = DB.keys.find(k => k.key === key);

  if (!keyData || keyData.status !== 'active') {
    return res.status(403).send('Invalid key');
  }

  const script = DB.scripts.find(s => s.id === req.params.scriptId);

  if (!script || script.status !== 'online') {
    return res.status(404).send('Script not found');
  }

  script.executions++;
  keyData.last_used = new Date().toISOString();
  saveDb();

  res.type('text/plain');
  res.send(script.content);
});

// -------------------------------------------------------
// START SERVER
// -------------------------------------------------------
const adminUser = process.env.ADMIN_USER;
const adminPass = process.env.ADMIN_PASS;

if (!DB.admins.find(a => a.username === adminUser)) {
  DB.admins.push({
    id: Date.now(),
    username: adminUser,
    password_hash: bcrypt.hashSync(adminPass, 10),
    role: 'master'
  });

  saveDb();
  console.log(`✅ Admin criado: ${adminUser}`);
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🪐 Saturn Storage rodando em http://0.0.0.0:${PORT}`);
});