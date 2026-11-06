From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Globalenvs Floats Csem Smallstep.
From FiveGhSetZeta Require Import Source Execution.
From FiveGhSetZetaProof Require Import Public.
From FivePaparazziState Require Import State.
Import ListNotations.
Definition NormalCompletion:Prop:=forall s o m b,
 Genv.find_symbol FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists t mf,star Csem.step FiveGhSetZeta.Execution.ge(FiveGhSetZeta.Execution.entry[Vsingle o]m)t
 (Returnstate(Vsingle(clamp_zeta o))Kstop mf) /\ repr(set_zeta s o)mf b /\ writable mf b.
Definition AllReturnSpec:Prop:=forall s o m b t v mf,
 Genv.find_symbol FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._gh_ref=Some b -> repr s m b -> writable m b ->
 star Csem.step FiveGhSetZeta.Execution.ge(FiveGhSetZeta.Execution.entry[Vsingle o]m)t(Returnstate v Kstop mf) ->
 v=Vsingle(clamp_zeta o) /\ repr(set_zeta s o)mf b /\ writable mf b.
