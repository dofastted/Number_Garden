# entry — Native Host (HAP)

> HAP module `entry/`. Depends on `number_garden` and `garden_core`.

## Current State

Official template content: `EntryAbility` loads `pages/Index` (template "Hello World" page),
`EntryBackupAbility` backup extension, template resources. No persistence or navigation code yet.

## Guidelines Index

| Guide | Description |
|-------|-------------|
| [Host Lifecycle](./host-lifecycle.md) | Stage model, page registration, lifecycle rules, screens, logging, alternative runtimes |
| [Persistence](./persistence.md) | RDB tables, transaction order, crash consistency, save versioning |

## Pre-Development Checklist

- [ ] New page registered in `entry/src/main/resources/base/profile/main_pages.json`.
- [ ] Storage APIs checked against the SDK declaration files, not memory.
- [ ] Board, cards, undo stack, receipts and first-clear reward written in one transaction.

## Quality Check

- [ ] State is published only after the transaction commits.
- [ ] Kill-and-restore leaves a full pre- or post-command state.
- [ ] Background discards drafts without extra saving logic.
- [ ] Integration tests (`entry/src/ohosTest/`) run on a device/emulator, or marked `NOT_RUN`.
