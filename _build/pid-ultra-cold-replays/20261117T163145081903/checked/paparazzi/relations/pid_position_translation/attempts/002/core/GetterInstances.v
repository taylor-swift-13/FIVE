From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Determinism Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceAllOrder Require Import PureDenotation PhaseComposition.
From PidPositionTranslationSupport Require Import MemoryLayout GetterSemantics.
From PidPositionTranslationCore Require Import FactorySemantics.
From PidPositionSafety Require Import GetterAssignmentComplete GetterAllOrder.
From PidPositionTranslationAttempt002 Require Import EntryPrefix SpeedEntryPrefix PrefixFields SpeedPrefixFields.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Module A:=GetterAssignmentShell.
Lemma raw_deref_complete:forall ge ty ch m b ofs v,
 type_is_volatile ty=false ->access_mode ty=By_value ch ->
 Mem.loadv ch m(Vptr b ofs)=Some v ->
 Cexec.do_deref_loc ge PureDenotation.quiet_world ty m b ofs Full=
 Some(PureDenotation.quiet_world,E0,v).
Proof.
 intros ge ty ch m b ofs v NV MODE LOAD.
 eapply Cexec.do_deref_loc_complete;[eapply deref_loc_value;eauto|apply possible_trace_nil].
Qed.
Lemma raw_int_store_complete:forall ge m b ofs v mf,
 Mem.storev Mint32 m(Vptr b ofs)(Vint v)=Some mf ->
 Cexec.do_assign_loc ge PureDenotation.quiet_world tint m b ofs Full(Vint v)=
 Some(PureDenotation.quiet_world,E0,mf,Vint v).
Proof.
 intros ge m b ofs v mf ST;eapply Cexec.do_assign_loc_complete;
 [eapply assign_loc_value;[reflexivity|reflexivity|exact ST]|apply possible_trace_nil].
Qed.

Theorem original_position_x_store_certificate:forall e m mf bg gh pb sb reference measured flags k,
 e!S._gh=Some(bg,tptr gh_type) ->e!S._guidance_pid_pos_err=None ->e!S._stateGetPositionNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->Genv.find_symbol E.ge S._state=Some sb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Mem.load Mint32 m gh 44=Some(Vint reference) ->
 Mem.load Mint32 m sb 100=Some(Vint measured) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.store Mint32 m pb 0(Vint(Int.sub reference measured))=Some mf ->
 exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos(original_position_assignment S._x)k e m).
Proof.
 intros e m mf bg gh pb sb reference measured flags k ENV ERRN GETN ERRSYM STATE PTR REF MEASURED FLAGS VALID STORE.
 destruct concrete_position_getter_target as[fb[GETSYM GETFUN]].
 eapply GetterAssignmentComplete.original_getter_assignment_certificate with
 (ge:=E.ge)(caller:=S.f_guidance_pid_h_run_pos)(leaf:=S.f_stateGetPositionNed_i)
 (ghid:=S._HorizontalGuidance)(refid:=S._HorizontalGuidanceReference)(vectid:=S._Int32Vect2)(nedid:=S._NedCoor_i)
 (axis:=S._x)(iref:=S._ref)(icomponent:=S._pos)(ierr:=S._guidance_pid_pos_err)(igh:=S._gh)
 (berr:=pb)(bparam:=bg)(bgh:=gh)(bcache:=sb)(dref:=44)(dcomponent:=0)(daxis:=0)
 (cacheofs:=Ptrofs.repr 100)(reference:=reference)(measured:=measured)(difference:=Int.sub reference measured)
 (ghco:=FactorySemantics.co_for S._HorizontalGuidance)
 (refco:=FactorySemantics.co_for S._HorizontalGuidanceReference)
 (vecco:=FactorySemantics.co_for S._Int32Vect2)(nedco:=FactorySemantics.co_for S._NedCoor_i)
 (igetter:=S._stateGetPositionNed_i)(bgetter:=fb).
 - exact ENV.
 - exact ERRN.
 - exact ERRSYM.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_field.
 - p_field.
 - p_field.
 - p_field.
 - eapply raw_deref_complete with(ch:=Mint64);[reflexivity|reflexivity|exact PTR].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact REF].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact MEASURED].
 - reflexivity.
 - apply raw_int_store_complete;exact STORE.
 - exact GETN.
 - exact GETSYM.
 - exact GETFUN.
 - reflexivity.
 - intros base IS.
   eapply original_position_getter_certificate with(co:=FactorySemantics.co_for S._State)(flags:=flags)(delta:=100);
   [exact STATE|p_cenv|p_field|p_field|exact FLAGS|exact VALID|exact IS].
