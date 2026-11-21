# 已证明：float_mat_inv_3d / termination

对任意机器参数与任意初始内存证明 Acc(successor ge)(entry args m)，覆盖所有可能后继。此命题不要求安全前条件；非法输入仍保留原始停滞/错误语义。它不是有限展开、单条返回路径或存在性终止。

全部 1 项目标由精确类型 GoalBinding 实例化，完整依赖冷编译及独立 `rocq check` 通过。关闭的 passed 运行是 `_build/matrix-eight-acceptance/20261121T075856-99eb163cb6/five-rocq`；关闭后实际 `validate_current` 通过。证明源码/规范/检查器与真实编译快照逐项 hash 绑定，见 [goal-validation.json](evidence/goal-validation.json)、[kernel-evidence.json](evidence/kernel-evidence.json) 及 [可重跑检查器](check.py)。独立检查只重验既有数学证明，作者实际运行配置见 [runtime-configuration.json](evidence/runtime-configuration.json)。

- `Termination`: `FiveMatInv3Termination.Spec.Termination` → `FiveMatInv3Termination.Proof.termination_proved`

- `prepare/source/float_mat_inv_3d.c`: `68ede3a9167c9a8c036eadfd24fd9ee590183f2b282e8594eee165d8e6a07d3f`
- `align/model/Source.v`: `8a5457ea6fc48aa16b627d174d6b1174e89b06f1212f995ecff82ffdf4b1f6db`
- `align/model/Execution.v`: `b39e1b5ecaeaad262a7295ad1864bce57c2547ff1f7f30ae589c02bafb30b3cf`
- `rocq/termination/problem/Spec.v`: `b299f5c6858ee3087d326e0baae91d69a2762229c1041813670c4028511f5972`
- `rocq/termination/attempts/001/Proof.v`: `95fb93c7b6dd2b973598d3eb2ab2228761636df2d1504d1233ee861396634a32`

目标为 CompCert 3.17 x86-64、little endian、IEEE754 binary32、round-to-nearest-ties-to-even；精确导入闭包与当前源 hash 见 [provenance.json](provenance.json)。内存观察使用真实 `Mem.loadbytes`/`memval` 与 frame，不把未初始化字节当数值零。准备代码声明的标准内建绑定是边界；普通 libm 的任意实现、其他编译器及机器码/硬件对应不在本结论中。

实际继承假设：`ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`。完整 `Print Assumptions` 原始输出为 `_build/matrix-eight-acceptance/20261121T075856-99eb163cb6/five-rocq/logs/065-FiveMatrixClose3Termination-goal-certificate.stdout.log`；索引见 [assumptions-index.json](evidence/assumptions-index.json)。没有为本目标新增 Axiom，也没有 Admitted/admit。

成本见 [costs.json](costs.json)。此问题没有单独 token/时间/内存测量边界，逐题分摊均为 null；原案例构造、失败冷检查与八题独立检查共享记录分别引用，不能逐题重复相加。八题独立检查保留完整实测数字及原始审核的阶段分类限制；它不被伪装为模型作者阶段。根汇总按实际 actor/event ID 与直接工具命令去重，工具采样 RSS 不包含模型服务器或桌面进程。历史失败与原始输入不被覆写。
