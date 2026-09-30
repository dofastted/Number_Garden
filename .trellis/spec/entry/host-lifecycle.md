# Host, Lifecycle and Navigation

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §一 (架构结论), §二 (先实现什么), §八 (交互).
> Code: `entry/src/main/ets/entryability/EntryAbility.ets`, `entry/src/main/module.json5`,
> `entry/src/main/resources/base/profile/main_pages.json`.

## What `entry` Owns

Stage startup, native navigation, settings, lifecycle, platform adapters, dependency wiring (creating
port implementations and handing them to `garden_core` / `GardenGameView`), and transactional saves.
It never re-implements game rules.

## Stage Model

- One `UIAbility`: `EntryAbility`, declared in `entry/src/main/module.json5` with `mainElement`
  `EntryAbility` and the `entity.system.home` / `ohos.want.action.home` skill.
- `EntryAbility.onWindowStageCreate` loads the first page with `windowStage.loadContent('pages/Index', …)`
  and logs failures through `hilog.error` before returning.
- Every routable page file lives in `entry/src/main/ets/pages/` and must be listed in
  `entry/src/main/resources/base/profile/main_pages.json`, otherwise it is not packaged as a page.
- `EntryBackupAbility` (backup extension) comes from the official template together with
  `resources/base/profile/backup_config.json`.

## Lifecycle Rules

- Backgrounding discards sudoku previews (`UiDraft`); committed state is already saved per command, so
  nothing else needs to be flushed on background.
- Returning from background restores the last committed state, never a draft.

## Screens

- Home: primary entry "继续游戏"; secondary entries for classic chapters, sudoku chapters and settings.
- Game page hosts `GardenGameView`.
- Result: emphasize the next level; no promotions or activity stacks.

Out of scope for the product (§二): server, login backend, ads, in-app purchase, stamina, leaderboards,
online level editor, random tile refill, 3D.

## Alternative Runtimes

H5/WebView and Cocos/XComponent are alternatives that need their own ADR; they are not built in
parallel. If ever used, state, saves, identity, privacy and lifecycle stay in the native host. Never
expose generic bridges (file access, SQL, `eval`) and never load remote game code.

## Logging

Current pattern (template): `hilog` from `@kit.PerformanceAnalysisKit` with a module-level
`const DOMAIN = 0x0000;` and the `'testTag'` tag. Use `%{public}s` only for non-sensitive values;
anything else uses the default private format. Log failures with the error code before an early return,
as `onWindowStageCreate` does.

## Common Mistakes

- Adding a page file without registering it in `main_pages.json`.
- Saving game state in `onBackground` instead of on every committed command.
- Letting `EntryAbility` or a page call rule functions to decide legality.
