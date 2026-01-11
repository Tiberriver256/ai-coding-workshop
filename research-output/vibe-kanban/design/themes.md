# Themes - Vibe Kanban

## Light and dark mode strategy
- Theme is driven by shared semantic tokens with light and dark values.
- Surfaces shift from light neutral backgrounds to deep neutral panels.
- Text colors invert for legibility while keeping hierarchy (high, normal, low).
- Accent and semantic colors keep hue consistency across modes.

## Color customization approach
- Brand color is an orange hue used for focus, accents, and highlights.
- Focus ring and active states reference the brand token.
- Muted surfaces and borders adapt to the active theme for contrast.

## Board and lane color coding
- Column headers include a status dot and a faint tinted header background.
- Status colors map consistently across the UI (To Do = neutral, In Progress = info, In Review = warning, Done = success, Cancelled = error).
- Shared tasks add a colored edge strip to distinguish ownership.

## Accessibility considerations
- Contrast shifts between text-high, text-normal, and text-low for hierarchy.
- Focus indicators are visible across light and dark surfaces.
- Disabled states reduce opacity but remain legible.
