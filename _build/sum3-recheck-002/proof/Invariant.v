From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveSum3 Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveSum3Proof Require Import SourceInvariant.
From FiveSum3Proof.support Require Import NormalCorrespondence.
From FiveSum3Proof Require Import PureProgress.
Import ListNotations.

(** An annotation of execution states. Its denotation is derived from the
    structural caller precondition; it is not assumed at the public entry. *)
Definition execution_invariant (s:Csem.state) : Prop :=
 source_state s /\ normal_state s=true /\ exists result,state_eval sum3_ge s=Some result.
Definition normal_return(s:Csem.state) := exists v m,s=Returnstate v Kstop m.
Definition source_error(s:Csem.state) := ~normal_return s /\ nostep Csem.step sum3_ge s.

Lemma not_stuck_excludes_stuck : forall ge f a k e m t,
 Csem.not_stuck ge e a m -> ~Csem.estep ge (ExprState f a k e m) t Stuckstate.
Proof.
 intros ge f a k e m t NS BAD; inversion BAD; subst.
 match goal with N:~imm_safe _ _ ?K ?sub _, CT:Csem.context ?K RV ?C |- _ =>
 apply N; exact(NS K C sub CT eq_refl) end.
Qed.

Lemma normal_estep_forward : forall ge f a k e m t s' result,
 source_state(ExprState f a k e m) -> normal_state(ExprState f a k e m)=true ->
 state_eval ge (ExprState f a k e m)=Some result ->
 Csem.estep ge (ExprState f a k e m) t s' -> state_eval ge s'=Some result.
