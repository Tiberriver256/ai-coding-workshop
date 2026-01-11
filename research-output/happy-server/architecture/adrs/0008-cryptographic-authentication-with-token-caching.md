# Title
Cryptographic Authentication with Token Caching

# Status
Accepted

# Context
The system needs strong authentication without storing passwords and must support device-to-device authorization workflows. Repeated token verification should be efficient for real-time connections.

# Decision
Authenticate users via cryptographic signatures on client-provided challenges, then issue signed tokens for subsequent requests. Cache verified tokens in memory to avoid repeated verification on high-frequency calls (e.g., WebSocket connections). Use short-lived tokens for sensitive flows such as OAuth state.

# Consequences
- No password storage is required, reducing breach impact.
- Authentication is fast for long-lived connections due to token caching.
- Token revocation is limited to cache invalidation, which must be handled explicitly when needed.
