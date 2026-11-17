# PID 位置平移：Ultra 重试的证明与验收

后续验收：第003次尝试已完成124项目标绑定编译和独立内核检查，见 [当前报告](../../../models/guidance_pid_h_run_pos/rocq/cbmc_recheck/attempts/003/report.md) 与 [本次成本](../../../models/guidance_pid_h_run_pos/rocq/cbmc_recheck/attempts/003/costs.json)。下文保留第002次尝试的历史结果、480秒超时及原计量截止；最新完整验收状态以第003次尝试和模型 Rocq 阶段交接为准。

本轮原关系六个主目标、模型 NoError/终止目标，以及全部 124 个原 CBMC ID 的独立 Rocq 重验均已完成证明与独立内核检查。六个关系目标与模型无错误、终止性使用已通过的当前精确目标绑定；全部124项正式证明的独立内核和逐ID门禁已通过，但额外整组 CurrentGoalBinding 重放在480秒超时，不标为通过。

此次三位数学作者的实际运行配置均为 **gpt-6.1-sol / ultra**。配置由真实 session turn_context 与 runtime receipt 核对，用户的 ultra 要求覆盖 skill 默认 medium。根协调器负责验收、校验脚本与发布，没有代写数学证明。

| 目标 | 实际结论 |
|---|---|
| 位置平移关系 | 两侧原入口正常返回存在，且任意两个正常结果满足原关系 |
| 原 Csem NoError | InputGood 下全部可达状态无 source_error，覆盖所有操作数求值顺序 |
| 所有后继终止 | 原入口对任意原始参数/内存均有 Acc；包括可能立即停住的域外输入 |
| 非空与非零域 | 构造实际符号内存及真实执行；dx=25600、误差512，覆盖两种 flight |
| 关系内存框架 | 精确输出字节、其余旧字节、全部权限、nextblock+15及新栈块释放 |
| 模型 NoError / termination | 当前模型问题的完整 RequestedGoal 类型别名已验收 |
| 原 CBMC 重验 | 51溢出、7移位、60指针、6断言，共124个精确ID与独立证明 |

原 C SHA-256 为 `8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04`。Source/Execution、原函数与全部运行分支保持原样；prepare/cbmc/align 的冻结证据经传递 hash 校验后复用。本轮没有用替代控制器、裁剪模型或有界执行枚举代替原 Csem 证明。ABI 为 CompCert 3.17 x86-64 Linux standard、小端、binary32 RNE；实际入口为隐藏返回缓冲区参数，返回 void/Vundef，观察 LTP 缓冲区。

## 前条件修正与旧失败记录

旧单次 NoError 问题仅有可读性，未保证 ref.pos 和 NED_i 位置缓存的 x/y 是 Some(Vint)；可读内存允许 Vundef。新 InputGood 明确加入初始化位置与可表示的有符号位置减法。没有把正常返回或最终关系塞进前提。

原 InputPair 的 AxisTranslation 已含这些条件，`corrected_relation_domain_unchanged` 证明主关系新旧域等价。旧 Spec 的逐字节快照、变更理由与 hash 单独保存。001 的完整 init_mem 求值方法在执行函数前遭遇资源瓶颈；这不是程序反例。其已检查的算术、getter 与语义辅助定理仍有效。001 全部文件、报告、费用和原目标快照保持不变，本轮费用单独计算。

## 原执行与 124 项的边界

正常路径与全求值顺序证书分开构造并连接，包含四次原 getter、位置/速度差值与夹限、完整 PID、两种 flight、积分器、原短路分支、factory、结构体复制及完整分配/绑定/释放。静态1429/3216由初始化内存特征与只读字节一致性推出；heading 范围经 Flocq 推出乘4096/转int有定义。没有完整初始化内存的大型求值。

控制器与入口的整数检查量化原入口全部实际可达 ready 操作，并绑定原 AST 节点与整数类型；指针检查从实际可达状态推出当前可读跨度，不把成功 load 或操作成功当作前提。harness 六个平移加法按原有界逻辑 InputPair 域证明可表示性；六个断言另有真实 typed snapshot 的分配、转换、store/load 及原 alpha-renamed &&/== 表达式到 Vint1 的 Csem.star。未声称未建模 nondet/assume harness main 的完整执行。

stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f 保持 OPEN；已证域的有效缓存和 approx=false 排除它们。域外完整外部环境对应没有被声称。Print Assumptions 保留实际继承的 CompCert/标准库、classical、extensionality与外部语义接口；没有新增目标公理、Admitted 或假执行摘要。

## 费用与可重跑证据

费用只汇总从 **2026-11-08T04:12:45.504Z** 开始的根请求及三位 fresh Ultra 作者实际事件。旧 medium 的61,381,526 tokens与5152.413秒墙钟是独立历史引用，不进入本轮总量。实际 token 事件按 session/事件去重；cached input 是 input 的子集，reasoning 是 output 的子集，不重复相加。完整 CPU 因缺失底层回执无法确定时记 null，另给已观测 CPU 小计；并发联合内存峰值没有实测，保持 null，单列已观测单进程/进程树最大值，不能用阶段峰值的总和或最大值代替；不估算超时消耗，不修改 raw 记录。工具 RSS 不代表模型服务器内存，后者不可观测。

最终数值、每次失败/超时、共享 run 引用与观测截止时间见 costs.json；源 hash、精确声明、直接编译与独立 kernel 回执见各当前 provenance、goal-validation.json 和 CBMC kernel-124-original-model.json；旧 publication-manifest.json 只对应历史001。重跑入口为 relation002/check.py 的 --cbmc 模式，历史001不会被执行或重编。

## 已记录数值
观测截止 **2026-11-08T09:12:02.819476Z**；本次请求直接墙钟 **17957.315 秒**。这是请求到截止时刻的实际时间，不是阶段时长之和。
| 指标 | 实际记录 |
|---|---|
| Input token | 526,871,821 |
| Output token | 1,596,162 |
| 总 token | 528,467,983 |
| 其中 cached-input | 524,350,592 |
| 其中 reasoning-output | 781,921 |
| 已观测工具 CPU 小计 | 6747.65 秒 |
| 完整工具 CPU | null；缺 GNU time 回执 |
| 并发联合工具内存峰值 | null；未进行联合采样 |
| 已观测单进程最大 RSS | 2,247,626,752 bytes |
| 已观测单命令进程树采样峰值 | 4,717,219,840 bytes |
| 模型服务器内存 | null；不可观测 |

阶段记录与共享运行如下；同一证明不会因被多个模型/关系引用而重复计费。

| 记录 | 自身边界内 token | 工具命令数 | 实际 run |
|---|---|---|---|
| lead-proof | 134,182,333 | 473 | _build/pid-position-translation-ultra-lead/20261108T041545-03e97f7214/five-rocq |
| core-proof | 135,885,518 | 598 | paparazzi/relations/pid_position_translation/attempts/002/core/runs/20261108T041531-b910be4c42/five-rocq |
| safety-proof | 166,838,232 | 288 | paparazzi/relations/pid_position_translation/attempts/002/safety/runs/20261108T041558-c0681fa42b/five-rocq |
| root-orchestration | 84,018,432 | 52 | _build/pid-position-translation-ultra-parent/20261108T041328-72f6bf20cf/five-verify |
| main-cold-check | 0 | 137 | _build/pid-ultra-cold-checks/20261108T073530-6b17da91a4/five-rocq |
| publication | 627,305 | 4 | _build/pid-position-translation-ultra-publication/20261108T090706-be8dbb32f9/five-verify |

总 token 由事件并集独立计算。根 raw Run 包含已引用的 lead 子运行，因此不能把 raw inclusive 值与子运行再相加；表中的 root 行只给该 root actor 自身边界事件。阶段边界以外但仍属本请求的实际事件仍进入总并集，未事后伪分摊。

当前 canonical124 独立内核检查已通过。额外 --cbmc 全依赖冷构建的222个源码编译及证明内核检查已通过，最后的整组 CurrentGoalBinding/Print Assumptions 重放在480秒超时，整次运行记录为 failed。失败运行 _build/pid-ultra-cold-checks/20261108T085131-16087d4672/five-rocq 的日志、原始输入与成本保留；重复源码树和可重建编译缓存已清理。该失败不被标为通过，也不抹去已成功的独立证明检查。
