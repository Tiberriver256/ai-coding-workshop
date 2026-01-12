const storageKey = 'slice0001.tasks';
const sessionsKey = 'slice0001.sessions';
const activeSessionKey = 'slice0001.mobile_active_session';
const pairingRequestKey = 'slice0001.pairing_request';
const pairedDevicesKey = 'slice0001.devices';
const invalidPairingMessage = 'Invalid connection link. Check the QR code and try again.';

const todoList = document.getElementById('todo-list');
const doneList = document.getElementById('done-list');
const todoCount = document.getElementById('todo-count');
const doneCount = document.getElementById('done-count');
const lastUpdated = document.getElementById('last-updated');
const syncPill = document.getElementById('sync-pill');
const pairingStatus = document.getElementById('pairing-status');
const pairingDetails = document.getElementById('pairing-details');
const manualLinkInput = document.getElementById('manual-link-input');
const manualLinkButton = document.getElementById('submit-link');
const manualLinkStatus = document.getElementById('manual-link-status');
const approvePairingButton = document.getElementById('approve-pairing');
const rejectPairingButton = document.getElementById('reject-pairing');
const deviceList = document.getElementById('device-list');
const deviceCount = document.getElementById('device-count');
const sessionList = document.getElementById('session-list');
const sessionCount = document.getElementById('session-count');
const projectPathInput = document.getElementById('project-path-input');
const projectPathStatus = document.getElementById('project-path-status');
const startMobileSessionButton = document.getElementById('start-mobile-session');
const activeSessionPanel = document.getElementById('active-session');
const activeSessionName = document.getElementById('active-session-name');
const activeSessionMeta = document.getElementById('active-session-meta');
const activeSessionStatus = document.getElementById('active-session-status');

let tasks = loadTasks();
let sessions = loadSessions();
let pairedDevices = loadPairedDevices();
let pairingRequest = loadPairingRequest();
let activeSessionId = loadActiveSessionId();
let pairingError = null;

function loadTasks() { try { const raw = localStorage.getItem(storageKey); if (!raw) { return []; } const parsed = JSON.parse(raw); if (!Array.isArray(parsed)) { return []; } return parsed.map((task) => normalizeTask(task)).filter((task) => task !== null); } catch (error) { console.warn('Failed to read tasks from localStorage', error); return []; } }
function loadSessions() { try { const raw = localStorage.getItem(sessionsKey); if (!raw) { return []; } const parsed = JSON.parse(raw); if (!Array.isArray(parsed)) { return []; } return parsed.map((session) => normalizeSession(session)).filter((session) => session !== null); } catch (error) { console.warn('Failed to read sessions from localStorage', error); return []; } }
function saveSessions() { localStorage.setItem(sessionsKey, JSON.stringify(sessions)); }
function loadActiveSessionId() { try { const value = localStorage.getItem(activeSessionKey); return value && value.trim() ? value : null; } catch (error) { console.warn('Failed to read active session', error); return null; } }
function saveActiveSessionId(value) { if (!value) { localStorage.removeItem(activeSessionKey); return; } localStorage.setItem(activeSessionKey, value); }
function createSessionId() { return `session_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`; }
function loadPairedDevices() {
  try {
    const raw = localStorage.getItem(pairedDevicesKey);
    if (!raw) {
      return [];
    }
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) {
      return [];
    }
    return parsed.filter((device) => device && typeof device === 'object');
  } catch (error) {
    console.warn('Failed to read paired devices', error);
    return [];
  }
}
function savePairedDevices(devices) {
  localStorage.setItem(pairedDevicesKey, JSON.stringify(devices));
}
function loadPairingRequest() {
  try {
    const raw = localStorage.getItem(pairingRequestKey);
    if (!raw) {
      return null;
    }
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== 'object') {
      return null;
    }
    return parsed;
  } catch (error) {
    console.warn('Failed to read pairing request', error);
    return null;
  }
}
function savePairingRequest(request) {
  if (!request) {
    localStorage.removeItem(pairingRequestKey);
    return;
  }
  localStorage.setItem(pairingRequestKey, JSON.stringify(request));
}

