# float_mat_inv_3d：Rocq 最终验收

五类问题全部验收完成；原始 CBMC 共 208 项，其中 206 项独立重证、2 项用原始反例证明为不成立。

| 问题 | 状态 | 当前尝试 | 目标数 |
|---|---|---|---:|
| no_error | proved | [001](../no_error/attempts/001/report.md) | 1 |
| termination | proved | [001](../termination/attempts/001/report.md) | 1 |
| functional | proved | [001](../functional/attempts/001/report.md) | 2 |
| execution_correspondence | proved | [001](../execution_correspondence/attempts/001/report.md) | 8 |
| cbmc_recheck | refuted | [003](../cbmc_recheck/attempts/003/report.md) | 208 |

无错误证明覆盖明确前条件下原始 Csem 的所有可达状态；输入、输出分别为合法分离的对齐数组，输入单元已初始化，输出单元可写，地址不回绕。数值允许所有 binary32 位模式。终止性使用全部 Csem 后继上的 Acc；非法调用可能阻塞，不能把全域不存在无限执行理解成所有非法调用正常返回。功能证明提供正常调用存在性、所有正常返回的结果、逐字节输出及写区外 frame。

执行层始终为原始 CompCert Csyntax/Csem/Cexec，未通过定理前条件删减机器输入或内存。目标为 CompCert3.17、x86-64 Linux standard ABI、小端、binary32 最近偶数舍入及固定 NaN 策略。源码、模型、规范、实际编译快照和继承假设均由各尝试绑定。

传统 CBMC 的全属性账本、真实输入位和已发生内存修改前缀均保留。重验证明从实际调用后的 Post 连接到内存读取和断言观察；已反驳的是缩放状态不变与成功结果残差约束。历史尝试中缺失的观察连接在后续尝试中补齐，旧尝试和成本保留。组合门禁为 accepted，见 [原始输出](evidence/gate.stdout.log)。

证明作者使用实际 gpt-6.1-sol、Ultra，运行回执、Print Assumptions 和独立内核检查见各尝试。源抽取、前端和显式 fabs/fabsf 内建绑定属于记录的可信边界；未声称一般 libm 或任意 GCC 二进制等价。

[成本](costs.json)统一记录时间、token、工具内存，保留失败、修复和检查。共享事件按 ID 去重；未独立观测的逐定理分摊或并发联合峰值为 null，并给出范围及原因。[完整工作流汇总](../../../../relations/matrix_inverse_scale/evidence/workflow-costs.json)保留历史和本次继续工作的边界。
