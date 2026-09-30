# Frozen Rule Sets

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §三 (规则规格冻结).
> Reference vectors: `content/reference/validated_puzzle_examples.json`.

The game has exactly two rule sets. Each has a versioned id that is stored in every save
(`docs/TECHNICAL_DESIGN_ZH.md` §四 "存档保留所用关卡和规则版本").

| Id | Mode | Board |
|----|------|-------|
| `classic-v1` | 经典配对 | up to 6×6, digits 1–9, `0` = empty |
| `sudoku-pair-4-v1` | 数独数对 | 4×4, digits 1–4, 2×2 boxes |

Never mix the two validators, never add a third mode (`docs/AGENT_PROMPT_ZH.md`: 不要新增第三种玩法).
A rule change means a new rule-set id plus an ADR/spec diff first; never edit expected test results
to make an implementation pass (`docs/AGENT_PROMPT_ZH.md` §完成每个切片后的交付).

---

## classic-v1

A move is legal only when **all** hold:

1. Two different cells, both non-empty.
2. Values are equal **or** sum to 10. Equal is enough on its own: `9`+`9` and `5`+`5` are legal.
3. Both cells are in the same row or the same column.
4. Every cell strictly between them is empty (`0`).

Effect of a legal move: exactly those two cells become `0`. Nothing else moves.

Explicitly illegal / absent mechanics:

- Diagonal pairs (even when the sum is 10), bent paths, wrap-around from row end to the next row start.
- Gravity, refill, column collapse, shuffle.

Win condition: every cell is `0`. An invalid attempt is not committed and costs nothing
(no lives, no currency, no move counter).

Worked example from the design doc: row `1 4 6 9` → clear `4`+`6`, then `1`+`9` across the gap.

Reference vector `classic` in `content/reference/validated_puzzle_examples.json`:

- `board` is 4×4; `solution_path_0based` uses **row-major flat indices** (`index = row * cols + col`).
- `claim` is "at least one clear-all path, not unique order": tests must replay the path to an empty
  board, never assert that the path is the only solution.

---

## sudoku-pair-4-v1

Board constraints: every row, column and 2×2 box contains 1–4 without repeats. Givens are immutable.

Seed cards:

- All cards are public for the whole level.
- A card holds two digits that are equal or sum to 5 (`2|3`, `4|1`, `2|2` …).
- The two target cells may be non-adjacent and in different rows/columns.

Placement validation must check **both previews together** against the board. Two cells that are each
legal on their own can conflict jointly (e.g. two `2`s previewed in the same box) — confirmation must
be blocked in that case.

Commit is atomic: both cells and the card inventory change in one state transition. Undo restores both
cells and returns the **same** card (same card id). Before explicit confirmation nothing in the board or
inventory changes; see `.trellis/spec/number_garden/component-guidelines.md` for the draft flow.

Reference vector `hybrid` in the reference JSON (also the board shown in `docs/design/ui-preview.png`):

- `given` / `solution` are 4×4 row arrays, `solution_count` is `1`.
- `pair_cards[].cells` use `[row, col]` pairs — a different index convention from the classic flat path.
  Normalize at the loader boundary; do not let both conventions leak into rule code.

---

## Non-product vectors

`region` in the reference JSON (5×5 region puzzle) is **not** a game mode. Do not implement it.

## Board indexing

A 6×6 classic board has 36 cells, so a single 32-bit bitmask is wrong (§五). Use explicit arrays with a
stable state key, or a two-word bitset that has its own tests covering indices 31, 32, 35 and
out-of-range access. Python reference results (arbitrary-precision ints) do not prove ArkTS bit
operations are safe.

## Common Mistakes

- Treating "sum to 10" as the only rule and rejecting `9`+`9`.
- Allowing a pair across a non-empty cell because the endpoints match.
- Validating sudoku previews one cell at a time.
- Returning the undo card as a new card object with a new id.
