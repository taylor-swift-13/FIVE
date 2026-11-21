From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Ctypes Csem Smallstep Globalenvs.
From FiveGuidanceAllOrder Require Import CallfreeExecution.
Require FiveQuatVmult.Execution FiveRmatOfQuat.Execution FiveRmatVmult.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition f32 (z:Z) := Vsingle (Float32.of_bits (Int.repr z)).
Fixpoint put (m:mem) (b:block) (ofs:Z) (bits:list Z) : option mem :=
 match bits with []=>Some m | z::zs=>match Mem.store Mfloat32 m b ofs (f32 z) with Some m'=>put m' b (ofs+4) zs|None=>None end end.
Record fixture := Fixture { initial:mem; qb:block; vb:block; ab:block; rb:block; bb:block; ca:block; cb:block }.
Definition global_initial : option mem := Genv.init_mem FiveQuatVmult.Source.prog.
Definition base_memory : mem := match global_initial with Some m=>m|None=>Mem.empty end.
Definition make_fixture (q v:list Z):option fixture :=
 let '(m1,bq):=Mem.alloc base_memory 0 16 in
 let '(m2,bv):=Mem.alloc m1 0 12 in
 let '(m3,ba):=Mem.alloc m2 0 12 in
 let '(m4,br):=Mem.alloc m3 0 36 in
 let '(m5,bb):=Mem.alloc m4 0 12 in
 let '(m6,bca):=Mem.alloc m5 0 12 in
 let '(m7,bcb):=Mem.alloc m6 0 12 in
 match put m7 bq 0 q with Some m8=>match put m8 bv 0 v with
 |Some m9=>Some(Fixture m9 bq bv ba br bb bca bcb)|None=>None end|None=>None end.
Definition force_fixture(x:option fixture):fixture := match x with Some f=>f|None=>Fixture Mem.empty 1%positive 1%positive 1%positive 1%positive 1%positive 1%positive 1%positive end.
Definition q_unit:list Z:=[1065353216;0;0;0].
Definition v_unit:list Z:=[1065353216;0;0].
Definition q_trace:list Z:=[3208096458;3191717350;2687829235;268909329].
Definition v_trace:list Z:=[1124089879;1149239296;2382364672].
Definition unit_fixture:=force_fixture(make_fixture q_unit v_unit).
Definition trace_fixture:=force_fixture(make_fixture q_trace v_trace).
Definition args_direct(f:fixture):list val :=[Vptr(ab f)Ptrofs.zero;Vptr(qb f)Ptrofs.zero;Vptr(vb f)Ptrofs.zero].
Definition args_matrix(f:fixture):list val :=[Vptr(rb f)Ptrofs.zero;Vptr(qb f)Ptrofs.zero].
Definition args_vmult(f:fixture):list val :=[Vptr(bb f)Ptrofs.zero;Vptr(rb f)Ptrofs.zero;Vptr(vb f)Ptrofs.zero].
Definition after (o:option(val*mem)):mem:=match o with Some(_,m)=>m|None=>Mem.empty end.
Definition md(f:fixture):mem:=after(state_eval FiveQuatVmult.Execution.ge(FiveQuatVmult.Execution.entry(args_direct f)(initial f))).
Definition mr(f:fixture):mem:=after(state_eval FiveRmatOfQuat.Execution.ge(FiveRmatOfQuat.Execution.entry(args_matrix f)(md f))).
Definition mf(f:fixture):mem:=after(state_eval FiveRmatVmult.Execution.ge(FiveRmatVmult.Execution.entry(args_vmult f)(mr f))).
Definition evaluated(f:fixture):Prop:=
 state_eval FiveQuatVmult.Execution.ge(FiveQuatVmult.Execution.entry(args_direct f)(initial f))=Some(Vundef,md f) /\
 state_eval FiveRmatOfQuat.Execution.ge(FiveRmatOfQuat.Execution.entry(args_matrix f)(md f))=Some(Vundef,mr f) /\
 state_eval FiveRmatVmult.Execution.ge(FiveRmatVmult.Execution.entry(args_vmult f)(mr f))=Some(Vundef,mf f).
Definition output_bits(m:mem)(b:block):option(list Z):=
 match Mem.load Mfloat32 m b 0,Mem.load Mfloat32 m b 4,Mem.load Mfloat32 m b 8 with
 |Some(Vsingle x),Some(Vsingle y),Some(Vsingle z)=>Some[Int.unsigned(Float32.to_bits x);Int.unsigned(Float32.to_bits y);Int.unsigned(Float32.to_bits z)]|_,_,_=>None end.
