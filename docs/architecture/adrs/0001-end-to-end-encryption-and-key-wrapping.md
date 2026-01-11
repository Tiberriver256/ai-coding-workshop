# End-to-End Encryption and Key Wrapping

Status: Accepted

## Context
The unified product synchronizes sensitive task data, agent state, and artifacts across devices while enabling remote access. The service must route and store data without access to plaintext, and multiple devices must independently decrypt the same entities.

## Decision
Use client-owned end-to-end encryption with per-entity data keys and recipient key wrapping:
- Each user maintains a content key pair derived from a master secret; data keys are generated per task/session/machine.
- Clients encrypt payloads locally and attach a wrapped data key for each authorized recipient device.
- The service stores and relays only ciphertext and wrapped keys, never plaintext or raw key material.
- Key envelopes are versioned to support rotation and forward compatibility.

## Consequences
- The service remains zero-knowledge; data exposure on the service does not reveal user content.
- Key distribution and rotation add onboarding and recovery complexity.
- Loss of the user master secret prevents decryption of historical data.
