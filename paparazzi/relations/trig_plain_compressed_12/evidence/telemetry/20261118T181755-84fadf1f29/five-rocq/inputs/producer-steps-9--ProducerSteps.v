From Stdlib Require Import ZArith Lia Bool.
From compcert Require Import Coqlib Integers AST Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import TypedGuards SourceTyping ProducerMath ReachableMath.
Local Open Scope Z_scope.

Inductive producer_kind:=SmallDelta|DivFive|HalfIndex|RemainderTwo|MaskEight|ConstantNine|ShiftCount.
Definition producer_bounds(k:producer_kind)(z:Z):Prop:=match k with
 |SmallDelta=> -4<=z<=10|DivFive=> -6553<=z<=6553|HalfIndex=> -16384<=z<=16383
 |RemainderTwo=>0<=z<=1|MaskEight=>0<=z<=8|ConstantNine=>z=9|ShiftCount=>0<=z<32 end.
Definition lit(z:Z):expr:=(Csyntax.Eval(Vint(Int.repr z))tint).
Inductive producer:producer_kind->expr->Prop:=
| producer_value:forall k x,producer_bounds k(Int.signed x)->producer k(Eval(Vint x)tint)
| producer_mod5:forall a,typeof a=tshort->producer SmallDelta(Ebinop Omod a(lit 5)tint)
| producer_mask7:forall a,typeof a=tshort->producer SmallDelta(Ebinop Oand a(lit 7)tint)
| producer_div5:forall a,typeof a=tshort->producer DivFive(Ebinop Odiv a(lit 5)tint)
| producer_half:forall a,typeof a=tshort->producer HalfIndex(Ebinop Odiv a(lit 2)tint)
| producer_rem2:forall a,typeof a=tushort->producer RemainderTwo(Ebinop Omod a(lit 2)tint)
| producer_mask8:forall a,typeof a=tshort->producer MaskEight(Ebinop Oand a(lit 8)tint)
| producer_nine:producer ConstantNine(Ebinop Omul(lit 3)(lit 3)tint)
| producer_ten:forall a,producer ConstantNine a->producer SmallDelta(Ebinop Oadd a(lit 1)tint)
| producer_shift:forall a,producer RemainderTwo a->producer ShiftCount(Ebinop Omul(lit 4)a tint).

Lemma producer_type : forall k a,producer k a->typeof a=tint.
Proof. intros k a P;inversion P;reflexivity. Qed.
Lemma producer_literal_bounds : forall k v ty,producer k(Eval v ty)->
 exists x,v=Vint x /\ty=tint /\producer_bounds k(Int.signed x).
Proof. intros k v ty P;inversion P;subst;eauto. Qed.
Lemma producer_no_lred : forall ge e k a m a' mf,producer k a->Csem.lred ge e a m a' mf->False.
Proof. intros ge e k a m a' mf P R;inversion R;subst;inversion P. Qed.

Lemma short_div5_semantics : forall ge m v result,
 sem_binary_operation ge Odiv v tshort(Vint(Int.repr 5))tint m=Some result ->
 exists x,v=Vint x /\result=Vint(Int.divs x(Int.repr 5)).
Proof.
 intros ge m v result S;destruct v;try discriminate S.
 all:cbv beta iota zeta delta[sem_binary_operation sem_div sem_binarith classify_binarith binarith_type typeconv
 sem_cast classify_cast cast_int_int remove_attributes change_attributes tshort tint Archi.ptr64]in S;try discriminate S.
 all:assert(E50:Int.eq(Int.repr 5)Int.zero=false)by(vm_compute;reflexivity).
 all:assert(E5M:Int.eq(Int.repr 5)Int.mone=false)by(vm_compute;reflexivity).
 all:cbn in S;rewrite ?E50,?E5M,?andb_false_r in S;cbn in S;try discriminate S.
 all:inversion S;subst;eauto.
