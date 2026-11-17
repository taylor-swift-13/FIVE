From compcert Require Import Coqlib Values Memory Events Ctypes Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition PureDenotation.
From PidPositionSafety Require Import FalseAndIf.
Definition phase_step(target:Csem.state)(ge:genv)(s:Csem.state)(t:trace)(next:Csem.state):Prop:=
 s<>target/\Csem.step ge s t next.
Lemma certificate_before_exit:forall ge P target initial,
 certificate ge P target ->P initial ->forall t reached,
 star(phase_step target)ge initial t reached ->P reached.
Proof.
 intros ge P target initial CERT INIT t reached PATH;revert INIT.
 induction PATH;intros INIT;auto.
 destruct H as[NE STEP];apply IHPATH;eapply(proj2 CERT);eauto.
Qed.
Theorem false_and_no_do_before_exit:forall ge f e k m left right yes value,
 simple left=true ->pure_rval ge e m left=Some value ->
 Cop.bool_val value(typeof left)m=Some false ->
 forall t reached,star(phase_step(State f Sskip k e m))ge
 (State f(Sifthenelse(Eseqand left right tint)yes Sskip)k e m)t reached ->
 forall f' a k' e' m',reached<>State f'(Sdo a)k' e' m'.
Proof.
 intros ge f e k m left right yes value SI PV BV t reached PATH f' a k' e' m' EQ.
 pose proof(FalseAndIf.false_and_if_certificate ge f e k m left right yes Sskip value SI PV BV)as CERT.
 pose proof(certificate_before_exit ge _ _ _ CERT
 (FalseAndIf.initial_member ge f e k m left right yes Sskip value)t reached PATH)as INV.
 destruct INV as[START|[[r[VR ER]]|[DONE|EXIT]]];subst;discriminate.
Qed.
Print Assumptions false_and_no_do_before_exit.
