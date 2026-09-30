# 工具链记录

记录日期：2026-10-01。只写本机实测结果；未实测的项目标为 NOT_RUN / BLOCKED。

## 来源

| 项 | 值 |
|---|---|
| 包 | HarmonyOS Command Line Tools (linux-x64) 26.0.0.821 |
| 获取方式 | 社区镜像 GitHub Release `ErBWs/ohos-sdk@26.0.0.821`（华为官方下载需实名开发者账号登录；由用户选定此来源） |
| 校验 | `ohos-sdk-linux-amd64.tar.gz` 分片拼接后 sha256 = `0cbdf7ac5c1be1e42694d448ffaee0c0be0ba9a948197e2bc5b61ca5bdc481f2`，与 Release 附带 `.sha256` 一致。该值由上传者提供，不是华为官方签名 |
| 安装位置 | `/mnt/d/tools/harmonyos/cli-26.0.0.821/command-line-tools`（WSL 根分区空间不足，放在 D 盘） |

风险：镜像为非官方再分发。正式签名、上架前应换用官方下载的同版本工具链重新构建。

## 版本（来自 `command-line-tools/version.txt` 与命令输出）

| 工具 | 版本 | 验证命令 |
|---|---|---|
| Command Line Tools | 26.0.0.821 | `version.txt` |
| HarmonyOS SDK | HarmonyOS 26.0.0 Release，Ohos_sdk_public 26.0.0.105，API 26 | `sdk/default/sdk-pkg.json` |
| hvigor / hvigor-ohos-plugin | 6.26.4 | `hvigorw -v` |
| ohpm | 26.0.0.630 | `ohpm -v` |
| codelinter | 6.0.240 | `version.txt` |
| hdc | 3.2.0f | `sdk/default/openharmony/toolchains/hdc -v` |
| Node（工具链自带） | v24.14.1 | `tool/node/bin/node -v` |
| Java | Temurin 21.0.10 | `java -version` |
| OpenSpec CLI | 1.5.0 | `openspec --version`（本项目流程使用 Trellis，未启用 OpenSpec） |
| Python | 3.13.5 | `python3 --version`（仅开发机工具） |

## 工程元数据取值依据

- `build-profile.json5` 的 `targetSdkVersion` / `compatibleSdkVersion` = `26.0.0`：hvigor-ohos-plugin 6.26.4 的 `src/const/version-const.js` 规定 API ≥ 26 时版本串只写平台版本（不再带 `(API)` 后缀）。
- `modelVersion` = `26.0.0`：同文件 `CURRENT_MODEL_VERSION` 取当前 SDK 平台版本。
- `compatibleSdkVersion` 暂与目标版本相同。是否下调以覆盖更多设备，需在确定目标机型后再定。
- 模板文件结构来自 DevEco Studio「Empty Ability」模板（对照 `ohosvscode/arkTS` 仓库 `packages/vscode/templates/empty-ability`，MIT）；HAR 模块结构对照 DevEco Static Library 模板形态。
- `@ohos/hypium` 1.0.29、`@ohos/hamock` 1.0.0：`https://ohpm.openharmony.cn/ohpm/` 当日 `latest`。

## 环境变量

```bash
export OHOS_CLT=/mnt/d/tools/harmonyos/cli-26.0.0.821/command-line-tools
export DEVECO_SDK_HOME=$OHOS_CLT/sdk
export PATH=$OHOS_CLT/bin:$OHOS_CLT/tool/node/bin:$OHOS_CLT/sdk/default/openharmony/toolchains:$PATH
```

## 常用命令（在仓库根目录执行）

```bash
ohpm install --all
hvigorw assembleHap --mode module -p product=default -p buildMode=debug --no-daemon
codelinter
```

产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`。

## 未具备

| 项 | 状态 | 原因 |
|---|---|---|
| 签名配置 | BLOCKED | 需用户在 AppGallery Connect 申请证书与 Profile；`bundleName` 当前为 `com.dofastted.numbergarden`，注册应用前可改 |
| 真机 / 模拟器 | NOT_RUN | 无已连接设备；命令行工具不含模拟器镜像 |
| DevEco Studio | 未安装 | 下载需华为账号登录 |
| 原生测试运行 | NOT_RUN | 尚无规则代码与测试用例 |
