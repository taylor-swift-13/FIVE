# 位置平移不变性：本轮尝试

**在明确限制的输入范围内，原函数的 CBMC 124/124 项检查通过。完整 Rocq 主关系、无错误和终止性证明尚未完成。** 本轮只验证 `guidance_pid_h_run_pos`，没有增加第二个 PID 入口模型。

## 具体例子

参考位置从10米平移到110米，测量位置从8米平移到108米，即二者共同增加100米。定点 Q8 原始位移为25600，位置误差始终为512，即2米。取 kp=100、ki=1，其余水平增益与速度/加速度为0，全局 heading=0，真实 NEDi 缓存有效、thrust approximation=false：

| 初始积分 | in_flight | 平移前后 cmd_earth.x | 平移前后最终积分 |
| --- | --- | --- | --- |
| 0 | false | 800 | 0 |
| 0 | true | 800 | 800 |
| 93650940 | false | 800 | 0 |
| 93650940 | true | 2229 | 93650944，达到积分上限 |

四个原函数 native 样例在 UBSan 下通过；CBMC 的符号范围也包含两种飞行状态和积分饱和区。这些样例不是 Rocq 的主入口正常返回证明。

## 已建立与待证明

| 内容 | 本轮结果 |
| --- | --- |
| 准备原始函数、完整原类型/宏及真实 callee 切片 | 已冻结，明确为开放外部接口模型 |
| 原 C 的传统 CBMC | **124/124 SUCCESS**；最终一次 Z3 位向量+formula slicing 命令检查全部属性 |
| CompCert 模型 | 3.17 原 Csyntax/Csem/Cexec；新鲜来源审计通过，全部参数/内存与运行时分支保留 |
| 四个共同平移算术引理 | 编译与独立内核通过；无新增假设 |
| 两个真实 cached getter 子定理 | 原 Source 函数 Csem.star 正常返回原 state 字段指针，内存不变；精确类型绑定及独立内核通过 |
| 通用 quiet Cexec→Csem 路径桥 | 已证；**不是实际主入口正常返回或终止性定理** |
| 主入口位置平移关系、正常返回存在、非零执行非空性、frame | **pending** |
| 原 Csem 全可达无错误、全后继 Acc 终止性、精确控制过渡 | **pending** |
| 124项独立 Rocq 属性重验、完整外部环境对应 | **pending** |

getter 子定理的局部前提包含 state 符号与 composite lookup、实际字段布局、可读的缓存字和 bit1 有效；speed 子定理保留真正 Mem.loadv 的 pointer-wrap guard。它们没有组合为主入口证明，也没有假设外部回调完成性。

## 检查范围与可信边界

CBMC 中原始参考/测量位置及位移为±1000000；speed/accel 原始整数±10000；gains 0..100；初始积分±100000000；binary32 全局 heading 在[-3,3]。Q19 速度±10000约为±0.0191m/s，Q10加速度约为±9.7656m/s²。两次调用 in_flight 相同且覆盖两值；NEDi 缓存有效，runtime thrust approximation=false。Rocq 问题的位置域更广，要求共同平移与误差相减32位有符号可表示；它没有预设计算误差相等或已经返回。

目标为 CompCert 3.17、x86-64 Linux standard ABI、小端、binary32 RNE，NaN policy 由生成 manifest 的原语义库 hash 固定。返回结构体的真实隐藏缓冲区 ABI 已记录；只比较已初始化的有效字段。允许 gh=&guidance_h，实际读取的是全局 heading。

模型保留原始缓存 getter 的无效缓存分支、静态滤波状态、thrust 分支和 atan2f；原外调 stateCalcPositionNed_i/stateCalcSpeedNed_i/atan2f 的实现环境覆盖仍待证。COMMANDS_NB=4、COMMAND_THRUST=3 是显式 controller verification profile，不冒充完整生产机体配置。没有证明 native libm、GCC 或硬件的普遍等价。

## 失败、限制与下一步

全部失败原样保留：SAT/trace与SAT sliced各300秒超时；Z3 FPA触发CBMC内部不支持；Z3未切片180秒超时；三个SAT单属性60秒超时。最终切片Z3命令完整通过124项，未添加误差相等假设或替换函数体。

具体 Genv.init_mem、lazy 初始化及备用 raw Mem.alloc/store 初始化在执行函数前触及本次3GB虚拟内存方法预算。早期字段路径递归 guard 检查曾超时并出现较高RSS，随后以显式结构递归修复。这些失败不构成程序反例，也不是无法执行的形式结论。实际getter符号证明随后成功。

下一步需要把 getter、位置/速度误差、PID整数运算、积分裁剪与返回工厂组合为主入口符号执行证明，并建立全后继安全/终止和124项原属性适配器。当前整体不标作已验证。

## 实际成本

下表为每次实际阶段记录，含失败与重试。单位为秒、token、bytes；缓存和reasoning是子集，不重复加入总token。阶段墙钟可能重叠，不能相加为任务墙钟。

| 阶段调用 | 实测墙钟秒 | 实测总token | 观测工具树RSS峰值bytes |
| --- | ---: | ---: | ---: |
| prepare | 341.286 | 1146426 | 22876160 |
| prepare | 251.624 | 1497683 | 15728640 |
| cbmc | 1329.681 | 7766162 | 580644864 |
| align | 208.013 | 2196943 | 17993728 |
| align | 559.203 | 6335068 | 1282961408 |
| rocq | 2834.528 | 19036898 | 11108077568 |

完整工具CPU因超时终止缺失GNU-time回执而为 **null**；并发联合RSS与模型服务端内存也为 **null**。观测RSS是10ms采样，可能漏峰或重复计共享页。最终任务 token 以实际root窗口与本次fresh worker事件ID并集去重；根包装器CPU不能再次叠加子阶段。最终截止、逐调用数字与已记录CPU小计见 costs.json。

## 证据入口

- 问题：`paparazzi/relations/pid_position_translation/problem/Spec.v`
- 当前尝试及复现：`paparazzi/relations/pid_position_translation/attempts/001/`
- 真实getter子证明：`paparazzi/relations/pid_position_translation/support/GetterSemantics.v`
- 四阶段：`paparazzi/models/guidance_pid_h_run_pos/{prepare,cbmc,align,rocq}/`
- 完整属性记录：`cbmc/properties.json`；主Rocq重验仍pending：`rocq/spec-recheck.json`
- 最终数学证据冻结：`evidence/core-freeze.json`

实际证明作者为 gpt-6.1-sol / medium，运行时回执在 attempt evidence。独立内核检查和原始假设清单均保留；Csem 子定理继承 CompCert/库的 classical、functional extensionality 和外部语义接口，未新增目标公理或 admitted proof。没有 commit/push。

## 最终封账

截止：2026-11-07T18:48:41.456964+00:00。实际任务墙钟 5152.413 秒；实际去重 token 61381526（input 61135249，output 246277；cached input 60801280、reasoning output 156265 是子集）。已记录 GNU 工具 CPU 小计 324.93 秒，完整工具 CPU 仍为 null。最大已观测单命令工具树 RSS 11108077568 bytes；任务并发联合峰值仍为 null。root 包装器仅取自身命令，嵌套 exporter 不再次累计。逐调用记录与未知原因见 costs.json；全部历史失败均包含。封账后仅机械写入这些数值、清单和交付镜像，未新增数学工作。
