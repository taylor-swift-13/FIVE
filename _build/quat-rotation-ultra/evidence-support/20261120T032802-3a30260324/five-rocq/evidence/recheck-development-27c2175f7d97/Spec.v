From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassSupport Require Import LowpassMemory.
From FiveRmatVmult Require Import Source Execution.
From FiveRmatVmultCase Require Import Contract.
From FiveRmatVmultNoError Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.
Inductive GuardKind := Dst(delta:Z)|MatrixBase|Src(i:Z)|Index(i:Z).
Definition ValidKind(k:GuardKind):Prop :=match k with Dst d=>In d[0;4;8]|MatrixBase=>True|Src i=>0<=i<3|Index i=>0<=i<9 end.
Definition FieldValid(m:mem)(b:block)(p:ptrofs)(delta:Z)(perm:permission):Prop :=
 Mem.valid_block m b /\Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr delta))=Ptrofs.unsigned p+delta /\
 Ptrofs.unsigned p+delta+4<=Ptrofs.modulus /\Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+delta)perm.
Definition SourceFields(m:mem)(b:block)(p:ptrofs)(n:Z):Prop :=
 Mem.valid_block m b /\forall i,0<=i<n->FieldValid m b p(4*i)Readable.
Definition SiteFacts(k:GuardKind):Prop :=forall args m,Contract.Precondition args m->
 exists bo br bv po pr pv f v,args=Args bo br bv po pr pv /\Reads m br pr 9 f /\Reads m bv pv 3 v /\
 match k with
 |Dst delta=>FieldValid m bo po delta Writable
 |MatrixBase=>SourceFields m br pr 9
 |Src i=>FieldValid m bv pv(4*i)Readable
 |Index i=>0<=i<9 /\FieldValid m br pr(4*i)Readable
 end.
Definition ExactObservation:Prop :=forall m bo br bv po pr pv f v,
 bo<>br->bo<>bv->br<>bv->writable12 m bo po->Reads m br pr 9 f->Reads m bv pv 3 v->
 exists mf,(exists t,star Csem.step Execution.ge(Execution.entry(Args bo br bv po pr pv)m)t(Returnstate Vundef Kstop mf)) /\
 Mem.loadbytes mf bo(Ptrofs.unsigned po)12=Some(encode_val Mfloat32(Vsingle(Row f v 0))++encode_val Mfloat32(Vsingle(Row f v 3))++encode_val Mfloat32(Vsingle(Row f v 6))) /\
 Frame m mf bo po /\
 (forall t vr mr,star Csem.step Execution.ge(Execution.entry(Args bo br bv po pr pv)m)t(Returnstate vr Kstop mr)->vr=Vundef /\mr=mf).
Definition RuntimeContexts:Prop :=forall args m,Contract.Precondition args m->
 forall t f a k e mm,star Csem.step Execution.ge(Execution.entry args m)t(ExprState f a k e mm)->
 Csem.not_stuck Execution.ge e a mm.
Definition RuntimeLoads:Prop :=forall args m,Contract.Precondition args m->
 forall t f k e mm C b p,star Csem.step Execution.ge(Execution.entry args m)t
 (ExprState f(C(Evalof(Eloc b p Full tfloat)tfloat))k e mm)->context RV RV C->
 exists value,Mem.loadv Mfloat32 mm(Vptr b p)=Some value.
Definition RuntimeStores:Prop :=forall args m,Contract.Precondition args m->
 forall t f k e mm C b p x,star Csem.step Execution.ge(Execution.entry args m)t
 (ExprState f(C(Eassign(Eloc b p Full tfloat)(Eval(Vsingle x)tfloat)tfloat))k e mm)->context RV RV C->
 exists mf,Mem.storev Mfloat32 mm(Vptr b p)(Vsingle x)=Some mf.
