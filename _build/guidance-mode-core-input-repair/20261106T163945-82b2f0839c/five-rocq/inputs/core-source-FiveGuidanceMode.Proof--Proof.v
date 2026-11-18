From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import Unconditional.
From FiveGuidanceEntry Require Import EntryPrelimit.
From FiveGuidanceRelationSupport Require Import Witnesses.
Theorem normal_completion:Spec.NormalCompletion.
Proof. exact Unconditional.normal_completion. Qed.
Theorem all_final_state_formula:Spec.AllFinalStateFormula.
Proof. exact Unconditional.all_final_state_formula. Qed.
Theorem all_final_named_bits:Spec.AllFinalNamedBits.
Proof. exact Unconditional.all_final_named_bits. Qed.
Theorem actual_prelimit:Spec.ActualPrelimitExists.
Proof. exact EntryPrelimit.actual_prelimit_exists. Qed.
Theorem nontrivial_witnesses:Spec.NontrivialWitnesses.
Proof. exact Witnesses.nontrivial_witnesses. Qed.
Print Assumptions normal_completion.
Print Assumptions all_final_state_formula.
Print Assumptions all_final_named_bits.
Print Assumptions actual_prelimit.
Print Assumptions nontrivial_witnesses.
