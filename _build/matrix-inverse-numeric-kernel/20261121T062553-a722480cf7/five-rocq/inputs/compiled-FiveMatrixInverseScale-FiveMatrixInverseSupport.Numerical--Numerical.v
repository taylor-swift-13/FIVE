From Stdlib Require Import List ZArith Reals Lia Lra Psatz.
From compcert Require Import Integers Floats Values.
From Flocq Require Import Core.Core IEEE754.Binary.
From FiveMatrixInverseSupport Require Import Dyadic Kernels Threshold RealMatrix.
Import ListNotations.
Local Open Scope R_scope.
Definition Lift2(f:Z->float32):RMatrix:=fun i j=>real32(f(Z.of_nat(2*i+j))).
Definition Lift3(f:Z->float32):RMatrix:=fun i j=>real32(f(Z.of_nat(3*i+j))).
Definition Computed2(f:Z->float32):RMatrix:=Lift2(D2.Output f).
Definition Computed3(f:Z->float32):RMatrix:=Lift3(D3.Output f).
Lemma lift2_diagonal:forall x,EqN 2(Lift2(Diag2 x))(RDiag(real32 x)).
Proof. intros x i j I J;assert(A:i=0%nat\/i=1%nat)by lia;assert(B:j=0%nat\/j=1%nat)by lia;destruct A as [-> | ->];destruct B as [-> | ->];reflexivity. Qed.
Lemma computed2_safe:forall k,(-20<=k<=20)%Z->EqN 2(Computed2(Diag2(power32 k)))(RDiag(bpow radix2(-k))).
Proof.
 intros k K i j I J;assert(A:i=0%nat\/i=1%nat)by lia;assert(B:j=0%nat\/j=1%nat)by lia;destruct A as [-> | ->];destruct B as [-> | ->].
 - pose proof(f_equal(fun xs=>nth 0%nat xs Float32.zero)(output2_safe k K))as E.
   change(D2.Output(Diag2(power32 k))0%Z=power32(-k))in E.
   change(real32(D2.Output(Diag2(power32 k))0%Z)=bpow radix2(-k));rewrite E;apply power_real;lia.
 - pose proof(f_equal(fun xs=>nth 1%nat xs Float32.zero)(output2_safe k K))as E.
   change(D2.Output(Diag2(power32 k))1%Z=Float32.neg Float32.zero)in E.
   change(real32(D2.Output(Diag2(power32 k))1%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 2%nat xs Float32.zero)(output2_safe k K))as E.
   change(D2.Output(Diag2(power32 k))2%Z=Float32.neg Float32.zero)in E.
   change(real32(D2.Output(Diag2(power32 k))2%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 3%nat xs Float32.zero)(output2_safe k K))as E.
   change(D2.Output(Diag2(power32 k))3%Z=power32(-k))in E.
   change(real32(D2.Output(Diag2(power32 k))3%Z)=bpow radix2(-k));rewrite E;apply power_real;lia.
Qed.
Lemma computed2_large_zero:EqN 2(Computed2 large2)Zero.
Proof. intros i j I J;assert(A:i=0%nat\/i=1%nat)by lia;assert(B:j=0%nat\/j=1%nat)by lia;destruct A as [-> | ->];destruct B as [-> | ->];vm_compute;reflexivity. Qed.
Lemma lift3_diagonal:forall x,EqN 3(Lift3(Diag3 x))(RDiag(real32 x)).
Proof. intros x i j I J;assert(A:i=0%nat\/i=1%nat\/i=2%nat)by lia;assert(B:j=0%nat\/j=1%nat\/j=2%nat)by lia;destruct A as [-> | [-> | ->]];destruct B as [-> | [-> | ->]];reflexivity. Qed.
Lemma computed3_safe:forall k,(-20<=k<=20)%Z->EqN 3(Computed3(Diag3(power32 k)))(RDiag(bpow radix2(-k))).
Proof.
 intros k K i j I J;assert(A:i=0%nat\/i=1%nat\/i=2%nat)by lia;assert(B:j=0%nat\/j=1%nat\/j=2%nat)by lia;destruct A as [-> | [-> | ->]];destruct B as [-> | [-> | ->]].
 - pose proof(f_equal(fun xs=>nth 0%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))0%Z=power32(-k))in E.
   change(real32(D3.Output(Diag3(power32 k))0%Z)=bpow radix2(-k));rewrite E;apply power_real;lia.
 - pose proof(f_equal(fun xs=>nth 1%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))1%Z=Float32.neg Float32.zero)in E.
   change(real32(D3.Output(Diag3(power32 k))1%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 2%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))2%Z=Float32.zero)in E.
   change(real32(D3.Output(Diag3(power32 k))2%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 3%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))3%Z=Float32.neg Float32.zero)in E.
   change(real32(D3.Output(Diag3(power32 k))3%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 4%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))4%Z=power32(-k))in E.
   change(real32(D3.Output(Diag3(power32 k))4%Z)=bpow radix2(-k));rewrite E;apply power_real;lia.
 - pose proof(f_equal(fun xs=>nth 5%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))5%Z=Float32.neg Float32.zero)in E.
   change(real32(D3.Output(Diag3(power32 k))5%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 6%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))6%Z=Float32.zero)in E.
   change(real32(D3.Output(Diag3(power32 k))6%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 7%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))7%Z=Float32.neg Float32.zero)in E.
   change(real32(D3.Output(Diag3(power32 k))7%Z)=0);rewrite E;reflexivity.
 - pose proof(f_equal(fun xs=>nth 8%nat xs Float32.zero)(output3_safe k K))as E.
   change(D3.Output(Diag3(power32 k))8%Z=power32(-k))in E.
   change(real32(D3.Output(Diag3(power32 k))8%Z)=bpow radix2(-k));rewrite E;apply power_real;lia.
