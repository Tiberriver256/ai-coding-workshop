const taskViewSection = document.getElementById('task-view');
const openTaskViewButton = document.getElementById('open-task-view');
const pauseTaskStreamButton = document.getElementById('pause-task-stream');
const taskLogStream = document.getElementById('task-log-stream');
const taskViewStatus = document.getElementById('task-view-status');
const taskViewAttemptLabel = document.getElementById('task-view-attempt');
const openProcessesButton = document.getElementById('open-processes');
const processPanel = document.getElementById('process-panel');
const processPanelStatus = document.getElementById('process-panel-status');
const processList = document.getElementById('process-list');
const processLogViewer = document.getElementById('process-log-viewer');
const processLogEntries = document.getElementById('process-log-entries');
const processLogTitle = document.getElementById('process-log-title');
const taskViewAgent = typeof defaultAgentConfig === 'object'
  ? { ...defaultAgentConfig }
  : { provider: 'OpenAI', model: 'gpt-4.1-mini', temperature: 0.2 };
const taskViewAttempt = {
  id: 'attempt_log_stream_demo',
  status: 'running',
  agent: taskViewAgent,
  startedAt: new Date().toISOString(),
  taskTitle: 'View real-time execution logs',
};
const taskViewLogEntries = [
  { id: 'log_1', timestamp: new Date(Date.now() - 120000).toISOString(), kind: 'action', source: 'agent', message: 'Scanning monitoring feature requirements.' },
  { id: 'log_2', timestamp: new Date(Date.now() - 90000).toISOString(), kind: 'response', source: 'agent', message: 'Summarized the scenario and prepared UI changes.' },
  { id: 'log_3', timestamp: new Date(Date.now() - 60000).toISOString(), kind: 'action', source: 'agent', message: 'Rendering task view log stream panel.' },
  { id: 'log_4', timestamp: new Date(Date.now() - 30000).toISOString(), kind: 'response', source: 'agent', message: 'Streaming logs now show actions and responses.' },
  { id: 'log_5', timestamp: new Date(Date.now() - 15000).toISOString(), kind: 'system', source: 'system', message: 'Waiting for the next agent event.' },
];
const taskViewProcesses = [
  { id: 'process_boot', name: 'Initialize agent runtime', status: 'running', startedAt: new Date(Date.now() - 180000).toISOString(), updatedAt: new Date(Date.now() - 60000).toISOString() },
  { id: 'process_sync', name: 'Sync workspace changes', status: 'completed', startedAt: new Date(Date.now() - 150000).toISOString(), updatedAt: new Date(Date.now() - 90000).toISOString() },
  { id: 'process_render', name: 'Render monitoring UI', status: 'queued', startedAt: new Date(Date.now() - 60000).toISOString(), updatedAt: new Date(Date.now() - 45000).toISOString() },
];
const taskProcessLogEntries = {
  process_boot: [
    { id: 'process_boot_1', timestamp: new Date(Date.now() - 170000).toISOString(), level: 'info', message: 'Loaded agent configuration and tools.' },
    { id: 'process_boot_2', timestamp: new Date(Date.now() - 130000).toISOString(), level: 'info', message: 'Connected to local workspace.' },
  ],
  process_sync: [
    { id: 'process_sync_1', timestamp: new Date(Date.now() - 140000).toISOString(), level: 'info', message: 'Fetched latest task changes.' },
    { id: 'process_sync_2', timestamp: new Date(Date.now() - 100000).toISOString(), level: 'success', message: 'Workspace synced successfully.' },
  ],
  process_render: [
    { id: 'process_render_1', timestamp: new Date(Date.now() - 50000).toISOString(), level: 'info', message: 'Preparing task view updates.' },
    { id: 'process_render_2', timestamp: new Date(Date.now() - 35000).toISOString(), level: 'info', message: 'Waiting for next render cycle.' },
  ],
};
let taskLogStreamTimer = null;
let taskLogStreamIndex = 0;
let activeProcessId = null;

