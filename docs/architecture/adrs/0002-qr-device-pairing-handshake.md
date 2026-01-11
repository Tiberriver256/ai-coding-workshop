# QR Device Pairing Handshake for Onboarding

Status: Accepted

## Context
New CLIs, agents, and remote devices must be onboarded without passwords while securely receiving encryption material and access credentials. The service must not learn secrets during onboarding.

## Decision
Use an out-of-band QR-based pairing handshake:
- The device requesting access generates an ephemeral key pair and registers a pending pairing request.
- The user scans a QR code containing the pairing request identifier and public key.
- An already-authenticated device encrypts a response to the ephemeral public key and submits it to the service.
- The response includes access credentials and any content public keys needed for key wrapping.
- The requesting device retrieves and decrypts the response locally, completing onboarding.

## Consequences
- Pairing requires user presence and a trusted device, preventing silent enrollment.
- The service only relays encrypted responses and never sees plaintext credentials.
- Versioned response formats allow interoperability as protocols evolve.
