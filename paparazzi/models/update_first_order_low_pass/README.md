# update_first_order_low_pass

Complete proof artifact: exact upstream update body, direct traditional CBMC36/36 SUCCESS, original unrestricted CompCert Csyntax/Cexec model, and49 independently kernel-checked typed goals across5 problems. [Rocq report](rocq/report/report.md). The [actual update/get relation](../../relations/lowpass_update_readback/problem/Spec.v) proves normal completion and exact readback bits with explicit byte/frame observations.

The proof domain is an aligned nonwrapping initialized writable12-byte filter and any binary32 input; numerical restrictions are unnecessary. The execution model still accepts all machine arguments and memory. Source, target, assumptions, evidence, retained development failures and measured costs are linked from the stage/problem reports.

Run `python3 paparazzi/report/lowpass_update_readback/check_all.py` from the FIVE repository root. Add `--compile` to cold rebuild all11 active proof questions (historical getter5, new update5, relation1).

