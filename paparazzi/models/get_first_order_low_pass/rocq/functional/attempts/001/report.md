getter 原始 Csyntax/Csem/Cexec，模型覆盖任意机器参数和内存；安全/正常功能条件为对齐不绕回指针与 last_out 可读且含 typed binary32，其余字段不要求初始化，数值域不限制。终止性目标为所有 args/m 的 Acc，包含无后继非法状态的有限停止；在安全条件下另证正常返回存在。功能 frame 涵盖调用前有效块的每个 Mem.loadbytes 观察。CBMC19项各保留实际原ID/条件/表达式观察并独立证明。

实际模型 gpt-6.1-sol；请求/观测推理强度 medium。目标：NormalCompletion, AllReturns. 全部请求目标已证明；无 pending。

问题：[Spec.v](../../problem/Spec.v)；证明：[Proof.v](Proof.v)；复现：[check.py](check.py)。目标类型、来源/物理输入 SHA、实际依赖和独立内核 receipt 由 evidence/goal-validation.json 绑定；Print Assumptions 保存在真实编译stdout中。

共享 authoring 与所有失败/重试成本见 [costs.json](costs.json)，不伪造每目标模型token分摊。目标 CompCert3.17 x86-64 Linux standard little-endian binary32 nearest-even；NaN策略由 manifest/Archi/Flocq 绑定，语义信任边界与既有模型一致。

正式验收：2 个精确目标均由 [typed GoalBinding](evidence/goal-validation.json) 绑定，并在 CLOSED passed run032054 的实际完整编译、Print Assumptions 和独立 kernel 中通过。共享依赖只复用同一新运行内、相同 argv/物理源码的成功完整编译；默认 check.py 仍全闭包冷构建。

[实际 GoalBinding 假设输出](../../../../../../../_build/lowpass-readback/20261107T032054-5f16295536/five-rocq/logs/030-get_first_order_low_pass-goal-certificate.stdout.log)；[独立内核记录](evidence/kernel-evidence.json)。实际继承项包含 ClassicalDedekindReals.sig_not_dec / sig_forall_dec、FunctionalExtensionality.functional_extensionality_dep、Classical_Prop.classic；部分 generic Csem 依赖还打印 Events.external_functions_sem 和 inline_assembly_sem 语义参数，原选定函数可达调用闭包为空。每个目标的精确子集以 stdout 为准；无新问题公理或 admitted 证明。

真实失败和修复保存在共享 authoring run030051 与 [历史说明](../../../../../../report/lowpass_readback/evidence/history.json)。这些费用保留；未从 finalrun 或阶段记录中删除。每问题独占 token/时间/RSS 分配未知为 null，仅引用共享实际记录一次。
