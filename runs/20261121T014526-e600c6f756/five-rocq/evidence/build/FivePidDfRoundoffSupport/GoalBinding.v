From Stdlib Require Import Reals.
From compcert Require Import Floats.
From FivePidDfRoundoffSupport Require Import Absorption.
Open Scope R_scope.
Definition goal_upper : RN 16777217 = 16777216 := RN_upper_endpoint.
Definition goal_lower : RN (-16777217) = -16777216 := RN_lower_endpoint.
Definition goal_absorption : forall x y,
 finite x -> finite y -> Rabs (r32 x) <= 16777216 -> Rabs (r32 y) <= 1 ->
 finite (Float32.add x y) /\
 Rabs (r32 (Float32.add x y)) <= 16777216 /\
 Rabs (r32 (Float32.add x y) - (r32 x + r32 y)) <= u * Rabs (r32 x + r32 y) + eta /\
 Rabs (r32 (Float32.add x y)) <= Rabs (r32 x) + 3 := add_absorption.
Definition goal_error_two : forall x y,
 finite x -> finite y -> Rabs (r32 x) <= 16777216 -> Rabs (r32 y) <= 1 ->
 Rabs (r32 (Float32.add x y) - (r32 x+r32 y)) <= 2 := add_absorption_error_two.
Print Assumptions goal_absorption.
Print Assumptions goal_upper.
Print Assumptions goal_lower.
Print Assumptions goal_error_two.
