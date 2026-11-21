From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveMatInv3Case Require Import MatrixMemory.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract RecheckSupport Memcpy16 Replay ExactReplay.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.
Definition CopyGuard(k:nat):Prop:=forall m src dst,CopyPre m src dst->
 match k with
 |0%nat=>forall order:Prop,~(src=dst/\order)
 |1%nat=>Mem.valid_pointer m src 0=true
 |2%nat=>Mem.weak_valid_pointer m dst 16=true
 |3%nat=>forall order:Prop,~(dst=src/\order)
 |4%nat=>Mem.valid_pointer m dst 0=true
 |5%nat=>Mem.weak_valid_pointer m src 16=true
 |6%nat=>src<>dst \/0+16<=0\/0+16<=0
 |7%nat=>Mem.range_perm m src 0 16 Cur Readable
 |_=>Mem.range_perm m dst 0 16 Cur Writable end.
Definition CaseStatus(f:Z->float32)(expected:val):Prop:=forall m bo bi po pi,Inputs m bo bi po pi f->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate result Kstop mf)->result=expected.
Definition CaseWords(f:Z->float32)(words:list Z):Prop:=forall m bo bi pi,Inputs m bo bi Ptrofs.zero pi f->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi Ptrofs.zero pi)m)t(Returnstate result Kstop mf)->forall dst bytes obs,
 Mem.loadbytes mf bo 0 16=Some bytes->Mem.storebytes mf dst 0 bytes=Some obs->
 map(fun i=>Mem.load Mint32 obs dst(4*i))[0;1;2;3]=map(fun w=>Some(Vint(Int.repr w)))words.
Definition CasePreserves(f:Z->float32):Prop:=forall m bo bi po pi,Inputs m bo bi po pi f->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate result Kstop mf)->
 Mem.loadbytes mf bo(Ptrofs.unsigned po)16=Mem.loadbytes m bo(Ptrofs.unsigned po)16.
Definition Assertion1:Prop:=forall m bo bi po pi f,Inputs m bo bi po pi f->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate result Kstop mf)->result=Vint Int.zero\/result=Vint Int.one.
Definition Assertion2:Prop:=forall m bo bi pi f before after,Inputs m bo bi(Ptrofs.repr 4)pi f->
 Mem.load Mint32 m bo 0=Some(Vint before)->Mem.load Mint32 m bo 20=Some(Vint after)->forall t result mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi(Ptrofs.repr 4)pi)m)t(Returnstate result Kstop mf)->
 Frame m mf bo(Ptrofs.repr 4)/\Mem.load Mint32 mf bo 0=Some(Vint before)/\Mem.load Mint32 mf bo 20=Some(Vint after).
