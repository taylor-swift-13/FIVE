本次验证已完成：33个新精确目标全部 proved，11个active问题、两套完整CompCert门禁及786份物理输入副本验收通过。原reset模型、证明、报告和历史成本完整复用，没有修改或重新署名。

对任意 binary32 value（含NaN、Inf、±0、次正规），初始只需对齐且不绕回的 writable12 对象，旧字段允许未初始化。原reset的实际输出内存传入原get的实际Csem调用。两次正常返回存在；所有允许的正常返回均精确为Vsingle value，位模式与彼此一致。time_const偏移0..4的Mem.loadbytes保持不变，包含未知字节。frame分别量化每次调用前有效的原调用者块，允许临时参数栈分配/释放。

getter31个目标：所有可达状态无错误1、所有后继Acc终止性1、正常返回存在与所有返回的精确值/只读性质2、完整执行对应8、全部19项真实CBMC守卫和断言的Rocq重验。关系另证NormalCompletion与AllReturns两个目标。终止性对任意机器参数/内存成立；合法安全条件下的正常返回单独证明，避免把非法状态有限停止说成正常完成。

[精确关系问题](../../relations/lowpass_readback/problem/Spec.v) · [关系证明与假设](../../relations/lowpass_readback/attempts/001/report.md) · [getter汇总](../../models/get_first_order_low_pass/rocq/report/report.md) · [严格复现门禁](check_all.py) · [最终独立门禁receipt](evidence/parent-final-gate.json)。

实际证明worker为gpt-6.1-sol，requested/observed medium；[runtime receipt](evidence/runtime.json)。目标固定为CompCert3.17原Csyntax/Csem/Cexec、x86-64 Linux standard ABI、小端binary32 nearest-even和manifest/Archi绑定的NaN策略。源函数体未改，只移除static inline以导出。可达外部调用闭包为空；继承Stdlib/CompCert经典逻辑、实数可判定性、函数外延性及通用外部语义参数以每个Print Assumptions原日志为准，无新增目标公理或admit。

以下成本是实际记录值。墙钟是各自边界的直接测量，存在重叠，不能相加；CPU/RSS仅覆盖已计量命令。未采样的authoring/setup helper包容CPU/RSS均为null，未用重放或估计填充。缓存/推理token是输入/输出的子集。每问题独占分摊未知为null，只引用共享实测阶段。

| 实际阶段/尝试 | 结果 | 墙钟s | 输入token | 输出token | 总token | 命令CPU s | 命令树RSS峰值 bytes |
|---|---|---:|---:|---:|---:|---:|---:|
| prepare 025543 | passed | 72.284050 | 222362 | 1386 | 223748 | null | null |
| cbmc 025711 | passed | 86.985588 | 238389 | 1971 | 240360 | 0.09 | 23506944 |
| align 025839 | passed | 132.081914 | 602385 | 2312 | 604697 | 54.44 | 1467928576 |
| rocq 030051 | failed | 1132.899813 | 5429247 | 31931 | 5461178 | 380.49 | 1406447616 |
| cbmc 031944 | passed | 28.227832 | 147825 | 859 | 148684 | 0.04 | 17453056 |
| align 032012 | passed | 41.705080 | 148811 | 844 | 149655 | 0.08 | 30801920 |
| rocq 032054 | passed | 366.050786 | 2191045 | 11692 | 2202737 | 298.54 | 1391046656 |
| verify 032720 | passed | 560.267368 | 3121499 | 16647 | 3138146 | 8.70 | 45912064 |
| verify 025508 | close_failed_after_status_write | 2295.547526 | 7935638 | 15993 | 7951631 | 101.35 | 1000886272 |
| verify 033425 | passed | 8.946366 | 0 | 0 | 0 | 5.67 | 45993984 |

任务总边界：2026-11-07T02:53:02.782Z → 2026-11-07T03:36:41.176453+00:00。直接端到端墙钟 2618.394453 s；按真实event_id并集去重 219 个事件，输入 21596690、输出 91106、总计 21687796 token；cached input 21231616、reasoning output 27063 为子集。Root task事件从确切最新用户“就做这个继续”时间开始，worker是新任务actor；包含初始未归属阶段的读取与最终报告前事件。截止后最终渲染/汇报事件不包含在本receipt。

独立计量命令的GNU CPU实测合计 849.40 s。最大单个命令树的RSS采样峰值 1467928576 bytes；并发合并任务峰值和包容全部工具的CPU/RSS为null。这一单命令最大值不冒充总内存峰值；10ms采样可能漏峰或重复计共享页，且不含模型服务器/桌面内存。原reset历史费用不加到新任务；新的复核/冷构建费用已包括。

[完整逐阶段成本](costs.json) · [去重事件/原始命令索引](evidence/task-token-union.json) · [原始成本审计说明](evidence/cost-audits.json)。初始prepare无计量命令，RSS缺失使原始成本审计不完整；其真实token/墙钟仍保留，资源未知明确null。其他worker阶段及最终验证成本审计通过。

真实历史均保留：[记录](evidence/history.json)。首轮真实CBMC成功的bash argv收据由新直接CBMC调用补齐严格门禁；一轮关系证明短模块Spec遮蔽错误修正后，新的独立正式run检查通过；一次历史授权识别冲突已按最新明确授权澄清。首次root封账因outputs参数格式错误而未完成收尾，其原始run/metrics保持不动，[失败封账快照与说明](evidence/root-close-failure/note.json)单列；新的root verify033425已完整关闭且审计通过。失败、重试及这次纠正的实际费用全部计入。当前无pending证明或授权阻塞。

复现：在 /home/yangfp/five 运行 `source scripts/env.sh` 后执行 `python3 paparazzi/report/lowpass_readback/check_all.py`。单独独立冷构建关系：`python3 paparazzi/relations/lowpass_readback/attempts/001/check.py`。门禁覆盖11个active问题、全部原始CBMC ID、两套完整执行契约和物理输入SHA。
