From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore ClosedCalls LowDispatcher LowSin PlainBody.
From PprzTrigInitSupport Require Import SideEffects.
Import ListNotations.
Section NO_WHILE.
Variable ge:Csem.genv.
Variable allowed:function->Prop.
Variable ids:list ident.
Fixpoint nw_stmt(e:env)(s:statement):Prop :=
 match s with
 |Sskip|Sbreak|Scontinue|Sreturn None=>True
 |Sdo a|Sreturn(Some a)=>closed_expr ge allowed e a
 |Ssequence a b=>nw_stmt e a/\nw_stmt e b
 |Sifthenelse a yes no=>closed_expr ge allowed e a/\nw_stmt e yes/\nw_stmt e no
 |Swhile _ _|Sdowhile _ _=>False
 |Sfor _ _ _ _=>False
 |_=>False end.
Fixpoint nw_cont(e:env)(k:cont):Prop :=
 match k with
 |Kstop=>True
 |Kdo k|Kreturn k=>nw_cont e k
 |Kseq s k=>nw_stmt e s/\nw_cont e k
 |Kifthenelse yes no k=>nw_stmt e yes/\nw_stmt e no/\nw_cont e k
 |Kwhile1 _ _ _|Kwhile2 _ _ _|Kdowhile1 _ _ _|Kdowhile2 _ _ _=>False
 |Kfor2 _ _ _ _|Kfor3 _ _ _ _|Kfor4 _ _ _ _=>False
 |Kcall f ec C ty k=>True/\unshadowed ids ec/\(forall v,closed_expr ge allowed ec(C(Eval v ty)))/\nw_cont ec k
 |_=>False end.
Definition nw_state(S:Csem.state):Prop :=
 match S with
 |State f s k e _=>True/\unshadowed ids e/\nw_stmt e s/\nw_cont e k
 |ExprState f a k e _=>True/\unshadowed ids e/\closed_expr ge allowed e a/\nw_cont e k
 |Callstate fd _ k _=>(exists f,fd=Internal f/\allowed f)/\is_call_cont k/\(exists e,nw_cont e k)
 |Returnstate _ k _=>exists e,nw_cont e k
 |Stuckstate=>True end.
Lemma nw_cont_call : forall k e,nw_cont e k->nw_cont e(call_cont k).
Proof. induction k;intros current_env H;simpl in *;intuition eauto. Qed.
Lemma nw_cont_call_any : forall k e,is_call_cont k->nw_cont e k->forall e',nw_cont e' k.
Proof. destruct k;simpl;intros;try contradiction;auto. Qed.
Lemma nw_callback_free : forall S,nw_state S->callback_free_state S.
Proof.
 destruct S;simpl;intros H;repeat match goal with H:_/\_|-_=>destruct H end;auto.
 - destruct H1 as[Q O];apply quiet_no_builtin;apply qexpr_quiet;exact Q.
 - destruct H as[f[EQ A]];subst;exact I.
Qed.
Lemma nw_silent : forall S,nw_state S->silent_state ge S.
Proof.
 intros S CS;destruct S;simpl in CS;repeat match goal with H:_/\_|-_=>destruct H end.
 - intros t next[E|T];inversion E||inversion T;reflexivity.
 - apply quiet_expression_silent;apply qexpr_quiet;unfold closed_expr in *;tauto.
 - destruct H as[f[EQ A]];subst;intros t next[E|T];inversion E||inversion T;reflexivity.
 - intros t next[E|T];inversion E||inversion T;reflexivity.
 - intros t next[E|T];inversion E||inversion T.
