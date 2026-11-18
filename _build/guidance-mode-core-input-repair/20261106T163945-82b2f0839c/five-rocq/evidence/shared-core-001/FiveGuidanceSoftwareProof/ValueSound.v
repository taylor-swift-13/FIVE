From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveGuidanceSoftwareProof Require Import ValueEvaluator ValueChecker NumericOps LocalMemory FlatStatements.
Import ListNotations.
Local Open Scope Z_scope.
Section SIMULATION.
Variables union_id float_field uint_field:ident.
Variable gamma:PTree.t type.
Local Notation place :=(place_of union_id float_field uint_field gamma).
Definition env_matches(e:env):Prop:=forall id ty,gamma!id=Some ty->exists b,e!id=Some(b,ty).
Definition union_layout(ge:Csem.genv):Prop:=exists co,
 (genv_cenv ge)!union_id=Some co /\
 union_field_offset ge float_field(co_members co)=OK(0,Full) /\
 union_field_offset ge uint_field(co_members co)=OK(0,Full).
Lemma place_shape:forall l p,place l=Some p ->
 gamma!(place_id p)=Some(place_container p) /\typeof l=place_type p /\
 ((place_union p=false /\l=Evar(place_id p)(place_container p) /\place_type p=place_container p)\/
 (place_union p=true /\place_container p=Tunion union_id noattr /\
 ((place_type p=tfloat /\l=Efield(Evalof(Evar(place_id p)(Tunion union_id noattr))(Tunion union_id noattr))float_field tfloat)\/
  (place_type p=tuint /\l=Efield(Evalof(Evar(place_id p)(Tunion union_id noattr))(Tunion union_id noattr))uint_field tuint)))).
Proof.
 intros l p P;unfold place_of in P;option_cases P;inversion P;subst;cbn;repeat split;try assumption;eauto 10.
Qed.
Lemma place_location:forall(ge:Csem.genv)e m l p,
 env_matches e ->union_layout ge ->place l=Some p ->
 exists b,e!(place_id p)=Some(b,place_container p) /\
 pure_lval ge e m l=Some(b,Ptrofs.zero,Full).
Proof.
 intros ge e m l p ENV[co[GET[FF UF]]]P.
 destruct(place_shape l p P)as[LOOK[TYPE CASE]].
 destruct(ENV _ _ LOOK)as[b LB];exists b;split;[exact LB|].
 destruct CASE as[[UN[-> SAME]]|[UN[CONT[[FLOAT ->]|[UINT ->]]]]].
 - cbn[pure_lval];rewrite LB,dec_eq_true;reflexivity.
 - eapply local_union_location;[rewrite <- CONT;exact LB|exact GET|exact FF].
 - eapply local_union_location;[rewrite <- CONT;exact LB|exact GET|exact UF].
Qed.
Lemma scalar_mode : forall ty,scalar_type ty=true ->
 access_mode ty=By_value(slot_chunk ty) /\type_is_volatile ty=false.
Proof.
 intros ty S;unfold scalar_type,numeric_kind in S.
 destruct(numeric_tag ty)as[tag|]eqn:T;try discriminate.
 pose proof(numeric_tag_sound ty tag T)as EQ;subst ty;destruct tag;split;reflexivity.
Qed.
Lemma scalar_slot_typed : forall ty v,
 scalar_type ty=true ->slot_typed union_id ty v ->typed_value ty v.
Proof.
 intros ty v SC TV;unfold slot_typed in TV.
 destruct(type_eq ty(Tunion union_id noattr));[subst ty;discriminate SC|exact TV].
Qed.
Lemma loadv_zero : forall ch m b v,
 Mem.load ch m b 0=Some v ->Mem.loadv ch m(Vptr b Ptrofs.zero)=Some v.
Proof.
 intros ch m b v H;unfold Mem.loadv;rewrite Ptrofs.unsigned_zero,zle_true;[exact H|change(size_chunk ch<=18446744073709551616);destruct ch;cbn;lia].
Qed.
Lemma initialized_place_read : forall(ge:Csem.genv)e m rho ids l p,
 env_matches e ->union_layout ge ->locals_repr rho e m ->
 initialized_values union_id gamma ids rho ->place l=Some p ->
 has_id(place_id p)ids=true ->scalar_type(place_type p)=true ->
 exists v,read_place rho p=Some v /\typed_value(place_type p)v /\
 pure_rval ge e m(Evalof l(place_type p))=Some v.
