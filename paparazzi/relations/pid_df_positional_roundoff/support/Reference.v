From Stdlib Require Import Reals ZArith Lia Lra Psatz.
Open Scope R_scope.
Definition previous (x:nat->R)(n:nat):R:=match n with O=>0 |S k=>x k end.
Fixpoint trap_sum(x:nat->R)(n:nat):R:=
 match n with O=>0|S k=>trap_sum x k+x(S k)+x k end.
Definition positional(P H D:R)(x:nat->R)(n:nat):R:=
 P*x n+H*trap_sum x n+D*(x n-previous x n).
Fixpoint incremental(a b c:R)(x:nat->R)(n:nat):R:=
 match n with O=>0|S k=>incremental a b c x k+a*x(S k)+b*x k+c*previous x k end.
Definition Delta(a b c A B C:R):R:=Rabs(a-A)+Rabs(b-B)+Rabs(c-C).

Theorem exact_positional:forall P H D x,x O=0->forall n,
 incremental(P+H+D)(-P+H-2*D)D x n=positional P H D x n.
Proof.
 intros P H D x X n;induction n as[|n IH].
 - unfold positional,previous;cbn;rewrite X;ring.
 - cbn[incremental];rewrite IH;unfold positional at 1 2.
   cbn[trap_sum previous];destruct n;cbn[previous]in *;[rewrite X|];ring.
Qed.

Lemma product_difference:forall a A x,Rabs x<=1->
 Rabs(a*x-A*x)<=Rabs(a-A).
Proof.
 intros a A x H;replace(a*x-A*x)with((a-A)*x)by ring.
 rewrite Rabs_mult;pose proof(Rabs_pos(a-A));pose proof(Rabs_pos x);nra.
Qed.
Lemma Delta_nonnegative:forall a b c A B C,0<=Delta a b c A B C.
Proof. intros a b c A B C;unfold Delta;pose proof(Rabs_pos(a-A));pose proof(Rabs_pos(b-B));pose proof(Rabs_pos(c-C));nra. Qed.
Lemma coefficient_perturbation:forall a b c A B C x,
 (forall k,Rabs(x k)<=1)->forall n,
 Rabs(incremental a b c x n-incremental A B C x n)<=INR n*Delta a b c A B C.
Proof.
 intros a b c A B C x X n;induction n as[|n IH].
 - cbn;rewrite Rminus_diag,Rabs_R0;right;ring.
 - cbn[incremental];rewrite S_INR.
   replace(incremental a b c x n+a*x(S n)+b*x n+c*previous x n-
    (incremental A B C x n+A*x(S n)+B*x n+C*previous x n))
   with((incremental a b c x n-incremental A B C x n)+
    (a*x(S n)-A*x(S n))+(b*x n-B*x n)+(c*previous x n-C*previous x n))by ring.
   eapply Rle_trans;[apply Rabs_triang|].
   eapply Rle_trans;[apply Rplus_le_compat_r;apply Rabs_triang|].
   eapply Rle_trans;[apply Rplus_le_compat_r;apply Rplus_le_compat_r;apply Rabs_triang|].
   pose proof(product_difference a A(x(S n))(X(S n)))as Ha.
   pose proof(product_difference b B(x n)(X n))as Hb.
   assert(Hp:Rabs(previous x n)<=1)by(destruct n;cbn[previous];[rewrite Rabs_R0;lra|apply X]).
   pose proof(product_difference c C(previous x n)Hp)as Hc.
   unfold Delta in *;nra.
Qed.

Lemma accumulated_local_error:forall a b c x y d,
 0<=d->y O=0->
 (forall k,Rabs(y(S k)-(y k+a*x(S k)+b*x k+c*previous x k))<=2*d*(INR k+1))->
 forall n,Rabs(y n-incremental a b c x n)<=d*INR n*(INR n+1).
Proof.
 intros a b c x y d Hd Y E n;induction n as[|n IH].
 - cbn;rewrite Y,Rminus_diag,Rabs_R0;lra.
 - cbn[incremental];rewrite S_INR.
   replace(y(S n)-(incremental a b c x n+a*x(S n)+b*x n+c*previous x n))
   with((y(S n)-(y n+a*x(S n)+b*x n+c*previous x n))+
    (y n-incremental a b c x n))by ring.
   eapply Rle_trans;[apply Rabs_triang|].
   pose proof(E n);nra.
Qed.
