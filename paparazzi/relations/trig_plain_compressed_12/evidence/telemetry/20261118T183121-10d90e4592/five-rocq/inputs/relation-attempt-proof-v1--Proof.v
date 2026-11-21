From Stdlib Require Import List.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitialMemory.
Theorem initial_memories : initial_memory_exists.
Proof.
 destruct plain_init_mem_exists as [mp MP].
 destruct compressed_init_mem_exists as [ml ML].
 destruct buffer_symbol_info_exists as [b [BS BV]].
 exists mp,ml,b;split;[exact MP|]. split;[exact ML|exact BS].
Qed.
Print Assumptions initial_memories.
