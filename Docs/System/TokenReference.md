# Token Reference

This file is generated from `DesignTokens/design-token-manifest.json`.

## Token counts

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

## Colors

| Token | Raw value |
| --- | --- |
| `appBackground` | `bg.app` |
| `sidebarBackground` | `bg.sidebar` |
| `sidebarSelection` | `bg.sidebarSelection` |
| `toolbarBackground` | `bg.toolbar` |
| `titlebarBackground` | `bg.titlebar` |
| `workspaceBackground` | `bg.workspace` |
| `groupedSurface` | `surface.grouped` |
| `raisedSurface` | `surface.raised` |
| `inputSurface` | `surface.input` |
| `insetSurface` | `surface.inset` |
| `hoverSurface` | `surface.hover` |
| `pressedSurface` | `surface.pressed` |
| `selectedSurface` | `surface.selected` |
| `overlaySurface` | `surface.overlay` |
| `scrimSurface` | `surface.scrim` |
| `subtleBorder` | `border.subtle` |
| `strongBorder` | `border.strong` |
| `textPrimary` | `text.primary` |
| `textSecondary` | `text.secondary` |
| `textMuted` | `text.muted` |
| `textDisabled` | `text.disabled` |
| `textOnAccent` | `text.onAccent` |
| `accentPrimary` | `accent.primary` |
| `accentHover` | `accent.hover` |
| `accentPressed` | `accent.pressed` |
| `focusRing` | `focus.ring` |
| `success` | `state.success` |
| `warning` | `state.warning` |
| `danger` | `state.danger` |
| `info` | `state.info` |
| `successSurface` | `state.successSurface` |
| `warningSurface` | `state.warningSurface` |
| `dangerSurface` | `state.dangerSurface` |
| `infoSurface` | `state.infoSurface` |
| `chartBlue` | `chart.blue` |
| `chartTeal` | `chart.teal` |
| `chartAmber` | `chart.amber` |
| `chartRed` | `chart.red` |
| `chartPurple` | `chart.purple` |
| `chartGreen` | `chart.green` |
| `chartNeutral` | `chart.neutral` |

## Typography

| Token | Size | Weight | Line height |
| --- | --- | --- | --- |
| `displayLarge` | 56 | bold | 62 |
| `display` | 44 | bold | 50 |
| `displaySmall` | 40 | semibold | 46 |
| `hero` | 36 | bold | 42 |
| `pageTitle` | 30 | bold | 36 |
| `title` | 26 | semibold | 31 |
| `titleCompact` | 24 | semibold | 29 |
| `sectionTitle` | 22 | semibold | 28 |
| `sectionSubtitle` | 17 | regular | 23 |
| `eyebrow` | 11 | semibold | 14 |
| `bodyLarge` | 17 | regular | 24 |
| `body` | 15 | regular | 22 |
| `bodyStrong` | 15 | semibold | 22 |
| `bodySmall` | 14 | regular | 20 |
| `bodySmallStrong` | 14 | semibold | 20 |
| `label` | 13 | semibold | 18 |
| `labelStrong` | 13 | bold | 18 |
| `caption` | 12 | regular | 16 |
| `captionStrong` | 12 | semibold | 16 |
| `helper` | 13 | regular | 18 |
| `buttonLarge` | 16 | semibold | 20 |
| `button` | 15 | medium | 18 |
| `buttonSmall` | 13 | medium | 16 |
| `mono` | 13 | regular | 19 |
| `monoSmall` | 12 | regular | 17 |
| `monoCaption` | 12 | regular | 16 |
| `numeric` | 16 | semibold | 20 |
| `tableMeta` | 12 | medium | 16 |

## Materials

