# 原 Csem 全后继终止

已证明：PidPositionRunPosTerminationAttempt002.Proof.termination，精确当前问题见 problem/Spec.v。当前 RequestedGoal 已由原入口的全部后继 Acc 证明闭合。底层 target-aware rank 对任意原始参数与内存成立，无需数值前条件或执行 fuel；它不是单条正常返回路径。外部调用按原 CompCert 原子 external-call 语义解释。

本次实际数学作者为 gpt-6.1-sol / ultra，用户配置覆盖 skill 默认 medium。三位实际作者的 runtime/session 元数据与去重事件在共享成本记录和总报告中；common runtime receipt 为 paparazzi/relations/pid_position_translation/attempts/002/evidence/runtime-config.json，model config 为 paparazzi/relations/pid_position_translation/attempts/002/evidence/model-config.json。当前问题 SHA-256：6bc1324b2780b07cf805fe8c07fb72977494f8f48fd2ce1ab96a2a7202fd3d63；传递 canonical InputGood/关系 Spec：e0e217b4d9147f43fa76cb35debb04499297f2823a0fb7e3416236ed8a29257e。

原 C SHA-256 8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04；Source.v f33d6cd38506ff1e080cda6d2261f873a6f269ccb8be1b924ca56c2fa8c4e26f；Execution.v 92b467146447e6b549f6224440049979e58911b55b9418defd3b28c10cf8fea1。目标为 CompCert3.17 / Rocq9.2 / OCaml4.14.2，x86-64 Linux standard，小端，binary32 RNE。实际入口参数含隐藏返回缓冲区，返回 void/Vundef；观察原 active LTP 字段、Mem.loadbytes/memval 与声明范围内的权限/字节。

原 Source/Execution 及全部分支保持不变。有效 NED_i cache 与 approx=false 排除 stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f；绑定仍 OPEN，域外完整环境对应没有被声称。Print Assumptions 保留实际继承的 CompCert 外部语义接口、标准库 classical、proof-irrelevance 和 extensionality；没有新增目标公理或 Admitted。

当前完整 cold compile、精确 CurrentGoalBinding、Print Assumptions 与独立内核回执见 evidence/goal-validation.json 和 provenance.json。check.py 委托共同冷构建，可复跑当前完整目标；历史001不会执行或重编。001报告/成本/原问题快照保持不变，前条件更正理由在关系002/evidence/precondition-change.json。

费用见本目录 costs.json 与共享 relation002/costs.json。没有逐目标时间/token的独立边界，因此本目标分摊为 null，并引用真实共享记录；所有失败/超时保留。完整 CPU 与并发联合 RSS 的未知项不会由已观测小计估算；模型服务器内存不可观测。
