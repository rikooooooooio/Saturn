require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Banco em memória
const DB = {
  admins: [],
  scripts: [],
  versions: [] // Histórico de versões: { id, scriptId, name, content, status, createdAt }
};

// Admin padrão
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';
const adminHash = bcrypt.hashSync(ADMIN_PASS, 10);
DB.admins.push({ id: 1, username: ADMIN_USER, password_hash: adminHash });
console.log(`✅ Admin pronto: ${ADMIN_USER}`);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use((req, res, next) => { req.DB = DB; next(); });

// Autenticação
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Preencha todos os campos' });
  const admin = DB.admins.find(a => a.username === username);
  if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });
  if (!bcrypt.compareSync(password, admin.password_hash)) return res.status(401).json({ error: 'Credenciais inválidas' });
  const token = jwt.sign({ id: admin.id, username: admin.username }, process.env.JWT_SECRET || 'secret', { expiresIn: '8h' });
  res.cookie('token', token, { httpOnly: true, secure: true, sameSite: 'lax', maxAge: 8 * 60 * 60 * 1000 });
  return res.json({ success: true });
});
app.post('/api/auth/logout', (req, res) => { res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax' }); res.json({ success: true }); });
app.get('/api/auth/me', (req, res) => {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Não autenticado' });
  try { const d = jwt.verify(token, process.env.JWT_SECRET || 'secret'); res.json({ username: d.username }); } catch { res.status(401).json({ error: 'Token inválido' }); }
});
function authMiddleware(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Acesso negado' });
  try { jwt.verify(token, process.env.JWT_SECRET || 'secret'); next(); } catch { res.status(401).json({ error: 'Token inválido' }); }
}

// SCRIPTS - CRUD + Tags + Duplicação + Histórico
app.get('/api/scripts', authMiddleware, (req, res) => {
  const scripts = DB.scripts.map(s => ({
    id: s.id, name: s.name, status: s.status, tags: s.tags || [],
    updated_at: s.updated_at, executions: s.executions || 0
  }));
  res.json(scripts);
});
app.get('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  res.json(script);
});
app.post('/api/scripts', authMiddleware, (req, res) => {
  const { name, content, status, tags } = req.body;
  if (!name || !content) return res.status(400).json({ error: 'Nome e conteúdo obrigatórios' });
  const newScript = {
    id: uuidv4(), name, content, status: status || 'online',
    tags: tags || [], executions: 0,
    created_at: new Date().toISOString(), updated_at: new Date().toISOString()
  };
  DB.scripts.push(newScript);
  res.status(201).json(newScript);
});
app.put('/api/scripts/:id', authMiddleware, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  // Salvar versão anterior no histórico
  DB.versions.push({
    id: uuidv4(), scriptId: script.id, name: script.name, content: script.content,
    status: script.status, tags: script.tags || [], createdAt: new Date().toISOString()
  });
  const { name, content, status, tags } = req.body;
  if (name !== undefined) script.name = name;
  if (content !== undefined) script.content = content;
  if (status !== undefined) script.status = status;
  if (tags !== undefined) script.tags = tags;
  script.updated_at = new Date().toISOString();
  res.json(script);
});
app.delete('/api/scripts/:id', authMiddleware, (req, res) => {
  const index = DB.scripts.findIndex(s => s.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: 'Script não encontrado' });
  DB.scripts.splice(index, 1);
  // Remove histórico associado
  DB.versions = DB.versions.filter(v => v.scriptId !== req.params.id);
  res.json({ success: true });
});
// Duplicar script
app.post('/api/scripts/:id/duplicate', authMiddleware, (req, res) => {
  const original = DB.scripts.find(s => s.id === req.params.id);
  if (!original) return res.status(404).json({ error: 'Script não encontrado' });
  const duplicate = {
    id: uuidv4(), name: original.name + ' (Cópia)', content: original.content,
    status: original.status, tags: [...(original.tags || [])], executions: 0,
    created_at: new Date().toISOString(), updated_at: new Date().toISOString()
  };
  DB.scripts.push(duplicate);
  res.status(201).json(duplicate);
});
// Histórico de versões de um script
app.get('/api/scripts/:id/versions', authMiddleware, (req, res) => {
  const versions = DB.versions.filter(v => v.scriptId === req.params.id);
  res.json(versions);
});

// Loader público (proteção por User-Agent)
app.get('/api/load/:id', (req, res) => {
  const userAgent = (req.get('User-Agent') || '').toLowerCase();
  if (!userAgent.includes('roblox')) return res.status(403).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  const script = DB.scripts.find(s => s.id === req.params.id && s.status === 'online');
  if (!script) return res.status(404).sendFile(path.join(__dirname, 'public', 'blocked.html'));
  script.executions = (script.executions || 0) + 1;
  script.last_execution = new Date().toISOString();
  res.type('text/plain').send(script.content);
});

// Páginas
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html')));
app.get('/admin/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'dashboard.html')));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🪐 Saturn Storage rodando em http://0.0.0.0:${PORT}`);
  console.log(`🔑 Admin: ${ADMIN_USER} | Senha: ${ADMIN_PASS}`);
});