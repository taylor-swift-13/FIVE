From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy Smallstep.
Import ListNotations.
Local Open Scope Z_scope.
Lemma source_array_add:forall(ge:Csem.genv)elem n index_type m b index size,
 sizeof ge elem=size ->0<=size<=12868 ->typeconv index_type=tint ->
 sem_binary_operation ge Oadd(Vptr b Ptrofs.zero)(Tarray elem n noattr)(Vint index)index_type m=
 Some(Vptr b(Ptrofs.repr(size*Int.signed index))).
Proof.
 intros ge elem n index_type m b index size SZ BOUND IDX.
 unfold sem_binary_operation,sem_add,classify_add;cbn[typeconv];rewrite IDX.
 cbn[sem_add_ptr_int ptrofs_of_int];match goal with|-?G=>idtac G end;rewrite SZ,Ptrofs.add_zero_l.
 unfold Ptrofs.of_ints;rewrite Ptrofs.mul_signed.
 rewrite(Ptrofs.signed_repr size)by(change(-9223372036854775808<=size<=9223372036854775807);lia).
 rewrite(Ptrofs.signed_repr(Int.signed index))by(pose proof(Int.signed_range index)as R;change(-2147483648<=Int.signed index<=2147483647)in R;change(-9223372036854775808<=Int.signed index<=9223372036854775807);lia).
 reflexivity.
Qed.
Definition source_read(elem:type)(n:Z)(b:block)(index:Int.int)(index_type:type):expr:=
 Evalof(Ederef(Ebinop Oadd(Eval(Vptr b Ptrofs.zero)(Tarray elem n noattr))
 (Eval(Vint index)index_type)(Tpointer elem noattr))elem)elem.
Definition source_write(elem:type)(n:Z)(b:block)(index:Int.int)(index_type:type)(v:val)(vty:type):expr:=
 Eassign(Ederef(Ebinop Oadd(Eval(Vptr b Ptrofs.zero)(Tarray elem n noattr))
 (Eval(Vint index)index_type)(Tpointer elem noattr))elem)(Eval v vty)elem.
Theorem read_pointer_reaches_attempt:forall(ge:Csem.genv)f k e m C elem n b index index_type size,
 context RV RV C ->sizeof ge elem=size ->0<=size<=12868 ->typeconv index_type=tint ->
 star Csem.step ge(ExprState f(C(source_read elem n b index index_type))k e m)E0
 (ExprState f(C(Evalof(Eloc b(Ptrofs.repr(size*Int.signed index))Full elem)elem))k e m).
Proof.
 intros ge f k e m C elem n b index index_type size CT SZ BOUND IDX;unfold source_read.
 eapply star_two.
 - left;eapply Csem.step_rred with(C:=fun x=>C(Evalof(Ederef x elem)elem)).
   + apply red_binop;exact(source_array_add ge elem n index_type m b index size SZ BOUND IDX).
   + eapply Cstrategy.context_compose;[exact CT|]. apply ctx_rvalof;apply ctx_deref;constructor.
 - left;eapply Csem.step_lred with(C:=fun x=>C(Evalof x elem)).
   + constructor.
   + eapply Cstrategy.context_compose;[exact CT|]. apply ctx_rvalof;constructor.
 - reflexivity.
Qed.
Theorem write_pointer_reaches_attempt:forall(ge:Csem.genv)f k e m C elem n b index index_type size v vty,
 context RV RV C ->sizeof ge elem=size ->0<=size<=12868 ->typeconv index_type=tint ->
 star Csem.step ge(ExprState f(C(source_write elem n b index index_type v vty))k e m)E0
 (ExprState f(C(Eassign(Eloc b(Ptrofs.repr(size*Int.signed index))Full elem)(Eval v vty)elem))k e m).
Proof.
 intros ge f k e m C elem n b index index_type size v vty CT SZ BOUND IDX;unfold source_write.
 eapply star_two.
 - left;eapply Csem.step_rred with(C:=fun x=>C(Eassign(Ederef x elem)(Eval v vty)elem)).
   + apply red_binop;exact(source_array_add ge elem n index_type m b index size SZ BOUND IDX).
   + eapply Cstrategy.context_compose;[exact CT|]. apply ctx_assign_left;apply ctx_deref;constructor.
 - left;eapply Csem.step_lred with(C:=fun x=>C(Eassign x(Eval v vty)elem)).
   + constructor.
   + eapply Cstrategy.context_compose;[exact CT|]. apply ctx_assign_left;constructor.
 - reflexivity.
Qed.
Print Assumptions source_array_add.
Print Assumptions read_pointer_reaches_attempt.
Print Assumptions write_pointer_reaches_attempt.
