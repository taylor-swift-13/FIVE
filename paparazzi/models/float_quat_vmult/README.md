# float_quat_vmult

已完成prepare→CBMC→align→Rocq。固定原Paparazzi函数；合法分离caller内存下所有可达状态安全，全部后继终止，8类全域执行对应通过。共享301-ID query为300proved+1refuted；旋转路径位相等已由原Csem实际反例反驳。

[原C](prepare/source/float_quat_vmult.c) · [原模型](align/model/Source.v) · [Rocq报告](rocq/report/report.md) · [全部301重验](rocq/spec-recheck.json) · [交接](rocq/handoff.json) · [共享关系](../../relations/quat_rotation_paths/problem/report.md)
