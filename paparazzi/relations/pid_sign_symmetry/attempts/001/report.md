# PID严格符号对称性：原始Csem实际反例

结论：原全称严格符号对称关系 refuted。请求的两项否定目标均 proved，无待完成请求目标。[Spec.v](../../problem/Spec.v)是权威命题；[Proof.v](Proof.v)中 proved_actual_counterexample 和 proved_strict_symmetry_refuted 分别证明真实执行反例与全称命题的否定。proved指这些反例/否定定理。

| 观察量 | 正向输入 A | 完整镜像输入 B |
| --- | ---: | ---: |
| x参考位置（1/256m） | 64 | -64 |
| P项，kp=1 | 1 | -1 |
| D/速度/加速度项 | 0 | 0 |
| 初始积分 | 0 | 0 |
| 更新后的存储积分 | 1 | -1 |
| 积分算术右移16位 | 0 | -1 |
| 实际返回x及存储cmd_earth.x（1/4096rad） | 1 | -2 |
| 严格对称要求的B输出 | — | -1 |

其他输入、模式、内存frame与单位详见[问题报告](../../problem/report.md)。Witness.v从已检查symbolic_witness_base取得真实全局初始化内存和新分配gh/ret，证明20个合法store存在；两份输入只有x参考位置不同。computed_original_result使用原有original_entry_normal_result，得到两次原始star Csem.step到Returnstate的存在性，再连接实际返回/全局load与精确机器运算。它不以返回存在为未证明前提。积分存储在此见证仍取反；输出非对称足以否定严格关系。

模型为paparazzi/models/guidance_pid_h_run_pos，原准备C SHA-256为8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04。原上游提交abfee3dd56eeab12c528635504a429db3daf409a，COMMANDS_NB=4、COMMAND_THRUST=3。CompCert 3.17、x86-64 Linux standard ABI、小端、binary32 nearest-ties-to-even、-fstruct-passing；本证明为原始Csem，不声称GCC二进制/硬件等价。新C准备/CBMC/align未运行，旧源码与旧证明没有修改。

本轮实际模型gpt-6.1-sol，用户指定与运行时观测推理努力均ultra，覆盖技能medium默认。[运行时配置](evidence/runtime-config.json)仅提取session身份与配置，不保存思维内容。开始数学分析前创建skill-session；初始技能和计量接口读取位于边界外，不倒算为已精确归属成本。

复现：在/home/yangfp/five加载scripts/env.sh后，执行python3 paparazzi/relations/pid_sign_symmetry/attempts/001/check.py --timeout 600。检查器核验原始handoff角色、路径与hash，固定外部语义依赖，计算58个实际导入模块闭包，复制不可变源码快照后逐一冷编译，再独立rocq check Proof与精确GoalBinding.v。绑定覆盖两个请求目标；编译、Print Assumptions、精确类型和输入/声明hash保存在provenance与goal-validation。非--publish复现不覆盖发布证据。

继承假设是现有CompCert/Flocq基线：ClassicalDedekindReals.sig_not_dec、sig_forall_dec、Classical_Prop.classic、dependent functional extensionality、proof irrelevance及Events.external_functions_sem/inline_assembly_sem参数。本轮无新Axiom、admit、Admitted。有效缓存与禁用force路径不调用这些未解析外部函数。

失败的首次依赖缺失、Witness自动化/名称冲突及整数表示证明修复均保留原始遥测命令和stderr，没有覆盖失败历史。成本见[costs.json](costs.json)：同一真实session涵盖问题构造、证明、失败、修复、最终冷编译与内核验收。CPU/RSS由GNU time与10ms进程树采样记录；共享页可能重复计数、短峰可能漏采，模型服务器/桌面内存不在可见范围。token来自实际Codex累计事件边界，缓存/推理token是输入/输出子集。总墙钟直接测量，不是命令耗时之和。旧依赖历史作者成本不重计，本次重编译计入本轮。

最终58个本地依赖模块从不可变快照冷编译成功，独立Proof内核命令132、精确GoalBinding编译133、独立GoalBinding内核134均exit=0。[当前来源绑定](provenance.json)、[精确目标验收](evidence/goal-validation.json)保存完整hash、编译快照和内核命令引用。

Spec.v SHA-256: a5f8eaa39cde0988ff3b94ef85b96ddf751aa56edc81c86552ce7165f7c224ef
Proof.v SHA-256: bcef17209c5dd5db3260c1ec22d3f71c5232ac53c07653d596c61f048bbc0593
Witness.v SHA-256: a91dff51eebadfe2fb7aedb804b137e78c10ebb24f8d4c9d36743a89f9a8d534

实际成本边界已关闭：墙钟 15154.223s；工具CPU 309.280s；input 4438377、output 23386、total 4461763 tokens（cached input 4332672、reasoning output 4187，二者为子集）；工具进程树采样峰值 1182162944 bytes，单进程最大RSS 1179963392 bytes。48条实际token事件，136条计量命令，8条失败命令均保留。测量状态 complete。最终源文件缓存清理仅限本次relation，共移除187个编译缓存；未移除源快照或原始成功/失败回执。结束后成本账本归一化、独立成本审核与最终metadata包装开销在边界外，不估算为0。

最终[本relation产物验收](evidence/artifact-validation.json)、[标准examples验收](evidence/canonical-example-validation.json)均passed；[独立成本审核](evidence/cost-audit.json)complete、exit=0。先前open-run元数据检查因内核门禁要求所属run先关闭而失败，该历史日志保留；关闭后当前精确目标验收成功。
