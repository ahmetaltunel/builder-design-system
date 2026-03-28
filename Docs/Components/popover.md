# Popover

Popover is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use popover when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping popover inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
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

- Prefer direct labels that describe the user outcome for popover rather than implementation jargon.
- Use verb-led labels when popover performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what popover affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific popover state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked popover and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of popover with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when popover can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If popover can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving popover should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in popover labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main popover concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If popover presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
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

**Popover example**  
Canonical compiled example for Popover. Use Popover when temporary surfaces should keep focus, context, and dismissal predictable.

```swift
// Canonical example for Popover
let environment = DesignSystemEnvironment.preview(.dark)

PopoverSurface(environment: environment, title: "Popover") {
    Text("Use popovers for lightweight contextual guidance.")
}
```
