From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cexec.
From PprzTrigRelationSupport Require Import PureEval PlainCore Total InitState InitProtocol PackedPrefix.
From PprzTrigInitSupport Require Import Compound EncoderBody.
Open Scope Z_scope.
Definition short_slot(e:env)(m:mem)(id:ident):Prop :=exists b,
 e!id=Some(b,tshort) /\Mem.range_perm m b 0 2 Cur Writable.
Lemma core_short_slot : forall e base input buffer m id,
 protocol_core e base input buffer m ->In id init_local_ids ->short_slot e m id.
Proof.
 intros e base input buffer m id[S F R H]IN.
 destruct(sh_cover _ _ _ _ S id IN)as[b B]. exists b;split;[exact B|]. intros i I.
 eapply Mem.perm_implies;[apply(F id b B);exact I|constructor].
Qed.
Lemma short_store_slot : forall e m id z,
 short_slot e m id->0<=z<=16383 ->exists b mf,
 e!id=Some(b,tshort) /\Mem.store Mint16signed m b 0(Vint(Int.repr z))=Some mf /\short_cell e mf id z.
Proof.
 intros e m id z[b[B R]]Z.
 destruct(Mem.valid_access_store m Mint16signed b 0(Vint(Int.repr z)))as[mf S].
 - split;[exact R|]. change(2|0);exists 0;lia.
 - exists b,mf;split;[exact B|]. split;[exact S|]. exists b;split;[exact B|]. split.
   + pose proof(@Mem.load_store_same Mint16signed m b 0(Vint(Int.repr z))mf S)as L.
     cbn [Val.load_result]in L. rewrite nonnegative_short_cast in L by exact Z;exact L.
   + intros i I. eapply Mem.perm_store_1;[exact S|apply R;exact I].
Qed.
Lemma cast_to_short : forall m ty z,0<=z<=16383 ->
 (ty=tshort \/ty=tint \/ty=tuchar)->sem_cast(Vint(Int.repr z))ty tshort m=Some(Vint(Int.repr z)).
Proof.
 intros m ty z Z [-> | [-> | ->]];
 change(Some(Vint(Int.sign_ext 16(Int.repr z)))=Some(Vint(Int.repr z)));
 rewrite nonnegative_short_cast by exact Z;reflexivity.
Qed.
Lemma short_assignment_atom : forall ge e m mf id b rhs z,
 e!id=Some(b,tshort) ->pure_rval ge e m rhs=Some(Vint(Int.repr z)) ->
 (typeof rhs=tshort \/typeof rhs=tint \/typeof rhs=tuchar)->0<=z<=16383 ->
 Mem.store Mint16signed m b 0(Vint(Int.repr z))=Some mf ->
 atom_eval ge e m(Eassign(Evar id tshort)rhs tshort)=Some(Vint(Int.repr z),mf).
Proof.
 intros ge e m mf id b rhs z B R TY Z S. unfold atom_eval;cbn [typeof]. rewrite dec_eq_true.
 cbn [pure_lval]. rewrite B,dec_eq_true,R.
 rewrite(cast_to_short m(typeof rhs)z Z TY).
 cbn [Cexec.do_assign_loc tshort type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk].
 rewrite Ptrofs.unsigned_zero. rewrite zle_true by(change(2<=18446744073709551616);lia).
 rewrite S;reflexivity.
Qed.
Theorem short_assignment_action : forall ge Q f k e base input buffer p m id rhs z,
 protocol_core e base input buffer m ->packed_prefix p m buffer ->In id init_local_ids ->
 Cstrategy.simple rhs=true ->core_expr rhs=true ->pure_rval ge e m rhs=Some(Vint(Int.repr z)) ->
 (typeof rhs=tshort \/typeof rhs=tint \/typeof rhs=tuchar)->0<=z<=16383 ->
 (forall mf,protocol_core e base input buffer mf /\packed_prefix p mf buffer /\short_cell e mf id z /\
   (forall id' old,id'<>id->short_cell e m id' old->short_cell e mf id' old)->
   Total.total ge Q(State f Sskip k e mf)) ->
 Total.total ge Q(State f(Sdo(Eassign(Evar id tshort)rhs tshort))k e m).
