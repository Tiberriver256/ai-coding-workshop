# Authentication and Authorization Across Components

## Status
Accepted

## Context
The ecosystem must authenticate devices without passwords, authorize access to HTTP and real-time channels, and support long-lived sessions across multiple clients. Authentication must also integrate with device pairing flows.

## Decision
Adopt a cryptographic challenge-response flow with bearer tokens:
- Devices generate a key pair and sign a server-provided challenge to obtain an authentication token.
- The server verifies signatures, upserts the user account, and issues a signed bearer token.
- All HTTP requests use the bearer token in the Authorization header; real-time connections include the token in the handshake.
- Real-time connections declare a scope (user, session, machine) and must provide the corresponding identifiers; the server rejects scoped connections missing required IDs.
- Token verification is cached server-side to optimize high-frequency socket usage, with explicit invalidation for revocation.

## Consequences
- Eliminates password storage and reduces replay risk.
- Requires secure local storage for tokens and device keys on clients.
- Cached token verification improves performance but complicates revocation.
- Authentication becomes a shared protocol used by both initial login and device-pairing flows.