function normalizeSession(session) { if (!session || typeof session !== 'object') { return null; } const createdAt = typeof session.createdAt === 'string' && session.createdAt.trim() ? session.createdAt : new Date().toISOString(); const statusValue = typeof session.status === 'string' && session.status.trim() ? session.status.trim().toLowerCase() : 'online'; const status = statusValue === 'offline' ? 'offline' : 'online'; const projectPath = typeof session.projectPath === 'string' && session.projectPath.trim() ? session.projectPath.trim() : ''; const fallbackName = projectPath ? projectPath.split(/[\\/]/).filter(Boolean).slice(-1)[0] : 'Coding session'; const name = typeof session.name === 'string' && session.name.trim() ? session.name.trim() : fallbackName; const updatedAt = typeof session.updatedAt === 'string' && session.updatedAt.trim() ? session.updatedAt : createdAt; const id = typeof session.id === 'string' && session.id.trim() ? session.id.trim() : createSessionId(); return { ...session, id, name, status, projectPath, createdAt, updatedAt }; }
function createSessionFromPath(projectPath) { const trimmed = projectPath.trim(); const timestamp = new Date().toISOString(); const projectName = trimmed ? trimmed.split(/[\\/]/).filter(Boolean).slice(-1)[0] : 'Coding session'; const name = trimmed ? `${projectName} session` : 'Coding session'; return normalizeSession({ id: createSessionId(), name, status: 'online', createdAt: timestamp, updatedAt: timestamp, projectPath: trimmed }); }
function getActiveSession() { if (!Array.isArray(sessions) || sessions.length === 0) { return null; } if (activeSessionId) { const found = sessions.find((session) => session.id === activeSessionId); if (found) { return found; } } return sessions[0]; }
function setActiveSession(session) { if (!session) { activeSessionId = null; saveActiveSessionId(null); return; } activeSessionId = session.id; saveActiveSessionId(activeSessionId); }
function renderActiveSession() { if (!activeSessionPanel || !activeSessionName || !activeSessionMeta || !activeSessionStatus) { return; } const session = getActiveSession(); if (!session) { activeSessionName.textContent = 'No session open.'; activeSessionMeta.textContent = 'Start a session to open it here.'; activeSessionStatus.textContent = 'Offline'; activeSessionStatus.dataset.status = 'offline'; return; } activeSessionName.textContent = session.name || 'Active session'; activeSessionMeta.textContent = session.projectPath ? `Path: ${session.projectPath}` : 'Ready to connect.'; activeSessionStatus.textContent = session.status === 'online' ? 'Online' : 'Offline'; activeSessionStatus.dataset.status = session.status === 'online' ? 'online' : 'offline'; }

function normalizeTask(task) { if (!task || typeof task !== 'object') { return null; } const createdAt = typeof task.createdAt === 'string' && task.createdAt.trim() ? task.createdAt : new Date().toISOString(); return { ...task, status: typeof task.status === 'string' && task.status.trim() ? task.status : 'todo', createdAt, updatedAt: typeof task.updatedAt === 'string' && task.updatedAt.trim() ? task.updatedAt : createdAt }; }

