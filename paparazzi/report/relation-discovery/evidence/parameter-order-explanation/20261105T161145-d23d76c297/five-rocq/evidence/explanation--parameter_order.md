# 一个最简单的跨函数关系：先调 omega，还是先调 zeta？

我们选择目录中的 **G2：参数设置顺序关系**。它只有两个入口函数，适合先理解“关系”到底在比较什么。

当前结论仅为**有源码依据、尚未证明的候选关系**；没有生成模型、正式规约、CBMC 结果或 Rocq 证明。
## 比较的是两段程序

两个函数都修改共享状态 `gh_ref`：

- [`gh_set_omega(o)`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L78)：限制 omega 的范围，并更新 `omega_2` 和 `zeta_omega`。
- [`gh_set_zeta(z)`](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c#L87)：限制 zeta 的范围，并更新 `zeta_omega`。

我们从**同一个已初始化逻辑状态 S 的两份独立副本**出发，分别执行：

```text
程序 A：gh_set_omega(o); gh_set_zeta(z);
程序 B：gh_set_zeta(z);  gh_set_omega(o);
```

问题是：**输入 o、z 相同，只交换调用顺序，最终状态是否相同？**

这里不是在一份正在使用的 `gh_ref` 上先跑 A、再跑 B，也不是只检查某一个函数内部的局部断言。它比较两段真实程序的执行结果。

## 为什么这件事值得检查

`zeta_omega` 是由两个参数共同决定的缓存系数。任一参数发生变化，都必须更新它；否则控制器之后可能读到过时的组合系数。

实际源码中，两处更新都使用同一乘法顺序：

```c
gh_ref.zeta_omega = gh_ref.zeta * gh_ref.omega;
```

因此，顺序关系不仅涉及两个独立字段，还涉及它们共享的缓存，以及 `omega_2` 的一致性。这使它成为一个有实际意义的跨函数问题。

## 预期的最终状态关系

令 O 是 o 经 `[0.1f, 5.0f]` 限制后的值，Z 是 z 经 `[0.7f, 1.2f]` 限制后的值。我们预期 A、B 最终都有：

| 字段 | 预期最终值 |
|---|---|
| `omega` | O |
| `zeta` | Z |
| `omega_2` | 按实际浮点语义计算的 `O * O` |
| `zeta_omega` | 按实际浮点语义计算的 `Z * O` |
| 位置、速度、加速度及其余字段 | 保持各自初始值；两边对应字段相同 |

目标是**最终命名字段的浮点位表示相同**。相同目标环境下，两条路径最终都以 `zeta * omega` 的相同操作数顺序更新缓存；这里不靠实数代数重排来替代浮点计算。

## 一个可以直接看懂的例子

初始 `omega=1`、`zeta=0.75`，设置 `o=2`、`z=1`；这些数都可精确表示，且设置值没有触发限幅。

| 执行路线 | 第一次调用之后的 `zeta_omega` | 两次调用结束后的字段 |
|---|---|---|
| A：先 omega，后 zeta | `0.75 * 2 = 1.5` | `omega=2, zeta=1, omega_2=4, zeta_omega=2` |
| B：先 zeta，后 omega | `1 * 1 = 1` | `omega=2, zeta=1, omega_2=4, zeta_omega=2` |

**中间状态可以不同，最终状态仍可相同。** 如果并发读者能观察第一次调用后的缓存，那是另一个问题，不属于这里的最终状态关系。

## 条件与观察范围

为便于第一次理解，先考虑所有相关字段已初始化、参数和旧系数有限且有效的状态，并固定目标浮点语义、binary32 字段、舍入方式和编译选项；执行期间没有其他写入者。这是说明问题时选用的简单场景，**不是已经生成的模型或已经确定的正式前条件**。

限幅必须遵循实际 [`Bound` 宏（std.h:144）](https://github.com/paparazzi/paparazzi/blob/abfee3dd56eeab12c528635504a429db3daf409a/sw/include/std.h#L144)。它还会把 NaN 限制到下界；本例先不扩展到异常值与浮点异常标志。

只比较最终命名字段；不要求结构体填充字节、独立模型的私有分配块、执行历史、按时间排列的返回值序列或浮点异常标志相同。两种路线的调用顺序本来就不同。

## 将来真正形式化时比较什么

下面只是问题示意，**不是已编译的 Rocq 代码**：

```text
从 S 的独立副本执行 A，得到 SA；从 S 的独立副本执行 B，得到 SB。
要求：投影到上述命名字段后，SA 与 SB 的对应位表示相同。
```

将来需要以这两个真实 C 入口及其调用闭包生成的 CompCert 执行模型为依据，组合实际执行，再通过共享逻辑状态表示比较字段。不同模型的全局块编号或整块内存不必相同，也不能用手写的纯函数替代实际 C 计算来冒充这个结论。

当前交付到此为止：选定一个最简单的关系，并解释它的含义；**尚未形式化或证明该关系**。完整候选目录见 [README](README.md#g2--omegazeta-tuning-order-preserves-final-configuration-and-future-traces)。
