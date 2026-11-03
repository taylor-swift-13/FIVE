# CompCert 生成与规约映射契约

本契约用于 five-align 的生成/映射交付。实际证明归 five-rocq，最终验收归 five-verify；详见 [证明证据与验收](../../five-verify/references/proof-evidence.md)。

## 导出与来源审计

```sh
source scripts/env.sh
python3 scripts/compcert-align.py export --source path/to/code.c \
  --function f_function_name --output _build/compcert/case \
  --namespace CaseName --request path/to/request.json --session SESSION_JSONL
python3 scripts/compcert-align.py audit \
  --manifest _build/compcert/case/compcert-manifest.json
```

`--include-dir`、`--define` 可重复。固定实际 CompCert 安装配置，当前是 x86-64 Linux 小端。request 的 purpose 为 execution-translation，execution_backend 为 compcert-csyntax-cexec，target 与 manifest 一致，domain 表示全部机器输入/状态。生成阶段不会把 request 改成有限输入表。

导出保留原 C、完整预处理、Source.v、原始 Cexec 的 Execution.v、Extraction.v，并自动生成 `proof/Precondition.v`、`proof/Obligations.v`、`proof/Proofs.v`。manifest 绑定文件、工具、CompCert 语义依赖及真实命令。generated/来源审计通过表示生成步骤完成，coverage 和程序性质仍可为 pending。

audit 从原 C/头文件重新导出，比较预处理、AST、包装和依赖。只忽略 `Info.source_file` 文件名元数据；不能规范化运算、类型或其他 AST 内容。源码、工具、头文件、模型、前条件或证明变化后重新绑定证据，不能只替换 hash 沿用旧证明结论。

## 前条件与待证目标

已有 Csyntax 模型可单独生成：

```sh
python3 scripts/generate-obligations.py \
  --source-module CaseName.Source --function f_function_name \
  --precondition-module CaseName.proof.Precondition \
  --output model/proof/Obligations.v
```

省略 `--precondition` 表示具体条件待填写；只给出 `list val -> mem -> Prop` 接口，两个目标以条件为显式参数。已由用户/上游明确提供谓词时可以用 `--precondition NAME` 引用，不能自行补全或加强。重生成保留已有前条件和证明，自动目标冲突时报错。Rocq 编译映射模型命名空间以及 `shared/` 到 `FiveShared`。

无错误是所有 Csem 可达状态均非“非正常返回且 nostep”；终止性为 Csem 全后继的 `Acc`。两者没有 fuel 限制，也不要求直接计算模型。manifest 的 `generated_obligations` 记录前条件待填写/复核、目标未证明及生成器/通用定义 hash。声明编译和 kernel check 不代表程序性质成立。

entry 和 transitions 仍覆盖原始机器参数/内存及全部后继。清点调用、外部环境、事件/世界和正常/错误/字节观察，将覆盖缺口转换为明确待证义务。closed_transitions 不能用于尚未建立相容性证明的外部或带事件环境。对应定理、适配器证明和函数性质由 five-rocq 完成。

## CBMC → Rocq 映射交接

有 CBMC 输入时交付 `spec-map.json`，schema 为 `five-cbmc-rocq-map/1`：

- `request_sha256`、`backend_manifest_sha256`：同一原始请求与模型。
- `verification_method`：`traditional-bounded-model-checking`。
- `cbmc_run`、`cbmc_command_id`、`cbmc_json`、`cbmc_input_sha256`：绑定真实 CBMC 命令、原始结果、C/harness，不自行生成新的属性 ID。
- `properties`：每个实际 property ID 一项；保留 `cbmc_status`、`scope`（原前条件、位置、内存、调用/展开范围、观察方式）、`rocq_goal`（模块符号和声明文件），以及输入/状态/观察对应关系。
- 每项 `mapping_status` 为 `mapped` 或 `mapping-gap`，`proof_status` 为 `pending`；缺口列 `gaps`。真实 FAILURE 附原始 trace 引用及已知位/字节信息，未知部分明确标注。不得以映射完成代表属性已证明。

无 CBMC 输入时 report 中记 not_applicable，不制造空重验结果。五类信息缺失（属性、输入、程序位置、范围、观察）时列 mapping-gap，不用同名断言代替映射。

five-rocq 消费映射并完成独立重验/反驳；结果使用 `spec-recheck.json`，与 pending 的 spec-map 分开。CBMC 结论不能成为 Rocq 公理。涉及抽象功能模型时，执行层与抽象之间的衔接本身也是 five-rocq 的证明目标。

## 生成阶段完成条件

生成文件与来源审计匹配、前条件接口和两个自动目标齐全、实际属性全部映射或明确列缺口、外部环境/覆盖义务有记录。本阶段真实实现问题须修复；待证明不等于生成失败。存在 mapping-gap 或覆盖缺口时不得声称对应部分完成。

这里不运行要求完整证明的交付门禁。`compcert-verify.py gate` 由 five-verify 在相应证明齐备后调用；旧 `compcert-align.py gate` 只是兼容入口，不是 align 的阶段验收条件。
