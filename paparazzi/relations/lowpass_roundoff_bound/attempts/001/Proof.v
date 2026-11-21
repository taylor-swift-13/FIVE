From Stdlib Require Import List ZArith Reals Psatz.
From compcert Require Import Integers Floats Values Memory.
From FiveLowpassRoundoff Require Import Spec.
From FiveLowpassRoundoffSupport Require Import Recurrence Cycles Numerical.
Require FiveLowpassUpdateCase.Witness.
Local Open Scope R_scope.
Module Spec:=FiveLowpassRoundoff.Spec.
Module N:=FiveLowpassRoundoffSupport.Numerical.

Lemma original_step:forall c li lo x,U.output c li lo x=N.step c li lo x.
Proof. reflexivity. Qed.
Theorem numeric_invariant:Spec.NumericInvariant.
Proof.
 unfold Spec.NumericInvariant;intros c x y0 [FC[HC[FY[HY HX]]]] n.
 induction n as[|n[FN HN]].
 - cbn[Spec.actual];split;[exact FY|lra].
 - destruct(HX n)as[FL HL];destruct(HX(S n))as[FX HV].
   cbn[Spec.actual];rewrite original_step.
   pose proof(N.step_bound_local c (x n)(Spec.actual c x y0 n)(x(S n))
     FC HC FL HL FN HN FX HV)as[F[B E]];split;assumption.
Qed.
Theorem local_roundoff:Spec.LocalRoundoff.
Proof.
 unfold Spec.LocalRoundoff;intros c x y0 A n.
 pose proof(numeric_invariant c x y0 A n)as[FY HY].
 destruct A as[FC[HC[F0[H0 HX]]]].
 destruct(HX n)as[FL HL];destruct(HX(S n))as[FX HV].
 cbn[Spec.actual];rewrite original_step.
 pose proof(N.step_bound_local c (x n)(Spec.actual c x y0 n)(x(S n))
     FC HC FL HL FY HY FX HV)as[F[B E]];exact E.
Qed.
Theorem arbitrary_horizon:Spec.ArbitraryHorizon.
Proof.
 unfold Spec.ArbitraryHorizon;intros c x y0 A n.
 assert(E:Rabs(Spec.real32(Spec.actual c x y0 n)-Spec.ideal c x y0 n)<=envelope Spec.delta n).
 { unfold Spec.ideal;apply (arbitrary_horizon_roundoff (Spec.real32 c)(fun k=>Spec.real32(x k))(Spec.real32 y0)(fun k=>Spec.real32(Spec.actual c x y0 k)) Spec.delta).
   - exact(proj1(proj2 A)).
   - unfold Spec.delta;lra.
   - reflexivity.
   - exact(local_roundoff c x y0 A). }
 split;[exact E|].
 pose proof(envelope_bounds Spec.delta n ltac:(unfold Spec.delta;lra))as[LOW HIGH].
 unfold Spec.delta in *;lra.
Qed.
Theorem execution_exists:Spec.ExecutionExists.
Proof.
 unfold Spec.ExecutionExists;intros c x y0 m b p A INIT n.
 destruct(repeated_exists c x y0 m b p INIT n)as[mf[RUN[OBS VALID]]].
 exists mf;auto.
Qed.
Theorem every_execution:Spec.EveryExecution.
Proof.
 unfold Spec.EveryExecution;intros c x y0 m b p A INIT n mf rs RUN.
 destruct(calls_observed b p x n m mf rs RUN c y0 INIT)as[RET[OBS VALID]].
 pose proof(arbitrary_horizon c x y0 A n)as[E UNIFORM].
 pose proof(numeric_invariant c x y0 A n)as[F B].
 split;[exact RET|];split;[exact OBS|];split;[exact E|];split;assumption.
Qed.
Theorem nonvacuity:Spec.Nonvacuity.
Proof.
 unfold Spec.Nonvacuity;split.
 - exists N.one,(fun _=>Float32.zero),Float32.zero.
   unfold Spec.Admissible;split;[exact N.one_finite|].
   split;[change(1<=N.r32 N.one<=2);rewrite N.one_real;lra|].
   assert(F:Spec.finite32 Float32.zero)by reflexivity.
   assert(R:Spec.real32 Float32.zero=0)by reflexivity.
   split;[exact F|];split;[rewrite R,Rabs_R0;lra|].
   intros n;split;[exact F|rewrite R,Rabs_R0;lra].
 - intros c x y0 A.
   destruct(FiveLowpassUpdateCase.Witness.initialized_inhabited c(x O)y0)as[m[b INIT]].
   exists m,b,Ptrofs.zero;exact INIT.
Qed.
Print Assumptions numeric_invariant.
Print Assumptions local_roundoff.
Print Assumptions arbitrary_horizon.
Print Assumptions execution_exists.
Print Assumptions every_execution.
Print Assumptions nonvacuity.

Example nonzero_roundoff_example_bits:
 Float32.to_bits(U.output
 (Float32.of_bits(Int.repr 1073741824)) Float32.zero Float32.zero N.one)
 =Int.repr 1051372203.
Proof. vm_compute;reflexivity. Qed.
