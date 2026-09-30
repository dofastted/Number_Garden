# Accessibility, Layout and Visual Rules

> Source of truth: `docs/TECHNICAL_DESIGN_ZH.md` §七 (美术规范) and §八 (交互与全年龄可用性).

## Layout

Compact six-column baseline at 320 vp width:

| Item | Value |
|------|-------|
| Screen side margin | 12 vp each side |
| Board inner padding | 4 vp each side |
| Cell gap | 4 vp |
| Resulting cell size | ≈ 44.7 vp (`(320 − 24 − 8 − 5×4) / 6`) |
| Common buttons | ≥ 48 vp |

Game screen order: native top bar → one-line rule → board → seed tray (sudoku only) → bottom tools.
In-game, shrink title and garden decoration; the board has priority.

Large font sizes: switch to an expanded board or an accessible scroll layout. Never shrink the font to
make the layout fit.

## Screen Reader

- Every cell has an accessibility description in stable row/column order, e.g.
  `第 2 行第 3 列，数字 6，已选中`.
- Icons carry visible text or an accessible name.
- Color, sound and vibration are never the only channel for any information.

## Visual Theme

- Cream ceramic tiles, dark high-contrast digits, sage-green accent, modest flower rewards.
- Not a toddler toy; no 3D model per cell; no high-saturation color per digit 1–9.
- Effects layer never intercepts taps and never covers digits.

## Motion

| Event | Duration |
|-------|----------|
| Select | 80–100 ms |
| Clear pair | 160–220 ms |
| Garden stage change | ≤ 600 ms |
| Result screen | skippable immediately |

Reduced-motion setting removes scale, translate and shake.

## Assets

- Planned set: one digit-tile component, 8 action icons, 6 garden-stage images, optional 6 short
  sound effects and one light music loop.
- Every asset gets an entry in an asset table with size, use, source file and license status.
  `planned` is never reported as done. No formal art or audio exists yet.
- Fonts: system font or a font with an obtained license; never bundle an unlicensed font.
- Budget: signed package 30 MiB, owned media ≤ 8 MiB (not yet measured on device). Do not drop
  required platform capabilities to meet it.

## Common Mistakes

- Using the concept images in `docs/design/concept/` as screenshots or as asset sources.
- Announcing only "selected" without row/column/value for a cell.
- Hardcoding a board size that breaks under large system fonts.
