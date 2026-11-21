From Stdlib Require Import List Bool.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Csyntax Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution ContinuationLift PhaseComposition.
Definition function_scope(f:function)(s:Csem.state):Prop:=match s with
| State f' _ _ _ _|ExprState f' _ _ _ _=>f'=f
| Callstate fd _ _ _=>fd=Internal f
| _=>True end.
Lemma normal_scope_step:forall ge f s t next,
 normal_state s=true ->function_scope f s ->Csem.step ge s t next ->function_scope f next.
Proof.
 intros ge f s t next NORMAL SCOPE[ES|SS].
 - inversion ES;subst;cbn[function_scope]in*;try exact SCOPE;try exact I.
   exfalso;eapply normal_no_callred;[exact NORMAL|eassumption|reflexivity|eassumption].
 - inversion SS;subst;cbn[function_scope normal_state]in*;try discriminate;try exact SCOPE;try exact I.
   injection SCOPE as FF;subst;reflexivity.
Qed.
Definition tagged_callee_invariant(ge:genv)(f:function)(base:cont)(v:val)(mf:mem)(s:Csem.state):Prop:=
 exists raw,s=plug_state base raw/\execution_invariant ge raw/\state_eval ge raw=Some(v,mf)/\function_scope f raw.
Lemma tagged_callee_entry:forall ge f base initial tw v mf,
 normal_state initial=true ->call_names initial ->function_scope f initial ->
 star Csem.step ge initial tw(Returnstate v Kstop mf) ->
 tagged_callee_invariant ge f base v mf(plug_state base initial).
Proof.
 intros ge f base initial tw v mf NO NA SC PA.
 destruct(callee_invariant_entry ge base initial tw v mf NO NA PA)as[raw[EQ[INV DEN]]].
 pose proof(all_order_normal_correspondence ge initial tw v mf NO PA)as DI.
 exists initial;split;[reflexivity|];split.
 - split;[exact NO|];split;[exact NA|exists(v,mf);exact DI].
 - auto.
Qed.
Lemma tagged_callee_scope:forall ge f base v mf s,
 tagged_callee_invariant ge f base v mf s ->function_scope f s.
Proof.
 intros ge f base v mf s[raw[EQ[INV[DEN SC]]]];subst s;destruct raw;cbn[plug_state function_scope]in*;exact SC.
Qed.
Theorem tagged_callee_progress:forall ge f base v mf s,
 is_call_cont base ->tagged_callee_invariant ge f base v mf s ->
 s=Returnstate v base mf\/exists t next,Csem.step ge s t next/\tagged_callee_invariant ge f base v mf next.
Proof.
 intros ge f base v mf s BASE[raw[EQ[INV[DEN SC]]]];subst s.
 destruct(invariant_progress ge raw INV)as[[vr[mr RET]]|[t[next STEP]]].
 - subst raw;cbn[state_eval]in DEN;inversion DEN;subst;left;reflexivity.
 - right;exists t,(plug_state base next);split.
   + apply plug_normal_step;[exact BASE|exact(proj1 INV)|exact STEP].
   + exists next;split;[reflexivity|];split.
     * eapply invariant_preserved;[exact INV|exact STEP].
     * split;[exact(proj2(normal_step_forward _ _ _ _ _ (proj1 INV)DEN STEP))|].
       eapply normal_scope_step;[exact(proj1 INV)|exact SC|exact STEP].
Qed.
Theorem tagged_callee_successors:forall ge f base v mf s t next,
 is_call_cont base ->tagged_callee_invariant ge f base v mf s ->
 s<>Returnstate v base mf ->Csem.step ge s t next ->
 tagged_callee_invariant ge f base v mf next.
Proof.
 intros ge f base v mf s t next BASE[raw[EQ[INV[DEN SC]]]]NF STEP;subst s.
 assert(NR:~normal_return raw).
 { intros[vr[mr RET]];subst raw;cbn[state_eval]in DEN;inversion DEN;subst;apply NF;reflexivity. }
 destruct(plug_step_inverse ge base raw t next BASE(proj1 INV)NR STEP)as[raw'[EQ STEP']].
 exists raw';split;[exact EQ|];split.
 - eapply invariant_preserved;[exact INV|exact STEP'].
 - split;[exact(proj2(normal_step_forward _ _ _ _ _ (proj1 INV)DEN STEP'))|].
   eapply normal_scope_step;[exact(proj1 INV)|exact SC|exact STEP'].
Qed.
Print Assumptions tagged_callee_successors.
