From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csem Cexec.
Import ListNotations.
Local Open Scope Z_scope.

Section STACK.
Variable ge:Csem.genv.
Lemma allocation_load : forall vars e m ch b ofs v,
 Mem.load ch m b ofs=Some v ->
 Mem.load ch (snd(Cexec.do_alloc_variables ge e m vars))b ofs=Some v.
Proof.
 induction vars as[|[id ty] vars IH];intros e m ch b ofs v LD;cbn [Cexec.do_alloc_variables];[exact LD|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A;apply IH.
 eapply Mem.load_alloc_other;eauto.
Qed.
Lemma allocation_perm : forall vars e m b ofs k p,
 Mem.perm m b ofs k p -> Mem.perm(snd(Cexec.do_alloc_variables ge e m vars))b ofs k p.
Proof.
 induction vars as[|[id ty]vars IH];intros e m b ofs k p PER;cbn [Cexec.do_alloc_variables];[exact PER|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A;apply IH.
 eapply Mem.perm_alloc_1;eauto.
Qed.
Lemma allocation_valid_block : forall vars e m b,
 Mem.valid_block m b -> Mem.valid_block(snd(Cexec.do_alloc_variables ge e m vars))b.
Proof.
 induction vars as[|[id ty]vars IH];intros e m b VB;cbn [Cexec.do_alloc_variables];[exact VB|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A;apply IH.
 eapply Mem.valid_block_alloc;eauto.
Qed.
Lemma allocation_keeps_binding : forall vars e m id,
 ~In id(map fst vars) ->
 (fst(Cexec.do_alloc_variables ge e m vars))!id=e!id.
Proof.
 induction vars as[|[head ty]vars IH];intros e m id NOT;cbn [Cexec.do_alloc_variables];[reflexivity|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A.
 rewrite IH by(simpl in NOT;tauto).
 apply PTree.gso;intro EQ;subst;simpl in NOT;tauto.
Qed.
Definition env_valid (m:mem)(e:env):Prop := forall id b ty,e!id=Some(b,ty)->Mem.valid_block m b.
Definition env_separated (e:env):Prop := forall id1 id2 b ty1 ty2,
 e!id1=Some(b,ty1)->e!id2=Some(b,ty2)->id1=id2.
Lemma allocation_env_valid : forall vars e m,
 env_valid m e -> env_valid(snd(Cexec.do_alloc_variables ge e m vars))(fst(Cexec.do_alloc_variables ge e m vars)).
Proof.
 induction vars as[|[head ty]vars IH];intros e m VALID;cbn [Cexec.do_alloc_variables];[exact VALID|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A;apply IH.
 intros id b t LOOK;rewrite PTree.gsspec in LOOK;destruct(peq id head).
 - injection LOOK as EQ _;subst b;eapply Mem.valid_new_block;exact A.
 - eapply Mem.valid_block_alloc;[exact A|eapply VALID;exact LOOK].
Qed.
Lemma allocation_env_separated : forall vars e m,
 env_valid m e -> env_separated e -> env_separated(fst(Cexec.do_alloc_variables ge e m vars)).
Proof.
 induction vars as[|[head ty]vars IH];intros e m VALID SEP;cbn [Cexec.do_alloc_variables];[exact SEP|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A;apply IH.
 - intros id b t LOOK;rewrite PTree.gsspec in LOOK;destruct(peq id head).
   + injection LOOK as EQ _;subst b;eapply Mem.valid_new_block;exact A.
   + eapply Mem.valid_block_alloc;[exact A|eapply VALID;exact LOOK].
 - intros id1 id2 b t1 t2 L1 L2.
   rewrite PTree.gsspec in L1,L2;destruct(peq id1 head), (peq id2 head);subst;auto.
   + injection L1 as EQ _;subst b;exfalso.
     eapply(Mem.fresh_block_alloc _ _ _ _ _ A);eapply VALID;exact L2.
   + injection L2 as EQ _;subst b;exfalso.
     eapply(Mem.fresh_block_alloc _ _ _ _ _ A);eapply VALID;exact L1.
   + eapply SEP;eauto.
Qed.
Lemma allocated_variable : forall vars e m id ty,
 NoDup(map fst vars) -> In(id,ty)vars ->
 exists b,
 (fst(Cexec.do_alloc_variables ge e m vars))!id=Some(b,ty) /\
 ~Mem.valid_block m b /\
 Mem.valid_block(snd(Cexec.do_alloc_variables ge e m vars))b /\
 Mem.range_perm(snd(Cexec.do_alloc_variables ge e m vars))b 0(sizeof ge ty)Cur Freeable.
Proof.
 induction vars as[|[head ht]vars IH];intros e m id ty ND IN;[contradiction|].
 inversion ND as[|? ? NOT NDREST];subst.
 cbn [Cexec.do_alloc_variables].
 destruct(Mem.alloc m 0(sizeof ge ht))as[ma fresh]eqn:A.
 destruct IN as[EQ|IN].
 - injection EQ as EID ET;subst head ht;exists fresh;split.
   + rewrite allocation_keeps_binding by exact NOT;apply PTree.gss.
   + split;[eapply Mem.fresh_block_alloc;exact A|]. split.
     * apply allocation_valid_block;eapply Mem.valid_new_block;exact A.
     * intros ofs RANGE;apply allocation_perm;eapply Mem.perm_alloc_2;[exact A|exact RANGE].
 - destruct(IH(PTree.set head(fresh,ht)e)ma id ty NDREST IN)as[b[LOOK[FRESH[VB PERM]]]].
   exists b;split;[exact LOOK|]. split.
   + intro OLD;apply FRESH;eapply Mem.valid_block_alloc;[exact A|exact OLD].
   + split;assumption.
Qed.
End STACK.
Print Assumptions allocated_variable.
Print Assumptions allocation_env_separated.
