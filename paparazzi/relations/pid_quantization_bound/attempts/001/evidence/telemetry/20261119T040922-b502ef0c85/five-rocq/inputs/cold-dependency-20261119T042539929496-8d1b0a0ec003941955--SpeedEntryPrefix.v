From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout GetterSemantics.
From PidPositionTranslationAttempt002 Require Import EntryPrefix.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.

Lemma original_cached_speed_strategy : forall m b co flags delta,
 Genv.find_symbol Execution.ge Source._state=Some b ->
 PTree.get Source._State (genv_cenv Execution.ge)=Some co ->
 field_offset Execution.ge Source._speed_status (co_members co)=OK(280,Full) ->
 field_offset Execution.ge Source._ned_speed_i (co_members co)=OK(delta,Full) ->
 Mem.load Mint16unsigned m b 280=Some(Vint flags) ->
 Int.and flags (Int.repr 2)=Int.repr 2 ->
 Cstrategy.eval_funcall Execution.ge m (Internal Source.f_stateGetSpeedNed_i) [] E0 m (Vptr b(Ptrofs.repr delta)).
Proof.
 intros m b co flags delta SYM CO STATUS POS LOAD VALID.
 eapply Cstrategy.eval_funcall_internal with(e:=empty_env)(m1:=m)(m2:=m)(m3:=m)
 (out:=Out_return(Some(Vptr b(Ptrofs.repr delta),ned_ptr))).
 - constructor.
 - constructor.
 - constructor.
 - cbn[Source.f_stateGetSpeedNed_i fn_body].
   eapply BigstepSupport.sequence_normal.
   + eapply Cstrategy.exec_Sifthenelse with(v1:=Vint Int.zero)(b:=false)(m1:=m)(t1:=E0)(t2:=E0).
     * apply BigstepSupport.simple_expression.
       -- eapply cache_expression_false with(b:=b)(co:=co)(flags:=flags)(statusofs:=280);eassumption.
       -- reflexivity.
     * reflexivity.
     * constructor.
   + apply Cstrategy.exec_Sreturn_some.
     apply BigstepSupport.simple_expression.
     * apply getter_return_expression with(co:=co);assumption.
     * reflexivity.
 - cbn[Cstrategy.outcome_result_value Source.f_stateGetSpeedNed_i fn_return].
   split;[discriminate|reflexivity].
 - reflexivity.
Qed.

Definition speed_getter_type := Tfunction [] ned_ptr cc_default.
Definition speed_getter_expr := Evalof(Evar Source._stateGetSpeedNed_i speed_getter_type) speed_getter_type.
Definition speed_getter_call := Ecall speed_getter_expr Enil ned_ptr.
Lemma original_speed_call_evaluates : forall e m fb sb co flags delta,
 PTree.get Source._stateGetSpeedNed_i e=None ->
 Genv.find_symbol Execution.ge Source._stateGetSpeedNed_i=Some fb ->
 Genv.find_funct Execution.ge(Vptr fb Ptrofs.zero)=Some(Internal Source.f_stateGetSpeedNed_i) ->
 Genv.find_symbol Execution.ge Source._state=Some sb ->
 PTree.get Source._State (genv_cenv Execution.ge)=Some co ->
 field_offset Execution.ge Source._speed_status (co_members co)=OK(280,Full) ->
 field_offset Execution.ge Source._ned_speed_i (co_members co)=OK(delta,Full) ->
 Mem.load Mint16unsigned m sb 280=Some(Vint flags) ->
 Int.and flags (Int.repr 2)=Int.repr 2 ->
 Cstrategy.eval_expr Execution.ge e m RV speed_getter_call E0 m
 (Eval(Vptr sb(Ptrofs.repr delta))ned_ptr).
