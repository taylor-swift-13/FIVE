候选1逐位等价：已反驳，全部所请求证明与实际301-ID重验均闭合。当前[问题](../../problem/Spec.v)与[证明](Proof.v)分离；[goal-validation](evidence/goal-validation.json)穷尽绑定6个精确目标类型，57个实际项目模块冷编译、Print Assumptions与独立rocq check通过。

单位输入 q=(1,0,0,0), v=(1,0,0)：原直接路径x位0x3f800000（1），原矩阵路径x位0x3f7ffffe（0.99999988079071044921875）；差2^-23。矩阵先将原double M_SQRT2*q分量存入float，再做float平方/减1；直接路径保留原float乘法后double0.5减法及末尾乘2。此有限精度路径差异在单位四元数上已出现，不是内存越界或崩溃反例。未声称一般输入的误差界。

原CBMC实际trace（未替换为单位例）：q=[bf37aaca,be3dbde6,a03504f3,10073b11]，v=[43004017,44800000,8e000000]；A=[41496084,41f167c0,c3882155]，B=[41496085,41f167c0,c3882155]。真实native独立重放和纯标量Rocq数值证明一致。

两个输入各有真正Genv.init_mem成功的非空初始状态、七个新caller块、初始化/权限/分离/有限域证明；排除force_fixture和after的fallback。三次原Csem NormalCall逐mem交接，输出全部12字节及所有原caller写区外frame成立。原两次memcpy extcall保留18项guard，复制后完整左关联3个uint32相等&&断言经Csem五步化为假，观察内存不再改动。模型始终为自动原Csyntax/Cexec，不按输入条件裁剪。

配置：请求及运行元数据均为gpt-6.1-sol、ultra；见[实际配置回执](../../../../report/quat_rotation_paths/runtime-configuration.json)及各support运行。目标CompCert3.17、x86-64 Linux standard ABI、小端、binary32最近偶数舍入和manifest固定NaN策略，原0.5和M_SQRT2的double类型保留。源版本abfee3dd56eeab12c528635504a429db3daf409a；各C/AST/Execution/manifest hash见[源身份表](../../evidence/source-identities.json)，Spec/Proof/所有依赖hash由provenance.json和goal-validation绑定。

继承假设按实际Print Assumptions保留CompCert/Flocq的Classical/FunctionalExtensionality及Events外部语义声明；没有新增Axiom、Admitted或admit。前端导出与内核/library为可信边界；没有证明GCC机器码或整个航空应用与该语义等价。原始来源、失败的完整mem计算、合取脚本修复、OS/会话中断和重试均留在_build/quat-rotation-ultra，历史运行不改签。[costs.json](costs.json)列实际最终阶段，额外[共享阶段成本](../../../../report/quat_rotation_paths/rocq-costs.json)及[去重总量](../../evidence/workflow-costs.json)分别记录；未知null不是0，并发联合峰值未观测。
