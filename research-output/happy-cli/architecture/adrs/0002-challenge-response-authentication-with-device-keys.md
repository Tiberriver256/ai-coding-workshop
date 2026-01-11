# Challenge-Response Authentication with Device Keys

## Status
Accepted

## Context
The CLI must authenticate to the server without repeatedly prompting for credentials and without sending reusable secrets over the network. Mobile onboarding also requires a secure bootstrap path that can bind a device to a user account.

## Decision
Use a device-generated keypair/secret to perform a challenge-response authentication flow. The client signs a server-provided challenge, the server verifies the signature, and issues a bearer token for subsequent API calls. Store the token and device key material locally and allow regeneration to rotate credentials when needed.

## Consequences
- Avoids password-based flows and replay attacks on static secrets.
- Requires secure local storage and key rotation procedures.
- Loss or compromise of the device key necessitates re-authentication and server-side revocation.
