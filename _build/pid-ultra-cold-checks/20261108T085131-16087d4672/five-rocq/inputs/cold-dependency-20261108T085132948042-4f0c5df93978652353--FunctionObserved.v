From Stdlib Require Import List Bool.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Ctypes Csyntax Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From PidPositionSafety Require Import FunctionPhases.
From CoreCBMC Require Import ArithmeticPhases.
Theorem observed_allocated_void_call_certificate:forall ge f args m e ma mb bodym mf Observe,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f)) ->
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e ma ->
 bind_parameters ge e ma(fn_params f)args mb ->
 Mem.free_list bodym(blocks_of_env ge e)=Some mf ->
 (forall k,observed_certificate ge Observe
   (State f(fn_body f)k e mb)(State f(Sreturn None)k e bodym)) ->
 (forall k,Observe(Callstate(Internal f)args k m)) ->
 (forall k,Observe(State f(Sreturn None)k e bodym)) ->
 (forall k,Observe(Returnstate Vundef k mf)) ->
 forall k,is_call_cont k ->observed_certificate ge Observe
 (Callstate(Internal f)args k m)(Returnstate Vundef k mf).
Proof.
 intros ge f args m e ma mb bodym mf Observe NAMES AV BIND FREE BODY OC OS OR k BASE.
 eapply observed_prepend with(middle:=State f(fn_body f)k e mb);[exact(internal_dispatch_transition ge f args m e ma mb k NAMES AV BIND)|apply OC|].
 eapply observed_join with(middle:=State f(Sreturn None)k e bodym);[exact(BODY k)|].
 eapply observed_prepend with(middle:=Returnstate Vundef k mf);[exact(return_void_transition ge f k e bodym mf BASE FREE)|apply OS|].
 apply observed_singleton;apply OR.
Qed.
Print Assumptions observed_allocated_void_call_certificate.
