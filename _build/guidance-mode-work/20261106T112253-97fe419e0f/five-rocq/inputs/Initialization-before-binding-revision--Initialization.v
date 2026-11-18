From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Globalenvs Ctypes Csem.
From FivePaparazziState Require Import State MemorySupport.
From FiveGuidanceEntry Require Import Entry.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Require FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition zero_state : State.state :=
 State.mkstate Float32.zero Float32.zero Float32.zero Float32.zero
 Int64.zero Int64.zero Float32.zero Float32.zero Float32.zero Float32.zero
 Float32.zero Float32.zero Float32.zero Float32.zero.
Lemma repeat_from_forall : forall (A:Type)(x:A) xs,
 Forall (eq x) xs -> xs=repeat x (length xs).
Proof. intros A x xs H;induction H;[reflexivity|]. subst x0;simpl;f_equal;exact IHForall. Qed.
Lemma zero_bytes_slice : forall m b ofs n,
 Mem.loadbytes m b 0 64=Some(repeat (Byte Byte.zero) 64%nat) ->
 0<=ofs -> 0<=n -> ofs+n<=64 ->
 Mem.loadbytes m b ofs n=Some(repeat (Byte Byte.zero)(Z.to_nat n)).
Proof.
 intros m b ofs n LD O N HI.
 replace 64 with (ofs+(64-ofs)) in LD by lia.
 destruct(Mem.loadbytes_split m b 0 ofs (64-ofs) _ LD ltac:(lia) ltac:(lia)) as [a[c[A[C EQ]]]].
 replace (0+ofs) with ofs in C by lia.
 replace (64-ofs) with (n+(64-ofs-n)) in C by lia.
 destruct(Mem.loadbytes_split m b ofs n (64-ofs-n) _ C ltac:(lia) ltac:(lia)) as [x[y[X[Y XY]]]].
 assert(ALL:Forall(eq(Byte Byte.zero))(repeat(Byte Byte.zero)64%nat)) by (repeat constructor).
 rewrite EQ in ALL;apply Forall_app in ALL as [_ AC].
 rewrite XY in AC;apply Forall_app in AC as [AX _].
 apply repeat_from_forall in AX.
 pose proof(Mem.loadbytes_length _ _ _ _ _ X)as LEN.
 rewrite LEN in AX;rewrite AX in X;exact X.
Qed.

Module SpeedInit.
Definition global_block : block :=
 match Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_ref with Some b=>b|None=>1%positive end.
Definition maximum_block : block :=
 match Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_max_accel with Some b=>b|None=>1%positive end.
Lemma global_symbol : Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_ref=Some global_block.
Proof. reflexivity. Qed.
Lemma maximum_symbol : Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_max_accel=Some maximum_block.
Proof. reflexivity. Qed.
Lemma distinct_objects : global_block<>maximum_block.
Proof. discriminate. Qed.
Lemma zero_memory : exists m,
 repr zero_state m global_block /\ writable m global_block /\
 Mem.load Mfloat32 m maximum_block 0=Some(Vsingle fixed_maximum).
Proof.
 destruct(Genv.init_mem_exists FiveGhSpeed.Source.prog)as[m INIT].
 { intros id v IN.
   assert(V:v=FiveGhSpeed.Source.v_gh_ref \/ v=FiveGhSpeed.Source.v_gh_max_accel).
   { change(In(id,Gvar v)FiveGhSpeed.Source.global_definitions)in IN.
     simpl in IN;intuition congruence. }
   destruct V as[EQ|EQ];subst v;split.
   all: try (simpl;split;[exists 0;reflexivity|exact I]).
   all: simpl;intros i o [H|H];[discriminate|contradiction]. }
 pose proof(Genv.init_mem_characterization FiveGhSpeed.Source.prog global_block
 (gv:=FiveGhSpeed.Source.v_gh_ref)(m:=m)ltac:(reflexivity)INIT)as[W[_[_ BYTES]]].
 pose proof(Genv.init_mem_characterization FiveGhSpeed.Source.prog maximum_block
 (gv:=FiveGhSpeed.Source.v_gh_max_accel)(m:=m)ltac:(reflexivity)INIT)as[CW[_[_ CBYTES]]].
 assert(B:Mem.loadbytes m global_block 0 64=Some(repeat(Byte Byte.zero)64%nat)).
 { exact(BYTES eq_refl). }
 assert(C:Mem.load Mfloat32 m maximum_block 0=Some(Vsingle fixed_maximum)).
 { pose proof(CBYTES eq_refl)as CB.
   eapply Mem.loadbytes_load with (bytes:=encode_val Mfloat32(Vsingle fixed_maximum)).
   - exact CB.
   - exists 0;reflexivity. }
 exists m;split;[|split;assumption].
 unfold State.repr,zero_state;simpl.
 repeat split;
 match goal with |- Mem.load ?chunk m global_block ?ofs=Some ?v =>
   assert(LD:Mem.loadbytes m global_block ofs(size_chunk chunk)=Some(repeat(Byte Byte.zero)(Z.to_nat(size_chunk chunk))))by(eapply zero_bytes_slice;eauto;cbn;lia);
   pose proof(Mem.loadbytes_load chunk m global_block ofs _ LD ltac:(cbn;match goal with |- (?d | ?n)=>exists(n/d);reflexivity end))as L;exact L
 end.
