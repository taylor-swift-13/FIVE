---
name: five-verify
description: Orchestrate FIVE preparation, CBMC checking, CompCert model and obligation generation, and Rocq proof stages; validate their handoffs and summarize evidence, pending goals and costs.
---

# FIVE 调度与结果汇总

本 skill 是完整工作流的总入口，负责**调度、阶段衔接、证据验收和成本汇总**。实际工作按以下边界交给对应 skill：

| 阶段 | 职责和产物 |
|---|---|
| [five-prepare](../five-prepare/SKILL.md) | 固定准备后的 C、依赖、目标与实际外部调用绑定，交给 CBMC 和 CompCert |
| [five-cbmc](../five-cbmc/SKILL.md) | 传统 CBMC 符号执行/BMC：原 C 属性、输入条件、展开范围、结果与真实反例 |
| [five-align](../five-align/SKILL.md) | CompCert 模型、来源审计、外部接口清单、自动待证目标及 C/CBMC → Rocq 规约映射 |
| [five-rocq](../five-rocq/SKILL.md) | 前条件和规约构造、语义对应、无错误/终止性、CBMC 属性重验/反驳及高层功能证明 |

按实际依赖调度，允许迭代；纯模型生成或纯 Rocq 任务可只运行所需阶段。默认不启动子 agent。完整验证请求中的证明工作由 five-rocq 执行；用户只要求模型/目标生成时，停在声明交付，不自动填写前条件或尝试证明。

## 共同准备与案例交接

准备是独立的 [five-prepare](../five-prepare/SKILL.md) 阶段；完整 C 工作流由 five-verify 调度。各阶段在同一个案例文件夹中交接，不限定外层路径。**开始前必须读取并遵守 [共享案例目录与阶段交接契约](../five-verify/references/case-contract.md)**，包括本阶段必需输入与 hash 核验、规定输出、阶段状态、每案例完整目录和 `report/costs.json`。单独运行某阶段时检查其必要输入；缺失则先完成或明确要求准备，不得假定来源或静默换输入。纯 Rocq 输入的 C 阶段标为不适用。

本阶段按照 prepare → CBMC → align → Rocq 的依赖衔接共享 case（CBMC 可与 align 分支独立，但映射依赖实际 CBMC 结果）；按用户指定范围跳过阶段，逐一核对输入 hash、产物、状态与成本，不匹配时停止依赖步骤并报告。详见共享契约。

## 衔接与范围

- 固定源码/request、目标语义、版本、头文件与依赖，贯穿生成、映射和证明。执行层为原始 CompCert Csyntax/Csem/Cexec，所有机器输入/状态均保留；具体 CBMC/Rocq 证明条件不能裁剪模型。
- CBMC 始终是传统 BMC，不使用替换函数/循环体的契约路线。有界结果保留其范围；CBMC 成功不成为 Rocq 公理。
- 每个 CompCert 模型自动生成 `Precondition.v`、参数化的 `Obligations.v` 和 `Proofs.v`。默认前条件待填写、无错误/终止性待证明。检查文件齐全和阶段状态，不把目标生成/类型检查计为定理已证。
- align 提供 spec-map；rocq 提供 spec-recheck、实际证明、假设和内核证据。语义对应、外部环境覆盖和高层模型衔接若尚未证明，明确保留缺口。不能用同名断言或一个返回样例替代对应关系。
- 对真实 C 错误允许报告已证明的反例；不能修改模型掩盖错误，也不能把“反驳已完成”汇总成程序正确。NaN/位模式/内存字节按固定语义观察。

## 证据验收

生成阶段完成与最终验证完成分开验收。align 完成不以交出实际证明为前提；证明阶段可以继续有 pending 目标，最终报告必须反映它们。

需要验收执行对应和 CBMC 规约重验时，调用 `scripts/compcert-verify.py gate`；具体 contract、spec-recheck、kernel 证据及命令见 [证明证据与验收](references/proof-evidence.md)。该门禁保留来源审计、全执行对应证据、真实 CBMC 结果与独立重验等要求，不因职责移动降低标准。它不自动覆盖额外的无错误、终止性或功能定理；这些按用户目标另核对 five-rocq 的证明证据。

汇总分别列出 CBMC 结果/范围、模型生成与来源状态、规约映射状态、具体前条件、各定理 proved/refuted/pending、语义衔接和可信边界。仅在相关证据支持时陈述原 C 的结论。Rocq 内计算、抽取执行、关系语义证明、独立内核检查分别记录；直接计算模型不是最终证明的必需条件。

## 成本记录

遵循 [最小产物契约](references/run-contract.md)。四个实际阶段分别记录 token、时间和峰值内存；本 skill 记录调度/汇总自身的 session 与端到端墙钟。使用事件 ID 去重，不把同一证明同时算入 align 和 rocq。引用阶段证据，缺失指标为 null，不复制同义报告或事后分摊历史主 agent 用量。

对每个实际阶段和包装记录执行 `python3 scripts/audit-costs.py --run RUN_DIR`。成本核验独立于证明验收：证明可以已通过而成本不完整，此时明确报告 partial，不宣称完整交付。包装自身 token 排除已归属子阶段的事件；总量取事件并集。端到端墙钟直接计时，不相加阶段时间；避免同时测量包装子进程树并再次累加该子阶段 CPU/RSS。并行阶段缺少联合峰值时不能用各阶段峰值之和或最大值冒充总峰值。
