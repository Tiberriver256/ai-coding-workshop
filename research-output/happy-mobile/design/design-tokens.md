# Design Tokens (Happy Mobile)

This document captures the abstract, semantic tokens inferred from the UI. Values are expressed as human-readable design values (not code).

## Colors

### Core neutrals
- text.primary: Light #000000, Dark #FFFFFF
- text.secondary: Light #8E8E93 (alt neutral #49454F), Dark #8E8E93 (alt neutral #CAC4D0)
- surface.base: Light #FFFFFF, Dark #18171C (alt #212121)
- surface.high: Light #F8F8F8, Dark #2C2C2E (alt #171717)
- surface.highest: Light #F0F0F0, Dark #38383A (alt #292929)
- surface.selected: Light #C6C6C8, Dark #2C2C2E
- divider: Light #EAEAEA, Dark #38383A (alt #292929)
- shadow.color: #000000
- shadow.opacity: 0.10

### Brand / primary actions
- primary.fill: #000000
- primary.text-on: #FFFFFF
- primary.disabled: #C0C0C0
- primary.pressed: #1A1A1A

### Links / accents
- link: #2BACCC
- focus/connecting: Light #007AFF, Dark #0A84FF

### Semantic colors
- success: Light #34C759, Dark #32D74B
- warning: Light #FF9500, Dark #FF9F0A
- warning.text: Light #FF9500, Dark #FFAB00
- warning.background: Light #FFF8F0, Dark rgba(255,159,10,0.15)
- error: Light #FF3B30, Dark #FF453A
- error.text: Light #FF3B30, Dark #FF6B6B
- error.background: Light #FFF0F0, Dark rgba(255,69,58,0.15)
- info: Light #007AFF, Dark #0A84FF

### Status palette (connection + indicators)
- status.connected: #34C759
- status.connecting: Light #007AFF, Dark #FFFFFF
- status.disconnected: #999999 / #8E8E93
- status.error: #FF3B30 / #FF453A
- status.default: #8E8E93

### Input + selection
- input.background: Light #F5F5F5, Dark #1C1C1E (alt #303030)
- input.text: Light #000000, Dark #FFFFFF
- input.placeholder: #999999 / #8E8E93
- pressed.overlay: Light #D1D1D6, Dark #2C2C2E
- ripple.overlay: Light rgba(0,0,0,0.08), Dark rgba(255,255,255,0.08)

### Messaging
- user.message.background: Light #F0EEE6, Dark #2C2C2E
- user.message.text: Light #000000, Dark #FFFFFF
- agent.message.text: Light #000000, Dark #FFFFFF
- event.message.text: Light #666666, Dark #8E8E93

### Permission modes (chips/badges)
- default: #8E8E93
- accept-edits: Light #007AFF, Dark #0A84FF
- plan: Light #34C759, Dark #32D74B
- bypass / yolo: Light #FF9500 / #DC143C, Dark #FF9F0A / #FF453A
- read-only: #8B8B8D / #98989D
- safe-yolo: #FF6B35 / #FF7A4C

### Badges & counts
- badge.background: status.error
- badge.text: #FFFFFF

### Diff + code review palette (contextual)
- added.background: Light #E6FFED, Dark #0D2E1F
- added.border: Light #34D058, Dark #3FB950
- removed.background: Light #FFEEF0, Dark #3F1B23
- removed.border: Light #D73A49, Dark #F85149
- context.background: Light #F6F8FA, Dark #161B22
- hunk.header.text: Light #005CC5, Dark #58A6FF

### Syntax highlighting palette (contextual)
- keyword: Light #1D4ED8, Dark #569CD6
- string: Light #059669, Dark #CE9178
- comment: Light #6B7280, Dark #6A9955
- number: Light #0891B2, Dark #B5CEA8
- function: Light #9333EA, Dark #DCDCAA
- bracket.1: Light #FF6B6B, Dark #FFD700
- bracket.2: Light #4ECDC4, Dark #DA70D6
- bracket.3: Light #45B7D1, Dark #179FFF
- bracket.4: Light #F7B731, Dark #FF8C00
- bracket.5: Light #5F27CD, Dark #00FF00

### Terminal palette (contextual)
- terminal.background: #1E1E1E
- terminal.prompt: Light #34C759, Dark #32D74B
- terminal.text: #E0E0E0
- terminal.stderr: #FFB86C
- terminal.error: #FF5555 / #FF6B6B
- terminal.empty: #6272A4 / #7B7B93

## Typography

### Font families
- Primary (UI): IBM Plex Sans
- Monospace (code/keys): IBM Plex Mono
- Logo / display accent: Bricolage Grotesque Bold
- Legacy fallback: Space Mono

### Font weights
- Regular: 400
- Semibold: 600
- Bold: 700 (used sparingly)

### Type scale (approx.)
- micro: 10
- tiny: 11
- caption: 12
- small: 13
- body: 14
- body-lg: 16
- subhead: 17
- title: 20
- title-lg: 24
- display: 28
- display-xl: 34

### Line heights (typical)
- 12-14 size: 14-20
- 15-17 size: 20-24
- 20+ size: 24-40

## Spacing system

The UI uses a tight, 4-based spacing scale with occasional 6 and 10 steps.

- 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 32, 40, 48, 64

Common patterns
- List row padding: 16 horizontal, 12-16 vertical
- Section padding: 16-24 horizontal, 20-35 vertical
- Card padding: 12-16
- Small gaps: 4-8

## Radii

- hairline: 1
- xs: 3-4
- sm: 6
- md: 8
- lg: 10-12
- xl: 14-16
- 2xl: 20
- pill: 9999 (fully rounded)
- avatar: 50% (circle)

## Shadows / elevation

Shadows are subtle and used sparingly.

- elevation-1: 0px 0.3px 0px @ 10% (light cards, grouped lists)
- elevation-2: 0px 1px 2px @ 10-20% (avatars, small surfaces)
- elevation-3: 0px 2px 4px @ 10-20% (floating buttons, small overlays)
- elevation-4: 0px 2px 4px @ 20-25% (headers, modals)
- elevation-5: 0px 20px 40px @ 25% (command palette / large overlay)

## Motion / timing

- quick fade / scale: 150-200ms
- standard UI transitions: 200-300ms
- pulse (status): 1000ms
- shimmer: 1500ms
- voice bars: 300-400ms loops with staggered delays (100-200ms)
- easing: mostly linear for shimmer and pulses; spring for focus/scale

## Breakpoints (layout density)
- xs: 0
- sm: 300
- md: 500
- lg: 800
- xl: 1200
