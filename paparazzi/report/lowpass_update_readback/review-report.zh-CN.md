# update 后 get 精确读回验证

已完成新 update 模型的四阶段验证及实际 update/get 串接证明：新5个模型问题和1个关系问题共51个精确类型目标，均经过源码编译、Print Assumptions、GoalBinding 类型绑定及独立内核检查。既有 getter 模型及其5个已完成问题保持不变；本次主 agent 还独立冷编译并内核检查了关系证明。综合11问题严格交付门禁已在 worker 侧通过，完整检查两套 CompCert 门禁和512项物理输入拷贝；[实际回执](evidence/local-delivery-gate.json) 已绑定真实命令。主 agent 又以独立命令020复核通过。

验证的是原 C 调用次序：`r = update_first_order_low_pass(&filter, input)`，再把 update 的实际输出内存传给 `y = get_first_order_low_pass(&filter)`。证明正常返回存在，且所有正常返回都满足 `bits(r) = bits(y)`；中间和最终内存的 `last_in`4..8字节等于输入编码，`last_out`8..12字节等于实际返回值编码；`time_const`0..4字节逐字节保持。getter 保持其调用前所有有效 caller blocks；update 的 frame 保持原内存中写区4..12以外的 caller 字节，临时栈分配与释放不被误写成全内存相等。

安全证明的前条件单独要求：指针对齐、不回绕、12字节可写，且原 tc/last_in/last_out 都有已初始化的 binary32 类型读取。输入与三个字段允许所有 binary32 值，包括 NaN、无穷大和零分母计算结果；没有增加有限性或分母非零假设。Nonvacuity 为任意 tc/li/lo 三元组实际构造可满足的内存。执行模型和8项全执行对应仍覆盖任意机器实参列表和任意 CompCert 内存，终止性是所有后继关系的 Acc。

原始表达式的 binary32 运算树完整保留：先 input+last_in，再加 (tc-1)*last_out，最后除以 1+tc；仅移除了 static inline 链接修饰，以让独立入口留在自动导出的 CompCert Csyntax 中。源码来自 Paparazzi 固定提交 abfee3dd56eeab12c528635504a429db3daf409a，原头文件物理快照和哈希随 prepare 交付。结论限于固定的 CompCert3.17、x86-64 Linux standard ABI、小端与 binary32 RNE/已固定 NaN 策略；不声称实数代数重排、GCC硬件或跨工具 NaN 载荷恒等。

| 新问题 | 精确类型目标数 | 状态 |
| --- | ---: | --- |
| no_error：所有可达 Csem 状态 | 1 | proved |
| termination：所有机器输入、所有后继 | 1 | proved |
| functional：正常完成、所有返回、可满足性 | 3 | proved |
| execution_correspondence：8项全执行对应 | 8 | proved |
| cbmc_recheck：全部实际属性 | 36 | proved |
| 实际 update/get 关系：完成与所有返回 | 2 | proved |

传统直接 CBMC 的36项实际属性全部 SUCCESS：24项源指针守卫、9项 memcpy/bits 守卫、3项精确位断言。Rocq 逐项独立重验，不把 CBMC 成功当公理。源访问点证明给出真实 entry 和 out/last_in/last_out 三个实际存储前缀的访问见证；所有可达状态安全由独立 no_error 定理提供。memcpy 的跨对象比较通过真实分离对象守卫适配，不伪称 C 中不同对象的指针大小比较有统一语义。

实际证明 worker 为 gpt-6.1-sol、medium，当前 session 运行元数据见 [runtime-config.json](evidence/runtime-config.json)。[关系规约](../../relations/lowpass_update_readback/problem/Spec.v)、[关系证明](../../relations/lowpass_update_readback/attempts/001/Proof.v)、[update模型说明](../../models/update_first_order_low_pass/README.md) 和 [综合检查器](check_all.py) 均可直接查看。核心候选102项文件及哈希已冻结在 [core-candidate-002.json](evidence/core-candidate-002.json)，初版候选和旧绑定元数据作为真实历史保留。

实际失败和修复均保留：两个过宽 proof tactic 搜索由主 agent 精确终止，改为显式证明项后4.5秒左右完成相同命题；首个 recheck 类型证书误带旧19项模板列表，被内核检查拒绝后，在新的不可变构建目录绑定当前完整36项并通过。原 C、AST、规约和已声称定理没有因此减弱。失败证书物理快照、命令、CPU/RSS与输出见 [development-history.json](evidence/development-history.json)，未保存的旧 checker 同时输入快照明确为 null，不补造历史输入。

实际阶段观测如下，token包含真实输入与输出，缓存输入和推理输出仅为子集。墙钟是各调用的直接计时；工具CPU和RSS是实际计量命令的观测，失败和重试都包含。不同调用的墙钟不直接相加冒充端到端时间。

