# Content density

Density is desktop-first and information-rich without becoming cramped, using consistent row heights and grouped surface rhythm.

## Calibration Notes

- Sidebar rows feel compact but not compressed.
- Settings rows balance generous labels with tight, right-aligned controls.
- The composer remains roomy even when the rest of the UI is dense.

## Implementation Guidelines

- Support compact, default, and comfortable modes with token multipliers.
- Adjust row heights and padding through density tokens instead of component-specific overrides.
- Keep tables, forms, and navigation in sync when density changes.

## Token References

- `DensityMode`
- `SpacingToken.rowGap`
- `SpacingToken.toolbarHeight`
- `SpacingToken.panelPadding`


