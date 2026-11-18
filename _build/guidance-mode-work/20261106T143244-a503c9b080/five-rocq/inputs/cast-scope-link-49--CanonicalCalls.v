From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry SaturationBody SymbolicPrefix.
From FiveGuidanceAllOrder Require Import FactorShell PureDenotation.
From FiveGuidanceSoftwareProof Require Import GuardTrace.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceCbmcAdapters Require Import SpeedPrelimit AccelPrelimit NumericGuards.
Import ListNotations.
Local Open Scope Z_scope.
Definition bits32 (n:Z):float32:=Float32.of_bits(Int.repr n).
Definition CanonicalControls(s:state):Prop:=
 speed_x s=bits32 1065353216 /\ speed_y s=bits32 0 /\
 accel_x s=bits32 1073741824 /\ accel_y s=bits32 0 /\
 inv_tau s=bits32 1073741824 /\ dt s=bits32 989855744.
Definition speed_command(taken:bool):vector:=vec
 (bits32(if taken then 1086324736 else 1065353216))(bits32 0).
Definition accel_command(taken:bool):vector:=vec
 (if taken then canonical_sat_x else bits32 3154116608)canonical_negative_zero.
Definition canonical_delta:int64:=Int64.repr 268435456.
Lemma canonical_increments:forall s,CanonicalControls s ->
 pos_increment(speed_x s)(dt s)=Some canonical_delta /\
 pos_increment(speed_y s)(dt s)=Some Int64.zero.
Proof.
 intros s[SX[SY[AX[AY[INV DT]]]]];rewrite SX,SY,DT;vm_compute;split;reflexivity.
Qed.
Definition reference_raw(s:state)(sp:vector):vector:=vec
 (Float32.mul(Float32.sub(Float32.add(speed_x s)(Float32.mul(accel_x s)(dt s)))(vx sp))(Float32.neg(inv_tau s)))
 (Float32.mul(Float32.sub(Float32.add(speed_y s)(Float32.mul(accel_y s)(dt s)))(vy sp))(Float32.neg(inv_tau s))).
Lemma canonical_raw_after_integration:forall s taken,CanonicalControls s ->
 raw_speed_accel(integrated s canonical_delta Int64.zero)(speed_command taken)=accel_command taken.
Proof.
 intros s taken[SX[SY[AX[AY[INV DT]]]]].
 change(reference_raw s(speed_command taken)=accel_command taken).
 unfold reference_raw;rewrite SX,SY,AX,AY,INV,DT.
 destruct taken;apply(f_equal2 vec);apply float32_bits_inj;vm_compute;reflexivity.
Qed.
Lemma canonical_raw_from_actual_integrate:forall s si taken,
 CanonicalControls s ->integrate s=Some si ->
 raw_speed_accel si(speed_command taken)=accel_command taken.
Proof.
 intros s si taken CONTROL INTEGRATED.
 destruct(canonical_increments s CONTROL)as[X Y].
 unfold integrate in INTEGRATED;rewrite X,Y in INTEGRATED;injection INTEGRATED as EQ;subst si.
 apply canonical_raw_after_integration;exact CONTROL.
Qed.
Lemma canonical_reference_raw:forall s taken,CanonicalControls s ->
 reference_raw s(speed_command taken)=accel_command taken.
Proof. intros;apply canonical_raw_after_integration;assumption. Qed.
Lemma canonical_norm_and_branch:forall taken,
 saturation_branch fixed_maximum(accel_command taken)=taken /\
 (taken=true ->norm2(accel_command taken)=canonical_sat_norm).
Proof. destruct taken;split.
 - vm_compute;reflexivity.
 - intros _;reflexivity.
 - vm_compute;reflexivity.
 - discriminate.
Qed.
Lemma canonical_reference_norm:forall s,CanonicalControls s ->
 norm2(reference_raw s(speed_command true))=canonical_sat_norm /\
 saturation_branch fixed_maximum(reference_raw s(speed_command false))=false.
Proof.
 intros s CONTROL;rewrite !canonical_reference_raw by exact CONTROL.
 split;[exact(proj2(canonical_norm_and_branch true)eq_refl)|exact(proj1(canonical_norm_and_branch false))].
