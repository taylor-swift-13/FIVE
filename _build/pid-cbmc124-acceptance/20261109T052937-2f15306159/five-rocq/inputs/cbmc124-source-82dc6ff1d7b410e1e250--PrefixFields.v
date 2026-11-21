From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
From PidPositionSafety Require Import PidTermination.
From PidPositionTranslationAttempt002 Require Import EntryPrefix.
Import ListNotations.
Open Scope Z_scope.
Module S := PidPositionRunPos.Source.
Module E := PidPositionRunPos.Execution.
Local Transparent E.ge.
Lemma prefix_ge_ce : genv_cenv E.ge=ce.
Proof. unfold E.ge,Csem.globalenv,ce. cbv beta iota zeta delta [genv_cenv]. reflexivity. Qed.
Local Opaque E.ge.
Ltac p_cenv :=
 lazymatch goal with |- PTree.get ?id _ = Some ?co =>
 unify co (FactorySemantics.co_for id);rewrite prefix_ge_ce;
 apply FactorySemantics.co_for_lookup;vm_compute;reflexivity end.
Ltac p_field := rewrite prefix_ge_ce;vm_compute;reflexivity.
Ltac p_rv :=
 lazymatch goal with
 | |- eval_simple_rvalue _ _ _ (Eval _ _) _ => constructor
 | |- eval_simple_rvalue _ _ _ (Evalof ?l ?ty) _ =>
   let mode := eval hnf in (access_mode ty) in
   lazymatch mode with
   | By_copy=>eapply esr_rvalof;[p_lv|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]
   | By_value ?ch=>eapply read_scalar with(chunk:=ch);
      [p_lv|reflexivity|reflexivity|reflexivity|
       lazymatch goal with |- Mem.loadv ?c ?mm (Vptr ?bb ?oo)=Some ?vv =>
       let ox := eval vm_compute in (Ptrofs.unsigned oo) in
       change(Mem.load c mm bb ox=Some vv);eassumption end]
   end
 | |- eval_simple_rvalue _ _ _ (Eaddrof _ _) _ => apply esr_addrof;p_lv
 end
with p_lv :=
 lazymatch goal with
 | |- eval_simple_lvalue _ _ _ (Evar _ _) _ _ _ =>
   first[eapply esl_var_local;eassumption|eapply esl_var_global;eassumption]
 | |- eval_simple_lvalue _ _ _ (Ederef _ _) _ _ _ => eapply esl_deref;p_rv
 | |- eval_simple_lvalue _ _ _ (Efield ?r _ _) _ _ _ =>
   let rt := eval cbv beta iota zeta delta [typeof] in(typeof r)in
   lazymatch rt with
   | Tstruct _ _=>eapply esl_field_struct;[p_rv|reflexivity|p_cenv|p_field]
   | Tunion _ _=>eapply esl_field_union;[p_rv|reflexivity|idtac|p_cenv];p_field
   end
 end.

Lemma reference_x_read : forall e m bg gh v,
 e!S._gh=Some(bg,tptr gh_type) ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint v) ->
 eval_simple_rvalue E.ge e m(ref_position_expr S._x)(Vint v).
Proof.
 intros e m bg gh v ENV PTR FIELD.
 change(Mem.load Mint32 m gh 44=Some(Vint v))in FIELD.
 unfold ref_position_expr,gh_ref_expr,gh_expr,vec_type,gh_type;p_rv.
Qed.
Lemma reference_y_read : forall e m bg gh v,
 e!S._gh=Some(bg,tptr gh_type) ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint v) ->
 eval_simple_rvalue E.ge e m(ref_position_expr S._y)(Vint v).
Proof.
 intros e m bg gh v ENV PTR FIELD.
 change(Mem.load Mint32 m gh 48=Some(Vint v))in FIELD.
 unfold ref_position_expr,gh_ref_expr,gh_expr,vec_type,gh_type;p_rv.
Qed.
Lemma cached_measured_x_read : forall e m sb v,
 Mem.load Mint32 m sb 100=Some(Vint v) ->
 eval_simple_rvalue E.ge e m
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr 100))GetterSemantics.ned_ptr)S._x)(Vint v).
Proof.
 intros;unfold measured_axis_expr,GetterSemantics.ned_ptr;p_rv.
Qed.
Lemma cached_measured_y_read : forall e m sb v,
 Mem.load Mint32 m sb 104=Some(Vint v) ->
 eval_simple_rvalue E.ge e m
 (measured_axis_expr(Eval(Vptr sb(Ptrofs.repr 100))GetterSemantics.ned_ptr)S._y)(Vint v).
Proof.
 intros;unfold measured_axis_expr,GetterSemantics.ned_ptr;p_rv.
Qed.
Lemma position_error_x_lvalue : forall e m pb,
 e!S._guidance_pid_pos_err=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->
 eval_simple_lvalue E.ge e m(pid_axis_lvalue S._guidance_pid_pos_err S._x)pb Ptrofs.zero Full.
Proof.
 intros;unfold pid_axis_lvalue,pid_vec_expr,vec_type.
 change(eval_simple_lvalue E.ge e m
 (Efield(Evalof(Evar S._guidance_pid_pos_err(Tstruct S._Int32Vect2 noattr))(Tstruct S._Int32Vect2 noattr))S._x tint)
 pb(Ptrofs.add Ptrofs.zero(Ptrofs.repr 0))Full).
 p_lv.
Qed.
Lemma position_error_y_lvalue : forall e m pb,
 e!S._guidance_pid_pos_err=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->
 eval_simple_lvalue E.ge e m(pid_axis_lvalue S._guidance_pid_pos_err S._y)pb(Ptrofs.repr 4)Full.
