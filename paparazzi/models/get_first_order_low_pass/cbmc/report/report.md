传统 CBMC 对原始准备 C 与实际 harness 的19项全部 SUCCESS：6项源指针读守卫、9项 memcpy/bits 守卫、4项返回/三个字段只读位断言。全部 binary32，无循环/递归，unwind=1；memcpy合法观察位模式；反例 not_applicable。

首轮真实成功调用使用 bash 包装，严格门禁要求 cbmc 为原始 argv[0]，故保留其历史结果/成本并执行新 direct CBMC 调用；新旧 properties 逐项完全相同，canonical receipt 为031944。
