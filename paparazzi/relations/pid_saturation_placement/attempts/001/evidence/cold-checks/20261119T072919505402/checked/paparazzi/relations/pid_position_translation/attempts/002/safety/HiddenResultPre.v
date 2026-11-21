From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation PureProgress CallfreeExecution.
From PidPositionSafety Require Import PureCallArguments HiddenResultLhs HiddenResultContext.
Import ListNotations.
Module L:=HiddenResultLhs.
Section PRE.
Variable ge:genv.
Variable caller leaf:function.
Variable e:env.
Variable k:cont.
Variable m:mem.
Variable sid ires:AST.ident.
Variable br ret:block.
Variable params:list type.
Variable cc:AST.calling_convention.
Variable vf:val.
Variable values:list val.
Variable post:expr.
Local Notation sty:=(L.sty sid).
Local Notation LH:=(L.lhs sid ires br ret).
Hypothesis local_res:e!ires=Some(br,tptr sty).
Hypothesis res_deref:Cexec.do_deref_loc ge quiet_world(tptr sty)m br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero).
Hypothesis find_leaf:Genv.find_funct ge vf=Some(Internal leaf).
Hypothesis leaf_type:type_of_fundef(Internal leaf)=Tfunction params tvoid cc.
Record prepared(fn:expr)(al:exprlist):Prop:={
 prepared_fn_simple:simple fn=true;
 prepared_args_simple:simplelist al=true;
 prepared_fn_value:eval_simple_rvalue ge e m fn vf;
 prepared_arg_values:eval_simple_list ge e m al params values;
 prepared_class:classify_fun(typeof fn)=fun_case_f params tvoid cc
}.
Definition pre_expr(st:L.lhs_stage)(fn:expr)(al:exprlist):expr:=
 hidden_expr(LH st)fn al post sty.
Definition pre_state(st:L.lhs_stage)(fn:expr)(al:exprlist):Csem.state:=
 ExprState caller(pre_expr st fn al)(Kdo k)e m.
Definition frame(st:L.lhs_stage):cont:=
 Kcall caller e(fun hole=>Eassign(LH st)(Ecomma hole post sty)sty)tvoid(Kdo k).
Definition pre_or_call(s:Csem.state):Prop:=
 (exists st fn al,prepared fn al /\s=pre_state st fn al)\/
 (exists st,s=Callstate(Internal leaf)values(frame st)m).
Lemma pre_immediate:forall st fn al,prepared fn al ->
 imm_safe ge e RV(pre_expr st fn al)m.
Proof.
 intros st fn al[SF SA FV AV CL];unfold pre_expr,hidden_expr.
 eapply lift_immediate with(from:=RV)(a:=Ecall fn al tvoid)
 (C:=fun x=>Eassign(LH st)(Ecomma x post sty)sty).
 - constructor;constructor;constructor.
 - reflexivity.
 - eapply call_immediate;[exact FV|exact AV|exact CL|exact find_leaf|exact leaf_type].
Qed.
Lemma pre_not_stuck:forall st fn al,prepared fn al ->
 not_stuck ge e(pre_expr st fn al)m.
Proof.
 intros st fn al P from C a CT EQ.
 pose proof(hidden_context_decompose from C a(LH st)fn al post sty CT (eq_sym EQ))as HH.
 destruct P as[SF SA FV AV CL].
 inversion HH;subst.
 - apply pre_immediate;constructor;assumption.
 - eapply big_subexpression_safe;[eassumption|rewrite <-H0;apply L.lhs_simple|].
   rewrite <-H0;unfold big_defined;exists ret,Ptrofs.zero,Full;eapply L.lhs_big;[exact local_res|exact res_deref].
 - eapply lift_immediate with(from:=RV)(a:=Ecall fn al tvoid)(C:=fun x=>Ecomma x post sty).
   + constructor;constructor.
   + reflexivity.
   + eapply call_immediate;[exact FV|exact AV|exact CL|exact find_leaf|exact leaf_type].
 - eapply call_immediate;[exact FV|exact AV|exact CL|exact find_leaf|exact leaf_type].
 - eapply big_subexpression_safe;[eassumption|exact SF|].
   unfold big_defined;eexists;exact FV.
 - eapply arguments_subexpression_safe;eauto.
