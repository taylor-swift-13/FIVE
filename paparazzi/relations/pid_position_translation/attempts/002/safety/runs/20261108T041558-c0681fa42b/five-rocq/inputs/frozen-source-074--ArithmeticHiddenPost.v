From Stdlib Require Import List Bool ZArith Classical.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation PureProgress AtomicDenotation BlockExecution PhaseComposition CallfreeExecution.
From PidPositionSafety Require Import PureSound PureCallArguments HiddenResultLhs AtomicPhase.
From CoreCBMC Require Import ArithmeticTree ArithmeticAtomic ArithmeticObservation.
Import ListNotations.
Module L:=HiddenResultLhs.
Definition comma_expr(l post:expr)(ty:type):expr:=Eassign l(Ecomma(Eval Vundef tvoid)post ty)ty.
Inductive comma_hole(l post:expr)(ty:type):kind->(expr->expr)->expr->Prop:=
| ch_whole:comma_hole l post ty RV(fun x=>x)(comma_expr l post ty)
| ch_lhs:forall from D a,context from LV D ->l=D a ->
 comma_hole l post ty from(fun x=>Eassign(D x)(Ecomma(Eval Vundef tvoid)post ty)ty)a
| ch_comma:comma_hole l post ty RV(fun x=>Eassign l x ty)(Ecomma(Eval Vundef tvoid)post ty)
| ch_literal:comma_hole l post ty RV(fun x=>Eassign l(Ecomma x post ty)ty)(Eval Vundef tvoid).
Lemma comma_context_decompose:forall from C a l post ty,
 context from RV C ->C a=comma_expr l post ty ->comma_hole l post ty from C a.
Proof.
 intros from C a l post ty CT EQ;unfold comma_expr in EQ.
 inversion CT;subst;cbn in EQ;try discriminate.
 - subst a;constructor.
 - inversion EQ;subst;eapply ch_lhs;[eassumption|reflexivity].
 - inversion EQ;subst.
   match goal with CT0:Csem.context _ RV ?D,EQ0:?D a=Ecomma _ _ _|-_=>
   inversion CT0;subst;cbn in EQ0;try discriminate end.
   + subst a;constructor.
   + match goal with E:Ecomma _ _ _=Ecomma _ _ _|-_=>inversion E;subst end.
     match goal with CT1:Csem.context _ RV ?D,EQ1:?D a=Eval _ _|-_=>
     inversion CT1;subst;cbn in EQ1;try discriminate end.
     subst a;constructor.
Qed.
Section POST.
Variable ge:genv.
Variable caller:function.
Variable e:env.
Variable k:cont.
Variable m mf:mem.
Variable sid ires:AST.ident.
Variable br ret:block.
Variable post:expr.
Variable v vc copied:val.
Local Notation sty:=(L.sty sid).
Local Notation LH:=(L.lhs sid ires br ret).
Hypothesis local_res:e!ires=Some(br,tptr sty).
Hypothesis res_deref:Cexec.do_deref_loc ge quiet_world(tptr sty)m br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero).
Hypothesis post_type:typeof post=sty.
Hypothesis post_simple:simple post=true.
Hypothesis post_tree:arithmetic_tree ge e m post.
Hypothesis post_value:pure_rval ge e m post=Some v.
Hypothesis cast_value:sem_cast v sty sty m=Some vc.
Hypothesis store_copy:Cexec.do_assign_loc ge quiet_world sty m ret Ptrofs.zero Full vc=
 Some(quiet_world,E0,mf,copied).
