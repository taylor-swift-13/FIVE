From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions.
From FiveRmatOfQuat Require Import Source Execution.
Import ListNotations.
Local Open Scope Z_scope.
From FiveRmatOfQuatCase Require Import Base.
Definition Args(out q:block):list val:=[Vptr out Ptrofs.zero;Vptr q Ptrofs.zero].
Record Inputs(m:mem)(q out:block)(qi qx qy qz:float32):Prop:={
 qo:q<>out;
 lqi:Mem.load Mfloat32 m q 0=Some(Vsingle qi);
 lqx:Mem.load Mfloat32 m q 4=Some(Vsingle qx);
 lqy:Mem.load Mfloat32 m q 8=Some(Vsingle qy);
 lqz:Mem.load Mfloat32 m q 12=Some(Vsingle qz);
 wout:forall ofs,In ofs[0;4;8;12;16;20;24;28;32]->Mem.valid_access m Mfloat32 out ofs Writable
}.
Definition Precondition(args:list val)(m:mem):Prop:=exists q out qi qx qy qz,args=Args out q /\Inputs m q out qi qx qy qz.
Definition local_repr(rho:PTree.t val)(e:env)(m:mem):Prop:=forall id b ty value,
 e!id=Some(b,ty)->rho!id=Some value->Mem.load(match access_mode ty with By_value ch=>ch|_=>Mint32 end)m b 0=Some value.
Definition local_write(e:env)(m:mem):Prop:=forall id b ty,e!id=Some(b,ty)->Mem.valid_access m(match access_mode ty with By_value ch=>ch|_=>Mint32 end)b 0 Writable.
Definition Nonlocal(e:env)(q out:block):Prop:=forall id b ty,e!id=Some(b,ty)->b<>q /\b<>out.
Definition freeable(e:env)(m:mem):Prop:=forall id b ty,e!id=Some(b,ty)->Mem.range_perm m b 0(sizeof Execution.ge ty)Cur Freeable.
Definition access_kept(m mf:mem):Prop:=forall ch b ofs p,Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p.
Inductive stores(e:env)(out:block):mem->mem->Prop:=
|stores_refl:forall m,stores e out m m
|stores_step:forall m m' mf ch b ofs value,
 stores e out m m' ->((b=out /\ 0<=ofs /\ ofs+size_chunk ch<=36) \/exists id ty,e!id=Some(b,ty))->Mem.store ch m' b ofs value=Some mf ->stores e out m mf.
Lemma inputs_store_local:forall m mf q out qi qx qy qz ch b ofs value,
 Inputs m q out qi qx qy qz ->b<>q->
 Mem.store ch m b ofs value=Some mf->Inputs mf q out qi qx qy qz.
Proof.
 intros m mf q out qi qx qy qz ch b ofs value I BQ ST;destruct I;constructor;auto;
 try(erewrite Mem.load_store_other by(exact ST||(left;congruence));eassumption).
 intros off IN;eapply Mem.store_valid_access_1;[exact ST|auto].
Qed.
Lemma local_repr_after:forall rho e m id b ty value mf,
 env_separated e->local_repr rho e m->e!id=Some(b,ty)->
 Mem.store Mfloat32 m b 0(Vsingle value)=Some mf->ty=tfloat->
 local_repr(PTree.set id(Vsingle value)rho)e mf.
Proof.
 intros rho e m id b ty value mf SEP REP L ST EQ;subst ty.
 intros other bx tx vx LX RX;rewrite PTree.gsspec in RX;destruct(peq other id)as[EQ|NE].
 - subst other;rewrite L in LX;injection LX as B T;subst bx tx;injection RX as V;subst vx.
   erewrite Mem.load_store_same by exact ST;reflexivity.
 - erewrite Mem.load_store_other;[eapply REP;eauto|exact ST|left].
   intro EQ;subst bx;apply NE;eapply SEP;eauto.
Qed.
Lemma local_float:forall e m rho id b x,
 local_repr rho e m->e!id=Some(b,tfloat)->rho!id=Some(Vsingle x)->
 pure_rval Execution.ge e m(Evalof(Evar id tfloat)tfloat)=Some(Vsingle x).
Proof. intros e m rho id b x REP LOOK VAL;eapply float_variable;[exact LOOK|exact(REP id b tfloat(Vsingle x)LOOK VAL)]. Qed.
Lemma local_ptr:forall e m rho id bx b ty,
 local_repr rho e m->e!id=Some(bx,tptr ty)->rho!id=Some(Vptr b Ptrofs.zero)->
 pure_rval Execution.ge e m(Evalof(Evar id(tptr ty))(tptr ty))=Some(Vptr b Ptrofs.zero).