Qed.
Lemma prepared_function_replace:forall fn fn' al,
 prepared fn al ->typeof fn=typeof fn' ->simple fn'=true ->
 pure_rval ge e m fn=pure_rval ge e m fn' ->prepared fn' al.
Proof.
 intros fn fn' al[SF SA FV AV CL]TY SN EQ;constructor;auto.
 - eapply rval_transport;[exact SF|exact SN|exact EQ|exact FV].
 - rewrite <-TY;exact CL.
Qed.
Lemma prepared_arguments_replace:forall fn al al',
 prepared fn al ->simplelist al'=true ->eval_simple_list ge e m al' params values ->
 prepared fn al'.
Proof. intros fn al al'[SF SA FV AV CL]SN EV;constructor;assumption. Qed.
Lemma pre_lred_context:forall st fn al C a b mf,
 prepared fn al ->context LV RV C ->C a=pre_expr st fn al ->
 lred ge e a m b mf ->
 mf=m /\exists st' fn' al',prepared fn' al'/\C b=pre_expr st' fn' al'.
Proof.
 intros st fn al C a b mf P CT EQ RED.
 pose proof P as P0;destruct P as[SF SA FV AV CL].
 pose proof(hidden_context_decompose LV C a(LH st)fn al post sty CT EQ)as HH.
 inversion HH;subst.
 - destruct(L.lhs_lred_closed ge caller e m sid ires br ret local_res res_deref st D a b mf H H0 RED)
   as[MM[st' NEXT]];subst mf.
   split;[reflexivity|exists st',fn,al;split;[exact P0|]].
   unfold pre_expr,hidden_expr;rewrite NEXT;reflexivity.
 - destruct(pure_replace_lred ge e m RV D a b mf H SF RED)as[MM[TY[SN DEN]]];subst mf.
   split;[reflexivity|exists st,(D b),al;split;[|reflexivity]].
   eapply prepared_function_replace;[exact P0|exact TY|exact SN|exact DEN].
 - destruct(PureDenotation.pure_lred ge e a m b mf RED)as[MM[TY[SN DEN]]];subst mf.
   destruct(arguments_transport ge e m LV D H a b params values(eq_sym TY)SN DEN SA AV)as[AN ARGS].
   split;[reflexivity|exists st,fn,(D b);split;[|reflexivity]].
   eapply prepared_arguments_replace;[exact P0|exact AN|exact ARGS].
Qed.
Lemma pre_rred_context:forall st fn al C a b t mf,
 prepared fn al ->context RV RV C ->C a=pre_expr st fn al ->
 rred ge a m t b mf ->
 mf=m /\ t=E0/\exists st' fn' al',prepared fn' al'/\C b=pre_expr st' fn' al'.
Proof.
 intros st fn al C a b t mf P CT EQ RED.
 pose proof P as P0;destruct P as[SF SA FV AV CL].
 pose proof(hidden_context_decompose RV C a(LH st)fn al post sty CT EQ)as HH.
 inversion HH;subst.
 - inversion RED.
 - destruct(L.lhs_rred_closed ge caller e m sid ires br ret local_res res_deref st D a b t mf H H0 RED)
   as[MM[TT[st' NEXT]]];subst mf t.
   split;[reflexivity|];split;[reflexivity|exists st',fn,al;split;[exact P0|]].
   unfold pre_expr,hidden_expr;rewrite NEXT;reflexivity.
 - inversion RED.
 - inversion RED.
 - destruct(pure_replace_rred ge e m RV D a b t mf H SF RED)as[MM[TT[TY[SN DEN]]]];subst mf t.
   split;[reflexivity|];split;[reflexivity|exists st,(D b),al;split;[|reflexivity]].
   eapply prepared_function_replace;[exact P0|exact TY|exact SN|exact DEN].
 - pose proof(simplelist_hole _ _ H a SA)as SUB.
   destruct(PureDenotation.pure_rred ge e a m t b mf SUB RED)as[MM[TT[TY[SN DEN]]]];subst mf t.
   destruct(arguments_transport ge e m RV D H a b params values(eq_sym TY)SN DEN SA AV)as[AN ARGS].
   split;[reflexivity|];split;[reflexivity|exists st,fn,(D b);split;[|reflexivity]].
   eapply prepared_arguments_replace;[exact P0|exact AN|exact ARGS].
Qed.
Lemma pre_call_context:forall st fn al C a fd args ty,
 prepared fn al ->context RV RV C ->C a=pre_expr st fn al ->
 callred ge a m fd args ty ->
 exists st',Callstate fd args(Kcall caller e C ty(Kdo k))m=
 Callstate(Internal leaf)values(frame st')m.
Proof.
 intros st fn al C a fd args ty P CT EQ RED.
 destruct P as[SF SA FV AV CL].
 pose proof(hidden_context_decompose RV C a(LH st)fn al post sty CT EQ)as HH.
 inversion HH;subst.
 - inversion RED.
 - assert(SUB:simple a=true).
   { eapply simple_context_hole;[exact H|]. rewrite <-H0;apply L.lhs_simple. }
   inversion RED;subst;discriminate SUB.
 - inversion RED.
 - inversion RED as[vf0 tyf0 m0 tyargs0 tyres0 cc0 el0 ty0 fd0 vals0 F0 C0 S0 CL0];subst.
   inversion FV;subst.
   rewrite find_leaf in F0;injection F0 as FD;subst fd.
   rewrite leaf_type in S0;injection S0 as PARAM RET CC;subst tyargs0 tyres0 cc0.
   pose proof(cast_values_unique ge e m _ params args values C0 AV)as VALUES;subst args.
   exists st;reflexivity.
 - pose proof(simple_context_hole _ _ _ H a SF)as SUB;inversion RED;subst;discriminate SUB.
 - pose proof(simplelist_hole _ _ H a SA)as SUB;inversion RED;subst;discriminate SUB.
Qed.

Theorem pre_all_successors:forall st fn al t next,
 prepared fn al ->Csem.step ge(pre_state st fn al)t next ->
 t=E0/\pre_or_call next.
Proof.
 intros st fn al t next P STEP;destruct STEP as[ES|SS].
 - inversion ES;subst.
   + match goal with CT:Csem.context LV RV ?C,EQ:?C ?a=pre_expr st fn al,
       RED:lred ge e ?a m ?b ?mf|-_ =>
       destruct(pre_lred_context st fn al C a b mf P CT EQ RED)
       as[MM[st'[fn'[al'[PN EX]]]]];subst mf end.
     split;[reflexivity|left;exists st',fn',al';split;[exact PN|]].
     unfold pre_state;rewrite EX;reflexivity.
   + match goal with CT:Csem.context RV RV ?C,EQ:?C ?a=pre_expr st fn al,
       RED:rred ge ?a m t ?b ?mf|-_ =>
       destruct(pre_rred_context st fn al C a b t mf P CT EQ RED)
       as[MM[TT[st'[fn'[al'[PN EX]]]]]];subst mf t end.
     split;[reflexivity|left;exists st',fn',al';split;[exact PN|]].
     unfold pre_state;rewrite EX;reflexivity.
   + match goal with CT:Csem.context RV RV ?C,EQ:?C ?a=pre_expr st fn al,
       RED:callred ge ?a m ?fd ?args ?ty|-_ =>
       destruct(pre_call_context st fn al C a fd args ty P CT EQ RED)as[st' EX]end.
     split;[reflexivity|right;exists st';exact EX].
   + exfalso;apply H7;exact(pre_not_stuck st fn al P K C a H6(eq_sym H0)).
 - inversion SS.
Qed.
Theorem pre_progress:forall st fn al,prepared fn al ->
 exists t next,Csem.step ge(pre_state st fn al)t next/\pre_or_call next.
Proof.
 intros st fn al P.
 destruct(immediate_has_step ge caller(pre_expr st fn al)(Kdo k)e m eq_refl
 (pre_immediate st fn al P))as[t[next STEP]].
 exists t,next;split;[exact STEP|exact(proj2(pre_all_successors st fn al t next P STEP))].
Qed.

End PRE.
Print Assumptions pre_not_stuck.
