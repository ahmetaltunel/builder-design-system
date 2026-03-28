# Loading bar

Loading bar is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use loading bar when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping loading bar inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Semantic status cue
- Primary label
- Supporting detail
- Dismiss or follow-up action

## Variants

- Info
- Success
- Warning
- Error

## States

- Normal
- Dismissed
- Inline action hover
- Persistent banner

## Density Behavior

Density tightens banner padding and overlay chrome while keeping status hierarchy readable.

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

- Prefer direct labels that describe the user outcome for loading bar rather than implementation jargon.
- Use verb-led labels when loading bar performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what loading bar affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific loading bar state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked loading bar and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of loading bar with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when loading bar can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If loading bar can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving loading bar should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in loading bar labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main loading bar concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If loading bar presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `surface.overlay`
- `state.info`
- `state.warning`
- `state.danger`
- `ElevationToken.raised`
- `MotionToken.modalPresence`

## Platform Notes

- Preserve the macOS desktop tone by keeping interactions direct, low-chrome, and fast.

## Do

- Do make the message or consequence immediately clear.
- Do use semantic status color as support, not as the only signal.

## Don't

- Don't hide destructive consequences behind vague labels.
- Don't force users to parse color alone to understand status.

## SwiftUI Example

**Loading bar example**  
Canonical compiled example for Loading bar. Use Loading bar when status needs to be explicit without taking over the workspace.

```swift
// Canonical example for Loading bar
let environment = DesignSystemEnvironment.preview(.dark)

LoadingBar(environment: environment, label: "Indexing references", detail: "Duration is not yet known.")
```
