require('dotenv').config();
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');
const { initDatabase, getDb, saveDb } = require('./database');
const bcrypt = require('bcryptjs');

const authRoutes = require('./routes/auth');
const scriptsRoutes = require('./routes/scripts');
const loadRoutes = require('./routes/load');

const app = express();
const PORT = process.env.PORT || 3000;

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

// Rota de emergência para resetar senha
app.get('/api/reset-admin', (req, res) => {
  const db = getDb();
  const username = 'nanagui';
  const password = '001010GGZEHEN';
  db.run('DELETE FROM admins WHERE username = ?', [username]);
  const hash = bcrypt.hashSync(password, 10);
  db.prepare('INSERT INTO admins (username, password_hash) VALUES (?, ?)').run([username, hash]);
  saveDb();
  res.json({ success: true, username, password });
});

(async () => {
  await initDatabase();
  const db = getDb();

  const username = process.env.ADMIN_USER || 'nanagui';
  const password = process.env.ADMIN_PASS || '001010GGZEHEN';
  const existing = db.prepare('SELECT id FROM admins WHERE username = ?').get([username]);
  if (!existing) {
    const hash = bcrypt.hashSync(password, 10);
    // 🔥 CORREÇÃO: password_hash (nome correto da coluna)
    db.prepare('INSERT INTO admins (username, password_hash) VALUES (?, ?)').run([username, hash]);
    saveDb();
    console.log(`✅ Admin criado: ${username}`);
  } else {
    // Garantir que o hash não está vazio (corrige registros antigos)
    const admin = db.prepare('SELECT password_hash FROM admins WHERE username = ?').get([username]);
    if (!admin.password_hash || admin.password_hash === '') {
      const hash = bcrypt.hashSync(password, 10);
      db.prepare('UPDATE admins SET password_hash = ? WHERE username = ?').run([hash, username]);
      saveDb();
      console.log(`🔧 Hash do admin ${username} foi corrigido`);
    }
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🪐 Saturn Storage rodando em http://0.0.0.0:${PORT}`);
  });
})();