Qed.
Lemma nw_estep : forall S t S',nw_state S->Csem.estep ge S t S'->nw_state S'.
Proof.
 intros S t S' CS STEP;inversion STEP;subst;cbn[nw_state]in CS;
 destruct CS as[AF[ENV[[QUIET ORIGIN]CONT]]].
 - cbn[nw_state];repeat split;auto.
   + eapply(qcontext_replace _ _ _ H0 a a' QUIET).
     eapply q_lred;[exact(qcontext_hole _ _ _ H0 a QUIET)|exact H].
   + exact(origin_lred_context ge allowed _ _ _ H0 eq_refl e a m a' m' ORIGIN H).
 - cbn[nw_state];repeat split;auto.
   + eapply(qcontext_replace _ _ _ H0 a a' QUIET).
     eapply q_rred;[exact(qcontext_hole _ _ _ H0 a QUIET)|exact H].
   + exact(origin_rred_context ge allowed _ _ _ H0 eq_refl e a m t a' m' ORIGIN H).
 - assert(HOLE:origin_expr ge allowed e a)by(eapply origin_context_hole;eauto).
   destruct(origin_call_internal ge allowed _ _ _ _ _ _ HOLE H)as[target[FD AT]];subst fd.
   split;[exists target;auto|]. split;[exact I|]. exists empty_env.
   cbn[nw_cont]. split;[exact AF|]. split;[exact ENV|].
   split;[|exact CONT]. intro v;unfold closed_expr;split.
   + eapply(qcontext_replace _ _ _ H0 a(Eval v ty)QUIET).
     assert(Q:qexpr a=true)by(eapply qcontext_hole;eauto).
     inversion H;subst;cbn[qexpr]in Q;core_unpack;assumption.
   + inversion H;subst;eapply(origin_call_replace ge allowed _ _ _ H0 eq_refl);eauto.
 - exact I.
Qed.
Hypothesis allowed_locals : forall f,allowed f->Forall(fun p=>~In(fst p)ids)(fn_params f++fn_vars f).
Hypothesis allowed_bodies : forall f,allowed f->forall e,unshadowed ids e->nw_stmt e(fn_body f).
Lemma unshadowed_empty : unshadowed ids empty_env.
Proof. intros id IN;apply PTree.gempty. Qed.
Lemma unshadowed_alloc : forall env0 m vars e m',alloc_variables ge env0 m vars e m'->
 unshadowed ids env0->Forall(fun p=>~In(fst p)ids)vars->unshadowed ids e.
Proof.
 intros env0 m vars e m' AL;induction AL;intros ENV FRESH;auto.
 inversion FRESH;subst;apply IHAL;auto.
 intros function_id IN;rewrite PTree.gso;[apply ENV;exact IN|intro EQ;subst;contradiction].
Qed.
Lemma nw_sstep : forall S t S',nw_state S->Csem.sstep ge S t S'->nw_state S'.
Proof.
 intros S t S' CS STEP;inversion STEP;subst;cbn[nw_state nw_stmt nw_cont]in CS;
 repeat match goal with H:_/\_|-_=>destruct H end;try contradiction;
 cbn[nw_state nw_stmt nw_cont];try(solve[tauto]).
 all:try(solve[destruct b;tauto]).
 all:try(solve[repeat match goal with H:_\/_|-_=>destruct H;subst end;tauto]).
 all:try(solve[eexists;eapply nw_cont_call;eauto]).
 all:try(solve[eexists;eassumption]).
 - destruct H2 as[target[FD AT]];inversion FD;subst.
   destruct H4 as[ec CONT].
   assert(ENV:unshadowed ids e)by(eapply unshadowed_alloc;eauto using unshadowed_empty,allowed_locals).
   split;[exact I|]. split;[exact ENV|]. split;[apply allowed_bodies;auto|].
   eapply nw_cont_call_any;eauto.
 - destruct CS as[e0[AF[ENV[EXPR CONT]]]].
   split;[exact AF|]. split;[exact ENV|]. split;[apply EXPR|exact CONT].
Qed.
Theorem nw_step : forall S t S',nw_state S->Csem.step ge S t S'->nw_state S'.
Proof. intros S t S' C[E|T];eauto using nw_estep,nw_sstep. Qed.
Theorem nw_do_step_exact : forall cb asm w S t S',nw_state S->
 ((exists rule,In(TR rule t S')(Cexec.do_step ge cb asm w S))<->Csem.step ge S t S').
Proof. intros;apply pure_do_step_exact;eauto using nw_callback_free,nw_silent. Qed.
End NO_WHILE.