Qed.
Lemma computed3_large_zero:EqN 3(Computed3 large3)Zero.
Proof. intros i j I J;assert(A:i=0%nat\/i=1%nat\/i=2%nat)by lia;assert(B:j=0%nat\/j=1%nat\/j=2%nat)by lia;destruct A as [-> | [-> | ->]];destruct B as [-> | [-> | ->]];vm_compute;reflexivity. Qed.
Lemma one_real:real32 one=1.
Proof. change(8388608/8388608=1);field. Qed.
Lemma small_real:real32 small= /256.
Proof. change(8388608/2147483648= /256);field. Qed.
Lemma big2_real:real32 big2=bpow radix2 100.
Proof. change(8388608*151115727451828646838272=1267650600228229401496703205376);ring. Qed.
Lemma big3_real:real32 big3=bpow radix2 50.
Proof. change(8388608*134217728=1125899906842624);ring. Qed.
Lemma big2_positive:0<real32 big2.
Proof. rewrite big2_real;apply bpow_gt_0. Qed.
Lemma big3_positive:0<real32 big3.
Proof. rewrite big3_real;apply bpow_gt_0. Qed.
Lemma small_positive:0<real32 small.
Proof. rewrite small_real;lra. Qed.
Lemma one_positive:0<real32 one.
Proof. rewrite one_real;lra. Qed.
Lemma reciprocal_power:forall k, /bpow radix2 k=bpow radix2(-k).
Proof. intro k;rewrite bpow_opp;reflexivity. Qed.
Lemma safe2_ideal:forall k,(-20<=k<=20)%Z->
 Inverts2(Lift2(Diag2(power32 k)))(RDiag(/bpow radix2 k)) /\
 Norm2(Lift2(Diag2(power32 k)))*Norm2(RDiag(/bpow radix2 k))=1 /\
 Residual2(Lift2(Diag2(power32 k)))(Computed2(Diag2(power32 k)))=0.
Proof.
 intros k K;assert(P:0<bpow radix2 k)by apply bpow_gt_0.
 assert(E:EqN 2(Lift2(Diag2(power32 k)))(RDiag(bpow radix2 k))).
 { rewrite <-(power_real k ltac:(lia));apply lift2_diagonal. }
 split.
 - eapply inverts2_ext;[exact E|intros i j I J;reflexivity|apply diagonal_inverse2;lra].
 - split.
 + rewrite(norm2_ext _ _ E);apply diagonal_condition2;lra.
 + rewrite(residual2_ext _ _ _ _ E(computed2_safe k K)).
   rewrite <-reciprocal_power;apply inverse_residual2;apply diagonal_inverse2;lra.
Qed.
Lemma large2_ideal_failure:
 finite32 big2 /\ Inverts2(Lift2 large2)(RDiag(/real32 big2)) /\
 Norm2(Lift2 large2)*Norm2(RDiag(/real32 big2))=1 /\
 Residual2(Lift2 large2)(Computed2 large2)=1.
Proof.
 assert(P:0<real32 big2)by apply big2_positive.
 unfold large2.
 split;[vm_compute;reflexivity|];split.
 - eapply inverts2_ext;[apply lift2_diagonal|intros i j I J;reflexivity|apply diagonal_inverse2;lra].
 - split.
 + rewrite(norm2_ext _ _(lift2_diagonal big2));apply diagonal_condition2;lra.
 + change(Residual2(Lift2(Diag2 big2))(Computed2 large2)=1).
   rewrite(residual2_ext _ _ _ _(lift2_diagonal big2) computed2_large_zero);apply zero_residual2.
