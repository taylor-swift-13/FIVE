From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress AtomicDenotation AtomicProgress.
Import ListNotations.
Inductive normal_outcome := Nnormal | Nreturn (v:val).

Fixpoint stmt_eval (ge:genv) (e:env) (ret:type) (s:statement) (m:mem): option (normal_outcome * mem) :=
  match s with
  | Sskip => Some (Nnormal,m)
  | Sdo a => match atomic_eval ge e m a with Some (_,m') => Some (Nnormal,m') | None => None end
  | Ssequence s1 s2 =>
      match stmt_eval ge e ret s1 m with
      | Some (Nnormal,m') => stmt_eval ge e ret s2 m'
      | Some (Nreturn v,m') => Some (Nreturn v,m')
      | None => None end
  | Sifthenelse a s1 s2 =>
      match pure_rval ge e m a with
      | Some v => match bool_val v (typeof a) m with
        | Some b => stmt_eval ge e ret (if b then s1 else s2) m
        | None => None end
      | None => None end
  | Sreturn None => Some (Nreturn Vundef,m)
  | Sreturn (Some a) =>
      match pure_rval ge e m a with
      | Some v => match sem_cast v (typeof a) ret m with
          | Some v' => Some (Nreturn v',m) | None => None end
      | None => None end
  | _ => None
  end.

Fixpoint cont_eval (ge:genv) (e:env) (ret:type) (k:cont) (out:normal_outcome) (m:mem): option (val*mem) :=
  match out with
  | Nreturn v => match Mem.free_list m (blocks_of_env ge e) with Some m' => Some (v,m') | None => None end
  | Nnormal =>
      match k with
      | Kstop => match Mem.free_list m (blocks_of_env ge e) with Some m' => Some (Vundef,m') | None => None end
      | Kseq s k =>
          match stmt_eval ge e ret s m with
          | Some (out,m') => cont_eval ge e ret k out m' | None => None end
      | _ => None end
  end.

Lemma cont_eval_return:
  forall ge e ret k v m,
  cont_eval ge e ret k (Nreturn v) m =
  match Mem.free_list m (blocks_of_env ge e) with Some m' => Some (v,m') | None => None end.
Proof. destruct k; reflexivity. Qed.

