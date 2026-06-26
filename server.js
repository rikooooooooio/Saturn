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

// Chave para mascarar a rota admin. Mude isso no seu arquivo .env se quiser alterar a URL!
const ADMIN_ROUTE_SECRET = process.env.ADMIN_ROUTE_SECRET || 'saturn_secret_hash_2026';
// Gera um hash único longo e imprevisível, ex: /fojwbwk927462819...
const DYNAMIC_ADMIN_PATH = '/' + crypto.createHash('sha256').update(ADMIN_ROUTE_SECRET).digest('hex');

console.log(`\n[SEGURANÇA] Sua URL administrativa secreta gerada é: http://localhost:${PORT}${DYNAMIC_ADMIN_PATH}\n`);

// --- SEGURANÇA BÁSICA ---
app.set('trust proxy', 1);
app.use(helmet({
  contentSecurityPolicy: false, // Permite estilos inline do seu painel atual
}));
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Limitadores de requisição
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: { error: 'Muitas tentativas de login. Tente novamente mais tarde.' }
});

const apiLimiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  max: 100,
  message: { error: 'Calma aí! Você está fazendo muitas requisições.' }
});

DB.scripts = DB.scripts || [];
DB.admins = DB.admins || [];

// Middleware de Autenticação ajustado para redirecionar para a rota dinâmica se falhar
function auth(req, res, next) {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Acesso negado. Redirecionando...' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.clearCookie('token');
    res.status(401).json({ error: 'Sessão expirada.' });
  }
}

// --------------------- AUTENTICAÇÃO ---------------------
app.post('/api/auth/login', loginLimiter, (req, res) => {
  const { username, password } = req.body;
  const admin = DB.admins.find(a => a.username === username);
  if (!admin || !bcrypt.compareSync(password, admin.password_hash)) {
    return res.status(401).json({ error: 'Credenciais inválidas' });
  }

  const token = jwt.sign({ id: admin.id, username }, JWT_SECRET, { expiresIn: '8h' });
  res.cookie('token', token, { httpOnly: true, secure: process.env.NODE_ENV === 'production', sameSite: 'lax', path: '/' });
  res.json({ success: true, redirectPath: `${DYNAMIC_ADMIN_PATH}/dashboard` });
});

app.post('/api/auth/logout', (req, res) => {
  res.clearCookie('token', { httpOnly: true, secure: process.env.NODE_ENV === 'production', sameSite: 'lax', path: '/' });
  res.json({ success: true, redirectPath: DYNAMIC_ADMIN_PATH });
});

app.get('/api/auth/me', auth, (req, res) => res.json({ username: req.user.username }));

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
    created_at: new Date().toISOString()
  };
  DB.scripts.push(script);
  saveDb();
  res.status(201).json(script);
});

app.put('/api/scripts/:id', auth, (req, res) => {
  const script = DB.scripts.find(s => s.id === req.params.id);
  if (!script) return res.status(404).json({ error: 'Script não encontrado' });
  
  const { name, content, status } = req.body;
  if (name) script.name = name.trim();
  if (content) script.content = content;
  if (status) script.status = status;
  
  saveDb();
  res.json(script);
});

app.delete('/api/scripts/:id', auth, (req, res) => {
  DB.scripts = DB.scripts.filter(s => s.id !== req.params.id);
  saveDb();
  res.json({ success: true });
});

app.get('/api/export', auth, (req, res) => res.json({ scripts: DB.scripts }));

app.post('/api/import', auth, (req, res) => {
  if (!req.body.scripts || !Array.isArray(req.body.scripts)) return res.status(400).json({ error: 'Formato inválido' });
  DB.scripts = req.body.scripts;
  saveDb();
  res.json({ success: true, imported: DB.scripts.length });
});

// --------------------- LOADER COM BLOQUEIO DE NAVEGADOR ---------------------
app.get('/api/load/:id', apiLimiter, (req, res) => {
  const userAgent = req.headers['user-agent'] || '';
  
  // Lista de termos comuns que indicam navegadores web normais
  const isBrowser = /Mozilla|Chrome|Safari|Edge|Firefox|Opera/i.test(userAgent);

  // Se o acesso vier de um navegador, exibe a página de bloqueio/falsa
  if (isBrowser) {
    res.status(403).send(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title>403 Forbidden</title>
        <style>
          body { background-color: #0b0b0b; color: #555; font-family: monospace; padding: 50px; text-align: center; }
          h1 { color: #dd3333; font-size: 2rem; margin-bottom: 10px; }
          p { font-size: 1rem; }
          .container { max-width: 600px; margin: 100px auto; border: 1px solid #222; padding: 40px; border-radius: 8px; background: #111; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>HTTP Error 403 - Forbidden</h1>
          <p>Access to the requested infrastructure resource is strictly prohibited.</p>
          <hr style="border-color: #222; margin: 20px 0;">
          <p style="color: #333; font-size: 0.8rem;">Saturn Security Protocol Node v4.0</p>
        </div>
      </body>
      </html>
    `);
    return;
  }

  // Se vier via script externo (ex: Python, cURL, Requests, Jogos), entrega o código
  const script = DB.scripts.find(s => s.id === req.params.id && s.status === 'online');
  if (!script) return res.status(404).send('-- Erro: Recurso indisponível ou em manutenção.');
  
  script.executions = (script.executions || 0) + 1;
  saveDb();
  res.type('text/plain').send(script.content);
});

// --------------------- ROTAS DINÂMICAS DO PAINEL ---------------------
// Tela de Login Dinâmica
app.get(DYNAMIC_ADMIN_PATH, (req, res) => {
  res.sendFile(path.join(__dirname, 'public/admin/login.html'));
});

// Dashboard Dinâmico
app.get(`${DYNAMIC_ADMIN_PATH}/dashboard`, (req, res) => {
  // O arquivo HTML é servido normalmente aqui, mas o acesso público direto via url antiga não funcionará
  res.sendFile(path.join(__dirname, 'public/admin/dashboard.html'));
});

// Se tentarem acessar a rota antiga antiga "/admin", retorna 404 para despistar
app.get('/admin', (req, res) => res.status(404).send('Cannot GET /admin'));
app.get('/admin/dashboard', (req, res) => res.status(404).send('Cannot GET /admin/dashboard'));

app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));

// --------------------- ADMIN INICIAL ---------------------
const ADMIN_USER = process.env.ADMIN_USER || 'nanagui';
const ADMIN_PASS = process.env.ADMIN_PASS || '001010GGZEHEN';
if (!DB.admins.find(a => a.username === ADMIN_USER)) {
  DB.admins.push({ id: 1, username: ADMIN_USER, password_hash: bcrypt.hashSync(ADMIN_PASS, 10) });
  saveDb();
  console.log(`✅ Admin padrão registrado: ${ADMIN_USER}`);
}

app.listen(PORT, '0.0.0.0', () => console.log(`🪐 Rodando com sucesso.`));
