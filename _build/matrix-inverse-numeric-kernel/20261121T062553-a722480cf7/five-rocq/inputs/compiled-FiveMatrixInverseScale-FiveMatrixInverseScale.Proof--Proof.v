From Stdlib Require Import List ZArith Reals Lia Lra.
From compcert Require Import Integers Floats Values.
From FiveMatrixInverseSupport Require Import Dyadic Kernels Witness Threshold RealMatrix Numerical.
From FiveMatrixInverseScale Require Import Spec.
Require FiveInv2Functional.Proof FiveMatInv3Functional.Proof.
Import ListNotations.
Local Open Scope R_scope.
Theorem actual2:Spec.Actual2.
Proof. split;[exact FiveInv2Functional.Proof.normal_call|exact FiveInv2Functional.Proof.all_returns]. Qed.
Theorem actual3:Spec.Actual3.
Proof. split;[exact FiveMatInv3Functional.Proof.normal_call|exact FiveMatInv3Functional.Proof.all_normal_observations]. Qed.
Lemma legal2:forall f,Spec.Legal2 f(D2.Result f).
Proof.
 intro f;destruct(matrix4_inhabited f)as[m[bo[bi IN]]].
 destruct(FiveInv2Functional.Proof.normal_call m bo bi Ptrofs.zero Ptrofs.zero f IN)as[t[mf[PATH POST]]].
 exists m,bo,bi,mf,t;auto.
Qed.
Lemma legal3:forall f,Spec.Legal3 f(D3.Status f).
Proof.
 intro f;destruct(matrix9_inhabited f)as[m[bo[bi[NE[W RD]]]]].
 destruct(FiveMatInv3Functional.Proof.normal_call m bo bi Ptrofs.zero Ptrofs.zero f NE W RD)as[mf[[t PATH]POST]].
 exists m,bo,bi,mf,t;auto.
Qed.
Theorem safe_family2:Spec.SafeFamily2.
Proof.
 split;[exact actual2|];intros k K;split;[apply reject2_safe;exact K|];split;[apply output2_safe;exact K|];split;[apply safe2_ideal;exact K|].
 apply finite_diag2;apply power_finite;lia.
Qed.
Theorem scale_status_refuted2:Spec.ScaleRefuted2.
Proof.
 split;[exact actual2|];split.
 - intro i;split;apply finite_diag2;vm_compute;reflexivity.
 - split.
 + split;apply diagonal_condition_one2;[pose proof one_positive|pose proof small_positive];lra.
 + split;[lra|];split;[exact scale2_small|];split;[exact(proj1 base2_kernel)|];split;[exact(proj1 small2_kernel)|];split.
 * pose proof(legal2 base2)as L;rewrite(proj1 base2_kernel)in L;exact L.
 * pose proof(legal2 small2)as L;rewrite(proj1 small2_kernel)in L;exact L.
Qed.
Theorem overflow_reliability_refuted2:Spec.OverflowRefuted2.
Proof.
 destruct large2_ideal_failure as[FIN[INV[COND RES]]].
 split;[exact actual2|];split;[apply finite_diag2;exact FIN|];split.
 - exists(RDiag(/real32 big2));split;assumption.
 - destruct large2_kernel as[STATUS[DET WORDS]];split;[exact STATUS|];split;[exact DET|];split;[exact WORDS|];split;[exact RES|].
   pose proof(legal2 large2)as L;rewrite STATUS in L;exact L.
Qed.
Theorem safe_family3:Spec.SafeFamily3.
Proof.
 split;[exact actual3|];intros k K;split;[apply accept3_safe;exact K|];split;[apply output3_safe;exact K|];split;[apply safe3_ideal;exact K|].
 apply finite_diag3;apply power_finite;lia.
Qed.
Theorem scale_status_refuted3:Spec.ScaleRefuted3.
Proof.
 split;[exact actual3|];split.
 - intro i;split;apply finite_diag3;vm_compute;reflexivity.
 - split.
 + split;apply diagonal_condition_one3;[pose proof one_positive|pose proof small_positive];lra.
 + split;[lra|];split;[exact scale3_small|];split;[exact(proj1 base3_kernel)|];split;[exact(proj1 small3_kernel)|];split.
 * pose proof(legal3 base3)as L;rewrite(proj1 base3_kernel)in L;exact L.
 * pose proof(legal3 small3)as L;rewrite(proj1 small3_kernel)in L;exact L.
Qed.
Theorem overflow_reliability_refuted3:Spec.OverflowRefuted3.
Proof.
 destruct large3_ideal_failure as[FIN[INV[COND RES]]].
 split;[exact actual3|];split;[apply finite_diag3;exact FIN|];split.
 - exists(RDiag(/real32 big3));split;assumption.
 - destruct large3_kernel as[STATUS[DET WORDS]];split;[exact STATUS|];split;[exact DET|];split;[exact WORDS|];split;[exact RES|].
   pose proof(legal3 large3)as L;rewrite STATUS in L;exact L.
Qed.
Print Assumptions safe_family2.
Print Assumptions safe_family3.
Print Assumptions scale_status_refuted2.
Print Assumptions scale_status_refuted3.
Print Assumptions overflow_reliability_refuted2.
Print Assumptions overflow_reliability_refuted3.
