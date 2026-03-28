# File token group

File token group is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use file token group when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping file token group inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Primary utility surface
- Context label
- Focused interaction
- Supporting metadata

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

Density adapts supporting chrome around the specialized surface rather than compressing the main interaction.

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

- Prefer direct labels that describe the user outcome for file token group rather than implementation jargon.
- Use verb-led labels when file token group performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what file token group affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific file token group state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked file token group and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of file token group with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when file token group can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If file token group can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving file token group should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in file token group labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main file token group concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If file token group presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `surface.grouped`
- `surface.input`
- `text.primary`
- `text.secondary`
- `radius.large`

## Platform Notes

- Preserve the macOS desktop tone by keeping interactions direct, low-chrome, and fast.

## Do

- Do let spacing and hierarchy communicate structure before adding more containers.
- Do keep the component visually tied to the calibrated shell.

## Don't

- Don't wrap file token group in redundant cards.
- Don't drift away from the calibrated neutral palette.

## SwiftUI Example

**File token group example**  
Canonical compiled example for File token group. Use File token group when a domain-specific workflow still needs the core system's spacing, state, and feedback rules.

```swift
// Canonical example for File token group
let environment = DesignSystemEnvironment.preview(.dark)

FileTokenGroup(environment: environment, items: [
    .init(title: "release-notes.md", detail: "18 KB", status: .success),
    .init(title: "screenshots.zip", detail: "2 files", status: .warning)
])
```
