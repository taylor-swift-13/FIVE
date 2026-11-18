getter 的五个具名问题全部 proved，无 pending：NoError1、无条件 AllSuccessorsTerminate1、Functional2、完整执行对应8、真实 CBMC 重验19，共31个精确类型绑定。另有 reset→get 关系2个目标，总计33个新目标。所有正式证据来自 CLOSED passed Rocq run032054，含完整编译源码快照、物理输入SHA、Print Assumptions、每问题typed GoalBinding与独立内核检查。

模型不裁剪机器输入。安全/正常功能前条件仅为合法对齐不绕回指针与 last_out 可读 typed binary32；其余字段可以未知。所有后继终止性 forall args,m，和正常返回存在性分别陈述。Getter保持所有调用前有效块的字节观察。

全部19项原CBMC ID使用真实直接CBMC输入条件逐项独立重验，结果见 spec-recheck.json；原CBMC成功从未作为Rocq公理。生成期spec-map-final.json仍标pending，真实证明账本单列。

实际运行、失败/重试、共享消费和未知的未采样setup资源见 [costs](costs.json)。历史reset模型/证明/原费用只引用，不修改或重新署名。
