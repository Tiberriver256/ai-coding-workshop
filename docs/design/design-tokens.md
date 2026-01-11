# Design Tokens

Purpose: A token set for a kanban-first agent orchestration workspace with secure remote access, QR pairing, and coding-focused tooling. Tokens are semantic, tech-agnostic, and map to both web and mobile surfaces.

## Token principles
- Semantic over raw values (e.g., `text.primary`, `surface.panel`, `status.running`).
- UI and code tooling share a visual language but use specialized tokens for diffs/logs.
- Status communication is redundant: color + icon + text.
- Tokens support real-time updates with motion and emphasis states.

## Color system

### Brand
- brand.primary: #1F5EFF (signal blue for primary actions and focus)
- brand.primary-hover: #1B4FD6
- brand.primary-pressed: #163FAF
- brand.secondary: #1BC6A3 (mint accent for positive states and highlights)
- brand.signal: #FFB020 (attention highlight for approvals)
- text.on-brand: #FFFFFF

### Neutrals and surfaces
- surface.canvas: #F6F7FB (overall background)
- surface.panel: #FFFFFF (primary cards and columns)
- surface.subtle: #EEF1F6 (panels within panels)
- surface.elevated: #FFFFFF (modals, menus)
- surface.inverse: #0E1117 (dark surface for code/terminal)
- border.default: #D6DBE6
- border.strong: #C2C9D8
- divider: #E5E8F0

### Text
- text.primary: #0B0D12
- text.secondary: #4B5363
- text.muted: #707A8F
- text.inverse: #F7F9FC
- text.on-status: #FFFFFF

### Dark theme equivalents (surfaces, text, borders)
- surface.canvas: #0B0F16
- surface.panel: #121826
- surface.subtle: #1A2233
- surface.elevated: #1E273A
- surface.inverse: #F6F7FB
- border.default: #2A3447
- border.strong: #3A465E
- divider: #222B3D
- text.primary: #F3F6FC
- text.secondary: #C0C7D6
- text.muted: #8C96AD
- text.inverse: #0B0D12
- text.on-status: #0B0D12

### Semantic status
- status.success: #1EA672
- status.warning: #F0A500
- status.error: #E54545
- status.info: #2E7DFF
- status.neutral: #B8C0D4

### Agent state mapping (required)
- status.agent.pending: status.neutral
- status.agent.running: status.info
- status.agent.awaiting-approval: status.warning
- status.agent.approved: status.success
- status.agent.rejected: status.error
- status.agent.completed: status.success
- status.agent.failed: status.error

### Kanban column accents
- column.todo: #B8C0D4 (neutral)
- column.in-progress: #2E7DFF (info)
- column.in-review: #F0A500 (warning)
- column.done: #1EA672 (success)
- column.blocked: #E54545 (error)

### Controls
- control.background: #F2F4F8
- control.background-hover: #E9EDF5
- control.background-pressed: #DEE3EF
- control.border-focus: #1F5EFF
- control.placeholder: #8A93A8
- control.disabled: #C7CDDB

### Diff and review
- diff.added.bg: #E9FBF2
- diff.added.border: #1EA672
- diff.removed.bg: #FDECEC
- diff.removed.border: #E54545
- diff.modified.bg: #FFF4E0
- diff.modified.border: #F0A500
- diff.context.bg: #F3F5FA
- diff.hunk.text: #1F5EFF
- diff.comment.bg: #EEF6FF

### Logs and terminal
- terminal.bg: #0E1117
- terminal.text: #E6EDF7
- terminal.muted: #8C96A8
- terminal.info: #4DA3FF
- terminal.success: #2DD4BF
- terminal.warning: #FFC857
- terminal.error: #FF6B6B

### Overlays and feedback
- overlay.scrim: rgba(10, 13, 20, 0.55)
- toast.success.bg: #1EA672
- toast.error.bg: #E54545
- toast.info.bg: #2E7DFF
- toast.text: #FFFFFF

## Typography

### Font families
- primary.ui: "IBM Plex Sans" (fallback: "Inter", system sans)
- display: "Space Grotesk" (fallback: primary.ui)
- mono: "IBM Plex Mono" (fallback: "SF Mono", monospace)

### Type scale (px)
- t0: 11 (micro labels)
- t1: 12 (caption)
- t2: 14 (body)
- t3: 16 (body-lg)
- t4: 18 (subhead)
- t5: 20 (section title)
- t6: 24 (page title)
- t7: 30 (display)
- t8: 36 (hero)

### Weights
- regular: 400
- medium: 500
- semibold: 600
- bold: 700

## Spacing & sizing

### Spacing scale (px)
- s1: 2
- s2: 4
- s3: 8
- s4: 12
- s5: 16
- s6: 20
- s7: 24
- s8: 32
- s9: 40
- s10: 48
- s11: 64

### Component sizing
- control.height.sm: 28
- control.height.md: 36
- control.height.lg: 44
- avatar.size.sm: 24
- avatar.size.md: 32
- avatar.size.lg: 40
- icon.size.sm: 16
- icon.size.md: 20
- icon.size.lg: 24

## Radii and borders
- radius.xs: 4
- radius.sm: 6
- radius.md: 10
- radius.lg: 14
- radius.xl: 18
- radius.pill: 9999
- border.width: 1
- border.width.strong: 2

## Elevation
- elevation.1: subtle card lift
- elevation.2: menus and tooltips
- elevation.3: modals and drawers
- elevation.4: full-screen overlays

## Motion

### Durations
- motion.fast: 120ms
- motion.standard: 200ms
- motion.slow: 320ms
- motion.stream: 900ms (log pulse, running indicator)
- motion.shimmer: 1400ms (loading placeholders)

### Easing
- easing.standard: cubic-bezier(0.2, 0.0, 0.0, 1)
- easing.emphasized: cubic-bezier(0.2, 0.0, 0, 1)
- easing.linear: linear

### Real-time feedback patterns
- status.pulse: subtle scale/opacity loop for running agents
- log.newline: brief highlight fade on incoming log lines
- approval.attention: soft glow around pending approval panel

## Layout breakpoints (adaptive)
- compact: 0-599
- medium: 600-1023
- wide: 1024-1439
- ultra: 1440+

## Data density modes
- density.comfy: standard paddings, 44px targets
- density.compact: reduced padding for dense logs and tables
