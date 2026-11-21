全部可达状态安全。

`Spec.NoError` 对每个满足 `Contract.Precondition` 的初态以及所有原 Csem 可达状态排除错误。前条件为分离的合法 16B 输出/输入区，4 字节对齐、不绕回、4 个初始化 binary32 输入、输出可写；输出初始字节可为 Undef。证明使用完整分支/表达式证书，覆盖全部运算数求值顺序，未用选定返回路径代替安全。

请求目标：`FiveInv2NoError.Proof.no_error_proved : FiveInv2NoError.Spec.NoError`

当前作者源码证明已编译；最终独立收据待根调度安装并验证。
