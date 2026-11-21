# PID_df 准备

固定 Paparazzi 提交 abfee3dd56eeab12c528635504a429db3daf409a 的 PID_df 结构和 update_pid_df 原始函数体，仅删除 static inline 入口声明限定符。无外部调用和额外头文件依赖。CompCert 目标 x86-64 Linux、little-endian binary32，模型保留所有机器浮点输入。初始内存约定不声称执行 init_pid_df Csem。

[实测成本与原始审计](costs.json)。token 依据实际 session 事件，不以脚本文字数估算；计量缺项保持 null 并给出原因。
