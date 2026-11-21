From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory Memdata Ctypes Cop Csyntaxdefs Csem.
From FiveShared.verification Require Import Obligations.
From StateSpeedSetterSupport Require Import HarnessMemory.
From StateSpeedSetNedISupport Require Import Setup Harness.
Open Scope Z_scope.

Definition RawGuard(P:mem->block->block->Prop):Prop:=forall m sb src before x y z,
 RawHarnessGood m sb src before x y z ->P m sb before.
Definition SourceGuard(ofs:Z)(P:mem->block->Z->Prop):Prop:=forall m sb src before x y z,
 HarnessGood m sb src before x y z ->
 Obligations.no_error ge(E.entry(Args(Int.repr 65535)src)m) /\P m src ofs.
Definition pointer_nonnull(m:mem)(b:block)(ofs:Z):Prop:=Vptr b(Ptrofs.repr ofs)<>Vint Int.zero.
Definition pointer_live(m:mem)(b:block)(ofs:Z):Prop:=Mem.valid_block m b.
Definition pointer_not_deallocated(m:mem)(b:block)(ofs:Z):Prop:=Mem.perm m b ofs Max Nonempty.
Definition pointer_not_dead(m:mem)(b:block)(ofs:Z):Prop:=Mem.perm m b ofs Cur Nonempty.
Definition pointer_word_range(m:mem)(b:block)(ofs:Z):Prop:=
 Mem.valid_access m Mint32 b ofs Readable /\Ptrofs.unsigned(Ptrofs.repr ofs)=ofs /\ofs+4<=Ptrofs.modulus.
Definition pointer_not_integer(m:mem)(b:block)(ofs:Z):Prop:=
 (forall i,Vptr b(Ptrofs.repr ofs)<>Vint i) /\(forall i,Vptr b(Ptrofs.repr ofs)<>Vlong i).

(* Original builtin guards: zeroing, live one-past endpoint, two same-object
   guarded comparisons, pointer relation, nonoverlap, read and write regions. *)
Definition property_0:Prop:=RawGuard(fun m sb before=>exists mz,Mem.storebytes m sb 0 zeros=Some mz).
Definition property_1:Prop:=RawGuard(fun m sb before=>Mem.valid_block m before /\
 Ptrofs.unsigned(Ptrofs.repr 656)=656 /\Mem.weak_valid_pointer m before 656=true).
Definition property_2:Prop:=RawGuard(fun m sb before=>sb<>before /\
 (sb=before ->Mem.weak_valid_pointer m before 656=true /\Mem.weak_valid_pointer m sb 0=true)).
Definition property_3:Prop:=RawGuard(fun m sb before=>before<>sb /\
 (before=sb ->Mem.weak_valid_pointer m sb 656=true /\Mem.weak_valid_pointer m before 0=true)).
Definition property_4:Prop:=RawGuard(fun m sb before=>Mem.valid_block m before /\Mem.weak_valid_pointer m before 0=true).
Definition property_5:Prop:=RawGuard(fun m sb before=>forall i j,0<=i<656 ->0<=j<656 ->
 Vptr sb(Ptrofs.repr i)<>Vptr before(Ptrofs.repr j)).
Definition property_6:Prop:=RawGuard(fun m sb before=>Mem.range_perm m sb 0 656 Cur Readable).
Definition property_7:Prop:=RawGuard(fun m sb before=>Mem.range_perm m before 0 656 Cur Writable).

Definition property_8:Prop:=forall m sb src before x y z,
 HarnessGood m sb src before x y z ->exists mf,
 NormalCall(Int.repr 65535)src m mf /\
 (Mem.load Mint32 mf sb destination_offset=Some(Vint x) /\
 Mem.load Mint32 mf sb(destination_offset+4)=Some(Vint y) /\
 Mem.load Mint32 mf sb(destination_offset+8)=Some(Vint z)) /\
 (forall mf',NormalCall(Int.repr 65535)src m mf' ->mf'=mf).
Definition property_9:Prop:=forall m sb src before x y z mf,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->
 Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr selected_status)).
Definition property_10:Prop:=forall m sb src before x y z mf i,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->0<=i<656 ->
 Ptrofs.unsigned(Ptrofs.repr i)=i /\Mem.weak_valid_pointer mf sb i=true.
Definition property_11:Prop:=forall m sb src before x y z mf i,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->0<=i<656 ->
 exists v,Mem.load Mint8unsigned mf sb i=Some(Vint v).
Definition property_12:Prop:=forall m sb src before x y z mf i,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->0<=i<656 ->
 0<=i<Z.of_nat 656 /\exists v,Mem.load Mint8unsigned mf before i=Some(Vint v).
Definition property_13:Prop:=forall m sb src before x y z mf i,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->
 0<=i<656 ->~writes sb sb i ->Mem.loadbytes mf sb i 1=Mem.loadbytes mf before i 1 /\
 exists v,Mem.load Mint8unsigned mf sb i=Some(Vint v) /\Mem.load Mint8unsigned mf before i=Some(Vint v) /\
 Cop.sem_binary_operation ge Oeq(Vint v)tuchar(Vint v)tuchar mf=Some(Vint Int.one).
Definition property_14:Prop:=SourceGuard 0 pointer_nonnull.
Definition property_15:Prop:=SourceGuard 0 pointer_live.
Definition property_16:Prop:=SourceGuard 0 pointer_not_deallocated.
Definition property_17:Prop:=SourceGuard 0 pointer_not_dead.
Definition property_18:Prop:=SourceGuard 0 pointer_word_range.
Definition property_19:Prop:=SourceGuard 0 pointer_not_integer.
Definition property_20:Prop:=SourceGuard 4 pointer_nonnull.
Definition property_21:Prop:=SourceGuard 4 pointer_live.
Definition property_22:Prop:=SourceGuard 4 pointer_not_deallocated.
Definition property_23:Prop:=SourceGuard 4 pointer_not_dead.
Definition property_24:Prop:=SourceGuard 4 pointer_word_range.
Definition property_25:Prop:=SourceGuard 4 pointer_not_integer.
Definition property_26:Prop:=SourceGuard 8 pointer_nonnull.
Definition property_27:Prop:=SourceGuard 8 pointer_live.
Definition property_28:Prop:=SourceGuard 8 pointer_not_deallocated.
Definition property_29:Prop:=SourceGuard 8 pointer_not_dead.
Definition property_30:Prop:=SourceGuard 8 pointer_word_range.
Definition property_31:Prop:=SourceGuard 8 pointer_not_integer.
Definition HarnessPreparationGoal:Prop:=forall m sb src before x y z,
 RawHarnessGood m sb src before x y z ->exists m0,
 Preparation m m0 sb before /\HarnessGood m0 sb src before x y z.
