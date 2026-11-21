From Stdlib Require Import List ZArith Lia Classical_Prop.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigCBMC Require Import GlobalMemory.
Import ListNotations.
Local Open Scope Z_scope.
Lemma stuck_error:forall ge,source_error ge Stuckstate.
Proof. intros;split;[intros[v[m H]];discriminate|intros t next[E|E];inversion E]. Qed.
Lemma no_error_reachable_stuck_step:forall ge initial prefix s t,
 no_error ge initial ->star Csem.step ge initial prefix s ->Csem.step ge s t Stuckstate ->False.
Proof.
 intros ge initial prefix s t SAFE PATH STEP.
 apply(SAFE(prefix**t)Stuckstate);[eapply star_trans;[exact PATH|apply star_one;exact STEP|reflexivity]|apply stuck_error].
Qed.
(** Actual attempted operations, including those whose load/store would fail:
    no successful-access or expected-result premise is used here. *)
Theorem every_reachable_attempt_safe:forall ge initial prefix f k e m K C a w,
 no_error ge initial ->star Csem.step ge initial prefix(ExprState f(C a)k e m) ->
 silent_state ge(ExprState f(C a)k e m) ->context K RV C ->
 Cexec.imm_safe_t ge e w K a m.
Proof.
 intros ge initial prefix f k e m K C a w SAFE PATH SIL CT.
 apply NNPP;intro BAD.
 destruct(@Cexec.not_imm_safe_t ge e w K C a m f k CT BAD)as[ST|CR].
 - eapply no_error_reachable_stuck_step;eauto.
 - destruct CR as[t[next[STEP IMP]]]. specialize(SIL _ _ STEP);subst t.
   apply(IMP w);constructor.
Qed.
Lemma loadv_unwrap:forall ch m b ofs v,Mem.loadv ch m(Vptr b ofs)=Some v ->Mem.load ch m b(Ptrofs.unsigned ofs)=Some v.
Proof. intros;cbn[Mem.loadv]in H;repeat match type of H with context[if ?c then _ else _]=>destruct c;try discriminate H end;exact H. Qed.
Lemma storev_unwrap:forall ch m b ofs v mf,Mem.storev ch m(Vptr b ofs)v=Some mf ->Mem.store ch m b(Ptrofs.unsigned ofs)v=Some mf.
Proof. intros;cbn[Mem.storev]in H;repeat match type of H with context[if ?c then _ else _]=>destruct c;try discriminate H end;exact H. Qed.
Lemma deref_value_load:forall ge ty ch m b ofs t v,
 access_mode ty=By_value ch ->type_is_volatile ty=false ->
 deref_loc ge ty m b ofs Full t v ->Mem.load ch m b(Ptrofs.unsigned ofs)=Some v.
Proof. intros ge ty ch m b ofs t v MODE NV D;inversion D;subst;try congruence;match goal with LOAD:Mem.loadv ?chunk _ _=Some _|-_=>assert(E:chunk=ch)by congruence;subst chunk;eapply loadv_unwrap;exact LOAD end. Qed.
Theorem every_reachable_load:forall ge initial prefix f k e m C b ofs ty ch,
 no_error ge initial ->star Csem.step ge initial prefix(ExprState f(C(Evalof(Eloc b ofs Full ty)ty))k e m) ->
 silent_state ge(ExprState f(C(Evalof(Eloc b ofs Full ty)ty))k e m) ->context RV RV C ->
 access_mode ty=By_value ch ->type_is_volatile ty=false ->
 exists v,Mem.load ch m b(Ptrofs.unsigned ofs)=Some v.
