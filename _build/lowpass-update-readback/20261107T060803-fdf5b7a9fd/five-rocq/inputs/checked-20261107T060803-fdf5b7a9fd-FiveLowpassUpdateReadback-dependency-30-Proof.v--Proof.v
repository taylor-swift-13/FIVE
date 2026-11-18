From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassUpdateReadback Require Import Spec.
From FiveLowpassSupport Require Import LowpassMemory.
Require FiveLowpassUpdateFunctional.Proof FiveLowpassGetFunctional.Proof FiveLowpassGetCase.Contract FiveLowpassUpdateCase.Contract.
Module Spec:=FiveLowpassUpdateReadback.Spec.
Module U:=FiveLowpassUpdateCase.Contract.
Module G:=FiveLowpassGetCase.Contract.
Import ListNotations.
Local Open Scope Z_scope.
Lemma update_establishes_readable:forall m b p tc li lo,
 U.Initialized m b p tc li lo->G.ReadableOut m b p lo.
Proof. intros m b p tc li lo [[AL[NW W]][TC[LI LO]]];repeat split;auto. Qed.
Lemma observations:forall m mu mf b p tc li lo input,
 U.Initialized m b p tc li lo->U.Post m mu b p tc li lo input->G.Frame mu mf->
 Spec.Observations m mu mf b p input(Vsingle(U.output tc li lo input)).
Proof.
 intros m mu mf b p tc li lo input INIT [POST[BIN[BOUT UF]]] GF.
 pose proof(U.initialized_valid m b p tc li lo INIT)as VM.
 pose proof(U.initialized_valid mu b p tc input(U.output tc li lo input)POST)as VU.
 assert(TC:Mem.loadbytes mu b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4)by(apply UF;[exact VM|right;left;lia]).
 unfold Spec.Observations;split;[exact TC|]. split;[rewrite GF by exact VU;exact TC|].
 split;[exact BIN|]. split;[rewrite GF by exact VU;exact BIN|].
 split;[exact BOUT|]. split;[rewrite GF by exact VU;exact BOUT|]. split;assumption.
Qed.
Theorem normal_completion:Spec.NormalCompletion.
Proof.
 unfold Spec.NormalCompletion;intros m b p tc li lo input P.
 destruct(FiveLowpassUpdateFunctional.Proof.normal_completion m b p tc li lo input P)as[tu[mu[UPDATE POST]]].
 pose proof(update_establishes_readable mu b p tc input(U.output tc li lo input)(proj1 POST))as R.
 destruct(FiveLowpassGetFunctional.Proof.normal_completion mu b p(U.output tc li lo input)R)as[tg[mf[GET[READ GF]]]].
 exists tu,mu,tg,mf;split;[exact UPDATE|]. split;[exact GET|]. eapply observations;eauto.
Qed.
Theorem all_returns:Spec.AllReturns.
Proof.
 unfold Spec.AllReturns;intros m b p tc li lo input P tu r mu tg y mf UPDATE GET.
 destruct(FiveLowpassUpdateFunctional.Proof.all_returns m b p tc li lo input P tu r mu UPDATE)as[RR POST].
 pose proof(update_establishes_readable mu b p tc input(U.output tc li lo input)(proj1 POST))as R.
 destruct(FiveLowpassGetFunctional.Proof.all_returns mu b p(U.output tc li lo input)R tg y mf GET)as[YY[READ GF]].
 subst r y;split;[reflexivity|]. split;[reflexivity|]. split;[reflexivity|]. eapply observations;eauto.
Qed.
Print Assumptions normal_completion.
Print Assumptions all_returns.
