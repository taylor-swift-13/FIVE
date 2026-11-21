From Stdlib Require Import Bool List ZArith String Classical Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep Builtins Builtins0.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation FactorShell PhaseComposition.
Import ListNotations.
Local Open Scope string_scope.
Definition fabs_ef := EF_builtin "__builtin_fabsf" (mksignature [AST.Xsingle] AST.Xsingle cc_default).
Definition fabs_fd : Csyntax.fundef := External fabs_ef [tfloat] tfloat cc_default.
Definition fabs_type := Tfunction [tfloat] tfloat cc_default.
Definition threshold := Float.of_bits(Int64.repr 4547007122018943789).
Definition compare_abs(a:expr):expr := Ebinop Olt a (Eval(Vfloat threshold)tdouble)tint.
Section FABS.
Variable ge:genv.
Variable e:env.
Variable caller:function.
Variable k:cont.
Variable yes no:statement.
Variable ifunction idet:ident.
Variable bfunction bdet:block.
Variable d:float32.
Variable m:mem.
Hypothesis function_global:e!ifunction=None.
Hypothesis function_symbol:Genv.find_symbol ge ifunction=Some bfunction.
Hypothesis function_find:Genv.find_funct ge(Vptr bfunction Ptrofs.zero)=Some fabs_fd.
Hypothesis det_local:e!idet=Some(bdet,tfloat).
Hypothesis det_load:Mem.load Mfloat32 m bdet 0=Some(Vsingle d).
Definition call_expr(fs ds:read_stage):expr :=
 Ecall(read_res ifunction fabs_type bfunction(Vptr bfunction Ptrofs.zero)fs)
 (Econs(read_res idet tfloat bdet(Vsingle d)ds)Enil)tfloat.
Definition pre_state(fs ds:read_stage):Csem.state :=
 ExprState caller(compare_abs(call_expr fs ds))(Kifthenelse yes no k)e m.
Definition call_frame:cont := Kcall caller e compare_abs tfloat(Kifthenelse yes no k).
Definition called:Csem.state := Callstate fabs_fd[Vsingle d]call_frame m.
Definition returned:Csem.state := Returnstate(Vsingle(Float32.abs d))call_frame m.
Definition target:Csem.state := ExprState caller(compare_abs(Eval(Vsingle(Float32.abs d))tfloat))(Kifthenelse yes no k)e m.
Definition phase(s:Csem.state):Prop := (exists fs ds,s=pre_state fs ds) \/s=called\/s=returned\/s=target.
Definition pre_or_called(s:Csem.state):Prop := (exists fs ds,s=pre_state fs ds)\/s=called.
Ltac close_pre := split;[reflexivity|unfold pre_or_called;first[
 left;first[solve[exists Rvar,Rvar;reflexivity]|solve[exists Rvar,Rloc;reflexivity]|solve[exists Rvar,Rval;reflexivity]|solve[exists Rloc,Rvar;reflexivity]|solve[exists Rloc,Rloc;reflexivity]|solve[exists Rloc,Rval;reflexivity]|solve[exists Rval,Rvar;reflexivity]|solve[exists Rval,Rloc;reflexivity]|solve[exists Rval,Rval;reflexivity]]|right;reflexivity]].
Ltac reduce_pre :=
 cbn[pre_state compare_abs call_expr read_res Cexec.do_step Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc Cexec.is_val_list Cexec.incontext Cexec.topred Cexec.stuck];
 rewrite ?function_global,?function_symbol,?det_local;rewrite ?dec_eq_true;
 cbn[Cexec.do_deref_loc access_mode type_is_volatile];
 cbv[Mem.loadv];rewrite ?Ptrofs.unsigned_zero;rewrite ?zle_true by(change(4<=18446744073709551616);lia);rewrite ?det_load;
 cbn[fabs_type classify_fun sem_cast_arguments sem_cast];rewrite ?function_find;
 cbv[fabs_fd fabs_type type_of_fundef tfloat tptr access_mode type_is_volatile sem_cast classify_cast];rewrite ?dec_eq_true;
 rewrite ?zle_true by(change(4<=18446744073709551616);lia);rewrite ?det_load;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].
Lemma pre_animator:forall fs ds rule t next,
 In(TR rule t next)(Cexec.do_step ge null_external null_external quiet_world(pre_state fs ds))->t=E0/\pre_or_called next.
Proof. intros fs ds rule t next;destruct fs,ds;reduce_pre;
 intros IN;simpl in IN;repeat destruct IN as[EQ|IN];try contradiction;inversion EQ;subst;close_pre. Qed.