function renderTaskViewMeta() {
  if (!taskViewAttemptLabel) { return; }
  const agent = taskViewAttempt?.agent || {};
  const agentLabel = [agent.provider, agent.model].filter(Boolean).join(' ');
  const statusLabel = taskViewAttempt?.status ? taskViewAttempt.status.replace('_', ' ') : 'running';
  taskViewAttemptLabel.textContent = agentLabel ? `${statusLabel} · ${agentLabel}` : statusLabel;
}
function setTaskViewStatus(message) {
  if (!taskViewStatus) { return; }
  const text = message ? message.trim() : 'Idle';
  taskViewStatus.textContent = text || 'Idle';
}
function renderTaskLogEntry(entry) {
  const item = document.createElement('div');
  item.className = 'task-log-entry';
  item.dataset.kind = entry?.kind || 'system';
  const meta = document.createElement('div');
  meta.className = 'task-log-meta';
  const badge = document.createElement('span');
  badge.className = 'task-log-badge';
  badge.textContent = entry?.kind || 'system';
  const source = document.createElement('span');
  source.className = 'task-log-source';
  source.textContent = entry?.source || 'system';
  const time = document.createElement('span');
  time.className = 'task-log-time';
  time.textContent = formatTimestamp(entry?.timestamp || new Date().toISOString());
  meta.append(badge, source, time);
  const message = document.createElement('p');
  message.className = 'task-log-message';
  message.textContent = entry?.message || 'Awaiting updates...';
  item.append(meta, message);
  return item;
}
function appendTaskLogEntry(entry) {
  if (!taskLogStream) { return; }
  const item = renderTaskLogEntry(entry);
  taskLogStream.appendChild(item);
  taskLogStream.scrollTop = taskLogStream.scrollHeight;
}
function stopTaskLogStream(message) {
  if (taskLogStreamTimer) {
    clearInterval(taskLogStreamTimer);
    taskLogStreamTimer = null;
  }
  setTaskViewStatus(message || 'Paused');
}
function startTaskLogStream() {
  if (!taskLogStream) { return; }
  taskLogStream.innerHTML = '';
  taskLogStreamIndex = 0;
  setTaskViewStatus('Streaming');
  taskLogStreamTimer = setInterval(() => {
    if (taskLogStreamIndex >= taskViewLogEntries.length) {
      stopTaskLogStream('Awaiting new events');
      return;
    }
    appendTaskLogEntry(taskViewLogEntries[taskLogStreamIndex]);
    taskLogStreamIndex += 1;
  }, 1200);
  if (taskViewLogEntries.length > 0) {
    appendTaskLogEntry(taskViewLogEntries[0]);
    taskLogStreamIndex = 1;
  }
}
function openTaskView() {
  if (taskViewSection) { taskViewSection.setAttribute('data-state', 'open'); }
  renderTaskViewMeta();
  startTaskLogStream();
}
function pauseTaskLogStream() {
  stopTaskLogStream('Paused');
}

