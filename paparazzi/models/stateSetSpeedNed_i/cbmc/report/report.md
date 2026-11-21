# stateSetSpeedNed_i：传统CBMC结果

实际32个属性，失败ID为[]，其余为SUCCESS；无UNKNOWN。完整实际argv/输入hash/原JSON及反例trace由properties.json绑定。指针、bounds、除零、移位、整数/浮点溢出及NaN等所有实际发出的检查均保留；不能将求解结果当作Rocq公理。

验证实际setter接受复制三词、精确status与全部State字节frame。

后续align逐项映射和Rocq独立重验尚待完成。本阶段三case共享费用按真实事件ID并集合并，逐case工具命令另列。
