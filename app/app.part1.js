const storageKey = 'slice0001.tasks', sessionsKey = 'slice0001.sessions', pairingRequestKey = 'slice0001.pairing_request', pairedDevicesKey = 'slice0001.devices', copilotSettingsKey = 'slice0001.copilot_cli', githubCliSettingsKey = 'slice0001.github_cli', azureCliSettingsKey = 'slice0001.azure_cli', assistantProviderKey = 'slice0001.assistant_provider', defaultAttemptStatus = 'running', githubRemoteBranches = ['main', 'develop', 'release'];
const defaultAgentConfig = { provider: 'OpenAI', model: 'gpt-4.1-mini', temperature: 0.2 };
const defaultCopilotSettings = { installed: true, authenticated: true, enabled: false }, defaultGithubSettings = { installed: true, authenticated: true }, defaultAzureSettings = { installed: true, authenticated: true, devopsExtension: true };
const assistantSuggestionTemplates = ['Draft a step-by-step plan with milestones and a clear definition of done.', 'List the files to inspect, the changes to make, and the tests to run.', 'Summarize the expected behavior and call out edge cases to verify.'];
const copilotSuggestionTemplates = ['Use Copilot CLI to outline a step-by-step approach with tests.', 'Ask Copilot CLI for a concise task summary and acceptance checks.', 'Have Copilot CLI suggest edge cases and verification steps.'];
const activityTaskId = 'task_agent_activity_demo', reviewTaskId = 'task_code_review_demo', reviewNoDiffTaskId = 'task_code_review_no_diffs';
const activityEvidenceTypes = { attempt_started: 'attempt_started', attempt_completed: 'attempt_completed', task_merged: 'task_merged', pull_request_created: 'pull_request_created', review_feedback_sent: 'review_feedback_sent' };
const activityEvidenceLabels = { attempt_started: 'Attempt started', attempt_completed: 'Attempt completed', task_merged: 'Merged into main', pull_request_created: 'Pull request created', review_feedback_sent: 'Review feedback sent' };
const todoList = document.getElementById('todo-list'), todoCount = document.getElementById('todo-count'), inProgressList = document.getElementById('in-progress-list'), inProgressCount = document.getElementById('in-progress-count'), inReviewList = document.getElementById('in-review-list'), inReviewCount = document.getElementById('in-review-count'), doneList = document.getElementById('done-list'), doneCount = document.getElementById('done-count'), taskCount = document.getElementById('task-count'), taskModal = document.getElementById('task-modal'), openModalButton = document.getElementById('open-modal'), closeModalButton = document.getElementById('close-modal'), cancelModalButton = document.getElementById('cancel-modal'), form = document.getElementById('task-form'), titleInput = document.getElementById('task-title'), descriptionInput = document.getElementById('task-description'), assistantPanel = document.getElementById('assistant-panel'), assistantToggle = document.getElementById('assistant-toggle'), assistantProviderSelect = document.getElementById('assistant-provider'), assistantSuggestButton = document.getElementById('assistant-suggest'), assistantSuggestions = document.getElementById('assistant-suggestions'), titleError = document.getElementById('title-error'), connectModal = document.getElementById('connect-modal'), openConnectButton = document.getElementById('open-connect'), openPairingButton = document.getElementById('open-pairing'), closeConnectButton = document.getElementById('close-connect'), qrCodeContainer = document.getElementById('qr-code'), pairingLinkInput = document.getElementById('pairing-link'), copyLinkButton = document.getElementById('copy-link'), activityPanel = document.getElementById('agent-activity'), activityTaskTitle = document.getElementById('activity-task-title'), activityStartButton = document.getElementById('activity-start'), activityCompleteButton = document.getElementById('activity-complete'), activityMergeButton = document.getElementById('activity-merge'), activityPrButton = document.getElementById('activity-pr'), activityLog = document.getElementById('activity-log'), prModal = document.getElementById('pr-modal'), prForm = document.getElementById('pr-form'), prTitleInput = document.getElementById('pr-title'), prDescriptionInput = document.getElementById('pr-description'), prBaseBranchSelect = document.getElementById('pr-base-branch'), prBaseBranchError = document.getElementById('pr-base-branch-error'), closePrButton = document.getElementById('close-pr'), cancelPrButton = document.getElementById('cancel-pr'), submitPrButton = document.getElementById('submit-pr'), githubCliInstructions = document.getElementById('github-cli-instructions'), azureCliInstructions = document.getElementById('azure-cli-instructions'), azureRepoUnsupportedMessage = document.getElementById('azure-repo-unsupported'), prProviderLabel = document.getElementById('pr-provider-label'), searchInput = document.getElementById('task-search'), deviceList = document.getElementById('device-list'), sessionList = document.getElementById('session-list'), startSessionButton = document.getElementById('start-session'), pairingStatus = document.getElementById('pairing-status'), copilotToggle = document.getElementById('copilot-toggle'), copilotStatus = document.getElementById('copilot-status'), copilotInstructions = document.getElementById('copilot-instructions'), copilotPill = document.getElementById('copilot-pill'), reviewModal = document.getElementById('review-modal'), reviewTaskMeta = document.getElementById('review-task-meta'), reviewSummaryTitle = document.getElementById('review-summary-title'), reviewSummaryCopy = document.getElementById('review-summary-copy'), reviewSummaryTab = document.getElementById('review-summary-tab'), reviewDiffTab = document.getElementById('review-diff-tab'), closeReviewButton = document.getElementById('close-review'), diffFileList = document.getElementById('diff-file-list'), reviewCommentList = document.getElementById('review-comment-list'), reviewCommentCount = document.getElementById('review-comment-count'), reviewSendButton = document.getElementById('review-send'), reviewSendHint = document.getElementById('review-send-hint'), diffInlineButton = document.getElementById('diff-inline'), diffSplitButton = document.getElementById('diff-split'), diffViewLabel = document.getElementById('diff-view-label');
const demoSeedEnabled = document.body?.dataset?.demoSeed === 'true';
let tasks = loadTasks(); let sessions = loadSessions(); let pairedDevices = loadPairedDevices(); let pairingRequest = loadPairingRequest();
let copilotSettings = loadCopilotSettings(); let githubSettings = loadGithubSettings(); let azureSettings = loadAzureSettings();
let assistantEnabled = false; let activePullRequestTaskId = null; let activeReviewTaskId = null; let reviewView = 'summary'; let diffViewMode = 'inline';
let assistantDrafts = []; let assistantProvider = loadAssistantProvider(); let searchQuery = '';
const statusAliases = { todo: 'todo', 'in progress': 'in_progress', 'in-progress': 'in_progress', in_progress: 'in_progress', 'in review': 'in_review', 'in-review': 'in_review', in_review: 'in_review', done: 'done' };
const columnConfig = [{ key: 'todo', list: todoList, count: todoCount, emptyMessage: 'No tasks yet. Create one to get started.', showCompleteAction: true }, { key: 'in_progress', list: inProgressList, count: inProgressCount, emptyMessage: 'Nothing in progress yet.', showCompleteAction: true }, { key: 'in_review', list: inReviewList, count: inReviewCount, emptyMessage: 'No reviews queued yet.', showCompleteAction: true }, { key: 'done', list: doneList, count: doneCount, emptyMessage: 'No tasks completed yet.', showCompleteAction: false }];
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
function loadSessions() { try { const raw = localStorage.getItem(sessionsKey); if (!raw) { return []; } const parsed = JSON.parse(raw); if (!Array.isArray(parsed)) { return []; } return parsed.map((session) => normalizeSession(session)).filter(Boolean); } catch (error) { console.warn('Failed to read sessions from localStorage', error); return []; } }
function saveSessions() { localStorage.setItem(sessionsKey, JSON.stringify(sessions)); }
function normalizeSession(session) { if (!session || typeof session !== 'object') { return null; } const createdAt = typeof session.createdAt === 'string' && session.createdAt.trim() ? session.createdAt : new Date().toISOString(); const statusValue = typeof session.status === 'string' && session.status.trim() ? session.status.trim().toLowerCase() : 'online'; const status = statusValue === 'offline' ? 'offline' : 'online'; const name = typeof session.name === 'string' && session.name.trim() ? session.name.trim() : 'Coding session'; return { ...session, id: session.id || `session_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`, name, status, createdAt, updatedAt: typeof session.updatedAt === 'string' && session.updatedAt.trim() ? session.updatedAt : createdAt, deviceName: session.deviceName || getDeviceName() }; }
function createSession() { const timestamp = new Date().toISOString(); return normalizeSession({ id: `session_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`, name: 'Coding session', status: 'online', createdAt: timestamp, updatedAt: timestamp, deviceName: getDeviceName() }); }
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
function savePairedDevices(devices) { localStorage.setItem(pairedDevicesKey, JSON.stringify(devices)); }
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
  const installed = typeof settings.installed === 'boolean' ? settings.installed : defaultCopilotSettings.installed;
  const authenticated = typeof settings.authenticated === 'boolean' ? settings.authenticated : defaultCopilotSettings.authenticated;
  const enabled = Boolean(settings.enabled) && installed && authenticated;
  return { installed, authenticated, enabled };
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
function saveCopilotSettings(settings) { localStorage.setItem(copilotSettingsKey, JSON.stringify(settings)); }
function isCopilotReady(settings) { return Boolean(settings?.installed) && Boolean(settings?.authenticated); }
function loadGithubSettings() { try { const raw = localStorage.getItem(githubCliSettingsKey); if (!raw) { return { ...defaultGithubSettings }; } const parsed = JSON.parse(raw); const installed = typeof parsed?.installed === 'boolean' ? parsed.installed : defaultGithubSettings.installed; const authenticated = typeof parsed?.authenticated === 'boolean' ? parsed.authenticated : defaultGithubSettings.authenticated; return { installed, authenticated }; } catch (error) { console.warn('Failed to read GitHub CLI settings', error); return { ...defaultGithubSettings }; } } function isGithubCliReady(settings) { return Boolean(settings?.installed) && Boolean(settings?.authenticated); } function setGithubCliInstructions(settings) { if (!githubCliInstructions) { return; } const state = settings && typeof settings === 'object' ? settings : { installed: true, authenticated: true }; const instructions = []; if (!state.installed) { instructions.push('Install GitHub CLI from https://cli.github.com/.'); } if (!state.authenticated) { instructions.push('Authenticate GitHub CLI with: gh auth login.'); } const text = instructions.join(' ').trim(); githubCliInstructions.textContent = text; githubCliInstructions.hidden = !text; } function loadAzureSettings() { try { const raw = localStorage.getItem(azureCliSettingsKey); if (!raw) { return { ...defaultAzureSettings }; } const parsed = JSON.parse(raw); const installed = typeof parsed?.installed === 'boolean' ? parsed.installed : defaultAzureSettings.installed; const authenticated = typeof parsed?.authenticated === 'boolean' ? parsed.authenticated : defaultAzureSettings.authenticated; const devopsExtension = typeof parsed?.devopsExtension === 'boolean' ? parsed.devopsExtension : defaultAzureSettings.devopsExtension; return { installed, authenticated, devopsExtension }; } catch (error) { console.warn('Failed to read Azure CLI settings', error); return { ...defaultAzureSettings }; } } function isAzureCliReady(settings) { return Boolean(settings?.installed) && Boolean(settings?.authenticated) && Boolean(settings?.devopsExtension); } function setAzureCliInstructions(settings) { if (!azureCliInstructions) { return; } const state = settings && typeof settings === 'object' ? settings : { installed: true, authenticated: true, devopsExtension: true }; const instructions = []; if (!state.installed) { instructions.push('Install Azure CLI from https://aka.ms/azure-cli.'); } if (!state.devopsExtension) { instructions.push('Add Azure DevOps extension with: az extension add --name azure-devops.'); } if (!state.authenticated) { instructions.push('Authenticate Azure CLI with: az login && az devops login.'); } const text = instructions.join(' ').trim(); azureCliInstructions.textContent = text; azureCliInstructions.hidden = !text; } function setAzureRepoUnsupportedMessage(isUnsupported) { if (!azureRepoUnsupportedMessage) { return; } const message = isUnsupported ? 'This repository is not hosted on Azure Repos, so Azure DevOps PRs are unsupported.' : ''; azureRepoUnsupportedMessage.textContent = message; azureRepoUnsupportedMessage.hidden = !message; } function isAzureRepoUnsupported(requestedProvider) { if (requestedProvider !== 'azure') { return false; } return getRepoProvider() !== 'azure'; } function getRepoProvider() { const value = document.body?.dataset?.repoProvider; return value === 'azure' ? 'azure' : 'github'; } function setPullRequestProviderLabel(provider) { if (!prProviderLabel) { return; } prProviderLabel.textContent = provider === 'azure' ? 'Azure DevOps' : 'GitHub'; } function setPullRequestFormEnabled(enabled) { const disabled = !enabled; if (prTitleInput) { prTitleInput.disabled = disabled; } if (prDescriptionInput) { prDescriptionInput.disabled = disabled; } if (prBaseBranchSelect) { prBaseBranchSelect.disabled = disabled; } if (submitPrButton) { submitPrButton.disabled = disabled; } } function setBaseBranchError(message) { if (!prBaseBranchError) { return; } const text = message ? message.trim() : ''; prBaseBranchError.textContent = text; prBaseBranchError.hidden = !text; } function isGithubBaseBranchAvailable(branch) { return Boolean(branch) && githubRemoteBranches.includes(branch); } function validateBaseBranchSelection(branch) { const value = typeof branch === 'string' ? branch.trim() : ''; if (!value) { setBaseBranchError('Select a base branch.'); return false; } if (!isGithubBaseBranchAvailable(value)) { setBaseBranchError(`Base branch "${value}" not found on GitHub.`); return false; } setBaseBranchError(''); return true; }
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
function saveAssistantProvider(value) { localStorage.setItem(assistantProviderKey, value); }
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
  const pullRequest = task.pullRequest && typeof task.pullRequest === 'object' ? { ...task.pullRequest, status: typeof task.pullRequest.status === 'string' && task.pullRequest.status.trim() ? task.pullRequest.status.trim().toLowerCase() : 'open', baseBranch: typeof task.pullRequest.baseBranch === 'string' && task.pullRequest.baseBranch.trim() ? task.pullRequest.baseBranch.trim() : 'main', title: typeof task.pullRequest.title === 'string' ? task.pullRequest.title : task.title || '', description: typeof task.pullRequest.description === 'string' ? task.pullRequest.description : task.description || '' } : null;
  return { ...task, status: normalizeStatus(task.status), createdAt, updatedAt: typeof task.updatedAt === 'string' && task.updatedAt.trim() ? task.updatedAt : createdAt, attempts, activeAttemptId, evidence, pullRequest };
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
function createReviewCommentId() { return `review_comment_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`; }
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
function createActivityTask() { const timestamp = new Date().toISOString(); return { id: activityTaskId, title: 'Agent status demo', description: 'Track this task as the agent moves through start, review, and merge.', status: 'todo', createdAt: timestamp, updatedAt: timestamp, attempts: [], activeAttemptId: null, evidence: [], changes: ['Drafted PR summary', 'Updated UI copy'], isDemo: true }; }
function seedActivityTask() { if (tasks.some((task) => task.id === activityTaskId) || tasks.some((task) => normalizeStatus(task.status) === 'todo')) { return; } tasks = [createActivityTask(), ...tasks]; saveTasks(); }
function createReviewTask() {
  const timestamp = new Date().toISOString();
  return {
    id: reviewTaskId,
    title: 'Diff view review',
    description: 'Review file changes and switch diff layouts.',
    status: 'in_review',
    createdAt: timestamp,
    updatedAt: timestamp,
    attempts: [],
    activeAttemptId: null,
    evidence: [],
    diffFiles: [
      {
        path: 'app/index.html',
        additions: 12,
        deletions: 3,
        status: 'modified',
        lines: [
          { lineNumber: 118, type: 'context', content: '<section class="column" aria-labelledby="in-review-title">' },
          { lineNumber: 124, type: 'add', content: '<span class="pill pill-review">Review</span>' },
          { lineNumber: 126, type: 'del', content: '<span class="pill pill-muted">Review</span>' },
        ],
      },
      {
        path: 'app/styles.part1.css',
        additions: 18,
        deletions: 6,
        status: 'modified',
        lines: [
          { lineNumber: 321, type: 'context', content: '.review-panel { display: none; }' },
          { lineNumber: 330, type: 'add', content: '.diff-file-list { display: grid; gap: 10px; }' },
          { lineNumber: 337, type: 'del', content: '.diff-stat-del { color: #7c3d2b; }' },
        ],
      },
      {
        path: 'app/app.part1.js',
        additions: 24,
        deletions: 10,
        status: 'modified',
        lines: [
          { lineNumber: 210, type: 'context', content: 'const diffViewMode = \"inline\";' },
          { lineNumber: 223, type: 'add', content: 'renderReviewComments(task);' },
          { lineNumber: 236, type: 'del', content: 'diffFileList.innerHTML = \"\";' },
        ],
      },
    ],
    reviewComments: [],
    isDemo: true,
  };
}
function createNoDiffReviewTask() { const timestamp = new Date().toISOString(); return { id: reviewNoDiffTaskId, title: 'No code changes yet', description: 'Review an attempt that produced no file diffs.', status: 'in_review', createdAt: timestamp, updatedAt: timestamp, attempts: [], activeAttemptId: null, evidence: [], diffFiles: [], reviewComments: [], isDemo: true }; }
function seedReviewTask() {
  if (tasks.some((task) => normalizeStatus(task.status) === 'in_review')) { return; }
  const seeded = [];
  if (!tasks.some((task) => task.id === reviewTaskId)) { seeded.push(createReviewTask()); }
  if (!tasks.some((task) => task.id === reviewNoDiffTaskId)) { seeded.push(createNoDiffReviewTask()); }
  if (seeded.length === 0) { return; }
  tasks = [...seeded, ...tasks];
  saveTasks();
}
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
  if (taskCount) { taskCount.textContent = tasks.length.toString(); }
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
    if (task.pullRequest) { const pr = task.pullRequest; const prStatus = document.createElement('div'); prStatus.className = 'task-pr'; const number = pr.number ? `#${pr.number}` : ''; const statusLabel = pr.status ? pr.status.replace('_', ' ') : 'open'; const baseLabel = pr.baseBranch ? ` · Base ${pr.baseBranch}` : ''; prStatus.textContent = `PR ${number} · ${statusLabel}${baseLabel}`.trim(); card.appendChild(prStatus); }
    if (task.status === 'done') { const status = document.createElement('div'); status.className = 'task-status'; status.textContent = 'Done'; card.appendChild(status); }
    const actions = document.createElement('div'); actions.className = 'task-actions'; let hasActions = false;
    if (task.status === 'in_review') { const reviewButton = document.createElement('button'); reviewButton.type = 'button'; reviewButton.className = 'task-action task-action-review'; reviewButton.textContent = 'Review'; reviewButton.addEventListener('click', () => openReviewModal(task.id, 'diff')); actions.appendChild(reviewButton); hasActions = true; }
    if (options.showCompleteAction && task.status !== 'done') { const completeButton = document.createElement('button'); completeButton.type = 'button'; completeButton.className = 'task-action'; completeButton.textContent = 'Complete'; completeButton.addEventListener('click', () => markTaskDone(task.id)); actions.appendChild(completeButton); hasActions = true; }
    if (hasActions) { card.appendChild(actions); }
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
function setReviewView(view) { reviewView = view === 'diff' ? 'diff' : 'summary'; if (reviewModal) { reviewModal.setAttribute('data-review-view', reviewView); } if (reviewSummaryTab) { reviewSummaryTab.setAttribute('aria-selected', reviewView === 'summary'); } if (reviewDiffTab) { reviewDiffTab.setAttribute('aria-selected', reviewView === 'diff'); } }
function setDiffViewMode(mode) { diffViewMode = mode === 'split' ? 'split' : 'inline'; if (reviewModal) { reviewModal.setAttribute('data-diff-mode', diffViewMode); } if (diffInlineButton) { diffInlineButton.setAttribute('aria-pressed', diffViewMode === 'inline'); } if (diffSplitButton) { diffSplitButton.setAttribute('aria-pressed', diffViewMode === 'split'); } if (diffViewLabel) { diffViewLabel.textContent = diffViewMode === 'split' ? 'Split view' : 'Inline view'; } }
function renderReviewSummary(task) { if (!reviewSummaryTitle || !reviewSummaryCopy) { return; } if (!task) { reviewSummaryTitle.textContent = 'No task selected'; reviewSummaryCopy.textContent = 'Open the diff view to inspect file changes.'; return; } const files = Array.isArray(task.diffFiles) ? task.diffFiles.length : 0; reviewSummaryTitle.textContent = task.title || 'Review task'; reviewSummaryCopy.textContent = files ? `${files} file${files === 1 ? '' : 's'} changed. Open the diff view to inspect.` : 'No code changes yet.'; }
function getReviewComments(task) { return Array.isArray(task?.reviewComments) ? task.reviewComments : []; }
function updateReviewSendState(task) { if (!reviewSendButton && !reviewSendHint) { return; } const comments = getReviewComments(task); const count = comments.length; if (reviewSendButton) { reviewSendButton.disabled = count === 0; reviewSendButton.textContent = count ? `Send ${count} comment${count === 1 ? '' : 's'}` : 'Send'; } if (reviewSendHint) { const message = count ? `Send ${count} comment${count === 1 ? '' : 's'} to the agent and move the task back to In Progress.` : 'Add at least one comment before sending feedback.'; reviewSendHint.textContent = message; reviewSendHint.dataset.state = count ? 'ready' : 'empty'; } }
function lineHasComment(comments, filePath, lineNumber) { return comments.some((comment) => comment.filePath === filePath && comment.lineNumber === lineNumber); }
function renderReviewComments(task) { updateReviewSendState(task); if (!reviewCommentList || !reviewCommentCount) { return; } const comments = getReviewComments(task); reviewCommentCount.textContent = comments.length.toString(); reviewCommentList.innerHTML = ''; if (!task || comments.length === 0) { const empty = document.createElement('p'); empty.className = 'review-comment-empty'; empty.textContent = 'No review comments yet.'; reviewCommentList.appendChild(empty); return; } comments.forEach((comment) => { const item = document.createElement('div'); item.className = 'review-comment-item'; item.setAttribute('role', 'listitem'); const meta = document.createElement('div'); meta.className = 'review-comment-meta'; const lineLabel = comment.lineNumber ? `Line ${comment.lineNumber}` : 'Line'; meta.textContent = `${comment.filePath || 'File'} · ${lineLabel}`; const text = document.createElement('p'); text.className = 'review-comment-text'; text.textContent = comment.text || ''; item.append(meta, text); reviewCommentList.appendChild(item); }); }
function buildLineCommentForm(filePath, lineNumber) {
  const form = document.createElement('div');
  form.className = 'diff-comment-form';
  form.dataset.filePath = filePath || '';
  form.dataset.lineNumber = lineNumber ? lineNumber.toString() : '';
  const textarea = document.createElement('textarea');
  textarea.className = 'diff-comment-input';
  textarea.placeholder = 'Add a line-specific comment';
  const actions = document.createElement('div');
  actions.className = 'diff-comment-actions';
  const submit = document.createElement('button');
  submit.type = 'button';
  submit.className = 'diff-comment-submit';
  submit.textContent = 'Add comment';
  const cancel = document.createElement('button');
  cancel.type = 'button';
  cancel.className = 'diff-comment-cancel';
  cancel.textContent = 'Cancel';
  actions.append(submit, cancel);
  form.append(textarea, actions);
  return form;
}
function closeOpenCommentForms() {
  if (!diffFileList) { return; }
  diffFileList.querySelectorAll('.diff-comment-form').forEach((form) => form.remove());
  diffFileList.querySelectorAll('.diff-line.is-commenting').forEach((line) => line.classList.remove('is-commenting'));
}
function toggleLineCommentForm(lineRow, filePath, lineNumber) {
  if (!lineRow || !diffFileList) { return; }
  const existing = lineRow.nextElementSibling;
  if (existing && existing.classList.contains('diff-comment-form')) {
    existing.remove();
    lineRow.classList.remove('is-commenting');
    return;
  }
  closeOpenCommentForms();
  const form = buildLineCommentForm(filePath, lineNumber);
  lineRow.classList.add('is-commenting');
  lineRow.insertAdjacentElement('afterend', form);
  const input = form.querySelector('textarea');
  input?.focus();
}
function addLineComment(taskId, filePath, lineNumber, text) {
  const task = findTaskById(taskId);
  if (!task) { return null; }
  const trimmed = typeof text === 'string' ? text.trim() : '';
  if (!trimmed) { return null; }
  const timestamp = new Date().toISOString();
  const entry = { id: createReviewCommentId(), filePath: filePath || '', lineNumber: lineNumber || null, text: trimmed, createdAt: timestamp };
  task.reviewComments = [...getReviewComments(task), entry];
  task.updatedAt = timestamp;
  saveTasks();
  renderReviewComments(task);
  renderDiffFileList(task);
  return entry;
}
function renderDiffLines(file, comments) {
  const container = document.createElement('div');
  container.className = 'diff-lines';
  const lines = Array.isArray(file?.lines) ? file.lines : [];
  if (lines.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'empty';
    empty.textContent = 'No line changes recorded.';
    container.appendChild(empty);
    return container;
  }
  lines.forEach((line) => {
    const lineNumber = Number(line.lineNumber || line.line || 0) || 0;
    const lineType = line.type || 'context';
    const row = document.createElement('div');
    row.className = 'diff-line';
    row.dataset.lineType = lineType;
    row.dataset.filePath = file.path || '';
    row.dataset.lineNumber = lineNumber ? lineNumber.toString() : '';
    const gutter = document.createElement('div');
    gutter.className = 'diff-line-gutter';
    gutter.textContent = lineNumber ? lineNumber.toString() : '';
    const code = document.createElement('pre');
    code.className = 'diff-line-code';
    code.textContent = line.content || '';
    const commentButton = document.createElement('button');
    commentButton.type = 'button';
    commentButton.className = 'diff-line-comment';
    commentButton.textContent = 'Comment';
    commentButton.setAttribute('aria-label', `Add comment for line ${lineNumber || ''}`.trim());
    if (lineHasComment(comments, file.path || '', lineNumber || null)) {
      commentButton.dataset.hasComment = 'true';
    }
    row.append(gutter, code, commentButton);
    container.appendChild(row);
  });
  return container;
}
function renderDiffFileList(task) {
  if (!diffFileList) { return; }
  diffFileList.innerHTML = '';
  const files = Array.isArray(task?.diffFiles) ? task.diffFiles : [];
  if (files.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'empty';
    empty.textContent = 'No code changes yet.';
    diffFileList.appendChild(empty);
    return;
  }
  const comments = getReviewComments(task);
  files.forEach((file) => {
    const item = document.createElement('div');
    item.className = 'diff-file';
    item.setAttribute('role', 'listitem');
    const header = document.createElement('div');
    header.className = 'diff-file-header';
    const path = document.createElement('div');
    path.className = 'diff-file-path';
    path.textContent = file.path || 'Untitled file';
    const meta = document.createElement('div');
    meta.className = 'diff-file-meta';
    const status = document.createElement('span');
    status.className = 'diff-file-status';
    status.textContent = file.status || 'modified';
    const additions = document.createElement('span');
    additions.className = 'diff-stat diff-stat-add';
    additions.textContent = `+${file.additions || 0}`;
    const deletions = document.createElement('span');
    deletions.className = 'diff-stat diff-stat-del';
    deletions.textContent = `-${file.deletions || 0}`;
    meta.append(status, additions, deletions);
    header.append(path, meta);
    item.append(header, renderDiffLines(file, comments));
    diffFileList.appendChild(item);
  });
}
function handleDiffFileListClick(event) {
  if (!event || !diffFileList) { return; }
  const commentButton = event.target.closest('.diff-line-comment');
  if (commentButton) {
    const lineRow = commentButton.closest('.diff-line');
    if (!lineRow) { return; }
    const filePath = lineRow.dataset.filePath || '';
    const lineNumber = Number(lineRow.dataset.lineNumber || 0) || 0;
    toggleLineCommentForm(lineRow, filePath, lineNumber);
    return;
  }
  const submitButton = event.target.closest('.diff-comment-submit');
  if (submitButton) {
    const form = submitButton.closest('.diff-comment-form');
    if (!form) { return; }
    const input = form.querySelector('.diff-comment-input');
    const filePath = form.dataset.filePath || '';
    const lineNumber = Number(form.dataset.lineNumber || 0) || 0;
    addLineComment(activeReviewTaskId, filePath, lineNumber, input?.value || '');
    form.remove();
    return;
  }
  const cancelButton = event.target.closest('.diff-comment-cancel');
  if (cancelButton) {
    const form = cancelButton.closest('.diff-comment-form');
    if (form) { form.remove(); }
    return;
  }
}
function sendReviewFeedback() { const task = findTaskById(activeReviewTaskId); if (!task) { return null; } const comments = getReviewComments(task); if (comments.length === 0) { updateReviewSendState(task); return null; } const timestamp = new Date().toISOString(); const feedback = { sentAt: timestamp, commentCount: comments.length, comments: comments.map((comment) => ({ filePath: comment.filePath || '', lineNumber: comment.lineNumber || null, text: comment.text || '' })) }; const priorFeedback = Array.isArray(task.reviewFeedback) ? task.reviewFeedback : []; task.reviewFeedback = [...priorFeedback, feedback]; task.reviewComments = []; task.status = 'in_progress'; recordEvidence(task, activityEvidenceTypes.review_feedback_sent, `Sent ${comments.length} review comment${comments.length === 1 ? '' : 's'} to agent.`); task.updatedAt = timestamp; saveTasks(); renderTasks(); renderReviewComments(task); closeReviewModal(); return feedback; }
