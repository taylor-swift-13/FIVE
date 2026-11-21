From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Csyntax Csem Smallstep.
Import ListNotations.
Definition certificate(ge:genv)(P:Csem.state->Prop)(target:Csem.state):Prop :=
 (forall s,P s ->s=target \/ exists t next,Csem.step ge s t next /\ P next) /\
 (forall s t next,P s ->s<>target ->Csem.step ge s t next ->P next).
Definition unique_transition(ge:genv)(from to:Csem.state):Prop :=
 Csem.step ge from E0 to /\
 forall t next,Csem.step ge from t next ->t=E0 /\ next=to.
Theorem chain_certificate:forall ge P Q middle initial target,
 certificate ge P middle -> certificate ge Q target ->
 unique_transition ge middle initial ->Q initial ->
 certificate ge(fun s=>P s \/ Q s)target.
Proof.
 intros ge P Q middle initial target[PP PC][QP QC][BRIDGE UNIQUE]QI.
 split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[next[STEP PN]]]].
     * subst s;right;exists E0,initial;split;auto.
     * right;exists t,next;split;auto.
   + destruct(QP s QS)as[EQ|[t[next[STEP QN]]]].
     * auto.
     * right;exists t,next;split;auto.
 - intros s t next[PS|QS]NF STEP.
   + destruct(classic(s=middle))as[EQ|NE].
     * subst;destruct(UNIQUE _ _ STEP);subst;auto.
     * left;eapply PC;eauto.
   + right;eapply QC;eauto.
Qed.
Theorem singleton_bridge_certificate:forall ge initial target,
 unique_transition ge initial target ->
 certificate ge(fun s=>s=initial \/ s=target)target.
Proof.
 intros ge initial target[STEP UNIQUE];split.
 - intros s[EQ|EQ];[subst s;right;exists E0,target;split;auto|auto].
 - intros s t next[EQ|EQ]NF ST;subst;try contradiction.
   destruct(UNIQUE _ _ ST);subst;auto.
Qed.
Theorem certificate_reachable:forall ge P target initial,
 certificate ge P target ->P initial ->nostep Csem.step ge target ->
 forall t reached,star Csem.step ge initial t reached ->P reached.
Proof.
 intros ge P target initial[PR CL]PI STOP t reached PATH.
 revert PI;induction PATH;intros PI;auto.
 apply IHPATH;destruct(classic(s1=target))as[EQ|NE].
 - subst;exfalso;eapply STOP;eauto.
 - eapply CL;eauto.
Qed.
Theorem certificate_no_error:forall ge P target initial,
 certificate ge P target ->P initial ->nostep Csem.step ge target ->
 forall t reached,star Csem.step ge initial t reached ->
 reached=target \/ exists tr next,Csem.step ge reached tr next.
Proof.
 intros ge P target initial CERT PI STOP t reached PATH.
 pose proof(certificate_reachable ge P target initial CERT PI STOP t reached PATH)as INV.
 destruct(proj1 CERT reached INV)as[EQ|[tr[next[STEP PN]]]];[auto|right;eauto].
Qed.
Theorem certificate_normal_unique:forall ge P v mf initial,
 certificate ge P(Returnstate v Kstop mf) ->P initial ->
 forall t v' mf',star Csem.step ge initial t(Returnstate v' Kstop mf') ->
 v'=v /\ mf'=mf.
Proof.
 intros ge P v mf initial CERT PI t v' mf' PATH.
 assert(STOP:nostep Csem.step ge(Returnstate v Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 destruct(certificate_no_error ge P _ initial CERT PI STOP t _ PATH)as[EQ|[tr[next STEP]]].
 - inversion EQ;auto.
 - destruct STEP as[ES|SS];inversion ES||inversion SS.
Qed.
Print Assumptions chain_certificate.
Print Assumptions certificate_no_error.
Print Assumptions certificate_normal_unique.
