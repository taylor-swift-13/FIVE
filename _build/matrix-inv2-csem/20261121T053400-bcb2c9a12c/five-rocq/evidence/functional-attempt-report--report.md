真实调用存在与全部返回：作者源码证明已编译。

三个目标：任意合法输入都存在原 Csem 正常调用；任何正常返回具有相同精确状态码和 Post；任意 supplied float32 矩阵都可构造满足输入条件的实际内存。Post 明确给出源读取保持、输出可写、旧块合法性和 valid_access 保持、调用者 byte frame、成功时完整 16B 编码、拒绝时完整旧输出字节（包括 Undef）保持。状态码 0 成功、1 拒绝；成功输出按原运算树保留有符号零。

准确目标：`normal_call : Spec.NormalCall`；`all_returns : Spec.AllReturns`；`nonvacuity : Spec.Nonvacuity`，命名空间 `FiveInv2Functional.Proof`。

规范 SHA256：`e599fc799fa89cd8af08be5ef3cdbf0ca460487a4e0e487d8ceb48d0bc22cd08`。证明 SHA256：`f4b4253f4411450c7fa09da80469cd59e89c3f9d9d71036d2f0a2740efc74c46`。

目标为实际 `Source.f_float_mat_inv_2d`，x86-64、小端、CompCert 3.17 / binary32 / 最近偶数舍入。原模型域未限制 NaN、Inf、非法地址或别名；安全/功能前条件只限制所请求性质的合法调用。`fabsf` 使用冻结的真实 `Ecall ___builtin_fabsf`、`EF_builtin` 单精度签名和标准 `Float32.abs`；未替换 AST、未添加外部 oracle。比较右侧保持原 unsuffixed double `1e-4`（bits 4547007122018943789）。

当前作者运行已完整编译证明源码，并对交付定理输出 `Print Assumptions`。所有原始尝试、错误和资源记录保留在 `_build/matrix-inv2-csem/20261121T053400-bcb2c9a12c/five-rocq`。最终独立内核、精确 GoalBinding 与 `validate_current` 由根调度冷检查记录完成；在实际收据生成并通过前，不把编译通过写成最终接受。

实际作者为 GPT-6.1 Sol / Ultra（用户明确要求覆盖示例的 medium 默认值），运行元数据见同一 run 的 `evidence/runtime-metadata.json`。传递假设以实际 Print Assumptions 收据为准，包括 CompCert Events 外部语义参数、函数外延性、经典逻辑及 Flocq 的实数可判定选择构造；没有新增 Axiom、Admitted 或 admit。前端导出及标准内建语义仍属声明的可信边界。

时间、token、工具 CPU/RSS 共用真实作者记录，不伪造逐问题分摊或把未知值记零。源模型哈希：
- `prepared_c`: `5ff0fbc7d7284628788464d5b8d505756da59d0cddba3b97afe2a7c8d25b85e4`
- `Source.v`: `9cc1524a49e10a888c1381d5e77f6042748ebf43d2a8c2deaa7dcfd63b65e2a4`
- `Execution.v`: `03a7039fe82bf6df94795cd66ad95f1807dee7683cb40c32551aaa2f060c772e`