Qed.
Lemma safe3_ideal:forall k,(-20<=k<=20)%Z->
 Inverts3(Lift3(Diag3(power32 k)))(RDiag(/bpow radix2 k)) /\
 Norm3(Lift3(Diag3(power32 k)))*Norm3(RDiag(/bpow radix2 k))=1 /\
 Residual3(Lift3(Diag3(power32 k)))(Computed3(Diag3(power32 k)))=0.
Proof.
 intros k K;assert(P:0<bpow radix2 k)by apply bpow_gt_0.
 assert(E:EqN 3(Lift3(Diag3(power32 k)))(RDiag(bpow radix2 k))).
 { rewrite <-(power_real k ltac:(lia));apply lift3_diagonal. }
 split.
 - eapply inverts3_ext;[exact E|intros i j I J;reflexivity|apply diagonal_inverse3;lra].
 - split.
 + rewrite(norm3_ext _ _ E);apply diagonal_condition3;lra.
 + rewrite(residual3_ext _ _ _ _ E(computed3_safe k K)).
   rewrite <-reciprocal_power;apply inverse_residual3;apply diagonal_inverse3;lra.
Qed.
Lemma large3_ideal_failure:
 finite32 big3 /\ Inverts3(Lift3 large3)(RDiag(/real32 big3)) /\
 Norm3(Lift3 large3)*Norm3(RDiag(/real32 big3))=1 /\
 Residual3(Lift3 large3)(Computed3 large3)=1.
Proof.
 assert(P:0<real32 big3)by apply big3_positive.
 unfold large3.
 split;[vm_compute;reflexivity|];split.
 - eapply inverts3_ext;[apply lift3_diagonal|intros i j I J;reflexivity|apply diagonal_inverse3;lra].
 - split.
 + rewrite(norm3_ext _ _(lift3_diagonal big3));apply diagonal_condition3;lra.
 + change(Residual3(Lift3(Diag3 big3))(Computed3 large3)=1).
   rewrite(residual3_ext _ _ _ _(lift3_diagonal big3) computed3_large_zero);apply zero_residual3.
Qed.
Print Assumptions safe2_ideal.
Print Assumptions safe3_ideal.
Print Assumptions large2_ideal_failure.
Print Assumptions large3_ideal_failure.

Definition ConditionOne2(f:Z->float32):Prop:=exists B,Inverts2(Lift2 f)B /\ Norm2(Lift2 f)*Norm2 B=1.
Definition ConditionOne3(f:Z->float32):Prop:=exists B,Inverts3(Lift3 f)B /\ Norm3(Lift3 f)*Norm3 B=1.
Lemma finite_diag2:forall x,finite32 x->forall i,finite32(Diag2 x i).
Proof. intros x F i;unfold Diag2;destruct(_||_)%bool;[exact F|reflexivity]. Qed.
Lemma finite_diag3:forall x,finite32 x->forall i,finite32(Diag3 x i).
Proof. intros x F i;unfold Diag3;destruct(_||_)%bool;[exact F|reflexivity]. Qed.
Lemma diagonal_condition_one2:forall x,real32 x<>0->ConditionOne2(Diag2 x).
Proof.
 intros x N;exists(RDiag(/real32 x));split.
 - eapply inverts2_ext;[apply lift2_diagonal|intros i j I J;reflexivity|apply diagonal_inverse2;exact N].
 - rewrite(norm2_ext _ _(lift2_diagonal x));apply diagonal_condition2;exact N.
Qed.
Lemma scale2_small:EqN 2(Lift2 small2)(fun i j=>(/256)*Lift2 base2 i j).
Proof.
 intros i j I J;change(Lift2(Diag2 small)i j=(/256)*Lift2(Diag2 one)i j).
 rewrite(lift2_diagonal small i j I J),(lift2_diagonal one i j I J),small_real,one_real.
 unfold RDiag;destruct(Nat.eq_dec i j);ring.
Qed.
Lemma diagonal_condition_one3:forall x,real32 x<>0->ConditionOne3(Diag3 x).
Proof.
 intros x N;exists(RDiag(/real32 x));split.
 - eapply inverts3_ext;[apply lift3_diagonal|intros i j I J;reflexivity|apply diagonal_inverse3;exact N].
 - rewrite(norm3_ext _ _(lift3_diagonal x));apply diagonal_condition3;exact N.
Qed.
Lemma scale3_small:EqN 3(Lift3 small3)(fun i j=>(/256)*Lift3 base3 i j).
Proof.
 intros i j I J;change(Lift3(Diag3 small)i j=(/256)*Lift3(Diag3 one)i j).
 rewrite(lift3_diagonal small i j I J),(lift3_diagonal one i j I J),small_real,one_real.
 unfold RDiag;destruct(Nat.eq_dec i j);ring.
Qed.
