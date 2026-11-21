# float_rmat_vmult：所有后继终止性，attempt 001

已证明全部 1 项请求目标；本题无 pending。问题为 [Spec.v](../../problem/Spec.v)，证明为 [Proof.v](Proof.v)。

任意机器参数列表和任意 CompCert 内存；结论是原始 Csem 全部后继关系的 Acc 可访问性。终止性本身不排除到达错误，安全性由 no_error 题独立证明。

实际数学作者为 gpt-6.1-sol，请求与实际思考强度均为 ultra；[原始配置回执](../../../../../../report/quat_rotation_paths/runtime-configuration.json)。新的 root 检查只重放未改动的证明，没有修改数学证明、规约或模型。旧成功命令保留在已中断的共享运行中；当前回执来自独立完成的新运行。

模型为 CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux standard ABI、小端、binary32 最近偶数舍入；原 C 的 binary64 常量、提升和舍入位置均保留。NaN 策略、前端和语义库由 [manifest](../../../../align/model/compcert-manifest.json) 和 [provenance](provenance.json) 固定。本题不声称任意 GCC 二进制或硬件等价。

| 输入/产物 | SHA-256 |
| --- | --- |
| C | 468a207dd8dd04f0da2f5425a49e3a33db4c49eaeab003be650c883772284ab7 |
| Source.v | 99bc144d58c9748f268651fe9b855ce053cc0519e0e768decf0ce202b06a0a25 |
| Execution.v | ee850b847b24eb489348fc2150a2afbe6af2e779dc5ef88760a091c1c309573a |
| Spec.v | 4a64db33ff8bfb71311903173e4db852f4ff1393f7d6301a4292298fa76b4887 |
| Proof.v | 270f6bb4a61af31978a0206cd661935b9fe29d6acb19db51beabaa8a9d1b3672 |

- Termination：FiveRmatVmultTermination.Proof.termination_proved；精确类型 FiveRmatVmultTermination.Spec.Termination。

[精确目标核验](evidence/goal-validation.json) 绑定上述类型和定理。实际 GoalBinding 编译 038-FiveRmatVmultTermination-goal-certificate 与独立内核 039-FiveRmatVmultTermination-independent-kernel 均退出 0。原始命令与快照在 [run.json](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/run.json)。[Print Assumptions](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/logs/038-FiveRmatVmultTermination-goal-certificate.stdout.log) 保留实际继承假设：ClassicalDedekindReals.sig_forall_dec、ClassicalDedekindReals.sig_not_dec、Classical_Prop.classic、Events.external_functions_sem、Events.inline_assembly_sem、FunctionalExtensionality.functional_extensionality_dep。没有新增目标公理或 Admitted。

在仓库中 source scripts/env.sh 后执行 python3 paparazzi/models/float_rmat_vmult/rocq/termination/attempts/001/check.py 可重放。

[costs.json](costs.json) 统一记录时间、token、内存。本题新检查区间 40.526205 秒，工具 CPU 40.270000 秒，采样工具树峰值 1390219264 bytes。模型 token 无逐题独立边界，逐题字段为 null，引用共享实测记录；不分摊或重复相加。共享作者原运行包含会话中断等待，所有失败和重试均保留。工具 RSS 不含模型服务端内存，可能漏峰或重复计算共享页。
