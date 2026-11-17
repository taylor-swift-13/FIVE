# 位置平移不变性问题

唯一模型入口是原始 guidance_pid_h_run_pos。两次执行使用同一 Source/Execution 模块、两个内存值及真实隐藏返回指针 ABI。

Spec.v 量化所有 InputPair 和两种 in_flight，同时平移参考位置与真实 NEDi 缓存位置，并要求32位有符号加法及误差相减可表示。前提没有计算误差相等或已经返回。目标同时要求正常返回存在，以及全部允许正常执行对的已初始化 cmd_earth、积分器、返回标签与有效 LTP 字段位相同。frame 是单独目标；输入非空性和实际非零执行非空性分开。

Rocq 证明域是缓存有效、runtime thrust approximation=false、gains 0..100、speed/accel 原始整数 ±10000、初始积分 ±100000000、全局 binary32 heading 在[-3,3]。允许独立 caller GH 或 gh=&guidance_h；return buffer 不与全局对象重叠。完整模型仍保留所有原始参数/内存和未进入的运行时分支。

六项主目标均已由第002次尝试证明，并通过精确目标绑定、编译和独立内核检查：位置平移、原Csem全部可达状态无错误、所有后继终止、输入非空性、实际非零执行非空性，以及字节/权限框架。当前证据见 ../attempts/002/evidence/goal-validation.json。CBMC的124项重验另由模型 cbmc_recheck 第003次尝试完成精确目标绑定编译及独立内核检查，报告位于 ../../../models/guidance_pid_h_run_pos/rocq/cbmc_recheck/attempts/003/report.md。各结论保留上文声明的前条件与观察范围。
