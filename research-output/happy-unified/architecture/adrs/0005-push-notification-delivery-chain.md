# Push Notification Delivery Chain (CLI → Server → Mobile)

## Status
Accepted

## Context
Users need to be notified of session completion or permission requests even when the mobile app is not actively connected. Notifications must be delivered without exposing plaintext content to the server.

## Decision
Use the server as a push-token registry and allow CLI-initiated delivery:
- The mobile app registers its push token with the server using authenticated HTTP requests.
- The CLI fetches the user’s registered tokens from the server when it needs to notify.
- The CLI sends push messages to the notification provider using those tokens, including minimal metadata or encrypted payloads as needed.
- The server does not process notification content; it only stores tokens and enforces access control.

## Consequences
- Push delivery works even when real-time channels are offline.
- The server remains content-blind; notification payloads can be encrypted end-to-end.
- The CLI must handle token retrieval, provider errors, and retry logic.
- Token lifecycle management (registration, removal, rotation) becomes a cross-device responsibility.

