# End-to-End Encryption Protocol and Key Exchange

## Status
Accepted

## Context
The Happy ecosystem synchronizes sensitive session data, machine state, and artifacts across mobile, CLI, daemon, and server components. The server must route and persist data without access to plaintext, while multiple devices must independently decrypt and update the same entities. Key material must be exchanged securely during device pairing without exposing secrets to the server.

## Decision
Use client-owned end-to-end encryption with per-entity data keys and out-of-band key distribution:
- The mobile client derives a master secret and a content data key pair, and treats the public key as the recipient for data-key wrapping.
- During device pairing, the mobile client shares the content public key with the CLI via an encrypted QR response, enabling the CLI to wrap per-session and per-machine data keys for the mobile client.
- The CLI generates a fresh data key for each session and machine (legacy secret for older clients), encrypts payloads locally, and sends ciphertext plus an encrypted data key (`dataEncryptionKey`) to the server.
- The server stores only ciphertext and opaque encrypted data keys, and forwards them via HTTP APIs and real-time update events.
- Clients decrypt `dataEncryptionKey` locally to open the appropriate encryptor, then decrypt metadata, agent state, messages, and artifacts on-device.

## Consequences
- The server remains zero-knowledge; compromise of server storage does not expose plaintext.
- Key management and pairing complexity increases (device onboarding, recovery, rotation, and cache management).
- Loss of the user master secret or content key pair prevents decryption of historical data.
- Crypto version bytes in wrapped keys allow forward migration without breaking legacy clients.

