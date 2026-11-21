# 准备结果

原始入口函数体逐字保留。标准 fabs 调用显式绑定至受支持的编译器内建：2d 单精度 __builtin_fabsf（CompCert BI_fabsf=Float32.abs），3d 双精度 __builtin_fabs（实际 Oabsfloat）。CBMC 和 CompCert 使用同一 C 文件。保持原始 double 1e-4、float FLT_EPSILON、运算顺序和返回码。不同 libm 实现的 NaN 行为及源抽取/前端属于明确可信边界。
