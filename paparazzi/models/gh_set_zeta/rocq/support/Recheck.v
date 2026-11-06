From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Events Globalenvs Csyntax Csem Smallstep.
From FiveGhSetZeta Require Import Source Execution.
From FiveGhSetZetaProof Require Import Entry BitsUnion.
From FivePaparazziState Require Import State.
Import ListNotations.
Local Open Scope Z_scope.
Definition unrelated_bits(s:state):list val :=
 [Vint(Float32.to_bits(accel_x s));Vint(Float32.to_bits(accel_y s));
 Vint(Float32.to_bits(speed_x s));Vint(Float32.to_bits(speed_y s));
 Vlong(pos_x s);Vlong(pos_y s);Vint(Float32.to_bits(tau s));
 Vint(Float32.to_bits(omega s));Vint(Float32.to_bits(max_speed s));
 Vint(Float32.to_bits(omega_2 s));Vint(Float32.to_bits(inv_tau s));Vint(Float32.to_bits(dt s))].
Theorem returned_bound_bits : forall s z m b t v mf,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 star Csem.step Execution.ge(Execution.entry[Vsingle z]m)t(Returnstate v Kstop mf) ->
 v=Vsingle(clamp_zeta z) /\
 Mem.load Mfloat32 mf b 40=Some(Vsingle(clamp_zeta z)) /\
 UnionObservation(clamp_zeta z)mf.
Proof.
 intros s z m b t v mf SYM REP W PATH.
 destruct(entry_return_spec s z m b t v mf SYM REP W PATH)as[V[R WF]].
 split;[exact V|]. split;[unfold repr,set_zeta in R;simpl in R;tauto|]. apply union_observation.
Qed.
Theorem coefficient_product_bits : forall s z m b t v mf,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 star Csem.step Execution.ge(Execution.entry[Vsingle z]m)t(Returnstate v Kstop mf) ->
 Mem.load Mfloat32 mf b 48=Some(Vsingle(Float32.mul(clamp_zeta z)(omega s))) /\
 UnionObservation(Float32.mul(clamp_zeta z)(omega s))mf.
Proof.
 intros s z m b t v mf SYM REP W PATH.
 destruct(entry_return_spec s z m b t v mf SYM REP W PATH)as[V[R WF]].
 split;[unfold repr,set_zeta in R;simpl in R;tauto|apply union_observation].
Qed.
Theorem unrelated_fields_frame : forall s z m b t v mf,
 Genv.find_symbol Execution.ge Source._gh_ref=Some b -> repr s m b -> writable m b ->
 star Csem.step Execution.ge(Execution.entry[Vsingle z]m)t(Returnstate v Kstop mf) ->
 exists final,repr final mf b /\ unrelated_bits final=unrelated_bits s /\
 (forall x,UnionObservation x mf).
Proof.
 intros s z m b t v mf SYM REP W PATH.
 destruct(entry_return_spec s z m b t v mf SYM REP W PATH)as[V[R WF]].
 exists(set_zeta s z);split;[exact R|]. split;[reflexivity|intros;apply union_observation].
Qed.
Print Assumptions returned_bound_bits.
Print Assumptions coefficient_product_bits.
Print Assumptions unrelated_fields_frame.
