# Persistence

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §四 (状态与保存：先防止半盘错误).

## Storage Choice

Game state lives in the platform relational store (RDB). Exact module names, method signatures and API
levels must be confirmed against the pinned SDK recorded in `docs/TOOLCHAIN.md`:
`$DEVECO_SDK_HOME/default/openharmony/ets/api/@ohos.data.relationalStore.d.ts` and
`@ohos.data.preferences.d.ts` (kit barrel: `ets/kits/@kit.ArkData.d.ts`). Never write storage calls from
memory.

## Tables

| Table | Holds |
|-------|-------|
| `sessions` | Full committed state, copy of the initial level, level + rule-set version, `revision` |
| `command_receipts` | Idempotency receipts keyed by `commandId` (with payload fingerprint) |
| `level_progress` | First-clear records |

Board, card inventory, undo stack and first-clear reward change inside **one transaction**.

Preferences store only settings (volume, vibration, contrast …). Never split game state (for example
the two digits of a seed card) across Preferences keys.

## Command Handling Order

```
receive → receipt lookup → revision check → rule engine → RDB transaction → publish state → feedback
```

Receipt rules and revision rules are defined in `.trellis/spec/garden_core/state-and-commands.md`.
If the transaction fails, nothing is published and the UI keeps its previous committed state.

## Crash Consistency

- Every confirmed command is saved when it is committed; backgrounding is not the only save point.
- After a process kill the game may resume only at the full state before or after a command. A state
  such as "card consumed but only one cell placed" is a bug.

## Versioning

- Each save keeps the level and rule-set version it was started with.
- A content update never silently swaps the board of an in-progress session.
- An unsupported save version is kept as-is and the player gets an explicit choice; saves are never
  deleted automatically.

## Common Mistakes

- Publishing the new state before the transaction commits.
- Writing receipts in a separate transaction from the board.
- Treating a restart as the same `sessionId`.
