# float_rmat_of_quat：原始执行语义对应

状态：已证明。问题在 [Spec.v](Spec.v)，当前解答为 [attempt 001](../attempts/001/report.md)。

任意机器参数列表和任意 CompCert 内存；八项命题覆盖入口、可达步、完整执行、正常返回值及内存字节、非正常无后继错误的对应。原函数无外部调用、volatile 或 I/O，包装采用记录的 quiet world。本题不替代无错误或功能性质证明。

输入域没有裁剪原执行模型。规约以原始 CompCert Csyntax/Csem/Cexec 为准，输出按固定目标位模式和 Mem.loadbytes/memval 观察。

目标：domain_preservation、floating_point_correspondence、machine_integer_correspondence、memory_access_correspondence、control_and_exhaustion_correspondence、normal_result_and_memory_correspondence、invalid_operation_correspondence、whole_execution_correspondence。本题无剩余目标；模型、来源、实际假设、核验和成本见尝试报告。
