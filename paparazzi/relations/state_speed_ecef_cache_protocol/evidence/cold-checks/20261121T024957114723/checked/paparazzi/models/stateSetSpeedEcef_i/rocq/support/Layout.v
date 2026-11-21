From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors AST Integers Values Memory Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation.
From StateSpeedSetterSupport Require Import MemoryFacts.
From StateSpeedSetEcefISupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
Definition cenv:=prog_comp_env S.prog.
Lemma cenv_built:build_composite_env S.composites=OK cenv.
Proof. exact(prog_comp_env_eq S.prog). Qed.
Lemma ge_cenv:genv_cenv ge=cenv.
Proof.
 unfold ge,E.ge,Csem.globalenv,cenv.
 cbv beta iota zeta delta[genv_cenv];reflexivity.
Qed.
Definition layout:=field_layout(genv_cenv ge).
Lemma filter_layout:layout S._State S._speed_input_filter=Some(282,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Lemma status_layout:layout S._State S._speed_status=Some(280,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Lemma vector_layout:layout S._State S._ecef_speed_i=Some(284,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Lemma axis_layout:layout S._EcefCoor_i S._x=Some(0,Full) /\
 layout S._EcefCoor_i S._y=Some(4,Full) /\layout S._EcefCoor_i S._z=Some(8,Full).
Proof. repeat split;unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Local Opaque ge E.ge.

Lemma field_address:forall e m base sid attrs axis ty b start delta,
 typeof base=Tstruct sid attrs ->
 pure_rval ge e m base=Some(Vptr b(Ptrofs.repr start)) ->
 layout sid axis=Some(delta,Full) ->
 pure_lval ge e m(Efield base axis ty)=Some(b,Ptrofs.repr(start+delta),Full).
Proof.
 intros e m base sid attrs axis ty b start delta TY BASE LAYOUT.
 eapply struct_field_layout;[exact TY|exact BASE|].
 exact LAYOUT.
Qed.
Lemma global_state_address:forall e m sb,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 pure_rval ge e m state_address=Some(Vptr sb Ptrofs.zero).
Proof.
 intros e m sb NONE SYMBOL;apply global_struct_address;assumption.
Qed.
Lemma state_field_address:forall e m sb axis ty delta,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 layout S._State axis=Some(delta,Full) ->
 pure_lval ge e m(Efield state_address axis ty)=Some(sb,Ptrofs.repr delta,Full).
Proof.
 intros e m sb axis ty delta NONE SYMBOL LAYOUT.
 apply(field_address e m state_address S._State noattr axis ty sb 0 delta);
 [reflexivity|apply global_state_address;assumption|exact LAYOUT].
Qed.
Lemma filter_value:forall e m sb,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 Mem.load Mint16unsigned m sb 282=Some(Vint(Int.repr 65535)) ->
 pure_rval ge e m filter_read=Some(Vint(Int.repr 65535)).
Proof.
 intros e m sb NONE SYMBOL LOAD;unfold filter_read.
 eapply pure_scalar;[reflexivity|reflexivity|reflexivity| | | |exact LOAD].
 - apply state_field_address;[exact NONE|exact SYMBOL|exact filter_layout].
 - change(0<=282<=18446744073709551615);lia.
 - change(282+2<=18446744073709551616);lia.
Qed.
Lemma accepted_tests:forall e m sb,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 Mem.load Mint16unsigned m sb 282=Some(Vint(Int.repr 65535)) ->
 pure_rval ge e m first_test=Some(Vint Int.zero) /\
 pure_rval ge e m second_test=Some(Vint Int.one).
Proof.
 intros e m sb NONE SYMBOL LOAD;pose proof(filter_value e m sb NONE SYMBOL LOAD)as FILTER.
 unfold first_test,second_test;split;eapply pure_binary;[exact FILTER|reflexivity|reflexivity|exact FILTER|reflexivity|reflexivity].
Qed.
Lemma destination_base:forall e m sb,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 pure_rval ge e m dst_base=Some(Vptr sb(Ptrofs.repr destination_offset)).
Proof.
 intros e m sb NONE SYMBOL;apply struct_copy_value;[reflexivity|].
 exact(state_field_address e m sb S._ecef_speed_i vtype 284 NONE SYMBOL vector_layout).
Qed.
Lemma destination_axis:forall e m sb axis delta,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 layout S._EcefCoor_i axis=Some(delta,Full) ->
 pure_lval ge e m(Efield dst_base axis tint)=Some(sb,Ptrofs.repr(destination_offset+delta),Full).
Proof.
 intros;eapply field_address;[reflexivity|apply destination_base;assumption|assumption].
Qed.
Lemma parameter_pointer:forall e m bp src,
 e!S._ecef_speed=Some(bp,tptr vtype) ->Mem.load Mptr m bp 0=Some(Vptr src Ptrofs.zero) ->
 pure_rval ge e m(Evalof(Evar S._ecef_speed(tptr vtype))(tptr vtype))=Some(Vptr src Ptrofs.zero).
Proof.
 intros e m bp src LOOK LOAD;eapply pure_scalar;[reflexivity|reflexivity|reflexivity| | | |exact LOAD].
 - apply local_variable_lval;exact LOOK.
 - change(0<=0<=18446744073709551615);lia.
 - change(0+8<=18446744073709551616);lia.
Qed.
Lemma input_address:forall e m bp src,
 e!S._ecef_speed=Some(bp,tptr vtype) ->Mem.load Mptr m bp 0=Some(Vptr src Ptrofs.zero) ->
 pure_rval ge e m input_base=Some(Vptr src Ptrofs.zero).
Proof.
 intros e m bp src LOOK LOAD;apply struct_dereference_value;apply parameter_pointer with(bp:=bp);assumption.
Qed.
Lemma input_axis_value:forall e m bp src axis delta v,
 e!S._ecef_speed=Some(bp,tptr vtype) ->Mem.load Mptr m bp 0=Some(Vptr src Ptrofs.zero) ->
 layout S._EcefCoor_i axis=Some(delta,Full) ->0<=delta<=8 ->
 Mem.load Mint32 m src delta=Some(Vint v) ->
 pure_rval ge e m(Evalof(Efield input_base axis tint)tint)=Some(Vint v).
Proof.
 intros e m bp src axis delta v LOOK LOAD LAYOUT RANGE WORD.
 eapply pure_scalar;[reflexivity|reflexivity|reflexivity| | | |exact WORD].
 - apply(field_address e m input_base S._EcefCoor_i noattr axis tint src 0 delta);
   [reflexivity|apply input_address with(bp:=bp);assumption|exact LAYOUT].
 - change(0<=delta<=18446744073709551615);lia.
 - change(delta+4<=18446744073709551616);lia.
Qed.
Print Assumptions accepted_tests.
Print Assumptions input_axis_value.
