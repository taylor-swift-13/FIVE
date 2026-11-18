From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceSoftwareProof Require Import ValueEvaluator ValueChecker NumericOps LocalMemory FlatStatements ValueSound AssignmentSound.
Import ListNotations.
Definition outcome_rho(o:value_outcome):PTree.t val:=
 match o with ValueNormal r|ValueReturn _ _ r=>r end.
Definition runtime_outcome(o:value_outcome):outcome:=
 match o with ValueNormal _=>Out_normal|ValueReturn v ty _=>Out_return(Some(v,ty))end.
Definition heap_result(le:env)(m mf:mem)(o:value_outcome):Prop:=
 locals_repr(outcome_rho o)le mf /\locals_writable le mf /\
 access_preserved m mf /\stores_to(local_blocks le)m mf.
Lemma heap_result_refl:forall le rho m,locals_repr rho le m->locals_writable le m->
 heap_result le m m(ValueNormal rho).
Proof. intros;split;[assumption|];split;[assumption|];split;[intros ch b ofs p A;exact A|constructor]. Qed.
Lemma heap_result_return:forall le rho m v ty,locals_repr rho le m->locals_writable le m->
 heap_result le m m(ValueReturn v ty rho).
Proof. intros;exact(heap_result_refl le rho m H H0). Qed.
Lemma heap_result_trans:forall le m mi mf o r,
 heap_result le m mi(ValueNormal r)->heap_result le mi mf o->heap_result le m mf o.
Proof.
 intros le m mi mf o r [R[W[A S]]][R'[W'[A' S']]];split;[exact R'|];split;[exact W'|];split.
 - intros ch b ofs p VA;apply A';apply A;exact VA.
 - eapply stores_to_trans;eauto.
Qed.
Section STATEMENTS.
Variables union_id float_field uint_field:ident.
Variable gamma:PTree.t type.
Lemma good_join_left:forall ret a b o,
 good_value_outcome union_id gamma ret a o->
 good_value_outcome union_id gamma ret(join_outcome a b)o.
Proof.
 intros ret a b o G;destruct o;cbn in *;[|exact G].
 destruct a,b;cbn in *;try contradiction;try exact G.
 eapply initialized_values_weaken;[apply intersection_left|exact G].
Qed.
Lemma good_join_right:forall ret a b o,
 good_value_outcome union_id gamma ret b o->
 good_value_outcome union_id gamma ret(join_outcome a b)o.
Proof.
 intros ret a b o G;destruct o;cbn in *;[|exact G].
 destruct a,b;cbn in *;try contradiction;try exact G.
 eapply initialized_values_weaken;[apply intersection_right|exact G].
Qed.
Theorem checked_statement_sound:forall s ret ids expected rho ge le m,
 check_statement union_id float_field uint_field gamma ret ids s=Some expected ->
 env_matches gamma le->union_layout union_id float_field uint_field ge->
 env_separated le->locals_repr rho le m->locals_writable le m->
 initialized_values union_id gamma ids rho->
 exists o mf,
 value_statement union_id float_field uint_field gamma rho s=Some o /\
 statement_eval ge le s m=Some(runtime_outcome o,mf) /\
 good_value_outcome union_id gamma ret expected o /\heap_result le m mf o.
