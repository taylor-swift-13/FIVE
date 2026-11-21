# Attempt 001 — main proof pending

实际作者 gpt-6.1-sol，medium，见 evidence/runtime-config.json。CompCert 3.17，原 Csyntax/Csem/Cexec，x86-64 Linux standard ABI，小端；binary32 RNE 与 NaN policy 由 align manifest 绑定。原外调 stateCalcPositionNed_i/stateCalcSpeedNed_i/atan2f 未替换，完整环境覆盖待证。

已独立 kernel 检查：四个共同平移算术引理、QuietWalk 的真正 Cexec 步到原 Csem 路径桥、GetterSemantics 中两份原 Source getter 符号正常返回定理。getter 前提包括 state symbol/composite lookup、字段 offset、实际可读缓存字、缓存 bit1；speed 保留 Mem.loadv 的 pointer-wrap guard。结论是返回原 state 字段指针且内存完全相同。GetterBinding.v 用完整预期类型绑定它们；没有假设外部回调完成性。

主入口的正常返回存在、全部正常对关系、全可达无错误、全后继 Acc 终止、输入/实际执行非空性、frame、精确控制过渡、124项独立 Rocq 属性重验以及完整环境对应均 pending。类型检查不是证明；条件 quiet-walk 路径不是实际正常返回。

失败全部保留：Genv.init_mem/调用对象初始化的 vm_compute 与 lazy；备用 raw Mem.alloc/store 初始化；均在函数执行前达到显式 3,000,000 KiB 虚拟内存上限。它们是本次方法/资源瓶颈，不是不可执行定理或程序反例。字段路径 guard 检查、导入/类型、getter 初版和所有 CBMC 求解失败日志也保留。

四个算术引理 Closed under global context。实际 Csem 桥/getter 继承 CompCert/库的 classical、functional extensionality 和外部语义接口等假设；准确清单见原始 assumptions 输出。没有新增目标公理或 admitted proof。

各子问题没有独立模型用量边界，费用共享同一真实 five-rocq session，不能事后分摊。check.py --auxiliary 仅验收已建立事实；默认报告主目标 pending。
