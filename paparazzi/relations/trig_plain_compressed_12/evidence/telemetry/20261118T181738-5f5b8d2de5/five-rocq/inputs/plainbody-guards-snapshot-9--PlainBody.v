From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigPlain Require Import Source.
From PprzTrigRelationSupport Require Import Normalizer PlainCore PureEval PureProgress Total.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Definition fun_sin := Source.f_pprz_itrig_sin.
Definition body := fn_body fun_sin.
Definition norm := match body with Ssequence a _=>a|_=>Sskip end.
Definition rest := match body with Ssequence _ b=>b|_=>Sskip end.
Definition upper_loop := match norm with Ssequence a _=>a|_=>Sskip end.
Definition lower_loop := match norm with Ssequence _ b=>b|_=>Sskip end.
Definition fold_stmt := match rest with Ssequence a _=>a|_=>Sskip end.
Definition return_stmt := match rest with Ssequence _ b=>b|_=>Sskip end.
Definition upper_guard := match upper_loop with Swhile g _=>g|_=>Eval Vundef tint end.
Definition lower_guard := match lower_loop with Swhile g _=>g|_=>Eval Vundef tint end.
Definition upper_body := match upper_loop with Swhile _ s=>s|_=>Sskip end.
Definition lower_body := match lower_loop with Swhile _ s=>s|_=>Sskip end.
Definition pi_expr := match upper_guard with Ebinop _ _ c _=>c|_=>Eval Vundef tint end.
Definition halfpi_expr := match fold_stmt with Sifthenelse(Ebinop _ _ c _) _ _=>c|_=>Eval Vundef tint end.
Definition read_angle := Evalof (Evar Source._angle tint) tint.
Definition angle_env (b:block) : env := PTree.set Source._angle (b,tint) empty_env.

Lemma body_shape : body=Ssequence (Ssequence upper_loop lower_loop) (Ssequence fold_stmt return_stmt).
Proof. reflexivity. Qed.
Lemma pi_expr_value : forall ge e m,pure_rval ge e m pi_expr=Some(Vint(Int.repr 12867)).
Proof. intros;vm_compute;reflexivity. Qed.
Lemma halfpi_expr_value : forall ge e m,pure_rval ge e m halfpi_expr=Some(Vint(Int.repr 6433)).
Proof. intros;vm_compute;reflexivity. Qed.
Lemma angle_read : forall ge b m a,
 Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m read_angle=Some(Vint a).
Proof.
 intros ge b m a LOAD. cbn[pure_rval pure_lval read_angle].
 rewrite dec_eq_true. unfold angle_env;rewrite PTree.gss,dec_eq_true.
 cbn[Cexec.do_deref_loc tint access_mode type_is_volatile noattr Mem.loadv size_chunk].
 rewrite Ptrofs.unsigned_zero. destruct(zle (0+4) Ptrofs.modulus);[rewrite LOAD;reflexivity|].
 assert(BOUND:4<=Ptrofs.modulus) by (change(4<=18446744073709551616);lia). lia.
Qed.
Lemma upper_guard_simple : simple upper_guard=true.
Proof. reflexivity. Qed.
Lemma lower_guard_simple : simple lower_guard=true.
Proof. reflexivity. Qed.
Lemma upper_guard_false : forall ge b m a,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m upper_guard=Some(Vint Int.zero).
Proof.
 intros ge b m a RANGE LOAD.
 change (match pure_rval ge (angle_env b) m read_angle,
               pure_rval ge (angle_env b) m pi_expr with
 |Some v,Some w=>sem_binary_operation ge Ogt v tint w tint m|_,_=>None end = Some(Vint Int.zero)).
 rewrite(angle_read _ _ _ _ LOAD),pi_expr_value.
 cbn[sem_binary_operation sem_cmp classify_cmp sem_cmp_default].
 unfold Int.cmp. rewrite Int.signed_repr by (unfold Int.max_signed,Int.min_signed;vm_compute;lia).
 rewrite zlt_false by lia. reflexivity.
Qed.
Lemma lower_guard_false : forall ge b m a,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m lower_guard=Some(Vint Int.zero).
Proof.
 intros ge b m a RANGE LOAD.
 change(match pure_rval ge (angle_env b) m read_angle,
   (match pure_rval ge (angle_env b) m pi_expr with
    |Some v=>sem_unary_operation Oneg v tint m|None=>None end) with
 |Some v,Some w=>sem_binary_operation ge Olt v tint w tint m|_,_=>None end = Some(Vint Int.zero)).
 rewrite(angle_read _ _ _ _ LOAD),pi_expr_value.
 cbn[sem_unary_operation sem_neg classify_neg sem_binary_operation sem_cmp classify_cmp sem_cmp_default].
 unfold Int.cmp. rewrite Int.signed_neg by (change(12867<> -2147483648);lia).
 rewrite Int.signed_repr by (unfold Int.max_signed,Int.min_signed;vm_compute;lia).
 rewrite zlt_false by lia. reflexivity.
Qed.