Qed.
End SpeedInit.

Module AccelInit.
Definition global_block : block :=
 match Genv.find_symbol FiveGhAccel.Execution.ge FiveGhAccel.Source._gh_ref with Some b=>b|None=>1%positive end.
Definition maximum_block : block :=
 match Genv.find_symbol FiveGhAccel.Execution.ge FiveGhAccel.Source._gh_max_accel with Some b=>b|None=>1%positive end.
Lemma global_symbol : Genv.find_symbol FiveGhAccel.Execution.ge FiveGhAccel.Source._gh_ref=Some global_block.
Proof. reflexivity. Qed.
Lemma maximum_symbol : Genv.find_symbol FiveGhAccel.Execution.ge FiveGhAccel.Source._gh_max_accel=Some maximum_block.
Proof. reflexivity. Qed.
Lemma distinct_objects : global_block<>maximum_block.
Proof. discriminate. Qed.
Lemma zero_memory : exists m,
 repr zero_state m global_block /\ writable m global_block /\
 Mem.load Mfloat32 m maximum_block 0=Some(Vsingle fixed_maximum).
Proof.
 destruct(Genv.init_mem_exists FiveGhAccel.Source.prog)as[m INIT].
 { intros id v IN.
   assert(V:v=FiveGhAccel.Source.v_gh_ref \/ v=FiveGhAccel.Source.v_gh_max_accel).
   { change(In(id,Gvar v)FiveGhAccel.Source.global_definitions)in IN.
     simpl in IN;intuition congruence. }
   destruct V as[EQ|EQ];subst v;split.
   all: try (simpl;split;[exists 0;reflexivity|exact I]).
   all: simpl;intros i o [H|H];[discriminate|contradiction]. }
 pose proof(Genv.init_mem_characterization FiveGhAccel.Source.prog global_block
 (gv:=FiveGhAccel.Source.v_gh_ref)(m:=m)ltac:(reflexivity)INIT)as[W[_[_ BYTES]]].
 pose proof(Genv.init_mem_characterization FiveGhAccel.Source.prog maximum_block
 (gv:=FiveGhAccel.Source.v_gh_max_accel)(m:=m)ltac:(reflexivity)INIT)as[CW[_[_ CBYTES]]].
 assert(B:Mem.loadbytes m global_block 0 64=Some(repeat(Byte Byte.zero)64%nat)).
 { exact(BYTES eq_refl). }
 assert(C:Mem.load Mfloat32 m maximum_block 0=Some(Vsingle fixed_maximum)).
 { pose proof(CBYTES eq_refl)as CB.
   eapply Mem.loadbytes_load with (bytes:=encode_val Mfloat32(Vsingle fixed_maximum)).
   - exact CB.
   - exists 0;reflexivity. }
 exists m;split;[|split;assumption].
 unfold State.repr,zero_state;simpl.
 repeat split;
 match goal with |- Mem.load ?chunk m global_block ?ofs=Some ?v =>
   assert(LD:Mem.loadbytes m global_block ofs(size_chunk chunk)=Some(repeat(Byte Byte.zero)(Z.to_nat(size_chunk chunk))))by(eapply zero_bytes_slice;eauto;cbn;lia);
   pose proof(Mem.loadbytes_load chunk m global_block ofs _ LD ltac:(cbn;match goal with |- (?d | ?n)=>exists(n/d);reflexivity end))as L;exact L
 end.
