From Stdlib Require Import List.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import BlockExecution PhaseComposition ConcretePhases StandaloneCallShell FactorShell.
From FiveGuidanceCbmcAdapters Require Import CallScope.
Import ListNotations.
Theorem guarded_phase_chain_certificate:forall ge f e blocks m mf,
 phase_chain ge f e blocks m mf ->forall leaf norm branch k tail,
 exists P,certificate ge P(State f tail k e mf) /\P(State f(phase_sequence blocks tail)k e m) /\
 forall s,P s->helper_call_ok leaf norm branch s.
Proof.
 intros ge f e blocks m mf CHAIN;induction CHAIN;intros leaf norm branch k tail.
 - exists(fun s=>s=State f tail k e m);split;[apply singleton_certificate|].
   split;[reflexivity|];intros s EQ;subst;apply state_call_ok.
 - destruct(IHCHAIN leaf norm branch k tail)as[REST[CERTREST[INITREST SAFEREST]]].
   set(base:=Kseq(phase_sequence rest tail)k).
   set(BLOCK:=block_context_invariant ge base f e ma).
   assert(CERTBLOCK:certificate ge BLOCK(State f Sskip base e ma)).
   { split;[apply block_context_progress|apply block_context_all_successors]. }
   assert(INITBLOCK:BLOCK(State f st base e m)).
   { eapply block_context_entry;[exact H|exact H0]. }
   pose proof(chain_certificate ge BLOCK REST(State f Sskip base e ma)
   (State f(phase_sequence rest tail)k e ma)(State f tail k e mf)
   CERTBLOCK CERTREST(skip_sequence_transition ge f _ k e ma)INITREST)as TAILCERT.
   exists(fun s=>s=State f(Ssequence st(phase_sequence rest tail))k e m \/BLOCK s \/REST s);split.
   + eapply chain_certificate;[apply singleton_certificate|exact TAILCERT|apply sequence_transition|left;exact INITBLOCK].
   + split;[left;reflexivity|]. intros s[EQ|[BL|RS]].
     * subst;apply state_call_ok.
     * eapply block_context_call_ok;exact BL.
     * apply SAFEREST;exact RS.
Qed.
Theorem guarded_speed_prefix_certificate:forall e f m mi mf,
 (forall tail out final,Cstrategy.exec_stmt Speed.ge e mi tail E0 final out ->Cstrategy.exec_stmt Speed.ge e m(Speed.integration_context tail)E0 final out) ->
 (forall tail out final,Cstrategy.exec_stmt Speed.ge e mf tail E0 final out ->Cstrategy.exec_stmt Speed.ge e mi(Speed.raw_context tail)E0 final out) ->
 forall leaf norm branch k tail,exists P,certificate Speed.ge P(State f tail k e mf) /\
 P(State f(phase_sequence speed_blocks tail)k e m) /\forall s,P s->helper_call_ok leaf norm branch s.
Proof.
 intros e f m mi mf INTEGRATE RAW leaf norm branch k tail;apply guarded_phase_chain_certificate.
 eapply execution_phase_chain;[apply speed_blocks_syntax|].
 change(Cstrategy.exec_stmt Speed.ge e m(Speed.integration_context(Speed.raw_context Sskip))E0 mf Out_normal).
 apply INTEGRATE;apply RAW;constructor.
Qed.
Theorem guarded_accel_prefix_certificate:forall e f m mf,
 (forall tail out final,Cstrategy.exec_stmt Accel.ge e mf tail E0 final out ->Cstrategy.exec_stmt Accel.ge e m(Accel.integration_context tail)E0 final out) ->
 forall leaf norm branch k tail,exists P,certificate Accel.ge P(State f tail k e mf) /\
 P(State f(phase_sequence accel_blocks tail)k e m) /\forall s,P s->helper_call_ok leaf norm branch s.
Proof.
 intros e f m mf INTEGRATE leaf norm branch k tail;apply guarded_phase_chain_certificate.
 eapply execution_phase_chain;[apply accel_blocks_syntax|].
 change(Cstrategy.exec_stmt Accel.ge e m(Accel.integration_context Sskip)E0 mf Out_normal).
 apply INTEGRATE;constructor.
Qed.

Theorem guarded_speed_saturation_call_certificate:forall e m ba f k mf P norm branch,
 e!SS._gh_saturate_accel=None ->e!SS._accel_sp=Some(ba,Speed.vt) ->
 certificate Speed.ge P(Returnstate Vundef(Kcall f e(fun x=>x)tvoid(Kdo k))mf) ->
 P(Callstate(Internal SS.f_gh_saturate_accel)[Vptr ba Ptrofs.zero](Kcall f e(fun x=>x)tvoid(Kdo k))m) ->
 (forall s,P s->helper_call_ok SS.f_five_sqrtf norm branch s) ->
 exists Q,certificate Speed.ge Q(State f Sskip k e mf) /\Q(State f Speed.saturation_call k e m) /\
 forall s,Q s->helper_call_ok SS.f_five_sqrtf norm branch s.
Proof.
 intros e m ba f k mf P norm branch EH LA CERT PI SAFE.
 exists(StandaloneCallShell.invariant e f k
  SS._gh_saturate_accel SS._accel_sp Speed.saturation_block ba Speed.vt m Vundef mf P);split.
 - eapply call_certificate;eauto using Speed.saturation_symbol,Speed.saturation_funct;reflexivity.
 - split;[apply initial_certificate|].
   intros s[START|[PRE|[CALLEE|[POST|DONE]]]].
   + subst;apply state_call_ok.
   + destruct PRE as[rs[ns EQ]];subst;apply expr_call_ok.
   + apply SAFE;exact CALLEE.
   + subst;apply expr_call_ok.
   + subst;apply state_call_ok.
Qed.

Theorem guarded_accel_saturation_call_certificate:forall e m ba f k mf P norm branch,
 e!AS._gh_saturate_accel=None ->e!AS._accel_sp=Some(ba,Accel.vt) ->
 certificate Accel.ge P(Returnstate Vundef(Kcall f e(fun x=>x)tvoid(Kdo k))mf) ->
 P(Callstate(Internal AS.f_gh_saturate_accel)[Vptr ba Ptrofs.zero](Kcall f e(fun x=>x)tvoid(Kdo k))m) ->
 (forall s,P s->helper_call_ok AS.f_five_sqrtf norm branch s) ->
 exists Q,certificate Accel.ge Q(State f Sskip k e mf) /\Q(State f Accel.saturation_call k e m) /\
 forall s,Q s->helper_call_ok AS.f_five_sqrtf norm branch s.
Proof.
 intros e m ba f k mf P norm branch EH LA CERT PI SAFE.
 exists(StandaloneCallShell.invariant e f k
  AS._gh_saturate_accel AS._accel_sp Accel.saturation_block ba Accel.vt m Vundef mf P);split.
 - eapply call_certificate;eauto using Accel.saturation_symbol,Accel.saturation_funct;reflexivity.
 - split;[apply initial_certificate|].
   intros s[START|[PRE|[CALLEE|[POST|DONE]]]].
   + subst;apply state_call_ok.
   + destruct PRE as[rs[ns EQ]];subst;apply expr_call_ok.
   + apply SAFE;exact CALLEE.
   + subst;apply expr_call_ok.
   + subst;apply state_call_ok.
Qed.
