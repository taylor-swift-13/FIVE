---
name: five-rocq
description: Construct explicit preconditions and specifications and prove requested theorems entirely in Rocq, including CompCert safety, termination, semantic correspondence and mapped CBMC properties. Accepts one or many Rocq models without requiring C or CBMC.
---

# 纯 Rocq 规约与证明

本阶段负责**前条件构造、功能规约和实际定理证明**。接收一个或多个 Rocq 实现、模型、定义、待证目标或需求；不强制来自某个 C 函数，也不要求 C 或 CBMC。CompCert 模型和初步属性映射由 [five-align](../five-align/SKILL.md) 提供，完整工作流的调度与证据汇总由 [five-verify](../five-verify/SKILL.md) 负责。

## 共同准备与案例交接

准备是独立的 [five-prepare](../five-prepare/SKILL.md) 阶段；完整 C 工作流由 five-verify 调度。各阶段在同一个案例文件夹中交接，不限定外层路径。**开始前必须读取并遵守 [共享案例目录与阶段交接契约](../five-verify/references/case-contract.md)**，包括本阶段必需输入与 hash 核验、规定输出、阶段状态、每案例完整目录和 `report/costs.json`。单独运行某阶段时检查其必要输入；缺失则先完成或明确要求准备，不得假定来源或静默换输入。纯 Rocq 输入的 C 阶段标为不适用。

本阶段读取一个或多个 Rocq 模型、用户目标与适用的 `align/model/proof/` 和属性映射，写入 `rocq/<problem>/problem/`、`rocq/<problem>/attempts/<编号>/`、证明证据与 `rocq/report/`；纯 Rocq 情形无需 C/CBMC，详见共享契约。

## 前条件与证明

- 读取输入定义和依赖，明确目标量词、前条件、观察方式及语义范围。可证明无错误、终止性、功能关系、跨函数组合、跨周期不变量、语义对应或用户指定的其他定理。
- 对 CompCert 模型接收脚本生成的 `Precondition.v`、`Obligations.v`、`Proofs.v`。用户仅要求生成时保持 pending，不开始填写或证明；用户进入证明阶段后，由大模型在独立前条件文件列明调用类型、内存、数值及环境要求，说明其范围和可满足性，再在证明文件完成相应实例。
- 不把结论自身或空输入域作为前条件来完成任务，不悄悄加强用户已经给定的前条件。性质不成立时报告反例及可以成立的条件，不修改执行语义掩盖错误。
- 无错误针对原始 Csem 所有可达状态；终止性针对所有可能后继。不要用有限展开、一个执行样例或“存在一条返回路径”代替。长期运行循环的整体终止命题可能不成立，应说明并按实际请求区分单周期终止与主循环安全。
- 将规约与实现分开，用递归定义、归纳不变量、辅助引理和适当自动化证明。只有涉及浮点时才要求相应 Flocq 支持；区分位相等、IEEE 比较、数值相等和误差界。实际内存观察按字节与 frame 陈述。
- Cexec/Csem 全执行对应、外部适配器/环境覆盖、抽象功能模型与执行层的连接，凡需新增形式证明都在本阶段完成。引用原始 CompCert 定理或已检查的依赖，保留前端与外部环境可信边界。生成 Csyntax 本身不能代替这些证明。

## 映射后的 CBMC 属性

有 `spec-map.json` 时，按真实属性 ID、原输入条件、位置、内存区域、调用/展开范围及观察逐项独立重验，必要时先补足命题/状态对应。CBMC 成功不是 Rocq 的公理；纯功能模型上的相似断言需要执行层衔接证明。

重验/反驳结果写 `spec-recheck.json`，保留映射输入与真实 proof run 的绑定。若存在实际反例，重建输入位模式、内存状态、出错操作和已发生的写入前缀，并证明所声称的反例性质。未知字节保持未知；直接求值并非必需，可用执行关系证明复现。不能用 synthetic 变体冒充原 CBMC 反例。无法重验或两套语义存在尚未解决的差异时记 pending/gap，不强行标为 proved/refuted。证据格式见 [证明证据与验收](../five-verify/references/proof-evidence.md)。

## 检查与交付

编译修改模块及受影响依赖，对交付定理运行 `Print Assumptions` 并记录实际继承假设，执行独立 `rocq check`。不使用 Admitted、admit 或为目标新增未证明 Axiom。声明通过检查不等于存在证明；证明实际覆盖的条件、外部假设和未完成项独立列出。

输出前条件、精确规约/命题、证明源码、依赖与假设、编译/内核证据、实际反例以及 pending 义务。证明止于所声明的 Rocq/CompCert 语义；映射回 C 所需的形式衔接也由本阶段证明，five-verify 检查这些证据能否支撑最终结论。

当前项目可先 `source scripts/env.sh`，通用构建入口 `python3 scripts/prove-rocq.py --namespace NAME file1.v file2.v ...` 只构建/检查现有源码，不自动构造证明。已有项目优先使用自身构建配置。

遵循 [最小产物契约](references/run-contract.md)。工作前建立带 `--session` 的 five-rocq 记录，统计实际 token、时间、内存，结束采集事件差额。纯 Rocq 输入无需 C/CBMC 产物，未证明义务单列。

结束必须通过 `python3 scripts/audit-costs.py --run RUN_DIR` 的成本核验。计入规约/前条件构造、证明尝试、修复、失败与超时，不能只统计最后一次编译。模型 token 与工具 CPU/RSS 分别记录；缺失指标记 null 并说明原因，不以估计或 0 替代。

未来产物的权威格式是 [examples 索引](../../../examples/README.md)、[sum3](../../../examples/models/sum3/README.md)、[sum2](../../../examples/models/sum2/README.md) 及 [relations](../../../examples/relations/)；开始产物工作前读取相关示例并遵守 [共享契约](../five-verify/references/case-contract.md)。采用 `prepare/ → cbmc/ → align/ → rocq/` 顺序交接及具名问题的 `problem/`、保留历史的 `attempts/<编号>/`，具体文件、当前尝试、证据与成本规范统一由共享契约维护。仅按用户请求的阶段和目标验收，不将模型生成当证明，也不因只请求生成而强制完成证明。
