From Stdlib Require Import List ZArith.
From compcert Require Import Integers.
From StateSpeedMemory Require Import MemoryLayout Protocol SourceComparison Refutations.
From StateSpeedRelationProblem Require Import Spec.
Theorem proved_actual_protocol:Spec.ActualProtocolGoal.
Proof. split;[exact MemoryLayout.actual_state_interface_layout|exact SourceComparison.actual_protocol]. Qed.
Theorem proved_read_after_write_refutation:Spec.ReadAfterWriteRefutationGoal.
Proof.
 destruct Refutations.paired_counterexample as[w[A B]];exists w;rewrite A,B;unfold expected_bits;split;discriminate.
Qed.
Theorem proved_history_independence_refutation:Spec.HistoryIndependenceRefutationGoal.
Proof.
 destruct Refutations.paired_counterexample as[w[A B]];exists w;rewrite A,B;discriminate.
Qed.
Print Assumptions proved_actual_protocol.
Print Assumptions proved_read_after_write_refutation.
Print Assumptions proved_history_independence_refutation.
