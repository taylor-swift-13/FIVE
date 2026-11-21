# 六项数值关系证明结果

已完成六项目标的完整独立冷检查：53 个实际依赖模块、六个精确 GoalBinding 类型证书和独立 Rocq 内核检查均通过。内核运行先关闭为 passed，再执行 validate_current；当前来源、原文件与实际编译快照全部匹配。没有在最终冷检查期间或之后编辑证明/模型/准备 C 源。

| 目标 | 2d | 3d |
| --- | --- | --- |
| 符号族 A=2^k I，-20≤k≤20 | 成功 iff k≥-6 | 成功 iff k≥-7 |
| 成功分支逆矩阵 | 精确 2^-k I，保留原始负零 | 精确 2^-k I，保留原始正/负零分布 |
| 正比例缩放状态不变 | I 成功、(1/256)I 拒绝，已反驳 | 同左，已反驳 |
| 成功保证小残差 | 2^100 I 返回成功但实数∞残差1，已反驳 | 2^50 I 返回成功但实数∞残差1，已反驳 |

全部上述输入均有限且非奇异，理想逆矩阵经双向矩阵乘法证明，∞条件数严格等于1。安全符号族的成功计算候选与理想逆相同，实数∞残差为0。该符号证明使用通用 Flocq 精确 dyadic 乘/除/扩展及指数单调性；仅枚举固定矩阵坐标，未枚举41条程序路径。

规范中的 Computed2/3 是源码赋值表达式候选的实数解释；只有成功分支将其写出。实际 Csem 调用的 Post 逐字节绑定该候选。拒绝分支保留全部原输出 memval，包括未知字节，不把候选逆矩阵当作拒绝调用的实际输出。所有合法分离输入的正常调用存在性及所有正常返回观察也由原始 Csem 功能定理传入此关系。执行模型保留非法内存、别名与所有机器输入；本数值定理的内存和数值条件不裁剪模型。

2d 原始 double 1e-4、3d double fabs/float EPS、所有运算次序及返回0成功/1失败均固定。fabsf/fabs 显式绑定至真正识别的标准编译器内建；原始 libm 一般实现对应及源抽取/前端仍是明确可信边界。根代理的原始原生 libm 六见证检查支持固定有限见证，不是 Rocq 公理，也不构成一般库等价证明。

证据：[规范](../../problem/Spec.v)、[证明](Proof.v)、[当前精确目标验收](evidence/goal-validation.json)、[内核回执](evidence/kernel-evidence.json)、[原输入及实际编译快照来源](provenance.json)、[实际模型/Ultra回执](evidence/runtime-config.json)。

继承假设（原样 Print Assumptions 详见 ../../../../../_build/matrix-inverse-numeric-kernel/20261121T062553-a722480cf7/five-rocq/logs/054-FiveMatrixInverseScale-goal-certificate.stdout.log）：ClassicalDedekindReals.sig_forall_dec, ClassicalDedekindReals.sig_not_dec, Classical_Prop.classic, Events.external_functions_sem, Events.inline_assembly_sem, FunctionalExtensionality.functional_extensionality_dep。Events 两项是 CompCert 语义接口参数；所选闭包实际可达的 fabsf 是识别内建，未新增未证明公理或把未知回调当作无错误。

实际模型 gpt-6.1-sol；请求和运行时观测推理强度均为 ultra。以下为独立实测阶段，不按目标或两个矩阵虚构分摊；缓存/推理 token 已包含在输入/输出子集中，工具 RSS 不含模型服务器或桌面内存。

| 实测阶段 | 墙钟秒 | 工具CPU秒 | token总数 | 工具树采样峰值bytes |
| --- | ---: | ---: | ---: | ---: |
| matrix-inverse-numerics | 2514.854059 | 56.38000000000001 | 21648113 | 587980800 |
| matrix-inverse-numeric-kernel | 253.716711 | 162.59 | 1626533 | 1043357696 |
| matrix-inverse-numeric-validation | 54.381732 | 0.3700000000000001 | 556932 | 23474176 |

三份数值阶段成本审计均通过；[逐阶段成本](costs.json)保留 input/output/cache/reasoning、墙钟、CPU、RSS及原回执。交付元数据整理独立计入 _build/matrix-inverse-delivery/20261121T063101-73fb925f32/five-verify。模型 prepare/CBMC/align 的共享历史费用见各模型 stage 报告，不能再次按两个模型相加。历史 align exporter 为工具回放，其独立模型 token 未观测字段为 null；原始 align 成本审计的不完整/并行探测重叠警示均保留，未改签为完整。数值证明与当前目标验收已通过，历史计量不足不冒充已测量。

根代理仍负责参与模型最终五项规范/190与208条真实 CBMC 属性/失败 trace 的独立最终收据和 CompCert gate；本尝试不把这些跨阶段验收偷换成自己的六个数值目标。
