# Accessibility Acceptance Checklist

Every component or pattern must clear this checklist before it is considered systemized.

## Semantics

- exposes a clear accessibility label
- exposes a useful value or state when applicable
- exposes a useful hint when the next action is non-obvious

## Keyboard

- keyboard focus can reach the surface
- focus is visible and uses shared tokens
- escape, return, and arrow behavior are predictable where applicable
- focus is restored after closing overlays

## Visual Contrast

- text/background pairs meet contrast expectations
- focus and status are not communicated by color alone
- disabled states remain legible

## Motion

- reduced-motion behavior is implemented
- transitions stay purposeful and restrained

## Messaging

- live-region or status messaging exists where the UI changes asynchronously
- validation is connected to the field it explains
