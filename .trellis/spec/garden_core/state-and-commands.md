# State Model and Commands

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §一 (模块职责) and §四 (状态与保存).

## Three State Layers

| Layer | Contents | Owner | Persisted |
|-------|----------|-------|-----------|
| `LevelDefinition` | Validated level data | `garden_core` types, loaded by `entry` | Copy stored in the session row |
| `CommittedState` | Board, card inventory, win/lose, undo stack, revision | `garden_core` | Yes, in one RDB transaction per command |
| `UiDraft` | Selection, previews, running animations | `number_garden` | Never |

`UiDraft` may be discarded at any time (back navigation, backgrounding). It must never be treated as a
saved move.

## Command Envelope

Every complete player action carries:

- `sessionId` — changes on restart (重开产生新 sessionId).
- `commandId` — idempotency key.
- `expectedRevision` — the revision the UI saw.

## Engine Contract

The rule engine is a pure transition: current `CommittedState` + command → new immutable state plus
effect events. It never plays sounds, writes storage, touches components, or reads the clock for game
logic.

Host processing order (implemented in `entry`, see `.trellis/spec/entry/persistence.md`):

```
receive command → validate → compute candidate state → RDB transaction → publish state → play feedback
```

Tile selection may respond immediately, but success of a move is never announced before the save
succeeds.

## Idempotency and Revision Rules

Check in this order — receipts first, then revision — so a legitimate retry is not rejected as stale:

1. Same `commandId`, same payload → return the original receipt, do not execute again.
2. Same `commandId`, different payload → reject.
3. New command with a stale `expectedRevision` → reject.

Undo restores the board and card, and **increments** the revision. Invalid attempts do not enter the
committed history.

## Layer Boundary

`garden_core` must not import ArkUI (`@kit.ArkUI`, decorators such as `@Component`/`@State`),
relational storage, preferences, media, or `number_garden`. Storage and platform needs are expressed
as port interfaces declared in `garden_core` and implemented in `entry`.

Dependency direction is one-way (`docs/AGENT_PROMPT_ZH.md`: 规则、数据、UI 和平台适配保持单向依赖):

```
entry ──▶ number_garden ──▶ garden_core
entry ─────────────────────▶ garden_core
```

This matches the `file:` dependencies in `entry/oh-package.json5` and `number_garden/oh-package.json5`.

## Common Mistakes

- Mutating the previous state object in place (breaks undo and receipt replay).
- Deciding win/lose in `number_garden` instead of in the engine result.
- Rejecting a legitimate retry as "stale revision" because the receipt lookup ran second.
- Keeping undo history outside the transaction that saves the board.
