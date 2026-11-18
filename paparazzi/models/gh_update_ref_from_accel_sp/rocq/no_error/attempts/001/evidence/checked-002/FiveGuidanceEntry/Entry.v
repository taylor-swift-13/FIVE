From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory.
From FivePaparazziState Require Import State MemorySupport.
From FiveGuidanceEntry Require Import SoftwareSqrt.
Local Open Scope Z_scope.

(** Source-order denotation of the two unchanged integration prefixes.
    The fixed-point macro multiplies in binary32, then converts to signed64. *)
Record vector : Type := vec { vx : float32; vy : float32 }.
Definition norm2 (v : vector) : float32 :=
 Float32.add (Float32.mul (vx v) (vx v)) (Float32.mul (vy v) (vy v)).
Definition sqrt_binding : float32->float32 := software_sqrt.
Definition saturation_branch (maximum : float32) (v : vector) : bool :=
 Float32.cmp Cgt (norm2 v) (Float32.mul maximum maximum).
Definition saturate_using (sqrt32 : float32->float32) (maximum : float32) (v : vector) : vector :=
 if saturation_branch maximum v then
   let factor := Float32.div maximum (sqrt32 (norm2 v)) in
   vec (Float32.mul (vx v) factor) (Float32.mul (vy v) factor)
 else v.
Definition saturate : float32->vector->vector := saturate_using software_sqrt.
Definition q37 : float32 := Float32.of_long (Int64.repr 137438953472).
Definition pos_increment (speed timestep : float32) : option int64 :=
 Float32.to_long (Float32.mul (Float32.mul speed timestep) q37).
Definition signed_sum_ok (x y : int64) : Prop :=
 Int64.min_signed <= Int64.signed x + Int64.signed y <= Int64.max_signed.
Definition integration_safe (s : state) : Prop :=
 exists dx dy, pos_increment (speed_x s) (dt s)=Some dx /\
 pos_increment (speed_y s) (dt s)=Some dy /\
 signed_sum_ok (pos_x s) dx /\ signed_sum_ok (pos_y s) dy.
Definition integrated (s : state) (dx dy : int64) : state :=
 mkstate (accel_x s) (accel_y s)
  (Float32.add (speed_x s) (Float32.mul (accel_x s) (dt s)))
  (Float32.add (speed_y s) (Float32.mul (accel_y s) (dt s)))
  (Int64.add (pos_x s) dx) (Int64.add (pos_y s) dy)
  (tau s) (omega s) (zeta s) (max_speed s)
  (zeta_omega s) (omega_2 s) (inv_tau s) (dt s).
Definition integrate (s : state) : option state :=
 match pos_increment (speed_x s) (dt s), pos_increment (speed_y s) (dt s) with
 | Some dx, Some dy => Some (integrated s dx dy)
 | _,_ => None
 end.
Definition with_accel (s : state) (a : vector) : state :=
 mkstate (vx a) (vy a) (speed_x s) (speed_y s) (pos_x s) (pos_y s)
  (tau s) (omega s) (zeta s) (max_speed s)
  (zeta_omega s) (omega_2 s) (inv_tau s) (dt s).
Definition raw_speed_accel (s : state) (sp : vector) : vector :=
 vec (Float32.mul (Float32.sub (speed_x s) (vx sp)) (Float32.neg (inv_tau s)))
     (Float32.mul (Float32.sub (speed_y s) (vy sp)) (Float32.neg (inv_tau s))).
Definition speed_update (maximum : float32) (s : state) (sp : vector) : option state :=
 match integrate s with
 | Some si => Some (with_accel si (saturate maximum (raw_speed_accel si sp)))
 | None => None
 end.
Definition accel_update (maximum : float32) (s : state) (sp : vector) : option state :=
 match integrate s with
 | Some si => Some (with_accel si (saturate maximum sp))
 | None => None
 end.

Lemma integrate_safe_exists : forall s, integration_safe s -> exists si, integrate s=Some si.
Proof.
 intros s (dx & dy & X & Y & SX & SY); unfold integrate; rewrite X,Y; eauto.
Qed.
Lemma speed_update_safe_exists : forall maximum s sp,
 integration_safe s -> exists sf, speed_update maximum s sp=Some sf.
Proof.
 intros maximum s sp H; destruct (integrate_safe_exists s H) as [si SI].
 unfold speed_update; rewrite SI; eauto.
Qed.
Lemma accel_update_safe_exists : forall maximum s sp,
 integration_safe s -> exists sf, accel_update maximum s sp=Some sf.
Proof.
 intros maximum s sp H; destruct (integrate_safe_exists s H) as [si SI].
 unfold accel_update; rewrite SI; eauto.
Qed.
Definition config (s : state) :=
 (tau s, omega s, zeta s, max_speed s, zeta_omega s, omega_2 s, inv_tau s, dt s).
Lemma speed_update_preserves_config : forall maximum s sp sf,
 speed_update maximum s sp=Some sf -> config sf=config s.
Proof.
 intros maximum s sp sf H; unfold speed_update, integrate in H.
 destruct (pos_increment (speed_x s) (dt s)); try discriminate.
 destruct (pos_increment (speed_y s) (dt s)); try discriminate.
 injection H as <-; reflexivity.
Qed.
Lemma accel_update_preserves_config : forall maximum s sp sf,
 accel_update maximum s sp=Some sf -> config sf=config s.
Proof.
 intros maximum s sp sf H; unfold accel_update, integrate in H.
 destruct (pos_increment (speed_x s) (dt s)); try discriminate.
 destruct (pos_increment (speed_y s) (dt s)); try discriminate.
 injection H as <-; reflexivity.
