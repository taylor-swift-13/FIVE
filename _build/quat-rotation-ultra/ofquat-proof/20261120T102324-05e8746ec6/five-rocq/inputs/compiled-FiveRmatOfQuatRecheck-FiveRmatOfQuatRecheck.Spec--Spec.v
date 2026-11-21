From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Base Contract Body Output.
From FiveRmatOfQuatNoError Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.
Inductive GuardKind:=Qfield(i:Z)|MatrixBase|Index(i:Z).
Definition ValidKind(k:GuardKind):Prop:=match k with Qfield i=>0<=i<4|MatrixBase=>True|Index i=>0<=i<9 end.
Definition FieldValid(m:mem)(b:block)(delta:Z)(perm:permission):Prop:=Mem.valid_block m b /\ Ptrofs.unsigned(Ptrofs.repr delta)=delta /\delta+4<=Ptrofs.modulus /\ Mem.valid_access m Mfloat32 b delta perm.
Definition SiteFacts(k:GuardKind):Prop:=forall args m,Contract.Precondition args m->exists q out qi qx qy qz,
 args=Args out q /\Inputs m q out qi qx qy qz /\
 match k with Qfield i=>FieldValid m q(4*i)Readable|MatrixBase=>Mem.valid_block m out /\forall i,0<=i<9->FieldValid m out(4*i)Writable|Index i=>0<=i<9 /\FieldValid m out(4*i)Writable end.
Definition ExactObservation:Prop:=forall m q out qi qx qy qz,Inputs m q out qi qx qy qz->exists mf,
 (exists t,star Csem.step Execution.ge(Execution.entry(Args out q)m)t(Returnstate Vundef Kstop mf)) /\
 Mem.loadbytes mf out 0 36=Some(matrix_bytes(matrix_values qi qx qy qz)) /\
 (forall i:nat,(i<9)%nat->Mem.load Mfloat32 mf out(Z.of_nat i*4)=Some(Vsingle(nth i(matrix_values qi qx qy qz)Float32.zero))) /\
 (forall b z n,Mem.valid_block m b->(b<>out\/z+n<=0\/36<=z)->Mem.loadbytes mf b z n=Mem.loadbytes m b z n) /\
 (forall ch b ofs p,Mem.valid_block m b->Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p) /\
 (forall t vr mr,star Csem.step Execution.ge(Execution.entry(Args out q)m)t(Returnstate vr Kstop mr)->vr=Vundef /\mr=mf).
Definition RuntimeContexts:Prop:=forall args m,Contract.Precondition args m->forall t f a k e mm,
 star Csem.step Execution.ge(Execution.entry args m)t(ExprState f a k e mm)->Csem.not_stuck Execution.ge e a mm.
Definition RuntimeLoads:Prop:=forall args m,Contract.Precondition args m->forall t f k e mm C b p,
 star Csem.step Execution.ge(Execution.entry args m)t(ExprState f(C(Evalof(Eloc b p Full tfloat)tfloat))k e mm)->context RV RV C->exists value,Mem.loadv Mfloat32 mm(Vptr b p)=Some value.
Definition RuntimeStores:Prop:=forall args m,Contract.Precondition args m->forall t f k e mm C b p x,
 star Csem.step Execution.ge(Execution.entry args m)t(ExprState f(C(Eassign(Eloc b p Full tfloat)(Eval(Vsingle x)tfloat)tfloat))k e mm)->context RV RV C->exists mf,Mem.storev Mfloat32 mm(Vptr b p)(Vsingle x)=Some mf.
Definition RuntimeDefined:Prop:=RuntimeContexts /\RuntimeLoads /\RuntimeStores.
Fixpoint ExprNodes(a:expr):list expr:=a::match a with
 |Evalof x _|Ederef x _|Efield x _ _|Eaddrof x _|Ecast x _|Eunop _ x _=>ExprNodes x
 |Ebinop _ x y _|Eassign x y _|Eassignop _ x y _ _=>ExprNodes x++ExprNodes y|_=>[]end.
Definition OriginalNodes:list expr:=List.concat(map ExprNodes acts).
Definition OriginalSite(k:GuardKind):expr:=match k with
 |Qfield i=>Evalof(qfield(if Z.eqb i 0 then Source._qi else if Z.eqb i 1 then Source._qx else if Z.eqb i 2 then Source._qy else Source._qz))tfloat
 |MatrixBase=>rmarray|Index i=>lhs(nth(Z.to_nat i+11)%nat acts(Eval Vundef tvoid))end.
