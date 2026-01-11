const storageKey = 'slice0001.tasks';
const pairingRequestKey = 'slice0001.pairing_request';
const pairedDevicesKey = 'slice0001.devices';

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

let tasks = loadTasks();
let pairedDevices = loadPairedDevices();
let pairingRequest = loadPairingRequest();

function loadTasks() {
  try {
    const raw = localStorage.getItem(storageKey);
    if (!raw) {
      return [];
    }
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) {
      return [];
    }
    return parsed
      .map((task) => normalizeTask(task))
      .filter((task) => task !== null);
  } catch (error) {
    console.warn('Failed to read tasks from localStorage', error);
    return [];
  }
}
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

function normalizeTask(task) {
  if (!task || typeof task !== 'object') {
    return null;
  }

  const createdAt =
    typeof task.createdAt === 'string' && task.createdAt.trim()
      ? task.createdAt
      : new Date().toISOString();

  return {
    ...task,
    status: typeof task.status === 'string' && task.status.trim() ? task.status : 'todo',
    createdAt,
    updatedAt:
      typeof task.updatedAt === 'string' && task.updatedAt.trim() ? task.updatedAt : createdAt,
  };
}

function formatTimestamp(isoString) {
  try {
    const date = new Date(isoString);
    return date.toLocaleTimeString(undefined, {
      hour: 'numeric',
      minute: '2-digit',
    });
  } catch (error) {
    return 'Just now';
  }
}
function setManualLinkStatus(message, tone) {
  if (!manualLinkStatus) {
    return;
  }
  manualLinkStatus.textContent = message || '';
  if (!tone) {
    manualLinkStatus.removeAttribute('data-tone');
    return;
  }
  manualLinkStatus.dataset.tone = tone;
}
function getPairingParams() {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('pairing');
  if (!token) {
    return null;
  }
  return {
    id: token,
    deviceName: params.get('device') || 'New computer',
  };
}
function parsePairingLink(link) {
  if (!link) {
    return null;
  }
  try {
    const url = new URL(link, window.location.href);
    const token = url.searchParams.get('pairing');
    if (!token) {
      return null;
    }
    return {
      id: token,
      deviceName: url.searchParams.get('device') || 'New computer',
    };
  } catch (error) {
    return null;
  }
}
function applyPairingParams(params) {
  if (!params) {
    return false;
  }
  if (pairingRequest && pairingRequest.id === params.id) {
    return false;
  }
  pairingRequest = {
    id: params.id,
    deviceName: params.deviceName,
    status: 'pending',
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
  applyPairingParams(params);
}
function renderPairingRequest() {
  if (!pairingDetails || !pairingStatus || !approvePairingButton || !rejectPairingButton) {
    return;
  }
  if (!pairingRequest) {
    pairingStatus.textContent = 'None';
    pairingDetails.textContent = 'No pending pairing requests.';
    approvePairingButton.disabled = true;
    rejectPairingButton.disabled = true;
    return;
  }
  const deviceName = pairingRequest.deviceName || 'New computer';
  if (pairingRequest.status === 'pending') {
    pairingStatus.textContent = 'Pending';
    pairingDetails.textContent = `${deviceName} is requesting access.`;
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
  const device = {
    id: `device_${pairingRequest.id}`,
    name: pairingRequest.deviceName,
    status: 'paired',
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
  updateTimestamp();
  updateStatusPill();
}

window.addEventListener('storage', (event) => {
  if (event.key === storageKey) {
    tasks = loadTasks();
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

ingestPairingLink();
render();
