From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigCBMC Require Import ArrayBases ArrayOrigins ArrayContexts ArrayState GlobalMemory GlobalAccess GlobalSource.
Local Open Scope Z_scope.
(** A ready ORIGINAL source memory operation, in any legal C evaluation context.
    Its target block is an OUTPUT of source provenance, never a known-global
    filtering premise. *)
Inductive ArrayEvent(elem:type)(a:expr)(b:block)(ofs:ptrofs):Prop:=
| event_load:forall C,context RV RV C->a=C(Evalof(Eloc b ofs Full elem)elem)->ArrayEvent elem a b ofs
| event_store:forall C v ty,context RV RV C->a=C(Eassign(Eloc b ofs Full elem)(Eval v ty)elem)->ArrayEvent elem a b ofs
| event_assignop:forall C op v ty tyres,context RV RV C->a=C(Eassignop op(Eloc b ofs Full elem)(Eval v ty)tyres elem)->ArrayEvent elem a b ofs.
Lemma event_lvalue:forall ge elem owner f a k e m b ofs,
 ArrayState.array_state ge elem owner(ExprState f a k e m)->ArrayEvent elem a b ofs ->
 exists ids,owner f ids/\array_lvalue ge elem ids(Eloc b ofs Full elem).
Proof.
 intros ge elem owner f a k e m b ofs[ids[OWN[ENV[EXPR CONT]]]]EVENT.
 exists ids;split;[exact OWN|]. inversion EVENT;subst a;
 pose proof(@ArrayContexts.array_context_hole ge elem ids RV RV C H _ EXPR)as SUB;
 pose proof(ArrayOrigins.array_expr_head ge elem ids _ SUB)as HEAD;
 cbn[ArrayOrigins.array_head]in HEAD.
 - apply HEAD;reflexivity.
 - apply HEAD;reflexivity.
 - apply(proj1 HEAD);reflexivity.
Qed.
Lemma located_array_origin:forall ge elem ids b ofs,
 array_lvalue ge elem ids(Eloc b ofs Full elem)->
 exists id n index,In(id,n)ids/\Genv.find_symbol ge id=Some b/\ofs=Ptrofs.repr(sizeof ge elem*Int.signed index).
Proof.
 intros ge elem ids b ofs H;inversion H;subst.
 unfold ArrayBases.global_array in H0;destruct H0 as[IN SYMBOL].
 do 3 eexists;repeat split;eauto.
Qed.
Lemma event_machine_offset_bound:forall ge initial prefix f a k e m b ofs elem ch bytesize,
 no_error ge initial ->global_state b bytesize initial ->
 (forall p s,star Csem.step ge initial p s->silent_state ge s) ->
 star Csem.step ge initial prefix(ExprState f a k e m) ->ArrayEvent elem a b ofs ->
 access_mode elem=By_value ch ->type_is_volatile elem=false ->0<=Ptrofs.unsigned ofs<bytesize.
Proof.
 intros ge initial prefix f a k e m b ofs elem ch bytesize SAFE BOUND SIL PATH EVENT MODE NV.
 inversion EVENT;subst a.
 - eapply every_reachable_global_load_in_bounds;[exact SAFE|exact BOUND|exact PATH|eapply SIL;exact PATH|exact H|exact MODE|exact NV].
 - eapply every_reachable_global_store_in_bounds;[exact SAFE|exact BOUND|exact PATH|eapply SIL;exact PATH|exact H|exact MODE|exact NV].
 - destruct(every_reachable_assignop_load ge initial prefix f k e m C op b ofs elem v ty tyres ch SAFE PATH(SIL _ _ PATH)H MODE NV)as[old LOAD].
   eapply global_load_range;[exact(global_bounds_reachable ge initial b bytesize prefix _ BOUND PATH)|exact LOAD].
Qed.
Theorem every_array_event_origin_and_bounds:forall ge elem owner initial prefix f a k e m b ofs ch,
 no_error ge initial ->
 (forall p s,star Csem.step ge initial p s->silent_state ge s) ->
 (forall ff ids id n bb,owner ff ids->In(id,n)ids->Genv.find_symbol ge id=Some bb->
 0<sizeof ge elem<=2 /\0<=sizeof ge elem*n<=12868 /\global_state bb(sizeof ge elem*n)initial) ->
 star Csem.step ge initial prefix(ExprState f a k e m) ->
 ArrayState.array_state ge elem owner(ExprState f a k e m) ->ArrayEvent elem a b ofs ->
 access_mode elem=By_value ch ->type_is_volatile elem=false ->
 exists ids id n index,owner f ids/\In(id,n)ids/\Genv.find_symbol ge id=Some b/\
 ofs=Ptrofs.repr(sizeof ge elem*Int.signed index)/\0<=Int.signed index<n.
Proof.
 intros ge elem owner initial prefix f a k e m b ofs ch SAFE SIL GLOBAL PATH ORIGIN EVENT MODE NV.
 destruct(event_lvalue ge elem owner f a k e m b ofs ORIGIN EVENT)as[ids[OWN LV]].
 destruct(located_array_origin ge elem ids b ofs LV)as[id[n[index[IN[SYMBOL OFFSET]]]]].
 destruct(GLOBAL f ids id n b OWN IN SYMBOL)as[SIZE[BYTES BOUND]].
 pose proof(event_machine_offset_bound ge initial prefix f a k e m b ofs elem ch(sizeof ge elem*n)SAFE BOUND SIL PATH EVENT MODE NV)as PTR.
 rewrite OFFSET in PTR.
 assert(SIGNED:0<=sizeof ge elem*Int.signed index<sizeof ge elem*n).
 { eapply signed_offset_nowrap;[|exact BYTES|exact PTR].
   pose proof(Int.signed_range index)as WORD;change(-2147483648<=Int.signed index<=2147483647)in WORD;nia. }
 exists ids,id,n,index;repeat split;try assumption;nia.
Qed.
Print Assumptions every_array_event_origin_and_bounds.
