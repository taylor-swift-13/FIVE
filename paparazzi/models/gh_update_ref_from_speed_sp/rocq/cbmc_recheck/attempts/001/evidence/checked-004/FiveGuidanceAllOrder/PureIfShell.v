From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress CallfreeExecution PhaseComposition.
Section IF_SHELL.
Variable ge:genv.
Variable f:function.
Variable e:env.
Variable k:cont.
Variable m:mem.
Variable condition:expr.
Variable yes no:statement.
Variable value:val.
Variable taken:bool.
Hypothesis condition_simple:simple condition=true.
Hypothesis condition_value:pure_rval ge e m condition=Some value.
Hypothesis condition_bool:bool_val value(typeof condition)m=Some taken.
Definition target:Csem.state:=State f(if taken then yes else no)k e m.
Definition invariant(s:Csem.state):Prop:=
 s=State f(Sifthenelse condition yes no)k e m \/
 (exists residual,s=ExprState f residual(Kifthenelse yes no k)e m /\
 typeof residual=typeof condition /\simple residual=true /\pure_rval ge e m residual=Some value) \/s=target.
Lemma initial:invariant(State f(Sifthenelse condition yes no)k e m).
Proof. left;reflexivity. Qed.
Theorem all_successors:forall s t next,invariant s->s<>target->Csem.step ge s t next->invariant next.
Proof.
 intros s t next[START|[EXPR|DONE]]NF STEP.
 - subst s;destruct STEP as[ES|SS];[inversion ES|].
   inversion SS;subst;
   try solve[right;left;exists condition;repeat split;auto];
   repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
 - destruct EXPR as[a[EQ[TY[SI VAL]]]];subst s.
   destruct STEP as[ES|SS].
   + destruct(simple_estep ge f a(Kifthenelse yes no k)e m t next SI ES)as[BAD|[a'[EQ[TA[SA DEN]]]]].
     * subst next;inversion ES;subst;exfalso.
       match goal with N:~imm_safe _ _ _ _ _,CT:Csem.context _ _ _|-_=>
       apply N;pose proof(pure_not_stuck ge e m _ value SI VAL)as NS;exact(NS _ _ _ CT eq_refl)end.
     * subst next;right;left;exists a';repeat split;auto;congruence.
   + inversion SS;subst.
     cbn[pure_rval]in VAL;injection VAL as EQ.
     cbn[typeof]in TY.
     match goal with B:bool_val _ _ _=Some _|-_=>
     rewrite EQ,TY in B;rewrite condition_bool in B;injection B as EQB end.
     right;right;unfold target;rewrite <-EQB;reflexivity.
 - contradiction.
Qed.
Theorem progress:forall s,invariant s->s=target \/exists t next,Csem.step ge s t next /\invariant next.
Proof.
 intros s[START|[EXPR|DONE]].
 - subst s;right;exists E0,(ExprState f condition(Kifthenelse yes no k)e m);split.
   + right;apply step_ifthenelse_1.
   + right;left;exists condition;repeat split;auto.
 - destruct EXPR as[a[EQ[TY[SI VAL]]]];subst s.
   destruct(literal RV a)eqn:LIT.
   + destruct(literal_r_inv a LIT)as[v[ty EQ]];subst a.
     cbn[pure_rval]in VAL;injection VAL as EQ.
     cbn[typeof]in TY;right;exists E0,target;split.
     * right;unfold target;eapply step_ifthenelse_2;rewrite EQ,TY;exact condition_bool.
     * right;right;reflexivity.
   + destruct(immediate_has_step ge f a(Kifthenelse yes no k)e m LIT
     (simple_immediate ge e m a SI ltac:(rewrite VAL;discriminate)))as[t[next STEP]].
     right;exists t,next;split;[exact STEP|].
     eapply all_successors;[right;left;exists a;repeat split;auto| |exact STEP].
     intro EQ;unfold target in EQ;discriminate EQ.
 - auto.
Qed.
Theorem if_certificate:certificate ge invariant target.
Proof. split;[apply progress|apply all_successors]. Qed.
Print Assumptions if_certificate.
End IF_SHELL.
