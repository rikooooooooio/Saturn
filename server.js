require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { DB, saveDb } = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// -------------------------------------------------------
// AUTENTICAÇÃO
// -------------------------------------------------------
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Preencha todos os campos' });

  const admin = DB.admins.find(a => a.username === username);
  if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });

  if (!admin.password_hash) {
    return res.status(500).json({ error: 'Erro interno. Acesse /api/reset-admin' });
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

// -------------------------------------------------------
// ROTA DE EMERGÊNCIA
// -------------------------------------------------------
app.get('/api/reset-admin', (req, res) => {
  const user = process.env.ADMIN_USER || 'nanagui';
  const pass = process.env.ADMIN_PASS || '001010GGZEHEN';
  const hash = bcrypt.hashSync(pass, 10);

  DB.admins = DB.admins.filter(a => a.username !== user);
  DB.admins.push({ id: Date.now(), username: user, password_hash: hash, role: 'master' });
  saveDb();

  return res.json({ success: true, username: user, password: pass });
});

// -------------------------------------------------------
// SCRIPTS (CRUD completo)
// -------------------------------------------------------
app.get('/api/scripts', authMiddleware, (req, res) => {
  const scripts = DB.scripts.map(s => ({
    id: s.id,
    name: s.name,
    status: s.status,
    tags: s.tags || [],
    executions: s.executions || 0,
    updated_at: s.updated_at
  })).sort((a, b) => new Date(b.updated_at) - new Date(a.updated_at));
  return res.json(scripts);
});

app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  return res.json(script);
});

app.post('/api/scripts', authMiddleware, (req, res) => {
  const { name, content, status, tags } = req.body;
  if (!name || !content) return res.status(400).json({ error: 'Nome e conteúdo obrigatórios' });

  const newScript = {
    id: uuidv4(),
    name,
    content,
    status: status || 'online',
    tags: tags || [],
    executions: 0,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };
  DB.scripts.push(newScript);
  saveDb();
  return res.status(201).json(newScript);
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
    tags: script.tags,
    created_at: new Date().toISOString()
  });

  const { name, content, status, tags } = req.body;
  if (name !== undefined) script.name = name;
  if (content !== undefined) script.content = content;
  if (status !== undefined) script.status = status;
  if (tags !== undefined) script.tags = tags;
  script.updated_at = new Date().toISOString();
  saveDb();
  return res.json(script);
});

app.delete('/api/scripts/:id', authMiddleware, (req, res) => {
  DB.scripts = DB.scripts.filter(s => s.id !== req.params.id);
  DB.versions = DB.versions.filter(v => v.script_id !== req.params.id);
  saveDb();
  return res.json({ success: true });
});

app.post('/api/scripts/:id/duplicate', authMiddleware, (req, res) => {
  const original = DB.scripts.find(s => s.id === req.params.id);
  if (!original) return res.status(404).json({ error: 'Script não encontrado' });

  const newScript = {
    ...original,
    id: uuidv4(),
    name: original.name + ' (Cópia)',
    executions: 0,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };
  DB.scripts.push(newScript);
  saveDb();
  return res.status(201).json(newScript);
});

app.get('/api/scripts/:id/versions', authMiddleware, (req, res) => {
  const versions = DB.versions
    .filter(v => v.script_id === req.params.id)
    .sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
  return res.json(versions);
});

// -------------------------------------------------------
// LOADER PÚBLICO (apenas User-Agent check)
// -------------------------------------------------------
app.get('/api/load/:scriptId', (req, res) => {
  // Verifica User-Agent (bloqueia navegadores comuns)
  const ua = (req.get('User-Agent') || '').toLowerCase();
  if (!ua.includes('roblox')) {
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  const script = DB.scripts.find(s => s.id === req.params.scriptId && s.status === 'online');
  if (!script) {
    return res.status(404).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  // Incrementa contador de execuções
  script.executions = (script.executions || 0) + 1;
  saveDb();

  // Retorna o conteúdo do script
  res.type('text/plain');
  return res.send(script.content);
});

// -------------------------------------------------------
// PÁGINAS
// -------------------------------------------------------
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html')));
app.get('/admin/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'dashboard.html')));

// -------------------------------------------------------
// INICIALIZAÇÃO
// -------------------------------------------------------
const user = process.env.ADMIN_USER || 'nanagui';
const pass = process.env.ADMIN_PASS || '001010GGZEHEN';

if (!DB.admins.find(a => a.username === user)) {
  const hash = bcrypt.hashSync(pass, 10);
  DB.admins.push({ id: Date.now(), username: user, password_hash: hash, role: 'master' });
  saveDb();
  console.log(`✅ Admin criado: ${user}`);
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🪐 Rodando na porta ${PORT}`);
});