Definition SourceOccurrence(k:GuardKind):Prop:=In(OriginalSite k)OriginalNodes.
Definition MappedGoal(k:GuardKind):Prop:=FiveRmatOfQuatNoError.Spec.NoError /\SiteFacts k /\SourceOccurrence k /\RuntimeDefined /\ExactObservation.
Definition OriginalLedger:list(string*GuardKind):=[
 ("float_rmat_of_quat.pointer_dereference.1",Qfield 0);
 ("float_rmat_of_quat.pointer_dereference.2",Qfield 0);
 ("float_rmat_of_quat.pointer_dereference.3",Qfield 0);
 ("float_rmat_of_quat.pointer_dereference.4",Qfield 0);
 ("float_rmat_of_quat.pointer_dereference.5",Qfield 0);
 ("float_rmat_of_quat.pointer_dereference.6",Qfield 0);
 ("float_rmat_of_quat.pointer_dereference.7",Qfield 1);
 ("float_rmat_of_quat.pointer_dereference.8",Qfield 1);
 ("float_rmat_of_quat.pointer_dereference.9",Qfield 1);
 ("float_rmat_of_quat.pointer_dereference.10",Qfield 1);
 ("float_rmat_of_quat.pointer_dereference.11",Qfield 1);
 ("float_rmat_of_quat.pointer_dereference.12",Qfield 1);
 ("float_rmat_of_quat.pointer_dereference.13",Qfield 2);
 ("float_rmat_of_quat.pointer_dereference.14",Qfield 2);
 ("float_rmat_of_quat.pointer_dereference.15",Qfield 2);
 ("float_rmat_of_quat.pointer_dereference.16",Qfield 2);
 ("float_rmat_of_quat.pointer_dereference.17",Qfield 2);
 ("float_rmat_of_quat.pointer_dereference.18",Qfield 2);
 ("float_rmat_of_quat.pointer_dereference.19",Qfield 3);
 ("float_rmat_of_quat.pointer_dereference.20",Qfield 3);
 ("float_rmat_of_quat.pointer_dereference.21",Qfield 3);
 ("float_rmat_of_quat.pointer_dereference.22",Qfield 3);
 ("float_rmat_of_quat.pointer_dereference.23",Qfield 3);
 ("float_rmat_of_quat.pointer_dereference.24",Qfield 3);
 ("float_rmat_of_quat.pointer_dereference.25",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.26",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.27",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.28",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.29",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.30",MatrixBase);
 ("float_rmat_of_quat.array_bounds.1",Index 0);
 ("float_rmat_of_quat.pointer_dereference.31",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.32",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.33",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.34",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.35",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.36",MatrixBase);
 ("float_rmat_of_quat.array_bounds.2",Index 1);
 ("float_rmat_of_quat.pointer_dereference.37",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.38",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.39",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.40",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.41",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.42",MatrixBase);
 ("float_rmat_of_quat.array_bounds.3",Index 2);
 ("float_rmat_of_quat.pointer_dereference.43",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.44",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.45",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.46",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.47",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.48",MatrixBase);
 ("float_rmat_of_quat.array_bounds.4",Index 3);
 ("float_rmat_of_quat.pointer_dereference.49",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.50",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.51",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.52",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.53",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.54",MatrixBase);
 ("float_rmat_of_quat.array_bounds.5",Index 4);
 ("float_rmat_of_quat.pointer_dereference.55",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.56",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.57",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.58",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.59",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.60",MatrixBase);
 ("float_rmat_of_quat.array_bounds.6",Index 5);
 ("float_rmat_of_quat.pointer_dereference.61",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.62",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.63",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.64",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.65",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.66",MatrixBase);
 ("float_rmat_of_quat.array_bounds.7",Index 6);
 ("float_rmat_of_quat.pointer_dereference.67",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.68",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.69",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.70",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.71",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.72",MatrixBase);
 ("float_rmat_of_quat.array_bounds.8",Index 7);
 ("float_rmat_of_quat.pointer_dereference.73",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.74",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.75",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.76",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.77",MatrixBase);
 ("float_rmat_of_quat.pointer_dereference.78",MatrixBase);
 ("float_rmat_of_quat.array_bounds.9",Index 8)].
Definition AllOriginal87:Prop:=forall id k,In(id,k)OriginalLedger->MappedGoal k.