function formatTimestamp(isoString) { try { const date = new Date(isoString); return date.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' }); } catch (error) { return 'Just now'; } }
function setManualLinkStatus(message, tone) { if (!manualLinkStatus) { return; } manualLinkStatus.textContent = message || ''; if (!tone) { manualLinkStatus.removeAttribute('data-tone'); return; } manualLinkStatus.dataset.tone = tone; }
function setProjectPathStatus(message, tone) { if (!projectPathStatus) { return; } projectPathStatus.textContent = message || ''; if (!tone) { projectPathStatus.removeAttribute('data-tone'); return; } projectPathStatus.dataset.tone = tone; }
function setPairingDetailsTone(tone) {
  if (!pairingDetails) {
    return;
  }
  if (!tone) {
    pairingDetails.removeAttribute('data-tone');
    return;
  }
  pairingDetails.dataset.tone = tone;
}
function setPairingError(message) {
  pairingError = message || null;
}
function clearPairingError() {
  pairingError = null;
}
function isValidPairingToken(token) {
  if (!token || typeof token !== 'string') {
    return false;
  }
  return /^pair_[a-z0-9]+_[a-z0-9]{6}$/.test(token);
}
function isForcePairing(value) {
  if (value === null || value === undefined) {
    return false;
  }
  const normalized = String(value).trim().toLowerCase();
  return normalized === '' || normalized === 'true' || normalized === '1' || normalized === 'yes';
}
function getPairingParams() {
  const params = new URLSearchParams(window.location.search);
  if (!params.has('pairing')) {
    return null;
  }
  const token = params.get('pairing');
  if (!isValidPairingToken(token)) {
    return { error: invalidPairingMessage };
  }
  const forceParam = params.get('force');
  return {
    id: token,
    deviceName: params.get('device') || 'New computer',
    force: isForcePairing(forceParam),
  };
}
function parsePairingLink(link) {
  if (!link) {
    return null;
  }
  try {
    const url = new URL(link, window.location.href);
    const token = url.searchParams.get('pairing');
    if (!token || !isValidPairingToken(token)) {
      return null;
    }
    const forceParam = url.searchParams.get('force');
    return {
      id: token,
      deviceName: url.searchParams.get('device') || 'New computer',
      force: isForcePairing(forceParam),
    };
  } catch (error) {
    return null;
  }
}
function applyPairingParams(params) {
  if (!params) {
    return false;
  }
  clearPairingError();
  if (pairingRequest && pairingRequest.id === params.id) {
    return false;
  }
  pairingRequest = {
    id: params.id,
    deviceName: params.deviceName,
    status: 'pending',
    force: Boolean(params.force),
    createdAt: new Date().toISOString(),
  };
  savePairingRequest(pairingRequest);
  return true;
}
function ingestPairingLink() {
  const params = getPairingParams();
  if (!params) {
    return;
  }
  if (params.error) {
    if (!pairingRequest) {
      setPairingError(params.error);
    }
    return;
  }
  applyPairingParams(params);
}
function renderPairingRequest() {
  if (!pairingDetails || !pairingStatus || !approvePairingButton || !rejectPairingButton) {
    return;
  }
  if (pairingError && !pairingRequest) {
    pairingStatus.textContent = 'Invalid';
    pairingDetails.textContent = pairingError;
    setPairingDetailsTone('error');
    approvePairingButton.disabled = true;
    rejectPairingButton.disabled = true;
    return;
  }
  setPairingDetailsTone();
  if (!pairingRequest) {
    pairingStatus.textContent = 'None';
    pairingDetails.textContent = 'No pending pairing requests.';
    approvePairingButton.disabled = true;
    rejectPairingButton.disabled = true;
    return;
  }
  const deviceName = pairingRequest.deviceName || 'New computer';
  if (pairingRequest.status === 'pending') {
    pairingStatus.textContent = pairingRequest.force ? 'Re-auth' : 'Pending';
    pairingDetails.textContent = pairingRequest.force
      ? `${deviceName} is requesting re-authentication.`
      : `${deviceName} is requesting access.`;
    approvePairingButton.disabled = false;
    rejectPairingButton.disabled = false;
    return;
  }
  if (pairingRequest.status === 'rejected') {
    pairingStatus.textContent = 'Rejected';
    pairingDetails.textContent = `${deviceName} pairing request was rejected.`;
    approvePairingButton.disabled = true;
    rejectPairingButton.disabled = true;
    return;
  }
  if (pairingRequest.status === 'approved') {
    pairingStatus.textContent = pairingRequest.force ? 'Re-paired' : 'Approved';
    pairingDetails.textContent = pairingRequest.force
      ? `${deviceName} was re-paired successfully.`
      : `${deviceName} pairing approved.`;
    approvePairingButton.disabled = true;
    rejectPairingButton.disabled = true;
    return;
  }
  pairingStatus.textContent = 'None';
  pairingDetails.textContent = 'No pending pairing requests.';
  approvePairingButton.disabled = true;
  rejectPairingButton.disabled = true;
}
function approvePairingRequest() {
  if (!pairingRequest || pairingRequest.status !== 'pending') {
    return;
  }
  const timestamp = new Date().toISOString();
  const status = pairingRequest.force ? 're-paired' : 'paired';
  const existingDevice = pairedDevices.find(
    (device) => device && device.name === pairingRequest.deviceName
  );
  const device = {
    id: existingDevice ? existingDevice.id : `device_${pairingRequest.id}`,
    name: pairingRequest.deviceName,
    status,
    pairedAt: timestamp,
  };
  pairedDevices = [device, ...pairedDevices.filter((item) => item.id !== device.id)];
  savePairedDevices(pairedDevices);
  pairingRequest = { ...pairingRequest, status: 'approved', approvedAt: timestamp };
  savePairingRequest(pairingRequest);
  renderPairingRequest();
  renderDeviceList();
  updateStatusPill();
}

function rejectPairingRequest() {
  if (!pairingRequest || pairingRequest.status !== 'pending') {
    return;
  }
  const timestamp = new Date().toISOString();
  const deviceName = pairingRequest.deviceName || 'New computer';
  pairingRequest = { ...pairingRequest, status: 'rejected', rejectedAt: timestamp };
  savePairingRequest(pairingRequest);
  setManualLinkStatus(`Rejected pairing for ${deviceName}.`, 'error');
  renderPairingRequest();
  updateTimestamp();
}
function submitManualLink() {
  if (!manualLinkInput) {
    return;
  }
  const value = manualLinkInput.value.trim();
  if (!value) {
    setManualLinkStatus('Paste a connection link to continue.', 'error');
    return;
  }
  const params = parsePairingLink(value);
  if (!params) {
    setManualLinkStatus('That link is invalid. Check and try again.', 'error');
    return;
  }
  const applied = applyPairingParams(params);
  if (!applied) {
    setManualLinkStatus('That link is already pending.', 'success');
    return;
  }
  setManualLinkStatus(`Link received for ${params.deviceName}.`, 'success');
  renderPairingRequest();
  updateTimestamp();
}
function renderDeviceList() {
  if (!deviceList || !deviceCount) {
    return;
  }
  deviceList.innerHTML = '';
  if (!Array.isArray(pairedDevices) || pairedDevices.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'empty';
    empty.textContent = 'No devices paired yet.';
    deviceList.appendChild(empty);
    deviceCount.textContent = '0';
    return;
  }
  pairedDevices.forEach((device) => {
    const card = document.createElement('article');
    card.className = 'device-card';
    card.setAttribute('role', 'listitem');
    const title = document.createElement('h3');
    title.textContent = device.name || 'Unnamed device';
    const meta = document.createElement('div');
    meta.className = 'device-meta';
    meta.textContent = device.pairedAt ? `Paired ${formatTimestamp(device.pairedAt)}` : 'Paired recently';
    const status = document.createElement('div');
    status.className = 'device-status';
    status.textContent = device.status ? device.status.toUpperCase() : 'PAIRED';
    card.append(title, meta, status);
    deviceList.appendChild(card);
  });
  deviceCount.textContent = pairedDevices.length.toString();
}

function startMobileSession() {
  if (!projectPathInput) {
    return;
  }
  const value = projectPathInput.value.trim();
  if (!value) {
    setProjectPathStatus('Enter a project path to continue.', 'error');
    return;
  }
  const session = createSessionFromPath(value);
  sessions = [session, ...sessions];
  saveSessions();
  setActiveSession(session);
  renderSessionList();
  renderActiveSession();
  setProjectPathStatus(`Session started for ${session.projectPath}.`, 'success');
  projectPathInput.value = '';
  updateTimestamp();
}

function renderSessionList() { if (!sessionList || !sessionCount) { return; } sessionList.innerHTML = ''; if (!Array.isArray(sessions) || sessions.length === 0) { const empty = document.createElement('div'); empty.className = 'empty'; empty.textContent = 'No active sessions yet.'; sessionList.appendChild(empty); sessionCount.textContent = '0'; return; } sessions.forEach((session) => { const card = document.createElement('article'); card.className = 'session-card'; card.setAttribute('role', 'listitem'); const title = document.createElement('h3'); title.textContent = session.name || 'Remote session'; const meta = document.createElement('div'); meta.className = 'session-meta'; const time = document.createElement('span'); time.textContent = session.updatedAt ? `Started ${formatTimestamp(session.updatedAt)}` : 'Online now'; const status = document.createElement('span'); status.className = 'session-status'; status.dataset.status = session.status || 'offline'; status.textContent = session.status === 'online' ? 'Online' : 'Offline'; meta.append(time, status); card.append(title, meta); sessionList.appendChild(card); }); sessionCount.textContent = sessions.length.toString(); }

function renderTaskList(listElement, list, emptyMessage) {
  listElement.innerHTML = '';

  if (list.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'empty';
    empty.textContent = emptyMessage;
    listElement.appendChild(empty);
    return;
  }

  list.forEach((task) => {
    const card = document.createElement('article');
    card.className = `task-card${task.status === 'done' ? ' done' : ''}`;
    card.setAttribute('role', 'listitem');

    const title = document.createElement('h3');
    title.textContent = task.title;

    const description = document.createElement('p');
    description.textContent = task.description || 'No description provided.';

    const meta = document.createElement('div');
    meta.className = 'task-meta';
    meta.textContent =
      task.status === 'done'
        ? `Completed ${formatTimestamp(task.updatedAt)}`
        : `Created ${formatTimestamp(task.createdAt)}`;

    card.appendChild(title);
    card.appendChild(description);
    card.appendChild(meta);
    listElement.appendChild(card);
  });
}

function updateStatusPill() {
  if (!syncPill) {
    return;
  }
  syncPill.textContent = pairedDevices.length > 0 ? 'Paired' : 'Local only';
}

function updateTimestamp() {
  if (!lastUpdated) {
    return;
  }
  lastUpdated.textContent = `Updated ${formatTimestamp(new Date().toISOString())}`;
}

function render() {
  const todoTasks = tasks.filter((task) => task.status !== 'done');
  const doneTasks = tasks.filter((task) => task.status === 'done');

  renderTaskList(todoList, todoTasks, 'No tasks yet.');
  renderTaskList(doneList, doneTasks, 'No completed tasks yet.');

  todoCount.textContent = todoTasks.length.toString();
  doneCount.textContent = doneTasks.length.toString();
  renderPairingRequest();
  renderDeviceList();
  renderSessionList();
  renderActiveSession();
  updateTimestamp();
  updateStatusPill();
}

window.addEventListener('storage', (event) => {
  if (event.key === storageKey) {
    tasks = loadTasks();
    render();
  }
  if (event.key === sessionsKey) {
    sessions = loadSessions();
    render();
  }
  if (event.key === pairedDevicesKey) {
    pairedDevices = loadPairedDevices();
    render();
  }
  if (event.key === pairingRequestKey) {
    pairingRequest = loadPairingRequest();
    render();
  }
  if (event.key === activeSessionKey) {
    activeSessionId = loadActiveSessionId();
    renderActiveSession();
  }
});

if (approvePairingButton) {
  approvePairingButton.addEventListener('click', approvePairingRequest);
}
if (rejectPairingButton) {
  rejectPairingButton.addEventListener('click', rejectPairingRequest);
}
if (manualLinkButton) {
  manualLinkButton.addEventListener('click', submitManualLink);
}
if (startMobileSessionButton) {
  startMobileSessionButton.addEventListener('click', startMobileSession);
}

ingestPairingLink();
render();