Definition RuntimeDefined:Prop :=RuntimeContexts /\RuntimeLoads /\RuntimeStores.
Fixpoint ExprNodes(a:expr):list expr := a::match a with
 |Evalof x _|Ederef x _|Efield x _ _|Eaddrof x _|Ecast x _|Eunop _ x _=>ExprNodes x
 |Ebinop _ x y _|Eassign x y _|Eassignop _ x y _ _=>ExprNodes x++ExprNodes y
 |_=>[] end.
Definition OriginalAssignments:list expr :=match fn_body Source.f_float_rmat_vmult with
 |Ssequence(Sdo a)(Ssequence(Sdo b)(Sdo c))=>[a;b;c]|_=>[]end.
Definition OriginalNodes:list expr := List.concat(map ExprNodes OriginalAssignments).
Definition OriginalSite(k:GuardKind):expr :=match k with
 |Dst d=>Field Source._vb(if Z.eqb d 0 then Source._x else if Z.eqb d 4 then Source._y else Source._z)
 |MatrixBase=>Evalof(Efield(Evalof(Ederef(Ptr Source._m_a2b rt)rt)rt)Source._m(tarray tfloat 9))(tarray tfloat 9)
 |Src i=>Vec(if Z.eqb i 0 then Source._x else if Z.eqb i 1 then Source._y else Source._z)
 |Index i=>Mat i end.
