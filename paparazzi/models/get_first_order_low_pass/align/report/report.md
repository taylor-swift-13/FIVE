原 getter 的 CompCert3.17 原 Csyntax/Cexec 自动导出覆盖所有机器参数和内存，reachable external closure 为空。两次新鲜来源审计均通过。spec-map-final.json 冻结真实 direct-CBMC19项原ID、条件、路径及 canonical Spec SHA；所有 proof_status 保持 pending，实际证明只写入 rocq/spec-recheck.json。

导出阶段源语义问题发现0/解决0/未解决0。验收元数据改正：首次 CBMC argv 包装收据由新直接调用替代；初始 map 保留历史，完整声明绑定 map 单列。未改变模型或数值输入域。