Qed.
Lemma speed_source_order : forall maximum s sp dx dy,
 pos_increment (speed_x s) (dt s)=Some dx ->
 pos_increment (speed_y s) (dt s)=Some dy ->
 speed_update maximum s sp =
 Some (with_accel (integrated s dx dy)
 (saturate maximum (raw_speed_accel (integrated s dx dy) sp))).
Proof. intros; unfold speed_update,integrate; rewrite H,H0; reflexivity. Qed.
Lemma accel_source_order : forall maximum s sp dx dy,
 pos_increment (speed_x s) (dt s)=Some dx ->
 pos_increment (speed_y s) (dt s)=Some dy ->
 accel_update maximum s sp =
 Some (with_accel (integrated s dx dy) (saturate maximum sp)).
Proof. intros; unfold accel_update,integrate; rewrite H,H0; reflexivity. Qed.

(** Necessary memory support for the two real signed64 position stores. *)
Definition replace_long (s : state) (offset : Z) (x : int64) : state :=
 mkstate (accel_x s) (accel_y s) (speed_x s) (speed_y s)
 (if Z.eqb offset 16 then x else pos_x s)
 (if Z.eqb offset 24 then x else pos_y s)
 (tau s) (omega s) (zeta s) (max_speed s)
 (zeta_omega s) (omega_2 s) (inv_tau s) (dt s).
Lemma writable_long_access : forall m b offset,
 writable m b -> (offset=16 \/ offset=24) ->
 Mem.valid_access m Mint64 b offset Writable.
Proof.
 intros m b offset W OFF; unfold Mem.valid_access; split.
 - intros ofs RNG; apply W; destruct OFF; subst; cbn in *; lia.
 - destruct OFF; subst; match goal with |- (?d | ?n) => exists (n/d); reflexivity end.
Qed.
Lemma repr_store_long : forall s m b offset x mf,
 repr s m b -> (offset=16 \/ offset=24) ->
 Mem.store Mint64 m b offset (Vlong x)=Some mf ->
 repr (replace_long s offset x) mf b.
Proof.
 intros s m b offset x mf R OFF S; unfold repr in R.
 repeat match goal with H : _ /\ _ |- _ => destruct H end.
 destruct OFF; subst offset; unfold repr, replace_long; simpl; repeat split;
 first [erewrite Mem.load_store_same by exact S; reflexivity |
        erewrite Mem.load_store_other by (exact S || (right; cbn; lia)); assumption].
Qed.
Lemma writable_store_long : forall m b offset x mf,
 writable m b -> Mem.store Mint64 m b offset (Vlong x)=Some mf -> writable mf b.
Proof. intros m b offset x mf W S ofs RNG; eapply Mem.perm_store_1; eauto. Qed.
Print Assumptions integrate_safe_exists.
Print Assumptions speed_source_order.
Print Assumptions repr_store_long.

(** Two genuinely different branch witnesses, with nonempty cast-safe domains. *)
Definition fixed_maximum : float32 := Float32.of_bits (Int.repr 1085611704).
Definition fzero : float32 := Float32.of_bits Int.zero.
Definition fone : float32 := Float32.of_bits (Int.repr 1065353216).
Definition ftwo : float32 := Float32.of_bits (Int.repr 1073741824).
Definition fhundred : float32 := Float32.of_bits (Int.repr 1120403456).
Definition sample_state : state :=
 mkstate fzero fzero fzero fzero Int64.zero Int64.zero
 fzero fzero fzero fzero fzero fzero ftwo
 (Float32.of_bits (Int.repr 989855744)).
Lemma float32_bits_inj : forall a b, Float32.to_bits a=Float32.to_bits b -> a=b.
Proof. intros a b H; rewrite <- (Float32.of_to_bits a), <- (Float32.of_to_bits b); rewrite H; reflexivity. Qed.
Lemma fixed_maximum_initializer :
 fixed_maximum = Float.to_single (Float.of_bits (Int64.repr 4618058611900117156)).
Proof. apply float32_bits_inj; vm_compute; reflexivity. Qed.
Lemma sample_integration_safe : integration_safe sample_state.
Proof.
 exists Int64.zero,Int64.zero; split; [vm_compute; reflexivity|].
 split; [vm_compute; reflexivity|].
 unfold signed_sum_ok; vm_compute; split; split; discriminate.
Qed.
Lemma sample_integrate : integrate sample_state=Some sample_state.
Proof. vm_compute; reflexivity. Qed.
Lemma speed_unsaturated_branch :
 saturation_branch fixed_maximum
 (raw_speed_accel sample_state (vec fone fone))=false.
Proof. vm_compute; reflexivity. Qed.
Lemma speed_saturated_branch :
 saturation_branch fixed_maximum
 (raw_speed_accel sample_state (vec fhundred fhundred))=true.
Proof. vm_compute; reflexivity. Qed.
Lemma accel_unsaturated_branch :
 saturation_branch fixed_maximum (vec fone fone)=false.
Proof. vm_compute; reflexivity. Qed.
Lemma accel_saturated_branch :
 saturation_branch fixed_maximum (vec fhundred fhundred)=true.
Proof. vm_compute; reflexivity. Qed.
Lemma matching_accel_after_integration : forall maximum s si sp,
 integrate s=Some si ->
 speed_update maximum s sp = accel_update maximum s (raw_speed_accel si sp).
Proof. intros maximum s si sp SI; unfold speed_update,accel_update; rewrite SI; reflexivity. Qed.
Print Assumptions sample_integration_safe.
Print Assumptions speed_saturated_branch.
Print Assumptions matching_accel_after_integration.
