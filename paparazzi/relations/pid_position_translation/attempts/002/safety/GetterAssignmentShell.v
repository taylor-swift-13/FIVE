From Stdlib Require Import Bool List ZArith String Classical.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress AtomicDenotation AtomicProgress CallfreeExecution ContinuationLift BlockExecution PhaseComposition FactorShell.
Import ListNotations AST.
Inductive lhs_stage:=L0|L1|L2|L3.
Inductive ref_stage:=R0|R1|R2|R3|R4|R5|R6|R7|R8|R9|R10.
Inductive fn_stage:=F0|F1|F2.
Definition null_external:=FactorShell.null_external.
Section GETTER_ASSIGNMENT.
Variable ge:genv.
Variable caller leaf:function.
Variable e:env.
Variable k:cont.
Variable m:mem.
Variable ghid refid vectid nedid axis iref icomponent ierr igh igetter:AST.ident.
Variable berr bparam bgh bgetter:block.
Variable dref dcomponent daxis:Z.
Variable reference:int.
Definition ghty:=Tstruct ghid noattr.
Definition refty:=Tstruct refid noattr.
Definition vty:=Tstruct vectid noattr.
Definition nedty:=Tstruct nedid noattr.
Definition rettype:=tptr nedty.
Definition function_type:=Tfunction []rettype cc_default.
Definition axis_offset:=Ptrofs.add Ptrofs.zero(Ptrofs.repr daxis).
Definition ref_offset:=Ptrofs.add Ptrofs.zero(Ptrofs.repr dref).
Definition component_offset:=Ptrofs.add ref_offset(Ptrofs.repr dcomponent).
Definition scalar_offset:=Ptrofs.add component_offset(Ptrofs.repr daxis).
Definition axis_load(a:expr):expr:=Evalof(Efield a axis tint)tint.
Definition component_load(a:expr):expr:=Evalof(Efield a icomponent vty)vty.
Definition reference_load(a:expr):expr:=Evalof(Efield a iref refty)refty.
Definition lhs_res(st:lhs_stage):expr:=match st with
| L0=>Efield(Evalof(Evar ierr vty)vty)axis tint
| L1=>Efield(Evalof(Eloc berr Ptrofs.zero Full vty)vty)axis tint
| L2=>Efield(Eval(Vptr berr Ptrofs.zero)vty)axis tint
| L3=>Eloc berr axis_offset Full tint end.
Definition ref_res(st:ref_stage):expr:=match st with
| R0=>axis_load(component_load(reference_load(Evalof(Ederef(Evalof(Evar igh(tptr ghty))(tptr ghty))ghty)ghty)))
| R1=>axis_load(component_load(reference_load(Evalof(Ederef(Evalof(Eloc bparam Ptrofs.zero Full(tptr ghty))(tptr ghty))ghty)ghty)))
| R2=>axis_load(component_load(reference_load(Evalof(Ederef(Eval(Vptr bgh Ptrofs.zero)(tptr ghty))ghty)ghty)))
| R3=>axis_load(component_load(reference_load(Evalof(Eloc bgh Ptrofs.zero Full ghty)ghty)))
| R4=>axis_load(component_load(reference_load(Eval(Vptr bgh Ptrofs.zero)ghty)))
| R5=>axis_load(component_load(Evalof(Eloc bgh ref_offset Full refty)refty))
| R6=>axis_load(component_load(Eval(Vptr bgh ref_offset)refty))
| R7=>axis_load(Evalof(Eloc bgh component_offset Full vty)vty)
| R8=>axis_load(Eval(Vptr bgh component_offset)vty)
| R9=>Evalof(Eloc bgh scalar_offset Full tint)tint
| R10=>Eval(Vint reference)tint end.
Definition fn_res(st:fn_stage):expr:=match st with
| F0=>Evalof(Evar igetter function_type)function_type
| F1=>Evalof(Eloc bgetter Ptrofs.zero Full function_type)function_type
| F2=>Eval(Vptr bgetter Ptrofs.zero)function_type end.
Definition getter_read(hole:expr):expr:=axis_load(Evalof(Ederef hole nedty)nedty).
Definition assignment_context(l r:expr):expr->expr:=
 fun hole=>Eassign l(Ebinop Osub r(getter_read hole)tint)tint.
