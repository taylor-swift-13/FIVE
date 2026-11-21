目标为固定原 Paparazzi float_rmat_vmult，CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux、小端、binary32 RNE。前条件只要求三个不同的caller block、4字节对齐且不绕回的任意offset、36字节已初始化矩阵、12字节已初始化输入向量和12字节可写输出；所有float32含NaN、Inf和signed zero均允许。未裁剪原模型，未假定执行结果或后条件。

证明原Csem所有可达状态无错误。真实参数分配/绑定、原fn_body三次Mem.store与cleanup已建立state_eval存在。


请求目标：NoError；当前均proved。
