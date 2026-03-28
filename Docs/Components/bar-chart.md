# Bar chart

Bar chart is calibrated for the design-system shell with restrained surfaces, semantic tokens, and consistent light and dark behavior.

## When To Use

- **Primary usage:** Use bar chart when the interaction benefits from the design-system shell language instead of standalone card styling.
- **Composition:** Prefer grouping bar chart inside long-form panels, structured lists, or shell regions so it inherits the product hierarchy.
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

- Prefer direct labels that describe the user outcome for bar chart rather than implementation jargon.
- Use verb-led labels when bar chart performs work and noun-led labels only when it is a destination or mode.

### Helper text

- Use helper text to explain what bar chart affects before the user makes a mistake.
- Keep helper text short enough to scan in compact density.

### Validation copy

- Tie validation to the specific bar chart state that needs to change.
- Name the fix directly instead of describing a generic failure.

### Error copy

- State what blocked bar chart and what the user can do next.
- Avoid vague errors that do not name the affected surface or field.

### Confirmations

- Confirm the outcome of bar chart with factual language such as Saved, Applied, or Updated.
- Include a next step only when the user still needs to act.

### Destructive actions

- Use destructive wording only when bar chart can remove, reset, or disconnect real data or state.
- Name the consequence explicitly.

### Empty states

- If bar chart can render empty, explain why nothing is shown and offer one clear next step.
- Keep the title short and operational.

### Announcements

- Announcements involving bar chart should say what changed, who it affects, and what action is available.
- Keep live status concise enough for repeated exposure.

### Localization

- Avoid idioms and unstable shorthand in bar chart labels and supporting copy.
- Keep status language easy to localize.

### Terminology

- Use one canonical term for the main bar chart concept across the docs, code examples, and showcase.
- Do not switch between overlapping nouns unless the product meaning changes.

### AI and generated content

- If bar chart presents machine-generated output, distinguish prompt, generated content, and next-step actions clearly.
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

- Don't wrap bar chart in redundant cards.
- Don't drift away from the calibrated neutral palette.

## SwiftUI Example

**Bar chart example**  
Canonical compiled example for Bar chart. Use Bar chart when analytical content needs to stay readable and token-driven.

```swift
// Canonical example for Bar chart
let environment = DesignSystemEnvironment.preview(.dark)

BarChartPanel(environment: environment, title: "Bar chart", state: .ready, series: [
    .init(title: "Coverage", color: environment.theme.color(.chartBlue), points: [
        .init(label: "Tokens", value: 82),
        .init(label: "Components", value: 80),
        .init(label: "Patterns", value: 24)
    ])
], selection: .constant(nil), visibleSeriesIDs: .constant(["Coverage"]), valueFormatter: { value in "\(Int(value))%" })
```
