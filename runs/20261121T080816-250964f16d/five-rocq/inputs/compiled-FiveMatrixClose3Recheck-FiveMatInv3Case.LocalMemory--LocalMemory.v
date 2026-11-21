From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceEntry Require Import StackCleanup.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveLowpassSupport Require Import Expressions.
From FivePprzFloatMatInv3d Require Import Source Execution.
From FiveMatInv3Case Require Import MatrixMemory MatrixAccess Scalar.
Import ListNotations.
Local Open Scope Z_scope.
Definition Known(e:env)(m:mem)(vs:PTree.t float32):Prop:=forall id x,vs!id=Some x->exists b,e!id=Some(b,tfloat)/\Mem.load Mfloat32 m b 0=Some(Vsingle x).
Definition FullFrame(m0 m:mem):Prop:=forall b z n,Mem.valid_block m0 b->Mem.loadbytes m b z n=Mem.loadbytes m0 b z n.
Definition Access(m0 m:mem):Prop:=forall ch b z p,Mem.valid_access m0 ch b z p->Mem.valid_access m ch b z p.
Definition Outside(e:env)(b:block):Prop:=forall id ty,e!id=Some(b,ty)->False.
Record Core(e:env)(bpo bpi bo bi:block)(po pi:ptrofs)(f:Z->float32)(vs:PTree.t float32)(m:mem):Prop:={
 core_free:forall id b ty,e!id=Some(b,ty)->Mem.range_perm m b 0(sizeof Execution.ge ty)Cur Freeable;
 core_outptr:Mem.load Mptr m bpo 0=Some(Vptr bo po);
 core_inptr:Mem.load Mptr m bpi 0=Some(Vptr bi pi);
 core_reads:Reads m bi pi 9 f;
 core_write:WriteRegion m bo po 9;
 core_known:Known e m vs
}.
Lemma known_empty:forall e m,Known e m(PTree.empty float32).
Proof. intros e m id x H;rewrite PTree.gempty in H;discriminate. Qed.
Lemma known_value:forall e m vs id x,Known e m vs->vs!id=Some x->pure_rval Execution.ge e m(Local id)=Some(Vsingle x).
Proof. intros e m vs id x K V;destruct(K id x V)as[b[E L]];unfold Local;eapply float_variable;eauto. Qed.
Lemma known_store:forall e m vs id bx x mf,
 env_separated e->Known e m vs->e!id=Some(bx,tfloat)->Mem.store Mfloat32 m bx 0(Vsingle x)=Some mf->Known e mf(PTree.set id x vs).
Proof. intros e m vs id bx x mf SEP K E ST j y LOOK;rewrite PTree.gsspec in LOOK;destruct(peq j id).
 - subst j;injection LOOK as<-;exists bx;split;[exact E|erewrite Mem.load_store_same by exact ST;reflexivity].
 - destruct(K j y LOOK)as[bj[EJ LJ]];exists bj;split;[exact EJ|].
   erewrite Mem.load_store_other;[exact LJ|exact ST|left;intro EQ;subst bj;apply n;eapply SEP;eauto]. Qed.
Lemma local_slot_distinct:forall e id bx pid bp ty,
 env_separated e->e!id=Some(bx,tfloat)->e!pid=Some(bp,tptr ty)->bx<>bp.
Proof. intros e id bx pid bp ty SEP E P EQ;subst bp;assert(id=pid)by(eapply SEP;eauto);subst pid;rewrite E in P;discriminate. Qed.
Lemma fullframe_store_local:forall e m0 m bx id ty x mf,
 (forall b,Mem.valid_block m0 b->Outside e b)->e!id=Some(bx,ty)->
 FullFrame m0 m->Mem.store Mfloat32 m bx 0(Vsingle x)=Some mf->FullFrame m0 mf.
Proof. intros e m0 m bx id ty x mf F E FRAME ST b z n V;erewrite Mem.loadbytes_store_other;[apply FRAME;exact V|exact ST|left;intro EQ;subst b;exact(F bx V id ty E)]. Qed.
Lemma access_store:forall m mf ch b z v,Mem.store ch m b z v=Some mf->Access m mf.
Proof. intros m mf ch b z v ST ch' b' z' p VA;eapply Mem.store_valid_access_1;eauto. Qed.
Lemma access_trans:forall m0 m1 m2,Access m0 m1->Access m1 m2->Access m0 m2.
Proof. unfold Access;auto. Qed.
Lemma local_step:forall e bpo bpi bo bi po pi f vs m id bx x rhs,
 env_separated e->Outside e bi->
 e!Source._inv_out=Some(bpo,tptr(tarray tfloat 3))->e!Source._mat_in=Some(bpi,tptr(tarray tfloat 3))->
 e!id=Some(bx,tfloat)->Core e bpo bpi bo bi po pi f vs m->
 typeof rhs=tfloat->pure_rval Execution.ge e m rhs=Some(Vsingle x)->
 exists mf,Mem.store Mfloat32 m bx 0(Vsingle x)=Some mf /\
 atomic_eval Execution.ge e m(Eassign(Evar id tfloat)rhs tfloat)=Some(Vsingle x,mf) /\
 Core e bpo bpi bo bi po pi f(PTree.set id x vs)mf.
