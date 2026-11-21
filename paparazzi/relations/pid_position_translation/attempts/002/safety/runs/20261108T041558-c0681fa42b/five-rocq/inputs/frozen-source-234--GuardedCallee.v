From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation CallfreeExecution ContinuationLift PureIfShell PhaseComposition.
Import ListNotations.

Lemma certificate_prepend:forall ge P target initial next,
 unique_transition ge initial next ->certificate ge P target ->P next ->
 certificate ge(fun s=>s=initial\/P s)target.
Proof.
 intros ge P target initial next[STEP UNIQ][PROG CLOSED]PN;split.
 - intros s[EQ|PS];[subst;right;exists E0,next;split;auto|].
   destruct(PROG s PS)as[EQ|[t[n[ST PI]]]];[auto|right;exists t,n;split;auto].
 - intros s t dst[EQ|PS]NF ST.
   + subst;destruct(UNIQ _ _ ST)as[TT EQ];subst;auto.
   + right;eapply CLOSED;eauto.
Qed.
Lemma certificate_join:forall ge P middle Q target,
 certificate ge P middle ->certificate ge Q target ->Q middle ->
 certificate ge(fun s=>P s\/Q s)target.
Proof.
 intros ge P middle Q target[PP PC][QP QC]QM;split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[n[ST PI]]]].
     * subst;destruct(QP middle QM)as[EQ|[t[n[ST QI]]]];[auto|right;exists t,n;split;auto].
     * right;exists t,n;split;auto.
   + destruct(QP s QS)as[EQ|[t[n[ST QI]]]];[auto|right;exists t,n;split;auto].
 - intros s t dst[PS|QS]NF ST.
   + destruct(classic(s=middle))as[EQ|NE].
     * subst;right;eapply QC;eauto.
     * left;eapply PC;eauto.
   + right;eapply QC;eauto.
Qed.
Lemma internal_nil_unique:forall ge f m base,
 fn_params f=[] ->fn_vars f=[] ->
 unique_transition ge(Callstate(Internal f)[]base m)(State f(fn_body f)base empty_env m).
Proof.
 intros ge f m base PA VA;split.
 - right;eapply step_internal_function with(e:=empty_env)(m1:=m)(m2:=m).
   + rewrite PA,VA;constructor.
   + rewrite PA,VA;constructor.
   + rewrite PA;constructor.
 - intros t next[ES|SS];[inversion ES|].
   inversion SS;subst.
   match goal with A:alloc_variables _ _ _ _ _ _ |- _=>rewrite PA,VA in A;inversion A;subst end.
   match goal with B:bind_parameters _ _ _ _ _ _ |- _=>rewrite PA in B;inversion B;subst end.
   split;reflexivity.
Qed.
Lemma sequence_unique:forall ge f a b base e m,
 unique_transition ge(State f(Ssequence a b)base e m)(State f a(Kseq b base)e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|];inversion SS;subst;repeat match goal with H:_\/_ |- _=>destruct H end;try discriminate;split;reflexivity.
Qed.
Lemma skip_sequence_unique:forall ge f b base e m,
 unique_transition ge(State f Sskip(Kseq b base)e m)(State f b base e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|];inversion SS;subst;cbn[is_call_cont]in *;try contradiction;split;reflexivity.
Qed.

Theorem original_guarded_callee_certificate:forall ge f m condition yes tail testval result,
 fn_params f=[] ->fn_vars f=[] ->
 fn_body f=Ssequence(Sifthenelse condition yes Sskip)tail ->
 simple condition=true ->pure_rval ge empty_env m condition=Some testval ->
 Cop.bool_val testval(typeof condition)m=Some false ->
 normal_stmt tail=true ->
 star Csem.step ge(State f tail Kstop empty_env m)E0(Returnstate result Kstop m) ->
 forall base,is_call_cont base ->
 exists P,certificate ge P(Returnstate result base m) /\P(Callstate(Internal f)[]base m).
Proof.
 intros ge f m condition yes tail testval result PA VA BODY SI EV BOOL NT TAIL base BASE.
 set(Q:=callee_invariant ge base result m).
 assert(QC:certificate ge Q(Returnstate result base m)).
 { split.
   - intros s INV;apply callee_invariant_progress;auto.
   - intros;eapply callee_invariant_all_successors;eauto. }
 assert(QI:Q(State f tail base empty_env m)).
 { pose proof(callee_invariant_entry ge base(State f tail Kstop empty_env m)E0 result m
 ltac:(simpl;rewrite NT;reflexivity)I TAIL)as H;exact H. }
 set(Q1:=fun s=>s=State f Sskip(Kseq tail base)empty_env m\/Q s).
 assert(C1:certificate ge Q1(Returnstate result base m)).
 { apply certificate_prepend with(next:=State f tail base empty_env m);auto using skip_sequence_unique. }
 pose proof(PureIfShell.if_certificate ge f empty_env(Kseq tail base)m condition yes Sskip testval false SI EV BOOL)as IF.
 set(PIF:=PureIfShell.invariant ge f empty_env(Kseq tail base)m condition yes Sskip testval false).
 set(Q2:=fun s=>PIF s\/Q1 s).
 assert(C2:certificate ge Q2(Returnstate result base m)).
 { eapply certificate_join;[exact IF|exact C1|left;reflexivity]. }
 assert(I2:Q2(State f(Sifthenelse condition yes Sskip)(Kseq tail base)empty_env m)).
 { left;apply PureIfShell.initial. }
 set(Q3:=fun s=>s=State f(fn_body f)base empty_env m\/Q2 s).
 assert(C3:certificate ge Q3(Returnstate result base m)).
 { apply certificate_prepend with(next:=State f(Sifthenelse condition yes Sskip)(Kseq tail base)empty_env m);auto.
   rewrite BODY;apply sequence_unique. }
 set(Q4:=fun s=>s=Callstate(Internal f)[]base m\/Q3 s).
 exists Q4;split;[|left;reflexivity].
 apply certificate_prepend with(next:=State f(fn_body f)base empty_env m);auto.
 - apply internal_nil_unique;auto.
 - left;reflexivity.
Qed.
Print Assumptions original_guarded_callee_certificate.
