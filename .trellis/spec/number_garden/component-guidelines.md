# Component Guidelines

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §一 (架构结论), §三 (数独草稿流程), §八 (交互).
> Visual reference: `docs/design/ui-preview.png` (static design drawn from real sample levels; not a device screenshot).

## Ownership

`GardenGameView` is the embeddable game component. `entry` places it inside its native `GamePage`.

| `number_garden` does | `number_garden` never does |
|----------------------|----------------------------|
| Render cells, seed tray, previews, explanations, feedback | Write storage directly |
| Hold `UiDraft` (selection, previews, animation state) | Decide win/lose or legality on its own |
| Emit commands (with `sessionId`/`commandId`/`expectedRevision`) to the host | Keep a second copy of the rules |

Legality and outcomes come from `garden_core`; persistence comes from `entry`.

## Rendering

- Boards have at most 36 cells: render each cell as an ArkUI component so it is focusable and readable
  by the screen reader.
- `Canvas` is allowed only for decorative overlays (pair lines, light effects) and must not intercept
  touches or cover digits. Never render the whole board as one `Canvas`.
- Digits are live text, never baked into images.

## Cell States

Every cell renders one of: empty, normal, selected, invalid, fixed given, player-placed, translucent
preview, hint. Distinguish them with stroke, font weight and symbols in addition to color.

## Classic Interaction

1. First tap highlights a cell.
2. Second tap submits the pair for validation.
3. Illegal pair: keep the first selection and show the reason.
4. Tapping the selected cell again cancels the selection.
5. While a save is in flight, do not queue unbounded taps.
6. When no pair is available, offer undo / restart / hint — never force an ad.

## Sudoku Draft Flow

```
choose card → (optional) swap digit order → preview cell 1 → preview cell 2 → explicit "种下这对" → atomic commit
```

- Cards are always visible; the digit waiting to be placed is highlighted.
- Changing card or swapping order clears preview positions so digits never silently swap targets.
- Givens cannot be overwritten.
- Back navigation or backgrounding discards previews without touching committed state.

## Animation

Animations never own state; game state must not depend on animation duration or completion callbacks.

## Legacy Concept Art

`docs/design/concept/` holds early concept images. Do **not** reproduce their score/moves header,
limited-use hint/undo/shuffle counters, shuffle mechanic, or per-digit candy colors. They are not
product screenshots.

## Common Mistakes

- Writing the board into state before the host confirms the save.
- Clearing the first selection on an illegal second tap.
- Committing a sudoku pair on the second preview tap without explicit confirmation.
