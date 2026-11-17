From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport EffectfulSupport.
From FiveGuidanceAllOrder Require Import PureDenotation PhaseComposition.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
From PidPositionSafety Require Import PureSound HiddenResultPre HiddenResultComplete.
From PidPositionTranslationAttempt002 Require Import FrontSemantics EntryReturn.
From PidPositionTranslationAttempt002 Require Import HiddenResultArithmetic.
From CoreCBMC Require Import ArithmeticHiddenPre ArithmeticTree ArithmeticArguments ArithmeticObservation.

Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.

Theorem original_entry_tail_core_arithmetic_certificate :
 forall e m mc br bf bg temp funb gh ret(flight:bool)x y heading k,
 e!S.__res=Some(br,tptr sp_type) ->e!S._in_flight=Some(bf,tbool) ->
 e!S._gh=Some(bg,tptr gh_type) ->e!S.__res__1=Some(temp,sp_type) ->
 e!S._guidance_pid_h_run=None ->
 Genv.find_symbol E.ge S._guidance_pid_h_run=Some funb ->
 Genv.find_funct E.ge(Vptr funb Ptrofs.zero)=Some(Internal S.f_guidance_pid_h_run) ->
 temp<>ret ->
 Mem.load Mint64 m br 0=Some(Vptr ret Ptrofs.zero) ->
 Mem.load Mint64 mc br 0=Some(Vptr ret Ptrofs.zero) ->
 Mem.load Mbool m bf 0=Some(Vint(if flight then Int.one else Int.zero)) ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Cstrategy.eval_funcall E.ge m(Internal S.f_guidance_pid_h_run)
 [Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]E0 mc Vundef ->
 active_fields mc temp x y heading ->
 access_preserved m mc ->
 Mem.range_perm m temp 0 36 Cur Writable ->
 Mem.range_perm m ret 0 36 Cur Writable ->
 (forall base,is_call_cont base ->
   exists P,certificate E.ge P(Returnstate Vundef base mc) /\
   P(Callstate(Internal S.f_guidance_pid_h_run)
     [Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]base m) /\
   (forall s,P s->arithmetic_observation E.ge S.f_guidance_pid_h_run s)) ->
 exists mf P bytes,
 certificate E.ge P(State S.f_guidance_pid_h_run_pos Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run_pos entry_return_assignment k e m) /\
 (forall s,P s->arithmetic_observation E.ge S.f_guidance_pid_h_run s) /\
 Cstrategy.exec_stmt E.ge e m after_front E0 mf(Out_return None) /\
 active_fields mf ret x y heading /\access_preserved m mf /\
 Mem.loadbytes mc temp 0 36=Some bytes /\Mem.storebytes mc ret 0 bytes=Some mf.
Proof.
 intros e m mc br bf bg temp funb gh ret flight x y heading k
 LR LF LG LC NC SC FC DIFFERENT RES RESC FLIGHT GH CALL ACTIVE KEEP WT WR CAL.
 destruct(original_entry_return_tail e m mc br bf bg temp funb gh ret flight x y heading
 LR LF LG LC NC SC FC DIFFERENT RES RESC FLIGHT GH CALL ACTIVE KEEP WT WR)
 as[mf[bytes[EXEC[ACT[KP[BYTES COPY]]]]]].
 assert(RF:eval_simple_rvalue E.ge e m entry_core_function(Vptr funb Ptrofs.zero)).
 { unfold_entry_return;ert_rv LR LF LG LC NC SC. }
 assert(ARGS:eval_simple_list E.ge e m entry_core_args
 [tptr sp_type;tbool;tptr gh_type]
 [Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]).
 { unfold_entry_return.
   eapply esrl_cons;[ert_rv LR LF LG LC NC SC|reflexivity|].
   eapply esrl_cons;[ert_rv LR LF LG LC NC SC|destruct flight;reflexivity|].
   eapply esrl_cons;[ert_rv LR LF LG LC NC SC|reflexivity|constructor]. }
 assert(D0:Cexec.do_deref_loc E.ge quiet_world(tptr sp_type)m br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero)).
 { apply Cexec.do_deref_loc_complete;[|constructor].
   eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;
   [exact RES|change(0+8<=18446744073709551616);lia]. }
 assert(D1:Cexec.do_deref_loc E.ge quiet_world(tptr sp_type)mc br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero)).
 { apply Cexec.do_deref_loc_complete;[|constructor].
   eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;
   [exact RESC|change(0+8<=18446744073709551616);lia]. }
 assert(POST:eval_simple_rvalue E.ge e mc entry_core_result(Vptr temp Ptrofs.zero)).
 { unfold_entry_return;ert_rv LR LF LG LC NC SC. }
 assert(PV:pure_rval E.ge e mc entry_core_result=Some(Vptr temp Ptrofs.zero)).
 { apply(proj1(simple_big_denotation E.ge e mc));[exact POST|reflexivity]. }
 assert(COPYA:Cexec.do_assign_loc E.ge quiet_world sp_type mc ret Ptrofs.zero Full(Vptr temp Ptrofs.zero)=
 Some(quiet_world,E0,mf,Vptr temp Ptrofs.zero)).
 { apply Cexec.do_assign_loc_complete;[|constructor].
   eapply assign_loc_copy with(bytes:=bytes).
   - reflexivity.
   - change(4|0);exists 0;reflexivity.
   - change(4|0);exists 0;reflexivity.
   - left;exact DIFFERENT.
   - change(Mem.loadbytes mc temp 0 36=Some bytes);exact BYTES.
   - exact COPY. }
 assert(PREP:ArithmeticHiddenPre.prepared E.ge e m[tptr sp_type;tbool;tptr gh_type]
 {|cc_vararg:=None;cc_unproto:=false;cc_structret:=true|}
 (Vptr funb Ptrofs.zero)
 [Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]
 entry_core_function entry_core_args).
 { constructor;[reflexivity|reflexivity|exact RF|exact ARGS|reflexivity|exact I|exact (conj I (conj I (conj I I)))]. }
 destruct(hidden_result_arithmetic_certificate E.ge S.f_guidance_pid_h_run_pos S.f_guidance_pid_h_run S.f_guidance_pid_h_run e k
 m mc mf S._StabilizationSetpoint S.__res br ret[tptr sp_type;tbool;tptr gh_type]
 {|cc_vararg:=None;cc_unproto:=false;cc_structret:=true|}
 (Vptr funb Ptrofs.zero)
 [Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]
 entry_core_function entry_core_args entry_core_result(Vptr temp Ptrofs.zero)
 (Vptr temp Ptrofs.zero)(Vptr temp Ptrofs.zero)
 LR D0 D1 FC eq_refl PREP eq_refl eq_refl I PV eq_refl COPYA CAL)
 as[P[CERT[IN OBS]]].
 exists mf,P,bytes;split;[exact CERT|];split;[exact IN|];split;[exact OBS|].
 exact(conj EXEC(conj ACT(conj KP(conj BYTES COPY)))).
Qed.
Print Assumptions original_entry_tail_core_arithmetic_certificate.
