From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceSoftwareProof Require Import ValueEvaluator ValueChecker NumericOps LocalMemory FlatStatements ValueSound.
Import ListNotations.
Local Open Scope Z_scope.
Definition local_blocks(e:env)(b:block):Prop:=exists id ty,e!id=Some(b,ty).
Section ASSIGN.
Variables union_id float_field uint_field:ident.
Variable gamma:PTree.t type.
Local Notation place :=(place_of union_id float_field uint_field gamma).
Lemma typed_scalar_properties:forall ty v,typed_value ty v->
 scalar_type ty=true /\ access_mode ty=By_value(slot_chunk ty) /\
 type_is_volatile ty=false /\ Val.load_result(slot_chunk ty)v=v /\slot_typed union_id ty v.
Proof.
 intros ty v TV;destruct(typed_value_cases ty v TV)as[(n&->&->)|[(n&->&->)|[(n&->&->)|(f&->&->)]]];
 repeat split;try reflexivity;unfold slot_typed;rewrite dec_eq_false;try discriminate;exact I.
Qed.
Lemma initialized_set:forall ids rho id ty v,
 initialized_values union_id gamma ids rho ->gamma!id=Some ty ->
 slot_typed union_id ty v ->
 initialized_values union_id gamma(id::ids)(PTree.set id v rho).
Proof.
 intros ids rho id ty v INIT G TV other IN;destruct(peq other id)as[->|NE].
 - exists ty,v;rewrite PTree.gss;auto.
 - simpl in IN;destruct IN as[EQ|IN];[congruence|].
   destruct(INIT other IN)as[t[w[GT[RV ST]]]];exists t,w;rewrite PTree.gso by exact NE;auto.
Qed.
Lemma place_store_properties:forall l p vc le m b,
 place l=Some p ->typed_value(typeof l)vc ->
 le!(place_id p)=Some(b,place_container p) ->locals_writable le m ->
 exists observed ch,
 canonical_value p vc=Some observed /\slot_typed union_id(place_container p)observed /\
 access_mode(typeof l)=By_value ch /\type_is_volatile(typeof l)=false /\
 Mem.valid_access m ch b 0 Writable /\
 (forall mf,Mem.store ch m b 0 vc=Some mf ->
 Mem.load(slot_chunk(place_container p))mf b 0=Some observed).
Proof.
 intros l p vc le m b PLACE TV LOOK W.
 destruct(place_shape union_id float_field uint_field gamma l p PLACE)as[G[TP CASE]].
 pose proof(W _ _ _ LOOK)as VA.
 destruct CASE as[[UN[L SAME]]|[UN[CONT[[FLOAT L]|[UINT L]]]]].
 - rewrite TP,SAME in TV.
   destruct(typed_scalar_properties _ _ TV)as[SC[MODE[NV[RES ST]]]].
   exists vc,(slot_chunk(place_container p));repeat split.
   + unfold canonical_value;rewrite UN;reflexivity.
   + exact ST.
   + rewrite TP,SAME;exact MODE.
   + rewrite TP,SAME;exact NV.
   + exact(proj1 VA).
   + exact(proj2 VA).
   + intros mf STORE;erewrite Mem.load_store_same by exact STORE;rewrite RES;reflexivity.
 - rewrite TP,FLOAT in TV;destruct vc;cbn in TV;try contradiction.
   exists(Vint(Float32.to_bits f)),Mfloat32;repeat split.
   + unfold canonical_value;rewrite UN,FLOAT,dec_eq_true;reflexivity.
   + unfold slot_typed;rewrite CONT,dec_eq_true;exact I.
   + rewrite TP,FLOAT;reflexivity.
   + rewrite TP,FLOAT;reflexivity.
   + rewrite CONT in VA;exact(proj1 VA).
   + rewrite CONT in VA;exact(proj2 VA).
   + intros mf STORE;rewrite CONT;eapply store_single_as_bits;exact STORE.
 - rewrite TP,UINT in TV;destruct vc;cbn in TV;try contradiction.
   exists(Vint i),Mint32;repeat split.
   + unfold canonical_value;rewrite UN,UINT,dec_eq_false;[reflexivity|discriminate].
   + unfold slot_typed;rewrite CONT,dec_eq_true;exact I.
   + rewrite TP,UINT;reflexivity.
   + rewrite TP,UINT;reflexivity.
   + rewrite CONT in VA;exact(proj1 VA).
   + rewrite CONT in VA;exact(proj2 VA).
   + intros mf STORE;rewrite CONT;erewrite Mem.load_store_same by exact STORE;reflexivity.
Qed.
Theorem checked_assign_sound:forall ids l r ty ids' rho ge le m,
 check_assign union_id float_field uint_field gamma ids l r ty=Some ids' ->
 env_matches gamma le ->union_layout union_id float_field uint_field ge ->
 env_separated le ->locals_repr rho le m ->locals_writable le m ->
 initialized_values union_id gamma ids rho ->
 exists rho' mf,
 value_assign union_id float_field uint_field gamma rho l r ty=Some rho' /\
 statement_eval ge le(Sdo(Eassign l r ty))m=Some(Out_normal,mf) /\
 initialized_values union_id gamma ids' rho' /\locals_repr rho' le mf /\
 locals_writable le mf /\access_preserved m mf /\stores_to(local_blocks le)m mf.
Proof.
 intros ids l r ty ids' rho ge le m CHECK ENV LAYOUT SEP REP W INIT.
 unfold check_assign in CHECK.
 destruct(type_eq ty(typeof l))as[EQ|NE];try discriminate;subst ty.
 destruct(place l)as[p|]eqn:PLACE;try discriminate.
 destruct(check_expr union_id float_field uint_field gamma ids r && safe_cast(typeof r)(typeof l))eqn:CHECKED;try discriminate.
 injection CHECK as IDS;subst ids';apply andb_true_iff in CHECKED as[CR CAST].
 destruct(checked_expr_sound union_id float_field uint_field gamma r ids rho ge le m CR ENV LAYOUT REP INIT)as[vr[VR[TR PR]]].
 destruct(safe_cast_total(typeof r)(typeof l)vr CAST TR)as[vc[TC CV]].
 destruct(place_location union_id float_field uint_field gamma ge le m l p ENV LAYOUT PLACE)as[b[LOOK LOC]].
 destruct(place_store_properties l p vc le m b PLACE TC LOOK W)as[observed[ch[CAN[ST[MODE[NV[VA POST]]]]]]].
 destruct(write_location_exists ge le rho m(place_id p)b(place_container p)l r ch vr vc observed SEP REP W LOOK LOC MODE NV VA PR(CV m)POST)as[mf[EV[REP'[W'[ACC STORE]]]]].
 exists(PTree.set(place_id p)observed rho),mf;split.
 - unfold value_assign;rewrite dec_eq_true,PLACE,VR,CV,CAN;reflexivity.
 - split;[exact EV|]. split.
   + eapply initialized_set;[exact INIT| |exact ST].
     exact(proj1(place_shape union_id float_field uint_field gamma l p PLACE)).
   + split;[exact REP'|]. split;[exact W'|]. split;[exact ACC|].
     eapply stores_to_step;[exists(place_id p),(place_container p);exact LOOK|exact STORE|constructor].
Qed.
End ASSIGN.
Print Assumptions checked_assign_sound.

