# CBMC stage

`harness.c` calls `sum3(16777216.0f, 1.0f, -16777216.0f)` and checks all 32 bits of the result with `memcpy`. `results.json` is the original CBMC 6.11 JSON result. Traditional bounded model checking passed `main.assertion.1` and the generated memory checks for this concrete input. No contracts replace the function body. The exact command, raw logs and resource records are under `../report/evidence/cbmc/`.

Costs and measurement limitations: [`../report/costs.json`](../report/costs.json), stage `five-cbmc`.
