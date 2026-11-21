From Stdlib Require Import Classical.
From compcert Require Import Values Memory Events Csem.
From FiveGuidanceAllOrder Require Import PhaseComposition.
Section READONLY.
Variable ge:genv.
Variables L R F:Type.
Variable pre:L->R->F->Csem.state.
Variable call:L->R->Csem.state.
Variable frame:L->R->cont.
Variable post:L->R->Csem.state.
Variable initial target:Csem.state.
Variable observe:Csem.state->Prop.
Hypothesis initial_observed:observe initial.
Hypothesis pre_observed:forall l r f,observe(pre l r f).
Variable result:val.
Variable m:mem.
Variable l0:L.
Variable r0:R.
Variable f0:F.
Definition pre_or_call(s:Csem.state):Prop:=
 (exists l r f,s=pre l r f)\/(exists l r,s=call l r).
Hypothesis pre_progress:forall l r f,exists t next,
 Csem.step ge(pre l r f)t next /\pre_or_call next.
Hypothesis pre_all_successors:forall l r f t next,
 Csem.step ge(pre l r f)t next ->pre_or_call next.
Hypothesis initial_unique:unique_transition ge initial(pre l0 r0 f0).
Hypothesis callees:forall l r,exists P,
 certificate ge P(Returnstate result(frame l r)m) /\P(call l r)/\(forall s,P s->observe s).
Hypothesis returns:forall l r,
 unique_transition ge(Returnstate result(frame l r)m)(post l r).
Hypothesis postphases:forall l r,exists Q,certificate ge Q target /\Q(post l r)/\(forall s,Q s->observe s).
Definition active_callee(s:Csem.state):Prop:=
 exists l r P,certificate ge P(Returnstate result(frame l r)m) /\P(call l r)/\(forall z,P z->observe z)/\P s.
Definition active_post(s:Csem.state):Prop:=
 exists l r Q,certificate ge Q target /\Q(post l r)/\(forall z,Q z->observe z)/\Q s.
Definition invariant(s:Csem.state):Prop:=
 s=initial\/(exists l r f,s=pre l r f)\/active_callee s\/active_post s.
Lemma enter_callee:forall l r,active_callee(call l r).
Proof. intros;destruct(callees l r)as[P[C[I OBS]]];exists l,r,P;auto. Qed.
Lemma enter_post:forall l r,active_post(post l r).
Proof. intros;destruct(postphases l r)as[Q[C[I OBS]]];exists l,r,Q;auto. Qed.
Lemma classify_pre:forall s,pre_or_call s ->
 (exists l r f,s=pre l r f)\/active_callee s.
Proof.
 intros s[PRE|[l[r EQ]]];auto;subst;right;apply enter_callee.
Qed.
Theorem readonly_assignment_certificate:certificate ge invariant target.
Proof.
 split.
 - intros s[START|[PRE|[CALLEE|POST]]].
   + subst;right;exists E0,(pre l0 r0 f0);split;[exact(proj1 initial_unique)|].
     right;left;exists l0,r0,f0;reflexivity.
   + destruct PRE as[l[r[f EQ]]];subst s.
     destruct(pre_progress l r f)as[t[next[STEP CL]]].
     right;exists t,next;split;auto;destruct(classify_pre _ CL)as[P|C].
     * right;left;exact P.
     * right;right;left;exact C.
   + destruct CALLEE as[l[r[P[C[INCUR[OBS IN]]]]]].
     destruct(proj1 C s IN)as[EQ|[t[next[STEP PN]]]].
     * subst;right;exists E0,(post l r);split;[exact(proj1(returns l r))|].
       right;right;right;apply enter_post.
     * right;exists t,next;split;auto;right;right;left;exists l,r,P;auto.
   + destruct POST as[l[r[Q[C[QI[OBS IN]]]]]].
     destruct(proj1 C s IN)as[EQ|[t[next[STEP QN]]]];[auto|].
     right;exists t,next;split;auto;right;right;right;exists l,r,Q;auto.
 - intros s t next[START|[PRE|[CALLEE|POST]]]NF STEP.
   + subst;destruct(proj2 initial_unique t next STEP)as[TT EQ];subst.
     right;left;exists l0,r0,f0;reflexivity.
   + destruct PRE as[l[r[f EQ]]];subst.
     destruct(classify_pre _ (pre_all_successors l r f t next STEP))as[P|C].
     * right;left;exact P.
     * right;right;left;exact C.
   + destruct CALLEE as[l[r[P[C[INCUR[OBS IN]]]]]].
     destruct(classic(s=Returnstate result(frame l r)m))as[EQ|NE].
     * subst;destruct(proj2(returns l r)t next STEP)as[TT EQ];subst.
       right;right;right;apply enter_post.
     * right;right;left;exists l,r,P;split;[exact C|];split;[exact INCUR|];split;[exact OBS|].
       eapply(proj2 C);eauto.
   + destruct POST as[l[r[Q[C[QI[OBS IN]]]]]];right;right;right;exists l,r,Q.
     split;[exact C|];split;[exact QI|];split;[exact OBS|];eapply(proj2 C);eauto.
Qed.
Theorem initial_member:invariant initial.
Proof. left;reflexivity. Qed.
Theorem observations:forall s,invariant s ->observe s.
Proof.
 intros s[START|[PRE|[CAL|POST]]].
 - subst;exact initial_observed.
 - destruct PRE as[l[r[f EQ]]];subst;apply pre_observed.
 - destruct CAL as[l[r[P[C[PI[OBS IN]]]]]];apply OBS;exact IN.
 - destruct POST as[l[r[Q[C[QI[OBS IN]]]]]];apply OBS;exact IN.
Qed.
End READONLY.
Print Assumptions readonly_assignment_certificate.
