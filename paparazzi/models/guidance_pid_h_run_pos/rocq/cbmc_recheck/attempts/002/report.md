# 全部124个原CBMC性质的Rocq重验

已证明：PidPositionRunPosCBMCAttempt002.Proof.checked_properties，精确当前问题见 problem/Spec.v。全部124个实际CBMC ID各有精确 Goal/定理别名及独立 kernel：51溢出、7移位、60指针、6断言。控制器与入口的算术/指针性质覆盖原入口实际可达 ready 操作及所有求值顺序；当前 readable_span 从语义安全性推出，不以成功访问为前提。harness 的六个加法按原逻辑 InputPair 域证明可表示性，六断言另有真实分配、cast、store/load 快照与原 alpha-renamed &&/== 表达式的 Csem.star 到真。Source没有 nondet/assume harness main，未声称该 main 的完整执行。

本次实际数学作者为 gpt-6.1-sol / ultra，用户配置覆盖 skill 默认 medium。三位实际作者的 runtime/session 元数据与去重事件在共享成本记录和总报告中；common runtime receipt 为 paparazzi/relations/pid_position_translation/attempts/002/evidence/runtime-config.json，model config 为 paparazzi/relations/pid_position_translation/attempts/002/evidence/model-config.json。当前问题 SHA-256：9594ed02379ec393b9094d24140762217cc95372955f4e2efd0e0590253ee6c3；传递 canonical InputGood/关系 Spec：e0e217b4d9147f43fa76cb35debb04499297f2823a0fb7e3416236ed8a29257e。

原 C SHA-256 8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04；Source.v f33d6cd38506ff1e080cda6d2261f873a6f269ccb8be1b924ca56c2fa8c4e26f；Execution.v 92b467146447e6b549f6224440049979e58911b55b9418defd3b28c10cf8fea1。目标为 CompCert3.17 / Rocq9.2 / OCaml4.14.2，x86-64 Linux standard，小端，binary32 RNE。实际入口参数含隐藏返回缓冲区，返回 void/Vundef；观察原 active LTP 字段、Mem.loadbytes/memval 与声明范围内的权限/字节。

原 Source/Execution 及全部分支保持不变。有效 NED_i cache 与 approx=false 排除 stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f；绑定仍 OPEN，域外完整环境对应没有被声称。Print Assumptions 保留实际继承的 CompCert 外部语义接口、标准库 classical、proof-irrelevance 和 extensionality；没有新增目标公理或 Admitted。

全部124个当前证明及传递依赖已编译并通过独立内核检查，逐ID门禁已通过；回执见 evidence/kernel-124-original-model.json、evidence/recheck-ledger.json 和 spec-recheck.json。额外整组 CurrentGoalBinding/Print Assumptions 重放在480秒超时，当前不提供通过的 goal-validation.json/provenance.json，详见 evidence/validation-status.json。check.py 委托共同冷构建，可复跑当前完整目标；历史001不会执行或重编。001报告/成本/原问题快照保持不变，前条件更正理由在关系002/evidence/precondition-change.json。

费用见本目录 costs.json 与共享 relation002/costs.json。没有逐目标时间/token的独立边界，因此本目标分摊为 null，并引用真实共享记录；所有失败/超时保留。完整 CPU 与并发联合 RSS 的未知项不会由已观测小计估算；模型服务器内存不可观测。
