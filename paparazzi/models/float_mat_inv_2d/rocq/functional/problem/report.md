# float_mat_inv_2d / functional

对满足类型和内存前条件的任意 binary32 矩阵，证明存在正常原始 Csem 调用，并证明每一个正常返回都具有规定状态和精确内存后置条件。输出按 Mem.loadbytes/memval 观察；成功时对应逐项浮点运算的编码，拒绝时保留全部原输出字节，未知初始 memval 不被改写为零。frame 同时覆盖输入区、输出区外的旧块和旧权限。 2D 保留原 double 1e-4 阈值比较；3D 保留 double fabs 与 float EPS 的原表达式和运算次序。

规范为 [Spec.v](Spec.v)，当前状态与全部请求目标见 [status.json](status.json)。当前接受尝试为 [001](../attempts/001/report.md)，没有该问题尚未证明的请求目标。

- `NormalCall`: `FiveInv2Functional.Spec.NormalCall` → `FiveInv2Functional.Proof.normal_call`
- `AllReturns`: `FiveInv2Functional.Spec.AllReturns` → `FiveInv2Functional.Proof.all_returns`
- `Nonvacuity`: `FiveInv2Functional.Spec.Nonvacuity` → `FiveInv2Functional.Proof.nonvacuity`

执行范围是冻结准备代码与声明的标准内建绑定；不宣称任意原 libm、其他编译器二进制或硬件实现已建立对应。
