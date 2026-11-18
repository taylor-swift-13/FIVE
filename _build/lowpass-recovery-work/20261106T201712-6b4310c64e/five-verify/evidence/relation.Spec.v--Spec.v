From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassSupport Require Import LowpassMemory.
Require FiveLowpassInit.Execution FiveLowpassRetune.Execution FiveLowpassReset.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition coefficient(tau h:float32):float32:=Float32.div(Float32.mul(Float32.of_bits(Int.repr 1073741824))tau)h.
Definition final_bytes(tau h value:float32):list memval:=encode_val Mfloat32(Vsingle(coefficient tau h))++encode_val Mfloat32(Vsingle value)++encode_val Mfloat32(Vsingle value).
Definition Returns(ge:Csem.genv)(entry:list val->mem->Csem.state)(args:list val)(m:mem)(rv:val)(mf:mem):Prop:=exists t,star Csem.step ge(entry args m)t(Returnstate rv Kstop mf).
Definition Frame(m mf:mem)(b:block)(p:ptrofs):Prop:=forall q z n,Mem.valid_block m q->q<>b \/z+n<=Ptrofs.unsigned p \/Ptrofs.unsigned p+12<=z->Mem.loadbytes mf q z n=Mem.loadbytes m q z n.
Definition FinalPost(ma mb fa fb:mem)(ba bb:block)(pa pb:ptrofs)(tau h value:float32):Prop:=
 writable12 fa ba pa /\writable12 fb bb pb /\
 Mem.loadbytes fa ba(Ptrofs.unsigned pa)12=Some(final_bytes tau h value) /\
 Mem.loadbytes fb bb(Ptrofs.unsigned pb)12=Some(final_bytes tau h value) /\
 Frame ma fa ba pa /\Frame mb fb bb pb.
Definition NormalCompletion:Prop:=forall ma mb ba bb pa pb tau h value,
 writable12 ma ba pa->writable12 mb bb pb->exists m1 fa fb,
 Returns FiveLowpassRetune.Execution.ge FiveLowpassRetune.Execution.entry[Vptr ba pa;Vsingle tau;Vsingle h]ma Vundef m1 /\
 Returns FiveLowpassReset.Execution.ge FiveLowpassReset.Execution.entry[Vptr ba pa;Vsingle value]m1(Vsingle value)fa /\
 Returns FiveLowpassInit.Execution.ge FiveLowpassInit.Execution.entry[Vptr bb pb;Vsingle tau;Vsingle h;Vsingle value]mb Vundef fb /\
 FinalPost ma mb fa fb ba bb pa pb tau h value.
Definition AllNormalResults:Prop:=forall ma mb ba bb pa pb tau h value,
 writable12 ma ba pa->writable12 mb bb pb->forall m1 fa fb rr rs ri,
 Returns FiveLowpassRetune.Execution.ge FiveLowpassRetune.Execution.entry[Vptr ba pa;Vsingle tau;Vsingle h]ma rr m1 ->
 Returns FiveLowpassReset.Execution.ge FiveLowpassReset.Execution.entry[Vptr ba pa;Vsingle value]m1 rs fa ->
 Returns FiveLowpassInit.Execution.ge FiveLowpassInit.Execution.entry[Vptr bb pb;Vsingle tau;Vsingle h;Vsingle value]mb ri fb ->
 rr=Vundef /\ri=Vundef /\rs=Vsingle value /\
 Mem.loadbytes fa ba(Ptrofs.unsigned pa)12=Mem.loadbytes fb bb(Ptrofs.unsigned pb)12 /\
 FinalPost ma mb fa fb ba bb pa pb tau h value.
Definition Nonvacuity:Prop:=exists ma mb ba bb,ba<>bb /\writable12 ma ba Ptrofs.zero /\writable12 mb bb Ptrofs.zero.
