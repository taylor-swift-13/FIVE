From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Ctyping.
From PprzTrigRelationSupport Require Import PureEval ClosedCalls.
From PprzTrigCBMC Require Import ProducerContexts PointerAccess.
Import ListNotations.
Local Open Scope Z_scope.
Section ARRAYS.
Variable ge:Csem.genv.
Variable elem:type.
Variable ids:list(ident*Z).
Definition global_array(id:ident)(n:Z)(b:block):Prop:=In(id,n)ids/\Genv.find_symbol ge id=Some b.
Definition array_block(b:block):Prop:=exists id n,global_array id n b.
Definition array_unshadowed(e:env):Prop:=forall id n,In(id,n)ids->e!id=None.
Inductive array_base:expr->Z->Prop:=
|base_name:forall id n b,global_array id n b->array_base(Evalof(Evar id(Tarray elem n noattr))(Tarray elem n noattr))n
|base_loc:forall id n b,global_array id n b->array_base(Evalof(Eloc b Ptrofs.zero Full(Tarray elem n noattr))(Tarray elem n noattr))n
|base_value:forall id n b,global_array id n b->array_base(Eval(Vptr b Ptrofs.zero)(Tarray elem n noattr))n.
Inductive array_pointer:expr->Prop:=
|pointer_add:forall a index n,array_base a n->typeconv(typeof index)=tint->
 array_pointer(Ebinop Oadd a index(Tpointer elem noattr))
|pointer_value:forall id n b index,global_array id n b->
 array_pointer(Eval(Vptr b(Ptrofs.repr(sizeof ge elem*Int.signed index)))(Tpointer elem noattr)).
Inductive array_lvalue:expr->Prop:=
|lvalue_deref:forall ptr,array_pointer ptr->array_lvalue(Ederef ptr elem)
|lvalue_location:forall id n b index,global_array id n b->
 array_lvalue(Eloc b(Ptrofs.repr(sizeof ge elem*Int.signed index))Full elem).

Lemma base_lred_context:forall from C,Csem.context from RV C->from=LV->
 forall e a m a' mf n,array_unshadowed e->array_base(C a)n->lred ge e a m a' mf->array_base(C a')n.
Proof.
 intros from C CT KK e a m a' mf n ENV BASE LR;subst from.
 remember(C a)as whole eqn:EQ;inversion BASE;subst whole;inversion CT;subst C;try discriminate.
 all:match goal with E:Evalof ?LEAF ?TF=Evalof(?C ?A)?TY,SUB:Csem.context LV LV ?C|-_=>
  inversion E;subst TY;
  destruct(ClosedCalls.leaf_context _ _ _ SUB A LEAF eq_refl ltac:(congruence))as[KK[AA ID]];
  try(rewrite AA in LR);repeat rewrite ID end.
 all:inversion LR;subst;try congruence.
 all:unfold global_array in *;repeat match goal with H:_/\_|-_=>destruct H end.
 all:try(solve[exfalso;match goal with IN:In(?ID,?N)ids,LOCAL:(?EN)!?ID=Some _|-_=>specialize(ENV ID N IN);congruence end]).
 all:eapply base_loc;split;eassumption.
Qed.
Lemma base_rred_context:forall C,Csem.context RV RV C->forall a m t a' mf n,
 array_base(C a)n->rred ge a m t a' mf->array_base(C a')n.
Proof.
 intros C CT a m t a' mf n BASE RR.
 remember(C a)as whole eqn:EQ;inversion BASE;subst whole;inversion CT;subst C;try discriminate.
 all:try(solve[inversion RR;subst;
 match goal with D:deref_loc _ _ _ _ _ _ _ _|-_=>inversion D;subst;cbn[access_mode]in *;try discriminate end;
 eapply base_value;eauto]).
 all:try(match goal with E:Evalof ?LEAF ?TF=Evalof(?C ?A)?TY,SUB:Csem.context RV LV ?C|-_=>
  inversion E;subst TY;
  destruct(ClosedCalls.leaf_context _ _ _ SUB A LEAF eq_refl ltac:(congruence))as[BAD _];discriminate end).
 all:match goal with |-?G=>idtac "BASE-RR-LEFT" G end.
Qed.
Lemma base_no_call:forall from C,Csem.context from RV C->forall fn args ty n,
 array_base(C(Ecall fn args ty))n->False.
Proof.
 intros from C CT fn args ty n B.
 assert(NC:ClosedCalls.no_calls(C(Ecall fn args ty))=true)by(inversion B;reflexivity).
 pose proof(@ClosedCalls.no_calls_hole from RV C CT _ NC);discriminate.
Qed.
Lemma array_add_some:forall n b v ty m out,typeconv ty=tint->
 sem_binary_operation ge Oadd(Vptr b Ptrofs.zero)(Tarray elem n noattr)v ty m=Some out->
 exists index,v=Vint index/\out=Vptr b(Ptrofs.repr(sizeof ge elem*Int.signed index)).
Proof.
 intros n b v ty m out TY SEM.
 unfold sem_binary_operation,sem_add,classify_add in SEM;cbn[typeconv]in SEM;rewrite TY in SEM.
 cbn[tint]in SEM;destruct v;try discriminate SEM.
 exists i;split;[reflexivity|].

 (* The exact bit arithmetic follows directly from CompCert's int-to-pointer operation. *)
 cbn[sem_add_ptr_int ptrofs_of_int]in SEM.
 unfold Ptrofs.of_ints in SEM.
 rewrite Ptrofs.add_zero_l in SEM;inversion SEM;subst out.
 unfold Ptrofs.mul;apply f_equal;apply Ptrofs.eqm_samerepr;apply Ptrofs.eqm_mult;apply Ptrofs.eqm_sym;apply Ptrofs.eqm_unsigned_repr.
Qed.
Lemma pointer_head_rred:forall a m t a' mf,array_pointer a->rred ge a m t a' mf->array_pointer a'.
Proof.
 intros a m t a' mf PTR RED;inversion PTR;subst;inversion RED;subst.
 match goal with B:array_base(Eval _ _) _|-_=>inversion B;subst end.
 match goal with S:sem_binary_operation _ _ _ _ _ _ _=Some _|-_=>
 destruct(@array_add_some _ _ _ _ _ _ H0 S)as[index[V OUT]];subst end.
 eapply pointer_value;eauto.
Qed.
End ARRAYS.




