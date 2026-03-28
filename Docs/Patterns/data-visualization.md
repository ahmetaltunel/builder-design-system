# Data visualization

## Problem

Use this pattern for analytical or operational views that need charts to sit comfortably inside the system shell.

## When To Use

- At-a-glance status should be readable before drilling into detail.
- Charts and tables must share the same token system.

## Required Components

- Charts
- Table
- Tabs
- Segmented control

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

- Use explicit labels for filters, scopes, and data groupings.
- Summarize what the data shows before diving into dense details.

### Action labels

- Keep action labels inside the data visualization pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the data visualization flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the data visualization pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for data visualization should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the data visualization flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in data visualization that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the data visualization pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to data visualization should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the data visualization pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the data visualization recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the data visualization flow includes generated content, clearly separate authored input, generated output, and review actions.
- Make certainty and ownership explicit.

## Configurations

- Primary configuration
- Dense variant
- Secondary-context variant

## Related Patterns

- Workspace dashboard
- Filtering patterns
- Loading and refreshing

## Accessibility Acceptance

- Semantics: Pass
- Keyboard: Pass
- Contrast: Pass
- Motion: Pass
- Messaging: Pass

## SwiftUI Example

**Data visualization example**  
Canonical compiled pattern example for Data visualization. Use Data visualization when charts, filters, and dense analytical detail need one shared operating surface.

```swift
// Canonical example for Data visualization
let environment = DesignSystemEnvironment.preview(.dark)

VStack(spacing: 16) {
    ChartPanel(environment: environment, title: "Coverage", points: points)
    DataTable(environment: environment, columns: columns, rows: rows, selectedRowID: $selectedRowID)
}
```