Proof. intros e m rho id bx b ty REP LOOK VAL;eapply pointer_variable;[exact LOOK|exact(REP id bx(tptr ty)(Vptr b Ptrofs.zero)LOOK VAL)]. Qed.
Lemma float_field:forall e m rho id bx b sid fid delta co x,
 local_repr rho e m->e!id=Some(bx,tptr(Tstruct sid noattr))->rho!id=Some(Vptr b Ptrofs.zero)->
 (genv_cenv Execution.ge)!sid=Some co->field_offset Execution.ge fid(co_members co)=Errors.OK(delta,Full)->
 0<=delta<=12->Mem.load Mfloat32 m b delta=Some(Vsingle x)->
 pure_rval Execution.ge e m(Evalof(Efield(Evalof(Ederef(Evalof(Evar id(tptr(Tstruct sid noattr)))(tptr(Tstruct sid noattr)))(Tstruct sid noattr))(Tstruct sid noattr))fid tfloat)tfloat)=Some(Vsingle x).
Proof.
 intros e m rho id bx b sid fid delta co x REP LOOK VAL CO OFF D LOAD.
 assert(LOC:pure_lval Execution.ge e m(Efield(Evalof(Ederef(Evalof(Evar id(tptr(Tstruct sid noattr)))(tptr(Tstruct sid noattr)))(Tstruct sid noattr))(Tstruct sid noattr))fid tfloat)=Some(b,Ptrofs.repr delta,Full)).
 { replace(Ptrofs.repr delta)with(Ptrofs.add Ptrofs.zero(Ptrofs.repr delta))by(apply Ptrofs.add_zero_l). eapply struct_field;[eapply local_ptr;eauto|exact CO|exact OFF]. }
 change(match pure_lval Execution.ge e m(Efield(Evalof(Ederef(Evalof(Evar id(tptr(Tstruct sid noattr)))(tptr(Tstruct sid noattr)))(Tstruct sid noattr))(Tstruct sid noattr))fid tfloat)with
 |Some(b0,o0,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m b0 o0 bf with Some(_,_,value)=>Some value|None=>None end|None=>None end=Some(Vsingle x)).
 rewrite LOC.
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite Ptrofs.unsigned_repr by(change(0<=delta<=18446744073709551615);lia).
 rewrite zle_true by(change(delta+4<=18446744073709551616);lia);rewrite LOAD;reflexivity.
Qed.
Section CONTEXT.
Variable e:env.
Variable q out:block.
Variable qi qx qy qz:float32.
Record Context(rho:PTree.t val)(m:mem):Prop:={
 context_inputs:Inputs m q out qi qx qy qz;
 context_repr:local_repr rho e m;
 context_write:local_write e m;
 context_free:freeable e m
}.
Lemma store_context:forall rho m id b x mf,
 env_separated e->Nonlocal e q out->Context rho m->e!id=Some(b,tfloat)->
 Mem.store Mfloat32 m b 0(Vsingle x)=Some mf->Context(PTree.set id(Vsingle x)rho)mf.
Proof.
 intros rho m id b x mf SEP NL [IN REP WR FR] LOOK ST;constructor.
 - destruct(NL id b tfloat LOOK)as[BQ BO];eapply inputs_store_local;eauto.
 - eapply local_repr_after;eauto.
 - intros id' b' ty' LOOK';eapply Mem.store_valid_access_1;[exact ST|eapply WR;exact LOOK'].
 - intros id' b' ty' LOOK' ofs RANGE;eapply Mem.perm_store_1;[exact ST|eapply FR;eauto].
Qed.
Lemma write_local:forall rho m id b r vr x,
 env_separated e->Nonlocal e q out->Context rho m->e!id=Some(b,tfloat)->
 pure_rval Execution.ge e m r=Some vr->sem_cast vr(typeof r)tfloat m=Some(Vsingle x)->
 exists mf,atomic_eval Execution.ge e m(Eassign(Evar id tfloat)r tfloat)=Some(Vsingle x,mf) /\
 Context(PTree.set id(Vsingle x)rho)mf /\Mem.store Mfloat32 m b 0(Vsingle x)=Some mf.
Proof.
 intros rho m id b r vr x SEP NL CT LOOK RV CAST.
 pose proof(context_write _ _ CT id b tfloat LOOK)as ACCESS.
 destruct(Mem.valid_access_store m Mfloat32 b 0(Vsingle x)ACCESS)as[mf ST].
 exists mf;split.
 - eapply assign_float_any;[reflexivity| |exact RV|exact CAST| |].
   + cbn[pure_lval];rewrite LOOK,dec_eq_true;reflexivity.
   + rewrite Ptrofs.unsigned_zero;change(4<=18446744073709551616);lia.
   + rewrite Ptrofs.unsigned_zero;exact ST.
 - split;[eapply store_context;eauto|exact ST].
Qed.
Lemma local_write_stmt:forall rho m id b r vr x,
 env_separated e->Nonlocal e q out->Context rho m->e!id=Some(b,tfloat)->
 pure_rval Execution.ge e m r=Some vr->sem_cast vr(typeof r)tfloat m=Some(Vsingle x)->
 exists mf,stmt_eval Execution.ge e tvoid(Sdo(Eassign(Evar id tfloat)r tfloat))m=Some(Nnormal,mf) /\
 Context(PTree.set id(Vsingle x)rho)mf.
Proof.
 intros;destruct(write_local rho m id b r vr x H H0 H1 H2 H3 H4)as[mf[EV[CT ST]]];exists mf;split;auto;cbn[stmt_eval];rewrite EV;reflexivity.
Qed.
End CONTEXT.
Lemma assignop_as_assign:forall ge e m id b r op x vr,
 e!id=Some(b,tfloat)->Mem.load Mfloat32 m b 0=Some(Vsingle x)->
 pure_rval ge e m r=Some vr->typeof r=tfloat->
 atomic_eval ge e m(Eassignop op(Evar id tfloat)r tfloat tfloat)=
 atomic_eval ge e m(Eassign(Evar id tfloat)(Ebinop op(Evalof(Evar id tfloat)tfloat)r tfloat)tfloat).
Proof.
 intros ge e m id b r op x vr LOOK LOAD RV TY.
 assert(LOC:pure_lval ge e m(Evar id tfloat)=Some(b,Ptrofs.zero,Full))by(cbn[pure_lval];rewrite LOOK,dec_eq_true;reflexivity).
 assert(VAL:pure_rval ge e m(Evalof(Evar id tfloat)tfloat)=Some(Vsingle x))by(eapply float_variable;eauto).
 assert(D:Cexec.do_deref_loc ge PureDenotation.quiet_world tfloat m b Ptrofs.zero Full=Some(PureDenotation.quiet_world,E0,Vsingle x)).
 { cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv];rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);rewrite LOAD;reflexivity. }
 change((if type_eq tfloat tfloat then match pure_lval ge e m(Evar id tfloat),pure_rval ge e m r with
 |Some(b0,ofs,bf),Some vr0=>match Cexec.do_deref_loc ge PureDenotation.quiet_world tfloat m b0 ofs bf with
 |Some(_,_,vl)=>match sem_binary_operation ge op vl tfloat vr0(typeof r)m with Some vo=>commit ge m tfloat(b0,ofs,bf)vo tfloat|None=>None end|None=>None end|_,_=>None end else None)=
 (if type_eq tfloat tfloat then match pure_lval ge e m(Evar id tfloat),pure_rval ge e m(Ebinop op(Evalof(Evar id tfloat)tfloat)r tfloat)with
 |Some loc,Some vo=>commit ge m tfloat loc vo tfloat|_,_=>None end else None)).
 rewrite !dec_eq_true,LOC,RV,D.
 change(match sem_binary_operation ge op(Vsingle x)tfloat vr(typeof r)m with Some vo=>commit ge m tfloat(b,Ptrofs.zero,Full)vo tfloat|None=>None end=
 match(match pure_rval ge e m(Evalof(Evar id tfloat)tfloat),pure_rval ge e m r with Some vl,Some vr=>sem_binary_operation ge op vl tfloat vr(typeof r)m|_,_=>None end)with Some vo=>commit ge m tfloat(b,Ptrofs.zero,Full)vo tfloat|None=>None end).
 rewrite VAL,RV;reflexivity.
Qed.
Lemma store_output_context:forall e q out qi qx qy qz rho m ofs x mf,
 Nonlocal e q out->Context e q out qi qx qy qz rho m->
 Mem.store Mfloat32 m out ofs(Vsingle x)=Some mf->Context e q out qi qx qy qz rho mf.
Proof. intros e q out qi qx qy qz rho m ofs x mf NL [IN REP WR FR] ST;constructor.
 - eapply inputs_store_local with(b:=out);[exact IN|intro EQ;subst out;exact(qo _ _ _ _ _ _ _ IN eq_refl)|exact ST].
 - intros id b ty value LOOK VAL;erewrite Mem.load_store_other;[eapply REP;eauto|exact ST|left;exact(proj2(NL id b ty LOOK))].
 - intros id b ty LOOK;eapply Mem.store_valid_access_1;[exact ST|eapply WR;exact LOOK].
 - intros id b ty LOOK z Z;eapply Mem.perm_store_1;[exact ST|eapply FR;eauto].
Qed.