Proof.
 intros e bpo bpi bo bi po pi f vs m id bx x rhs SEP OI EO EI E C TY R.
 assert(VA:Mem.valid_access m Mfloat32 bx 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros z B;apply(core_free _ _ _ _ _ _ _ _ _ _ C id bx tfloat E);change(0<=z<4);exact B|exists 0;lia]. }
 destruct(Mem.valid_access_store m Mfloat32 bx 0(Vsingle x)VA)as[mf ST].
 exists mf;split;[exact ST|];split.
 - eapply(assign_float Execution.ge e m(Evar id tfloat)rhs bx Ptrofs.zero x mf);[reflexivity|exact TY| |exact R|change(0+4<=18446744073709551616);lia|exact ST].
   cbn[pure_lval];rewrite E,dec_eq_true;reflexivity.
 - destruct C as[FREE LO LI RD W K];constructor.
   + intros j bj tj EJ z B;eapply Mem.perm_store_1;[exact ST|eapply FREE;eauto].
   + erewrite Mem.load_store_other;[exact LO|exact ST|left;intro EQ;apply(local_slot_distinct e id bx Source._inv_out bpo(tarray tfloat 3)SEP E EO);symmetry;exact EQ].
   + erewrite Mem.load_store_other;[exact LI|exact ST|left;intro EQ;apply(local_slot_distinct e id bx Source._mat_in bpi(tarray tfloat 3)SEP E EI);symmetry;exact EQ].
   + eapply(reads_store_preserved m bi pi 9 f Mfloat32 bx 0(Vsingle x)mf);[exact RD|intro EQ;subst bi;exact(OI id tfloat E)|exact ST].
   + eapply writable_store_preserved;eauto.
   + eapply known_store;eauto.
Qed.
Fixpoint Updated(vs:PTree.t float32)(ys:list(ident*float32)):PTree.t float32:=match ys with []=>vs|(id,x)::ys=>Updated(PTree.set id x vs)ys end.
Fixpoint PrefixValid(e:env)(bpo bpi bo bi:block)(po pi:ptrofs)(f:Z->float32)(vs:PTree.t float32)(xs:list(ident*expr))(ys:list(ident*float32)):Prop:=
 match xs,ys with
 |[],[]=>True
 |(id,r)::xs,(j,x)::ys=>id=j /\ typeof r=tfloat /\
 (forall m,Core e bpo bpi bo bi po pi f vs m->pure_rval Execution.ge e m r=Some(Vsingle x)) /\
 PrefixValid e bpo bpi bo bi po pi f(PTree.set id x vs)xs ys
 |_,_=>False end.
Lemma prefix_execute:forall xs ys e bpo bpi bo bi po pi f vs m m0,
 env_separated e->Outside e bi->
 e!Source._inv_out=Some(bpo,tptr(tarray tfloat 3))->e!Source._mat_in=Some(bpi,tptr(tarray tfloat 3))->
 (forall id r,In(id,r)xs->exists bx,e!id=Some(bx,tfloat))->
 (forall b,Mem.valid_block m0 b->Outside e b)->
 Core e bpo bpi bo bi po pi f vs m->FullFrame m0 m->Access m0 m->
 PrefixValid e bpo bpi bo bi po pi f vs xs ys->
 exists mf,(forall tail,stmt_eval Execution.ge e tbool(PrefixStmt xs tail)m=stmt_eval Execution.ge e tbool tail mf) /\
 Core e bpo bpi bo bi po pi f(Updated vs ys)mf /\ FullFrame m0 mf /\ Access m0 mf /\ Mem.nextblock mf=Mem.nextblock m.
Proof.
 induction xs as[|[id rhs]xs IH];intros ys e bpo bpi bo bi po pi f vs m m0 SEP OI EO EI AVAILABLE FRESH C FRAME ACC PV;destruct ys as[|[j x]ys];cbn[PrefixValid]in PV;try contradiction.
 - exists m;cbn[Updated PrefixStmt];auto.
 - destruct PV as[<- [TY[RV REST]]].
   destruct(AVAILABLE id rhs(or_introl eq_refl))as[bx E].
   destruct(local_step e bpo bpi bo bi po pi f vs m id bx x rhs SEP OI EO EI E C TY(RV m C))as[m1[ST[AE C1]]].
   destruct(IH ys e bpo bpi bo bi po pi f(PTree.set id x vs)m1 m0 SEP OI EO EI
    ltac:(intros k r IN;apply AVAILABLE with r;right;exact IN) FRESH C1
    (fullframe_store_local e m0 m bx id tfloat x m1 FRESH E FRAME ST)
    (access_trans m0 m m1 ACC(access_store _ _ _ _ _ _ ST)) REST)as[mf[EV[CF[FF[AF NB]]]]].
   exists mf;split;[intros tail;cbn[PrefixStmt stmt_eval];rewrite AE;apply EV|].
   split;[exact CF|];split;[exact FF|];split;[exact AF|].
   rewrite NB;exact(Mem.nextblock_store _ _ _ _ _ _ ST).
Qed.
Print Assumptions prefix_execute.
