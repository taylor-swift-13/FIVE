From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
Require FiveLowpassReset.Execution FiveLowpassGet.Execution FiveLowpassGetCase.Contract.
From FiveLowpassSupport Require Import LowpassMemory.
Import ListNotations.
Local Open Scope Z_scope.
Definition Reset(m:mem)(b:block)(p:ptrofs)(value:float32)(t:trace)(result:val)(mr:mem):Prop:=
 star Csem.step FiveLowpassReset.Execution.ge(FiveLowpassReset.Execution.entry[Vptr b p;Vsingle value]m)t(Returnstate result Kstop mr).
Definition Get(mr:mem)(b:block)(p:ptrofs)(t:trace)(result:val)(mf:mem):Prop:=
 star Csem.step FiveLowpassGet.Execution.ge(FiveLowpassGet.Execution.entry[Vptr b p]mr)t(Returnstate result Kstop mf).
Definition Bits(v:val):option int:=match v with Vsingle f=>Some(Float32.to_bits f)|_=>None end.
Definition Observations(m mr mf:mem)(b:block)(p:ptrofs):Prop:=
 Mem.loadbytes mr b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4 /\
 Mem.loadbytes mf b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4 /\
 FiveLowpassGetCase.Contract.Frame mr mf /\
 (forall q z n,Mem.valid_block m q->
 q<>b \/ z+n<=Ptrofs.unsigned p+4 \/ Ptrofs.unsigned p+12<=z->
 Mem.loadbytes mr q z n=Mem.loadbytes m q z n).
Definition NormalCompletion:Prop:=forall m b p(value:float32),writable12 m b p->
 exists tr mr tg mf,Reset m b p value tr(Vsingle value)mr /\Get mr b p tg(Vsingle value)mf /\Observations m mr mf b p.
Definition AllReturns:Prop:=forall m b p(value:float32),writable12 m b p->
 forall tr rr mr tg rg mf,Reset m b p value tr rr mr->Get mr b p tg rg mf->
 rr=Vsingle value /\rg=Vsingle value /\rr=rg /\
 Bits rr=Some(Float32.to_bits value) /\Bits rg=Some(Float32.to_bits value) /\Observations m mr mf b p.
