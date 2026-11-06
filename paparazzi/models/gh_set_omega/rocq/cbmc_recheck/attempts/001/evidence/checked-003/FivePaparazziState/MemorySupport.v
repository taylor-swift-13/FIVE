From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory.
From FivePaparazziState Require Import State.
Import ListNotations.
Local Open Scope Z_scope.
Definition float_offsets : list Z := [0;4;8;12;32;36;40;44;48;52;56;60].
Definition replace_float (s : state) (offset : Z) (x : float32) : state :=
 mkstate
 (if Z.eqb offset 0 then x else accel_x s)
 (if Z.eqb offset 4 then x else accel_y s)
 (if Z.eqb offset 8 then x else speed_x s)
 (if Z.eqb offset 12 then x else speed_y s)
 (pos_x s) (pos_y s)
 (if Z.eqb offset 32 then x else tau s)
 (if Z.eqb offset 36 then x else omega s)
 (if Z.eqb offset 40 then x else zeta s)
 (if Z.eqb offset 44 then x else max_speed s)
 (if Z.eqb offset 48 then x else zeta_omega s)
 (if Z.eqb offset 52 then x else omega_2 s)
 (if Z.eqb offset 56 then x else inv_tau s)
 (if Z.eqb offset 60 then x else dt s).
Lemma writable_float_access : forall m b offset,
 writable m b -> In offset float_offsets ->
 Mem.valid_access m Mfloat32 b offset Writable.
Proof.
 intros m b offset W OFF. unfold float_offsets in OFF; simpl in OFF.
 unfold Mem.valid_access; split.
 - intros ofs RNG; apply W; repeat match goal with H : _ \/ _ |- _ => destruct H as [H|H] end; try contradiction; subst offset; cbn in *; lia.
 - repeat match goal with H : _ \/ _ |- _ => destruct H as [H|H] end; try contradiction; subst offset; match goal with |- (?d | ?n) => exists (n/d); reflexivity end.
Qed.
Lemma writable_store : forall m b offset x mf,
 writable m b -> Mem.store Mfloat32 m b offset (Vsingle x)=Some mf ->
 writable mf b.
Proof.
 intros m b offset x mf W S ofs RNG.
 eapply Mem.perm_store_1; eauto.
Qed.
Lemma repr_store_float : forall s m b offset x mf,
 repr s m b -> In offset float_offsets ->
 Mem.store Mfloat32 m b offset (Vsingle x)=Some mf ->
 repr (replace_float s offset x) mf b.
Proof.
 intros s m b offset x mf R OFF S.
 unfold repr in R; repeat match goal with H : _ /\ _ |- _ => destruct H end.
 unfold float_offsets in OFF; simpl in OFF.
 repeat match goal with H : _ \/ _ |- _ => destruct H as [H|H] end; try contradiction; subst offset;
 unfold repr, replace_float; simpl; repeat split;
 first [erewrite Mem.load_store_same by exact S; reflexivity |
        erewrite Mem.load_store_other by (exact S || (right; cbn; lia)); assumption].
Qed.
Print Assumptions repr_store_float.

Lemma repr_alloc : forall s m b lo hi ma fresh,
 repr s m b -> Mem.alloc m lo hi=(ma,fresh) -> repr s ma b.
Proof.
 intros s m b lo hi ma fresh R A; unfold repr in *;
 repeat match goal with H : _ /\ _ |- _ => destruct H end;
 repeat split; eapply Mem.load_alloc_other; eauto.
Qed.
Lemma writable_alloc : forall m b lo hi ma fresh,
 writable m b -> Mem.alloc m lo hi=(ma,fresh) -> writable ma b.
Proof.
 intros m b lo hi ma fresh W A ofs RNG; eapply Mem.perm_alloc_1; eauto.
Qed.
Lemma repr_store_other : forall s m b chunk other offset v mf,
 repr s m b -> b<>other -> Mem.store chunk m other offset v=Some mf -> repr s mf b.
Proof.
 intros s m b chunk other offset v mf R D S; unfold repr in *;
 repeat match goal with H : _ /\ _ |- _ => destruct H end;
 repeat split; erewrite Mem.load_store_other by (exact S || (left; exact D)); assumption.
Qed.
Lemma writable_store_other : forall m b chunk other offset v mf,
 writable m b -> Mem.store chunk m other offset v=Some mf -> writable mf b.
Proof.
 intros m b chunk other offset v mf W S ofs RNG; eapply Mem.perm_store_1; eauto.
Qed.
Lemma repr_free_other : forall s m b other lo hi mf,
 repr s m b -> b<>other -> Mem.free m other lo hi=Some mf -> repr s mf b.
Proof.
 intros s m b other lo hi mf R D F; unfold repr in *;
 repeat match goal with H : _ /\ _ |- _ => destruct H end;
 repeat split; erewrite Mem.load_free by (exact F || (left; exact D)); assumption.
Qed.
Lemma writable_free_other : forall m b other lo hi mf,
 writable m b -> b<>other -> Mem.free m other lo hi=Some mf -> writable mf b.
Proof.
 intros m b other lo hi mf W D F ofs RNG; eapply Mem.perm_free_1; eauto.
Qed.
Print Assumptions repr_free_other.
