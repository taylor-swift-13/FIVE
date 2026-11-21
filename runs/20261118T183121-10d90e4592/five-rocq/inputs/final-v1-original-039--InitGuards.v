From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import PureEval TrigData TrigEmission InitState InitLoop ChunkMachine.
Open Scope Z_scope.
Definition single_limit := Ebinop Oadd
 (Ebinop Odiv(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)(Eval(Vint(Int.repr 5))tint)tint)
 (Eval(Vint(Int.repr 1))tint)tint.
Definition multi_limit := Ebinop Oadd(Evalof(Evar PprzTrigInit.Source._k tshort)tshort)
 (Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 3))tint)(Eval(Vint(Int.repr 3))tint)tint)
  (Eval(Vint(Int.repr 1))tint)tint)tint.
Lemma single_limit_value : forall ge e m t,short_cell e m PprzTrigInit.Source._temp t ->
 pure_rval ge e m single_limit=Some(Vint(Int.add(Int.divs(Int.repr t)(Int.repr 5))(Int.repr 1))).
Proof.
 intros ge e m t T.
 change(match(match pure_rval ge e m(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)with
 |Some v=>sem_binary_operation ge Odiv v tshort(Vint(Int.repr 5))tint m|None=>None end)with
 |Some v=>sem_binary_operation ge Oadd v tint(Vint(Int.repr 1))tint m|None=>None end=
 Some(Vint(Int.add(Int.divs(Int.repr t)(Int.repr 5))(Int.repr 1)))).
 rewrite(short_read_value _ _ _ _ _ T).
 cbv beta iota zeta delta[sem_binary_operation sem_div sem_add sem_binarith classify_binarith binarith_type classify_add
 typeconv sem_cast classify_cast cast_int_int tshort tint Archi.ptr64].
 assert(E50:Int.eq(Int.repr 5)Int.zero=false)by(vm_compute;reflexivity).
 assert(E5M:Int.eq(Int.repr 5)Int.mone=false)by(vm_compute;reflexivity).
 try rewrite E50;try rewrite E5M;try rewrite andb_false_r;reflexivity.
Qed.
Lemma multi_limit_value : forall ge e m k,short_cell e m PprzTrigInit.Source._k k ->
 pure_rval ge e m multi_limit=Some(Vint(Int.add(Int.repr k)(Int.add(Int.mul(Int.repr 3)(Int.repr 3))(Int.repr 1)))).
Proof.
 intros ge e m k K.
 change(match pure_rval ge e m(Evalof(Evar PprzTrigInit.Source._k tshort)tshort)with
 |Some v=>sem_binary_operation ge Oadd v tshort
  (Vint(Int.add(Int.mul(Int.repr 3)(Int.repr 3))(Int.repr 1)))tint m|None=>None end=Some(Vint(Int.add(Int.repr k)(Int.add(Int.mul(Int.repr 3)(Int.repr 3))(Int.repr 1))))).
 rewrite(short_read_value _ _ _ _ _ K);reflexivity.
Qed.
Lemma inner_condition_shape : forall c,inner_condition c=
 Ebinop Olt(Evalof(Evar PprzTrigInit.Source._j tshort)tshort)
 (if multi c then multi_limit else single_limit)tint.
Proof. intros c;unfold inner_condition,inner_with_init;destruct(multi c);reflexivity. Qed.
Lemma inner_guard_value : forall e m c j,In c literal_chunks ->
 short_cell e m PprzTrigInit.Source._j j ->
 (if multi c then short_cell e m PprzTrigInit.Source._k(k_value c)
 else short_cell e m PprzTrigInit.Source._temp(first c)) ->
 pure_rval PprzTrigInit.Execution.ge e m(inner_condition c)=
 Some(Val.of_bool(Int.cmp Clt(Int.repr j)(Int.repr(repetitions c)))).
Proof.
 intros e m c j IN J OTHER. rewrite inner_condition_shape.
 pose proof(literal_chunk_machine c IN)as[LIM[DELTA K]]. rewrite<-LIM.
 unfold machine_repetitions. destruct(multi c)eqn:M.
 - rewrite K. change(match pure_rval PprzTrigInit.Execution.ge e m(Evalof(Evar PprzTrigInit.Source._j tshort)tshort),
   pure_rval PprzTrigInit.Execution.ge e m multi_limit with
   |Some v,Some w=>sem_binary_operation PprzTrigInit.Execution.ge Olt v tshort w tint m|_,_=>None end=Some(Val.of_bool(Int.cmp Clt(Int.repr j)(Int.add(Int.repr(k_value c))(Int.add(Int.mul(Int.repr 3)(Int.repr 3))(Int.repr 1)))))).
   rewrite(short_read_value _ _ _ _ _ J),(multi_limit_value _ _ _ _ OTHER);reflexivity.
 - change(match pure_rval PprzTrigInit.Execution.ge e m(Evalof(Evar PprzTrigInit.Source._j tshort)tshort),
   pure_rval PprzTrigInit.Execution.ge e m single_limit with
   |Some v,Some w=>sem_binary_operation PprzTrigInit.Execution.ge Olt v tshort w tint m|_,_=>None end=Some(Val.of_bool(Int.cmp Clt(Int.repr j)(Int.add(Int.divs(Int.repr(first c))(Int.repr 5))(Int.repr 1))))).
   rewrite(short_read_value _ _ _ _ _ J),(single_limit_value _ _ _ _ OTHER);reflexivity.
Qed.
