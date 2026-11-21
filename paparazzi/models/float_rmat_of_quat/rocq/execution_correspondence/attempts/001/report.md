# float_rmat_of_quat：原始执行语义对应，attempt 001

已证明全部 8 项请求目标；本题无 pending。问题为 [Spec.v](../../problem/Spec.v)，证明为 [Proof.v](Proof.v)。

任意机器参数列表和任意 CompCert 内存；八项命题覆盖入口、可达步、完整执行、正常返回值及内存字节、非正常无后继错误的对应。原函数无外部调用、volatile 或 I/O，包装采用记录的 quiet world。本题不替代无错误或功能性质证明。

实际数学作者为 gpt-6.1-sol，请求与实际思考强度均为 ultra；[原始配置回执](../../../../../../report/quat_rotation_paths/runtime-configuration.json)。新的 root 检查只重放未改动的证明，没有修改数学证明、规约或模型。旧成功命令保留在已中断的共享运行中；当前回执来自独立完成的新运行。

模型为 CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux standard ABI、小端、binary32 最近偶数舍入；原 C 的 binary64 常量、提升和舍入位置均保留。NaN 策略、前端和语义库由 [manifest](../../../../align/model/compcert-manifest.json) 和 [provenance](provenance.json) 固定。本题不声称任意 GCC 二进制或硬件等价。

| 输入/产物 | SHA-256 |
| --- | --- |
| C | 5d5e765cf53bd21025c740ed40c0ef5d7f2650b85c30fd125911826efb03e44e |
| Source.v | 98aa27469ac90ded8c1f0720ae84e04b78f038d1281796696220d61f6e56689c |
| Execution.v | 92a529f71bfdf4ea1cc35a4b5afb9871416e915184e574efdff739710b9d9b37 |
| Spec.v | 3017fddd7cd08e015f232155b6b3f8fcbb77e5171e69d8b6c178fd0631adaa6e |
| Proof.v | 10789b0c178bd9786c63ea391c3da1f5f73329726376f98952b5215652cd985a |

- domain_preservation：FiveRmatOfQuatCorrespondence.Proof.domain_preservation；精确类型 FiveRmatOfQuatCorrespondence.Spec.domain_preservation_goal。
- floating_point_correspondence：FiveRmatOfQuatCorrespondence.Proof.floating_point_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.floating_point_correspondence_goal。
- machine_integer_correspondence：FiveRmatOfQuatCorrespondence.Proof.machine_integer_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.machine_integer_correspondence_goal。
- memory_access_correspondence：FiveRmatOfQuatCorrespondence.Proof.memory_access_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.memory_access_correspondence_goal。
- control_and_exhaustion_correspondence：FiveRmatOfQuatCorrespondence.Proof.control_and_exhaustion_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.control_and_exhaustion_correspondence_goal。
- normal_result_and_memory_correspondence：FiveRmatOfQuatCorrespondence.Proof.normal_result_and_memory_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.normal_result_and_memory_correspondence_goal。
- invalid_operation_correspondence：FiveRmatOfQuatCorrespondence.Proof.invalid_operation_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.invalid_operation_correspondence_goal。
- whole_execution_correspondence：FiveRmatOfQuatCorrespondence.Proof.whole_execution_correspondence；精确类型 FiveRmatOfQuatCorrespondence.Spec.whole_execution_correspondence_goal。

[精确目标核验](evidence/goal-validation.json) 绑定上述类型和定理。实际 GoalBinding 编译 032-FiveRmatOfQuatCorrespondence-goal-certificate 与独立内核 033-FiveRmatOfQuatCorrespondence-independent-kernel 均退出 0。原始命令与快照在 [run.json](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/run.json)。[Print Assumptions](../../../../../../../_build/quat-rotation-root/structural-current/20261120T105030-c520032c69/five-verify/logs/032-FiveRmatOfQuatCorrespondence-goal-certificate.stdout.log) 保留实际继承假设：ClassicalDedekindReals.sig_forall_dec、ClassicalDedekindReals.sig_not_dec、Classical_Prop.classic、Events.external_functions_sem、Events.inline_assembly_sem、FunctionalExtensionality.functional_extensionality_dep。没有新增目标公理或 Admitted。

在仓库中 source scripts/env.sh 后执行 python3 paparazzi/models/float_rmat_of_quat/rocq/execution_correspondence/attempts/001/check.py 可重放。

[costs.json](costs.json) 统一记录时间、token、内存。本题新检查区间 51.942528 秒，工具 CPU 51.750000 秒，采样工具树峰值 999084032 bytes。模型 token 无逐题独立边界，逐题字段为 null，引用共享实测记录；不分摊或重复相加。共享作者原运行包含会话中断等待，所有失败和重试均保留。工具 RSS 不含模型服务端内存，可能漏峰或重复计算共享页。
