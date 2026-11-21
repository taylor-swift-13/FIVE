From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Integers Values Memory Memdata Globalenvs Ctypes Csem Smallstep.
From FiveShared.verification Require Import Obligations.
Require PprzTrigPlain.Source PprzTrigPlain.Execution.
Require PprzTrigLow.Source PprzTrigLow.Execution.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import TrigData.
Import ListNotations.
Open Scope Z_scope.

(** Canonical question.  All execution models retain their complete machine
    domain.  This first source theorem selects the same explicit normalized
    angle precondition as CBMC; no analytical sine accuracy claim is made. *)
Definition normalized_angle (a:Int.int) : Prop := -12867 <= Int.signed a <= 12867.
Definition Returns (ge:Csem.genv) (entry:list val->mem->Csem.state)
 (args:list val) (before:mem) (v:val) (after:mem) : Prop :=
 exists t, star Csem.step ge (entry args before) t (Returnstate v Kstop after).
Definition initial_plain (m:mem) : Prop := Genv.init_mem PprzTrigPlain.Source.prog=Some m.
Definition initial_low (m:mem) : Prop := Genv.init_mem PprzTrigInit.Source.prog=Some m.
Definition buffer_symbol (b:block) : Prop :=
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12=Some b.
Definition init_returns (m:mem) (v:val) (m':mem) : Prop :=
 Returns PprzTrigInit.Execution.ge PprzTrigInit.Execution.entry [] m v m'.
Definition packed_state (b:block) (m:mem) : Prop :=
 Mem.loadbytes m b 0 9651=Some (map (fun z=>Byte (Byte.repr z)) expected_bytes).
Definition existing_frame (before after:mem) : Prop :=
 Mem.unchanged_on (fun b _=>Plt b (Mem.nextblock before)) before after.
Definition init_frame (b:block) (before after:mem) : Prop :=
 Mem.unchanged_on (fun b' _=>Plt b' (Mem.nextblock before) /\ b'<>b) before after.

Definition initial_memory_exists : Prop :=
 exists mp ml b, initial_plain mp /\ initial_low ml /\ buffer_symbol b.
Definition initializer_total : Prop := forall ml,
 initial_low ml -> safe_termination PprzTrigInit.Execution.ge
   (PprzTrigInit.Execution.entry [] ml).
Definition initializer_success_and_representation : Prop := forall ml b,
 initial_low ml -> buffer_symbol b ->
 (exists ml', init_returns ml (Vint Int.zero) ml') /\
 (forall v ml', init_returns ml v ml' ->
   v=Vint Int.zero /\ packed_state b ml' /\ init_frame b ml ml').
Definition plain_sine_total_normalized : Prop := forall mp a,
 initial_plain mp -> normalized_angle a ->
 safe_termination PprzTrigPlain.Execution.ge (PprzTrigPlain.Execution.entry [Vint a] mp).
Definition low_sine_total_normalized : Prop := forall ml ml' a,
 initial_low ml -> init_returns ml (Vint Int.zero) ml' -> normalized_angle a ->
 safe_termination PprzTrigLow.Execution.ge (PprzTrigLow.Execution.entry [Vint a] ml').
Definition sine_equivalence_normalized : Prop := forall mp ml ml' a,
 initial_plain mp -> initial_low ml -> init_returns ml (Vint Int.zero) ml' ->
 normalized_angle a ->
 (exists rp mp', Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry [Vint a] mp (Vint rp) mp') /\
 (exists rc mc', Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry [Vint a] ml' (Vint rc) mc') /\
 (forall vp mp' vc mc',
   Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry [Vint a] mp vp mp' ->
   Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry [Vint a] ml' vc mc' ->
   exists r, vp=Vint r /\ vc=Vint r).
Definition sine_frame_normalized : Prop := forall mp ml ml' a,
 initial_plain mp -> initial_low ml -> init_returns ml (Vint Int.zero) ml' ->
 normalized_angle a ->
 (forall v mp', Returns PprzTrigPlain.Execution.ge PprzTrigPlain.Execution.entry [Vint a] mp v mp' -> existing_frame mp mp') /\
 (forall v mc', Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry [Vint a] ml' v mc' -> existing_frame ml' mc').
Definition FullSourceEquivalenceNormalized : Prop :=
 initial_memory_exists /\ initializer_total /\ initializer_success_and_representation /\
 plain_sine_total_normalized /\ low_sine_total_normalized /\
 sine_equivalence_normalized /\ sine_frame_normalized.
