# float_mat_inv_2d / 原始 CBMC 全属性重验

原始 CBMC 共 190 个实际 property ID；逐 ID 独立重验为 188 proved、2 refuted、0 pending。状态 refuted 表示正缩放状态不变性与成功残差断言已由实际反例驳回，不表示程序数值正确。

原条件保持：任意 binary32 安全调用，以及原 harness 的 I、2^-8 I 和有限大对角矩阵；有效、对齐、初始化且分离的调用者对象，原展开范围和内存观察范围均不改变。模型自身保留全部参数、别名和非法内存状态，定理前条件独立列明。成功位模式包含有符号零；拒绝分支保持任意初始 memval/未知字节。原始 uint32 memcpy 观察与逻辑合取均在 Csem 中组合到实际返回内存。

原断言4/8由返回 Post → Mem.loadbytes → 真正 extcall_memcpy_sem → Mint32 载入 → 原 Csem 合取真连接；断言6由实际 before-copy → 原拒绝调用及其唯一正常返回 → 原字节不变 → after-copy → 双目标 Mint32 载入 → 原 Csem 逐对相等合取真连接。原断言9/10保留各自实际原始 arbitrary 位模式和四次调用前缀，分别证明原状态比较与真实最终内存残差赋值/短路比较返回0。未知字节没有被替换为零。

规范为 [Spec.v](Spec.v)，所有实际 ID 与当前尝试见 [status.json](status.json)。当前接受尝试为 [002](../attempts/002/report.md)。原始逐 ID 条件、位置和证明绑定见 [spec-recheck.json](../../spec-recheck.json)；没有遗漏的请求目标。
