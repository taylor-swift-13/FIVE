From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveLowpassSupport Require Import Expressions LowpassMemory Straightline.
From FiveRmatVmult Require Import Source Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition vt := Tstruct Source._FloatVect3 noattr.
Definition rt := Tstruct Source._FloatRMat noattr.
Definition Ptr(id:ident)(ty:type):expr := Evalof(Evar id(tptr ty))(tptr ty).
Definition Field(id:ident)(fid:ident):expr := Efield(Evalof(Ederef(Ptr id vt)vt)vt)fid tfloat.
Definition Vec(fid:ident):expr := Evalof(Field Source._va fid)tfloat.
Definition Mat(i:Z):expr := Evalof(Ederef(Ebinop Oadd
 (Evalof(Efield(Evalof(Ederef(Ptr Source._m_a2b rt)rt)rt)Source._m(tarray tfloat 9))(tarray tfloat 9))
 (Eval(Vint(Int.repr i))tint)(tptr tfloat))tfloat)tfloat.
Definition RowExpr(i:Z):expr := Ebinop Oadd(Ebinop Oadd
 (Ebinop Omul(Mat i)(Vec Source._x)tfloat)
 (Ebinop Omul(Mat(i+1))(Vec Source._y)tfloat)tfloat)
 (Ebinop Omul(Mat(i+2))(Vec Source._z)tfloat)tfloat.
Definition Row(f v:Z->float32)(i:Z):float32 :=
 Float32.add(Float32.add(Float32.mul(f i)(v 0))(Float32.mul(f(i+1))(v 1)))(Float32.mul(f(i+2))(v 2)).
Definition Reads(m:mem)(b:block)(p:ptrofs)(n:Z)(f:Z->float32):Prop :=
 (4|Ptrofs.unsigned p) /\ Ptrofs.unsigned p+4*n<=Ptrofs.modulus /\
 (forall i,0<=i<n->Mem.load Mfloat32 m b(Ptrofs.unsigned p+4*i)=Some(Vsingle(f i))).
Definition Args(bo br bv:block)(po pr pv:ptrofs):list val := [Vptr bo po;Vptr br pr;Vptr bv pv].
Definition Precondition(args:list val)(m:mem):Prop :=
 exists bo br bv po pr pv f v,args=Args bo br bv po pr pv /\bo<>br /\bo<>bv /\br<>bv /\
 writable12 m bo po /\Reads m br pr 9 f /\Reads m bv pv 3 v.
Definition Frame(m mf:mem)(bo:block)(po:ptrofs):Prop :=
 forall b ofs n,Mem.valid_block m b->b<>bo \/ ofs+n<=Ptrofs.unsigned po \/ Ptrofs.unsigned po+12<=ofs ->
 Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Lemma read_valid:forall m b p n f,0<n->Reads m b p n f->Mem.valid_block m b.
Proof. intros m b p n f N [_[_ L]];eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(L 0 ltac:(lia))|constructor]. Qed.
Lemma read_pointer:forall m b p n f i,Reads m b p n f->0<=i<n->
 Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr(4*i)))=Ptrofs.unsigned p+4*i.
Proof. intros m b p n f i[_[NW L]]B;rewrite Ptrofs.add_unsigned.
 rewrite(Ptrofs.unsigned_repr(4*i)) by(pose proof(Ptrofs.unsigned_range p);change Ptrofs.max_unsigned with 18446744073709551615;change Ptrofs.modulus with 18446744073709551616 in NW;lia).
 apply Ptrofs.unsigned_repr;pose proof(Ptrofs.unsigned_range p);change Ptrofs.max_unsigned with 18446744073709551615;change Ptrofs.modulus with 18446744073709551616 in NW;lia. Qed.
Lemma vec_location:forall e m id bp b p fid delta,
 e!id=Some(bp,tptr vt)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 (fid=Source._x /\delta=0)\/(fid=Source._y /\delta=4)\/(fid=Source._z /\delta=8)->
 pure_lval Execution.ge e m(Field id fid)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof. intros e m id bp b p fid delta E L D;unfold Field;eapply struct_field.
 - unfold Ptr;eapply pointer_variable;eauto.
 - reflexivity.
 - destruct D as[[-> ->]|[[-> ->]|[-> ->]]];reflexivity. Qed.
