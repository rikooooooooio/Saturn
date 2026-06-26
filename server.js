require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { initDatabase, getDb, saveDb } = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

// -------------------------------------------------------
// MIDDLEWARES
// -------------------------------------------------------
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Injeta o banco nas requisições
app.use((req, res, next) => {
  req.db = getDb();
  req.saveDb = saveDb;
  next();
});

// -------------------------------------------------------
// AUTENTICAÇÃO
// -------------------------------------------------------
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Preencha todos os campos' });

  const admin = req.db.prepare('SELECT * FROM admins WHERE username = ?').get([username]);
  if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });

  // Verifica se o hash existe e é válido
  if (!admin.password_hash || typeof admin.password_hash !== 'string') {
    console.error(`Hash inválido para usuário ${username}. Use /api/reset-admin para corrigir.`);
    return res.status(500).json({ error: 'Erro interno (hash inválido). Acesse /api/reset-admin' });
  }

  const valid = bcrypt.compareSync(password, admin.password_hash);
  if (!valid) return res.status(401).json({ error: 'Credenciais inválidas' });

  const token = jwt.sign(
    { id: admin.id, username: admin.username, role: admin.role || 'admin' },
    process.env.JWT_SECRET || 'secret',
    { expiresIn: '8h' }
  );

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    maxAge: 8 * 60 * 60 * 1000
  });

  return res.json({ success: true, role: admin.role });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax' });
  return res.json({ success: true });
});

app.get('/api/auth/me', (req, res) => {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Não autenticado' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    return res.json({ username: decoded.username, role: decoded.role });
  } catch {
    return res.status(401).json({ error: 'Token inválido' });
  }
});

// Middleware de autenticação
function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Acesso negado' });

  try {
    req.admin = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    next();
  } catch {
    return res.status(401).json({ error: 'Token inválido' });
  }
}

// Middleware para rotas restritas ao master
function masterMiddleware(req, res, next) {
  if (!req.admin || req.admin.role !== 'master') {
    return res.status(403).json({ error: 'Apenas o admin master pode executar esta ação' });
  }
  next();
}

// -------------------------------------------------------
// ROTA DE EMERGÊNCIA PARA RESETAR O ADMIN
// -------------------------------------------------------
app.get('/api/reset-admin', (req, res) => {
  const db = getDb();
  const masterUser = process.env.ADMIN_USER || 'nanagui';
  const masterPass = process.env.ADMIN_PASS || '001010GGZEHEN';
  const hash = bcrypt.hashSync(masterPass, 10);

  db.run('DELETE FROM admins WHERE username = ?', [masterUser]);
  db.prepare('INSERT INTO admins (username, password_hash, role) VALUES (?, ?, ?)').run([masterUser, hash, 'master']);
  saveDb();

  return res.json({
    success: true,
    username: masterUser,
    password: masterPass,
    message: 'Admin recriado com sucesso. Faça login novamente.'
  });
});

// -------------------------------------------------------
// CRUD DE SCRIPTS
// -------------------------------------------------------
app.get('/api/scripts', authMiddleware, (req, res) => {
  const scripts = req.db.prepare('SELECT id, name, status, tags, executions, updated_at FROM scripts ORDER BY updated_at DESC').all();
  return res.json(scripts.map(s => ({ ...s, tags: JSON.parse(s.tags || '[]') })));
});

app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  script.tags = JSON.parse(script.tags || '[]');
  return res.json(script);
});

app.post('/api/scripts', authMiddleware, (req, res) => {
  const { name, content, status, tags } = req.body;
  if (!name || !content) return res.status(400).json({ error: 'Nome e conteúdo são obrigatórios' });

  const id = uuidv4();
  const now = new Date().toISOString();
  req.db.prepare('INSERT INTO scripts (id, name, content, status, tags, updated_at) VALUES (?, ?, ?, ?, ?, ?)')
    .run([id, name, content, status || 'online', JSON.stringify(tags || []), now]);
  req.saveDb();

  const newScript = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([id]);
  newScript.tags = JSON.parse(newScript.tags || '[]');
  return res.status(201).json(newScript);
});

