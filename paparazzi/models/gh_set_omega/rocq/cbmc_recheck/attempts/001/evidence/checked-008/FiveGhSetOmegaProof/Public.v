From Stdlib Require Import List.
From compcert Require Import Values Memory Globalenvs Floats Ctypes Csem.
From FiveGhSetOmega Require Import Source Execution.
From FivePaparazziState Require Import State Layout.
Import ListNotations.
Definition caller_precondition(args:list val)(m:mem):Prop :=
 exists s o b,args=[Vsingle o] /\ Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref=Some b /\ repr s m b /\ writable m b.
Lemma caller_precondition_satisfiable : exists args m,caller_precondition args m.
Proof.
 destruct concrete_initialized_state as[m[R W]].
 exists [Vsingle Float32.zero],m.
 exists zero_state,Float32.zero,shared_block;split;[reflexivity|]. split;[exact omega_symbol|]. split;assumption.
Qed.
Print Assumptions caller_precondition_satisfiable.
