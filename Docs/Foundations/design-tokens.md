# Design tokens

The system is token-first: semantic roles drive every screen, and the showcase surfaces the taxonomy openly in the foundations browser.

## Calibration Notes

- Template layouts and catalog examples must share the same token source.
- Token names should describe responsibility, not raw appearance.

## Implementation Guidelines

- Expose colors, typography, spacing, radii, motion, and elevation through enums and theme accessors.
- Keep token names stable across light and dark modes.
- Document token purpose in both code and docs.

## Token References

- `AppTheme`
- `ColorToken`
- `TypographyToken`
- `SpacingToken`
- `RadiusToken`
- `MotionToken`
- `MotionCurveToken`
- `ElevationToken`
- `ShadowToken`
- `IconToken`
- `GridToken`
- `MaterialToken`


## Generated Token Coverage

- Colors: 41
- Typography: 28
- Spacing: 14
- Radius: 5
- Motion durations: 6
- Motion curves: 6
- Elevation roles: 4
- Shadow roles: 6
- Material roles: 24
- Icon roles: 10
- Grid roles: 7
