From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import CoreInputs ClampSemantics.
From CoreCBMC Require Import NumericBounds CanonicalDomain.
Import ListNotations.
Open Scope Z_scope.
Theorem initial_x_axis_bounds:forall m gh ret(D:core_initial_data m gh)r p speed measured,
 InputGood m gh ret ->
 load_path Mint32 m gh gh_type[Source._ref;Source._speed;Source._x]=Some(Vint speed) ->
 axis_bounds(cid_kp _ _ D)(cid_kd _ _ D)(cid_ki _ _ D)(cid_kv _ _ D)(cid_ka _ _ D)
 (clamp_bits(Int.sub r p)(Int.repr 4096))(clamp_bits(Int.sub speed measured)(Int.repr 8388608))
 speed(cid_ax _ _ D)(cid_ix _ _ D).
Proof.
 intros m gh ret D r p speed measured GOOD SPEED.
 eapply inputgood_axis_bounds with(axis:=Source._x);[exact GOOD|cbn;auto|exact SPEED| |].
 - change(Mem.load Mint32 m gh 60=Some(Vint(cid_ax _ _ D)));exact(cid_accel_x _ _ D).
 - unfold load_global;rewrite(cid_i_symbol _ _ D).
   change(Mem.load Mint32 m(cid_i _ _ D)0=Some(Vint(cid_ix _ _ D)));exact(cid_integral_x _ _ D).
Qed.
Theorem initial_y_axis_bounds:forall m gh ret(D:core_initial_data m gh)r p speed measured,
 InputGood m gh ret ->
 load_path Mint32 m gh gh_type[Source._ref;Source._speed;Source._y]=Some(Vint speed) ->
 axis_bounds(cid_kp _ _ D)(cid_kd _ _ D)(cid_ki _ _ D)(cid_kv _ _ D)(cid_ka _ _ D)
 (clamp_bits(Int.sub r p)(Int.repr 4096))(clamp_bits(Int.sub speed measured)(Int.repr 8388608))
 speed(cid_ay _ _ D)(cid_iy _ _ D).
Proof.
 intros m gh ret D r p speed measured GOOD SPEED.
 eapply inputgood_axis_bounds with(axis:=Source._y);[exact GOOD|cbn;auto|exact SPEED| |].
 - change(Mem.load Mint32 m gh 64=Some(Vint(cid_ay _ _ D)));exact(cid_accel_y _ _ D).
 - unfold load_global;rewrite(cid_i_symbol _ _ D).
   change(Mem.load Mint32 m(cid_i _ _ D)4=Some(Vint(cid_iy _ _ D)));exact(cid_integral_y _ _ D).
Qed.
Print Assumptions initial_x_axis_bounds.
