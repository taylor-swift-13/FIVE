From Stdlib Require Import Bool List ZArith Classical.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation FactorShell StandaloneCallShell PhaseComposition.
Import ListNotations.
Section CALL.
Variable ge:genv.
Variable e:env.
Variable caller:function.
Variable callee:Csyntax.fundef.
Variable k:cont.
Variable ifunction:ident.
Variable bfunction:block.
Variable m:mem.
Definition call_type:=Tfunction[]tvoid cc_default.
Hypothesis function_global:e!ifunction=None.
Hypothesis function_symbol:Genv.find_symbol ge ifunction=Some bfunction.
Hypothesis callee_find:Genv.find_funct ge(Vptr bfunction Ptrofs.zero)=Some callee.
Hypothesis callee_signature:type_of_fundef callee=call_type.
Definition call_expr(rs:read_stage):expr:=
 Ecall(read_res ifunction call_type bfunction(Vptr bfunction Ptrofs.zero)rs)Enil tvoid.
Definition pre_state(rs:read_stage):Csem.state:=ExprState caller(call_expr rs)(Kdo k)e m.
Definition call_frame:cont:=Kcall caller e(fun x=>x)tvoid(Kdo k).
Definition pre_or_call(s:Csem.state):Prop:=
 (exists rs,s=pre_state rs) \/s=Callstate callee[]call_frame m.
Lemma pre_animator_step:forall rs rule t next,
 In(TR rule t next)(Cexec.do_step ge null_external null_external quiet_world(pre_state rs))->
 t=E0 /\pre_or_call next.
Proof.
 intros rs rule t next;destruct rs;
 cbn[pre_state call_expr read_res Cexec.do_step Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc Cexec.is_val_list Cexec.incontext Cexec.topred Cexec.stuck];
 rewrite ?function_global,?function_symbol;rewrite ?dec_eq_true;
 cbn[Cexec.do_deref_loc access_mode type_is_volatile].
 all:cbn[call_type classify_fun sem_cast_arguments sem_cast];rewrite ?callee_find,?callee_signature;
 cbv[call_type tvoid access_mode type_is_volatile sem_cast classify_cast];rewrite ?dec_eq_true;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].
 all:intros IN;cbn in IN;repeat destruct IN as[EQ|IN];try contradiction;inversion EQ;subst;
 split;[reflexivity|unfold pre_or_call;first[left;first[solve[exists Rloc;reflexivity]|solve[exists Rval;reflexivity]]|right;reflexivity]].
Qed.
Lemma pre_callback_free:forall rs,callback_free_state(pre_state rs).
Proof. intros;destruct rs;reflexivity. Qed.
Lemma pre_core:forall rs,SourceClosure.core_expr ge(fun _=>True)(fun _ _=>True)(call_expr rs).
Proof.
 intros;destruct rs;cbn[call_expr read_res call_type SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];repeat split;try reflexivity;
 unfold SourceClosure.valid_call;intros;split;exact I.
Qed.
Lemma pre_silent:forall rs,silent_state ge(pre_state rs).
Proof.
 intros rs t next STEP;pose proof(pre_core rs)as CORE.
 destruct STEP as[ES|SS];[|inversion SS].
 inversion ES;subst;auto.
 match goal with EQ:?C ?A=call_expr _|-_=>rewrite<-EQ in CORE end.
 match goal with HC:Csem.context RV RV ?C,RR:rred ge ?a m t ?a2 ?m2|-_=>
 pose proof(SourceClosure.core_context_hole ge(fun _=>True)(fun _ _=>True)_ _ _ HC a CORE)as CA;
 exact(proj1(SourceClosure.core_rred ge(fun _=>True)(fun _ _=>True)a m t a2 m2 CA RR))end.
Qed.
Lemma pre_all_successors:forall rs t next,Csem.step ge(pre_state rs)t next->t=E0 /\pre_or_call next.
Proof.
 intros rs t next STEP;pose proof(pre_silent rs t next STEP)as TT;subst t.
 destruct(pure_do_step_complete ge null_external null_external quiet_world(pre_state rs)E0 next quiet_world(pre_callback_free rs)(possible_trace_nil quiet_world)STEP)as[rule IN].
 eapply pre_animator_step;exact IN.
