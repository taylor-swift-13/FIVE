From Stdlib Require Import List.
From compcert Require Import AST Integers Floats Values Memory Ctypes Csem Smallstep.
From FiveCases.identity.model Require Import Source Execution.
From FiveCases.identity.proof.support Require Import Correspondence PathFacts.
Import ListNotations.
Theorem all_reachable_no_error : forall input memory t reached,
 star Csem.step Execution.ge
  (Execution.entry [Vsingle(Float32.of_bits input)] memory) t reached ->
 ~ Execution.source_error reached.
Proof.
 intros input memory t reached PATH [NOTRETURN STOP].
 destruct (source_execution_certificate Execution.ge input memory) as [released [EXEC CERT]].
 destruct (certificate_maximal _ _ _ _ CERT _ _ PATH STOP) as [EQ TRACE].
 subst reached. apply NOTRETURN. unfold Execution.normal_return. eauto.
Qed.
Print Assumptions all_reachable_no_error.