Proof.
 intros ge e m rho ids l p ENV LAYOUT REP INIT PLACE IN SC.
 destruct(place_shape l p PLACE)as[GAMMA[TYPE CASE]].
 apply has_id_true in IN.
 destruct(INIT _ IN)as[ct[v[GT[VAL SLOT]]]].
 assert(CT:ct=place_container p)by congruence;subst ct.
 destruct(place_location ge e m l p ENV LAYOUT PLACE)as[b[LOOK LOC]].
 pose proof(REP _ _ _ _ LOOK VAL)as LOAD.
 destruct CASE as[[UN[L SAME]]|[UN[CONT[[FLOAT L]|[UINT L]]]]].
 - subst l;exists v;split.
   + unfold read_place;rewrite VAL,UN;reflexivity.
   + split.
     * rewrite SAME;apply scalar_slot_typed;[rewrite <- SAME;exact SC|exact SLOT].
     * rewrite SAME;eapply read_scalar_local;[exact LOOK| | |exact LOAD].
       all:destruct(scalar_mode(place_container p)ltac:(rewrite <- SAME;exact SC));assumption.
 - subst l;unfold slot_typed in SLOT;rewrite CONT,dec_eq_true in SLOT.
   destruct v;cbn in SLOT;try contradiction.
   rewrite CONT in LOAD;change(Mem.load Mint32 m b 0=Some(Vint i))in LOAD.
   exists(Vsingle(Float32.of_bits i));split.
   + unfold read_place;rewrite VAL,UN,FLOAT;reflexivity.
   + split;[rewrite FLOAT;exact I|]. rewrite FLOAT.
     eapply read_location_rvalue with(ch:=Mfloat32)(b:=b)(ofs:=Ptrofs.zero);try reflexivity;[exact LOC|].
     apply loadv_zero;apply load_bits_as_single;exact LOAD.
 - subst l;unfold slot_typed in SLOT;rewrite CONT,dec_eq_true in SLOT.
   destruct v;cbn in SLOT;try contradiction.
   rewrite CONT in LOAD;change(Mem.load Mint32 m b 0=Some(Vint i))in LOAD.
   exists(Vint i);split.
   + unfold read_place;rewrite VAL,UN,UINT;reflexivity.
   + split;[rewrite UINT;exact I|]. rewrite UINT.
     eapply read_location_rvalue with(ch:=Mint32)(b:=b)(ofs:=Ptrofs.zero);try reflexivity;[exact LOC|].
     apply loadv_zero;exact LOAD.
Qed.
Lemma value_literal_constraint:forall rho a v,
 value_expr union_id float_field uint_field gamma rho a=Some v ->
 literal_constraint(literal_value a)v.
Proof.
 intros rho a v EV;destruct a;cbn[literal_value literal_constraint];try exact I.
 cbn[value_expr]in EV;congruence.
Qed.
Theorem checked_expr_sound:forall a ids rho(ge:Csem.genv)le m,
 check_expr union_id float_field uint_field gamma ids a=true ->
 env_matches le ->union_layout ge ->locals_repr rho le m ->
 initialized_values union_id gamma ids rho ->
 exists v,value_expr union_id float_field uint_field gamma rho a=Some v /\
 typed_value(typeof a)v /\pure_rval ge le m a=Some v.
Proof.
 induction a;intros ids rho ge le m CHECK ENV LAYOUT REP INIT;cbn[check_expr]in CHECK;try discriminate.
 - exists v;split;[reflexivity|]. split;[eapply literal_typed_sound;exact CHECK|reflexivity].
 - destruct(type_eq ty(typeof a))as[EQ|NE];try discriminate.
   destruct(place a)as[p|]eqn:P;try discriminate;core_unpack.
   destruct(place_shape a p P)as[G[TP CASE]].
   assert(PT:place_type p=ty)by congruence.
   destruct(initialized_place_read ge le m rho ids a p ENV LAYOUT REP INIT P ltac:(assumption)ltac:(rewrite PT;assumption))as[v[READ[TV PV]]].
   exists v;split.
   + change((if type_eq ty(typeof a)then match place a with Some p=>read_place rho p|None=>None end else None)=Some v).
     rewrite <- EQ,dec_eq_true,P;exact READ.
   + split;[rewrite <- PT;exact TV|rewrite <- PT;exact PV].
 - core_unpack.
   destruct(IHa ids rho ge le m ltac:(assumption)ENV LAYOUT REP INIT)as[v[QV[TV PV]]].
   destruct(safe_unop_total op(typeof a)ty v ltac:(assumption)TV)as[result[TR OP]].
   exists result;split.
   + change((match value_expr union_id float_field uint_field gamma rho a with Some w=>sem_unary_operation op w(typeof a)Mem.empty|None=>None end)=Some result).
     rewrite QV;apply OP.
   + split;[exact TR|].
     change((match pure_rval ge le m a with Some w=>sem_unary_operation op w(typeof a)m|None=>None end)=Some result).
     rewrite PV;apply OP.
 - core_unpack.
   destruct(IHa1 ids rho ge le m ltac:(assumption)ENV LAYOUT REP INIT)as[v[QV[TV PV]]].
   destruct(IHa2 ids rho ge le m ltac:(assumption)ENV LAYOUT REP INIT)as[w[QW[TW PW]]].
   destruct(safe_binop_total op(typeof a1)(typeof a2)ty(literal_value a2)v w ltac:(assumption)TV TW(value_literal_constraint rho a2 w QW))as[result[TR OP]].
   exists result;split.
   + change((match value_expr union_id float_field uint_field gamma rho a1,value_expr union_id float_field uint_field gamma rho a2 with Some x,Some y=>sem_binary_operation empty_cenv op x(typeof a1)y(typeof a2)Mem.empty|_,_=>None end)=Some result).
     rewrite QV,QW;apply OP.
   + split;[exact TR|].
     change((match pure_rval ge le m a1,pure_rval ge le m a2 with Some x,Some y=>sem_binary_operation ge op x(typeof a1)y(typeof a2)m|_,_=>None end)=Some result).
     rewrite PV,PW;apply OP.
 - core_unpack.
   destruct(IHa ids rho ge le m ltac:(assumption)ENV LAYOUT REP INIT)as[v[QV[TV PV]]].
   destruct(safe_cast_total(typeof a)ty v ltac:(assumption)TV)as[result[TR OP]].
   exists result;split.
   + change((match value_expr union_id float_field uint_field gamma rho a with Some w=>sem_cast w(typeof a)ty Mem.empty|None=>None end)=Some result).
     rewrite QV;apply OP.
   + split;[exact TR|].
     change((match pure_rval ge le m a with Some w=>sem_cast w(typeof a)ty m|None=>None end)=Some result).
     rewrite PV;apply OP.
Qed.
End SIMULATION.
