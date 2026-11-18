From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceEntry Require Import BigstepSupport EffectfulSupport.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics ReturnSemantics.
From PidPositionTranslationAttempt002 Require Import FrontSemantics.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent FactorySemantics.ge.
Local Opaque E.ge.
Definition entry_return_assignment:=match after_front with Ssequence a _=>a|_=>Sskip end.
Definition entry_return_lvalue:=match entry_return_assignment with Sdo(Eassign l _ _)=>l|_=>Eval Vundef tvoid end.
Definition entry_return_rvalue:=match entry_return_assignment with Sdo(Eassign _ r _)=>r|_=>Eval Vundef tvoid end.
Definition entry_core_call:=match entry_return_rvalue with Ecomma a _ _=>a|_=>Eval Vundef tvoid end.
Definition entry_core_function:=match entry_core_call with Ecall f _ _=>f|_=>Eval Vundef tvoid end.
Definition entry_core_args:=match entry_core_call with Ecall _ args _=>args|_=>Enil end.
Definition entry_core_result:=match entry_return_rvalue with Ecomma _ a _=>a|_=>Eval Vundef tvoid end.
Ltac ert_rv LR LF LG LC NC SC :=
 lazymatch goal with
 | |-eval_simple_rvalue _ _ _(Eval _ _)_=>constructor
 | |-eval_simple_rvalue _ _ _(Eaddrof _ _)_=>apply esr_addrof;ert_lv LR LF LG LC NC SC
 | |-eval_simple_rvalue _ _ _(Evalof ?l ?ty)_=>
   let mode:=eval hnf in(access_mode ty)in
   lazymatch mode with
   | By_copy=>eapply esr_rvalof;[ert_lv LR LF LG LC NC SC|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]
   | By_reference=>eapply esr_rvalof;[ert_lv LR LF LG LC NC SC|reflexivity|reflexivity|apply deref_loc_reference;reflexivity]
   | By_value ?ch=>eapply read_scalar with(chunk:=ch);
     [ert_lv LR LF LG LC NC SC|reflexivity|reflexivity|reflexivity|
      lazymatch goal with |-Mem.loadv ?c ?mm(Vptr ?bb ?oo)=Some ?vv=>
      change(Mem.load c mm bb 0=Some vv);eassumption end]
   end
 end
with ert_lv LR LF LG LC NC SC :=
 lazymatch goal with
 | |-eval_simple_lvalue _ _ _(Evar ?id _)_ _ _=>
   lazymatch id with
   | S.__res=>eapply esl_var_local;exact LR
   | S._in_flight=>eapply esl_var_local;exact LF
   | S._gh=>eapply esl_var_local;exact LG
   | S.__res__1=>eapply esl_var_local;exact LC
   | S._guidance_pid_h_run=>eapply esl_var_global;[exact NC|exact SC]
   end
 | |-eval_simple_lvalue _ _ _(Ederef _ _)_ _ _=>eapply esl_deref;ert_rv LR LF LG LC NC SC
 end.
Ltac unfold_entry_return :=
 unfold entry_core_function,entry_core_args,entry_core_call,entry_core_result,
 entry_return_lvalue,entry_return_rvalue,entry_return_assignment,after_front;
 cbn[S.f_guidance_pid_h_run_pos fn_body].

Theorem original_entry_return_tail : forall e m mc br bf bg temp funb gh ret(flight:bool)x y heading,
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
 Mem.range_perm m temp 0 36 Cur Writable ->Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf bytes,
 Cstrategy.exec_stmt E.ge e m after_front E0 mf(Out_return None) /\
 active_fields mf ret x y heading /\access_preserved m mf /\
 Mem.loadbytes mc temp 0 36=Some bytes /\Mem.storebytes mc ret 0 bytes=Some mf.
