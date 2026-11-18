# 严格符号对称性：反例问题

本问题请求反驳：在同一 PID 实现中，同时取反所有有符号物理输入与初始积分、保留相同增益和模式，返回水平指令是否必然严格取反。答案是否定的。为反驳全域命题，只需在一个满足其条件的子域上构造实际反例；这里选取只有 x 参考位置非零的最小子域。StrictSymmetryGoal 是全域严格对称性在该子域上的必要条件，仍然为假。输出非对称没有被放进前条件。

权威问题是 [Spec.v](Spec.v)。请求目标仅为 ActualCounterexampleGoal 和 StrictSymmetryRefutedGoal：前者存在实际合法输入内存、两条原始 CompCert Csem 正常返回执行，以及返回值和全局状态观察；后者证明 ~StrictSymmetryGoal。两个否定目标的状态是 proved；被检验的严格对称关系结果为 refuted。没有请求安全性、终止性或任意输入功能正确性的新证明。

两次输入共享同一真实初始内存布局、返回缓冲区、增益和模式。InputGood 沿用 position_translation/002 的内存、数值条件，且通过真实分配与 store 序列证明可满足。两次执行 in_flight=true、approx_force_by_thrust=false，NED_i 位置/速度缓存均有效。kp=ki=1，kd=kv=ka=0；x 参考位置分别为 +64/-64，参考速度、参考加速度、测量位置、测量速度、两轴初始积分和 heading 均为0。y 参考位置也为0。初始0积分取反仍为0，heading和坐标系完全一致。same_except_positions_and_return 要求除参考/测量位置及返回缓冲区外逐字节一致、权限和 nextblock 一致；本见证只有 x 参考位置变化。

位置定点格式有8位小数，故 ±64 是 ±0.25m；控制指令有12位小数，单位rad，1个指令量化单位为1/4096rad。严格对称预测应为 +1/-1，而实际返回和 guidance_pid.cmd_earth.x 为 +1/-2。积分更新值为 +1/-1，积分原始存储仍对称；随后算术右移16位给出0/-1，破坏严格输出对称。位置限±4096、轨迹指令限±1429、总指令限±3216及积分限±(1429<<16)均未饱和。失败来自负数算术右移向负无穷取整，未触及溢出。

冻结 guidance_pid_h_run_pos 的原准备C和自动生成 Csyntax/Execution 不作修改。CompCert 3.17 x86-64 Linux standard ABI、小端、binary32 nearest-ties-to-even、-fstruct-passing。参数是隐藏返回指针、flight整数和gh指针。ObservedX用精确Mint32读取观察返回type=2（STAB_SP_LTP）、format=0、活动union的x、全局cmd与积分，不解释padding或非活动union字节；frame用逐字节Mem.loadbytes比较。NormalCall是原始star Csem.step到Returnstate。有效缓存和禁用force支路避开未解析的stateCalcPositionNed_i/stateCalcSpeedNed_i/atan2f；绑定保持原状。

当前 [001报告](../attempts/001/report.md) 与 [状态](status.json)。C准备、CBMC和align复用原模型，本轮不重新运行，历史成本不重计。本结果是实现性质反例；是否违反飞控设计需求需另有需求依据，不能据此称为已确认航空安全缺陷。
