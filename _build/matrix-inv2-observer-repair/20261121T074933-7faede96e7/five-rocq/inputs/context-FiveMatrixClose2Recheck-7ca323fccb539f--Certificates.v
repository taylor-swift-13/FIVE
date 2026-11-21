From Stdlib Require Import List Classical String.
From compcert Require Import Coqlib AST Values Memory Events Globalenvs Determinism Ctypes Csyntax Csem Cexec Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress CallfreeExecution PhaseComposition BlockExecution.
Definition Defined(ge:genv)(v:val)(mf:mem)(s:Csem.state):Prop := normal_state s=true /\ call_names s /\ state_eval ge s=Some(v,mf).
Lemma defined_certificate:forall ge v mf,certificate ge(Defined ge v mf)(Returnstate v Kstop mf).
Proof. intros ge v mf;split.
 - intros s[N[CN EV]].
   destruct(invariant_progress ge s ltac:(split;[exact N|];split;[exact CN|];exists(v,mf);exact EV))as[[vr[mr EQ]]|[t[next ST]]].
   + subst s;cbn[state_eval]in EV;inversion EV;left;reflexivity.
   + right;exists t,next;split;auto;destruct(normal_step_forward ge s t next(v,mf)N EV ST)as[NN EN];unfold Defined;split;[exact NN|];split;[exact(normal_step_names ge s t next N CN ST)|exact EN].
 - intros s t next[N[CN EV]]NF ST;destruct(normal_step_forward ge s t next(v,mf)N EV ST)as[NN EN];unfold Defined;split;[exact NN|];split;[exact(normal_step_names ge s t next N CN ST)|exact EN].
Qed.
Lemma join_certificate:forall ge P Q middle target,certificate ge P middle->certificate ge Q target->Q middle->certificate ge(fun s=>P s\/Q s)target.
Proof. intros ge P Q middle target[PP PC][QP QC]QI;split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[next[ST PN]]]];[subst s;destruct(QP middle QI)as[EQ|[t[next[ST QN]]]]|];eauto 8.
   + destruct(QP s QS)as[EQ|[t[next[ST QN]]]];eauto 8.
 - intros s t next[PS|QS]NF ST.
   + destruct(classic(s=middle))as[EQ|NE];[subst s;right;eapply QC;eauto|left;eapply PC;eauto].
   + right;eapply QC;eauto.
Qed.
Lemma prepend_certificate:forall ge P initial middle target,unique_transition ge initial middle->certificate ge P target->P middle->certificate ge(fun s=>s=initial\/P s)target.
Proof. intros ge P initial middle target[ST UNIQUE][PP PC]PI;split.
 - intros s[EQ|PS];[subst s;right;exists E0,middle;auto|destruct(PP s PS)as[EQ|[t[next[STEP PN]]]];eauto 8].
 - intros s t next[EQ|PS]NF STEP;[subst s;destruct(UNIQUE t next STEP)as[TT EQ];subst next;auto|right;eapply PC;eauto].
Qed.
Lemma accessible_certificate_reaches:forall ge P target initial,certificate ge P target->P initial->Acc(successor ge)initial->exists t,star Csem.step ge initial t target.
Proof. intros ge P target initial CERT PI ACC;revert PI;induction ACC as[s ACC IH];intros PI.
 destruct(proj1 CERT s PI)as[EQ|[tr[next[ST PN]]]];[subst s;exists E0;constructor|].
 destruct(IH next ltac:(exists tr;exact ST)PN)as[t PATH];exists(tr**t);eapply star_step;eauto. Qed.
Lemma certificate_safety:forall ge P v mf initial,certificate ge P(Returnstate v Kstop mf)->P initial->no_error ge initial.
Proof. intros ge P v mf initial CERT PI t reached PATH[NR STOP].
 destruct(certificate_no_error ge P(Returnstate v Kstop mf)initial CERT PI(return_stop_nostep ge v mf)t reached PATH)as[EQ|[tr[next ST]]].
 - subst reached;apply NR;exists v,mf;reflexivity.
 - exact(STOP tr next ST). Qed.
Print Assumptions defined_certificate.
Print Assumptions accessible_certificate_reaches.

Lemma seq_unique:forall ge f a b k e m,unique_transition ge(State f(Ssequence a b)k e m)(State f a(Kseq b k)e m).
Proof. intros;split.
 - right;constructor.
 - intros t next[ES|SS];[inversion ES|inversion SS;subst;repeat match goal with H:_\/_ |- _=>destruct H end;try discriminate;cbn[is_call_cont]in *;try contradiction;split;reflexivity]. Qed.
Lemma skipseq_unique:forall ge f a k e m,unique_transition ge(State f Sskip(Kseq a k)e m)(State f a k e m).
Proof. intros;split.
 - right;constructor.
 - intros t next[ES|SS];[inversion ES|inversion SS;subst;repeat match goal with H:_\/_ |- _=>destruct H end;try discriminate;cbn[is_call_cont]in *;try contradiction;split;reflexivity]. Qed.
Lemma if_unique:forall ge f a yes no k e m,unique_transition ge(State f(Sifthenelse a yes no)k e m)(ExprState f a(Kifthenelse yes no k)e m).
Proof. intros;split.
 - right;constructor.
 - intros t next[ES|SS];[inversion ES|inversion SS;subst;repeat match goal with H:_\/_ |- _=>destruct H end;try discriminate;cbn[is_call_cont]in *;try contradiction;split;reflexivity]. Qed.
Definition null_external (_:string)(_:signature)(_:Senv.t)(_:world)(_:list val)(_:mem):option(world*trace*val*mem):=None.
Lemma internal_unique:forall ge f args m e ma mb,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f))->
 Cexec.do_alloc_variables ge empty_env m(fn_params f++fn_vars f)=(e,ma)->
 Cexec.sem_bind_parameters ge PureDenotation.quiet_world e ma(fn_params f)args=Some mb->
 unique_transition ge(Callstate(Internal f)args Kstop m)(State f(fn_body f)Kstop e mb).
Proof. intros ge f args m e ma mb ND ALLOC BIND.
 assert(AN:Cexec.do_step ge null_external null_external PureDenotation.quiet_world(Callstate(Internal f)args Kstop m)=
 (TR "step_internal_function" E0(State f(fn_body f)Kstop e mb)::nil)).
 { cbn[Cexec.do_step];destruct(list_norepet_dec ident_eq(var_names(fn_params f)++var_names(fn_vars f)))as[YES|NO];[rewrite ALLOC,BIND;reflexivity|contradiction]. }
 split.
 - eapply supported_nonstuck_transition;[exact I|rewrite AN;left;reflexivity|discriminate].
 - intros t next STEP;assert(TT:t=E0)by(destruct STEP as[ES|SS];inversion ES||inversion SS;auto);subst t.
   destruct(pure_do_step_complete ge null_external null_external PureDenotation.quiet_world(Callstate(Internal f)args Kstop m)E0 next PureDenotation.quiet_world I(possible_trace_nil _)STEP)as[rule IN].
   rewrite AN in IN;destruct IN as[EQ|BAD];[inversion EQ;auto|contradiction].
Qed.