Definition normalized(st:L.lhs_stage):expr:=Eassign(LH st)post sty.
Definition post_state(st:L.lhs_stage):Csem.state:=ExprState caller(comma_expr(LH st)post sty)(Kdo k)e m.
Definition target:=State caller Sskip k e mf.
Lemma normalized_atomic:forall st,atomic_expr(normalized st)=true.
Proof. intros;unfold normalized;cbn[atomic_expr];rewrite L.lhs_simple,post_simple,L.lhs_type;reflexivity. Qed.
Lemma normalized_value:forall st,atomic_eval ge e m(normalized st)=Some(copied,mf).
Proof.
 intros st;unfold normalized;cbn[atomic_eval];rewrite L.lhs_type,L.type_eq_diag,post_value.
 assert(LV:pure_lval ge e m(LH st)=Some(ret,Ptrofs.zero,Full)).
 { apply(proj2(simple_big_denotation ge e m));[eapply L.lhs_big;[exact local_res|exact res_deref]|apply L.lhs_simple]. }
 rewrite LV;unfold commit;rewrite post_type,cast_value,store_copy;reflexivity.
Qed.
Lemma normalized_tree:forall st,arithmetic_tree ge e m(normalized st).
Proof.
 intros;unfold normalized;destruct st;cbn[arithmetic_tree L.lhs];tauto.
Qed.
Lemma normalized_certificate:forall st,
 certificate ge(arithmetic_atomic_invariant ge caller e k mf copied)target /\
 arithmetic_atomic_invariant ge caller e k mf copied(ExprState caller(normalized st)(Kdo k)e m).
Proof.
 intros;split;[apply arithmetic_atomic_certificate|].
 eapply arithmetic_atomic_initial;[apply normalized_atomic|apply normalized_value|apply normalized_tree].
Qed.
Definition post_or_normal(s:Csem.state):Prop:=
 (exists st,s=post_state st)\/
 (exists st,s=ExprState caller(normalized st)(Kdo k)e m).
Lemma comma_safe:imm_safe ge e RV(Ecomma(Eval Vundef tvoid)post sty)m.
Proof. intros;eapply imm_safe_rred with(C:=fun x=>x).
 - apply red_comma;exact post_type.
 - constructor.
Qed.
Lemma post_not_stuck:forall st,not_stuck ge e(comma_expr(LH st)post sty)m.
Proof.
 intros st from C a CT EQ.
 pose proof(comma_context_decompose from C a(LH st)post sty CT(eq_sym EQ))as HH.
 inversion HH;subst.
 - unfold comma_expr;eapply lift_immediate with(from:=RV)(a:=Ecomma(Eval Vundef tvoid)post sty)
   (C:=fun x=>Eassign(LH st)x sty);[constructor;constructor|reflexivity|apply comma_safe].
 - eapply big_subexpression_safe;[exact H|rewrite <-H0;apply L.lhs_simple|].
   rewrite <-H0;unfold big_defined;exists ret,Ptrofs.zero,Full;eapply L.lhs_big;[exact local_res|exact res_deref].
 - apply comma_safe.
 - apply imm_safe_val.
Qed.
Lemma post_all_successors:forall st t next,Csem.step ge(post_state st)t next ->
 t=E0/\post_or_normal next.
