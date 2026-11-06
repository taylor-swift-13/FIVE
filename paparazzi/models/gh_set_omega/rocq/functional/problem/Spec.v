From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Globalenvs Floats Csem Smallstep.
From FiveGhSetOmega Require Import Source Execution.
From FiveGhSetOmegaProof Require Import Public.
From FivePaparazziState Require Import State.
Import ListNotations.
Definition NormalCompletion:Prop:=forall s o m b,
 Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref=Some b -> repr s m b -> writable m b ->
 exists t mf,star Csem.step FiveGhSetOmega.Execution.ge(FiveGhSetOmega.Execution.entry[Vsingle o]m)t
 (Returnstate(Vsingle(clamp_omega o))Kstop mf) /\ repr(set_omega s o)mf b /\ writable mf b.
Definition AllReturnSpec:Prop:=forall s o m b t v mf,
 Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref=Some b -> repr s m b -> writable m b ->
 star Csem.step FiveGhSetOmega.Execution.ge(FiveGhSetOmega.Execution.entry[Vsingle o]m)t(Returnstate v Kstop mf) ->
 v=Vsingle(clamp_omega o) /\ repr(set_omega s o)mf b /\ writable mf b.
