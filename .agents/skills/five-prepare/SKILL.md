---
name: five-prepare
description: Prepare and freeze a C case, its dependencies, target configuration and explicit external-call bindings for the FIVE CBMC and CompCert stages.
---

# FIVE 案例准备

将用户选定的 C 程序和入口整理为一个可追溯、可被 CBMC 与 CompCert 共同消费的案例。调用本 skill 不等于运行验证或证明。外层案例路径由项目决定。

## 输入、输出和交接

输入：原始 C 源码、入口、目标平台/编译语义、实际依赖和用户指定的检查或替代实现；缺失但必要的信息应登记为阻塞，不能猜造。输出：同一个案例目录的 `source/Program.c`、实际需要的头文件与依赖、适用许可证、`source/bindings.json`，以及 `report/report.md`、`report/manifest.json`、`report/costs.json` 中本阶段记录。完整目录、状态、hash、成本与后续阶段接口必须遵守 [共享案例目录与阶段交接契约](../five-verify/references/case-contract.md)。建立该契约规定的目录；下游未运行文件不得用空文件伪造。

## 准备方法

1. 固定原始源及依赖版本/hash、选定入口、C 方言、目标 ABI、字节序、浮点格式和舍入、实际预处理/编译选项；保留源文件和依赖的可追溯引用。
2. 按用户目标处理依赖，必要时将明确的外部调用绑定到给定 C 实现，记录调用点、原绑定、替代实现、两者的来源与 hash；把实际实现纳入准备后的程序。不得把测试桩或替代实现伪装成原始库实现。
3. 在 `source/bindings.json` 固定实际准备结果、未知项、外部环境和待证对应。CBMC 和 CompCert 消费相同的准备后程序；对原始库绑定的性质迁移须由 five-rocq 另行证明，不得声称自动成立。
4. 缺失生成头文件、目标不受支持或依赖不可取得时记录 limitation 和 blocked，保留真实输入及失败日志；不得虚构配置。只为准备所需执行最小检查，不自行运行 CBMC 或证明。

## 成本和交付

每个案例必须有 `report/costs.json`，对本阶段记录实际 input/output/total token、墙钟时间、工具 CPU、工具进程内存峰值及原始证据；失败和重试计入。遵循 [运行与成本契约](../five-verify/references/run-contract.md)：分析或修改前建立带当前 session 的 `five-prepare` 运行，用计量器执行工具，结束后调用 `python3 scripts/audit-costs.py --run RUN_DIR`。数值无法获得时记 `null`、原因和 partial，批次成本独立保存并引用，不伪造逐案例费用。交付准备状态、输入/输出、绑定、限制和未完成事项。
