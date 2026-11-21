# update_pid_df：Rocq 阶段验收

五个单模型问题全部完成。原始 Csem 所有可达状态的无错误、所有后继终止、全执行对应、正常返回与字节观察，以及全部 81 个实际 CBMC 属性均已独立证明并通过内核检查。

| 问题 | 状态 | 实际尝试 | 目标数 |
|---|---|---|---:|
| no_error | proved | [001](../no_error/attempts/001/report.md) | 1 |
| termination | proved | [001](../termination/attempts/001/report.md) | 1 |
| functional | proved | [001](../functional/attempts/001/report.md) | 3 |
| execution_correspondence | proved | [001](../execution_correspondence/attempts/001/report.md) | 8 |
| cbmc_recheck | proved | [001](../cbmc_recheck/attempts/001/report.md) | 81 |

入口 update_pid_df，32 字节 PID_df 对象。单调用安全与功能证明的数值域保留所有 binary32 位模式，包括 NaN 和无穷；前条件要求合法、对齐、地址不回绕、已初始化且可写的对象及正确调用类型。函数精确写入 u[0..1]、e[0..2]，保持 g[0..2] 的 12 字节和原始写区外 frame。

执行模型为原始自动生成 Csyntax/Csem/Cexec。目标 CompCert 3.17，x86-64 Linux standard ABI，小端、binary32、最近偶数舍入，NaN 策略由原 manifest 固定。源代码固定在 abfee3dd56eeab12c528635504a429db3daf409a；源、模型、规范及实际编译快照的哈希由各尝试 provenance.json 与 goal-validation.json 绑定。模型完整性与数值定理的有限有界前条件分开。

CBMC 使用传统符号执行/有界模型检查；81 项为 8 个实际位观察断言及其余 73 项实际守卫。重验逐项连接原始语句访问位置、参数绑定和调用后的字节观察，详见 cbmc_recheck 的映射及报告。来源审计、全执行对应及独立重验的组合门禁为 accepted，原始结果在 [gate.stdout.log](evidence/gate.stdout.log)。

prepare/verification-request.json 保留初始高层验证要求；align/request.json 是由准备结果生成并由 CompCert manifest 哈希绑定的完整执行翻译请求。门禁和重验绑定后者，同时保留前者的来源链；最终全 n 定理强于初始有限时域目标，原冻结请求未被事后改写。

新增数学证明作者的实际模型为 gpt-6.1-sol、Ultra；配置回执、Print Assumptions、独立内核命令和传递依赖见每个实际尝试。没有新增未证明公理或 admitted 目标。原 CompCert/Flocq/标准库继承假设按实际内核输出保留。

本阶段的 [成本记录](costs.json) 包含实际失败构造和成功检查，统一使用时间、token、内存三元组。共享作者及检查区间须按事件 ID 去重；不虚构逐定理分摊。端到端汇总另计调度、来源准备、CBMC、CompCert 导出与关系证明。未观察到的完整资源消耗为 null；各记录的数值只覆盖其原始计量范围。
