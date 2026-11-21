From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveLowpassSupport Require Import Expressions.
From FivePprzFloatMatInv3d Require Import Source Execution.
From FiveMatInv3Case Require Import MatrixMemory MatrixAccess Scalar LocalMemory Expression.
Import ListNotations.
Local Open Scope Z_scope.
Lemma core_output_store:forall e bpo bpi bo bi po pi f vs m i x mf,
 Outside e bo->bo<>bi->
 e!Source._inv_out=Some(bpo,tptr(tarray tfloat 3))->e!Source._mat_in=Some(bpi,tptr(tarray tfloat 3))->
 Core e bpo bpi bo bi po pi f vs m->Mem.store Mfloat32 m bo(Ptrofs.unsigned po+4*i)(Vsingle x)=Some mf->
 Core e bpo bpi bo bi po pi f vs mf.
Proof.
 intros e bpo bpi bo bi po pi f vs m i x mf OUT NE EO EI C ST;destruct C as[FREE LO LI RD W K];constructor.
 - intros id b ty E z B;eapply Mem.perm_store_1;[exact ST|eapply FREE;eauto].
 - erewrite Mem.load_store_other;[exact LO|exact ST|left;intro EQ;subst bpo;exact(OUT Source._inv_out _ EO)].
 - erewrite Mem.load_store_other;[exact LI|exact ST|left;intro EQ;subst bpi;exact(OUT Source._mat_in _ EI)].
 - eapply(reads_store_preserved m bi pi 9 f Mfloat32 bo(Ptrofs.unsigned po+4*i)(Vsingle x)mf);[exact RD|congruence|exact ST].
 - eapply writable_store_preserved;eauto.
 - intros id y LOOK;destruct(K id y LOOK)as[b[E L]];exists b;split;[exact E|].
   erewrite Mem.load_store_other;[exact L|exact ST|left;intro EQ;subst b;exact(OUT id _ E)].
Qed.
Fixpoint OutputValid(e:env)(bpo bpi bo bi:block)(po pi:ptrofs)(f:Z->float32)(xs:list(Z*Z*expr))(ys:list(Z*float32)):Prop:=
 match xs,ys with
 |[],[]=>True
 |(r,c,rhs)::xs,(i,x)::ys=>i=3*r+c /\ 0<=r<3 /\ 0<=c<3 /\ typeof rhs=tfloat /\
 (forall m,Core e bpo bpi bo bi po pi f(Updated(PTree.empty float32)(LocalResults f))m->pure_rval Execution.ge e m rhs=Some(Vsingle x)) /\
 OutputValid e bpo bpi bo bi po pi f xs ys
 |_,_=>False end.
Lemma output_valid:forall e bpo bpi bo bi po pi f,OutputValid e bpo bpi bo bi po pi f OutExprs(Outputs f).
Proof.
 intros e bpo bpi bo bi po pi f;unfold OutExprs,Outputs;cbn[OutputValid].
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 split;[reflexivity|];split;[lia|];split;[lia|];split;[reflexivity|];split.
 { intros m C;unfold FBin,FNeg,Output;fp_value C. }
 exact I.
Qed.
Lemma output_execute:forall xs ys e bpo bpi bo bi po pi f m mf,
 Outside e bo->bo<>bi->
 e!Source._inv_out=Some(bpo,tptr(tarray tfloat 3))->e!Source._mat_in=Some(bpi,tptr(tarray tfloat 3))->
 Core e bpo bpi bo bi po pi f(Updated(PTree.empty float32)(LocalResults f))m->
 OutputValid e bpo bpi bo bi po pi f xs ys->Writes m bo(Ptrofs.unsigned po)ys mf->
 stmt_eval Execution.ge e tbool(OutputStmt xs)m=Some(Nreturn(Vint Int.zero),mf) /\
 Core e bpo bpi bo bi po pi f(Updated(PTree.empty float32)(LocalResults f))mf /\ Access m mf.
