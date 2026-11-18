From Stdlib Require Import Lia.
From FivePaparazziState Require Import State.
From FiveGuidanceCbmcAdapters Require Import NumericGuards MemoryGuards ByteAssertions ActualPointerSites CanonicalCalls.

(** The numeric casts are checked at their actual source-order products under
    the frozen harness controls; the wide entry natural domain is unchanged. *)
Definition CanonicalCastLink:Prop:=forall s,
 CanonicalCalls.CanonicalControls s->NumericGuards.canonical_cast_controls s.
Definition entry_guard_id(n:nat):Prop:=NumericGuards.entry_guard_id n /\CanonicalCastLink.
Definition main_guard_id(n:nat):Prop:=NumericGuards.main_guard_id n /\CanonicalCastLink.
Theorem entry_guards:forall n,(1<=n<=4)%nat->entry_guard_id n.
Proof. intros n B;split;[apply NumericGuards.entry_guards;exact B|exact CanonicalCalls.canonical_controls_match_cast_scope]. Qed.
Theorem main_guards:forall n,(1<=n<=16)%nat->main_guard_id n.
Proof. intros n B;split;[apply NumericGuards.main_guards;exact B|exact CanonicalCalls.canonical_controls_match_cast_scope]. Qed.

(** Every pointer ID retains its field offset guard and real entry-to-helper
    allocation/read/factor/scale-site packets for both generated models. *)
Definition saturation_pointer_guard_id(n:nat):Prop:=
 MemoryGuards.saturation_pointer_guard_id n /\
 ActualPointerSites.Speed.ActualSites /\ActualPointerSites.Accel.ActualSites.
Theorem saturation_pointer_guards:forall n,(1<=n<=24)%nat->saturation_pointer_guard_id n.
Proof. intros n B;split;[apply MemoryGuards.saturation_pointer_guards;exact B|];split;[exact ActualPointerSites.Speed.actual_sites|exact ActualPointerSites.Accel.actual_sites]. Qed.

Definition memcpy_guard_id:=MemoryGuards.memcpy_guard_id.
Definition bits_guard_id:=MemoryGuards.bits_guard_id.
Theorem memcpy_guards:forall n,(1<=n<=8)%nat->memcpy_guard_id n.
Proof. exact MemoryGuards.memcpy_guards. Qed.
Theorem bits_guards:forall n,(1<=n<=3)%nat->bits_guard_id n.
Proof. exact MemoryGuards.bits_guards. Qed.

(** These are the byte/C-integer strengthened predicates, including sequential
    eight-parameter tests with preserved global memory, not bare float bits. *)
Definition manual_speed_id:=ByteAssertions.manual_speed_id.
Definition manual_accel_id:=ByteAssertions.manual_accel_id.
Theorem manual_speed_assertions:forall n,(1<=n<=14)%nat->manual_speed_id n.
Proof. exact ByteAssertions.manual_speed_assertions. Qed.
Theorem manual_accel_assertions:forall n,(1<=n<=14)%nat->manual_accel_id n.
Proof. exact ByteAssertions.manual_accel_assertions. Qed.
Print Assumptions entry_guards.
Print Assumptions main_guards.
Print Assumptions saturation_pointer_guards.
Print Assumptions memcpy_guards.
Print Assumptions bits_guards.
Print Assumptions manual_speed_assertions.
Print Assumptions manual_accel_assertions.
