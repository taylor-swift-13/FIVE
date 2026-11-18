From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Events Globalenvs Ctypes Csem.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Import ListNotations.
Local Open Scope Z_scope.

(** A packet belongs to the actual memcpy call in the bits helper: source and
    destination blocks are the two fresh four-byte caller objects.  It does
    not evaluate a C pointer ordering between distinct objects. *)
Definition valid4 (m:mem)(b:block)(p:permission):Prop :=
 Mem.range_perm m b 0 4 Cur p.
Record MemcpyPacket (m:mem)(src dst:block):Prop := {
 packet_safety:MemcpySafety m src dst;
 packet_source_valid4:valid4 m src Readable;
 packet_destination_valid4:valid4 m dst Writable
}.
Theorem packet_of_safety:forall m src dst,
 MemcpySafety m src dst -> MemcpyPacket m src dst.
Proof. intros m src dst H;constructor;[exact H|exact(src_readable _ _ _ H)|exact(dst_writable _ _ _ H)]. Qed.

(** Full witness links the guard packet to the same allocations, actual
    float32 source store, official memcpy, copied bytes and integer result. *)
Definition GuardedBitsRun (ge:genv)(x:float32)(m mf:mem)(result:int):Prop :=
 exists ma src mb dst stored bytes,
 Mem.alloc m 0 4=(ma,src) /\ Mem.alloc ma 0 4=(mb,dst) /\
 Mem.store Mfloat32 mb src 0(Vsingle x)=Some stored /\
 MemcpyPacket stored src dst /\
 Mem.loadbytes stored src 0 4=Some bytes /\bytes=Memdata.encode_val Mfloat32(Vsingle x) /\
 BitsAdapter.Lib.official_memcpy(Genv.to_senv(Csem.genv_genv ge))
 [Vptr dst Ptrofs.zero;Vptr src Ptrofs.zero;Vlong(Int64.repr 4)]stored E0(Vptr dst Ptrofs.zero)mf /\
 Mem.loadbytes mf dst 0 4=Some bytes /\Mem.load Mint32 mf dst 0=Some(Vint result) /\
 result=Float32.to_bits x /\ Mem.loadbytes mf src 0 4=Some bytes.
Theorem guarded_bits_run:forall ge x m mf result,
 BitsRun ge x m mf result -> GuardedBitsRun ge x m mf result.
Proof.
 intros ge x m mf result(ma&src&mb&dst&stored&bytes&A&B&S&SAFE&R&ENC&COPY&D&LOAD&RESULT&FRAME).
 exists ma,src,mb,dst,stored,bytes.
 split;[exact A|]. split;[exact B|]. split;[exact S|].
 split;[apply packet_of_safety;exact SAFE|].
 split;[exact R|]. split;[exact ENC|]. split;[exact COPY|].
 split;[exact D|]. split;[exact LOAD|]. split;assumption.
Qed.
Theorem guarded_bits_run_exists:forall ge x m,
 exists mf,GuardedBitsRun ge x m mf(Float32.to_bits x).
Proof. intros;destruct(bits_run_exists ge x m)as[mf H];exists mf;apply guarded_bits_run;exact H. Qed.
Theorem guarded_bits_run_forget:forall ge x m mf result,
 GuardedBitsRun ge x m mf result -> BitsRun ge x m mf result.
Proof.
 intros ge x m mf result(ma&src&mb&dst&stored&bytes&A&B&S&PACKET&R&ENC&COPY&D&LOAD&RESULT&FRAME).
 exists ma,src,mb,dst,stored,bytes.
 split;[exact A|]. split;[exact B|]. split;[exact S|].
 split;[exact(packet_safety _ _ _ PACKET)|].
 split;[exact R|]. split;[exact ENC|]. split;[exact COPY|].
 split;[exact D|]. split;[exact LOAD|]. split;assumption.
