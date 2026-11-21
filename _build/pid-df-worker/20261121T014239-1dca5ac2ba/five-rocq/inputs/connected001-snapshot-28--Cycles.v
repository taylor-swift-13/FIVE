From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Csem Smallstep.
From FivePidDfRoundoff Require Import Spec.
Require FivePidDfCase.UpdateCall.
Import ListNotations.
Local Open Scope Z_scope.

Lemma returns_succ:forall a b c x n,
 Returns a b c x(S n)=Returns a b c x n++[Vsingle(actual a b c x(S n))].
Proof. intros;unfold Returns;rewrite seq_S,map_app;cbn;reflexivity. Qed.
Lemma observations_zero:forall m b0 p a b c x,
 x O=Float32.zero->Initial m b0 p a b c->Observed a b c x O b0 p m m.
Proof.
 intros m b0 p a b c x X I;unfold Observed,Initial in *;cbn[actual prev_actual prev32 prev2].
 rewrite X;split;[exact I|];split.
 - intros q z n V O;reflexivity.
 - split;[intros q V;exact V|lia].
Qed.
Lemma observations_step:forall a b c x n m0 m1 m2 b0 p,
 Observed a b c x n b0 p m0 m1->
 U.Post m1 m2 b0 p a b c(actual a b c x n)(x n)(prev32 x n)(x(S n))->
 Observed a b c x(S n)b0 p m0 m2.
Proof.
 intros a b c x n m0 m1 m2 b0 p[READY[FR[V0 LAST]]][NEXT[BYTES[FR2 V2]]].
 unfold Observed;cbn[actual prev_actual prev32 prev2];split;[exact NEXT|].
 split;[eapply U.frame_trans;eauto|].
 split;[intros q V;apply V2;apply V0;exact V|];intro H;exact BYTES.
Qed.
Lemma call_post:forall m b0 p a b c u0 u1 e0 e1 e2 x,
 U.Initialized m b0 p a b c u0 u1 e0 e1 e2->
 forall t r mf,Call b0 p x m t r mf->
 r=Vsingle(U.fp_step a b c u0 e0 e1 x) /\ U.Post m mf b0 p a b c u0 e0 e1 x.
Proof.
 intros m b0 p a b c u0 u1 e0 e1 e2 x INIT t r mf PATH.
 eapply FivePidDfCase.UpdateCall.update_call_observed;eauto.
Qed.
Theorem calls_observed:forall b0 p x n m mf rs,Calls b0 p x n m mf rs->
 forall a b c,x O=Float32.zero->Initial m b0 p a b c->
 rs=Returns a b c x n /\ Observed a b c x n b0 p m mf.
Proof.
 intros b0 p x n m mf rs RUN;induction RUN as[mm|n m0 m1 m2 rs t r RUN IH CALL];intros a b c X INIT.
 - split;[reflexivity|];eapply observations_zero;eauto.
 - destruct(IH a b c X INIT)as[RET OBS].
   pose proof(proj1 OBS)as READY.
   destruct(call_post m1 b0 p a b c(actual a b c x n)(prev_actual a b c x n)(x n)(prev32 x n)(prev2 x n)(x(S n))READY t r m2 CALL)as[RR POST].
   change(r=Vsingle(actual a b c x(S n)))in RR.
   subst r rs;split;[symmetry;apply returns_succ|].
   eapply observations_step;eauto.
Qed.
Theorem repeated_exists:forall a b c x m b0 p,
 x O=Float32.zero->Initial m b0 p a b c->forall n,exists mf,
 Calls b0 p x n m mf(Returns a b c x n) /\ Observed a b c x n b0 p m mf.
Proof.
 intros a b c x m b0 p X INIT n;induction n as[|n IH].
 - exists m;split;[constructor|];eapply observations_zero;eauto.
 - destruct IH as[m1[RUN OBS]];pose proof(proj1 OBS)as READY.
   destruct(FivePidDfCase.UpdateCall.update_call_execution m1 b0 p a b c
    (actual a b c x n)(prev_actual a b c x n)(x n)(prev32 x n)(prev2 x n)(x(S n))READY)as[t[m2[CALL POST]]].
   exists m2;split.
   + rewrite returns_succ;eapply calls_succ;[exact RUN|exact CALL].
   + eapply observations_step;eauto.
Qed.
