From Stdlib Require Import Bool List ZArith Classical.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress AtomicDenotation AtomicProgress ContinuationLift.
Import ListNotations.
Fixpoint block_stmt(s:statement):bool :=
 match s with
 | Sskip=>true | Sdo a=>atomic_expr a
 | Ssequence a b=>block_stmt a && block_stmt b
 | Sifthenelse a b c=>simple a && block_stmt b && block_stmt c
 | _=>false end.
Fixpoint block_cont(k:cont):bool :=
 match k with Kstop=>true|Kseq s k=>block_stmt s && block_cont k|_=>false end.
Definition block_state(s:Csem.state):bool :=
 match s with
 | State _ st k _ _=>block_stmt st && block_cont k
 | ExprState _ a(Kdo k)_ _=>atomic_expr a && block_cont k
 | ExprState _ a(Kifthenelse b c k)_ _=>simple a && block_stmt b && block_stmt c && block_cont k
 | _=>false end.
Fixpoint block_eval(ge:genv)(e:env)(s:statement)(m:mem):option mem :=
 match s with
 | Sskip=>Some m
 | Sdo a=>option_map snd(atomic_eval ge e m a)
 | Ssequence a b=>match block_eval ge e a m with Some ma=>block_eval ge e b ma|None=>None end
 | Sifthenelse a b c=>
   match pure_rval ge e m a with
   | Some v=>match bool_val v(typeof a)m with Some bv=>block_eval ge e(if bv then b else c)m|None=>None end
   | None=>None end
 | _=>None end.
Fixpoint block_tail(ge:genv)(e:env)(k:cont)(m:mem):option mem :=
 match k with
 | Kstop=>Some m
 | Kseq s k=>match block_eval ge e s m with Some ma=>block_tail ge e k ma|None=>None end
 | _=>None end.
Definition block_denotation(ge:genv)(s:Csem.state):option mem :=
 match s with
 | State _ st k e m=>match block_eval ge e st m with Some ma=>block_tail ge e k ma|None=>None end
 | ExprState _ a(Kdo k)e m=>match atomic_eval ge e m a with Some(_,ma)=>block_tail ge e k ma|None=>None end
 | ExprState _ a(Kifthenelse b c k)e m=>
   match pure_rval ge e m a with
   | Some v=>match bool_val v(typeof a)m with
     | Some bv=>match block_eval ge e(if bv then b else c)m with Some ma=>block_tail ge e k ma|None=>None end
     | None=>None end
   | None=>None end
 | _=>None end.
Definition block_done(s:Csem.state):Prop :=
 exists f e m,s=State f Sskip Kstop e m.
Lemma block_stmt_normal:forall s,block_stmt s=true -> CallfreeExecution.normal_stmt s=true.
Proof. induction s;simpl;intros;core_unpack;try discriminate;core_build;eauto. Qed.
Lemma block_cont_normal:forall k,block_cont k=true -> CallfreeExecution.normal_cont k=true.
Proof. induction k;simpl;intros;core_unpack;try discriminate;core_build;eauto using block_stmt_normal. Qed.
Lemma block_state_normal:forall s,block_state s=true -> CallfreeExecution.normal_state s=true.
Proof.
 destruct s;simpl;intros;core_unpack;try discriminate;core_build;
 eauto using block_stmt_normal,block_cont_normal.
 destruct k;simpl in *;core_unpack;try discriminate;core_build;
 eauto using block_stmt_normal,block_cont_normal.
Qed.
Lemma block_estep:forall ge f a k e m t next,
 block_state(ExprState f a k e m)=true ->
 Csem.estep ge(ExprState f a k e m)t next ->
 (next=Stuckstate \/
 block_state next=true /\
 block_denotation ge(ExprState f a k e m)=block_denotation ge next).
