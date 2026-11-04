# FIVE 共享案例目录与阶段交接契约

本文件规定案例**内部**接口；案例外层路径由项目选择。五个 skill 共同维护同一个案例目录，增量写入自己负责的区域，不覆盖其他阶段的结果。纯 Rocq 案例仍受本契约约束，但 C/CBMC/CompCert 不适用时登记 `not_applicable`，不编造源码或模型。

```text
<case>/
  source/Program.c             # prepare 后的 C 入口；纯 Rocq 时不适用
  source/preprocessed.i        # align 实际消费的预处理快照，产生后固定
  source/bindings.json         # 原始源码、依赖、目标及实际调用绑定
  source/                      # 实际使用的头文件、依赖和适用许可证
  cbmc/                        # harness、属性、日志和真实反例（如适用）
  model/Source.v               # CompCert 自动生成的 Csyntax；不得手改
  model/Execution.v            # Cexec 执行入口及其依赖
  model/spec-map.json          # 有 CBMC 属性时逐项映射；否则记录不适用
  proof/Precondition.v         # 独立前条件；未填写保持参数化
  proof/Obligations.v          # 自动生成的无错误、终止性等待证目标
  proof/Proofs.v               # 实际证明或未完成状态，不编造证明
  proof/spec-recheck.json      # 仅在 Rocq 重验 CBMC 属性时生成
  report/report.md             # 各阶段状态、结论、范围和缺口
  report/manifest.json         # 输入/输出、hash、阶段状态及交接清单
  report/costs.json            # 每个阶段的成本、状态及原始证据引用
```

必须创建这些目录和 `report/report.md`、`report/manifest.json`、`report/costs.json`；仅当对应阶段已实际生成且适用时才要求其具体文件。没有执行的阶段在 manifest 和报告中记 `not_run`；不适用记 `not_applicable`；缺少输入或工具记 `blocked`，已生成但未证记 `pending`，失败记 `failed`；不得用空文件冒充产物。共享翻译单元的依赖、批次证据可在目录外集中保存，但须可解析地引用并固定 hash。已有证明和状态不因添加阶段而被覆盖。

## 固定交接接口

每个阶段都读当前 case 下 `report/manifest.json`、`report/costs.json`，在启动前核对直接输入的路径、hash、目标配置和前一阶段状态；有缺失、内容变化或依赖不可用时停止依赖该输入的步骤，登记原因，不静默替代。执行完成后仅增量更新自己的阶段状态、输入/输出路径与 SHA-256、工具版本/选项和成本引用。路径均以 case 目录为基准，允许指向存在的共享文件。状态只能表示实际证据支持的程度。报告生成/类型检查、证明、成本审核分别记状态。

| skill | 必需输入 | 写入与交给下游 |
|---|---|---|
| five-prepare | 原 C、入口、目标语义、依赖及用户要求；输入可来自案例外 | `source/Program.c`、实际依赖和 `source/bindings.json`；在报告/manifest 固定准备结果和限制，供 CBMC 与 align 消费 |
| five-cbmc | 已准备的 `source/`、bindings、入口和用户指定检查性质/界限 | `cbmc/` 的 harness、命令、属性、假设、范围、结果及实际反例，manifest 索引并标明状态；交给 align |
| five-align | 已准备的 `source/` 和 bindings；若映射 CBMC 规约，还需实际 `cbmc/` 属性与范围 | `source/preprocessed.i`、`model/Source.v`、`model/Execution.v`、生成的三个 `proof/*.v`、来源审计及适用时 `model/spec-map.json`，供 rocq 使用；未运行 CBMC 不阻塞模型生成 |
| five-rocq | 一个或多个已有 Rocq 模型及用户目标；CompCert 任务还读 align 的模型、义务和映射 | 前条件、规约、证明和假设、内核证据及适用时 `proof/spec-recheck.json`，交给 verify；纯 Rocq 无需 C 或 CBMC |
| five-verify | 用户目标和案例清单；分别读取所请求阶段的实际交付 | 调度与接口检查，更新各案例 `report/` 汇总、未完成项及去重后的成本；不将生成当证明 |

`source/bindings.json` 至少登记：原始源文件与准备后的源文件路径及 SHA-256、实际依赖与版本或 hash、入口、C 方言和目标 ABI/端序/浮点与舍入、预处理和编译选项、外部调用原绑定与实际绑定、重定向实现及其来源/哈希、尚需证明的对应关系。未知或不可恢复字段写 `null` 并说明原因；不得猜测未发生重定向。准备后的程序是两个分支的相同输入；改回原库绑定的性质迁移必须另有对应性证据。

`report/manifest.json` 至少有 case 标识、目标语义、`stages`（五个 skill 各自的状态、输入和输出路径/hash、日志及限制）。`report/costs.json` 至少有 `stages`（五个 skill 各自的状态、实际 input/output/total token、墙钟秒、工具 CPU 秒、工具进程 RSS 峰值字节、采集方法和可核对证据路径）。阶段未执行记 `not_run`，未知数值为 `null` 和原因，不能用 0 或估算。失败、重试及准备阶段均计入；案例独立边界需在开始前采集，批次共享消耗单列并引用，不能伪造单案例实测或重复相加。对于每个实际执行的阶段，通过 `scripts/audit-costs.py --run RUN_DIR` 检查成本；无法完整核验时标记 partial。

为避免每个阶段自定义不同字段，新案例的 `report/manifest.json` 使用 `schema: "five-case-manifest/1"`、`case_id`、`target` 和 `stages`。`stages` 的键固定为 `five-prepare`、`five-cbmc`、`five-align`、`five-rocq`、`five-verify`；每个值包含 `status`、`inputs`、`outputs`、`logs`、`limitations`。inputs/outputs 为数组，每项至少含 `path` 和小写 SHA-256 字符串 `sha256`；仅对真实存在的文件列 hash。`logs` 为路径数组，`limitations` 为字符串数组。尚未运行的阶段用空数组与 `not_run` 初始化，不能把文件缺失写成已交付。实际结果还应记录阶段特有的范围、命令及工具版本。

新案例 `report/costs.json` 使用 `schema: "five-case-costs/1"` 和同名五个 `stages` 键；每项固定字段 `status`、`input_tokens`、`output_tokens`、`total_tokens`、`wall_seconds`、`tool_cpu_seconds`、`tool_peak_rss_bytes`、`measurement_method`、`evidence`、`missing_reason`。数值字段必须是实测数或 null；`evidence` 为路径数组；token total 仅为 input + output，缓存和 reasoning 如记录则作为子集另列。共享批次的实际开销通过 `shared_batches` 引用，不填入无法确定的单案例数值。历史案例保留现有数据并增量迁移，未能追溯的字段保持 null，不能重写历史。

工具可能先把 CompCert 产物写入自身输出目录；align 必须保留原始导出/审计证据，再将经核对的预处理输入、原始 AST、执行包装和目标安装到上述案例路径，记录源路径及 hash。不能假定原工具默认输出路径已经符合共享接口。
