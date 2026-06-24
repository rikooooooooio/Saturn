const initSqlJs = require('sql.js');

let db = null;

async function initDatabase() {
  const SQL = await initSqlJs();
  // 🧠 Banco em MEMÓRIA (nada de arquivo, sempre limpo)
  db = new SQL.Database();

  db.run(`
    CREATE TABLE IF NOT EXISTS scripts (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      content TEXT NOT NULL,
      status TEXT DEFAULT 'online',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS admins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL
    )
  `);

  return db;
}

function getDb() {
  return db;
}

// saveDb vazia (não salva em disco)
function saveDb() {}

module.exports = { initDatabase, getDb, saveDb };