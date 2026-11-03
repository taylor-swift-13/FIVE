From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.proof.support Require Import MemorySpec.
From FiveCases.lowpass.proof Require Import Entry.
Import ListNotations.
Local Open Scope Z_scope.

Definition witness_state := mkState Int.zero Int.zero Int.zero Int.zero Int.zero Int.zero Int.zero Int.zero.

Theorem precondition_inhabited : exists m b fs,lowpass_pre m b fs.
Proof.
 destruct(Mem.alloc Mem.empty 0 32)as [m0 b]eqn:ALLOC.
 assert(W:forall ofs,In ofs [0;4;8;12;16;20;24;28] ->
  Mem.valid_access m0 Mfloat32 b ofs Writable).
 { intros ofs IN;destruct IN as [<-|[<-|[<-|[<-|[<-|[<-|[<-|[<-|[]]]]]]]]].
   all: (eapply Mem.valid_access_freeable_any;
   eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|simpl;lia|];
   first[exists 0;reflexivity|exists 1;reflexivity|exists 2;reflexivity|
    exists 3;reflexivity|exists 4;reflexivity|exists 5;reflexivity|
    exists 6;reflexivity|exists 7;reflexivity]). }
 assert(W0:Mem.valid_access m0 Mfloat32 b 0 Writable)by(apply W;simpl;tauto).
 destruct(Mem.valid_access_store m0 Mfloat32 b 0(Vsingle(Float32.of_bits Int.zero))W0)as [m1 S0].
 assert(W1:Mem.valid_access m1 Mfloat32 b 4 Writable)by(eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]).
 destruct(Mem.valid_access_store m1 Mfloat32 b 4(Vsingle(Float32.of_bits Int.zero))W1)as [m2 S1].
 assert(W2:Mem.valid_access m2 Mfloat32 b 8 Writable)by(eapply Mem.store_valid_access_1;[exact S1|];eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]).
 destruct(Mem.valid_access_store m2 Mfloat32 b 8(Vsingle(Float32.of_bits Int.zero))W2)as [m3 S2].
 assert(W3:Mem.valid_access m3 Mfloat32 b 12 Writable).
 { eapply Mem.store_valid_access_1;[exact S2|];eapply Mem.store_valid_access_1;[exact S1|];eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]. }
 destruct(Mem.valid_access_store m3 Mfloat32 b 12(Vsingle(Float32.of_bits Int.zero))W3)as [m4 S3].
 assert(W4:Mem.valid_access m4 Mfloat32 b 16 Writable).
 { eapply Mem.store_valid_access_1;[exact S3|];eapply Mem.store_valid_access_1;[exact S2|];eapply Mem.store_valid_access_1;[exact S1|];eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]. }
 destruct(Mem.valid_access_store m4 Mfloat32 b 16(Vsingle(Float32.of_bits Int.zero))W4)as [m5 S4].
 assert(W5:Mem.valid_access m5 Mfloat32 b 20 Writable).
 { eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact S3|];eapply Mem.store_valid_access_1;[exact S2|];eapply Mem.store_valid_access_1;[exact S1|];eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]. }
 destruct(Mem.valid_access_store m5 Mfloat32 b 20(Vsingle(Float32.of_bits Int.zero))W5)as [m6 S5].
 assert(W6:Mem.valid_access m6 Mfloat32 b 24 Writable).
 { eapply Mem.store_valid_access_1;[exact S5|];eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact S3|];eapply Mem.store_valid_access_1;[exact S2|];eapply Mem.store_valid_access_1;[exact S1|];eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]. }
 destruct(Mem.valid_access_store m6 Mfloat32 b 24(Vsingle(Float32.of_bits Int.zero))W6)as [m7 S6].
 assert(W7:Mem.valid_access m7 Mfloat32 b 28 Writable).
 { eapply Mem.store_valid_access_1;[exact S6|];eapply Mem.store_valid_access_1;[exact S5|];eapply Mem.store_valid_access_1;[exact S4|];eapply Mem.store_valid_access_1;[exact S3|];eapply Mem.store_valid_access_1;[exact S2|];eapply Mem.store_valid_access_1;[exact S1|];eapply Mem.store_valid_access_1;[exact S0|apply W;simpl;tauto]. }
 destruct(Mem.valid_access_store m7 Mfloat32 b 28(Vsingle(Float32.of_bits Int.zero))W7)as [m8 S7].
 exists m8,b,witness_state;constructor.
 - eapply Mem.store_valid_block_1;[exact S7|]. eapply Mem.store_valid_block_1;[exact S6|].
   eapply Mem.store_valid_block_1;[exact S5|]. eapply Mem.store_valid_block_1;[exact S4|].
   eapply Mem.store_valid_block_1;[exact S3|]. eapply Mem.store_valid_block_1;[exact S2|].
   eapply Mem.store_valid_block_1;[exact S1|]. eapply Mem.store_valid_block_1;[exact S0|].
   eapply Mem.valid_new_block;exact ALLOC.
 - unfold HarnessMemory.initialized_state,witness_state,HarnessMemory.single_word;simpl;repeat split;
   repeat first[
    erewrite Mem.load_store_same by eassumption
   |erewrite Mem.load_store_other by(eassumption || (right;simpl;lia))];reflexivity.
 - intros ofs IN;eapply Mem.store_valid_access_1;[exact S7|].
   eapply Mem.store_valid_access_1;[exact S6|]. eapply Mem.store_valid_access_1;[exact S5|].
   eapply Mem.store_valid_access_1;[exact S4|]. eapply Mem.store_valid_access_1;[exact S3|].
   eapply Mem.store_valid_access_1;[exact S2|]. eapply Mem.store_valid_access_1;[exact S1|].
   eapply Mem.store_valid_access_1;[exact S0|]. apply W;simpl in *;tauto.
Qed.

Print Assumptions precondition_inhabited.

