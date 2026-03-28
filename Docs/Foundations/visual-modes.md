# Visual modes

Visual modes define how components shift across selected, focused, disabled, read-only, loading, and status-bearing states.

## Calibration Notes

- Selection is soft and rounded, not a harsh background fill.
- Disabled surfaces should remain visible and still feel native to the shell.

## Implementation Guidelines

- Model state visuals explicitly so previews can render a state matrix.
- Use opacity changes sparingly; pair them with border, fill, or label changes.
- Make focus visible without turning controls into bright outlines.

## Token References

- `normal`
- `selected`
- `focused`
- `disabled`
- `readOnly`
- `loading`
- `error`
- `success`
- `warning`
- `betaPreview`


