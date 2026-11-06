From FiveGhSetZetaFunctional Require Import Spec.
From FiveGhSetZetaProof Require Import Entry Public.
Theorem normal_completion:Spec.NormalCompletion.
Proof. exact Entry.entry_normal. Qed.
Theorem all_return_spec:Spec.AllReturnSpec.
Proof. exact Entry.entry_return_spec. Qed.
Print Assumptions normal_completion.
Print Assumptions all_return_spec.
