From Stdlib Require Import List ZArith Reals Lra.
From compcert Require Import Integers Floats Values Memory.
From FivePidDfRoundoff Require Import Spec.
From FivePidDfRoundoffSupport Require Import Reference Numerical Cycles.
Require FivePidDfCase.Witness.
Open Scope R_scope.
Module S:=FivePidDfRoundoff.Spec.
Theorem exact_arithmetic:S.ExactArithmetic.
Proof. exact exact_positional. Qed.
Theorem coefficient_deviation:S.CoefficientPerturbation.
Proof. exact coefficient_perturbation. Qed.
Theorem numeric_invariant:S.NumericInvariant.
Proof. exact invariant. Qed.
Theorem local_roundoff:S.LocalRoundoff.
Proof. exact local_error. Qed.
Theorem arbitrary_horizon:S.ArbitraryHorizon.
Proof.
 unfold S.ArbitraryHorizon;intros a b c x A P H D n.
 pose proof(positional_error a b c x A P H D n)as E.
 unfold total_envelope in E;rewrite envelope_explicit in E;exact E.
Qed.
Theorem original_init_coefficients:S.OriginalInitCoefficients.
Proof.
 unfold S.OriginalInitCoefficients;intros Kp Kd Ki Ts x T A n.
 apply arbitrary_horizon;exact A.
Qed.
Theorem execution_exists:S.ExecutionExists.
Proof.
 unfold S.ExecutionExists;intros a b c x A m b0 p INIT n.
 eapply repeated_exists;[exact(proj1(proj2(proj2(proj2 A))))|exact INIT].
Qed.
Theorem every_execution:S.EveryExecution.
Proof.
 unfold S.EveryExecution;intros a b c x A m b0 p INIT n mf rs RUN.
 destruct(calls_observed b0 p x n m mf rs RUN a b c(proj1(proj2(proj2(proj2 A))))INIT)as[RET OBS].
 split;[exact RET|];split;[exact OBS|];split.
 - exact(proj1(invariant a b c x A n)).
 - intros;apply arbitrary_horizon;exact A.
Qed.
Theorem nonvacuity:S.Nonvacuity.
Proof.
 unfold S.Nonvacuity;split.
 - exists Float32.zero,Float32.zero,Float32.zero,(fun _=>Float32.zero).
   assert(Z:Unit Float32.zero).
   { split;[reflexivity|change(Rabs 0<=1);rewrite Rabs_R0;lra]. }
   split;[exact Z|];split;[exact Z|];split;[exact Z|];split;[reflexivity|intro n;exact Z].
 - intros a b c.
   destruct(FivePidDfCase.Witness.initialized_inhabited a b c Float32.zero Float32.zero Float32.zero Float32.zero Float32.zero)as[m[b0 INIT]].
   exists m,b0,Ptrofs.zero;exact INIT.
Qed.
Print Assumptions exact_arithmetic.
Print Assumptions coefficient_deviation.
Print Assumptions numeric_invariant.
Print Assumptions local_roundoff.
Print Assumptions arbitrary_horizon.
Print Assumptions original_init_coefficients.
Print Assumptions execution_exists.
Print Assumptions every_execution.
Print Assumptions nonvacuity.
