# Motion

Motion is fast, restrained, and functional: hover, focus, selection, and presence transitions only.

## Calibration Notes

- Nothing in the screenshots suggests ornamental animation.
- The system should still feel alive through selection and presence changes.

## Implementation Guidelines

- Use quick and regular timings by default.
- Respect reduced motion globally.
- Avoid spring-heavy, playful motion curves.

## Token References

- `quick`
- `regular`
- `emphasis`
- `hover`
- `selection`
- `modalPresence`
- `standard`
- `emphasized`
- `snappy`
- `settle`
- `modal`
- `reduced`


## Generated Motion Durations

| Token | Duration |
| --- | --- |
| `quick` | `0.12s` |
| `regular` | `0.18s` |
| `emphasis` | `0.28s` |
| `hover` | `0.10s` |
| `selection` | `0.16s` |
| `modalPresence` | `0.22s` |

## Generated Motion Curves

| Token | Curve | Notes |
| --- | --- | --- |
| `standard` | `[0.20, 0.00, 0.00, 1.00]` | Default control, hover, and row transitions. |
| `emphasized` | `[0.20, 0.00, 0.00, 1.08]` | Use when an important state change needs extra presence without becoming playful. |
| `snappy` | `[0.28, 0.00, 0.12, 1.00]` | Useful for compact toggles and segmented-control movement. |
| `settle` | `[0.18, 0.00, 0.08, 1.00]` | Best for larger panels that should arrive calmly. |
| `modal` | `[0.24, 0.00, 0.00, 1.00]` | Overlay and modal entry/exit timing. |
| `reduced` | `[0.00, 0.00, 1.00, 1.00]` | Fallback curve when reduced motion is active. |