Definition pre_expr(ls:lhs_stage)(rs:ref_stage)(fs:fn_stage):expr:=
 assignment_context(lhs_res ls)(ref_res rs)(Ecall(fn_res fs)Enil rettype).
Definition pre_state(ls:lhs_stage)(rs:ref_stage)(fs:fn_stage):Csem.state:=
 ExprState caller(pre_expr ls rs fs)(Kdo k)e m.
Definition call_frame(ls:lhs_stage)(rs:ref_stage):cont:=
 Kcall caller e(assignment_context(lhs_res ls)(ref_res rs))rettype(Kdo k).
Definition pre_or_call(s:Csem.state):Prop:=
 (exists ls rs fs,s=pre_state ls rs fs)\/
 (exists ls rs,s=Callstate(Ctypes.Internal leaf)[](call_frame ls rs)m).
Hypothesis param_local:e!igh=Some(bparam,tptr ghty).
Hypothesis error_global:e!ierr=None.
Hypothesis error_symbol:Genv.find_symbol ge ierr=Some berr.
Hypothesis getter_global:e!igetter=None.
Hypothesis getter_symbol:Genv.find_symbol ge igetter=Some bgetter.
Variable ghco refco vecco:composite.
Hypothesis gh_lookup:PTree.get ghid(genv_cenv ge)=Some ghco.
Hypothesis ref_lookup:PTree.get refid(genv_cenv ge)=Some refco.
Hypothesis vec_lookup:PTree.get vectid(genv_cenv ge)=Some vecco.
Hypothesis gh_field:field_offset ge iref(co_members ghco)=OK(dref,Full).
Hypothesis ref_field:field_offset ge icomponent(co_members refco)=OK(dcomponent,Full).
Hypothesis axis_field:field_offset ge axis(co_members vecco)=OK(daxis,Full).
Hypothesis param_deref:Cexec.do_deref_loc ge quiet_world(tptr ghty)m bparam Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr bgh Ptrofs.zero).
Hypothesis scalar_deref:Cexec.do_deref_loc ge quiet_world tint m bgh scalar_offset Full=
 Some(quiet_world,E0,Vint reference).
