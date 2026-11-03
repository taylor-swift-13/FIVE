# pid

尚未完成整个 C 函数的全可达无错误证明。

已证明 binary32 加减乘除在 CompCert Cop 中均返回 Some，包括 dt=0；这没有证明内存访问或调用安全。仍需已初始化 PID 结构体的读写不变式、分支和复合赋值保持、内部函数及包装函数调用边界。不能从算术总性推出整个函数无错误。

执行模型及 C 源码未改变，执行域未缩小。错误沿用非正常返回且无语义后继的定义。

定理及假设见 theorem.txt；完整重新编译及独立内核检查见 ../../../reports/validation.json。


Official CompCert migration: runtime uses installed compcert.Csem/Cexec; original C and exported AST are unchanged. Generic source/executable correspondence explicitly assumes Library.environment for ordinary external calls; the full no-error proof remains incomplete. See ../../../reports/official-compcert-migration.json.
