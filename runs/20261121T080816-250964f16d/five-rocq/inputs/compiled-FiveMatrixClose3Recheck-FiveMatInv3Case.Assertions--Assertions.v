From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract Scalar Observer RecheckSupport TraceInputs SequentialReplay.
From FiveMatrixInverseSupport Require Import Kernels.
Require FiveMatInv3Functional.Spec FiveMatInv3Functional.Proof.
Import ListNotations.
Local Open Scope Z_scope.
Definition BaseWords:list Z:=[1065353216;2147483648;0;2147483648;1065353216;2147483648;0;2147483648;1065353216].
Definition LargeWords:list Z:=[0;2147483648;0;2147483648;0;2147483648;0;2147483648;0].
Definition WordBridge:Prop:=forall m src dst mf bytes f,
 Mem.loadbytes m src 0 36=Some bytes->Mem.storebytes m dst 0 bytes=Some mf->
 (forall i,0<=i<9->Mem.loadbytes m src(4*i)4=Some(encode_val Mfloat32(Vsingle(f i))))->
 forall i,0<=i<9->Mem.load Mint32 mf dst(4*i)=Some(Vint(Float32.to_bits(f i))).
Lemma word_bridge:WordBridge.
Proof. exact memcpy_word_observation. Qed.
Definition Assert1:Prop:=forall m bo bi po pi f,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->forall t v mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate v Kstop mf)->v=Vint Int.zero \/v=Vint Int.one.
Lemma assertion1:Assert1.
Proof. intros m bo bi po pi f NE W RD t v mf PATH;destruct(FiveMatInv3Functional.Proof.all_normal_observations m bo bi po pi f NE W RD t v mf PATH)as[-> POST];unfold Status;destruct(Accept f);auto. Qed.
Definition Assert2:Prop:=forall m bo bi po pi f,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 f->forall t v mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate v Kstop mf)->
 Mem.loadbytes mf bo(Ptrofs.unsigned po-4)4=Mem.loadbytes m bo(Ptrofs.unsigned po-4)4 /\
 Mem.loadbytes mf bo(Ptrofs.unsigned po+36)4=Mem.loadbytes m bo(Ptrofs.unsigned po+36)4.
Lemma assertion2:Assert2.
Proof. intros m bo bi po pi f NE W RD t v mf PATH;destruct(FiveMatInv3Functional.Proof.all_normal_observations m bo bi po pi f NE W RD t v mf PATH)as[V[BYTES[FR REST]]].
 split;apply FR;try exact(writable_valid m bo po 9 ltac:(lia)W);[right;left|right;right];lia. Qed.
Definition Assert3:=FixedOutcome base3(Vint Int.zero).
Lemma assertion3:Assert3.
Proof. apply fixed_outcome;exact(proj1 base3_kernel). Qed.
Definition Assert4:Prop:=Assert3 /\words3 base3=map Int.repr BaseWords /\WordBridge.
Lemma assertion4:Assert4.
Proof. split;[exact assertion3|];split;[exact(proj2(proj2 base3_kernel))|exact word_bridge]. Qed.
Definition Assert5:=FixedOutcome small3(Vint Int.one).
Lemma assertion5:Assert5.
Proof. apply fixed_outcome;exact(proj1 small3_kernel). Qed.
Lemma small_rejects:Accept small3=false.
Proof. pose proof(proj1 small3_kernel)as H;unfold Status in H;destruct(Accept small3);[discriminate|reflexivity]. Qed.
Definition Assert6:Prop:=(forall m bo bi po pi,bo<>bi->WriteRegion m bo po 9->Reads m bi pi 9 small3->forall t v mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate v Kstop mf)->
 Mem.loadbytes mf bo(Ptrofs.unsigned po)36=Mem.loadbytes m bo(Ptrofs.unsigned po)36) /\
 (forall m1 b1 m2 b2 bytes z,Mem.loadbytes m1 b1 0 36=Some bytes->Mem.loadbytes m2 b2 0 36=Some bytes->0<=z->z+4<=36->Mem.loadbytes m1 b1 z 4=Mem.loadbytes m2 b2 z 4).
Lemma assertion6:Assert6.
Proof. split;[|exact same_bytes_cell].
 intros m bo bi po pi NE W RD t v mf PATH;destruct(FiveMatInv3Functional.Proof.all_normal_observations m bo bi po pi small3 NE W RD t v mf PATH)as[V[BYTES REST]].
 unfold OutputBytes in BYTES;rewrite small_rejects in BYTES;exact BYTES. Qed.
