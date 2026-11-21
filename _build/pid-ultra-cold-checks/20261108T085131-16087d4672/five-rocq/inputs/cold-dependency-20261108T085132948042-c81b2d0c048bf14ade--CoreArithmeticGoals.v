From Stdlib Require Import List.
From compcert Require Import AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import CoreClamp.
From CoreCBMC Require Import ArithmeticTree SourceArithmeticNodes.
Import ListNotations.
Record arithmetic_site:Type:={
 site_top:nat;site_statement_path:list nat;site_expression_path:list nat;site_kind:arithmetic_kind}.
Definition original_site_bound(site:arithmetic_site):Prop:=
 In(site_statement_path site,site_expression_path site,site_kind site)(original_top_nodes(site_top site)).
Fixpoint source_expr_at(p:list nat)(a:expr):option expr:=
 match p with []=>Some a|n::p=>match a,n with
 | Eunop _ a _,0|Evalof a _,0|Ederef a _,0|Eaddrof a _,0|Efield a _ _,0|Ecast a _,0|Eparen a _ _,0|Epostincr _ a _,0=>source_expr_at p a
 | Ebinop _ a _ _,0|Eassign a _ _,0|Eassignop _ a _ _ _,0|Ecomma a _ _,0|Eseqand a _ _,0|Eseqor a _ _,0=>source_expr_at p a
 | Ebinop _ _ b _,1|Eassign _ b _,1|Eassignop _ _ b _ _,1|Ecomma _ b _,1|Eseqand _ b _,1|Eseqor _ b _,1=>source_expr_at p b
 | Econdition c _ _ _,0=>source_expr_at p c|Econdition _ a _ _,1=>source_expr_at p a|Econdition _ _ b _,2=>source_expr_at p b
 | Ecall a _ _,0=>source_expr_at p a|Ecall _ al _,1=>source_exprlist_at p al
 | Ebuiltin _ _ al _,0=>source_exprlist_at p al|_,_=>None end end
with source_exprlist_at(p:list nat)(al:exprlist):option expr:=
 match p,al with 0::p,Econs a _=>source_expr_at p a|1::p,Econs _ al=>source_exprlist_at p al|_,_=>None end.
Fixpoint source_stmt_at(p:list nat)(s:statement):statement:=
 match p with []=>s|n::p=>match s,n with
 | Ssequence a _,0|Sifthenelse _ a _,0=>source_stmt_at p a
 | Ssequence _ b,1|Sifthenelse _ _ b,1=>source_stmt_at p b|_,_=>Sskip end end.
Definition source_site_expr(site:arithmetic_site):option expr:=
 match source_stmt_at(site_statement_path site)(top_statement(site_top site)(fn_body Source.f_guidance_pid_h_run))with
 | Sdo a=>source_expr_at(site_expression_path site)a|_=>None end.
Definition is_tint(ty:type):bool:=if Ctypes.type_eq ty tint then true else false.
Definition source_integer_site(site:arithmetic_site):bool:=
 match source_site_expr site with
 |Some(Ebinop _ a b ty)=>is_tint(typeof a)&&is_tint(typeof b)&&is_tint ty
 |Some(Eunop _ a ty)=>is_tint(typeof a)&&is_tint ty
 |Some(Eassignop _ a b tr ty)=>is_tint(typeof a)&&is_tint(typeof b)&&is_tint tr&&is_tint ty
 |_=>false end.
Definition CoreBinaryEventGoal(op:binary_operation):Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 forall t C x y k e ma,
 star Csem.step Execution.ge(Execution.entry(call_args gh ret flight)m)t
 (ExprState Source.f_guidance_pid_h_run
 (C(Ebinop op(Eval(Vint x)tint)(Eval(Vint y)tint)tint))k e ma) ->
 context RV RV C ->binary_safe op tint tint(Vint x)(Vint y).
