原始 getter 的缓存命中路径四项目标已证明：所有可达原始 Csem 状态无错误、所有可能后继终止（Acc）、精确返回指针且整个输出内存等于输入内存、所有字节/frame 及缓存标志保持。任何正常返回也必须满足该精确结果，不只是一条返回路径。

全部本问题的具名目标已闭合。规范与证明分离；当前原始源码、原始模型、规约及实际编译快照由 [provenance.json](provenance.json) 和 [goal-validation](evidence/goal-validation.json) 精确绑定。每个目标均有实际类型实例化 GoalBinding.v、Print Assumptions、完整源码编译和独立 rocq check；内核运行已以 passed 关闭后，再执行当前来源校验。

实际模型为 GPT-6.1 Sol，推理强度 Ultra；用户要求的 Ultra 覆盖示例默认值。见 [runtime.json](runtime.json)。工具实际版本为 Rocq9.2/OCaml4.14.2。目标为 CompCert3.17、x86-64/Linux、小端、binary32、最近偶数舍入；源码固定到 upstream abfee3dd56eeab12c528635504a429db3daf409a。模型及其机器输入域未裁剪；具体前条件独立写在 Spec.v。没有新增 Axiom、Admitted、CBMC 公理或替换执行语义。Print Assumptions 的实际继承项包括 Classical_Prop.classic、FunctionalExtensionality.functional_extensionality_dep、ClassicalDedekindReals.sig_not_dec、ClassicalDedekindReals.sig_forall_dec，以及 CompCert Events.external_functions_sem / Events.inline_assembly_sem 的原语义参数；原始输出的逐项位置见 [configuration.json](configuration.json)，不能将其称为无假设证明。

成本按两项新问题的共同实际 session 及独立冷检查运行记录，所有失败编译和修复均保留；[costs.json](costs.json) 不虚构逐问题分摊。开发时一次并行记录冲突丢失一行进程树采样，已保留分立原始日志及独立审计；完整 CPU/RSS 仍无法观测的字段为 null。数学闭合、来源/内核验收与资源观测完整性分别陈述。没有待证的本问题目标。