Proof.
 intros;unfold pid_axis_lvalue,pid_vec_expr,vec_type.
 change(eval_simple_lvalue E.ge e m
 (Efield(Evalof(Evar S._guidance_pid_pos_err(Tstruct S._Int32Vect2 noattr))(Tstruct S._Int32Vect2 noattr))S._y tint)
 pb(Ptrofs.add Ptrofs.zero(Ptrofs.repr 4))Full).
 p_lv.
Qed.
Print Assumptions reference_x_read.

Local Transparent PidTermination.ge PidTermination.ast_prog.
Lemma concrete_position_getter_target :
 exists fb,
 Genv.find_symbol E.ge S._stateGetPositionNed_i=Some fb /\
 Genv.find_funct E.ge(Vptr fb Ptrofs.zero)=Some(Internal S.f_stateGetPositionNed_i).
Proof.
 exists(PidTermination.symbol_block S._stateGetPositionNed_i);split.
 - change(Genv.find_symbol(genv_genv PidTermination.ge)S._stateGetPositionNed_i=Some(PidTermination.symbol_block S._stateGetPositionNed_i)).
   rewrite PidTermination.ge_base;vm_compute;reflexivity.
 - change(Genv.find_funct_ptr(genv_genv PidTermination.ge)(PidTermination.symbol_block S._stateGetPositionNed_i)=Some(Internal S.f_stateGetPositionNed_i)).
   rewrite PidTermination.ge_base;vm_compute;reflexivity.
Qed.
Local Opaque PidTermination.ge.

Lemma actual_cached_position_call : forall e m sb flags,
 e!S._stateGetPositionNed_i=None ->
 Genv.find_symbol E.ge S._state=Some sb ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Cstrategy.eval_expr E.ge e m RV pos_getter_call E0 m
 (Eval(Vptr sb(Ptrofs.repr 100))GetterSemantics.ned_ptr).
Proof.
 intros e m sb flags LOCAL STATE LOAD VALID.
 destruct concrete_position_getter_target as[fb[SYM FUN]].
 eapply original_position_call_evaluates with(fb:=fb)(co:=FactorySemantics.co_for S._State)(flags:=flags).
 - exact LOCAL.
 - exact SYM.
 - exact FUN.
 - exact STATE.
 - p_cenv.
 - p_field.
 - p_field.
 - exact LOAD.
 - exact VALID.
Qed.

Theorem original_two_position_assignments : forall e m bg gh pb sb rx ry px py flags,
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid_pos_err=None ->
 e!S._stateGetPositionNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->
 Genv.find_symbol E.ge S._state=Some sb ->
 bg<>pb -> gh<>pb ->sb<>pb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) ->
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) ->
 Mem.load Mint32 m sb 100=Some(Vint px) ->
 Mem.load Mint32 m sb 104=Some(Vint py) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 exists mf,
 Cstrategy.exec_stmt E.ge e m
 (Ssequence(original_position_assignment S._x)(original_position_assignment S._y))E0 mf Out_normal /\
 Mem.load Mint32 mf pb 0=Some(Vint(Int.sub rx px)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(Int.sub ry py)) /\
 raw_writes(fun b=>b=pb)m mf.
Proof.
 intros e m bg gh pb sb rx ry px py flags ENV LOCAL GET SYM STATE DBG DGH DS PTR RX RY PX PY CACHE VALID WRITE.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m Mint32 pb 0(Vint(Int.sub rx px))A0)as[m1 ST0].
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 destruct(Mem.valid_access_store m1 Mint32 pb 4(Vint(Int.sub ry py))A4)as[mf ST4].
 exists mf;split.
 - eapply sequence_normal with(ma:=m1).
   + eapply original_position_assignment_exec with(ra:=rx)(pa:=px)(sb:=sb)(delta:=100).
     * apply position_error_x_lvalue;[exact LOCAL|exact SYM].
     * eapply reference_x_read;eassumption.
     * eapply actual_cached_position_call;eassumption.
     * apply cached_measured_x_read;exact PX.
     * change(Mem.store Mint32 m pb 0(Vint(Int.sub rx px))=Some m1);exact ST0.
   + eapply original_position_assignment_exec with(ra:=ry)(pa:=py)(sb:=sb)(delta:=100).
     * apply position_error_y_lvalue;[exact LOCAL|exact SYM].
     * eapply reference_y_read;[exact ENV| |].
       -- erewrite Mem.load_store_other;[exact PTR|exact ST0|left;exact DBG].
       -- change(Mem.load Mint32 m1 gh 48=Some(Vint ry)).
          erewrite Mem.load_store_other;[exact RY|exact ST0|left;exact DGH].
     * eapply actual_cached_position_call;try eassumption.
       erewrite Mem.load_store_other;[exact CACHE|exact ST0|left;exact DS].
     * apply cached_measured_y_read.
       erewrite Mem.load_store_other;[exact PY|exact ST0|left;exact DS].
     * change(Mem.store Mint32 m1 pb 4(Vint(Int.sub ry py))=Some mf);exact ST4.
 - split.
   + rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia).
     rewrite(Mem.load_store_same Mint32 m pb 0(Vint(Int.sub rx px))m1 ST0);reflexivity.
   + split.
     * rewrite(Mem.load_store_same Mint32 m1 pb 4(Vint(Int.sub ry py))mf ST4);reflexivity.
     * eapply raw_writes_store;[reflexivity|exact ST0|].
       eapply raw_writes_store;[reflexivity|exact ST4|constructor].
Qed.
Print Assumptions original_two_position_assignments.
