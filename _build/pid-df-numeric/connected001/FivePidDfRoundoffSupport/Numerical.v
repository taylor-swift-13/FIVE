From Stdlib Require Import Reals ZArith Lia Lra Psatz.
From compcert Require Import Floats.
From FivePidDfRoundoffSupport Require Export Sequence.
From FivePidDfRoundoffSupport Require Import Absorption.
Open Scope R_scope.
Lemma abs_bounds:forall a b,Rabs a<=b-> -b<=a<=b.
Proof. intros a b H;unfold Rabs in H;destruct(Rcase_abs a);lra. Qed.

Theorem step_bound:forall a b c y e0 e1 x k,
 Unit a->Unit b->Unit c->Unit e0->Unit e1->Unit x->
 finite y->Rabs(r32 y)<=16777216->Rabs(r32 y)<=9*k->0<=k->
 finite(step a b c y e0 e1 x) /\
 Rabs(r32(step a b c y e0 e1 x))<=16777216 /\
 Rabs(r32(step a b c y e0 e1 x))<=9*(k+1) /\
 Rabs(r32(step a b c y e0 e1 x)-
 (r32 y+r32 a*r32 x+r32 b*r32 e0+r32 c*r32 e1))<=32*u*(k+1).
Proof.
 intros a b c y e0 e1 x k[Fa Ha][Fb Hb][Fc Hc][F0 H0][F1 H1][Fx Hx]Fy YB YK K.
 destruct(unit_product a x Fa Fx Ha Hx)as[Fp[P Ep]].
 destruct(unit_product b e0 Fb F0 Hb H0)as[Fq[Q Eq]].
 destruct(unit_product c e1 Fc F1 Hc H1)as[Fr[T Er]].
 set(p:=Float32.mul a x)in *;set(q:=Float32.mul b e0)in *;set(r:=Float32.mul c e1)in *.
 destruct(add_absorption y p Fy Fp YB P)as[Fz[ZB[Ez ZG]]].
 set(z:=Float32.add y p)in *.
 destruct(add_absorption z q Fz Fq ZB Q)as[Fv[VB[Ev VG]]].
 set(v:=Float32.add z q)in *.
 destruct(add_absorption v r Fv Fr VB T)as[Fw[WB[Ew WG]]].
 set(w:=Float32.add v r)in *.
 assert(ZK:Rabs(r32 z)<=9*k+3)by lra.
 assert(VK:Rabs(r32 v)<=9*k+6)by lra.
 assert(WK:Rabs(r32 w)<=9*(k+1))by lra.
 assert(Sz:Rabs(r32 y+r32 p)<=9*k+1)by
  (eapply Rle_trans;[apply Rabs_triang|];lra).
 assert(Sv:Rabs(r32 z+r32 q)<=9*k+4)by
  (eapply Rle_trans;[apply Rabs_triang|];lra).
 assert(Sw:Rabs(r32 v+r32 r)<=9*k+7)by
  (eapply Rle_trans;[apply Rabs_triang|];lra).
 assert(Ez':Rabs(r32 z-(r32 y+r32 p))<=u*(9*k+1)+eta).
 { rewrite u_value in *;lra. }
 assert(Ev':Rabs(r32 v-(r32 z+r32 q))<=u*(9*k+4)+eta).
 { rewrite u_value in *;lra. }
 assert(Ew':Rabs(r32 w-(r32 v+r32 r))<=u*(9*k+7)+eta).
 { rewrite u_value in *;lra. }
 change(finite w /\ Rabs(r32 w)<=16777216 /\ Rabs(r32 w)<=9*(k+1) /\
 Rabs(r32 w-(r32 y+r32 a*r32 x+r32 b*r32 e0+r32 c*r32 e1))<=32*u*(k+1)).
 split;[exact Fw|];split;[exact WB|];split;[exact WK|].
 apply abs_bounds in Ez';apply abs_bounds in Ev';apply abs_bounds in Ew'.
 apply abs_bounds in Ep;apply abs_bounds in Eq;apply abs_bounds in Er.
 apply Rabs_le;rewrite u_value,eta_value in *;lra.
Qed.

Theorem invariant:forall a b c x,Admissible a b c x->forall n,
 finite(actual a b c x n) /\ Rabs(r32(actual a b c x n))<=16777216 /\
 Rabs(r32(actual a b c x n))<=9*INR n.
Proof.
 intros a b c x[A[B[C[X0 X]]]]n;induction n as[|n[F[Bd G]]].
 - cbn[actual];split;[reflexivity|];change(Rabs 0<=16777216 /\ Rabs 0<=9*0);rewrite Rabs_R0;split;lra.
 - cbn[actual];destruct(step_bound a b c(actual a b c x n)(x n)(prev32 x n)(x(S n))(INR n)
   A B C(X n)(prev_unit x X n)(X(S n))F Bd G(pos_INR n))as[F'[B'[G' E]]].
   split;[exact F'|];split;[exact B'|];rewrite S_INR;exact G'.
Qed.
Theorem local_error:forall a b c x,Admissible a b c x->forall n,
 Rabs(r32(actual a b c x(S n))-
 (r32(actual a b c x n)+r32 a*r32(x(S n))+r32 b*r32(x n)+r32 c*previous(fun k=>r32(x k))n))
 <=32*u*(INR n+1).
Proof.
 intros a b c x A n.
 destruct(invariant a b c x A n)as[F[Bd G]].
 destruct A as[A[B[C[X0 X]]]].
 cbn[actual];rewrite <-previous_real.
 exact(proj2(proj2(proj2(step_bound a b c(actual a b c x n)(x n)(prev32 x n)(x(S n))(INR n)
 A B C(X n)(prev_unit x X n)(X(S n))F Bd G(pos_INR n))))).
Qed.
Theorem floating_stored_error:forall a b c x,Admissible a b c x->forall n,
 Rabs(r32(actual a b c x n)-incremental(r32 a)(r32 b)(r32 c)(fun k=>r32(x k))n)<=roundoff_envelope n.
Proof.
 intros a b c x A n;unfold roundoff_envelope.
 apply(accumulated_local_error (r32 a)(r32 b)(r32 c)(fun k=>r32(x k))(fun k=>r32(actual a b c x k))(16*u)).
 - rewrite u_value;lra.
 - reflexivity.
 - intro k;replace(2*(16*u)*(INR k+1))with(32*u*(INR k+1))by ring;apply local_error;exact A.
Qed.
Theorem positional_error:forall a b c x,Admissible a b c x->forall P H D n,
 Rabs(r32(actual a b c x n)-positional P H D(fun k=>r32(x k))n)<=total_envelope a b c P H D n.
Proof.
 intros a b c x A P H D n.
 pose proof(floating_stored_error a b c x A n)as E.
 destruct A as[AA[BB[CC[X0 X]]]].
 assert(R0:(fun k=>r32(x k))O=0)by(rewrite X0;reflexivity).
 pose proof(coefficient_perturbation(r32 a)(r32 b)(r32 c)(P+H+D)(-P+H-2*D)D
  (fun k=>r32(x k))(fun k=>proj2(X k))n)as C.
 rewrite(exact_positional P H D(fun k=>r32(x k))R0 n)in C.
 unfold total_envelope.
 replace(r32(actual a b c x n)-positional P H D(fun k=>r32(x k))n)
 with((r32(actual a b c x n)-incremental(r32 a)(r32 b)(r32 c)(fun k=>r32(x k))n)+
 (incremental(r32 a)(r32 b)(r32 c)(fun k=>r32(x k))n-positional P H D(fun k=>r32(x k))n))by ring.
 eapply Rle_trans;[apply Rabs_triang|];lra.
Qed.
