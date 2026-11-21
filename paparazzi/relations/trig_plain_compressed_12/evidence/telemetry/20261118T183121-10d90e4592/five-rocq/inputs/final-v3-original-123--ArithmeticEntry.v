From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Ctyping Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import PlainCore ClosedCalls LowDispatcher.
From PprzTrigCBMC Require Import ProducerSteps ArithmeticOriginsExpr ArithmeticState SourceTyping.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.
Definition init_direct_ids:list ident:=[PprzTrigInit.Source._get_nibble;PprzTrigInit.Source._table_encode_12].
Definition init_functions:list function:=[PprzTrigInit.Source.f_pprz_trig_int_init;PprzTrigInit.Source.f_get_nibble;PprzTrigInit.Source.f_table_encode_12].
Definition init_allowed(f:function):Prop:=In f init_functions.
Lemma init_static_bodies:forall f,init_allowed f->ClosedCalls.static_stmt init_direct_ids(fn_body f)=true.
Proof.
 intros f[EQ|[EQ|[EQ|[]]]];subst;vm_compute;reflexivity.
Qed.
Lemma init_static_locals:forall f,init_allowed f->Forall(fun p=>~In(fst p)init_direct_ids)(fn_params f++fn_vars f).
Proof.
 intros f[EQ|[EQ|[EQ|[]]]];subst;
 cbn[PprzTrigInit.Source.f_pprz_trig_int_init PprzTrigInit.Source.f_get_nibble PprzTrigInit.Source.f_table_encode_12 fn_params fn_vars];
 repeat apply Forall_cons;try constructor;unfold init_direct_ids;cbn;intros[E|[E|[]]];vm_compute in E;discriminate.
Qed.
Lemma init_known_functions:forall id,In id init_direct_ids->exists b target,
 Genv.find_symbol PprzTrigInit.Execution.ge id=Some b /\
 Genv.find_funct PprzTrigInit.Execution.ge(Vptr b Ptrofs.zero)=Some(Internal target)/\init_allowed target.
Proof.
 intros id[E|[E|[]]];subst id.
 - destruct(@source_function_link PprzTrigInit.Source.prog PprzTrigInit.Source._get_nibble
    PprzTrigInit.Source.f_get_nibble ltac:(vm_compute;reflexivity))as[b[SYM FUN]].
   exists b,PprzTrigInit.Source.f_get_nibble;repeat split;auto;unfold init_allowed,init_functions;cbn;auto.
 - destruct(@source_function_link PprzTrigInit.Source.prog PprzTrigInit.Source._table_encode_12
    PprzTrigInit.Source.f_table_encode_12 ltac:(vm_compute;reflexivity))as[b[SYM FUN]].
   exists b,PprzTrigInit.Source.f_table_encode_12;repeat split;auto;unfold init_allowed,init_functions;cbn;auto.
Qed.
Lemma init_closed_bodies:forall f,init_allowed f->forall e,ClosedCalls.unshadowed init_direct_ids e->
 ClosedCalls.closed_stmt PprzTrigInit.Execution.ge init_allowed e(fn_body f).
Proof. intros;eapply ClosedCalls.static_stmt_sound;eauto using init_known_functions,init_static_bodies. Qed.
Definition init_closed:=ClosedCalls.closed_state PprzTrigInit.Execution.ge init_allowed init_direct_ids.
Lemma init_step_closed:forall s t s',init_closed s->Csem.step PprzTrigInit.Execution.ge s t s'->init_closed s'.
Proof. intros;eapply ClosedCalls.closed_step;eauto using init_static_locals,init_closed_bodies. Qed.
Lemma init_start_closed:forall args m,init_closed(PprzTrigInit.Execution.entry args m).
Proof. intros;split;[exists PprzTrigInit.Source.f_pprz_trig_int_init;split;[reflexivity|unfold init_allowed,init_functions;cbn;auto]|]. split;[exact I|]. exists empty_env;exact I. Qed.

Lemma init_arithmetic_bodies:forall f,init_allowed f->arithmetic_stmt(fn_body f).
Proof.
 intros f[EQ|[EQ|[EQ|[]]]];subst;
 cbn[PprzTrigInit.Source.f_pprz_trig_int_init PprzTrigInit.Source.f_get_nibble PprzTrigInit.Source.f_table_encode_12 fn_body
   arithmetic_stmt arithmetic_expr arithmetic_exprlist arithmetic_head typeof].
 all:repeat split;try exact I;try reflexivity.
 all:try(solve[unfold add_origin;left;split;[reflexivity|constructor;reflexivity]]).
 all:try(solve[unfold add_origin;right;left;split;[reflexivity|constructor;reflexivity]]).
 all:try(solve[unfold add_origin;right;right;left;split;[constructor;reflexivity|reflexivity]]).
 all:try(solve[unfold add_origin;right;right;right;split;[constructor|reflexivity]]).
 all:try(solve[constructor;try constructor;reflexivity]).
 all:try(solve[unfold mul_origin;left;split;reflexivity]).
 all:try(solve[unfold mul_origin;right;split;[reflexivity|constructor;reflexivity]]).
 all:try(solve[apply producer_value;vm_compute;intuition discriminate]).
 all:unfold add_origin;left;split;[reflexivity|apply producer_ten;constructor].
Qed.

Lemma init_arithmetic_step:forall s t s',Ctyping.wt_state PprzTrigInit.Source.prog s->
 init_closed s->arithmetic_state s->Csem.step PprzTrigInit.Execution.ge s t s'->arithmetic_state s'.
Proof.
 intros s t s' WT CS AS[E|S].
 - eapply arithmetic_estep;eauto.
 - eapply arithmetic_sstep;eauto using init_arithmetic_bodies.
Qed.
Theorem every_initializer_prefix_arithmetic:forall args m prefix s,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix s->arithmetic_state s.
Proof.
 intros args m prefix s PATH.
 assert(START:Ctyping.wt_state PprzTrigInit.Source.prog(PprzTrigInit.Execution.entry args m)).
 { apply(@original_initializer_reachable_typed args m E0 _);constructor. }
 assert(INV:forall a t b,star Csem.step PprzTrigInit.Execution.ge a t b->
 Ctyping.wt_state PprzTrigInit.Source.prog a->init_closed a->arithmetic_state a->arithmetic_state b).
 { intros a t b STAR;induction STAR;intros WT CLOSED ARITH;[exact ARITH|].
   apply IHSTAR;[eapply Ctyping.preservation;[exact original_init_program_well_typed|exact H|exact WT]|eapply init_step_closed;eauto|eapply init_arithmetic_step;eauto]. }
 eapply INV;[exact PATH|exact START|apply init_start_closed|exact I].
Qed.
Print Assumptions every_initializer_prefix_arithmetic.

