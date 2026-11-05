Require Import FiveSum3Proof.SourceInvariant.
Require Import FiveSum3Proof.RecheckSpec.
Require Import FiveSum3Proof.Proof.
Definition goal_0 : FiveSum3Proof.RecheckSpec.ResultBitsGoal := FiveSum3Proof.Proof.sum3_cbmc_result_bits.
Print Assumptions goal_0.
Definition goal_1 : FiveSum3Proof.RecheckSpec.FullHarnessGoal := FiveSum3Proof.Proof.full_harness_observation.
Print Assumptions goal_1.
Definition goal_2 : forall m (a b c:Floats.float32), exists br bb mf v, FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v := FiveSum3Proof.Proof.harness_prefix_exists.
Print Assumptions goal_2.
Definition goal_3 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ (((True /\ ~(bb <> br)) -> False)) := FiveSum3Proof.Proof.cbmc_memcpy_pointer_1.
Print Assumptions goal_3.
Definition goal_4 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ (((True /\ ~(bb <> br)) -> Memory.Mem.valid_pointer stored br (BinNums.Z0) = true)) := FiveSum3Proof.Proof.cbmc_memcpy_pointer_arithmetic_1.
Print Assumptions goal_4.
Definition goal_5 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ (((True /\ ~(bb <> br)) -> Memory.Mem.weak_valid_pointer stored bb (BinNums.Zpos (BinNums.xO (BinNums.xO BinNums.xH))) = true)) := FiveSum3Proof.Proof.cbmc_memcpy_pointer_arithmetic_2.
Print Assumptions goal_5.
Definition goal_6 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ ((~(bb <> br \/ order1) -> False)) := FiveSum3Proof.Proof.cbmc_memcpy_pointer_2.
Print Assumptions goal_6.
Definition goal_7 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ ((~(bb <> br \/ order1) -> Memory.Mem.valid_pointer stored bb (BinNums.Z0) = true)) := FiveSum3Proof.Proof.cbmc_memcpy_pointer_arithmetic_3.
Print Assumptions goal_7.
Definition goal_8 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ ((~(bb <> br \/ order1) -> Memory.Mem.weak_valid_pointer stored br (BinNums.Zpos (BinNums.xO (BinNums.xO BinNums.xH))) = true)) := FiveSum3Proof.Proof.cbmc_memcpy_pointer_arithmetic_4.
Print Assumptions goal_8.
Definition goal_9 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ (((bb <> br \/ order1) \/ order2)) := FiveSum3Proof.Proof.cbmc_main_precondition_instance_1.
Print Assumptions goal_9.
Definition goal_10 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ (Memory.Mem.range_perm stored br (BinNums.Z0) (BinNums.Zpos (BinNums.xO (BinNums.xO BinNums.xH))) Memtype.Cur Memtype.Readable) := FiveSum3Proof.Proof.cbmc_main_precondition_instance_2.
Print Assumptions goal_10.
Definition goal_11 : forall m (a b c:Floats.float32) br bb mf v (order1 order2:Prop), FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v = Some stored /\ (Memory.Mem.range_perm stored bb (BinNums.Z0) (BinNums.Zpos (BinNums.xO (BinNums.xO BinNums.xH))) Memtype.Cur Memtype.Writable) := FiveSum3Proof.Proof.cbmc_main_precondition_instance_3.
Print Assumptions goal_11.
Definition goal_12 : forall m (a b c:Floats.float32) br bb mf v, FiveSum3Proof.RecheckSpec.HarnessPrefix m a b c br bb mf v -> FiveSum3Proof.RecheckSpec.ByteObservation br bb mf v /\ exists stored, Memory.Mem.store AST.Mfloat32 mf br (BinNums.Z0) v=Some stored /\ forall copied t ret, Events.extcall_memcpy_sem (BinNums.Zpos (BinNums.xO (BinNums.xO BinNums.xH))) (BinNums.Zpos BinNums.xH) (Globalenvs.Genv.to_senv (Csem.genv_genv FiveSum3Proof.SourceInvariant.sum3_ge)) (Datatypes.cons (Values.Vptr bb Integers.Ptrofs.zero) (Datatypes.cons (Values.Vptr br Integers.Ptrofs.zero) Datatypes.nil)) stored t ret copied -> Memory.Mem.load AST.Mint32 copied bb (BinNums.Z0)=Some(Values.Vint Integers.Int.zero) /\ Smallstep.star Csem.step FiveSum3Proof.SourceInvariant.sum3_ge (Csem.ExprState FiveSum3Proof.SourceInvariant.sum3_function FiveSum3Proof.RecheckSpec.bits_assertion Csem.Kstop(FiveSum3Proof.RecheckSpec.bits_env bb)copied) Events.E0 (Csem.ExprState FiveSum3Proof.SourceInvariant.sum3_function(Csyntax.Eval(Values.Vint Integers.Int.one)Ctypesdefs.tint)Csem.Kstop(FiveSum3Proof.RecheckSpec.bits_env bb)copied) := FiveSum3Proof.Proof.cbmc_main_assertion_1.
Print Assumptions goal_12.