Qed.
Lemma short_div2_semantics : forall ge m v result,
 sem_binary_operation ge Odiv v tshort(Vint(Int.repr 2))tint m=Some result ->
 exists x,v=Vint x /\result=Vint(Int.divs x(Int.repr 2)).
Proof.
 intros ge m v result S;destruct v;try discriminate S.
 all:cbv beta iota zeta delta[sem_binary_operation sem_div sem_binarith classify_binarith binarith_type typeconv
 sem_cast classify_cast cast_int_int remove_attributes change_attributes tshort tint Archi.ptr64]in S;try discriminate S.
 all:assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 all:assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 all:cbn in S;rewrite ?E20,?E2M,?andb_false_r in S;cbn in S;try discriminate S.
 all:inversion S;subst;eauto.
Qed.
Lemma short_mod5_semantics : forall ge m v result,
 sem_binary_operation ge Omod v tshort(Vint(Int.repr 5))tint m=Some result ->
 exists x,v=Vint x /\result=Vint(Int.mods x(Int.repr 5)).
Proof.
 intros ge m v result S;destruct v;try discriminate S.
 all:cbv beta iota zeta delta[sem_binary_operation sem_mod sem_binarith classify_binarith binarith_type typeconv
 sem_cast classify_cast cast_int_int remove_attributes change_attributes tshort tint Archi.ptr64]in S;try discriminate S.
 all:assert(E50:Int.eq(Int.repr 5)Int.zero=false)by(vm_compute;reflexivity).
 all:assert(E5M:Int.eq(Int.repr 5)Int.mone=false)by(vm_compute;reflexivity).
 all:cbn in S;rewrite ?E50,?E5M,?andb_false_r in S;cbn in S;try discriminate S.
 all:inversion S;subst;eauto.
Qed.
Lemma ushort_mod2_semantics : forall ge m v result,
 sem_binary_operation ge Omod v tushort(Vint(Int.repr 2))tint m=Some result ->
 exists x,v=Vint x /\result=Vint(Int.mods x(Int.repr 2)).
Proof.
 intros ge m v result S;destruct v;try discriminate S.
 all:cbv beta iota zeta delta[sem_binary_operation sem_mod sem_binarith classify_binarith binarith_type typeconv
 sem_cast classify_cast cast_int_int remove_attributes change_attributes tushort tint Archi.ptr64]in S;try discriminate S.
 all:assert(E20:Int.eq(Int.repr 2)Int.zero=false)by(vm_compute;reflexivity).
 all:assert(E2M:Int.eq(Int.repr 2)Int.mone=false)by(vm_compute;reflexivity).
 all:cbn in S;rewrite ?E20,?E2M,?andb_false_r in S;cbn in S;try discriminate S.
 all:inversion S;subst;eauto.
Qed.
Lemma short_mask_semantics : forall ge m v n result,
 sem_binary_operation ge Oand v tshort(Vint(Int.repr n))tint m=Some result ->
 exists x,v=Vint x /\result=Vint(Int.and x(Int.repr n)).
Proof.
 intros ge m v n result S;destruct v;try discriminate S.
 all:cbv beta iota zeta delta[sem_binary_operation sem_and sem_binarith classify_binarith binarith_type typeconv
 sem_cast classify_cast cast_int_int remove_attributes change_attributes tshort tint Archi.ptr64]in S;try discriminate S.
 all:inversion S;subst;eauto.
Qed.

Theorem producer_head_rred : forall (ge:Csem.genv) te k a m t next mf,
 producer k a ->Ctyping.wt_rvalue ge te a ->Csem.rred ge a m t next mf ->producer k next.
