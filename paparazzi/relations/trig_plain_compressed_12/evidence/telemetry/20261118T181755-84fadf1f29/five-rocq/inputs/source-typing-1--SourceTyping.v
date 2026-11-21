From compcert Require Import Errors Csyntax Csem Ctyping.
Require PprzTrigInit.Source.

Lemma original_init_program_well_typed : Ctyping.wt_program PprzTrigInit.Source.prog.
Proof.
 apply(@Ctyping.typecheck_program_sound PprzTrigInit.Source.prog PprzTrigInit.Source.prog).
 vm_compute;reflexivity.
Qed.
Check @Ctyping.wt_call_state.
Check @Ctyping.wt_find_funct.
Check @Ctyping.preservation.
Check @Ctyping.wt_subexpr.
Check @Ctyping.wt_val_int.
Check @Ctyping.wt_int.
Print Assumptions original_init_program_well_typed.
