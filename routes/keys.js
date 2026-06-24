const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

function generateKey() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const segment = () => Array.from({ length: 4 }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
  return `SATURN-${segment()}-${segment()}-${segment()}`;
}

router.use(auth);

router.get('/', (req, res) => {
  const keys = req.db.prepare('SELECT * FROM keys ORDER BY created_at DESC').all();
  res.json(keys);
});

router.post('/', (req, res) => {
  const { scriptId, expiresAt, hwid } = req.body;
  const key = generateKey();
  req.db.prepare('INSERT INTO keys (key, script_id, expires_at, hwid, status) VALUES (?, ?, ?, ?, ?)')
    .run([key, scriptId || null, expiresAt || null, hwid || '', 'active']);
  req.saveDb();
  const newKey = req.db.prepare('SELECT * FROM keys WHERE key = ?').get([key]);
  res.status(201).json(newKey);
});

router.put('/:id/revoke', (req, res) => {
  const key = req.db.prepare('SELECT * FROM keys WHERE id = ?').get([req.params.id]);
  if (!key) return res.status(404).json({ error: 'Key not found' });
  req.db.prepare('UPDATE keys SET status = ? WHERE id = ?').run(['revoked', req.params.id]);
  req.saveDb();
  res.json({ success: true });
});

router.put('/:id/reset-hwid', (req, res) => {
  const key = req.db.prepare('SELECT * FROM keys WHERE id = ?').get([req.params.id]);
  if (!key) return res.status(404).json({ error: 'Key not found' });
  req.db.prepare('UPDATE keys SET hwid = ? WHERE id = ?').run(['', req.params.id]);
  req.saveDb();
  res.json({ success: true });
});

router.delete('/:id', (req, res) => {
  const key = req.db.prepare('SELECT * FROM keys WHERE id = ?').get([req.params.id]);
  if (!key) return res.status(404).json({ error: 'Key not found' });
  req.db.prepare('DELETE FROM keys WHERE id = ?').run([req.params.id]);
  req.saveDb();
  res.json({ success: true });
});

module.exports = router;