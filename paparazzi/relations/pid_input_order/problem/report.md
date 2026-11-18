# PID 输入顺序关系

结论：候选顺序无关性已被原始 CompCert Csem 实际反例反驳。两个请求目标均已证明；无请求目标待完成。

[Spec.v](Spec.v) 中 OrderInvarianceGoal 量化同一初始内存 m、相同 gh/ret、两个非空输入序列、相同输入多重集（Permutation）和相同末拍输入。每个 OrderRun 步骤包含真实 Mem.store Mint32 gh 44、原输入条件和原始 NormalCall ... true。观察为返回对象 type/format/x、全局 cmd_earth.x 与积分状态 x 的五个精确 Mint32 load。

OrderInitial 固定 kp=ki=1、kd=kv=ka=0、所有测量/速度/加速度/y/heading 为零，暖 NED 缓存、approx_force_by_thrust=false、in_flight=true；初始积分码 L=1429*65536=93650944，属于原 InputGood 允许的状态。证明实际构造此内存，未假设任何返回值。未声称该积分状态可由零初始化运行到达。

实际序列 [64;-64;0] 与 [-64;64;0] 只改变参考位置 x，码 ±64 对应 ±0.25 m；末拍均为零。终态积分码分别为 L−1 与 L，返回及全局命令码分别为 1428 与 1429。积分码单位是 2^-28 rad；命令码单位是 2^-12 rad，转码使用右移16位。

当前证明与实际成本见 [attempt 001](../attempts/001/report.md)。本任务只运行 five-rocq，未新增 prepare/CBMC/align、安全或终止目标。
