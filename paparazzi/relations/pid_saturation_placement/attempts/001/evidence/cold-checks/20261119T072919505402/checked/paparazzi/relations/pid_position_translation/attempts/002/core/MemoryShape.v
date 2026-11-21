From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Globalenvs Ctypes Csem Cexec.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory.
Import ListNotations.
Open Scope Z_scope.
Fixpoint advance(n:nat)(b:block):block:=match n with O=>b|S n=>Pos.succ(advance n b)end.
Definition same_permissions(m mf:mem):Prop:=
 forall b z k p,Mem.perm mf b z k p <->Mem.perm m b z k p.
Definition stack_shape(m mf:mem)(count:nat):Prop:=
 Mem.nextblock mf=advance count(Mem.nextblock m) /\same_permissions m mf.
Lemma same_permissions_trans:forall a b c,same_permissions a b ->same_permissions b c ->same_permissions a c.
Proof. intros a b c AB BC x z k p;rewrite(BC x z k p),(AB x z k p);reflexivity. Qed.
Lemma raw_writes_shape:forall P m mf,raw_writes P m mf ->
 Mem.nextblock mf=Mem.nextblock m /\same_permissions m mf.
Proof.
 intros P m mf W;induction W.
 - split;[reflexivity|intros b z k p;reflexivity].
 - destruct IHW as[NB PERM];split;[rewrite NB;eapply Mem.nextblock_store;exact H0|].
   intros b0 z k p;rewrite(PERM b0 z k p);split;[eapply Mem.perm_store_2|eapply Mem.perm_store_1];exact H0.
 - destruct IHW as[NB PERM];split;[rewrite NB;eapply Mem.nextblock_storebytes;exact H0|].
   intros b0 z k p;rewrite(PERM b0 z k p);split;[eapply Mem.perm_storebytes_2|eapply Mem.perm_storebytes_1];exact H0.
Qed.
Lemma replay_stores_same_permissions:forall us m mf,
 replay_stores m us=Some mf ->same_permissions m mf.
Proof.
 induction us as[|[[[ch b]o]v]us IH];intros m mf RUN;cbn[replay_stores]in RUN.
 - injection RUN as<-;intros b z k p;reflexivity.
 - destruct(Mem.store ch m b o v)as[ma|]eqn:ST;try discriminate.
   intros b0 z k p;rewrite(IH ma mf RUN b0 z k p);split;[eapply Mem.perm_store_2|eapply Mem.perm_store_1];exact ST.
Qed.
Lemma iter_succ_commute:forall n b,advance n(Pos.succ b)=Pos.succ(advance n b).
Proof. induction n;intros;cbn[advance];[reflexivity|rewrite IHn;reflexivity]. Qed.
Lemma advance_add:forall a b p,advance(a+b)p=advance a(advance b p).
Proof. induction a;intros;cbn[advance Nat.add];[reflexivity|rewrite IHa;reflexivity]. Qed.
Lemma allocation_nextblock:forall ge vars e m,
 Mem.nextblock(snd(Cexec.do_alloc_variables ge e m vars))=
 advance(length vars)(Mem.nextblock m).
Proof.
 intros ge vars;induction vars as[|[id ty]vars IH];intros e m;cbn[Cexec.do_alloc_variables length].
 - reflexivity.
 - destruct(Mem.alloc m 0(sizeof ge ty))as[ma b]eqn:AL;rewrite IH.
   rewrite(Mem.nextblock_alloc _ _ _ _ _ AL);apply iter_succ_commute.
Qed.
Lemma allocation_permission_origin:forall ge vars e m,
 NoDup(map fst vars) ->
 forall b z k p,Mem.perm(snd(Cexec.do_alloc_variables ge e m vars))b z k p ->
 Mem.perm m b z k p \/exists id ty,
 (fst(Cexec.do_alloc_variables ge e m vars))!id=Some(b,ty) /\0<=z<sizeof ge ty.
Proof.
 intros ge vars;induction vars as[|[head ty]vars IH];intros e m ND b z k p PERM.
 - left;exact PERM.
 - inversion ND as[|id ids NOT DUP];subst.
   cbn[Cexec.do_alloc_variables]in *.
   destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:AL.
   destruct(IH(PTree.set head(fresh,ty)e)ma DUP b z k p PERM)as[OLD|[id[ty0[LOOK BOUND]]]].
   + destruct(peq b fresh)as[EQ|NE].
     * subst b;right;exists head,ty;split.
       -- rewrite(allocation_keeps_binding ge vars(PTree.set head(fresh,ty)e)ma head NOT);apply PTree.gss.
       -- eapply Mem.perm_alloc_3;[exact AL|exact OLD].
     * left;eapply Mem.perm_alloc_4;[exact AL|exact OLD|exact NE].
   + right;exists id,ty0;auto.