| Token | Fill | Border | Elevation | Radius |
| --- | --- | --- | --- | --- |
| `shell` | `bg.app` | `border.subtle` | `flat` | `large` |
| `sidebar` | `bg.sidebar` | `border.subtle` | `flat` | `large` |
| `titlebar` | `bg.titlebar` | `border.subtle` | `flat` | `large` |
| `toolbar` | `bg.toolbar` | `border.subtle` | `flat` | `medium` |
| `workspace` | `bg.workspace` | `border.subtle` | `flat` | `large` |
| `grouped` | `surface.grouped` | `border.subtle` | `subtle` | `large` |
| `raised` | `surface.raised` | `border.subtle` | `raised` | `large` |
| `panel` | `surface.grouped` | `border.subtle` | `subtle` | `large` |
| `card` | `surface.raised` | `border.subtle` | `subtle` | `large` |
| `inset` | `surface.inset` | `border.subtle` | `flat` | `large` |
| `input` | `surface.input` | `border.subtle` | `flat` | `medium` |
| `code` | `surface.inset` | `border.strong` | `flat` | `large` |
| `menu` | `surface.overlay` | `border.subtle` | `raised` | `medium` |
| `hover` | `surface.hover` | `border.subtle` | `flat` | `medium` |
| `pressed` | `surface.pressed` | `border.subtle` | `flat` | `medium` |
| `selected` | `surface.selected` | `border.strong` | `flat` | `medium` |
| `notice` | `surface.raised` | `border.strong` | `subtle` | `large` |
| `tableHeader` | `surface.inset` | `border.subtle` | `flat` | `medium` |
| `tableRow` | `surface.grouped` | `border.subtle` | `flat` | `medium` |
| `popover` | `surface.overlay` | `border.subtle` | `floating` | `large` |
| `modal` | `surface.overlay` | `border.subtle` | `floating` | `extraLarge` |
| `drawer` | `surface.overlay` | `border.subtle` | `raised` | `large` |
| `overlay` | `surface.overlay` | `border.subtle` | `floating` | `large` |
| `scrim` | `surface.scrim` | `border.subtle` | `flat` | `small` |

## Shadows

| Token | Description |
| --- | --- |
| `flat` | No visible shadow. |
| `hairline` | Hairline separation for crisp low-elevation surfaces. |
| `subtle` | Small grouped panels and table headers. |
| `raised` | Raised cards, menus, and sheet-like regions. |
| `floating` | Floating overlays, popovers, and modals. |
| `focus` | Supplementary focus glow for highly interactive surfaces. |

## Elevation relationships

| Elevation | Shadow token |
| --- | --- |
| `flat` | `flat` |
| `subtle` | `subtle` |
| `raised` | `raised` |
| `floating` | `floating` |

## Motion curves

| Token | Curve | Notes |
| --- | --- | --- |
| `standard` | `[0.20, 0.00, 0.00, 1.00]` | Default control, hover, and row transitions. |
| `emphasized` | `[0.20, 0.00, 0.00, 1.08]` | Use when an important state change needs extra presence without becoming playful. |
| `snappy` | `[0.28, 0.00, 0.12, 1.00]` | Useful for compact toggles and segmented-control movement. |
| `settle` | `[0.18, 0.00, 0.08, 1.00]` | Best for larger panels that should arrive calmly. |
| `modal` | `[0.24, 0.00, 0.00, 1.00]` | Overlay and modal entry/exit timing. |
| `reduced` | `[0.00, 0.00, 1.00, 1.00]` | Fallback curve when reduced motion is active. |

## Icon roles

| Token | Symbol | Point size | Role |
| --- | --- | --- | --- |
| `navigationPrimary` | `square.grid.2x2` | 16 | Primary navigation and route entry points. |
| `navigationSecondary` | `sidebar.left` | 15 | Secondary navigation, breadcrumbs, and anchor lists. |
| `utility` | `slider.horizontal.3` | 14 | Utility actions and settings affordances. |
| `statusInfo` | `info.circle` | 14 | Informational state communication. |
| `statusSuccess` | `checkmark.circle` | 14 | Positive completion and safe success states. |
| `statusWarning` | `exclamationmark.triangle` | 14 | Warning and caution states. |
| `statusDanger` | `xmark.octagon` | 14 | Error and destructive states. |
| `accentAction` | `sparkles` | 15 | Primary accent-led calls to action and advanced builder actions. |
| `contentStructure` | `square.stack.3d.up` | 15 | Content grouping, foundations, and layered system concepts. |
| `dataSeries` | `chart.xyaxis.line` | 14 | Data, charting, and analytical content. |

## Grid specs

| Token | Columns | Gutter | Margin | Max width |
| --- | --- | --- | --- | --- |
| `sidebar` | 1 | 16 | 16 | 272 |
| `browser` | 1 | 16 | 22 | 294 |
| `content` | 12 | 20 | 28 | 1280 |
| `inspector` | 1 | 16 | 22 | 330 |
| `settings` | 8 | 16 | 24 | 960 |
| `dashboard` | 12 | 16 | 24 | 1320 |
| `editor` | 12 | 18 | 24 | 1180 |
