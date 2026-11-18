getter 原始 Csyntax/Csem/Cexec，模型覆盖任意机器参数和内存；安全/正常功能条件为对齐不绕回指针与 last_out 可读且含 typed binary32，其余字段不要求初始化，数值域不限制。终止性目标为所有 args/m 的 Acc，包含无后继非法状态的有限停止；在安全条件下另证正常返回存在。功能 frame 涵盖调用前有效块的每个 Mem.loadbytes 观察。CBMC19项各保留实际原ID/条件/表达式观察并独立证明。

精确问题：[Spec.v](Spec.v)。当前尝试：[001](../attempts/001/report.md)。请求目标：NormalCompletion, AllReturns。全部请求目标已证明；无 pending。最终实际源快照、GoalBinding 类型和独立内核 receipts 见尝试报告。