function setProcessPanelStatus(message) {
  if (!processPanelStatus) { return; }
  const text = message ? message.trim() : 'Hidden';
  processPanelStatus.textContent = text || 'Hidden';
}
function renderProcessListItem(process) {
  const button = document.createElement('button');
  button.type = 'button';
  button.className = 'process-item';
  button.dataset.processId = process?.id || '';
  button.dataset.state = process?.id === activeProcessId ? 'active' : 'idle';
  const title = document.createElement('div');
  title.className = 'process-item-title';
  title.textContent = process?.name || 'Unnamed process';
  const meta = document.createElement('div');
  meta.className = 'process-item-meta';
  const status = document.createElement('span');
  status.className = 'process-item-status';
  status.dataset.status = process?.status || 'queued';
  status.textContent = process?.status || 'queued';
  const time = document.createElement('span');
  const timestamp = process?.updatedAt || process?.startedAt;
  time.textContent = timestamp ? formatTimestamp(timestamp) : 'Just now';
  meta.append(status, time);
  button.append(title, meta);
  return button;
}
function renderProcessList() {
  if (!processList) { return; }
  processList.innerHTML = '';
  if (!Array.isArray(taskViewProcesses) || taskViewProcesses.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'empty';
    empty.textContent = 'No processes available.';
    processList.appendChild(empty);
    return;
  }
  taskViewProcesses.forEach((process) => {
    processList.appendChild(renderProcessListItem(process));
  });
}
function renderProcessLogEntry(entry) {
  const item = document.createElement('div');
  item.className = 'process-log-entry';
  const meta = document.createElement('div');
  meta.className = 'process-log-meta';
  const level = document.createElement('span');
  level.textContent = entry?.level || 'info';
  const time = document.createElement('span');
  time.textContent = formatTimestamp(entry?.timestamp || new Date().toISOString());
  meta.append(level, time);
  const message = document.createElement('p');
  message.className = 'process-log-message';
  message.textContent = entry?.message || 'Awaiting process updates...';
  item.append(meta, message);
  return item;
}
function renderProcessLogs(processId) {
  if (!processLogEntries) { return; }
  processLogEntries.innerHTML = '';
  const entries = taskProcessLogEntries?.[processId] || [];
  if (!entries.length) {
    const empty = document.createElement('div');
    empty.className = 'empty';
    empty.textContent = 'No logs available for this process.';
    processLogEntries.appendChild(empty);
    return;
  }
  entries.forEach((entry) => {
    processLogEntries.appendChild(renderProcessLogEntry(entry));
  });
}
function openProcessLogView(processId) {
  if (!processId) {
    renderProcessList();
    renderProcessLogs(null);
    return;
  }
  activeProcessId = processId;
  const process = taskViewProcesses.find((candidate) => candidate.id === processId);
  if (processLogTitle) { processLogTitle.textContent = process?.name || 'Process logs'; }
  renderProcessList();
  renderProcessLogs(processId);
}
function handleProcessListClick(event) {
  const button = event.target.closest('button[data-process-id]');
  if (!button) { return; }
  openProcessLogView(button.dataset.processId);
}
function openProcessPanel() {
  if (processPanel) { processPanel.setAttribute('data-state', 'open'); }
  const hasProcesses = Array.isArray(taskViewProcesses) && taskViewProcesses.length > 0;
  setProcessPanelStatus(hasProcesses ? 'Visible' : 'Empty');
  if (hasProcesses) {
    const initialId = activeProcessId || taskViewProcesses[0].id;
    openProcessLogView(initialId);
    return;
  }
  renderProcessList();
  renderProcessLogs(null);
}

