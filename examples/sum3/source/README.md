# Prepared source

`Program.c` is the unchanged C translation unit; the selected entry is `sum3`. `bindings.json` records the original and prepared file hashes, target, and the absence of external calls in this entry. `preprocessed.i` is the frozen input generated during the CompCert export; it is not a replacement for the source. `native_main.c` is a separate concrete-input native test driver, not part of the modelled function.

Preparation costs and their limitations are in [`../report/costs.json`](../report/costs.json), stage `five-prepare`.
