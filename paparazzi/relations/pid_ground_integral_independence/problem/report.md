# 地面状态对历史积分的独立性

规约：[Spec.v](Spec.v)。复用原始 `guidance_pid_h_run_pos` CompCert Csyntax/Csem 模型，调用参数是隐藏返回缓冲区、`in_flight=false`、`gh` 指针。未重生成 C、CBMC、模型或旧证明。

主命题对两份实际内存和四个旧积分 x/y 值分别全称量化。两份内存满足已有 `InputGood`，同一 `gh`/`ret`，权限和 nextblock 相同；除旧积分的两个 Mint32 字与返回缓冲区之外，所有一字节 `Mem.loadbytes` 观察一致。四个旧值无相等或零约束，仍保留原输入域的 ±100000000 界限；其它数值、缓存有效及近似推力分支关闭条件沿用旧规约。

请求目标：

- `GroundIndependenceGoal`：存在正常返回，且所有正常返回对的 cmd_earth.x/y、有效返回 type/format/LTP x/y/heading 位相同；两份新积分都恰为 `Vint Int.zero`。
- `GroundFrameGoal`：所有正常返回对在整个返回块外逐字节相同，包括已被覆盖的旧积分区域；权限和 nextblock 相同。
- `GroundNoErrorGoal`：原始 Csem 所有可达状态均无 source_error。
- `GroundTerminationGoal`：原始 Csem 全后继关系的 Acc 终止性。
- `GroundNonvacuityGoal`：存在旧积分 x 不同的合法输入对及满足完整关系的实际正常返回。

观察使用 CompCert memval/`Mem.loadbytes`，x86-64 Linux little-endian，IEEE754 binary32、RNE。返回 padding/非活动 union 字段不进入有效返回比较；返回块外 frame 不排除积分字。证明只声称冻结原始 CompCert Csem 语义，外部绑定保持原模型不变。当前尝试及机器状态见 [status.json](status.json)。

当前尝试001已完成全部五项目标，pending goals：无。独立双内核及精确类型绑定均通过，详见 [尝试报告](../attempts/001/report.md)。
