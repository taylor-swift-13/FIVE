# FIVE 共享案例目录与阶段交接契约

## Gold-standard authority and layout

[Examples index](../../../../examples/README.md), [sum3](../../../../examples/models/sum3/README.md), [sum2](../../../../examples/models/sum2/README.md), and [cross-model relations](../../../../examples/relations/) are the normative, maintained artifact examples for all future FIVE verification work. Read the relevant concrete reference before creating artifacts. Their format is authoritative; their particular inputs, preconditions and outcomes do not constrain another user's problem.

The outer case location is project-selected. Its internal C workflow has exactly four stage output directories, in dependency order:

```text
<case>/
  prepare/{source/,report/,handoff.json}
  cbmc/{harness.c,report/,handoff.json}   # actual harness/log filenames follow the examples
  align/{model/,report/,handoff.json}   # generated declarations remain model artifacts
  rocq/{support/,report/,handoff.json,spec-recheck.json}
    no_error/{problem/,attempts/001/}
    termination/{problem/,attempts/001/}
    cbmc_recheck/{problem/,attempts/001/}
<examples-or-project>/relations/<relation>/{problem/,attempts/001/}
```

Each stage has `report/report.md`, `report/costs.json` and `handoff.json`; the handoff binds input/output roles, paths and SHA-256. Preserve tool manifests where actually produced. Paths below such as `source/`, `model/` and generated `proof/` are relative to their owning stage: prepared source is `prepare/source/`, generated AST is `align/model/Source.v`, and generated obligation scaffolding is `align/model/proof/`. Actual proofs belong under `rocq/<problem>/attempts/`, never in place of the immutable generated model. Shared evidence may live elsewhere if a resolvable hash-bound reference identifies it.

For a complete C workflow, freeze source, dependencies, verification request, requested properties/conditions/bounds and target before checking; preserve every actual emitted property ID in the CBMC handoff before mapping. `prepare/handoff.json` is CBMC input; `cbmc/handoff.json` is align input; `align/handoff.json` is Rocq input. Each next stage verifies status and hashes of all transitive artifacts it consumes. The prepared C and bindings are identical throughout. Missing request/input or changed hashes block dependent work instead of silently substituting inputs. Pure model generation and pure Rocq requests run only the applicable stages; record others `not_run` or `not_applicable`, without fabricating source, CBMC runs or proofs. Standalone align may generate a model without CBMC, recording mapping as not applicable.

Status describes evidence: `not_run`, `not_applicable`, `blocked`, `pending`, `failed`, `proved` or `refuted` as applicable. A generation stage can finish with explicitly pending proofs when generation alone was requested. A real counterexample with checked replay can complete a requested refutation; this is never program correctness. Do not claim whole-task `COMPLETE` while any requested goal, actual CBMC property ID or required independent receipt remains open. Report the actual result and remaining items; unobserved cost figures are `null`, with reasons, and observed figures are `recorded`. Do not label a user-facing result summary `partial`; raw telemetry status is preserved unchanged.

## 固定交接接口

每个阶段读取当前 case 中前序阶段的 handoff 与自身阶段的 `report/report.md`、`report/costs.json`（首次调用时建立），在启动前核对直接输入的路径、hash、目标配置和前一阶段状态；有缺失、内容变化或依赖不可用时停止依赖该输入的步骤，登记原因，不静默替代。执行完成后仅增量更新自己的阶段状态、输入/输出路径与 SHA-256、工具版本/选项和成本引用。路径均以 case 目录为基准，允许指向存在的共享文件。状态只能表示实际证据支持的程度。报告生成/类型检查、证明、成本审核分别记状态。

| skill | 必需输入 | 写入与交给下游 |
|---|---|---|
| five-prepare | 原 C、入口、目标语义、依赖及用户要求；输入可来自案例外 | `prepare/source/<entry>.c`、实际依赖和 `prepare/source/bindings.json`；在报告/handoff 固定准备结果和限制，供 CBMC 与 align 消费 |
| five-cbmc | 已准备的 `prepare/source/`、bindings、入口和用户指定检查性质/界限 | `cbmc/` 的 harness、命令、属性、假设、范围、结果及实际反例，handoff 索引并标明状态；交给 align |
| five-align | 已准备的 `prepare/source/` 和 bindings；若映射 CBMC 规约，还需实际 `cbmc/` 属性与范围 | `align/model/preprocessed.i`、`align/model/Source.v`、`align/model/Execution.v`、生成的三个 `align/model/proof/*.v`、来源审计及适用时由 handoff 的 spec-map 角色绑定的属性映射，供 rocq 使用；未运行 CBMC 不阻塞模型生成 |
| five-rocq | 一个或多个已有 Rocq 模型及用户目标；CompCert 任务还读 align 的模型、义务和映射 | 前条件、规约、证明和假设、内核证据及适用时 `rocq/spec-recheck.json`，交给 verify；纯 Rocq 无需 C 或 CBMC |
| five-verify | 用户目标和案例清单；分别读取所请求阶段的实际交付 | 调度与接口检查，引用四阶段 `report/` 并更新案例汇总（不新增第五个阶段目录）、未完成项及去重后的成本；不将生成当证明 |

