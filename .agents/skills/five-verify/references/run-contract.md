# 最小运行与产物契约

每次 skill 调用创建唯一运行目录（FIVE 默认 `runs/<run-id>/<skill>/`），保留失败、超时和中断状态，不覆盖旧结论。一次输入变化对应一次新运行。

只保留三份入口文件及支撑结论的证据：

| 产物 | 内容 |
| --- | --- |
| `report.md` | 简短结论、范围、未完成项、资源数字；align记录本阶段真实问题的发现/解决/未解决数及最终结论 |
| `metrics.json` | 模型token、墙钟时间、工具CPU时间、内存峰值、采集方法、口径和可用状态 |
| `run.json` | 输入/输出清单与hash、语义/前置条件、工具版本与命令、结果、必要证据索引；不另存多份同义摘要 |
| `inputs/`、`evidence/`、`logs/` | 必要源码快照、证明/反例/测试和原始工具输出。相同证据引用一次，不堆叠复制报告 |

时间使用秒，内存使用bytes，token使用token数。墙钟从本次调用开始到结束；CPU仅统计执行工具。GNU time最大RSS是单进程最大值，不是并发进程总和；`/proc`进程树RSS采样峰值会注明间隔、共享页可能重复计数和可能漏掉短峰值。模型服务器/桌面agent内存不能冒充工具内存。

token记录input、output、cached-input及可取得的reasoning-output，后两者是子集，不重复加进total。只导入供应商usage或明确标识的Codex session事件；按event_id对实际阶段与端到端汇总去重。没有可靠接口则值为null并记unavailable+原因，不用日志字数估计，不把未知记0；用户报告列明已记录数值、未知 null 与原因；原始计量状态保持工具实际输出，不能宣称指标齐全。保留必要usage回执即可，不保存模型思维过程或完整无关聊天。

当前 align 为单 agent，不要求子 agent 或独立审批。实际另有授权子任务时，才分别记录其指标和证据。端到端墙钟直接计时，不能相加子阶段墙钟；串行阶段峰值取最大，无法测量并发总峰值时明确不可用。启动子agent前记录调用时间和输入版本；资源回放不能冒充此前agent思考时间。

开始工作时建立记录，外部命令通过 `scripts/five_telemetry.py` 的 Run.command 或CLI执行；在成功、失败和超时路径均finish。模型usage可经 `python3 scripts/five_telemetry.py tokens --run RUN_DIR --receipt usage.json` 导入。通用CLI提供start/exec/finish；现有a+b与纯Rocq入口已接入。对已有项目复用其构建命令，不强迫改项目结构。

完整产物意味着结论可检查、可重跑；未生成的必需证据列原因及缺项。验证passed、产物完整性、指标完整性是三个不同状态。

## 四阶段模型 token 的实际采集

prepare、CBMC、align、Rocq 分别建立skill-session记录；不能把主聊天总量直接分摊给它们，也不能只统计执行脚本时段。先识别本次CODEX_THREAD_ID与对应session JSONL，在读取/分析实现、编写模型或证明之前运行：

```bash
python3 scripts/five_telemetry.py start --base runs --skill five-cbmc \
  --scope scope.json --session /path/to/current-session.jsonl
```

其余阶段分别使用 five-prepare/five-align/five-rocq。保存返回的RUN目录；该阶段完成后用finish结束同一记录。start和finish自动采集token_count累计事件边界，提取实际input/output/cache/reasoning计数；缓存与reasoning为子集。工具执行作为该记录的exec命令，必要证据由finish的outputs传入。最终面向用户的总汇报可计入five-verify，不倒灌进已经结束的阶段。

align 当前只记录主 agent 自身的阶段 session，不再要求 A/B session、问题计数或审批。若用户另外授权实际子任务，才记录各自 session 并按 parent/event_id 去重；不创建虚构子任务或把一个 session 冒充另一个。只有确实观测为空的边界区间可记0，缺失数据为null。

`scripts/codex_usage.py`可按本聊天父子session身份提取实际用量（不导出聊天或推理内容），也提供snapshot/receipt边界命令。已有历史session累计用量可准确提取；历史主agent没有阶段边界时保留unattributed，不作事后精确分摊。纯脚本回放计量不等于skill的模型工作计量。

## 逐阶段严格成本验收

prepare、CBMC、align、Rocq 以及实际调用的 verify 各自建立独立 skill-session。边界从该阶段开始分析/构造/修复前建立，到阶段工作完成时结束；重试、失败、超时同样计入。工具回放不能代替阶段大模型消耗。切换职责时结束或明确暂停归属，不能给同一阶段工作事后分摊名称。

每个阶段必须记录实际 input/output/total token，缓存与 reasoning 为子集；直接计墙钟；工具 CPU 以 GNU time 为证据；内存同时保留单进程最大 RSS 与工具进程树采样峰值及采样间隔。模型服务端/桌面 agent 内存不在可见范围，不包含在工具 RSS 中。采样峰值可能漏峰、共享页可能重复计数，不能称为精确的系统总内存峰值。

`Run.finish` 自动记录 `cost_audit`，核查 session 用量边界、原始 receipt、事件去重、GNU time 记录、采样数据与汇总口径。结束后还可运行：

```sh
python3 scripts/audit-costs.py --run RUN_DIR
```

返回 0 才表示该阶段成本证据完整；非 0 明确列缺项；成本审计完整性与已记录数值分开陈述。验证结果与成本状态独立：证明通过不能掩盖成本缺失，失败的证明也必须统计消耗。未知值为 null 并说明原因，禁止用 0、字数估计、脚本耗时代替；没有可靠用量接口时如实报告不完整，不制造记录。

端到端 token 按事件 ID 并集去重；verify 自身 token 排除已归属子阶段的事件，不把含子阶段的包裹区间再次当作自身消耗。端到端墙钟直接测量。工具计时若已经包裹了整个子阶段，不能再把子阶段 CPU 累加一次；脚本成本审计会拒绝这种重叠。顺序执行内存峰值取有证据的最大值，并行联合峰值缺失则保持未知。最终报告逐阶段列状态/指标，再列去重汇总。
用户报告遵循 [共享案例契约](case-contract.md) 的 gold-standard 规范：使用 recorded 表示已记录的实测，未观测值为 null 并说明原因，不使用 partial 作为用户汇总标签；原始 metrics/audit 回执原样保留。请求及实际模型/推理强度分别记录，配置要求按当前用户请求，不能追溯改签历史运行。
