# Attempt 002 — 原语义主目标与 124 项重验

本次作者实际为 **gpt-6.1-sol / ultra**；ultra 是用户对此次重试的明确配置，覆盖 skill 的默认 medium。运行从分析与前条件修订之前建立，涵盖证明构造、失败、修复、编译及内核检查。实际 runtime 回执与共享运行见 evidence 和 costs.json；历史 001 的配置、结果、成本及全部文件保持不变。

原 C SHA-256 为 `8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04`；模型为 PidPositionRunPos.Source / Execution，CompCert 3.17、Rocq 9.2、OCaml 4.14.2，x86-64 Linux standard ABI、小端、binary32 RNE。当前源、模型、规约与证明依赖的完整 hash 由 provenance 与 goal-validation 绑定。没有改写原 Source.v / Execution.v，没有用裁剪后的控制器替代原函数。

## 精确主目标

evidence/GoalBinding.v 将以下六项逐一绑定到当前 problem/Spec.v 的完整预期类型，并实际编译、打印假设、接受独立 rocq check：

| 当前规约 | 已检查证明 |
|---|---|
| PositionTranslationGoal | Proof.position_translation |
| NoErrorGoal | Proof.no_error |
| AllSuccessorTerminationGoal | Proof.all_successor_termination |
| InputNonvacuityGoal | Proof.input_nonvacuity |
| NonzeroNonvacuityGoal | Proof.nonzero_nonvacuity |
| RelationalFrameGoal | Proof.relational_frame |

关系目标同时给出两侧原入口的正常返回存在性，并覆盖**任意两次正常返回**。NoError 覆盖原 Csem 的全部可达状态；终止覆盖全部可能后继的 Acc，底层证明甚至不要求 InputGood。不存在把某条 Cstrategy 路径当作所有 Csem 求值顺序的替代。

实际入口采用隐藏返回缓冲区 ABI：参数为 `[Vptr ret 0; Vint flight; Vptr gh 0]`，函数返回 void / Vundef，结果由调用者缓冲区观察。证明包括原四次缓存 getter、位置与速度差值/浮点夹限、完整 PID 算术、两种 flight 分支、积分器、禁用推力近似时的原短路分支、原 factory、结构体复制、参数绑定、分配与释放。所有原函数和运行分支仍在模型中。

## 前条件修正及 001 记录

原 InputGoodLegacy 保持原定义；新的 InputGood 显式加入 ref.pos 与 state.ned_pos_i 的 x/y 实际 Some(Vint) 加载，以及有符号位置减法可表示条件。可读内存允许 Vundef，因此原单次 NoError 问题的前条件不足以支持整数计算。没有以“会正常返回”或“最终关系成立”作为前提。

主关系原先的 AxisTranslation 已包含初始化位置和安全减法条件。Proof.corrected_relation_domain_unchanged 证明新旧 InputPair 域等价；主关系没有被静默缩域。原规范精确快照在 evidence/Spec-original-001.v，变更理由与 hash 在 evidence/precondition-change.json。

001 的完整内存 vm_compute / lazy / raw-memory 见证方法在函数执行之前遇到资源瓶颈，没有产生该程序的反例，也没有证明程序不可执行。001 已检查的算术、quiet-step 桥及两项原 getter 定理仍有效。此次采用任意符号 mem、权限、真实 Mem.store/storebytes、组合调用与求值上下文证书；001 的报告、费用与证据未改签。

## 非空性、数值和字节观察

非空见证由 Genv.init_mem 存在性/初始化特征、两个新分配块和有限合法 stores 构造，未对完整初始化内存求值。实际一侧 x 参考/测量为 512/0，另一侧为 26112/25600；位移 dx=25600 非零，位置误差 512 非零，且两种 flight 均存在完整原 Csem 执行。

heading 的 [-3,3] 浮点比较前提经 Flocq 推出原乘 4096 与转 int 有定义，结果范围 [-12288,12288]，没有另加期望执行结果或未证明 cast 前提。只读静态限值 1429/3216 从原 init_mem 特征和逐字节只读一致性推导。

FramedNormalReturn 证明原调用共增加 15 个分配编号，恢复所有块、偏移、权限种类与权限等级的原权限。四个误差字和四个 PID/积分器输出字具有实际 store 的 encode_val 字节；其余旧字节按精确写入范围保留。FrameRelation 因此证明最终逐字节关系，而非由数值相等推测内存相等。观察为 CompCert Mem.loadbytes / memval；未知字节没有被改成零，返回缓冲区依原规约排除，已释放新栈块没有可读权限。

## 独立检查、外部边界与重验

本次已成功独立检查六项 GoalBinding 及其完整传递证明闭包，另分别检查真实非空见证、原 core、全求值顺序 shell 与最终内存证明。实际命令、Print Assumptions 输出、声明快照与依赖 hash 见 goal-validation 和对应真实 Run 日志；check.py 提供重跑入口，不执行或重编历史 001。

假设输出保留 CompCert/标准库实际继承的 classical、functional extensionality、proof irrelevance 及 external_functions_sem / inline_assembly_sem 等接口；没有为本目标新增未证明公理或 admitted proof。原 stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f 绑定保持 OPEN。已证域的有效 NED_i 缓存和 approx_force_by_thrust=false 排除这些调用；不声称域外完整外部环境对应。

124 个实际 CBMC ID 的 Rocq 命题按原 ID、表达式、位置、对象跨度和原边界逐项绑定，分为 51 项整数溢出、7 项移位、60 项指针检查和 6 项断言。控制器与入口的算术结论直接量化原入口的所有实际 Csem 可达 ready 操作；初始算术树经每种操作数求值顺序、复合赋值展开、分支、调用和释放保持。harness 的六个平移加法按原有界位置/位移的逻辑 InputPair 域证明有符号可表示性，未冒称未建模 harness main 的执行事件。approx=false 的短路证书排除未执行分支中的检查点，未把操作成功当成前提。

指针命题的前提只有 InputGood、实际可达状态、原字段/类型/上下文绑定，当前可读跨度由真实语义安全性推出。已释放但仍 valid_block 的情况不能替代当前权限；每一项都有当前 readable_span。GH 的 24 字节引用对象范围与当次 4 字节标量访问分开记录，缓存访问宽 4，factory 原向量复制宽 8。

六个断言除任意两次原 NormalCall 的结果关系外，还在第二次最终内存上构造真实分配、类型转换、store/load 的局部快照，证明原 alpha-renamed &&/== 表达式的 Csem.star 到 Vint 1。此观察限定逻辑 InputPair 域，未声称未建模 nondet/assume harness 的完整 main 执行。主 NoError 不是 signed-overflow 检查的替代。canonical `PidPositionRunPosCBMCAttempt002.Proof` 的全部 124 个独立定理别名与 `checked_properties` 已编译并通过独立内核检查；`checked_property_count` 精确为 124。当前逐 ID expected binding、依赖 hash、冷构建和交接校验记录见模型 cbmc_recheck/attempts/002 与 spec-recheck。check.py 的 `--cbmc` 入口会重新检查这组规范，不执行历史 001。

本次所有失败、超时和内存受限尝试保留于同一真实运行，包括闭合浮点 proof-object 求值、未限定参数的字节 frame 重写，以及随后符号化修复。时间、token、工具 CPU/RSS 与共享成本只引用实际记录；不伪造逐子目标分摊，缓存与 reasoning token 不重复相加。模型服务器内存不可观测，不计入工具 RSS。
