# Rocq 证明证据与最终验收

five-align 交付模型、来源审计、spec-map 与待证目标；本文件规定 five-rocq 产出的证明证据以及 five-verify 的验收要求。模型生成阶段不要求这些定理已完成。

## 全执行对应证据

`execution-contract.json` 使用既有八类全执行义务。声明和对应关系由 align 交接；证明由 rocq 完成。最终声称全域执行对应时，每条必须 proof-backed、status proved，域与冻结 request 一致且 domain_restrictions 为空：

```text
execution_backend: compcert-csyntax-cexec
backend_manifest_sha256: 当前 manifest hash
alignment_issues: [{issue_id: 稳定ID, status: resolved, ...}]
```

execution_entry 绑定生成的 Execution.v/module/entry；source_semantics.source_sha256 至少包含原 C、Source.v 和 Execution.v，以及所用库适配器/规约/注册表。清楚列出可信外部库假设、world/volatile/I/O 范围。主 agent 审查命题充分性，metadata 本身不能证明命题覆盖完整。

无真实问题时 alignment_issues 为空；最终验收时实际问题须关闭。移交给 rocq 的待证义务不在生成阶段虚报为已解决。

## CBMC 独立重验结果

align 的 `spec-map.json` 是属性映射；rocq 在实际证明或反驳后输出 `spec-recheck.json`，schema 为 `five-cbmc-rocq-recheck/1`：

- request_sha256、backend_manifest_sha256 绑定同一请求和模型。
- verification_method 为 traditional-bounded-model-checking。
- cbmc_run、cbmc_command_id、cbmc_json 指向真实 CBMC 命令和原始 JSON stdout；cbmc_input_sha256 覆盖实际原 C/harness 等输入。
- properties 覆盖全部实际 property ID，不漏项、不重复。scope 保留原前条件、位置、内存区域、调用/展开范围和观察；theorem 是模型侧真实命题，evidence 是证明记录。
- 只有独立证据成立时才标 proved/refuted。现有完整重验门禁要求 SUCCESS 对应 proved、FAILURE 对应 refuted；UNKNOWN、超时、未完成或语义差异只能记 pending/gap，不能进入完整通过状态。
- 实际 FAILURE 的 counterexample_replay 绑定原始 trace、输入位/字节、出错操作和修改前缀。可用 Csem 执行关系证明复现，不要求直接 vm_compute。未复现不伪造 reproduced。反例证实表示原属性不成立。

CBMC 结论不是 Rocq 的公理，也不能以纯功能模型的相似断言代替执行层重验。

## 内核与假设证据

每个 evidence 的 kind 为 rocq-kernel-check，含 run、command_id、theorems、statement_artifacts、dependency_sha256。引用的 run.json 必须包含成功的实际 `rocq check`/`coqchk` 命令，检查所声称定理所在模块；禁止 admit/norec 等绕过检查选项。

依赖和声明应匹配真实 proof run 的输入快照，且在该运行中实际编译，不能只重填当前 hash。记录 `Print Assumptions` 和继承假设；声明编译通过并不证明待证命题。执行对应和属性重验使用相同证据标准。

## 最终门禁

```sh
python3 scripts/compcert-verify.py gate --request request.json \
  --request-sha256 FROZEN_HASH --contract execution-contract.json \
  --manifest _build/compcert/case/compcert-manifest.json \
  --spec-recheck spec-recheck.json
```

门禁实施新鲜来源审计、外部支持清单检查、全执行对应证明记录检查、实际 CBMC 属性的 Rocq 重验及问题关闭核查。不要求 agent 审批。最终验证统一使用 `compcert-verify.py gate`，不作为 align 的生成阶段验收条件。

门禁接受的范围是执行层与 CBMC 重验；独立的无错误、终止性和高层功能目标应另外核对相应 Rocq 定理的量词、前条件、实际证明/内核证据和当前依赖。不能因为 gate accepted 就把这些目标自动标为 proved。没有完整证据时给出范围明确的阶段报告和 pending 项。

## Gold-standard completion and observation boundary

The [shared case contract](case-contract.md) and its examples index define the normative problem/attempt layout. Validate the active attempt, preserving historical attempts and their original outcomes. A whole-task `COMPLETE` requires closure of every requested goal and every actual CBMC property ID under its original conditions, plus successful independent receipts bound to the exact current statements and dependencies. Checking one replacement assertion or a selected subset cannot close the original ledger. Counterexample replay may close an actual failed property as `refuted`, never as program correctness; unexplained UNKNOWN or semantic mismatch stays pending/gap. Generation-only requests correctly stop with declared pending obligations.

Memory-property statements must identify target representation and endian, source/destination ranges, CompCert `memval`/`Mem.loadbytes` interpretation, actual write prefix, and frame conditions. A numerical equality alone does not establish byte-copy or assertion-expression properties. All-reachable-state safety and all-successor termination remain distinct from finite executions or existence of a normal return. Metadata and a successful gate do not replace review of those quantifiers or additional requested goals.
