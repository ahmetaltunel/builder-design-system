# Workspace navigation

## Problem

Use this pattern when the shell needs to frame multiple areas, tools, or secondary panels coherently.

## When To Use

- Structural navigation must stay persistent and predictable.
- Global utilities should remain discoverable without crowding the workspace.

## Required Components

- Side navigation
- Top navigation
- Split panel

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

- Keep action labels inside the workspace navigation pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the workspace navigation flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the workspace navigation pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for workspace navigation should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the workspace navigation flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in workspace navigation that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the workspace navigation pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to workspace navigation should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the workspace navigation pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the workspace navigation recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the workspace navigation flow includes generated content, clearly separate authored input, generated output, and review actions.
- Make certainty and ownership explicit.

## Configurations

- Top + side navigation
- Side navigation only
- Top navigation only

## Related Patterns

- Secondary panels
- Help system
- Hero header

## Accessibility Acceptance

- Semantics: Pass
- Keyboard: Pass
- Contrast: Pass
- Motion: Pass
- Messaging: Pass

## SwiftUI Example

**Workspace navigation example**  
Canonical compiled pattern example for Workspace navigation. Use Workspace navigation when primary navigation, secondary context, and content must feel like one desktop workspace.

```swift
// Canonical example for Workspace navigation
let environment = DesignSystemEnvironment.preview(.dark)

AppLayout(environment: environment, sidebarWidth: 240) {
    NavigationSidebarList(environment: environment, sections: sections, selection: $route) { item, isSelected in
        SidebarRow(environment: environment, title: item.title, symbol: item.symbol ?? "circle", isSelected: isSelected)
    }
} content: {
    SplitPanel(environment: environment) {
        PanelSurface(environment: environment, title: "Workspace") { Text("Current route") }
    } secondary: {
        ContextPanel(environment: environment, title: "Inspector") { Text("Selection details") }
    }
}
```