Proof.
 intros st t next STEP;destruct STEP as[ES|SS];[|inversion SS].
 inversion ES;subst.
 - match goal with CT:Csem.context LV RV ?C,EQ:?C ?a=comma_expr _ _ _,RED:lred ge e ?a m ?b ?mm|-_=>
   pose proof(comma_context_decompose LV C a(LH st)post sty CT EQ)as HH;inversion HH;subst end.
   match goal with CT:Csem.context LV LV D,EQ:LH st=D a,RED:lred ge e a m a' m'|-_=>
   destruct(L.lhs_lred_closed ge caller e m sid ires br ret local_res res_deref st D a a' m' CT EQ RED)
   as[MM[st' EX]];subst m' end.
   split;[reflexivity|left;exists st';unfold post_state,comma_expr;rewrite EX;reflexivity].
 - match goal with CT:Csem.context RV RV ?C,EQ:?C ?a=comma_expr _ _ _|-_=>
   pose proof(comma_context_decompose RV C a(LH st)post sty CT EQ)as HH;inversion HH;subst end.
   + match goal with RED:rred ge _ _ _ _ _|-_=>inversion RED end.
   + match goal with CT:Csem.context RV LV D,EQ:LH st=D a,RED:rred ge a m t a' m'|-_=>
     destruct(L.lhs_rred_closed ge caller e m sid ires br ret local_res res_deref st D a a' t m' CT EQ RED)
     as[MM[TT[st' EX]]];subst m' t end.
     split;[reflexivity|left;exists st';unfold post_state,comma_expr;rewrite EX;reflexivity].
   + match goal with RED:rred ge _ _ _ _ _|-_=>inversion RED;subst end;split;[reflexivity|right;exists st;reflexivity].
   + match goal with RED:rred ge _ _ _ _ _|-_=>inversion RED end.
 - match goal with CT:Csem.context RV RV ?C,EQ:?C ?a=comma_expr _ _ _|-_=>
   pose proof(comma_context_decompose RV C a(LH st)post sty CT EQ)as HH;inversion HH;subst end.
   + match goal with RED:callred ge _ _ _ _ _|-_=>inversion RED end.
   + assert(SUB:simple a=true)by(eapply simple_context_hole;[exact H|match goal with EQ:LH st=D a|-_=>rewrite <-EQ;apply L.lhs_simple end]).
     match goal with RED:callred ge _ _ _ _ _|-_=>inversion RED;subst end;discriminate SUB.
   + match goal with RED:callred ge _ _ _ _ _|-_=>inversion RED end.
   + match goal with RED:callred ge _ _ _ _ _|-_=>inversion RED end.
 - exfalso;apply H7;exact(post_not_stuck st K C a H6(eq_sym H0)).
Qed.
Lemma post_progress:forall st,exists t next,Csem.step ge(post_state st)t next/\post_or_normal next.
Proof.
 intros st.
 assert(STEP:Csem.step ge(post_state st)E0(ExprState caller(normalized st)(Kdo k)e m)).
 { left;unfold post_state,comma_expr,normalized;eapply step_rred with(C:=fun x=>Eassign(LH st)x sty).
   - apply red_comma;exact post_type.
   - constructor;constructor. }
 exists E0,(ExprState caller(normalized st)(Kdo k)e m);split;[exact STEP|right;exists st;reflexivity].
Qed.
Definition invariant(s:Csem.state):Prop:=(exists st,s=post_state st)\/arithmetic_atomic_invariant ge caller e k mf copied s.
Theorem post_certificate:certificate ge invariant target.
Proof.
 pose proof(proj1(normalized_certificate L.H0))as AC.
 split.
 - intros s[PRE|POST].
   + destruct PRE as[st EQ];subst.
     destruct(post_progress st)as[t[next[STEP CL]]];right;exists t,next;split;[exact STEP|].
     destruct CL as[P|[st' EQ]];[left;exact P|right;subst;exact(proj2(normalized_certificate st'))].
   + destruct(proj1 AC s POST)as[EQ|[t[next[STEP IN]]]];[left;exact EQ|right;exists t,next;split;[exact STEP|right;exact IN]].
 - intros s t next[PRE|POST]NF STEP.
   + destruct PRE as[st EQ];subst.
     destruct(proj2(post_all_successors st t next STEP))as[P|[st' EQ]];
     [left;exact P|right;subst;exact(proj2(normalized_certificate st'))].
   + right;eapply(proj2 AC);eauto.
Qed.
Theorem post_initial:forall st,invariant(post_state st).
Proof. intros;left;exists st;reflexivity. Qed.
Lemma comma_tree:forall st,arithmetic_tree ge e m(comma_expr(LH st)post sty).
Proof.
 intros;unfold comma_expr;destruct st;cbn[arithmetic_tree L.lhs];tauto.
Qed.
Theorem post_observation:forall f' a k' e' ma,
 invariant(ExprState f' a k' e' ma) ->arithmetic_tree ge e' ma a.
Proof.
 intros f' a k' e' ma[[st EQ]|POST].
 - unfold post_state in EQ;injection EQ as FF AA KK EE MM;subst;apply comma_tree.
 - eapply arithmetic_atomic_observation;exact POST.
Qed.
End POST.
Print Assumptions post_certificate.
