require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const rateLimit = require('express-rate-limit');
const path = require('path');
const { initDatabase, getDb, saveDb } = require('./database');
const argon2 = require('argon2');

// Import routes
const authRoutes = require('./routes/auth');
const scriptsRoutes = require('./routes/scripts');
const keysRoutes = require('./routes/keys');
const loaderRoutes = require('./routes/loader');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Rate limit
const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 60,
  message: 'Too many requests, try again later.'
});
app.use('/api/', limiter);

// Middleware para injetar o db nas requisições
app.use((req, res, next) => {
  req.db = getDb();
  req.saveDb = saveDb;
  next();
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/scripts', scriptsRoutes);
app.use('/api/keys', keysRoutes);
app.use('/api/load', loaderRoutes);

// Serve admin page
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});

// Inicializar banco e admin, depois iniciar servidor
(async () => {
  await initDatabase();
  const db = getDb();

  const adminEmail = process.env.ADMIN_EMAIL;
  const adminPassword = process.env.ADMIN_PASSWORD;
  const existing = db.prepare('SELECT id FROM admins WHERE email = ?').get([adminEmail]);
  if (!existing) {
    const hash = await argon2.hash(adminPassword, {
      type: argon2.argon2id,
      memoryCost: 2 ** 16,
      timeCost: 3,
      parallelism: 1
    });
    db.prepare('INSERT INTO admins (email, password_hash) VALUES (?, ?)').run([adminEmail, hash]);
    saveDb();
    console.log(`✅ Admin created: ${adminEmail}`);
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🪐 Saturn Panel running on http://0.0.0.0:${PORT}`);
  });
})();