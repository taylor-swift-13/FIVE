From Stdlib Require Import List ZArith Lia Classical_Prop.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
Import ListNotations.
Local Open Scope Z_scope.

(** Allocation never reuses a valid block; stores preserve permissions and free
    only removes them.  CompCert's external-call specification has the same
    old-block Max-permission condition. *)
Record old_forward(m m':mem):Prop:={
 old_valid:forall b,Mem.valid_block m b ->Mem.valid_block m' b;
 old_max:forall b ofs p,Mem.valid_block m b ->Mem.perm m' b ofs Max p ->Mem.perm m b ofs Max p
}.
Lemma forward_refl:forall m,old_forward m m.
Proof. intros;constructor;auto. Qed.
Lemma forward_trans:forall a b c,old_forward a b ->old_forward b c ->old_forward a c.
Proof. intros a b c A B;constructor;intros;eauto using old_valid,old_max. Qed.
Lemma forward_store:forall ch m b ofs v m',Mem.store ch m b ofs v=Some m' ->old_forward m m'.
Proof. intros;constructor;intros;eauto using Mem.store_valid_block_1,Mem.perm_store_2. Qed.
Lemma forward_storev:forall ch m addr v m',Mem.storev ch m addr v=Some m' ->old_forward m m'.
Proof. intros ch m addr v m' H;destruct addr;try discriminate H;eapply forward_store;exact H. Qed.
Lemma forward_storebytes:forall m b ofs bytes m',Mem.storebytes m b ofs bytes=Some m' ->old_forward m m'.
Proof. intros;constructor;intros;eauto using Mem.storebytes_valid_block_1,Mem.perm_storebytes_2. Qed.
Lemma forward_alloc:forall m lo hi m' b,Mem.alloc m lo hi=(m',b) ->old_forward m m'.
Proof.
 intros m lo hi m' b AL;constructor;intros.
 - eapply Mem.valid_block_alloc;eauto.
 - eapply Mem.perm_alloc_4;eauto. intro EQ;subst b0;exact(Mem.fresh_block_alloc _ _ _ _ _ AL H).
Qed.
Lemma forward_free:forall m b lo hi m',Mem.free m b lo hi=Some m' ->old_forward m m'.
Proof. intros;constructor;intros;eauto using Mem.valid_block_free_1,Mem.perm_free_3. Qed.
Lemma forward_free_list:forall blocks m m',Mem.free_list m blocks=Some m' ->old_forward m m'.
Proof.
 induction blocks as[|[[b lo]hi]rest IH];intros m m' H;cbn[Mem.free_list]in H.
 - inversion H;apply forward_refl.
 - destruct(Mem.free m b lo hi)as[mi|]eqn:F;try discriminate.
   eapply forward_trans;[eapply forward_free;exact F|eapply IH;exact H].
