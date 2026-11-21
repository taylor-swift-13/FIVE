From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveQuatVmult Require Import Source Execution.
From FiveQuatVmultCase Require Import Contract Body.
From FiveQuatVmultNoError Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.
Inductive GuardKind := QuaternionField(delta:Z)|InputField(delta:Z)|OutputField(delta:Z).
Definition ValidKind(k:GuardKind):Prop:=match k with QuaternionField d=>In d[0;4;8;12]|_=>match k with InputField d|OutputField d=>In d[0;4;8]|_=>False end end.
Definition FieldValid(m:mem)(b:block)(delta:Z)(p:permission):Prop:=Mem.valid_block m b /\
 Ptrofs.unsigned(Ptrofs.repr delta)=delta /\delta+4<=Ptrofs.modulus /\Mem.valid_access m Mfloat32 b delta p.
Definition SiteFacts(k:GuardKind):Prop:=forall args m,Contract.Precondition args m->
 exists q v out qi qx qy qz vx vy vz,args=Args out q v /\Inputs m q v out qi qx qy qz vx vy vz /\
 match k with QuaternionField d=>FieldValid m q d Readable|InputField d=>FieldValid m v d Readable|OutputField d=>FieldValid m out d Writable end.
Definition RuntimeContexts:Prop:=forall args m,Contract.Precondition args m->forall t f a k e mm,
 star Csem.step Execution.ge(Execution.entry args m)t(ExprState f a k e mm)->Csem.not_stuck Execution.ge e a mm.
Definition RuntimeLoads:Prop:=forall args m,Contract.Precondition args m->forall t f k e mm C b p,
 star Csem.step Execution.ge(Execution.entry args m)t(ExprState f(C(Evalof(Eloc b p Full tfloat)tfloat))k e mm)->
 context RV RV C->exists value,Mem.loadv Mfloat32 mm(Vptr b p)=Some value.
Definition RuntimeStores:Prop:=forall args m,Contract.Precondition args m->forall t f k e mm C b p x,
 star Csem.step Execution.ge(Execution.entry args m)t(ExprState f(C(Eassign(Eloc b p Full tfloat)(Eval(Vsingle x)tfloat)tfloat))k e mm)->
 context RV RV C->exists mf,Mem.storev Mfloat32 mm(Vptr b p)(Vsingle x)=Some mf.
Definition RuntimeDefined:Prop:=RuntimeContexts /\RuntimeLoads /\RuntimeStores.
Definition ExactObservation:Prop:=forall m q v out qi qx qy qz vx vy vz,Inputs m q v out qi qx qy qz vx vy vz->
 exists mf,(exists t,star Csem.step Execution.ge(Execution.entry(Args out q v)m)t(Returnstate Vundef Kstop mf)) /\
 Mem.loadbytes mf out 0 12=Some(encode_val Mfloat32(Vsingle(output_x qi qx qy qz vx vy vz))++encode_val Mfloat32(Vsingle(output_y qi qx qy qz vx vy vz))++encode_val Mfloat32(Vsingle(output_z qi qx qy qz vx vy vz))) /\
 (forall b z n,Mem.valid_block m b->(b<>out\/z+n<=0\/12<=z)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n) /\
 access_kept m mf /\
 (forall t vr mr,star Csem.step Execution.ge(Execution.entry(Args out q v)m)t(Returnstate vr Kstop mr)->vr=Vundef /\mr=mf).
Fixpoint ExprNodes(a:expr):list expr:=a::match a with
 |Evalof x _|Ederef x _|Efield x _ _|Eaddrof x _|Ecast x _|Eunop _ x _=>ExprNodes x
 |Ebinop _ x y _|Eassign x y _|Eassignop _ x y _ _=>ExprNodes x++ExprNodes y|_=>[]end.