Qed.
Print Assumptions original_position_x_store_certificate.

Theorem original_position_y_store_certificate:forall e m mf bg gh pb sb reference measured flags k,
 e!S._gh=Some(bg,tptr gh_type) ->e!S._guidance_pid_pos_err=None ->e!S._stateGetPositionNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some pb ->Genv.find_symbol E.ge S._state=Some sb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Mem.load Mint32 m gh 48=Some(Vint reference) ->
 Mem.load Mint32 m sb 104=Some(Vint measured) ->
 Mem.load Mint16unsigned m sb 2=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.store Mint32 m pb 4(Vint(Int.sub reference measured))=Some mf ->
 exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos(original_position_assignment S._y)k e m).
Proof.
 intros e m mf bg gh pb sb reference measured flags k ENV ERRN GETN ERRSYM STATE PTR REF MEASURED FLAGS VALID STORE.
 destruct concrete_position_getter_target as[fb[GETSYM GETFUN]].
 eapply GetterAssignmentComplete.original_getter_assignment_certificate with
 (ge:=E.ge)(caller:=S.f_guidance_pid_h_run_pos)(leaf:=S.f_stateGetPositionNed_i)
 (ghid:=S._HorizontalGuidance)(refid:=S._HorizontalGuidanceReference)(vectid:=S._Int32Vect2)(nedid:=S._NedCoor_i)
 (axis:=S._y)(iref:=S._ref)(icomponent:=S._pos)(ierr:=S._guidance_pid_pos_err)(igh:=S._gh)
 (berr:=pb)(bparam:=bg)(bgh:=gh)(bcache:=sb)(dref:=44)(dcomponent:=0)(daxis:=4)
 (cacheofs:=Ptrofs.repr 100)(reference:=reference)(measured:=measured)(difference:=Int.sub reference measured)
 (ghco:=FactorySemantics.co_for S._HorizontalGuidance)
 (refco:=FactorySemantics.co_for S._HorizontalGuidanceReference)
 (vecco:=FactorySemantics.co_for S._Int32Vect2)(nedco:=FactorySemantics.co_for S._NedCoor_i)
 (igetter:=S._stateGetPositionNed_i)(bgetter:=fb).
 - exact ENV.
 - exact ERRN.
 - exact ERRSYM.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_field.
 - p_field.
 - p_field.
 - p_field.
 - eapply raw_deref_complete with(ch:=Mint64);[reflexivity|reflexivity|exact PTR].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact REF].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact MEASURED].
 - reflexivity.
 - apply raw_int_store_complete;exact STORE.
 - exact GETN.
 - exact GETSYM.
 - exact GETFUN.
 - reflexivity.
 - intros base IS.
   eapply original_position_getter_certificate with(co:=FactorySemantics.co_for S._State)(flags:=flags)(delta:=100);
   [exact STATE|p_cenv|p_field|p_field|exact FLAGS|exact VALID|exact IS].
Qed.
Print Assumptions original_position_y_store_certificate.

Theorem original_speed_x_store_certificate:forall e m mf bg gh pb sb reference measured flags k,
 e!S._gh=Some(bg,tptr gh_type) ->e!S._guidance_pid_speed_err=None ->e!S._stateGetSpeedNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some pb ->Genv.find_symbol E.ge S._state=Some sb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Mem.load Mint32 m gh 52=Some(Vint reference) ->
 Mem.load Mint32 m sb 296=Some(Vint measured) ->
 Mem.load Mint16unsigned m sb 280=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.store Mint32 m pb 0(Vint(Int.sub reference measured))=Some mf ->
 exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos(original_speed_assignment S._x)k e m).
