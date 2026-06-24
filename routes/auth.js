module.exports = function({ verifyPassword, hashPassword }) {
  const express = require('express');
  const router = express.Router();
  const jwt = require('jsonwebtoken');
  const authenticateToken = require('../middleware/auth');

  router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email e senha são obrigatórios' });
    }

    try {
      const admin = req.db.prepare('SELECT * FROM admins WHERE email = ?').get([email]);
      if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });

      // Verificar se o hash não está vazio
      if (!admin.password_hash || admin.password_hash.trim() === '') {
        console.error('❌ Hash vazio no banco para', email);
        return res.status(500).json({ error: 'Erro interno (hash inválido). Use /api/reset-admin' });
      }

      const valid = await verifyPassword(admin.password_hash, password);
      if (!valid) return res.status(401).json({ error: 'Credenciais inválidas' });

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

      console.log('✅ Login bem-sucedido:', email);
      res.json({ success: true });
    } catch (err) {
      console.error('💥 Erro no login:', err.message);
      res.status(500).json({ error: 'Erro interno' });
    }
  });

  router.post('/logout', (req, res) => {
    res.clearCookie('token', { httpOnly: true, secure: true, sameSite: 'lax' });
    res.json({ success: true });
  });

  router.get('/me', authenticateToken, (req, res) => {
    res.json({ email: req.admin.email });
  });

  return router;
};