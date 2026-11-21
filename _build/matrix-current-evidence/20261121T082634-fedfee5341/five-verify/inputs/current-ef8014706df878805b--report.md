# 已关闭全部原始属性：float_mat_inv_2d / 尝试 002

原始 CBMC 共 190 个实际 property ID；逐 ID 独立重验为 188 proved、2 refuted、0 pending。状态 refuted 表示正缩放状态不变性与成功残差断言已由实际反例驳回，不表示程序数值正确。

原条件保持：任意 binary32 安全调用，以及原 harness 的 I、2^-8 I 和有限大对角矩阵；有效、对齐、初始化且分离的调用者对象，原展开范围和内存观察范围均不改变。模型自身保留全部参数、别名和非法内存状态，定理前条件独立列明。成功位模式包含有符号零；拒绝分支保持任意初始 memval/未知字节。原始 uint32 memcpy 观察与逻辑合取均在 Csem 中组合到实际返回内存。

原断言4/8由返回 Post → Mem.loadbytes → 真正 extcall_memcpy_sem → Mint32 载入 → 原 Csem 合取真连接；断言6由实际 before-copy → 原拒绝调用及其唯一正常返回 → 原字节不变 → after-copy → 双目标 Mint32 载入 → 原 Csem 逐对相等合取真连接。原断言9/10保留各自实际原始 arbitrary 位模式和四次调用前缀，分别证明原状态比较与真实最终内存残差赋值/短路比较返回0。未知字节没有被替换为零。

所有 190 个实际 ID 均有独立精确类型 GoalBinding 与实际 theorem 绑定；没有只重验替代断言或选定子集。见 [goal-validation.json](evidence/goal-validation.json)、[kernel-evidence.json](evidence/kernel-evidence.json)、[gate-kernel-evidence.json](evidence/gate-kernel-evidence.json) 及 [可重跑检查器](check.py)。完整依赖冷编译和独立 `rocq check` 的 CLOSED passed 运行：`_build/matrix-inv2-observer-repair/20261121T074933-7faede96e7/five-rocq`。源/规范/证明/检查器/实际编译快照逐项 hash 绑定；根验收另对关闭运行执行实际 `validate_current`。

反例9：原 I 返回0、原 2^-8 I 返回1，正缩放后状态不相等。反例10：原 2^100 I 报告成功，精确输出带有符号零，原残差的 binary32 位为 `0xbf800000`（-1），原范围比较为假。两个属性分别引用其自身真实原 trace；属性9的 trace 停在残差赋值之前，记录不会把后续写入冒充已发生前缀。见 [原始重验 ledger](../../../spec-recheck.json) 和 [按原 trace 绑定的反例](../../../report/evidence/original-ledger-binding.json)。

- `prepare/source/float_mat_inv_2d.c`: `5ff0fbc7d7284628788464d5b8d505756da59d0cddba3b97afe2a7c8d25b85e4`
- `align/model/Source.v`: `9cc1524a49e10a888c1381d5e77f6042748ebf43d2a8c2deaa7dcfd63b65e2a4`
- `align/model/Execution.v`: `03a7039fe82bf6df94795cd66ad95f1807dee7683cb40c32551aaa2f060c772e`
- `rocq/cbmc_recheck/problem/Spec.v`: `f2bfd3e509b9da216b2d0dac82bdebaf490838a38212a02b766c57904a4b1d42`
- `rocq/cbmc_recheck/attempts/002/Proof.v`: `fb857de8ccc5d43b1033c86f0a565ddc9accde9b026d3bbd8e6077794ed57d42`

直接和传递导入、原位置/范围、原 harness 与标准内建绑定，均见 [provenance.json](provenance.json) 和 canonical recheck。ABI 是 CompCert3.17 x86-64 little endian；浮点为 binary32 round-to-nearest-ties-to-even，NaN 及字节表示按冻结 CompCert/Archi hash。2D 保留原 double1e-4 比较；3D 保留 doublefabs/floatEPS 与实际运算顺序。未证明任意原 libm 实现、其他编译器机器码或硬件等价。

实际继承假设：`ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec`, `Classical_Prop.classic`, `Events.external_functions_sem`, `Events.inline_assembly_sem`, `FunctionalExtensionality.functional_extensionality_dep`。完整原始 Print Assumptions：`_build/matrix-inv2-observer-repair/20261121T074933-7faede96e7/five-rocq/logs/102-FiveMatrixClose2Recheck-goal-certificate.stdout.log`，见 [assumptions-index.json](evidence/assumptions-index.json)。没有新增用于填补目标的 Axiom，也没有 Admitted/admit。实际作者模型/effort 由 [runtime-configuration.json](evidence/runtime-configuration.json) 引用的保留原始回执支持。

成本见 [costs.json](costs.json)。包含原始构造、独立审查、失败/被取代尝试、修复和最终内核检查；逐题分摊未知为null，实际共享值留在各原始 metrics/usage 中，根汇总去重。辅助2D复制证明的两条极短 cp 命令有缺失 RSS 采样，审核限制保留，不用重放或0补造；并行联合 RSS 未观测。模型服务器/桌面内存未计入工具 RSS。
