# Showcase Guide

BuilderShowcase is the native macOS app that consumes BuilderDesignSystem.

Its job is to help you inspect:

- shell fidelity
- light and dark theme parity
- density changes
- hit areas and focus behavior
- component states
- composed pattern behavior

It is not the source of truth for tokens, component contracts, or pattern definitions.

## Run the showcase

```bash
swift run BuilderShowcase
```

Verify the package first or after changes:

```bash
Scripts/validate-design-system.sh
```

Record or refresh visual baselines when the intended UI changes:

```bash
UPDATE_SNAPSHOTS=1 swift test --filter BuilderSnapshotTests
```

## Route guide

### Home

Use this first to understand the builder workflow and jump into the highest-value routes quickly.

### Foundations

Use this route to inspect visual specimens for color, typography, spacing, motion, materials, and structural rules, with token details in the inspector.

### Components

This is the main route for checking the reusable component surface. It now uses a browser + canvas + inspector model rather than stacked documentation panels.

The sidebar and browser columns use native macOS navigation containers from `BuilderComponents`, so arrow-key movement and selection come from the platform instead of custom event interception.

Use it to verify:

- disabled, loading, and read-only state behavior
- per-component usage guidance and related recipes
- tokens, variants, accessibility, and platform notes in the inspector
- the state exercise panel before treating a component as production-ready

### Recipes

Use this route to inspect scenario-driven compositions such as settings, data exploration, onboarding, and feedback loops.

### Lab

Use this route for free-form product-like composition. It is the best place to check:

- hit targets
- shell/layout composition
- grouped settings rows
- feedback and overlay surfaces
- light and dark parity

### Settings

Use this route to validate appearance, accessibility, and theme/token tooling from one place.

The settings menu includes:

- `Appearance`
- `Accessibility`
- `Theme & tokens`

## What to inspect first

1. Launch in dark mode and inspect the shell.
2. Switch to light mode and confirm secondary text remains readable.
3. Toggle compact, default, and comfortable density.
4. Open `Components` and test the live playground controls.
5. Open `Lab` and verify composition, hit targets, and grouped settings behavior.
6. Open `Settings` and inspect `Appearance`, `Accessibility`, and `Theme & tokens`.

## Ownership boundary

The showcase owns:

- route composition
- sample content
- manual inspection controls
- live consumption of shared examples

The showcase should not define:

- new tokens only used in a view
- component rules that exist only in showcase code
- one-off colors or radii
- product naming that leaks into the reusable system

## Source map

Showcase-oriented code lives in:

- `Sources/BuilderShowcase/App/`
- `Sources/BuilderShowcase/Features/`
- `Sources/BuilderShowcase/Shared/`

Shared runtime code comes from:

- `Sources/BuilderFoundation/`
- `Sources/BuilderComponents/`
- `Sources/BuilderDesignSystem/`

Catalog support comes from:

- `Sources/BuilderCatalog/`

Canonical example fixtures come from:

- `Sources/BuilderReferenceExamples/`
