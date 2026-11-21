原始全域全后继终止：作者源码证明已编译。

`Spec.AllSuccessorsTerminate` 对任意原始 args/mem 证明 `Acc(successor Execution.ge)`。非法调用可能结束于原始错误状态；正常返回由功能问题的合法前条件单独保证。带函数调用预算的语句/表达式度量严格下降，未以有界展开或存在返回代替全部后继终止。

准确目标：`FiveInv2Termination.Proof.all_successors_terminate : FiveInv2Termination.Spec.AllSuccessorsTerminate`

规范 SHA256：`be7ad0a1da38c72a44f8e98216daa41bd2b39c1788e8e4ccdc0781b562fef1c4`。证明 SHA256：`3543b7e4a0be08779489b655fdf6030bd79ba2cd3454beed410d0d37ed43e49d`。

目标为实际 `Source.f_float_mat_inv_2d`，x86-64、小端、CompCert 3.17 / binary32 / 最近偶数舍入。原模型域未限制 NaN、Inf、非法地址或别名；安全/功能前条件只限制所请求性质的合法调用。`fabsf` 使用冻结的真实 `Ecall ___builtin_fabsf`、`EF_builtin` 单精度签名和标准 `Float32.abs`；未替换 AST、未添加外部 oracle。比较右侧保持原 unsuffixed double `1e-4`（bits 4547007122018943789）。

当前作者运行已完整编译证明源码，并对交付定理输出 `Print Assumptions`。所有原始尝试、错误和资源记录保留在 `_build/matrix-inv2-csem/20261121T053400-bcb2c9a12c/five-rocq`。最终独立内核、精确 GoalBinding 与 `validate_current` 由根调度冷检查记录完成；在实际收据生成并通过前，不把编译通过写成最终接受。

实际作者为 GPT-6.1 Sol / Ultra（用户明确要求覆盖示例的 medium 默认值），运行元数据见同一 run 的 `evidence/runtime-metadata.json`。传递假设以实际 Print Assumptions 收据为准，包括 CompCert Events 外部语义参数、函数外延性、经典逻辑及 Flocq 的实数可判定选择构造；没有新增 Axiom、Admitted 或 admit。前端导出及标准内建语义仍属声明的可信边界。

时间、token、工具 CPU/RSS 共用真实作者记录，不伪造逐问题分摊或把未知值记零。源模型哈希：
- `prepared_c`: `5ff0fbc7d7284628788464d5b8d505756da59d0cddba3b97afe2a7c8d25b85e4`
- `Source.v`: `9cc1524a49e10a888c1381d5e77f6042748ebf43d2a8c2deaa7dcfd63b65e2a4`
- `Execution.v`: `03a7039fe82bf6df94795cd66ad95f1807dee7683cb40c32551aaa2f060c772e`
