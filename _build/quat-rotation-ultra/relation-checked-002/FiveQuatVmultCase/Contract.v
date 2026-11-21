From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions.
From FiveQuatVmult Require Import Source Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition qtype:=tptr(Tstruct Source._FloatQuat noattr).
Definition vtype:=tptr(Tstruct Source._FloatVect3 noattr).
Definition Args(out q v:block):list val:=[Vptr out Ptrofs.zero;Vptr q Ptrofs.zero;Vptr v Ptrofs.zero].
Record Inputs(m:mem)(q v out:block)(qi qx qy qz vx vy vz:float32):Prop:={
 qv:q<>v;qo:q<>out;vo:v<>out;
 lqi:Mem.load Mfloat32 m q 0=Some(Vsingle qi);
 lqx:Mem.load Mfloat32 m q 4=Some(Vsingle qx);
 lqy:Mem.load Mfloat32 m q 8=Some(Vsingle qy);
 lqz:Mem.load Mfloat32 m q 12=Some(Vsingle qz);
 lvx:Mem.load Mfloat32 m v 0=Some(Vsingle vx);
 lvy:Mem.load Mfloat32 m v 4=Some(Vsingle vy);
 lvz:Mem.load Mfloat32 m v 8=Some(Vsingle vz);
 wout:forall ofs,In ofs[0;4;8]->Mem.valid_access m Mfloat32 out ofs Writable
}.
Definition Precondition(args:list val)(m:mem):Prop:=exists q v out qi qx qy qz vx vy vz,args=Args out q v /\Inputs m q v out qi qx qy qz vx vy vz.
Definition local_repr(rho:PTree.t val)(e:env)(m:mem):Prop:=forall id b ty value,
 e!id=Some(b,ty)->rho!id=Some value->Mem.load(match access_mode ty with By_value ch=>ch|_=>Mint32 end)m b 0=Some value.
Definition local_write(e:env)(m:mem):Prop:=forall id b ty,e!id=Some(b,ty)->Mem.valid_access m(match access_mode ty with By_value ch=>ch|_=>Mint32 end)b 0 Writable.
Definition Nonlocal(e:env)(q v out:block):Prop:=forall id b ty,e!id=Some(b,ty)->b<>q /\b<>v /\b<>out.
Definition freeable(e:env)(m:mem):Prop:=forall id b ty,e!id=Some(b,ty)->Mem.range_perm m b 0(sizeof Execution.ge ty)Cur Freeable.
Definition access_kept(m mf:mem):Prop:=forall ch b ofs p,Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p.
Inductive stores(e:env)(out:block):mem->mem->Prop:=
|stores_refl:forall m,stores e out m m
|stores_step:forall m m' mf ch b ofs value,
 stores e out m m' ->((b=out /\0<=ofs /\ofs+size_chunk ch<=12) \/exists id ty,e!id=Some(b,ty))->Mem.store ch m' b ofs value=Some mf ->stores e out m mf.
Definition Direct(qi qx qy qz vx vy vz:float32):float32*float32*float32:=
 let qi2:=Float.to_single(Float.sub(Float.of_single(Float32.mul qi qi))(Float.of_bits(Int64.repr 4602678819172646912)))in
 let qiqx:=Float32.mul qi qx in let qiqy:=Float32.mul qi qy in let qiqz:=Float32.mul qi qz in
 let m01:=Float32.mul qx qy in let m02:=Float32.mul qx qz in let m12:=Float32.mul qy qz in
 let m00:=Float32.add qi2(Float32.mul qx qx)in
 let m10:=Float32.sub m01 qiqz in let m20:=Float32.add m02 qiqy in let m21:=Float32.sub m12 qiqx in
 let m01:=Float32.add m01 qiqz in let m02:=Float32.sub m02 qiqy in let m12:=Float32.add m12 qiqx in
 let m11:=Float32.add qi2(Float32.mul qy qy)in let m22:=Float32.add qi2(Float32.mul qz qz)in
 let two:=Float32.of_int(Int.repr 2)in
 (Float32.mul two(Float32.add(Float32.add(Float32.mul m00 vx)(Float32.mul m01 vy))(Float32.mul m02 vz)),
  Float32.mul two(Float32.add(Float32.add(Float32.mul m10 vx)(Float32.mul m11 vy))(Float32.mul m12 vz)),
  Float32.mul two(Float32.add(Float32.add(Float32.mul m20 vx)(Float32.mul m21 vy))(Float32.mul m22 vz))).