function openReviewModal(taskId, view) {
  if (!reviewModal) { return; }
  const task = findTaskById(taskId);
  if (!task) { return; }
  activeReviewTaskId = task.id;
  if (reviewTaskMeta) { reviewTaskMeta.textContent = task.title || 'Review task'; }
  renderReviewSummary(task);
  renderDiffFileList(task);
  renderReviewComments(task);
  setReviewView(view || 'diff');
  setDiffViewMode(diffViewMode);
  reviewModal.setAttribute('aria-hidden', 'false');
  reviewModal.setAttribute('data-state', 'open');
}
function closeReviewModal() {
  if (!reviewModal) { return; }
  reviewModal.setAttribute('aria-hidden', 'true');
  reviewModal.setAttribute('data-state', 'closed');
  activeReviewTaskId = null;
  closeOpenCommentForms();
  renderReviewComments(null);
  setReviewView('summary');
  setDiffViewMode('inline');
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
function openPullRequestModal(taskId, requestedProvider) { if (!prModal) { return; } const task = findTaskById(taskId); if (!task) { return; } const repoProvider = getRepoProvider(); const provider = requestedProvider || repoProvider; setPullRequestProviderLabel(provider); setAzureRepoUnsupportedMessage(false); if (isAzureRepoUnsupported(provider)) { activePullRequestTaskId = null; setAzureRepoUnsupportedMessage(true); setAzureCliInstructions(); setGithubCliInstructions(); setPullRequestFormEnabled(false); prModal.setAttribute('aria-hidden', 'false'); prModal.setAttribute('data-state', 'open'); return; } if (provider === 'azure') { const ready = isAzureCliReady(azureSettings); if (!ready) { activePullRequestTaskId = null; setAzureCliInstructions(azureSettings); setGithubCliInstructions(); setPullRequestFormEnabled(false); prModal.setAttribute('aria-hidden', 'false'); prModal.setAttribute('data-state', 'open'); return; } setAzureCliInstructions(azureSettings); setGithubCliInstructions(); } else { const ready = isGithubCliReady(githubSettings); if (!ready) { activePullRequestTaskId = null; setGithubCliInstructions(githubSettings); setAzureCliInstructions(); setPullRequestFormEnabled(false); prModal.setAttribute('aria-hidden', 'false'); prModal.setAttribute('data-state', 'open'); return; } setGithubCliInstructions(githubSettings); setAzureCliInstructions(); } setPullRequestFormEnabled(true); activePullRequestTaskId = task.id; if (prTitleInput) { prTitleInput.value = task.title || ''; } if (prDescriptionInput) { prDescriptionInput.value = task.description || ''; } if (prBaseBranchSelect) { prBaseBranchSelect.value = task.pullRequest?.baseBranch || prBaseBranchSelect.value || 'main'; } setBaseBranchError(''); prModal.setAttribute('aria-hidden', 'false'); prModal.setAttribute('data-state', 'open'); prTitleInput?.focus(); }
function closePullRequestModal() { if (!prModal) { return; } prModal.setAttribute('aria-hidden', 'true'); prModal.setAttribute('data-state', 'closed'); if (prForm) { prForm.reset(); } setGithubCliInstructions(); setAzureCliInstructions(); setAzureRepoUnsupportedMessage(false); setPullRequestProviderLabel(getRepoProvider()); setPullRequestFormEnabled(true); setBaseBranchError(''); activePullRequestTaskId = null; }
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
function setCopilotInstructions(message, state) { if (!copilotInstructions) { return; } const text = message ? message.trim() : ''; copilotInstructions.textContent = text; copilotInstructions.setAttribute('data-state', text ? (state || 'visible') : 'hidden'); }
function updateCopilotStatusUI() {
  if (!copilotStatus || !copilotPill || !copilotToggle) { return; }
  const ready = isCopilotReady(copilotSettings);
  copilotToggle.disabled = !ready; copilotToggle.checked = Boolean(copilotSettings?.enabled) && ready;
  if (!copilotSettings?.installed) {
    copilotStatus.textContent = 'Copilot CLI not installed';
    copilotPill.textContent = 'Install required';
    copilotPill.classList.add('is-muted');
    setCopilotInstructions('Install Copilot CLI with: gh extension install github/gh-copilot.', 'install');
    return;
  }
  if (!copilotSettings?.authenticated) {
    copilotStatus.textContent = 'Copilot CLI needs authentication';
    copilotPill.textContent = 'Sign in required';
    copilotPill.classList.add('is-muted');
    setCopilotInstructions('Authenticate Copilot CLI with: gh copilot auth.', 'auth');
    return;
  }
  setCopilotInstructions('');
  if (copilotSettings?.enabled) {
    copilotStatus.textContent = 'Connected';
    copilotPill.textContent = 'Connected'; copilotPill.classList.remove('is-muted');
    return;
  }
  copilotStatus.textContent = 'Ready to connect'; copilotPill.textContent = 'Available';
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
function requestAssistantSuggestions() { if (!assistantEnabled) { return; } if (assistantProvider === 'copilot-cli' && !copilotSettings?.enabled) { return; } const suggestions = assistantProvider === 'copilot-cli' ? copilotSuggestionTemplates : assistantSuggestionTemplates; assistantDrafts = [...suggestions]; renderAssistantSuggestions(assistantDrafts); if (assistantSuggestions) { assistantSuggestions.setAttribute('data-provider', assistantProvider); } }
function insertSuggestion(suggestion) { if (!suggestion) { return; } const current = descriptionInput.value.trim(); const spacer = current ? ' ' : ''; descriptionInput.value = `${current}${spacer}${suggestion}`; descriptionInput.focus(); }
function resetAssistantUI() { if (assistantToggle) { assistantToggle.checked = false; } setAssistantEnabled(false); }
function buildTaskPayload({ title, description, startAttempt }) {
  const timestamp = new Date().toISOString();
  const task = { id: createTaskId(), title, description, status: startAttempt ? 'in_progress' : 'todo', createdAt: timestamp, updatedAt: timestamp, attempts: [], activeAttemptId: null, evidence: [] };
  if (startAttempt) { const attempt = createAttempt(defaultAgentConfig); task.attempts = [attempt]; task.activeAttemptId = attempt.id; }
  return task;
}
function createPullRequest(task, payload, provider) { const target = provider || getRepoProvider(); if (!task) { return null; } if (isAzureRepoUnsupported(target)) { setAzureRepoUnsupportedMessage(true); setPullRequestFormEnabled(false); return null; } setAzureRepoUnsupportedMessage(false); if (target === 'azure') { if (!isAzureCliReady(azureSettings)) { setAzureCliInstructions(azureSettings); setPullRequestFormEnabled(false); return null; } } else if (!isGithubCliReady(githubSettings)) { setGithubCliInstructions(githubSettings); setPullRequestFormEnabled(false); return null; } const timestamp = new Date().toISOString(); const number = Math.floor(Math.random() * 9000) + 1000; const providerLabel = target === 'azure' ? 'Azure DevOps' : 'GitHub'; const pullRequest = { id: `pr_${Date.now().toString(36)}`, title: payload.title || task.title, description: payload.description || task.description || '', baseBranch: payload.baseBranch || 'main', status: 'open', number, provider: target, createdAt: timestamp }; task.pullRequest = pullRequest; recordEvidence(task, activityEvidenceTypes.pull_request_created, `PR #${number} created on ${providerLabel}`); task.updatedAt = timestamp; saveTasks(); renderTasks(); return pullRequest; }
openModalButton.addEventListener('click', openTaskModal); closeModalButton.addEventListener('click', closeTaskModal); cancelModalButton.addEventListener('click', closeTaskModal);
taskModal.addEventListener('click', (event) => { if (event.target === taskModal) { closeTaskModal(); } });
if (closePrButton) { closePrButton.addEventListener('click', closePullRequestModal); } if (cancelPrButton) { cancelPrButton.addEventListener('click', closePullRequestModal); } if (prModal) { prModal.addEventListener('click', (event) => { if (event.target === prModal) { closePullRequestModal(); } }); }
if (closeReviewButton) { closeReviewButton.addEventListener('click', closeReviewModal); }
if (reviewModal) { reviewModal.addEventListener('click', (event) => { if (event.target === reviewModal) { closeReviewModal(); } }); }
window.addEventListener('keydown', (event) => { if (event.key !== 'Escape') { return; } if (taskModal.getAttribute('aria-hidden') === 'false') { closeTaskModal(); } if (connectModal.getAttribute('aria-hidden') === 'false') { closeConnectModal(); } if (prModal?.getAttribute('aria-hidden') === 'false') { closePullRequestModal(); } if (reviewModal?.getAttribute('aria-hidden') === 'false') { closeReviewModal(); } });
titleInput.addEventListener('input', () => { if (titleInput.value.trim()) { clearValidation(); } });
if (searchInput) { searchQuery = normalizeSearchQuery(searchInput.value); searchInput.addEventListener('input', (event) => { setSearchQuery(event.target.value); }); }
if (assistantToggle) { assistantToggle.addEventListener('change', (event) => { setAssistantEnabled(event.target.checked); }); }
if (assistantProviderSelect) { assistantProviderSelect.addEventListener('change', (event) => { setAssistantProvider(event.target.value); }); }
if (assistantSuggestButton) { assistantSuggestButton.addEventListener('click', () => { requestAssistantSuggestions(); }); }
if (assistantSuggestions) { assistantSuggestions.addEventListener('click', (event) => { const button = event.target.closest('button[data-suggestion]'); if (!button) { return; } insertSuggestion(button.dataset.suggestion); }); }
if (reviewSummaryTab) { reviewSummaryTab.addEventListener('click', () => setReviewView('summary')); } if (reviewDiffTab) { reviewDiffTab.addEventListener('click', () => setReviewView('diff')); } if (diffInlineButton) { diffInlineButton.addEventListener('click', () => setDiffViewMode('inline')); } if (diffSplitButton) { diffSplitButton.addEventListener('click', () => setDiffViewMode('split')); } if (diffFileList) { diffFileList.addEventListener('click', handleDiffFileListClick); } if (reviewSendButton) { reviewSendButton.addEventListener('click', sendReviewFeedback); }
if (openTaskViewButton) { openTaskViewButton.addEventListener('click', openTaskView); }
if (pauseTaskStreamButton) { pauseTaskStreamButton.addEventListener('click', pauseTaskLogStream); }
if (openProcessesButton) { openProcessesButton.addEventListener('click', openProcessPanel); }
if (processList) { processList.addEventListener('click', handleProcessListClick); }
if (activityStartButton) { activityStartButton.addEventListener('click', () => startTaskAttempt(activityTaskId)); } if (activityCompleteButton) { activityCompleteButton.addEventListener('click', () => completeTaskAttempt(activityTaskId)); } if (activityMergeButton) { activityMergeButton.addEventListener('click', () => mergeTask(activityTaskId)); }
if (activityPrButton) { activityPrButton.addEventListener('click', () => openPullRequestModal(activityTaskId)); } if (prBaseBranchSelect) { prBaseBranchSelect.addEventListener('change', (event) => { validateBaseBranchSelection(event.target.value); }); }
if (copilotToggle) { copilotToggle.addEventListener('change', (event) => { setCopilotEnabled(event.target.checked); }); }
registerColumnDropTargets(); setAssistantEnabled(Boolean(assistantToggle?.checked)); setAssistantProvider(assistantProvider); updateCopilotStatusUI(); updateAssistantProviderAvailability(); renderTaskViewMeta(); setTaskViewStatus('Idle'); setProcessPanelStatus('Hidden');
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
if (prForm) { prForm.addEventListener('submit', (event) => { event.preventDefault(); const task = findTaskById(activePullRequestTaskId); if (!task) { return; } const provider = getRepoProvider(); if (provider === 'azure') { if (!isAzureCliReady(azureSettings)) { setAzureCliInstructions(azureSettings); setPullRequestFormEnabled(false); return; } } else if (!isGithubCliReady(githubSettings)) { setGithubCliInstructions(githubSettings); setPullRequestFormEnabled(false); return; } const baseBranch = prBaseBranchSelect?.value; if (!validateBaseBranchSelection(baseBranch)) { return; } const payload = { title: prTitleInput?.value.trim(), description: prDescriptionInput?.value.trim(), baseBranch }; const pullRequest = createPullRequest(task, payload, provider); if (!pullRequest) { return; } closePullRequestModal(); }); }
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
  if (event.key === githubCliSettingsKey) {
    githubSettings = loadGithubSettings();
    return;
  }
  if (event.key === azureCliSettingsKey) {
    azureSettings = loadAzureSettings();
    return;
  }
  if (event.key === assistantProviderKey) {
    assistantProvider = loadAssistantProvider();
    setAssistantProvider(assistantProvider);
  }
});
seedActivityTask(); seedReviewTask();
renderTasks();
