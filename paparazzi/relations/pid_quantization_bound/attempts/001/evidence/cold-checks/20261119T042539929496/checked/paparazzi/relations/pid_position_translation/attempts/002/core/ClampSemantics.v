From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport.
Import ListNotations.
Open Scope Z_scope.
Definition clip_bits(v mx:int):int:=if Int.lt v(Int.neg mx)then Int.neg mx else if Int.lt mx v then mx else v.
Definition clamp_expr(r mx:expr):expr:=Econdition(Ebinop Olt r(Eunop Oneg mx tint)tint)
 (Eunop Oneg mx tint)(Econdition(Ebinop Ogt r mx tint)mx r tint)tint.
Lemma condition_from_expressions:forall ge e m c a b ty vc choose v result,
 eval_expression ge e m c E0 m vc ->bool_val vc(typeof c)m=Some choose ->
 eval_expression ge e m(if choose then a else b)E0 m v ->
 sem_cast v(typeof(if choose then a else b))ty m=Some result ->
 eval_expression ge e m(Econdition c a b ty)E0 m result.
Proof.
 intros ge e m c a b ty vc choose v result C BOOL B CAST.
 inversion C;subst;inversion B;subst.
 eapply eval_expression_intro with(a':=Eval result ty);[|constructor].
 replace E0 with(E0**E0)by reflexivity;eapply eval_condition;eauto.
Qed.
Lemma int32_clamp_expression:forall ge e m r mx v maximum,
 typeof r=tint ->typeof mx=tint ->source_simple r=true ->source_simple mx=true ->
 eval_simple_rvalue ge e m r(Vint v) ->eval_simple_rvalue ge e m mx(Vint maximum) ->
 eval_expression ge e m(clamp_expr r mx)E0 m(Vint(clip_bits v maximum)).
Proof.
 intros ge e m r mx v maximum RT MT RS MS RV MV.
 assert(NEG:eval_simple_rvalue ge e m(Eunop Oneg mx tint)(Vint(Int.neg maximum))).
 { eapply esr_unop;[exact MV|rewrite MT;reflexivity]. }
 unfold clamp_expr,clip_bits.
 destruct(Int.lt v(Int.neg maximum))eqn:LOW.
 - eapply condition_from_expressions with(vc:=Vint Int.one)(choose:=true)(v:=Vint(Int.neg maximum)).
   + apply simple_expression;[eapply esr_binop;[exact RV|exact NEG|rewrite RT;change(Some(Val.of_bool(Int.lt v(Int.neg maximum)))=Some(Vint Int.one));rewrite LOW;reflexivity]|cbn[source_simple];rewrite RS,MS;reflexivity].
   + reflexivity.
   + apply simple_expression;[exact NEG|cbn[source_simple];rewrite MS;reflexivity].
   + reflexivity.
 - eapply condition_from_expressions with(vc:=Vint Int.zero)(choose:=false)(v:=Vint(if Int.lt maximum v then maximum else v)).
   + apply simple_expression;[eapply esr_binop;[exact RV|exact NEG|rewrite RT;change(Some(Val.of_bool(Int.lt v(Int.neg maximum)))=Some(Vint Int.zero));rewrite LOW;reflexivity]|cbn[source_simple];rewrite RS,MS;reflexivity].
   + reflexivity.
   + destruct(Int.lt maximum v)eqn:HIGH.
     * eapply condition_from_expressions with(vc:=Vint Int.one)(choose:=true)(v:=Vint maximum).
       -- apply simple_expression;[eapply esr_binop;[exact RV|exact MV|rewrite RT,MT;change(Some(Val.of_bool(Int.lt maximum v))=Some(Vint Int.one));rewrite HIGH;reflexivity]|cbn[source_simple];rewrite RS,MS;reflexivity].
       -- reflexivity.
       -- apply simple_expression;assumption.
       -- rewrite MT;reflexivity.
     * eapply condition_from_expressions with(vc:=Vint Int.zero)(choose:=false)(v:=Vint v).
       -- apply simple_expression;[eapply esr_binop;[exact RV|exact MV|rewrite RT,MT;change(Some(Val.of_bool(Int.lt maximum v))=Some(Vint Int.zero));rewrite HIGH;reflexivity]|cbn[source_simple];rewrite RS,MS;reflexivity].
       -- reflexivity.
       -- apply simple_expression;assumption.
       -- rewrite RT;reflexivity.
   + reflexivity.
Qed.
Lemma atomic_assign_expression:forall ge e m l r ty b ofs bf v vc vout mf,
 eval_simple_lvalue ge e m l b ofs bf ->source_simple l=true ->
 eval_expression ge e m r E0 m v ->
 sem_cast v(typeof r)(typeof l)m=Some vc ->assign_loc ge(typeof l)m b ofs bf vc E0 mf vout ->ty=typeof l ->
 exec_stmt ge e m(Sdo(Eassign l r ty))E0 mf Out_normal.
Proof.
 intros ge e m l r ty b ofs bf v vc vout mf LV LS RV CAST ST TY;inversion RV;subst.
 eapply exec_Sdo;eapply eval_expression_intro with(a':=Eval vout(typeof l));[|constructor].
 replace E0 with(E0**E0**E0)by reflexivity.
 eapply eval_assign;[eapply(proj2(simple_eval_expr_refl ge e m));eauto|eassumption|exact LV|eassumption|exact CAST|exact ST|reflexivity].
Qed.
Print Assumptions int32_clamp_expression.
