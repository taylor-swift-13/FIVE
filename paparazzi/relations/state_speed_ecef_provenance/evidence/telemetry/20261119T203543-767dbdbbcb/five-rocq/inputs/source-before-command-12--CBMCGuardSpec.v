
From Stdlib Require Import List ZArith Bool.
From compcert Require Import AST Integers Floats Values Memory Memdata Ctypes Cop Csyntax Csem Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation.
From StateSpeedGetterSupport Require Import ControlExclusion.
From StateSpeedMemory Require Import Protocol HarnessObservation ObserverCopy InitialMemory.
From StateSpeedSetterSupport Require Import DefinedBytes.
Import ListNotations.
Open Scope Z_scope.
Definition active_function(s:Csem.state):option function:=
 match s with State f _ _ _ _|ExprState f _ _ _ _=>Some f|Callstate(Internal f)_ _ _=>Some f|_=>None end.
(* This stronger source-PC exclusion discharges each literal guard in a callee;
   it makes no arithmetic or pointer claim on an unevaluated expression. *)
Definition FallbackGuard(f:function):Prop:=
 forall m sb x y z, G.InputGood m sb x y z->forall t reached,
 star Csem.step G.ge(G.E.entry[]m)t reached->active_function reached<>Some f.
Definition pointer_condition(kind:nat)(ch:memory_chunk)(extent:Z)(mode:permission)
 (m:mem)(b:block)(ofs:Z):Prop:=
 match kind with
 | 0%nat=>Vptr b(Ptrofs.repr ofs)<>Vint Int.zero
 | 1%nat=>Mem.valid_block m b
 | 2%nat=>Mem.perm m b ofs Max Nonempty
 | 3%nat=>Mem.perm m b ofs Cur Nonempty
 | 4%nat=>Mem.valid_access m ch b ofs mode /\Ptrofs.unsigned(Ptrofs.repr ofs)=ofs /\
 0<=ofs /\ofs+size_chunk ch<=extent /\ofs+size_chunk ch<=Ptrofs.modulus
 | _=>(forall i,Vptr b(Ptrofs.repr ofs)<>Vint i) /\(forall i,Vptr b(Ptrofs.repr ofs)<>Vlong i)
 end.
Definition NSourceGuard(ofs:Z)(kind:nat):Prop:=
 forall m sb ns es nx ny nz ex ey ez,ProtocolInput m sb ns es nx ny nz ex ey ez->
 pointer_condition kind Mint32 12 Readable m ns ofs.
Definition ESourceGuard(ofs:Z)(kind:nat):Prop:=
 forall m mn sb ns es nx ny nz ex ey ez,ProtocolInput m sb ns es nx ny nz ex ey ez->
 N.SetterResult m mn sb ns nx ny nz->pointer_condition kind Mint32 12 Readable mn es ofs.
Definition ObserverPointerGuard(ofs:Z)(ch:memory_chunk)(kind:nat):Prop:=
 forall m ob,Mem.range_perm m ob 0 1360 Cur Writable->
 pointer_condition kind ch 1360 Writable m ob ofs.
Definition ObserverArrayGuard(base i:Z):Prop:=
 0<=i<3 /\base+4*i+4<=1360 /\Ptrofs.unsigned(Ptrofs.repr(base+4*i))=base+4*i.
Definition MainArrayGuard(after:bool):Prop:=
 forall w a b,WitnessObservations w a b->forall i,0<=i<656->
 0<=i<Z.of_nat(length(if after then after_get a else before_get a)) /\
 0<=i<Z.of_nat(length(if after then after_get b else before_get b)) /\
 Ptrofs.unsigned(Ptrofs.repr((if after then 704 else 48)+i))=(if after then 704 else 48)+i.
Definition ZeroInitializationGuard:Prop:=
 forall m sb,Mem.range_perm m sb 0 656 Cur Writable->
 exists mz,Mem.storebytes m sb 0(repeat(Byte Byte.zero)656)=Some mz.
Definition ProtocolSourceReadable(after:bool)(ofs n:Z):Prop:=
 forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 Mem.range_perm(if after then mf else me)sb ofs(ofs+n)Cur Readable.
Definition ObserverDestinationWritable(ofs n:Z):Prop:=
 forall m ob,Mem.range_perm m ob 0 1360 Cur Writable->Mem.range_perm m ob ofs(ofs+n)Cur Writable.
Definition CopyNonoverlap(srcOfs dstOfs n:Z):Prop:=
 forall sb ob,sb<>ob->forall i j,srcOfs<=i<srcOfs+n->dstOfs<=j<dstOfs+n->
 Vptr sb(Ptrofs.repr i)<>Vptr ob(Ptrofs.repr j).
Definition ProtocolCopy(after:bool)(srcOfs dstOfs n:Z):Prop:=
 forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 forall ob,sb<>ob->Mem.range_perm(if after then mf else me)ob 0 1360 Cur Writable->
 exists bytes copied,Mem.loadbytes(if after then mf else me)sb srcOfs n=Some bytes /\
 CopiedBytes(if after then mf else me)copied sb ob srcOfs dstOfs n bytes.
(* The second || alternative is evaluated only after object equality; the
   third also requires the first same-object ordering alternative to fail. *)
Definition MemcpyEvaluationGuard(second:bool)(srcOfs dstOfs n:Z)(sb ob:block):Prop:=
 sb=ob /\(if second then ~(srcOfs>=dstOfs+n)else True).
Definition GuardedMemcpyPointer(second source:bool)(srcOfs dstOfs n at:Z)(kind:nat):Prop:=
 forall m sb ob,sb<>ob->MemcpyEvaluationGuard second srcOfs dstOfs n sb ob->
 pointer_condition kind Mint8unsigned(if source then 656 else 1360)Readable m(if source then sb else ob)at.
Definition GuardedMemcpySameObject(second:bool)(srcOfs dstOfs n:Z):Prop:=
 forall sb ob,sb<>ob->MemcpyEvaluationGuard second srcOfs dstOfs n sb ob->sb=ob.
Definition rhs_at(s:statement)(axis:nat):option expr:=
 let '(x,y,z):=conversion_rhs_triple s in match axis with 0%nat=>x|1%nat=>y|_=>z end.
Definition axis_ident(axis:nat):ident:=match axis with 0%nat=>G.S._x|1%nat=>G.S._y|_=>G.S._z end.
Definition DivisionGuard(fallback:bool)(axis:nat):Prop:=
 rhs_at(if fallback then original_fallback_conversion_block else original_conversion_block)axis=
 Some(G.conversion(axis_ident axis)) /\
 forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 (nx=Int.zero \/nx=Protocol.S)->ny=Int.zero->nz=Int.zero->
 exists f,pure_rval G.ge empty_env me(G.conversion(axis_ident axis))=Some(Vsingle f) /\
 Binary.is_finite 24 128 f=true /\Binary.is_nan 24 128 f=false.
Definition MainAssertion(k:nat):Prop:=
 exists w a b,witness_initial_bytes w=InitialMemory.initial_state_contents /\
 WitnessObservations w a b /\TypedFrameComparisons w /\
 (if Nat.leb k 7 then harness_assertion k a b else ~harness_assertion k a b).
