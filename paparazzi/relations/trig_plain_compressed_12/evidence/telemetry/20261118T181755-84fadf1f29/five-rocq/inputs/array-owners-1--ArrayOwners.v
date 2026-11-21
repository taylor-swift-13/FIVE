From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Csyntax Csem Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import InitialMemory ClosedCalls.
From PprzTrigCBMC Require Import ArrayBases ArrayOrigins ArrayContexts ArrayState NoShadow.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigLow.Execution.ge PprzTrigPlain.Execution.ge.
Definition buffer_descriptor:list(ident*Z):=[(PprzTrigLow.Source._data_buf_12,9651)].
Definition rom_descriptor:list(ident*Z):=[(PprzTrigLow.Source._pprz_trig_int_compr,1690)].
Definition plain_descriptor:list(ident*Z):=[(PprzTrigPlain.Source._pprz_trig_int,6434)].
Inductive low_array_owner:function->list(ident*Z)->Prop:=
|owner_sin:low_array_owner PprzTrigLow.Source.f_pprz_itrig_sin []
|owner_dispatcher:low_array_owner PprzTrigLow.Source.f_pprz_trig_int_f []
|owner_decoder:low_array_owner PprzTrigLow.Source.f_pprz_trig_int_12 buffer_descriptor
|owner_init:low_array_owner PprzTrigLow.Source.f_pprz_trig_int_init []
|owner_nibble:low_array_owner PprzTrigLow.Source.f_get_nibble rom_descriptor
|owner_encoder:low_array_owner PprzTrigLow.Source.f_table_encode_12 buffer_descriptor.
Definition plain_array_owner(f:function)(ids:list(ident*Z)):Prop:=f=PprzTrigPlain.Source.f_pprz_itrig_sin/\ids=plain_descriptor.
Lemma low_allowed_owned:forall f,ClosedCalls.actual_allowed f->exists ids,low_array_owner f ids.
Proof. intros f[EQ|[EQ|[EQ|[EQ|[EQ|[EQ|[]]]]]]];subst;eexists;constructor. Qed.
Lemma plain_allowed_owned:forall f,NoShadow.plain_allowed f->exists ids,plain_array_owner f ids.
Proof. intros f EQ;exists plain_descriptor;split;[exact EQ|reflexivity]. Qed.
Lemma low_array_locals:forall f ids,low_array_owner f ids->Forall(fun p=>~In(fst p)(map fst ids))(fn_params f++fn_vars f).
Proof. intros f ids OWN;inversion OWN;subst;repeat apply Forall_cons;try constructor;vm_compute;intuition discriminate. Qed.
Lemma plain_array_locals:forall f ids,plain_array_owner f ids->Forall(fun p=>~In(fst p)(map fst ids))(fn_params f++fn_vars f).
Proof. intros f ids[EQ ID];subst;repeat apply Forall_cons;try constructor;vm_compute;intuition discriminate. Qed.
Lemma low_buffer_source_base:array_base PprzTrigLow.Execution.ge tuchar buffer_descriptor
 (Evalof(Evar PprzTrigLow.Source._data_buf_12(tarray tuchar 9651))(tarray tuchar 9651))9651.
Proof. destruct buffer_symbol_info_exists as[b[SYM VAR]];eapply base_name;split;[left;reflexivity|exact SYM]. Qed.
Lemma low_rom_source_base:array_base PprzTrigLow.Execution.ge tuchar rom_descriptor
 (Evalof(Evar PprzTrigLow.Source._pprz_trig_int_compr(tarray tuchar 1690))(tarray tuchar 1690))1690.
Proof. destruct compressed_symbol_info_exists as[b[SYM VAR]];eapply base_name;split;[left;reflexivity|exact SYM]. Qed.
Lemma plain_table_source_base:array_base PprzTrigPlain.Execution.ge tshort plain_descriptor
 (Evalof(Evar PprzTrigPlain.Source._pprz_trig_int(tarray tshort 6434))(tarray tshort 6434))6434.
Proof. destruct plain_symbol_info_exists as[b[SYM VAR]];eapply base_name;split;[left;reflexivity|exact SYM]. Qed.
Lemma low_array_bodies:forall f ids,low_array_owner f ids->array_stmt PprzTrigLow.Execution.ge tuchar ids(fn_body f).
Proof.
 intros f ids OWN;inversion OWN;subst;
 cbn[PprzTrigLow.Source.f_pprz_itrig_sin PprzTrigLow.Source.f_pprz_trig_int_f PprzTrigLow.Source.f_pprz_trig_int_12
 PprzTrigLow.Source.f_pprz_trig_int_init PprzTrigLow.Source.f_get_nibble PprzTrigLow.Source.f_table_encode_12
 fn_body array_stmt array_expr array_exprlist array_head typeof].
 all:repeat split;try exact I;try reflexivity.
 all:try(solve[intros EQ;discriminate EQ]).
 all:try(solve[intros;eauto 8 using lvalue_deref,pointer_add,low_buffer_source_base,low_rom_source_base]).
 all:match goal with |-?G=>idtac "LOW-BODY-LEFT" G end.
Qed.
Lemma plain_array_bodies:forall f ids,plain_array_owner f ids->array_stmt PprzTrigPlain.Execution.ge tshort ids(fn_body f).
Proof.
 intros f ids[EQ ID];subst;
 cbn[PprzTrigPlain.Source.f_pprz_itrig_sin fn_body array_stmt array_expr array_exprlist array_head typeof].
 all:repeat split;try exact I;try reflexivity.
 all:try(solve[intros EQ;discriminate EQ]).
 all:try(solve[intros;eauto 8 using lvalue_deref,pointer_add,plain_table_source_base]).
 all:match goal with |-?G=>idtac "PLAIN-BODY-LEFT" G end.
Qed.
