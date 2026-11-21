# 原低通滤波器任意n拍舍入误差

已证明对全部自然数n：

|real(ŷ_n)−yR_n| ≤ 2^-19(1−2^-n) ≤ 2^-19 ≈ 1.9073486328125×10^-6。

每拍输入为符号量且绝对值≤1；存储系数c为任意有限binary32，实数值在[1,2]；实际输出始终有限且绝对值≤2。证明没有固定n上限或枚举输入。

## 原程序与明确前条件

原更新运算树为 out=(value+last_in+(time_const−1.0f)*last_out)/(1.0f+time_const)，随后写last_in=value、last_out=out并返回out。本次保持原C、预处理输入、Source.v、Execution.v及模型机器输入域不变；条件只属于本问题的定理。

所有输入x_n、初始输出ŷ0和存储系数c均显式有限，排除B2R对NaN/Inf映射为0导致的空洞。要求1≤real(c)≤2，|real(x_n)|≤1，|real(ŷ0)|≤1，初始last_in=x_0。允许负数、零和subnormal，各拍输入可以任意独立改变。

内存条件使用原Initialized：合法、对齐、地址范围不回绕、12字节可写且三个float字段已初始化。没有把未来输出有限、局部误差界、未来trace合法或未来正常返回当作前条件。

参考递推使用同一存储binary32系数c的精确实数值：

yR_0=real(ŷ0)；
yR_(n+1)=[real(x_(n+1))+real(x_n)+(real(c)−1)yR_n]/[1+real(c)]。

初始误差因此为0。该界覆盖更新操作的舍入误差；初始化时tau/sample_time到c的系数合成、传感器量化、连续系统离散化误差均不是这一参考的组成部分。

## 从Flocq单步到任意n

1. FloatBounds.v证明binary32 RNE的通用误差 |RN(z)−z|≤2^-24|z|+2^-150，包含下溢/subnormal。它证明RN单调性、精确端点2和8，并把本证明范围内的Float32 add/sub/mul/div连接到RN，建立有限性。
2. Numerical.v严格沿原运算树合成。若c∈[1,2]、|x|,|last_in|≤1、|last_out|≤2且这些数有限，则实际结果有限、幅度≤2，并且相对同一旧状态的一次实数更新的误差≤2^-20。分母非零和各中间操作安全均在证明内建立；保守舍入分析最后得到15u≤16u=2^-20，u=2^-24。
3. Proof.numeric_invariant用自然数归纳，将初态幅度≤1推进为所有实际输出有限、幅度≤2。Proof.local_roundoff实例化上述已证明的单步结论，δ没有成为用户前条件。
4. 实数参考对旧输出的系数α=(real(c)−1)/(1+real(c))位于[0,1/3]，从而≤1/2。Recurrence.v由三角不等式证明e_(n+1)≤δ+e_n/2、e_0=0蕴含e_n≤2δ(1−2^-n)。Proof.arbitrary_horizon将δ=2^-20和实际单步定理代入，关闭全部前提。

这里的乘方和归纳覆盖任意自然数；没有用有限展开代替无限时域结论。

## 原Csem、实际返回和字节frame

actual调用既有Contract.output；original_step证明它与数值模块的原运算树定义相等。Call直接使用原生成Execution.entry、原Csem.step的star关系和原Returnstate。Calls连接n次这样的实际调用。

Cycles.repeated_exists证明对任意n均存在正常完成的实际调用链。Cycles.calls_observed量化所有原Csem正常返回链，证明返回值列表恰好等于逐拍binary32输出，最终last_in=x_n、last_out=ŷ_n、系数仍为c。最终数值界通过Initialized的Mem.load Mfloat32精确值等式连接到真实字段。返回值的CompCert val/float相等也保证to_bits相等。

系数的4个Mem.loadbytes字节和初态相等。n>0时last_in、last_out的4字节分别等于encode_val Mfloat32(Vsingle对应值)。U.Frame保留所有初态合法块中与写区[offset+4,offset+12)不相交范围的Mem.loadbytes结果；原先未知字节/None保持未知，没有被任意具体化。

CallMemory在原完整单调用证明上增加“旧块仍合法”的引理，使上述frame可跨n传递。原程序、AST和执行语义没有改动。正常返回存在性没有替代安全或所有后继终止；原模型已有的无错误、所有后继终止、执行对应及全部原CBMC属性重验继续使用其当前有效证据，根调度已核对全部source/spec/snapshot/kernel绑定。旧作者配置和旧成本保持原样。

## 非空域与非零舍入实例

