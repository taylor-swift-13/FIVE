# ECEF 速度读后写与旧 NED 历史独立性

已完成：原始 C 运行、传统 CBMC、三个 CompCert 执行模型，以及 Rocq 中的实际调用关系和反例证明。

Paparazzi 的 State 同时保存多种坐标系、数值格式的速度缓存。NED 是局部北、东、地向下坐标；ECEF 是地心地固坐标。本问题检验：写入新的 ECEF 整数速度后，读取 ECEF 浮点速度应解码这份新输入，并且不应受已经失效的旧 NED 缓存影响。

实际使用三个执行模型，按返回的真实内存逐次交接：

`stateSetSpeedNed_i → stateSetSpeedEcef_i → stateGetSpeedEcef_f`

问题是本目录的 [Spec.v](Spec.v)，证明是 [attempt 001](../attempts/001/Proof.v)，[验收和成本报告](../attempts/001/report.md)。`ProtocolRun` 明确包含三个原始 Csem 的 `NormalCall`，分别使用生成模型各自的全局环境；状态布局、全局 State 符号和内存桥接均有证明，没有假设三个全局环境整体相等。

设整数编码比例 S=2^19。既有规约中的 `G.decode i` 是先执行 `Float32.of_int i`，再以 binary32 除以 524288；没有换成实数计算。

| 先写入的旧 NED x | 随后写入的新 ECEF x | 应读取的 ECEF x | 实际读取值 | 实际 x 位模式 |
|---|---|---|---|---|
| 0 | 2S | 2 米/秒 | 0 米/秒 | 0x00000000 |
| S | 2S | 2 米/秒 | 1 米/秒 | 0x3f800000 |

应有的 2 米/秒位模式是 0x40000000；另外两个分量均为正零。两次调用均接受输入，整数 ECEF 字段确实保存新向量，NED 有效位已被清除；getter 最后设置 ECEF 浮点有效位。差异来自固定原始提交 `abfee3dd56eeab12c528635504a429db3daf409a` 的 `sw/airborne/state.c:1134`：

```c
SPEEDS_FLOAT_OF_BFP(state.ecef_speed_f, state.ned_speed_i);
```

该分支检查的是 ECEF 整数表示有效，却读取 NED 整数字段。

三个已验收目标：

- `ActualProtocolGoal`：对满足显式合法内存、ANY 过滤器和源向量条件的符号化输入，构造三个真实模型调用；最终观测为 `Some (bits_of nx ny nz)`，即旧 NED 输入的解码位模式。还证明新 ECEF 整数字段保留原输入。
- `ReadAfterWriteRefutationGoal`：构造 `WitnessPair`，两次执行读取结果都不等于新 ECEF 向量应有的位模式。
- `HistoryIndependenceRefutationGoal`：同一份初始 656 字节 State、同一新 ECEF 输入，改变此前 NED 输入即可改变 getter 结果。

初始内存的非空性由真实 `Genv.init_mem`、新分配源对象和实际初始化存储构造。三个模型的无错误证明覆盖前条件下所有可达原始 Csem 状态，终止性覆盖所有可能后继。源模型保留完整分支与原始输入域；证明前条件单独陈述。

CBMC 原始账本共 340 项：337 项重验，3 项功能断言被反驳。getter 的 276 项全部保留；99 项位于本协议不会进入的原始 fallback 函数，排除性由原始 Csem 控制不变量证明。内置 memcpy 的短路对象守卫、真实观察器布局、依次复制前状态/返回 12 字节/后状态，以及已定义字节的 C 比较均有对应证明。断言按原 CBMC 的独立非阻塞观察组织；这里没有声称证明了一个遇断言失败会中止的 Csem main。

完整冷验收使用 100 个源模块、14 个具名问题和 379 个精确类型绑定；证明模块和 GoalBinding 模块均通过独立内核检查。实际数学证明作者均为 GPT-6.1 Sol Ultra。失败、超时、观察器补强和完整的已记录成本保留在共享证据中；未观测指标为 null。

[最终门禁与完整目标核验](../evidence/final-acceptance.json) · [汇总成本与共享记录](../evidence/workflow-costs.json)
