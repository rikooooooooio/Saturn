const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const argon2 = require('argon2');
const authenticateToken = require('../middleware/auth');

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  console.log('🔐 Tentativa de login:', { email, password: password ? '***' : 'VAZIO' });

  if (!email || !password) {
    console.log('❌ Campos faltando');
    return res.status(400).json({ error: 'Email e senha são obrigatórios' });
  }

  try {
    const admin = req.db.prepare('SELECT * FROM admins WHERE email = ?').get([email]);
    console.log('👤 Admin encontrado:', admin ? 'sim' : 'não');

    if (!admin) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const valid = await argon2.verify(admin.password_hash, password);
    console.log('🔑 Senha válida:', valid);

    if (!valid) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: 'admin' },
      process.env.JWT_SECRET || 'fallback-secret',
      { expiresIn: '8h' }
    );

    res.cookie('token', token, {
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 8 * 60 * 60 * 1000,
    });

    console.log('✅ Login bem-sucedido');
    res.json({ success: true });
  } catch (err) {
    console.error('💥 Erro no login:', err.message);
    res.status(500).json({ error: 'Erro interno' });
  }
});

router.post('/logout', (req, res) => {
  res.clearCookie('token', {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
  });
  res.json({ success: true });
});

router.get('/me', authenticateToken, (req, res) => {
  res.json({ email: req.admin.email });
});

module.exports = router;