Definition state_eval (ge:genv) (S:Csem.state): option (val*mem) :=
  match S with
  | State f s k e m =>
      match stmt_eval ge e (fn_return f) s m with
      | Some (out,m') => cont_eval ge e (fn_return f) k out m' | None => None end
  | ExprState f a k e m =>
      match k with
      | Kdo k => match atomic_eval ge e m a with
          | Some (_,m') => cont_eval ge e (fn_return f) k Nnormal m' | None => None end
      | Kifthenelse s1 s2 k =>
          match pure_rval ge e m a with
          | Some v => match bool_val v (typeof a) m with
            | Some b => match stmt_eval ge e (fn_return f) (if b then s1 else s2) m with
              | Some (out,m') => cont_eval ge e (fn_return f) k out m'
              | None => None end
            | None => None end
          | None => None end
      | Kreturn k =>
          match pure_rval ge e m a with
          | Some v => match sem_cast v (typeof a) (fn_return f) m with
              | Some v' => cont_eval ge e (fn_return f) k (Nreturn v') m | None => None end
          | None => None end
      | _ => None end
  | Callstate (Internal f) args k m =>
      match Cexec.do_alloc_variables ge empty_env m (fn_params f ++ fn_vars f) with
      | (e,m') => match Cexec.sem_bind_parameters ge quiet_world e m' (fn_params f) args with
          | Some m'' => match stmt_eval ge e (fn_return f) (fn_body f) m'' with
              | Some (out,m''') => cont_eval ge e (fn_return f) k out m''' | None => None end
          | None => None end end
  | Returnstate v Kstop m => Some (v,m)
  | _ => None
  end.

Fixpoint normal_stmt (s:statement): bool :=
  match s with
  | Sskip | Sreturn None => true
  | Sdo a => atomic_expr a
  | Sreturn (Some a) => simple a
  | Ssequence s1 s2 => normal_stmt s1 && normal_stmt s2
  | Sifthenelse a s1 s2 => simple a && normal_stmt s1 && normal_stmt s2
  | _ => false end.
Fixpoint normal_cont (k:cont): bool :=
  match k with Kstop => true | Kseq s k => normal_stmt s && normal_cont k | _ => false end.
Definition normal_state (S:Csem.state): bool :=
  match S with
  | State _ s k _ _ => normal_stmt s && normal_cont k
  | ExprState _ a (Kdo k) _ _ => atomic_expr a && normal_cont k
  | ExprState _ a (Kreturn k) _ _ => simple a && normal_cont k
  | ExprState _ a (Kifthenelse s1 s2 k) _ _ => simple a && normal_stmt s1 && normal_stmt s2 && normal_cont k
  | ExprState _ _ _ _ _ => false
  | Callstate (Internal f) _ Kstop _ => normal_stmt (fn_body f)
  | Returnstate _ Kstop _ | Stuckstate => true
  | _ => false end.

Lemma normal_cont_call:
  forall k, normal_cont k = true -> call_cont k = Kstop.
Proof. induction k; simpl; intros H; core_unpack; try discriminate; auto. Qed.
Lemma normal_cont_is_call:
  forall k, normal_cont k = true -> is_call_cont k -> k = Kstop.
Proof. destruct k; simpl; intros; try discriminate; tauto. Qed.


Lemma normal_estep_forward: forall ge f a k e m t next result,
 normal_state(ExprState f a k e m)=true ->
 state_eval ge(ExprState f a k e m)=Some result ->
 Csem.estep ge(ExprState f a k e m)t next ->
 normal_state next=true /\ state_eval ge next=Some result.
Proof.
 intros ge f a k e m t next result NORMAL EV STEP.
 destruct k;simpl in NORMAL;try discriminate;core_unpack.
 - cbn[state_eval] in EV.
   destruct(atomic_eval ge e m a) as [[v mf]|]eqn:AE;try discriminate.
   destruct(atomic_defined_estep ge f a (Kdo k) e m t next v mf ltac:(assumption) AE STEP)
    as [a'[m'[EQ[TT[SI DEN]]]]];subst next.
   split;[simpl;core_build;auto|cbn[state_eval];rewrite DEN;exact EV].
 - assert(NS:Csem.not_stuck ge e a m).
   { cbn[state_eval] in EV;destruct(pure_rval ge e m a)eqn:PV;try discriminate;eapply pure_not_stuck;eauto. }
   match goal with SI:simple a=true |- _=>
   destruct(simple_estep ge f a (Kifthenelse s s0 k)e m t next SI STEP)
    as [BAD|[a'[EQ[TY[SA DEN]]]]] end.
   + subst next;inversion STEP;subst.
     exfalso;match goal with N:~imm_safe _ _ _ _ _,CT:Csem.context _ _ _ |- _=>
      apply N;apply(NS _ _ _ CT eq_refl) end.
   + subst next;split;[simpl;core_build;auto|].
     cbn[state_eval] in *;rewrite DEN,<-TY in EV;exact EV.
 - assert(NS:Csem.not_stuck ge e a m).
   { cbn[state_eval] in EV;destruct(pure_rval ge e m a)eqn:PV;try discriminate;eapply pure_not_stuck;eauto. }
   match goal with SI:simple a=true |- _=>
   destruct(simple_estep ge f a (Kreturn k)e m t next SI STEP)
    as [BAD|[a'[EQ[TY[SA DEN]]]]] end.
   + subst next;inversion STEP;subst.
     exfalso;match goal with N:~imm_safe _ _ _ _ _,CT:Csem.context _ _ _ |- _=>
      apply N;apply(NS _ _ _ CT eq_refl) end.
   + subst next;split;[simpl;core_build;auto|].
     cbn[state_eval] in *;rewrite DEN,<-TY in EV;exact EV.
Qed.
Lemma normal_sstep_preserved:
  forall ge S t S', normal_state S = true -> Csem.sstep ge S t S' -> normal_state S' = true.
Proof.
  intros ge S t S' NORMAL STEP; inversion STEP; subst; simpl in NORMAL;
    repeat match goal with H: _ /\ _ |- _ => destruct H end;
    core_unpack; try discriminate; simpl; core_build; auto.
  - destruct b; simpl; core_build; auto.
  - rewrite (normal_cont_call _ NORMAL); reflexivity.
  - rewrite (normal_cont_call _ NORMAL); reflexivity.
  - assert (HK: k = Kstop) by (eapply normal_cont_is_call; eauto). subst; reflexivity.
  - destruct k;simpl in NORMAL;try discriminate;exact NORMAL.
  - destruct k;simpl in NORMAL;try discriminate;reflexivity.
Qed.

Lemma normal_sstep_denotation:
  forall ge S t S', normal_state S = true -> Csem.sstep ge S t S' ->
  state_eval ge S = state_eval ge S'.
Proof.
  intros ge S t S' NORMAL STEP; inversion STEP; subst; simpl in NORMAL;
    repeat match goal with H: _ /\ _ |- _ => destruct H end;
    core_unpack; try discriminate; simpl; auto.
  - destruct (atomic_eval ge e m x) as [[v mx]|]; reflexivity.
  - destruct (stmt_eval ge e (fn_return f) s1 m) as [[out mx]|]; simpl; auto.
    destruct out; try rewrite cont_eval_return; reflexivity.
  - destruct (pure_rval ge e m a) as [v|]; simpl; auto.
    destruct (bool_val v (typeof a) m); reflexivity.
  - match goal with H:bool_val _ _ _=Some _ |- _ => rewrite H end; reflexivity.
  - rewrite (normal_cont_call _ NORMAL), cont_eval_return. simpl.
    match goal with H: Mem.free_list _ _ = Some _ |- _ => rewrite H end; reflexivity.
  - destruct (pure_rval ge e m x) as [v|]; simpl; auto.
    destruct (sem_cast v (typeof x) (fn_return f) m); reflexivity.
  - rewrite (normal_cont_call _ NORMAL).
    match goal with H: sem_cast _ _ _ _ = Some _ |- _ => rewrite H end.
    rewrite cont_eval_return. simpl. match goal with H: Mem.free_list _ _ = Some _ |- _ => rewrite H end; reflexivity.
  - assert (HK: k = Kstop) by (eapply normal_cont_is_call; eauto). subst; simpl.
    match goal with H: Mem.free_list _ _ = Some _ |- _ => rewrite H end; reflexivity.
  - match goal with A: alloc_variables ge _ _ _ _ _ |- _ =>
      rewrite (do_alloc_variables_complete ge _ _ _ _ _ A) end.
    match goal with B: bind_parameters ge _ _ _ _ _ |- _ =>
      rewrite (sem_bind_parameters_complete ge quiet_world _ _ _ _ _ B) end.
    reflexivity.
Qed.


Lemma normal_estep_backward: forall ge f a k e m t next,
 normal_state(ExprState f a k e m)=true ->
 Csem.estep ge(ExprState f a k e m)t next ->
 normal_state next=true /\
 forall result,state_eval ge next=Some result ->
 state_eval ge(ExprState f a k e m)=Some result.
Proof.
 intros ge f a k e m t next NORMAL STEP.
 destruct k;simpl in NORMAL;try discriminate;core_unpack.
 - match goal with AT:atomic_expr a=true |- _=>
   destruct(atomic_estep ge f a (Kdo k)e m t next AT STEP)
    as [BAD|[a'[m'[EQ[TT[SI DEN]]]]]] end.
   + subst;split;[reflexivity|simpl;discriminate].
   + subst;split;[simpl;core_build;auto|].
     cbn[state_eval];rewrite DEN;auto.
 - match goal with SI:simple a=true |- _=>
   destruct(simple_estep ge f a (Kifthenelse s s0 k)e m t next SI STEP)
    as [BAD|[a'[EQ[TY[SA DEN]]]]] end.
   + subst;split;[reflexivity|simpl;discriminate].
   + subst;split;[simpl;core_build;auto|].
     cbn[state_eval];rewrite DEN,<-TY;auto.
 - match goal with SI:simple a=true |- _=>
   destruct(simple_estep ge f a (Kreturn k)e m t next SI STEP)
    as [BAD|[a'[EQ[TY[SA DEN]]]]] end.
   + subst;split;[reflexivity|simpl;discriminate].
   + subst;split;[simpl;core_build;auto|].
     cbn[state_eval];rewrite DEN,<-TY;auto.
Qed.
Theorem normal_step_backward: forall ge S t next,
 normal_state S=true -> Csem.step ge S t next ->
 normal_state next=true /\
 forall result,state_eval ge next=Some result -> state_eval ge S=Some result.
Proof.
 intros ge S t next NORMAL [ES|SS].
 - destruct S;inversion ES;subst;eapply normal_estep_backward;eauto.
 - split;[eapply normal_sstep_preserved;eauto|].
   rewrite(normal_sstep_denotation _ _ _ _ NORMAL SS);auto.
Qed.
Theorem all_order_normal_correspondence: forall ge S t v mf,
 normal_state S=true ->
 star Csem.step ge S t(Returnstate v Kstop mf) ->
 state_eval ge S=Some(v,mf).
Proof.
 intros ge S t v mf NORMAL PATH.
 remember(Returnstate v Kstop mf)as FINAL.
 revert NORMAL;induction PATH;intros NORMAL;subst.
 - reflexivity.
 - destruct(normal_step_backward _ _ _ _ NORMAL H)as [NN BACK].
   apply BACK;apply IHPATH;auto.
Qed.
Print Assumptions all_order_normal_correspondence.

Definition call_names(s:Csem.state):Prop :=
 match s with
 | Callstate(Internal f)_ _ _=>list_norepet(var_names(fn_params f)++var_names(fn_vars f))
 | _=>True end.
Lemma normal_no_callred: forall ge f a k e m from C sub fd args ty,
 normal_state(ExprState f a k e m)=true ->
 context from RV C -> a=C sub -> callred ge sub m fd args ty -> False.
Proof.
 intros ge f a k e m from C sub fd args ty NORMAL CT EQ CR;subst a.
 destruct k;simpl in NORMAL;try discriminate;core_unpack.
 - pose proof(atomic_context_hole _ _ _ CT sub ltac:(assumption))as BAD.
   inversion CR;subst;discriminate.
 - pose proof(simple_context_hole _ _ _ CT sub ltac:(assumption))as BAD.
   inversion CR;subst;discriminate.
 - pose proof(simple_context_hole _ _ _ CT sub ltac:(assumption))as BAD.
   inversion CR;subst;discriminate.
Qed.
Lemma normal_step_names: forall ge S t next,
 normal_state S=true -> call_names S -> Csem.step ge S t next -> call_names next.
Proof.
 intros ge S t next NORMAL NAMES [ES|SS].
 - inversion ES;subst;simpl;auto.
   exfalso;eapply normal_no_callred;eauto.
 - inversion SS;subst;simpl;auto.
Qed.
Lemma normal_step_forward: forall ge S t next result,
 normal_state S=true -> state_eval ge S=Some result -> Csem.step ge S t next ->
 normal_state next=true /\ state_eval ge next=Some result.
Proof.
 intros ge S t next result NORMAL EV [ES|SS].
 - destruct S;inversion ES;subst;eapply normal_estep_forward;eauto.
 - split;[eapply normal_sstep_preserved;eauto|].
   rewrite <-(normal_sstep_denotation _ _ _ _ NORMAL SS);exact EV.
Qed.
Definition execution_invariant(ge:genv)(s:Csem.state):Prop :=
 normal_state s=true /\ call_names s /\ exists result,state_eval ge s=Some result.
Definition normal_return(s:Csem.state):Prop :=exists v m,s=Returnstate v Kstop m.
Lemma invariant_preserved: forall ge s t next,
 execution_invariant ge s -> Csem.step ge s t next -> execution_invariant ge next.
Proof.
 intros ge s t next [N[CN[r EV]]] STEP.
 destruct(normal_step_forward _ _ _ _ _ N EV STEP)as [NN EN].
 split;[exact NN|]. split;[exact(normal_step_names ge s t next N CN STEP)|exists r;exact EN].
Qed.
Lemma immediate_has_step: forall ge f a k e m,
 literal RV a=false -> imm_safe ge e RV a m ->
 exists t next,Csem.step ge(ExprState f a k e m)t next.
Proof.
 intros ge f a k e m NL IS;inversion IS;subst;try discriminate.
 - eexists;eexists;left;eapply step_lred;eauto.
 - eexists;eexists;left;eapply step_rred;eauto.
 - eexists;eexists;left;eapply Csem.step_call;eauto.
Qed.
Theorem invariant_progress : forall ge s,
 execution_invariant ge s -> normal_return s \/ exists t s',Csem.step ge s t s'.
Proof.
 intros ge s [NORMAL[NAMES[result EVAL]]].
 destruct s as [f stmt k e m|f a k e m|fd args k m|v k m|];
 cbn [normal_state] in NORMAL; try discriminate.
 - core_unpack.
   destruct stmt; cbn [normal_stmt] in *; core_unpack;try discriminate.
   + destruct k; cbn [normal_cont] in *;core_unpack;try discriminate.
     * cbn [state_eval stmt_eval cont_eval] in EVAL.
       destruct(Mem.free_list m (blocks_of_env ge e))eqn:FREE;try discriminate.
       right; eexists;eexists;right;eapply step_skip_call;[exact I|exact FREE].
     * right;eexists;eexists;right;eapply step_skip_seq.
   + right;eexists;eexists;right;eapply step_do_1.
   + right;eexists;eexists;right;eapply step_seq.
   + right;eexists;eexists;right;eapply step_ifthenelse_1.
   + destruct o as [a|].
     * right;eexists;eexists;right;eapply step_return_1.
     * cbn [state_eval stmt_eval] in EVAL. rewrite cont_eval_return in EVAL.
       destruct(Mem.free_list m (blocks_of_env ge e))eqn:FREE;try discriminate.
       right;eexists;eexists;right;eapply step_return_0;exact FREE.
 - 
   destruct k; cbn [normal_state] in NORMAL;try discriminate;core_unpack.
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as [v[ty EQ]];subst a.
       right;eexists;eexists;right;eapply step_do_2.
     * right;eapply immediate_has_step;eauto.
       cbn [state_eval] in EVAL;destruct(atomic_eval ge e m a)as [[v mx]|]eqn:EV;
       try discriminate;pose proof(atomic_not_stuck _ _ _ _ _ _ ltac:(eassumption) EV) as NS;exact(NS RV (fun x=>x) a (ctx_top RV) eq_refl).
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as [v[ty EQ]];subst a.
       cbn [state_eval pure_rval typeof] in EVAL.
       destruct(bool_val v ty m)eqn:BOOL;try discriminate.
       right;eexists;eexists;right;eapply step_ifthenelse_2;exact BOOL.
     * right;eapply immediate_has_step;eauto.
       cbn [state_eval] in EVAL;destruct(pure_rval ge e m a)eqn:EV;try discriminate.
       eapply simple_immediate;eauto;congruence.
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as [v[ty EQ]];subst a.
       change((match sem_cast v ty (fn_return f) m with
        | Some v2=>cont_eval ge e (fn_return f) k (Nreturn v2) m
        | None=>None end)=Some result) in EVAL.
       destruct(sem_cast v ty (fn_return f) m)eqn:CAST;try discriminate.
       rewrite cont_eval_return in EVAL.
       destruct(Mem.free_list m (blocks_of_env ge e))eqn:FREE;try discriminate.
       right;eexists;eexists;right;eapply step_return_2;eauto.
     * right;eapply immediate_has_step;eauto.
       cbn [state_eval] in EVAL;destruct(pure_rval ge e m a)eqn:EV;try discriminate.
       eapply simple_immediate;eauto;congruence.
 - destruct fd;try discriminate. destruct k;try discriminate.
   cbn [state_eval] in EVAL.
   destruct(do_alloc_variables ge empty_env m
    (fn_params f++fn_vars f))as [e ma]eqn:ALLOC.
   destruct(sem_bind_parameters ge quiet_world e ma
    (fn_params f) args)eqn:BIND;try discriminate.
   right;eexists;eexists;right;eapply step_internal_function.
   + exact NAMES.
   + pose proof(do_alloc_variables_sound ge
      (fn_params f++fn_vars f) empty_env m)as A.
     rewrite ALLOC in A;exact A.
   + eapply sem_bind_parameters_sound;exact BIND.
 - destruct k;try discriminate;left;unfold normal_return;eauto.
Qed.


Theorem reachable_invariant: forall ge initial t reached,
 execution_invariant ge initial ->
 star Csem.step ge initial t reached -> execution_invariant ge reached.
Proof.
 intros ge initial t reached INV PATH;revert INV;induction PATH;intros INV;auto.
 apply IHPATH;eapply invariant_preserved;eauto.
Qed.

(** A constructive normal execution discharges the denotation premise.  Syntax,
    rather than an assumed safety predicate, ensures all alternate operand orders
    preserve the same denotation. *)
Theorem normal_witness_certifies_all_orders: forall ge initial tw v mf,
 normal_state initial=true -> call_names initial ->
 star Csem.step ge initial tw(Returnstate v Kstop mf) ->
 (forall t reached,star Csem.step ge initial t reached ->
   normal_return reached \/ exists tr next,Csem.step ge reached tr next) /\
 (forall t v' mf',star Csem.step ge initial t(Returnstate v' Kstop mf') ->
   v'=v /\ mf'=mf).
Proof.
 intros ge initial tw v mf NORMAL NAMES WITNESS.
 pose proof(all_order_normal_correspondence ge initial tw v mf NORMAL WITNESS)as DEN.
 assert(INV:execution_invariant ge initial).
 { split;auto;split;auto;exists(v,mf);exact DEN. }
 split.
 - intros t reached PATH;apply invariant_progress.
   eapply reachable_invariant;eauto.
 - intros t v' mf' PATH.
   pose proof(all_order_normal_correspondence ge initial t v' mf' NORMAL PATH)as DEN'.
   rewrite DEN in DEN';inversion DEN';auto.
Qed.
Corollary normal_witness_excludes_all_errors: forall ge initial tw v mf,
 normal_state initial=true -> call_names initial ->
 star Csem.step ge initial tw(Returnstate v Kstop mf) ->
 forall t reached,star Csem.step ge initial t reached ->
 ~(~normal_return reached /\ nostep Csem.step ge reached).
Proof.
 intros ge initial tw v mf NORMAL NAMES WIT t reached PATH[NR STOP].
 destruct(proj1(normal_witness_certifies_all_orders ge initial tw v mf NORMAL NAMES WIT)
   t reached PATH)as [DONE|[tr[next STEP]]].
 - contradiction.
 - exact(STOP tr next STEP).
Qed.
Print Assumptions normal_witness_certifies_all_orders.
Print Assumptions normal_witness_excludes_all_errors.