Proof.
 induction s;intros ret ids expected rho ge le m CHECK ENV LAYOUT SEP REP W INIT;
 cbn[check_statement]in CHECK;try discriminate.
 - injection CHECK as E;subst expected;exists(ValueNormal rho),m;split;[reflexivity|].
   split;[reflexivity|];split;[exact INIT|apply heap_result_refl;assumption].
 - destruct e;try discriminate.
   destruct(check_assign union_id float_field uint_field gamma ids e1 e2 ty)as[ids'|]eqn:CA;try discriminate.
   injection CHECK as E;subst expected.
   destruct(checked_assign_sound union_id float_field uint_field gamma ids e1 e2 ty ids' rho ge le m CA ENV LAYOUT SEP REP W INIT)
    as[rho'[mf[VA[EV[INIT'[REP'[W'[ACC HISTORY]]]]]]]].
   exists(ValueNormal rho'),mf;split.
   + cbn[value_statement];rewrite VA;reflexivity.
   + split;[exact EV|]. split;[exact INIT'|]. split;[exact REP'|];split;[exact W'|];split;[exact ACC|exact HISTORY].
 - destruct(check_statement union_id float_field uint_field gamma ret ids s1)as[first|]eqn:C1;try discriminate.
   destruct(IHs1 ret ids first rho ge le m C1 ENV LAYOUT SEP REP W INIT)as[o1[mi[V1[E1[G1 H1]]]]].
   destruct first as[ids1|].
   + destruct o1 as[rho1|v ty rho1].
     * destruct H1 as[R1[W1[A1 S1]]].
       destruct(IHs2 ret ids1 expected rho1 ge le mi CHECK ENV LAYOUT SEP R1 W1 G1)as[o2[mf[V2[E2[G2 H2]]]]].
       exists o2,mf;split.
       -- cbn[value_statement];rewrite V1;exact V2.
       -- split;[cbn[statement_eval];rewrite E1;exact E2|].
          split;[exact G2|];eapply heap_result_trans;[split;[exact R1|];split;[exact W1|];split;[exact A1|exact S1]|exact H2].
     * exists(ValueReturn v ty rho1),mi;split.
       -- cbn[value_statement];rewrite V1;reflexivity.
       -- split;[cbn[statement_eval];rewrite E1;reflexivity|];split;[exact G1|exact H1].
   + injection CHECK as E;subst expected.
     destruct o1 as[rho1|v ty rho1];[contradiction G1|].
     exists(ValueReturn v ty rho1),mi;split.
     * cbn[value_statement];rewrite V1;reflexivity.
     * split;[cbn[statement_eval];rewrite E1;reflexivity|];split;assumption.
 - destruct(check_expr union_id float_field uint_field gamma ids e)eqn:CE;try discriminate.
   destruct(check_statement union_id float_field uint_field gamma ret ids s1)as[a|]eqn:C1;try discriminate.
   destruct(check_statement union_id float_field uint_field gamma ret ids s2)as[b|]eqn:C2;try discriminate.
   injection CHECK as E;subst expected.
   destruct(checked_expr_sound union_id float_field uint_field gamma e ids rho ge le m CE ENV LAYOUT REP INIT)as[v[VE[TV PE]]].
   destruct(bool_val_total(typeof e)v TV)as[choose B].
   destruct choose.
   + destruct(IHs1 ret ids a rho ge le m C1 ENV LAYOUT SEP REP W INIT)as[o[mf[VO[EO[GO HO]]]]].
     exists o,mf;split.
     * cbn[value_statement];rewrite VE,B;exact VO.
     * split;[cbn[statement_eval];rewrite PE,B;exact EO|].
       split;[eapply good_join_left;exact GO|exact HO].
   + destruct(IHs2 ret ids b rho ge le m C2 ENV LAYOUT SEP REP W INIT)as[o[mf[VO[EO[GO HO]]]]].
     exists o,mf;split.
     * cbn[value_statement];rewrite VE,B;exact VO.
     * split;[cbn[statement_eval];rewrite PE,B;exact EO|].
       split;[eapply good_join_right;exact GO|exact HO].
 - destruct o as[a|];try discriminate.
   destruct(check_expr union_id float_field uint_field gamma ids a)eqn:CE;try discriminate.
   destruct(type_eq(typeof a)ret)as[TY|NE];try discriminate.
   injection CHECK as E;subst expected.
   destruct(checked_expr_sound union_id float_field uint_field gamma a ids rho ge le m CE ENV LAYOUT REP INIT)as[v[VE[TV PE]]].
   exists(ValueReturn v(typeof a)rho),m;split.
   + cbn[value_statement];rewrite VE;reflexivity.
   + split;[cbn[statement_eval];rewrite PE;reflexivity|].
     split;[cbn;split;[exact TY|rewrite <- TY;exact TV]|apply heap_result_return;assumption].
Qed.
End STATEMENTS.
Print Assumptions checked_statement_sound.

Corollary checked_statement_exec:forall union_id float_field uint_field gamma s ret ids expected rho ge le m,
 source_statement s=true ->
 check_statement union_id float_field uint_field gamma ret ids s=Some expected ->
 env_matches gamma le->union_layout union_id float_field uint_field ge->
 env_separated le->locals_repr rho le m->locals_writable le m->
 initialized_values union_id gamma ids rho->
 exists o mf,
 value_statement union_id float_field uint_field gamma rho s=Some o /\
 Cstrategy.exec_stmt ge le m s E0 mf(runtime_outcome o) /\
 good_value_outcome union_id gamma ret expected o /\heap_result le m mf o.
Proof.
 intros uid ff uf gamma s ret ids expected rho ge le m SOURCE CHECK ENV LAYOUT SEP REP W INIT.
 destruct(checked_statement_sound uid ff uf gamma s ret ids expected rho ge le m CHECK ENV LAYOUT SEP REP W INIT)as[o[mf[V[E[G H]]]]].
 exists o,mf;split;[exact V|];split;[eapply statement_eval_sound;eauto|];split;assumption.
Qed.
Print Assumptions checked_statement_exec.

