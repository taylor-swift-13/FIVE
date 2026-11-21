From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation.
From FiveLowpassSupport Require Import Expressions.
From FiveMatInv3Case Require Import MatrixMemory.
Local Open Scope Z_scope.
Definition MatrixPtr(id:ident)(n:Z):expr:=Evalof(Evar id(tptr(tarray tfloat n)))(tptr(tarray tfloat n)).
Definition MatrixLoc(id:ident)(n r c:Z):expr:=Ederef(Ebinop Oadd
 (Evalof(Ederef(Ebinop Oadd(MatrixPtr id n)(Eval(Vint(Int.repr r))tint)(tptr(tarray tfloat n)))(tarray tfloat n))(tarray tfloat n))
 (Eval(Vint(Int.repr c))tint)(tptr tfloat))tfloat.
Definition MatrixVal(id:ident)(n r c:Z):expr:=Evalof(MatrixLoc id n r c)tfloat.
Lemma matrix_location:forall ge e m id bx b p n r c,
 e!id=Some(bx,tptr(tarray tfloat n))->Mem.load Mptr m bx 0=Some(Vptr b p)->
 (n=2\/n=3)->0<=r<n->0<=c<n->
 pure_lval ge e m(MatrixLoc id n r c)=Some(b,Ptrofs.add p(Ptrofs.repr(4*(n*r+c))),Full).
Proof.
 intros ge e m id bx b p n r c E L N R C.
 assert(P:pure_rval ge e m(MatrixPtr id n)=Some(Vptr b p))by(unfold MatrixPtr;eapply pointer_variable;eauto).
 unfold MatrixLoc;cbn[pure_lval pure_rval];fold(MatrixPtr id n);fold(pure_rval ge e m(MatrixPtr id n));rewrite P.
 destruct N as[-> | ->];assert(RR:r=0\/r=1\/r=2)by lia;assert(CC:c=0\/c=1\/c=2)by lia;
 destruct RR as[-> | [-> | ->]];destruct CC as[-> | [-> | ->]];try lia;
 match goal with |- _=Some(b,Ptrofs.add p(Ptrofs.repr(4*(?nn*?rr+?cc))),Full)=>
 change(Some(b,Ptrofs.add(Ptrofs.add p(Ptrofs.repr(4*nn*rr)))(Ptrofs.repr(4*cc)),Full)=Some(b,Ptrofs.add p(Ptrofs.repr(4*(nn*rr+cc))),Full)) end;
 rewrite Ptrofs.add_assoc;reflexivity.
Qed.
Lemma matrix_value:forall ge e m id bx b p n r c f,
 e!id=Some(bx,tptr(tarray tfloat n))->Mem.load Mptr m bx 0=Some(Vptr b p)->
 Reads m b p(n*n)f->(n=2\/n=3)->0<=r<n->0<=c<n->
 pure_rval ge e m(MatrixVal id n r c)=Some(Vsingle(f(n*r+c))).
Proof.
 intros ge e m id bx b p n r c f E L RD N R C.
 assert(B:0<=n*r+c<n*n)by(destruct N as[-> | ->];nia).
 pose proof(matrix_location ge e m id bx b p n r c E L N R C)as LOC.
 change(match pure_lval ge e m(MatrixLoc id n r c)with Some(bb,pp,bf)=>match Cexec.do_deref_loc ge quiet_world tfloat m bb pp bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle(f(n*r+c)))).
 rewrite LOC;cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite(index_pointer p(n*n)(n*r+c)(proj1(proj2 RD))B);rewrite zle_true by(destruct RD as[_[NW _]];change Ptrofs.modulus with 18446744073709551616 in NW|-*;cbn[size_chunk];lia).
 rewrite(proj2(proj2 RD)(n*r+c)B);reflexivity.
Qed.
Print Assumptions matrix_value.
