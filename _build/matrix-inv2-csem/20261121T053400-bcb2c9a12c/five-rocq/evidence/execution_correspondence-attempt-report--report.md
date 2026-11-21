八类原始执行对应：作者源码证明已编译。

八目标覆盖原始域、浮点、机器整数、内存访问、控制/耗尽、正常结果与内存、非法操作及全部执行。每个原 args/mem 的全部可达原 Csem 步与实际 Cexec animator 步精确对应，两个 star 互相等价；错误状态和 byte 观察保持。域限制为空。

准确目标：命名空间 `FiveInv2Correspondence.Proof`，八个与 `Spec.<name>_goal` 精确对应的同名定理。

规范 SHA256：`698513d0e2c8baa40485ebbc20bc864908e412c330a3b6f1b0532dbebd517ed6`。证明 SHA256：`7b42d6d5e76e0620860504d91a3209dada1bd31757e5cf9c737bc0766b673b76`。

目标为实际 `Source.f_float_mat_inv_2d`，x86-64、小端、CompCert 3.17 / binary32 / 最近偶数舍入。原模型域未限制 NaN、Inf、非法地址或别名；安全/功能前条件只限制所请求性质的合法调用。`fabsf` 使用冻结的真实 `Ecall ___builtin_fabsf`、`EF_builtin` 单精度签名和标准 `Float32.abs`；未替换 AST、未添加外部 oracle。比较右侧保持原 unsuffixed double `1e-4`（bits 4547007122018943789）。

当前作者运行已完整编译证明源码，并对交付定理输出 `Print Assumptions`。所有原始尝试、错误和资源记录保留在 `_build/matrix-inv2-csem/20261121T053400-bcb2c9a12c/five-rocq`。最终独立内核、精确 GoalBinding 与 `validate_current` 由根调度冷检查记录完成；在实际收据生成并通过前，不把编译通过写成最终接受。

实际作者为 GPT-6.1 Sol / Ultra（用户明确要求覆盖示例的 medium 默认值），运行元数据见同一 run 的 `evidence/runtime-metadata.json`。传递假设以实际 Print Assumptions 收据为准，包括 CompCert Events 外部语义参数、函数外延性、经典逻辑及 Flocq 的实数可判定选择构造；没有新增 Axiom、Admitted 或 admit。前端导出及标准内建语义仍属声明的可信边界。

时间、token、工具 CPU/RSS 共用真实作者记录，不伪造逐问题分摊或把未知值记零。源模型哈希：
- `prepared_c`: `5ff0fbc7d7284628788464d5b8d505756da59d0cddba3b97afe2a7c8d25b85e4`
- `Source.v`: `9cc1524a49e10a888c1381d5e77f6042748ebf43d2a8c2deaa7dcfd63b65e2a4`
- `Execution.v`: `03a7039fe82bf6df94795cd66ad95f1807dee7683cb40c32551aaa2f060c772e`
