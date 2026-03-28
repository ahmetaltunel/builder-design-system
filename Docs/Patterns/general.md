# General

## Problem

Use this pattern when the UI needs clear action sequencing, recency, or response feedback without extra ornament.

## When To Use

- The next action should always be obvious.
- Step or state progression must stay visible.

## Required Components

- Button
- Status indicator
- Live region
- Link

## Layout Recipe

- Start from the shell or grouped settings surface instead of a standalone marketing-style page.
- Establish one dominant area of work, then add secondary context or feedback surfaces as needed.
- Use spacing and subtle separators to communicate structure before adding new containers.

## Accessibility & Motion

- Respect reduced motion by simplifying transitions to fades or no-op changes.
- Do not communicate critical state through color alone.
- Preserve keyboard traversal across all participating components.

## Copy Tone

Utility-first product language. Labels, headings, and helper copy should help someone operate or decide quickly.

## Content Guidance

- Use utility-first language that explains the current state or next action.
- Keep feedback and helper copy short enough for repeated exposure.

### Action labels

- Keep action labels inside the general pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the general flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the general pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for general should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the general flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in general that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the general pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to general should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the general pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the general recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the general flow includes generated content, clearly separate authored input, generated output, and review actions.
- Make certainty and ownership explicit.

## Configurations

- Primary configuration
- Dense variant
- Secondary-context variant

## Related Patterns

- Selection in forms
- Communicating unsaved changes
- Actions

## Accessibility Acceptance

- Semantics: Pass
- Keyboard: Pass
- Contrast: Pass
- Motion: Pass
- Messaging: Pass

## SwiftUI Example

**General example**  
Canonical compiled pattern example for General. Use General when the interface needs a clear next step, stable validation, and explicit completion language.

```swift
// Canonical example for General
let environment = DesignSystemEnvironment.preview(.dark)

PanelSurface(environment: environment, title: "General") {
    ValidationSummary(environment: environment, items: validationItems)
    SystemButton(environment: environment, title: "Continue", tone: .primary) {}
}
```
