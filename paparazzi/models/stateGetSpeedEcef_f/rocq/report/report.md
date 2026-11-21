
<!-- current-acceptance -->

当前所有具名问题均通过精确类型绑定、完整源码冷编译和独立内核检查。全部真实 CBMC ID 已独立重验；失败属性的重验结论是反例成立。

| 问题 | 问题和当前证明 |
|---|---|
| cbmc_recheck | [问题](../cbmc_recheck/problem/report.md) · [证明尝试](../cbmc_recheck/attempts/001/report.md) |
| execution_correspondence | [问题](../execution_correspondence/problem/report.md) · [证明尝试](../execution_correspondence/attempts/001/report.md) |
| functional | [问题](../functional/problem/report.md) · [证明尝试](../functional/attempts/001/report.md) |
| no_error | [问题](../no_error/problem/report.md) · [证明尝试](../no_error/attempts/001/report.md) |
| termination | [问题](../termination/problem/report.md) · [证明尝试](../termination/attempts/001/report.md) |

[执行对应合同](../execution_correspondence/attempts/001/evidence/execution-contract.json) · [完整 CBMC 重验](../spec-recheck.json) · [成本](costs.json)

完整程序模型不裁剪输入域。安全/功能定理的前条件与原始有界 harness 范围分别列明。模型配置：CompCert 3.17，x86-64/Linux，小端，binary32，最近偶数舍入；源码、Source.v、Execution.v、语义库哈希及外部绑定见 align 模型清单与对应合同。原始 C、CBMC 输入和 CompCert AST 均未改。

新增 [cache_hit 问题](../cache_hit/problem/report.md) 与 [当前证明](../cache_hit/attempts/001/report.md)：原始命中路径四项目标均已证明。关联 [任意次数协议与原始新鲜性反驳](../../../../relations/state_speed_ecef_cache_protocol/problem/report.md)。原有三项错误正确性断言的反例及阶段 REFUTED 结论保留；缓存稳定不代表数据新鲜。
