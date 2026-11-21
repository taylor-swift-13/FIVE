# float_quat_vmult：原始执行语义对应，attempt 001

已证明全部 8 项请求目标；本题无 pending。问题为 [Spec.v](../../problem/Spec.v)，证明为 [Proof.v](Proof.v)。

任意机器参数列表和任意 CompCert 内存；八项命题覆盖入口、可达步、完整执行、正常返回值及内存字节、非正常无后继错误的对应。原函数无外部调用、volatile 或 I/O，包装采用记录的 quiet world。本题不替代无错误或功能性质证明。

实际数学作者为 gpt-6.1-sol，请求与实际思考强度均为 ultra；[原始配置回执](../../../../../../report/quat_rotation_paths/runtime-configuration.json)。新的 root 检查只重放未改动的证明，没有修改数学证明、规约或模型。旧成功命令保留在已中断的共享运行中；当前回执来自独立完成的新运行。

模型为 CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux standard ABI、小端、binary32 最近偶数舍入；原 C 的 binary64 常量、提升和舍入位置均保留。NaN 策略、前端和语义库由 [manifest](../../../../align/model/compcert-manifest.json) 和 [provenance](provenance.json) 固定。本题不声称任意 GCC 二进制或硬件等价。

| 输入/产物 | SHA-256 |
| --- | --- |
| C | 64c3359619e2f8de1f8c0b16ace92ab01c969fb7d408981bd68ba0fb7b8d80ff |
| Source.v | 7f5c226c3d94819451f6ccd2a5a0bb9e17360d8c026aeccefb814b3a269d5b04 |
| Execution.v | 0b476992b2f98598571949b9b1bfa7674b07cdd9b6b09f897d250340db539ab9 |
| Spec.v | 8ae266161c478f12e34a84929c01ac05794c4f6d519187f20e1a02d7f6efce6d |
| Proof.v | c5092e105e8ca6f67c71021ba4e187dc64d107ab2f147139f5553bca4fc5a8bb |

- domain_preservation：FiveQuatVmultCorrespondence.Proof.domain_preservation；精确类型 FiveQuatVmultCorrespondence.Spec.domain_preservation_goal。
- floating_point_correspondence：FiveQuatVmultCorrespondence.Proof.floating_point_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.floating_point_correspondence_goal。
- machine_integer_correspondence：FiveQuatVmultCorrespondence.Proof.machine_integer_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.machine_integer_correspondence_goal。
- memory_access_correspondence：FiveQuatVmultCorrespondence.Proof.memory_access_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.memory_access_correspondence_goal。
- control_and_exhaustion_correspondence：FiveQuatVmultCorrespondence.Proof.control_and_exhaustion_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.control_and_exhaustion_correspondence_goal。
- normal_result_and_memory_correspondence：FiveQuatVmultCorrespondence.Proof.normal_result_and_memory_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.normal_result_and_memory_correspondence_goal。
- invalid_operation_correspondence：FiveQuatVmultCorrespondence.Proof.invalid_operation_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.invalid_operation_correspondence_goal。
- whole_execution_correspondence：FiveQuatVmultCorrespondence.Proof.whole_execution_correspondence；精确类型 FiveQuatVmultCorrespondence.Spec.whole_execution_correspondence_goal。

[精确目标核验](evidence/goal-validation.json) 绑定上述类型和定理。实际 GoalBinding 编译 021-FiveQuatVmultCorrespondence-goal-certificate 与独立内核 022-FiveQuatVmultCorrespondence-independent-kernel 均退出 0。原始命令与快照在 [run.json](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/run.json)。[Print Assumptions](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/logs/021-FiveQuatVmultCorrespondence-goal-certificate.stdout.log) 保留实际继承假设：ClassicalDedekindReals.sig_forall_dec、ClassicalDedekindReals.sig_not_dec、Classical_Prop.classic、Events.external_functions_sem、Events.inline_assembly_sem、FunctionalExtensionality.functional_extensionality_dep。没有新增目标公理或 Admitted。

在仓库中 source scripts/env.sh 后执行 python3 paparazzi/models/float_quat_vmult/rocq/execution_correspondence/attempts/001/check.py 可重放。

[costs.json](costs.json) 统一记录时间、token、内存。本题新检查区间 56.731252 秒，工具 CPU 56.410000 秒，采样工具树峰值 1000222720 bytes。模型 token 无逐题独立边界，逐题字段为 null，引用共享实测记录；不分摊或重复相加。共享作者原运行包含会话中断等待，所有失败和重试均保留。工具 RSS 不含模型服务端内存，可能漏峰或重复计算共享页。
