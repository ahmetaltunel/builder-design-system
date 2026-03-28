# Donut chart

Donut chart is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use donut chart when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping donut chart inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
- **Copy tone:** Keep labels and helper text practical and operational rather than promotional.

## Anatomy

- Data frame
- Legend or headers
- Readable axis or labels
- Filtering or paging affordances

## Variants

- Default
- Dense
- Empty
- Loading

## States

- Idle
- Sorting
- Filtered
- Loading
- Error

## Density Behavior

Density adapts supporting chrome around the specialized surface rather than compressing the main interaction.

## Accessibility

- Visible focus treatment must use the system focus token rather than a local highlight.
- VoiceOver labels should prefer the catalog name plus current value or state.
- Text and icons must keep contrast in both light and dark themes.
- Rows and charts should remain understandable without relying on color alone.

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

- Prefer direct labels that describe the user outcome for donut chart rather than implementation jargon.
- Use verb-led labels when donut chart performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what donut chart affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific donut chart state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked donut chart and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of donut chart with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when donut chart can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If donut chart can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving donut chart should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in donut chart labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main donut chart concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If donut chart presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
- Do not imply certainty when content is draft or model-generated.

## Tokens

- `surface.grouped`
- `surface.raised`
- `text.primary`
- `text.secondary`
- `chart.blue`
- `chart.teal`

## Platform Notes

- Use monospaced and metadata treatments sparingly so utility surfaces feel native to the shell rather than like imported inspectors.

## Do

- Do let spacing and hierarchy communicate structure before adding more containers.
- Do keep the component visually tied to the calibrated shell.

## Don't

- Don't wrap donut chart in redundant cards.
- Don't drift away from the calibrated neutral palette.

## SwiftUI Example

**Donut chart example**  
Canonical compiled example for Donut chart. Use Donut chart when analytical content needs to stay readable and token-driven.

```swift
// Canonical example for Donut chart
let environment = DesignSystemEnvironment.preview(.dark)

DonutChartPanel(environment: environment, title: "Donut chart", state: .ready, slices: [
    .init(title: "Ready", value: 18, color: environment.theme.color(.chartGreen)),
    .init(title: "Review", value: 7, color: environment.theme.color(.chartAmber)),
    .init(title: "Blocked", value: 3, color: environment.theme.color(.chartRed))
], selection: .constant(nil), visibleSeriesIDs: .constant(["Ready", "Review", "Blocked"]), valueFormatter: { value in "\(Int(value)) items" })
```
