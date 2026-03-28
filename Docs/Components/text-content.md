# Text content

Text content is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use text content when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping text content inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
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

- Prefer direct labels that describe the user outcome for text content rather than implementation jargon.
- Use verb-led labels when text content performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what text content affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific text content state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked text content and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of text content with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when text content can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If text content can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving text content should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in text content labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main text content concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If text content presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
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

- Don't wrap text content in redundant cards.
- Don't drift away from the calibrated neutral palette.

## SwiftUI Example

**Text content example**  
Canonical compiled example for Text content. Use Text content to organize content before reaching for bespoke layout or decorative chrome.

```swift
// Canonical example for Text content
let environment = DesignSystemEnvironment.preview(.dark)

TextContentBlock(environment: environment, title: "Text content", bodyText: "Use content blocks for editorial guidance inside grouped surfaces.")
```
