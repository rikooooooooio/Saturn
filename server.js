require('dotenv').config();
const path = require('path');
const express = require('express');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const rateLimit = require('express-rate-limit');
const { initDatabase, getDb, saveDb } = require('./database');
const bcrypt = require('bcryptjs');

const authRoutes = require('./routes/auth');
const scriptsRoutes = require('./routes/scripts');
const keysRoutes = require('./routes/keys');
const loaderRoutes = require('./routes/loader');

const app = express();
const PORT = process.env.PORT || 3000;

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

// NOTA: o antigo endpoint público "GET /api/reset-admin" foi removido.
// Ele expunha o email/senha do admin em JSON para qualquer visitante, sem
// autenticação nenhuma, e ainda resetava as credenciais. Se você precisar
// resetar a senha do admin no futuro, faça isso por um script local
// (ex: `node scripts/reset-admin.js`), nunca por uma rota HTTP pública.

/**
 * Garante que existe um admin, sem nunca apagar dados existentes e sem
 * duplicar o registro a cada restart do servidor.
 */
function ensureAdminSeed(db) {
  const adminEmail = process.env.ADMIN_EMAIL;
  const adminPassword = process.env.ADMIN_PASSWORD;

  if (!adminEmail || !adminPassword) {
    console.warn('⚠️  ADMIN_EMAIL / ADMIN_PASSWORD não definidos no .env — nenhum admin será criado automaticamente.');
    return;
  }

  const existing = db.prepare('SELECT id, password_hash FROM admins WHERE email = ?').get([adminEmail]);

  if (!existing) {
    const hash = bcrypt.hashSync(adminPassword, 10);
    db.prepare('INSERT INTO admins (email, password_hash) VALUES (?, ?)').run([adminEmail, hash]);
    saveDb();
    console.log(`✅ Admin criado: ${adminEmail}`);
    return;
  }

  // Caminho seguro e explícito para trocar a senha do admin sem expor
  // nenhuma rota HTTP pública: defina RESET_ADMIN_PASSWORD=true no .env,
  // reinicie o servidor uma vez, e depois REMOVA essa linha do .env.
  if (process.env.RESET_ADMIN_PASSWORD === 'true') {
    const hash = bcrypt.hashSync(adminPassword, 10);
    db.prepare('UPDATE admins SET password_hash = ? WHERE email = ?').run([hash, adminEmail]);
    saveDb();
    console.log(`🔁 Senha do admin ${adminEmail} foi atualizada a partir do .env. Remova RESET_ADMIN_PASSWORD do .env agora.`);
    return;
  }

  console.log(`ℹ️  Admin já existe: ${adminEmail} (senha mantida como está). Para trocar a senha, defina RESET_ADMIN_PASSWORD=true no .env e reinicie.`);
}

(async () => {
  try {
    // initDatabase() deve criar as tabelas SE NÃO EXISTIREM (CREATE TABLE IF NOT EXISTS).
    // O arquivo .db nunca é apagado aqui — isso é o que estava causando a perda
    // de todos os scripts e keys a cada reinício do servidor.
    await initDatabase();
    const db = getDb();

    ensureAdminSeed(db);

    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🪐 Rodando na porta ${PORT}`);
    });
  } catch (error) {
    console.error('❌ Erro ao iniciar o servidor:', error);
    process.exit(1);
  }
})();