Lemma vec_value:forall e m bp b p v fid i,
 e!Source._va=Some(bp,tptr vt)->Mem.load Mptr m bp 0=Some(Vptr b p)->Reads m b p 3 v->
 (fid=Source._x /\i=0)\/(fid=Source._y /\i=1)\/(fid=Source._z /\i=2)->
 pure_rval Execution.ge e m(Vec fid)=Some(Vsingle(v i)).
Proof. intros e m bp b p v fid i E L RD D.
 assert(B:0<=i<3)by(destruct D as[[-> ->]|[[-> ->]|[-> ->]]];lia).
 assert(LOC:pure_lval Execution.ge e m(Field Source._va fid)=Some(b,Ptrofs.add p(Ptrofs.repr(4*i)),Full)).
 { eapply vec_location;eauto;destruct D as[[-> ->]|[[-> ->]|[-> ->]]];simpl;tauto. }
 change(match pure_lval Execution.ge e m(Field Source._va fid)with Some(bb,pp,bf)=>match Cexec.do_deref_loc Execution.ge quiet_world tfloat m bb pp bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle(v i))).
 rewrite LOC;cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite(read_pointer _ _ _ _ _ _ RD B);rewrite zle_true by(destruct RD as[_[NW _]];change Ptrofs.modulus with 18446744073709551616 in NW|-*;cbn[size_chunk];lia).
 rewrite(proj2(proj2 RD) i B);reflexivity.
Qed.
Lemma mat_array:forall e m bp b p,
 e!Source._m_a2b=Some(bp,tptr rt)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 pure_rval Execution.ge e m
 (Evalof(Efield(Evalof(Ederef(Ptr Source._m_a2b rt)rt)rt)Source._m(tarray tfloat 9))(tarray tfloat 9))=Some(Vptr b p).
Proof.
 intros e m bp b p E L.
 assert(P:pure_rval Execution.ge e m(Ptr Source._m_a2b rt)=Some(Vptr b p))by(unfold Ptr;eapply pointer_variable;eauto).
 cbn[pure_rval pure_lval];rewrite ?dec_eq_true.
 fold(Ptr Source._m_a2b rt);fold(pure_rval Execution.ge e m(Ptr Source._m_a2b rt));rewrite P.
 change(Some(Vptr b(Ptrofs.add p(Ptrofs.repr 0)))=Some(Vptr b p)).
 rewrite Ptrofs.add_zero;reflexivity.
Qed.
Lemma mat_value:forall e m bp b p f i,
 e!Source._m_a2b=Some(bp,tptr rt)->Mem.load Mptr m bp 0=Some(Vptr b p)->Reads m b p 9 f->0<=i<9->
 pure_rval Execution.ge e m(Mat i)=Some(Vsingle(f i)).
Proof.
 intros e m bp b p f i E L RD B.
 pose proof(mat_array e m bp b p E L)as A.
 assert(C:i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia.
 change(match(match(match pure_rval Execution.ge e m(Evalof(Efield(Evalof(Ederef(Ptr Source._m_a2b rt)rt)rt)Source._m(tarray tfloat 9))(tarray tfloat 9))with
 |Some v=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)(Vint(Int.repr i))tint m|None=>None end)with Some(Vptr bb pp)=>Some(bb,pp,Full)|_=>None end)with
 |Some(bb,pp,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m bb pp bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle(f i))).
 rewrite A.
 destruct C as [-> | [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]]];
 match goal with |- _=Some(Vsingle(f ?j))=>change(match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m b(Ptrofs.add p(Ptrofs.repr(4*j)))Full with Some(_,_,v)=>Some v|None=>None end=Some(Vsingle(f j)))end;
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv];
 match goal with |- _=Some(Vsingle(f ?j))=>rewrite(read_pointer m b p 9 f j RD ltac:(lia))end;rewrite zle_true by(destruct RD as[_[NW _]];change Ptrofs.modulus with 18446744073709551616 in NW|-*;cbn[size_chunk];lia);
 match goal with |- _=Some(Vsingle(f ?j))=>rewrite(proj2(proj2 RD) j ltac:(lia))end;reflexivity.
