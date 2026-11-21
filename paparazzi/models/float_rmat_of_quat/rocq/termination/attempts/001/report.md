# float_rmat_of_quat：所有后继终止性，attempt 001

已证明全部 1 项请求目标；本题无 pending。问题为 [Spec.v](../../problem/Spec.v)，证明为 [Proof.v](Proof.v)。

任意机器参数列表和任意 CompCert 内存；结论是原始 Csem 全部后继关系的 Acc 可访问性。终止性本身不排除到达错误，安全性由 no_error 题独立证明。

实际数学作者为 gpt-6.1-sol，请求与实际思考强度均为 ultra；[原始配置回执](../../../../../../report/quat_rotation_paths/runtime-configuration.json)。新的 root 检查只重放未改动的证明，没有修改数学证明、规约或模型。旧成功命令保留在已中断的共享运行中；当前回执来自独立完成的新运行。

模型为 CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux standard ABI、小端、binary32 最近偶数舍入；原 C 的 binary64 常量、提升和舍入位置均保留。NaN 策略、前端和语义库由 [manifest](../../../../align/model/compcert-manifest.json) 和 [provenance](provenance.json) 固定。本题不声称任意 GCC 二进制或硬件等价。

| 输入/产物 | SHA-256 |
| --- | --- |
| C | 5d5e765cf53bd21025c740ed40c0ef5d7f2650b85c30fd125911826efb03e44e |
| Source.v | 98aa27469ac90ded8c1f0720ae84e04b78f038d1281796696220d61f6e56689c |
| Execution.v | 92a529f71bfdf4ea1cc35a4b5afb9871416e915184e574efdff739710b9d9b37 |
| Spec.v | 8d29c0aa1846cd2f6b8218133ce7b42de61ac5cc25e14eac804d222e6938becf |
| Proof.v | bde1a3542d14b932302d2425bbbbdad8cf003a927e24bcc39a04b1c55ffd9222 |

- Termination：FiveRmatOfQuatTermination.Proof.termination_proved；精确类型 FiveRmatOfQuatTermination.Spec.Termination。

[精确目标核验](evidence/goal-validation.json) 绑定上述类型和定理。实际 GoalBinding 编译 027-FiveRmatOfQuatTermination-goal-certificate 与独立内核 028-FiveRmatOfQuatTermination-independent-kernel 均退出 0。原始命令与快照在 [run.json](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/run.json)。[Print Assumptions](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/logs/027-FiveRmatOfQuatTermination-goal-certificate.stdout.log) 保留实际继承假设：ClassicalDedekindReals.sig_forall_dec、ClassicalDedekindReals.sig_not_dec、Classical_Prop.classic、Events.external_functions_sem、Events.inline_assembly_sem、FunctionalExtensionality.functional_extensionality_dep。没有新增目标公理或 Admitted。

在仓库中 source scripts/env.sh 后执行 python3 paparazzi/models/float_rmat_of_quat/rocq/termination/attempts/001/check.py 可重放。

[costs.json](costs.json) 统一记录时间、token、内存。本题新检查区间 42.736041 秒，工具 CPU 42.490000 秒，采样工具树峰值 1390956544 bytes。模型 token 无逐题独立边界，逐题字段为 null，引用共享实测记录；不分摊或重复相加。共享作者原运行包含会话中断等待，所有失败和重试均保留。工具 RSS 不含模型服务端内存，可能漏峰或重复计算共享页。
