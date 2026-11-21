From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation.
From StateSpeedSetterSupport Require Import MemoryFacts.
From StateSpeedGetterSupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
Definition layout:=field_layout(genv_cenv ge).
Lemma status_layout:layout S._State S._speed_status=Some(280,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Lemma ned_layout:layout S._State S._ned_speed_i=Some(296,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Lemma float_layout:layout S._State S._ecef_speed_f=Some(328,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];reflexivity. Qed.
Lemma ned_axes:layout S._NedCoor_i S._x=Some(0,Full) /\layout S._NedCoor_i S._y=Some(4,Full) /\layout S._NedCoor_i S._z=Some(8,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];repeat split;reflexivity. Qed.
Lemma float_axes:layout S._EcefCoor_f S._x=Some(0,Full) /\layout S._EcefCoor_f S._y=Some(4,Full) /\layout S._EcefCoor_f S._z=Some(8,Full).
Proof. unfold layout,ge,E.ge,Csem.globalenv;cbv beta iota zeta delta[genv_cenv];repeat split;reflexivity. Qed.
Local Opaque ge E.ge.
Lemma field_address:forall e m base sid attrs axis ty b start delta,
 typeof base=Tstruct sid attrs->pure_rval ge e m base=Some(Vptr b(Ptrofs.repr start))->
 layout sid axis=Some(delta,Full)->pure_lval ge e m(Efield base axis ty)=Some(b,Ptrofs.repr(start+delta),Full).
Proof. intros;eapply struct_field_layout;eauto. Qed.
Lemma global_state_address:forall e m sb,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->pure_rval ge e m state_address=Some(Vptr sb Ptrofs.zero).
Proof. intros;apply global_struct_address;assumption. Qed.
Lemma state_field_address:forall e m sb axis ty delta,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->layout S._State axis=Some(delta,Full)->
 pure_lval ge e m(Efield state_address axis ty)=Some(sb,Ptrofs.repr delta,Full).
Proof.
 intros e m sb axis ty delta NONE SYM LAYOUT;replace delta with(0+delta)at 2 by lia.
 eapply field_address;[reflexivity|apply global_state_address;assumption|exact LAYOUT].
Qed.
Lemma vector_base_address:forall e m sb sid field start,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->layout S._State field=Some(start,Full)->
 pure_rval ge e m(vector_address sid field)=Some(Vptr sb(Ptrofs.repr start)).
Proof. intros;eapply struct_copy_value;[reflexivity|apply state_field_address;assumption]. Qed.
Lemma ned_word_value:forall e m sb axis delta i,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->layout S._NedCoor_i axis=Some(delta,Full)->0<=delta<=8->
 Mem.load Mint32 m sb(296+delta)=Some(Vint i)->pure_rval ge e m(ned_word axis)=Some(Vint i).
Proof.
 intros e m sb axis delta i NONE SYM AX RANGE LOAD;unfold ned_word.
 eapply pure_scalar;[reflexivity|reflexivity|reflexivity| | | |exact LOAD].
 - eapply field_address;[reflexivity|apply vector_base_address;[exact NONE|exact SYM|exact ned_layout]|exact AX].
 - change(0<=296+delta<=18446744073709551615);lia.
 - change(296+delta+4<=18446744073709551616);lia.
Qed.
Lemma float_axis_address:forall e m sb axis delta,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->layout S._EcefCoor_f axis=Some(delta,Full)->
 pure_lval ge e m(float_lvalue axis)=Some(sb,Ptrofs.repr(328+delta),Full).
Proof.
 intros e m sb axis delta NONE SYM AX;unfold float_lvalue.
 eapply field_address;[reflexivity|apply vector_base_address;[exact NONE|exact SYM|exact float_layout]|exact AX].
Qed.
Lemma status_value:forall e m sb i,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint i)->
 pure_rval ge e m status_read=Some(Vint i).
Proof.
 intros e m sb i NONE SYM LOAD;unfold status_read.
 eapply pure_scalar;[reflexivity|reflexivity|reflexivity| | | |exact LOAD].
 - apply state_field_address;[exact NONE|exact SYM|exact status_layout].
 - change(0<=280<=18446744073709551615);lia.
 - change(280+2<=18446744073709551616);lia.
Qed.
Lemma status_one_tests:forall e m sb,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 pure_rval ge e m(status_test 5)=Some(Vint Int.zero) /\pure_rval ge e m(status_test 0)=Some(Vint Int.one).
Proof.
 intros e m sb NONE SYM LOAD;pose proof(status_value e m sb Int.one NONE SYM LOAD)as WORD.
 unfold status_test;split;eapply pure_binary;[eapply pure_binary;[exact WORD|reflexivity|reflexivity]|reflexivity|reflexivity|eapply pure_binary;[exact WORD|reflexivity|reflexivity]|reflexivity|reflexivity].
Qed.
Lemma getter_condition_value:forall e m sb,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 pure_rval ge e m getter_condition=Some(Vint Int.one).
Proof.
 intros e m sb NONE SYM LOAD;pose proof(proj1(status_one_tests e m sb NONE SYM LOAD))as TEST.
 change((match pure_rval ge e m(status_test 5)with Some v=>sem_unary_operation Onotbool v tint m|None=>None end)=Some(Vint Int.one));rewrite TEST;reflexivity.
Qed.
Lemma denominator_value:forall e m,pure_rval ge e m denominator=Some(Vint(Int.repr 524288)).
Proof. reflexivity. Qed.
Lemma conversion_value:forall e m sb axis delta i,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->layout S._NedCoor_i axis=Some(delta,Full)->0<=delta<=8->
 Mem.load Mint32 m sb(296+delta)=Some(Vint i)->pure_rval ge e m(conversion axis)=Some(Vsingle(decode i)).
Proof.
 intros e m sb axis delta i NONE SYM AX RANGE LOAD.
 pose proof(ned_word_value e m sb axis delta i NONE SYM AX RANGE LOAD)as WORD.
 unfold conversion;eapply pure_binary;[|apply denominator_value|reflexivity].
 change((match pure_rval ge e m(ned_word axis)with Some v=>sem_cast v tint tfloat m|None=>None end)=Some(Vsingle(Float32.of_int i))).
 rewrite WORD;reflexivity.
Qed.
Print Assumptions conversion_value.
Print Assumptions status_one_tests.
