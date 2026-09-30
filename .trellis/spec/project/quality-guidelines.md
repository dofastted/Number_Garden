# Quality Guidelines

> Evidence: `docs/AGENT_PROMPT_ZH.md`, `docs/TECHNICAL_DESIGN_ZH.md` §九, `code-linter.json5`,
> `qa/STATUS.md`, `HANDOFF.md`.

## Scope Guard

Only 数对花园 with its two modes. Forbidden without an explicit product decision: a third game mode,
stamina, timers/time pressure, purchases, ads, backend server, login backend, leaderboards, 3D.
Do not switch the architecture to WebView/H5, Android compatibility, Cocos, Unity or remote web content.

## Test Layers

| Layer | Where | Proves |
|-------|-------|--------|
| Desktop reference tests | `tools/` (Python) | Rule/level logic on the dev machine |
| Native pure-rule tests | `garden_core/src/test/` (hypium local tests) | ArkTS rules match the reference vectors |
| Native platform integration | `entry/src/ohosTest/` | Storage, lifecycle, embedding |
| Device manual / performance | device | Real behavior, budgets |

Passing one layer never implies another. Port the same vectors (`content/reference/`) into native
tests; never change expected results to make a test pass — change the rule spec first.

Tests must exercise real behavior: rule edges (equal vs sum-10, blocked path, 6×6 indices 31/32/35),
revision/receipt ordering, atomic commit/undo. No tautologies (the DevEco template's
`assertContain('abc','b')` sample tests were intentionally not added).

## Evidence Rules

- Mark an item done only with a real command, exit code and saved log (`qa/logs/`).
- Missing SDK, signing or device → record `BLOCKED` / `NOT_RUN`; never substitute simulated
  screenshots or the static HTML/PNG design previews for native results.
- After each slice update `HANDOFF.md` and `qa/STATUS.md`: modified files, requirement ids, commands +
  exit codes, log paths, passed items, not-run items, risks, next concrete task.

## Static Checks

`codelinter` with `code-linter.json5` (template rule sets `@performance/recommended`,
`@typescript-eslint/recommended`, plus `@security/*` crypto rules) must report no defects. ArkTS
compiler warnings in `qa/logs/g0-assembleHap.log` are tracked in `qa/STATUS.md`; do not silence them
with suppressions.

## Collaboration

- One agent at a time edits save/storage code and build files (`build-profile.json5`,
  `oh-package.json5`, `hvigor/`).
- Reviews check real code and logs, not a previous agent's claim of "done".

## Security

Never commit keys, certificates, signing profiles or account data. No store submission, purchases or
production-account operations by agents.

## Art and Content

Every asset has source and license recorded; concept images are not screenshots. `humanReview` of
levels stays `pending` until a person signs off.
