# Quality Bar

This repository treats design-system maturity as more than a component count.

## Foundation quality bar

- Named semantic tokens exist.
- Tokens, exports, and token docs come from the same source.
- Light and dark themes both work.
- Shadow and motion-curve contracts exist as first-class tokens.
- Density implications are documented.
- Accessibility implications are documented.
- The foundation is visible in the app catalog.

## Component quality bar

- Anatomy, variants, states, and density behavior are documented.
- Accessibility, theming hooks, and engineering notes are documented.
- Do and don't guidance exists.
- Related patterns are linked.
- A canonical SwiftUI example exists.
- A preview is present in the catalog.
- Visual regression coverage exists for the applicable state matrix.

## Pattern quality bar

- Criteria and configurations exist.
- Required components are listed.
- General guidelines are explicit.
- Accessibility and motion rules are explicit.
- Design-language guardrails exist.
- A preview is present in the catalog.
- A reusable example scaffold exists.

## Repo quality bar

- Build passes.
- Tests pass.
- Generated docs, snippets, and token export match runtime tokens.
- Changelog is updated when maturity changes.
- Docs clearly separate the system from the showcase app.
- The showcase consumes shared tokens and contracts instead of redefining them locally.
- Governance artifacts exist and are enforced in review.
