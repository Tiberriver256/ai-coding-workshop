# Threat Model — Slice 0001 + Roadmap

## Scope
- **In scope (Slice 0001)**: Local-only Kanban board UI running in the browser with tasks persisted to `localStorage`.
- **Planned roadmap in scope**: Task orchestration, agent execution, remote access, multi-device sync, and streaming (per ADRs and feature docs).
- **Out of scope**: Production hosting hardening, SOC2 controls, incident response.

## References
- `docs/plan/slice-plan.md`
- `docs/architecture/adrs/0007-slice-0001-local-task-creation-and-persistence.md`
- `docs/architecture/adrs/0001-end-to-end-encryption-and-key-wrapping.md`
- `docs/architecture/adrs/0002-qr-device-pairing-handshake.md`
- `docs/architecture/adrs/0003-secure-remote-access-via-p2p-and-relay.md`
- `docs/architecture/adrs/0004-kanban-state-sync-and-streaming.md`
- `docs/architecture/adrs/0006-agent-integration-and-approvals.md`
- `docs/features/kanban-board.feature`
- `docs/features/task-orchestration.feature`

## Assets
- Task content (title, description, status, timestamps).
- Local task store (`localStorage`).
- Roadmap: device keys, wrapped data keys, auth tokens, audit logs, agent run artifacts, logs/diffs.

## Trust Boundaries
- Browser runtime ⇄ `localStorage` (same-origin boundary).
- Local UI ⇄ future sync/relay services.
- User devices ⇄ remote access plane (P2P/relay).
- UI ⇄ external agent runtimes.

## Threats and Mitigations

### Slice 0001 (Local-only)
| ID | Threat | Impact | Mitigations / Status |
| --- | --- | --- | --- |
| T-001 | Local data exposure on shared device/browser profile. | Task content readable by anyone with device access. | **Mitigated by scope**: local-only, no network sync. Document usage: treat device as trusted, no multi-user security in this slice. |
| T-002 | DOM injection / XSS from task input. | UI compromise, data exfil in future multi-user scope. | **Mitigated**: rendering uses `textContent`; no HTML injection. Keep rendering strictly text-based. |
| T-003 | Local storage tampering or corruption. | Tasks missing or mutated. | **Mitigated**: defensive parsing + normalization; invalid entries ignored. No integrity guarantees in this slice. |
| T-004 | Data loss from storage clearing or quota eviction. | Task history lost. | **Accepted**: no backup/sync in Slice 0001. Plan for sync/backup in roadmap. |
| T-005 | Predictable IDs (Date + random) reused in future sync. | Possible collision or tampering in multi-device context. | **Accepted** for local-only. **Planned**: replace with UUIDv4 or ULID when sync is introduced. |

### Roadmap (Remote access, sync, agents, streaming)
| ID | Threat | Impact | Mitigations / Status |
| --- | --- | --- | --- |
| R-001 | Stolen/over-scoped auth tokens enable remote control. | Unauthorized agent runs, data access. | **Planned**: scoped bearer tokens, short TTLs, rotation, revocation, device-bound sessions (ADR-0003). |
| R-002 | MITM or relay compromise of remote access traffic. | Command injection or data leakage. | **Planned**: E2E encryption for all control/data messages; mutual key exchange; relay forwards ciphertext only (ADR-0003, ADR-0001). |
| R-003 | Key compromise or loss. | Data exposure or permanent data loss. | **Planned**: per-entity data keys, key wrapping, rotation, secure local storage, recovery workflow (ADR-0001). |
| R-004 | Unauthorized device enrollment. | Persistent attacker access. | **Planned**: QR pairing with user presence, ephemeral keys, encrypted response payloads (ADR-0002). |
| R-005 | Event stream replay/ordering attacks. | Inconsistent state, hidden task changes. | **Planned**: ordered, idempotent patch streams; bounded history; snapshot refresh on reconnect; sequence validation (ADR-0004). |
| R-006 | Agent execution overreach (dangerous actions). | Destructive changes, data exfil. | **Planned**: capability declarations, approval gates, isolated workspaces, audit trail (ADR-0006). |
| R-007 | Sensitive data leakage in logs/diffs. | Secrets exposed to unauthorized viewers. | **Planned**: log redaction, access controls per workspace/user, classification of sensitive fields. |
| R-008 | DoS on relay or streaming channels. | Service disruption, lost visibility. | **Planned**: rate limits, bounded channels, stats-only fallback for large streams (ADR-0004). |

## Assumptions
- Slice 0001 runs as a static, local-only web app with no backend or multi-user sync.
- The user device/browser profile is trusted for Slice 0001; no secure multi-user isolation is provided.
- Task content may be sensitive; users should avoid storing secrets until E2E encryption and access controls exist.
- Future slices will introduce authenticated services and remote access per ADRs.

## Open Security Work (Next)
- Define key management UX (backup, recovery, rotation).
- Establish authZ model (workspace/user/device scoping) and token lifecycle.
- Add log redaction rules and sensitive-field classification.
- Formalize secure coding and dependency scanning once third-party deps exist.
