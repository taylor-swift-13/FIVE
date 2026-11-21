# stateGetSpeedEcef_f：传统CBMC结果

实际276个属性，失败ID为["main.assertion.8", "main.assertion.9", "main.assertion.10"]，其余为SUCCESS；无UNKNOWN。完整实际argv/输入hash/原JSON及反例trace由properties.json绑定。指针、bounds、除零、移位、整数/浮点溢出及NaN等所有实际发出的检查均保留；不能将求解结果当作Rocq公理。

实际driver调用两个原始setter及原始getter；每次设置ANY过滤并从真实filter读取sender。两组均证实setter接受、ECEF_i新值、NED_i历史保持、原返回指针、status及frame检查通过。三个失败分别为两组完整向量read-after-write与完整向量history independence。两个协议的全部3个float词在getter后立即memcpy，未保存待后续解引用的别名指针。__CPROVER_assert是独立非阻断属性观察，不声称某条native aborting assert路径会继续运行。

后续align逐项映射和Rocq独立重验尚待完成。本阶段三case共享费用按真实事件ID并集合并，逐case工具命令另列。
