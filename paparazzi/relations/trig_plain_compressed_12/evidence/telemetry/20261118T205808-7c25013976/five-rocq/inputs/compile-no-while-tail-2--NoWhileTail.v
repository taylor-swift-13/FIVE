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

Fixpoint nw_static_stmt(ids:list ident)(s:statement):bool :=
 match s with
 |Sskip|Sbreak|Scontinue|Sreturn None=>true
 |Sdo a|Sreturn(Some a)=>qexpr a&&static_expr ids a
 |Ssequence a b=>nw_static_stmt ids a&&nw_static_stmt ids b
 |Sifthenelse a yes no=>qexpr a&&static_expr ids a&&nw_static_stmt ids yes&&nw_static_stmt ids no
 |Swhile _ _|Sdowhile _ _=>false
 |Sfor _ _ _ _=>false
 |_=>false end.

Lemma nw_static_sound : forall ge allowed ids,
 (forall id,In id ids->exists b target,Genv.find_symbol ge id=Some b /\Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target)/\allowed target)->
 forall s e,unshadowed ids e->nw_static_stmt ids s=true->nw_stmt ge allowed e s.
Proof.
 intros ge allowed ids KNOWN s;induction s;simpl;intros current_env ENV ST;core_unpack;try discriminate;unfold closed_expr;
 intuition eauto using static_expr_sound.
 all:match goal with o:option expr|-_=>destruct o;simpl in *;core_unpack;unfold closed_expr;intuition eauto using static_expr_sound end.
Qed.
Require PprzTrigLow.Source PprzTrigLow.Execution.
Definition tail_allowed(f:function):Prop:=f=PprzTrigLow.Source.f_pprz_trig_int_f\/
 f=PprzTrigLow.Source.f_pprz_trig_int_12\/f=PprzTrigLow.Source.f_get_nibble\/f=PprzTrigLow.Source.f_table_encode_12.
Lemma tail_known : forall id,In id direct_ids->exists b target,
 Genv.find_symbol PprzTrigLow.Execution.ge id=Some b /\Genv.find_funct PprzTrigLow.Execution.ge(Vptr b Ptrofs.zero)=Some(Internal target)/\tail_allowed target.
Proof.
 intros id IN;unfold direct_ids in IN;destruct IN as[E|[E|[E|[E|[]]]]];subst id.
 - destruct dispatcher_link as[b[S F]];exists b,PprzTrigLow.Source.f_pprz_trig_int_f;repeat split;auto;unfold tail_allowed;auto.
 - destruct decoder_link as[b[S F]];exists b,PprzTrigLow.Source.f_pprz_trig_int_12;repeat split;auto;unfold tail_allowed;auto.
 - destruct(@source_function_link PprzTrigLow.Source.prog PprzTrigLow.Source._get_nibble PprzTrigLow.Source.f_get_nibble ltac:(vm_compute;reflexivity))as[b[S F]].
   exists b,PprzTrigLow.Source.f_get_nibble;repeat split;auto;unfold tail_allowed;auto.
 - destruct(@source_function_link PprzTrigLow.Source.prog PprzTrigLow.Source._table_encode_12 PprzTrigLow.Source.f_table_encode_12 ltac:(vm_compute;reflexivity))as[b[S F]].
   exists b,PprzTrigLow.Source.f_table_encode_12;repeat split;auto;unfold tail_allowed;auto.
Qed.
Lemma tail_locals : forall f,tail_allowed f->Forall(fun p=>~In(fst p)direct_ids)(fn_params f++fn_vars f).
Proof.
 intros f A;apply actual_static_locals;unfold tail_allowed in A;unfold actual_allowed,internal_functions;destruct A as[E|[E|[E|E]]];subst f;cbn;auto 12.
Qed.
Lemma tail_bodies : forall f,tail_allowed f->forall e,unshadowed direct_ids e->nw_stmt PprzTrigLow.Execution.ge tail_allowed e(fn_body f).
Proof.
 intros f A e E;apply(nw_static_sound _ _ _ tail_known _ e E);unfold tail_allowed in A;destruct A as[E|[E|[E|E]]];subst f;vm_compute;reflexivity.
Qed.
Theorem tail_reachable_no_while : forall s t current,
 nw_state PprzTrigLow.Execution.ge tail_allowed direct_ids s->star Csem.step PprzTrigLow.Execution.ge s t current->nw_state PprzTrigLow.Execution.ge tail_allowed direct_ids current.
Proof.
 intros s t current INV PATH;induction PATH;[exact INV|apply IHPATH;eapply nw_step;eauto using tail_locals,tail_bodies].
Qed.
