# Themes

Theme strategy for light and dark modes with accessibility and agent-state clarity.

## Theme model
- Two primary modes: Light and Dark.
- Token-driven mapping: components use semantic tokens only.
- High-contrast variant available for accessibility.

## Light theme characteristics
- Cool-neutral canvas with crisp white panels.
- Strong text contrast for dense task content.
- Brand blue as primary action and focus.

## Dark theme characteristics
- Deep neutral canvas with lifted panels.
- Softer borders and subtle shadows.
- Brand blue remains high-contrast for focus and primary actions.

## Status color mapping for agent states (required)
- Pending: neutral gray with hollow status dot.
- Running: info blue with pulsing dot.
- Awaiting-approval: amber with attention ring.
- Approved: green with check icon.
- Rejected: red with cross icon.
- Completed: green with solid dot.
- Failed: red with solid dot and error banner.

## Accessibility guidelines
- Minimum contrast: 4.5:1 for body text, 3:1 for large text and UI icons.
- Do not rely on color alone; always pair color with label or icon.
- Focus ring uses brand.primary and is visible on all surfaces.
- Motion-reduced mode disables pulses and shimmer.

## Semantic theming rules
- Surfaces: `surface.canvas` for app background, `surface.panel` for cards.
- Emphasis: `surface.subtle` for secondary containers, `surface.elevated` for overlays.
- Text: `text.primary` for main content, `text.secondary` for metadata.
- Borders: `border.default` for standard lines, `border.strong` for active frames.

## Real-time feedback
- Running agents show pulse and animated dot.
- New logs briefly highlight then settle to normal text.
- Pending approvals use a soft glow to pull attention.

