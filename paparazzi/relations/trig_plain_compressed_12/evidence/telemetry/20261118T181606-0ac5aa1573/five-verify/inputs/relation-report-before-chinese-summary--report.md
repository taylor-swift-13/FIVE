The ordinary-table and flash-compressed LOW12 original C implementations return the same int32 word for every normalized Q12 angle code a in[-12867,12867]. Both source executions are safe and terminate after the genuine original compressed initializer. LOW12 preserves the original Q14 output precision.

The seven [canonical goals](Spec.v) include real initial-memory existence; initializer safety/termination; successful return0, exact9651 packed bytes and its frame; safety/termination of both sine entries; return-word equality; and preservation of each sine entry’s existing blocks. Each model uses its own global-memory layout. The compressed representation is proved from the original1690 ROM bytes; decoded equality is never an input premise. The ordinary6434 int16 literals are the reference data.

[Attempt001](../attempts/001/report.md) supplies the complete original CompCert Csem proofs, [exact goal certificate](../attempts/001/evidence/goal-binding/GoalBinding.v), [independent kernel receipt](../attempts/001/evidence/kernel-check.json), and [shared actual costs](../evidence/rocq-shared-costs.json). The chosen configuration is COMPR_LOW, unrolled threshold lookup, PPRZ_TRIG_CONST=const, without PPRZ_TRIG_INT_TEST, on CompCert3.17 x86-64 Linux little endian.

The execution models keep the full machine-input and memory domain. This functional theorem uses the explicitly normalized angle domain; it establishes fixed-point representation equivalence, without an analytic sine-accuracy claim. Other compression backends and cosine are outside this theorem.

The three entry cases retain separate full stage evidence. All101 case-qualified traditional CBMC properties have exact source propositions and kernel-backed proofs; the original automatic guard IDs are preserved. [Final artifact validation](../evidence/artifact-validation.json) and [kernel summary](../evidence/final-kernel-summary.json) record successful acceptance.

| Entry case | Actual CBMC properties | Stage evidence |
| --- | ---: | --- |
| Ordinary-table sine | 13 | [Rocq stage](../../../models/trig_plain/pprz_itrig_sin/rocq/report/report.md) |
| LOW12 sine after genuine initialization | 51 | [Rocq stage](../../../models/trig_compressed_12/pprz_itrig_sin/rocq/report/report.md) |
| Genuine LOW12 initializer and selected decoder query | 37 | [Rocq stage](../../../models/trig_compressed_12/pprz_trig_int_init/rocq/report/report.md) |