Proof.
 intros ge initial prefix f k e m C b ofs ty ch SAFE PATH SIL CT MODE NV.
 pose proof(every_reachable_attempt_safe ge initial prefix f k e m RV C _
  (World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))SAFE PATH SIL CT)as I.
 apply Cexec.imm_safe_t_inv in I;cbn[Cexec.invert_expr_prop]in I.
 destruct I as[_[t[v[w'[D PT]]]]];exists v;eapply deref_value_load;eauto.
Qed.
Theorem every_reachable_assignop_load:forall ge initial prefix f k e m C op b ofs ty v ty2 tyres ch,
 no_error ge initial ->star Csem.step ge initial prefix(ExprState f(C(Eassignop op(Eloc b ofs Full ty)(Eval v ty2)tyres ty))k e m) ->
 silent_state ge(ExprState f(C(Eassignop op(Eloc b ofs Full ty)(Eval v ty2)tyres ty))k e m) ->context RV RV C ->
 access_mode ty=By_value ch ->type_is_volatile ty=false ->
 exists old,Mem.load ch m b(Ptrofs.unsigned ofs)=Some old.
Proof.
 intros ge initial prefix f k e m C op b ofs ty v ty2 tyres ch SAFE PATH SIL CT MODE NV.
 pose proof(every_reachable_attempt_safe ge initial prefix f k e m RV C _
  (World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))SAFE PATH SIL CT)as I.
 apply Cexec.imm_safe_t_inv in I;cbn[Cexec.invert_expr_prop]in I.
 destruct I as[t[old[w'[_[D PT]]]]];exists old;eapply deref_value_load;eauto.
Qed.
Theorem every_reachable_postincrement_load:forall ge initial prefix f k e m C id b ofs ty ch,
 no_error ge initial ->star Csem.step ge initial prefix(ExprState f(C(Epostincr id(Eloc b ofs Full ty)ty))k e m) ->
 silent_state ge(ExprState f(C(Epostincr id(Eloc b ofs Full ty)ty))k e m) ->context RV RV C ->
 access_mode ty=By_value ch ->type_is_volatile ty=false ->
 exists old,Mem.load ch m b(Ptrofs.unsigned ofs)=Some old.
Proof.
 intros ge initial prefix f k e m C id b ofs ty ch SAFE PATH SIL CT MODE NV.
 pose proof(every_reachable_attempt_safe ge initial prefix f k e m RV C _
  (World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))SAFE PATH SIL CT)as I.
 apply Cexec.imm_safe_t_inv in I;cbn[Cexec.invert_expr_prop]in I.
 destruct I as[t[old[w'[_[D PT]]]]];exists old;eapply deref_value_load;eauto.
Qed.
Theorem every_reachable_store:forall ge initial prefix f k e m C b ofs ty v ty2 ch,
 no_error ge initial ->star Csem.step ge initial prefix(ExprState f(C(Eassign(Eloc b ofs Full ty)(Eval v ty2)ty))k e m) ->
 silent_state ge(ExprState f(C(Eassign(Eloc b ofs Full ty)(Eval v ty2)ty))k e m) ->context RV RV C ->
 access_mode ty=By_value ch ->type_is_volatile ty=false ->
 exists cv mf,Mem.store ch m b(Ptrofs.unsigned ofs)cv=Some mf.
Proof.
 intros ge initial prefix f k e m C b ofs ty v ty2 ch SAFE PATH SIL CT MODE NV.
 pose proof(every_reachable_attempt_safe ge initial prefix f k e m RV C _
  (World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None))SAFE PATH SIL CT)as I.
 apply Cexec.imm_safe_t_inv in I;cbn[Cexec.invert_expr_prop]in I.
 destruct I as[cv[mf[v'[t[w'[_[CAST[ASSIGN PT]]]]]]]].
 inversion ASSIGN;subst;try congruence;match goal with STORE:Mem.storev ?chunk _ _ _=Some _|-_=>assert(E:chunk=ch)by congruence;subst chunk;do 2 eexists;eapply storev_unwrap;exact STORE end.
Qed.
Theorem every_reachable_global_load_in_bounds:forall ge initial prefix f k e m C b ofs ty ch size,
 no_error ge initial ->global_state b size initial ->
 star Csem.step ge initial prefix(ExprState f(C(Evalof(Eloc b ofs Full ty)ty))k e m) ->
 silent_state ge(ExprState f(C(Evalof(Eloc b ofs Full ty)ty))k e m) ->context RV RV C ->
 access_mode ty=By_value ch ->type_is_volatile ty=false ->0<=Ptrofs.unsigned ofs<size.
Proof.
 intros ge initial prefix f k e m C b ofs ty ch size SAFE BOUND PATH SIL CT MODE NV.
 destruct(every_reachable_load ge initial prefix f k e m C b ofs ty ch SAFE PATH SIL CT MODE NV)as[v LOAD].
 eapply global_load_range;[|exact LOAD].
 exact(global_bounds_reachable ge initial b size prefix _ BOUND PATH).
Qed.
Theorem every_reachable_global_store_in_bounds:forall ge initial prefix f k e m C b ofs ty v ty2 ch size,
 no_error ge initial ->global_state b size initial ->
 star Csem.step ge initial prefix(ExprState f(C(Eassign(Eloc b ofs Full ty)(Eval v ty2)ty))k e m) ->
 silent_state ge(ExprState f(C(Eassign(Eloc b ofs Full ty)(Eval v ty2)ty))k e m) ->context RV RV C ->
 access_mode ty=By_value ch ->type_is_volatile ty=false ->0<=Ptrofs.unsigned ofs<size.
Proof.
 intros ge initial prefix f k e m C b ofs ty v ty2 ch size SAFE BOUND PATH SIL CT MODE NV.
 destruct(every_reachable_store ge initial prefix f k e m C b ofs ty v ty2 ch SAFE PATH SIL CT MODE NV)as[cv[mf STORE]].
 eapply global_store_range;[|exact STORE].
 exact(global_bounds_reachable ge initial b size prefix _ BOUND PATH).
Qed.
Print Assumptions every_reachable_attempt_safe.
Print Assumptions every_reachable_global_load_in_bounds.
Print Assumptions every_reachable_global_store_in_bounds.
