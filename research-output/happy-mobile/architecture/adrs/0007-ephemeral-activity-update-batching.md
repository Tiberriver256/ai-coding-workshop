# Ephemeral Activity Updates With Debounced Batching

## Status
Accepted

## Context
Presence and activity signals (online status, thinking state) change frequently and can generate high update volume. Treating these signals like durable updates increases network and processing overhead.

## Decision
Send presence/activity as ephemeral updates on a dedicated channel. Accumulate updates per session, emit significant changes immediately, and debounce minor timestamp-only changes into batched updates. Do not persist ephemeral updates; they only update current UI state.

## Consequences
- Reduces update churn and bandwidth for high-frequency signals.
- Keeps durable update stream stable and replayable.
- Introduces small delays for non-critical activity updates.
- Requires separate handling paths for ephemeral vs durable data.
