# Design System Handbook

BuilderDesignSystem is a desktop-first macOS design system for calm, utility-focused builder tools.

This handbook documents the reusable system itself. It does not treat the showcase app as the source of truth.

## System intent

The system should feel:

- quiet
- precise
- dense but readable
- native to macOS
- restrained in color and motion
- confident without decorative effects

## Visual calibration

The calibrated baseline is:

- rounded window shell with macOS traffic lights
- graphite or warm-neutral shell surfaces
- long runs of negative space in the workspace
- grouped settings panels with restrained borders
- one blue accent family
- SF system UI typography with monospaced treatment reserved for code-like surfaces
- motion limited to hover, focus, selection, and presence

## Architecture

### Runtime layers

- `BuilderFoundation`
  - token enums
  - generated token registry
  - theme and material resolution
  - density, contrast, context, and mode types
  - typography, material, shadow, icon, grid, and motion-curve specs
- `BuilderComponents`
  - reusable SwiftUI surfaces
  - navigation primitives
  - controls and form fields
  - status and content helpers
- `BuilderDesignSystem`
  - public package product and umbrella module that re-exports `BuilderFoundation` and `BuilderComponents`

### Internal support

- `BuilderCatalog`
  - foundations taxonomy
  - components taxonomy
  - patterns taxonomy
  - cross-reference data used by the showcase
- `BuilderReferenceExamples`
  - compiled SwiftUI examples for components and patterns
  - snippet source used by generated docs
  - shared preview content used by the showcase

### Showcase app

- `BuilderShowcase`
  - app shell
  - feature routes
  - live demos
  - manual inspection surfaces

## Generated references

The authoritative reference set now includes:

- `Docs/System/TokenReference.md`
- `Docs/Foundations/`
- `Docs/Components/`
- `Docs/Patterns/`

These pages are generated or maintained to stay aligned with the runtime package and catalog metadata.

The canonical example layer lives in `BuilderReferenceExamples`, so generated docs and showcase canvases both consume the same authored SwiftUI examples instead of parallel demo implementations.

## Repository layout

- `Sources/BuilderFoundation/`
  - `Tokens/`
  - `Environment/`
  - `Theme/`
  - `Specs/`
- `Sources/BuilderComponents/`
  - `Surfaces/`
  - `Navigation/`
  - `Controls/`
  - `Forms/`
  - `Feedback/`
  - `Content/`
- `Sources/BuilderDesignSystem/`
- `Sources/BuilderCatalog/`
  - `Foundations/`
  - `Components/`
  - `Patterns/`
  - `CrossReference/`
- `Sources/BuilderReferenceExamples/`
- `Sources/BuilderShowcase/`
  - `App/`
  - `Features/`
  - `Shared/`

## Foundation topics

The documented foundation set is:

1. Visual foundation
2. Colors
3. Content density
4. Data visualization colors
5. Design tokens
6. Iconography
7. Layout
8. Motion
9. Spacing
10. Theming
11. Typography
12. Visual context
13. Visual modes
14. Visual style

## Public contracts

The main runtime contracts are:

- `AppTheme`
- `ThemeMode`
- `ThemeContrast`
- `DensityMode`
- `VisualContext`
- `VisualMode`
- `DesignSystemEnvironment`
- `ColorToken`
- `TypographyToken`
- `SpacingToken`
- `RadiusToken`
- `MotionToken`
- `MotionCurveToken`
- `ElevationToken`
- `ShadowToken`
- `MaterialToken`
- `IconToken`
- `GridToken`

## Theme baselines

### Dark mode

- app background: `#161616`
- sidebar background: `#2E3235`
- sidebar selection: `#4A5054`
- workspace background: `#1A1A1A`
- grouped surface: `#242424`
- accent: `#339CFF`

### Light mode

- app background: `#F6F5F2`
- sidebar background: `#ECEAE6`
- sidebar selection: `#DEDDD8`
- workspace background: `#FFFFFF`
- grouped surface: `#FFFFFF`
- accent: `#0169CC`

Light mode should stay soft and warm. It should not become a stark documentation page with dark-mode containers pasted into it.

## Typography roles

The typography system now exposes 28 semantic roles across six groups:

- Display: `displayLarge`, `display`, `displaySmall`, `hero`
- Titles: `pageTitle`, `title`, `titleCompact`, `sectionTitle`, `sectionSubtitle`, `eyebrow`
- Body: `bodyLarge`, `body`, `bodyStrong`, `bodySmall`, `bodySmallStrong`
- Labels and captions: `label`, `labelStrong`, `caption`, `captionStrong`, `helper`
- Actions: `buttonLarge`, `button`, `buttonSmall`
- Utility and data: `mono`, `monoSmall`, `monoCaption`, `numeric`, `tableMeta`

