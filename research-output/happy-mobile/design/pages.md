# Pages

All distinct screens, grouped by feature area. Each entry lists purpose and key elements. Responsive notes included where relevant.

## Onboarding & authentication
- Welcome / Not Authenticated
  - Purpose: entry point for new or returning users
  - Key elements: logo, title, subtitle, primary CTA (create account), secondary CTA (restore/link)
  - Responsive: portrait center stack; landscape two-column layout
- Restore (QR)
  - Purpose: link an existing account from another device
  - Key elements: step list, QR code, loading indicator, fallback button to manual restore
- Restore (Manual)
  - Purpose: restore via secret key
  - Key elements: multiline key input, primary/secondary actions

## Core sessions
- Sessions List (main tab)
  - Purpose: browse and resume sessions
  - Key elements: active sessions group, project/session sections, swipe delete, status dots
  - Responsive: tablet shows split view and compact groups
- Session Detail (chat)
  - Purpose: live conversation with agent
  - Key elements: header (title, subtitle, avatar), message thread, tool cards, composer
- Session Info
  - Purpose: session metadata and status
  - Key elements: status indicators, session details, actions
- Session Files
  - Purpose: browse files associated with a session
  - Key elements: file list, status badges
- File Detail / Diff View
  - Purpose: inspect file content or changes
  - Key elements: code block, diff colors, line numbers
- Message Detail
  - Purpose: inspect a single message in detail
  - Key elements: message content, metadata
- Recent Sessions
  - Purpose: quick access to recently used sessions
  - Key elements: compact list, timestamps

## New session flow
- New Session
  - Purpose: compose a new session prompt
  - Key elements: prompt input, permission mode, agent selection, machine/path selectors
- Pick Machine
  - Purpose: select a target machine
  - Key elements: machine list, status indicators
- Pick Path
  - Purpose: select a working directory
  - Key elements: path list, recent paths, input field

## Inbox & social
- Inbox
  - Purpose: friend requests / messages / notifications
  - Key elements: feed list, status indicators
  - Responsive: tablet uses floating action button for add friend
- Friends List
  - Purpose: manage friends
  - Key elements: avatar rows, status
- Friend Search
  - Purpose: add new friends
  - Key elements: search input, results list

## Artifacts
- Artifacts List
  - Purpose: browse saved artifacts
  - Key elements: card list, metadata
- Artifact Detail
  - Purpose: read/view artifact content
  - Key elements: title, body, actions
- Artifact Create
  - Purpose: create a new artifact
  - Key elements: form fields, primary action
- Artifact Edit
  - Purpose: edit existing artifact
  - Key elements: editable content, save action

## Settings & account
- Settings Home
  - Purpose: manage account and preferences
  - Key elements: profile header card, grouped settings list
- Account Settings
  - Purpose: account details and device linking
  - Key elements: profile info, link new device, backup key
- Appearance
  - Purpose: theme controls
  - Key elements: light/dark/adaptive options
- Usage
  - Purpose: usage metrics
  - Key elements: charts/bars, totals
- Voice
  - Purpose: voice assistant settings
  - Key elements: toggles, status text
- Voice Language
  - Purpose: language selection for voice
  - Key elements: list of languages
- Features / Experiments
  - Purpose: opt-in feature toggles
  - Key elements: switches
- Language
  - Purpose: app language
  - Key elements: language list
- Connect Service (Claude)
  - Purpose: OAuth sign-in for external service
  - Key elements: webview, loading overlays
- Server Settings
  - Purpose: custom server configuration
  - Key elements: input fields, status
- Changelog / What’s New
  - Purpose: release notes
  - Key elements: list of updates
- Machine Detail
  - Purpose: manage a specific machine
  - Key elements: status, recent sessions, path input, actions
- User Profile
  - Purpose: view another user
  - Key elements: avatar, name, badges, actions

## Terminal
- Terminal Connection (deep link)
  - Purpose: confirm terminal link request
  - Key elements: warning/info header, connection details, accept/reject
- Terminal Connect (manual)
  - Purpose: manual entry for connection URL
  - Key elements: input, confirm action

## Experimental / internal
- Zen (index / new / view)
  - Purpose: experimental focus/notes experience
  - Key elements: list, detail, creation
- Developer / Diagnostics screens
  - Purpose: internal demos (colors, typography, inputs, logs)
  - Key elements: component showcases and test utilities
- Text Selection
  - Purpose: internal text selection test
  - Key elements: sample text blocks
