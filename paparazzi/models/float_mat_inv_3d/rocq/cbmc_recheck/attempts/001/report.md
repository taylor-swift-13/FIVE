# 历史尝试 001：已被 003 取代

旧 Proof.v 编译通过；全量 GoalBinding 因 String scope 未导出而失败，没有该题成功的独立完整接受回执；同时原 observer 组合义务尚缺。 这是历史实际检查结果，不是全部原始 CBMC 目标已经完成。当前完整问题和证明见 [尝试 003](../003/report.md)。旧 Proof.v、编译时 Spec 快照与原 run/log/输入保持；后续规范扩展不回填历史结论。

旧检查器在当前规范扩展后拒绝原 immutable input 是预期行为，应重跑当前尝试。实际旧问题/证明快照绑定见 [historical-input-binding.json](evidence/historical-input-binding.json)；原始失败与成本保留。
