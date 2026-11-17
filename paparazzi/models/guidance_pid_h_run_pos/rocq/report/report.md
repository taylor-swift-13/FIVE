# 原PID位置控制器：Rocq当前结果

当前 NoError、全后继终止和全部124个实际CBMC性质已证明并通过独立内核检查。NoError、终止性及关系六目标的精确目标绑定已通过；CBMC尝试003现已补齐全部124项精确目标绑定、逐项假设输出及独立内核检查。先前480秒超时作为历史失败保留并计费。关系 pid_position_translation 的六个主目标亦全部已证，包括两侧正常存在、任意正常结果关系、非空/非零域和精确字节/权限框架。

| 当前问题 | 活跃尝试 | 结果 |
|---|---|---|
| no_error | attempts/002 | 原 Csem 全部可达状态无 source_error |
| termination | attempts/002 | 所有后继 Acc，底层对任意raw args/mem成立 |
| cbmc_recheck | attempts/003 | 124/124原ID逐项证明，无refuted/pending |

数学作者实际 gpt-6.1-sol / ultra，runtime与model config在关系002/evidence，三位作者均由真实session元数据核对。Source/Execution仍是同一原程序、CompCert3.17 x86-64 Linux standard、小端、binary32 RNE，隐藏返回缓冲区 ABI。前条件明确修正位置初始化/安全减法，主 InputPair 域新旧等价。

旧001的 init_mem 求值方法在函数执行前遇到资源限制，不是程序反例；原已检 getter/算术辅助定理仍有效。历史001、旧总报告与成本不改签。此前阶段report/cost/handoff精确快照见 _build/pid-position-translation-ultra-publication/20261108T090706-be8dbb32f9/five-verify/inputs/previous-rocq-stage.json。

NoError不是signed-overflow检查的替代。124项包含51overflow、7shift、60pointer、6assertion；控制器/入口绑定真实可达redex，harness按逻辑InputPair与真实局部表达式观察限定，不声称未建模 nondet harness main。当前逐ID映射见 cbmc_recheck/attempts/002/evidence/property-map.json，原align生成gapmap保持历史生成状态。

stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f仍OPEN，在有效缓存/approx=false已证域内不调用。域外完整外部环境及GCC二进制/硬件等价没有自动获得。继承假设与完整来源/声明hash见各当前goal-validation/provenance。

当前124项复跑使用 cbmc_recheck/attempts/003/check.py，只构建197项必要依赖并保留标准124项精确类型证书。NoError、终止性及关系六目标仍使用既有002检查器。费用只按实际共享run/事件归一，不伪分摊：见 costs.json、关系002/costs.json和新总报告 paparazzi/report/pid_position_translation/ultra-retry/report.zh-CN.md。缺GNU回执的完整CPU、并发联合峰值及模型服务器内存保持null，并列已观测指标。

当前CBMC验收与成本：cbmc_recheck/attempts/003/{report.md,costs.json,evidence/goal-validation.json}。证明源与002逐字相同，原C/Source/Execution/Spec和界限未变；003实际作者 gpt-6.1-sol / ultra，运行 _build/pid-cbmc124-acceptance/20261109T052937-2f15306159/five-rocq。

003实际闭合计量：墙钟1430.430秒，工具CPU 871.70秒，模型tokens 5547057，工具树采样峰值1596407808 bytes；真实会话/资源审计complete。历史失败和旧共享费用保留，未重复相加。最终静态门禁由独立five-verify协调记录。

本次验收协调与最终门禁的实际成本单独记录在 costs.json 的 acceptance-coordination 记录；与证明阶段按事件ID去重的本次汇总见 current_request。两阶段墙钟重叠，不相加。历史失败与超时记录保留，原C、模型和全部001/002文件的3509项冻结hash核验通过。
