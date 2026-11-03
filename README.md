# FIVE 形式化产物

当前职责：`five-cbmc` 产出 C 属性检查及反例；`five-align` 生成 CompCert 模型、待证目标并映射规约；`five-rocq` 填写前条件、规约并完成实际证明（包括语义对应和 CBMC 属性重验）；`five-verify` 调度、验收证据并汇总。生成阶段完成与定理已证明分别记录。最终执行对应/CBMC 重验门禁使用 `scripts/compcert-verify.py gate`，不作为 align 的生成阶段完成条件。

每个实际阶段独立记录 token、墙钟、工具 CPU、工具进程 RSS，结束时自动写入 `cost_audit`；可用 `python3 scripts/audit-costs.py --run RUN_DIR` 独立核验。缺失或不一致返回非零、成本状态为 partial，不以 0/估计填补；端到端按事件 ID 去重，并保留采样内存的范围和限制。

执行语义固定为 CompCert 3.17 的 x86-64 / Linux / 小端目标，浮点使用 CompCert binary32 语义（含其 NaN 策略、最近偶数舍入）。这是对指定 CompCert C 语义的证明。

| 程序 | 执行模型 | 完整无错误证明 |
|---|---|---|
| identity | 原始 Csyntax + Cexec | 原始 Csem 所有可达状态；符号执行证书 |
| addition | 共享 Csyntax + 官方 Cexec | 已证明，任意两个 binary32 输入与初始内存 |
| addition_store | 共享 Csyntax + 官方 Cexec | 待证明 |
| bubble_sort | 共享 Csyntax + 官方 Cexec | 待证明 |
| lowpass | 原始 Csyntax + Cexec | 已证明，含显式内存前条件 |
| pid | Csyntax + 官方 Cexec | 待证明 |
| attitude_trig | Csyntax + 官方 Cexec，自实现三角函数 | 待证明 |
| sum3 | 原始 Csyntax + Cexec | 已证明，三个 binary32 参数，无数值域限制 |

## 标准结构

```text
cases/<程序>/
  source/          原始 C、必需头文件和许可证
  model/           自动导出的 Csyntax 与 CompCert 执行入口
  proof/           无错误证明及必要 support；辅助引理不代表完整安全证明
  report/
    report.md      证明范围、前条件和状态
    costs.json     成本记录索引
shared/            去重后的执行语义和证明依赖
reports/
  costs.json       历史真实 token / 时间 / 内存记录的唯一归档
  validation.json  本次重新编译、独立内核检查及源码哈希
  source-validation.json  C 重新导出 AST 的一致性检查
  cleanup.json     清理范围与删除字节数
scripts/           当前通用后端、成本采集和重新构建工具
.agents/skills/    当前工作流
.tools/            工具链
```

错误指非正常返回且没有语义后继的状态。NaN、无穷大和浮点溢出本身不等于该错误。执行模型不通过前条件缩小输入域；证明的调用约定、内存前条件写在对应定理中。

低通与 identity 的 proof/support 中保留了证明需要的功能见证；这些不是 C 的替代执行语义。addition、addition_store、bubble_sort 的共享编译单元和执行引擎仅存一份，个例 model 选择对应函数。所有执行器均为已安装的官方 Csem/Cexec。共享 Library 仅适配普通 memcpy 到官方块复制；旧回调仅作为行为保持证明的参考。

在 WSL 项目根目录重新检查：

```sh
source scripts/env.sh
python3 scripts/check-models.py
```

编译与内核检查只在临时目录中生成对象，结束后自动删除。`reports/costs.json` 保存已有实际记录；空值和不完整测量仍明确保留。阶段和包装调用可能共享 token 事件，不能直接相加。共享阶段成本不任意摊分给单个程序。

普通 memcpy 的原始 C/AST 未修改。适配器使用官方 Cexec.do_ef_memcpy，保留三个参数、目的指针返回、字节对齐和原非重叠约束。共享引擎、PID、三角模块的通用语义对应定理显式带 Library.environment 外部环境契约；加法完整安全定理不依赖该契约。详见 reports/official-compcert-migration.json。

每个新 CompCert 模型的导出都自动调用 [生成器](scripts/generate-obligations.md)，生成 `proof/Precondition.v`、`proof/Obligations.v`、`proof/Proofs.v`。默认前条件和证明待后续大模型填写；无错误与终止性命题以未确定的前条件为显式参数，不需要直接运行模型。重生成保留已填写的前条件和证明。通用性质定义在 `shared/verification/Obligations.v`；sum3 保留先前显式指定前条件的示例。终止性覆盖所有语义后继，没有展开界；生成/类型检查不等于程序已证明。已有无错误证明仍按上表记录。

AST 库接口审计见 reports/ast-library-audit.json。当前 8 个模型只有 addition_store 和 bubble_sort 使用普通外部 memcpy，没有直接系统调用或 malloc/free 调用；其他内建声明未使用。运行 `python3 scripts/ast_library_audit.py --output reports/ast-library-audit.json` 可复查。官方具体语义直接复用，普通库只补最小规格/适配且不验证库内部实现，直接系统接口没有官方具体支持时禁止占位实现。
