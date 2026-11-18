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