Qed.
Lemma rval_mul:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Omul a b tfloat)=Some(Vsingle(Float32.mul x y)).
Proof. intros;change(match pure_rval Execution.ge e m a,pure_rval Execution.ge e m b with Some v,Some w=>sem_binary_operation Execution.ge Omul v(typeof a)w(typeof b)m|_,_=>None end=Some(Vsingle(Float32.mul x y)));rewrite H,H0,H1,H2;reflexivity. Qed.
Lemma rval_add:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Oadd a b tfloat)=Some(Vsingle(Float32.add x y)).
Proof. intros;change(match pure_rval Execution.ge e m a,pure_rval Execution.ge e m b with Some v,Some w=>sem_binary_operation Execution.ge Oadd v(typeof a)w(typeof b)m|_,_=>None end=Some(Vsingle(Float32.add x y)));rewrite H,H0,H1,H2;reflexivity. Qed.
Lemma row_value:forall e m bpr bpv br bv pr pv f v i,
 e!Source._m_a2b=Some(bpr,tptr rt)->e!Source._va=Some(bpv,tptr vt)->
 Mem.load Mptr m bpr 0=Some(Vptr br pr)->Mem.load Mptr m bpv 0=Some(Vptr bv pv)->
 Reads m br pr 9 f->Reads m bv pv 3 v->0<=i<=6->
 pure_rval Execution.ge e m(RowExpr i)=Some(Vsingle(Row f v i)).
Proof.
 intros e m bpr bpv br bv pr pv f v i ER EV LR LV RM RV I.
 unfold RowExpr,Row;eapply rval_add;try reflexivity.
 - eapply rval_add;try reflexivity.
   + eapply rval_mul;try reflexivity;[eapply mat_value;eauto;lia|eapply vec_value;eauto;left;auto].
   + eapply rval_mul;try reflexivity;[eapply mat_value;eauto;lia|eapply vec_value;eauto;right;left;auto].
 - eapply rval_mul;try reflexivity;[eapply mat_value;eauto;lia|eapply vec_value;eauto;right;right;auto].
Qed.
Lemma reads_store:forall m b p n f ch bw ofs value mf,
 Reads m b p n f->b<>bw->Mem.store ch m bw ofs value=Some mf->Reads mf b p n f.
Proof. intros m b p n f ch bw ofs value mf[AL[NW RD]]NE ST;repeat split;auto.
 intros i B;erewrite Mem.load_store_other by(exact ST||(left;congruence));apply RD;exact B. Qed.
Lemma reads_alloc:forall vars e m b p n f,Reads m b p n f->Reads(snd(Cexec.do_alloc_variables Execution.ge e m vars))b p n f.
Proof. intros vars e m b p n f[AL[NW RD]];repeat split;auto;intros i B;eapply allocation_load;apply RD;exact B. Qed.
Lemma writable_alloc:forall vars e m b p,writable12 m b p->writable12(snd(Cexec.do_alloc_variables Execution.ge e m vars))b p.
Proof. intros vars e m b p[AL[NW RP]];repeat split;auto;intros z B;eapply allocation_perm;apply RP;exact B. Qed.
Lemma body_syntax:fn_body Source.f_float_rmat_vmult=
 Ssequence(Sdo(Eassign(Field Source._vb Source._x)(RowExpr 0)tfloat))
 (Ssequence(Sdo(Eassign(Field Source._vb Source._y)(RowExpr 3)tfloat))
 (Sdo(Eassign(Field Source._vb Source._z)(RowExpr 6)tfloat))).
Proof. reflexivity. Qed.
Lemma row_assign:forall e m bpo bpr bpv bo br bv po pr pv f v fid delta i mf,
 e!Source._vb=Some(bpo,tptr vt)->e!Source._m_a2b=Some(bpr,tptr rt)->e!Source._va=Some(bpv,tptr vt)->
 Mem.load Mptr m bpo 0=Some(Vptr bo po)->Mem.load Mptr m bpr 0=Some(Vptr br pr)->Mem.load Mptr m bpv 0=Some(Vptr bv pv)->
 writable12 m bo po->Reads m br pr 9 f->Reads m bv pv 3 v->0<=i<=6->
 (fid=Source._x/\delta=0)\/(fid=Source._y/\delta=4)\/(fid=Source._z/\delta=8)->
 Mem.store Mfloat32 m bo(Ptrofs.unsigned po+delta)(Vsingle(Row f v i))=Some mf->
 atomic_eval Execution.ge e m(Eassign(Field Source._vb fid)(RowExpr i)tfloat)=Some(Vsingle(Row f v i),mf).
