# Content Guidelines

BuilderDesignSystem uses calm, precise, desktop-first product language.

## Voice and Tone

- Lead with the user task, current state, or next action.
- Prefer clear operational language over marketing language.
- Keep labels and action names short enough to scan quickly in dense layouts.
- Use supportive language without sounding vague or apologetic.

## Action Labels

- Start with a verb when the control performs work: `Create workspace`, `Save changes`, `Open lab`.
- Use noun labels only when the surface is a destination: `Foundations`, `Settings`, `Recipes`.
- Avoid overloaded verbs like `Manage`, `Handle`, or `Process` when a more direct action exists.

## Empty States

- Explain what is missing or why the surface is empty.
- Offer one clear next step.
- Keep the body short; if extra detail is needed, move it into supporting docs or a secondary panel.

## Error States

- Name the problem directly.
- Say what the user can do next.
- Pair the message with inline field guidance or an actionable banner when possible.
- Avoid blameful language.

## Helper and Validation Text

- Use helper text to reduce ambiguity before an error happens.
- Use validation text to explain the exact fix needed.
- Keep validation attached to the relevant field or grouped summary.

## Announcements and Live Status

- Announcements should say what changed, why it matters, and what action is available.
- Live status should stay short enough for repeated exposure in dense product surfaces.
- Prefer factual updates like `Saved just now` or `Review pending` over celebratory or vague language.

## Destructive Actions

- State the consequence explicitly.
- Use direct verbs like `Delete`, `Remove`, or `Disconnect`.
- Reserve high-severity tone for actions that are truly destructive or hard to reverse.

## Confirmations and Announcements

- Confirm what changed and whether any follow-up is needed.
- Announcements should say what changed, who it affects, and what action is available.
- Live status should be concise enough for repeated exposure.

## Error and Recovery Copy

- Name the problem, then tell the user how to recover.
- Use inline validation first when the fix is local to a field.
- Use summaries or banners when multiple fields or product-wide state are involved.
- Avoid `Something went wrong` unless a specific explanation is genuinely unavailable.

## Empty States and No-Result States

- Explain why the surface is empty or why the current query returned no results.
- Offer one clear next step such as clearing a filter, creating the first item, or opening documentation.
- Keep the empty-state title short and the body operational.

## Confirmations and Follow-Up

- Confirm what changed and whether any follow-up is needed.
- Keep confirmations factual and short.
- When the next action matters, include it in the confirmation instead of a separate generic success sentence.

## Localization and Terminology

- Avoid idioms and culture-specific shorthand.
- Prefer stable system terms over clever synonyms.
- Keep one canonical term per concept across docs, components, and showcase copy.
- Do not switch between labels like `workspace`, `project`, and `surface` for the same concept without an explicit reason.
- Keep date, time, and status language easy to localize.

## AI and Generated Content

- Distinguish prompt, output, review, and action areas clearly.
- Do not imply certainty when a response is draft or machine-generated.
- Make follow-up actions explicit.

## Structured Content Contract

These categories now map directly to catalog metadata and generated docs for components and patterns.

### Action labels

- Use direct verbs for actions and stable nouns for destinations.
- Prefer labels that describe the outcome rather than the implementation.

### Helper text

- Reduce ambiguity before failure.
- Keep helper text attached to the control or section it explains.

### Validation copy

- Explain the exact fix required.
- Keep validation local unless multiple fields fail together.

### Error copy

- Name the problem and the recovery path.
- Avoid generic statements that do not say what the user should do next.

### Confirmations

- State what changed and whether follow-up is still needed.
- Keep confirmation language factual and short.

### Destructive actions

- Name the consequence explicitly.
- Reserve high-severity language for genuinely destructive outcomes.

### Empty states

- Explain the absence and offer one clear next step.
- Keep titles short and operational.

### Announcements

- State the change, who it affects, and what action is available.
- Keep repeated announcements concise enough for dense desktop surfaces.

### Localization

- Avoid idioms and unstable shorthand.
- Use date, time, and status language that localizes cleanly.

### Terminology

- Use one canonical term per concept across docs, examples, and the showcase.
- Avoid switching between synonyms unless the meaning actually changes.

### AI and Generated Content

- Distinguish prompt, output, review, and action areas clearly.
- Do not imply certainty when content is draft or machine-generated.
