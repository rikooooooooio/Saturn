const express = require('express');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/', (req, res) => {
  const scripts = req.db.prepare('SELECT id, name, description, status, updated_at FROM scripts ORDER BY updated_at DESC').all();
  res.json(scripts);
});

router.get('/:id', (req, res) => {
  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  if (!script) return res.status(404).json({ error: 'Script not found' });
  res.json(script);
});

router.post('/', (req, res) => {
  const { name, description, content, status } = req.body;
  if (!name || !content) return res.status(400).json({ error: 'Name and content required' });
  const id = uuidv4();
  const now = new Date().toISOString();
  req.db.prepare('INSERT INTO scripts (id, name, description, content, status, updated_at) VALUES (?, ?, ?, ?, ?, ?)')
    .run([id, name, description || '', content, status || 'online', now]);
  req.saveDb();
  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([id]);
  res.status(201).json(script);
});

router.put('/:id', (req, res) => {
  const { name, description, content, status } = req.body;
  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  if (!script) return res.status(404).json({ error: 'Script not found' });
  const now = new Date().toISOString();
  req.db.prepare(`UPDATE scripts SET name = COALESCE(?, name), description = COALESCE(?, description), content = COALESCE(?, content), status = COALESCE(?, status), updated_at = ? WHERE id = ?`)
    .run([name || null, description || null, content || null, status || null, now, req.params.id]);
  req.saveDb();
  const updated = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  res.json(updated);
});

router.delete('/:id', (req, res) => {
  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ?').get([req.params.id]);
  if (!script) return res.status(404).json({ error: 'Script not found' });
  req.db.prepare('DELETE FROM scripts WHERE id = ?').run([req.params.id]);
  req.saveDb();
  res.json({ success: true });
});

module.exports = router;