Proof.
 intros e m bpo bpr bpv bo br bv po pr pv f v fid delta i mf EO ER EV LO LR LV W RM RV B D ST.
 assert(DL:In delta[0;4;8])by(destruct D as[[-> ->]|[[-> ->]|[-> ->]]];simpl;auto).
 eapply assign_float;try reflexivity.
 - eapply vec_location;eauto.
 - eapply row_value;eauto.
 - rewrite(field_pointer _ _ _ _ W DL);destruct W as[_[NW _]];destruct DL as[<-|[<-|[<-|[]]]];lia.
 - rewrite(field_pointer _ _ _ _ W DL);exact ST.
Qed.
Lemma body_eval:forall e m bpo bpr bpv bo br bv po pr pv f v mf,
 e!Source._vb=Some(bpo,tptr vt)->e!Source._m_a2b=Some(bpr,tptr rt)->e!Source._va=Some(bpv,tptr vt)->
 Mem.load Mptr m bpo 0=Some(Vptr bo po)->Mem.load Mptr m bpr 0=Some(Vptr br pr)->Mem.load Mptr m bpv 0=Some(Vptr bv pv)->
 writable12 m bo po->Reads m br pr 9 f->Reads m bv pv 3 v->
 bo<>br->bo<>bv->bo<>bpo->bo<>bpr->bo<>bpv->
 three_stores m bo po(Row f v 0)(Row f v 3)(Row f v 6)mf->
 stmt_eval Execution.ge e tvoid(fn_body Source.f_float_rmat_vmult)m=Some(Nnormal,mf).
Proof.
 intros e m bpo bpr bpv bo br bv po pr pv f v mf EO ER EV LO LR LV W RM RV OR OV OP OPR OPV[m1[m2[S0[S1 S2]]]].
 assert(W1:writable12 m1 bo po)by(eapply store_preserves_writable12;eauto).
 assert(W2:writable12 m2 bo po)by(eapply store_preserves_writable12;eauto).
 assert(RM1:Reads m1 br pr 9 f)by(eapply reads_store;eauto).
 assert(RM2:Reads m2 br pr 9 f)by(eapply reads_store;eauto).
 assert(RV1:Reads m1 bv pv 3 v)by(eapply reads_store;eauto).
 assert(RV2:Reads m2 bv pv 3 v)by(eapply reads_store;eauto).
 assert(LO1:Mem.load Mptr m1 bpo 0=Some(Vptr bo po))by(erewrite Mem.load_store_other by(exact S0||(left;congruence));exact LO).
 assert(LR1:Mem.load Mptr m1 bpr 0=Some(Vptr br pr))by(erewrite Mem.load_store_other by(exact S0||(left;congruence));exact LR).
 assert(LV1:Mem.load Mptr m1 bpv 0=Some(Vptr bv pv))by(erewrite Mem.load_store_other by(exact S0||(left;congruence));exact LV).
 assert(LO2:Mem.load Mptr m2 bpo 0=Some(Vptr bo po))by(erewrite Mem.load_store_other by(exact S1||(left;congruence));exact LO1).
 assert(LR2:Mem.load Mptr m2 bpr 0=Some(Vptr br pr))by(erewrite Mem.load_store_other by(exact S1||(left;congruence));exact LR1).
 assert(LV2:Mem.load Mptr m2 bpv 0=Some(Vptr bv pv))by(erewrite Mem.load_store_other by(exact S1||(left;congruence));exact LV1).
 assert(A0:atomic_eval Execution.ge e m(Eassign(Field Source._vb Source._x)(RowExpr 0)tfloat)=Some(Vsingle(Row f v 0),m1))by(eapply row_assign;eauto;try lia;left;auto).
 assert(A1:atomic_eval Execution.ge e m1(Eassign(Field Source._vb Source._y)(RowExpr 3)tfloat)=Some(Vsingle(Row f v 3),m2))by(eapply row_assign;eauto;try lia;right;left;auto).
 assert(A2:atomic_eval Execution.ge e m2(Eassign(Field Source._vb Source._z)(RowExpr 6)tfloat)=Some(Vsingle(Row f v 6),mf))by(eapply row_assign;eauto;try lia;right;right;auto).
 rewrite body_syntax;cbn[stmt_eval];rewrite A0,A1,A2;reflexivity.
Qed.