app.put('/api/scripts/:id', authMiddleware, (req, res) => {
  const original = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  if (!original) return res.status(404).json({ error: 'Script não encontrado' });

  // Salva versão anterior no histórico
  req.db.prepare('INSERT INTO versions (id, script_id, name, content, status, tags) VALUES (?, ?, ?, ?, ?, ?)')
    .run([uuidv4(), original.id, original.name, original.content, original.status, original.tags]);
  req.saveDb();

  const { name, content, status, tags } = req.body;
  const now = new Date().toISOString();
  req.db.prepare('UPDATE scripts SET name = COALESCE(?, name), content = COALESCE(?, content), status = COALESCE(?, status), tags = COALESCE(?, tags), updated_at = ? WHERE id = ?')
    .run([name || null, content || null, status || null, tags ? JSON.stringify(tags) : null, now, req.params.id]);
  req.saveDb();

  const updated = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  updated.tags = JSON.parse(updated.tags || '[]');
  return res.json(updated);
});

app.delete('/api/scripts/:id', authMiddleware, (req, res) => {
  req.db.prepare('DELETE FROM scripts WHERE id = ?').run([req.params.id]);
  req.saveDb();
  return res.json({ success: true });
});

app.post('/api/scripts/:id/duplicate', authMiddleware, (req, res) => {
  const original = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  if (!original) return res.status(404).json({ error: 'Script não encontrado' });

  const newId = uuidv4();
  const now = new Date().toISOString();
  req.db.prepare('INSERT INTO scripts (id, name, content, status, tags, updated_at) VALUES (?, ?, ?, ?, ?, ?)')
    .run([newId, original.name + ' (Cópia)', original.content, original.status, original.tags, now]);
  req.saveDb();

  const duplicated = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([newId]);
  duplicated.tags = JSON.parse(duplicated.tags || '[]');
  return res.status(201).json(duplicated);
});

app.get('/api/scripts/:id/versions', authMiddleware, (req, res) => {
  const versions = req.db.prepare('SELECT * FROM versions WHERE script_id = ? ORDER BY created_at DESC').all([req.params.id]);
  return res.json(versions);
});

// -------------------------------------------------------
// SISTEMA DE KEYS
// -------------------------------------------------------
app.get('/api/keys', authMiddleware, (req, res) => {
  const keys = req.db.prepare('SELECT * FROM keys ORDER BY created_at DESC').all();
  return res.json(keys);
});

app.post('/api/keys', authMiddleware, (req, res) => {
  const { scriptId, hwid, expiresAt } = req.body;
  const key = 'SATURN-' + uuidv4().slice(0, 16).toUpperCase();
  req.db.prepare('INSERT INTO keys (key, script_id, hwid, expires_at) VALUES (?, ?, ?, ?)')
    .run([key, scriptId || null, hwid || '', expiresAt || null]);
  req.saveDb();

  const newKey = req.db.prepare('SELECT * FROM keys WHERE key = ?').get([key]);
  return res.status(201).json(newKey);
});

app.put('/api/keys/:id', authMiddleware, (req, res) => {
  const { hwid, expiresAt, status } = req.body;
  req.db.prepare('UPDATE keys SET hwid = COALESCE(?, hwid), expires_at = COALESCE(?, expires_at), status = COALESCE(?, status) WHERE id = ?')
    .run([hwid || null, expiresAt || null, status || null, req.params.id]);
  req.saveDb();
  return res.json({ success: true });
});

app.delete('/api/keys/:id', authMiddleware, (req, res) => {
  req.db.prepare('DELETE FROM keys WHERE id = ?').run([req.params.id]);
  req.saveDb();
  return res.json({ success: true });
});