Definition SourceOccurrence(k:GuardKind):Prop :=In(OriginalSite k)OriginalNodes.
Definition MappedGoal(k:GuardKind):Prop :=FiveRmatVmultNoError.Spec.NoError /\SiteFacts k /\SourceOccurrence k /\RuntimeDefined /\ExactObservation.
Definition OriginalLedger:list(string*GuardKind):=[
 ("float_rmat_vmult.pointer_dereference.1",Dst 0);
 ("float_rmat_vmult.pointer_dereference.2",Dst 0);
 ("float_rmat_vmult.pointer_dereference.3",Dst 0);
 ("float_rmat_vmult.pointer_dereference.4",Dst 0);
 ("float_rmat_vmult.pointer_dereference.5",Dst 0);
 ("float_rmat_vmult.pointer_dereference.6",Dst 0);
 ("float_rmat_vmult.pointer_dereference.7",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.8",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.9",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.10",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.11",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.12",MatrixBase);
 ("float_rmat_vmult.array_bounds.1",Index 0);
 ("float_rmat_vmult.pointer_dereference.13",Src 0);
 ("float_rmat_vmult.pointer_dereference.14",Src 0);
 ("float_rmat_vmult.pointer_dereference.15",Src 0);
 ("float_rmat_vmult.pointer_dereference.16",Src 0);
 ("float_rmat_vmult.pointer_dereference.17",Src 0);
 ("float_rmat_vmult.pointer_dereference.18",Src 0);
 ("float_rmat_vmult.array_bounds.2",Index 1);
 ("float_rmat_vmult.pointer_dereference.19",Src 1);
 ("float_rmat_vmult.pointer_dereference.20",Src 1);
 ("float_rmat_vmult.pointer_dereference.21",Src 1);
 ("float_rmat_vmult.pointer_dereference.22",Src 1);
 ("float_rmat_vmult.pointer_dereference.23",Src 1);
 ("float_rmat_vmult.pointer_dereference.24",Src 1);
 ("float_rmat_vmult.array_bounds.3",Index 2);
 ("float_rmat_vmult.pointer_dereference.25",Src 2);
 ("float_rmat_vmult.pointer_dereference.26",Src 2);
 ("float_rmat_vmult.pointer_dereference.27",Src 2);
 ("float_rmat_vmult.pointer_dereference.28",Src 2);
 ("float_rmat_vmult.pointer_dereference.29",Src 2);
 ("float_rmat_vmult.pointer_dereference.30",Src 2);
 ("float_rmat_vmult.pointer_dereference.31",Dst 4);
 ("float_rmat_vmult.pointer_dereference.32",Dst 4);
 ("float_rmat_vmult.pointer_dereference.33",Dst 4);
 ("float_rmat_vmult.pointer_dereference.34",Dst 4);
 ("float_rmat_vmult.pointer_dereference.35",Dst 4);
 ("float_rmat_vmult.pointer_dereference.36",Dst 4);
 ("float_rmat_vmult.pointer_dereference.37",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.38",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.39",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.40",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.41",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.42",MatrixBase);
 ("float_rmat_vmult.array_bounds.4",Index 3);
 ("float_rmat_vmult.pointer_dereference.43",Src 0);
 ("float_rmat_vmult.pointer_dereference.44",Src 0);
 ("float_rmat_vmult.pointer_dereference.45",Src 0);
 ("float_rmat_vmult.pointer_dereference.46",Src 0);
 ("float_rmat_vmult.pointer_dereference.47",Src 0);
 ("float_rmat_vmult.pointer_dereference.48",Src 0);
 ("float_rmat_vmult.array_bounds.5",Index 4);
 ("float_rmat_vmult.pointer_dereference.49",Src 1);
 ("float_rmat_vmult.pointer_dereference.50",Src 1);
 ("float_rmat_vmult.pointer_dereference.51",Src 1);
 ("float_rmat_vmult.pointer_dereference.52",Src 1);
 ("float_rmat_vmult.pointer_dereference.53",Src 1);
 ("float_rmat_vmult.pointer_dereference.54",Src 1);
 ("float_rmat_vmult.array_bounds.6",Index 5);
 ("float_rmat_vmult.pointer_dereference.55",Src 2);
 ("float_rmat_vmult.pointer_dereference.56",Src 2);
 ("float_rmat_vmult.pointer_dereference.57",Src 2);
 ("float_rmat_vmult.pointer_dereference.58",Src 2);
 ("float_rmat_vmult.pointer_dereference.59",Src 2);
 ("float_rmat_vmult.pointer_dereference.60",Src 2);
 ("float_rmat_vmult.pointer_dereference.61",Dst 8);
 ("float_rmat_vmult.pointer_dereference.62",Dst 8);
 ("float_rmat_vmult.pointer_dereference.63",Dst 8);
 ("float_rmat_vmult.pointer_dereference.64",Dst 8);
 ("float_rmat_vmult.pointer_dereference.65",Dst 8);
 ("float_rmat_vmult.pointer_dereference.66",Dst 8);
 ("float_rmat_vmult.pointer_dereference.67",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.68",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.69",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.70",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.71",MatrixBase);
 ("float_rmat_vmult.pointer_dereference.72",MatrixBase);
 ("float_rmat_vmult.array_bounds.7",Index 6);
 ("float_rmat_vmult.pointer_dereference.73",Src 0);
 ("float_rmat_vmult.pointer_dereference.74",Src 0);
 ("float_rmat_vmult.pointer_dereference.75",Src 0);
 ("float_rmat_vmult.pointer_dereference.76",Src 0);
 ("float_rmat_vmult.pointer_dereference.77",Src 0);
 ("float_rmat_vmult.pointer_dereference.78",Src 0);
 ("float_rmat_vmult.array_bounds.8",Index 7);
 ("float_rmat_vmult.pointer_dereference.79",Src 1);
 ("float_rmat_vmult.pointer_dereference.80",Src 1);
 ("float_rmat_vmult.pointer_dereference.81",Src 1);
 ("float_rmat_vmult.pointer_dereference.82",Src 1);
 ("float_rmat_vmult.pointer_dereference.83",Src 1);
 ("float_rmat_vmult.pointer_dereference.84",Src 1);
 ("float_rmat_vmult.array_bounds.9",Index 8);
 ("float_rmat_vmult.pointer_dereference.85",Src 2);
 ("float_rmat_vmult.pointer_dereference.86",Src 2);
 ("float_rmat_vmult.pointer_dereference.87",Src 2);
 ("float_rmat_vmult.pointer_dereference.88",Src 2);
 ("float_rmat_vmult.pointer_dereference.89",Src 2);
 ("float_rmat_vmult.pointer_dereference.90",Src 2)].
Definition AllOriginal99:Prop := forall id k,In(id,k)OriginalLedger->MappedGoal k.
