量词与精确命题见 [Spec.v](Spec.v)。当前 [001](../attempts/001/report.md) 四项目标均已证明。

入口是未改原始 Csem 的 stateGetSpeedEcef_f，实参为空。HitInput 只要求 _state 符号定位、offset280 可读的 Mint16unsigned status 和 bit5=1；不要求其余标志值，也不要求328..339浮点缓存已初始化。返回地址为 _state+328；命中分支不读取那12字节，因而整个 mem 精确不变，未知 memval 保持未知。该弱前条件本身不声称返回指针可解引用；完整协议层另给656B可写状态与已完成首轮转换。

SafetyGoal 量化所有可达原始状态；TerminationGoal 用 Acc 覆盖所有后继。ExactReturnGoal 同时给出正常路径及任何正常返回的指针/整个内存唯一性。ByteFrameGoal 对任意块/偏移/长度的 Mem.loadbytes 选项逐一相等，并保留 HitInput。没有待证目标。