Each typography role resolves through `TypographySpec`, which now includes:

- size
- weight
- tracking
- line height
- monospaced intent

The goal is to cover expressive headings, dense settings UI, helper copy, action labels, code-like surfaces, and numeric or table-heavy workflows without relying on ad hoc font choices.

## Visual foundation contracts

BuilderDesignSystem now treats the following as first-class contracts instead of informal styling choices:

- icon roles via `IconToken` and `IconSpec`
- layout grids via `GridToken` and `GridSpec`
- motion curves via `MotionCurveToken` and `MotionCurveSpec`
- shadow roles via `ShadowToken` and `ShadowTokenSpec`

## Public components

The reusable package now exposes 80 top-level public component views and wrappers rather than a small primitive-only layer.

### Surfaces

- `AppLayout`
- `AppLayoutToolbar`
- `PanelSurface`
- `PanelLayout`
- `ContentLayout`
- `ColumnLayout`
- `SplitPanel`
- `ContainerBox`
- `ContextPanel`
- `ModalSurface`
- `DrawerSurface`
- `PopoverSurface`
- `SettingsGroup`
- `SettingsRow`
- `SidebarBackdrop`

### Navigation

- `NavigationSidebarList`
- `NavigationBrowserList`
- `SidebarRow`
- `BreadcrumbGroup`
- `AnchorNavigation`
- `TopNavigationBar`
- `Tabs`
- `PaginationControl`
- `TreeView`

`NavigationSidebarList` and `NavigationBrowserList` are the native macOS list surfaces for route and browser-style navigation. They use small AppKit bridges for selection, first-responder ownership, and arrow-key movement, while the row visuals remain SwiftUI-driven so the shell keeps its custom design language.

### Controls

- `SystemButton`
- `ToolbarButton`
- `ButtonGroup`
- `ButtonDropdown`
- `SegmentedPicker`
- `SelectMenu`
- `MultiselectMenu`
- `Checkbox`
- `RadioGroup`
- `ToggleSwitch`
- `ToggleButton`
- `TilePicker`
- `SliderField`
- `TokenBadge`
- `TokenGroup`
- `CopyToClipboardButton`

### Forms

- `TextInputField`
- `TextAreaField`
- `TextFilterField`
- `AutosuggestField`
- `DateField`
- `TimeField`
- `DateRangeField`
- `FormField`
- `AttributeEditor`
- `ViewPreferencesPanel`
- `PropertyFilterBar`
- `ResourceSelector`
- `FileDropZone`
- `TagEditor`
- `ReadOnlyField`
- `ReadOnlyTextArea`

### Feedback

- `AlertBanner`
- `NoticeStack`
- `StatusBadge`
- `StatusIndicator`
- `ProgressBar`
- `LoadingSpinner`
- `LiveRegionMessage`
- `ErrorStateView`

### Content

- `HeaderBlock`
- `KeyValuePairs`
- `CardGrid`
- `Board`
- `GridLayout`
- `ListSurface`
- `TextContentBlock`
- `ExpandableSection`
- `DataTable`
- `ChartPanel`
- `CalendarPanel`
- `CodeView`
- `CodeEditorSurface`
- `BulletList`
- `StepsView`
- `WizardLayout`
- `SpaceBetween`
- `Box`

This public surface should be the default source for showcase demos. Demo-only views should not quietly replace reusable component families.

## Materials

Materials are explicit surface roles rather than accidental local fills. The system now models 24 roles across shell, interactive, data, and overlay contexts.

### Shell and structural materials

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

### Interactive and stateful materials

- `input`
- `code`
- `menu`
- `hover`
- `pressed`
- `selected`
- `notice`

### Data and collection materials

- `tableHeader`
- `tableRow`

### Overlay materials

- `popover`
- `modal`
- `drawer`
- `overlay`
- `scrim`

Each `MaterialSpec` resolves:

- fill color
- border color
- border width
- elevation role
- radius role
- fill opacity
- translucency intent
- interactivity intent

Use `theme.material(...)` when a view needs a named surface role with fill, border, elevation, radius, and behavior semantics.

## Adoption rules

When building UI:

1. choose the visual context
2. choose theme mode and contrast mode
3. derive spacing, radius, typography, and color from tokens
4. assemble reusable components
5. compose patterns only after component behavior is stable

Prefer:

- `theme.color(.groupedSurface)`
- `theme.spacing(.panelPadding, density: density)`
- `theme.radius(.large)`

Avoid:

- ad hoc hex values
- per-screen spacing literals
- hardcoded radii that bypass the token system

## Separation rule

If the showcase needs a new style rule, add it to the system first. Do not patch the showcase with one-off values and then backfill the library later.
