# 两阶段命令限幅与统一限幅：验证完成

三个请求目标均已证明。规范为 `../../problem/Spec.v`，当前尝试为本目录。实际证明作者及见证作者均为 GPT-6.1 Sol、Ultra；真实运行元数据见 `evidence/runtime-config.json`，用户指定Ultra覆盖参考示例默认Medium。

| 请求目标 | 精确定理 | 状态 |
| --- | --- | --- |
| source_comparison | `PidSaturationAttempt001.Proof.proved_source_comparison` | proved |
| actual_counterexample | `PidSaturationAttempt001.Proof.proved_actual_counterexample` | proved |
| unconditional_equivalence_refuted | `PidSaturationAttempt001.Proof.proved_unconditional_equivalence_refuted` | proved |

## 结论

令 `A` 为按原整数运算得到的PD与速度/加速度前馈总量，`I'` 为原程序更新并夹持的积分，`b=floor(I'/65536)`。原始Csem实现的命令为 `clip3216(clip1429(A)+b)`；本次Rocq整数统一限幅参考为 `clip3216(A+b)`。统一参考只移动命令限幅，输入夹持、每个floor、PD积分更新及积分限幅均保持相同。本次验证比较一个原始C实现的真实Csem调用和一个Rocq整数参考。

任一x/y轴、任意原域合法符号输入和增益，均有：

- `-1429<=b<=1429`，所以原算法外层3216限幅不激活，实际命令等于 `clip1429(A)+b`。
- 二者相等当且仅当 `abs(A)<=1429`。
- `A>1429` 时实际两阶段命令小于统一参考；`A<−1429` 时实际命令大于统一参考。
- 绝对差不超过 `max(0,abs(A)-1429)`。

两组真实原程序执行反例均已构造。输入为参考位置x编码1280、实测位置0、kp100、其余增益0、速度/加速度/y/航向0：

| 合法初始积分 | 更新后积分 | PD加前馈A | 积分命令b | 原两阶段命令 | 统一参考 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 0 | 2000 | 0 | 1429 | 2000 |
| -65536000 | -65536000 | 2000 | -1000 | 429 | 1000 |

第一组使用零初积分。第二组展示合法已有负积分的抵消情形，只主张该初始内存满足原输入域，不主张固定ki0时它来自reset零积分历史。两组都由真实可写内存中的CompCert store构造，随后执行原始Csem调用；实际全局命令、active返回字段和更新后积分通过 `Mem.load Mint32` 观察。数值2000/1429或1000/429均低于最终3216限幅。命令编码的弧度值精确除以4096。

该结果证明两种限幅放置具有不同算法行为；逐调用算法等价性被反驳。闭环轨迹或飞行品质没有在本定理中评估。

## 域、执行连接与内存观察

沿用未改动的原 `InputGood`：flight=true、缓存有效、approx_force_by_thrust=false、五个编码增益0..100、位置差有符号安全、原有速度/加速度/积分/航向范围和真实内存/帧条件。主比较对符号输入、两轴及任意原域初积分普遍量化；反例的零前馈及具体参数没有缩小主命题。没有将正确输出、返回内存、未来返回或结论自身作为前条件。

`proved_source_comparison` 从原入口总性导出实际返回存在，对每个原 `NormalCall` 返回使用 `normal_axis_observation`、`axis_machine_exact` 和原active返回结果建立精确整数公式。`SaturationArithmetic` 证明夹持公式、精确相等条件、严格方向及差值界。`Witness.witness_input_exists` 对任意合法原积分范围构造输入内存，包含真实Mint32 store及其InputGood/ReadAxis保持；两个反例在取得实际原返回后才用闭合常数计算验证数字。反驳使用同一实际内存全局命令加载的唯一性。

观察包括返回对象type=2、format=0，实际全局积分、全局cmd_earth[axis]和实际active返回向量同一Vint命令。目标为原CompCert x86-64 Linux标准ABI、小端、Mint32有符号字段。仅这些声明字段是本问题的新观察；原模型仍保留全部执行与内存操作。

没有修改原C/Source.v/Execution.v，也没有新CBMC、C模型生成、align或论文/push操作。原模型和旧证据按原hand-off及SHA256复用。证明止于记录的CompCert前端及Rocq Csem语义、固定绑定和继承库假设。纯整数限幅证明Print Assumptions封闭；执行证明保留原经典逻辑、函数外延、proof irrelevance及CompCert外部/内联汇编语义参数，原始打印已保留。没有新增未证明Axiom、Admitted或admit。