Proof.
 intros ge te k a m t next mf P W RED;inversion P;subst.
 - inversion RED.
 - inversion RED;subst;cbn[typeof]in H;subst ty1.
   match goal with S:sem_binary_operation _ Omod _ _ _ _ _=Some _|-_=>
    destruct(@short_mod5_semantics ge _ _ _ S)as[x[X RESULT]];subst end.
   apply producer_value;unfold producer_bounds;pose proof(signed_mod5_value x);lia.
 - inversion RED;subst;cbn[typeof]in H;subst ty1.
   match goal with S:sem_binary_operation _ Oand _ _ _ _ _=Some _|-_=>
    destruct(@short_mask_semantics ge _ _ 7 _ S)as[x[X RESULT]];subst end.
   apply producer_value;unfold producer_bounds;pose proof(signed_mask7_value x);lia.
 - inversion RED;subst;cbn[typeof]in H;subst ty1.
   match goal with S:sem_binary_operation _ Odiv _ _ _ _ _=Some _|-_=>
    destruct(@short_div5_semantics ge _ _ _ S)as[x[X RESULT]];subst end.
   apply producer_value;unfold producer_bounds;apply signed_div5_value.
   destruct(@typed_ready_binary_operands ge te Odiv(Vint x)tshort(Vint(Int.repr 5))tint tint W)as[L R].
   exact(@typed_eval_short_range x L).
 - inversion RED;subst;cbn[typeof]in H;subst ty1.
   match goal with S:sem_binary_operation _ Odiv _ _ _ _ _=Some _|-_=>
    destruct(@short_div2_semantics ge _ _ _ S)as[x[X RESULT]];subst end.
   apply producer_value;unfold producer_bounds;apply signed_div2_value.
   destruct(@typed_ready_binary_operands ge te Odiv(Vint x)tshort(Vint(Int.repr 2))tint tint W)as[L R].
   exact(@typed_eval_short_range x L).
 - inversion RED;subst;cbn[typeof]in H;subst ty1.
   match goal with S:sem_binary_operation _ Omod _ _ _ _ _=Some _|-_=>
    destruct(@ushort_mod2_semantics ge _ _ _ S)as[x[X RESULT]];subst end.
   apply producer_value;unfold producer_bounds;apply signed_rem2_value.
   destruct(@typed_ready_binary_operands ge te Omod(Vint x)tushort(Vint(Int.repr 2))tint tint W)as[L R].
   exact(@typed_eval_ushort_range x L).
 - inversion RED;subst;cbn[typeof]in H;subst ty1.
   match goal with S:sem_binary_operation _ Oand _ _ _ _ _=Some _|-_=>
    destruct(@short_mask_semantics ge _ _ 8 _ S)as[x[X RESULT]];subst end.
   apply producer_value;unfold producer_bounds;exact(signed_mask8_value x).
 - inversion RED;subst;unfold lit in *.
   match goal with S:sem_binary_operation _ Omul _ _ _ _ _=Some _|-_=>change(Some(Vint(Int.repr 9))=Some _)in S;inversion S;subst end.
   apply producer_value;reflexivity.
 - inversion RED;subst.
   match goal with PR:producer ConstantNine(Eval _ _)|-_=>destruct(@producer_literal_bounds _ _ _ PR)as[x[X[TY B]]];subst end.
   assert(XEQ:x=Int.repr 9)by(rewrite<-B;apply Int.repr_signed);subst x.
   match goal with S:sem_binary_operation _ Oadd _ _ _ _ _=Some _|-_=>change(Some(Vint(Int.repr 10))=Some _)in S;inversion S;subst end.
   apply producer_value;vm_compute;intuition discriminate.
 - inversion RED;subst.
   match goal with PR:producer RemainderTwo(Eval _ _)|-_=>destruct(@producer_literal_bounds _ _ _ PR)as[x[X[TY B]]];subst end.
   match goal with S:sem_binary_operation _ Omul _ _ _ _ _=Some _|-_=>change(Some(Vint(Int.mul(Int.repr 4)x))=Some _)in S;inversion S;subst end.
   apply producer_value;unfold producer_bounds in *;pose proof(@signed_mul4_small x B);lia.
Qed.
