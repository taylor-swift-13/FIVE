# Cross-model problem

`Sum2EqualsSum3` compares `sum2(sum2(a,b),c)` with `sum3(a,b,c)` on normal returns. All models use CompCert 3.17 Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32, nearest ties to even and no external calls. Each manifest binds the actual frontend and semantic dependencies.

- `sum2` uses `FiveSum2` and entry `f_sum2`. Manifest SHA-256 `db3cc28f99b371b0b758e378381e11380e341a817763dd401d988a5be46c5780`, Source SHA-256 `6605d81b08d60d60936c479f46b11deabc6dacade4e1446ce2f10cd63734fb0e`, Execution SHA-256 `ae470887faa2ed9168348b51ab9e00cf65778cd4481e50b8c1f46e657c01fa07`.
- `sum3` uses `FiveSum3` and entry `f_sum3`. Manifest SHA-256 `c4c5a5b39e4c0cf2f1e05ce18f6454af9652b2bd4d1dac1b0f9bc0f8d87f04f2`, Source SHA-256 `73e34704b1ea03671de34f619daa475cc70dff336f1720e64c431995008d373e`, Execution SHA-256 `cac05564097b235e3c31d3bf9a826b8bfd1929b2d9dba7368737baa4a0f79ebe`.

Spec SHA-256 `87f8626a6c3398fcb44dfb49a9b92190bc83291ce4d8fdd316e80f8e363199ea`. The proposition is proved by [attempt 001](../attempts/001/report.md) using actual GPT-6.1 Sol medium, with independent kernel evidence.

Rocq 9.2 compiled both models and `Spec.v` and independently checked the specification module.
