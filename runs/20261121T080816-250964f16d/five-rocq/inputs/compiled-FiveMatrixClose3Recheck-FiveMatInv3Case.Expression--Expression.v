From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FivePprzFloatMatInv3d Require Import Source Execution.
From FiveMatInv3Case Require Import MatrixMemory MatrixAccess Scalar LocalMemory.
Import ListNotations.
Local Open Scope Z_scope.
Lemma rval_add:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Oadd a b tfloat)=Some(Vsingle(Float32.add x y)).
Proof. intros;change(match pure_rval Execution.ge e m a,pure_rval Execution.ge e m b with Some v,Some w=>sem_binary_operation Execution.ge Oadd v(typeof a)w(typeof b)m|_,_=>None end=Some(Vsingle(Float32.add x y)));rewrite H,H0,H1,H2;reflexivity. Qed.
Lemma rval_sub:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Osub a b tfloat)=Some(Vsingle(Float32.sub x y)).
Proof. intros;change(match pure_rval Execution.ge e m a,pure_rval Execution.ge e m b with Some v,Some w=>sem_binary_operation Execution.ge Osub v(typeof a)w(typeof b)m|_,_=>None end=Some(Vsingle(Float32.sub x y)));rewrite H,H0,H1,H2;reflexivity. Qed.
Lemma rval_mul:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Omul a b tfloat)=Some(Vsingle(Float32.mul x y)).
Proof. intros;change(match pure_rval Execution.ge e m a,pure_rval Execution.ge e m b with Some v,Some w=>sem_binary_operation Execution.ge Omul v(typeof a)w(typeof b)m|_,_=>None end=Some(Vsingle(Float32.mul x y)));rewrite H,H0,H1,H2;reflexivity. Qed.
Lemma rval_div:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Odiv a b tfloat)=Some(Vsingle(Float32.div x y)).
Proof. intros;change(match pure_rval Execution.ge e m a,pure_rval Execution.ge e m b with Some v,Some w=>sem_binary_operation Execution.ge Odiv v(typeof a)w(typeof b)m|_,_=>None end=Some(Vsingle(Float32.div x y)));rewrite H,H0,H1,H2;reflexivity. Qed.
Lemma rval_neg:forall e m a x,typeof a=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->
 pure_rval Execution.ge e m(Eunop Oneg a tfloat)=Some(Vsingle(Float32.neg x)).
Proof. intros;change(match pure_rval Execution.ge e m a with Some v=>sem_unary_operation Oneg v(typeof a)m|_=>None end=Some(Vsingle(Float32.neg x)));rewrite H,H0;reflexivity. Qed.
Ltac fp_value C:=lazymatch goal with
 | |- pure_rval _ _ _ (Ebinop Oadd _ _ _)=_=>eapply rval_add;[reflexivity|reflexivity|fp_value C|fp_value C]
 | |- pure_rval _ _ _ (Ebinop Osub _ _ _)=_=>eapply rval_sub;[reflexivity|reflexivity|fp_value C|fp_value C]
 | |- pure_rval _ _ _ (Ebinop Omul _ _ _)=_=>eapply rval_mul;[reflexivity|reflexivity|fp_value C|fp_value C]
 | |- pure_rval _ _ _ (Ebinop Odiv _ _ _)=_=>eapply rval_div;[reflexivity|reflexivity|fp_value C|fp_value C]
 | |- pure_rval _ _ _ (Eunop Oneg _ _)=_=>eapply rval_neg;[reflexivity|fp_value C]
 | |- pure_rval _ _ _ (MatrixVal _ _ _ _)=_=>eapply matrix_value;[eassumption|exact(core_inptr _ _ _ _ _ _ _ _ _ _ C)|exact(core_reads _ _ _ _ _ _ _ _ _ _ C)|right;reflexivity|vm_compute;intuition discriminate|vm_compute;intuition discriminate]
 | |- pure_rval _ _ _ (Local _)=_=>eapply known_value;[exact(core_known _ _ _ _ _ _ _ _ _ _ C)|reflexivity]
 end.
Lemma prefix_valid:forall e bpo bpi bo bi po pi f,
 e!Source._mat_in=Some(bpi,tptr(tarray tfloat 3))->
 PrefixValid e bpo bpi bo bi po pi f(PTree.empty float32)Prefix(LocalResults f).
Proof.
 intros e bpo bpi bo bi po pi f EI;unfold Prefix,LocalResults;cbn[PrefixValid].
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M00,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M10,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M20,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M01,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M11,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M21,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M02,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M12,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold M22,MinExpr,FBin,Inp;fp_value C. }
 split;[reflexivity|];split;[reflexivity|];split.
 { intros m C;unfold Det,MinExpr,FBin,Inp;fp_value C. }
 exact I.
Qed.
Lemma guard_value:forall e bpo bpi bo bi po pi f m,
 Core e bpo bpi bo bi po pi f(Updated(PTree.empty float32)(LocalResults f))m->
 pure_rval Execution.ge e m Guard=Some(Val.of_bool(Accept f)).
Proof.
 intros e bpo bpi bo bi po pi f m C.
 assert(D:pure_rval Execution.ge e m(Local Source._det)=Some(Vsingle(Det f))).
 { eapply known_value;[exact(core_known _ _ _ _ _ _ _ _ _ _ C)|reflexivity]. }
 change(match(match pure_rval Execution.ge e m(Local Source._det)with Some v=>sem_unary_operation Oabsfloat v tfloat m|None=>None end)with Some v=>sem_binary_operation Execution.ge Ogt v tdouble(Vsingle(Float32.of_bits(Int.repr 872415232)))tfloat m|None=>None end=Some(Val.of_bool(Accept f))).
 rewrite D;reflexivity.
Qed.
Print Assumptions prefix_valid.
Print Assumptions guard_value.
