# End-to-End Encryption for Session and Machine Data

## Status
Accepted

## Context
The CLI exchanges session metadata, agent state, and live messages with a remote server for mobile control. This data can include sensitive source code, prompts, and tool outputs. The server should not be able to read user content while still enabling routing, storage, and fan-out to authorized devices.

## Decision
Encrypt all session and machine payloads on the client before transmission. Use per-session or per-machine data keys for content encryption and store only ciphertext on the server. When rotating or provisioning a new data key, wrap (encrypt) the data key with a device public key so only authorized clients can decrypt it. Maintain an encryption version/variant marker in payloads to support forward migration.

## Consequences
- Server-side storage and routing can operate without access to plaintext content.
- Key management becomes critical; loss of local keys means loss of data access.
- Adds CPU overhead and payload size increases due to encryption and encoding.
- Requires versioning and migration strategy for future crypto changes.
