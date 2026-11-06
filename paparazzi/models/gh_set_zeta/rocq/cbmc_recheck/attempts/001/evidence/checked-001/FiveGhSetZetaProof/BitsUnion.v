From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
Local Open Scope Z_scope.
(** Exact union representation adapter used by bits(float): one four-byte
    caller object stores binary32 then reads uint32 from the same bytes. *)
Definition UnionObservation(x:float32)(m:mem):Prop := exists ma b stored,
 Mem.alloc m 0 4=(ma,b) /\ Mem.store Mfloat32 ma b 0(Vsingle x)=Some stored /\
 Mem.loadbytes stored b 0 4=Some(encode_val Mfloat32(Vsingle x)) /\
 Mem.load Mint32 stored b 0=Some(Vint(Float32.to_bits x)).
Theorem union_observation : forall x m,UnionObservation x m.
Proof.
 intros x m;destruct(Mem.alloc m 0 4)as[ma b]eqn:ALLOC.
 assert(A:Mem.valid_access ma Mfloat32 b 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 destruct(Mem.valid_access_store ma Mfloat32 b 0(Vsingle x)(Mem.valid_access_freeable_any _ _ _ _ _ A))as[stored STORE].
 assert(B:Mem.loadbytes stored b 0 4=Some(encode_val Mfloat32(Vsingle x))).
 { change(Mem.loadbytes stored b 0(size_chunk Mfloat32)=Some(encode_val Mfloat32(Vsingle x)));eapply Mem.loadbytes_store_same;exact STORE. }
 exists ma,b,stored;split;[exact ALLOC|]. split;[exact STORE|]. split;[exact B|].
 pose proof(Mem.loadbytes_load Mint32 stored b 0 _ B(ex_intro _ 0 eq_refl))as E.
 pose proof(decode_encode_val_general(Vsingle x)Mfloat32 Mint32)as DE.
 change(decode_val Mint32(encode_val Mfloat32(Vsingle x))=Vint(Float32.to_bits x))in DE.
 rewrite DE in E;exact E.
Qed.
Print Assumptions union_observation.
