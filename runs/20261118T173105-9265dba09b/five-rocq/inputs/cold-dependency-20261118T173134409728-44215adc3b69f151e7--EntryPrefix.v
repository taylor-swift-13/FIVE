From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout GetterSemantics.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.

Lemma original_cached_position_strategy : forall m b co flags delta,
 Genv.find_symbol Execution.ge Source._state=Some b ->
 PTree.get Source._State (genv_cenv Execution.ge)=Some co ->
 field_offset Execution.ge Source._pos_status (co_members co)=OK(2,Full) ->
 field_offset Execution.ge Source._ned_pos_i (co_members co)=OK(delta,Full) ->
 Mem.load Mint16unsigned m b 2=Some(Vint flags) ->
 Int.and flags (Int.repr 2)=Int.repr 2 ->
 Cstrategy.eval_funcall Execution.ge m (Internal Source.f_stateGetPositionNed_i) [] E0 m (Vptr b(Ptrofs.repr delta)).
Proof.
 intros m b co flags delta SYM CO STATUS POS LOAD VALID.
 eapply Cstrategy.eval_funcall_internal with(e:=empty_env)(m1:=m)(m2:=m)(m3:=m)
 (out:=Out_return(Some(Vptr b(Ptrofs.repr delta),ned_ptr))).
 - constructor.
 - constructor.
 - constructor.
 - cbn[Source.f_stateGetPositionNed_i fn_body].
   eapply BigstepSupport.sequence_normal.
   + eapply Cstrategy.exec_Sifthenelse with(v1:=Vint Int.zero)(b:=false)(m1:=m)(t1:=E0)(t2:=E0).
     * apply BigstepSupport.simple_expression.
       -- eapply cache_expression_false with(b:=b)(co:=co)(flags:=flags)(statusofs:=2);eassumption.
       -- reflexivity.
     * reflexivity.
     * constructor.
   + apply Cstrategy.exec_Sreturn_some.
     apply BigstepSupport.simple_expression.
     * apply getter_return_expression with(co:=co);assumption.
     * reflexivity.
 - cbn[Cstrategy.outcome_result_value Source.f_stateGetPositionNed_i fn_return].
   split;[discriminate|reflexivity].
 - reflexivity.
Qed.

Definition pos_getter_type := Tfunction [] ned_ptr cc_default.
Definition pos_getter_expr := Evalof(Evar Source._stateGetPositionNed_i pos_getter_type) pos_getter_type.
Definition pos_getter_call := Ecall pos_getter_expr Enil ned_ptr.
Definition measured_axis_expr (getter:expr) (axis:ident) :=
 Evalof(Efield(Evalof(Ederef getter(Tstruct Source._NedCoor_i noattr))
 (Tstruct Source._NedCoor_i noattr))axis tint)tint.

Lemma original_position_call_evaluates : forall e m fb sb co flags delta,
 PTree.get Source._stateGetPositionNed_i e=None ->
 Genv.find_symbol Execution.ge Source._stateGetPositionNed_i=Some fb ->
 Genv.find_funct Execution.ge(Vptr fb Ptrofs.zero)=Some(Internal Source.f_stateGetPositionNed_i) ->
 Genv.find_symbol Execution.ge Source._state=Some sb ->
 PTree.get Source._State (genv_cenv Execution.ge)=Some co ->
 field_offset Execution.ge Source._pos_status (co_members co)=OK(2,Full) ->
 field_offset Execution.ge Source._ned_pos_i (co_members co)=OK(delta,Full) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags (Int.repr 2)=Int.repr 2 ->
 Cstrategy.eval_expr Execution.ge e m RV pos_getter_call E0 m
 (Eval(Vptr sb(Ptrofs.repr delta))ned_ptr).
Proof.
 intros e m fb sb co flags delta LOCAL SYM FUN ST CO STATUS POS LOAD VALID.
 unfold pos_getter_call.
 replace E0 with(E0**E0**E0) by reflexivity.
 eapply Cstrategy.eval_call with(rf':=pos_getter_expr)(rargs':=Enil)
 (vf:=Vptr fb Ptrofs.zero)(vargs:=[])(targs:=[])(tres:=ned_ptr)(cconv:=cc_default)
 (fd:=Internal Source.f_stateGetPositionNed_i).
 - unfold pos_getter_expr;apply Cstrategy.eval_valof;[reflexivity|constructor].
 - constructor.
 - unfold pos_getter_expr;eapply Cstrategy.esr_rvalof.
   + apply esl_var_global;[exact LOCAL|exact SYM].
   + reflexivity.
   + reflexivity.
   + constructor;reflexivity.
 - constructor.
 - reflexivity.
 - exact FUN.
 - reflexivity.
 - eapply original_cached_position_strategy;eassumption.
Qed.

