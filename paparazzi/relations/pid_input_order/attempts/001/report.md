# PID 输入顺序反例：attempt 001

已反驳 OrderInvarianceGoal。ActualOrderCounterexampleGoal 与 OrderInvarianceRefutedGoal 均已完成，当前请求目标没有待证项。

实际初始内存由原 Genv 初始化和明确可写对象/字段存储构造，随后两条序列从同一内存 m 分支；每拍只有参考 x 的真实 Mem.store，积分从前一拍原始 Csem 调用保留。[64;-64;0] 的积分路径是 L→L→L−1→L−1，[-64;64;0] 是 L→L−1→L→L。共同最后零输入的返回 type=2、format=0、x 及全局 cmd_earth.x / 积分 x 的五个 Mint32 load 分别观察到 (1428,L−1) 与 (1429,L)，其中 L=93650944。

这是积分状态自身的 sat_L 限幅丢弃先到正增量：kp=ki=1、参考码±64使P增量恰为±1，没有P除法余数。无积分限幅的理想参照下，两序列均回到L。实际积分码只差1（2^-28 rad），但正数终态处在右移16位的阈值两侧，使命令码差1（2^-12 rad）。这不混同于仅执行器饱和而积分继续增长的经典windup，也不同于此前两个舍入反例。

范围固定为原 guidance_pid_h_run_pos，暖有效NED位置/速度缓存、approx_force_by_thrust=false、in_flight=true；其余测量/速度/加速度/y/heading均零，kd=kv=ka=0。初始L由原InputGood允许且实际内存存在，未证明从零积分初始化运行到达L。只反驳所述候选关系，不新增安全、全局终止或硬件等价结论。

目标为 CompCert 3.17 Csem/Cexec、x86-64 Linux standard ABI、小端、IEEE754 binary32 nearest ties to even（NaN策略由原manifest及语义hash固定）；实际工具为 Rocq 9.2 / OCaml 4.14.2。保持原准备源码、自动Source.v/Execution.v及绑定不变。本次prepare/CBMC/align未运行。观察是确切CompCert 32位标量load，不推断填充或未知字节。

实际证明模型为 gpt-6.1-sol，requested/observed effort均为ultra（用户覆盖参考默认medium）；[runtime-config.json](evidence/runtime-config.json) 只记录真实session观察。无Admitted、admit或新增未证明公理。实际继承假设由Proof与GoalBinding的Print Assumptions输出保留：Classical_Prop.classic、FunctionalExtensionality.functional_extensionality_dep、Axioms.proof_irr、ClassicalDedekindReals.sig_not_dec / sig_forall_dec、CompCert Events.external_functions_sem / inline_assembly_sem。

[provenance.json](provenance.json) 绑定原源码/模型、全部当前消费源码及外部语义hash；[goal-validation.json](evidence/goal-validation.json) 绑定136个当前源码快照和两条精确canonical类型。首次作者run的实际Proof/双kernel虽成功，但最终开发快照未加入其Run.inputs，首次metadata验收失败，原始记录与 [首次metadata失败](evidence/metadata-validation-first.json) 均保留。为补齐此缺项，另建真实--session区间，从空目录完整冷编译全部136源；每源在编译前实际Run.capture，精确GoalBinding亦先capture后编译；所有当前编译快照、成功完整compile回执和两次独立kernel均属于同一新的验收run。没有修改旧closed run或缩减kernel依赖。

当前独立 [Proof kernel receipt](evidence/cold-checks/20261118T173134409728/proof-kernel-evidence.json)、精确 [GoalBinding source](evidence/cold-checks/20261118T173134409728/checked/paparazzi/relations/pid_input_order/attempts/001/GoalBinding.v) 及其 [kernel receipt](evidence/cold-checks/20261118T173134409728/checked/paparazzi/relations/pid_input_order/attempts/001/certificate-kernel-evidence.json) 均通过。实际Print Assumptions在这些归档命令stdout中；当前验收元数据由 [metadata-validation.json](evidence/metadata-validation.json) 留存。

默认从仓库根重放：source scripts/env.sh && python3 paparazzi/relations/pid_input_order/attempts/001/check.py。重放从零编译完整实际依赖闭包，再检查Proof及精确GoalBinding；普通重放不覆盖已发表回执。失败的BOUND策略、透明展开/通用搜索超时和缺导入修复均保留在本次成本与原始日志中。

成本与验收信息见 [costs.json](costs.json) 和一次归档的 [telemetry](evidence/telemetry/run.json)。工具RSS不包括模型服务器或桌面agent内存；后者不可观测，保持未知。

实际会话墙钟 1740.270151 s；工具CPU总量未知（超时进程未留下完整GNU time记录），已记录部分为 490.07 s。模型token：input 11742305、output 42049、total 11784354；cached-input 11647104、reasoning-output 20180 均为子集，不重复相加。工具进程树采样峰值 1422036992 bytes；单进程最大RSS 1419730944 bytes。原始telemetry的measurement_status保留为partial；CPU缺项如实未知，不影响已核验的数学反例。

最终完整冷验收成本：墙钟 581.509891 s，工具CPU 464.78 s，工具树采样峰值 1421123584 bytes；该run独立成本审计通过。作者run的超时缺失CPU/RSS回执仍如实保留，未修饰为完整。
两次真实usage边界之间的metadata过渡token以实际event_id机械回收，工具CPU/RSS未知并单列。三个区间token事件并集：input 18086740、output 57349、total 18144089；cached-input 17958912、reasoning-output 28708 为子集。端到端墙钟按首start/末finish直接计 2765.404831 s，未相加阶段wall；全流程CPU/RSS总量保留未知，已记录CPU小计 954.85 s、已观测工具树峰值 1422036992 bytes。详情 [costs.json](costs.json)。
