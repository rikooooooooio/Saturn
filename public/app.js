// ==================== CONFIGURAÇÃO ====================
let isAuthenticated = false;

// ==================== ELEMENTOS ====================
const loginSection = document.getElementById('loginSection');
const appSection = document.getElementById('appSection');
const loginForm = document.getElementById('loginForm');
const loginError = document.getElementById('loginError');
const logoutBtn = document.getElementById('logoutBtn');
const modal = document.getElementById('modal');
const modalTitle = document.getElementById('modalTitle');
const modalContent = document.getElementById('modalContent');
const modalCancel = document.getElementById('modalCancel');
const modalSave = document.getElementById('modalSave');
const tabLinks = document.querySelectorAll('.sidebar-link');
const tabContents = document.querySelectorAll('.tab-content');

// ==================== FUNÇÃO API COM COOKIE ====================
async function api(url, options = {}) {
  try {
    const res = await fetch(url, {
      credentials: 'include', // 🔥 envia cookie HttpOnly
      ...options,
    });
    if (res.status === 401 || res.status === 403) {
      isAuthenticated = false;
      showLogin();
      throw new Error('Unauthorized');
    }
    return res;
  } catch (err) {
    console.error('API Error:', err);
    throw err;
  }
}

// ==================== AUTENTICAÇÃO ====================
function showLogin() {
  loginSection.classList.remove('hidden');
  appSection.classList.add('hidden');
}

async function checkAuth() {
  try {
    const res = await api('/api/auth/me');
    if (res.ok) {
      isAuthenticated = true;
      loginSection.classList.add('hidden');
      appSection.classList.remove('hidden');
      // Ativar primeira aba (Dashboard)
      document.querySelector('.sidebar-link[data-tab="dashboard"]').click();
    } else {
      showLogin();
    }
  } catch {
    showLogin();
  }
}

loginForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value;

  try {
    const res = await api('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });

    if (res.ok) {
      isAuthenticated = true;
      loginSection.classList.add('hidden');
      appSection.classList.remove('hidden');
      document.querySelector('.sidebar-link[data-tab="dashboard"]').click();
    } else {
      const data = await res.json();
      loginError.textContent = data.error || 'Credenciais inválidas';
      loginError.style.display = 'block';
    }
  } catch (err) {
    loginError.textContent = 'Erro de conexão';
    loginError.style.display = 'block';
  }
});

logoutBtn.addEventListener('click', async () => {
  await api('/api/auth/logout', { method: 'POST' });
  isAuthenticated = false;
  showLogin();
});

// ==================== NAVEGAÇÃO DE ABAS ====================
tabLinks.forEach(link => {
  link.addEventListener('click', () => {
    // Ativar link
    tabLinks.forEach(l => l.classList.remove('active'));
    link.classList.add('active');

    // Mostrar conteúdo da aba
    const tabId = link.getAttribute('data-tab');
    tabContents.forEach(c => c.classList.add('hidden'));
    const target = document.getElementById(`tab-${tabId}`);
    if (target) target.classList.remove('hidden');

    // Carregar dados conforme aba
    if (tabId === 'dashboard') loadDashboard();
    else if (tabId === 'scripts') loadScripts();
    else if (tabId === 'keys') loadKeys();
    // Settings não precisa de carregamento
  });
});

// ==================== DASHBOARD ====================
async function loadDashboard() {
  try {
    const scriptsRes = await api('/api/scripts');
    const scripts = await scriptsRes.json();
    const keysRes = await api('/api/keys');
    const keys = await keysRes.json();

    document.getElementById('statScripts').textContent = scripts.length;
    document.getElementById('statKeys').textContent = keys.length;
    document.getElementById('statActiveKeys').textContent = keys.filter(k => k.status === 'active').length;
    document.getElementById('statOnlineScripts').textContent = scripts.filter(s => s.status === 'online').length;
  } catch (err) {
    console.error('Erro ao carregar dashboard:', err);
  }
}

// ==================== SCRIPTS ====================
async function loadScripts() {
  try {
    const res = await api('/api/scripts');
    const scripts = await res.json();
    const tbody = document.getElementById('scriptsTable');
    if (!tbody) return;

    if (scripts.length === 0) {
      tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;padding:2rem;color:#666;">Nenhum script encontrado</td></tr>`;
      return;
    }

    tbody.innerHTML = scripts.map(s => `
      <tr>
        <td><strong>${escapeHtml(s.name)}</strong></td>
        <td><span class="badge badge-${s.status}">${s.status}</span></td>
        <td style="font-family:monospace;font-size:0.8rem;color:#888;">/api/load/${s.id}</td>
        <td>
          <button class="btn btn-sm btn-secondary edit-script" data-id="${s.id}">Edit</button>
          <button class="btn btn-sm btn-danger delete-script" data-id="${s.id}">Delete</button>
        </td>
      </tr>
    `).join('');

    // Event listeners
    tbody.querySelectorAll('.edit-script').forEach(btn =>
      btn.addEventListener('click', () => openScriptModal(btn.dataset.id))
    );
    tbody.querySelectorAll('.delete-script').forEach(btn =>
      btn.addEventListener('click', () => deleteScript(btn.dataset.id))
    );
  } catch (err) {
    console.error('Erro ao carregar scripts:', err);
  }
}

