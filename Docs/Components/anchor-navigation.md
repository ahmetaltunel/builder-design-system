# Anchor navigation

Anchor navigation is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use anchor navigation when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping anchor navigation inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Hierarchical items
- Selection affordance
- Optional counters or icons
- Keyboard-friendly focus order

## Variants

- Default
- Compact
- Expanded
- Disabled where applicable

## States

- Normal
- Hover
- Focused
- Selected
- Disabled
- Read-only when applicable

## Density Behavior

Density adjusts row heights, panel padding, and toolbar height without changing the core shell proportions.

## Accessibility

- Visible focus treatment must use the system focus token rather than a local highlight.
- VoiceOver labels should prefer the catalog name plus current value or state.
- Text and icons must keep contrast in both light and dark themes.

## Accessibility Acceptance

- Semantics: Pass
- Keyboard: Pass
- Contrast: Pass
- Motion: Pass
- Messaging: Pass

## Content Guidance

- Prefer direct labels and short supporting text.
- Keep action labels verb-led and specific.
- Use calm, operational language that matches a desktop work environment.

### Action labels

- Prefer direct labels that describe the user outcome for anchor navigation rather than implementation jargon.
- Use verb-led labels when anchor navigation performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what anchor navigation affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific anchor navigation state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked anchor navigation and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of anchor navigation with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when anchor navigation can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If anchor navigation can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving anchor navigation should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in anchor navigation labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main anchor navigation concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If anchor navigation presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `bg.sidebar`
- `bg.workspace`
- `surface.grouped`
- `border.subtle`
- `radius.large`
- `SpacingToken.toolbarHeight`

## Platform Notes

- Align with macOS desktop expectations: dense navigation, precise selection affordances, and restrained window-like framing.

## Do

- Do keep anchor navigation compact and structural so the workspace remains primary.
- Do use subdued backgrounds and rounded selection treatment instead of loud fills.

## Don't

- Don't turn anchor navigation into a marketing-style hero surface.
- Don't add extra shadows or gradients just to create emphasis.

## SwiftUI Example

**Anchor navigation example**  
Canonical compiled example for Anchor navigation. Use Anchor navigation when hierarchy, current location, and keyboard travel need to stay aligned.

```swift
// Canonical example for Anchor navigation
let environment = DesignSystemEnvironment.preview(.dark)

AnchorNavigation(environment: environment, items: [
    .init(title: "Overview", anchor: "overview"),
    .init(title: "Tokens", anchor: "tokens"),
    .init(title: "Accessibility", anchor: "accessibility")
])
```
