原始全域全后继终止。

`Spec.AllSuccessorsTerminate` 对任意原始 args/mem 证明 `Acc(successor Execution.ge)`。非法调用可能结束于原始错误状态；正常返回由功能问题的合法前条件单独保证。带函数调用预算的语句/表达式度量严格下降，未以有界展开或存在返回代替全部后继终止。

请求目标：`FiveInv2Termination.Proof.all_successors_terminate : FiveInv2Termination.Spec.AllSuccessorsTerminate`

当前作者源码证明已编译；最终独立收据待根调度安装并验证。
