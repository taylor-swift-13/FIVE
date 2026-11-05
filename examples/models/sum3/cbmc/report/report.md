# CBMC result

Traditional CBMC returned success for all 10 reported properties. The first sum3 call uses unconstrained binary32 arguments; the output-bit assertion covers only `(16777216.0f, 1.0f, -16777216.0f)` and checks `0x00000000`. Actual command, raw JSON and costs are linked by `../handoff.json` and `costs.json`.

## Model configuration

| Field | Value |
| --- | --- |
| Entry | `sum3` / `f_sum3` |
| Namespace | `FiveSum3` |
| Target | CompCert 3.17 Csem/Cexec, x86-64 Linux, standard ABI, little endian, IEEE 754 binary32, nearest ties to even |
| Rocq | 9.2 (rebuild environment), OCaml 4.14.2 |
| Frontend options | No explicit frontend or preprocessor arguments |
| External bindings | None |
| Bindings SHA-256 | c7ea3a535f1984b4117a388e470c1e1db7e51ef196500028e320a91d126ba5a4 |
| align/model/compcert-manifest.json SHA-256 | c4c5a5b39e4c0cf2f1e05ce18f6454af9652b2bd4d1dac1b0f9bc0f8d87f04f2 |
| align/model/Source.v SHA-256 | 73e34704b1ea03671de34f619daa475cc70dff336f1720e64c431995008d373e |
| align/model/Execution.v SHA-256 | cac05564097b235e3c31d3bf9a826b8bfd1929b2d9dba7368737baa4a0f79ebe |
| align/model/proof/Obligations.v SHA-256 | e2f1294af7aea0efa22eba759d46d1526a44ffbbe0e7b051ace62c2535ccf921 |
| prepare/source/sum3.c SHA-256 | 25143236d5dea5a1721a5f9947573083d3831f51240a6f1b0d23098e09c8ff03 |

The backend manifest records tool and CompCert semantic dependency hashes, including the NaN policy inputs.
