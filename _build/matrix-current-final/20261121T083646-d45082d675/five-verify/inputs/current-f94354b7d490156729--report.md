# float_mat_inv_2d / no_error

对满足独立前条件的任意机器参数与初始内存，证明原始 Csem 的所有可达状态均不是错误状态。前条件要求调用类型、已初始化的输入 float32 单元、可读/可写权限、对齐、地址不回绕及调用者输入输出对象分离；任意 binary32 位模式（含 NaN、无穷及有符号零）均在数值量词内，初始输出字节可以未知。

规范为 [Spec.v](Spec.v)，当前状态与全部请求目标见 [status.json](status.json)。当前接受尝试为 [001](../attempts/001/report.md)，没有该问题尚未证明的请求目标。

- `NoError`: `FiveInv2NoError.Spec.NoError` → `FiveInv2NoError.Proof.no_error_proved`

执行范围是冻结准备代码与声明的标准内建绑定；不宣称任意原 libm、其他编译器二进制或硬件实现已建立对应。
