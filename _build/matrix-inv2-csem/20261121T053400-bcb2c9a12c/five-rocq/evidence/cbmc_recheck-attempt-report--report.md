全部 190 个实际 CBMC ID 独立重验：作者源码证明已编译。

实际 ledger 全部保留：144 个源码地址/解引用 guard、36 个真实 memcpy guard/前条件、8 个成功断言均有独立 Rocq 证明；2 个实际失败断言以原反例重放反驳。每个 ID 在 `Spec.P001`–`P190` 与 `Proof.property_001`–`property_190` 一一绑定，顺序见 goal-index.json。memcpy 采用实际 16B `extcall_memcpy_sem` / `Mem.storebytes`，证明 uint32 Mint32 读取恰为原 binary32 bits；对象间内部 guard 映射到块分离，不假设不相关 C 指针间次序。

两个原 trace 的 arbitrary 输入相同：`fea1e6c9 3f947db7 00eb142c 6fe26b14`；真实输出 `80000000 00000000 00000000 00000000`，返回 0。guarded.value 位于同一个 24B 结构块 offset 4，初始全 +0，guard words 位于 0/20。基准、小尺度、大尺度输出初始均为 `41880000 00000000 00000000 41880000`。ExactReplay 已构造一个初始化共同内存并按原顺序证明全部 4 次原 Csem 调用存在；每次 Post 保留实际写入/字节 frame。identity 返回 0；2^-8 I 返回 1 并保持原字节；2^100 I 返回 0、det=+Inf、对角输出 +0，残差分量 -1。

`main.assertion.9` 的正比例状态不变为假；`main.assertion.10` 的成功必有小残差为假。二者是反驳，不是数值正确性。反例为目标源调用与 byte-copy 观察的已证明组合；harness 自身没有另行导出成单体 Csem AST。

准确目标：全部 `FiveInv2Recheck.Proof.property_001`–`property_190 : FiveInv2Recheck.Spec.P001`–`P190`。

规范 SHA256：`ad7bd7b7fd160935385a9af54746cbc71dae58244efd70158a27ba91c23e3f3c`。证明 SHA256：`bb73caa0305e620f7db90838bba24a5d701bcd542b516f970b515932f55d5a97`。

目标为实际 `Source.f_float_mat_inv_2d`，x86-64、小端、CompCert 3.17 / binary32 / 最近偶数舍入。原模型域未限制 NaN、Inf、非法地址或别名；安全/功能前条件只限制所请求性质的合法调用。`fabsf` 使用冻结的真实 `Ecall ___builtin_fabsf`、`EF_builtin` 单精度签名和标准 `Float32.abs`；未替换 AST、未添加外部 oracle。比较右侧保持原 unsuffixed double `1e-4`（bits 4547007122018943789）。

当前作者运行已完整编译证明源码，并对交付定理输出 `Print Assumptions`。所有原始尝试、错误和资源记录保留在 `_build/matrix-inv2-csem/20261121T053400-bcb2c9a12c/five-rocq`。最终独立内核、精确 GoalBinding 与 `validate_current` 由根调度冷检查记录完成；在实际收据生成并通过前，不把编译通过写成最终接受。

实际作者为 GPT-6.1 Sol / Ultra（用户明确要求覆盖示例的 medium 默认值），运行元数据见同一 run 的 `evidence/runtime-metadata.json`。传递假设以实际 Print Assumptions 收据为准，包括 CompCert Events 外部语义参数、函数外延性、经典逻辑及 Flocq 的实数可判定选择构造；没有新增 Axiom、Admitted 或 admit。前端导出及标准内建语义仍属声明的可信边界。

时间、token、工具 CPU/RSS 共用真实作者记录，不伪造逐问题分摊或把未知值记零。源模型哈希：
- `prepared_c`: `5ff0fbc7d7284628788464d5b8d505756da59d0cddba3b97afe2a7c8d25b85e4`
- `Source.v`: `9cc1524a49e10a888c1381d5e77f6042748ebf43d2a8c2deaa7dcfd63b65e2a4`
- `Execution.v`: `03a7039fe82bf6df94795cd66ad95f1807dee7683cb40c32551aaa2f060c772e`