Lemma inputs_store_local:forall m mf q v out qi qx qy qz vx vy vz ch b ofs value,
 Inputs m q v out qi qx qy qz vx vy vz ->b<>q->b<>v->
 Mem.store ch m b ofs value=Some mf->Inputs mf q v out qi qx qy qz vx vy vz.
Proof.
 intros m mf q v out qi qx qy qz vx vy vz ch b ofs value I BQ BV ST;destruct I;constructor;auto;
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
Variable q v out:block.
Variable qi qx qy qz vx vy vz:float32.
Record Context(rho:PTree.t val)(m:mem):Prop:={
 context_inputs:Inputs m q v out qi qx qy qz vx vy vz;
 context_repr:local_repr rho e m;
 context_write:local_write e m;
 context_free:freeable e m
}.
Lemma store_context:forall rho m id b x mf,
 env_separated e->Nonlocal e q v out->Context rho m->e!id=Some(b,tfloat)->
 Mem.store Mfloat32 m b 0(Vsingle x)=Some mf->Context(PTree.set id(Vsingle x)rho)mf.
Proof.
 intros rho m id b x mf SEP NL [IN REP WR FR] LOOK ST;constructor.
 - destruct(NL id b tfloat LOOK)as[BQ[BV BO]];eapply inputs_store_local;eauto.
 - eapply local_repr_after;eauto.
 - intros id' b' ty' LOOK';eapply Mem.store_valid_access_1;[exact ST|eapply WR;exact LOOK'].
 - intros id' b' ty' LOOK' ofs RANGE;eapply Mem.perm_store_1;[exact ST|eapply FR;eauto].
Qed.
Lemma assign_float_any:forall ge e m l r b p rv x mf,
 typeof l=tfloat->pure_lval ge e m l=Some(b,p,Full)->pure_rval ge e m r=Some rv->
 sem_cast rv(typeof r)tfloat m=Some(Vsingle x)->Ptrofs.unsigned p+4<=Ptrofs.modulus->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p)(Vsingle x)=Some mf->
 atomic_eval ge e m(Eassign l r tfloat)=Some(Vsingle x,mf).
Proof. intros;cbn[atomic_eval];rewrite H,dec_eq_true,H0,H1;unfold commit;rewrite H2.
 cbv[Cexec.do_assign_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.storev].
 rewrite zle_true by exact H3;rewrite H4;reflexivity. Qed.
Lemma write_local:forall rho m id b r vr x,
 env_separated e->Nonlocal e q v out->Context rho m->e!id=Some(b,tfloat)->
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
 env_separated e->Nonlocal e q v out->Context rho m->e!id=Some(b,tfloat)->
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
Lemma output_location:forall e m rho bp q v out qi qx qy qz vx vy vz fid delta,
 Context e q v out qi qx qy qz vx vy vz rho m->
 e!Source._v_out=Some(bp,vtype)->rho!Source._v_out=Some(Vptr out Ptrofs.zero)->
 (fid=Source._x /\delta=0)\/(fid=Source._y /\delta=4)\/(fid=Source._z /\delta=8)->
 pure_lval Execution.ge e m(Efield(Evalof(Ederef(Evalof(Evar Source._v_out vtype)vtype)(Tstruct Source._FloatVect3 noattr))(Tstruct Source._FloatVect3 noattr))fid tfloat)=Some(out,Ptrofs.repr delta,Full).
