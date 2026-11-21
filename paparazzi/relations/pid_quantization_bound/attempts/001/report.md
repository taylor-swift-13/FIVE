# PID 精确除法参考及任意调用数偏差：完成

六个请求目标全部证明；没有待证目标。当前问题是 `../../problem/Spec.v`，问题范围与方程见 `../../problem/report.md`。真实使用 GPT-6.1 Sol、Ultra；请求与观测一致，运行元数据见 `evidence/runtime-config.json`。本次用户指定 Ultra，覆盖示例的默认 Medium。

| 请求目标 | 当前定理 | 结论 |
| --- | --- | --- |
| arbitrary_horizon | `PidQuantizationAttempt001.Proof.proved_arbitrary_horizon` | proved |
| execution_total | `PidQuantizationAttempt001.Proof.proved_execution_total` | proved |
| every_call_no_error | `PidQuantizationAttempt001.Proof.proved_every_call_no_error` | proved |
| every_call_termination | `PidQuantizationAttempt001.Proof.proved_every_call_termination` | proved |
| execution_existence | `PidQuantizationAttempt001.Proof.proved_execution_existence` | proved |
| reference_interpretation | `PidQuantizationAttempt001.Proof.proved_reference_interpretation` | proved |

对任一 x/y 轴、同一固定符号增益、相同逐周期符号输入、相同任意合法初积分，经过 n 次原始 Csem 调用，令 T=131072、S=65536、a=2+3kd/T：积分原始编码单位的偏差在 `[0,n*ki*a]`。n>=1 时实际全局命令及实际返回对象对应字段中读出的同一命令满足

`0 <= u_ref-u_C <= min(6432,5+3kd/T+n*ki*a/S)`。

上界随 n 至多线性增长；实际差值可随输入和饱和而减小。数值偏小表示向负方向偏移。转换至弧度精确除以4096，参考分子分母为 `T*S*4096=35184372088832`；`RationalReference.radians_error_scaling` 给出严格的 Q 不等式转换。n=0 仅有积分关系，没有命令观察。

PD 两级取整损失至多 `2+3kd/T`，速度与加速度前馈的两个取整各至多1，积分转命令的取整至多1。单周期积分器误差增加至多 `ki*a`；积分器夹持和两次命令饱和均单调且不放大有序差值。`ExactArithmetic.exact_cycle_error` 证明这些数学事实；`Proof.one_cycle_observed` 通过已证 `normal_axis_observation`、`axis_machine_exact` 将它们连接到原实际返回内存；`cycles_growth` 对实际调用数归纳。

参考是保留原算法顺序和实际编码常数的精确有理运算。它积分 PD，保留位置/速度误差夹持、总前馈、积分限幅以及1429和3216两次命令饱和。`RationalReference` 的 Q 算法与可执行 Z 分子实现普遍相等；动态除法均无舍入。航向的原浮点处理不在本数值参考范围。

每周期保持原有 `InputGood`：真实内存/ABI/帧、位置减法安全、缓存有效、`approx_force_by_thrust=false`、各编码增益0..100，以及原速度/加速度/积分/航向范围。引用的 Csem 轨迹执行 `in_flight=true`。环境步只准备许可输入并保持真实积分器。主偏差定理没有把观测命令、正确输出、未来返回、零前馈或零误差放入前条件。

`proved_execution_total` 从任意 `ReadyCycles` 的合法输入驱动构造实际返回轨迹，返回使用原入口已证总性；`WitnessBridge` 对全部 A∈[0,4096]、kp,ki∈[0,100] 和任意 n 构造真实初始内存、实际输入 store 和返回后的合法状态，证明两轴驱动可满足。该非空性族的零速度、加速度及部分零增益仅用于存在性见证，未缩小主偏差定理的任意输入域。

## 模型、观察与信任边界

