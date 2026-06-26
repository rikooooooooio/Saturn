require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const crypto = require('crypto');
const { z } = require('zod');
const rateLimit = require('express-rate-limit');
const { DB, saveDb } = require('./database');

// ---------------------------
// INIT SAFE DB
// ---------------------------
DB.admins ??= [];
DB.scripts ??= [];
DB.keys ??= [];
DB.versions ??= [];
DB.securityLogs ??= [];
DB.analytics ??= { executions: [], keys: [] };

// ---------------------------
// ENV CHECK
// ---------------------------
if (!process.env.JWT_SECRET || !process.env.SCRIPT_KEY) {
  console.error("Missing env vars");
  process.exit(1);
}

const JWT_SECRET = process.env.JWT_SECRET;
const SCRIPT_KEY = process.env.SCRIPT_KEY;

// ---------------------------
// APP
// ---------------------------
const app = express();
const PORT = process.env.PORT || 3000;

app.set('trust proxy', 1);
app.use(express.json({ limit: '1mb' }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// ---------------------------
// CRYPTO HELPERS (SCRIPT)
// ---------------------------
function encrypt(text) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(
    'aes-256-cbc',
    Buffer.from(SCRIPT_KEY),
    iv
  );

  let enc = cipher.update(text);
  enc = Buffer.concat([enc, cipher.final()]);

  return iv.toString('hex') + ':' + enc.toString('hex');
}

function decrypt(data) {
  const [ivHex, content] = data.split(':');
  const iv = Buffer.from(ivHex, 'hex');

  const decipher = crypto.createDecipheriv(
    'aes-256-cbc',
    Buffer.from(SCRIPT_KEY),
    iv
  );

  let dec = decipher.update(Buffer.from(content, 'hex'));
  dec = Buffer.concat([dec, decipher.final()]);
  return dec.toString();
}

// ---------------------------
// HWID HASH
// ---------------------------
function hashHWID(hwid) {
  return crypto
    .createHash('sha256')
    .update(hwid + (process.env.HWID_SALT || 'salt'))
    .digest('hex');
}

// ---------------------------
// SECURITY LOG
// ---------------------------
function log(action, details, req) {
  DB.securityLogs.push({
    action,
    details,
    ip: req.ip,
    time: new Date().toISOString()
  });
  if (DB.securityLogs.length > 1000) DB.securityLogs.shift();
  saveDb();
}

// ---------------------------
// RATE LIMIT
// ---------------------------
app.use('/api/', rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 120
}));

// ---------------------------
// AUTH
// ---------------------------
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;

  const admin = DB.admins.find(a => a.username === username);
  if (!admin || !bcrypt.compareSync(password, admin.password_hash)) {
    log('LOGIN_FAIL', username, req);
    return res.status(401).json({ error: 'invalid' });
  }

  const token = jwt.sign(
    { id: admin.id, username: admin.username },
    JWT_SECRET,
    { expiresIn: '8h' }
  );

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict'
  });

  log('LOGIN_OK', username, req);
  res.json({ ok: true });
});

function auth(req, res, next) {
  try {
    req.user = jwt.verify(req.cookies.token, JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ error: 'unauthorized' });
  }
}

// ---------------------------
// KEYS (KEYAUTH STYLE)
// ---------------------------
app.post('/api/keys', auth, (req, res) => {
  const key = "SATURN-" + uuidv4().slice(0, 16).toUpperCase();

  const newKey = {
    id: Date.now(),
    key,
    status: "active",
    bound_hwid: null,
    uses: 0,
    max_uses: 1,
    expires_at: null,
    created_at: new Date().toISOString()
  };

  DB.keys.push(newKey);
  saveDb();

  log('KEY_CREATE', key, req);
  res.json(newKey);
});

// ---------------------------
// SCRIPT CREATE (ENCRYPTED)
// ---------------------------
app.post('/api/scripts', auth, (req, res) => {
  const { name, content } = req.body;

  const script = {
    id: uuidv4(),
    name,
    content: encrypt(content), // 🔐 encrypted
    executions: 0,
    created_at: new Date().toISOString()
  };

  DB.scripts.push(script);
  saveDb();

  log('SCRIPT_CREATE', name, req);
  res.json(script);
});

// ---------------------------
// LOADER (KEY + HWID + ANTI-LEAK)
// ---------------------------
app.get('/api/load/:id', (req, res) => {
  const { key, hwid } = req.query;

  if (!key || !hwid) {
    log('LOAD_NO_AUTH', req.params.id, req);
    return res.status(403).send('blocked');
  }

  const keyData = DB.keys.find(k => k.key === key);
  if (!keyData || keyData.status !== "active") {
    log('LOAD_BAD_KEY', key, req);
    return res.status(403).send('blocked');
  }

  const hashed = hashHWID(hwid);

  // bind HWID (anti-share)
  if (!keyData.bound_hwid) {
    keyData.bound_hwid = hashed;
  }

  if (keyData.bound_hwid !== hashed) {
    log('HWID_MISMATCH', key, req);
    return res.status(403).send('blocked');
  }

  if (keyData.uses >= keyData.max_uses) {
    return res.status(403).send('limit');
  }

  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).send('not found');

  keyData.uses++;
  script.executions++;

  // 📊 analytics
  DB.analytics.executions.push({
    scriptId: script.id,
    key,
    hwid: hashed,
    ip: req.ip,
    time: new Date().toISOString()
  });

  saveDb();

  // decrypt before send
  const output = decrypt(script.content);

  res.type('text/plain').send(output);
});

// ---------------------------
// ANALYTICS API
// ---------------------------
app.get('/api/analytics', auth, (req, res) => {
  res.json(DB.analytics);
});

// ---------------------------
// INIT ADMIN
// ---------------------------
if (!DB.admins.length) {
  DB.admins.push({
    id: 1,
    username: process.env.ADMIN_USER || 'admin',
    password_hash: bcrypt.hashSync(process.env.ADMIN_PASS || '123', 10),
    role: 'master'
  });

  saveDb();
}

// ---------------------------
app.listen(PORT, () => {
  console.log("Saturn PRO running on", PORT);
});