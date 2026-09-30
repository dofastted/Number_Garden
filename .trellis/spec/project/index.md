# Project-Wide Guidelines

> Applies to every module: layout, build/toolchain, quality and evidence rules.

## Current State

Native HarmonyOS project created from the DevEco Empty Ability template (API 26). `entry` shows the
template page; `garden_core` and `number_garden` contain module configuration and an empty `Index.ets`
barrel. Product rules come from `docs/TECHNICAL_DESIGN_ZH.md` and `docs/AGENT_PROMPT_ZH.md`.

## Guidelines Index

| Guide | Description |
|-------|-------------|
| [Directory Structure](./directory-structure.md) | Module layout, registration, dependency direction, where code goes |
| [Build and Toolchain](./build-and-toolchain.md) | Pinned SDK/hvigor/ohpm versions, env vars, build/lint commands, API lookup |
| [Quality Guidelines](./quality-guidelines.md) | Scope guard, test layers, evidence rules, static checks, security |

## Pre-Development Checklist

- [ ] Read `HANDOFF.md` and `qa/STATUS.md` for the current slice and open risks.
- [ ] Identify the owning module (`entry` / `number_garden` / `garden_core` / `content`) and read its spec layer.
- [ ] Confirm any platform API against the installed SDK declarations (see Build and Toolchain).
- [ ] Check the change respects `entry → number_garden → garden_core`.

## Quality Check

- [ ] `ohpm install --all` and `hvigorw assembleHap … --no-daemon` exit 0; logs saved in `qa/logs/`.
- [ ] `codelinter` reports no defects.
- [ ] Relevant native tests added/updated and run, or marked `NOT_RUN` with the reason.
- [ ] `HANDOFF.md` and `qa/STATUS.md` updated with commands, exit codes and log paths.
