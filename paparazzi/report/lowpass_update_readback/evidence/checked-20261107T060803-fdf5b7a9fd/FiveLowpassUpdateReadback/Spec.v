From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
Require FiveLowpassUpdate.Execution FiveLowpassGet.Execution FiveLowpassGetCase.Contract FiveLowpassUpdateCase.Contract.
Import ListNotations.
Local Open Scope Z_scope.
Module U:=FiveLowpassUpdateCase.Contract.
Definition Update(m:mem)(b:block)(p:ptrofs)(input:float32)(t:trace)(result:val)(mu:mem):Prop:=
 star Csem.step FiveLowpassUpdate.Execution.ge(FiveLowpassUpdate.Execution.entry[Vptr b p;Vsingle input]m)t(Returnstate result Kstop mu).
Definition Get(mu:mem)(b:block)(p:ptrofs)(t:trace)(result:val)(mf:mem):Prop:=
 star Csem.step FiveLowpassGet.Execution.ge(FiveLowpassGet.Execution.entry[Vptr b p]mu)t(Returnstate result Kstop mf).
Definition Bits(v:val):option int:=match v with Vsingle f=>Some(Float32.to_bits f)|_=>None end.
Definition Observations(m mu mf:mem)(b:block)(p:ptrofs)(input:float32)(returned:val):Prop:=
 Mem.loadbytes mu b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4 /\
 Mem.loadbytes mf b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4 /\
 Mem.loadbytes mu b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle input)) /\
 Mem.loadbytes mf b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle input)) /\
 Mem.loadbytes mu b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32 returned) /\
 Mem.loadbytes mf b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32 returned) /\
 FiveLowpassGetCase.Contract.Frame mu mf /\ U.Frame m mu b p.
Definition NormalCompletion:Prop:=forall m b p tc li lo input,U.Initialized m b p tc li lo->
 exists tu mu tg mf,
 Update m b p input tu(Vsingle(U.output tc li lo input))mu /\
 Get mu b p tg(Vsingle(U.output tc li lo input))mf /\
 Observations m mu mf b p input(Vsingle(U.output tc li lo input)).
Definition AllReturns:Prop:=forall m b p tc li lo input,U.Initialized m b p tc li lo->
 forall tu r mu tg y mf,Update m b p input tu r mu->Get mu b p tg y mf->
 r=Vsingle(U.output tc li lo input) /\y=r /\Bits r=Bits y /\
 Observations m mu mf b p input r.
