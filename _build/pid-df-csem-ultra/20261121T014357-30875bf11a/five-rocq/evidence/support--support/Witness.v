From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
From FivePidDfCase Require Import PidMemory Contract.
Local Open Scope Z_scope.
Theorem initialized_inhabited:forall a bc c u0 u1 e0 e1 e2:float32,exists m b,Initialized m b Ptrofs.zero a bc c u0 u1 e0 e1 e2.
Proof.
 intros a bc c u0 u1 e0 e1 e2;destruct(Mem.alloc Mem.empty 0 32)as[ma b]eqn:A.
 assert(W:writable32 ma b Ptrofs.zero).
 { unfold writable32;rewrite Ptrofs.unsigned_zero;split;[exists 0;lia|]. split;[change(32<=18446744073709551616);lia|].
 intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|exact R]|constructor]. }
 destruct(field_store ma b Ptrofs.zero 0 u0 W ltac:(unfold field_offsets;simpl;tauto))as[m1 S1].
 assert(W1:writable32 m1 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W|exact S1]).
 destruct(field_store m1 b Ptrofs.zero 4 u1 W1 ltac:(unfold field_offsets;simpl;tauto))as[m2 S2].
 assert(W2:writable32 m2 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W1|exact S2]).
 destruct(field_store m2 b Ptrofs.zero 8 e0 W2 ltac:(unfold field_offsets;simpl;tauto))as[m3 S3].
 assert(W3:writable32 m3 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W2|exact S3]).
 destruct(field_store m3 b Ptrofs.zero 12 e1 W3 ltac:(unfold field_offsets;simpl;tauto))as[m4 S4].
 assert(W4:writable32 m4 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W3|exact S4]).
 destruct(field_store m4 b Ptrofs.zero 16 e2 W4 ltac:(unfold field_offsets;simpl;tauto))as[m5 S5].
 assert(W5:writable32 m5 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W4|exact S5]).
 destruct(field_store m5 b Ptrofs.zero 20 a W5 ltac:(unfold field_offsets;simpl;tauto))as[m6 S6].
 assert(W6:writable32 m6 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W5|exact S6]).
 destruct(field_store m6 b Ptrofs.zero 24 bc W6 ltac:(unfold field_offsets;simpl;tauto))as[m7 S7].
 assert(W7:writable32 m7 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W6|exact S7]).
 destruct(field_store m7 b Ptrofs.zero 28 c W7 ltac:(unfold field_offsets;simpl;tauto))as[m8 S8].
 assert(W8:writable32 m8 b Ptrofs.zero)by(eapply store_preserves_writable32;[exact W7|exact S8]).
 exists m8,b;split;[exact W8|].
 repeat split.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S7||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S6||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S2||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S1;reflexivity.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S7||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S6||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S3||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S2;reflexivity.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S7||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S6||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S4||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S3;reflexivity.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S7||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S6||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S5||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S4;reflexivity.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S7||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S6||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S5;reflexivity.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_other by(exact S7||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S6;reflexivity.
 - erewrite Mem.load_store_other by(exact S8||(cbn[size_chunk];intuition lia)). erewrite Mem.load_store_same by exact S7;reflexivity.
 - erewrite Mem.load_store_same by exact S8;reflexivity.
Qed.
Print Assumptions initialized_inhabited.
