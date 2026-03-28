# Tree view

Tree view is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use tree view when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping tree view inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Header or label
- Primary content region
- Supporting metadata
- Optional action cluster

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

Density affects rows, metadata spacing, and pagination rhythm while maintaining scanability.

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

- Prefer direct labels that describe the user outcome for tree view rather than implementation jargon.
- Use verb-led labels when tree view performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what tree view affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific tree view state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked tree view and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of tree view with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when tree view can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If tree view can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving tree view should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in tree view labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main tree view concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If tree view presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `surface.grouped`
- `surface.raised`
- `text.primary`
- `text.secondary`
- `chart.blue`
- `chart.teal`

## Platform Notes

- Preserve the macOS desktop tone by keeping interactions direct, low-chrome, and fast.

## Do

- Do let spacing and hierarchy communicate structure before adding more containers.
- Do keep the component visually tied to the calibrated shell.

## Don't

- Don't wrap tree view in redundant cards.
- Don't drift away from the calibrated neutral palette.

## SwiftUI Example

**Tree view example**  
Canonical compiled example for Tree view. Use Tree view to organize content before reaching for bespoke layout or decorative chrome.

```swift
// Canonical example for Tree view
let environment = DesignSystemEnvironment.preview(.dark)

TreeView(environment: environment, nodes: [
    .init(id: "foundations", title: "Foundations", children: [.init(id: "color", title: "Color"), .init(id: "motion", title: "Motion")]),
    .init(id: "components", title: "Components")
], selection: $selection)
```
