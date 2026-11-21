From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Ctypes Csem Smallstep.
Require FiveQuatVmult.Execution FiveRmatOfQuat.Execution FiveRmatVmult.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCall(ge:Csem.genv)(entry:list val->mem->Csem.state)(args:list val)(m mf:mem):Prop:=
 exists t,star Csem.step ge(entry args m)t(Returnstate Vundef Kstop mf).
Definition float_cells(m:mem)(b:block)(n:nat):Prop:=
 forall i,(i<n)%nat->exists x,Mem.load Mfloat32 m b(4*Z.of_nat i)=Some(Vsingle x).
Definition writable(m:mem)(b:block)(n:Z):Prop:=Mem.range_perm m b 0 n Cur Writable.
Definition disjoint(q v a r b:block):Prop:=NoDup[q;v;a;r;b].
Definition Domain(m:mem)(q v a r b:block):Prop:=
 disjoint q v a r b /\ float_cells m q 4 /\ float_cells m v 3 /\ writable m a 12 /\ writable m r 36 /\ writable m b 12 /\
 (forall i,(i<4)%nat->exists x,Mem.load Mfloat32 m q(4*Z.of_nat i)=Some(Vsingle x) /\ Float32.cmp Cle (Float32.neg (Float32.of_bits(Int.repr 1065353216))) x=true /\ Float32.cmp Cle x (Float32.of_bits(Int.repr 1065353216))=true) /\
 (forall i,(i<3)%nat->exists x,Mem.load Mfloat32 m v(4*Z.of_nat i)=Some(Vsingle x) /\ Float32.cmp Cle (Float32.of_bits(Int.repr 3296722944)) x=true /\ Float32.cmp Cle x(Float32.of_bits(Int.repr 1149239296))=true).
Definition BitEquality:Prop:=forall m q v a r b md mr mf,
 Domain m q v a r b ->
 NormalCall FiveQuatVmult.Execution.ge FiveQuatVmult.Execution.entry[Vptr a Ptrofs.zero;Vptr q Ptrofs.zero;Vptr v Ptrofs.zero]m md ->
 NormalCall FiveRmatOfQuat.Execution.ge FiveRmatOfQuat.Execution.entry[Vptr r Ptrofs.zero;Vptr q Ptrofs.zero]md mr ->
 NormalCall FiveRmatVmult.Execution.ge FiveRmatVmult.Execution.entry[Vptr b Ptrofs.zero;Vptr r Ptrofs.zero;Vptr v Ptrofs.zero]mr mf ->
 Mem.loadbytes mf a 0 12=Mem.loadbytes mf b 0 12.
Definition FrameOutside(m mf:mem)(a r b:block):Prop:=forall blk ofs n,
 Mem.valid_block m blk -> (blk<>a /\ blk<>r /\ blk<>b) -> Mem.loadbytes mf blk ofs n=Mem.loadbytes m blk ofs n.
Definition Refutation:Prop:=~BitEquality.
From compcert Require Import Globalenvs Events.
Require FiveRmatVmultCase.Memcpy FiveRmatVmultCase.MemcpyLedger.
Definition InputBits(m:mem)(b:block)(bits:list Z):Prop:=forall i z,nth_error bits i=Some z->
 Mem.load Mfloat32 m b(4*Z.of_nat i)=Some(Vsingle(Float32.of_bits(Int.repr z))).
Definition WordBytes(bits:list Z):list memval:=List.concat(map(fun z=>encode_val Mint32(Vint(Int.repr z)))bits).
Definition CopyObservation(se:Senv.t)(m:mem)(a ca b cb:block)(left right:list memval):Prop:=
 exists ma mb,
 extcall_memcpy_sem 12 1 se[Vptr ca Ptrofs.zero;Vptr a Ptrofs.zero]m E0 Vundef ma /\
 extcall_memcpy_sem 12 1 se[Vptr cb Ptrofs.zero;Vptr b Ptrofs.zero]ma E0 Vundef mb /\
 Mem.loadbytes mb ca 0 12=Some left /\Mem.loadbytes mb cb 0 12=Some right /\
 FiveRmatVmultCase.Memcpy.CopyFrame m ma ca /\FiveRmatVmultCase.Memcpy.CopyFrame ma mb cb /\
 (forall id second kind,In(id,(second,kind))FiveRmatVmultCase.MemcpyLedger.Original18->
 FiveRmatVmultCase.MemcpyLedger.GuardPredicate(if second then ma else m)(if second then b else a)(if second then cb else ca)kind).
Definition ProtocolWitness(qbits vbits lhs rhs:list Z):Prop:=
 exists m q v a r b ca cb md mr mf,
 NoDup[q;v;a;r;b;ca;cb] /\Domain m q v a r b /\InputBits m q qbits /\InputBits m v vbits /\
 NormalCall FiveQuatVmult.Execution.ge FiveQuatVmult.Execution.entry[Vptr a Ptrofs.zero;Vptr q Ptrofs.zero;Vptr v Ptrofs.zero]m md /\
 NormalCall FiveRmatOfQuat.Execution.ge FiveRmatOfQuat.Execution.entry[Vptr r Ptrofs.zero;Vptr q Ptrofs.zero]md mr /\
 NormalCall FiveRmatVmult.Execution.ge FiveRmatVmult.Execution.entry[Vptr b Ptrofs.zero;Vptr r Ptrofs.zero;Vptr v Ptrofs.zero]mr mf /\
 Mem.loadbytes mf a 0 12=Some(WordBytes lhs) /\Mem.loadbytes mf b 0 12=Some(WordBytes rhs) /\
 FrameOutside m mf a r b /\(forall se,CopyObservation se mf a ca b cb(WordBytes lhs)(WordBytes rhs)).
Definition UnitWitness:Prop:=ProtocolWitness[1065353216;0;0;0][1065353216;0;0][1065353216;0;0][1065353214;0;0].
Definition ActualTraceWitness:Prop:=ProtocolWitness[3208096458;3191717350;2687829235;268909329][1124089879;1149239296;2382364672][1095327876;1106339776;3280478549][1095327877;1106339776;3280478549].
