# number_garden — Game UI Layer

> HAR module `number_garden/`. Public API: `number_garden/Index.ets`. Depends on `garden_core`.

## Current State

Module configuration only, empty `Index.ets`. No components yet. `GardenGameView` is the first
component to add. Visual target: `docs/design/ui-preview.png`.

## Guidelines Index

| Guide | Description |
|-------|-------------|
| [Component Guidelines](./component-guidelines.md) | Ownership, rendering, cell states, classic and sudoku interaction flows |
| [Accessibility and Visual](./accessibility-and-visual.md) | Layout math, screen reader labels, theme, motion, assets |

## Pre-Development Checklist

- [ ] Legality/outcome comes from `garden_core`, persistence from `entry`; the component only emits commands.
- [ ] Draft state (`UiDraft`) stays local and is discarded on back/background.
- [ ] Every interactive cell is an ArkUI component with an accessibility description.

## Quality Check

- [ ] Cell states distinguishable without color.
- [ ] Buttons ≥ 48 vp; large-font layout does not shrink text.
- [ ] Reduced-motion path removes scale/translate/shake; state never waits on animation.
- [ ] No elements from `docs/design/concept/` (score, moves, shuffle, limited-use counters).
