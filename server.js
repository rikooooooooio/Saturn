require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const rateLimit = require('express-rate-limit');
const path = require('path');
const { initDatabase, getDb, saveDb } = require('./database');
const argon2 = require('argon2');

const authRoutes = require('./routes/auth');
const scriptsRoutes = require('./routes/scripts');
const keysRoutes = require('./routes/keys');
const loaderRoutes = require('./routes/loader');

const app = express();
const PORT = process.env.PORT || 3000;

// Confiar no proxy do Render
app.set('trust proxy', 1);

app.use(helmet());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 60,
  standardHeaders: true,
  legacyHeaders: false,
});
app.use('/api/', limiter);

app.use((req, res, next) => {
  req.db = getDb();
  req.saveDb = saveDb;
  next();
});

app.use('/api/auth', authRoutes);
app.use('/api/scripts', scriptsRoutes);
app.use('/api/keys', keysRoutes);
app.use('/api/load', loaderRoutes);

app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});

// Inicialização com correção do admin
(async () => {
  try {
    await initDatabase();
    const db = getDb();

    const adminEmail = process.env.ADMIN_EMAIL || 'nanagui@youtubepontucom';
    const adminPassword = process.env.ADMIN_PASSWORD || '001010GGZEHEN';

    // 🔧 Remove admin antigo se existir (hash vazio/corrompido)
    db.run('DELETE FROM admins WHERE email = ?', [adminEmail]);

    // Cria um novo com hash válido
    const hash = await argon2.hash(adminPassword, {
      type: argon2.argon2id,
      memoryCost: 2 ** 16,
      timeCost: 3,
      parallelism: 1,
    });

    db.prepare('INSERT INTO admins (email, password_hash) VALUES (?, ?)').run([adminEmail, hash]);
    saveDb();
    console.log(`✅ Admin criado/atualizado: ${adminEmail}`);
    console.log(`🔑 Use: Email: ${adminEmail} | Senha: ${adminPassword}`);

    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🪐 Saturn Panel rodando em http://0.0.0.0:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Falha na inicialização:', error);
    process.exit(1);
  }
})();