Proof.
 intros e m fb sb co flags delta LOCAL SYM FUN ST CO STATUS POS LOAD VALID.
 unfold speed_getter_call.
 replace E0 with(E0**E0**E0) by reflexivity.
 eapply Cstrategy.eval_call with(rf':=speed_getter_expr)(rargs':=Enil)
 (vf:=Vptr fb Ptrofs.zero)(vargs:=[])(targs:=[])(tres:=ned_ptr)(cconv:=cc_default)
 (fd:=Internal Source.f_stateGetSpeedNed_i).
 - unfold speed_getter_expr;apply Cstrategy.eval_valof;[reflexivity|constructor].
 - constructor.
 - unfold speed_getter_expr;eapply Cstrategy.esr_rvalof.
   + apply esl_var_global;[exact LOCAL|exact SYM].
   + reflexivity.
   + reflexivity.
   + constructor;reflexivity.
 - constructor.
 - reflexivity.
 - exact FUN.
 - reflexivity.
 - eapply original_cached_speed_strategy;eassumption.
Qed.

Lemma speed_measured_axis_call_reduction : forall e m sb delta axis,
 Cstrategy.eval_expr Execution.ge e m RV speed_getter_call E0 m
 (Eval(Vptr sb(Ptrofs.repr delta))ned_ptr) ->
 Cstrategy.eval_expr Execution.ge e m RV (measured_axis_expr speed_getter_call axis) E0 m
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr delta))ned_ptr)axis).
Proof.
 intros;unfold measured_axis_expr.
 apply Cstrategy.eval_valof;[reflexivity|].
 apply Cstrategy.eval_field;apply Cstrategy.eval_valof;[reflexivity|].
 apply Cstrategy.eval_deref;assumption.
Qed.

Definition ref_speed_expr (axis:ident) :=
 Evalof(Efield(Evalof(Efield gh_ref_expr Source._speed vec_type)vec_type)axis tint)tint.
Definition original_speed_assignment (axis:ident) :=
 Sdo(Eassign(pid_axis_lvalue Source._guidance_pid_speed_err axis)
 (Ebinop Osub(ref_speed_expr axis)(measured_axis_expr speed_getter_call axis)tint)tint).
Lemma original_speed_assignment_exec : forall e m mf axis eb eofs ra pa sb delta,
 Cstrategy.eval_simple_lvalue Execution.ge e m (pid_axis_lvalue Source._guidance_pid_speed_err axis) eb eofs Full ->
 Cstrategy.eval_simple_rvalue Execution.ge e m (ref_speed_expr axis) (Vint ra) ->
 Cstrategy.eval_expr Execution.ge e m RV speed_getter_call E0 m (Eval(Vptr sb(Ptrofs.repr delta))ned_ptr) ->
 Cstrategy.eval_simple_rvalue Execution.ge e m
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr delta))ned_ptr)axis)(Vint pa) ->
 Mem.storev Mint32 m(Vptr eb eofs)(Vint(Int.sub ra pa))=Some mf ->
 Cstrategy.exec_stmt Execution.ge e m (original_speed_assignment axis) E0 mf Out_normal.
Proof.
 intros e m mf axis eb eofs ra pa sb delta LV RA GET PA STORE.
 unfold original_speed_assignment.
 eapply effectful_assignment with(r':=Ebinop Osub(ref_speed_expr axis)
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr delta))ned_ptr)axis)tint)
 (v:=Vint(Int.sub ra pa))(vc:=Vint(Int.sub ra pa)).
 - exact LV.
 - reflexivity.
 - replace E0 with(E0**E0)by reflexivity.
   eapply Cstrategy.eval_binop.
   + eapply(proj1(simple_eval_expr_refl Execution.ge e m));[exact RA|reflexivity].
   + apply speed_measured_axis_call_reduction;exact GET.
 - eapply Cstrategy.esr_binop;[exact RA|exact PA|reflexivity].
 - reflexivity.
 - apply BigstepSupport.assign_scalar with(chunk:=Mint32);try reflexivity;exact STORE.
 - reflexivity.
Qed.
Print Assumptions original_speed_assignment_exec.

Lemma original_speed_prefix_binding :
 match fn_body Source.f_guidance_pid_h_run_pos with
 | Ssequence _ (Ssequence _ (Ssequence a _)) =>
   a=Ssequence(original_speed_assignment Source._x)(original_speed_assignment Source._y)
 | _=>False end.
Proof. reflexivity. Qed.