Proof.
 intros ge f a k e m t next BL STEP.
 destruct k;simpl in BL;try discriminate;core_unpack.
 - match goal with AT:atomic_expr a=true |- _=>
   destruct(atomic_estep ge f a(Kdo k)e m t next AT STEP)
    as [BAD|[a'[m'[EQ[TT[SI DEN]]]]]] end.
   + auto.
   + subst next;right;split;[simpl;core_build;auto|].
     cbn[block_denotation];rewrite DEN;auto.
 - match goal with SI:simple a=true |- _=>
   destruct(simple_estep ge f a(Kifthenelse s s0 k)e m t next SI STEP)
    as[BAD|[a'[EQ[TY[SA DEN]]]]] end.
   + auto.
   + subst next;right;split;[simpl;core_build;auto|].
     cbn[block_denotation];rewrite DEN,<-TY;auto.
Qed.
Lemma block_sstep:forall ge s t next,
 block_state s=true -> ~block_done s -> Csem.sstep ge s t next ->
 block_state next=true /\ block_denotation ge s=block_denotation ge next.
Proof.
 intros ge s t next BL ND STEP;inversion STEP;subst;simpl in BL;core_unpack;try discriminate.
 all: try solve[split;[simpl;core_build;auto|reflexivity]].
 - split;[simpl;core_build;auto|].
   cbn[block_denotation block_eval];destruct(atomic_eval ge e m x)as [[v ma]|];reflexivity.
 - split;[simpl;core_build;auto|].
   cbn[block_denotation block_eval];destruct(block_eval ge e s1 m);reflexivity.
 - split;[simpl;core_build;auto|].
   cbn[block_denotation block_eval];destruct(pure_rval ge e m a);[destruct(bool_val v(typeof a)m)|];reflexivity.
 - split;[destruct b;simpl;core_build;auto|].
   cbn[block_denotation pure_rval typeof];rewrite H;reflexivity.
 - destruct k;simpl in BL;core_unpack;try discriminate.
   + exfalso;apply ND;unfold block_done;eauto.
   + contradiction.
Qed.

Lemma block_expression_not_stuck:forall ge f a k e m mf,
 block_state(ExprState f a k e m)=true ->
 block_denotation ge(ExprState f a k e m)=Some mf ->
 not_stuck ge e a m.
Proof.
 intros ge f a k e m mf BL DEN;destruct k;simpl in BL;try discriminate;core_unpack;
 cbn[block_denotation] in DEN.
 - destruct(atomic_eval ge e m a)as [[v ma]|]eqn:AE;try discriminate.
   eapply atomic_not_stuck;eauto.
 - destruct(pure_rval ge e m a)eqn:PV;try discriminate.
   eapply pure_not_stuck;eauto.
Qed.
Lemma block_estep_defined:forall ge f a k e m mf t next,
 block_state(ExprState f a k e m)=true ->
 block_denotation ge(ExprState f a k e m)=Some mf ->
 Csem.estep ge(ExprState f a k e m)t next ->
 block_state next=true /\ block_denotation ge next=Some mf.
Proof.
 intros ge f a k e m mf t next BL DEN STEP.
 destruct(block_estep _ _ _ _ _ _ _ _ BL STEP)as [BAD|[BN EQ]].
 - subst next;inversion STEP;subst;exfalso.
   match goal with N:~imm_safe _ _ _ _ _,CT:Csem.context _ _ _ |- _=>
     apply N;eapply block_expression_not_stuck;[exact BL|exact DEN|exact CT|reflexivity] end.
 - split;auto;congruence.
Qed.
Definition block_invariant(ge:genv)(mf:mem)(s:Csem.state):Prop :=
 block_state s=true /\ block_denotation ge s=Some mf.
Lemma block_successors:forall ge mf s t next,
 block_invariant ge mf s -> ~block_done s ->
 Csem.step ge s t next -> block_invariant ge mf next.
Proof.
 intros ge mf s t next[BL DEN]ND[ES|SS].
 - destruct s;inversion ES;subst;eapply block_estep_defined;eauto.
 - destruct(block_sstep ge s t next BL ND SS)as [BN EQ];split;auto;congruence.
Qed.
Lemma block_progress_raw:forall ge mf s,
 block_invariant ge mf s ->
 block_done s \/ exists t next,Csem.step ge s t next.
Proof.
 intros ge mf s[BL DEN].
 destruct s as[f st k e m|f a k e m|fd args k m|v k m|];
 cbn[block_state] in BL;try discriminate.
 - core_unpack;destruct st;cbn[block_stmt] in *;core_unpack;try discriminate.
   + destruct k;cbn[block_cont] in *;core_unpack;try discriminate.
     * left;unfold block_done;eauto.
     * right;eexists;eexists;right;eapply step_skip_seq.
   + right;eexists;eexists;right;eapply step_do_1.
   + right;eexists;eexists;right;eapply step_seq.
   + right;eexists;eexists;right;eapply step_ifthenelse_1.
 - destruct k;cbn[block_state] in BL;try discriminate;core_unpack.
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as[v[ty EQ]];subst a.
       right;eexists;eexists;right;eapply step_do_2.
     * right;eapply CallfreeExecution.immediate_has_step;eauto.
       pose proof(block_expression_not_stuck ge f a(Kdo k)e m mf ltac:(simpl;core_build;eauto)DEN)as NS;
       exact(NS RV(fun x=>x)a(ctx_top RV)eq_refl).
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as[v[ty EQ]];subst a.
       cbn[block_denotation pure_rval typeof] in DEN.
       destruct(bool_val v ty m)eqn:BV;try discriminate.
       right;eexists;eexists;right;eapply step_ifthenelse_2;exact BV.
     * right;eapply CallfreeExecution.immediate_has_step;eauto.
       pose proof(block_expression_not_stuck ge f a(Kifthenelse s s0 k)e m mf ltac:(simpl;core_build;eauto)DEN)as NS;
       exact(NS RV(fun x=>x)a(ctx_top RV)eq_refl).
Qed.
Print Assumptions block_successors.

Lemma nostep_path_eq:forall ge s t next,
 nostep Csem.step ge s -> star Csem.step ge s t next -> next=s /\ t=E0.
Proof. intros ge s t next NS PATH;inversion PATH;subst;auto;exfalso;eapply NS;eauto. Qed.
Lemma stuck_nostep:forall ge,nostep Csem.step ge Stuckstate.
Proof. intros ge t next[ES|SS];inversion ES||inversion SS. Qed.
Lemma return_stop_nostep:forall ge v m,nostep Csem.step ge(Returnstate v Kstop m).
Proof. intros ge v m t next[ES|SS];inversion ES||inversion SS. Qed.
Lemma block_done_path_eq:forall ge f e m t f' e' mf,
 star Csem.step ge(State f Sskip Kstop e m)t(State f' Sskip Kstop e' mf) ->
 State f' Sskip Kstop e' mf=State f Sskip Kstop e m.
Proof.
 intros ge f e m t f' e' mf PATH;inversion PATH;subst;auto.
 destruct H as[ES|SS];[inversion ES|].
 inversion SS;subst.
 match goal with P:star _ _ (Returnstate _ Kstop _) _ _ |- _=>
   destruct(nostep_path_eq _ _ _ _ (return_stop_nostep _ _ _) P)as[EQ TT];discriminate EQ end.
Qed.
Theorem block_normal_correspondence:forall ge initial t f e mf,
 block_state initial=true ->
 star Csem.step ge initial t(State f Sskip Kstop e mf) ->
 block_denotation ge initial=Some mf.
Proof.
 intros ge initial t f e mf BL PATH.
 remember(State f Sskip Kstop e mf)as FINAL.
 revert BL;induction PATH;intros BL;subst.
 - reflexivity.
 - destruct(classic(block_done s1))as[DONE|ND].
   + destruct DONE as[ff[ee[mm EQ]]];subst s1.
     assert(PP:exists tr,star Csem.step ge(State ff Sskip Kstop ee mm)tr(State f Sskip Kstop e mf)).
     { eexists;eapply star_step;[exact H|exact PATH|reflexivity]. }
     destruct PP as[tr PP];pose proof(block_done_path_eq _ _ _ _ _ _ _ _ PP)as EQ.
     inversion EQ;subst;reflexivity.
   + destruct H as[ES|SS].
     * destruct s1;try solve[inversion ES].
       destruct(block_estep _ _ _ _ _ _ _ _ BL ES)as[BAD|[BN DEN]].
       -- inversion BAD;subst;destruct(nostep_path_eq _ _ _ _ (stuck_nostep ge) PATH)as[EQ TT];discriminate EQ.
       -- rewrite DEN;apply IHPATH;auto.
     * destruct(block_sstep _ _ _ _ BL ND SS)as[BN DEN].
       rewrite DEN;apply IHPATH;auto.
Qed.
Print Assumptions block_normal_correspondence.

Lemma block_plug_sstep:forall ge base s t next,
 block_state s=true -> ~block_done s -> Csem.sstep ge s t next ->
 Csem.sstep ge(plug_state base s)t(plug_state base next).
Proof.
 intros ge base s t next BL ND STEP;inversion STEP;subst;simpl in BL;core_unpack;try discriminate;
 cbn[plug_state plug_cont];try solve[constructor;auto].
 destruct k;simpl in BL;core_unpack;try discriminate.
 - exfalso;apply ND;unfold block_done;eauto.
 - contradiction.
Qed.
Lemma block_plug_sstep_inverse:forall ge base s t next,
 block_state s=true -> ~block_done s ->
 Csem.sstep ge(plug_state base s)t next ->
 exists raw,next=plug_state base raw /\ Csem.sstep ge s t raw.
Proof.
 intros ge base s t next BL ND STEP.
 destruct s as[f st k e m|f a k e m|fd args k m|v k m|];
 cbn[block_state plug_state] in BL,STEP;try discriminate.
 - destruct st;cbn[block_stmt] in BL;core_unpack;try discriminate;
   destruct k;cbn[block_cont plug_cont] in *;core_unpack;try discriminate;
   try solve[exfalso;apply ND;unfold block_done;eauto];
   inversion STEP;subst;cbn[is_call_cont] in *;try contradiction;
   repeat match goal with H:_ \/ _ |- _=>destruct H end;try discriminate;
   try solve[eexists;split;[|eauto 8 using step_skip_seq,step_do_1,step_seq,step_ifthenelse_1,step_do_2,step_ifthenelse_2];reflexivity].
 - destruct k;cbn[block_state] in BL;try discriminate;core_unpack;
   cbn[plug_cont] in STEP;inversion STEP;subst;cbn[is_call_cont] in *;try contradiction;
   repeat match goal with H:_ \/ _ |- _=>destruct H end;try discriminate;
   try solve[eexists;split;[|eauto 8 using step_skip_seq,step_do_1,step_seq,step_ifthenelse_1,step_do_2,step_ifthenelse_2];reflexivity].
Qed.
Lemma block_plug_step:forall ge base s t next,
 block_state s=true -> ~block_done s -> Csem.step ge s t next ->
 Csem.step ge(plug_state base s)t(plug_state base next).
Proof.
 intros ge base s t next BL ND[ES|SS].
 - left;eapply plug_normal_estep;[apply block_state_normal;exact BL|exact ES].
 - right;eapply block_plug_sstep;eauto.
Qed.
Lemma block_plug_step_inverse:forall ge base s t next,
 block_state s=true -> ~block_done s ->
 Csem.step ge(plug_state base s)t next ->
 exists raw,next=plug_state base raw /\ Csem.step ge s t raw.
Proof.
 intros ge base s t next BL ND[ES|SS].
 - destruct(plug_estep_inverse ge base s t next(block_state_normal _ BL)ES)as[raw[EQ STEP]].
   exists raw;split;auto;left;exact STEP.
 - destruct(block_plug_sstep_inverse ge base s t next BL ND SS)as[raw[EQ STEP]].
   exists raw;split;auto;right;exact STEP.
Qed.
Definition block_owner(f:function)(e:env)(s:Csem.state):Prop :=
 match s with State f' _ _ e' _ |ExprState f' _ _ e' _=>f'=f /\ e'=e|_=>False end.
Lemma block_owner_preserved:forall ge f e s t next mf0,
 block_state s=true -> block_denotation ge s=Some mf0 -> ~block_done s -> block_owner f e s ->
 Csem.step ge s t next -> block_owner f e next.
Proof.
 intros ge f e s t next mf0 BL DEN ND OWN[ES|SS].
 - destruct s;try solve[inversion ES];simpl in OWN;destruct OWN;subst.
   pose proof(proj1(block_estep_defined _ _ _ _ _ _ _ _ _ BL DEN ES))as BN.
   inversion ES;subst;simpl in BN;try discriminate;simpl;auto.
 - inversion SS;subst;simpl in BL,OWN;core_unpack;try discriminate;simpl;auto.
 destruct k;simpl in BL,H;try discriminate;try contradiction.
 apply ND;unfold block_done;eauto.
Qed.
Definition block_context_invariant(ge:genv)(base:cont)(f:function)(e:env)(mf:mem)(s:Csem.state):Prop :=
 exists raw,s=plug_state base raw /\ block_invariant ge mf raw /\ block_owner f e raw.
Lemma block_context_entry:forall ge base f e st m t mf,
 block_stmt st=true ->
 star Csem.step ge(State f st Kstop e m)t(State f Sskip Kstop e mf) ->
 block_context_invariant ge base f e mf(State f st base e m).
Proof.
 intros ge base f e st m t mf BS PATH.
 exists(State f st Kstop e m);split;[reflexivity|];split.
 - split;[simpl;core_build;auto|eapply block_normal_correspondence;[simpl;core_build;auto|exact PATH]].
 - split;reflexivity.
Qed.
Theorem block_context_progress:forall ge base f e mf s,
 block_context_invariant ge base f e mf s ->
 s=State f Sskip base e mf \/
 exists t next,Csem.step ge s t next /\ block_context_invariant ge base f e mf next.
Proof.
 intros ge base f e mf s[raw[EQ[INV OWN]]];subst s.
 destruct(classic(block_done raw))as[DONE|ND].
 - destruct DONE as[ff[ee[mm EQ]]];subst raw;destruct INV as[BL DEN].
   cbn[block_denotation block_eval block_tail]in DEN;inversion DEN;subst.
   cbn[block_owner]in OWN;destruct OWN;subst;left;reflexivity.
 - destruct(block_progress_raw ge mf raw INV)as[DONE|[t[next STEP]]];[contradiction|].
   right;exists t,(plug_state base next);split.
   + apply block_plug_step;auto;exact(proj1 INV).
   + exists next;split;auto;split.
     * eapply block_successors;eauto.
     * eapply block_owner_preserved;[exact(proj1 INV)|exact(proj2 INV)|exact ND|exact OWN|eassumption].
Qed.
Theorem block_context_all_successors:forall ge base f e mf s t next,
 block_context_invariant ge base f e mf s ->
 s<>State f Sskip base e mf -> Csem.step ge s t next ->
 block_context_invariant ge base f e mf next.
Proof.
 intros ge base f e mf s t next[raw[EQ[INV OWN]]]NF STEP;subst s.
 assert(ND:~block_done raw).
 { intros[ff[ee[mm EQ]]];subst raw;destruct INV as[BL DEN].
   cbn[block_denotation block_eval block_tail]in DEN;inversion DEN;subst.
   cbn[block_owner]in OWN;destruct OWN;subst;apply NF;reflexivity. }
 destruct(block_plug_step_inverse ge base raw t next(proj1 INV)ND STEP)as[raw'[EQ STEP']].
 exists raw';split;auto;split.
 - eapply block_successors;eauto.
 - eapply block_owner_preserved;[exact(proj1 INV)|exact(proj2 INV)|exact ND|exact OWN|eassumption].
Qed.
Print Assumptions block_context_all_successors.
Print Assumptions block_context_entry.
Print Assumptions block_context_progress.
