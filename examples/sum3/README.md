# sum3: FIVE stages and artifacts

This example checks the prepared C function `sum3(a,b,c) = (a+b)+c`. All stages contribute to this directory.

| Stage | Input | Output | Actual status |
| --- | --- | --- | --- |
| `five-prepare` | `source/Program.c`, entry and target | `source/bindings.json`, manifest and costs | Prepared; old full-stage cost partial |
| `five-cbmc` | Program, bindings, `cbmc/harness.c` | `cbmc/results.json`, commands, native and CBMC logs | Concrete result bits and generated checks passed; native result `0x00000000` |
| `five-align` | Prepared C; CBMC property | `model/Source.v`, `model/Execution.v`, `source/preprocessed.i`, `model/spec-map.json`, pending goals | CompCert export/audit passed; CBMC mapping includes pending gaps |
| `five-rocq` | CompCert model, properties and proof goals | `proof/NoError.v`, `proof/Core.v`, `proof/Functional.v`, `proof/spec-recheck.json`, kernel and assumption logs | All-reachable no-error and pure binary32 example proved; Csem return correspondence and termination pending |
| `five-verify` | Stage results and evidence | `report/manifest.json`, `report/costs.json`, `report/report.md` | Partial; no end-to-end verification claim |

## Statements and scope

The no-error theorem covers every reachable CompCert state for exactly three binary32 arguments and arbitrary initial memory; it imposes no numerical-domain restriction. The 32-bit assertion checked by CBMC covers only `(16777216.0f, 1.0f, -16777216.0f)`. The separately proved `Functional.sum3_concrete_bits` computes the corresponding pure Float32 result; the theorem linking that calculation to the Csem function return and the CBMC `memcpy` observation remains to be established. The goal of termination is also pending.

The Rocq compile log records inherited assumptions, including CompCert external-function semantics and classical/extensionality assumptions. The exported execution model is CompCert Csem/Cexec; a native or GCC equivalence theorem is not claimed.

The [manifest](report/manifest.json) binds actual inputs and outputs by SHA-256. The [cost report](report/costs.json) links individual run records. Stage-only token totals remain partial because the measured intervals include directory changes or miss analysis outside their boundaries. Previous artifacts and historical records are preserved.

`proof/build.py` is a retained copy of the build script used for the recorded proof run; run it from a configured FIVE environment. The recorded `run.json` contains the actual commands.
