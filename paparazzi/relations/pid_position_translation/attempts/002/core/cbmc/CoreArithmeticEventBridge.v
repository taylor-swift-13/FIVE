From Stdlib Require Import List.
From compcert Require Import AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationProblem Require Import Spec.
From CoreCBMC Require Import ArithmeticTree ArithmeticObservation CoreArithmeticGoals.
Definition CoreArithmeticObservationGoal:Prop:=
 forall m gh ret flight,InputGood m gh ret ->forall t s,
 star Csem.step Execution.ge(Execution.entry(call_args gh ret flight)m)t s ->
 arithmetic_observation Execution.ge Source.f_guidance_pid_h_run s.
Lemma core_observer_binary_event:CoreArithmeticObservationGoal ->
 forall op,CoreBinaryEventGoal op.
Proof.
 intros OBS op m gh ret flight GOOD t C x y k e ma PATH CT.
 pose proof(OBS m gh ret flight GOOD t _ PATH)as SAFE.
 specialize(SAFE eq_refl);destruct SAFE as[BIN UNI].
 exact(BIN C op(Vint x)tint(Vint y)tint tint CT eq_refl).
Qed.
Lemma core_observer_unary_event:CoreArithmeticObservationGoal ->
 forall op,CoreUnaryEventGoal op.
Proof.
 intros OBS op m gh ret flight GOOD t C x k e ma PATH CT.
 pose proof(OBS m gh ret flight GOOD t _ PATH)as SAFE.
 specialize(SAFE eq_refl);destruct SAFE as[BIN UNI].
 exact(UNI C op(Vint x)tint tint CT eq_refl).
Qed.
Lemma core_observer_site:CoreArithmeticObservationGoal ->
 forall site,original_site_bound site ->source_integer_site site=true ->
 CoreArithmeticSiteGoal site.
Proof.
 intros OBS site BOUND INT;split;[exact BOUND|];split;[exact INT|].
 destruct(site_kind site);[apply core_observer_binary_event|apply core_observer_unary_event|apply core_observer_binary_event];exact OBS.
Qed.
Print Assumptions core_observer_site.
