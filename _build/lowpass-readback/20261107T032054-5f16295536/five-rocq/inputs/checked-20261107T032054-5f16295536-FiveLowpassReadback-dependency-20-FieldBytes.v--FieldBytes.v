From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
From FiveLowpassSupport Require Import LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Lemma prefix_unique:forall(A:Type)(xs ys us vs:list A),length xs=length us->xs++ys=us++vs->xs=us /\ys=vs.
Proof.
 intros A xs;induction xs as[|x xs IH];intros ys us vs LEN EQ;destruct us as[|u us];simpl in LEN,EQ;try discriminate.
 - auto.
 - injection LEN as LEN;injection EQ as X EQ;subst u;destruct(IH ys us vs LEN EQ);subst;auto.
Qed.
Lemma encoded_split:forall m b ofs a tail n,
 0<=n->Mem.loadbytes m b ofs(4+n)=Some(encode_val Mfloat32(Vsingle a)++tail)->
 Mem.loadbytes m b ofs 4=Some(encode_val Mfloat32(Vsingle a)) /\Mem.loadbytes m b(ofs+4)n=Some tail.
Proof.
 intros m b ofs a tail n N LD;destruct(Mem.loadbytes_split m b ofs 4 n _ LD ltac:(lia)ltac:(lia))as[x[y[X[Y E]]]].
 assert(L:length x=length(encode_val Mfloat32(Vsingle a))).
 { rewrite(Mem.loadbytes_length _ _ _ _ _ X),encode_val_length;reflexivity. }
 destruct(prefix_unique _ x y _ tail L(eq_sym E));subst x y;auto.
Qed.
Lemma encoded_two:forall m b ofs a c,
 Mem.loadbytes m b ofs 8=Some(encode_val Mfloat32(Vsingle a)++encode_val Mfloat32(Vsingle c))->
 Mem.loadbytes m b ofs 4=Some(encode_val Mfloat32(Vsingle a)) /\Mem.loadbytes m b(ofs+4)4=Some(encode_val Mfloat32(Vsingle c)).
Proof. intros;apply(encoded_split m b ofs a _ 4);auto;lia. Qed.
Lemma encoded_three:forall m b ofs a c d,
 Mem.loadbytes m b ofs 12=Some(encode_val Mfloat32(Vsingle a)++encode_val Mfloat32(Vsingle c)++encode_val Mfloat32(Vsingle d))->
 Mem.loadbytes m b ofs 4=Some(encode_val Mfloat32(Vsingle a)) /\
 Mem.loadbytes m b(ofs+4)4=Some(encode_val Mfloat32(Vsingle c)) /\
 Mem.loadbytes m b(ofs+8)4=Some(encode_val Mfloat32(Vsingle d)).
Proof.
 intros;destruct(encoded_split m b ofs a _ 8 ltac:(lia)H)as[A REST].
 destruct(encoded_two m b(ofs+4)c d REST)as[C D];replace(ofs+4+4)with(ofs+8)in D by lia;auto.
Qed.
Lemma encoded_load:forall m b ofs x,
 (4|ofs)->Mem.loadbytes m b ofs 4=Some(encode_val Mfloat32(Vsingle x))->Mem.load Mfloat32 m b ofs=Some(Vsingle x).
Proof.
 intros;pose proof(Mem.loadbytes_load Mfloat32 m b ofs _ H0 H)as LD.
 pose proof(decode_encode_val_general(Vsingle x)Mfloat32 Mfloat32)as EQ;cbn[decode_encode_val]in EQ;rewrite EQ in LD;exact LD.
Qed.
Definition FieldObservation(ge:Csem.genv)(m:mem)(b:block)(ofs:Z)(x:float32):Prop:=
 Mem.load Mfloat32 m b ofs=Some(Vsingle x) /\CopiedBitsEqualBothOrders ge x x m /\
 (forall mx rr,BitsRun ge x m mx rr->Mem.load Mfloat32 mx b ofs=Some(Vsingle x)).
Lemma field_observation:forall ge m b p delta x,
 writable12 m b p->In delta[0;4;8]->Mem.loadbytes m b(Ptrofs.unsigned p+delta)4=Some(encode_val Mfloat32(Vsingle x))->
 FieldObservation ge m b(Ptrofs.unsigned p+delta)x.
Proof.
 intros ge m b p delta x P D BYTES.
 pose proof(field_access m b p delta P D)as VA.
 assert(LD:Mem.load Mfloat32 m b(Ptrofs.unsigned p+delta)=Some(Vsingle x))by(apply encoded_load;[exact(proj2 VA)|exact BYTES]).
 split;[exact LD|];split;[apply copied_bits_equal;reflexivity|].
 intros mx rr BR;pose proof(proj1(bits_run_old_frame ge x m mx rr BR)Mfloat32 b(Ptrofs.unsigned p+delta))as KEEP.
 rewrite KEEP;[exact LD|]. eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor].
Qed.
Print Assumptions field_observation.
