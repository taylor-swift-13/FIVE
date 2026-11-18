From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory.
Import ListNotations.
Local Open Scope Z_scope.

(** Complete original GuidanceHRef named state, x86-64 Linux little endian.
    No padding observation and no restriction on floating-point bit patterns. *)
Record state : Type := mkstate {
  accel_x : float32; accel_y : float32;
  speed_x : float32; speed_y : float32;
  pos_x : int64; pos_y : int64;
  tau : float32; omega : float32; zeta : float32; max_speed : float32;
  zeta_omega : float32; omega_2 : float32; inv_tau : float32; dt : float32
}.
Definition repr (s : state) (m : mem) (b : block) : Prop :=
  Mem.load Mfloat32 m b 0 = Some (Vsingle (accel_x s)) /\
  Mem.load Mfloat32 m b 4 = Some (Vsingle (accel_y s)) /\
  Mem.load Mfloat32 m b 8 = Some (Vsingle (speed_x s)) /\
  Mem.load Mfloat32 m b 12 = Some (Vsingle (speed_y s)) /\
  Mem.load Mint64 m b 16 = Some (Vlong (pos_x s)) /\
  Mem.load Mint64 m b 24 = Some (Vlong (pos_y s)) /\
  Mem.load Mfloat32 m b 32 = Some (Vsingle (tau s)) /\
  Mem.load Mfloat32 m b 36 = Some (Vsingle (omega s)) /\
  Mem.load Mfloat32 m b 40 = Some (Vsingle (zeta s)) /\
  Mem.load Mfloat32 m b 44 = Some (Vsingle (max_speed s)) /\
  Mem.load Mfloat32 m b 48 = Some (Vsingle (zeta_omega s)) /\
  Mem.load Mfloat32 m b 52 = Some (Vsingle (omega_2 s)) /\
  Mem.load Mfloat32 m b 56 = Some (Vsingle (inv_tau s)) /\
  Mem.load Mfloat32 m b 60 = Some (Vsingle (dt s)).
Definition writable (m : mem) (b : block) : Prop :=
  Mem.range_perm m b 0 64 Cur Writable.
Definition omega_min : float32 := Float32.of_bits (Int.repr 1036831949).
Definition omega_max : float32 := Float32.of_bits (Int.repr 1084227584).
Definition zeta_min : float32 := Float32.of_bits (Int.repr 1060320051).
Definition zeta_max : float32 := Float32.of_bits (Int.repr 1067030938).
Definition bound (lo hi x : float32) : float32 :=
  if Float32.cmp Cgt x lo then
    if Float32.cmp Clt x hi then x else hi
  else lo.
Definition clamp_omega := bound omega_min omega_max.
Definition clamp_zeta := bound zeta_min zeta_max.
Definition set_omega (s : state) (o : float32) : state :=
  let O := clamp_omega o in
  mkstate (accel_x s) (accel_y s) (speed_x s) (speed_y s)
    (pos_x s) (pos_y s) (tau s) O (zeta s) (max_speed s)
    (Float32.mul (zeta s) O) (Float32.mul O O) (inv_tau s) (dt s).
Definition set_zeta (s : state) (z : float32) : state :=
  let Z := clamp_zeta z in
  mkstate (accel_x s) (accel_y s) (speed_x s) (speed_y s)
    (pos_x s) (pos_y s) (tau s) (omega s) Z (max_speed s)
    (Float32.mul Z (omega s)) (omega_2 s) (inv_tau s) (dt s).
Definition named_bits (s : state) : list val :=
  [Vint (Float32.to_bits (accel_x s)); Vint (Float32.to_bits (accel_y s));
   Vint (Float32.to_bits (speed_x s)); Vint (Float32.to_bits (speed_y s));
   Vlong (pos_x s); Vlong (pos_y s); Vint (Float32.to_bits (tau s));
   Vint (Float32.to_bits (omega s)); Vint (Float32.to_bits (zeta s));
   Vint (Float32.to_bits (max_speed s)); Vint (Float32.to_bits (zeta_omega s));
   Vint (Float32.to_bits (omega_2 s)); Vint (Float32.to_bits (inv_tau s));
   Vint (Float32.to_bits (dt s))].
Lemma setters_commute : forall s o z,
  set_zeta (set_omega s o) z = set_omega (set_zeta s z) o.
Proof. intros []; reflexivity. Qed.
Lemma repr_unique : forall a c m b, repr a m b -> repr c m b -> a=c.
Proof.
 intros [] [] m b A C; unfold repr in *; simpl in *.
 repeat match goal with H : _ /\ _ |- _ => destruct H end.
 repeat match goal with H : ?x = Some _, H1 : ?x = Some _ |- _ =>
   rewrite H in H1; injection H1 as H1; try subst; clear H1
 end.
 reflexivity.
Qed.
Print Assumptions setters_commute.
Print Assumptions repr_unique.
