# omega / zeta 设置顺序验证

比较同一个完整逻辑初始状态的两份独立副本：

```text
A: gh_set_omega(o); gh_set_zeta(z);
B: gh_set_zeta(z); gh_set_omega(o);
```

两个原始入口的无错误、全后继终止、功能结果及实际 CBMC 属性重验，连同顺序关系，均已有实际 Rocq 证明及独立内核回执。最终整体验收与去重成本见[验证汇总](../../report/parameter_order/report.md)。

| 模型 | 准备 | 实际 CBMC | CompCert 模型 | Rocq 证明 |
| --- | --- | --- | --- | --- |
| gh_set_omega | [源码与绑定](../../models/gh_set_omega/prepare/handoff.json) | [15 / 15 属性](../../models/gh_set_omega/cbmc/report/report.md) | [来源与映射](../../models/gh_set_omega/align/report/report.md) | [问题、证明与验收](../../models/gh_set_omega/rocq/report/report.md) |
| gh_set_zeta | [源码与绑定](../../models/gh_set_zeta/prepare/handoff.json) | [3 / 3 属性](../../models/gh_set_zeta/cbmc/report/report.md) | [来源与映射](../../models/gh_set_zeta/align/report/report.md) | [问题、证明与验收](../../models/gh_set_zeta/rocq/report/report.md) |

[关系规约](problem/Spec.v)、[证明](attempts/001/Proof.v)、[证明报告](attempts/001/report.md)及[严格目标证书](attempts/001/evidence/goal-validation.json)分别证明：两条具体调用链都能正常返回；每对实际正常执行都有同一精确最终字段公式；十四个命名字段的位表示相同；前条件确实可满足。每个模型还保留功能与执行对应两个辅助问题，因此总共十一项具名问题；原请求的两模型各三类性质及跨模型关系全部包含在内。执行对应辅助问题的实际目录分别为 omega 的 [execution](../../models/gh_set_omega/rocq/execution/problem/report.md) 和 zeta 的 [execution_correspondence](../../models/gh_set_zeta/rocq/execution_correspondence/problem/report.md)。

令 O、Z 为实际 Bound 宏对 o、z 的结果，最终状态为：

| 字段 | 最终值 |
| --- | --- |
| omega | O |
| zeta | Z |
| omega_2 | Float32.mul O O |
| zeta_omega | Float32.mul Z O |
| accel、speed、pos、tau、max_speed、inv_tau、dt | 各自初始命名字段保持不变 |

证明量化所有 binary32 参数及旧浮点字段，包含 NaN、无穷和有符号零。前条件明确要求原始完整 GuidanceHRef 对象的十四个字段具有已初始化的类型化读取值，且完整 64 字节具有写权限；无并发写入。实际 Bound 把 NaN 输入限制到下界。证明保留乘法的实际操作数顺序，没有用实数代数重排替代浮点运算。

执行语义固定为 CompCert 3.17、x86-64 Linux、小端、binary32、最近偶数舍入与该安装的精确 NaN 策略。两份模型均从固定 Paparazzi 提交 abfee3dd56eeab12c528635504a429db3daf409a 的原始入口、Bound 宏及完整结构体依赖闭包导出。实际生成复合类型的 sizeof=64、alignof=8、所有顶层及嵌套字段偏移也已证明。

比较命名字段，不比较结构体填充、独立分配块编号、局部参数释放后的字节、执行历史、按时间排列的返回值或浮点异常标志。这里不宣称 GCC/硬件等价，也不扩展为后续 guidance 更新轨迹的定理。

从仓库根目录复现：

```bash
source scripts/env.sh
python3 paparazzi/report/parameter_order/check_all.py
python3 paparazzi/report/parameter_order/check_all.py --compile
```

第一条检查四阶段交接、来源、所有活动目标与严格回执；第二条还从实际当前源码重新构建并独立检查全部活动证明。每次实际失败、重试及最终成功均保留成本和原始证据。成本中的 null 表示未观测，不表示零；历史超时或重叠计量的缺口与证明结果分别报告。
