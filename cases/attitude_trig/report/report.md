# attitude_trig

The model entry is `model/Execution.v`. Existing `theorem.txt` and kernel-check logs are historical evidence; no CBMC or Rocq verification was run for the repository organization and module naming changes on 2026-11-03.

尚未完成整个 C 函数的全可达无错误证明。

已证明 copy4、乘积数组、product_bit 索引、取模/移位数和规约循环的数学边界。仍需将指数范围从实际位操作导出，证明全局常量表初始化保持、三个循环和所有内部调用的实际状态不变式，以及欧拉角读取和矩阵写入权限。局部边界命题不等于整个三角/矩阵执行模型无错误。

执行模型及 C 源码未改变，执行域未缩小。错误沿用非正常返回且无语义后继的定义。

定理及假设见 theorem.txt；完整重新编译及独立内核检查见 ../../../reports/validation.json。


Official CompCert migration: runtime uses installed compcert.Csem/Cexec; original C and exported AST are unchanged. Generic source/executable correspondence explicitly assumes Library.environment for ordinary external calls; the full no-error proof remains incomplete. See ../../../reports/official-compcert-migration.json.
