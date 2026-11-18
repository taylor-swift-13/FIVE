From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import Unconditional EntryCorollaries EntrySafety SpeedExecution AccelExecution.
Require FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Definition goal_all_final_formula : Spec.AllFinalStateFormula := all_final_state_formula.
Definition goal_all_final_named_bits : Spec.AllFinalNamedBits := all_final_named_bits.
Definition goal_normal_completion : Spec.NormalCompletion := normal_completion.
Print Assumptions goal_all_final_formula.
Print Assumptions goal_all_final_named_bits.
Print Assumptions goal_normal_completion.
Print Assumptions speed_no_error_given_software.
Print Assumptions accel_no_error_given_software.
