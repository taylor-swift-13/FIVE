From compcert Require Import Floats.
From FiveGuidanceSoftwareProof Require Import SourceCertificate.
(** Exact auxiliary result of interpreting the frozen, original CompCert
    Csyntax helper body. Its execution correspondence is proved separately;
    this definition is not an ideal sqrt or an external-library axiom. *)
Definition software_sqrt : float32 -> float32 := source_derived_sqrt.
Lemma software_sqrt_positive_zero:software_sqrt Float32.zero=Float32.zero.
Proof. vm_compute;reflexivity. Qed.
Lemma software_sqrt_negative_zero:software_sqrt(Float32.neg Float32.zero)=Float32.neg Float32.zero.
Proof. vm_compute;reflexivity. Qed.
Print Assumptions software_sqrt_positive_zero.
