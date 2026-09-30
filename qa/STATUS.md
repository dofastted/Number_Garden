# 验收状态

更新：2026-10-01。只记录有证据的结果。状态：PASS / FAIL / NOT_RUN / BLOCKED。

## G0 原生模板与工具链

| 项 | 状态 | 证据 |
|---|---|---|
| 工具链安装与版本记录 | PASS | `docs/TOOLCHAIN.md` |
| 依赖安装 `ohpm install --all` | PASS（exit 0） | `qa/logs/g0-ohpm-install.log` |
| 构建 `hvigorw assembleHap --mode module -p product=default -p buildMode=debug --no-daemon` | PASS（exit 0，52 tasks） | `qa/logs/g0-assembleHap.log` |
| 产物 `entry-default-unsigned.hap` | PASS（125,426 字节；`module.json`：`com.dofastted.numbergarden`，minAPIVersion/targetAPIVersion 260000026，deviceTypes `phone`） | 本地构建输出，未入库 |
| 静态检查 `codelinter` | PASS（No defects found） | `qa/logs/g0-codelinter.log` |
| 签名 | BLOCKED | 需用户 AGC 证书与 Profile |
| 真机/模拟器安装运行 | NOT_RUN | 无设备 |
| 原生纯规则测试 | NOT_RUN | 尚无规则代码 |
| 原生平台集成测试（ohosTest） | NOT_RUN | 尚无测试目标 |

已知告警：`entry/src/main/ets/entryability/EntryAbility.ets:9:42` ArkTS WARN「Function may throw exceptions」（模板代码 `setColorMode` 调用）。

## G1–G4

全部 NOT_RUN。
