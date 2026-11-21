From Stdlib Require Import List Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation.
From PidPositionSafety Require Import HiddenResultLhs HiddenResultContext HiddenResultPre.
From PidPositionTranslationAttempt002 Require Import NoSubSyntax.
Module A:=HiddenResultPre.
Module L:=HiddenResultLhs.
Lemma lhs_no_sub:forall sid ires br ret st,no_sub(L.lhs sid ires br ret st)=true.
Proof. intros;destruct st;reflexivity. Qed.
Lemma hidden_no_sub:forall sid ires br ret st fn args post,
 no_sub post=true ->no_sub fn=true ->no_sub_list args=true ->
 no_sub(hidden_expr(L.lhs sid ires br ret st)fn args post(L.sty sid))=true.
Proof.
 intros;unfold hidden_expr;cbn[no_sub];rewrite lhs_no_sub,H,H0,H1;reflexivity.
Qed.
Lemma hidden_no_sub_operands:forall sid ires br ret st fn args post,
 no_sub(hidden_expr(L.lhs sid ires br ret st)fn args post(L.sty sid))=true ->
 no_sub fn=true /\no_sub_list args=true.
Proof.
 intros;unfold hidden_expr in H;cbn[no_sub]in H.
 repeat rewrite Bool.andb_true_iff in H;tauto.
Qed.
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
Hypothesis local_res:e!ires=Some(br,tptr(L.sty sid)).
Hypothesis res_before:Cexec.do_deref_loc ge quiet_world(tptr(L.sty sid))m br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero).
Hypothesis find_leaf:Genv.find_funct ge vf=Some(Internal leaf).
Hypothesis leaf_type:type_of_fundef(Internal leaf)=Tfunction params tvoid cc.
Hypothesis post_no_sub:no_sub post=true.
Definition prepared(fn:expr)(args:exprlist):Prop:=
 A.prepared ge e m params cc vf values fn args /\no_sub fn=true /\no_sub_list args=true.
Definition pre_or_call(s:Csem.state):Prop:=
 (exists st fn args,prepared fn args /\s=A.pre_state caller e k m sid ires br ret post st fn args) \/
 (exists st,s=Callstate(Internal leaf)values(A.frame caller e k sid ires br ret post st)m).
Lemma prepared_pre_no_sub:forall st fn args,prepared fn args ->
 no_sub(A.pre_expr sid ires br ret post st fn args)=true.
Proof. intros st fn args[P[NF NA]];unfold A.pre_expr;apply hidden_no_sub;assumption. Qed.
Theorem pre_all_successors:forall st fn args t next,
 prepared fn args ->
 Csem.step ge(A.pre_state caller e k m sid ires br ret post st fn args)t next ->
 pre_or_call next.
Proof.
 intros st fn args t next PN STEP.
 pose proof(prepared_pre_no_sub st fn args PN)as NS.
 assert(NEXT:expr_no_sub next).
 { destruct STEP as[ES|SS].
   - eapply no_sub_estep;[exact NS|exact ES].
   - unfold A.pre_state,A.pre_expr,hidden_expr in SS;inversion SS. }
 pose proof(proj2(A.pre_all_successors ge caller leaf e k m sid ires br ret params cc vf values post
 local_res res_before find_leaf leaf_type st fn args t next(proj1 PN)STEP))as CL.
 destruct CL as[[st'[fn'[args'[PRE EQ]]]]|[st' EQ]].
 - subst next;cbn[expr_no_sub A.pre_state]in NEXT.
   destruct(hidden_no_sub_operands sid ires br ret st' fn' args' post NEXT)as[NF NA].
   left;exists st',fn',args';split;[exact(conj PRE(conj NF NA))|reflexivity].
 - right;exists st';exact EQ.
Qed.
Theorem pre_progress:forall st fn args,prepared fn args ->
 exists t next,Csem.step ge(A.pre_state caller e k m sid ires br ret post st fn args)t next /\pre_or_call next.
Proof.
 intros st fn args PN.
 destruct(A.pre_progress ge caller leaf e k m sid ires br ret params cc vf values post
 local_res res_before find_leaf leaf_type st fn args(proj1 PN))as[t[next[STEP CL]]].
 exists t,next;split;[exact STEP|eapply pre_all_successors;[exact PN|exact STEP]].
Qed.
End PRE.
Print Assumptions pre_all_successors.
