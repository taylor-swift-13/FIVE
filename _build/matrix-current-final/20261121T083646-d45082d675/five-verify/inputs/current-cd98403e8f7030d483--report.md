# float_mat_inv_2d / execution_correspondence

八项目标对任意参数、任意内存及原始 Csem 全执行量化：入口域、浮点、整数、内存、控制/耗尽、返回值与字节观察、非法操作及完整执行。使用原始 Source.v、Execution.v 与 Cexec 语义闭包；非法内存、别名及所有机器值均保留，domain restrictions 为空。

规范为 [Spec.v](Spec.v)，当前状态与全部请求目标见 [status.json](status.json)。当前接受尝试为 [001](../attempts/001/report.md)，没有该问题尚未证明的请求目标。

- `domain_preservation_goal`: `FiveInv2Correspondence.Spec.domain_preservation_goal` → `FiveInv2Correspondence.Proof.domain_preservation`
- `floating_point_correspondence_goal`: `FiveInv2Correspondence.Spec.floating_point_correspondence_goal` → `FiveInv2Correspondence.Proof.floating_point_correspondence`
- `machine_integer_correspondence_goal`: `FiveInv2Correspondence.Spec.machine_integer_correspondence_goal` → `FiveInv2Correspondence.Proof.machine_integer_correspondence`
- `memory_access_correspondence_goal`: `FiveInv2Correspondence.Spec.memory_access_correspondence_goal` → `FiveInv2Correspondence.Proof.memory_access_correspondence`
- `control_and_exhaustion_correspondence_goal`: `FiveInv2Correspondence.Spec.control_and_exhaustion_correspondence_goal` → `FiveInv2Correspondence.Proof.control_and_exhaustion_correspondence`
- `normal_result_and_memory_correspondence_goal`: `FiveInv2Correspondence.Spec.normal_result_and_memory_correspondence_goal` → `FiveInv2Correspondence.Proof.normal_result_and_memory_correspondence`
- `invalid_operation_correspondence_goal`: `FiveInv2Correspondence.Spec.invalid_operation_correspondence_goal` → `FiveInv2Correspondence.Proof.invalid_operation_correspondence`
- `whole_execution_correspondence_goal`: `FiveInv2Correspondence.Spec.whole_execution_correspondence_goal` → `FiveInv2Correspondence.Proof.whole_execution_correspondence`

执行范围是冻结准备代码与声明的标准内建绑定；不宣称任意原 libm、其他编译器二进制或硬件实现已建立对应。
