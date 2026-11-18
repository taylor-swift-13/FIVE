From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport.
From FiveGuidanceAllOrder Require Import PureDenotation PureProgress FactorShell.
Import ListNotations.
Inductive lhs_stage:=H0|H1|H2|H3.
Section LHS.
Variable ge:genv.
Variable f:function.
Variable e:env.
Variable m:mem.
Variable sid ires:AST.ident.
Variable br ret:block.
Definition sty:=Tstruct sid noattr.
Definition lhs(st:lhs_stage):expr:=match st with
 | H0=>Ederef(Evalof(Evar ires(tptr sty))(tptr sty))sty
 | H1=>Ederef(Evalof(Eloc br Ptrofs.zero Full(tptr sty))(tptr sty))sty
 | H2=>Ederef(Eval(Vptr ret Ptrofs.zero)(tptr sty))sty
 | H3=>Eloc ret Ptrofs.zero Full sty end.
Definition addr(st:lhs_stage):expr:=Eaddrof(lhs st)(tptr sty).
Definition addr_state(st:lhs_stage):Csem.state:=ExprState f(addr st)Kstop e m.
Definition addr_done:Csem.state:=ExprState f(Eval(Vptr ret Ptrofs.zero)(tptr sty))Kstop e m.
Hypothesis local_res:e!ires=Some(br,tptr sty).
Hypothesis res_deref:Cexec.do_deref_loc ge quiet_world(tptr sty)m br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero).
Lemma lhs_simple:forall st,simple(lhs st)=true.
Proof. destruct st;reflexivity. Qed.
Lemma lhs_type:forall st,typeof(lhs st)=sty.
Proof. destruct st;reflexivity. Qed.
Lemma lhs_big:forall st,eval_simple_lvalue ge e m(lhs st)ret Ptrofs.zero Full.
Proof.
 assert(D:deref_loc ge(tptr sty)m br Ptrofs.zero Full E0(Vptr ret Ptrofs.zero)).
 { exact(proj1(Cexec.do_deref_loc_sound ge quiet_world(tptr sty)m br Ptrofs.zero Full quiet_world E0(Vptr ret Ptrofs.zero)res_deref)). }
 destruct st;cbn[lhs].
 - eapply esl_deref;eapply esr_rvalof;[apply esl_var_local;exact local_res|reflexivity|reflexivity|exact D].
 - eapply esl_deref;eapply esr_rvalof;[constructor|reflexivity|reflexivity|exact D].
 - apply esl_deref;constructor.
 - constructor.
Qed.
Lemma type_eq_diag:forall(A:Type)ty(x y:A),(if Ctypes.type_eq ty ty then x else y)=x.
Proof. intros;destruct(Ctypes.type_eq ty ty);auto;contradiction n;reflexivity. Qed.
Definition addr_class(s:Csem.state):Prop:=(exists st,s=addr_state st)\/s=addr_done.
Lemma addr_animator:forall st rule t next,
 In(TR rule t next)(Cexec.do_step ge FactorShell.null_external FactorShell.null_external quiet_world(addr_state st)) ->
 t=E0 /\addr_class next.
Proof.
 intros st rule t next;destruct st;
 cbn[addr_state addr lhs Cexec.do_step Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc
 Cexec.incontext Cexec.topred Cexec.stuck];
 rewrite ?local_res,?res_deref;
 repeat rewrite type_eq_diag;
 cbn[Cexec.do_deref_loc sty access_mode type_is_volatile];
 cbn[Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd];
 intros IN;simpl in IN;repeat rewrite type_eq_diag in IN;
 cbn[Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd]in IN;
 simpl in IN;repeat destruct IN as[EQ|IN];try contradiction;inversion EQ;subst.
 all: split;[reflexivity|unfold addr_class;first[
 left;first[solve[exists H0;reflexivity]|solve[exists H1;reflexivity]|solve[exists H2;reflexivity]|solve[exists H3;reflexivity]]
 |right;reflexivity]].
Qed.
Lemma addr_silent:forall st,silent_state ge(addr_state st).
Proof.
 intros st t next[ES|SS];[|inversion SS].
 assert(SI:simple(addr st)=true)by(destruct st;reflexivity).
 inversion ES;subst;auto.
 all: try match goal with SI:simple ?ORIG=true,EQ:?C ?A = ?ORIG |- _=>rewrite <-EQ in SI end.
 pose proof(PureDenotation.simple_context_hole RV RV C H11 a SI)as SA.
 destruct(PureDenotation.pure_rred ge e a m t a' m' SA H10)as[MM[TT REST]];exact TT.

Qed.
Lemma addr_all_successors:forall st t next,Csem.step ge(addr_state st)t next ->
 t=E0 /\addr_class next.
Proof.
 intros st t next STEP;pose proof(addr_silent st t next STEP)as TT;subst t.
 destruct(pure_do_step_complete ge FactorShell.null_external FactorShell.null_external quiet_world
 (addr_state st)E0 next quiet_world ltac:(destruct st;reflexivity)(possible_trace_nil _)STEP)as[rule IN].
 eapply addr_animator;exact IN.
Qed.
Lemma lhs_lred_closed:forall st C a b mf,
 context LV LV C ->lhs st=C a ->lred ge e a m b mf ->
 mf=m /\exists st',C b=lhs st'.
Proof.
 intros st C a b mf CT EQ RED.
 assert(STEP:Csem.step ge(addr_state st)E0(ExprState f(Eaddrof(C b)(tptr sty))Kstop e mf)).
 { unfold addr_state,addr;rewrite EQ;left;eapply step_lred with(C:=fun x=>Eaddrof(C x)(tptr sty));[exact RED|constructor;exact CT]. }
 destruct(addr_all_successors st E0 _ STEP)as[TT[[st' SAME]|DONE]].
 - unfold addr_state,addr in SAME;inversion SAME;subst;split;[reflexivity|exists st';congruence].
 - discriminate DONE.
Qed.
Lemma lhs_rred_closed:forall st C a b t mf,
 context RV LV C ->lhs st=C a ->rred ge a m t b mf ->
 mf=m /\t=E0/\exists st',C b=lhs st'.
Proof.
 intros st C a b t mf CT EQ RED.
 assert(STEP:Csem.step ge(addr_state st)t(ExprState f(Eaddrof(C b)(tptr sty))Kstop e mf)).
 { unfold addr_state,addr;rewrite EQ;left;eapply step_rred with(C:=fun x=>Eaddrof(C x)(tptr sty));[exact RED|constructor;exact CT]. }
 destruct(addr_all_successors st t _ STEP)as[TT[[st' SAME]|DONE]].
 - unfold addr_state,addr in SAME;inversion SAME;subst;repeat split;auto;exists st';congruence.
 - discriminate DONE.
Qed.
End LHS.
Print Assumptions lhs_lred_closed.
Print Assumptions lhs_rred_closed.