Definition Field(id sid fid:ident):expr:=Efield(Evalof(Ederef(Evalof(Evar id(tptr(Tstruct sid noattr)))(tptr(Tstruct sid noattr)))(Tstruct sid noattr))(Tstruct sid noattr))fid tfloat.
Definition OriginalSite(k:GuardKind):expr:=match k with
 |QuaternionField d=>Field Source._q Source._FloatQuat(if Z.eqb d 0 then Source._qi else if Z.eqb d 4 then Source._qx else if Z.eqb d 8 then Source._qy else Source._qz)
 |InputField d=>Field Source._v_in Source._FloatVect3(if Z.eqb d 0 then Source._x else if Z.eqb d 4 then Source._y else Source._z)
 |OutputField d=>Field Source._v_out Source._FloatVect3(if Z.eqb d 0 then Source._x else if Z.eqb d 4 then Source._y else Source._z)end.
Definition SourceOccurrence(k:GuardKind):Prop:=exists index node a,nth_error Body.acts index=Some a /\nth_error(ExprNodes a)node=Some(OriginalSite k).
Definition MappedGoal(k:GuardKind):Prop:=FiveQuatVmultNoError.Spec.NoError /\SiteFacts k /\SourceOccurrence k /\RuntimeDefined /\ExactObservation.
Definition OriginalLedger:list(string*GuardKind):=[
("float_quat_vmult.pointer_dereference.1",QuaternionField 0);
("float_quat_vmult.pointer_dereference.2",QuaternionField 0);
("float_quat_vmult.pointer_dereference.3",QuaternionField 0);
("float_quat_vmult.pointer_dereference.4",QuaternionField 0);
("float_quat_vmult.pointer_dereference.5",QuaternionField 0);
("float_quat_vmult.pointer_dereference.6",QuaternionField 0);
("float_quat_vmult.pointer_dereference.7",QuaternionField 4);
("float_quat_vmult.pointer_dereference.8",QuaternionField 4);
("float_quat_vmult.pointer_dereference.9",QuaternionField 4);
("float_quat_vmult.pointer_dereference.10",QuaternionField 4);
("float_quat_vmult.pointer_dereference.11",QuaternionField 4);
("float_quat_vmult.pointer_dereference.12",QuaternionField 4);
("float_quat_vmult.pointer_dereference.13",QuaternionField 8);
("float_quat_vmult.pointer_dereference.14",QuaternionField 8);
("float_quat_vmult.pointer_dereference.15",QuaternionField 8);
("float_quat_vmult.pointer_dereference.16",QuaternionField 8);
("float_quat_vmult.pointer_dereference.17",QuaternionField 8);
("float_quat_vmult.pointer_dereference.18",QuaternionField 8);
("float_quat_vmult.pointer_dereference.19",QuaternionField 12);
("float_quat_vmult.pointer_dereference.20",QuaternionField 12);
("float_quat_vmult.pointer_dereference.21",QuaternionField 12);
("float_quat_vmult.pointer_dereference.22",QuaternionField 12);
("float_quat_vmult.pointer_dereference.23",QuaternionField 12);
("float_quat_vmult.pointer_dereference.24",QuaternionField 12);
("float_quat_vmult.pointer_dereference.25",OutputField 0);
("float_quat_vmult.pointer_dereference.26",OutputField 0);
("float_quat_vmult.pointer_dereference.27",OutputField 0);
("float_quat_vmult.pointer_dereference.28",OutputField 0);
("float_quat_vmult.pointer_dereference.29",OutputField 0);
("float_quat_vmult.pointer_dereference.30",OutputField 0);
("float_quat_vmult.pointer_dereference.31",InputField 0);
("float_quat_vmult.pointer_dereference.32",InputField 0);
("float_quat_vmult.pointer_dereference.33",InputField 0);
("float_quat_vmult.pointer_dereference.34",InputField 0);
("float_quat_vmult.pointer_dereference.35",InputField 0);
("float_quat_vmult.pointer_dereference.36",InputField 0);
("float_quat_vmult.pointer_dereference.37",InputField 4);
("float_quat_vmult.pointer_dereference.38",InputField 4);
("float_quat_vmult.pointer_dereference.39",InputField 4);
("float_quat_vmult.pointer_dereference.40",InputField 4);
("float_quat_vmult.pointer_dereference.41",InputField 4);
("float_quat_vmult.pointer_dereference.42",InputField 4);
("float_quat_vmult.pointer_dereference.43",InputField 8);
("float_quat_vmult.pointer_dereference.44",InputField 8);
("float_quat_vmult.pointer_dereference.45",InputField 8);
("float_quat_vmult.pointer_dereference.46",InputField 8);
("float_quat_vmult.pointer_dereference.47",InputField 8);
("float_quat_vmult.pointer_dereference.48",InputField 8);
("float_quat_vmult.pointer_dereference.49",OutputField 4);
("float_quat_vmult.pointer_dereference.50",OutputField 4);
("float_quat_vmult.pointer_dereference.51",OutputField 4);
("float_quat_vmult.pointer_dereference.52",OutputField 4);
("float_quat_vmult.pointer_dereference.53",OutputField 4);
("float_quat_vmult.pointer_dereference.54",OutputField 4);
("float_quat_vmult.pointer_dereference.55",InputField 0);
("float_quat_vmult.pointer_dereference.56",InputField 0);
("float_quat_vmult.pointer_dereference.57",InputField 0);
("float_quat_vmult.pointer_dereference.58",InputField 0);
("float_quat_vmult.pointer_dereference.59",InputField 0);
("float_quat_vmult.pointer_dereference.60",InputField 0);
("float_quat_vmult.pointer_dereference.61",InputField 4);
("float_quat_vmult.pointer_dereference.62",InputField 4);
("float_quat_vmult.pointer_dereference.63",InputField 4);
("float_quat_vmult.pointer_dereference.64",InputField 4);
("float_quat_vmult.pointer_dereference.65",InputField 4);
("float_quat_vmult.pointer_dereference.66",InputField 4);
("float_quat_vmult.pointer_dereference.67",InputField 8);
("float_quat_vmult.pointer_dereference.68",InputField 8);
("float_quat_vmult.pointer_dereference.69",InputField 8);
("float_quat_vmult.pointer_dereference.70",InputField 8);
("float_quat_vmult.pointer_dereference.71",InputField 8);
("float_quat_vmult.pointer_dereference.72",InputField 8);
("float_quat_vmult.pointer_dereference.73",OutputField 8);
("float_quat_vmult.pointer_dereference.74",OutputField 8);
("float_quat_vmult.pointer_dereference.75",OutputField 8);
("float_quat_vmult.pointer_dereference.76",OutputField 8);
("float_quat_vmult.pointer_dereference.77",OutputField 8);
("float_quat_vmult.pointer_dereference.78",OutputField 8);
("float_quat_vmult.pointer_dereference.79",InputField 0);
("float_quat_vmult.pointer_dereference.80",InputField 0);
("float_quat_vmult.pointer_dereference.81",InputField 0);
("float_quat_vmult.pointer_dereference.82",InputField 0);
("float_quat_vmult.pointer_dereference.83",InputField 0);
("float_quat_vmult.pointer_dereference.84",InputField 0);
("float_quat_vmult.pointer_dereference.85",InputField 4);
("float_quat_vmult.pointer_dereference.86",InputField 4);
("float_quat_vmult.pointer_dereference.87",InputField 4);
("float_quat_vmult.pointer_dereference.88",InputField 4);
("float_quat_vmult.pointer_dereference.89",InputField 4);
("float_quat_vmult.pointer_dereference.90",InputField 4);
("float_quat_vmult.pointer_dereference.91",InputField 8);
("float_quat_vmult.pointer_dereference.92",InputField 8);
("float_quat_vmult.pointer_dereference.93",InputField 8);
("float_quat_vmult.pointer_dereference.94",InputField 8);
("float_quat_vmult.pointer_dereference.95",InputField 8);
("float_quat_vmult.pointer_dereference.96",InputField 8)].
Definition AllOriginal96:Prop:=forall id k,In(id,k)OriginalLedger->MappedGoal k.
