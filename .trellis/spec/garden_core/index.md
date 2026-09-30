# garden_core — Pure Rules Layer

> HAR module `garden_core/`. Public API: `garden_core/Index.ets`.

## Current State

Module configuration only (`build-profile.json5`, `oh-package.json5`, `src/main/module.json5`,
empty `Index.ets`). No rule code yet. The rules below are frozen by `docs/TECHNICAL_DESIGN_ZH.md` and are
binding for the first implementation.

## Guidelines Index

| Guide | Description |
|-------|-------------|
| [Rules](./rules.md) | `classic-v1` and `sudoku-pair-4-v1` legality, effects, reference vectors, board indexing |
| [State and Commands](./state-and-commands.md) | Three state layers, command envelope, idempotency/revision order, layer boundary |
| [Solver and Hints](./solver-and-hints.md) | Result enum, budgets, staleness keys, TaskPool boundary, hint semantics |

## Pre-Development Checklist

- [ ] Rule change? Update `rules.md` (new rule-set id) before touching code or expected results.
- [ ] No imports from `@kit.ArkUI`, ArkUI decorators, storage, media, `number_garden` or `entry`.
- [ ] New public symbol exported through `Index.ets` is ArkUI-free.

## Quality Check

- [ ] Hypium local tests in `garden_core/src/test/` replay the vectors from
      `content/reference/validated_puzzle_examples.json`.
- [ ] Edge cases covered: equal-but-not-10 pairs, blocked paths, diagonals, 6×6 indices 31/32/35,
      joint sudoku preview conflicts, undo returning the same card, revision increments on undo.
- [ ] State transitions return new objects; inputs are not mutated.