Qed.
Theorem guarded_old_frame:forall ge x m mf result,
 GuardedBitsRun ge x m mf result ->
 (forall ch b ofs,Mem.valid_block m b->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b->0<=n->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof. intros;apply(bits_run_old_frame ge x m mf result);apply guarded_bits_run_forget;assumption. Qed.
Theorem guarded_old_valid:forall ge x m mf result,
 GuardedBitsRun ge x m mf result ->forall b,Mem.valid_block m b->Mem.valid_block mf b.
Proof. intros ge x m mf result H;apply(bits_run_old_valid ge x m mf result);apply guarded_bits_run_forget;exact H. Qed.
Print Assumptions packet_of_safety.
Print Assumptions guarded_bits_run.
Print Assumptions guarded_bits_run_exists.
Print Assumptions guarded_bits_run_forget.
Print Assumptions guarded_old_frame.
Print Assumptions guarded_old_valid.

(** Dispatch follows the actual instrumented-properties.json emitted for all
    three unchanged lowpass harnesses: six memcpy pointer guards followed by
    two literal-size conversion guards, and three bits preconditions. *)
Definition memcpy_guard_at(n:nat)(m:mem)(src dst:block):Prop:=match n with
 |1%nat=>src<>dst
 |2%nat=>Mem.valid_pointer m src 0=true
 |3%nat=>Mem.weak_valid_pointer m dst 4=true
 |4%nat=>dst<>src
 |5%nat=>Mem.valid_pointer m dst 0=true
 |6%nat=>Mem.weak_valid_pointer m src 4=true
 |7%nat=>0<=4<=Int64.max_signed
 |8%nat=>0<=Int64.signed(Int64.repr 4)<=Int64.max_unsigned
 |_=>False end.
Definition bits_guard_at(n:nat)(m:mem)(src dst:block):Prop:=match n with
 |1%nat=>src<>dst \/0+4<=0\/0+4<=0
 |2%nat=>Mem.range_perm m src 0 4 Cur Readable
 |3%nat=>Mem.range_perm m dst 0 4 Cur Writable
 |_=>False end.
Theorem memcpy_packet_guards:forall n m src dst,
 (1<=n<=8)%nat->MemcpyPacket m src dst->memcpy_guard_at n m src dst.
Proof.
 intros n m src dst B P;pose proof(packet_safety _ _ _ P)as S.
 assert(C:n=1%nat\/n=2%nat\/n=3%nat\/n=4%nat\/n=5%nat\/n=6%nat\/n=7%nat\/n=8%nat)by lia.
 repeat destruct C as[E|C];try(rename C into E);subst n;cbn[memcpy_guard_at].
 - exact(separated _ _ _ S).
 - exact(src_live _ _ _ S).
 - exact(dst_end_live _ _ _ S).
 - exact(separated_rev _ _ _ S).
 - exact(dst_live _ _ _ S).
 - exact(src_end_live _ _ _ S).
 - vm_compute;intuition discriminate.
 - vm_compute;intuition discriminate.
Qed.
Theorem bits_packet_guards:forall n m src dst,
 (1<=n<=3)%nat->MemcpyPacket m src dst->bits_guard_at n m src dst.
Proof.
 intros n m src dst B P;pose proof(packet_safety _ _ _ P)as S.
 assert(C:n=1%nat\/n=2%nat\/n=3%nat)by lia.
 destruct C as[E|[E|E]];subst n;cbn[bits_guard_at].
 - exact(nonoverlap _ _ _ S).
 - exact(packet_source_valid4 _ _ _ P).
 - exact(packet_destination_valid4 _ _ _ P).
Qed.

(** A property retains the same actual bits execution and the same uniquely
    determined parameter/local allocations and source store at the memcpy
    site. Guard propositions are never detached from that actual call. *)
Definition GuardedBitsProperty(G:mem->block->block->Prop)
 (ge:genv)(x:float32)(m mf:mem)(result:int):Prop:=
 GuardedBitsRun ge x m mf result /\
 exists ma src mb dst stored,
 Mem.alloc m 0 4=(ma,src) /\Mem.alloc ma 0 4=(mb,dst) /\
 Mem.store Mfloat32 mb src 0(Vsingle x)=Some stored /\
 MemcpyPacket stored src dst /\G stored src dst.
Theorem guarded_property:forall G,
 (forall m src dst,MemcpyPacket m src dst->G m src dst)->
 forall ge x m mf result,GuardedBitsRun ge x m mf result->
 GuardedBitsProperty G ge x m mf result.
Proof.
 intros G GUARD ge x m mf result H;split;[exact H|].
 destruct H as(ma&src&mb&dst&stored&bytes&A&B&S&P&REST).
 exists ma,src,mb,dst,stored.
 split;[exact A|]. split;[exact B|]. split;[exact S|]. split;[exact P|]. apply GUARD;exact P.
Qed.
Definition memcpy_guard_id(n:nat):Prop:=forall ge x m,
 exists mf,GuardedBitsProperty(memcpy_guard_at n)ge x m mf(Float32.to_bits x).
Definition bits_guard_id(n:nat):Prop:=forall ge x m,
 exists mf,GuardedBitsProperty(bits_guard_at n)ge x m mf(Float32.to_bits x).
Theorem memcpy_guards:forall n,(1<=n<=8)%nat->memcpy_guard_id n.
Proof.
 intros n B ge x m;destruct(guarded_bits_run_exists ge x m)as[mf H];exists mf.
 eapply guarded_property;[intros;apply memcpy_packet_guards;assumption|exact H].
Qed.
Theorem bits_guards:forall n,(1<=n<=3)%nat->bits_guard_id n.
Proof.
 intros n B ge x m;destruct(guarded_bits_run_exists ge x m)as[mf H];exists mf.
 eapply guarded_property;[intros;apply bits_packet_guards;assumption|exact H].
Qed.
Print Assumptions memcpy_packet_guards.
Print Assumptions bits_packet_guards.
Print Assumptions guarded_property.
Print Assumptions memcpy_guards.
Print Assumptions bits_guards.
