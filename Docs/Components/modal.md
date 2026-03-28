# Modal

Modal is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use modal when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping modal inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Overlay surface
- Entry transition
- Focused content region
- Dismiss affordance

## Variants

- Inline
- Floating
- Modal context
- Docked context

## States

- Closed
- Opening
- Open
- Blocked-dismiss

## Density Behavior

Density tightens banner padding and overlay chrome while keeping status hierarchy readable.

## Accessibility

- Visible focus treatment must use the system focus token rather than a local highlight.
- VoiceOver labels should prefer the catalog name plus current value or state.
- Text and icons must keep contrast in both light and dark themes.
- Opening an overlay should move focus into the overlay and restore it predictably when dismissed.

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

- Prefer direct labels that describe the user outcome for modal rather than implementation jargon.
- Use verb-led labels when modal performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what modal affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific modal state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked modal and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of modal with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when modal can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If modal can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving modal should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in modal labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main modal concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If modal presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
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

**Modal example**  
Canonical compiled example for Modal. Use Modal when temporary surfaces should keep focus, context, and dismissal predictable.

```swift
// Canonical example for Modal
let environment = DesignSystemEnvironment.preview(.dark)

ModalSurface(environment: environment, title: "Modal") {
    ValidationSummary(environment: environment, items: validationItems)
} footer: {
    SystemButton(environment: environment, title: "Continue", tone: .primary) {}
}
```