Proof.
 intros ge Q f k e base input buffer p m id rhs z C P IN SIMPLE CORE READ TY Z END.
 destruct(short_store_slot e m id z(core_short_slot _ _ _ _ _ _ C IN)Z)as[b[mf[B[S NEW]]]].
 eapply do_atom_total with(v:=Vint(Int.repr z))(mf:=mf).
 - cbn [atom_expr Cstrategy.simple];rewrite SIMPLE;reflexivity.
 - cbn [core_expr];rewrite CORE;reflexivity.
 - eapply short_assignment_atom;eauto.
 - apply END;split.
   + eapply protocol_core_local_store;eauto.
   + split;[eapply packed_prefix_local_store;[exact P|eapply shape_local_not_buffer;[exact(pc_shape _ _ _ _ _ C)|exact B]|exact S]|].
     split;[exact NEW|]. intros id' old NE CELL.
     eapply short_cell_store_other;[exact CELL|exact S|]. intros b' B'.
     eapply sh_injective;[exact(pc_shape _ _ _ _ _ C)|exact B'|exact B|exact NE].
Qed.

Lemma small_int_add : forall v d,0<=v<=16383 ->0<=d<=7 ->
 Int.add(Int.repr v)(Int.repr d)=Int.repr(v+d).
Proof.
 intros v d V D. unfold Int.add.
 rewrite(Int.unsigned_repr v)by(change(0<=v<=4294967295);lia).
 rewrite(Int.unsigned_repr d)by(change(0<=d<=4294967295);lia). reflexivity.
Qed.
Lemma short_addition_atom : forall ge e m mf id b rhs v d,
 e!id=Some(b,tshort) ->Mem.load Mint16signed m b 0=Some(Vint(Int.repr v)) ->
 pure_rval ge e m rhs=Some(Vint(Int.repr d)) ->typeof rhs=tint ->
 0<=v<=16383 ->0<=d<=7 ->0<=v+d<=16383 ->
 Mem.store Mint16signed m b 0(Vint(Int.repr(v+d)))=Some mf ->
 atom_eval ge e m(Eassignop Oadd(Evar id tshort)rhs tint tshort)=Some(Vint(Int.repr(v+d)),mf).
Proof.
 intros ge e m mf id b rhs v d B L R TY V D SUM S.
 unfold atom_eval;cbn [typeof]. rewrite dec_eq_true.
 cbn [pure_lval]. rewrite B,dec_eq_true,R,TY.
 cbn [Cexec.do_deref_loc tshort type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv size_chunk].
 rewrite Ptrofs.unsigned_zero. rewrite zle_true by(change(2<=18446744073709551616);lia). rewrite L.
 cbv beta iota zeta delta[sem_binary_operation sem_add sem_binarith classify_binarith binarith_type classify_add
 typeconv sem_cast classify_cast cast_int_int remove_attributes change_attributes tshort tint Archi.ptr64].
 rewrite small_int_add by assumption.
 rewrite nonnegative_short_cast by exact SUM.
 cbn [Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk].
 rewrite Ptrofs.unsigned_zero. rewrite zle_true by(change(2<=18446744073709551616);lia).
 rewrite S;reflexivity.
Qed.
Theorem short_addition_action : forall ge Q f k e base input buffer p m id rhs v d,
 protocol_core e base input buffer m ->packed_prefix p m buffer ->short_cell e m id v ->
 Cstrategy.simple rhs=true ->core_expr rhs=true ->pure_rval ge e m rhs=Some(Vint(Int.repr d)) ->typeof rhs=tint ->
 0<=v<=16383 ->0<=d<=7 ->0<=v+d<=16383 ->
 (forall mf,protocol_core e base input buffer mf /\packed_prefix p mf buffer /\short_cell e mf id(v+d) /\
   (forall id' old,id'<>id->short_cell e m id' old->short_cell e mf id' old)->
   Total.total ge Q(State f Sskip k e mf)) ->
 Total.total ge Q(State f(Sdo(Eassignop Oadd(Evar id tshort)rhs tint tshort))k e m).
Proof.
 intros ge Q f k e base input buffer p m id rhs v d C P CELL SIMPLE CORE READ TY V D SUM END.
 destruct CELL as[b[B[L W]]].
 destruct(Mem.valid_access_store m Mint16signed b 0(Vint(Int.repr(v+d))))as[mf S].
 { split;[exact W|]. change(2|0);exists 0;lia. }
 eapply do_atom_total with(v:=Vint(Int.repr(v+d)))(mf:=mf).
 - cbn [atom_expr Cstrategy.simple];rewrite SIMPLE;reflexivity.
 - cbn [core_expr];rewrite CORE;reflexivity.
 - eapply short_addition_atom;eauto.
 - apply END;split.
   + eapply protocol_core_local_store;eauto.
   + split;[eapply packed_prefix_local_store;[exact P|eapply shape_local_not_buffer;[exact(pc_shape _ _ _ _ _ C)|exact B]|exact S]|].
     split.
     * exists b;split;[exact B|]. split.
       -- pose proof(@Mem.load_store_same Mint16signed m b 0(Vint(Int.repr(v+d)))mf S)as E.
          cbn [Val.load_result]in E;rewrite nonnegative_short_cast in E by exact SUM;exact E.
       -- intros i I;eapply Mem.perm_store_1;[exact S|apply W;exact I].
     * intros id' old NE OTHER. eapply short_cell_store_other;[exact OTHER|exact S|]. intros b' B'.
       eapply sh_injective;[exact(pc_shape _ _ _ _ _ C)|exact B'|exact B|exact NE].
Qed.
