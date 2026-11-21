Original stateSetSpeedEcef_i accepted-call verification.

The original body and model are immutable. The only C exposure change is static-inline storage exposure; the body is unchanged. State uses the original656-byte layout, ushort filter/status and three int32 coordinates. InputGood states a State symbol, full State write permission, loaded ANY filter, three readable input words and source/State separation. The original call returns and copies to offsets284,288,292, stores status1, preserves the input, all old permissions and all bytes outside the14 actual written bytes.

No-error covers every reachable original Csem state under InputGood. Acc termination and the eight execution-translation obligations cover the complete raw argument/memory domain. All32 actual original CBMC IDs are independently mapped and rechecked; the proof constructs the original zero/filter/snapshot harness preparation and covers every byte index0..655.

Development proofs compile under actual GPT-6.1 Sol Ultra. Final typed-goal and independent-kernel receipts are produced by the shared checker; canonical status files and spec-recheck.json record acceptance. No original source, CBMC harness/result or align artifact was modified. CompCert3.17 x86-64 Linux little-endian C semantics is the boundary; this stage asserts no compiled GCC or hardware equivalence.

Costs are one shared two-setter authoring interval plus a separate GuardShell helper interval, each counted once globally. Command059 lost part of the historical timing due a writer collision; the surviving subset and incident are retained, so missing complete CPU/peak metrics remain null.

<!-- current-acceptance -->

当前所有具名问题均通过精确类型绑定、完整源码冷编译和独立内核检查。全部真实 CBMC ID 已独立重验；失败属性的重验结论是反例成立。

| 问题 | 问题和当前证明 |
|---|---|
| cbmc_recheck | [问题](../cbmc_recheck/problem/report.md) · [证明尝试](../cbmc_recheck/attempts/001/report.md) |
| execution_correspondence | [问题](../execution_correspondence/problem/report.md) · [证明尝试](../execution_correspondence/attempts/001/report.md) |
| no_error | [问题](../no_error/problem/report.md) · [证明尝试](../no_error/attempts/001/report.md) |
| termination | [问题](../termination/problem/report.md) · [证明尝试](../termination/attempts/001/report.md) |

[执行对应合同](../execution_correspondence/attempts/001/evidence/execution-contract.json) · [完整 CBMC 重验](../spec-recheck.json) · [成本](costs.json)

完整程序模型不裁剪输入域。安全/功能定理的前条件与原始有界 harness 范围分别列明。模型配置：CompCert 3.17，x86-64/Linux，小端，binary32，最近偶数舍入；源码、Source.v、Execution.v、语义库哈希及外部绑定见 align 模型清单与对应合同。原始 C、CBMC 输入和 CompCert AST 均未改。
