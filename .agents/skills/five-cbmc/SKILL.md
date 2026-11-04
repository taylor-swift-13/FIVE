---
name: five-cbmc
description: Use CBMC to verify floating-point C implementations, memory safety, and scoped implementation-level properties in FIVE.
---

# C 实现层验证

本阶段明确使用 **传统符号执行与有界模型检查（BMC）的 CBMC**：对准备后的实际函数/循环体生成 SAT/SMT 约束，使用 harness 中的 assume/assert 和显式展开界。不是霍尔逻辑/契约替换路线；不启用将函数或循环体替换为契约假设的模式。CBMC 运行命令和既有实现端检查保持原样，结论不作为 Rocq 公理。属性、范围和真实反例交给 five-align 映射为模型侧待证任务，再由 five-rocq 独立重验/反驳；five-verify 汇总证据。

输入可以是一个或多个 C 函数、调用链、验证入口和局部性质。先读取项目已有的目标语义及范围；缺失时根据实际目标明确写出，不把宿主机默认行为当作规约。

- 固定 C 方言、目标 ABI、字节序、浮点格式、舍入模式和相关编译选项。区分语言未定义行为与确定的目标平台行为。
- 为待验证性质构造 harness，记录输入假设、数组/内存范围、程序位置、函数调用和循环展开界；有循环时检查展开是否足够。可把局部规约或不变式作为待检查断言；不以它们替换原始函数/循环体。
- 使用准备后实际要验证的 C 实现，并记录它与原始源码及外部绑定的关系。优先用 memcpy 表达合法的浮点与整数位观察，除非项目明确验证其他访问方式。
- 运行内存与局部功能检查。失败时保留反例；超时和 unknown 都不是通过。只在对应范围内陈述结论。
- 保存完整命令、版本、源码与输入摘要、日志、断言结果和求解范围。前置条件必须能被翻译/对齐阶段引用。

输入假设和展开界仅属于本次性质验证；不得要求 five-align 按这些假设裁剪执行模型或对齐范围。验证可以限定非 NaN、数组长度或内存条件，但模型必须保留这些条件之外的相关执行行为。

参考表若来自 Rocq 模型，核对它与本次实现、目标语义和输入域匹配。CBMC 输出是外部工具证据；除非确实检查了证明证书，不称其为 Rocq 内核检查的定理。

在当前 FIVE 项目中先 `source scripts/env.sh`。使用传统 CBMC 对选定 C 文件和验证入口直接执行有界模型检查；历史案例测试入口已清理，不引用旧有限参考表。保留的案例在同一文件夹内组织 `source`、`cbmc`、`model`、`proof` 和 `report`。

交付：实现层结论、适用前置条件、范围与证据路径。模型生成和属性映射交给 [five-align](../five-align/SKILL.md)，实际规约/语义对应证明交给 [five-rocq](../five-rocq/SKILL.md)，端到端调度交给 [five-verify](../five-verify/SKILL.md)。

## 共同准备与案例交接

准备是独立的 [five-prepare](../five-prepare/SKILL.md) 阶段；完整 C 工作流由 five-verify 调度。各阶段在同一个案例文件夹中交接，不限定外层路径。**开始前必须读取并遵守 [共享案例目录与阶段交接契约](../five-verify/references/case-contract.md)**，包括本阶段必需输入与 hash 核验、规定输出、阶段状态、每案例完整目录和 `report/costs.json`。单独运行某阶段时检查其必要输入；缺失则先完成或明确要求准备，不得假定来源或静默换输入。纯 Rocq 输入的 C 阶段标为不适用。

本阶段从 `source/Program.c` 与 `source/bindings.json` 读取同一份准备结果，将 harness、属性、范围、日志及真实反例写入 `cbmc/`，并更新 `report/`；详见共享契约。

## 计量及产物

遵循 [最小产物契约](references/run-contract.md)。必须有原C/入口/harness、输入约束与界限、目标配置、属性结果、原始求解日志；失败时保留实际trace与对应输入，成功时反例项明确not_applicable。输出比较完整位模式；涉及写内存时逐字节比较预期结果和实际修改集合，并检查写区外frame不变，不用浮点==或容差冒充位等价。

本skill必须在开始模型工作前依照产物契约建立带`--session`的skill-session记录，并在结束时采集日志边界差额；不要仅用脚本回放记录代替本阶段的模型token消耗。

本阶段结束必须通过 `python3 scripts/audit-costs.py --run RUN_DIR` 的成本核验：实际 token、墙钟、工具 CPU 和工具内存峰值分别有证据。费用记录不完整时保留已有验证结果，但不能宣称本阶段成本统计完整；失败/超时的成本同样保留。
