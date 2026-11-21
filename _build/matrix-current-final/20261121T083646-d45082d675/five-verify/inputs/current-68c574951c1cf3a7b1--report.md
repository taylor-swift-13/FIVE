# 已证明：float_mat_inv_3d / execution_correspondence

八项目标对任意参数、任意内存及原始 Csem 全执行量化：入口域、浮点、整数、内存、控制/耗尽、返回值与字节观察、非法操作及完整执行。使用原始 Source.v、Execution.v 与 Cexec 语义闭包；非法内存、别名及所有机器值均保留，domain restrictions 为空。

全部 8 项目标由精确类型 GoalBinding 实例化，完整依赖冷编译及独立 `rocq check` 通过。关闭的 passed 运行是 `_build/matrix-eight-acceptance/20261121T075856-99eb163cb6/five-rocq`；关闭后实际 `validate_current` 通过。证明源码/规范/检查器与真实编译快照逐项 hash 绑定，见 [goal-validation.json](evidence/goal-validation.json)、[kernel-evidence.json](evidence/kernel-evidence.json) 及 [可重跑检查器](check.py)。独立检查只重验既有数学证明，作者实际运行配置见 [runtime-configuration.json](evidence/runtime-configuration.json)。

- `domain_preservation_goal`: `FiveMatInv3Correspondence.Spec.domain_preservation_goal` → `FiveMatInv3Correspondence.Proof.domain_preservation`
- `floating_point_correspondence_goal`: `FiveMatInv3Correspondence.Spec.floating_point_correspondence_goal` → `FiveMatInv3Correspondence.Proof.floating_point_correspondence`
- `machine_integer_correspondence_goal`: `FiveMatInv3Correspondence.Spec.machine_integer_correspondence_goal` → `FiveMatInv3Correspondence.Proof.machine_integer_correspondence`
- `memory_access_correspondence_goal`: `FiveMatInv3Correspondence.Spec.memory_access_correspondence_goal` → `FiveMatInv3Correspondence.Proof.memory_access_correspondence`
- `control_and_exhaustion_correspondence_goal`: `FiveMatInv3Correspondence.Spec.control_and_exhaustion_correspondence_goal` → `FiveMatInv3Correspondence.Proof.control_and_exhaustion_correspondence`
- `normal_result_and_memory_correspondence_goal`: `FiveMatInv3Correspondence.Spec.normal_result_and_memory_correspondence_goal` → `FiveMatInv3Correspondence.Proof.normal_result_and_memory_correspondence`
- `invalid_operation_correspondence_goal`: `FiveMatInv3Correspondence.Spec.invalid_operation_correspondence_goal` → `FiveMatInv3Correspondence.Proof.invalid_operation_correspondence`
- `whole_execution_correspondence_goal`: `FiveMatInv3Correspondence.Spec.whole_execution_correspondence_goal` → `FiveMatInv3Correspondence.Proof.whole_execution_correspondence`

- `prepare/source/float_mat_inv_3d.c`: `68ede3a9167c9a8c036eadfd24fd9ee590183f2b282e8594eee165d8e6a07d3f`
- `align/model/Source.v`: `8a5457ea6fc48aa16b627d174d6b1174e89b06f1212f995ecff82ffdf4b1f6db`
- `align/model/Execution.v`: `b39e1b5ecaeaad262a7295ad1864bce57c2547ff1f7f30ae589c02bafb30b3cf`
- `rocq/execution_correspondence/problem/Spec.v`: `fc26b55242eb6e5c5ba8820aa9fca9d3d8cd12c7e0f1bf78df37d0e6e6280c22`
- `rocq/execution_correspondence/attempts/001/Proof.v`: `f52f167f3eef1c745a50deb0344117409f2b090649683ff6eee452576ee378de`

目标为 CompCert 3.17 x86-64、little endian、IEEE754 binary32、round-to-nearest-ties-to-even；精确导入闭包与当前源 hash 见 [provenance.json](provenance.json)。内存观察使用真实 `Mem.loadbytes`/`memval` 与 frame，不把未初始化字节当数值零。准备代码声明的标准内建绑定是边界；普通 libm 的任意实现、其他编译器及机器码/硬件对应不在本结论中。

实际继承假设：`ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`。完整 `Print Assumptions` 原始输出为 `_build/matrix-eight-acceptance/20261121T075856-99eb163cb6/five-rocq/logs/074-FiveMatrixClose3Correspondence-goal-certificate.stdout.log`；索引见 [assumptions-index.json](evidence/assumptions-index.json)。没有为本目标新增 Axiom，也没有 Admitted/admit。

成本见 [costs.json](costs.json)。此问题没有单独 token/时间/内存测量边界，逐题分摊均为 null；原案例构造、失败冷检查与八题独立检查共享记录分别引用，不能逐题重复相加。八题独立检查保留完整实测数字及原始审核的阶段分类限制；它不被伪装为模型作者阶段。根汇总按实际 actor/event ID 与直接工具命令去重，工具采样 RSS 不包含模型服务器或桌面进程。历史失败与原始输入不被覆写。
