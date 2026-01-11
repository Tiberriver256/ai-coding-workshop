# Title
Zero-Knowledge Encrypted Payload Storage

# Status
Accepted

# Context
The system syncs sensitive user content across devices. The service must provide synchronization and storage without having access to plaintext content. Data is stored and transmitted between clients while preserving privacy guarantees and limiting server liability.

# Decision
Store user content as opaque encrypted blobs and treat encryption keys as client-owned. The server accepts encrypted payloads and persists them without attempting to decrypt or interpret their contents. Metadata fields that are intended for client consumption are stored as strings/bytes and carried through the API and real-time update streams as opaque values.

# Consequences
- The server cannot provide server-side search, moderation, or content-based features without client cooperation.
- Operational risks are reduced because plaintext data never exists on the server.
- Clients must handle encryption/decryption and key management, increasing client complexity.
- Troubleshooting must rely on metadata and event traces rather than content inspection.
