From Stdlib Require Import List.
From compcert Require Import Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution ContinuationLift PhaseComposition.
From StateSpeedSetterSupport Require Import Certificates.
Definition function_owner(f:function)(s:Csem.state):Prop:=
 match s with State f2 _ _ _ _|ExprState f2 _ _ _ _=>f2=f|Callstate _ _ _ _=>False|_=>True end.
Lemma owner_normal_step:forall ge f s t next,
 normal_state s=true->function_owner f s->Csem.step ge s t next->function_owner f next.
Proof.
 intros ge f s t next N OWN[ES|SS].
 - inversion ES;subst;cbn[function_owner]in *;auto.
   exfalso;eapply normal_no_callred;eauto.
 - inversion SS;subst;cbn[function_owner]in *;try contradiction;auto.
   all:destruct k;cbn[normal_state normal_cont]in N;try discriminate;contradiction.
Qed.
Definition owned_normal(ge:genv)(f:function)(v:val)(mf:mem)(s:Csem.state):Prop:=
 normal_state s=true /\call_names s /\state_eval ge s=Some(v,mf) /\function_owner f s.
Lemma owned_normal_certificate:forall ge f v mf,certificate ge(owned_normal ge f v mf)(Returnstate v Kstop mf).
Proof.
 intros ge f v mf;split.
 - intros s[N[CN[EV OWN]]].
   destruct(proj1(evaluator_certificate ge v mf)s(conj N(conj CN EV)))as[EQ|[t[next[ST PN]]]];[left;exact EQ|].
   right;exists t,next;split;[exact ST|];destruct PN as[NN[NC NE]];repeat split;try assumption;eapply owner_normal_step;eauto.
 - intros s t next[N[CN[EV OWN]]]NF ST.
   destruct(proj2(evaluator_certificate ge v mf)s t next(conj N(conj CN EV))NF ST)as[NN[NC NE]].
   repeat split;try assumption;eapply owner_normal_step;eauto.
Qed.
Definition owned_callee(ge:genv)(base:cont)(f:function)(v:val)(mf:mem)(s:Csem.state):Prop:=
 exists raw,s=plug_state base raw /\owned_normal ge f v mf raw.
Lemma owned_callee_certificate:forall ge base f v mf,is_call_cont base->certificate ge(owned_callee ge base f v mf)(Returnstate v base mf).
Proof.
 intros ge base f v mf BASE;split.
 - intros s[raw[EQ[N[CN[EV OWN]]]]];subst s.
   destruct(proj1(owned_normal_certificate ge f v mf)raw(conj N(conj CN(conj EV OWN))))as[RET|[t[next[ST PN]]]].
   + subst raw;left;reflexivity.
   + right;exists t,(plug_state base next);split;[eapply plug_normal_step;eauto|exists next;split;[reflexivity|exact PN]].
 - intros s t next[raw[EQ[N[CN[EV OWN]]]]]NF ST;subst s.
   assert(NR:~CallfreeExecution.normal_return raw).
   { intros[w[mm RET]];subst raw;cbn[state_eval]in EV;injection EV as W M;subst;apply NF;reflexivity. }
   destruct(plug_step_inverse ge base raw t next BASE N NR ST)as[raw2[EQ ST2]].
   exists raw2;split;[exact EQ|].
   eapply(proj2(owned_normal_certificate ge f v mf));[repeat split;eassumption| |exact ST2].
   intro RET;subst raw;contradiction NR;exists v,mf;reflexivity.
Qed.
Print Assumptions owned_callee_certificate.
