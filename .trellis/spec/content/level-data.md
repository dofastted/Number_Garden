# Level Data and Dev Tools

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §二 (先实现什么) and §六 (关卡设计与生产).

## Location and Ownership

- `content/` holds level JSON and reference vectors. It is produced on the developer machine and
  imported into the app; it is not generated at runtime.
- `tools/` holds developer-machine scripts (Python). They are never shipped in the HAP and never run as
  a service on the phone.
- Current files: `content/reference/validated_puzzle_examples.json` only. The 16 sample level files
  described in the design doc are not in this repository yet.

## Sample Scope

Sample target: 12 classic levels + 4 sudoku levels + one art theme. Classic samples use `sampleOrder`
to pick the teaching order; this is not the final 60-level list compressed to 12.

| Sample | Level ids | Teaches |
|--------|-----------|---------|
| 1–2 | `classic-001/002` | Equal pairs, select, cancel, another pair |
| 3–4 | `classic-011/012` | Sum-to-10 alongside equal pairs |
| 5–6 | `classic-021/022` | Clear blockers, then pair across gaps |
| 7–8 | `classic-031/032` | Watch both directions |
| 9–10 | `classic-041/042` | Proven wrong first move, practice undo |
| 11–12 | `classic-051/052` | 6×6 boundary and a relaxed level |
| 13–16 | `sudoku-001…004` | 2, 3, 4 seed cards |

Release target 60 classic + 12 sudoku is later work; do not pad with low-quality levels.

## Import Checks

Before any level enters the app, run: schema, semantics, proof, content digest, unique id.
`JSON` type assertions are not runtime validation. Reject:

- booleans where numbers are expected, floats, `NaN`
- wrong row/column lengths
- duplicate `cardId`

Proof requirements:

- Classic: at least one independently replayed clear-all path (multiple valid orders are allowed).
- Sudoku: unique solution counted independently; missing-digit set covered exactly by the cards;
  atomic pair placement replayed.

## Generation Method

- Classic: build by reverse insertion, then verify with independent code.
- Sudoku: full solution first → dig an even number of cells → count unique solution → split missing
  digits into legal pairs. Never deal random cards first and hope they cover the gaps.

## Metadata

Record planned vs measured difficulty, target skill, first observation point, hint, validation result
and human notes. `humanReview` stays `pending` until a person signs off; solver node count is not player
difficulty.

## Common Mistakes

- Treating the `region` vector in the reference JSON as a level type.
- Changing expected results in reference vectors to make native tests pass.
- Importing Python modules or generated scripts into ArkTS sources.
