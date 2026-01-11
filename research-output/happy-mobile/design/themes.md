# Themes

## Theme model
- Two primary themes: Light and Dark
- Theme preference supports fixed (light/dark) or adaptive (follow system)
- Theming is token-driven; components reference semantic tokens rather than raw colors

## Light theme characteristics
- High-contrast text on white surfaces
- Subtle neutral dividers and pressed overlays
- Primary actions are dark-filled pills with white text
- Status colors are saturated (success green, warning orange, error red)

## Dark theme characteristics
- Near-black surfaces with white text
- Softer neutral borders and pressed overlays
- Primary action remains dark-filled for consistency (with white text)
- Status colors remain vivid but slightly adjusted for contrast

## Theme token mapping (examples)
- surface.base: Light #FFFFFF → Dark #18171C
- surface.high: Light #F8F8F8 → Dark #2C2C2E
- text.primary: Light #000000 → Dark #FFFFFF
- text.secondary: Light #8E8E93 → Dark #8E8E93 / #CAC4D0
- divider: Light #EAEAEA → Dark #38383A
- primary.fill: #000000 (both)
- primary.text-on: #FFFFFF (both)

## Theming behaviors
- Icons and illustrations tint to primary/secondary text colors
- Message bubbles invert tone relative to the background
- Status indicators preserve hue but shift brightness for accessibility
- Scrollbars and overlays adapt to surface and divider tokens

## Theme variants
- Design assets include higher-contrast variants; not all are surfaced in UI
- Default experience prioritizes readability with soft borders and minimal shadows
