From Stdlib Require Import Reals Lra Psatz ZArith Lia.
Local Open Scope R_scope.
Definition RMatrix:=nat->nat->R.
Definition RDiag(a:R):RMatrix:=fun i j=>if Nat.eq_dec i j then a else 0.
Definition Eye:RMatrix:=RDiag 1.
Definition Zero:RMatrix:=fun _ _=>0.
Definition Mul2(A B:RMatrix):RMatrix:=fun i j=>A i 0%nat*B 0%nat j+A i 1%nat*B 1%nat j.
Definition Mul3(A B:RMatrix):RMatrix:=fun i j=>A i 0%nat*B 0%nat j+A i 1%nat*B 1%nat j+A i 2%nat*B 2%nat j.
Definition Norm2(A:RMatrix):R:=Rmax(Rabs(A 0%nat 0%nat)+Rabs(A 0%nat 1%nat))(Rabs(A 1%nat 0%nat)+Rabs(A 1%nat 1%nat)).
Definition Norm3(A:RMatrix):R:=Rmax(Rabs(A 0%nat 0%nat)+Rabs(A 0%nat 1%nat)+Rabs(A 0%nat 2%nat))
 (Rmax(Rabs(A 1%nat 0%nat)+Rabs(A 1%nat 1%nat)+Rabs(A 1%nat 2%nat))(Rabs(A 2%nat 0%nat)+Rabs(A 2%nat 1%nat)+Rabs(A 2%nat 2%nat))).
Definition Inverts2(A B:RMatrix):Prop:=forall i j,(i<2)%nat->(j<2)%nat->Mul2 A B i j=Eye i j /\Mul2 B A i j=Eye i j.
Definition Inverts3(A B:RMatrix):Prop:=forall i j,(i<3)%nat->(j<3)%nat->Mul3 A B i j=Eye i j /\Mul3 B A i j=Eye i j.
Definition Residual2(A X:RMatrix):R:=Norm2(fun i j=>Mul2 A X i j-Eye i j).
Definition Residual3(A X:RMatrix):R:=Norm3(fun i j=>Mul3 A X i j-Eye i j).
Lemma diagonal_norm2:forall a,Norm2(RDiag a)=Rabs a.
Proof. intro a;unfold Norm2,RDiag;cbn;rewrite Rabs_R0;rewrite Rplus_0_l,Rplus_0_r;apply Rmax_left;lra. Qed.
Lemma diagonal_norm3:forall a,Norm3(RDiag a)=Rabs a.
Proof. intro a;unfold Norm3,RDiag;cbn;rewrite Rabs_R0;repeat rewrite Rplus_0_l;repeat rewrite Rplus_0_r;repeat rewrite (Rmax_left (Rabs a)(Rabs a)) by lra;reflexivity. Qed.
Lemma diagonal_inverse2:forall a,a<>0->Inverts2(RDiag a)(RDiag(/a)).
Proof.
 intros a N i j I J;assert(A:i=0%nat\/i=1%nat)by lia;assert(B:j=0%nat\/j=1%nat)by lia;
 destruct A as [-> | ->];destruct B as [-> | ->];unfold Mul2,Eye,RDiag;cbn;split;field;exact N.
Qed.
Lemma diagonal_condition2:forall a,a<>0->Norm2(RDiag a)*Norm2(RDiag(/a))=1.
Proof. intros a N;rewrite !diagonal_norm2,<-Rabs_mult;replace(a* /a)with 1 by(field;exact N);apply Rabs_R1. Qed.
Lemma inverse_residual2:forall A B,Inverts2 A B->Residual2 A B=0.
Proof.
 intros A B H;unfold Residual2,Norm2.
 rewrite(proj1(H 0%nat 0%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 0%nat 1%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 1%nat 0%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 1%nat 1%nat ltac:(lia) ltac:(lia))).
 repeat rewrite Rminus_diag;rewrite Rabs_R0;repeat rewrite Rplus_0_l;repeat rewrite (Rmax_left 0 0) by lra;reflexivity.
Qed.
Lemma zero_residual2:forall a,Residual2(RDiag a)Zero=1.
Proof.
 intro a;unfold Residual2,Norm2,Mul2,Zero,Eye,RDiag;cbn;
 repeat rewrite Rmult_0_r;repeat rewrite Rplus_0_l;repeat rewrite Rminus_0_l;
 repeat rewrite Ropp_0;repeat rewrite Rabs_Ropp;rewrite Rabs_R0,Rabs_R1;
 repeat rewrite Rplus_0_l;repeat rewrite Rplus_0_r;repeat rewrite (Rmax_left 0 0) by lra;repeat rewrite (Rmax_left 1 1) by lra;reflexivity.
Qed.
Lemma diagonal_inverse3:forall a,a<>0->Inverts3(RDiag a)(RDiag(/a)).
Proof.
 intros a N i j I J;assert(A:i=0%nat\/i=1%nat\/i=2%nat)by lia;assert(B:j=0%nat\/j=1%nat\/j=2%nat)by lia;
 destruct A as [-> | [-> | ->]];destruct B as [-> | [-> | ->]];unfold Mul3,Eye,RDiag;cbn;split;field;exact N.
