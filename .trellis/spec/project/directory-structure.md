# Directory Structure

> Evidence: repository tree, `build-profile.json5` (`modules`), module `oh-package.json5` files,
> `docs/TECHNICAL_DESIGN_ZH.md` §一 (模块职责).

## Repository Layout

```
AppScope/                 app.json5 (bundleName, version, icon, label) + app-level resources
entry/                    HAP — Stage host
  src/main/ets/entryability/EntryAbility.ets
  src/main/ets/entrybackupability/EntryBackupAbility.ets
  src/main/ets/pages/     routable pages (register in resources/base/profile/main_pages.json)
  src/main/resources/     base/, dark/ qualifiers; element/, media/, profile/
  src/main/module.json5
garden_core/              HAR — pure rules (no ArkUI)
  Index.ets               public API barrel (oh-package.json5 "main")
  src/main/module.json5   "type": "har"
number_garden/            HAR — embeddable game UI (GardenGameView)
  Index.ets               public API barrel
  src/main/module.json5   "type": "har"
content/                  level JSON + reference vectors (content/reference/)
tools/                    developer-machine Python scripts (not shipped)
docs/                     design docs, toolchain record, design images
qa/                       STATUS.md + logs/ (command evidence)
hvigor/hvigor-config.json5, hvigorfile.ts, build-profile.json5, oh-package.json5, code-linter.json5
```

## Module Registration

A new module must be registered in the root `build-profile.json5` `modules` array. HAP modules get
`targets` with `applyToProducts: ["default"]` (see `entry`); HAR modules only need `name` + `srcPath`
(see `garden_core`, `number_garden`).

## Dependency Direction

Declared with local `file:` dependencies:

- `entry/oh-package.json5` → `garden_core`, `number_garden`
- `number_garden/oh-package.json5` → `garden_core`
- `garden_core/oh-package.json5` → nothing

Never add a reverse edge (`garden_core` → `number_garden`, or any HAR → `entry`). After changing
dependencies run `ohpm install --all` and commit the updated `oh-package-lock.json5` files.

## Where New Code Goes

| Code | Location |
|------|----------|
| Rule validation, state transitions, undo, solver, port interfaces | `garden_core/src/main/ets/` |
| Board/tile/seed-tray components, `UiDraft`, animations | `number_garden/src/main/ets/` |
| Pages, navigation, settings, RDB/preferences adapters, dependency wiring | `entry/src/main/ets/` |
| Level JSON | `content/` |
| Generators / validators (Python) | `tools/` |
| Native unit tests for a module | `<module>/src/test/` (hypium local tests) |
| Device/integration tests | `<module>/src/ohosTest/` (requires an `ohosTest` target in the module `build-profile.json5`) |

Cross-module imports go through the target module's `Index.ets` using the package name
(`import { X } from 'garden_core'`), never through relative paths into another module's `src/`.

## Generated / Ignored

`oh_modules/`, `build/`, `.hvigor/`, `local.properties` and HAR `BuildProfile.ets` are generated and
git-ignored (`.gitignore`, `garden_core/.gitignore`, `number_garden/.gitignore`). Do not hand-edit or
commit them.

## Common Mistakes

- Creating a module directory without adding it to root `build-profile.json5`.
- Putting UI helpers into `garden_core` "because the rules need them".
- Importing `../garden_core/src/main/ets/...` from `number_garden` instead of the package barrel.
