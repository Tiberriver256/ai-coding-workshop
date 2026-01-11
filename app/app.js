const storageKey = 'slice0001.tasks';
const pairingRequestKey = 'slice0001.pairing_request';
const pairedDevicesKey = 'slice0001.devices';
const copilotSettingsKey = 'slice0001.copilot_cli';
const assistantProviderKey = 'slice0001.assistant_provider';
const defaultAttemptStatus = 'running';
const defaultAgentConfig = { provider: 'OpenAI', model: 'gpt-4.1-mini', temperature: 0.2 };
const defaultCopilotSettings = { installed: true, authenticated: true, enabled: false };
const assistantSuggestionTemplates = ['Draft a step-by-step plan with milestones and a clear definition of done.', 'List the files to inspect, the changes to make, and the tests to run.', 'Summarize the expected behavior and call out edge cases to verify.'];
const activityTaskId = 'task_agent_activity_demo';
const activityEvidenceTypes = { attempt_started: 'attempt_started', attempt_completed: 'attempt_completed', task_merged: 'task_merged' };
const activityEvidenceLabels = { attempt_started: 'Attempt started', attempt_completed: 'Attempt completed', task_merged: 'Merged into main' };
const todoList = document.getElementById('todo-list'), todoCount = document.getElementById('todo-count'), inProgressList = document.getElementById('in-progress-list'), inProgressCount = document.getElementById('in-progress-count'), inReviewList = document.getElementById('in-review-list'), inReviewCount = document.getElementById('in-review-count'), doneList = document.getElementById('done-list'), doneCount = document.getElementById('done-count'), taskModal = document.getElementById('task-modal'), openModalButton = document.getElementById('open-modal'), closeModalButton = document.getElementById('close-modal'), cancelModalButton = document.getElementById('cancel-modal'), form = document.getElementById('task-form'), titleInput = document.getElementById('task-title'), descriptionInput = document.getElementById('task-description'), assistantPanel = document.getElementById('assistant-panel'), assistantToggle = document.getElementById('assistant-toggle'), assistantProviderSelect = document.getElementById('assistant-provider'), assistantSuggestButton = document.getElementById('assistant-suggest'), assistantSuggestions = document.getElementById('assistant-suggestions'), titleError = document.getElementById('title-error'), connectModal = document.getElementById('connect-modal'), openConnectButton = document.getElementById('open-connect'), openPairingButton = document.getElementById('open-pairing'), closeConnectButton = document.getElementById('close-connect'), qrCodeContainer = document.getElementById('qr-code'), pairingLinkInput = document.getElementById('pairing-link'), copyLinkButton = document.getElementById('copy-link'), activityPanel = document.getElementById('agent-activity'), activityTaskTitle = document.getElementById('activity-task-title'), activityStartButton = document.getElementById('activity-start'), activityCompleteButton = document.getElementById('activity-complete'), activityMergeButton = document.getElementById('activity-merge'), activityLog = document.getElementById('activity-log'), searchInput = document.getElementById('task-search'), deviceList = document.getElementById('device-list'), pairingStatus = document.getElementById('pairing-status'), copilotToggle = document.getElementById('copilot-toggle'), copilotStatus = document.getElementById('copilot-status'), copilotPill = document.getElementById('copilot-pill');
let tasks = loadTasks();
let pairedDevices = loadPairedDevices();
let pairingRequest = loadPairingRequest();
let copilotSettings = loadCopilotSettings();
let assistantEnabled = false;
let assistantDrafts = [];
let assistantProvider = loadAssistantProvider();
let searchQuery = '';
const statusAliases = { todo: 'todo', 'in progress': 'in_progress', 'in-progress': 'in_progress', in_progress: 'in_progress', 'in review': 'in_review', 'in-review': 'in_review', in_review: 'in_review', done: 'done' };
const columnConfig = [
  { key: 'todo', list: todoList, count: todoCount, emptyMessage: 'No tasks yet. Create one to get started.', showCompleteAction: true },
  { key: 'in_progress', list: inProgressList, count: inProgressCount, emptyMessage: 'Nothing in progress yet.', showCompleteAction: true },
  { key: 'in_review', list: inReviewList, count: inReviewCount, emptyMessage: 'No reviews queued yet.', showCompleteAction: true },
  { key: 'done', list: doneList, count: doneCount, emptyMessage: 'No tasks completed yet.', showCompleteAction: false },
];
function loadTasks() {
  try {
    const raw = localStorage.getItem(storageKey);
    if (!raw) { return []; }
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) { return []; }
    return parsed.map((task) => normalizeTask(task)).filter((task) => task !== null);
  } catch (error) {
    console.warn('Failed to read tasks from localStorage', error);
    return [];
  }
}
function loadPairedDevices() {
  try {
    const raw = localStorage.getItem(pairedDevicesKey);
    if (!raw) { return []; }
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) { return []; }
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
    if (!raw) { return null; }
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== 'object') { return null; }
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
function normalizeCopilotSettings(settings) {
  if (!settings || typeof settings !== 'object') {
    return { ...defaultCopilotSettings };
  }
  return {
    installed: typeof settings.installed === 'boolean' ? settings.installed : defaultCopilotSettings.installed,
    authenticated: typeof settings.authenticated === 'boolean' ? settings.authenticated : defaultCopilotSettings.authenticated,
    enabled: Boolean(settings.enabled),
  };
}
function loadCopilotSettings() {
  try {
    const raw = localStorage.getItem(copilotSettingsKey);
    if (!raw) { return { ...defaultCopilotSettings }; }
    const parsed = JSON.parse(raw);
    return normalizeCopilotSettings(parsed);
  } catch (error) {
    console.warn('Failed to read Copilot CLI settings', error);
    return { ...defaultCopilotSettings };
  }
}
function saveCopilotSettings(settings) {
  localStorage.setItem(copilotSettingsKey, JSON.stringify(settings));
}
function isCopilotReady(settings) {
  return Boolean(settings?.installed) && Boolean(settings?.authenticated);
}
function normalizeAssistantProvider(value, allowCopilot) {
  if (value === 'copilot-cli' && allowCopilot) {
    return 'copilot-cli';
  }
  return 'templates';
}
function loadAssistantProvider() {
  try {
    const raw = localStorage.getItem(assistantProviderKey);
    if (!raw) { return normalizeAssistantProvider('templates', copilotSettings?.enabled); }
    return normalizeAssistantProvider(raw, copilotSettings?.enabled);
  } catch (error) {
    console.warn('Failed to read assistant provider', error);
    return normalizeAssistantProvider('templates', copilotSettings?.enabled);
  }
}
function saveAssistantProvider(value) {
  localStorage.setItem(assistantProviderKey, value);
}
function normalizeAttempt(attempt) {
  if (!attempt || typeof attempt !== 'object') { return null; }
  const startedAt = typeof attempt.startedAt === 'string' && attempt.startedAt.trim() ? attempt.startedAt : new Date().toISOString();
  const status = typeof attempt.status === 'string' && attempt.status.trim() ? attempt.status.trim().toLowerCase() : defaultAttemptStatus;
  const agent = attempt.agent && typeof attempt.agent === 'object' ? { ...defaultAgentConfig, ...attempt.agent } : { ...defaultAgentConfig };
  return { ...attempt, status, startedAt, agent };
}
function normalizeEvidenceEntry(entry) {
  if (!entry || typeof entry !== 'object') { return null; }
  const timestamp = typeof entry.timestamp === 'string' && entry.timestamp.trim() ? entry.timestamp : new Date().toISOString();
  const type = typeof entry.type === 'string' && entry.type.trim() ? entry.type.trim().toLowerCase() : 'update';
  const note = typeof entry.note === 'string' ? entry.note : '';
  const id = typeof entry.id === 'string' && entry.id.trim() ? entry.id : createEvidenceId();
  return { ...entry, id, type, note, timestamp };
}
function normalizeTask(task) {
  if (!task || typeof task !== 'object') { return null; }
  const createdAt = typeof task.createdAt === 'string' && task.createdAt.trim() ? task.createdAt : new Date().toISOString();
  const attempts = Array.isArray(task.attempts) ? task.attempts.map((attempt) => normalizeAttempt(attempt)).filter(Boolean) : [];
  const evidence = Array.isArray(task.evidence) ? task.evidence.map((entry) => normalizeEvidenceEntry(entry)).filter(Boolean) : [];
  const activeAttemptId = typeof task.activeAttemptId === 'string' && task.activeAttemptId.trim() ? task.activeAttemptId : attempts[0]?.id || null;
  return { ...task, status: normalizeStatus(task.status), createdAt, updatedAt: typeof task.updatedAt === 'string' && task.updatedAt.trim() ? task.updatedAt : createdAt, attempts, activeAttemptId, evidence };
}
function normalizeStatus(status) { if (typeof status !== 'string') { return 'todo'; } const normalized = status.trim().toLowerCase(); return statusAliases[normalized] || 'todo'; }
function saveTasks() { localStorage.setItem(storageKey, JSON.stringify(tasks)); }
function normalizeSearchQuery(value) { return typeof value === 'string' ? value.trim().toLowerCase() : ''; }
function taskMatchesSearch(task, query) {
  if (!query) {
    return true;
  }
  const haystack = [task.title, task.description].filter(Boolean).join(' ').toLowerCase();
  return haystack.includes(query);
}
function getVisibleTasks() {
  const query = searchQuery;
  if (!query) {
    return tasks;
  }
  return tasks.filter((task) => taskMatchesSearch(task, query));
}
function setSearchQuery(value) {
  searchQuery = normalizeSearchQuery(value);
  renderTasks();
}
function createTaskId() { return `task_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`; }
function createAttemptId() { return `attempt_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`; }
function createEvidenceId() { return `evidence_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`; }
function createPairingToken() { return `pair_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`; }
function getDeviceName() {
  const hostname = window.location.hostname || 'Local computer';
  return hostname === 'localhost' || hostname === '127.0.0.1' ? 'Local computer' : hostname;
}
function createPairingRequest() {
  const timestamp = new Date().toISOString();
  return {
    id: createPairingToken(),
    deviceName: getDeviceName(),
    status: 'pending',
    createdAt: timestamp,
  };
}
function createAttempt(config) { const timestamp = new Date().toISOString(); return { id: createAttemptId(), status: defaultAttemptStatus, startedAt: timestamp, updatedAt: timestamp, agent: { ...config } }; }
function formatTimestamp(isoString) {
  try {
    const date = new Date(isoString);
    return date.toLocaleString(undefined, { month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' });
  } catch (error) { return 'Just now'; }
}
function formatEvidenceLabel(type) { return !type ? 'Update logged' : activityEvidenceLabels[type] || type.replace(/_/g, ' '); }
function recordEvidence(task, type, note) { if (!task) { return null; } const timestamp = new Date().toISOString(); const entry = { id: createEvidenceId(), type, note: note || '', timestamp }; task.evidence = [...(Array.isArray(task.evidence) ? task.evidence : []), entry]; task.updatedAt = timestamp; return entry; }
function createActivityTask() { const timestamp = new Date().toISOString(); return { id: activityTaskId, title: 'Agent status demo', description: 'Track this task as the agent moves through start, review, and merge.', status: 'todo', createdAt: timestamp, updatedAt: timestamp, attempts: [], activeAttemptId: null, evidence: [], isDemo: true }; }
function seedActivityTask() { if (tasks.some((task) => task.id === activityTaskId) || tasks.some((task) => normalizeStatus(task.status) === 'todo')) { return; } tasks = [createActivityTask(), ...tasks]; saveTasks(); }
function findTaskById(taskId) { return tasks.find((task) => task.id === taskId); }
function renderTasks() {
  const grouped = {
    todo: [],
    in_progress: [],
    in_review: [],
    done: [],
  };
  const visibleTasks = getVisibleTasks();
  visibleTasks.forEach((task) => {
    const status = normalizeStatus(task.status);
    grouped[status].push(task);
  });
  columnConfig.forEach((column) => {
    renderTaskList(column.list, grouped[column.key], {
      emptyMessage: column.emptyMessage,
      showCompleteAction: column.showCompleteAction,
    });
    column.count.textContent = grouped[column.key].length.toString();
  });
  renderActivityPanel();
  renderDeviceList();
  updatePairingStatus();
}
function getActiveAttempt(task) {
  if (!task || !Array.isArray(task.attempts) || task.attempts.length === 0) {
    return null;
  }
  if (task.activeAttemptId) {
    return task.attempts.find((attempt) => attempt.id === task.activeAttemptId) || task.attempts[0];
  }
  return task.attempts[0];
}
function renderTaskList(listElement, list, options) {
  listElement.innerHTML = '';
  if (list.length === 0) { const empty = document.createElement('div'); empty.className = 'empty'; empty.textContent = options.emptyMessage; listElement.appendChild(empty); return; }
  list.forEach((task) => {
    const card = document.createElement('article');
    card.className = `task-card${task.status === 'done' ? ' done' : ''}`; card.setAttribute('role', 'listitem'); card.setAttribute('draggable', 'true'); card.dataset.taskId = task.id;
    card.addEventListener('dragstart', handleTaskDragStart); card.addEventListener('dragend', handleTaskDragEnd);
    const title = document.createElement('h4'); title.textContent = task.title;
    const description = document.createElement('p'); description.textContent = task.description || 'No description provided.';
    const meta = document.createElement('div'); meta.className = 'task-meta'; meta.textContent = task.status === 'done' ? `Completed ${formatTimestamp(task.updatedAt)}` : `Created ${formatTimestamp(task.createdAt)}`;
    card.append(title, description, meta);
    const activeAttempt = getActiveAttempt(task);
    if (activeAttempt) { const attemptMeta = document.createElement('div'); attemptMeta.className = 'task-attempt'; const statusLabel = activeAttempt.status ? activeAttempt.status.replace('_', ' ') : defaultAttemptStatus; const agentLabel = activeAttempt.agent ? [activeAttempt.agent.provider, activeAttempt.agent.model].filter(Boolean).join(' ') : ''; attemptMeta.textContent = agentLabel ? `Attempt ${statusLabel} · ${agentLabel}` : `Attempt ${statusLabel}`; card.appendChild(attemptMeta); }
    if (Array.isArray(task.evidence) && task.evidence.length > 0) { const latest = task.evidence[task.evidence.length - 1]; const evidence = document.createElement('div'); evidence.className = 'task-evidence'; const label = latest ? formatEvidenceLabel(latest.type) : 'Evidence logged'; evidence.textContent = `${label} · ${task.evidence.length} update${task.evidence.length === 1 ? '' : 's'}`; card.appendChild(evidence); }
    if (task.status === 'done') { const status = document.createElement('div'); status.className = 'task-status'; status.textContent = 'Done'; card.appendChild(status); }
    if (options.showCompleteAction && task.status !== 'done') { const actions = document.createElement('div'); actions.className = 'task-actions'; const completeButton = document.createElement('button'); completeButton.type = 'button'; completeButton.className = 'task-action'; completeButton.textContent = 'Complete'; completeButton.addEventListener('click', () => markTaskDone(task.id)); actions.appendChild(completeButton); card.appendChild(actions); }
    listElement.appendChild(card);
  });
}
function getStatusForList(listElement) { const column = columnConfig.find((entry) => entry.list === listElement); return column ? column.key : null; }
function moveTaskToStatus(taskId, targetStatus) { const task = findTaskById(taskId); if (!task) { return false; } const normalized = normalizeStatus(targetStatus); if (task.status === normalized) { return false; } task.status = normalized; task.updatedAt = new Date().toISOString(); saveTasks(); renderTasks(); return true; }
function handleTaskDragStart(event) { const card = event.currentTarget; const taskId = card?.dataset?.taskId; if (!taskId || !event.dataTransfer) { return; } event.dataTransfer.effectAllowed = 'move'; event.dataTransfer.setData('text/plain', taskId); card.classList.add('is-dragging'); }
function handleTaskDragEnd(event) { const card = event.currentTarget; if (card) { card.classList.remove('is-dragging'); } columnConfig.forEach((column) => { column.list.classList.remove('drag-target'); }); }
function handleTaskDragOver(event) { event.preventDefault(); if (event.dataTransfer) { event.dataTransfer.dropEffect = 'move'; } event.currentTarget.classList.add('drag-target'); }
function handleTaskDragLeave(event) { event.currentTarget.classList.remove('drag-target'); }
function handleTaskDrop(event) { event.preventDefault(); const list = event.currentTarget; list.classList.remove('drag-target'); const taskId = event.dataTransfer?.getData('text/plain'); const targetStatus = getStatusForList(list); if (!taskId || !targetStatus) { return; } moveTaskToStatus(taskId, targetStatus); }
function registerColumnDropTargets() { columnConfig.forEach((column) => { column.list.addEventListener('dragover', handleTaskDragOver); column.list.addEventListener('dragleave', handleTaskDragLeave); column.list.addEventListener('drop', handleTaskDrop); }); }
function renderActivityLog(task) {
  if (!activityLog) { return; }
  activityLog.innerHTML = '';
  if (!task) { const empty = document.createElement('div'); empty.className = 'empty'; empty.textContent = 'No activity task available.'; activityLog.appendChild(empty); return; }
  if (!Array.isArray(task.evidence) || task.evidence.length === 0) { const empty = document.createElement('div'); empty.className = 'empty'; empty.textContent = 'No agent activity recorded yet.'; activityLog.appendChild(empty); return; }
  [...task.evidence].slice(-5).reverse().forEach((entry) => { const item = document.createElement('div'); item.className = 'activity-item'; const label = document.createElement('span'); label.textContent = formatEvidenceLabel(entry.type); const time = document.createElement('span'); time.className = 'activity-time'; time.textContent = formatTimestamp(entry.timestamp); item.append(label, time); activityLog.appendChild(item); });
}
function updateActivityControls(task) {
  if (!activityStartButton || !activityCompleteButton || !activityMergeButton) { return; }
  if (!task) { activityStartButton.disabled = true; activityCompleteButton.disabled = true; activityMergeButton.disabled = true; return; }
  const status = normalizeStatus(task.status); activityStartButton.disabled = status !== 'todo'; activityCompleteButton.disabled = status !== 'in_progress'; activityMergeButton.disabled = status !== 'in_review';
}
function renderActivityPanel() {
  if (!activityPanel) { return; }
  const task = findTaskById(activityTaskId);
  if (activityTaskTitle) { activityTaskTitle.textContent = task ? task.title : 'No active task'; }
  renderActivityLog(task); updateActivityControls(task);
}
function renderDeviceList() {
  if (!deviceList) { return; }
  deviceList.innerHTML = '';
  if (!Array.isArray(pairedDevices) || pairedDevices.length === 0) { const empty = document.createElement('div'); empty.className = 'empty'; empty.textContent = 'No paired devices yet.'; deviceList.appendChild(empty); return; }
  pairedDevices.forEach((device) => { const card = document.createElement('article'); card.className = 'device-card'; card.setAttribute('role', 'listitem'); const title = document.createElement('h4'); title.textContent = device.name || 'Unnamed device'; const meta = document.createElement('div'); meta.className = 'device-meta'; meta.textContent = device.pairedAt ? `Paired ${formatTimestamp(device.pairedAt)}` : 'Paired recently'; const status = document.createElement('div'); status.className = 'device-status'; status.textContent = device.status ? device.status.toUpperCase() : 'PAIRED'; card.append(title, meta, status); deviceList.appendChild(card); });
}
function updatePairingStatus() {
  if (!pairingStatus) { return; }
  if (Array.isArray(pairedDevices) && pairedDevices.length > 0) { pairingStatus.textContent = `${pairedDevices.length} device${pairedDevices.length === 1 ? '' : 's'} paired.`; return; }
  if (pairingRequest && pairingRequest.status === 'pending') { pairingStatus.textContent = 'Pairing request awaiting approval.'; return; }
  if (pairingRequest && pairingRequest.status === 'rejected') { pairingStatus.textContent = 'Pairing request rejected.'; return; }
  pairingStatus.textContent = 'No devices paired yet.';
}
function openTaskModal() { taskModal.setAttribute('aria-hidden', 'false'); taskModal.setAttribute('data-state', 'open'); titleInput.focus(); }
function closeTaskModal() { taskModal.setAttribute('aria-hidden', 'true'); taskModal.setAttribute('data-state', 'closed'); form.reset(); clearValidation(); resetAssistantUI(); }
function clearValidation() { titleError.textContent = ''; titleInput.removeAttribute('aria-invalid'); }
function validateForm() { const titleValue = titleInput.value.trim(); if (!titleValue) { titleError.textContent = 'Title is required.'; titleInput.setAttribute('aria-invalid', 'true'); titleInput.focus(); return false; } clearValidation(); return true; }
function clearAssistantSuggestions() { if (!assistantSuggestions) { return; } assistantSuggestions.innerHTML = ''; assistantSuggestions.setAttribute('data-state', 'empty'); assistantSuggestions.removeAttribute('data-provider'); }
function renderAssistantSuggestions(suggestions) {
  if (!assistantSuggestions) { return; }
  assistantSuggestions.innerHTML = '';
  if (!suggestions || suggestions.length === 0) { assistantSuggestions.setAttribute('data-state', 'empty'); return; }
  assistantSuggestions.setAttribute('data-state', 'ready');
  suggestions.forEach((suggestion) => { const button = document.createElement('button'); button.type = 'button'; button.className = 'assistant-suggestion'; button.dataset.suggestion = suggestion; const label = document.createElement('span'); label.className = 'assistant-suggestion-label'; label.textContent = 'Use suggestion'; const text = document.createElement('span'); text.className = 'assistant-suggestion-text'; text.textContent = suggestion; button.append(label, text); assistantSuggestions.appendChild(button); });
}
function updateCopilotStatusUI() {
  if (!copilotStatus || !copilotPill || !copilotToggle) { return; }
  const ready = isCopilotReady(copilotSettings);
  copilotToggle.disabled = !ready;
  copilotToggle.checked = Boolean(copilotSettings?.enabled) && ready;
  if (!ready) {
    copilotStatus.textContent = 'Copilot CLI not ready';
    copilotPill.textContent = 'Unavailable';
    copilotPill.classList.add('is-muted');
    return;
  }
  if (copilotSettings?.enabled) {
    copilotStatus.textContent = 'Connected';
    copilotPill.textContent = 'Connected';
    copilotPill.classList.remove('is-muted');
    return;
  }
  copilotStatus.textContent = 'Ready to connect';
  copilotPill.textContent = 'Available';
  copilotPill.classList.add('is-muted');
}
function updateAssistantProviderAvailability() {
  if (!assistantProviderSelect) { return; }
  const copilotOption = assistantProviderSelect.querySelector('option[value="copilot-cli"]');
  if (copilotOption) {
    copilotOption.disabled = !copilotSettings?.enabled;
  }
  const normalized = normalizeAssistantProvider(assistantProviderSelect.value, copilotSettings?.enabled);
  if (normalized !== assistantProviderSelect.value) {
    assistantProviderSelect.value = normalized;
  }
  setAssistantProvider(assistantProviderSelect.value);
}
function setCopilotEnabled(enabled) {
  const ready = isCopilotReady(copilotSettings);
  const nextEnabled = ready && Boolean(enabled);
  copilotSettings = { ...copilotSettings, enabled: nextEnabled };
  saveCopilotSettings(copilotSettings);
  updateCopilotStatusUI();
  updateAssistantProviderAvailability();
}
function setAssistantProvider(value) {
  assistantProvider = normalizeAssistantProvider(value, copilotSettings?.enabled);
  if (assistantProviderSelect) { assistantProviderSelect.value = assistantProvider; }
  saveAssistantProvider(assistantProvider);
  if (assistantPanel) { assistantPanel.setAttribute('data-provider', assistantProvider); }
}
function setAssistantEnabled(enabled) { assistantEnabled = enabled; if (assistantSuggestButton) { assistantSuggestButton.disabled = !enabled; } if (assistantPanel) { assistantPanel.setAttribute('data-enabled', enabled ? 'true' : 'false'); } if (!enabled) { clearAssistantSuggestions(); assistantDrafts = []; } }
function requestAssistantSuggestions() { if (!assistantEnabled) { return; } if (assistantProvider === 'copilot-cli' && !copilotSettings?.enabled) { return; } assistantDrafts = [...assistantSuggestionTemplates]; renderAssistantSuggestions(assistantDrafts); if (assistantSuggestions) { assistantSuggestions.setAttribute('data-provider', assistantProvider); } }
function insertSuggestion(suggestion) { if (!suggestion) { return; } const current = descriptionInput.value.trim(); const spacer = current ? ' ' : ''; descriptionInput.value = `${current}${spacer}${suggestion}`; descriptionInput.focus(); }
function resetAssistantUI() { if (assistantToggle) { assistantToggle.checked = false; } setAssistantEnabled(false); }
function buildTaskPayload({ title, description, startAttempt }) {
  const timestamp = new Date().toISOString();
  const task = { id: createTaskId(), title, description, status: startAttempt ? 'in_progress' : 'todo', createdAt: timestamp, updatedAt: timestamp, attempts: [], activeAttemptId: null, evidence: [] };
  if (startAttempt) { const attempt = createAttempt(defaultAgentConfig); task.attempts = [attempt]; task.activeAttemptId = attempt.id; }
  return task;
}
openModalButton.addEventListener('click', openTaskModal);
closeModalButton.addEventListener('click', closeTaskModal);
cancelModalButton.addEventListener('click', closeTaskModal);
taskModal.addEventListener('click', (event) => { if (event.target === taskModal) { closeTaskModal(); } });
window.addEventListener('keydown', (event) => { if (event.key !== 'Escape') { return; } if (taskModal.getAttribute('aria-hidden') === 'false') { closeTaskModal(); } if (connectModal.getAttribute('aria-hidden') === 'false') { closeConnectModal(); } });
titleInput.addEventListener('input', () => { if (titleInput.value.trim()) { clearValidation(); } });
if (searchInput) { searchQuery = normalizeSearchQuery(searchInput.value); searchInput.addEventListener('input', (event) => { setSearchQuery(event.target.value); }); }
if (assistantToggle) { assistantToggle.addEventListener('change', (event) => { setAssistantEnabled(event.target.checked); }); }
if (assistantProviderSelect) { assistantProviderSelect.addEventListener('change', (event) => { setAssistantProvider(event.target.value); }); }
if (assistantSuggestButton) { assistantSuggestButton.addEventListener('click', () => { requestAssistantSuggestions(); }); }
if (assistantSuggestions) { assistantSuggestions.addEventListener('click', (event) => { const button = event.target.closest('button[data-suggestion]'); if (!button) { return; } insertSuggestion(button.dataset.suggestion); }); }
if (activityStartButton) { activityStartButton.addEventListener('click', () => startTaskAttempt(activityTaskId)); }
if (activityCompleteButton) { activityCompleteButton.addEventListener('click', () => completeTaskAttempt(activityTaskId)); }
if (activityMergeButton) { activityMergeButton.addEventListener('click', () => mergeTask(activityTaskId)); }
if (copilotToggle) { copilotToggle.addEventListener('change', (event) => { setCopilotEnabled(event.target.checked); }); }
registerColumnDropTargets();
setAssistantEnabled(Boolean(assistantToggle?.checked));
setAssistantProvider(assistantProvider);
updateCopilotStatusUI();
updateAssistantProviderAvailability();
form.addEventListener('submit', (event) => {
  event.preventDefault();
  if (!validateForm()) {
    return;
  }
  const submitter = event.submitter;
  const action = submitter?.dataset?.action || 'create';
  const startAttempt = action === 'create-start';
  const newTask = buildTaskPayload({
    title: titleInput.value.trim(),
    description: descriptionInput.value.trim(),
    startAttempt,
  });
  tasks = [newTask, ...tasks];
  saveTasks();
  renderTasks();
  closeTaskModal();
});
function startTaskAttempt(taskId) { const task = findTaskById(taskId); if (!task) { return; } const attempt = createAttempt(defaultAgentConfig); const attempts = Array.isArray(task.attempts) ? task.attempts : []; task.attempts = [attempt, ...attempts]; task.activeAttemptId = attempt.id; task.status = 'in_progress'; recordEvidence(task, activityEvidenceTypes.attempt_started, 'Attempt started'); saveTasks(); renderTasks(); }
function completeTaskAttempt(taskId) { const task = findTaskById(taskId); if (!task) { return; } const timestamp = new Date().toISOString(); const activeAttempt = getActiveAttempt(task); if (activeAttempt) { activeAttempt.status = 'completed'; activeAttempt.updatedAt = timestamp; } task.status = 'in_review'; recordEvidence(task, activityEvidenceTypes.attempt_completed, 'Attempt completed'); saveTasks(); renderTasks(); }
function mergeTask(taskId) { const task = findTaskById(taskId); if (!task) { return; } task.status = 'done'; recordEvidence(task, activityEvidenceTypes.task_merged, 'Merged to main'); saveTasks(); renderTasks(); }
function markTaskDone(taskId) { moveTaskToStatus(taskId, 'done'); }
function getPairingLink(request) {
  const url = new URL('mobile/', window.location.href);
  if (request?.id) { url.searchParams.set('pairing', request.id); }
  if (request?.deviceName) { url.searchParams.set('device', request.deviceName); }
  return url.toString();
}
function renderQrCode(url) {
  if (!qrCodeContainer) {
    return;
  }
  qrCodeContainer.innerHTML = '';
  if (typeof QRCode === 'undefined') {
    const fallback = document.createElement('p');
    fallback.textContent = 'QR generator unavailable.';
    qrCodeContainer.appendChild(fallback);
    return;
  }
  const size = 200;
  new QRCode(qrCodeContainer, {
    text: url,
    width: size,
    height: size,
    colorDark: '#1f1c1a',
    colorLight: '#ffffff',
    correctLevel: QRCode.CorrectLevel.M,
  });
}
function openConnectModal() {
  connectModal.setAttribute('aria-hidden', 'false');
  pairingRequest = createPairingRequest();
  savePairingRequest(pairingRequest);
  const pairingLink = getPairingLink(pairingRequest);
  if (pairingLinkInput) { pairingLinkInput.value = pairingLink; }
  copyLinkButton.textContent = 'Copy link';
  renderQrCode(pairingLink);
  updatePairingStatus();
}
function closeConnectModal() {
  connectModal.setAttribute('aria-hidden', 'true');
}
async function copyMobileLink() {
  if (!pairingLinkInput) { return; }
  const url = pairingLinkInput.value;
  if (!url) {
    return;
  }
  try {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      await navigator.clipboard.writeText(url);
    } else {
      pairingLinkInput.select();
      document.execCommand('copy');
    }
    copyLinkButton.textContent = 'Copied!';
  } catch (error) {
    copyLinkButton.textContent = 'Copy failed';
  }
}
openConnectButton.addEventListener('click', openConnectModal);
if (openPairingButton) { openPairingButton.addEventListener('click', openConnectModal); }
closeConnectButton.addEventListener('click', closeConnectModal);
connectModal.addEventListener('click', (event) => {
  if (event.target === connectModal) {
    closeConnectModal();
  }
});
copyLinkButton.addEventListener('click', copyMobileLink);
window.addEventListener('storage', (event) => {
  if (event.key === storageKey) {
    tasks = loadTasks();
    renderTasks();
    return;
  }
  if (event.key === pairedDevicesKey) {
    pairedDevices = loadPairedDevices();
    renderDeviceList();
    updatePairingStatus();
    return;
  }
  if (event.key === pairingRequestKey) {
    pairingRequest = loadPairingRequest();
    updatePairingStatus();
    return;
  }
  if (event.key === copilotSettingsKey) {
    copilotSettings = loadCopilotSettings();
    updateCopilotStatusUI();
    updateAssistantProviderAvailability();
    return;
  }
  if (event.key === assistantProviderKey) {
    assistantProvider = loadAssistantProvider();
    setAssistantProvider(assistantProvider);
  }
});
seedActivityTask();
renderTasks();
