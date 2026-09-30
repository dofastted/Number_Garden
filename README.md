# 数对花园 Number Garden

原生鸿蒙（HarmonyOS）数字配对益智游戏。两种玩法：

- **经典配对 `classic-v1`**：数字相同或和为 10，同行/同列且中间为空即可消除，清空棋盘获胜。
- **数独数对 `sudoku-pair-4-v1`**：4×4 数独，用公开的种子卡一次种下两格，确认后原子落子。

无倒计时、无体力、无广告、无充值、无服务器。完整规格见 [docs/TECHNICAL_DESIGN_ZH.md](docs/TECHNICAL_DESIGN_ZH.md)。

## 架构

Stage 模型 + ArkTS + ArkUI。单向依赖：`entry → number_garden → garden_core`。

| 目录 | 类型 | 负责 |
|---|---|---|
| `AppScope/` | 应用级配置 | `app.json5`（bundleName、版本、图标、应用名） |
| `entry/` | HAP | Stage 启动、原生导航、设置、生命周期、平台适配、事务存档 |
| `garden_core/` | HAR | 纯规则：动作校验、状态迁移、撤销、求解、端口接口；不依赖 ArkUI |
| `number_garden/` | HAR | 可内嵌游戏界面 `GardenGameView`：棋盘、种子托盘、交互草稿、反馈 |
| `content/` | 数据 | 关卡 JSON 与参考向量（开发机生成） |
| `tools/` | 开发机脚本 | 关卡生成与校验，不进入手机运行时 |
| `docs/` | 文档 | 技术设计、Agent 施工说明、工具链记录、设计稿 |
| `qa/` | 验收 | 状态表 `STATUS.md` 与命令日志 `logs/` |
| `.trellis/` | 工作流 | Trellis 任务与编码规范（`.trellis/spec/`） |

## 构建

工具链版本与安装位置见 [docs/TOOLCHAIN.md](docs/TOOLCHAIN.md)。

```bash
export OHOS_CLT=/mnt/d/tools/harmonyos/cli-26.0.0.821/command-line-tools
export DEVECO_SDK_HOME=$OHOS_CLT/sdk
export PATH=$OHOS_CLT/bin:$OHOS_CLT/tool/node/bin:$PATH

ohpm install --all
hvigorw assembleHap --mode module -p product=default -p buildMode=debug --no-daemon
codelinter
```

## 当前进度

见 [HANDOFF.md](HANDOFF.md) 与 [qa/STATUS.md](qa/STATUS.md)。

## 文档

- [docs/TECHNICAL_DESIGN_ZH.md](docs/TECHNICAL_DESIGN_ZH.md) — 架构、规则冻结、存档、求解、关卡、美术、交互
- [docs/AGENT_PROMPT_ZH.md](docs/AGENT_PROMPT_ZH.md) — Agent 施工约束
- [docs/TOOLCHAIN.md](docs/TOOLCHAIN.md) — 工具链实测版本
- [docs/design/ui-preview.png](docs/design/ui-preview.png) — 屏幕与交互规格静态预览（非真机截图）
- `docs/design/concept/` — 早期概念图，仅作氛围参考，其中的分数/步数/洗牌/限次道具不属于本产品
