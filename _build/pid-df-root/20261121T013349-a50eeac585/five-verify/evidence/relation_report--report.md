# PID_df 位置式参考与浮点偏差：尝试001

九个规范目标全部 proved：[规范](../../problem/Spec.v)、[证明](Proof.v)、[可重跑检查器](check.py)、[当前精确目标证书](evidence/goal-validation.json)。

冷构建在 _build/pid-df-numeric/connected001 中逐个完整编译31个依赖源，保留独立快照。每个已请求命题均有完全限定的定理和精确 Rocq 类型，由实际编译的 GoalBinding.v 实例化；证书输出 Print Assumptions，并对 Proof/GoalBinding 执行独立 rocq check。[内核回执](evidence/kernel-evidence.json) 与 [完整来源](provenance.json) 绑定原始 C、AST、执行包装、规范、支持证明和检查器。

数学结论：初始误差历史与输出为零时，原增量系数 A=P+H+D、B=−P+H−2D、C=D 在精确实数中等于梯形积分/后向导数的位置式 PID。存储系数及样本有限且绝对值≤1时，对所有符号 n，实际输出有限，绝对值≤2²⁴且≤9n；与名义位置式输出的偏差≤2⁻²⁰n(n+1)+nΔ，Δ为三个原存储系数对名义系数的绝对偏差和。此项包含原 init 表达式的真实舍入与运算次序；并未重定义名义增益。

执行结论：调用原始 update_pid_df 的完整 Csem 链存在。任何正常返回链均给出同一实际结果序列；32字节 PID_df 对象中 u/e 五个字段按原源码移位，字节0..19为最后一次写入的 binary32 encode_val，系数20..31和写入范围外 caller-valid 内存由 frame 保持，旧有效块仍有效。单调用无错误/所有后继终止和81个真实 CBMC 属性由模型目录的独立问题提供，未作为这里的公理。

来源固定 Paparazzi abfee3dd56eeab12c528635504a429db3daf409a 的 filters/pid.h。目标为 CompCert3.17 Csem/Cexec、x86-64 Linux标准ABI、小端binary32最近偶数舍入，NaN策略由已绑定库定义。只删除 static inline 入口限定符；全机器模型未裁剪。数值定理条件不要求未来有限或误差结论。原 init 的 Csem 执行、整个固件链接和 GCC/硬件对应不属于本入口结论。

实际工具为 Rocq9.2/OCaml4.14.2。Print Assumptions 的继承边界包括标准库经典实数、经典逻辑/函数外延和 CompCert 库依赖；本地无 Admitted 或新增未证 Axiom。实际模型 GPT-6.1 Sol、Ultra，以[运行元数据](evidence/runtime-config.json)为证。

[成本](costs.json)保留完整 stage-session 用量、失败和超时。[开发历史](evidence/development-history.json)保留失败命令；一个被 Ctrl-C 终止的早期失败编译未产生 CPU/RSS 回执，见[计量缺项](evidence/measurement-gap.json)。后续成功冷构建不冒充该失败的资源测量。墙钟与模型用量仍包含该尝试；可观测工具子集的资源数字与未知完整总量分别标明。

准备阶段 verification-request.json 记录原始高层目标（有限时域误差）；align/request.json 是自动导出 manifest 实际绑定的全机器执行请求。两者均保持冻结；最终任意 n 定理强化原有限时域目标，没有追溯改写请求。
