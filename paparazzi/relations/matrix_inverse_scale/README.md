# Matrix inverse scaling and reliability

**Checked:** all six canonical numerical goals passed a fresh53-module compile, exact GoalBindings, independent Rocq kernel check and current-source validation. See [evidence](attempts/001/evidence/goal-validation.json).

This relation links the original Paparazzi 2D/3D Csem calls to exact floating-point computations and the ideal real inverse. The [canonical specification](problem/Spec.v) contains six goals; [attempt 001](attempts/001/report.md) retains the proof and independent-check evidence.

For A=2^k I with -20<=k<=20, a symbolic Flocq proof derives the exact inverse and original signed-zero words on success. The 2D routine accepts iff k>=-6; the 3D routine accepts iff k>=-7. Rejected calls preserve every output byte, including unknown memvals. Every matrix in this family is nonsingular with infinity condition number one.

Positive scaling status invariance is refuted by I and (1/256)I. Successful-result reliability is refuted by finite inputs 2^100 I (2D) and 2^50 I (3D): determinant overflow produces a successful zero inverse with exact real infinity residual one. These are numerical refutations, never a program-correctness claim. The universal call summaries retain the unrestricted execution model and all original memory behavior.

The supported intrinsic fabs bindings, source/frontend boundary, actual CBMC properties and trace replay are documented in the participating model folders. Fixed finite witnesses were also checked independently against native original libm by the coordinator; that observation is not a general library equivalence proof.

Both participating models have now passed final all-five-question acceptance and the unchanged CompCert delivery gate. All398 original CBMC IDs are covered, including4 reproduced refutations. Later observer-composition repairs and the superseded attempts are recorded in the model folders; the six numerical proofs and their85 bound inputs were unchanged. [Complete workflow costs](evidence/workflow-costs.json) deduplicate historical and resumed sessions.
