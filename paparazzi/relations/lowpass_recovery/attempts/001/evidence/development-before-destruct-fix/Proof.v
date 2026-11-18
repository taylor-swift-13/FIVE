From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassSupport Require Import LowpassMemory Straightline InitCall RetuneCall ResetCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
Require FiveLowpassInit.Execution FiveLowpassRetune.Execution FiveLowpassReset.Execution.
From FiveLowpassRecovery Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Lemma composite_summary:forall ma mb ba bb pa pb tau h value,
 writable12 ma ba pa->writable12 mb bb pb->exists m1 fa fb,
 state_eval FiveLowpassRetune.Execution.ge(FiveLowpassRetune.Execution.entry[Vptr ba pa;Vsingle tau;Vsingle h]ma)=Some(Vundef,m1) /\
 state_eval FiveLowpassReset.Execution.ge(FiveLowpassReset.Execution.entry[Vptr ba pa;Vsingle value]m1)=Some(Vsingle value,fa) /\
 state_eval FiveLowpassInit.Execution.ge(FiveLowpassInit.Execution.entry[Vptr bb pb;Vsingle tau;Vsingle h;Vsingle value]mb)=Some(Vundef,fb) /\
 FinalPost ma mb fa fb ba bb pa pb tau h value.
Proof.
 intros ma mb ba bb pa pb tau h value PA PB.
 destruct(retune_call_summary ma ba pa tau h PA)as[m1[ER[P1[BR[FR VR]]]]].
 destruct(reset_call_summary m1 ba pa value P1)as[fa[ES[PS[BS FS]]]].
 destruct(init_call_summary mb bb pb value tau h PB)as[fb[EI[PI[BI FI]]]].
 change(Mem.loadbytes m1 ba(Ptrofs.unsigned pa)4=Some(encode_val Mfloat32(Vsingle(coefficient tau h))))in BR.
 change(Mem.loadbytes fb bb(Ptrofs.unsigned pb)12=Some(final_bytes tau h value))in BI.
 assert(VBA:Mem.valid_block m1 ba).
 { pose proof(field_access m1 ba pa 0 P1 ltac:(simpl;auto))as W.
   eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W|constructor]. }
 assert(COEF:Mem.loadbytes fa ba(Ptrofs.unsigned pa)4=Some(encode_val Mfloat32(Vsingle(coefficient tau h))))
 by(rewrite(FS ba(Ptrofs.unsigned pa)4 VBA ltac:(right;left;lia));exact BR).
 assert(AB:Mem.loadbytes fa ba(Ptrofs.unsigned pa)12=Some(final_bytes tau h value)).
 { unfold final_bytes;replace 12 with(4+8)by lia;eapply Mem.loadbytes_concat;[exact COEF|exact BS|lia|lia]. }
 exists m1,fa,fb;split;[exact ER|];split;[exact ES|];split;[exact EI|].
 unfold FinalPost;split;[exact PS|];split;[exact PI|];split;[exact AB|];split;[exact BI|];split.
 - intros q z n VB OUT;rewrite(FS q z n(VR q VB)ltac:(destruct OUT as[NE|[LO|HI]];intuition lia)).
   apply FR;[exact VB|destruct OUT as[NE|[LO|HI]];intuition lia].
 - exact FI.
Qed.
Lemma retune_normal:forall args m,normal_state(FiveLowpassRetune.Execution.entry args m)=true.
Proof. intros;vm_compute;reflexivity. Qed.
Lemma reset_normal:forall args m,normal_state(FiveLowpassReset.Execution.entry args m)=true.
Proof. intros;vm_compute;reflexivity. Qed.
Lemma init_normal:forall args m,normal_state(FiveLowpassInit.Execution.entry args m)=true.
Proof. intros;vm_compute;reflexivity. Qed.
Lemma retune_names:forall args m,call_names(FiveLowpassRetune.Execution.entry args m).
Proof. intros;vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma reset_names:forall args m,call_names(FiveLowpassReset.Execution.entry args m).
Proof. intros;vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Lemma init_names:forall args m,call_names(FiveLowpassInit.Execution.entry args m).
Proof. intros;vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem normal_completion:Spec.NormalCompletion.
Proof.
 unfold Spec.NormalCompletion;intros ma mb ba bb pa pb tau h value PA PB.
 destruct(composite_summary ma mb ba bb pa pb tau h value PA PB)as[m1[fa[fb[ER[ES[EI POST]]]]]]].
 exists m1,fa,fb;split.
 - eapply defined_evaluator_return_exists;[apply retune_normal|apply retune_names|exact ER].
 - split;[eapply defined_evaluator_return_exists;[apply reset_normal|apply reset_names|exact ES]|].
   split;[eapply defined_evaluator_return_exists;[apply init_normal|apply init_names|exact EI]|exact POST].
Qed.
Theorem all_normal_results:Spec.AllNormalResults.
Proof.
 unfold Spec.AllNormalResults;intros ma mb ba bb pa pb tau h value PA PB m1 fa fb rr rs ri[tr PR][ts PS][ti PI].
 destruct(composite_summary ma mb ba bb pa pb tau h value PA PB)as[w1[wa[wb[ER[ES[EI POST]]]]]]].
 destruct(defined_evaluator_exact_return FiveLowpassRetune.Execution.ge _ _ _ _ _ _ (retune_normal _ _)ER PR)as[RR MR];subst rr m1.
 destruct(defined_evaluator_exact_return FiveLowpassReset.Execution.ge _ _ _ _ _ _ (reset_normal _ _)ES PS)as[RS MS];subst rs fa.
 destruct(defined_evaluator_exact_return FiveLowpassInit.Execution.ge _ _ _ _ _ _ (init_normal _ _)EI PI)as[RI MI];subst ri fb.
 split;[reflexivity|];split;[reflexivity|];split;[reflexivity|];split;[|exact POST].
 destruct POST as[_[_[A[B REST]]]];rewrite A,B;reflexivity.
Qed.
Theorem nonvacuity:Spec.Nonvacuity.
Proof.
 destruct(Mem.alloc Mem.empty 0 12)as[ma ba]eqn:A.
 destruct(Mem.alloc ma 0 12)as[mb bb]eqn:B.
 exists ma,mb,ba,bb;split.
 - intro EQ;subst bb;eapply Mem.fresh_block_alloc;[exact B|eapply Mem.valid_new_block;exact A].
 - split;unfold writable12;rewrite Ptrofs.unsigned_zero;split;try(exists 0;lia);split;try(change(0+12<=18446744073709551616);lia).
   + intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|lia]|constructor].
   + intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact B|lia]|constructor].
Qed.
Print Assumptions normal_completion.
Print Assumptions all_normal_results.
Print Assumptions nonvacuity.
