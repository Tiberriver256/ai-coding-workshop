# End-to-End Encryption With Hierarchical Data Keys

## Status
Accepted

## Context
The system synchronizes sensitive code, messages, and metadata across devices. The server must not be able to read user content, yet the client must support multiple resource types (sessions, machines, artifacts) and efficient decryption at runtime.

## Decision
Use client-side end-to-end encryption. Derive a master secret on the client, then generate per-entity data encryption keys (e.g., per session, machine, artifact). Encrypt and store those data keys separately so the server only persists ciphertext. Decrypt content on the client using the appropriate entity key and cache decrypted results to reduce repeated cryptographic work.

## Consequences
- Server remains blind to user content; compromise of server storage does not expose plaintext.
- Key management complexity increases (key derivation, storage, and rotation concerns).
- Client CPU and memory usage increase due to encryption/decryption and cache management.
- Loss of the master secret prevents decryption of historical data.
