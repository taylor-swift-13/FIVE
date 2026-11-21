From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail.
Import ListNotations.
Open Scope Z_scope.
From PidPositionSafety Require Import PureSound FalseAndIf.
From FiveGuidanceAllOrder Require Import PureDenotation PhaseComposition.
Theorem original_force_false_certificate:forall e m bp k,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 Mem.load Mint8unsigned m bp 44=Some(Vint Int.zero) ->
 exists P,certificate ge P(State S.f_guidance_pid_h_run Sskip k e m)/\
 P(State S.f_guidance_pid_h_run CoreTail.force_statement k e m).
Proof.
 intros e m bp k NP SP APPROX.
 assert(LV:eval_simple_lvalue ge e m
 (Efield(Evalof(Evar S._guidance_pid(Tstruct S._GuidancePID noattr))(Tstruct S._GuidancePID noattr))S._approx_force_by_thrust tbool)
 bp(Ptrofs.add Ptrofs.zero(Ptrofs.repr 44))Full).
 { core_lv I I I NP I I SP I I I I I I. }
 assert(RV:eval_simple_rvalue ge e m
 (Evalof(Efield(Evalof(Evar S._guidance_pid(Tstruct S._GuidancePID noattr))(Tstruct S._GuidancePID noattr))S._approx_force_by_thrust tbool)tbool)(Vint Int.zero)).
 { eapply read_scalar with(chunk:=Mbool);[exact LV|reflexivity|reflexivity|reflexivity|].
   change(Mem.load Mbool m bp 44=Some(Vint Int.zero));rewrite Mem.load_bool_int8_unsigned,APPROX;reflexivity. }
 pose proof(proj1(simple_big_denotation ge e m)_ _(RV)eq_refl)as PV.
 let st:=eval cbv beta iota zeta delta[CoreTail.force_statement top_statement S.f_guidance_pid_h_run fn_body]in CoreTail.force_statement in
 lazymatch st with Sifthenelse(Eseqand ?l ?r _) ?yes Sskip=>
 exists(FalseAndIf.invariant ge S.f_guidance_pid_h_run e k m l r yes Sskip(Vint Int.zero));
 split;[exact(FalseAndIf.false_and_if_certificate ge S.f_guidance_pid_h_run e k m l r yes Sskip
 (Vint Int.zero)eq_refl PV eq_refl)|apply FalseAndIf.initial_member]
 end.
Qed.
Print Assumptions original_force_false_certificate.
