From Stdlib Require Import List.
From compcert Require Import Values Memory Floats Globalenvs Csem Smallstep.
From FivePaparazziState Require Import State.
Require FiveGhSetOmega.Source FiveGhSetOmega.Execution.
Require FiveGhSetZeta.Source FiveGhSetZeta.Execution.
Import ListNotations.

Definition Returns (ge : Csem.genv) (entry : list val -> mem -> Csem.state)
 (args : list val) (before : mem) (value : val) (after : mem) : Prop :=
 exists t, star Csem.step ge (entry args before) t (Returnstate value Kstop after).
Definition omega_call (o : float32) (m : mem) (v : val) (mf : mem) : Prop :=
 Returns FiveGhSetOmega.Execution.ge FiveGhSetOmega.Execution.entry [Vsingle o] m v mf.
Definition zeta_call (z : float32) (m : mem) (v : val) (mf : mem) : Prop :=
 Returns FiveGhSetZeta.Execution.ge FiveGhSetZeta.Execution.entry [Vsingle z] m v mf.
Definition initial (s : State.state) (m : mem) (b : block) : Prop :=
 State.repr s m b /\ State.writable m b /\
Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref=Some b /\
Genv.find_symbol FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._gh_ref=Some b.
Definition omega_then_zeta (o z : float32) (before after : mem) : Prop :=
 exists mid vo vz, omega_call o before vo mid /\ zeta_call z mid vz after.
Definition zeta_then_omega (o z : float32) (before after : mem) : Prop :=
 exists mid vz vo, zeta_call z before vz mid /\ omega_call o mid vo after.
Definition final_state (s : State.state) (o z : float32) := State.set_zeta (State.set_omega s o) z.

(** Both concrete call sequences complete; this prevents vacuous equality. *)
Definition NormalCompletion : Prop := forall s o z ma mb ba bb,
 initial s ma ba -> initial s mb bb ->
 exists fa fb,
 omega_then_zeta o z ma fa /\ zeta_then_omega o z mb fb /\
State.repr (final_state s o z) fa ba /\ State.repr (final_state s o z) fb bb.

(** Every actual normal pair of Csem call executions has the exact source
 ordered binary32 result and preserves all other fourteen named fields. *)
Definition AllFinalStateFormula : Prop := forall s o z ma mb ba bb fa fb,
 initial s ma ba -> initial s mb bb ->
 omega_then_zeta o z ma fa -> zeta_then_omega o z mb fb ->
 State.repr (final_state s o z) fa ba /\ State.repr (final_state s o z) fb bb.
Definition AllFinalNamedBits : Prop := forall s o z ma mb ba bb fa fb sa sb,
 initial s ma ba -> initial s mb bb ->
 omega_then_zeta o z ma fa -> zeta_then_omega o z mb fb ->
 State.repr sa fa ba -> State.repr sb fb bb -> State.named_bits sa = State.named_bits sb.
Definition SatisfiableInitial : Prop := exists s ma mb ba bb, initial s ma ba /\ initial s mb bb.
