# Visual foundation

The app is calibrated around a quiet editor-like shell: translucent sidebar, charcoal workspace, rounded grouped panels, and restrained elevation.

## Calibration Notes

- Use the screenshots as literal composition references before introducing any new component styling.
- Keep the shell low-chrome, with the strongest emphasis on hierarchy, spacing, and muted contrast rather than decorative effects.
- Reserve elevated surfaces for the composer, suggestion tiles, and grouped settings panels.

## Implementation Guidelines

- Build all base surfaces from semantic tokens rather than local view colors.
- Match the screenshots' dark shell proportions before refining component-level details.
- Use rounded geometry consistently so custom views feel like siblings.

## Token References

- `bg.app`
- `bg.sidebar`
- `surface.grouped`
- `surface.raised`
- `border.subtle`
- `radius.large`
- `radius.extraLarge`
- `ShadowToken.raised`
- `GridToken.content`


## Elevation And Shadow Relationships

| Elevation | Shadow token | Description |
| --- | --- | --- |
| `flat` | `flat` | No visible shadow. |
| `subtle` | `subtle` | Small grouped panels and table headers. |
| `raised` | `raised` | Raised cards, menus, and sheet-like regions. |
| `floating` | `floating` | Floating overlays, popovers, and modals. |
