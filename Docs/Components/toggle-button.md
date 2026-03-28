# Toggle button

Toggle button is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use toggle button when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping toggle button inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Selectable values
- Current selection state
- Group context
- Clear action when relevant

## Variants

- Default
- Selected
- Mixed or multi-select
- Disabled

## States

- Normal
- Hover
- Focused
- Selected
- Disabled
- Read-only when applicable

## Density Behavior

Density changes control height, label spacing, and supporting-text rhythm while preserving hit targets.

## Accessibility

- Visible focus treatment must use the system focus token rather than a local highlight.
- VoiceOver labels should prefer the catalog name plus current value or state.
- Text and icons must keep contrast in both light and dark themes.
- Keyboard navigation should preserve label-to-control relationships and clear error messaging.

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

- Prefer direct labels that describe the user outcome for toggle button rather than implementation jargon.
- Use verb-led labels when toggle button performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what toggle button affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific toggle button state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked toggle button and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of toggle button with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when toggle button can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If toggle button can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving toggle button should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in toggle button labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main toggle button concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If toggle button presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `surface.input`
- `text.primary`
- `text.secondary`
- `focus.ring`
- `radius.medium`
- `SpacingToken.rowGap`

## Platform Notes

- Favor desktop-ready control sizing, keyboard access, and right-aligned control placement where settings-style layouts call for it.

## Do

- Do pair labels, descriptions, and validation in a consistent row rhythm.
- Do preserve keyboard access and a visible focus treatment.

## Don't

- Don't rely on placeholder text as the primary label.
- Don't compress density so far that controls lose clarity.

## SwiftUI Example

**Toggle button example**  
Canonical compiled example for Toggle button. Use Toggle button when selection state must stay legible across dense product surfaces.

```swift
// Canonical example for Toggle button
let environment = DesignSystemEnvironment.preview(.dark)

ToggleButton(environment: environment, title: "Show inspector", isOn: $isEnabled)
```