Qed.
Lemma diagonal_condition3:forall a,a<>0->Norm3(RDiag a)*Norm3(RDiag(/a))=1.
Proof. intros a N;rewrite !diagonal_norm3,<-Rabs_mult;replace(a* /a)with 1 by(field;exact N);apply Rabs_R1. Qed.
Lemma inverse_residual3:forall A B,Inverts3 A B->Residual3 A B=0.
Proof.
 intros A B H;unfold Residual3,Norm3.
 rewrite(proj1(H 0%nat 0%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 0%nat 1%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 0%nat 2%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 1%nat 0%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 1%nat 1%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 1%nat 2%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 2%nat 0%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 2%nat 1%nat ltac:(lia) ltac:(lia))).
 rewrite(proj1(H 2%nat 2%nat ltac:(lia) ltac:(lia))).
 repeat rewrite Rminus_diag;rewrite Rabs_R0;repeat rewrite Rplus_0_l;repeat rewrite (Rmax_left 0 0) by lra;repeat rewrite (Rmax_left 1 1) by lra;reflexivity.
Qed.
Lemma zero_residual3:forall a,Residual3(RDiag a)Zero=1.
Proof.
 intro a;unfold Residual3,Norm3,Mul3,Zero,Eye,RDiag;cbn;
 repeat rewrite Rmult_0_r;repeat rewrite Rplus_0_l;repeat rewrite Rminus_0_l;
 repeat rewrite Ropp_0;repeat rewrite Rabs_Ropp;rewrite Rabs_R0,Rabs_R1;
 repeat rewrite Rplus_0_l;repeat rewrite Rplus_0_r;repeat rewrite (Rmax_left 0 0) by lra;repeat rewrite (Rmax_left 1 1) by lra;reflexivity.
Qed.
Print Assumptions diagonal_inverse2.
Print Assumptions diagonal_condition2.
Print Assumptions zero_residual2.
Print Assumptions diagonal_inverse3.
Print Assumptions diagonal_condition3.
Print Assumptions zero_residual3.

Definition EqN(n:nat)(A B:RMatrix):Prop:=forall i j,(i<n)%nat->(j<n)%nat->A i j=B i j.
Lemma norm2_ext:forall A B,EqN 2 A B->Norm2 A=Norm2 B.
Proof. intros A B E;unfold Norm2.
 rewrite(E 0%nat 0%nat ltac:(lia) ltac:(lia)).
 rewrite(E 0%nat 1%nat ltac:(lia) ltac:(lia)).
 rewrite(E 1%nat 0%nat ltac:(lia) ltac:(lia)).
 rewrite(E 1%nat 1%nat ltac:(lia) ltac:(lia)).
 reflexivity.
Qed.
Lemma mul2_ext:forall A B C D,EqN 2 A C->EqN 2 B D->EqN 2(Mul2 A B)(Mul2 C D).
Proof. intros A B C D E F i j I J;unfold Mul2.
 rewrite(E i 0%nat I ltac:(lia)),(F 0%nat j ltac:(lia) J).
 rewrite(E i 1%nat I ltac:(lia)),(F 1%nat j ltac:(lia) J).
 reflexivity.
Qed.
Lemma residual2_ext:forall A B C D,EqN 2 A C->EqN 2 B D->Residual2 A B=Residual2 C D.
Proof. intros A B C D E F;apply norm2_ext;intros i j I J;rewrite(mul2_ext A B C D E F i j I J);reflexivity. Qed.
Lemma inverts2_ext:forall A B C D,EqN 2 A C->EqN 2 B D->Inverts2 C D->Inverts2 A B.
Proof. intros A B C D E F H i j I J;rewrite(mul2_ext A B C D E F i j I J),(mul2_ext B A D C F E i j I J);apply H;assumption. Qed.
Lemma norm3_ext:forall A B,EqN 3 A B->Norm3 A=Norm3 B.
Proof. intros A B E;unfold Norm3.
 rewrite(E 0%nat 0%nat ltac:(lia) ltac:(lia)).
 rewrite(E 0%nat 1%nat ltac:(lia) ltac:(lia)).
 rewrite(E 0%nat 2%nat ltac:(lia) ltac:(lia)).
 rewrite(E 1%nat 0%nat ltac:(lia) ltac:(lia)).
 rewrite(E 1%nat 1%nat ltac:(lia) ltac:(lia)).
 rewrite(E 1%nat 2%nat ltac:(lia) ltac:(lia)).
 rewrite(E 2%nat 0%nat ltac:(lia) ltac:(lia)).
 rewrite(E 2%nat 1%nat ltac:(lia) ltac:(lia)).
 rewrite(E 2%nat 2%nat ltac:(lia) ltac:(lia)).
 reflexivity.
Qed.
Lemma mul3_ext:forall A B C D,EqN 3 A C->EqN 3 B D->EqN 3(Mul3 A B)(Mul3 C D).
Proof. intros A B C D E F i j I J;unfold Mul3.
 rewrite(E i 0%nat I ltac:(lia)),(F 0%nat j ltac:(lia) J).
 rewrite(E i 1%nat I ltac:(lia)),(F 1%nat j ltac:(lia) J).
 rewrite(E i 2%nat I ltac:(lia)),(F 2%nat j ltac:(lia) J).
 reflexivity.
Qed.
Lemma residual3_ext:forall A B C D,EqN 3 A C->EqN 3 B D->Residual3 A B=Residual3 C D.
Proof. intros A B C D E F;apply norm3_ext;intros i j I J;rewrite(mul3_ext A B C D E F i j I J);reflexivity. Qed.
Lemma inverts3_ext:forall A B C D,EqN 3 A C->EqN 3 B D->Inverts3 C D->Inverts3 A B.
Proof. intros A B C D E F H i j I J;rewrite(mul3_ext A B C D E F i j I J),(mul3_ext B A D C F E i j I J);apply H;assumption. Qed.
