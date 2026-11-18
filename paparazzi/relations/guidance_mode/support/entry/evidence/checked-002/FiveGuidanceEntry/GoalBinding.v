From FiveGuidanceMode Require Import Spec.
From FiveGuidanceEntry Require Import EntryPrelimit.
Definition goal_actual_prelimit : FiveGuidanceMode.Spec.ActualPrelimitExists := FiveGuidanceEntry.EntryPrelimit.actual_prelimit_exists.
Print Assumptions goal_actual_prelimit.