async function openScriptModal(id = null) {
  modal.classList.add('show');
  if (id) {
    const res = await api(`/api/scripts/${id}`);
    const script = await res.json();
    modalTitle.textContent = 'Edit Script';
    modalContent.innerHTML = `
      <div class="form-group"><label class="form-label">Name</label><input id="scriptName" class="form-input" value="${escapeHtml(script.name)}"></div>
      <div class="form-group"><label class="form-label">Content</label><textarea id="scriptContent" class="form-input" style="min-height:150px;font-family:monospace;">${escapeHtml(script.content)}</textarea></div>
      <div class="form-group"><label class="form-label">Status</label><select id="scriptStatus" class="form-input">
        <option value="online" ${script.status==='online'?'selected':''}>Online</option>
        <option value="offline" ${script.status==='offline'?'selected':''}>Offline</option>
        <option value="maintenance" ${script.status==='maintenance'?'selected':''}>Maintenance</option>
        <option value="development" ${script.status==='development'?'selected':''}>Development</option>
      </select></div>
      <input type="hidden" id="scriptId" value="${script.id}">
    `;
    modalSave.onclick = () => saveScript(script.id);
  } else {
    modalTitle.textContent = 'New Script';
    modalContent.innerHTML = `
      <div class="form-group"><label class="form-label">Name</label><input id="scriptName" class="form-input" placeholder="My Script"></div>
      <div class="form-group"><label class="form-label">Content</label><textarea id="scriptContent" class="form-input" style="min-height:150px;font-family:monospace;" placeholder="-- Lua code"></textarea></div>
      <div class="form-group"><label class="form-label">Status</label><select id="scriptStatus" class="form-input">
        <option value="online">Online</option>
        <option value="offline">Offline</option>
        <option value="maintenance">Maintenance</option>
        <option value="development">Development</option>
      </select></div>
    `;
    modalSave.onclick = () => saveScript(null);
  }
}

async function saveScript(id) {
  const name = document.getElementById('scriptName').value.trim();
  const content = document.getElementById('scriptContent').value;
  const status = document.getElementById('scriptStatus').value;

  if (!name || !content) return alert('Preencha todos os campos');

  const url = id ? `/api/scripts/${id}` : '/api/scripts';
  const method = id ? 'PUT' : 'POST';

  await api(url, {
    method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, content, status }),
  });

  modal.classList.remove('show');
  loadScripts();
}

async function deleteScript(id) {
  if (!confirm('Tem certeza que deseja excluir este script?')) return;
  await api(`/api/scripts/${id}`, { method: 'DELETE' });
  loadScripts();
}

// ==================== KEYS ====================
async function loadKeys() {
  try {
    const res = await api('/api/keys');
    const keys = await res.json();
    const tbody = document.getElementById('keysTable');
    if (!tbody) return;

    if (keys.length === 0) {
      tbody.innerHTML = `<tr><td colspan="5" style="text-align:center;padding:2rem;color:#666;">Nenhuma key encontrada</td></tr>`;
      return;
    }

    tbody.innerHTML = keys.map(k => `
      <tr>
        <td style="font-family:monospace;">${k.key}</td>
        <td>${k.expires_at ? new Date(k.expires_at).toLocaleDateString() : '∞'}</td>
        <td>${k.hwid || 'Livre'}</td>
        <td><span class="badge badge-${k.status}">${k.status}</span></td>
        <td>
          <button class="btn btn-sm btn-secondary revoke-key" data-id="${k.id}">Revogar</button>
          <button class="btn btn-sm btn-secondary reset-hwid" data-id="${k.id}">Reset HWID</button>
          <button class="btn btn-sm btn-danger delete-key" data-id="${k.id}">Excluir</button>
        </td>
      </tr>
    `).join('');

    tbody.querySelectorAll('.revoke-key').forEach(b => b.addEventListener('click', () => revokeKey(b.dataset.id)));
    tbody.querySelectorAll('.reset-hwid').forEach(b => b.addEventListener('click', () => resetHwid(b.dataset.id)));
    tbody.querySelectorAll('.delete-key').forEach(b => b.addEventListener('click', () => deleteKey(b.dataset.id)));
  } catch (err) {
    console.error('Erro ao carregar keys:', err);
  }
}

async function generateKey() {
  const scriptId = prompt('ID do script (opcional):');
  const days = prompt('Dias de expiração (vazio = sem expiração):');
  const expiresAt = days ? new Date(Date.now() + days * 86400000).toISOString() : null;

  await api('/api/keys', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ scriptId, expiresAt }),
  });
  loadKeys();
}

async function revokeKey(id) {
  await api(`/api/keys/${id}/revoke`, { method: 'PUT' });
  loadKeys();
}

async function resetHwid(id) {
  await api(`/api/keys/${id}/reset-hwid`, { method: 'PUT' });
  loadKeys();
}

async function deleteKey(id) {
  if (!confirm('Excluir esta key?')) return;
  await api(`/api/keys/${id}`, { method: 'DELETE' });
  loadKeys();
}

// ==================== MODAL ====================
modalCancel.addEventListener('click', () => modal.classList.remove('show'));
modal.addEventListener('click', (e) => {
  if (e.target === modal) modal.classList.remove('show');
});
document.getElementById('newScriptBtn')?.addEventListener('click', () => openScriptModal());
document.getElementById('newKeyBtn')?.addEventListener('click', generateKey);

// ==================== HELPERS ====================
function escapeHtml(text) {
  return String(text).replace(/[&<>"]/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[m]));
}

// ==================== INICIALIZAÇÃO ====================
checkAuth();