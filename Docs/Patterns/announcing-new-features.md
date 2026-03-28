# Announcing new features

## Problem

Use this pattern when the product needs to introduce capability without turning the shell into a marketing surface.

## When To Use

- The pattern should reduce decision friction.
- The layout should preserve the shell's calm hierarchy.

## Required Components

- Notice stack
- Badge
- Link
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

Direct and informative. Describe what changed, who it is for, and what action is available in one short sentence.

## Content Guidance

- State what changed, who it affects, and what action is available.
- Keep announcement copy short enough to scan in a dense desktop shell.

### Action labels

- Keep action labels inside the announcing new features pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the announcing new features flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the announcing new features pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for announcing new features should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the announcing new features flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in announcing new features that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the announcing new features pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to announcing new features should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the announcing new features pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the announcing new features recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the announcing new features flow includes generated content, clearly separate authored input, generated output, and review actions.
- Make certainty and ownership explicit.

## Configurations

- Inline announcement
- Dismissible banner
- Badge-linked entry point

## Related Patterns

- User feedback
- Announcing beta and preview features
- Timestamps

## Accessibility Acceptance

- Semantics: Pass
- Keyboard: Pass
- Contrast: Pass
- Motion: Pass
- Messaging: Pass

## SwiftUI Example

**Announcing new features example**  
Canonical compiled pattern example for Announcing new features. Use Announcing new features to introduce change without turning the product shell into a marketing surface.

```swift
// Canonical example for Announcing new features
let environment = DesignSystemEnvironment.preview(.dark)

NoticeStack(environment: environment, notices: [
    .init(title: "New workflow", message: "Open Recipes to inspect the latest example-backed patterns.", tone: .info)
])
```
