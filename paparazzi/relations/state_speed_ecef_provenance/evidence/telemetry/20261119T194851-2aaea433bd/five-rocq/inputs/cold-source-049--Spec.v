From Stdlib Require Import ZArith.
From compcert Require Import Integers Memory Memdata.
From StateSpeedMemory Require Import MemoryLayout Protocol.
Open Scope Z_scope.
Definition ActualProtocolGoal:Prop:=
 (MemoryLayout.state_layout MemoryLayout.ce_N /\MemoryLayout.state_layout MemoryLayout.ce_E /\MemoryLayout.state_layout MemoryLayout.ce) /\ forall m sb ns es nx ny nz ex ey ez,ProtocolInput m sb ns es nx ny nz ex ey ez->
 exists mn me mf,ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez /\observe_bits mf sb=Some(bits_of nx ny nz).
Definition ReadAfterWriteRefutationGoal:Prop:=exists w:WitnessPair,
 observe_bits(witness_mfa w)(witness_sb w)<>Some expected_bits /\observe_bits(witness_mfb w)(witness_sb w)<>Some expected_bits.
Definition HistoryIndependenceRefutationGoal:Prop:=exists w:WitnessPair,
 observe_bits(witness_mfa w)(witness_sb w)<>observe_bits(witness_mfb w)(witness_sb w).
