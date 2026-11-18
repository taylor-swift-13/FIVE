From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
From FiveLowpassSupport Require Import LowpassMemory.
From FiveLowpassUpdateCase Require Import Contract.
Local Open Scope Z_scope.
Theorem initialized_inhabited:forall tc li lo:float32,exists m b,Initialized m b Ptrofs.zero tc li lo.
Proof.
 intros tc li lo;destruct(Mem.alloc Mem.empty 0 12)as[ma b]eqn:A.
 assert(W:writable12 ma b Ptrofs.zero).
 { unfold writable12;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|]. split;[change(12<=18446744073709551616);lia|].
 intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|exact R]|constructor]. }
 destruct(three_stores_exist ma b Ptrofs.zero tc li lo W)as[mf[m1[m2[S0[S4 S8]]]]].
 exists mf,b;split.
 - eapply store_preserves_writable12;[|exact S8]. eapply store_preserves_writable12;[|exact S4]. eapply store_preserves_writable12;[exact W|exact S0].
 - split.
 + erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S0;reflexivity.
 + split.
 * erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S4;reflexivity.
 * erewrite Mem.load_store_same by exact S8;reflexivity.
Qed.
Print Assumptions initialized_inhabited.
