require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// -------------------------------------------------------
// "BANCO" EM MEMÓRIA
// -------------------------------------------------------
const DB = {
  admins: [],
  scripts: []
};

// Criação garantida do admin
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';
const adminHash = bcrypt.hashSync(ADMIN_PASS, 10);
DB.admins.push({
  id: 1,
  username: ADMIN_USER,
  password_hash: adminHash
});
console.log(`✅ Admin pronto: ${ADMIN_USER}`);

// -------------------------------------------------------
// MIDDLEWARES
// -------------------------------------------------------
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use((req, res, next) => {
  req.DB = DB;
  next();
});

// -------------------------------------------------------
// AUTENTICAÇÃO
// -------------------------------------------------------
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Preencha todos os campos' });

  const admin = DB.admins.find(a => a.username === username);
  if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });

  const valid = bcrypt.compareSync(password, admin.password_hash);
  if (!valid) return res.status(401).json({ error: 'Credenciais inválidas' });

  const token = jwt.sign(
    { id: admin.id, username: admin.username },
    process.env.JWT_SECRET || 'secret',
    { expiresIn: '8h' }
  );

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    maxAge: 8 * 60 * 60 * 1000
  });

  return res.json({ success: true });
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
    return res.json({ username: decoded.username });
  } catch {
    return res.status(401).json({ error: 'Token inválido' });
  }
});

function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Acesso negado' });
  try {
    jwt.verify(token, process.env.JWT_SECRET || 'secret');
    next();
  } catch {
    return res.status(401).json({ error: 'Token inválido' });
  }
}

// -------------------------------------------------------
// CRUD DE SCRIPTS (PROTEGIDO)
// -------------------------------------------------------
app.get('/api/scripts', authMiddleware, (req, res) => {
  const scripts = DB.scripts.map(s => ({
    id: s.id,
    name: s.name,
    status: s.status,
    updated_at: s.updated_at
  }));
  return res.json(scripts);
});

app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  return res.json(script);
});

app.post('/api/scripts', authMiddleware, (req, res) => {
  const { name, content, status } = req.body;
  if (!name || !content) return res.status(400).json({ error: 'Nome e conteúdo obrigatórios' });

  const newScript = {
    id: uuidv4(),
    name,
    content,
    status: status || 'online',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };
  DB.scripts.push(newScript);
  return res.status(201).json(newScript);
});

app.put('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });

  const { name, content, status } = req.body;
  if (name !== undefined) script.name = name;
  if (content !== undefined) script.content = content;
  if (status !== undefined) script.status = status;
  script.updated_at = new Date().toISOString();
  return res.json(script);
});

app.delete('/api/scripts/:id', authMiddleware, (req, res) => {
  const index = DB.scripts.findIndex(s => s.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: 'Script não encontrado' });
  DB.scripts.splice(index, 1);
  return res.json({ success: true });
});

// -------------------------------------------------------
// LOADER PÚBLICO (PROTEÇÃO POR USER‑AGENT)
// -------------------------------------------------------
app.get('/api/load/:id', (req, res) => {
  const userAgent = (req.get('User-Agent') || '').toLowerCase();

  // Apenas o Roblox consegue carregar o código
  if (!userAgent.includes('roblox')) {
    return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  const script = DB.scripts.find(s => s.id === req.params.id && s.status === 'online');
  if (!script) {
    return res.status(404).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  }

  // Entrega o script em texto puro (somente o Roblox lê)
  res.type('text/plain');
  return res.send(script.content);
});

// -------------------------------------------------------
// PÁGINAS ESTÁTICAS
// -------------------------------------------------------
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html')));
app.get('/admin/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'dashboard.html')));

// -------------------------------------------------------
// INICIALIZAÇÃO
// -------------------------------------------------------
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🪐 Saturn Storage rodando em http://0.0.0.0:${PORT}`);
  console.log(`🔑 Admin: ${ADMIN_USER} | Senha: ${ADMIN_PASS}`);
});