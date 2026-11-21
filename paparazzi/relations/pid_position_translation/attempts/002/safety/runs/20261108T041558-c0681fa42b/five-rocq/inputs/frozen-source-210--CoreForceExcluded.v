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
From PidPositionSafety Require Import ForceExcluded.
Theorem original_force_no_do_before_exit:forall e m bp k,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 Mem.load Mint8unsigned m bp 44=Some(Vint Int.zero) ->
 forall t reached,star(phase_step(State S.f_guidance_pid_h_run Sskip k e m))ge
 (State S.f_guidance_pid_h_run force_statement k e m)t reached ->
 forall f' a k' e' m',reached<>State f'(Sdo a)k' e' m'.
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
 intros t reached PATH f' a k' e' m'.
 let st:=eval cbv beta iota zeta delta[CoreTail.force_statement top_statement S.f_guidance_pid_h_run fn_body]in CoreTail.force_statement in
 lazymatch st with Sifthenelse(Eseqand ?l ?r _) ?yes Sskip=>
 exact(false_and_no_do_before_exit ge S.f_guidance_pid_h_run e k m l r yes
 (Vint Int.zero)eq_refl PV eq_refl t reached PATH f' a k' e' m')
 end.
Qed.
Print Assumptions original_force_no_do_before_exit.
