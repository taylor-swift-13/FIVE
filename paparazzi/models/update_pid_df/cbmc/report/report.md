# PID_df 实现层检查

81 个实际发出的属性全部 SUCCESS。对象和输入为任意 binary32 位模式，无数值 assume。入口无循环，memcpy 展开界 6 并检查展开断言。检查 8 个位观察断言和全部实际内存/数组属性；没有将浮点 NaN/溢出设为错误。

[实测成本与原始审计](costs.json)。token 依据实际 session 事件，不以脚本文字数估算；计量缺项保持 null 并给出原因。

严格调用证据重放：原 shell 包装命令及其输出完整保留为历史。新增直接记录 cbmc 可执行文件 argv 的运行 _build/pid-df-worker/20261121T022224-fc1b796b6e/five-cbmc，命令002-direct-actual-cbmc，版本6.11.0单独记录。新输出为普通 JSON；81个属性的 ID、状态、描述及 sourceLocation 与冻结 ledger 完全逐项一致，所有状态 SUCCESS。源码、harness、原属性/输出、handoff、模型、规范及证明均保持原哈希。见[重放比较证据](../../../../../_build/pid-df-worker/20261121T022224-fc1b796b6e/five-cbmc/evidence/property-comparison.json)及新增成本行。