Qed.
End AccelInit.

Definition nontrivial_state : state :=
 mkstate ftwo fzero fone fzero Int64.zero Int64.zero
 fzero fzero fzero fzero fzero fzero ftwo
 (Float32.of_bits(Int.repr 989855744)).
Lemma write_float_keep_maximum : forall s m b bc offset x,
 repr s m b -> writable m b -> b<>bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle fixed_maximum) ->
 In offset float_offsets ->
 exists mf, repr(replace_float s offset x)mf b /\
 writable mf b /\ Mem.load Mfloat32 mf bc 0=Some(Vsingle fixed_maximum).
Proof.
 intros s m b bc offset x R W D C OFF.
 destruct(Mem.valid_access_store m Mfloat32 b offset(Vsingle x)
 (writable_float_access m b offset W OFF))as[mf S].
 exists mf;split;[eapply repr_store_float;eauto|].
 split;[eapply writable_store;eauto|].
 erewrite Mem.load_store_other;[exact C|exact S|left;congruence].
Qed.
Lemma nontrivial_memory : forall m b bc,
 repr zero_state m b -> writable m b -> b<>bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle fixed_maximum) ->
 exists mf,repr nontrivial_state mf b /\ writable mf b /\
 Mem.load Mfloat32 mf bc 0=Some(Vsingle fixed_maximum).
Proof.
 intros m b bc R W D C.
 destruct(write_float_keep_maximum zero_state m b bc 0 ftwo R W D C ltac:(simpl;tauto))as[m1[R1[W1 C1]]].
 destruct(write_float_keep_maximum _ m1 b bc 8 fone R1 W1 D C1 ltac:(simpl;tauto))as[m2[R2[W2 C2]]].
 destruct(write_float_keep_maximum _ m2 b bc 56 ftwo R2 W2 D C2 ltac:(simpl;tauto))as[m3[R3[W3 C3]]].
 destruct(write_float_keep_maximum _ m3 b bc 60 (Float32.of_bits(Int.repr 989855744)) R3 W3 D C3 ltac:(simpl;tauto))as[m4[R4[W4 C4]]].
 exists m4;split;[exact R4|];auto.
Qed.
Lemma nontrivial_safe : integration_safe nontrivial_state.
Proof.
 exists(Int64.repr 268435456),Int64.zero.
 split;[vm_compute;reflexivity|];split;[vm_compute;reflexivity|].
 unfold signed_sum_ok;vm_compute;repeat split;discriminate.
Qed.
Lemma nontrivial_position_advance : pos_increment(speed_x nontrivial_state)(dt nontrivial_state)<>Some Int64.zero.
Proof. vm_compute;discriminate. Qed.
Lemma nontrivial_speed_advance :
 Float32.to_bits(Float32.add(speed_x nontrivial_state)(Float32.mul(accel_x nontrivial_state)(dt nontrivial_state)))<>
 Float32.to_bits(speed_x nontrivial_state).
Proof. vm_compute;discriminate. Qed.
Definition nontrivial_integrated := integrated nontrivial_state(Int64.repr 268435456)Int64.zero.
Lemma nontrivial_integration : integrate nontrivial_state=Some nontrivial_integrated.
Proof.
 assert(X:pos_increment(speed_x nontrivial_state)(dt nontrivial_state)=Some(Int64.repr 268435456))by(vm_compute;reflexivity).
 assert(Y:pos_increment(speed_y nontrivial_state)(dt nontrivial_state)=Some Int64.zero)by(vm_compute;reflexivity).
 unfold integrate;rewrite X,Y;reflexivity.
Qed.
Lemma nontrivial_unsaturated :
 saturation_branch fixed_maximum(raw_speed_accel nontrivial_integrated(vec fone fzero))=false.
Proof. vm_compute;reflexivity. Qed.
Lemma nontrivial_saturated :
 saturation_branch fixed_maximum(raw_speed_accel nontrivial_integrated(vec fhundred fzero))=true.
Proof. vm_compute;reflexivity. Qed.
Print Assumptions nontrivial_memory.
Print Assumptions nontrivial_safe.
