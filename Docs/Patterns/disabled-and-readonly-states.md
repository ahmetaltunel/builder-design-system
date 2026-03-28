# Disabled and read-only states

## Problem

Use this pattern whenever the interface needs to show disabled, read-only, empty, or error conditions without losing orientation.

## When To Use

- The pattern should reduce decision friction.
- The layout should preserve the shell's calm hierarchy.

## Required Components

- Alert
- Status indicator
- Empty state
- Spinner

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

- Keep action labels inside the disabled and read-only states pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the disabled and read-only states flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the disabled and read-only states pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for disabled and read-only states should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the disabled and read-only states flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in disabled and read-only states that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the disabled and read-only states pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to disabled and read-only states should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the disabled and read-only states pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the disabled and read-only states recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the disabled and read-only states flow includes generated content, clearly separate authored input, generated output, and review actions.
- Make certainty and ownership explicit.

## Configurations

- Primary configuration
- Dense variant
- Secondary-context variant

## Related Patterns

- General
- User feedback
- Loading and refreshing

## Accessibility Acceptance

- Semantics: Pass
- Keyboard: Pass
- Contrast: Pass
- Motion: Pass
- Messaging: Pass

## SwiftUI Example

**Disabled and read-only states example**  
Canonical compiled pattern example for Disabled and read-only states. Use Disabled and read-only states when blocked, empty, or error conditions must still orient the user toward recovery.

```swift
// Canonical example for Disabled and read-only states
let environment = DesignSystemEnvironment.preview(.dark)

VStack(spacing: 14) {
    TextInputField(environment: environment, placeholder: "Project name", text: $name, status: .error, message: "Provide a readable name.")
    ReadOnlyField(environment: environment, label: "Owner", value: "Platform Design")
}
```
