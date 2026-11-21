已完成普通正弦查表实现与 `COMPR_LOW`／LOW12 闪存压缩实现的源程序等价验证：对所有归一化 Q12 角度编码 `a∈[-12867,12867]`，真实初始化后的两个原始 C 实现都安全、终止，并返回逐位相同的 int32／Q14 结果。LOW12 保存低12位并按阈值重建高2位，保留原表的输出精度。

[七项规范](Spec.v)与[证明](../attempts/001/Proof.v)包括真实初始内存的存在、原始 `pprz_trig_int_init` 的安全与终止、实际返回0并生成精确9651字节缓冲区、两种正弦入口的安全与终止、结果字相等，以及各自的内存保持性质。初始化从原始1690字节压缩常量出发构造缓冲区；普通表的6434个原始 int16 常量是参照数据。初始化保留缓冲区之外的原有内存块，正弦调用保留各自全部原有内存块。两个模型可以使用不同的全局内存布局。

完整流程已通过：三次传统 CBMC 检查分别成功13、51、37项；全部101个带案例限定的原始属性ID都保留，并在Rocq中证明了相应源操作守卫、数组来源与边界、算术／移位条件、调用方断言和实际产生的展开守卫。每个模型的8项执行对应义务也已证明，执行模型保留完整机器参数和内存域；上述功能性质使用明确的归一化角度前提。

最终独立内核检查覆盖176个本地Rocq模块（含13个证明模块），另有13个精确目标绑定证书，实际命令退出0，耗时1451.270秒。[目标绑定](../attempts/001/evidence/goal-binding/GoalBinding.v)、[当前输入与目标回执](../attempts/001/evidence/goal-validation.json)、[内核回执](../attempts/001/evidence/kernel-check.json)、[内核汇总](../evidence/final-kernel-summary.json)和[最终制品校验](../evidence/artifact-validation.json)保留可核查证据。

| 原始入口案例 | 实际CBMC属性数 | 完整阶段证据 |
| --- | ---: | --- |
| 普通表正弦 | 13 | [Rocq阶段](../../../models/trig_plain/pprz_itrig_sin/rocq/report/report.md) |
| 真实初始化后的LOW12正弦 | 51 | [Rocq阶段](../../../models/trig_compressed_12/pprz_itrig_sin/rocq/report/report.md) |
| LOW12初始化器及所选解码查询 | 37 | [Rocq阶段](../../../models/trig_compressed_12/pprz_trig_int_init/rocq/report/report.md) |

配置固定为LOW12、默认展开阈值逻辑、`PPRZ_TRIG_CONST=const`且未启用测试宏；目标是CompCert3.17／x86-64 Linux／小端。证明作者实际使用Sol6.1 Ultra。[实际成本](../evidence/rocq-shared-costs.json)逐次保留真实作者阶段，包含失败、超时和未采用的符号化证书探索；无法完整测得的CPU／RSS保持未知，已测子集有明确标注。继承的CompCert语义参数、经典逻辑等假设和Print Assumptions输出见[证明报告](../attempts/001/report.md)。

本定理建立固定点程序的表示等价。解析实数sin的误差、余弦、其他压缩配置以及归一化范围外的功能定理仍需另行证明。
