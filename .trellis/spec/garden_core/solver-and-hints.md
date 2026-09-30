# Solver and Hints

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §五 (提示与求解).

## Result Contract

A solve request returns exactly one of:

| Result | Meaning |
|--------|---------|
| `SOLVED` | A continuation exists; hint payload attached |
| `UNSOLVABLE` | Search completed and proved no continuation |
| `BUDGET_EXCEEDED` | Time or node budget ran out — **not** proof of unsolvability |
| `CANCELLED` | Request superseded or cancelled |

Never report a timeout or exhausted budget as `UNSOLVABLE`.

## Budgets

Initial budget: 150 ms / 25,000 nodes; at most one retry at 750 ms / 100,000 nodes. These are
unmeasured defaults awaiting device tuning — keep them as named configuration in one place, not as
literals scattered through the solver.

## Staleness

Every result carries `sessionId`, `levelDigest`, `revision`, `requestId`. The UI shows it only when all
four match the current state. Undo, restart, level switch and back navigation must make older results
unusable.

TaskPool cancellation does not guarantee the CPU work stops. Correctness comes from the budget plus
discarding stale results, not from cancellation.

## Concurrency Boundary

- Solving runs in a TaskPool task; ordinary move validation stays synchronous (it is small).
- The TaskPool entry file must not transitively import ArkUI. Do not import it through a barrel
  (`Index.ets`) that also re-exports UI; import the solver file directly.
- Pass only controlled, serializable data across threads (plain board arrays, ids, budgets).

## Hint Semantics

- Hints are computed from the **current** board, not by replaying the level's original reference path.
  Reference solutions are QA evidence, not a hint script.
- Sudoku hints must also respect the current seed-card inventory.

## Common Mistakes

- Treating `BUDGET_EXCEEDED` as "no moves left" and showing a dead-end dialog.
- Showing a hint that arrived after the player pressed undo.
- Importing `number_garden` or ArkUI types into the solver file.