Qed.
Lemma free_list_nextblock:forall regions m mf,
 Mem.free_list m regions=Some mf ->Mem.nextblock mf=Mem.nextblock m.
Proof.
 induction regions as[|[[b lo]hi]rs IH];intros m mf FREE;cbn[Mem.free_list]in FREE.
 - injection FREE as<-;reflexivity.
 - destruct(Mem.free m b lo hi)as[ma|]eqn:FR;try discriminate.
   rewrite(IH ma mf FREE);eapply Mem.nextblock_free;exact FR.
Qed.
Lemma free_list_perm_outside:forall regions m mf,
 Mem.free_list m regions=Some mf ->forall b z k p,
 ~In b(map region_block regions) ->Mem.perm m b z k p ->Mem.perm mf b z k p.
Proof.
 induction regions as[|[[head lo]hi]rs IH];intros m mf FREE b z k p OUT PERM;cbn[Mem.free_list]in FREE.
 - injection FREE as<-;exact PERM.
 - destruct(Mem.free m head lo hi)as[ma|]eqn:FR;try discriminate.
   eapply IH;[exact FREE|cbn in OUT;tauto|].
   eapply Mem.perm_free_1;[exact FR|left;cbn in OUT;intuition congruence|exact PERM].
Qed.
Lemma environment_region_member:forall(ge:Csem.genv)(e:env)id b ty,
 e!id=Some(b,ty) ->In(b,0,sizeof ge ty)(blocks_of_env ge e).
Proof.
 intros ge e id b ty LOOK;unfold blocks_of_env;apply in_map_iff.
 exists(id,(b,ty));split;[reflexivity|apply PTree.elements_correct;exact LOOK].
Qed.
Lemma finish_stack_permissions:forall ge decl e m ma body mf,
 NoDup(map fst decl) ->
 Cexec.do_alloc_variables ge empty_env m decl=(e,ma) ->
 (forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b) ->
 same_permissions ma body ->
 Mem.free_list body(blocks_of_env ge e)=Some mf ->
 same_permissions m mf.
Proof.
 intros ge decl e m ma body mf ND AL FRESH BODY FREE b z k p;split.
 - intro PERM;destruct(Mem.perm_free_list _ _ _ _ _ _ _ FREE PERM)as[PB OUT].
   apply BODY in PB.
   pose proof(allocation_permission_origin ge decl empty_env m ND b z k p)as ORIGIN.
   rewrite AL in ORIGIN;cbn in ORIGIN.
   destruct(ORIGIN PB)as[OLD|[id[ty[LOOK BOUND]]]];[exact OLD|].
   exfalso;eapply OUT;[eapply environment_region_member;exact LOOK|exact BOUND].
 - intro PERM;apply(free_list_perm_outside _ _ _ FREE b z k p).
   + intro IN;unfold blocks_of_env in IN;rewrite map_map in IN;apply in_map_iff in IN as[[id[bx ty]][EQ IN]].
     cbn in EQ;subst bx;apply(FRESH id b ty).
     * eapply PTree.elements_complete;exact IN.
     * eapply Mem.perm_valid_block;exact PERM.
   + apply BODY.
     pose proof(allocation_perm ge decl empty_env m b z k p PERM)as AP;rewrite AL in AP;exact AP.
Qed.
Lemma finish_stack_shape:forall ge decl e m ma body mf nested,
 NoDup(map fst decl) ->Cexec.do_alloc_variables ge empty_env m decl=(e,ma) ->
 (forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b) ->
 stack_shape ma body nested ->
 Mem.free_list body(blocks_of_env ge e)=Some mf ->
 stack_shape m mf(length decl+nested).
Proof.
 intros ge decl e m ma body mf nested ND AL FRESH[NB PERM]FREE;split.
 - rewrite(free_list_nextblock _ _ _ FREE),NB.
   pose proof(allocation_nextblock ge decl empty_env m)as ANB;rewrite AL in ANB;cbn in ANB;rewrite ANB.
   rewrite Nat.add_comm,advance_add;reflexivity.
 - eapply finish_stack_permissions;eauto.
Qed.
Print Assumptions finish_stack_shape.