Hypothesis leaf_find:Genv.find_funct ge(Vptr bgetter Ptrofs.zero)=Some(Ctypes.Internal leaf).
Hypothesis leaf_signature:type_of_fundef(Ctypes.Internal leaf)=function_type.
Ltac close_pool:=
 split;[reflexivity|unfold pre_or_call;first[
 left;first[solve[exists L0,R0,F0;reflexivity]|solve[exists L0,R0,F1;reflexivity]|solve[exists L0,R0,F2;reflexivity]|solve[exists L0,R1,F0;reflexivity]|solve[exists L0,R1,F1;reflexivity]|solve[exists L0,R1,F2;reflexivity]|solve[exists L0,R2,F0;reflexivity]|solve[exists L0,R2,F1;reflexivity]|solve[exists L0,R2,F2;reflexivity]|solve[exists L0,R3,F0;reflexivity]|solve[exists L0,R3,F1;reflexivity]|solve[exists L0,R3,F2;reflexivity]|solve[exists L0,R4,F0;reflexivity]|solve[exists L0,R4,F1;reflexivity]|solve[exists L0,R4,F2;reflexivity]|solve[exists L0,R5,F0;reflexivity]|solve[exists L0,R5,F1;reflexivity]|solve[exists L0,R5,F2;reflexivity]|solve[exists L0,R6,F0;reflexivity]|solve[exists L0,R6,F1;reflexivity]|solve[exists L0,R6,F2;reflexivity]|solve[exists L0,R7,F0;reflexivity]|solve[exists L0,R7,F1;reflexivity]|solve[exists L0,R7,F2;reflexivity]|solve[exists L0,R8,F0;reflexivity]|solve[exists L0,R8,F1;reflexivity]|solve[exists L0,R8,F2;reflexivity]|solve[exists L0,R9,F0;reflexivity]|solve[exists L0,R9,F1;reflexivity]|solve[exists L0,R9,F2;reflexivity]|solve[exists L0,R10,F0;reflexivity]|solve[exists L0,R10,F1;reflexivity]|solve[exists L0,R10,F2;reflexivity]|solve[exists L1,R0,F0;reflexivity]|solve[exists L1,R0,F1;reflexivity]|solve[exists L1,R0,F2;reflexivity]|solve[exists L1,R1,F0;reflexivity]|solve[exists L1,R1,F1;reflexivity]|solve[exists L1,R1,F2;reflexivity]|solve[exists L1,R2,F0;reflexivity]|solve[exists L1,R2,F1;reflexivity]|solve[exists L1,R2,F2;reflexivity]|solve[exists L1,R3,F0;reflexivity]|solve[exists L1,R3,F1;reflexivity]|solve[exists L1,R3,F2;reflexivity]|solve[exists L1,R4,F0;reflexivity]|solve[exists L1,R4,F1;reflexivity]|solve[exists L1,R4,F2;reflexivity]|solve[exists L1,R5,F0;reflexivity]|solve[exists L1,R5,F1;reflexivity]|solve[exists L1,R5,F2;reflexivity]|solve[exists L1,R6,F0;reflexivity]|solve[exists L1,R6,F1;reflexivity]|solve[exists L1,R6,F2;reflexivity]|solve[exists L1,R7,F0;reflexivity]|solve[exists L1,R7,F1;reflexivity]|solve[exists L1,R7,F2;reflexivity]|solve[exists L1,R8,F0;reflexivity]|solve[exists L1,R8,F1;reflexivity]|solve[exists L1,R8,F2;reflexivity]|solve[exists L1,R9,F0;reflexivity]|solve[exists L1,R9,F1;reflexivity]|solve[exists L1,R9,F2;reflexivity]|solve[exists L1,R10,F0;reflexivity]|solve[exists L1,R10,F1;reflexivity]|solve[exists L1,R10,F2;reflexivity]|solve[exists L2,R0,F0;reflexivity]|solve[exists L2,R0,F1;reflexivity]|solve[exists L2,R0,F2;reflexivity]|solve[exists L2,R1,F0;reflexivity]|solve[exists L2,R1,F1;reflexivity]|solve[exists L2,R1,F2;reflexivity]|solve[exists L2,R2,F0;reflexivity]|solve[exists L2,R2,F1;reflexivity]|solve[exists L2,R2,F2;reflexivity]|solve[exists L2,R3,F0;reflexivity]|solve[exists L2,R3,F1;reflexivity]|solve[exists L2,R3,F2;reflexivity]|solve[exists L2,R4,F0;reflexivity]|solve[exists L2,R4,F1;reflexivity]|solve[exists L2,R4,F2;reflexivity]|solve[exists L2,R5,F0;reflexivity]|solve[exists L2,R5,F1;reflexivity]|solve[exists L2,R5,F2;reflexivity]|solve[exists L2,R6,F0;reflexivity]|solve[exists L2,R6,F1;reflexivity]|solve[exists L2,R6,F2;reflexivity]|solve[exists L2,R7,F0;reflexivity]|solve[exists L2,R7,F1;reflexivity]|solve[exists L2,R7,F2;reflexivity]|solve[exists L2,R8,F0;reflexivity]|solve[exists L2,R8,F1;reflexivity]|solve[exists L2,R8,F2;reflexivity]|solve[exists L2,R9,F0;reflexivity]|solve[exists L2,R9,F1;reflexivity]|solve[exists L2,R9,F2;reflexivity]|solve[exists L2,R10,F0;reflexivity]|solve[exists L2,R10,F1;reflexivity]|solve[exists L2,R10,F2;reflexivity]|solve[exists L3,R0,F0;reflexivity]|solve[exists L3,R0,F1;reflexivity]|solve[exists L3,R0,F2;reflexivity]|solve[exists L3,R1,F0;reflexivity]|solve[exists L3,R1,F1;reflexivity]|solve[exists L3,R1,F2;reflexivity]|solve[exists L3,R2,F0;reflexivity]|solve[exists L3,R2,F1;reflexivity]|solve[exists L3,R2,F2;reflexivity]|solve[exists L3,R3,F0;reflexivity]|solve[exists L3,R3,F1;reflexivity]|solve[exists L3,R3,F2;reflexivity]|solve[exists L3,R4,F0;reflexivity]|solve[exists L3,R4,F1;reflexivity]|solve[exists L3,R4,F2;reflexivity]|solve[exists L3,R5,F0;reflexivity]|solve[exists L3,R5,F1;reflexivity]|solve[exists L3,R5,F2;reflexivity]|solve[exists L3,R6,F0;reflexivity]|solve[exists L3,R6,F1;reflexivity]|solve[exists L3,R6,F2;reflexivity]|solve[exists L3,R7,F0;reflexivity]|solve[exists L3,R7,F1;reflexivity]|solve[exists L3,R7,F2;reflexivity]|solve[exists L3,R8,F0;reflexivity]|solve[exists L3,R8,F1;reflexivity]|solve[exists L3,R8,F2;reflexivity]|solve[exists L3,R9,F0;reflexivity]|solve[exists L3,R9,F1;reflexivity]|solve[exists L3,R9,F2;reflexivity]|solve[exists L3,R10,F0;reflexivity]|solve[exists L3,R10,F1;reflexivity]|solve[exists L3,R10,F2;reflexivity]]
 |right;first[solve[exists L0,R0;reflexivity]|solve[exists L0,R1;reflexivity]|solve[exists L0,R2;reflexivity]|solve[exists L0,R3;reflexivity]|solve[exists L0,R4;reflexivity]|solve[exists L0,R5;reflexivity]|solve[exists L0,R6;reflexivity]|solve[exists L0,R7;reflexivity]|solve[exists L0,R8;reflexivity]|solve[exists L0,R9;reflexivity]|solve[exists L0,R10;reflexivity]|solve[exists L1,R0;reflexivity]|solve[exists L1,R1;reflexivity]|solve[exists L1,R2;reflexivity]|solve[exists L1,R3;reflexivity]|solve[exists L1,R4;reflexivity]|solve[exists L1,R5;reflexivity]|solve[exists L1,R6;reflexivity]|solve[exists L1,R7;reflexivity]|solve[exists L1,R8;reflexivity]|solve[exists L1,R9;reflexivity]|solve[exists L1,R10;reflexivity]|solve[exists L2,R0;reflexivity]|solve[exists L2,R1;reflexivity]|solve[exists L2,R2;reflexivity]|solve[exists L2,R3;reflexivity]|solve[exists L2,R4;reflexivity]|solve[exists L2,R5;reflexivity]|solve[exists L2,R6;reflexivity]|solve[exists L2,R7;reflexivity]|solve[exists L2,R8;reflexivity]|solve[exists L2,R9;reflexivity]|solve[exists L2,R10;reflexivity]|solve[exists L3,R0;reflexivity]|solve[exists L3,R1;reflexivity]|solve[exists L3,R2;reflexivity]|solve[exists L3,R3;reflexivity]|solve[exists L3,R4;reflexivity]|solve[exists L3,R5;reflexivity]|solve[exists L3,R6;reflexivity]|solve[exists L3,R7;reflexivity]|solve[exists L3,R8;reflexivity]|solve[exists L3,R9;reflexivity]|solve[exists L3,R10;reflexivity]]]].
