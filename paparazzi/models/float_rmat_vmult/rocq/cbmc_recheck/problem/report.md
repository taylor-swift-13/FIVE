目标为固定原 Paparazzi float_rmat_vmult，CompCert 3.17 Csyntax/Csem/Cexec，x86-64 Linux、小端、binary32 RNE。前条件只要求三个不同的caller block、4字节对齐且不绕回的任意offset、36字节已初始化矩阵、12字节已初始化输入向量和12字节可写输出；所有float32含NaN、Inf和signed zero均允许。未裁剪原模型，未假定执行结果或后条件。

仅本函数原始99个属性已重验：90个dereference和9个array bounds；不代表共享301项全部完成。每一ID绑定原AST实际source site，所有可达expression/subredex的imm_safe、实际float Mem.loadv/Mem.storev存在性，及所有正常return的12输出字节与caller frame。原harness有界有限域是本定理所有float域的子域。

运行时安全量化所有实际reachable expression contexts；固定下标0..8与原source AST的精确子表达式由nth_error/reflexivity核对。

请求目标：AllOriginal99, RuntimeDefined, ExactObservation；当前均proved。
