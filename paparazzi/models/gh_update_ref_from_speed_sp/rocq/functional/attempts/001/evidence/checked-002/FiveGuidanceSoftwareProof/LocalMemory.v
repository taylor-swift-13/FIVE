From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation.
From FiveGuidanceSoftwareProof Require Import FlatStatements.
Import ListNotations.
Local Open Scope Z_scope.
Definition slot_chunk(ty:type):memory_chunk:=
 match access_mode ty with By_value ch=>ch|_=>Mint32 end.
Definition locals_repr(rho:PTree.t val)(e:env)(m:mem):Prop:=
 forall id b ty v,e!id=Some(b,ty)->rho!id=Some v->Mem.load(slot_chunk ty)m b 0=Some v.
Definition locals_writable(e:env)(m:mem):Prop:=
 forall id b ty,e!id=Some(b,ty)->Mem.valid_access m(slot_chunk ty)b 0 Writable.
Lemma locals_after_store : forall rho e m id b ty ch value mf observed,
 env_separated e -> locals_repr rho e m ->e!id=Some(b,ty)->
 Mem.store ch m b 0 value=Some mf ->
 Mem.load(slot_chunk ty)mf b 0=Some observed ->
 locals_repr(PTree.set id observed rho)e mf.
Proof.
 intros rho e m id b ty ch value mf observed SEP REP LOOK ST POST.
 intros other bx tx vx LX RX.
 rewrite PTree.gsspec in RX;destruct(peq other id)as[EQ|NE].
 - subst other;rewrite LOOK in LX;injection LX as B T;subst bx tx;injection RX as V;subst vx;exact POST.
 - erewrite Mem.load_store_other;[eapply REP;eauto|exact ST|left].
   intro EQ;subst bx;apply NE;eapply SEP;eauto.
Qed.
Lemma locals_writable_after_store : forall e m ch b ofs v mf,
 locals_writable e m ->Mem.store ch m b ofs v=Some mf ->locals_writable e mf.
Proof. intros e m ch b ofs v mf W ST id bx ty LOOK;eapply Mem.store_valid_access_1;[exact ST|eapply W;exact LOOK]. Qed.
Lemma store_single_as_bits : forall m b ofs x mf,
 Mem.store Mfloat32 m b ofs(Vsingle x)=Some mf ->
 Mem.load Mint32 mf b ofs=Some(Vint(Float32.to_bits x)).
Proof.
 intros m b ofs x mf ST.
 destruct(Mem.load_store_similar _ _ _ _ _ _ ST Mint32 eq_refl ltac:(reflexivity))as[v[LD DE]].
 cbn[decode_encode_val]in DE;subst v;exact LD.
Qed.
Lemma load_bits_as_single : forall m b ofs bits,
 Mem.load Mint32 m b ofs=Some(Vint bits) ->
 Mem.load Mfloat32 m b ofs=Some(Vsingle(Float32.of_bits bits)).
Proof.
 intros m b ofs bits LOAD.
 destruct(Mem.load_loadbytes _ _ _ _ _ LOAD)as[bytes[BY DE]].
 assert(ALIGN:(align_chunk Mfloat32|ofs))by(exact(proj2(Mem.load_valid_access _ _ _ _ _ LOAD))).
 pose proof(Mem.loadbytes_load Mfloat32 m b ofs bytes BY ALIGN)as FLOAT.
 unfold decode_val in DE,FLOAT.
 destruct(proj_bytes bytes)as[bl|]eqn:B.
 - assert(E:bits=Int.repr(decode_int bl)).
   { exact(f_equal(fun v=>match v with Vint n=>n|_=>Int.zero end)DE). }
   rewrite E;exact FLOAT.
 - cbn in DE;discriminate.
Qed.
Lemma read_scalar_local : forall(ge:Csem.genv)e m id b ty ch v,
 e!id=Some(b,ty)->access_mode ty=By_value ch->type_is_volatile ty=false->
 Mem.load ch m b 0=Some v ->
 pure_rval ge e m(Evalof(Evar id ty)ty)=Some v.
Proof.
 intros ge e m id b ty ch v LOOK MODE NV LOAD.
 cbn[pure_rval pure_lval];rewrite LOOK;repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world ty m b Ptrofs.zero Full=Some(quiet_world,E0,v)).
 { apply Cexec.do_deref_loc_complete;[|constructor].
   eapply deref_loc_value;[exact MODE|exact NV|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact LOAD|change(size_chunk ch<=18446744073709551616);destruct ch;cbn;lia]. }
 rewrite D;reflexivity.
Qed.

Lemma write_location_exists : forall(ge:Csem.genv)e rho m id b container l r ch vr vc observed,
 env_separated e ->locals_repr rho e m ->locals_writable e m ->
 e!id=Some(b,container) ->
 pure_lval ge e m l=Some(b,Ptrofs.zero,Full) ->
 access_mode(typeof l)=By_value ch ->type_is_volatile(typeof l)=false ->
 Mem.valid_access m ch b 0 Writable ->
 pure_rval ge e m r=Some vr ->sem_cast vr(typeof r)(typeof l)m=Some vc ->
 (forall mf,Mem.store ch m b 0 vc=Some mf ->Mem.load(slot_chunk container)mf b 0=Some observed) ->
 exists mf,
 statement_eval ge e(Sdo(Eassign l r(typeof l)))m=Some(Out_normal,mf) /\
 locals_repr(PTree.set id observed rho)e mf /\
 locals_writable e mf /\ access_preserved m mf /\
 Mem.store ch m b 0 vc=Some mf.
