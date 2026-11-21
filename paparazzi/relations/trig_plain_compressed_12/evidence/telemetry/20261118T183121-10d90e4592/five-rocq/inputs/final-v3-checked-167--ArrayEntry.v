From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Ctypesdefs Csyntax Csem Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import ClosedCalls.
From PprzTrigCBMC Require Import ArrayBases ArrayOrigins ArrayContexts ArrayState ArrayMachine ArrayOwners NoShadow.
Import ListNotations.
Local Open Scope Z_scope.
Lemma low_array_start:forall f ids args m,ArrayOwners.low_array_owner f ids->
 ArrayState.array_state PprzTrigLow.Execution.ge tuchar ArrayOwners.low_array_owner(Callstate(Internal f)args Kstop m).
Proof. intros;split;[exists f,ids;auto| ]. split;[exact I|exists ids;exact I]. Qed.
Lemma plain_array_start:forall f ids args m,ArrayOwners.plain_array_owner f ids->
 ArrayState.array_state PprzTrigPlain.Execution.ge tshort ArrayOwners.plain_array_owner(Callstate(Internal f)args Kstop m).
Proof. intros;split;[exists f,ids;auto| ]. split;[exact I|exists ids;exact I]. Qed.
Theorem low_reachable_array_origins:forall args m prefix s,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s->
 ArrayState.array_state PprzTrigLow.Execution.ge tuchar ArrayOwners.low_array_owner s.
Proof.
 intros args m prefix s PATH.
 eapply(@ArrayMachine.original_array_every_prefix PprzTrigLow.Execution.ge tuchar ArrayOwners.low_array_owner
 ClosedCalls.actual_allowed ClosedCalls.direct_ids ArrayOwners.low_allowed_owned ArrayOwners.low_array_bodies
 ArrayOwners.low_array_locals ClosedCalls.actual_step_closed (PprzTrigLow.Execution.entry args m)prefix s).
 - apply ClosedCalls.allowed_start_closed;unfold ClosedCalls.actual_allowed,ClosedCalls.internal_functions;cbn;auto 12.
 - apply(low_array_start _ []args m);constructor.
 - exact PATH.
Qed.
Theorem init_reachable_array_origins:forall args m prefix s,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix s->
 ArrayState.array_state PprzTrigInit.Execution.ge tuchar ArrayOwners.low_array_owner s.
Proof.
 intros args m prefix s PATH.
 change(star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal PprzTrigLow.Source.f_pprz_trig_int_init)args Kstop m)prefix s)in PATH.
 eapply(@ArrayMachine.original_array_every_prefix PprzTrigLow.Execution.ge tuchar ArrayOwners.low_array_owner
 ClosedCalls.actual_allowed ClosedCalls.direct_ids ArrayOwners.low_allowed_owned ArrayOwners.low_array_bodies
 ArrayOwners.low_array_locals ClosedCalls.actual_step_closed (Callstate(Internal PprzTrigLow.Source.f_pprz_trig_int_init)args Kstop m)prefix s).
 - apply ClosedCalls.allowed_start_closed;unfold ClosedCalls.actual_allowed,ClosedCalls.internal_functions;cbn;auto 12.
 - apply(low_array_start _ []args m);constructor.
 - exact PATH.
Qed.
Theorem plain_reachable_array_origins:forall args m prefix s,
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry args m)prefix s->
 ArrayState.array_state PprzTrigPlain.Execution.ge tshort ArrayOwners.plain_array_owner s.
Proof.
 intros args m prefix s PATH.
 eapply(@ArrayMachine.original_array_every_prefix PprzTrigPlain.Execution.ge tshort ArrayOwners.plain_array_owner
 NoShadow.plain_allowed NoShadow.array_names ArrayOwners.plain_allowed_owned ArrayOwners.plain_array_bodies
 ArrayOwners.plain_array_locals NoShadow.plain_protected_step (PprzTrigPlain.Execution.entry args m)prefix s).
 - apply(@NoShadow.plain_all_reachable_protected args m E0 _);constructor.
 - apply(plain_array_start _ plain_descriptor args m);split;reflexivity.
 - exact PATH.
Qed.
Print Assumptions init_reachable_array_origins.
Print Assumptions plain_reachable_array_origins.


