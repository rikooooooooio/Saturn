require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const rateLimit = require('express-rate-limit');
const { DB, saveDb } = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  console.error('Missing JWT_SECRET');
  process.exit(1);
}

// 🔥 FIX RENDER + PROXY (ESSENCIAL)
app.set('trust proxy', 1);

app.use(express.json());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// ---------------- RATE LIMIT ----------------
app.use('/api/', rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200
}));

// ---------------- SECURITY LOG ----------------
function log(action, meta, req) {
  DB.logs = DB.logs || [];
  DB.logs.push({
    action,
    meta,
    ip: req.ip,
    time: new Date().toISOString()
  });

  DB.logs = DB.logs.slice(-1000);
  saveDb();
}

// ---------------- JWT ----------------
function auth(req, res, next) {
  const token = req.cookies.token;
  if (!token) return res.status(401).json({ error: 'no token' });

  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ error: 'invalid token' });
  }
}

// ---------------- LOGIN ----------------
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;

  const admin = DB.admins.find(a => a.username === username);
  if (!admin) return res.status(401).json({ error: 'invalid' });

  if (!bcrypt.compareSync(password, admin.password_hash)) {
    return res.status(401).json({ error: 'invalid' });
  }

  const token = jwt.sign(
    { id: admin.id, username: admin.username, role: admin.role },
    JWT_SECRET,
    { expiresIn: '8h' }
  );

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict'
  });

  log('LOGIN_SUCCESS', username, req);

  res.json({ success: true });
});

// ---------------- VERIFY ----------------
app.get('/api/auth/me', auth, (req, res) => {
  res.json(req.user);
});

// ---------------- DASHBOARD STATS (🔥 ANALYTICS) ----------------
app.get('/api/stats', auth, (req, res) => {
  const scripts = DB.scripts.length;
  const keys = DB.keys.length;

  const executions = DB.scripts.reduce((a, b) => a + (b.executions || 0), 0);

  const logs = DB.logs || [];

  res.json({
    scripts,
    keys,
    executions,
    lastLogs: logs.slice(-10)
  });
});

// ---------------- SCRIPTS (API REAL) ----------------
app.get('/api/scripts', auth, (req, res) => {
  res.json(DB.scripts);
});

app.post('/api/scripts', auth, (req, res) => {
  const s = {
    id: uuidv4(),
    name: req.body.name,
    content: req.body.content,
    executions: 0,
    created_at: new Date().toISOString()
  };

  DB.scripts.push(s);
  saveDb();

  log('SCRIPT_CREATED', s.name, req);

  res.json(s);
});

// ---------------- KEYS ----------------
app.get('/api/keys', auth, (req, res) => {
  res.json(DB.keys);
});

app.post('/api/keys', auth, (req, res) => {
  const key = 'SATURN-' + uuidv4().slice(0, 10);

  const k = {
    id: Date.now(),
    key,
    hwid: '',
    script: req.body.script || null,
    created_at: new Date().toISOString()
  };

  DB.keys.push(k);
  saveDb();

  log('KEY_CREATED', key, req);

  res.json(k);
});

// ---------------- LOADER (analytics execução) ----------------
app.get('/api/load/:id', (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).send('not found');

  script.executions = (script.executions || 0) + 1;
  saveDb();

  log('SCRIPT_EXEC', script.name, req);

  res.type('text').send(script.content);
});

// ---------------- PAGES ----------------
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'public/admin/login.html'));
});

app.get('/admin/dashboard', (req, res) => {
  res.sendFile(path.join(__dirname, 'public/admin/dashboard.html'));
});

// ---------------- START ----------------
app.listen(PORT, '0.0.0.0', () => {
  console.log('🚀 running on ' + PORT);
});