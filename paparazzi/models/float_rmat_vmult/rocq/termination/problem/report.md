# float_rmat_vmult：所有后继终止性

状态：已证明。问题在 [Spec.v](Spec.v)，当前解答为 [attempt 001](../attempts/001/report.md)。

任意机器参数列表和任意 CompCert 内存；结论是原始 Csem 全部后继关系的 Acc 可访问性。终止性本身不排除到达错误，安全性由 no_error 题独立证明。

输入域没有裁剪原执行模型。规约以原始 CompCert Csyntax/Csem/Cexec 为准，输出按固定目标位模式和 Mem.loadbytes/memval 观察。

目标：Termination。本题无剩余目标；模型、来源、实际假设、核验和成本见尝试报告。
