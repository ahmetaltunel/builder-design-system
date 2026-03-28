# Communicating unsaved changes

## Problem

Use this pattern when user work is at risk and the interface must communicate state clearly without panic.

## When To Use

- The pattern should reduce decision friction.
- The layout should preserve the shell's calm hierarchy.

## Required Components

- Modal
- Status indicator
- Button group
- Form

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

- Name the consequence directly and pair it with save, discard, and cancel actions.
- Avoid language that sounds punitive or vague.

### Action labels

- Keep action labels inside the communicating unsaved changes pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the communicating unsaved changes flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the communicating unsaved changes pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for communicating unsaved changes should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the communicating unsaved changes flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in communicating unsaved changes that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the communicating unsaved changes pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to communicating unsaved changes should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the communicating unsaved changes pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the communicating unsaved changes recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the communicating unsaved changes flow includes generated content, clearly separate authored input, generated output, and review actions.
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

**Communicating unsaved changes example**  
Canonical compiled pattern example for Communicating unsaved changes. Use Communicating unsaved changes when user work is at risk and recovery choices must stay unambiguous.

```swift
// Canonical example for Communicating unsaved changes
let environment = DesignSystemEnvironment.preview(.dark)

ModalSurface(environment: environment, title: "Leave without saving") {
    AlertBanner(environment: environment, title: "Unsaved changes", message: "Save or discard before leaving.", tone: .warning) {}
} footer: {
    ButtonGroup(environment: environment, options: [.init(label: "Save", value: "save"), .init(label: "Discard", value: "discard")], selection: $decision)
}
```