`prepare/source/bindings.json` 至少登记：原始源文件与准备后的源文件路径及 SHA-256、实际依赖与版本或 hash、入口、C 方言和目标 ABI/端序/浮点与舍入、预处理和编译选项、外部调用原绑定与实际绑定、重定向实现及其来源/哈希、尚需证明的对应关系。未知或不可恢复字段写 `null` 并说明原因；不得猜测未发生重定向。准备后的程序是两个分支的相同输入；改回原库绑定的性质迁移必须另有对应性证据。

每个实际阶段在 `<stage>/handoff.json` 使用 `schema: "five-stage-handoff/1"`，包含 `case_id`、`stage`、`status`、`target`、`paths_relative_to`、`outputs`、`limitations` 及适用的 `next_stage`。`outputs` 每项含 `role`、case 相对 `path` 和小写 SHA-256 `sha256`，包括供下游使用的传递输入。阶段报告和成本分别为 `<stage>/report/report.md`、`<stage>/report/costs.json`。补充 manifest 仅在实际工具或案例使用时保留并 hash 绑定，不要求案例根目录另建 `report/` 或虚构第五个阶段目录。先读取真实 handoff 的 role/path 再解析文件，不从历史默认文件名猜输入。生成的 CompCert manifest 保持工具原 schema，不能改成 handoff schema。

未知数值为 `null` 和原因，不能用 0 或估算。失败、重试及准备阶段均计入；案例独立边界需在开始前采集，批次共享消耗单列并引用，不能伪造逐案例实测或重复相加。每个实际执行阶段通过 `scripts/audit-costs.py --run RUN_DIR` 核查计量证据；审计完整性与验证结果独立陈述。

`report/costs.json` 使用 `schema: "five-stage-costs/1"`，以 `records` 数组保存本阶段及适用的历史或共享记录。每条记录有 `stage`、`run`、`status`、`evidence` 和三组实测字段：

- `time.wall_seconds`、`time.tool_cpu_seconds`
- `token.input`、`token.output`、`token.total`、`token.cached_input`、`token.reasoning_output`
- `memory.tool_peak_rss_bytes`（采样峰值）

保留计量范围及证据引用；无观测的字段为 `null`。缓存和推理 token 分别是输入和输出的子集。原始 `metrics.json` 保留工具生成的格式。共享成本使用同一份证据，避免重复归属。

工具可能先把 CompCert 产物写入自身输出目录；align 必须保留原始导出/审计证据，再将经核对的预处理输入、原始 AST、执行包装和目标安装到上述案例路径，记录源路径及 hash。不能假定原工具默认输出路径已经符合共享接口。

## Problem and attempt contract

Each named problem has one canonical question in `problem/Spec.v`, `problem/report.md`, and `problem/status.json`. The report states the exact proposition, quantifiers, entry, preconditions, observation semantics, requested goals and pending goals. `status.json` uses `schema: "five-proof-problem/1"`, `status`, `active_attempt` (relative to `problem/`), `specification: "Spec.v"`, and `requested_goals`; it points explicitly to the current attempt. Additional helper modules may be imported by this canonical question; they do not replace it. Each attempt binds its actual checked specification snapshot and hash, so later canonical-question extension cannot retroactively change a historical claim. Cross-model problems use the same contract under `relations/<name>/` and bind every participating model.

Each real attempt uses a fresh numbered `attempts/<number>/` containing `Proof.v`, `check.py`, `report.md`, `costs.json`, and the referenced evidence. Its readable report records:

- exact target, conditions and specification version; what was proved/refuted and what remains pending;
- model identity, source/model/specification hashes, actual imports, entry/ABI/endianness/float and byte-observation semantics, external bindings, tool versions and inherited assumptions;
- actual LLM model, requested and observed reasoning effort, with runtime receipt (unknown observations remain `null`);
- commands and successful independent kernel-check receipts for claimed theorems, dependency/statement snapshots, assumptions output and reproducible checker;
- measured time, tokens and tool memory, measurement boundaries, raw receipts and shared-cost references.

All new reference proof workers use actual `gpt-6.1-sol` with `medium` reasoning effort, evidenced by runtime metadata; do not relabel a differently configured historical run. Keep historical actual attempts, including failures, immutable and visible. A new active attempt does not erase their cost or evidence; a failed superseded attempt does not make a now-proved current goal pending. Add clarification outside the historical attempt when necessary.

`costs.json` uses `five-stage-costs/1` and the `time`, `token`, `memory` groups above. Start a real CLI `--session` skill-session boundary before substantive work, finish that run on every outcome, and retain audit evidence. Count shared event IDs once. Per-attempt unobserved allocation is `null` plus a link to the shared record, never an invented split. Preserve raw telemetry; normalize measured figures in the report with scope, not by rewriting raw statuses.

Safety quantifies all reachable original Csem states; termination covers all possible successors (for example `Acc`), never merely bounded execution or an existing return path. Byte observations must state representation/endian, `Mem.loadbytes`/`memval` interpretation, output/write-prefix and frame scope; unknown bytes stay unknown. Generated models, compiled declarations and matching function names are not proofs. See [proof evidence](proof-evidence.md) for actual CBMC coverage and independent receipt requirements.

Run `python3 scripts/check-example-artifacts.py` for reference metadata validation; `--compile` additionally reruns only active proof checkers. This complements semantic review and kernel checking; metadata validation cannot prove proposition adequacy.
