From Stdlib Require Import Bool List Classical ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition ConcretePhases PureDenotation BlockExecution.
From FiveGuidanceEntry Require Import BigstepSupport.

Lemma join_certificate:forall ge P Q middle target,
 certificate ge P middle ->certificate ge Q target ->Q middle ->
 certificate ge(fun s=>P s \/Q s)target.
Proof.
 intros ge P Q middle target[PP PC][QP QC]QM;split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[next[STEP PN]]]].
     * subst s;destruct(QP middle QM)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
     * right;eauto.
   + destruct(QP s QS)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
 - intros s t next[PS|QS]NF STEP.
   + destruct(classic(s=middle))as[EQ|NE].
     * subst s;right;eapply QC;eauto.
     * left;eapply PC;eauto.
   + right;eapply QC;eauto.
Qed.

Lemma prepend_transition:forall ge initial middle P target,
 unique_transition ge initial middle ->certificate ge P target ->P middle ->
 exists Q,certificate ge Q target /\Q initial.
Proof.
 intros ge initial middle P target TRANS CERT PI.
 exists(fun s=>s=initial \/P s);split;[|auto].
 eapply chain_certificate with(P:=fun s=>s=initial)(middle:=initial)(initial:=middle);
 [apply singleton_certificate|exact CERT|exact TRANS|exact PI].
Qed.

Lemma normal_block_certificate:forall ge f e k m st mf,
 block_stmt st=true ->Cstrategy.exec_stmt ge e m st E0 mf Out_normal ->
 exists P,certificate ge P(State f Sskip k e mf) /\P(State f st k e m).
Proof.
 intros ge f e k m st mf SYN EXEC.
 exists(block_context_invariant ge k f e mf);split.
 - split;[apply block_context_progress|apply block_context_all_successors].
 - eapply block_context_entry;[exact SYN|eapply normal_statement_path;exact EXEC].
Qed.

Lemma single_deref:forall ge m b x,
 Mem.load Mfloat32 m b 0=Some(Vsingle x) ->
 Cexec.do_deref_loc ge quiet_world tfloat m b Ptrofs.zero Full=
 Some(quiet_world,E0,Vsingle x).
Proof.
 intros ge m b x LOAD;apply Cexec.do_deref_loc_complete;[|constructor].
 eapply deref_loc_value;[reflexivity|reflexivity|].
 unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;
 [exact LOAD|change(0+4<=18446744073709551616)%Z;lia].
Qed.

Lemma single_assign:forall ge m b x mf,
 Mem.store Mfloat32 m b 0(Vsingle x)=Some mf ->
 Cexec.do_assign_loc ge quiet_world tfloat m b Ptrofs.zero Full(Vsingle x)=
 Some(quiet_world,E0,mf,Vsingle x).
Proof.
 intros ge m b x mf STORE;apply Cexec.do_assign_loc_complete;[|constructor].
 eapply assign_loc_value;[reflexivity|reflexivity|].
 unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;
 [exact STORE|change(0+4<=18446744073709551616)%Z;lia].
Qed.
Print Assumptions join_certificate.

Lemma sequence_certificate:forall ge f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid) ->
 P(State f first(Kseq second k)e m) ->
 certificate ge Q target ->Q(State f second k e mid) ->
 exists R,certificate ge R target /\R(State f(Ssequence first second)k e m).
Proof.
 intros ge f e k m mid first second P Q target CP PI CQ QI.
 pose proof(chain_certificate ge P Q _ _ target CP CQ
 (skip_sequence_transition ge f second k e mid)QI)as JOIN.
 eapply prepend_transition;[apply sequence_transition|exact JOIN|left;exact PI].
Qed.
