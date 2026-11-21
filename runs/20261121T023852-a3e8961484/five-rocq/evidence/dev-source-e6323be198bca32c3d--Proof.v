From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution PhaseComposition PureIfShell.
From StateSpeedSetterSupport Require Import MemoryFacts.
From StateSpeedGetterSupport Require Import Setup Layout Original Certificates.
From StateSpeedGetterCacheProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Local Opaque ge E.ge.
Module SC:=StateSpeedSetterSupport.Certificates.
Module GC:=StateSpeedGetterSupport.Certificates.
Module GS:=StateSpeedGetterSupport.GetterSource.
Lemma hot_condition:forall m sb q,
 Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint q)->HitWord q->
 pure_rval ge empty_env m getter_condition=Some(Vint Int.zero).
Proof.
 intros m sb q SYM LOAD HOT.
 pose proof(status_value empty_env m sb q eq_refl SYM LOAD)as WORD.
 assert(TEST:pure_rval ge empty_env m(status_test 5)=Some(Vint Int.one)).
 { unfold status_test;eapply pure_binary;[eapply pure_binary;[exact WORD|reflexivity|reflexivity]|reflexivity|].
   cbn[sem_binary_operation sem_and classify_binarith];unfold HitWord in HOT;rewrite HOT;reflexivity. }
 change((match pure_rval ge empty_env m(status_test 5)with Some v=>sem_unary_operation Onotbool v tint m|None=>None end)=Some(Vint Int.zero));rewrite TEST;reflexivity.
Qed.
Lemma hot_certificate:forall m sb,HitInput m sb->exists P,
 certificate ge P(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop m) /\P(E.entry[]m).
Proof.
 intros m sb[SYM[q[LOAD HOT]]].
 set(k:=Kseq getter_return Kstop).
 set(TAIL:=fun s=>normal_state s=true /\call_names s /\state_eval ge s=Some(Vptr sb(Ptrofs.repr 328),m)).
 assert(TC:certificate ge TAIL(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop m))by(apply SC.evaluator_certificate).
 assert(TI:TAIL(State S.f_stateGetSpeedEcef_f getter_return Kstop empty_env m))by(exact(return_state_defined m sb SYM)).
 set(IFINV:=PureIfShell.invariant ge S.f_stateGetSpeedEcef_f empty_env k m getter_condition getter_call Sskip(Vint Int.zero)false).
 assert(IC:certificate ge IFINV(State S.f_stateGetSpeedEcef_f Sskip k empty_env m)).
 { apply PureIfShell.if_certificate;[reflexivity|eapply hot_condition;eauto|reflexivity]. }
 pose proof(chain_certificate ge IFINV TAIL _ _ _ IC TC(SC.skip_seq_unique ge S.f_stateGetSpeedEcef_f getter_return Kstop empty_env m)TI)as CC.
 assert(II:IFINV(State S.f_stateGetSpeedEcef_f getter_first k empty_env m))by(left;reflexivity).
 set(BODY:=fun s=>s=State S.f_stateGetSpeedEcef_f(fn_body S.f_stateGetSpeedEcef_f)Kstop empty_env m \/IFINV s \/TAIL s).
 assert(BC:certificate ge BODY(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop m)).
 { unfold BODY;eapply SC.prepend_certificate;[exact CC|left;exact II|apply SC.sequence_unique]. }
 exists(fun s=>s=E.entry[]m \/BODY s);split.
 - eapply SC.prepend_certificate;[exact BC|left;reflexivity|apply GC.empty_function_unique;reflexivity].
 - left;reflexivity.
Qed.
Theorem proved_safety:SafetyGoal.
Proof.
 intros m sb INPUT;destruct(hot_certificate m sb INPUT)as[P[CERT INIT]].
 assert(STOP:nostep Csem.step ge(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop m)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 intros t reached PATH[NR NS].
 destruct(certificate_no_error ge P _ _ CERT INIT STOP t reached PATH)as[EQ|[tr[next STEP]]].
 - subst reached;apply NR;exists(Vptr sb(Ptrofs.repr 328)),m;reflexivity.
 - exact(NS tr next STEP).
Qed.
Theorem proved_termination:TerminationGoal.
Proof. intros m sb INPUT;apply GS.all_successor_termination. Qed.
Theorem proved_exact_return:ExactReturnGoal.
Proof.
 intros m sb INPUT;destruct(hot_certificate m sb INPUT)as[P[CERT INIT]].
 destruct(SC.certificate_has_return ge P _ _ CERT INIT(GS.all_successor_termination[]m))as[t PATH].
 pose proof(source_path_silent[]m t _ PATH)as SIL;subst t;split;[exact PATH|].
 intros t v mf PATH2;eapply certificate_normal_unique;eauto.
Qed.
Theorem proved_byte_frame:ByteFrameGoal.
Proof.
 intros m sb INPUT t v mf PATH;destruct(proved_exact_return m sb INPUT)as[_ UNIQUE].
 destruct(UNIQUE t v mf PATH)as[RET EQ];subst mf;split;[intros;reflexivity|exact INPUT].
Qed.
Print Assumptions proved_safety.
Print Assumptions proved_termination.
Print Assumptions proved_exact_return.
Print Assumptions proved_byte_frame.
