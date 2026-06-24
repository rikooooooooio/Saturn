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
const menuToggle = document.getElementById('menuToggle');

// ==================== FUNÇÃO API COM COOKIE ====================
async function api(url, options = {}) {
  const res = await fetch(url, {
    credentials: 'include', // envia cookie HttpOnly
    ...options,
  });
  if (res.status === 401 || res.status === 403) {
    isAuthenticated = false;
    showLogin();
    throw new Error('Unauthorized');
  }
  if (!res.ok) {
    throw new Error(`Request failed: ${res.status}`);
  }
  return res;
}

// ==================== AUTENTICAÇÃO ====================
function showLogin() {
  loginSection.classList.remove('hidden');
  appSection.classList.add('hidden');
}

async function checkAuth() {
  try {
    const res = await fetch('/api/auth/me', { credentials: 'include' });
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
    const res = await fetch('/api/auth/login', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });

    if (res.ok) {
      isAuthenticated = true;
      loginError.style.display = 'none';
      loginSection.classList.add('hidden');
      appSection.classList.remove('hidden');
      document.querySelector('.sidebar-link[data-tab="dashboard"]').click();
    } else {
      let message = 'Credenciais inválidas';
      try { message = (await res.json()).error || message; } catch {}
      loginError.textContent = message;
      loginError.style.display = 'block';
    }
  } catch (err) {
    loginError.textContent = 'Erro de conexão com o servidor';
    loginError.style.display = 'block';
  }
});

logoutBtn.addEventListener('click', async () => {
  try { await api('/api/auth/logout', { method: 'POST' }); } catch {}
  isAuthenticated = false;
  showLogin();
});

// ==================== NAVEGAÇÃO DE ABAS ====================
tabLinks.forEach(link => {
  link.addEventListener('click', () => {
    tabLinks.forEach(l => l.classList.remove('active'));
    link.classList.add('active');

    const tabId = link.getAttribute('data-tab');
    tabContents.forEach(c => c.classList.add('hidden'));
    const target = document.getElementById(`tab-${tabId}`);
    if (target) target.classList.remove('hidden');

    if (tabId === 'dashboard') loadDashboard();
    else if (tabId === 'scripts') loadScripts();
    else if (tabId === 'keys') loadKeys();

    // fecha o menu mobile depois de escolher uma aba
    if (menuToggle) menuToggle.checked = false;
  });
});

// ==================== DASHBOARD ====================
async function loadDashboard() {
  const ids = ['statScripts', 'statKeys', 'statActiveKeys', 'statOnlineScripts'];
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
    ids.forEach(id => { const el = document.getElementById(id); if (el) el.textContent = '—'; });
  }
}

// ==================== SCRIPTS ====================
async function loadScripts() {
  const tbody = document.getElementById('scriptsTable');
  if (!tbody) return;
  try {
    const res = await api('/api/scripts');
    const scripts = await res.json();

    if (scripts.length === 0) {
      tbody.innerHTML = `<tr><td colspan="4" class="empty-cell">Nenhum script encontrado. Clique em "+ New Script" para criar o primeiro.</td></tr>`;
      return;
    }

    tbody.innerHTML = scripts.map(s => `
      <tr>
        <td><strong>${escapeHtml(s.name)}</strong></td>
        <td><span class="badge badge-${s.status}">${escapeHtml(s.status)}</span></td>
        <td class="text-mono text-sm" style="color:var(--text-faint);">/api/load/${escapeHtml(s.id)}</td>
        <td>
          <button class="btn btn-sm btn-secondary edit-script" data-id="${s.id}">Edit</button>
          <button class="btn btn-sm btn-danger delete-script" data-id="${s.id}">Delete</button>
        </td>
      </tr>
    `).join('');

    tbody.querySelectorAll('.edit-script').forEach(btn =>
      btn.addEventListener('click', () => openScriptModal(btn.dataset.id))
    );
    tbody.querySelectorAll('.delete-script').forEach(btn =>
      btn.addEventListener('click', () => deleteScript(btn.dataset.id))
    );
  } catch (err) {
    console.error('Erro ao carregar scripts:', err);
    tbody.innerHTML = `<tr><td colspan="4" class="error-cell">Não foi possível carregar os scripts.<a href="#" id="retryScripts">Tentar novamente</a></td></tr>`;
    document.getElementById('retryScripts')?.addEventListener('click', (e) => { e.preventDefault(); loadScripts(); });
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
      <div class="form-group"><label class="form-label">Content</label><textarea id="scriptContent" class="form-input text-mono" style="min-height:150px;">${escapeHtml(script.content)}</textarea></div>
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
      <div class="form-group"><label class="form-label">Content</label><textarea id="scriptContent" class="form-input text-mono" style="min-height:150px;" placeholder="-- Lua code"></textarea></div>
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

  try {
    await api(url, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, content, status }),
    });
    modal.classList.remove('show');
    loadScripts();
  } catch (err) {
    alert('Não foi possível salvar o script. Tente novamente.');
  }
}

async function deleteScript(id) {
  if (!confirm('Tem certeza que deseja excluir este script?')) return;
  try {
    await api(`/api/scripts/${id}`, { method: 'DELETE' });
    loadScripts();
  } catch {
    alert('Não foi possível excluir o script.');
  }
}

// ==================== KEYS ====================
async function loadKeys() {
  const tbody = document.getElementById('keysTable');
  if (!tbody) return;
  try {
    const res = await api('/api/keys');
    const keys = await res.json();

    if (keys.length === 0) {
      tbody.innerHTML = `<tr><td colspan="5" class="empty-cell">Nenhuma key encontrada. Clique em "+ Generate Key" para criar a primeira.</td></tr>`;
      return;
    }

    tbody.innerHTML = keys.map(k => `
      <tr>
        <td class="text-mono">${escapeHtml(k.key)}</td>
        <td>${k.expires_at ? new Date(k.expires_at).toLocaleDateString() : '∞'}</td>
        <td>${escapeHtml(k.hwid || 'Livre')}</td>
        <td><span class="badge badge-${k.status}">${escapeHtml(k.status)}</span></td>
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
    tbody.innerHTML = `<tr><td colspan="5" class="error-cell">Não foi possível carregar as keys.<a href="#" id="retryKeys">Tentar novamente</a></td></tr>`;
    document.getElementById('retryKeys')?.addEventListener('click', (e) => { e.preventDefault(); loadKeys(); });
  }
}

async function generateKey() {
  const scriptId = prompt('ID do script (opcional):');
  const days = prompt('Dias de expiração (vazio = sem expiração):');
  const expiresAt = days ? new Date(Date.now() + days * 86400000).toISOString() : null;

  try {
    await api('/api/keys', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ scriptId, expiresAt }),
    });
    loadKeys();
  } catch {
    alert('Não foi possível gerar a key.');
  }
}

async function revokeKey(id) {
  try { await api(`/api/keys/${id}/revoke`, { method: 'PUT' }); loadKeys(); }
  catch { alert('Não foi possível revogar a key.'); }
}

async function resetHwid(id) {
  try { await api(`/api/keys/${id}/reset-hwid`, { method: 'PUT' }); loadKeys(); }
  catch { alert('Não foi possível resetar o HWID.'); }
}

async function deleteKey(id) {
  if (!confirm('Excluir esta key?')) return;
  try { await api(`/api/keys/${id}`, { method: 'DELETE' }); loadKeys(); }
  catch { alert('Não foi possível excluir a key.'); }
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
