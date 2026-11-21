From Stdlib Require Import ZArith Lia.
Open Scope Z_scope.
Definition signed32 (z:Z) : Prop := -2147483648 <= z <= 2147483647.
Definition physical_translation (r p d:Z) : Prop :=
 signed32 r /\ signed32 p /\ signed32 d / signed32 (r+d) /\ signed32 (p+d) /\ signed32 (r-p).
Definition trim (bound x:Z) : Z :=
 if Z.ltb bound x then bound else if Z.ltb x (-bound) then -bound else x.
Theorem common_translation_difference (r p d:Z) :
 (r+d)-(p+d)=r-p.
Proof. lia. Qed.
Theorem physical_translation_preserves_representable_error (r p d:Z) :
 physical_translation r p d ->
 signed32 ((r+d)-(p+d)) /\ (r+d)-(p+d)=r-p.
Proof. unfold physical_translation; intros H.
 rewrite common_translation_difference. tauto. Qed.
Theorem common_translation_trimmed_error (r p d bound:Z) :
 trim bound ((r+d)-(p+d))=trim bound (r-p).
Proof. rewrite common_translation_difference; reflexivity. Qed.
Theorem nonzero_physical_translation_witness :
 exists r p d:Z, physical_translation r p d / d<>0 /\ r-p<>0 /\ r-p=512 /\ r+d=28160 /\ p+d=27648.
Proof. exists 2560,2048,25600.
 unfold physical_translation,signed32; repeat split; lia. Qed.