Definition Assert7:=FixedOutcome large3(Vint Int.zero).
Lemma assertion7:Assert7.
Proof. apply fixed_outcome;exact(proj1 large3_kernel). Qed.
Definition Assert8:Prop:=Assert7 /\words3 large3=map Int.repr LargeWords /\WordBridge.
Lemma assertion8:Assert8.
Proof. split;[exact assertion7|];split;[exact(proj2(proj2 large3_kernel))|exact word_bridge]. Qed.
Definition OriginalReplay:Prop:=CallReplay arbitrary_0 OldArbitrary(Vint Int.one) /\CallReplay arbitrary_1 OldArbitrary(Vint Int.one) /\
 CallReplay base3 OldFixed(Vint Int.zero) /\CallReplay small3 OldFixed(Vint Int.one) /\CallReplay large3 OldFixed(Vint Int.zero).
Definition Refutation9:Prop:=(NonvacuousReplay arbitrary_0 /\NonvacuousReplay arbitrary_1) /\OriginalReplay /\Status base3<>Status small3 /\Assert3 /\Assert5.
Lemma refutation9:Refutation9.
Proof. split;[exact both_original_traces_replayed|];split;[exact original_calls_replay|];split;[exact RefuteScaleStatus3|];split;[exact assertion3|exact assertion5]. Qed.
Definition Refutation10:Prop:=(NonvacuousReplay arbitrary_0 /\NonvacuousReplay arbitrary_1) /\OriginalReplay /\Status large3=Vint Int.zero /\Float32.to_bits(residual3 large3)=Int.repr 3212836864 /\SmallResidual(residual3 large3)=false /\Assert8.
Lemma refutation10:Refutation10.
Proof. split;[exact both_original_traces_replayed|];split;[exact original_calls_replay|];split;[exact(proj1 RefuteLargeResidual3)|];split;[exact large3_residual|];split;[exact(proj2 RefuteLargeResidual3)|exact assertion8]. Qed.
Lemma original_base_input_bits:map(fun i=>Float32.to_bits(base3 i))[0;1;2;3;4;5;6;7;8]=map Int.repr[1065353216;0;0;0;1065353216;0;0;0;1065353216].
Proof. vm_compute;reflexivity. Qed.
Lemma original_small_input_bits:map(fun i=>Float32.to_bits(small3 i))[0;1;2;3;4;5;6;7;8]=map Int.repr[998244352;0;0;0;998244352;0;0;0;998244352].
Proof. vm_compute;reflexivity. Qed.
Lemma original_large_input_bits:map(fun i=>Float32.to_bits(large3 i))[0;1;2;3;4;5;6;7;8]=map Int.repr[1484783616;0;0;0;1484783616;0;0;0;1484783616].
Proof. vm_compute;reflexivity. Qed.
Lemma original_fixed_old_bits:map(fun i=>Float32.to_bits(OldFixed i))[0;1;2;3;4;5;6;7;8]=map Int.repr[1099431936;0;0;0;1099431936;0;0;0;1099431936].
Proof. vm_compute;reflexivity. Qed.
Print Assumptions refutation9.
Print Assumptions refutation10.
Lemma original_trace_0_base3_write_prefix:map(fun ix=>(fst ix,Float32.to_bits(snd ix)))(Outputs base3)=[(0,Int.repr 1065353216);(3,Int.repr 2147483648);(6,Int.repr 0);(1,Int.repr 2147483648);(4,Int.repr 1065353216);(7,Int.repr 2147483648);(2,Int.repr 0);(5,Int.repr 2147483648);(8,Int.repr 1065353216)].
Proof. vm_compute;reflexivity. Qed.
Lemma original_trace_0_large3_write_prefix:map(fun ix=>(fst ix,Float32.to_bits(snd ix)))(Outputs large3)=[(0,Int.repr 0);(3,Int.repr 2147483648);(6,Int.repr 0);(1,Int.repr 2147483648);(4,Int.repr 0);(7,Int.repr 2147483648);(2,Int.repr 0);(5,Int.repr 2147483648);(8,Int.repr 0)].
Proof. vm_compute;reflexivity. Qed.
Lemma original_trace_1_base3_write_prefix:map(fun ix=>(fst ix,Float32.to_bits(snd ix)))(Outputs base3)=[(0,Int.repr 1065353216);(3,Int.repr 2147483648);(6,Int.repr 0);(1,Int.repr 2147483648);(4,Int.repr 1065353216);(7,Int.repr 2147483648);(2,Int.repr 0);(5,Int.repr 2147483648);(8,Int.repr 1065353216)].
Proof. vm_compute;reflexivity. Qed.
Lemma original_trace_1_large3_write_prefix:map(fun ix=>(fst ix,Float32.to_bits(snd ix)))(Outputs large3)=[(0,Int.repr 0);(3,Int.repr 2147483648);(6,Int.repr 0);(1,Int.repr 2147483648);(4,Int.repr 0);(7,Int.repr 2147483648);(2,Int.repr 0);(5,Int.repr 2147483648);(8,Int.repr 0)].
Proof. vm_compute;reflexivity. Qed.
Print Assumptions refutation9.
Print Assumptions refutation10.
