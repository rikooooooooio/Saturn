const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const authenticateToken = require('../middleware/auth');

// secure:true exige HTTPS. Em dev local (http://localhost) isso faz o
// navegador descartar o cookie silenciosamente, e o login "não funciona"
// mesmo retornando sucesso. Em produção (atrás de HTTPS) queremos secure:true.
const isProduction = process.env.NODE_ENV === 'production';

const cookieOptions = {
  httpOnly: true,
  secure: isProduction,
  sameSite: 'lax',
  path: '/',
  maxAge: 8 * 60 * 60 * 1000,
};

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email e senha obrigatórios' });
  }

  const admin = req.db.prepare('SELECT * FROM admins WHERE email = ?').get([email]);
  if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });
  if (!admin.password_hash) {
    return res.status(500).json({ error: 'Nenhum admin configurado. Defina ADMIN_EMAIL e ADMIN_PASSWORD no .env e reinicie o servidor.' });
  }

  const valid = bcrypt.compareSync(password, admin.password_hash);
  if (!valid) return res.status(401).json({ error: 'Credenciais inválidas' });

  const jwtSecret = process.env.JWT_SECRET;
  if (!jwtSecret) {
    console.warn('⚠️  JWT_SECRET não definido no .env — usando um segredo fraco e temporário. Defina JWT_SECRET em produção.');
  }

  const token = jwt.sign(
    { id: admin.id, email: admin.email, role: 'admin' },
    jwtSecret || 'fallback-secret',
    { expiresIn: '8h' }
  );

  res.cookie('token', token, cookieOptions);

  console.log('✅ Login:', email);
  res.json({ success: true });
});

router.post('/logout', (req, res) => {
  // precisa ser EXATAMENTE as mesmas opções usadas em res.cookie, ou o
  // navegador não limpa o cookie certo
  res.clearCookie('token', { httpOnly: true, secure: isProduction, sameSite: 'lax', path: '/' });
  res.json({ success: true });
});

router.get('/me', authenticateToken, (req, res) => {
  res.json({ email: req.admin.email });
});

module.exports = router;
