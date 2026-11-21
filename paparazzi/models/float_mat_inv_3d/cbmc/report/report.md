# CBMC 结果

传统 BMC 直接分析原入口函数体（已明确 fabs 内建绑定）。实际发出 208 条属性：206 SUCCESS、2 FAILURE。保留全部 ID、命令、原始 JSON 与两条真实完整 trace。失败属性 main.assertion.9 反驳正比例缩放状态不变；main.assertion.10 反驳成功即可保证小残差。固定有限对角输入的计算残差为 -1。其余内存和位模式断言通过。所有结果须由 Rocq 独立重验/回放。

源函数无循环/递归；harness 的 memcpy 展开界40并启用展开断言。任意 binary32 矩阵的检查仅采用合法、初始化、分离的类型数组，未限制模型机器输入。浮点 Inf/NaN 是数值结果，未被标记为 C 执行错误。

## Input snapshot replay

The historical CBMC run retained its original direct invocation and raw results, but its input snapshot index was empty. A fresh direct invocation captured the canonical source, original harness, bindings and request before execution. The exact original argv/cwd, every property object and all complete counterexample traces were reproduced identically. No source, original result, frozen handoff, mapping or formal model was changed. Current Rocq acceptance binds this fresh raw run and retains the original evidence. See [comparison](evidence/source-snapshot-replay.json) and [costs](costs.json).