Proof.
 intros e m mf bg gh pb sb reference measured flags k ENV ERRN GETN ERRSYM STATE PTR REF MEASURED FLAGS VALID STORE.
 destruct concrete_speed_getter_target as[fb[GETSYM GETFUN]].
 eapply GetterAssignmentComplete.original_getter_assignment_certificate with
 (ge:=E.ge)(caller:=S.f_guidance_pid_h_run_pos)(leaf:=S.f_stateGetSpeedNed_i)
 (ghid:=S._HorizontalGuidance)(refid:=S._HorizontalGuidanceReference)(vectid:=S._Int32Vect2)(nedid:=S._NedCoor_i)
 (axis:=S._x)(iref:=S._ref)(icomponent:=S._speed)(ierr:=S._guidance_pid_speed_err)(igh:=S._gh)
 (berr:=pb)(bparam:=bg)(bgh:=gh)(bcache:=sb)(dref:=44)(dcomponent:=8)(daxis:=0)
 (cacheofs:=Ptrofs.repr 296)(reference:=reference)(measured:=measured)(difference:=Int.sub reference measured)
 (ghco:=FactorySemantics.co_for S._HorizontalGuidance)
 (refco:=FactorySemantics.co_for S._HorizontalGuidanceReference)
 (vecco:=FactorySemantics.co_for S._Int32Vect2)(nedco:=FactorySemantics.co_for S._NedCoor_i)
 (igetter:=S._stateGetSpeedNed_i)(bgetter:=fb).
 - exact ENV.
 - exact ERRN.
 - exact ERRSYM.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_field.
 - p_field.
 - p_field.
 - p_field.
 - eapply raw_deref_complete with(ch:=Mint64);[reflexivity|reflexivity|exact PTR].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact REF].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact MEASURED].
 - reflexivity.
 - apply raw_int_store_complete;exact STORE.
 - exact GETN.
 - exact GETSYM.
 - exact GETFUN.
 - reflexivity.
 - intros base IS.
   eapply original_speed_getter_certificate with(co:=FactorySemantics.co_for S._State)(flags:=flags)(statusofs:=280)(delta:=296);
   [exact STATE|p_cenv|p_field|p_field|exact FLAGS|exact VALID|exact IS].
Qed.
Print Assumptions original_speed_x_store_certificate.

Theorem original_speed_y_store_certificate:forall e m mf bg gh pb sb reference measured flags k,
 e!S._gh=Some(bg,tptr gh_type) ->e!S._guidance_pid_speed_err=None ->e!S._stateGetSpeedNed_i=None ->
 Genv.find_symbol E.ge S._guidance_pid_speed_err=Some pb ->Genv.find_symbol E.ge S._state=Some sb ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Mem.load Mint32 m gh 56=Some(Vint reference) ->
 Mem.load Mint32 m sb 300=Some(Vint measured) ->
 Mem.load Mint16unsigned m sb 280=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 Mem.store Mint32 m pb 4(Vint(Int.sub reference measured))=Some mf ->
 exists P,certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos(original_speed_assignment S._y)k e m).
Proof.
 intros e m mf bg gh pb sb reference measured flags k ENV ERRN GETN ERRSYM STATE PTR REF MEASURED FLAGS VALID STORE.
 destruct concrete_speed_getter_target as[fb[GETSYM GETFUN]].
 eapply GetterAssignmentComplete.original_getter_assignment_certificate with
 (ge:=E.ge)(caller:=S.f_guidance_pid_h_run_pos)(leaf:=S.f_stateGetSpeedNed_i)
 (ghid:=S._HorizontalGuidance)(refid:=S._HorizontalGuidanceReference)(vectid:=S._Int32Vect2)(nedid:=S._NedCoor_i)
 (axis:=S._y)(iref:=S._ref)(icomponent:=S._speed)(ierr:=S._guidance_pid_speed_err)(igh:=S._gh)
 (berr:=pb)(bparam:=bg)(bgh:=gh)(bcache:=sb)(dref:=44)(dcomponent:=8)(daxis:=4)
 (cacheofs:=Ptrofs.repr 296)(reference:=reference)(measured:=measured)(difference:=Int.sub reference measured)
 (ghco:=FactorySemantics.co_for S._HorizontalGuidance)
 (refco:=FactorySemantics.co_for S._HorizontalGuidanceReference)
 (vecco:=FactorySemantics.co_for S._Int32Vect2)(nedco:=FactorySemantics.co_for S._NedCoor_i)
 (igetter:=S._stateGetSpeedNed_i)(bgetter:=fb).
 - exact ENV.
 - exact ERRN.
 - exact ERRSYM.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_cenv.
 - p_field.
 - p_field.
 - p_field.
 - p_field.
 - eapply raw_deref_complete with(ch:=Mint64);[reflexivity|reflexivity|exact PTR].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact REF].
 - eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|exact MEASURED].
 - reflexivity.
 - apply raw_int_store_complete;exact STORE.
 - exact GETN.
 - exact GETSYM.
 - exact GETFUN.
 - reflexivity.
 - intros base IS.
   eapply original_speed_getter_certificate with(co:=FactorySemantics.co_for S._State)(flags:=flags)(statusofs:=280)(delta:=296);
   [exact STATE|p_cenv|p_field|p_field|exact FLAGS|exact VALID|exact IS].
Qed.
Print Assumptions original_speed_y_store_certificate.
