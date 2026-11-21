From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassRoundoff Require Import Spec.
From FiveLowpassRoundoffSupport Require Import CallMemory.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
Require FiveLowpassUpdateFunctional.Proof.
Import ListNotations.
Local Open Scope Z_scope.
Module U:=FiveLowpassUpdateCase.Contract.

Definition ValidBlocks(m mf:mem):Prop:=forall q,Mem.valid_block m q->Mem.valid_block mf q.
Lemma frame_trans:forall m0 m1 m2 b p,
 ValidBlocks m0 m1->U.Frame m0 m1 b p->U.Frame m1 m2 b p->U.Frame m0 m2 b p.
Proof. intros m0 m1 m2 b p VALID F1 F2 q z n V OUT;rewrite F2 by auto;apply F1;auto. Qed.
Lemma frame_refl:forall m b p,U.Frame m m b p.
Proof. intros m b p q z n V OUT;reflexivity. Qed.
Lemma call_post_valid:forall m b p c li lo x,
 U.Initialized m b p c li lo->
 forall t r mf,Call b p x m t r mf->
 r=Vsingle(U.output c li lo x) /\ U.Post m mf b p c li lo x /\ValidBlocks m mf.
Proof.
 intros m b p c li lo x INIT t r mf PATH.
 destruct(update_call_summary_valid m b p c li lo x INIT)as[after[EV[POST VALID]]].
 assert(N:normal_state(FiveLowpassUpdate.Execution.entry(U.Args b p x)m)=true)by(vm_compute;reflexivity).
 destruct(defined_evaluator_exact_return FiveLowpassUpdate.Execution.ge _ _ _ _ _ _ N EV PATH)as[VR MR].
 subst r mf;auto.
Qed.
Lemma returns_succ:forall c x y0 n,
 Returns c x y0(S n)=Returns c x y0 n++[Vsingle(actual c x y0(S n))].
Proof.
 intros;unfold Returns;rewrite seq_S,map_app;cbn;reflexivity.
Qed.
Lemma observations_zero:forall m b p c x y0,
 U.Initialized m b p c(x O)y0->Observed c x y0 O b p m m.
Proof.
 intros;unfold Observed;cbn[actual];split;[exact H|];split;[reflexivity|].
 split;[apply frame_refl|lia].
Qed.
Lemma observations_step:forall c x y0 n m0 m1 m2 b p,
 Observed c x y0 n b p m0 m1->ValidBlocks m0 m1->
 U.Post m1 m2 b p c(x n)(actual c x y0 n)(x(S n))->
 Observed c x y0(S n)b p m0 m2.
Proof.
 intros c x y0 n m0 m1 m2 b p [INIT[COEFF[FR BYTES]]] VALID [NEXT[BIN[BOUT KEEP]]].
 unfold Observed;cbn[actual];split;[exact NEXT|].
 split.
 - rewrite(KEEP b(Ptrofs.unsigned p)4).
   + exact COEFF.
   + eapply U.initialized_valid;exact INIT.
   + right;left;lia.
 - split.
   + eapply frame_trans;eauto.
   + intros;auto.
Qed.
Theorem calls_observed:forall b p x n m mf rs,Calls b p x n m mf rs->
 forall c y0,U.Initialized m b p c(x O)y0->
 rs=Returns c x y0 n /\ Observed c x y0 n b p m mf /\ValidBlocks m mf.
Proof.
 intros b p x n m mf rs CALLS;induction CALLS as[mm|n m0 m1 m2 rs t r RUN IH CALL];intros c y0 INIT.
 - split;[reflexivity|];split;[apply observations_zero;exact INIT|intros q V;exact V].
 - destruct(IH c y0 INIT)as[RET[OBS VALID]].
   pose proof(proj1 OBS)as READY.
   destruct(call_post_valid m1 b p c(x n)(actual c x y0 n)(x(S n))READY t r m2 CALL)as[RR[POST V2]].
   subst r rs;split.
   + symmetry;apply returns_succ.
   + split.
     * eapply observations_step;eauto.
     * intros q V;apply V2;apply VALID;exact V.
Qed.
Theorem repeated_exists:forall c x y0 m b p,
 U.Initialized m b p c(x O)y0->
 forall n,exists mf,Calls b p x n m mf(Returns c x y0 n) /\
 Observed c x y0 n b p m mf /\ValidBlocks m mf.
Proof.
 intros c x y0 m b p INIT n;induction n as[|n IH].
 - exists m;split;[constructor|];split;[apply observations_zero;exact INIT|intros q V;exact V].
 - destruct IH as[m1[RUN[OBS VALID]]].
   pose proof(proj1 OBS)as READY.
   destruct(FiveLowpassUpdateFunctional.Proof.normal_completion m1 b p c(x n)(actual c x y0 n)(x(S n))READY)as[t[m2[CALL POST]]].
   pose proof(call_post_valid m1 b p c(x n)(actual c x y0 n)(x(S n))READY t _ m2 CALL)as[EQ[POST2 V2]].
   exists m2;split.
   + rewrite returns_succ;eapply calls_succ;eauto.
   + split;[eapply observations_step;eauto|].
     intros q V;apply V2;apply VALID;exact V.
Qed.
Print Assumptions calls_observed.
Print Assumptions repeated_exists.
