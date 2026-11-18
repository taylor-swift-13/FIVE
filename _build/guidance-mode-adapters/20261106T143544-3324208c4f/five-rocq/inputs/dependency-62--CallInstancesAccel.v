From Stdlib Require Import List.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveGuidanceEntry Require Import AccelPrefix.
From FiveGuidanceAllOrder Require Import PhaseComposition StandaloneCallShell FactorShell.
Import ListNotations.
Theorem saturation_call_certificate:forall e m ba f k mf P,
 e!S._gh_saturate_accel=None ->e!S._accel_sp=Some(ba,vt) ->
 certificate ge P(Returnstate Vundef(Kcall f e(fun x=>x)tvoid(Kdo k))mf) ->
 P(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero](Kcall f e(fun x=>x)tvoid(Kdo k))m) ->
 exists Q,certificate ge Q(State f Sskip k e mf) /\Q(State f saturation_call k e m).
Proof.
 intros e m ba f k mf P EH LA CERT PI.
 exists(StandaloneCallShell.invariant e f k
  S._gh_saturate_accel S._accel_sp saturation_block ba vt m Vundef mf P);split.
 - eapply call_certificate;eauto using saturation_symbol,saturation_funct;reflexivity.
 - apply initial_certificate.
Qed.
Print Assumptions saturation_call_certificate.
