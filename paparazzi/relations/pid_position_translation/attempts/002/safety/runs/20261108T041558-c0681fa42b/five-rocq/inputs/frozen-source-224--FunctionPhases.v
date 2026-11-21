From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Determinism Ctypes Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From PidPositionSafety Require Import ConditionalBlock.
Definition phase_world:world:=World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None).
Lemma allocation_deterministic:forall ge env m vars e1 ma1 e2 ma2,
 alloc_variables ge env m vars e1 ma1 ->alloc_variables ge env m vars e2 ma2 ->e1=e2 /\ma1=ma2.
Proof.
 intros ge env m vars e1 ma1 e2 ma2 A1 A2.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A1)as D1.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A2)as D2.
 rewrite D1 in D2;injection D2;auto.
Qed.
Lemma parameters_deterministic:forall ge e m params args mf1 mf2,
 bind_parameters ge e m params args mf1 ->bind_parameters ge e m params args mf2 ->mf1=mf2.
Proof.
 intros ge e m params args mf1 mf2 B1 B2.
 pose proof(Cexec.sem_bind_parameters_complete ge phase_world e m params args mf1 B1)as D1.
 pose proof(Cexec.sem_bind_parameters_complete ge phase_world e m params args mf2 B2)as D2.
 rewrite D1 in D2;injection D2;auto.
Qed.
Lemma internal_dispatch_transition:forall ge f args m e ma mb k,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f)) ->
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e ma ->
 bind_parameters ge e ma(fn_params f)args mb ->
 unique_transition ge(Callstate(Internal f)args k m)(State f(fn_body f)k e mb).
Proof.
 intros ge f args m e ma mb k NAMES ALLOC BIND;split.
 - right;eapply step_internal_function;[exact NAMES|exact ALLOC|exact BIND].
 - intros t next[ES|SS];[inversion ES|].
   inversion SS;subst;split;[reflexivity|].
   match goal with
   |A:alloc_variables ge empty_env m(fn_params f++fn_vars f)?ee ?mx
    |-State _ _ _ ?ee _=_ =>
     destruct(allocation_deterministic ge empty_env m _ e ma ee mx ALLOC A)as[EE MM];subst ee mx end.
   match goal with
   |B:bind_parameters ge e ma(fn_params f)args ?mx |-State _ _ _ _ ?mx=_=>
    pose proof(parameters_deterministic ge e ma(fn_params f)args mb mx BIND B)as EQ;subst mx;reflexivity end.
Qed.
Lemma return_void_transition:forall ge f k e m mf,
 is_call_cont k ->Mem.free_list m(blocks_of_env ge e)=Some mf ->
 unique_transition ge(State f(Sreturn None)k e m)(Returnstate Vundef k mf).
Proof.
 intros ge f k e m mf CALL FREE.
 assert(CC:call_cont k=k)by(destruct k;cbn in CALL|-*;try contradiction;reflexivity).
 split.
 - pose proof(Csem.step_return_0 ge f k e m mf FREE)as STEP;rewrite CC in STEP;right;exact STEP.
 - intros t next[ES|SS];[inversion ES|inversion SS;subst].
   all:cbn in CALL;try contradiction;repeat match goal with H:_\/_|-_=>destruct H end;try discriminate.
   split;[reflexivity|].
   match goal with F:Mem.free_list _ _=Some ?mx|-_=>rewrite FREE in F;injection F as EQ;subst mx end.
   rewrite CC;reflexivity.
Qed.
Theorem allocated_void_call_certificate:forall ge f args m e ma mb bodym mf,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f)) ->
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e ma ->
 bind_parameters ge e ma(fn_params f)args mb ->
 Mem.free_list bodym(blocks_of_env ge e)=Some mf ->
 (forall k,exists P,certificate ge P(State f(Sreturn None)k e bodym)/\
   P(State f(fn_body f)k e mb)) ->
 forall k,is_call_cont k ->exists Q,certificate ge Q(Returnstate Vundef k mf)/\
 Q(Callstate(Internal f)args k m).
Proof.
 intros ge f args m e ma mb bodym mf NAMES AV BIND FREE BODY k BASE.
 destruct(BODY k)as[P[CP IP]].
 pose proof(return_void_transition ge f k e bodym mf BASE FREE)as CLEAN.
 pose proof(singleton_bridge_certificate ge _ _ CLEAN)as CC.
 pose proof(ConditionalBlock.join_certificate ge P _ _ _ CP CC ltac:(left;reflexivity))as JOIN.
 eapply ConditionalBlock.prepend_transition.
 - exact(internal_dispatch_transition ge f args m e ma mb k NAMES AV BIND).
 - exact JOIN.
 - left;exact IP.
Qed.
Print Assumptions allocated_void_call_certificate.