Proof.
 intros e m mc br bf bg temp funb gh ret flight x y heading
 LR LF LG LC NC SC FC DIFFERENT RES RESC FLIGHT GH CALL ACTIVE KEEP WT WR.
 assert(READTEMP:Mem.range_perm mc temp 0 36 Cur Readable).
 { eapply access_preserved_byte_range;[exact KEEP|].
   intros z ZR;eapply Mem.perm_implies;[apply WT;exact ZR|constructor]. }
 destruct(Mem.range_perm_loadbytes mc temp 0 36 READTEMP)as[bytes BYTES].
 assert(LEN:Z.of_nat(length bytes)=36).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ BYTES)as L;rewrite L;reflexivity. }
 assert(WRMC:Mem.range_perm mc ret 0 36 Cur Writable)by(eapply access_preserved_byte_range;eauto).
 destruct(Mem.range_perm_storebytes mc ret 0 bytes ltac:(rewrite LEN;exact WRMC))as[mf COPY].
 assert(RF:eval_simple_rvalue E.ge e m entry_core_function(Vptr funb Ptrofs.zero)).
 { unfold_entry_return;ert_rv LR LF LG LC NC SC. }
 assert(ARGS:eval_simple_list E.ge e m entry_core_args
 [tptr sp_type;tbool;tptr gh_type]
 [Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]).
 { unfold_entry_return.
   eapply esrl_cons;[ert_rv LR LF LG LC NC SC|reflexivity|].
   eapply esrl_cons;[ert_rv LR LF LG LC NC SC|destruct flight;reflexivity|].
   eapply esrl_cons;[ert_rv LR LF LG LC NC SC|reflexivity|constructor]. }
 assert(CALL_EXPR:eval_expr E.ge e m RV entry_core_call E0 mc(Eval Vundef tvoid)).
 { unfold entry_core_call at 1.
   eapply simple_call_expr with(vf:=Vptr funb Ptrofs.zero)
   (vargs:=[Vptr temp Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero])
   (fd:=Internal S.f_guidance_pid_h_run).
   - exact RF.
   - reflexivity.
   - exact ARGS.
   - reflexivity.
   - reflexivity.
   - exact FC.
   - reflexivity.
   - exact CALL. }
 assert(RHS:eval_expr E.ge e m RV entry_return_rvalue E0 mc entry_core_result).
 { unfold entry_return_rvalue at 1;cbn[entry_return_assignment after_front S.f_guidance_pid_h_run_pos fn_body].
   replace E0 with(E0**E0)by reflexivity;eapply eval_comma.
   - exact CALL_EXPR.
   - constructor.
   - eapply(proj1(simple_eval_expr_refl E.ge e mc));[unfold_entry_return;ert_rv LR LF LG LC NC SC|reflexivity].
   - reflexivity. }
 exists mf,bytes;split.
 - unfold after_front;cbn[S.f_guidance_pid_h_run_pos fn_body].
   eapply sequence_normal;[|constructor].
   eapply effectful_assign with(mr:=mc)(r':=entry_core_result)(v:=Vptr temp Ptrofs.zero)(vc:=Vptr temp Ptrofs.zero).
   + ert_lv LR LF LG LC NC SC.
   + reflexivity.
   + exact RHS.
   + ert_lv LR LF LG LC NC SC.
   + unfold_entry_return;ert_rv LR LF LG LC NC SC.
   + reflexivity.
   + eapply assign_loc_copy with(bytes:=bytes).
     * reflexivity.
     * change(4|0);exists 0;reflexivity.
     * change(4|0);exists 0;reflexivity.
     * left;exact DIFFERENT.
     * change(Mem.loadbytes mc temp 0 36=Some bytes);exact BYTES.
     * exact COPY.
   + reflexivity.
 - split.
   + unfold active_fields in *;destruct ACTIVE as[L0[L4[L8[L12[L16[L24[L28 L32]]]]]]];repeat split;
     match goal with |-Mem.load Mint32 _ _ ?o=Some ?v=>
      replace o with(0+o)by lia;eapply copy_typed_load;
      [exact BYTES|exact COPY|eassumption|lia|change(o+4<=36);lia|change(4|0+o);exists(o/4);reflexivity]end.
   + split.
     * intros ch b ofs p VA;split.
       -- intros z ZR;eapply Mem.perm_storebytes_1;[exact COPY|exact(proj1(KEEP _ _ _ _ VA)z ZR)].
       -- exact(proj2 VA).
     * split;assumption.
Qed.
Lemma returning_statement_original_path : forall ge e f s m mf final k,
 Cstrategy.exec_stmt ge e m s E0 mf(Out_return None) ->
 Mem.free_list mf(blocks_of_env ge e)=Some final ->
 star Csem.step ge(State f s k e m)E0(Returnstate Vundef(call_cont k)final).
Proof.
 intros ge e f s m mf final k EXEC FREE.
 destruct(Cstrategy.exec_stmt_to_steps ge e m s E0 mf(Out_return None)EXEC f k)as[reached[PATH END]].
 inversion END;subst.
 eapply star_trans with(t1:=E0)(t2:=E0);[apply strategy_star_csem;exact PATH| |reflexivity].
 apply star_one;right;rewrite<-H;apply step_return_0;exact FREE.
Qed.
Print Assumptions original_entry_return_tail.
