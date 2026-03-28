# Hero header

## Problem

Use this pattern only when a strong opening state improves orientation; keep it utility-led rather than marketing-led.

## When To Use

- The pattern should reduce decision friction.
- The layout should preserve the shell's calm hierarchy.

## Required Components

- Header
- Text content
- Button

## Layout Recipe

- Start from the shell or grouped settings surface instead of a standalone marketing-style page.
- Establish one dominant area of work, then add secondary context or feedback surfaces as needed.
- Use spacing and subtle separators to communicate structure before adding new containers.

## Accessibility & Motion

- Respect reduced motion by simplifying transitions to fades or no-op changes.
- Do not communicate critical state through color alone.
- Preserve keyboard traversal across all participating components.

## Copy Tone

Orienting rather than aspirational. The opening line should explain the workspace or next action.

## Content Guidance

- Lead with orientation and next action, not promotional language.
- Keep the supporting sentence operational and concise.

### Action labels

- Keep action labels inside the hero header pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the hero header flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the hero header pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for hero header should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the hero header flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in hero header that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the hero header pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to hero header should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the hero header pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the hero header recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the hero header flow includes generated content, clearly separate authored input, generated output, and review actions.
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

**Hero header example**  
Canonical compiled pattern example for Hero header. Use Hero header only when a strong opening state improves orientation and the copy stays utility-led.

```swift
// Canonical example for Hero header
let environment = DesignSystemEnvironment.preview(.dark)

HeaderBlock(environment: environment, title: "Hero header", subtitle: "Orient the workspace and present one clear next step.")
SystemButton(environment: environment, title: "Browse components", tone: .primary) {}
```