| 实际调用 | token总数 | 直接墙钟秒 | 自身工具CPU秒 | 已观测单命令树RSS bytes |
| --- | ---: | ---: | ---: | ---: |
| five-prepare / 20261107T060123-5c7ca7f852 | 653146 | 171.993 | 0.64 | 22913024 |
| five-cbmc / 20261107T060415-25cb84a65b | 145224 | 46.245 | 0.25 | 22953984 |
| five-align / 20261107T060501-83aa293866 | 1260838 | 182.077 | 127.36 | 1473015808 |
| five-rocq / 20261107T060803-fdf5b7a9fd | 22389337 | 2580.661 | 1176.04 | 1395462144 |
| five-verify / 20261107T065104-b5de1d4ddf | 1453753 | 248.813 | 0.61 | 28868608 |
| five-cbmc / 20261107T065513-a0cac485c1 | 213126 | 59.513 | 0.16 | 23453696 |
| five-verify / 20261107T065613-5ef20b7961 | 1532868 | 231.385 | 13.52 | 33849344 |
| five-align / 20261107T065613-c368bec83c | 0 | 0.608 | 0.07 | 17276928 |
| five-verify / 20261107T070242-dc2fe1a0b5 | 1638666 | 359.706 | 2.94 | 23588864 |
| five-verify / 20261107T055822-213c1c3ee8 | 20919001 | 3814.607 | 186.45 | 1405751296 |
| five-align / 20261107T064309-d6174ef3de | 569011 | 141.999 | 0.1 | 14393344 |
| 独立补充诊断（不重复计费） | null | null | 0.05 | null |

成本口径：prepare 两个极短读取命令、Rocq 两个极短读取命令、附加 align 一个 cat 命令未捕获工具树RSS采样；它们对应的采样值保持 null，GNU CPU与可取得的单进程RSS仍保留。各阶段表中的RSS仅是已观测命令集合的峰值，不声称每条命令均有采样。主 agent 的一次并发诊断有保留的 GNU CPU0.05秒及单进程RSS，原 Run 的墙钟/工具树采样行被并发覆盖，保持 null，并由独立补充回执计入一次CPU。主 agent 与 worker 曾并发执行，因此任务联合RSS峰值、模型服务端内存均为 null；不以各阶段峰值的最大值或和冒充联合峰值。

每个问题的逐尝试 costs.json 引用真实共享 Rocq 阶段；没有独立观测的逐尝试模型token和作者墙钟是 null，不将一份共享费用重复加6次。worker 启动前的文档、session发现和既有 GetCall 检视归为任务 setup/unattributed 的真实事件，不事后伪分摊至四阶段。旧 getter 历史费用不计入新任务；本次新的独立复核费用单独计量。四阶段完整实际记录和审计说明见 [costs.json](costs.json)、[stage-cost-audits.json](evidence/stage-cost-audits.json)。父 run、worker finalverify 和本次真实 publication 边界均已关闭；最终任务事件并集、所有新调用和诊断补充已按明确截止点汇总。

严格门禁首次还拒绝了两项产物问题：逐尝试运行元数据字段未按验证器格式挂接，以及初始 CBMC 只捕获 prepare handoff，未单独捕获原 C/harness。前者已按真实 Sol medium session 回执补全；后者没有修改闭合 raw run，而是新建065513真实直接 CBMC，先物理捕获原 C/harness 再运行，同一36项记录全部一致并通过。当前映射和重验账本绑定新运行，所有旧回执、费用和候选001保留。再次严格交付检查和主 agent 独立命令020均通过。

附加绑定修正 align065613 的真实 start/finish 位于同一工具调用内，边界内观测0个模型事件；这仅是工具绑定操作观测。脚本作者事件在前一个真实 CBMC 边界中，任务事件并集包含它；无法独立精确分摊的完整 mapping authoring token/墙钟记 null，不把0事件伪称0全部思考成本。

最终成本截止点：`2026-11-07T07:08:41.968372+00:00`；任务从最新原话“继续做”的 `2026-11-07T05:57:43.620Z` 开始，端到端直接墙钟 4258.348 秒。

| 最终任务口径 | 实际记录 |
| --- | ---: |
| 去重token（input+output） | 54215173 |
| input / output | 54053565 / 161608 |
| cached-input / reasoning-output（子集） | 53352448 / 73089 |
| 端到端墙钟秒 | 4258.348 |
| 已计量命令GNU CPU秒（含补充0.05一次） | 1508.19 |
| 含未计量setup的全部工具CPU | null |
| 已观测最大单命令工具树RSS bytes | 1473015808 |
| 任务并发联合工具树RSS / 模型服务端内存 | null / null |

完整真实事件ID、实际调用三元成本、未知项原因、截止范围和去重命令集合见 [task-token-union.json](evidence/task-token-union.json) 与 [costs.json](costs.json)。
[主 agent 最终独立回执](evidence/parent-final-review.json) 保留冷关系内核、完整11问题门禁及102项候选哈希复核。所有新51个目标是精确类型绑定角色，不虚称51项彼此独立的数学性质。证明问题无 pending；原始库假设和固定 CompCert 边界按前文及各 attempt 报告保持。
本截止之后的确定性报告渲染、哈希清单生成、最终聊天和 Windows 镜像明确排除；它们不用于补造此前未观测资源。
