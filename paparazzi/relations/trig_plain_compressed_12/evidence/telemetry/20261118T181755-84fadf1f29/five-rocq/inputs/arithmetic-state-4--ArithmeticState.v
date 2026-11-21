From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Ctypes Csyntax Csem Ctyping Smallstep.
From PprzTrigRelationSupport Require Import ClosedCalls.
From PprzTrigCBMC Require Import ArithmeticOriginsExpr ArithmeticContexts ArithmeticCall SourceTyping.

Fixpoint arithmetic_stmt(s:statement):Prop:=match s with
 |Sskip|Sbreak|Scontinue|Sreturn None=>True
 |Sdo a|Sreturn(Some a)=>arithmetic_expr a
 |Ssequence a b=>arithmetic_stmt a/\arithmetic_stmt b
 |Sifthenelse a yes no=>arithmetic_expr a/\arithmetic_stmt yes/\arithmetic_stmt no
 |Swhile a body|Sdowhile a body=>arithmetic_expr a/\arithmetic_stmt body
 |Sfor init a advance body=>arithmetic_stmt init/\arithmetic_expr a/\arithmetic_stmt advance/\arithmetic_stmt body
 |_=>False end.
Fixpoint arithmetic_cont(k:cont):Prop:=match k with
 |Kstop=>True
 |Kdo k|Kreturn k=>arithmetic_cont k
 |Kseq s k=>arithmetic_stmt s/\arithmetic_cont k
 |Kifthenelse yes no k=>arithmetic_stmt yes/\arithmetic_stmt no/\arithmetic_cont k
 |Kwhile1 a body k|Kwhile2 a body k|Kdowhile1 a body k|Kdowhile2 a body k=>arithmetic_expr a/\arithmetic_stmt body/\arithmetic_cont k
 |Kfor2 a advance body k|Kfor3 a advance body k|Kfor4 a advance body k=>arithmetic_expr a/\arithmetic_stmt advance/\arithmetic_stmt body/\arithmetic_cont k
 |Kcall f ec C ty k=>(forall v,arithmetic_expr(C(Eval v ty)))/\arithmetic_cont k
 |_=>False end.
Definition arithmetic_state(s:Csem.state):Prop:=match s with
 |State f s k e m=>arithmetic_stmt s/\arithmetic_cont k
 |ExprState f a k e m=>arithmetic_expr a/\arithmetic_cont k
 |Callstate fd args k m=>arithmetic_cont k
 |Returnstate res k m=>arithmetic_cont k
 |Stuckstate=>True end.
Lemma arithmetic_cont_call : forall k,arithmetic_cont k->arithmetic_cont(call_cont k).
Proof. induction k;simpl;intros A;intuition eauto. Qed.

Lemma arithmetic_estep : forall p S t S',Ctyping.wt_state p S->arithmetic_state S->
 Csem.estep(Csem.globalenv p)S t S'->arithmetic_state S'.
Proof.
 intros p S t S' WT A STEP;inversion STEP;subst;cbn[arithmetic_state]in A;destruct A as[EXPR CONT].
 - split;[eapply arithmetic_lred_context;eauto|exact CONT].
 - split;[|exact CONT]. inversion WT;subst.
   match goal with T:Ctyping.wt_rvalue _ ?TE(C a)|-_=>
    refine(@arithmetic_rred_context _ _ _ H0 _ TE _ _ _ _ _ EXPR _ H);
    exact(@Ctyping.wt_subexpr _ TE a RV RV C H0 T)end.
 - cbn[arithmetic_state arithmetic_cont];split;[|exact CONT].
   intro v;inversion H;subst;eapply arithmetic_call_context;eauto.
 - exact I.
Qed.
Section STATEMENTS.
Variable ge:Csem.genv.
Variable allowed:function->Prop.
Variable ids:list ident.
Hypothesis bodies:forall f,allowed f->arithmetic_stmt(fn_body f).
Lemma arithmetic_sstep : forall S t S',ClosedCalls.closed_state ge allowed ids S->
 arithmetic_state S->Csem.sstep ge S t S'->arithmetic_state S'.
Proof.
 intros S t S' CLOSED A STEP;inversion STEP;subst;cbn[arithmetic_state arithmetic_stmt arithmetic_cont]in A;
 repeat match goal with H:_/\_|-_=>destruct H end;try contradiction;
 cbn[arithmetic_state arithmetic_stmt arithmetic_cont];try(solve[tauto]).
 all:try(solve[destruct b;tauto]).
 all:try(solve[repeat match goal with H:_\/_|-_=>destruct H;subst end;tauto]).
 all:try(solve[eapply arithmetic_cont_call;eauto]).
 cbn[ClosedCalls.closed_state]in CLOSED.
   destruct CLOSED as[[target[FD AT]]REST];inversion FD;subst.
   split;[apply bodies;exact AT|assumption].
 Unshelve. all:match goal with |-?G=>idtac "SSTEP-LEFT" G end.
Qed.
End STATEMENTS.



