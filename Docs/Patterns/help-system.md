# Help system

## Problem

Use this pattern when contextual help or inspection should sit adjacent to work instead of interrupting it.

## When To Use

- The pattern should reduce decision friction.
- The layout should preserve the shell's calm hierarchy.

## Required Components

- Help panel
- Popover
- Drawer

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

- Keep action labels inside the help system pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the help system flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the help system pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for help system should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the help system flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in help system that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the help system pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to help system should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the help system pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the help system recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the help system flow includes generated content, clearly separate authored input, generated output, and review actions.
- Make certainty and ownership explicit.

## Configurations

- Inline help
- Popover help
- Persistent help panel

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

**Help system example**  
Canonical compiled pattern example for Help system. Use Help system when help, inspection, or magnified context should stay adjacent to the work.

```swift
// Canonical example for Help system
let environment = DesignSystemEnvironment.preview(.dark)

let navigator = HelpNavigator(topics: [
    .init(id: "context", title: "Current context", detail: "Tie guidance to the active workflow."),
    .init(id: "recovery", title: "Recovery", detail: "Name the next safe action.")
], selectedTopicID: "context")

HelpPanel(environment: environment, title: "Help", navigator: navigator) {
    BulletList(environment: environment, items: ["Explain the current decision", "Keep guidance adjacent to work"])
}
```
