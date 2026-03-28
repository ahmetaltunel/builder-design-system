# Generative AI components

Generative AI components is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use generative ai components when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping generative ai components inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Prompt or context region
- Generated output surface
- Utility actions
- Status or attribution

## Variants

- Prompting
- Streaming
- Resolved
- Review mode

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

- Prefer direct labels that describe the user outcome for generative ai components rather than implementation jargon.
- Use verb-led labels when generative ai components performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what generative ai components affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific generative ai components state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked generative ai components and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of generative ai components with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when generative ai components can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If generative ai components can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving generative ai components should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in generative ai components labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main generative ai components concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If generative ai components presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `surface.raised`
- `accent.primary`
- `text.muted`
- `radius.extraLarge`
- `SpacingToken.composerPadding`

## Platform Notes

- Preserve the macOS desktop tone by keeping interactions direct, low-chrome, and fast.

## Do

- Do let spacing and hierarchy communicate structure before adding more containers.
- Do keep the component visually tied to the calibrated shell.

## Don't

- Don't wrap generative ai components in redundant cards.
- Don't drift away from the calibrated neutral palette.

## SwiftUI Example

**Generative AI components example**  
Canonical compiled example for Generative AI components. Use Generative AI components when generated output, review state, and next actions must remain explicit.

```swift
// Canonical example for Generative AI components
let environment = DesignSystemEnvironment.preview(.dark)

VStack(spacing: 12) {
    PromptInput(environment: environment, prompt: $prompt, actionTitle: "Draft") {}
    ChatBubble(environment: environment, role: .assistant, author: "Builder assistant", message: output)
}
```
