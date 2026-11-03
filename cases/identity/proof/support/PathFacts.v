From Coq Require Import Lia.
From compcert Require Import Events Csem Smallstep.

(* Every constructor records both an actual edge and its exhaustive inverse.
   This is a finite certificate for the whole nondeterministic step relation. *)
Inductive certified_path (ge: Csem.genv) : Csem.state -> Csem.state -> nat -> Prop :=
| cp_done : forall s,
    (forall t next, Csem.step ge s t next -> False) ->
    certified_path ge s s O
| cp_step : forall s middle finish n,
    Csem.step ge s E0 middle ->
    (forall t next, Csem.step ge s t next -> t = E0 /\ next = middle) ->
    certified_path ge middle finish n ->
    certified_path ge s finish (S n).

Lemma certificate_star :
  forall ge start finish n,
  certified_path ge start finish n ->
  Smallstep.star Csem.step ge start E0 finish.
Proof.
  intros ge start finish n HC.
  induction HC.
  - apply star_refl.
  - eapply star_step; eauto.
Qed.

Lemma certificate_no_forever :
  forall ge start finish n,
  certified_path ge start finish n ->
  forall T, ~ Smallstep.forever Csem.step ge start T.
Proof.
  intros ge start finish n HC.
  induction HC as [s Hnone | s middle finish n Hstep Hunique HC IH];
    intros T Hinf.
  - inversion Hinf; subst; eapply Hnone; eauto.
  - inversion Hinf as [s1 t s2 T1 HD HI]; subst.
    destruct (Hunique _ _ HD) as [HT HE]; subst.
    eapply IH; eauto.
Qed.

Lemma certificate_starN_bounded :
  forall ge start finish N,
  certified_path ge start finish N ->
  forall n t next,
  Smallstep.starN Csem.step ge n start t next ->
  (n <= N)%nat.
Proof.
  intros ge start finish N HC.
  induction HC as [s Hnone | s middle finish N Hstep Hunique HC IH];
    intros n t next HR.
  - inversion HR; subst; try lia.
    exfalso; eapply Hnone; eauto.
  - inversion HR as [s0 | n0 s0 t0 t1 s1 t2 s2 HD HS EQ]; subst; try lia.
    destruct (Hunique _ _ HD) as [HT HE]; subst.
    specialize (IH _ _ _ HS). lia.
Qed.

Lemma certificate_maximal :
  forall ge start finish N,
  certified_path ge start finish N ->
  forall t next,
  Smallstep.star Csem.step ge start t next ->
  Smallstep.nostep Csem.step ge next ->
  next = finish /\ t = E0.
Proof.
  intros ge start finish N HC.
  induction HC as [s Hnone | s middle finish N Hstep Hunique HC IH];
    intros t next HR HN.
  - inversion HR as [s0 | s0 t1 s1 t2 s2 tt HD HS EQ]; subst; auto.
    exfalso; eapply Hnone; eauto.
  - inversion HR as [s0 | s0 t1 s1 t2 s2 tt HD HS EQ]; subst.
    + exfalso; eapply HN; exact Hstep.
    + destruct (Hunique _ _ HD) as [HT HE]; subst.
      simpl. eapply IH; eauto.
Qed.
