# 低通滤波接口关系：完整验证报告

已完成3个 CompCert 模型、16个正式证明问题和119个精确目标。当前77项 CBMC 检查及其 Rocq 独立重验全部通过。实际证明模型为 GPT-6.1 Sol，推理强度 medium，各次尝试保留配置、可读报告及成本。

## 已证明的关系

路线A：
```c
update_first_order_low_pass_tau(&f, tau, dt);
reset_first_order_low_pass(&f, value);
```
路线B：
```c
init_first_order_low_pass(&g, tau, dt, value);
```
两条路线都能正常结束，最终 `time_const`、`last_in`、`last_out` 共12字节逐位一致。系数保留源码计算次序：`div32(mul32(2.0f, tau), dt)`；另外两个字段均为 `value` 的原始位模式。对象外原有效内存区域的字节保持。`reset` 返回输入浮点值；两个 void 接口正常返回，不把不同类型的返回值互相比较。

规格允许两边旧值不同，甚至旧字段尚未初始化。安全证明的前条件是：参数具有相应机器类型；两个对象各自4字节对齐、连续12字节可写、指针偏移加12不超过2^64。浮点参数覆盖全部 binary32 位模式，包括NaN、无穷、带符号零和非规格化数。执行模型自身仍接受全部机器参数和 CompCert 内存，错误行为没有被这些证明前条件删掉。

## 证据与范围

|模型|CBMC及逐项重验|执行对应|功能目标|无错误|全后继终止|
|---|---:|---:|---:|---:|---:|
|init_first_order_low_pass|31|8|3|1|1|
|update_first_order_low_pass_tau|19|8|3|1|1|
|reset_first_order_low_pass|27|8|3|1|1|

跨模型关系另有正常完成、所有正常结果、非空性3个目标，总计119个。无错误覆盖所有可达 Csem 状态；终止性使用全后继关系的 Acc。关系直接调用三个实际执行模型。

目标标准为 CompCert3.17 Csem/Cexec、x86-64 Linux、小端、binary32、最近偶数舍入，NaN策略由具体语义库哈希固定。源码来自 Paparazzi 提交 `abfee3dd56eeab12c528635504a429db3daf409a` 的 `sw/airborne/filters/low_pass_filter.h`。提取只去掉独立入口的 static/inline 声明限定符；原结构体和函数体逐字保持。三份模型均已重新预处理、导出并通过来源审计。

当前CBMC使用传统有界模型检查、精确位向量后端，检查安全性、位复制和内存保持；源码没有循环或递归，使用 unwind1及展开断言。系数算术的CBMC历史尝试超时，保留为未解决记录；精确算术和完整12字节关系由Rocq证明。Rocq重验保留每个原始属性ID、位置、输入域、界限和位观察方式。

Root独立总检通过16个问题、三份完整CompCert门禁及454条实际输入快照SHA核验。关系还单独从空目录冷构建并通过内核检查；具体执行引理也经过独立内核检查。当前有效证明均有精确类型的 GoalBinding 证书及原始工具回执。

## 如何阅读产物

WSL根目录：`/home/yangfp/five`。

```text
paparazzi/models/<入口>/
  prepare/   原始来源、<入口>.c、bindings、请求及成本
  cbmc/      harness、真实属性/结果、历史尝试及成本
  align/     自动Csyntax/Cexec模型、待证接口、映射及成本
  rocq/      正式证明问题和尝试
    <任务>/problem/Spec.v          问题/前条件/规约
    <任务>/attempts/<编号>/Proof.v  实际证明
    <任务>/attempts/<编号>/report.md、costs.json、evidence/
paparazzi/relations/lowpass_recovery/
  problem/Spec.v                 跨三个模型的关系问题
  attempts/001/Proof.v           组合证明
paparazzi/report/lowpass_recovery/
  delivery-candidate.json、check_all.py、costs.json、evidence/
```

每个模型的当前尝试：无错误001、功能001、终止性002、执行对应001、CBMC重验002。关系当前尝试001。生成层 `align/model/proof/` 是待证接口；实际完成的证明看 `rocq/*/attempts/*/Proof.v`。旧尝试保留原报告、失败记录及取代原因。

## 成本

记录截止：2026-11-06T20:53:32.996161+00:00；任务墙钟约154.61分钟，直接从本次用户指令时间计量。

|指标|记录值|
|---|---:|
|input token|205,304,888|
|output token|766,879|
|总token|206,071,767|
|其中cached-input|204,359,680|
|其中reasoning-output|482,615|
|最大已观测单个工具进程树采样值|2857.38 MiB|
|并发全任务内存峰值|未联合采样，null|
|全任务工具CPU总数|历史缺口和嵌套重叠，null|

token按实际会话事件ID并集去重；cached-input包含于input，reasoning-output包含于output。共享批次和各案例的相同引用不重复累计。逐阶段和每次证明尝试均有统一 time/token/memory 成本记录。

历史费用说明：一次失败align被重复结束，初次阶段墙钟无法恢复，记null；第一次短时内核超时和部分早期诊断缺少完整工具CPU/RSS回执。旧CBMC重验001的回执归档/审计问题与关闭后更正均透明留档，当前002重新完整冷验证且成本核验自然通过。未知值没有估计补齐。各条详细依据见总 costs.json、成本运行索引及对应尝试报告。