Definition CoreUnaryEventGoal(op:unary_operation):Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 forall t C x k e ma,
 star Csem.step Execution.ge(Execution.entry(call_args gh ret flight)m)t
 (ExprState Source.f_guidance_pid_h_run
 (C(Eunop op(Eval(Vint x)tint)tint))k e ma) ->
 context RV RV C ->unary_safe op tint(Vint x).
Definition CoreArithmeticSiteGoal(site:arithmetic_site):Prop:=
 original_site_bound site /\source_integer_site site=true /\match site_kind site with
 | Binary op|Compound op=>CoreBinaryEventGoal op|Unary op=>CoreUnaryEventGoal op end.
Ltac source_site_member:=first[solve[left;reflexivity]|right;source_site_member].
Definition core_overflow_1_site:arithmetic_site:=Build_arithmetic_site 0 [] [1;0;0] (Binary Omul).
Definition core_overflow_1_goal:Prop:=CoreArithmeticSiteGoal core_overflow_1_site.
Lemma core_overflow_1_source_bound:original_site_bound core_overflow_1_site.
Proof. unfold original_site_bound,core_overflow_1_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_2_site:arithmetic_site:=Build_arithmetic_site 0 [] [1;1;0] (Binary Omul).
Definition core_overflow_2_goal:Prop:=CoreArithmeticSiteGoal core_overflow_2_site.
Lemma core_overflow_2_source_bound:original_site_bound core_overflow_2_site.
Proof. unfold original_site_bound,core_overflow_2_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_3_site:arithmetic_site:=Build_arithmetic_site 0 [] [1] (Binary Oadd).
Definition core_overflow_3_goal:Prop:=CoreArithmeticSiteGoal core_overflow_3_site.
Lemma core_overflow_3_source_bound:original_site_bound core_overflow_3_site.
Proof. unfold original_site_bound,core_overflow_3_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_4_site:arithmetic_site:=Build_arithmetic_site 1 [] [1;0;0] (Binary Omul).
Definition core_overflow_4_goal:Prop:=CoreArithmeticSiteGoal core_overflow_4_site.
Lemma core_overflow_4_source_bound:original_site_bound core_overflow_4_site.
Proof. unfold original_site_bound,core_overflow_4_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_5_site:arithmetic_site:=Build_arithmetic_site 1 [] [1;1;0] (Binary Omul).
Definition core_overflow_5_goal:Prop:=CoreArithmeticSiteGoal core_overflow_5_site.
Lemma core_overflow_5_source_bound:original_site_bound core_overflow_5_site.
Proof. unfold original_site_bound,core_overflow_5_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_6_site:arithmetic_site:=Build_arithmetic_site 1 [] [1] (Binary Oadd).
Definition core_overflow_6_goal:Prop:=CoreArithmeticSiteGoal core_overflow_6_site.
Lemma core_overflow_6_source_bound:original_site_bound core_overflow_6_site.
Proof. unfold original_site_bound,core_overflow_6_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_7_site:arithmetic_site:=Build_arithmetic_site 2 [] [1;0;1;0] (Binary Omul).
Definition core_overflow_7_goal:Prop:=CoreArithmeticSiteGoal core_overflow_7_site.
Lemma core_overflow_7_source_bound:original_site_bound core_overflow_7_site.
Proof. unfold original_site_bound,core_overflow_7_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_8_site:arithmetic_site:=Build_arithmetic_site 2 [] [1;0] (Binary Oadd).
Definition core_overflow_8_goal:Prop:=CoreArithmeticSiteGoal core_overflow_8_site.
Lemma core_overflow_8_source_bound:original_site_bound core_overflow_8_site.
Proof. unfold original_site_bound,core_overflow_8_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_9_site:arithmetic_site:=Build_arithmetic_site 2 [] [1;1;0] (Binary Omul).
Definition core_overflow_9_goal:Prop:=CoreArithmeticSiteGoal core_overflow_9_site.
Lemma core_overflow_9_source_bound:original_site_bound core_overflow_9_site.
Proof. unfold original_site_bound,core_overflow_9_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_10_site:arithmetic_site:=Build_arithmetic_site 2 [] [1] (Binary Oadd).
Definition core_overflow_10_goal:Prop:=CoreArithmeticSiteGoal core_overflow_10_site.
Lemma core_overflow_10_source_bound:original_site_bound core_overflow_10_site.
Proof. unfold original_site_bound,core_overflow_10_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_11_site:arithmetic_site:=Build_arithmetic_site 3 [] [1;0;1;0] (Binary Omul).
Definition core_overflow_11_goal:Prop:=CoreArithmeticSiteGoal core_overflow_11_site.
Lemma core_overflow_11_source_bound:original_site_bound core_overflow_11_site.
Proof. unfold original_site_bound,core_overflow_11_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_12_site:arithmetic_site:=Build_arithmetic_site 3 [] [1;0] (Binary Oadd).
Definition core_overflow_12_goal:Prop:=CoreArithmeticSiteGoal core_overflow_12_site.
Lemma core_overflow_12_source_bound:original_site_bound core_overflow_12_site.
Proof. unfold original_site_bound,core_overflow_12_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_13_site:arithmetic_site:=Build_arithmetic_site 3 [] [1;1;0] (Binary Omul).
Definition core_overflow_13_goal:Prop:=CoreArithmeticSiteGoal core_overflow_13_site.
Lemma core_overflow_13_source_bound:original_site_bound core_overflow_13_site.
Proof. unfold original_site_bound,core_overflow_13_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_14_site:arithmetic_site:=Build_arithmetic_site 3 [] [1] (Binary Oadd).
Definition core_overflow_14_goal:Prop:=CoreArithmeticSiteGoal core_overflow_14_site.
Lemma core_overflow_14_source_bound:original_site_bound core_overflow_14_site.
Proof. unfold original_site_bound,core_overflow_14_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_15_site:arithmetic_site:=Build_arithmetic_site 4 [0] [1;0;1] (Unary Oneg).
Definition core_overflow_15_goal:Prop:=CoreArithmeticSiteGoal core_overflow_15_site.
Lemma core_overflow_15_source_bound:original_site_bound core_overflow_15_site.
Proof. unfold original_site_bound,core_overflow_15_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_16_site:arithmetic_site:=Build_arithmetic_site 4 [0] [1;1] (Unary Oneg).
Definition core_overflow_16_goal:Prop:=CoreArithmeticSiteGoal core_overflow_16_site.
Lemma core_overflow_16_source_bound:original_site_bound core_overflow_16_site.
Proof. unfold original_site_bound,core_overflow_16_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_17_site:arithmetic_site:=Build_arithmetic_site 4 [1] [1;0;1] (Unary Oneg).
Definition core_overflow_17_goal:Prop:=CoreArithmeticSiteGoal core_overflow_17_site.
Lemma core_overflow_17_source_bound:original_site_bound core_overflow_17_site.
Proof. unfold original_site_bound,core_overflow_17_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_18_site:arithmetic_site:=Build_arithmetic_site 5 [0;0] [1] (Binary Omul).
Definition core_overflow_18_goal:Prop:=CoreArithmeticSiteGoal core_overflow_18_site.
Lemma core_overflow_18_source_bound:original_site_bound core_overflow_18_site.
Proof. unfold original_site_bound,core_overflow_18_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_19_site:arithmetic_site:=Build_arithmetic_site 5 [0;0] [] (Compound Oadd).
Definition core_overflow_19_goal:Prop:=CoreArithmeticSiteGoal core_overflow_19_site.
Lemma core_overflow_19_source_bound:original_site_bound core_overflow_19_site.
Proof. unfold original_site_bound,core_overflow_19_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_20_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;0] [1] (Binary Omul).
Definition core_overflow_20_goal:Prop:=CoreArithmeticSiteGoal core_overflow_20_site.
Lemma core_overflow_20_source_bound:original_site_bound core_overflow_20_site.
Proof. unfold original_site_bound,core_overflow_20_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_21_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;0] [] (Compound Oadd).
Definition core_overflow_21_goal:Prop:=CoreArithmeticSiteGoal core_overflow_21_site.
Lemma core_overflow_21_source_bound:original_site_bound core_overflow_21_site.
Proof. unfold original_site_bound,core_overflow_21_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_22_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;0;1;0] (Binary Oshl).
Definition core_overflow_22_goal:Prop:=CoreArithmeticSiteGoal core_overflow_22_site.
Lemma core_overflow_22_source_bound:original_site_bound core_overflow_22_site.
Proof. unfold original_site_bound,core_overflow_22_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_23_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;0;1] (Unary Oneg).
Definition core_overflow_23_goal:Prop:=CoreArithmeticSiteGoal core_overflow_23_site.
Lemma core_overflow_23_source_bound:original_site_bound core_overflow_23_site.
Proof. unfold original_site_bound,core_overflow_23_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_24_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;1;0] (Binary Oshl).
Definition core_overflow_24_goal:Prop:=CoreArithmeticSiteGoal core_overflow_24_site.
Lemma core_overflow_24_source_bound:original_site_bound core_overflow_24_site.
Proof. unfold original_site_bound,core_overflow_24_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_25_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;1] (Unary Oneg).
Definition core_overflow_25_goal:Prop:=CoreArithmeticSiteGoal core_overflow_25_site.
Lemma core_overflow_25_source_bound:original_site_bound core_overflow_25_site.
Proof. unfold original_site_bound,core_overflow_25_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_26_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;2;0;1] (Binary Oshl).
Definition core_overflow_26_goal:Prop:=CoreArithmeticSiteGoal core_overflow_26_site.
Lemma core_overflow_26_source_bound:original_site_bound core_overflow_26_site.
Proof. unfold original_site_bound,core_overflow_26_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_27_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;2;1] (Binary Oshl).
Definition core_overflow_27_goal:Prop:=CoreArithmeticSiteGoal core_overflow_27_site.
Lemma core_overflow_27_source_bound:original_site_bound core_overflow_27_site.
Proof. unfold original_site_bound,core_overflow_27_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_28_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;0;1;0] (Binary Oshl).
Definition core_overflow_28_goal:Prop:=CoreArithmeticSiteGoal core_overflow_28_site.
Lemma core_overflow_28_source_bound:original_site_bound core_overflow_28_site.
Proof. unfold original_site_bound,core_overflow_28_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_29_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;0;1] (Unary Oneg).
Definition core_overflow_29_goal:Prop:=CoreArithmeticSiteGoal core_overflow_29_site.
Lemma core_overflow_29_source_bound:original_site_bound core_overflow_29_site.
Proof. unfold original_site_bound,core_overflow_29_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_30_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;2;0;1] (Binary Oshl).
Definition core_overflow_30_goal:Prop:=CoreArithmeticSiteGoal core_overflow_30_site.
Lemma core_overflow_30_source_bound:original_site_bound core_overflow_30_site.
Proof. unfold original_site_bound,core_overflow_30_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_31_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;2;1] (Binary Oshl).
Definition core_overflow_31_goal:Prop:=CoreArithmeticSiteGoal core_overflow_31_site.
Lemma core_overflow_31_source_bound:original_site_bound core_overflow_31_site.
Proof. unfold original_site_bound,core_overflow_31_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_32_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;1;0] [] (Compound Oadd).
Definition core_overflow_32_goal:Prop:=CoreArithmeticSiteGoal core_overflow_32_site.
Lemma core_overflow_32_source_bound:original_site_bound core_overflow_32_site.
Proof. unfold original_site_bound,core_overflow_32_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_33_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;1;1] [] (Compound Oadd).
Definition core_overflow_33_goal:Prop:=CoreArithmeticSiteGoal core_overflow_33_site.
Lemma core_overflow_33_source_bound:original_site_bound core_overflow_33_site.
Proof. unfold original_site_bound,core_overflow_33_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_34_site:arithmetic_site:=Build_arithmetic_site 6 [0;0] [1;0] (Binary Omul).
Definition core_overflow_34_goal:Prop:=CoreArithmeticSiteGoal core_overflow_34_site.
Lemma core_overflow_34_source_bound:original_site_bound core_overflow_34_site.
Proof. unfold original_site_bound,core_overflow_34_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_35_site:arithmetic_site:=Build_arithmetic_site 6 [0;1;0] [1;0;0] (Binary Omul).
Definition core_overflow_35_goal:Prop:=CoreArithmeticSiteGoal core_overflow_35_site.
Lemma core_overflow_35_source_bound:original_site_bound core_overflow_35_site.
Proof. unfold original_site_bound,core_overflow_35_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_36_site:arithmetic_site:=Build_arithmetic_site 6 [0;1;0] [1;0] (Binary Oadd).
Definition core_overflow_36_goal:Prop:=CoreArithmeticSiteGoal core_overflow_36_site.
Lemma core_overflow_36_source_bound:original_site_bound core_overflow_36_site.
Proof. unfold original_site_bound,core_overflow_36_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_37_site:arithmetic_site:=Build_arithmetic_site 6 [0;1;1;0] [1;0;1;0;0] (Binary Omul).
Definition core_overflow_37_goal:Prop:=CoreArithmeticSiteGoal core_overflow_37_site.
Lemma core_overflow_37_source_bound:original_site_bound core_overflow_37_site.
Proof. unfold original_site_bound,core_overflow_37_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_38_site:arithmetic_site:=Build_arithmetic_site 6 [0;1;1;1] [1;0;1;0;0] (Binary Omul).
Definition core_overflow_38_goal:Prop:=CoreArithmeticSiteGoal core_overflow_38_site.
Lemma core_overflow_38_source_bound:original_site_bound core_overflow_38_site.
Proof. unfold original_site_bound,core_overflow_38_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_39_site:arithmetic_site:=Build_arithmetic_site 7 [0] [1;0;1] (Unary Oneg).
Definition core_overflow_39_goal:Prop:=CoreArithmeticSiteGoal core_overflow_39_site.
Lemma core_overflow_39_source_bound:original_site_bound core_overflow_39_site.
Proof. unfold original_site_bound,core_overflow_39_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_40_site:arithmetic_site:=Build_arithmetic_site 7 [0] [1;1] (Unary Oneg).
Definition core_overflow_40_goal:Prop:=CoreArithmeticSiteGoal core_overflow_40_site.
Lemma core_overflow_40_source_bound:original_site_bound core_overflow_40_site.
Proof. unfold original_site_bound,core_overflow_40_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_overflow_41_site:arithmetic_site:=Build_arithmetic_site 7 [1] [1;0;1] (Unary Oneg).
Definition core_overflow_41_goal:Prop:=CoreArithmeticSiteGoal core_overflow_41_site.
Lemma core_overflow_41_source_bound:original_site_bound core_overflow_41_site.
Proof. unfold original_site_bound,core_overflow_41_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_1_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;0;1;0] (Binary Oshl).
Definition core_undefined_shift_1_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_1_site.
Lemma core_undefined_shift_1_source_bound:original_site_bound core_undefined_shift_1_site.
Proof. unfold original_site_bound,core_undefined_shift_1_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_2_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;1;0] (Binary Oshl).
Definition core_undefined_shift_2_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_2_site.
Lemma core_undefined_shift_2_source_bound:original_site_bound core_undefined_shift_2_site.
Proof. unfold original_site_bound,core_undefined_shift_2_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_3_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;2;0;1] (Binary Oshl).
Definition core_undefined_shift_3_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_3_site.
Lemma core_undefined_shift_3_source_bound:original_site_bound core_undefined_shift_3_site.
Proof. unfold original_site_bound,core_undefined_shift_3_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_4_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;0] [1;2;1] (Binary Oshl).
Definition core_undefined_shift_4_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_4_site.
Lemma core_undefined_shift_4_source_bound:original_site_bound core_undefined_shift_4_site.
Proof. unfold original_site_bound,core_undefined_shift_4_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_5_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;0;1;0] (Binary Oshl).
Definition core_undefined_shift_5_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_5_site.
Lemma core_undefined_shift_5_source_bound:original_site_bound core_undefined_shift_5_site.
Proof. unfold original_site_bound,core_undefined_shift_5_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_6_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;2;0;1] (Binary Oshl).
Definition core_undefined_shift_6_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_6_site.
Lemma core_undefined_shift_6_source_bound:original_site_bound core_undefined_shift_6_site.
Proof. unfold original_site_bound,core_undefined_shift_6_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Definition core_undefined_shift_7_site:arithmetic_site:=Build_arithmetic_site 5 [0;1;1;0;1] [1;2;1] (Binary Oshl).
Definition core_undefined_shift_7_goal:Prop:=CoreArithmeticSiteGoal core_undefined_shift_7_site.
Lemma core_undefined_shift_7_source_bound:original_site_bound core_undefined_shift_7_site.
Proof. unfold original_site_bound,core_undefined_shift_7_site;cbv beta iota zeta delta[site_statement_path site_expression_path site_kind site_top original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd];source_site_member. Qed.
Lemma core_overflow_1_integer_source:source_integer_site core_overflow_1_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_2_integer_source:source_integer_site core_overflow_2_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_3_integer_source:source_integer_site core_overflow_3_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_4_integer_source:source_integer_site core_overflow_4_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_5_integer_source:source_integer_site core_overflow_5_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_6_integer_source:source_integer_site core_overflow_6_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_7_integer_source:source_integer_site core_overflow_7_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_8_integer_source:source_integer_site core_overflow_8_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_9_integer_source:source_integer_site core_overflow_9_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_10_integer_source:source_integer_site core_overflow_10_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_11_integer_source:source_integer_site core_overflow_11_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_12_integer_source:source_integer_site core_overflow_12_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_13_integer_source:source_integer_site core_overflow_13_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_14_integer_source:source_integer_site core_overflow_14_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_15_integer_source:source_integer_site core_overflow_15_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_16_integer_source:source_integer_site core_overflow_16_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_17_integer_source:source_integer_site core_overflow_17_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_18_integer_source:source_integer_site core_overflow_18_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_19_integer_source:source_integer_site core_overflow_19_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_20_integer_source:source_integer_site core_overflow_20_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_21_integer_source:source_integer_site core_overflow_21_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_22_integer_source:source_integer_site core_overflow_22_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_23_integer_source:source_integer_site core_overflow_23_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_24_integer_source:source_integer_site core_overflow_24_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_25_integer_source:source_integer_site core_overflow_25_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_26_integer_source:source_integer_site core_overflow_26_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_27_integer_source:source_integer_site core_overflow_27_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_28_integer_source:source_integer_site core_overflow_28_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_29_integer_source:source_integer_site core_overflow_29_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_30_integer_source:source_integer_site core_overflow_30_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_31_integer_source:source_integer_site core_overflow_31_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_32_integer_source:source_integer_site core_overflow_32_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_33_integer_source:source_integer_site core_overflow_33_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_34_integer_source:source_integer_site core_overflow_34_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_35_integer_source:source_integer_site core_overflow_35_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_36_integer_source:source_integer_site core_overflow_36_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_37_integer_source:source_integer_site core_overflow_37_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_38_integer_source:source_integer_site core_overflow_38_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_39_integer_source:source_integer_site core_overflow_39_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_40_integer_source:source_integer_site core_overflow_40_site=true. Proof. reflexivity. Qed.
Lemma core_overflow_41_integer_source:source_integer_site core_overflow_41_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_1_integer_source:source_integer_site core_undefined_shift_1_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_2_integer_source:source_integer_site core_undefined_shift_2_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_3_integer_source:source_integer_site core_undefined_shift_3_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_4_integer_source:source_integer_site core_undefined_shift_4_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_5_integer_source:source_integer_site core_undefined_shift_5_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_6_integer_source:source_integer_site core_undefined_shift_6_site=true. Proof. reflexivity. Qed.
Lemma core_undefined_shift_7_integer_source:source_integer_site core_undefined_shift_7_site=true. Proof. reflexivity. Qed.
