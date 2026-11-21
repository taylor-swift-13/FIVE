From Stdlib Require Import List.
From compcert Require Import Values Memory Events Csem Smallstep.
From PprzTrigRelationSupport Require Import Total.

Theorem total_actual_execution : forall ge Q s,
 Total.total ge Q s ->exists v m t,
 star Csem.step ge s t(Returnstate v Kstop m) /\Q v m.
Proof.
 intros ge Q s T;induction T as[v m POST|s NEXT ALL IH].
 - exists v,m,E0;split;[constructor|exact POST].
 - destruct NEXT as[t[n STEP]]. destruct(IH t n STEP)as[v[m[u[PATH POST]]]].
   exists v,m,(t**u);split;[eapply star_step;eauto|exact POST].
Qed.
