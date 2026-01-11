# Design Tokens - Vibe Kanban

This is a tech-agnostic extraction of the design tokens used by the app. Values are expressed in rem or HSL where they are explicitly defined.

## Color palette

### Neutrals and surfaces
Light mode (HSL):
- surface.background: 0 0% 95%
- surface.primary: 0 0% 100%
- surface.secondary: 0 0% 95%
- surface.panel: 0 0% 89%
- surface.muted: 0 0% 89%
- surface.accent: 0 0% 92%
- border.default: 0 0% 85%
- input.background: 0 0% 96%

Dark mode (HSL):
- surface.background: 0 0% 13%
- surface.primary: 0 0% 13%
- surface.secondary: 0 0% 11%
- surface.panel: 0 0% 16%
- surface.muted: 0 0% 16%
- surface.accent: 0 0% 20%
- border.default: 0 0% 20%
- input.background: 0 0% 20%

### Text
Light mode (HSL):
- text.high: 0 0% 5%
- text.normal: 0 0% 20%
- text.low: 0 0% 39%

Dark mode (HSL):
- text.high: 0 0% 96%
- text.normal: 0 0% 77%
- text.low: 0 0% 56%

### Brand and emphasis
Shared across light/dark (HSL):
- brand.primary: 25 82% 54%
- brand.hover: 25 75% 62%
- brand.secondary: 25 82% 37%
- text.onBrand: 0 0% 100%

### Semantic status colors
Shared across light/dark (HSL):
- status.success: 117 38% 50%
- status.warning: 32 95% 44%
- status.info: 217 91% 60%
- status.error: 0 59% 57%
- status.neutral: 0 0% 92% (light) / 0 0% 20% (dark)

Foreground partners (HSL):
- status.success.foreground: 117 38% 20% (light) / 117 38% 90% (dark)
- status.warning.foreground: 32 95% 14% (light) / 32.2 95% 90% (dark)
- status.info.foreground: 0 0% 5% (light) / 217.2 91.2% 90% (dark)
- status.neutral.foreground: 0 0% 5% (light) / 0 0% 90% (dark)

### Kanban status mapping
- To Do: neutral
- In Progress: info (blue)
- In Review: warning (orange)
- Done: success (green)
- Cancelled: error (red)

### Code/console accents (used in logs and diffs)
- console.background: 0 0% 100% (light) / 0 0% 0% (dark)
- console.foreground: 0 0% 5% (light) / 210 40% 98% (dark)
- console.success: 117 38% 50% (light) / 138.5 76.5% 47.7% (dark)
- console.error: 0 59% 57% (light) / 0 84.2% 60.2% (dark)

Syntax highlight accents are defined for keyword, function, constant, string, variable, comment, tag, punctuation, and deleted tokens.

## Typography

### Font families
- Sans serif: IBM Plex Sans (primary UI)
- Monospace: IBM Plex Mono (code, logs, URLs)
- Emoji fallback: Noto Emoji

### Type scale (rem)
- 2xs: 0.5rem
- xs: 0.75rem
- sm: 0.875rem
- base: 1rem
- lg: 1.125rem
- xl: 1.25rem

Line-height is typically 1.5x size for body and 1.0x for compact CTA text.

### Font weights
- Light: used for task card titles
- Regular: default body
- Medium: labels and controls
- Semibold: section titles
- Bold: page titles and primary emphasis

## Spacing system

The UI uses a tight 4px-based rhythm and common multiples.

### Core spacing tokens (rem)
- space.1: 0.25rem
- space.2: 0.5rem
- space.3: 0.75rem
- space.4: 1rem
- space.6: 1.5rem
- space.8: 2rem
- space.12: 3rem
- space.16: 4rem

### Named micro tokens (rem)
- space.half: 0.25rem
- space.base: 0.5rem
- space.plusfifty: 0.75rem
- space.double: 1rem

## Borders, radius, and elevation

### Border widths
- default border: 1px solid
- emphasized or dashed borders used for section separators and card headers

### Radius
- radius.base: 0.125rem (tight rounding)
- radius.sm: 0.1875rem
- radius.md: 0.21875rem
- radius.lg: 0.28125rem
- radius.full: 9999px (avatars and pills)

### Shadows and elevation
- elevation.1: subtle shadow (small handles, toggles)
- elevation.2: medium shadow (menus, tooltips, selects)
- elevation.3: large shadow (dialogs, overlays)

## Motion and timing

### Durations
- fast: 200ms (color transitions, accordion)
- medium: 300ms (panel fade/resize transitions)
- long: 1400ms (running status dots)
- loop: 2000ms (pill fade, animated border)

### Easing
- ease-out for accordion open/close
- ease-in-out for pill fade
- linear for looping animated borders

### Patterns
- fade + zoom + slide for overlays (menus, tooltips)
- subtle looping dot animation for running states
- animated gradient border for active chat/process state
