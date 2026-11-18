From Stdlib Require Import List.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Ctypes Csyntax Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import CallfreeExecution ContinuationLift PhaseComposition.
From FiveGuidanceEntry Require Import Entry SoftwareSqrt BigstepSupport.
Require FiveGhSpeed.Source FiveGhSpeed.Execution FiveGhAccel.Source FiveGhAccel.Execution.
Require FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.
Lemma speed_leaf_syntax:forall args m,
 normal_state(Callstate(Internal FiveGhSpeed.Source.f_five_sqrtf)args Kstop m)=true.
Proof. reflexivity. Qed.
Lemma accel_leaf_syntax:forall args m,
 normal_state(Callstate(Internal FiveGhAccel.Source.f_five_sqrtf)args Kstop m)=true.
Proof. reflexivity. Qed.
Lemma speed_leaf_names:forall args m,
 call_names(Callstate(Internal FiveGhSpeed.Source.f_five_sqrtf)args Kstop m).
Proof. intros;repeat constructor;simpl;intuition discriminate. Qed.
Lemma accel_leaf_names:forall args m,
 call_names(Callstate(Internal FiveGhAccel.Source.f_five_sqrtf)args Kstop m).
Proof. intros;repeat constructor;simpl;intuition discriminate. Qed.
Theorem speed_leaf_certificate:FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->
 forall m n k,is_call_cont k ->exists mf P,
 certificate FiveGhSpeed.Execution.ge P(Returnstate(Vsingle(software_sqrt n))k mf) /\
 P(Callstate(Internal FiveGhSpeed.Source.f_five_sqrtf)[Vsingle n]k m) /\
 access_preserved m mf /\FiveGuidanceEntry.SaturationBody.old_load_frame m mf /\FiveGuidanceEntry.SaturationBody.old_bytes_frame m mf.
Proof.
 intros CONTRACT m n k CALL;destruct(CONTRACT m n)as[mf[EXEC[KEEP[FRAME BFRAME]]]].
 pose proof(funcall_original_normal _ _ _ _ _ _ _ EXEC)as WIT.
 exists mf,(callee_invariant FiveGhSpeed.Execution.ge k(Vsingle(software_sqrt n))mf);split.
 - split.
   + intros state INV;eapply callee_invariant_progress;[exact CALL|exact INV].
   + intros state t next INV NF STEP;eapply callee_invariant_all_successors;[exact CALL|exact INV|exact NF|exact STEP].
 - split.
   + change(callee_invariant FiveGhSpeed.Execution.ge k(Vsingle(software_sqrt n))mf
     (plug_state k(Callstate(Internal FiveGhSpeed.Source.f_five_sqrtf)[Vsingle n]Kstop m))).
     eapply callee_invariant_entry;[apply speed_leaf_syntax|apply speed_leaf_names|exact WIT].
   + auto.
Qed.
Theorem accel_leaf_certificate:FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->
 forall m n k,is_call_cont k ->exists mf P,
 certificate FiveGhAccel.Execution.ge P(Returnstate(Vsingle(software_sqrt n))k mf) /\
 P(Callstate(Internal FiveGhAccel.Source.f_five_sqrtf)[Vsingle n]k m) /\
 access_preserved m mf /\FiveGuidanceEntry.SaturationBodyAccel.old_load_frame m mf /\FiveGuidanceEntry.SaturationBodyAccel.old_bytes_frame m mf.
Proof.
 intros CONTRACT m n k CALL;destruct(CONTRACT m n)as[mf[EXEC[KEEP[FRAME BFRAME]]]].
 pose proof(funcall_original_normal _ _ _ _ _ _ _ EXEC)as WIT.
 exists mf,(callee_invariant FiveGhAccel.Execution.ge k(Vsingle(software_sqrt n))mf);split.
 - split.
   + intros state INV;eapply callee_invariant_progress;[exact CALL|exact INV].
   + intros state t next INV NF STEP;eapply callee_invariant_all_successors;[exact CALL|exact INV|exact NF|exact STEP].
 - split.
   + change(callee_invariant FiveGhAccel.Execution.ge k(Vsingle(software_sqrt n))mf
     (plug_state k(Callstate(Internal FiveGhAccel.Source.f_five_sqrtf)[Vsingle n]Kstop m))).
     eapply callee_invariant_entry;[apply accel_leaf_syntax|apply accel_leaf_names|exact WIT].
   + auto.
Qed.
Print Assumptions speed_leaf_certificate.
Print Assumptions accel_leaf_certificate.