(* Actual property: float_mat_inv_2d.pointer_arithmetic.1; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)0 *)
Definition P001:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.2; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)0 *)
Definition P002:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.3; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)0 *)
Definition P003:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.4; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)0 *)
Definition P004:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.5; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)0 *)
Definition P005:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.6; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)0 *)
Definition P006:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.1; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)0] *)
Definition P007:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.2; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)0] *)
Definition P008:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.3; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)0] *)
Definition P009:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.4; SUCCESS. dereference failure: dead object in mat_in[(signed long int)0] *)
Definition P010:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.5; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)0] *)
Definition P011:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.6; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)0] *)
Definition P012:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.7; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)3 *)
Definition P013:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.8; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)3 *)
Definition P014:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.9; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)3 *)
Definition P015:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.10; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)3 *)
Definition P016:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.11; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)3 *)
Definition P017:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.12; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)3 *)
Definition P018:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.7; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)3] *)
Definition P019:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.8; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)3] *)
Definition P020:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.9; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)3] *)
Definition P021:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.10; SUCCESS. dereference failure: dead object in mat_in[(signed long int)3] *)
Definition P022:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.11; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)3] *)
Definition P023:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.12; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)3] *)
Definition P024:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.13; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)1 *)
Definition P025:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.14; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)1 *)
Definition P026:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.15; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)1 *)
Definition P027:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.16; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)1 *)
Definition P028:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.17; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)1 *)
Definition P029:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.18; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)1 *)
Definition P030:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.13; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)1] *)
Definition P031:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.14; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)1] *)
Definition P032:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.15; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)1] *)
Definition P033:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.16; SUCCESS. dereference failure: dead object in mat_in[(signed long int)1] *)
Definition P034:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.17; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)1] *)
Definition P035:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.18; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)1] *)
Definition P036:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.19; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)2 *)
Definition P037:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.20; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)2 *)
Definition P038:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.21; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)2 *)
Definition P039:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.22; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)2 *)
Definition P040:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.23; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)2 *)
Definition P041:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.24; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)2 *)
Definition P042:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.19; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)2] *)
Definition P043:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.20; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)2] *)
Definition P044:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.21; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)2] *)
Definition P045:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.22; SUCCESS. dereference failure: dead object in mat_in[(signed long int)2] *)
Definition P046:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.23; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)2] *)
Definition P047:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.24; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)2] *)
Definition P048:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.25; SUCCESS. pointer arithmetic: pointer NULL in inv_out + (signed long int)0 *)
Definition P049:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.26; SUCCESS. pointer arithmetic: pointer invalid in inv_out + (signed long int)0 *)
Definition P050:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.27; SUCCESS. pointer arithmetic: deallocated dynamic object in inv_out + (signed long int)0 *)
Definition P051:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.28; SUCCESS. pointer arithmetic: dead object in inv_out + (signed long int)0 *)
Definition P052:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.29; SUCCESS. pointer arithmetic: pointer outside object bounds in inv_out + (signed long int)0 *)
Definition P053:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.30; SUCCESS. pointer arithmetic: invalid integer address in inv_out + (signed long int)0 *)
Definition P054:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.25; SUCCESS. dereference failure: pointer NULL in inv_out[(signed long int)0] *)
Definition P055:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.26; SUCCESS. dereference failure: pointer invalid in inv_out[(signed long int)0] *)
Definition P056:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.27; SUCCESS. dereference failure: deallocated dynamic object in inv_out[(signed long int)0] *)
Definition P057:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.28; SUCCESS. dereference failure: dead object in inv_out[(signed long int)0] *)
Definition P058:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.29; SUCCESS. dereference failure: pointer outside object bounds in inv_out[(signed long int)0] *)
Definition P059:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.30; SUCCESS. dereference failure: invalid integer address in inv_out[(signed long int)0] *)
Definition P060:Prop:=SourceGuards 0 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.31; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)3 *)
Definition P061:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.32; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)3 *)
Definition P062:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.33; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)3 *)
Definition P063:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.34; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)3 *)
Definition P064:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.35; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)3 *)
Definition P065:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.36; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)3 *)
Definition P066:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.31; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)3] *)
Definition P067:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.32; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)3] *)
Definition P068:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.33; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)3] *)
Definition P069:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.34; SUCCESS. dereference failure: dead object in mat_in[(signed long int)3] *)
Definition P070:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.35; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)3] *)
Definition P071:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.36; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)3] *)
Definition P072:Prop:=SourceGuards 3 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.37; SUCCESS. pointer arithmetic: pointer NULL in inv_out + (signed long int)1 *)
Definition P073:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.38; SUCCESS. pointer arithmetic: pointer invalid in inv_out + (signed long int)1 *)
Definition P074:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.39; SUCCESS. pointer arithmetic: deallocated dynamic object in inv_out + (signed long int)1 *)
Definition P075:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.40; SUCCESS. pointer arithmetic: dead object in inv_out + (signed long int)1 *)
Definition P076:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.41; SUCCESS. pointer arithmetic: pointer outside object bounds in inv_out + (signed long int)1 *)
Definition P077:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.42; SUCCESS. pointer arithmetic: invalid integer address in inv_out + (signed long int)1 *)
Definition P078:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.37; SUCCESS. dereference failure: pointer NULL in inv_out[(signed long int)1] *)
Definition P079:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.38; SUCCESS. dereference failure: pointer invalid in inv_out[(signed long int)1] *)
Definition P080:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.39; SUCCESS. dereference failure: deallocated dynamic object in inv_out[(signed long int)1] *)
Definition P081:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.40; SUCCESS. dereference failure: dead object in inv_out[(signed long int)1] *)
Definition P082:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.41; SUCCESS. dereference failure: pointer outside object bounds in inv_out[(signed long int)1] *)
Definition P083:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.42; SUCCESS. dereference failure: invalid integer address in inv_out[(signed long int)1] *)
Definition P084:Prop:=SourceGuards 1 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.43; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)1 *)
Definition P085:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.44; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)1 *)
Definition P086:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.45; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)1 *)
Definition P087:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.46; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)1 *)
Definition P088:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.47; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)1 *)
Definition P089:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.48; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)1 *)
Definition P090:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.43; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)1] *)
Definition P091:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.44; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)1] *)
Definition P092:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.45; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)1] *)
Definition P093:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.46; SUCCESS. dereference failure: dead object in mat_in[(signed long int)1] *)
Definition P094:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.47; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)1] *)
Definition P095:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.48; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)1] *)
Definition P096:Prop:=SourceGuards 1 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.49; SUCCESS. pointer arithmetic: pointer NULL in inv_out + (signed long int)2 *)
Definition P097:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.50; SUCCESS. pointer arithmetic: pointer invalid in inv_out + (signed long int)2 *)
Definition P098:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.51; SUCCESS. pointer arithmetic: deallocated dynamic object in inv_out + (signed long int)2 *)
Definition P099:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.52; SUCCESS. pointer arithmetic: dead object in inv_out + (signed long int)2 *)
Definition P100:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.53; SUCCESS. pointer arithmetic: pointer outside object bounds in inv_out + (signed long int)2 *)
Definition P101:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.54; SUCCESS. pointer arithmetic: invalid integer address in inv_out + (signed long int)2 *)
Definition P102:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.49; SUCCESS. dereference failure: pointer NULL in inv_out[(signed long int)2] *)
Definition P103:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.50; SUCCESS. dereference failure: pointer invalid in inv_out[(signed long int)2] *)
Definition P104:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.51; SUCCESS. dereference failure: deallocated dynamic object in inv_out[(signed long int)2] *)
Definition P105:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.52; SUCCESS. dereference failure: dead object in inv_out[(signed long int)2] *)
Definition P106:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.53; SUCCESS. dereference failure: pointer outside object bounds in inv_out[(signed long int)2] *)
Definition P107:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.54; SUCCESS. dereference failure: invalid integer address in inv_out[(signed long int)2] *)
Definition P108:Prop:=SourceGuards 2 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.55; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)2 *)
Definition P109:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.56; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)2 *)
Definition P110:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.57; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)2 *)
Definition P111:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.58; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)2 *)
Definition P112:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.59; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)2 *)
Definition P113:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.60; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)2 *)
Definition P114:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.55; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)2] *)
Definition P115:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.56; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)2] *)
Definition P116:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.57; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)2] *)
Definition P117:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.58; SUCCESS. dereference failure: dead object in mat_in[(signed long int)2] *)
Definition P118:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.59; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)2] *)
Definition P119:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.60; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)2] *)
Definition P120:Prop:=SourceGuards 2 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.61; SUCCESS. pointer arithmetic: pointer NULL in inv_out + (signed long int)3 *)
Definition P121:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.62; SUCCESS. pointer arithmetic: pointer invalid in inv_out + (signed long int)3 *)
Definition P122:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.63; SUCCESS. pointer arithmetic: deallocated dynamic object in inv_out + (signed long int)3 *)
Definition P123:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.64; SUCCESS. pointer arithmetic: dead object in inv_out + (signed long int)3 *)
Definition P124:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.65; SUCCESS. pointer arithmetic: pointer outside object bounds in inv_out + (signed long int)3 *)
Definition P125:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.66; SUCCESS. pointer arithmetic: invalid integer address in inv_out + (signed long int)3 *)
Definition P126:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.61; SUCCESS. dereference failure: pointer NULL in inv_out[(signed long int)3] *)
Definition P127:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.62; SUCCESS. dereference failure: pointer invalid in inv_out[(signed long int)3] *)
Definition P128:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.63; SUCCESS. dereference failure: deallocated dynamic object in inv_out[(signed long int)3] *)
Definition P129:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.64; SUCCESS. dereference failure: dead object in inv_out[(signed long int)3] *)
Definition P130:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.65; SUCCESS. dereference failure: pointer outside object bounds in inv_out[(signed long int)3] *)
Definition P131:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_dereference.66; SUCCESS. dereference failure: invalid integer address in inv_out[(signed long int)3] *)
Definition P132:Prop:=SourceGuards 3 true.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.67; SUCCESS. pointer arithmetic: pointer NULL in mat_in + (signed long int)0 *)
Definition P133:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.68; SUCCESS. pointer arithmetic: pointer invalid in mat_in + (signed long int)0 *)
Definition P134:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.69; SUCCESS. pointer arithmetic: deallocated dynamic object in mat_in + (signed long int)0 *)
Definition P135:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.70; SUCCESS. pointer arithmetic: dead object in mat_in + (signed long int)0 *)
Definition P136:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.71; SUCCESS. pointer arithmetic: pointer outside object bounds in mat_in + (signed long int)0 *)
Definition P137:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_arithmetic.72; SUCCESS. pointer arithmetic: invalid integer address in mat_in + (signed long int)0 *)
Definition P138:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.67; SUCCESS. dereference failure: pointer NULL in mat_in[(signed long int)0] *)
Definition P139:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.68; SUCCESS. dereference failure: pointer invalid in mat_in[(signed long int)0] *)
Definition P140:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.69; SUCCESS. dereference failure: deallocated dynamic object in mat_in[(signed long int)0] *)
Definition P141:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.70; SUCCESS. dereference failure: dead object in mat_in[(signed long int)0] *)
Definition P142:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.71; SUCCESS. dereference failure: pointer outside object bounds in mat_in[(signed long int)0] *)
Definition P143:Prop:=SourceGuards 0 false.
(* Actual property: float_mat_inv_2d.pointer_dereference.72; SUCCESS. dereference failure: invalid integer address in mat_in[(signed long int)0] *)
Definition P144:Prop:=SourceGuards 0 false.
(* Actual property: main.assertion.1; SUCCESS. return status is boolean for arbitrary binary32 matrix *)
Definition P145:Prop:=Assertion1.
(* Actual property: main.assertion.2; SUCCESS. arbitrary matrix call preserves surrounding frame words *)
Definition P146:Prop:=Assertion2.
(* Actual property: memcpy.pointer_arithmetic.1; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(void * )small_before + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P147:Prop:=CopyGuard 2%nat.
(* Actual property: memcpy.pointer.1; SUCCESS. same object violation in (const unsigned char * )(const void * )small_out >= (const unsigned char * )(void * )small_before + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P148:Prop:=CopyGuard 0%nat.
(* Actual property: memcpy.pointer_arithmetic.2; SUCCESS. pointer relation: dead object in (const unsigned char * )(const void * )small_out *)
Definition P149:Prop:=CopyGuard 1%nat.
(* Actual property: memcpy.pointer_arithmetic.3; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(const void * )small_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P150:Prop:=CopyGuard 5%nat.
(* Actual property: memcpy.pointer.2; SUCCESS. same object violation in (const unsigned char * )(void * )small_before >= (const unsigned char * )(const void * )small_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P151:Prop:=CopyGuard 3%nat.
(* Actual property: memcpy.pointer_arithmetic.4; SUCCESS. pointer relation: dead object in (const unsigned char * )(void * )small_before *)
Definition P152:Prop:=CopyGuard 4%nat.
(* Actual property: main.precondition_instance.1; SUCCESS. memcpy src/dst overlap *)
Definition P153:Prop:=CopyGuard 6%nat.
(* Actual property: main.precondition_instance.2; SUCCESS. memcpy source region readable *)
Definition P154:Prop:=CopyGuard 7%nat.
(* Actual property: main.precondition_instance.3; SUCCESS. memcpy destination region writeable *)
Definition P155:Prop:=CopyGuard 8%nat.
(* Actual property: memcpy.pointer_arithmetic.5; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(void * )base_words + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P156:Prop:=CopyGuard 2%nat.
(* Actual property: memcpy.pointer.3; SUCCESS. same object violation in (const unsigned char * )(const void * )base_out >= (const unsigned char * )(void * )base_words + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P157:Prop:=CopyGuard 0%nat.
(* Actual property: memcpy.pointer_arithmetic.6; SUCCESS. pointer relation: dead object in (const unsigned char * )(const void * )base_out *)
Definition P158:Prop:=CopyGuard 1%nat.
(* Actual property: memcpy.pointer_arithmetic.7; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(const void * )base_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P159:Prop:=CopyGuard 5%nat.
(* Actual property: memcpy.pointer.4; SUCCESS. same object violation in (const unsigned char * )(void * )base_words >= (const unsigned char * )(const void * )base_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P160:Prop:=CopyGuard 3%nat.
(* Actual property: memcpy.pointer_arithmetic.8; SUCCESS. pointer relation: dead object in (const unsigned char * )(void * )base_words *)
Definition P161:Prop:=CopyGuard 4%nat.
(* Actual property: main.precondition_instance.4; SUCCESS. memcpy src/dst overlap *)
Definition P162:Prop:=CopyGuard 6%nat.
(* Actual property: main.precondition_instance.5; SUCCESS. memcpy source region readable *)
Definition P163:Prop:=CopyGuard 7%nat.
(* Actual property: main.precondition_instance.6; SUCCESS. memcpy destination region writeable *)
Definition P164:Prop:=CopyGuard 8%nat.
(* Actual property: memcpy.pointer_arithmetic.9; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(void * )small_after + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P165:Prop:=CopyGuard 2%nat.
(* Actual property: memcpy.pointer.5; SUCCESS. same object violation in (const unsigned char * )(const void * )small_out >= (const unsigned char * )(void * )small_after + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P166:Prop:=CopyGuard 0%nat.
(* Actual property: memcpy.pointer_arithmetic.10; SUCCESS. pointer relation: dead object in (const unsigned char * )(const void * )small_out *)
Definition P167:Prop:=CopyGuard 1%nat.
(* Actual property: memcpy.pointer_arithmetic.11; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(const void * )small_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P168:Prop:=CopyGuard 5%nat.
(* Actual property: memcpy.pointer.6; SUCCESS. same object violation in (const unsigned char * )(void * )small_after >= (const unsigned char * )(const void * )small_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P169:Prop:=CopyGuard 3%nat.
(* Actual property: memcpy.pointer_arithmetic.12; SUCCESS. pointer relation: dead object in (const unsigned char * )(void * )small_after *)
Definition P170:Prop:=CopyGuard 4%nat.
(* Actual property: main.precondition_instance.7; SUCCESS. memcpy src/dst overlap *)
Definition P171:Prop:=CopyGuard 6%nat.
(* Actual property: main.precondition_instance.8; SUCCESS. memcpy source region readable *)
Definition P172:Prop:=CopyGuard 7%nat.
(* Actual property: main.precondition_instance.9; SUCCESS. memcpy destination region writeable *)
Definition P173:Prop:=CopyGuard 8%nat.
(* Actual property: memcpy.pointer_arithmetic.13; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(void * )large_words + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P174:Prop:=CopyGuard 2%nat.
(* Actual property: memcpy.pointer.7; SUCCESS. same object violation in (const unsigned char * )(const void * )large_out >= (const unsigned char * )(void * )large_words + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P175:Prop:=CopyGuard 0%nat.
(* Actual property: memcpy.pointer_arithmetic.14; SUCCESS. pointer relation: dead object in (const unsigned char * )(const void * )large_out *)
Definition P176:Prop:=CopyGuard 1%nat.
(* Actual property: memcpy.pointer_arithmetic.15; SUCCESS. pointer arithmetic: dead object in (const unsigned char * )(const void * )large_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P177:Prop:=CopyGuard 5%nat.
(* Actual property: memcpy.pointer.8; SUCCESS. same object violation in (const unsigned char * )(void * )large_words >= (const unsigned char * )(const void * )large_out + (signed long int)sizeof(float [4l]) /*16ul*/  *)
Definition P178:Prop:=CopyGuard 3%nat.
(* Actual property: memcpy.pointer_arithmetic.16; SUCCESS. pointer relation: dead object in (const unsigned char * )(void * )large_words *)
Definition P179:Prop:=CopyGuard 4%nat.
(* Actual property: main.precondition_instance.10; SUCCESS. memcpy src/dst overlap *)
Definition P180:Prop:=CopyGuard 6%nat.
(* Actual property: main.precondition_instance.11; SUCCESS. memcpy source region readable *)
Definition P181:Prop:=CopyGuard 7%nat.
(* Actual property: main.precondition_instance.12; SUCCESS. memcpy destination region writeable *)
Definition P182:Prop:=CopyGuard 8%nat.
(* Actual property: main.assertion.3; SUCCESS. identity call succeeds *)
Definition P183:Prop:=CaseStatus base2(Vint Int.zero).
(* Actual property: main.assertion.4; SUCCESS. identity exact signedzero output bits *)
Definition P184:Prop:=CaseWords base2[1065353216;2147483648;2147483648;1065353216].
(* Actual property: main.assertion.5; SUCCESS. small conditionone diagonal call rejects *)
Definition P185:Prop:=CaseStatus small2(Vint Int.one).
(* Actual property: main.assertion.6; SUCCESS. rejected call preserves every output byte *)
Definition P186:Prop:=CasePreserves small2.
(* Actual property: main.assertion.7; SUCCESS. finite large diagonal call reports success *)
Definition P187:Prop:=CaseStatus large2(Vint Int.zero).
(* Actual property: main.assertion.8; SUCCESS. overflow determinant exact signedzero output bits *)
Definition P188:Prop:=CaseWords large2[0;2147483648;2147483648;0].
(* Actual property: main.assertion.9; FAILURE. positive scaling preserves inverse status *)
Definition P189:Prop:=OriginalReplay /\ Result base2<>Result small2 /\ TraceNonempty.
(* Actual property: main.assertion.10; FAILURE. successful wellconditioned inverse has residual component below half *)
Definition P190:Prop:=OriginalReplay /\ Result large2=Vint Int.zero /\ SmallResidual(residual2 large2)=false /\ Float32.to_bits(residual2 large2)=Int.repr 3212836864 /\ TraceNonempty.
