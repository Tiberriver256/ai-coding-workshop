# User Flows

Key journeys captured from the product UI.

## Onboarding / authentication
1. Launch app
2. Welcome screen with logo + two CTAs
3. Choose:
   - Create account (auto-creates credentials)
   - Restore/link (QR)
4. Success → Main app (sessions tab)

## Restore via QR
1. Welcome → Restore
2. Instructions + QR displayed
3. User scans from another device
4. Auth completes → Main app
5. Optional: “Restore with secret key instead” → Manual restore

## Manual restore
1. Restore → Manual
2. Paste secret key
3. Submit → Auth success

## New session (core task)
1. Sessions tab → “New”
2. Enter prompt
3. Choose machine + path
4. Select session type (simple/worktree)
5. Adjust permission mode (optional)
6. Send → Session chat opens

## Session conversation
1. Session view opens with header + message list
2. User sends message via composer
3. Agent responds; tool cards appear in-thread
4. Permission requests show inline decision panel
5. User approves/denies → conversation continues

## Review files in session
1. Session view → Files
2. File list with status
3. File detail / diff view
4. Back to session or list

## Inbox (social)
1. Inbox tab
2. View friend requests / notifications
3. Accept/ignore or open details
4. Optional: search and add friends

## Terminal connection
1. Settings → “Connect terminal”
2. Scan QR or enter URL
3. Terminal deep link opens confirmation screen
4. Accept → link success; Reject → dismiss

## Account linking (new device)
1. Settings → Account
2. “Link new device”
3. QR shown on current device
4. Scan from target device
5. Auth success

## Settings adjustments
1. Settings tab
2. Select section (appearance, voice, usage, language)
3. Modify toggles or choose options
4. Changes persist and reflect immediately

## Artifacts
1. Artifacts list
2. Open detail or create new
3. Edit/save → returns to list

## Subscription
1. Settings → “Support us”
2. Paywall presented
3. Confirm purchase → status updates in settings
