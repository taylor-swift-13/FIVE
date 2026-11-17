# Paparazzi 横向位置 PID

`guidance_pid_h_run_pos` 根据无人机的参考位置、实际位置和速度，计算本周期的横向姿态指令，并更新下一周期使用的积分器。比例项来自位置误差，微分项来自速度误差，飞行分支把比例与微分算出的量用于更新积分，另有速度和加速度前馈。

| 输入 | 输出及写入 |
| --- | --- |
| `gh` 中的参考位置、速度和加速度 | `cmd_earth.x/y`，以及返回设定值的有效 LTP 指令和航向字段 |
| 状态缓存中的实测水平位置、速度 | 限幅后的位置误差和速度误差 |
| PID 增益、旧积分、航向、`in_flight` 标志 | 新积分器，供下一周期读取 |

原始入口和被调用函数见 [C 源码](prepare/source/guidance_pid_h_run_pos.c#L906)。Rocq 观察原 CompCert 内存中的输出字段和字节。横向输出是软件指令，实际飞行轨迹由飞行器动力学决定。

## 已证明的两条关系

| 两次调用如何构造 | 已证明的结论 | 规约与证明报告 |
| --- | --- | --- |
| 目标位置与实测位置一起平移相同距离，保持其余输入条件相同 | 位置误差关系保持，控制输出、新积分和有效返回字段逐位相同，并满足规定的内存对应 | [规约](../../relations/pid_position_translation/problem/Spec.v) · [证明与成本](../../relations/pid_position_translation/attempts/002/report.md) |
| 两份旧积分独立取值，其余输入符合对应条件，且两次都令 `in_flight=false` | 两边的积分都清零，控制输出和有效返回字段逐位相同，返回区域外的字节及权限对应一致 | [规约](../../relations/pid_ground_integral_independence/problem/Spec.v) · [证明与成本](../../relations/pid_ground_integral_independence/attempts/001/report.md) |

两条主定理都量化符号输入。举例来说，目标位置和实测位置从 `(2 m, 0 m)` 一起变为 `(102 m, 100 m)`，位置误差仍是 2 m。这只是位置平移规约的一个实例。针对每周期实测位置扰动的指令差异上界属于拟议的后续性质。

## 四阶段产物

| 阶段 | 主要产物 | 报告与成本 |
| --- | --- | --- |
| `prepare` | [入口源码](prepare/source/guidance_pid_h_run_pos.c)、[绑定配置](prepare/source/bindings.json)、[交接](prepare/handoff.json) | [报告](prepare/report/report.md) · [成本](prepare/report/costs.json) |
| `cbmc` | [传统有界检查 harness](cbmc/harness.c)、[124 项属性](cbmc/properties.json)、[交接](cbmc/handoff.json) | [报告](cbmc/report/report.md) · [成本](cbmc/report/costs.json) |
| `align` | [CompCert Source.v](align/model/Source.v)、[Execution.v](align/model/Execution.v)、[生成配置](align/model/compcert-manifest.json)、[交接](align/handoff.json) | [报告](align/report/report.md) · [成本](align/report/costs.json) |
| `rocq` | [无错误](rocq/no_error/attempts/002/report.md)、[终止性](rocq/termination/attempts/002/report.md)、[124 项精确绑定与重验](rocq/cbmc_recheck/attempts/003/report.md)、[交接](rocq/handoff.json) | [报告](rocq/report/report.md) · [成本](rocq/report/costs.json) |

`problem/Spec.v` 放待证命题，`attempts/<编号>/Proof.v` 放证明，`report.md` 说明结果与范围，`costs.json` 记录时间、token 和工具内存。早期报告保留各阶段当时的状态。当前状态以本页链接的活跃证明尝试为准。

证明使用 CompCert 3.17、Rocq 9.2、x86-64 Linux 小端配置及 binary32 最近偶数舍入。规约明确限制位置和数值范围、内存权限及缓存条件，并约束推力近似标志。原模型保留所有运行分支。当前证明通过这些前条件排除未实现的外部调用。历史验收回执记录生成它们时的工作区位置和工具链路径。重放使用下列检查器，在仓库根目录执行，所需工具链见[项目 README](../../../README.md)。

```sh
source scripts/env.sh
python3 paparazzi/relations/pid_position_translation/attempts/002/check.py
python3 paparazzi/relations/pid_ground_integral_independence/attempts/001/check.py
python3 paparazzi/models/guidance_pid_h_run_pos/rocq/cbmc_recheck/attempts/003/check.py
```