Ltac typeeq_self:=
 repeat match goal with
 | |-context[if Ctypes.type_eq ?TY ?TY then _ else _]=>
 destruct(Ctypes.type_eq TY TY)as[TE|NE];[|exfalso;apply NE;reflexivity]
 | H:context[if Ctypes.type_eq ?TY ?TY then _ else _] |- _=>
 destruct(Ctypes.type_eq TY TY)as[TE|NE]in H;[|exfalso;apply NE;reflexivity] end.
Ltac simplify_animator:=
 cbn[pre_state pre_expr assignment_context getter_read lhs_res ref_res fn_res axis_load component_load reference_load
 Cexec.do_step Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc Cexec.is_val_list
 Cexec.incontext Cexec.topred Cexec.stuck];
 rewrite ?param_local,?error_global,?error_symbol,?getter_global,?getter_symbol;
 rewrite ?dec_eq_true;
 rewrite ?gh_lookup,?ref_lookup,?vec_lookup,?gh_field,?ref_field,?axis_field;
 rewrite ?param_deref,?scalar_deref;
 cbn[Cexec.do_deref_loc ghty refty vty nedty function_type rettype access_mode type_is_volatile];
 rewrite ?dec_eq_true;
 cbn[classify_fun sem_cast_arguments sem_cast];rewrite ?leaf_find,?leaf_signature;unfold function_type;rewrite ?dec_eq_true;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd];
 cbn[function_type rettype];rewrite ?dec_eq_true;typeeq_self;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd];
 rewrite ?gh_lookup,?ref_lookup,?vec_lookup,?gh_field,?ref_field,?axis_field;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].
