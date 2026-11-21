# float_mat_inv_3d / termination

对任意机器参数与任意初始内存证明 Acc(successor ge)(entry args m)，覆盖所有可能后继。此命题不要求安全前条件；非法输入仍保留原始停滞/错误语义。它不是有限展开、单条返回路径或存在性终止。

规范为 [Spec.v](Spec.v)，当前状态与全部请求目标见 [status.json](status.json)。当前接受尝试为 [001](../attempts/001/report.md)，没有该问题尚未证明的请求目标。

- `Termination`: `FiveMatInv3Termination.Spec.Termination` → `FiveMatInv3Termination.Proof.termination_proved`

执行范围是冻结准备代码与声明的标准内建绑定；不宣称任意原 libm、其他编译器二进制或硬件实现已建立对应。
