From Stdlib Require Import ZArith.
Open Scope Z_scope.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationSupport Require Import TranslationArithmetic QuietWalk WitnessSetup.

(* Established auxiliary facts. None is the general requested relation. *)
Theorem translated_error_arithmetic : forall r p d:Z, (r+d)-(p+d)=r-p.
Proof. exact common_translation_difference. Qed.
Theorem nonzero_representable_arithmetic_witness :
 exists r p d:Z, physical_translation r p d /\ d<>0 /\ r-p<>0 /\ r-p=512 /\ r+d=28160 /\ p+d=27648.
Proof. exact nonzero_physical_translation_witness. Qed.

(* PositionTranslationGoal, NoErrorGoal, AllSuccessorTerminationGoal and
   NonzeroNonvacuityGoal remain unproved. The actual finite-walk normal-return
   computation attempts are retained under evidence; no theorem is postulated. *)
