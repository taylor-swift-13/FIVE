# stateSetSpeedNed_i：自动模型生成及映射

由原prepared C经CompCert clightgen -csyntax自动生成Source.v、原Cexec包装与待证安全/终止接口，已重新预处理/导出审计。没有手译/手改AST。原始机器参数、任意Mem及全部原分支保留，输入域没有按协议前条件裁剪。

实际32个CBMC ID逐项映射并保持原Scope/真实FAILURE trace；此处只生成待证问题，安全、Acc终止、八类完整执行对应、每个CBMC独立重验及跨模型协议关系均待Rocq。getter保持全部原fallback及double中间算术callee。
