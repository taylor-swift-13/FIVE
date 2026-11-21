# 原始 getter 协议的全部 CBMC 属性重验

问题在 [Spec.v](Spec.v)，当前解答与精确验收在 [attempt 001](../attempts/001/report.md)。保留全部真实属性 ID，276 项中 273 项证明成立，main.assertion.8/.9/.10 三项证明被实际反例推翻。另有 `ObserverPreparationGoal`，保证观察内存和实际复制过程可构造。

输入沿用冻结的原始 harness：N1=(0,0,0)、N2=(524288,0,0)、E=(1048576,0,0)，State 完整置零、速度过滤器 ANY，并立即复制 getter 指针指向的三个完整浮点位模式。不是通过限制生成模型删除其他输入或分支。

每项具名命题引用实际模型的符号化调用、控制流不变量或有源位置绑定的观察适配器：99 个 fallback 函数守卫以实际 Csem 不可达性重验；源指针与观察器字段分别验证非空、存活、权限、范围和整数地址条件；memcpy 守卫保留原短路求值条件；六个实际除法右式有 AST 身份和有限值证明。

观察器按 CompCert Ctypes 证明为 1360 字节，bits/before/after 偏移分别为 36/48/704。新观察对象在协议执行前分配；先复制调用前 State，再从修改后的真实内存调用 getter，再复制完整 12 字节返回位模式和调用后 State。最终两个字节数组的读取为 Vint，并按 CompCert 的 C 相等运算得到真。没有把 Undef 相等当作 C 比较，也没有假设调用后结果。

模型配置：CompCert 3.17 Csyntax/Csem/Cexec，x86-64/Linux，小端，binary32、最近偶数舍入。精确源码、模型、规约和工具绑定见当前 provenance.json 与 goal-validation.json。数学作者实际 GPT-6.1 Sol Ultra；断言按非阻塞观察重验，三个失败项各有真实 CBMC trace 绑定与模型执行关系见证。
