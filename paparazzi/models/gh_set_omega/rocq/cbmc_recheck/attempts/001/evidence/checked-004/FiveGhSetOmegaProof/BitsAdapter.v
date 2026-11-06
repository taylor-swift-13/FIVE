From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csem.
Import ListNotations.
Local Open Scope Z_scope.
Record MemcpySafety (m:mem) (br bb:block) : Prop := {
 separated : br<>bb;
 src_live : Mem.valid_pointer m br 0=true;
 dst_end_live : Mem.weak_valid_pointer m bb 4=true;
 separated_rev : bb<>br;
 dst_live : Mem.valid_pointer m bb 0=true;
 src_end_live : Mem.weak_valid_pointer m br 4=true;
 nonoverlap : br<>bb \/ 0+4<=0 \/ 0+4<=0;
 src_readable : Mem.range_perm m br 0 4 Cur Readable;
 dst_writable : Mem.range_perm m bb 0 4 Cur Writable
}.
Lemma access_safety : forall m br bb,
 br<>bb -> Mem.valid_access m Mfloat32 br 0 Freeable ->
 Mem.valid_access m Mint32 bb 0 Freeable -> MemcpySafety m br bb.
Proof.
 intros m br bb DIFF [RP RA][BP BA]. 
 assert(R:Mem.range_perm m br 0 4 Cur Readable).
 { eapply Mem.range_perm_implies;[exact RP|constructor].  }
 assert(B:Mem.range_perm m bb 0 4 Cur Writable).
 { eapply Mem.range_perm_implies;[exact BP|constructor].  }
 constructor;auto.
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply R;lia|constructor]. 
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply B;change(0<=4-1<4);lia|constructor]. 
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply B;lia|constructor]. 
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply R;change(0<=4-1<4);lia|constructor]. 
Qed.


Definition BitsObservation (ge:genv)(x:float32)(m:mem) : Prop :=
 exists ma br mb bb stored copied bytes,
 Mem.alloc m 0 4=(ma,br) /\ Mem.alloc ma 0 4=(mb,bb) /\
 Mem.store Mfloat32 mb br 0(Vsingle x)=Some stored /\
 MemcpySafety stored br bb /\
 Mem.loadbytes stored br 0 4=Some bytes /\ bytes=encode_val Mfloat32(Vsingle x) /\
 extcall_memcpy_sem 4 1 (Genv.to_senv(Csem.genv_genv ge))
 [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero]stored E0 Vundef copied /\
 Mem.loadbytes copied bb 0 4=Some bytes /\
 Mem.load Mint32 copied bb 0=Some(Vint(Float32.to_bits x)) /\
 Mem.loadbytes copied br 0 4=Some bytes.
Lemma bits_observation : forall ge x m,BitsObservation ge x m.
Proof.
 intros ge x m.
 destruct(Mem.alloc m 0 4)as[ma br]eqn:AR.
 destruct(Mem.alloc ma 0 4)as[mb bb]eqn:AB.
 assert(DIFF:br<>bb).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AR)as V;rewrite EQ in V;exact(Mem.fresh_block_alloc _ _ _ _ _ AB V). }
 assert(RF:Mem.valid_access mb Mfloat32 br 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AB|]. eapply Mem.valid_access_alloc_same;[exact AR|lia|change(0+4<=4);lia|exists 0;reflexivity].  }
 assert(BF:Mem.valid_access mb Mint32 bb 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AB|lia|change(0+4<=4);lia|exists 0;reflexivity].  }
 destruct(Mem.valid_access_store mb Mfloat32 br 0(Vsingle x)(Mem.valid_access_freeable_any _ _ _ _ _ RF))as[stored STORE]. 
 assert(SAFE:MemcpySafety stored br bb).
 { apply access_safety;auto;eapply Mem.store_valid_access_1;eauto. }
 assert(READ:Mem.loadbytes stored br 0 4=Some(encode_val Mfloat32(Vsingle x))).
 { change(Mem.loadbytes stored br 0(size_chunk Mfloat32)=Some(encode_val Mfloat32(Vsingle x)));eapply Mem.loadbytes_store_same;exact STORE. }
 assert(WRITE:Mem.range_perm stored bb 0 (0+Z.of_nat(length(encode_val Mfloat32(Vsingle x))))Cur Writable).
 { rewrite encode_val_length;change(Mem.range_perm stored bb 0 4 Cur Writable);exact(dst_writable _ _ _ SAFE). }
 destruct(Mem.range_perm_storebytes _ _ _ _ WRITE)as[copied COPY]. 
 assert(BYTES:Mem.loadbytes copied bb 0 4=Some(encode_val Mfloat32(Vsingle x))).
 { pose proof(Mem.loadbytes_storebytes_same _ _ _ _ _ COPY)as E;rewrite encode_val_length in E;exact E. }
 assert(LOAD:Mem.load Mint32 copied bb 0=Some(Vint(Float32.to_bits x))).
 { pose proof(Mem.loadbytes_load Mint32 copied bb 0 _ BYTES(ex_intro _ 0 eq_refl))as E.
   pose proof(decode_encode_val_general(Vsingle x)Mfloat32 Mint32)as DE.
   change(decode_val Mint32(encode_val Mfloat32(Vsingle x))=Vint(Float32.to_bits x))in DE.
   rewrite DE in E;exact E. }
 unfold BitsObservation;exists ma,br,mb,bb,stored,copied,(encode_val Mfloat32(Vsingle x)).
 split;[exact AR|]. split;[exact AB|]. split;[exact STORE|]. split;[exact SAFE|]. split;[exact READ|]. split;[reflexivity|]. split.
 - econstructor;try rewrite Ptrofs.unsigned_zero;try exact READ;try exact COPY;try(left;reflexivity);try lia;try(exists 4;reflexivity);try(intros;exists 0;reflexivity);left;exact DIFF.
 - split;[exact BYTES|]. split;[exact LOAD|]. 
   erewrite Mem.loadbytes_storebytes_other;[exact READ|exact COPY|lia|left;exact DIFF]. 
Qed.
Print Assumptions bits_observation.
