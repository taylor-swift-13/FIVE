From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress AtomicDenotation AtomicProgress CallfreeExecution PhaseComposition StandaloneCallShell.
From PidPositionTranslationAttempt002 Require Import NoSubSyntax.
Section NO_SUB_ATOMIC.
Variable ge:genv.
Variable f:function.
Variable e:env.
Variable k:cont.
Variable m mf:mem.
Variable original:expr.
Variable result:val.
Hypothesis syntax:atomic_expr original=true.
Hypothesis evaluation:atomic_eval ge e m original=Some(result,mf).
Hypothesis annotated:no_sub original=true.
Definition no_sub_atomic_invariant(s:Csem.state):Prop:=
 s=State f Sskip k e mf \/
 exists a ma,s=ExprState f a(Kdo k)e ma /\atomic_expr a=true /\
 atomic_eval ge e ma a=Some(result,mf) /\no_sub a=true.
Lemma no_sub_atomic_successors:forall s t next,
 no_sub_atomic_invariant s ->s<>State f Sskip k e mf ->
 Csem.step ge s t next ->no_sub_atomic_invariant next.
Proof.
 intros s t next[DONE|[a[ma[EQ[AT[AE TREE]]]]]]NF STEP;[contradiction|subst s].
 destruct STEP as[ES|SS].
 - destruct(atomic_defined_estep ge f a(Kdo k)e ma t next result mf AT AE ES)
   as[ar[mr[EQ[TT[SY DEN]]]]].
   pose proof(no_sub_estep ge f a(Kdo k)e ma t next TREE ES)as TREE2.
   rewrite EQ in TREE2;cbn[expr_no_sub]in TREE2.
   right;exists ar,mr;auto.
 - inversion SS;subst;cbn[atomic_eval pure_rval]in AE;injection AE as VR MM;subst.
   left;reflexivity.
Qed.
Lemma no_sub_atomic_progress:forall s,
 no_sub_atomic_invariant s ->s=State f Sskip k e mf \/
 exists t next,Csem.step ge s t next /\no_sub_atomic_invariant next.
Proof.
 intros s[DONE|[a[ma[EQ[AT[AE TREE]]]]]];[left;exact DONE|subst s].
 destruct(literal RV a)eqn:LIT.
 - destruct(literal_r_inv a LIT)as[v[ty EQ]];subst a.
   cbn[atomic_eval pure_rval]in AE;injection AE as VR MM;subst.
   right;exists E0,(State f Sskip k e mf);split;[right;constructor|left;reflexivity].
 - destruct(immediate_has_step ge f a(Kdo k)e ma LIT
    ltac:(exact(atomic_not_stuck ge e ma a result mf AT AE RV(fun x=>x)a(ctx_top RV)eq_refl)))as[t[next STEP]].
   right;exists t,next;split;[exact STEP|].
   eapply no_sub_atomic_successors;[right;exists a,ma;auto|discriminate|exact STEP].
Qed.
Theorem no_sub_atomic_certificate:
 certificate ge no_sub_atomic_invariant(State f Sskip k e mf).
Proof. split;[exact no_sub_atomic_progress|exact no_sub_atomic_successors]. Qed.
Theorem no_sub_atomic_initial:
 no_sub_atomic_invariant(ExprState f original(Kdo k)e m).
Proof. right;exists original,m;auto. Qed.
Theorem no_sub_atomic_observation:forall f' a k' e' ma,
 no_sub_atomic_invariant(ExprState f' a k' e' ma) ->no_sub a=true.
Proof.
 intros f' a k' e' ma[DONE|[ar[mr[EQ REST]]]];[discriminate|].
 injection EQ as FF AA KK EE MM;subst;tauto.
Qed.
End NO_SUB_ATOMIC.
Print Assumptions no_sub_atomic_certificate.
