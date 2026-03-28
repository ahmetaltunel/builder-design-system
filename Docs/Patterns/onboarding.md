# Onboarding

## Problem

Use this pattern when the first-run journey needs structured guidance inside the same visual system.

## When To Use

- The next action should always be obvious.
- Step or state progression must stay visible.

## Required Components

- Wizard
- Tutorial panel
- Tutorial components

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

- Keep action labels inside the onboarding pattern direct and role-specific.
- Let the primary action read as the next obvious step.

### Helper text

- Use helper text to orient the user inside the onboarding flow before friction appears.
- Keep supporting guidance tied to the current step or state.

### Validation copy

- Validation in the onboarding pattern should explain the exact recovery path.
- Connect validation text to the local field or grouped summary that needs attention.

### Error copy

- Error copy for onboarding should name the issue and preserve orientation.
- Avoid generic failure language that does not say what to do next.

### Confirmations

- Use confirmations to state what changed inside the onboarding flow and whether follow-up is still required.
- Keep confirmations factual and short.

### Destructive actions

- Reserve destructive wording for actions in onboarding that truly remove work, data, or access.
- Make the consequence explicit before the action is taken.

### Empty states

- If the onboarding pattern can render empty or no-result states, explain why and suggest one recovery action.
- Do not let empty-state copy become decorative filler.

### Announcements

- Announcements related to onboarding should describe the state change and what it means for the current workflow.
- Keep announcement copy operational rather than promotional.

### Localization

- Keep the onboarding pattern free of idioms and unstable shorthand.
- Use date, time, and status language that can be localized cleanly.

### Terminology

- Use the same nouns for the same concepts throughout the onboarding recipe, docs, and examples.
- Avoid switching between synonyms that blur the workflow.

### AI and generated content

- If the onboarding flow includes generated content, clearly separate authored input, generated output, and review actions.
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

**Onboarding example**  
Canonical compiled pattern example for Onboarding. Use Onboarding when the first-run journey needs guided progress inside the same system language.

```swift
// Canonical example for Onboarding
let environment = DesignSystemEnvironment.preview(.dark)

let tutorialController = TutorialFlowController(steps: steps.map { .init(id: $0.id, title: $0.title) }, currentStepID: "review", completedStepIDs: ["choose"])

CoachmarkHost(environment: environment, step: .init(anchorID: "invite-team", title: "Invite the rollout group", message: "Attach onboarding help to a real anchor.", primaryActionTitle: "Continue", secondaryActionTitle: "Dismiss")) {
    WizardLayout(environment: environment, title: "Team onboarding", steps: steps, currentStepID: tutorialController.currentStepID) {
        TutorialPanel(environment: environment, title: "Rollout guidance", controller: tutorialController) {
            AnnotationAnchor(id: "invite-team") {
                SystemButton(environment: environment, title: "Invite team", tone: .primary) {}
            }
        }
    }
}
```
