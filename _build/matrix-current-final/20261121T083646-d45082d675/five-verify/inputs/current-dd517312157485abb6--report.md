# 已证明：float_mat_inv_2d / functional

对满足类型和内存前条件的任意 binary32 矩阵，证明存在正常原始 Csem 调用，并证明每一个正常返回都具有规定状态和精确内存后置条件。输出按 Mem.loadbytes/memval 观察；成功时对应逐项浮点运算的编码，拒绝时保留全部原输出字节，未知初始 memval 不被改写为零。frame 同时覆盖输入区、输出区外的旧块和旧权限。 2D 保留原 double 1e-4 阈值比较；3D 保留 double fabs 与 float EPS 的原表达式和运算次序。

全部 3 项目标由精确类型 GoalBinding 实例化，完整依赖冷编译及独立 `rocq check` 通过。关闭的 passed 运行是 `_build/matrix-eight-acceptance/20261121T075856-99eb163cb6/five-rocq`；关闭后实际 `validate_current` 通过。证明源码/规范/检查器与真实编译快照逐项 hash 绑定，见 [goal-validation.json](evidence/goal-validation.json)、[kernel-evidence.json](evidence/kernel-evidence.json) 及 [可重跑检查器](check.py)。独立检查只重验既有数学证明，作者实际运行配置见 [runtime-configuration.json](evidence/runtime-configuration.json)。

- `NormalCall`: `FiveInv2Functional.Spec.NormalCall` → `FiveInv2Functional.Proof.normal_call`
- `AllReturns`: `FiveInv2Functional.Spec.AllReturns` → `FiveInv2Functional.Proof.all_returns`
- `Nonvacuity`: `FiveInv2Functional.Spec.Nonvacuity` → `FiveInv2Functional.Proof.nonvacuity`

- `prepare/source/float_mat_inv_2d.c`: `5ff0fbc7d7284628788464d5b8d505756da59d0cddba3b97afe2a7c8d25b85e4`
- `align/model/Source.v`: `9cc1524a49e10a888c1381d5e77f6042748ebf43d2a8c2deaa7dcfd63b65e2a4`
- `align/model/Execution.v`: `03a7039fe82bf6df94795cd66ad95f1807dee7683cb40c32551aaa2f060c772e`
- `rocq/functional/problem/Spec.v`: `e599fc799fa89cd8af08be5ef3cdbf0ca460487a4e0e487d8ceb48d0bc22cd08`
- `rocq/functional/attempts/001/Proof.v`: `f4b4253f4411450c7fa09da80469cd59e89c3f9d9d71036d2f0a2740efc74c46`

目标为 CompCert 3.17 x86-64、little endian、IEEE754 binary32、round-to-nearest-ties-to-even；精确导入闭包与当前源 hash 见 [provenance.json](provenance.json)。内存观察使用真实 `Mem.loadbytes`/`memval` 与 frame，不把未初始化字节当数值零。准备代码声明的标准内建绑定是边界；普通 libm 的任意实现、其他编译器及机器码/硬件对应不在本结论中。

实际继承假设：`ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`。完整 `Print Assumptions` 原始输出为 `_build/matrix-eight-acceptance/20261121T075856-99eb163cb6/five-rocq/logs/043-FiveMatrixClose2Functional-goal-certificate.stdout.log`；索引见 [assumptions-index.json](evidence/assumptions-index.json)。没有为本目标新增 Axiom，也没有 Admitted/admit。

成本见 [costs.json](costs.json)。此问题没有单独 token/时间/内存测量边界，逐题分摊均为 null；原案例构造、失败冷检查与八题独立检查共享记录分别引用，不能逐题重复相加。八题独立检查保留完整实测数字及原始审核的阶段分类限制；它不被伪装为模型作者阶段。根汇总按实际 actor/event ID 与直接工具命令去重，工具采样 RSS 不包含模型服务器或桌面进程。历史失败与原始输入不被覆写。
