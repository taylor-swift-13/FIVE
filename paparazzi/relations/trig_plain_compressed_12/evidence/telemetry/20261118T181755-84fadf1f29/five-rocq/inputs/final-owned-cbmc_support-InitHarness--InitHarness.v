From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Csyntax Csem Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution PprzTrigLow.Source.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitialMemory InitComplete LowEntry LowClosed LowDecoder MachineData TrigData PackedPrefix.
From PprzTrigCBMC Require Import InitReference SineGuards.
Import ListNotations.
Local Open Scope Z_scope.
Theorem genuine_init_assertion:forall initial,Spec.initial_low initial->
 (exists after,Spec.init_returns initial(Vint Int.zero)after)/\
 (forall v after,Spec.init_returns initial v after->v=Vint Int.zero).
Proof.
 intros initial INIT.
 destruct buffer_symbol_info_exists as[b[SYMBOL VAR]].
 destruct(@InitComplete.initializer_representation_proved initial b INIT SYMBOL)as[EX ALL].
 split;[exact EX|intros v after RUN;exact(proj1(ALL v after RUN))].
Qed.
Theorem init_reference_index_guards:forall i,0<=Int.signed i<6434->
 0<=Int.signed i<Z.of_nat(length init_reference_values)/\Int.sign_ext 16 i=i.
Proof. intros i RANGE;rewrite init_reference_length;split;[exact RANGE|apply LowEntry.short_index;exact RANGE]. Qed.
Theorem initialized_lookup_literal_assertion:forall initial after i,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after->0<=Int.signed i<6434->
 (exists final t,star Csem.step PprzTrigInit.Execution.ge
 (Callstate(Internal PprzTrigInit.Source.f_pprz_trig_int_12)[Vint i]Kstop after)t
 (Returnstate(Vint(Int.repr(nth(Z.to_nat(Int.signed i))init_reference_values 0)))Kstop final))/\
 (forall v final t,star Csem.step PprzTrigInit.Execution.ge
 (Callstate(Internal PprzTrigInit.Source.f_pprz_trig_int_12)[Vint i]Kstop after)t(Returnstate v Kstop final)->
 v=Vint(Int.repr(nth(Z.to_nat(Int.signed i))init_reference_values 0))).
Proof.
 intros initial after i INIT RETURN RANGE.
 destruct buffer_symbol_info_exists as[b[SYMBOL VAR]].
 pose proof(@InitComplete.initialized_packed initial after b INIT SYMBOL RETURN)as PACKED.
 pose proof(@LowClosed.buffer_loads_from_packed after b PACKED)as BYTES.
 destruct(@actual_decoder_return_pc PprzTrigInit.Execution.ge after b i RANGE SYMBOL BYTES)as[EX[ALL REST]].
 rewrite init_reference_at.
 rewrite<-(proj1(machine_lookup_signed i RANGE)).
 split;[exact EX|intros v final t RUN;exact(ALL final v t RUN)].
Qed.
Print Assumptions genuine_init_assertion.
Print Assumptions initialized_lookup_literal_assertion.