原案例 `paparazzi/models/guidance_pid_h_run_pos` 的准备、CBMC、align 和旧证明均不可变复用，本次没有重跑这些阶段，也没有增加新的 CBMC 结论。输入索引 `provenance.json` 校验原 handoff 的准备源码、bindings、模型manifest、Source.v、Execution.v及完整导入源码闭包；外部语义依赖按manifest中的绝对路径和SHA256核验。

模型目标为 CompCert x86-64 Linux 标准ABI、小端、32位有符号命令字段。命令观察是 `Mem.load Mint32`：全局 `_guidance_pid._cmd_earth[axis]` 与实际返回对象 `_sp._ltp_i._vect[axis]` 均为同一 `Vint`；积分同样从实际全局字段读出。原 Csem 原函数保留全部内存操作；帧和输入权限来自原条件及已证原调用结果。没有新主张整块返回对象所有字节都等于参考。可信边界包括记录的 CompCert前端、固定外部绑定、原Rocq语义与继承库假设；未主张任意GCC/原生硬件一致性。

精确Q参考及本次数学取整引理 `Print Assumptions` 封闭。执行层定理保留原库继承的经典逻辑、函数外延、CompCert proof irrelevance和全局外部/内联汇编语义参数；原始打印在下述编译stdout中保留。没有新增未证明Axiom、Admitted或admit。

| 输入/证明 | SHA256 |
| --- | --- |
| `paparazzi/models/guidance_pid_h_run_pos/prepare/source/guidance_pid_h_run_pos.c` | `8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04` |
| `paparazzi/models/guidance_pid_h_run_pos/align/model/Source.v` | `f33d6cd38506ff1e080cda6d2261f873a6f269ccb8be1b924ca56c2fa8c4e26f` |
| `paparazzi/models/guidance_pid_h_run_pos/align/model/Execution.v` | `92b467146447e6b549f6224440049979e58911b55b9418defd3b28c10cf8fea1` |
| `paparazzi/relations/pid_quantization_bound/problem/Spec.v` | `0be69fe55be38ae14ead66142a78da637f8ffa23ca7129d003f0e867c53c4739` |
| `paparazzi/relations/pid_quantization_bound/attempts/001/Proof.v` | `f1dc09c2333a12b8f057ecfb52285de8a896c178ae1b92abfb02ecec6691d4f4` |
| `paparazzi/relations/pid_quantization_bound/attempts/001/ExactArithmetic.v` | `03fb563eaa194c3487e7eb2df6e915d44aa52ba491de1ae508fef5b6c5e18bc3` |
| `paparazzi/relations/pid_quantization_bound/attempts/001/RationalReference.v` | `98acf57020b51e8825f5c945a10d5cad2b61247d0c87d307eacc665674c87159` |
| `paparazzi/relations/pid_quantization_bound/attempts/001/WitnessBridge.v` | `5abede9f3ce558af873d71c3863d4db90421ad1fc18d2659475c92796b46e5ba` |

## 可复跑证据

工具版本实际输出：`The Rocq Prover, version 9.2 / compiled with OCaml 4.14.2`。

最终检查在同一作者Run `runs/20261119T040922-b502ef0c85/five-rocq` 中，将当前 137 个实际消费的本地源码先冻结到全新 `evidence/cold-checks/` 路径，逐个执行直接 `rocq compile -q ... file.v`；源码快照与所有外部语义hash由 `evidence/goal-validation.json` 绑定。全部六个目标在确定性的 GoalBinding.v 中按精确预期类型实例化，保留 Print Assumptions、实际编译和独立内核检查。

独立Proof内核命令 `261-cold-independent-proof-kernel`、精确证书编译 `262-cold-exact-goalbinding`、独立证书内核 `263-cold-exact-goalbinding-kernel` 全部实际退出0。收据为 `paparazzi/relations/pid_quantization_bound/attempts/001/evidence/cold-checks/20261119T042539929496/proof-kernel-evidence.json` 与 `paparazzi/relations/pid_quantization_bound/attempts/001/evidence/cold-checks/20261119T042539929496/checked/paparazzi/relations/pid_quantization_bound/attempts/001/certificate-kernel-evidence.json`。完整argv、超时、stdout/stderr、GNU time及RSS采样统计在Run的run.json和logs中，命令直接调用rocq，没有skip/admit/norec方式。