Proof.
 intros ge e rho m id b container l r ch vr vc observed SEP REP W LOOK LOC MODE NV ACCESS RV CAST POST.
 destruct(Mem.valid_access_store m ch b 0 vc ACCESS)as[mf ST].
 assert(AS:assign_loc ge(typeof l)m b Ptrofs.zero Full vc E0 mf vc).
 { eapply assign_loc_value;[exact MODE|exact NV|].
   unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact ST|change(size_chunk ch<=18446744073709551616);destruct ch;cbn;lia]. }
 assert(D:Cexec.do_assign_loc ge quiet_world(typeof l)m b Ptrofs.zero Full vc=Some(quiet_world,E0,mf,vc)).
 { apply Cexec.do_assign_loc_complete;[exact AS|constructor]. }
 exists mf;split.
 - cbn[statement_eval flat_eval];rewrite dec_eq_true,LOC,RV,CAST,D;reflexivity.
 - split;[eapply locals_after_store;eauto|]. split.
   + eapply locals_writable_after_store;eauto.
   + split;[intros chunk bx ofs p VA;eapply Mem.store_valid_access_1;eauto|exact ST].
Qed.
Lemma write_scalar_exists : forall(ge:Csem.genv)e rho m id b ty ch r vr vc,
 env_separated e ->locals_repr rho e m ->locals_writable e m ->
 e!id=Some(b,ty)->access_mode ty=By_value ch->type_is_volatile ty=false ->
 pure_rval ge e m r=Some vr ->sem_cast vr(typeof r)ty m=Some vc ->
 Val.load_result ch vc=vc ->
 exists mf,
 statement_eval ge e(Sdo(Eassign(Evar id ty)r ty))m=Some(Out_normal,mf) /\
 locals_repr(PTree.set id vc rho)e mf /\
 locals_writable e mf /\ access_preserved m mf /\
 Mem.store ch m b 0 vc=Some mf.
Proof.
 intros ge e rho m id b ty ch r vr vc SEP REP W LOOK MODE NV RV CAST RESULT.
 eapply write_location_exists;try eassumption.
 - cbn[pure_lval];rewrite LOOK,dec_eq_true;reflexivity.
 - pose proof(W id b ty LOOK)as A;unfold slot_chunk in A;rewrite MODE in A;exact A.
 - intros mf ST;unfold slot_chunk;rewrite MODE.
   erewrite Mem.load_store_same by exact ST;rewrite RESULT;reflexivity.
Qed.

Lemma local_read_from_repr : forall(ge:Csem.genv)e rho m id b ty ch v,
 locals_repr rho e m ->e!id=Some(b,ty)->rho!id=Some v ->
 access_mode ty=By_value ch->type_is_volatile ty=false ->
 pure_rval ge e m(Evalof(Evar id ty)ty)=Some v.
Proof.
 intros ge e rho m id b ty ch v REP LOOK VAL MODE NV.
 eapply read_scalar_local;try eassumption.
 pose proof(REP id b ty v LOOK VAL)as LOAD;unfold slot_chunk in LOAD;rewrite MODE in LOAD;exact LOAD.
Qed.
Lemma read_location_rvalue : forall(ge:Csem.genv)e m l ty ch b ofs v,
 typeof l=ty ->pure_lval ge e m l=Some(b,ofs,Full) ->
 access_mode ty=By_value ch->type_is_volatile ty=false ->
 Mem.loadv ch m(Vptr b ofs)=Some v ->
 pure_rval ge e m(Evalof l ty)=Some v.
Proof.
 intros ge e m l ty ch b ofs v TYPE LOC MODE NV LOAD.
 change((if type_eq ty(typeof l)then
 match pure_lval ge e m l with
 |Some(b0,o0,bf)=>match Cexec.do_deref_loc ge quiet_world ty m b0 o0 bf with
 |Some(_,_,w)=>Some w|None=>None end|None=>None end else None)=Some v).
 rewrite TYPE,dec_eq_true,LOC.
 assert(D:Cexec.do_deref_loc ge quiet_world ty m b ofs Full=Some(quiet_world,E0,v)).
 { apply Cexec.do_deref_loc_complete;[|constructor]. eapply deref_loc_value;eauto. }
 rewrite D;reflexivity.
Qed.
Lemma local_union_location : forall(ge:Csem.genv)e m vid uid field fty b co,
 e!vid=Some(b,Tunion uid noattr)->
 (genv_cenv ge)!uid=Some co ->
 union_field_offset ge field(co_members co)=OK(0,Full) ->
 pure_lval ge e m(Efield(Evalof(Evar vid(Tunion uid noattr))(Tunion uid noattr))field fty)=Some(b,Ptrofs.zero,Full).
Proof.
 intros ge e m vid uid field fty b co LOOK GET OFF.
 cbn[pure_lval pure_rval];rewrite LOOK;repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world(Tunion uid noattr)m b Ptrofs.zero Full=Some(quiet_world,E0,Vptr b Ptrofs.zero)).
 { apply Cexec.do_deref_loc_complete;[apply deref_loc_copy;reflexivity|constructor]. }
 rewrite D;cbn[typeof];rewrite GET,OFF;reflexivity.
Qed.
Print Assumptions local_union_location.
Print Assumptions write_location_exists.
