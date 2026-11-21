# 当前尝试：proved

本次待证目标已由完整冷编译、精确类型绑定和独立内核检查验收。问题在 `problem/Spec.v`，证明在本目录 `Proof.v`；辅助模块不替代问题。

- [当前目标及源码绑定](evidence/goal-validation.json)
- [独立证明内核记录](../../evidence/cold-checks/20261119T211947849575/source-bound-kernel-evidence.json)
- [时间、token、内存记录](costs.json)

所有数学证明作者的实际运行配置为 GPT-6.1 Sol Ultra。源码、执行模型和规约版本绑定见当前验收文件及 provenance.json；最终冷构建中的 GoalBinding.v 使用原声明的精确类型，并打印实际继承假设。历史失败、超时、内存上限和观察器补强均保留在共享原始记录；缺失资源指标为 null。

构造阶段记录（以下提到的待验收状态已由上述当前收据取代）：

Actual GPT-6.1 Sol Ultra authored proof. Development meter runs/20261119T194851-2aaea433bd/five-rocq; layout and named-call/termination helpers have separately recorded sessions. Final cold statement bindings and independent kernels pending. No source/AST changes.
