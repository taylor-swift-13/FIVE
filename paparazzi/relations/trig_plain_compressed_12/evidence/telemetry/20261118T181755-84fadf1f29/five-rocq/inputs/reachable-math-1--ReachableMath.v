From Stdlib Require Import ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Ctypes Ctypesdefs Cop Csyntax Csem Ctyping Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigCBMC Require Import TypedGuards SourceTyping.
Local Open Scope Z_scope.

Lemma typed_ready_binary_operands : forall ce te op v1 ty1 v2 ty2 ty,
 Ctyping.wt_rvalue ce te(Ebinop op(Eval v1 ty1)(Eval v2 ty2)ty) ->
 Ctyping.wt_val v1 ty1 /\Ctyping.wt_val v2 ty2.
Proof.
 intros ce te op v1 ty1 v2 ty2 ty W;inversion W;subst.
 repeat match goal with H:Ctyping.wt_rvalue _ _(Eval _ _)|-_=>inversion H;subst;clear H end.
 split;assumption.
Qed.

Theorem every_reachable_short_add_one_guard : forall args m prefix f C k e mp x ty,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Ebinop Oadd(Eval(Vint x)tshort)(Eval(Vint Int.one)tint)ty))k e mp) ->
 Csem.context RV RV C ->signed32(Int.signed x+1).
Proof.
 intros args m prefix f C k e mp x ty PATH CONTEXT.
 destruct(@original_reachable_redex_typed args m prefix f C k e mp
  (Ebinop Oadd(Eval(Vint x)tshort)(Eval(Vint Int.one)tint)ty)PATH CONTEXT)as[te T].
 destruct(@typed_ready_binary_operands(Csem.globalenv PprzTrigInit.Source.prog)te Oadd
  (Vint x)tshort(Vint Int.one)tint ty T)as[L R].
 apply short_increment_guard;exact(@typed_eval_short_range x L).
Qed.

Theorem every_reachable_uchar_shift_operand_guard : forall args m prefix f C k e mp x count ty,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Ebinop Oshl(Eval(Vint x)tuchar)(Eval(Vint(Int.repr count))tint)ty))k e mp) ->
 Csem.context RV RV C ->(count=4\/count=8) ->
 0<=Int.signed x /\0<=count<32 /\signed32(Int.signed x*2^count).
Proof.
 intros args m prefix f C k e mp x count ty PATH CONTEXT COUNT.
 destruct(@original_reachable_redex_typed args m prefix f C k e mp
  (Ebinop Oshl(Eval(Vint x)tuchar)(Eval(Vint(Int.repr count))tint)ty)PATH CONTEXT)as[te T].
 destruct(@typed_ready_binary_operands(Csem.globalenv PprzTrigInit.Source.prog)te Oshl
  (Vint x)tuchar(Vint(Int.repr count))tint ty T)as[L R].
 exact(@uchar_decoder_shift_guards(Int.signed x)count(@typed_eval_uchar_range x L)COUNT).
Qed.

Theorem every_reachable_short_negation_guard : forall args m prefix f C k e mp x ty,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
 (ExprState f(C(Eunop Oneg(Eval(Vint x)tshort)ty))k e mp) ->
 Csem.context RV RV C ->signed32(-Int.signed x).
Proof.
 intros args m prefix f C k e mp x ty PATH CONTEXT.
 destruct(@original_reachable_redex_typed args m prefix f C k e mp
  (Eunop Oneg(Eval(Vint x)tshort)ty)PATH CONTEXT)as[te T].
 inversion T;subst.
 match goal with W:Ctyping.wt_rvalue _ _(Eval(Vint x)tshort)|-_=>inversion W;subst end.
 match goal with V:Ctyping.wt_val(Vint x)tshort|-_=>pose proof(@typed_eval_short_range x V)as B end.
 unfold signed16 in B;unfold signed32;lia.
Qed.
