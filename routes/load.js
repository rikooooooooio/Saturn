const express = require('express');
const router = express.Router();
const path = require('path');

router.get('/:id', (req, res) => {
  const loaderSecret = process.env.LOADER_SECRET || 'saturn_loader_secret_2024';
  const clientSecret = req.headers['x-saturn-key'];

  // Bloquear acesso se não tiver o header correto
  if (clientSecret !== loaderSecret) {
    return res.status(403).sendFile(path.join(__dirname, '..', 'public', 'blocked.html'));
  }

  const script = req.db.prepare('SELECT * FROM scripts WHERE id = ? AND status = ?').get([req.params.id, 'online']);
  if (!script) {
    return res.status(404).sendFile(path.join(__dirname, '..', 'public', 'blocked.html'));
  }

  res.type('text/plain').send(script.content);
});

module.exports = router;