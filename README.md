# Builder Design System

Builder Design System is a macOS-first SwiftUI design system for calm, utility-focused builder tools.
The showcase app demonstrates and validates the system, but the design system itself owns the tokens, contracts, and reusable components.

[Get started](#get-started) | [Foundations](Docs/Foundations/README.md) | [Components](Docs/Components/README.md) | [Patterns](Docs/Patterns/README.md) | [Showcase](Docs/Showcase/Guide.md)

## Why Builder Design System

- Native macOS-first SwiftUI surfaces calibrated for dense, readable builder workflows.
- Semantic tokens and a theme runtime keep light and dark appearance, materials, motion, and density aligned.
- Reusable components are documented through canonical examples and generated references instead of ad hoc demos.
- Accessibility, density behavior, and design-system maturity are treated as part of the quality bar.

Builder Design System is a design system package plus a native showcase app. It is not a demo-first app or a thin styling layer owned by showcase code. If a visual or behavioral rule matters, it should live in the system first and then be exercised by the showcase.

## Get Started

Start by evaluating the package locally and exploring it through the showcase app.

Build everything, regenerate artifacts, and run the full test suite:

```bash
Scripts/validate-design-system.sh
```

Launch the showcase app:

```bash
swift run BuilderShowcase
```

Import the public package product:

```swift
import BuilderDesignSystem
```

`BuilderDesignSystem` is the stable consumer entrypoint. Inside this repository, `BuilderFoundation` and `BuilderComponents` remain internal module boundaries that support the public package.

This README intentionally focuses on local evaluation and repository-based exploration. A Swift Package Manager dependency snippet is not listed here because the canonical GitHub package URL and tagged install flow are not published in this repository yet.

## Explore The System

### Learn the system

- [Design System Handbook](Docs/System/Handbook.md) - Source-of-truth overview of system intent, architecture, visual calibration, and public contracts.
- [Foundations](Docs/Foundations/README.md) - Generated reference for colors, typography, materials, spacing, motion, theming, and related foundation topics.
- [Content Guidelines](Docs/System/ContentGuidelines.md) - Writing guidance for labels, validation, status messages, announcements, and calm product copy.

### Use components

- [Components](Docs/Components/README.md) - Generated component reference with usage guidance, anatomy, states, accessibility notes, and SwiftUI examples.
- [Patterns](Docs/Patterns/README.md) - Reusable composition guidance for common workflows such as navigation, feedback, onboarding, and density settings.
- [Token Reference](Docs/System/TokenReference.md) - Machine-aligned token counts and exported token values derived from the design token manifest.

### Inspect behavior

- [Showcase Guide](Docs/Showcase/Guide.md) - Route-by-route guide for validating visuals, density, accessibility, and composed behavior in the macOS showcase app.


## Architecture

| Layer | Responsibility |
| --- | --- |
| `BuilderFoundation` | Owns semantic tokens, theme resolution, visual modes, density, materials, motion, shadows, icons, and grid contracts. |
| `BuilderComponents` | Owns reusable SwiftUI surfaces, controls, navigation, forms, feedback, and content primitives. |
| `BuilderDesignSystem` | Public umbrella product that external consumers import. |
| `BuilderReferenceExamples` | Canonical SwiftUI examples shared by generated docs and showcase previews. |
| `BuilderCatalog` | Structured metadata for foundations, components, patterns, and cross-reference content. |
| `BuilderShowcase` | Native macOS app that demonstrates, inspects, and validates the system without defining it. |
| `BuilderArtifactGenerator` | Regenerates tokens, exports, and reference docs from manifest and catalog sources. |

The design system defines tokens, contracts, and reusable components. The showcase validates those contracts in real screens. Generated docs come from catalog metadata and canonical examples so the handbook, references, exports, and runtime stay aligned.

## Development Workflow

- Build from semantic tokens before adding view-local styling.
- Add or change reusable rules in `BuilderFoundation` or `BuilderComponents` before changing showcase code.
- Keep `BuilderCatalog` descriptive and `BuilderReferenceExamples` canonical so docs and previews share the same source material.
- Validate work in light and dark themes and across compact, default, and comfortable density modes.
- Run `Scripts/validate-design-system.sh` before review so generated artifacts, builds, and tests stay aligned.

## Status

Builder Design System is currently in `0.x` while the public surface and design-system maturity gates continue to evolve.
