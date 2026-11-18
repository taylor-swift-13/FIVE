实际 reset 的 Csem 正常输出内存传给实际 get；任意 binary32，包括 NaN/Inf/±0/次正规；仅 writable12 初始对象，旧字段允许 Undef。全部正常返回与 value 和彼此位相同；time_const0..4 的 Mem.loadbytes 精确保持，包含未知字节。frame 分别为 reset 调用原 m 有效块的写区外及 get 调用原 mr 所有有效块。

精确问题：[Spec.v](Spec.v)。当前尝试：[001](../attempts/001/report.md)。请求目标：NormalCompletion, AllReturns。全部请求目标已证明；无 pending。最终实际源快照、GoalBinding 类型和独立内核 receipts 见尝试报告。
