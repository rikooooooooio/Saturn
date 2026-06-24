const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const argon2 = require('argon2');

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const admin = req.db.prepare('SELECT * FROM admins WHERE email = ?').get([email]);
  if (!admin) return res.status(401).json({ error: 'Invalid credentials' });

  try {
    const valid = await argon2.verify(admin.password_hash, password);
    if (!valid) return res.status(401).json({ error: 'Invalid credentials' });

    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: 'admin' },
      process.env.JWT_SECRET,
      { expiresIn: '8h' }
    );
    res.cookie('token', token, {
      httpOnly: true,
      secure: false,
      sameSite: 'strict',
      maxAge: 8 * 60 * 60 * 1000
    });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Internal error' });
  }
});

router.post('/logout', (req, res) => {
  res.clearCookie('token');
  res.json({ success: true });
});

router.get('/me', require('../middleware/auth'), (req, res) => {
  res.json({ email: req.admin.email });
});

module.exports = router;
