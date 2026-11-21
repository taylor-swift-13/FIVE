候选1：固定原 Paparazzi float_quat_vmult 与 float_rmat_of_quat→float_rmat_vmult 是否对同一有限有界输入逐位相等。问题保留 forall 初始内存、输入、真实正常 Csem 调用及全部12字节观察；模型没有按证明域裁剪。

结论：refuted。原 CBMC 301 项共享 ledger 中300安全/观察属性已独立重验，唯一相等断言由实际 trace 反驳。单位四元数与实际 CBMC trace 均有非空、全局初始化兼容的七块内存构造、三次原 Csem 正常调用的真实内存交接、完整输出字节、caller frame、两次真实 memcpy 及原18 guard；复制后完整三个 uint32 && 断言通过 Csem 五步归约为假。每个模型另证全可达 no-error、全后继 Acc 终止及八类全域执行对应。
