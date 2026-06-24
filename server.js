require('dotenv').config();
const fs = require('fs');
const path = require('path');
const express = require('express');
const cookieParser = require('cookie-parser');
const { initDatabase, getDb, saveDb } = require('./database');
const bcrypt = require('bcryptjs');

const authRoutes = require('./routes/auth');
const scriptsRoutes = require('./routes/scripts');
const loadRoutes = require('./routes/load');

const app = express();
const PORT = process.env.PORT || 3000;

// 🔥 Remove banco antigo para garantir hash limpo
const DB_PATH = path.join(__dirname, 'saturn.db');
if (fs.existsSync(DB_PATH)) {
  fs.unlinkSync(DB_PATH);
  console.log('🗑️ Banco antigo removido. Um novo será criado.');
}

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use((req, res, next) => {
  req.db = getDb();
  req.saveDb = saveDb;
  next();
});

app.use('/api/auth', authRoutes);
app.use('/api/scripts', scriptsRoutes);
app.use('/api/load', loadRoutes);

app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'login.html')));
app.get('/admin/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'public', 'admin', 'dashboard.html')));

// 🚨 Rota de emergência – acesse se o login falhar
app.get('/api/reset-admin', (req, res) => {
  const db = getDb();
  const username = 'nanagui';
  const password = '001010GGZEHEN';
  db.run('DELETE FROM admins WHERE username = ?', [username]);
  const hash = bcrypt.hashSync(password, 10);
  db.prepare('INSERT INTO admins (username, password_hash) VALUES (?, ?)').run([username, hash]);
  saveDb();
  res.json({ success: true, message: 'Admin recriado', username, password });
});

(async () => {
  await initDatabase();
  const db = getDb();

  const username = process.env.ADMIN_USER || 'nanagui';
  const password = process.env.ADMIN_PASS || '001010GGZEHEN';

  // Remover qualquer registro antigo e criar um novo
  db.run('DELETE FROM admins WHERE username = ?', [username]);
  const hash = bcrypt.hashSync(password, 10);
  db.prepare('INSERT INTO admins (username, password_hash) VALUES (?, ?)').run([username, hash]);
  saveDb();

  console.log(`✅ Admin criado: ${username}`);

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🪐 Saturn Storage rodando em http://0.0.0.0:${PORT}`);
  });
})();