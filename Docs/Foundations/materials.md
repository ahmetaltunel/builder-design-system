# Materials

Materials define how shell, panel, card, input, menu, and overlay surfaces differ through fill, border, radius, elevation, opacity, translucency, and interactivity.

## Calibration Notes

- Dark mode materials should feel graphite and calm rather than glossy.
- Light mode materials should stay warm and soft instead of bright white stacks of cards.
- Overlay roles like popovers, modals, and drawers should feel related but still distinct.

## Implementation Guidelines

- Assign every surface to a named material role before styling it locally.
- Treat radius, fill opacity, and translucency as part of the material contract, not one-off view tweaks.
- Use material distinctions to create hierarchy before reaching for louder color or shadow changes.

## Token References

- `shell`
- `sidebar`
- `titlebar`
- `toolbar`
- `workspace`
- `grouped`
- `raised`
- `panel`
- `card`
- `inset`
- `input`
- `code`
- `menu`
- `hover`
- `pressed`
- `selected`
- `notice`
- `tableHeader`
- `tableRow`
- `popover`
- `modal`
- `drawer`
- `overlay`
- `scrim`


## Elevation And Shadow Relationships

| Elevation | Shadow token | Description |
| --- | --- | --- |
| `flat` | `flat` | No visible shadow. |
| `subtle` | `subtle` | Small grouped panels and table headers. |
| `raised` | `raised` | Raised cards, menus, and sheet-like regions. |
| `floating` | `floating` | Floating overlays, popovers, and modals. |
