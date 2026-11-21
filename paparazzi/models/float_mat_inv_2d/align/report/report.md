# 模型与映射结果

自动 Csyntax/Cexec 模型生成并通过独立新鲜源审计。入口 float_mat_inv_2d，命名空间 FivePprzFloatMatInv2d。保留全部参数和 Mem.mem，未按验证前条件裁剪执行域。

实际 fabs 绑定问题发现2项（两个模型），均通过明确且真实的标准内建绑定解决；未解决的生成问题0项。2d 保留单精度 EF_builtin __builtin_fabsf，其 CompCert 语义为 Float32.abs；3d 自动导出 Oabsfloat 双精度绝对值。原始 2d 的 double 1e-4、3d 的 float EPS、求值次序与返回码均保留。原始 libm 实现差异、源抽取及前端仍为明确可信边界。

190 条实际 CBMC 属性全部映射为独立待证/待反驳命题。模型、包装、参数化义务类型检查不是程序证明；安全、全后继终止性、调用摘要及真实 trace 回放交由 Rocq。当前实际运行请求由 manifest.request.path/SHA 绑定（不同于 prepare 的用户目标请求），两者均保留。
