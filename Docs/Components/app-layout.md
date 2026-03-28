# App layout

App layout is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use app layout when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping app layout inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Primary shell frame
- Navigation rail or split region
- Workspace content plane
- Optional secondary panel

## Variants

- Default
- Compact
- Expanded
- Disabled where applicable

## States

- Normal
- Hover
- Focused
- Selected
- Disabled
- Read-only when applicable

## Density Behavior

Density adjusts row heights, panel padding, and toolbar height without changing the core shell proportions.

## Accessibility

- Visible focus treatment must use the system focus token rather than a local highlight.
- VoiceOver labels should prefer the catalog name plus current value or state.
- Text and icons must keep contrast in both light and dark themes.

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

- Prefer direct labels that describe the user outcome for app layout rather than implementation jargon.
- Use verb-led labels when app layout performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what app layout affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific app layout state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked app layout and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of app layout with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when app layout can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If app layout can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving app layout should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in app layout labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main app layout concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If app layout presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `bg.sidebar`
- `bg.workspace`
- `surface.grouped`
- `border.subtle`
- `radius.large`
- `SpacingToken.toolbarHeight`

## Platform Notes

- Align with macOS desktop expectations: dense navigation, precise selection affordances, and restrained window-like framing.

## Do

- Do keep app layout compact and structural so the workspace remains primary.
- Do use subdued backgrounds and rounded selection treatment instead of loud fills.

## Don't

- Don't turn app layout into a marketing-style hero surface.
- Don't add extra shadows or gradients just to create emphasis.

## SwiftUI Example

**App layout example**  
Canonical compiled example for App layout. Use App layout to frame workspace structure without leaving the shared shell language.

```swift
// Canonical example for App layout
let environment = DesignSystemEnvironment.preview(.dark)

AppLayout(environment: environment, sidebarWidth: 240) {
    SidebarRow(environment: environment, title: "Components", symbol: "square.grid.2x2", isSelected: true)
} content: {
    PanelSurface(environment: environment, title: "App layout") {
        Text("Shell structure stays token-driven.")
    }
}
```
