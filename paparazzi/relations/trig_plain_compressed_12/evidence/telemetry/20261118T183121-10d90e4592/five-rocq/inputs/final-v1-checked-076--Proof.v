From Stdlib Require Import List.
From compcert Require Import Integers Values.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitialMemory PlainClosed LowClosed InitComplete.
Import ListNotations.
Theorem initial_memories : Spec.initial_memory_exists.
Proof.
 destruct plain_init_mem_exists as [mp MP].
 destruct compressed_init_mem_exists as [ml ML].
 destruct buffer_symbol_info_exists as [b [BS BV]].
 exists mp,ml,b;split;[exact MP|]. split;[exact ML|exact BS].
Qed.
Theorem initializer_total : Spec.initializer_total.
Proof. exact InitComplete.initializer_total_proved. Qed.
Theorem initializer_representation : Spec.initializer_success_and_representation.
Proof. exact InitComplete.initializer_representation_proved. Qed.
Theorem plain_sine_total : Spec.plain_sine_total_normalized.
Proof. exact PlainClosed.plain_sine_total_normalized_proved. Qed.
Theorem low_sine_total : Spec.low_sine_total_normalized.
Proof.
 intros ml ml' a INIT RETURN RANGE.
 destruct buffer_symbol_info_exists as[b[SYM INFO]].
 eapply LowClosed.low_total_from_packed;[exact RANGE|exact(InitComplete.low_buffer_symbol b SYM)|].
 exact(InitComplete.initialized_packed ml ml' b INIT SYM RETURN).
Qed.
Theorem sine_equivalence : Spec.sine_equivalence_normalized.
Proof.
 intros mp ml ml' a PLAIN LOW RETURN RANGE.
 destruct buffer_symbol_info_exists as[b[SYM INFO]].
 pose proof(InitComplete.initialized_packed ml ml' b LOW SYM RETURN)as PACKED.
 pose proof(InitComplete.low_buffer_symbol b SYM)as SYMBOL.
 split.
 - destruct(PlainClosed.plain_returns_initialized mp a PLAIN RANGE)as[mf PATH].
   exists(PlainClosed.literal_result a),mf;exact PATH.
 - split.
   + destruct(LowClosed.low_returns_packed ml' b a RANGE SYMBOL PACKED)as[mf PATH].
     exists(PlainClosed.literal_result a),mf;exact PATH.
   + intros vp mp' vc mc' PR LR.
     pose proof(PlainClosed.plain_normal_returns_value_and_frame mp a vp mp' PLAIN RANGE PR)as[PV PF].
     pose proof(LowClosed.low_normal_returns_value_and_frame ml' b a vc mc' RANGE SYMBOL PACKED LR)as[LV LF].
     exists(PlainClosed.literal_result a);auto.
Qed.
Theorem sine_frame : Spec.sine_frame_normalized.
Proof.
 intros mp ml ml' a PLAIN LOW RETURN RANGE.
 destruct buffer_symbol_info_exists as[b[SYM INFO]].
 pose proof(InitComplete.initialized_packed ml ml' b LOW SYM RETURN)as PACKED.
 pose proof(InitComplete.low_buffer_symbol b SYM)as SYMBOL.
 split;intros v mf PATH.
 - exact(proj2(PlainClosed.plain_normal_returns_value_and_frame mp a v mf PLAIN RANGE PATH)).
 - exact(proj2(LowClosed.low_normal_returns_value_and_frame ml' b a v mf RANGE SYMBOL PACKED PATH)).
Qed.
Theorem full_source_equivalence : Spec.FullSourceEquivalenceNormalized.
Proof.
 split;[exact initial_memories|]. split;[exact initializer_total|].
 split;[exact initializer_representation|]. split;[exact plain_sine_total|].
 split;[exact low_sine_total|]. split;[exact sine_equivalence|exact sine_frame].
Qed.
Print Assumptions initial_memories.
Print Assumptions initializer_total.
Print Assumptions initializer_representation.
Print Assumptions plain_sine_total.
Print Assumptions low_sine_total.
Print Assumptions sine_equivalence.
Print Assumptions sine_frame.
Print Assumptions full_source_equivalence.