// -------------------------------------------------------
// LOADER COM KEY + HWID (PROTEÇÃO REAL)
// -------------------------------------------------------
app.get('/api/load/:scriptId', (req, res) => {
  const { key, hwid } = req.query;
  if (!key) return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));

  const keyData = req.db.prepare('SELECT * FROM keys WHERE key = ?').get([key]);
  if (!keyData || keyData.status !== 'active') {
    req.db.prepare('INSERT INTO execution_logs (script_id, key_used, hwid, ip, success) VALUES (?, ?, ?, ?, 0)')
      .run([req.params.scriptId, key, hwid || '', req.ip]);
    req.saveDb();
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  if (keyData.expires_at && new Date(keyData.expires_at) < new Date()) {
    req.db.prepare('UPDATE keys SET status = ? WHERE id = ?').run(['expired', keyData.id]);
    req.saveDb();
    req.db.prepare('INSERT INTO execution_logs (script_id, key_used, hwid, ip, success) VALUES (?, ?, ?, ?, 0)')
      .run([req.params.scriptId, key, hwid || '', req.ip]);
    req.saveDb();
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  if (keyData.hwid && hwid !== keyData.hwid) {
    req.db.prepare('INSERT INTO execution_logs (script_id, key_used, hwid, ip, success) VALUES (?, ?, ?, ?, 0)')
      .run([req.params.scriptId, key, hwid || '', req.ip]);
    req.saveDb();
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  // Auto-vínculo de HWID no primeiro uso (se a key não tiver HWID)
  if (!keyData.hwid && hwid) {
    req.db.prepare('UPDATE keys SET hwid = ? WHERE id = ?').run([hwid, keyData.id]);
    req.saveDb();
  }

  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ? AND status = ?').get([req.params.scriptId, 'online']);
  if (!script) {
    req.db.prepare('INSERT INTO execution_logs (script_id, key_used, hwid, ip, success) VALUES (?, ?, ?, ?, 0)')
      .run([req.params.scriptId, key, hwid || '', req.ip]);
    req.saveDb();
    return res.status(404).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  req.db.prepare('UPDATE scripts SET executions = executions + 1 WHERE id = ?').run([script.id]);
  req.db.prepare('INSERT INTO execution_logs (script_id, key_used, hwid, ip, success) VALUES (?, ?, ?, ?, 1)')
    .run([script.id, key, hwid || '', req.ip]);
  req.saveDb();

  return res.type('text/plain').send(script.content);
});

// -------------------------------------------------------
// ESTATÍSTICAS
// -------------------------------------------------------
app.get('/api/stats', authMiddleware, (req, res) => {
  const scriptsCount = req.db.prepare('SELECT COUNT(*) as count FROM scripts').get().count;
  const keysCount = req.db.prepare('SELECT COUNT(*) as count FROM keys').get().count;
  const execToday = req.db.prepare("SELECT COUNT(*) as count FROM execution_logs WHERE success = 1 AND created_at > datetime('now', '-1 day')").get().count;
  return res.json({ totalScripts: scriptsCount, totalKeys: keysCount, executionsToday: execToday });
});

// -------------------------------------------------------
// GESTÃO DE ADMINS (APENAS MASTER)
// -------------------------------------------------------
app.get('/api/admins', authMiddleware, masterMiddleware, (req, res) => {
  const admins = req.db.prepare('SELECT id, username, role FROM admins').all();
  return res.json(admins);
});

app.post('/api/admins', authMiddleware, masterMiddleware, (req, res) => {
  const { username, password, role } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Username e senha obrigatórios' });
  const hash = bcrypt.hashSync(password, 10);
  req.db.prepare('INSERT INTO admins (username, password_hash, role) VALUES (?, ?, ?)').run([username, hash, role || 'admin']);
  req.saveDb();
  return res.json({ success: true });
});

app.delete('/api/admins/:id', authMiddleware, masterMiddleware, (req, res) => {
  if (req.admin.id == req.params.id) return res.status(400).json({ error: 'Você não pode excluir a si mesmo' });
  req.db.prepare('DELETE FROM admins WHERE id = ?').run([req.params.id]);
  req.saveDb();
  return res.json({ success: true });
});

// -------------------------------------------------------
// PÁGINAS ESTÁTICAS
// -------------------------------------------------------
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html')));
app.get('/admin/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'dashboard.html')));

// -------------------------------------------------------
// INICIALIZAÇÃO DO BANCO E ADMIN MASTER
// -------------------------------------------------------
(async () => {
  await initDatabase();
  const db = getDb();

  const masterUser = process.env.ADMIN_USER || 'nanagui';
  const masterPass = process.env.ADMIN_PASS || '001010GGZEHEN';

  // Garante que o admin master existe com hash válido
  const admin = db.prepare('SELECT * FROM admins WHERE username = ?').get([masterUser]);
  if (admin) {
    if (!admin.password_hash || typeof admin.password_hash !== 'string' || admin.password_hash.trim() === '') {
      const hash = bcrypt.hashSync(masterPass, 10);
      db.prepare('UPDATE admins SET password_hash = ? WHERE id = ?').run([hash, admin.id]);
      saveDb();
      console.log('🔧 Hash do admin corrigido');
    }
  } else {
    const hash = bcrypt.hashSync(masterPass, 10);
    db.prepare('INSERT INTO admins (username, password_hash, role) VALUES (?, ?, ?)').run([masterUser, hash, 'master']);
    saveDb();
    console.log('✅ Admin master criado');
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🪐 Saturn Storage rodando em http://0.0.0.0:${PORT}`);
    console.log(`🔑 Login: ${masterUser} / ${masterPass}`);
  });
})();