Qed.
(** The actual factor expression has54 possible partial evaluation shapes.
    Every call state in their certified successor closure uses the norm slot
    value as its sole argument, independent of expression evaluation order. *)
Lemma factor_call_argument:forall e caller leaf k ifactor imax isqrt inorm
 bfactor bmax bsqrt bnorm m maximum norm fd args kc mc,
 FactorShell.pre_or_call e caller leaf k ifactor imax isqrt inorm
 bfactor bmax bsqrt bnorm m maximum norm(Callstate fd args kc mc) ->
 fd=Internal leaf /\ args=[Vsingle norm] /\ mc=m.
Proof.
 intros e caller leaf k ifactor imax isqrt inorm bfactor bmax bsqrt bnorm m maximum norm fd args kc mc
 [[lr[ms[rs[ns H]]]]|[lr[ms H]]].
 - unfold FactorShell.pre_state in H;discriminate.
 - inversion H;auto.
Qed.
Lemma actual_factor_source_shape:forall bfactor bmax bsqrt bnorm maximum norm,
 FactorShell.pre_expr S._factor S._gh_max_accel S._five_sqrtf S._a_norm2
 bfactor bmax bsqrt bnorm maximum norm false Rvar Rvar Rvar =
 match factor_statement with Sdo a=>a|_=>Eval Vundef tfloat end.
Proof. intros;reflexivity. Qed.
Print Assumptions canonical_raw_from_actual_integrate.
Print Assumptions canonical_reference_norm.
Print Assumptions factor_call_argument.

Definition CanonicalSpeedPrefix(taken:bool):Prop:=forall s m bg src o,
 CanonicalControls s ->speed_initial s(speed_command taken)m bg src o ->
 exists si t k mr local global,
 integrate s=Some si /\
 star Csem.step FiveGhSpeed.Execution.ge(FiveGhSpeed.Execution.entry[Vptr src o]m)t
  (Callstate(Internal FiveGhSpeed.Source.f_gh_saturate_accel)[Vptr local Ptrofs.zero]k mr) /\
 argument_repr(accel_command taken)mr local Ptrofs.zero /\
 Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_ref=Some global /\repr si mr global.
Theorem canonical_speed_prefix:forall taken,CanonicalSpeedPrefix taken.
Proof.
 intros taken s m bg src o CONTROL INITIAL.
 destruct(SpeedPrelimit.speed_prelimit_zero s(speed_command taken)m bg src o INITIAL)
 as(si&t&k&mr&local&global&INT&PATH&ARG&SYM&REP).
 rewrite(canonical_raw_from_actual_integrate s si taken CONTROL INT)in ARG.
 exists si,t,k,mr,local,global;auto.
Qed.
Definition CanonicalAccelPrefix(taken:bool):Prop:=forall s m bg src o,
 CanonicalControls s ->accel_initial s(accel_command taken)m bg src o ->
 exists si t k mr local,
 integrate s=Some si /\
 star Csem.step FiveGhAccel.Execution.ge(FiveGhAccel.Execution.entry[Vptr src o]m)t
  (Callstate(Internal FiveGhAccel.Source.f_gh_saturate_accel)[Vptr local Ptrofs.zero]k mr) /\
 argument_repr(accel_command taken)mr local Ptrofs.zero /\repr si mr bg.
Theorem canonical_accel_prefix:forall taken,CanonicalAccelPrefix taken.
Proof. intros taken s m bg src o CONTROL INITIAL;eapply AccelPrelimit.accel_prelimit_exists;exact INITIAL. Qed.
Print Assumptions canonical_speed_prefix.
Print Assumptions canonical_accel_prefix.

Theorem canonical_controls_match_cast_scope:forall s,CanonicalControls s ->NumericGuards.canonical_cast_controls s.
Proof.
 intros s[SX[SY[AX[AY[INV DT]]]]];split;[exact SX|];split;[rewrite SY;reflexivity|exact DT].
Qed.
Print Assumptions canonical_controls_match_cast_scope.
