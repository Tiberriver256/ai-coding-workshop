# Feature-Sliced Guidance

## Purpose
Use Feature-Sliced Design (FSD) to keep UI code discoverable and consistent. These rules focus on naming and folder structure.

## FSD roots in this repo
- The linter auto-detects FSD roots by looking for directories that contain at least two FSD layer folders.
- To target specific roots, set `FSD_ROOTS` to a comma-separated list of paths (repo-relative).
- When new frontend packages adopt FSD, list their roots here.

## Layers (top-level folders inside an FSD root)
- Allowed layer names: `app`, `pages`, `widgets`, `features`, `entities`, `shared`, `processes` (deprecated).
- Layer folder names are lowercase; do not invent new layer names.
- Use only the layers you need.
- `app` and `shared` contain segments directly (no slices).
- All other layers contain slices (business-domain folders).

Example:
```text
src/
  app/
  pages/
  widgets/
  features/
  entities/
  shared/
```

## Slices
- Slice folder names are kebab-case and reflect business domain concepts (e.g., `user-profile`, `billing-settings`).
- Avoid technical or role-based names like `components` or `hooks` for slices.
- Each slice has a public API file: `index.ts`, `index.tsx`, `index.js`, `index.jsx`, `index.mjs`, or `index.cjs`.
- Slice groups are allowed: a folder under a layer may contain only slice folders and no shared code files.

Example:
```text
features/
  billing/
    index.ts
    ui/
    model/
```

## Segments
- Standard segments: `ui`, `api`, `model`, `lib`, `config`.
- Custom segments are allowed, but names must be kebab-case and purpose-driven.
- Do not use segment names like `components`, `hooks`, or `types`.
- Segments live directly inside a slice (or directly inside `app`/`shared`).

Example:
```text
shared/
  ui/
    index.ts
  api/
    index.ts
```

## Cross-imports (`@x`)
- Only use `@x` inside `entities` slices.
- Path pattern: `entities/<slice>/@x/<other-slice>.ts`.

## Linting
Run the linter:
```bash
scripts/check-feature-sliced.sh
```

Target specific roots:
```bash
FSD_ROOTS=app/src,packages/web/src scripts/check-feature-sliced.sh
```
