候选1已完整验证并反驳：原float_quat_vmult(q,v)与原float_rmat_of_quat(q)后接float_rmat_vmult(R,v)并非逐位相同。

| 项目 | 当前结果 |
|---|---|
| 三模型全可达no-error | proved（各自明确合法分离内存前条件） |
| 三模型全部后继Acc终止 | proved |
| 三模型8类全域执行对应 | 24/24 proved |
| 原传统CBMC共享ledger | 300 SUCCESS、1 FAILURE；301/301独立重验/反驳 |
| 单位例与原实际trace | 原Csem正常调用、全输出字节、caller frame、真实memcpy和完整断言false均proved |
| 标准最终gate | 三个均accepted；共享ledger只计301，不计903 |

q=(1,0,0,0), v=(1,0,0)时，直接路径x=0x3f800000，矩阵路径x=0x3f7ffffe，数值差2^-23。原double sqrt2常量先舍入到float临时量再平方的路径，与直接式的运算顺序不同；这是有限精度路径差异，未发现本query中的内存崩溃反例，也未声称一般误差界。

原CBMC实际反例q bits=[bf37aaca,be3dbde6,a03504f3,10073b11]，v=[43004017,44800000,8e000000]，A=[41496084,41f167c0,c3882155]，B=[41496085,41f167c0,c3882155]。单位例与该trace各自单独证明，不互相冒充。全部原C保持固定提交abfee3dd56eeab12c528635504a429db3daf409a的入口正文/类型/宏；没有替换浮点实现或执行模型。

入口：paparazzi/relations/quat_rotation_paths/problem/Spec.v与attempts/001/Proof.v；每模型四阶段handoff及各problem/status.json给出精确当前证明。实际模型/effort为gpt-6.1-sol/ultra；所有PrintAssumptions和独立kernel回执保留。

资源：prepare、CBMC、align、Rocq逐次recorded实测在各report/costs.json的共享记录中；最终去重汇总为paparazzi/relations/quat_rotation_paths/evidence/workflow-costs.json。相同event_id只计一次，缓存/reasoning是子集，逐case未独立分摊为null。端到端墙钟包含真实会话/OS中断闲置；部分历史工具CPU不可恢复仍为null，并发联合RSS不可用，禁止以worker峰值冒充。

复核：source scripts/env.sh；python3 paparazzi/report/quat_rotation_paths/check_all.py。可直接运行各attempt/check.py独立重编译精确目标；完整gate重放入口publish_gate.py --write --run-gates --record-run <新的实际five-verify run>。本交付未commit、未push。