Proof.
 intros e m rho bp q v out qi qx qy qz vx vy vz fid delta CT LOOK VAL ID.
 replace(Ptrofs.repr delta)with(Ptrofs.add Ptrofs.zero(Ptrofs.repr delta))by(apply Ptrofs.add_zero_l).
 eapply struct_field;[unfold vtype;eapply(local_ptr e m rho Source._v_out bp out(Tstruct Source._FloatVect3 noattr));[destruct CT;assumption|exact LOOK|exact VAL]|reflexivity|].
 destruct ID as[[-> ->]|[[-> ->]|[-> ->]]];reflexivity.
Qed.
Lemma output_context:forall e m mf rho q v out qi qx qy qz vx vy vz ofs x,
 Nonlocal e q v out->Context e q v out qi qx qy qz vx vy vz rho m->
 Mem.store Mfloat32 m out ofs(Vsingle x)=Some mf->Context e q v out qi qx qy qz vx vy vz rho mf.
Proof.
 intros e m mf rho q v out qi qx qy qz vx vy vz ofs x NL[IN REP W F]ST;constructor.
 - eapply inputs_store_local;[exact IN|symmetry;apply(qo _ _ _ _ _ _ _ _ _ _ _ IN)|symmetry;apply(vo _ _ _ _ _ _ _ _ _ _ _ IN)|exact ST].
 - intros id b ty value LOOK VAL;erewrite Mem.load_store_other;[eapply REP;eauto|exact ST|left].
   intro EQ;subst b;destruct(NL id out ty LOOK)as[A[B C]];contradiction C;reflexivity.
 - intros id b ty LOOK;eapply Mem.store_valid_access_1;[exact ST|eapply W;exact LOOK].
 - intros id b ty LOOK off RANGE;eapply Mem.perm_store_1;[exact ST|eapply F;eauto].
Qed.
Lemma write_output:forall e m rho bp q v out qi qx qy qz vx vy vz fid delta r x,
 Nonlocal e q v out->Context e q v out qi qx qy qz vx vy vz rho m->
 e!Source._v_out=Some(bp,vtype)->rho!Source._v_out=Some(Vptr out Ptrofs.zero)->
 (fid=Source._x /\delta=0)\/(fid=Source._y /\delta=4)\/(fid=Source._z /\delta=8)->
 pure_rval Execution.ge e m r=Some(Vsingle x)->typeof r=tfloat->
 exists mf,atomic_eval Execution.ge e m(Eassign(Efield(Evalof(Ederef(Evalof(Evar Source._v_out vtype)vtype)(Tstruct Source._FloatVect3 noattr))(Tstruct Source._FloatVect3 noattr))fid tfloat)r tfloat)=Some(Vsingle x,mf) /\
 Context e q v out qi qx qy qz vx vy vz rho mf /\Mem.store Mfloat32 m out delta(Vsingle x)=Some mf.
Proof.
 intros e m rho bp q v out qi qx qy qz vx vy vz fid delta r x NL CT LOOK VAL ID RV TY.
 assert(IN:In delta[0;4;8])by(destruct ID as[[-> ->]|[[-> ->]|[-> ->]]];simpl;auto).
 pose proof(context_inputs _ _ _ _ _ _ _ _ _ _ _ _ _ CT)as INPUT.
 destruct(Mem.valid_access_store m Mfloat32 out delta(Vsingle x)(wout _ _ _ _ _ _ _ _ _ _ _ INPUT delta IN))as[mf ST].
 exists mf;split.
 - eapply assign_float_any;[reflexivity|eapply output_location;eauto|exact RV|rewrite TY;reflexivity| |].
   + assert(D:0<=delta<=8)by(destruct ID as[[-> ->]|[[-> ->]|[-> ->]]];lia).
     rewrite Ptrofs.unsigned_repr by(change(0<=delta<=18446744073709551615);lia);change(delta+4<=18446744073709551616);lia.
   + assert(D:0<=delta<=8)by(destruct ID as[[-> ->]|[[-> ->]|[-> ->]]];lia).
     rewrite Ptrofs.unsigned_repr by(change(0<=delta<=18446744073709551615);lia);exact ST.
 - split;[eapply output_context;eauto|exact ST].
Qed.