Proof.
 intros ge f a k e m t s' result SOURCE NORMAL EVAL STEP.
 simpl in SOURCE; destruct SOURCE as [HF[CORE CK]].
 destruct k; simpl in NORMAL; try discriminate; core_unpack.
 - assert(NS:Csem.not_stuck ge e a m).
   { cbn [state_eval] in EVAL. destruct(flat_eval ge e m a) as [[v mx]|] eqn:EV;
      try discriminate. eapply flat_not_stuck;eauto. }
   inversion STEP; subst.
   + match goal with LR:lred ge e ?A m ?A' ?M', CT:Csem.context LV RV ?C,
      FL:flat_expr(?C ?A)=true |- _ =>
      destruct(flat_lred_context ge e m A A' M' LV C CT eq_refl FL LR) as [HM[NF EQ]];
      subst M'; cbn [state_eval] in *; rewrite EQ in EVAL; exact EVAL end.
   + match goal with RR:rred ge ?A m t ?A' ?M', CT:Csem.context RV RV ?C,
      FL:flat_expr(?C ?A)=true |- _ =>
      destruct(flat_rred_context ge e m A A' t M' C CT FL CORE RR) as [NF EQ];
      cbn [state_eval] in *; rewrite EQ in EVAL; exact EVAL end.
   + exfalso. match goal with CR:callred ge ?A _ _ _ _, CT:Csem.context RV RV ?C |- _ =>
      eapply core_no_callred; [exact(core_context_hole _ _ _ CT _ CORE)|exact CR] end.
   + exfalso; eapply not_stuck_excludes_stuck; eauto.
 - assert(NS:Csem.not_stuck ge e a m).
   { cbn [state_eval] in EVAL; destruct(pure_rval ge e m a) eqn:EV;try discriminate.
     eapply pure_not_stuck;eauto. }
   match goal with S:simple a=true |- _ =>
    destruct(simple_estep ge f a (Kreturn k) e m t s' S STEP)
     as [BAD|[a'[EQ[TY[NF PV]]]]] end.
   + subst s'; exfalso; eapply not_stuck_excludes_stuck;eauto.
   + subst s'; cbn [state_eval] in *; rewrite PV,<-TY in EVAL;exact EVAL.
Qed.

Theorem invariant_preserved : forall s t s',
 execution_invariant s -> Csem.step sum3_ge s t s' -> execution_invariant s'.
Proof.
 intros s t s' [SOURCE[NORMAL[result EVAL]]] STEP.
 pose proof(proj2(source_step_invariant _ _ _ _ SOURCE STEP)) as SOURCE'.
 pose proof(proj1(normal_step_denotation _ _ _ _ SOURCE NORMAL STEP)) as NORMAL'.
 repeat split; auto. exists result. destruct STEP as [ES|SS].
 - destruct s as [f stmt k e m|f a k e m|fd args k m|v k m|]; try solve[inversion ES].
   exact(normal_estep_forward sum3_ge f a k e m t s' result SOURCE NORMAL EVAL ES).
 - rewrite <-(normal_sstep_denotation _ _ _ _ SOURCE NORMAL SS);exact EVAL.
Qed.

Lemma immediate_has_step : forall ge f a k e m,
 literal RV a=false -> imm_safe ge e RV a m ->
 exists t s',Csem.step ge (ExprState f a k e m) t s'.
Proof.
 intros ge f a k e m NL IS; inversion IS; subst; try discriminate.
 - eexists; eexists; left; eapply step_lred;eauto.
 - eexists; eexists; left; eapply step_rred;eauto.
 - eexists; eexists; left; eapply Csem.step_call;eauto.
Qed.

Lemma sum3_vars_unique :
 list_norepet(var_names(fn_params sum3_function)++var_names(fn_vars sum3_function)).
Proof.
 change(list_norepet [Source._a;Source._b;Source._c]).
 repeat(apply list_norepet_cons; [simpl;intuition discriminate|]).
 apply list_norepet_nil.
Qed.

Theorem invariant_progress : forall s,
 execution_invariant s -> normal_return s \/ exists t s',Csem.step sum3_ge s t s'.
Proof.
 intros s [SOURCE[NORMAL[result EVAL]]].
 destruct s as [f stmt k e m|f a k e m|fd args k m|v k m|];
 cbn [source_state] in SOURCE; cbn [normal_state] in NORMAL; try discriminate.
 - destruct SOURCE as [HF[CORE CK]]. core_unpack.
   destruct stmt; cbn [normal_stmt] in *; core_unpack;try discriminate.
   + destruct k; cbn [normal_cont] in *;core_unpack;try discriminate.
     * cbn [state_eval stmt_eval cont_eval] in EVAL.
       destruct(Mem.free_list m (blocks_of_env sum3_ge e))eqn:FREE;try discriminate.
       right; eexists;eexists;right;eapply step_skip_call;[exact I|exact FREE].
     * right;eexists;eexists;right;eapply step_skip_seq.
   + right;eexists;eexists;right;eapply step_do_1.
   + right;eexists;eexists;right;eapply step_seq.
   + destruct o as [a|].
     * right;eexists;eexists;right;eapply step_return_1.
     * cbn [state_eval stmt_eval] in EVAL. rewrite cont_eval_return in EVAL.
       destruct(Mem.free_list m (blocks_of_env sum3_ge e))eqn:FREE;try discriminate.
       right;eexists;eexists;right;eapply step_return_0;exact FREE.
 - destruct SOURCE as [HF[CORE CK]].
   destruct k; cbn [normal_state] in NORMAL;try discriminate;core_unpack.
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as [v[ty EQ]];subst a.
       right;eexists;eexists;right;eapply step_do_2.
     * right;eapply immediate_has_step;eauto.
       cbn [state_eval] in EVAL;destruct(flat_eval sum3_ge e m a)as [[v mx]|]eqn:EV;
       try discriminate;eapply flat_immediate;eauto.
   + destruct(literal RV a)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as [v[ty EQ]];subst a.
       change((match sem_cast v ty (fn_return f) m with
        | Some v2=>cont_eval sum3_ge e (fn_return f) k (Nreturn v2) m
        | None=>None end)=Some result) in EVAL.
       destruct(sem_cast v ty (fn_return f) m)eqn:CAST;try discriminate.
       rewrite cont_eval_return in EVAL.
       destruct(Mem.free_list m (blocks_of_env sum3_ge e))eqn:FREE;try discriminate.
       right;eexists;eexists;right;eapply step_return_2;eauto.
     * right;eapply immediate_has_step;eauto.
       cbn [state_eval] in EVAL;destruct(pure_rval sum3_ge e m a)eqn:EV;try discriminate.
       eapply simple_immediate;eauto;congruence.
 - destruct SOURCE as [FD K];subst fd k.
   cbn [state_eval] in EVAL.
   destruct(do_alloc_variables sum3_ge empty_env m
    (fn_params sum3_function++fn_vars sum3_function))as [e ma]eqn:ALLOC.
   destruct(sem_bind_parameters sum3_ge quiet_world e ma
    (fn_params sum3_function) args)eqn:BIND;try discriminate.
   right;eexists;eexists;right;eapply step_internal_function.
   + exact sum3_vars_unique.
   + pose proof(do_alloc_variables_sound sum3_ge
      (fn_params sum3_function++fn_vars sum3_function) empty_env m)as A.
     rewrite ALLOC in A;exact A.
   + eapply sem_bind_parameters_sound;exact BIND.
 - subst k;left;unfold normal_return;eauto.
Qed.

Theorem invariant_excludes_error : forall s,execution_invariant s -> ~source_error s.
Proof.
 intros s INV [NOTRETURN STOP]. destruct(invariant_progress _ INV)as [DONE|[t[s' STEP]]].
 - contradiction.
 - exact(STOP t s' STEP).
Qed.

Theorem reachable_invariant : forall initial t s,
 execution_invariant initial -> star Csem.step sum3_ge initial t s -> execution_invariant s.
Proof.
 intros initial t s INV PATH;revert INV;induction PATH;intros INV;auto.
 apply IHPATH;eapply invariant_preserved;eauto.
Qed.

