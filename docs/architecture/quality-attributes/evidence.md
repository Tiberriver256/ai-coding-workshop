# Quality Attribute Evidence (Slice 0001)

This note links the quality attribute scenarios to architectural evidence or rationale relevant to Slice 0001.

## Security
Evidence: Slice 0001 is local-first and single-writer, which constrains the security surface area while future slices add encrypted sync and remote control. The security scenarios are backed by decisions on end-to-end encryption, QR-based onboarding, scoped remote access, and approval-gated actions.
- Scenario links: `docs/architecture/quality-attributes/security.feature`
- Evidence sources: `docs/architecture/adrs/0001-end-to-end-encryption-and-key-wrapping.md`, `docs/architecture/adrs/0002-qr-device-pairing-handshake.md`, `docs/architecture/adrs/0003-secure-remote-access-via-p2p-and-relay.md`, `docs/architecture/adrs/0006-agent-integration-and-approvals.md`
- Slice 0001 rationale: local persistence with no remote access reduces exposure while encryption and scoped access are staged for later slices. (`docs/architecture/adrs/0007-slice-0001-local-task-creation-and-persistence.md`)

## Reliability
Evidence: Reliability scenarios are supported by ordered patch streaming with retention, idempotent external operations, and approval timeouts. Slice 0001 adds local persistence and input validation to avoid partial or corrupt state.
- Scenario links: `docs/architecture/quality-attributes/reliability.feature`
- Evidence sources: `docs/architecture/adrs/0004-kanban-state-sync-and-streaming.md`, `docs/architecture/adrs/0005-external-devops-integration-and-reconciliation.md`, `docs/architecture/adrs/0006-agent-integration-and-approvals.md`
- Slice 0001 rationale: deterministic task shape and write-through persistence provide consistent recovery on refresh. (`docs/architecture/adrs/0007-slice-0001-local-task-creation-and-persistence.md`)

## Performance
Evidence: Performance scenarios are supported by incremental patch delivery and bounded log/diff channels that keep interactive latency stable. Remote control uses direct sessions with relay fallback to minimize round trips when available.
- Scenario links: `docs/architecture/quality-attributes/performance.feature`
- Evidence sources: `docs/architecture/adrs/0003-secure-remote-access-via-p2p-and-relay.md`, `docs/architecture/adrs/0004-kanban-state-sync-and-streaming.md`
- Slice 0001 rationale: local storage eliminates network fetches for the initial create-and-refresh flow. (`docs/architecture/adrs/0007-slice-0001-local-task-creation-and-persistence.md`)

## Maintainability
Evidence: Maintainability relies on explicit protocols, versioned envelopes, and modular integration boundaries that let new capabilities evolve without breaking existing behavior. Slice 0001 keeps the domain model minimal and deterministic to ease future migrations.
- Evidence sources: `docs/architecture/adrs/0001-end-to-end-encryption-and-key-wrapping.md`, `docs/architecture/adrs/0002-qr-device-pairing-handshake.md`, `docs/architecture/adrs/0005-external-devops-integration-and-reconciliation.md`, `docs/architecture/adrs/0006-agent-integration-and-approvals.md`, `docs/architecture/adrs/0007-slice-0001-local-task-creation-and-persistence.md`
- Slice 0001 rationale: a single canonical task shape and validation at boundaries simplify evolution and reduce regression risk.