复跑（保留当前发布证据）：

```sh
source scripts/env.sh
python3 paparazzi/relations/pid_quantization_bound/attempts/001/check.py
```

历史失败命令 `001-author-compile-ExactArithmetic, 026-author-compile-ExactArithmetic, 027-author-compile-ExactArithmetic, 029-author-compile---dependencies` 保存在本次Run；数学初稿和修复费用已包含，没有只统计最后成功编译。Q辅助证明的8次真实编译及见证辅助的26条真实命令分别留在各自Run，亦包含在去重总成本内。

## 实际成本

成本入口 `costs.json` 使用 five-stage-costs/1。新工作与两个辅助的token按事件ID并集计一次；旧模型和旧证明历史成本未重新计入。

| 范围 | 总token | 直接墙钟秒 | 工具CPU秒 | 工具树采样峰值bytes |
| --- | ---: | ---: | ---: | ---: |
| 本次关系证明阶段（已含辅助） | 16,634,566 | 1596.472870 | 1084.69 | null（并行联合峰值未观测） |
| `runs/20261119T041734-3b4aaeb961/five-rocq` | 1,467,401 | 263.379580 | 12.63 | 537,612,288 |
| `runs/20261119T041650-7960672274/five-rocq` | 6,169,029 | 522.206803 | 97.28 | 824,315,904 |

辅助行是整体的已含子记录，不能再次相加。整体input=16,568,606，output=65,960，cached-input=16,436,352，reasoning-output=29,594。缓存和推理是子集。本作者直接记录的工具树采样峰值为 1,549,750,272 bytes；整体GNU单进程最大RSS为 1,547,784,192 bytes。这两个值均不能替代并行整体RSS峰值。RSS按请求10ms采样，可能漏短峰并重复计算共享页；模型服务端和桌面进程内存不可见。

整体墙钟从首次实质源码研究前的真实 `--session` 边界直接计时；辅助墙钟不相加。CPU/RSS的测量对象是记录的证明工具，未将文件检查/调度开销或模型服务内存冒充为工具测量。主Run收尾链接已闭合的见证Run以覆盖其费用，保留该辅助原始parent=null的历史。主Run的原始成本audit状态是 `incomplete`，独立audit退出码 `1`；未观测的并行联合峰值按契约为null，验证结论与成本指标完整性分别报告。各辅助自身严格成本核验通过。没有估算或以0替代未知指标。

归档及计量补充：三个已闭合 proof Run 已移入 `evidence/telemetry/`，原仓库 Run 路径保留符号链接别名，因此既有独立内核收据继续解析到相同字节；没有复制或改写历史原始记录。成本引用按 attempt 相对路径解析。原审计器把时间重叠保守标为可能父子重复计量；`evidence/cost-reconciliation.json` 保留各直接工具 argv、GNU time及规则，主工具均为直接Rocq调用，未包裹独立辅助agent的工具。独立命令CPU按记录计一次；并行联合RSS继续为null。主证明结束到新包装计量开始之间的真实模型事件差额另列于成本中，工具时间/内存没有独立观测，保持null。

包装收尾记录：`evidence/telemetry/20261119T043744-a1696d0143/five-verify`。该独立five-verify计量为 1,369,202 tokens、286.329578秒直接墙钟、0.13秒已记录工具CPU；采样工具峰值 13824000 bytes。自身成本审计退出码1，原始状态incomplete。证明结束至包装开始的已测793525个模型token另列，工具资源未知。三段实际事件按ID并集统计，证明阶段表不含这两段收尾费用；整体工作流汇总由父five-verify报告提供。
