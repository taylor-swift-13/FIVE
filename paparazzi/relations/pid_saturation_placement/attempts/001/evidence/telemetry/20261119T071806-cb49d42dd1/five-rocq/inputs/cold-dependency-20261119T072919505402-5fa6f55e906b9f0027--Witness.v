From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import InputSemantics.
From PidMeasurementProblem Require Import Spec.
From PidAlternatingProblem Require Import Spec.
From PidAlternatingAttempt001 Require Import Witness.
From PidInputOrderAttempt001 Require Import Proof.
From PidSaturationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Module N:=PidSaturationProblem.Spec.
Local Opaque E.ge.

(** This is an initial-memory construction for each legal signed integral.
    It does not assert reachability of that integral from a reset history. *)
Theorem witness_input_exists : forall old:Z,
 -100000000<=old<=100000000 ->
 exists gh ret m,N.CycleInput P._x gh ret N.witness_gains m(N.witness_sample old).
Proof.
 intros old RANGE.
 destruct(initial_private_writable_input_exists 1280 100 0
   ltac:(unfold Parameters;lia))as(gh&ret&base&INPUT&WG&PRIVATE).
 destruct INPUT as(GOOD&RX&RY&PX&PY&AXES&KP&KD&KI&KV&KA&HEAD&IX&IY).
 destruct(actual_global_variable_binding P._guidance_pid_trim_att_integrator
   P.v_guidance_pid_trim_att_integrator ltac:(vm_compute;reflexivity))as[bi[SI VI]].
 assert(WR:writable_controller_globals base).
 { destruct GOOD as[LEG _];unfold InputGoodLegacy in LEG;tauto. }
 destruct(WR P._guidance_pid_trim_att_integrator ltac:(cbn;auto))
   as[wp[gv[SY[VA RP]]]].
 rewrite SI in SY;injection SY as EQ;subst wp.
 rewrite VI in VA;injection VA as EQ;subst gv.
 change(Mem.range_perm base bi 0 8 Cur Writable)in RP.
 assert(ACCESS:Mem.valid_access base Mint32 bi 0 Writable).
 { split.
   - intros ofs R;apply RP;cbn in R;lia.
   - change(4|0);exists 0;reflexivity. }
 destruct(Mem.valid_access_store base Mint32 bi 0(Vint(Int.repr old))ACCESS)
   as[m STORE].
 assert(BOUND:-100000000<=Int.signed(Int.repr old)<=100000000).
 { rewrite Int.signed_repr;[exact RANGE|change(-2147483648<=old<=2147483647);lia]. }
 pose proof(inputgood_store_integral_x base gh ret bi m(Int.repr old)
   GOOD SI VI BOUND STORE)as GOODF.
 assert(GI:gh<>bi).
 { intro EQ;apply(proj1(PRIVATE bi _ VI));symmetry;exact EQ. }
 assert(PATH:forall ch ty path v,load_path ch base gh ty path=Some v ->
   load_path ch m gh ty path=Some v).
 { intros ch ty path v LOAD;unfold load_path in LOAD|-*.
   destruct(path_info ty path)as[[ft ofs]|]eqn:PI in LOAD|-*;try discriminate LOAD.
   erewrite Mem.load_store_other;[exact LOAD|exact STORE|left;exact GI]. }
 assert(GLOBAL:forall ch id ty path v,
   id<>P._guidance_pid_trim_att_integrator ->load_global ch base id ty path=Some v ->
   load_global ch m id ty path=Some v).
 { intros ch id ty path v NE LOAD;unfold load_global,load_path in LOAD|-*.
   destruct(Genv.find_symbol E.ge id)as[b|]eqn:SYM in LOAD|-*;try discriminate LOAD.
   destruct(path_info ty path)as[[ft ofs]|]eqn:PI in LOAD|-*;try discriminate LOAD.
   erewrite Mem.load_store_other;[exact LOAD|exact STORE|left].
   eapply Genv.global_addresses_distinct;[exact NE|exact SYM|exact SI]. }
 destruct(AXES P._x ltac:(cbn;auto))as(SPEED&ACCEL&VEL).
 exists gh,ret,m;unfold N.CycleInput;split;[exact GOODF|].
 unfold ReadAxis;cbn [N.witness_gains N.witness_sample].
 refine(conj _ (conj _ (conj _ (conj _ (conj _ (conj _
   (conj _ (conj _ (conj _ (conj _ _)))))))))).
 - eapply GLOBAL with(id:=P._guidance_pid);[discriminate|exact KP].
 - eapply GLOBAL with(id:=P._guidance_pid);[discriminate|exact KD].
 - eapply GLOBAL with(id:=P._guidance_pid);[discriminate|exact KI].
 - eapply GLOBAL with(id:=P._guidance_pid);[discriminate|exact KV].
 - eapply GLOBAL with(id:=P._guidance_pid);[discriminate|exact KA].
 - apply PATH;exact RX.
 - eapply GLOBAL with(id:=P._state);[discriminate|exact PX].
 - apply PATH;exact SPEED.
 - eapply GLOBAL with(id:=P._state);[discriminate|exact VEL].
 - apply PATH;exact ACCEL.
 - unfold load_global;rewrite SI.
   change(Mem.load Mint32 m bi 0=Some(Vint(Int.repr old))).
   exact(Mem.load_store_same _ _ _ _ _ _ STORE).
Qed.
Print Assumptions witness_input_exists.
