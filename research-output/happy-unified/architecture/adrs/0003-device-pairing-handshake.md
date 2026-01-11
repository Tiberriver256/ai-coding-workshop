# Device Pairing Handshake (QR + Challenge Response)

## Status
Accepted

## Context
The CLI must be linked to a user account and obtain encryption material without prompting for passwords or exposing secrets to the server. Pairing must be simple for users and resilient across multiple devices.

## Decision
Implement an out-of-band QR-based pairing handshake:
- The CLI generates an ephemeral public/private key pair and registers the public key with the server as a pending auth request.
- The CLI displays a QR code containing a pairing URL with the public key.
- The mobile client scans the QR, encrypts a response payload to the CLI’s public key, and submits the response to the server using an authenticated API call.
- The response payload supports multiple versions: legacy secret material for older clients and a versioned bundle that includes the content public key used for data-key wrapping.
- The CLI polls the pending auth request endpoint, receives the encrypted response, decrypts it locally, and stores the resulting credentials.

## Consequences
- Pairing requires user presence (QR scan) and never transmits secrets in plaintext.
- The server only relays encrypted responses and never sees device secrets.
- The handshake adds polling and version negotiation complexity but supports backward compatibility.
- Pairing also becomes the distribution channel for content public keys, enabling future device synchronization.