Proof.
 induction xs as[|[[r c]rhs]xs IH];intros ys e bpo bpi bo bi po pi f m mf OUT NE EO EI C CERT WR;destruct ys as[|[i x]ys];cbn[OutputValid]in CERT;try contradiction.
 - cbn[Writes]in WR;subst mf;split;[reflexivity|];split;[exact C|intros ch b z p VA;exact VA].
 - destruct CERT as[-> [R[COL[TY[RV REST]]]]];destruct WR as[m1[ST WR]].
   pose proof(core_write _ _ _ _ _ _ _ _ _ _ C)as W.
   assert(LOC:pure_lval Execution.ge e m(MatrixLoc Source._inv_out 3 r c)=Some(bo,Ptrofs.add po(Ptrofs.repr(4*(3*r+c))),Full)).
   { eapply matrix_location;[exact EO|exact(core_outptr _ _ _ _ _ _ _ _ _ _ C)|right;reflexivity|exact R|exact COL]. }
   assert(B:0<=3*r+c<9)by lia.
   assert(PTR:Ptrofs.unsigned(Ptrofs.add po(Ptrofs.repr(4*(3*r+c))))=Ptrofs.unsigned po+4*(3*r+c))by(apply(index_pointer po 9 _ (proj1(proj2 W))B)).
   assert(AE:atomic_eval Execution.ge e m(Eassign(MatrixLoc Source._inv_out 3 r c)rhs tfloat)=Some(Vsingle x,m1)).
   { eapply assign_float;[reflexivity|exact TY|exact LOC|exact(RV m C)|rewrite PTR;destruct W as[_[NW _]];lia|rewrite PTR;exact ST]. }
   pose proof(core_output_store e bpo bpi bo bi po pi f _ m(3*r+c)x m1 OUT NE EO EI C ST)as C1.
   destruct(IH ys e bpo bpi bo bi po pi f m1 mf OUT NE EO EI C1 REST WR)as[EV[CF ACC]].
   split;[cbn[OutputStmt stmt_eval];rewrite AE;exact EV|];split;[exact CF|].
   eapply access_trans;[eapply access_store;exact ST|exact ACC].
Qed.
Definition BodyWrites(m:mem)(bo:block)(po:ptrofs)(f:Z->float32)(mf:mem):Prop:=if Accept f then Writes m bo(Ptrofs.unsigned po)(Outputs f)mf else mf=m.
Lemma suffix_execute:forall e bpo bpi bo bi po pi f m,
 Outside e bo->bo<>bi->
 e!Source._inv_out=Some(bpo,tptr(tarray tfloat 3))->e!Source._mat_in=Some(bpi,tptr(tarray tfloat 3))->
 Core e bpo bpi bo bi po pi f(Updated(PTree.empty float32)(LocalResults f))m->
 exists mf,stmt_eval Execution.ge e tbool Suffix m=Some(Nreturn(Status f),mf) /\
 BodyWrites m bo po f mf /\ Core e bpo bpi bo bi po pi f(Updated(PTree.empty float32)(LocalResults f))mf /\ Access m mf.
Proof.
 intros e bpo bpi bo bi po pi f m OUT NE EO EI C.
 pose proof(guard_value e bpo bpi bo bi po pi f m C)as G.
 destruct(Accept f)eqn:AC.
 - destruct(writes_exist(Outputs f)m bo po 9(core_write _ _ _ _ _ _ _ _ _ _ C))as[mf WR].
   { intros i x IN;unfold Outputs in IN;cbn in IN;repeat destruct IN as[IN|IN];try contradiction;inversion IN;lia. }
   destruct(output_execute OutExprs(Outputs f)e bpo bpi bo bi po pi f m mf OUT NE EO EI C(output_valid _ _ _ _ _ _ _ _)WR)as[EV[CF ACCESS]].
   exists mf;split.
   + unfold Suffix;cbn[stmt_eval];rewrite G;change(match bool_val(Val.of_bool true)tint m with Some b=>match stmt_eval Execution.ge e tbool(if b then OutputStmt OutExprs else Sskip)m with Some(Nnormal,mm)=>stmt_eval Execution.ge e tbool(Sreturn(Some(Eval(Vint Int.one)tint)))mm|Some(Nreturn v,mm)=>Some(Nreturn v,mm)|None=>None end|None=>None end=Some(Nreturn(Status f),mf)).
     change(match stmt_eval Execution.ge e tbool(OutputStmt OutExprs)m with Some(Nnormal,mm)=>stmt_eval Execution.ge e tbool(Sreturn(Some(Eval(Vint Int.one)tint)))mm|Some(Nreturn v,mm)=>Some(Nreturn v,mm)|None=>None end=Some(Nreturn(Status f),mf)).
     rewrite EV;unfold Status;rewrite AC;reflexivity.
   + split;[unfold BodyWrites;rewrite AC;exact WR|];split;assumption.
 - exists m;split.
   + unfold Suffix;cbn[stmt_eval];rewrite G;unfold Status;rewrite AC;reflexivity.
   + split;[unfold BodyWrites;rewrite AC;reflexivity|];split;[exact C|intros ch b z p VA;exact VA].
Qed.
Print Assumptions output_execute.
Print Assumptions suffix_execute.