Lemma pre_animator_step:forall ls rs fs rule t next,
 In(TR rule t next)(Cexec.do_step ge null_external null_external quiet_world(pre_state ls rs fs)) ->
 t=E0 /\ pre_or_call next.
Proof.
 intros ls rs fs rule t next;destruct ls,rs,fs;simplify_animator.
 all: intros IN;simpl in IN;typeeq_self;cbn[Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd]in IN;simpl in IN;repeat destruct IN as[EQ|IN];try contradiction;inversion EQ;subst;close_pool.

Qed.
Lemma pre_callback_free:forall ls rs fs,callback_free_state(pre_state ls rs fs).
Proof. intros;destruct ls,rs,fs;reflexivity. Qed.
Lemma pre_core:forall ls rs fs,
 SourceClosure.core_expr ge(fun _=>True)(fun _ _=>True)(pre_expr ls rs fs).
Proof.
 intros;destruct ls,rs,fs;
 cbn[pre_expr assignment_context getter_read lhs_res ref_res fn_res axis_load component_load reference_load
 function_type rettype ghty refty vty nedty SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];
 repeat split;try reflexivity;unfold SourceClosure.valid_call;intros;split;exact I.
Qed.
Lemma pre_silent:forall ls rs fs,silent_state ge(pre_state ls rs fs).
Proof.
 intros ls rs fs t next STEP;pose proof(pre_core ls rs fs)as CORE.
 destruct STEP as[ES|SS];[|inversion SS].
 inversion ES;subst;auto.
 match goal with EQ:?C ?A=pre_expr _ _ _ |- _=>rewrite <-EQ in CORE end.
 match goal with HC:Csem.context RV RV ?C,RR:rred ge ?a m t ?a' ?m' |- _=>
 pose proof(SourceClosure.core_context_hole ge(fun _=>True)(fun _ _=>True)
 _ _ _ HC a CORE)as CA;
 exact(proj1(SourceClosure.core_rred ge(fun _=>True)(fun _ _=>True)a m t a' m' CA RR))end.
Qed.
Theorem pre_all_successors:forall ls rs fs t next,
 Csem.step ge(pre_state ls rs fs)t next ->t=E0 /\pre_or_call next.
Proof.
 intros ls rs fs t next STEP.
 pose proof(pre_silent ls rs fs t next STEP)as TT;subst t.
 destruct(pure_do_step_complete ge null_external null_external quiet_world
 (pre_state ls rs fs)E0 next quiet_world(pre_callback_free ls rs fs)
 (possible_trace_nil quiet_world)STEP)as[rule IN].
 eapply pre_animator_step;exact IN.
Qed.
Lemma pre_animator_nonempty:forall ls rs fs,
 exists rule t next,In(TR rule t next)
 (Cexec.do_step ge null_external null_external quiet_world(pre_state ls rs fs)).
Proof.
 intros ls rs fs;destruct ls,rs,fs;simplify_animator.
 all: cbn[classify_fun];typeeq_self;cbn[Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].
 all: repeat eexists;apply in_eq.
Qed.
Theorem pre_progress:forall ls rs fs,
 exists t next,Csem.step ge(pre_state ls rs fs)t next /\pre_or_call next.
Proof.
 intros ls rs fs;destruct(pre_animator_nonempty ls rs fs)as[rule[t[next IN]]].
 pose proof(proj2(pre_animator_step ls rs fs rule t next IN))as CLASS.
 exists t,next;split;[|exact CLASS].
 eapply supported_nonstuck_transition;[apply pre_callback_free|exact IN|].
 destruct CLASS as[PRE|CALL].
 + destruct PRE as[ls0[rs0[fs0 EQ]]];subst;discriminate.
 + destruct CALL as[ls0[rs0 EQ]];subst;discriminate.
Qed.
End GETTER_ASSIGNMENT.
Print Assumptions pre_all_successors.
Print Assumptions pre_progress.