| 输入或证明 | SHA256 |
| --- | --- |
| `paparazzi/models/guidance_pid_h_run_pos/prepare/source/guidance_pid_h_run_pos.c` | `8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04` |
| `paparazzi/models/guidance_pid_h_run_pos/align/model/Source.v` | `f33d6cd38506ff1e080cda6d2261f873a6f269ccb8be1b924ca56c2fa8c4e26f` |
| `paparazzi/models/guidance_pid_h_run_pos/align/model/Execution.v` | `92b467146447e6b549f6224440049979e58911b55b9418defd3b28c10cf8fea1` |
| `paparazzi/relations/pid_saturation_placement/problem/Spec.v` | `3992a7278a5e8a73d5facc912ac35c7fe815f202ef86388fe29f5fcce3da785e` |
| `paparazzi/relations/pid_saturation_placement/attempts/001/Proof.v` | `468ea3f21a2986c9e116213930f65306a37e6a96f0c1a0b569fd3438e8ea4733` |
| `paparazzi/relations/pid_saturation_placement/attempts/001/SaturationArithmetic.v` | `e7e1dca7fee7a02fd3a899de8362ab8fe782e2e503825b31265ea9d4f56bc530` |
| `paparazzi/relations/pid_saturation_placement/attempts/001/Witness.v` | `8053cc2d71dbd43c73bc5f59fc7db12519a56424042039401cafc11fc407c83e` |

## 可复跑的内核证据

实际工具版本：`The Rocq Prover, version 9.2 / compiled with OCaml 4.14.2`。本次同一作者Run中先冻结 140 个实际消费的当前本地源码到新cold路径，再逐个直接 `rocq compile -q ... file.v` 全编译。`provenance.json`、`evidence/goal-validation.json` 绑定所有原模型输入、当前源、实际编译快照及外部语义hash。

Proof独立内核 `155-cold-independent-proof-kernel`、精确三类型GoalBinding编译 `156-cold-exact-goalbinding`、GoalBinding独立内核 `157-cold-exact-goalbinding-kernel` 均实际退出0。当前派生收据直接指向归档 `paparazzi/relations/pid_saturation_placement/attempts/001/evidence/telemetry/20261119T071806-cb49d42dd1/five-rocq`，不依赖本地runs别名；原始run.json、命令、时间和捕获输入字节未改写。全部失败和修复记录原样保留。Print Assumptions在Proof和精确目标证书编译stdout中可查。

复跑：

```sh
source scripts/env.sh
python3 paparazzi/relations/pid_saturation_placement/attempts/001/check.py
```

checker重建新冷快照，实际执行完整编译和独立内核；普通复跑保留当前发布证据。

## 真实成本

`costs.json` 为five-stage-costs/1，当前两条证明记录是父级ROOT的独立兄弟stage，按事件ID并集合并；main自身指标不包含见证作者。旧复用模型/证明的历史成本没有重新归入本任务。

| 证明范围 | 总token | 直接墙钟秒 | 工具CPU秒 | 各自工具树采样峰值bytes |
| --- | ---: | ---: | ---: | ---: |
| lead author and final checker | 7,953,861 | 1287.650121 | 547.27 | 1408262144 |
| real-memory witness helper | 3,757,645 | 400.379481 | 23.70 | 936812544 |

证明阶段事件并集为 11,711,506 tokens：input 11,665,101，output 46,405，cache 10,995,456，reasoning 24,771。cache和reasoning均为子集。直接主作者墙钟 1287.650121 秒覆盖证明区间，辅助墙钟不相加；独立工具CPU合计 570.97 秒。并行联合工具RSS未观测，为null；各自峰值不被冒充联合峰值。GNU time和请求10ms的进程树采样原记录保留，可能漏短峰或重复共享页，模型服务端及桌面内存不可见。文件检查/调度开销没有独立CPU/RSS观测，不用估算补齐。

每次真实编译失败、修复、证明、冷编译和内核检查均包含在其session/工具记录内。各自原始成本audit状态和不同问题计数在成本记录中引用，原始原文仅留在相应归档run中。证明结束后的包装/报告阶段由后续five-verify单独计量，不倒灌已闭合的证明费用。

主作者原始成本核验补充：{"Missing sampled tool memory: 001-saturation-work-find": 1, "Missing sampled tool memory: 002-saturation-work-cat": 1, "Missing sampled tool memory: 003-saturation-work-grep": 1, "Missing sampled tool memory: 004-saturation-work-sed": 1, "Missing sampled tool memory: 005-saturation-work-true": 1}。这些原始缺项不影响已通过的源码及内核证明；未观测资源继续保留null，未通过重放伪造之前的测量。

包装阶段：独立真实five-verify Run `evidence/telemetry/20261119T073933-daa1d49f21/five-verify`，1,214,136 tokens，167.569459秒直接墙钟，0.15秒已记录工具CPU，工具树采样峰值 18530304 bytes；原始成本核验状态 complete，独立核验退出码 0。其事件与证明阶段切换边界在 `evidence/stage-transition.json` 中原样记录；整体以事件并集统计，不相加重叠墙钟。父级five-verify维护最终工作流汇总。
