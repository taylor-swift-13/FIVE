# 地面历史积分独立性：五项目标全部证明

主结论对 **四个分别独立全称量化的符号旧积分字** `iax/iay/ibx/iby` 成立。两份真实 CompCert 内存均满足未修改的原 [InputGood](../../../pid_position_translation/problem/Spec.v)，其中旧积分仍按原域限制在 ±100000000。没有旧积分相等、为零或输出相同的前提。`0/1` 的选择 **仅用于旧积分不同的非空域存在性见证**；没有用具体输入代替主关系证明。

`in_flight=false` 是地面/非飞行标志。任意符合输入关系的两次原始 `guidance_pid_h_run_pos` 调用都存在正常返回；对所有实际正常返回对，`cmd_earth.x/y` 及有效返回 `type/format/LTP.x/LTP.y/heading` 位相同，两个新积分 x/y 均恰为 `Vint Int.zero`。返回块外全部一字节 `Mem.loadbytes` 观察相同，**已覆盖的积分区域也相同**；权限及 nextblock 相同。另已证明原始 Csem 所有可达状态无 source_error，及全后继关系的 Acc 终止性。五项目标见 [Spec.v](../../problem/Spec.v)、[Proof.v](Proof.v)；pending goals：无。

复用同一冻结原 C、Csyntax/Cexec 模型及旧证明；本次没有 C、CBMC、align 或模型生成。隐藏返回缓冲区 ABI 参数是 `[Vptr ret 0; Vint 0; Vptr gh 0]`。CompCert 3.17，x86-64 Linux little-endian，IEEE754 binary32、round-to-nearest-ties-to-even。数值界限、位置初始化及安全减法、缓存有效、近似推力分支关闭、全局只读字节和外部绑定均保持原域。返回 padding/非活动 union 字段不进入有效字段比较；整个返回块外的字节 frame 完整保留。结论止于原始 CompCert Csem，不另声称编译后的硬件二进制等价。

原 C SHA-256：`8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04`；当前规范 `20719fcb910554707395db6ba5be0cf98d2ddbe0438dac6359fff5eba7f7e22b`，证明 `25c6d3dcc8eb1ee586f82efd52eafeee61e8feba63254188de1bf25aa7bc6f79`。Source.v、Execution.v、manifest、外部语义源及完整实际依赖的 hash 见 [provenance.json](provenance.json)。实际调用模型 `gpt-6.1-sol`，用户请求与运行时观察的 reasoning effort 均为 `ultra`，明确覆盖共享契约的默认 medium；原始上下文回执见 [runtime-metadata.json](evidence/runtime-metadata.json)。一个纯推理见证助手同为 Sol Ultra，无工具执行；其真实 token 回执留在共享 _build，不复制到交付目录。

实际 Rocq 9.2 / OCaml 4.14.2。124 个源码构成聚焦依赖闭包，原依赖冷重建一次；新 Spec/Proof 在最终发布时再次实际编译。`Print Assumptions` 保留于真实日志。继承假设为 `ClassicalDedekindReals.sig_not_dec`、`sig_forall_dec`、dependent functional extensionality、classical `classic`，以及 CompCert 的 proof irrelevance、`Events.external_functions_sem`、`inline_assembly_sem`；未为本目标新增 Axiom/admit/Admitted。外部语义环境与旧模型一致，缓存/分支条件排除该输入域中的开放外部调用。

独立 `rocq check`：Proof 命令144通过（327.28秒）；[GoalBinding.v](GoalBinding.v) 将五个当前精确规范类型逐项绑定并实际编译，命令145输出假设；独立证书内核146通过（338.97秒）。[goal-validation.json](evidence/goal-validation.json)、[kernel-check.json](evidence/kernel-check.json)、[certificate-kernel-check.json](evidence/certificate-kernel-check.json) 绑定同一实际 proof run 的源码、原始快照及回执。交付 checker 的重放上限已调为900秒，原始成功回执保留实际360秒上限。编译缓存已删除。

重放：在 `/home/yangfp/five` 先 `source scripts/env.sh`，再 `python3 paparazzi/relations/pid_ground_integral_independence/attempts/001/check.py`。默认完整重建及双内核；发布复用只接受同一 proof run 中已成功编译、且被原 hash guard 冻结的依赖，新关系源码始终重新编译。当前严格类型/源码门禁采用未修改的 `example_proof_gate.validate_current`。

计量原始运行：`_build/pid-ground-integral-ultra/20261110T060916-2a7f0797fe/five-rocq`。阶段边界在实质证明分析之前建立；包含构造、修复、四次失败的 Proof 编译、最终成功及双内核，实际失败源码快照和日志保留于同一 _build。工具 CPU/RSS 为 GNU time 与10毫秒请求间隔的进程树采样；共享页可能重复、短峰可能漏采，不包括不可观察的模型服务端/桌面 agent 内存。启动前的技能/会话定位、外围编辑/通信包装器的 CPU/RSS 无独立观测，不以零或估计补充；整次请求的相应 token/墙钟由父调度实际回执覆盖。最终数字及助手事件去重口径见 [costs.json](costs.json)；报告/成本的归一化排版不改变已冻结证明输入。

已关闭证明阶段实测：墙钟 3769.042 秒，工具 CPU 1815.810 秒；工具进程树采样峰值 1496084480 bytes，单进程最大 RSS 1492320256 bytes。阶段+助手去重 token：{'input': 29066965, 'output': 58704, 'cached_input': 28937088, 'reasoning_output': 28058, 'total': 29125669}。原始成本审核：incomplete。

## 最终独立核对与完整请求成本

父调度已通过五项当前精确目标/源码绑定、旧模型与旧关系回执、四阶段交接hash及3544项旧文件冻结核验。新relation总共13个必要文件，重建缓存已清理；原C、模型与历史证明未改动。

内存主指标采用覆盖全部149条证明工具命令的GNU time最大单进程RSS：1492320256 bytes。命令010约43毫秒，真实树采样为0且无采样错误；GNU time另记录1916KiB。原成本审计对这条短命令的树采样提示保持原样，不声称默认审计通过。树采样最大值1496084480 bytes作为已观测量保留。

整次请求（含启动、证明、助手、修复及报告整理）的真实token按三个actor来源事件去重，共 58306443 tokens；请求到计量截止的直接墙钟 4807.387 秒。分项input/output/cache/reasoning及实际回执见costs.json的current_request。模型服务端与并发联合RSS未观测，保留null；工具CPU列实测小计并注明未观测启动部分，不估算补齐。
