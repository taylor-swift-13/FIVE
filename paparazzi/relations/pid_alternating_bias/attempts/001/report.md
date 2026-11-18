# 交替零均值输入的实际积分漂移：四项目标已证明

在原始、不修改的 guidance_pid_h_run_pos Csem 模型上，全部符号参数 `0≤A≤4096`、`0≤kp,ki≤100` 和任意自然数 n 满足用户公式。每拍原始InputGood有效，参考位置交替+A/−A，其余指定输入0，in_flight=true、approx_force_by_thrust=false、warm NED caches，实际积分逐拍保留。初始实际积分0，L=93650944：64整除kp×A则2n拍后积分0；否则为−min(n×ki,L)。这是实际存储字的Int.signed观察。

[规范](../../problem/Spec.v)绑定四个已验收目标，未完成请求：无。`proved_drift`量化所有实际2n次Csem调用轨迹；`proved_initial_existence`给出所有参数真实可满足内存；`proved_ready_execution`把合法准备驱动转换成真实调用；`proved_execution_existence`对所有参数与所有n直接构造真实2n调用，因此没有用Ready前提代替全域可实现性。

精确单次机器执行由 [Semantic.v](Semantic.v)连接到原normal-return及normal-memory唯一性，再使用既有溢出安全范围证明的整数乘加、负算术右移与饱和对应。`DriftArithmetic.v`证明负半拍为−(floor(kpA/64)+余数位)；ki×floor(kpA/64)≤640000<L是声明域的推论，保证非正偶拍状态后的正半拍不达上饱和。归纳没有增加参数前提，也未替换原模型为手写递推。

[Witness.v](Witness.v)从真实原初始全局内存及实际Mem.store构造所有符号参数的实例。[Driver.v](Driver.v)证明真实原调用返回后InputGood及所需输入保持，并只store私有gh块44处参考x字段；环境保留两个实际积分。[Proof.v](Proof.v)对这种驱动逐对构造任意n轨迹。存在性选择合法私有gh/ret实例；私有块条件只用于构造见证，未加强量化全部调用者的DriftGoal前提。

原C、CompCert模型和旧证明不变；没有重跑CBMC/align或修改论文。继承目标CompCert 3.17 x86-64 Linux、小端、原始返回缓冲ABI `[Vptr ret 0; Vint 1; Vptr gh 0]`；本结论止于原始CompCert Csem。积分按Mint32整数load的精确位字观察，不解释padding或inactive union字节。

原始prepared C SHA256：`8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04`。当前Spec SHA256：`be7af5e4b90e8182a974223ebb9386c012b9dc2a11fe713ccb2a5b40f01e7b75`。当前Proof SHA256：`d3c6affa47a2b5a728b7e729b7d621c50dd4d316260902369b1f49e31a21cfda`。[provenance.json](provenance.json)固定当前全部消费源码、原始prepare/align handoff及外部语义hash；[goal-validation.json](evidence/goal-validation.json)固定实际编译快照、全部四个精确类型与内核回执。

已对134个本地Rocq模块从独立快照完整冷编译；Rocq 9.2/OCaml4.14.2。Proof独立内核：[proof-kernel-evidence.json](evidence/cold-checks/20261118T100040836000/proof-kernel-evidence.json)。精确typed GoalBinding由实际四定理实例化后编译，并独立内核重验：[certificate-kernel-evidence.json](evidence/cold-checks/20261118T100040836000/checked/paparazzi/relations/pid_alternating_bias/attempts/001/certificate-kernel-evidence.json)。所有请求定理实际Print Assumptions已留日志；无新Axiom、admit或Admitted。继承假设为原CompCert/Flocq边界：经典逻辑、ClassicalDedekindReals两个选择原则、函数外延性、proof_irrelevance及标准external_functions_sem/inline_assembly_sem参数。

复现：在/home/yangfp/five执行 `source scripts/env.sh`，再 `python3 paparazzi/relations/pid_alternating_bias/attempts/001/check.py --timeout 600`。默认重放不改历史回执；`--publish`在全部检查及hash稳定后刷新当前证据。当前成功源快照及失败/中断日志均保留。

三个实际作者会话均GPT-6.1 Sol Ultra；[runtime-config.json](evidence/runtime-config.json)是实际turn_context元数据，不是配置猜测。每个会话开始分析前建立独立--session遥测，全部模型token有事件边界。原始run各归档一次到[evidence/telemetry](evidence/telemetry)，receipt.run与[costs.json](costs.json)均引用归档，原始日志内容未改。

| 实际区间 | 墙钟秒 | 保留GNU工具CPU秒 | 总tokens | 已索引观测树RSS bytes |
| --- | ---: | ---: | ---: | ---: |
| 主证明作者与最终冷验 | 2992.5797986984253 | 943.91 | 21337551 | 1552187392 |
| 精确整数算术子证明 | 265.42089343070984 | 2.76 | 872704 | 472793088 |
| 符号内存与实际驱动子证明 | 2365.9398918151855 | 1201.6 | 15955521 | 834174976 |

去重281个stage边界内事件：input=38027922，output=137854，total=38165776，cached-input=37762304，reasoning-output=60197（后两者为子集）。直接主墙钟2992.5797986984253秒；全部保留GNU收据逐份去重CPU合计2148.27秒。最高已观测单进程RSS为1550372864 bytes。子作者finish后对账的实际模型事件保持未归属，由根端到端总账并集，不伪改历史stage边界。

并发Run.command暴露原命令索引写回覆盖；[costs.json](costs.json)补充原GNU收据合计并保留原metrics/audit，没有重建冒充原ledger。见证子任务的[原收据对账](evidence/witness-raw-command-totals.json)逐份绑定117个保留time文件。部分<10ms快命令漏采RSS，加上raw-only命令缺元数据，使完整工具树峰值未知；表中只是已索引观测最大值。联合并发峰值、模型服务器/桌面agent内存亦未测量，不以0或估计填补。严格审计缺项如实保留在[cost-audit.json](evidence/cost-audit.json)；用户允许内存缺失。包装启动/文件传输和边界前强制读取的独立CPU/RSS未知。
