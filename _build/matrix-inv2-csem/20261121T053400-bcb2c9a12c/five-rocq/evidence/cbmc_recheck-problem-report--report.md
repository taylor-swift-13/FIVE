全部 190 个实际 CBMC ID 独立重验。

实际 ledger 全部保留：144 个源码地址/解引用 guard、36 个真实 memcpy guard/前条件、8 个成功断言均有独立 Rocq 证明；2 个实际失败断言以原反例重放反驳。每个 ID 在 `Spec.P001`–`P190` 与 `Proof.property_001`–`property_190` 一一绑定，顺序见 goal-index.json。memcpy 采用实际 16B `extcall_memcpy_sem` / `Mem.storebytes`，证明 uint32 Mint32 读取恰为原 binary32 bits；对象间内部 guard 映射到块分离，不假设不相关 C 指针间次序。

两个原 trace 的 arbitrary 输入相同：`fea1e6c9 3f947db7 00eb142c 6fe26b14`；真实输出 `80000000 00000000 00000000 00000000`，返回 0。guarded.value 位于同一个 24B 结构块 offset 4，初始全 +0，guard words 位于 0/20。基准、小尺度、大尺度输出初始均为 `41880000 00000000 00000000 41880000`。ExactReplay 已构造一个初始化共同内存并按原顺序证明全部 4 次原 Csem 调用存在；每次 Post 保留实际写入/字节 frame。identity 返回 0；2^-8 I 返回 1 并保持原字节；2^100 I 返回 0、det=+Inf、对角输出 +0，残差分量 -1。

`main.assertion.9` 的正比例状态不变为假；`main.assertion.10` 的成功必有小残差为假。二者是反驳，不是数值正确性。反例为目标源调用与 byte-copy 观察的已证明组合；harness 自身没有另行导出成单体 Csem AST。

请求目标：全部 `FiveInv2Recheck.Proof.property_001`–`property_190 : FiveInv2Recheck.Spec.P001`–`P190`。

当前作者源码证明已编译；最终独立收据待根调度安装并验证。
