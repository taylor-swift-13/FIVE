From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Ctypes Cop Csyntax Csyntaxdefs.
From FiveGuidanceSoftwareProof Require Import NumericOps.
Definition goal_0 : forall op ty1 ty2 tr lit v1 v2,
 safe_binop op ty1 ty2 tr lit=true ->typed_value ty1 v1 ->typed_value ty2 v2 ->literal_constraint lit v2 ->
 exists result,typed_value tr result /\forall cenv m,sem_binary_operation cenv op v1 ty1 v2 ty2 m=Some result := FiveGuidanceSoftwareProof.NumericOps.safe_binop_total.
Print Assumptions goal_0.
Definition goal_1 : forall op ty tr v,safe_unop op ty tr=true ->typed_value ty v ->
 exists result,typed_value tr result /\forall m,sem_unary_operation op v ty m=Some result := FiveGuidanceSoftwareProof.NumericOps.safe_unop_total.
Print Assumptions goal_1.
Definition goal_2 : forall fromty toty v,
 safe_cast fromty toty=true ->typed_value fromty v ->
 exists result,typed_value toty result /\forall m,sem_cast v fromty toty m=Some result := FiveGuidanceSoftwareProof.NumericOps.safe_cast_total.
Print Assumptions goal_2.
Definition goal_3 : forall ty v,typed_value ty v ->exists b,forall m,bool_val v ty m=Some b := FiveGuidanceSoftwareProof.NumericOps.bool_val_total.
Print Assumptions goal_3.
Definition goal_4 : forall ty1 ty2 v1 v2,
 typed_value ty1 v1 ->typed_value ty2 v2 ->forall op ce1 ce2 m1 m2,
 sem_binary_operation ce1 op v1 ty1 v2 ty2 m1=sem_binary_operation ce2 op v1 ty1 v2 ty2 m2 := FiveGuidanceSoftwareProof.NumericOps.numeric_binop_independent.
Print Assumptions goal_4.
Definition goal_5 : forall ty v,typed_value ty v ->forall op m1 m2,
 sem_unary_operation op v ty m1=sem_unary_operation op v ty m2 := FiveGuidanceSoftwareProof.NumericOps.numeric_unop_independent.
Print Assumptions goal_5.
Definition goal_6 : forall ty k,numeric_kind ty=Some k ->
 (k=K32 /\(ty=tint \/ty=tuint)) \/(k=K64 /\ty=tulong) \/(k=KF32 /\ty=tfloat) := FiveGuidanceSoftwareProof.NumericOps.numeric_kind_cases.
Print Assumptions goal_6.
