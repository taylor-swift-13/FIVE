From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import ProducerSteps ProducerContexts.
Local Open Scope Z_scope.

Definition add_origin(a b:expr):Prop:=
 (typeof a=tshort /\producer SmallDelta b) \/(a=lit 6434 /\producer HalfIndex b) \/
 (producer DivFive a /\b=lit 1) \/(producer ConstantNine a /\b=lit 1).
Definition mul_origin(a b:expr):Prop:=
 (a=lit 3 /\b=lit 3) \/(a=lit 4 /\producer RemainderTwo b).
Definition arithmetic_head(a:expr):Prop:=match a with
 |Ebinop Oadd a b ty=>match ty with Tpointer _ _=>True|_=>add_origin a b end
 |Ebinop Omul a b _=>mul_origin a b
 |Ebinop Oshl a b _=>producer MaskEight a /\b=lit 1
 |Ebinop Oshr _ b _=>producer ShiftCount b
 |Eassignop Oadd l r tyres ty=>typeof l=tshort /\ty=tshort /\tyres=tint /\producer SmallDelta r
 |Eassignop Omul _ _ _ _|Eassignop Oshl _ _ _ _|Eassignop Oshr _ _ _ _=>False
 |Epostincr Incr _ ty=>ty=tshort
 |Epostincr Decr _ _=>False
 |_=>True end.
Fixpoint arithmetic_expr(a:expr):Prop:=arithmetic_head a /\match a with
 |Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>arithmetic_expr a
 |Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>arithmetic_expr a/\arithmetic_expr b
 |Econdition a b c _=>arithmetic_expr a/\arithmetic_expr b/\arithmetic_expr c
 |Ecall a args _=>arithmetic_expr a/\arithmetic_exprlist args
 |Ebuiltin _ _ args _=>arithmetic_exprlist args
 |_=>True end
with arithmetic_exprlist(args:exprlist):Prop:=match args with
 |Enil=>True|Econs a rest=>arithmetic_expr a/\arithmetic_exprlist rest end.

Lemma arithmetic_value : forall v ty,arithmetic_expr(Eval v ty).
Proof. intros;split;exact I. Qed.
Lemma arithmetic_location : forall b ofs bf ty,arithmetic_expr(Eloc b ofs bf ty).
Proof. intros;split;exact I. Qed.
Lemma arithmetic_lred_head : forall ge e a m next mf,
 arithmetic_expr a ->Csem.lred ge e a m next mf ->arithmetic_expr next.
Proof. intros;inversion H0;subst;apply arithmetic_location. Qed.

Lemma arithmetic_rred_head : forall ge a m t next mf,
 arithmetic_expr a ->Csem.rred ge a m t next mf ->arithmetic_expr next.
Proof.
 intros ge a m t next mf A RED;inversion RED;subst;try(apply arithmetic_value).
 all:cbn[arithmetic_expr arithmetic_head]in A|-*.
 all:try(solve[tauto]).
 all:try(solve[destruct b;cbn;tauto]).
 - destruct A as[HEAD[AL AR]]. destruct op;cbn[arithmetic_head]in HEAD|-*;try contradiction.
   all:try(solve[repeat split;exact I]).
   destruct HEAD as[LEFT[TY[REST PROD]]];subst ty1 tyres.
   repeat split;try exact I;unfold add_origin;left;split;[reflexivity|exact PROD].
 - destruct id;cbn[arithmetic_head]in A;[|tauto].
   destruct A as[TYPE CHILD];subst ty.
   cbn[arithmetic_expr arithmetic_head]. repeat split;try exact I.
   unfold add_origin;left;split;[reflexivity|].
   change(producer SmallDelta(Eval(Vint(Int.repr 1))tint)).
   apply producer_value;vm_compute;intuition discriminate.
Qed.
