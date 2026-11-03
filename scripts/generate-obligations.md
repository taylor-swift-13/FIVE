# 生成待证目标

`compcert-align.py export` 在每次生成 CompCert 模型时自动调用 `generate-obligations.py`，为所选函数生成无错误与终止性命题。无需运行 Cexec，也不展开路径。默认只生成并检查命题的类型，前条件和证明留给后续大模型填写。

默认产物放在导出目录的 `proof/` 中：

- `Precondition.v`：声明 `precondition_type := list val -> mem -> Prop`；具体 `precondition` 待填写。不会以 `True`、`False`、公理或 `Admitted` 冒充已确定的前条件。
- `Obligations.v`：生成以 `pre` 为显式参数的 `no_error_goal pre` 和 `termination_goal pre`，直接引用原始 `Csem.step`。
- `Proofs.v`：预留定理陈述和证明位置（注释中的模板），不导出已证明定理。后续大模型定义 `Precondition.precondition` 并证明这两个实例化目标。

重复生成保留已有 `Precondition.v` 和 `Proofs.v`。如果自动目标文件不同，生成器报错，不能覆盖人工工作。修改前条件或证明后，应重新编译、审计、记录实际状态，不能沿用旧 manifest/hash。

已存在的模型可以独立调用生成器，不填写 `--precondition` 就使用上述默认模式：

```sh
python3 scripts/generate-obligations.py \
  --source-module CaseName.Source \
  --function f_function_name \
  --precondition-module CaseName.proof.Precondition \
  --output model/proof/Obligations.v
```

如果前条件已经明确提供，可以用 `--precondition` 选择现有定义。以下为之前 sum3 示例的复现方式，不是新模型的默认前条件：

```sh
python3 scripts/generate-obligations.py \
  --source-module FiveCases.sum3.model.Source \
  --function f_sum3 \
  --precondition-module FiveCases.sum3.proof.Precondition \
  --precondition typed_inputs \
  --output cases/sum3/proof/Obligations.v
```

输入需要指定原始 Csyntax 程序模块、函数定义和前条件模块位置。程序定义名称默认 `prog`，可用 `--program` 修改。生成器不会推断或增强前条件。函数、程序和前条件接口的名称及类型由后续 Rocq 编译检查。不要将 Clight 函数传入这个 Csyntax 接口。

生成的目标只是命题定义：默认模式的类型是 `precondition_type -> Prop`；指定现有前条件的模式是 `Prop`。后一模式中的 `Goal ... Abort.` 只检查目标类型，没有导出已证明定理，也没有添加公理。命题类型检查、独立内核检查、模型执行和目标证明分别报告。

- 无错误：从入口经任意有限次原始 `Csem.step` 到达的状态，都不是“非正常返回且没有后继”的状态。浮点 NaN、无穷大本身不是这种错误。
- 终止性：对原始 `Csem.step` 的所有后继建立 `Acc`，即强归一化；涵盖全部求值分支和事件轨迹，没有固定展开界。这比只存在一条返回路径更强。
- 两者分开证明。有限步后卡住的执行满足终止性但不满足无错误；无限安全循环可满足无错误但不满足终止性。两者合起来要求每条最大执行有限且以函数正常返回结束。

sum3 的示例前条件只要求三个 binary32 参数，允许全部位模式和任意初始 CompCert 内存。它不要求有限数，也不排除 NaN、无穷大或非规格化数。执行入口本身没有前条件限制。

其他函数的指针有效性、全局内存初始化和外部环境约束需要在规约中明确给出；只生成目标并不能保证目标为真。这里使用 CompCert 的 C 语义及其外部调用关系，不声称覆盖任意现实外部库。面向长期运行的控制主循环，通常证明无错误与单周期终止，而不要求主循环整体终止。
