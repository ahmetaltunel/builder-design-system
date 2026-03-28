# Layout

Layout is built around a left navigation rail, a dominant workspace, and optional secondary panels or settings content columns.

## Calibration Notes

- The sidebar is visually distinct but not visually heavy.
- Content remains centered and calm even in large windows.
- Settings pages use long grouped panels with controlled max width.

## Implementation Guidelines

- Use shell tokens for sidebar width, content width, and panel sizing.
- Avoid dashboard mosaics; prefer a primary working region.
- Support split and panel patterns without breaking the main shell rhythm.

## Token References

- `sidebar`
- `browser`
- `content`
- `inspector`
- `settings`
- `dashboard`
- `editor`


## Generated Grid Specs

| Token | Columns | Gutter | Margin | Max width |
| --- | --- | --- | --- | --- |
| `sidebar` | 1 | 16 | 16 | 272 |
| `browser` | 1 | 16 | 22 | 294 |
| `content` | 12 | 20 | 28 | 1280 |
| `inspector` | 1 | 16 | 22 | 330 |
| `settings` | 8 | 16 | 24 | 960 |
| `dashboard` | 12 | 16 | 24 | 1320 |
| `editor` | 12 | 18 | 24 | 1180 |
