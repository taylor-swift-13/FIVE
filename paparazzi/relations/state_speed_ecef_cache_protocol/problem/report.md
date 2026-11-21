精确命题见 [Spec.v](Spec.v)，当前 [001](../attempts/001/report.md) 的五项形式目标均已闭合。

RepeatedHitGoal：任意满足弱 HitInput 的内存和任意自然数 n。Reads 逐次用原始 getter Csem 正常调用连接，并在每次实际 post-memory 形成独立 Observation，记录返回指针、12B memval 选项、binary32三轴位向量选项及完整656B状态快照。既存在 n 次执行，也对任意符合 Reads 的实际序列证明全部观察等于第一次调用后的快照、末内存精确等于初内存、缓存标志保持，以及任意外部块/字节 frame 不变。不是在最后内存中比较两个指针别名。

ProtocolGoal：任意 ProtocolInput 的六个 int32，不裁剪值域；状态656B可写、filterANY，两份合法分离输入。复用原始 NED setter→ECEF setter→getter 的符号协议，首次输出由旧 NED 解码；对该真实首次 post-memory 任意增加 n 次命中，全部12B/位向量、完整状态及调用方 frame 稳定。

InvalidationGoal：任意 EI.InputGood 内存、id和新的三轴源值。接受的原始 ECEF setter 覆写三个整数源字段并将status精确写为1，从而清除ECEF_F及其他缓存有效位；旧浮点12B保持（含未知字节）。getter_condition在该真实写后内存为真，故下一读取无法走旧缓存。若原输入有三轴旧NED值，则实际下一次原始 miss 仍由旧NED计算并正常返回，其后任意多次命中保持该值。

FreshnessRefutationGoal / HistoryRefutationGoal：复用原始 Csem 成对反例，并证明对任意 n 均能稳定重复其错误/依赖旧历史的观察。因此缓存一致性和写失效成立，同时最新ECEF输入正确及历史无关性不成立。未修改原 C 的错误转换字段。

来源固定到 upstream abfee3dd56eeab12c528635504a429db3daf409a；字节采用小端 CompCert Mem.loadbytes/memval，不填补未知字节。此为已有 C/AST 上新的纯Rocq协议证明；无需重跑历史prepare/CBMC/align，也没有新增有界检查。没有待证的本问题目标。
