# float_quat_vmult：所有后继终止性，attempt 001

已证明全部 1 项请求目标；本题无 pending。问题为 [Spec.v](../../problem/Spec.v)，证明为 [Proof.v](Proof.v)。

任意机器参数列表和任意 CompCert 内存；结论是原始 Csem 全部后继关系的 Acc 可访问性。终止性本身不排除到达错误，安全性由 no_error 题独立证明。

实际数学作者为 gpt-6.1-sol，请求与实际思考强度均为 ultra；[原始配置回执](../../../../../../report/quat_rotation_paths/runtime-configuration.json)。新的 root 检查只重放未改动的证明，没有修改数学证明、规约或模型。旧成功命令保留在已中断的共享运行中；当前回执来自独立完成的新运行。

模型为 CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux standard ABI、小端、binary32 最近偶数舍入；原 C 的 binary64 常量、提升和舍入位置均保留。NaN 策略、前端和语义库由 [manifest](../../../../align/model/compcert-manifest.json) 和 [provenance](provenance.json) 固定。本题不声称任意 GCC 二进制或硬件等价。

| 输入/产物 | SHA-256 |
| --- | --- |
| C | 64c3359619e2f8de1f8c0b16ace92ab01c969fb7d408981bd68ba0fb7b8d80ff |
| Source.v | 7f5c226c3d94819451f6ccd2a5a0bb9e17360d8c026aeccefb814b3a269d5b04 |
| Execution.v | 0b476992b2f98598571949b9b1bfa7674b07cdd9b6b09f897d250340db539ab9 |
| Spec.v | e8b598fd9228177430a51e55d79b1396afe5984e5c8c0abaa6f1c2da417cb305 |
| Proof.v | 46aea8cb08f5c783514a86b1240a21fa8f5748e54a3e3a3a6af8579aa69e1cda |

- Termination：FiveQuatVmultTermination.Proof.termination_proved；精确类型 FiveQuatVmultTermination.Spec.Termination。

[精确目标核验](evidence/goal-validation.json) 绑定上述类型和定理。实际 GoalBinding 编译 015-FiveQuatVmultTermination-goal-certificate 与独立内核 016-FiveQuatVmultTermination-independent-kernel 均退出 0。原始命令与快照在 [run.json](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/run.json)。[Print Assumptions](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/logs/015-FiveQuatVmultTermination-goal-certificate.stdout.log) 保留实际继承假设：ClassicalDedekindReals.sig_forall_dec、ClassicalDedekindReals.sig_not_dec、Classical_Prop.classic、Events.external_functions_sem、Events.inline_assembly_sem、FunctionalExtensionality.functional_extensionality_dep。没有新增目标公理或 Admitted。

在仓库中 source scripts/env.sh 后执行 python3 paparazzi/models/float_quat_vmult/rocq/termination/attempts/001/check.py 可重放。

[costs.json](costs.json) 统一记录时间、token、内存。本题新检查区间 68.716944 秒，工具 CPU 66.460000 秒，采样工具树峰值 1387466752 bytes。模型 token 无逐题独立边界，逐题字段为 null，引用共享实测记录；不分摊或重复相加。共享作者原运行包含会话中断等待，所有失败和重试均保留。工具 RSS 不含模型服务端内存，可能漏峰或重复计算共享页。