Qed.
Lemma pre_animator_nonempty:forall rs,exists rule t next,In(TR rule t next)(Cexec.do_step ge null_external null_external quiet_world(pre_state rs)).
Proof.
 intros rs;destruct rs;
 cbn[pre_state call_expr read_res Cexec.do_step Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc Cexec.is_val_list Cexec.incontext Cexec.topred Cexec.stuck];
 rewrite ?function_global,?function_symbol;rewrite ?dec_eq_true;
 cbn[Cexec.do_deref_loc access_mode type_is_volatile].
 all:cbn[call_type classify_fun sem_cast_arguments sem_cast];rewrite ?callee_find,?callee_signature;
 cbv[call_type tvoid access_mode type_is_volatile sem_cast classify_cast];rewrite ?dec_eq_true;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].
 all:repeat eexists;apply in_eq.
Qed.
Lemma pre_progress:forall rs,exists t next,Csem.step ge(pre_state rs)t next /\pre_or_call next.
Proof.
 intros rs;destruct(pre_animator_nonempty rs)as[rule[t[next IN]]].
 pose proof(proj2(pre_animator_step rs rule t next IN))as CLASS.
 exists t,next;split;[|exact CLASS].
 eapply supported_nonstuck_transition;[apply pre_callback_free|exact IN|].
 intro EQ;destruct CLASS as[[rs2 EQ2]|EQ2];rewrite EQ in EQ2;discriminate.
Qed.
Variable result:val.
Variable final_mem:mem.
Variable callee_invariant:Csem.state->Prop.
Hypothesis callee_certificate:certificate ge callee_invariant(Returnstate result call_frame final_mem).
Hypothesis callee_entry:callee_invariant(Callstate callee[]call_frame m).
Definition post_state:=ExprState caller(Eval result tvoid)(Kdo k)e final_mem.
Definition target:=State caller Sskip k e final_mem.
Definition invariant(s:Csem.state):Prop:=
 s=State caller(Sdo(call_expr Rvar))k e m \/
 (exists rs,s=pre_state rs) \/callee_invariant s \/s=post_state \/s=target.
Lemma post_unique:unique_transition ge post_state target.
Proof.
 split;[right;apply step_do_2|].
 intros t next[ES|SS];[exfalso;eapply StandaloneCallShell.value_estep_none;exact ES|inversion SS;subst;auto].
Qed.
Theorem call_certificate:certificate ge invariant target.
Proof.
 split.
 - intros s[START|[PRE|[CALLEE|[POST|DONE]]]].
   + subst s;right;exists E0,(pre_state Rvar);split;[right;apply step_do_1|right;left;exists Rvar;reflexivity].
   + destruct PRE as[rs EQ];subst s;destruct(pre_progress rs)as[t[next[STEP CLASS]]].
     right;exists t,next;split;[exact STEP|].
     destruct CLASS as[PRE|CALL];[right;left;exact PRE|subst next;right;right;left;exact callee_entry].
   + destruct(proj1 callee_certificate s CALLEE)as[RET|[t[next[STEP CN]]]].
     * subst s;right;exists E0,post_state;split;[right;apply step_returnstate|right;right;right;left;reflexivity].
     * right;exists t,next;split;[exact STEP|right;right;left;exact CN].
   + subst s;right;exists E0,target;split;[exact(proj1 post_unique)|right;right;right;right;reflexivity].
   + auto.
 - intros s t next[START|[PRE|[CALLEE|[POST|DONE]]]]NF STEP.
   + subst s;destruct(FactorShell.do_step_unique _ _ _ _ _ _ _ _ STEP)as[TT EQ];subst next;right;left;exists Rvar;reflexivity.
   + destruct PRE as[rs EQ];subst s;destruct(pre_all_successors rs t next STEP)as[TT[PRE|CALL]].
     * right;left;exact PRE.
     * subst next;right;right;left;exact callee_entry.
   + destruct(classic(s=Returnstate result call_frame final_mem))as[RET|NR].
     * subst s;destruct(FactorShell.return_call_step_unique _ _ _ _ _ _ _ _ _ _ STEP)as[TT EQ];subst next;right;right;right;left;reflexivity.
     * right;right;left;eapply(proj2 callee_certificate);eauto.
   + subst s;destruct(proj2 post_unique t next STEP)as[TT EQ];subst next;right;right;right;right;reflexivity.
   + contradiction.
Qed.
Lemma initial_certificate:invariant(State caller(Sdo(call_expr Rvar))k e m).
Proof. left;reflexivity. Qed.
End CALL.
Print Assumptions call_certificate.
