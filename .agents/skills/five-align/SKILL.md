---
name: five-align
description: Generate CompCert Csyntax/Cexec models and unproved Rocq obligations, audit their source provenance, and map C/CBMC specifications to model-side propositions. Actual proofs belong to five-rocq.
---

# CompCert 模型与待证目标生成

本阶段负责**模型生成、来源检查、待证目标生成和规约映射**。具体前条件构造、无错误/终止性证明、语义对应证明以及 CBMC 规约的 Rocq 重验均交给 [five-rocq](../five-rocq/SKILL.md)；[five-verify](../five-verify/SKILL.md) 负责调度和最终证据验收。单独调用本 skill 时止于模型和待证任务交付，不自动进入证明阶段。

## 模型生成与来源

- 执行模型来自 **准备后的 C → CompCert `clightgen -csyntax` → 原始 `Cexec`**。不由大模型逐行翻译或替换浮点、整数、内存语义；导出失败时报告缺口，不回退到手写模型。
- 固定源码/request/hash、CompCert 版本与安装配置、预处理与头文件、架构/ABI/大小端、浮点格式、舍入和 NaN 策略。共同标准是指定 CompCert Csem/Cexec，不能自动推广到 GCC 或宿主硬件。
- 进入项目后 `source scripts/env.sh`，用 `scripts/compcert-align.py export` 导出，`audit` 重新预处理/导出并核对来源、AST、包装和依赖。命令和交接格式见 [生成与映射契约](references/compcert-alignment.md)。不手改 Source.v。
- 入口接受任意机器参数和 `Mem.mem`；不使用 non-NaN、指针有效性、初始化或合法长度等证明前条件裁剪模型。保留原始 Cexec 全部后继、控制/求值次序、事件轨迹、输出位模式和实际内存字节修改。
- 使用原始 block+offset、权限、初始化和生命周期。函数 error 是非正常返回且无合法 Csem 后继；仅检查 Stuckstate 不充分。NaN/Inf/浮点溢出不自动是错误；Vundef、访问失败、未实现接口、fuel 耗尽分别记录，保留出错前的实际写入。
- 清点外部调用、builtins、inline assembly、volatile/I/O 和所需环境。列出接口、已有对应证据与未完成的覆盖义务；回调 None 或缺失环境不能冒充 C 错误。若需要新的适配器正确性或完整执行对应证明，写成待证目标交给 five-rocq。缺口未解决时不能声称完整语义覆盖。

## 自动目标与前条件接口

每个模型/选定入口必须由 `scripts/generate-obligations.py` 生成一套目标；`compcert-align.py export` 已自动调用：

- `proof/Precondition.v`：`list val -> mem -> Prop` 接口，具体前条件待大模型在证明阶段填写。
- `proof/Obligations.v`：以显式前条件参数构造无错误和终止性命题。
- `proof/Proofs.v`：后续证明填写位置，默认没有已证明定理。

无错误量化原始 Csem 的所有可达状态；终止性使用后继关系的 `Acc`，涵盖全部执行分支和轨迹，无固定展开界。前条件缺失时保持参数化，不用 True、False、Axiom 或 Admitted 填补。重复生成保留已填写的前条件和证明；模型变化后重新检查，旧证明不得自动继承有效状态。

只做生成、编译/类型检查、来源审计；必要的独立 kernel check 检查当前声明，不能计作待证目标已证明。模型直接 vm_compute、抽取 OCaml 执行均不是该阶段必需条件。可执行性受阻不妨碍交付基于原始 Csem 的待证命题。

## CBMC 规约映射

接收 five-cbmc 的实际 harness、属性 ID、前条件、程序位置、访问区域、调用/展开范围、观察方式及真实反例。逐项或按明确覆盖关系整理模型侧命题与状态对应，记录在 `spec-map.json`；详细字段见生成与映射契约。忠实保留已有 CBMC 条件，不在此阶段推断新安全前条件。

每项绑定输入与模型 hash、原属性和 Rocq 命题，状态为 mapped/pending-proof 或明确 mapping-gap；CBMC 通过不能直接把 Rocq 状态标为 proved。CBMC 与 CompCert 的浮点/整数/内存/UB 差异显式列为侧条件或待证问题。无 CBMC 输入时记 not_applicable，模型生成不依赖先跑 CBMC。

真实反例的位模式、内存状态、出错操作和写入前缀保留原始来源并交接给 five-rocq；重验、反驳和对应性证明在证明阶段完成。未知字节保持未知，synthetic 变体与原反例分开。

## 共同准备与案例交接

准备是独立的 [five-prepare](../five-prepare/SKILL.md) 阶段；完整 C 工作流由 five-verify 调度。各阶段在同一个案例文件夹中交接，不限定外层路径。**开始前必须读取并遵守 [共享案例目录与阶段交接契约](../five-verify/references/case-contract.md)**，包括本阶段必需输入与 hash 核验、规定输出、阶段状态、每案例完整目录和 `report/costs.json`。单独运行某阶段时检查其必要输入；缺失则先完成或明确要求准备，不得假定来源或静默换输入。纯 Rocq 输入的 C 阶段标为不适用。

本阶段从 `source/<entry>.c`、`source/bindings.json` 和可选 `cbmc/` 属性读取输入，生成 `source/preprocessed.i`、`model/` 与 `proof/` 的规定文件，并更新 `report/`；详见共享契约。

## 交付与计量

align 为单 agent，不要求 A/B agent 或独立审批。修复本阶段发现的生成/映射实现问题并记录真实发现、解决、未解决数。证明任务留为显式 pending，不混入“生成失败”，也不冒充已完成证明。无法映射的属性或缺失环境如实列缺口。

保留原 C/预处理、自动 AST、原始解释器包装、manifest/来源审计、外部环境清单、待证文件及适用的 spec-map。报告区分生成完成、映射完成、覆盖待证和程序性质未证明。冻结的 execution-translation 请求保持不变；“生成阶段完成”不等于最终已验证交付。最终证明验收由 five-verify 进行。

遵循 [最小产物契约](references/run-contract.md)：开始工作前建立带 `--session` 的 five-align 记录，记录实际 token、时间、内存；结束采集事件差额。历史证明和费用不重签、不覆盖。

结束必须通过 `python3 scripts/audit-costs.py --run RUN_DIR` 的成本核验；实际 token、墙钟、工具 CPU 和工具内存峰值逐项有证据。缺失数据记 partial/null，不得用 0 或估计补齐，也不能把后续 rocq 证明消耗计入 align。
