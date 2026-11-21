真实调用存在与全部返回。

三个目标：任意合法输入都存在原 Csem 正常调用；任何正常返回具有相同精确状态码和 Post；任意 supplied float32 矩阵都可构造满足输入条件的实际内存。Post 明确给出源读取保持、输出可写、旧块合法性和 valid_access 保持、调用者 byte frame、成功时完整 16B 编码、拒绝时完整旧输出字节（包括 Undef）保持。状态码 0 成功、1 拒绝；成功输出按原运算树保留有符号零。

请求目标：`normal_call : Spec.NormalCall`；`all_returns : Spec.AllReturns`；`nonvacuity : Spec.Nonvacuity`，命名空间 `FiveInv2Functional.Proof`。

当前作者源码证明已编译；最终独立收据待根调度安装并验证。