Proof.nonvacuity给出数值域的实际见证，并对任意admissible c/x/ŷ0通过原Witness.initialized_inhabited构造合法实际内存。主定理的c没有固定为1，输入序列也没有固定。

例如c=2、last_in=last_out=0、value=1时，参考首拍为1/3，实际结果0x3eaaaaab=0.3333333432674408，误差1/(3·2^25)≈9.9341×10^-9。Proof.nonzero_roundoff_example_bits以实际Float32运算vm_compute核对了位模式。该例只解释舍入现象，任意n证明来自符号归纳。

## 独立验收与可信边界

六个目标在problem/status.json逐项登记。GoalBinding将每个目标绑定到完全限定定理和精确规范类型，实际编译并独立rocq check。当前证据在evidence/goal-validation.json、kernel-evidence.json及certificate-kernel-evidence.json。check.py从当前源码创建统一新快照，不信任旧.vo。

可复跑：在/home/yangfp/five执行source scripts/env.sh，再运行python3 paparazzi/relations/lowpass_roundoff_bound/attempts/001/check.py。

目标为CompCert3.17、x86-64 Linux、standard ABI、little endian、IEEE754 binary32、round-to-nearest ties-to-even。NaN策略由既有Floats/Archi语义哈希固定；本数值域显式有限。工具和精确依赖见模型manifest及新检查日志。

没有新增Axiom、Admitted或admit。数值定理继承标准实数、经典逻辑及函数外延性；执行层还继承CompCert external_functions_sem/inline_assembly_sem签名参数，而本函数无外部调用。完整Print Assumptions实际输出保留在新检查日志中。结论止于固定CompCert Csem和前端来源链，不包含另一个编译器或硬件二进制等价性。

本次三个实际证明作者均为gpt-6.1-sol、用户指定Ultra；自己的turn_context字段回执见evidence/runtime-config.json，两个helper的真实回执在各自运行中。复用的历史证明保持原配置。

## 当前来源哈希

| 文件 | SHA-256 |
|---|---|
| paparazzi/models/update_first_order_low_pass/prepare/source/update_first_order_low_pass.c | 19ab80bc756f2e4e73fe959b87e5fea29de39c184cf9349919bcdec1652ef010 |
| paparazzi/models/update_first_order_low_pass/align/model/Source.v | 8f35f13c38d61ad1d1fe8a4db2e6d3d3861e881315e0a0f029c39fcdb52b5c6e |
| paparazzi/models/update_first_order_low_pass/align/model/Execution.v | 1e107a7c0d4f34075a2303d305ecc8c35f1cf533d9cf9b53714610e7e0dd44b9 |
| paparazzi/models/update_first_order_low_pass/align/model/compcert-manifest.json | 5af22acc46ed323d3010e3ace064460510019466b5eec16388b04863c3d06d56 |
| paparazzi/relations/lowpass_roundoff_bound/problem/Spec.v | 02e202522fc925221e2a81bd520260c50d82c81e80a7485b02b40e1b4b950c81 |
| paparazzi/relations/lowpass_roundoff_bound/attempts/001/Proof.v | fe55b3cf5558ffdd284e99fa8c5450906e68d95f818952c94afa4c461967c8f1 |
| paparazzi/relations/lowpass_roundoff_bound/support/FloatBounds.v | 3cacb8f52061262d0834ebc5c36657bd2d5f0ee22b37a0ce0e7e3e5b8123149a |
| paparazzi/relations/lowpass_roundoff_bound/support/Numerical.v | dfbcb32ace0ab87339a685c3615d1dd8dadc67a306aa098a0197b29deed3c075 |

全部传递.v、原C、manifest、preprocessed、bindings及checker的哈希见provenance.json，精确编译快照和kernel绑定见goal-validation.json。

## 完整成本口径与缺测

COSTS_TABLE

全部构造、修复、失败和成功检查保留在实际运行中。author/check两个记录使用同一作者session，token须按event_id并集计算，不能直接相加。cache和reasoning是input/output子集。并发墙钟直接测量，不相加各作者时间；并行工具联合峰值没有观察时保留null。

本作者部分只读检查/文件写入未包资源计量；FloatBounds作者披露一次未包GNUtime/RSS的调试编译；Numerical作者两个过快的只读命令没有RSS样本，一次中断检查的命令资源记录缺失。故完整工具CPU和峰值内存为null并注明原因；可核对的编译/内核CPU和RSS子集保留在costs.json及原metrics中，不伪装成全量。模型服务端、桌面app内存不在工具RSS内。10ms工具进程树RSS采样可能漏掉短峰并重复共享页。
