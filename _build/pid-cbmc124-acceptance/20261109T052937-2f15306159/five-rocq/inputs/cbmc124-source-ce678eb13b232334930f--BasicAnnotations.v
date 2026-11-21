From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation.
From PidPositionTranslationCore Require Import ClampSemantics.
From CoreCBMC Require Import ArithmeticTree NumericBounds.
Open Scope Z_scope.
Fixpoint data_expression(a:expr):bool:=
 match a with
 | Eval _ _|Evar _ _|Eloc _ _ _ _|Esizeof _ _|Ealignof _ _=>true
 | Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Ecast a _|Eparen a _ _=>data_expression a
 | _=>false end.
Lemma data_expression_tree:forall ge e m a,
 data_expression a=true ->arithmetic_tree ge e m a.
Proof. intros ge e m a;induction a;cbn[data_expression arithmetic_tree];intros;try discriminate;auto. Qed.
Lemma binary_values_tree:forall ge e m op a b ty va vb,
 arithmetic_tree ge e m a ->arithmetic_tree ge e m b ->
 pure_rval ge e m a=Some va ->pure_rval ge e m b=Some vb ->
 binary_safe op(typeof a)(typeof b)va vb ->
 arithmetic_tree ge e m(Ebinop op a b ty).
Proof.
 intros;cbn[arithmetic_tree];split;[exact H|];split;[exact H0|].
 unfold binary_condition;rewrite H1,H2;exact H3.
Qed.
Lemma unary_value_tree:forall ge e m op a ty va,
 arithmetic_tree ge e m a ->pure_rval ge e m a=Some va ->
 unary_safe op(typeof a)va ->arithmetic_tree ge e m(Eunop op a ty).
Proof. intros;cbn[arithmetic_tree];split;[exact H|];unfold unary_condition;rewrite H0;exact H1. Qed.
Lemma comparison_condition:forall ge e m a b op,
 (op=Olt \/op=Ogt \/op=Ole \/op=Oge \/op=Oeq \/op=One) ->
 binary_condition ge e m op a b.
Proof.
 intros ge e m a b op OPS;unfold binary_condition;
 destruct(pure_rval ge e m a)as[va|];[destruct(pure_rval ge e m b)as[vb|]|];try constructor.
 destruct OPS as[E|[E|[E|[E|[E|E]]]]];subst op;destruct va,vb;constructor.
Qed.
Lemma int32_clamp_tree:forall ge e m r maximum mx,
 arithmetic_tree ge e m r ->arithmetic_tree ge e m maximum ->
 typeof maximum=tint ->pure_rval ge e m maximum=Some(Vint mx) ->
 Int.signed mx<> -2147483648 ->
 arithmetic_tree ge e m(clamp_expr r maximum).
Proof.
 intros ge e m r maximum mx RT MT TY MV NONMIN.
 assert(NEG:arithmetic_tree ge e m(Eunop Oneg maximum tint)).
 { eapply unary_value_tree;[exact MT|exact MV|rewrite TY;exact NONMIN]. }
 unfold clamp_expr;cbn[arithmetic_tree];split.
 - split;[exact RT|];split;[exact NEG|apply comparison_condition;auto].
 - split;[exact NEG|];split.
   + split;[exact RT|];split;[exact MT|apply comparison_condition;auto].
   + split;assumption.
Qed.
Lemma compound_add_tree:forall ge e m l r b ofs bf left right,
 arithmetic_tree ge e m l ->arithmetic_tree ge e m r ->
 typeof l=tint ->typeof r=tint ->
 pure_lval ge e m l=Some(b,ofs,bf) ->
 Cexec.do_deref_loc ge quiet_world tint m b ofs bf=Some(quiet_world,E0,Vint left) ->
 pure_rval ge e m r=Some(Vint right) ->
 signed32(Int.signed left+Int.signed right) ->
 arithmetic_tree ge e m(Eassignop Oadd l r tint tint).
Proof.
 intros ge e m l r b ofs bf left right TL TR LT RT LV READ RV SAFE.
 cbn[arithmetic_tree];split;[exact TL|];split;[exact TR|];split.
 - rewrite LT;reflexivity.
 - unfold assignop_condition;rewrite LV,RV,LT,RT,READ;exact SAFE.
Qed.
Print Assumptions int32_clamp_tree.