Lemma pre_nonempty:forall fs ds,exists rule t next,In(TR rule t next)(Cexec.do_step ge null_external null_external quiet_world(pre_state fs ds)).
Proof. intros fs ds;destruct fs,ds;reduce_pre;repeat eexists;apply in_eq. Qed.
Lemma pre_core:forall fs ds,SourceClosure.core_expr ge(fun _=>True)(fun _ _=>True)(compare_abs(call_expr fs ds)).
Proof. intros;destruct fs,ds;cbn[compare_abs call_expr read_res fabs_type SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];repeat split;try reflexivity;unfold SourceClosure.valid_call;intros;split;exact I. Qed.
Lemma pre_silent:forall fs ds,silent_state ge(pre_state fs ds).
Proof. intros fs ds t next STEP;pose proof(pre_core fs ds)as CORE;destruct STEP as[ES|SS];[|inversion SS].
 inversion ES;subst;auto.
 match goal with EQ:?C ?A=compare_abs _ |- _=>rewrite <-EQ in CORE end.
 match goal with HC:Csem.context RV RV ?C,RR:rred ge ?a m t ?a' ?m' |- _=>pose proof(SourceClosure.core_context_hole ge(fun _=>True)(fun _ _=>True) _ _ _ HC a CORE)as CA;exact(proj1(SourceClosure.core_rred ge(fun _=>True)(fun _ _=>True) a m t a' m' CA RR))end. Qed.
Lemma pre_step:forall fs ds t next,Csem.step ge(pre_state fs ds)t next->t=E0/\pre_or_called next.
Proof. intros fs ds t next STEP;pose proof(pre_silent fs ds t next STEP)as TT;subst t.
 destruct(pure_do_step_complete ge null_external null_external quiet_world(pre_state fs ds)E0 next quiet_world ltac:(destruct fs,ds;reflexivity)(possible_trace_nil quiet_world)STEP)as[rule IN];eapply pre_animator;exact IN. Qed.
Lemma pre_progress:forall fs ds,exists t next,Csem.step ge(pre_state fs ds)t next/\pre_or_called next.
Proof. intros fs ds;destruct(pre_nonempty fs ds)as[rule[t[next IN]]];pose proof(proj2(pre_animator fs ds rule t next IN))as CL;exists t,next;split;auto.
 eapply supported_nonstuck_transition;[destruct fs,ds;reflexivity|exact IN|];destruct CL as[[f0[d0 EQ]]|EQ];subst;discriminate. Qed.
Lemma called_unique:unique_transition ge called returned.
Proof.
 assert(SUP:callback_free_state called)by(vm_compute;reflexivity).
 assert(AN:Cexec.do_step ge null_external null_external quiet_world called=[TR "step_external_function" E0 returned]).
 { cbn[called returned call_frame Cexec.do_step];vm_compute;reflexivity. }
 split.
 - eapply supported_nonstuck_transition;[exact SUP|rewrite AN;left;reflexivity|discriminate].
 - intros t next STEP.
   assert(TT:t=E0)by(destruct STEP as[ES|SS];[inversion ES|inversion SS;subst;eapply(proj1(executable_builtin_silent ge fabs_ef _ _ _ _ _ ltac:(vm_compute;reflexivity) ltac:(eassumption)))]).
   subst t;destruct(pure_do_step_complete ge null_external null_external quiet_world called E0 next quiet_world SUP(possible_trace_nil quiet_world)STEP)as[rule IN].
   rewrite AN in IN;destruct IN as[EQ|BAD];[inversion EQ;auto|contradiction].
Qed.
Lemma returned_unique:unique_transition ge returned target.
Proof. split;[right;apply step_returnstate|intros t next STEP;exact(return_call_step_unique _ _ _ _ _ _ _ _ _ _ STEP)]. Qed.
Theorem phase_certificate:certificate ge phase target.
Proof. split.
 - intros s[[fs[ds EQ]]|[EQ|[EQ|EQ]]];subst s.
 + destruct(pre_progress fs ds)as[t[next[ST CL]]];right;exists t,next;split;auto;destruct CL as[CL|CL];[left;exact CL|right;left;exact CL].
 + right;exists E0,returned;split;[exact(proj1 called_unique)|right;right;left;reflexivity].
 + right;exists E0,target;split;[exact(proj1 returned_unique)|right;right;right;reflexivity].
 + left;reflexivity.
 - intros s t next[[fs[ds EQ]]|[EQ|[EQ|EQ]]]NF STEP;subst s;try contradiction.
 + destruct(pre_step fs ds t next STEP)as[TT[CL|CL]];[left;exact CL|right;left;exact CL].
 + destruct(proj2 called_unique t next STEP)as[TT EQ];subst;right;right;left;reflexivity.
 + destruct(proj2 returned_unique t next STEP)as[TT EQ];subst;right;right;right;reflexivity.
Qed.
End FABS.
Print Assumptions phase_certificate.