Lemma measured_axis_call_reduction : forall e m sb delta axis,
 Cstrategy.eval_expr Execution.ge e m RV pos_getter_call E0 m
 (Eval(Vptr sb(Ptrofs.repr delta))ned_ptr) ->
 Cstrategy.eval_expr Execution.ge e m RV (measured_axis_expr pos_getter_call axis) E0 m
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr delta))ned_ptr)axis).
Proof.
 intros;unfold measured_axis_expr.
 apply Cstrategy.eval_valof;[reflexivity|].
 apply Cstrategy.eval_field;apply Cstrategy.eval_valof;[reflexivity|].
 apply Cstrategy.eval_deref;assumption.
Qed.

Lemma effectful_assignment : forall ge e m mf l r r' ty b ofs bf v vc v',
 Cstrategy.eval_simple_lvalue ge e m l b ofs bf -> source_simple l=true ->
 Cstrategy.eval_expr ge e m RV r E0 m r' ->
 Cstrategy.eval_simple_rvalue ge e m r' v ->
 sem_cast v (typeof r) (typeof l) m=Some vc ->
 assign_loc ge (typeof l) m b ofs bf vc E0 mf v' -> ty=typeof l ->
 Cstrategy.exec_stmt ge e m (Sdo(Eassign l r ty)) E0 mf Out_normal.
Proof.
 intros ge e m mf l r r' ty b ofs bf v vc v' LV SIMPLE EV VALUE CAST STORE TY.
 eapply Cstrategy.exec_Sdo.
 eapply Cstrategy.eval_expression_intro with(a':=Eval v' ty);[|constructor].
 replace E0 with(E0**E0**E0)by reflexivity.
 eapply Cstrategy.eval_assign.
 - eapply(proj2(simple_eval_expr_refl ge e m));eassumption.
 - exact EV.
 - exact LV.
 - exact VALUE.
 - exact CAST.
 - exact STORE.
 - exact TY.
Qed.

Definition pid_vec_expr (id:ident) := Evalof(Evar id vec_type)vec_type.
Definition pid_axis_lvalue (id axis:ident) := Efield(pid_vec_expr id)axis tint.
Definition gh_expr := Evalof(Evar Source._gh(tptr gh_type))(tptr gh_type).
Definition gh_ref_expr := Evalof(Efield(Evalof(Ederef gh_expr gh_type)gh_type)Source._ref
 (Tstruct Source._HorizontalGuidanceReference noattr))(Tstruct Source._HorizontalGuidanceReference noattr).
Definition ref_position_expr (axis:ident) :=
 Evalof(Efield(Evalof(Efield gh_ref_expr Source._pos vec_type)vec_type)axis tint)tint.
Definition original_position_assignment (axis:ident) :=
 Sdo(Eassign(pid_axis_lvalue Source._guidance_pid_pos_err axis)
 (Ebinop Osub(ref_position_expr axis)(measured_axis_expr pos_getter_call axis)tint)tint).

Lemma original_source_position_prefix :
 fn_body Source.f_guidance_pid_h_run_pos =
 Ssequence
 (Ssequence(original_position_assignment Source._x)(original_position_assignment Source._y))
 (match fn_body Source.f_guidance_pid_h_run_pos with Ssequence _ tail=>tail|_=>Sskip end).
Proof. reflexivity. Qed.

Lemma original_position_assignment_exec : forall e m mf axis eb eofs ra pa sb delta,
 Cstrategy.eval_simple_lvalue Execution.ge e m (pid_axis_lvalue Source._guidance_pid_pos_err axis) eb eofs Full ->
 Cstrategy.eval_simple_rvalue Execution.ge e m (ref_position_expr axis) (Vint ra) ->
 Cstrategy.eval_expr Execution.ge e m RV pos_getter_call E0 m (Eval(Vptr sb(Ptrofs.repr delta))ned_ptr) ->
 Cstrategy.eval_simple_rvalue Execution.ge e m
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr delta))ned_ptr)axis)(Vint pa) ->
 Mem.storev Mint32 m(Vptr eb eofs)(Vint(Int.sub ra pa))=Some mf ->
 Cstrategy.exec_stmt Execution.ge e m (original_position_assignment axis) E0 mf Out_normal.
Proof.
 intros e m mf axis eb eofs ra pa sb delta LV RA GET PA STORE.
 unfold original_position_assignment.
 eapply effectful_assignment with(r':=Ebinop Osub(ref_position_expr axis)
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr delta))ned_ptr)axis)tint)
 (v:=Vint(Int.sub ra pa))(vc:=Vint(Int.sub ra pa)).
 - exact LV.
 - reflexivity.
 - replace E0 with(E0**E0)by reflexivity.
   eapply Cstrategy.eval_binop.
   + eapply(proj1(simple_eval_expr_refl Execution.ge e m));[exact RA|reflexivity].
   + apply measured_axis_call_reduction;exact GET.
 - eapply Cstrategy.esr_binop;[exact RA|exact PA|reflexivity].
 - reflexivity.
 - apply BigstepSupport.assign_scalar with(chunk:=Mint32);try reflexivity;exact STORE.
 - reflexivity.
Qed.
Print Assumptions original_position_assignment_exec.
