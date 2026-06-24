const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

router.post('/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Preencha todos os campos' });

  const admin = req.db.prepare('SELECT * FROM admins WHERE username = ?').get([username]);
  if (!admin) return res.status(401).json({ error: 'Credenciais inválidas' });

  // Verificar se o hash existe
  if (!admin.password_hash) {
    console.error('❌ Hash vazio para usuário:', username);
    return res.status(500).json({ error: 'Erro interno. Acesse /api/reset-admin' });
  }

  const valid = bcrypt.compareSync(password, admin.password_hash);
  if (!valid) return res.status(401).json({ error: 'Credenciais inválidas' });

  const token = jwt.sign({ id: admin.id, username: admin.username }, process.env.JWT_SECRET, { expiresIn: '8h' });

  res.cookie('token', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    maxAge: 8 * 60 * 60 * 1000,
  });

  res.json({ success: true });
});

router.post('/logout', (req, res) => {
  res.clearCookie('token');
  res.json({ success: true });
});

router.get('/me', (req, res) => {
  const token = req.cookies?.token;
  if (!token) return res.status(401).json({ error: 'Não autenticado' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    res.json({ username: decoded.username });
  } catch {
    res.status(401).json({ error: 'Token inválido' });
  }
});

module.exports = router;