Qed.
Lemma forward_external:forall ef ge args m t v m',external_call ef ge args m t v m' ->old_forward m m'.
Proof. intros;constructor;intros;eauto using external_call_valid_block,external_call_max_perm. Qed.
Lemma forward_volatile_store:forall ge ch m b ofs v t m',volatile_store ge ch m b ofs v t m' ->old_forward m m'.
Proof. intros;inversion H;subst;[apply forward_refl|eapply forward_storev;eassumption]. Qed.
Lemma forward_bitfield:forall ty sz sg pos width m addr v m' v',store_bitfield ty sz sg pos width m addr v m' v' ->old_forward m m'.
Proof. intros;inversion H;subst;eapply forward_storev;eassumption. Qed.
Lemma forward_assign:forall ge ty m b ofs bf v t m' v',assign_loc ge ty m b ofs bf v t m' v' ->old_forward m m'.
Proof. intros;inversion H;subst;eauto using forward_storev,forward_storebytes,forward_volatile_store,forward_bitfield. Qed.
Lemma forward_alloc_variables:forall ge e m vars e' m',alloc_variables ge e m vars e' m' ->old_forward m m'.
Proof. intros;induction H;[apply forward_refl|eapply forward_trans;eauto using forward_alloc]. Qed.
Lemma forward_bind_parameters:forall ge e m params args m',bind_parameters ge e m params args m' ->old_forward m m'.
Proof. intros;induction H;[apply forward_refl|eapply forward_trans;eauto using forward_assign]. Qed.
Lemma forward_lred:forall ge e a m a' m',lred ge e a m a' m' ->old_forward m m'.
Proof. intros;inversion H;subst;apply forward_refl. Qed.
Lemma forward_rred:forall ge a m t a' m',rred ge a m t a' m' ->old_forward m m'.
Proof. intros;inversion H;subst;eauto using forward_refl,forward_assign,forward_external. Qed.
Definition state_mem(s:Csem.state):option mem:=match s with
|State _ _ _ _ m|ExprState _ _ _ _ m|Callstate _ _ _ m|Returnstate _ _ m=>Some m
|Stuckstate=>None end.
Lemma original_step_forward:forall ge s t next m m',Csem.step ge s t next ->state_mem s=Some m ->state_mem next=Some m' ->old_forward m m'.
Proof.
 intros ge s t next m m' [ES|SS] A B.
 - inversion ES;subst;cbn[state_mem]in A,B;try discriminate;inversion A;inversion B;subst;eauto using forward_refl,forward_lred,forward_rred.
 - inversion SS;subst;cbn[state_mem]in A,B;try discriminate;inversion A;inversion B;subst;eauto using forward_refl,forward_free_list,forward_external.
   eapply forward_trans;eauto using forward_alloc_variables,forward_bind_parameters.
Qed.
Definition global_bounds(b:block)(size:Z)(m:mem):Prop:=Mem.valid_block m b /\forall ofs,Mem.perm m b ofs Max Nonempty ->0<=ofs<size.
Definition global_state(b:block)(size:Z)(s:Csem.state):Prop:=match state_mem s with Some m=>global_bounds b size m|None=>True end.
Lemma global_forward:forall b sz m m',old_forward m m' ->global_bounds b sz m ->global_bounds b sz m'.
Proof. intros b sz m m' F[V B];split;[eapply old_valid;eauto|intros;apply B;eapply old_max;eauto]. Qed.
Lemma global_step:forall ge b sz s t next,global_state b sz s ->Csem.step ge s t next ->global_state b sz next.
Proof.
 intros ge b sz s t next B STEP;unfold global_state in *.
 destruct(state_mem next)as[m'|]eqn:N;[|exact I].
 destruct(state_mem s)as[m|]eqn:S.
 - eapply global_forward;[eapply original_step_forward;eauto|exact B].
 - destruct s;try discriminate S;destruct STEP as[E|E];inversion E.
Qed.
Theorem global_bounds_reachable:forall ge initial b size prefix s,
 global_state b size initial ->star Csem.step ge initial prefix s ->global_state b size s.
Proof. intros ge initial b size prefix s B H;induction H;[exact B|apply IHstar;eapply global_step;eauto]. Qed.
Lemma global_load_range:forall m b size ch ofs v,global_bounds b size m ->Mem.load ch m b ofs=Some v ->0<=ofs<size.
Proof.
 intros m b size ch ofs v[V B]L;apply B;eapply Mem.perm_max.
 eapply Mem.perm_implies;[eapply Mem.valid_access_perm;eapply Mem.load_valid_access;exact L|constructor].
Qed.
Lemma global_store_range:forall m b size ch ofs v m',global_bounds b size m ->Mem.store ch m b ofs v=Some m' ->0<=ofs<size.
Proof.
 intros m b size ch ofs v m'[V B]L;apply B;eapply Mem.perm_max.
 eapply Mem.perm_implies;[eapply Mem.valid_access_perm;eapply Mem.store_valid_access_3;exact L|constructor].
Qed.
Print Assumptions original_step_forward.
Print Assumptions global_bounds_reachable.
