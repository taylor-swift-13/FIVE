# 交替零均值位置输入的实际积分漂移

用户目标：在未修改的 `guidance_pid_h_run_pos` CompCert Csem 模型上，对所有整数码 `0≤A≤4096`、`0≤kp,ki≤100` 与所有自然数 n，参考位置逐拍为 +A、−A，测量位置为0，其余增益 kd/kv/ka、速度、参考速度/加速度、y轴和heading为0，in_flight=true、approx_force_by_thrust=false、NED缓存有效。每拍满足原始 InputGood 数值、内存与别名域；环境保留实际积分状态。

设 L=1429×65536=93650944，初始实际x积分为0。对任何实际原始 Csem 2n次调用轨迹，最终存储x积分的 Int.signed 观察应为：64整除 kp×A 时0，否则 −min(n×ki,L)。负数算术右移取下整，饱和和32位精确算术均须由原模型导出。

`Spec.v` 是唯一问题规范。`AlternatingPairs` 每个构造步骤包含两次原始 `NormalCall`；环境使用已有 `EnvironmentStep`，仅允许输入字节变化并显式保留实际积分。`AlternatingInput` 只约束当拍输入、原始有效域及实际读得的积分；不含输出公式或未来执行假设。

验收目标：`DriftGoal`（全部轨迹的精确公式）、`InitialExistenceGoal`（所有符号参数真实初始内存）、`ReadyExecutionGoal`（任意合法Ready驱动产生真实调用）、`ExecutionExistenceGoal`（所有参数及任意n存在实际2n调用轨迹）。后者单独排除以准备性假设替代真实可实现性的空洞结论。

当前尝试见 `status.json`。仅请求本关系证明；不重新运行CBMC、align，不修改原模型、旧证明或论文。Csem结论继承原CompCert及既有语义证明的标准可信边界；具体假设以本尝试实际 Print Assumptions 与独立内核回执为准。
