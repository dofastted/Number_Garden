# content — Level Data and Dev Tools

> Directories `content/` (level JSON, reference vectors) and `tools/` (developer-machine Python).

## Current State

Only `content/reference/validated_puzzle_examples.json` exists. No level files or scripts yet.

## Guidelines Index

| Guide | Description |
|-------|-------------|
| [Level Data](./level-data.md) | Sample scope, import checks, proof requirements, generation method, metadata |

## Pre-Development Checklist

- [ ] New level ids follow the sample table (`classic-0xx`, `sudoku-00x`).
- [ ] Generator builds proof first (reverse insertion / solution-first), cards after.
- [ ] Python stays in `tools/`; nothing from `tools/` is imported by ArkTS code.

## Quality Check

- [ ] Schema, semantics, proof, content digest and unique-id checks pass for every file.
- [ ] Rejects booleans-as-numbers, floats, `NaN`, wrong lengths, duplicate `cardId`.
- [ ] `humanReview` left `pending` unless a person signed off.
