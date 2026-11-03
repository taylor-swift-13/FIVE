# bubble_sort

尚未完成整个 C 函数的全可达无错误证明。

已证明任意长度 n 下两层循环索引、相邻元素区间和机器计数器不回绕的边界引理；共享字节复制与浮点数组存储保持引理已通过。仍需把这些事实连接到实际 Csem 循环、表达式、参数/局部帧和三次 memcpy 调用的控制状态，证明归纳不变式建立、保持和进展。预期前条件为 n 个已初始化且可写的浮点元素及不回绕地址范围；不排除 NaN/Inf。

执行模型及 C 源码未改变，执行域未缩小。错误沿用非正常返回且无语义后继的定义。

定理及假设见 theorem.txt；完整重新编译及独立内核检查见 ../../../reports/validation.json。


Official CompCert migration: runtime uses installed compcert.Csem/Cexec; original C and exported AST are unchanged. Generic source/executable correspondence explicitly assumes Library.environment for ordinary external calls; the full no-error proof remains incomplete. See ../../../reports/official-compcert-migration.json.
