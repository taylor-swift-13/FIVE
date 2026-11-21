From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport EffectfulSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail ControllerPrefix.
From PidPositionSafety Require Import FactoryCall FactoryAllOrder PureSound HiddenResultPre HiddenResultComplete.
From FiveGuidanceAllOrder Require Import PureDenotation PhaseComposition ContinuationLift.
From PidPositionTranslationAttempt002 Require Import HiddenResultObserved HiddenResultScope.
From PidPositionSafety Require Import TaggedCallee.
Import ListNotations.
Open Scope Z_scope.
Definition core_return_tail:=drop_statements 8(fn_body S.f_guidance_pid_h_run).
Definition return_assignment:=match core_return_tail with Ssequence a _=>a|_=>Sskip end.
Definition return_lvalue:=match return_assignment with Sdo(Eassign l _ _)=>l|_=>Eval Vundef tvoid end.
Definition return_rvalue:=match return_assignment with Sdo(Eassign _ r _)=>r|_=>Eval Vundef tvoid end.
Definition factory_call_expr:=match return_rvalue with Ecomma a _ _=>a|_=>Eval Vundef tvoid end.
Definition factory_function_expr:=match factory_call_expr with Ecall f _ _=>f|_=>Eval Vundef tvoid end.
Definition factory_args_expr:=match factory_call_expr with Ecall _ args _=>args|_=>Enil end.
Definition factory_result_expr:=match return_rvalue with Ecomma _ a _=>a|_=>Eval Vundef tvoid end.
Ltac tail_rv LR LC NP SP NH SH NF SF :=
 lazymatch goal with
 | |-eval_simple_rvalue _ _ _(Eval _ _)_=>constructor
 | |-eval_simple_rvalue _ _ _(Ebinop _ _ _ _)_=>eapply esr_binop;[tail_rv LR LC NP SP NH SH NF SF|tail_rv LR LC NP SP NH SH NF SF|reflexivity]
 | |-eval_simple_rvalue _ _ _(Eaddrof _ _)_=>apply esr_addrof;tail_lv LR LC NP SP NH SH NF SF
 | |-eval_simple_rvalue _ _ _(Evalof ?l ?ty)_=>
   let mode:=eval hnf in(access_mode ty)in
   lazymatch mode with
   | By_copy=>eapply esr_rvalof;[tail_lv LR LC NP SP NH SH NF SF|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]
   | By_reference=>eapply esr_rvalof;[tail_lv LR LC NP SP NH SH NF SF|reflexivity|reflexivity|apply deref_loc_reference;reflexivity]
   | By_value ?ch=>eapply read_scalar with(chunk:=ch);
      [tail_lv LR LC NP SP NH SH NF SF|reflexivity|reflexivity|reflexivity|raw_scalar_load]
   end
 end
with tail_lv LR LC NP SP NH SH NF SF :=
 lazymatch goal with
 | |-eval_simple_lvalue _ _ _(Evar ?id _)_ _ _=>
   lazymatch id with
   | S.__res=>eapply esl_var_local;exact LR
   | S.__res__1=>eapply esl_var_local;exact LC
   | S._guidance_pid=>eapply esl_var_global;[exact NP|exact SP]
   | S._guidance_h=>eapply esl_var_global;[exact NH|exact SH]
   | S._stab_sp_from_ltp_i=>eapply esl_var_global;[exact NF|exact SF]
   end
 | |-eval_simple_lvalue _ _ _(Ederef _ _)_ _ _=>eapply esl_deref;tail_rv LR LC NP SP NH SH NF SF
 | |-eval_simple_lvalue _ _ _(Efield ?r _ _)_ _ _=>
   let rt:=eval cbv beta iota zeta delta[typeof]in(typeof r)in
   lazymatch rt with
   | Tstruct _ _=>eapply esl_field_struct;[tail_rv LR LC NP SP NH SH NF SF|reflexivity|cenv_lookup|cfield_lookup]
   | Tunion _ _=>eapply esl_field_union;[tail_rv LR LC NP SP NH SH NF SF|reflexivity|idtac|cenv_lookup];cfield_lookup
   end
 end.
Lemma access_preserved_byte_range:forall m mf b lo hi p,
 access_preserved m mf ->Mem.range_perm m b lo hi Cur p ->Mem.range_perm mf b lo hi Cur p.
Proof.
 intros m mf b lo hi p KEEP RANGE x X.
 assert(VA:Mem.valid_access m Mint8unsigned b x p).
 { split;[intros z ZR;apply RANGE;change(x<=z<x+1)in ZR;lia|change(1|x);exists x;lia]. }
 pose proof(KEEP _ _ _ _ VA)as[RP _];apply RP;change(x<=x<x+1);lia.
Qed.
Theorem original_factory_tail_scope_certificate:forall e m br temp bp bh bf ret h heading x y,
 e!S.__res=Some(br,tptr spty) ->e!S.__res__1=Some(temp,spty) ->
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!S._guidance_h=None ->Genv.find_symbol ge S._guidance_h=Some bh ->
 e!S._stab_sp_from_ltp_i=None ->Genv.find_symbol ge S._stab_sp_from_ltp_i=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal S.f_stab_sp_from_ltp_i) ->
 br<>temp ->temp<>ret ->
 Mem.load Mint64 m br 0=Some(Vptr ret Ptrofs.zero) ->
 Mem.load Mfloat32 m bh 28=Some(Vsingle h) ->
 sem_cast(Vsingle(Float32.mul h(Float32.of_int(Int.repr 4096))))tfloat tint m=Some(Vint heading) ->
 Mem.load Mint32 m bp 32=Some(Vint x) ->Mem.load Mint32 m bp 36=Some(Vint y) ->
 Mem.range_perm m bp 32 40 Cur Readable ->
 Mem.range_perm m temp 0 36 Cur Writable ->Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,(forall k,exists P,certificate ge P(State S.f_guidance_pid_h_run Sskip k e mf) /\
 P(State S.f_guidance_pid_h_run return_assignment k e m) /\
 (forall s,P s->function_scope S.f_guidance_pid_h_run s \/function_scope S.f_stab_sp_from_ltp_i s)) /\
 active_fields mf ret x y heading /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>temp ->b<>ret ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b ->b<>temp ->b<>ret ->0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros e m br temp bp bh bf ret h heading x y LR LC NP SP NH SH NF SF FF DRT DTR RES HEAD CAST LX LY RVS WT WR.
 destruct(original_factory_funcall m bp temp(Ptrofs.repr 32)heading x y LX LY ltac:(change(4|32);exists 8;reflexivity)RVS WT)
 as[mc[CALL[ACTIVE[KEEP[FRAME BFRAME]]]]].
 assert(VBR:Mem.valid_block m br)by(eapply loaded_block;exact RES).
 assert(RESC:Mem.load Mint64 mc br 0=Some(Vptr ret Ptrofs.zero))by(rewrite FRAME;auto).
 assert(READTEMP:Mem.range_perm mc temp 0 36 Cur Readable).
 { eapply access_preserved_byte_range;[exact KEEP|].
   intros z ZR;eapply Mem.perm_implies;[apply WT;exact ZR|constructor]. }
 destruct(Mem.range_perm_loadbytes mc temp 0 36 READTEMP)as[bytes BYTES].
 assert(LEN:Z.of_nat(length bytes)=36).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ BYTES)as L;rewrite L;reflexivity. }
 assert(WRMC:Mem.range_perm mc ret 0 36 Cur Writable)by(eapply access_preserved_byte_range;eauto).
 destruct(Mem.range_perm_storebytes mc ret 0 bytes ltac:(rewrite LEN;exact WRMC))as[mf COPY].
 assert(RF:eval_simple_rvalue ge e m factory_function_expr(Vptr bf Ptrofs.zero)).
 { unfold factory_function_expr,factory_call_expr,return_rvalue,return_assignment,core_return_tail;
   cbn[drop_statements S.f_guidance_pid_h_run fn_body];tail_rv LR LC NP SP NH SH NF SF. }
 assert(ARGS:eval_simple_list ge e m factory_args_expr
 [tptr spty;tptr vty;tint][Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading]).
 { unfold factory_args_expr,factory_call_expr,return_rvalue,return_assignment,core_return_tail;
   cbn[drop_statements S.f_guidance_pid_h_run fn_body].
   eapply esrl_cons;[tail_rv LR LC NP SP NH SH NF SF|reflexivity|].
   eapply esrl_cons;[tail_rv LR LC NP SP NH SH NF SF|reflexivity|].
   eapply esrl_cons with(v':=Vsingle(Float32.mul h(Float32.of_int(Int.repr 4096))));
   [tail_rv LR LC NP SP NH SH NF SF|exact CAST|constructor]. }
 exists mf;split.
 - intros k.
 assert(PATH:star Csem.step ge(Callstate(Internal S.f_stab_sp_from_ltp_i)
     [Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading]Kstop m)
     E0(Returnstate Vundef Kstop mc)).
 { apply funcall_original_normal;exact CALL. }
 assert(CAL:forall base,is_call_cont base ->exists P,
 certificate ge P(Returnstate Vundef base mc) /\
 P(Callstate(Internal S.f_stab_sp_from_ltp_i)
 [Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading]base m) /\
 (forall s,P s->function_scope S.f_stab_sp_from_ltp_i s)).
 { intros base BASE;exists(tagged_callee_invariant ge S.f_stab_sp_from_ltp_i base Vundef mc);split.
   - split;[intros s INV;eapply tagged_callee_progress;eauto|intros s t next INV NE STEP;eapply tagged_callee_successors;eauto].
   - split.
     + change(tagged_callee_invariant ge S.f_stab_sp_from_ltp_i base Vundef mc
       (plug_state base(Callstate(Internal S.f_stab_sp_from_ltp_i)
       [Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading]Kstop m))).
       eapply tagged_callee_entry;[apply factory_normal_syntax|apply factory_names|reflexivity|exact PATH].
     + intros s INV;apply tagged_callee_scope in INV;exact INV. }
 assert(D0:Cexec.do_deref_loc ge quiet_world(tptr spty)m br Ptrofs.zero Full=
   Some(quiet_world,E0,Vptr ret Ptrofs.zero)).
 { apply Cexec.do_deref_loc_complete;[|constructor].
   eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;
   [exact RES|change(0+8<=18446744073709551616);lia]. }
 assert(D1:Cexec.do_deref_loc ge quiet_world(tptr spty)mc br Ptrofs.zero Full=
   Some(quiet_world,E0,Vptr ret Ptrofs.zero)).
 { apply Cexec.do_deref_loc_complete;[|constructor].
   eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;
   [exact RESC|change(0+8<=18446744073709551616);lia]. }
 assert(POST:eval_simple_rvalue ge e mc factory_result_expr(Vptr temp Ptrofs.zero)).
 { unfold factory_result_expr;cbn[return_rvalue return_assignment core_return_tail drop_statements S.f_guidance_pid_h_run fn_body].
   tail_rv LR LC NP SP NH SH NF SF. }
 assert(PV:pure_rval ge e mc factory_result_expr=Some(Vptr temp Ptrofs.zero)).
 { apply(proj1(simple_big_denotation ge e mc));[exact POST|reflexivity]. }
 assert(COPYA:Cexec.do_assign_loc ge quiet_world spty mc ret Ptrofs.zero Full(Vptr temp Ptrofs.zero)=
   Some(quiet_world,E0,mf,Vptr temp Ptrofs.zero)).
 { apply Cexec.do_assign_loc_complete;[|constructor].
   eapply assign_loc_copy with(bytes:=bytes);[reflexivity|rewrite ge_ce;change(4|0);exists 0;reflexivity|rewrite ge_ce;change(4|0);exists 0;reflexivity|left;exact DTR|rewrite ge_ce;exact BYTES|exact COPY]. }
 assert(PREP:HiddenResultPre.prepared ge e m[tptr spty;tptr vty;tint]
  {|cc_vararg:=None;cc_unproto:=false;cc_structret:=true|}
  (Vptr bf Ptrofs.zero)[Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading]
  factory_function_expr factory_args_expr).
 { constructor;try reflexivity;[exact RF|exact ARGS]. }
 destruct(hidden_result_observed_certificate ge S.f_guidance_pid_h_run S.f_stab_sp_from_ltp_i e k
   m mc mf S._StabilizationSetpoint S.__res br ret[tptr spty;tptr vty;tint]
   {|cc_vararg:=None;cc_unproto:=false;cc_structret:=true|}
   (Vptr bf Ptrofs.zero)[Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading]
   factory_function_expr factory_args_expr factory_result_expr(Vptr temp Ptrofs.zero)
   (Vptr temp Ptrofs.zero)(Vptr temp Ptrofs.zero)
   LR D0 D1 FF eq_refl PREP eq_refl eq_refl PV eq_refl COPYA
   (fun s=>function_scope S.f_guidance_pid_h_run s\/function_scope S.f_stab_sp_from_ltp_i s))
   as[P[CERT[IN OBS]]].
   + intros base BASE;destruct(CAL base BASE)as[Q[CQ[IQ SQ]]].
     exists Q;split;[exact CQ|];split;[exact IQ|];intros s QS;right;apply SQ;exact QS.
   + left;reflexivity.
   + intros;left;reflexivity.
   + intros s INV;left;eapply hidden_post_function_scope;exact INV.
   + exists P;exact(conj CERT(conj IN OBS)).
 - split.
   + unfold active_fields in *;destruct ACTIVE as[L0[L4[L8[L12[L16[L24[L28 L32]]]]]]];repeat split.
     * replace 0 with(0+0)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L0|lia|change(0+4<=36);lia|change(4|0+0);exists 0;reflexivity].
     * replace 4 with(0+4)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L4|lia|change(4+4<=36);lia|change(4|0+4);exists 1;reflexivity].
     * replace 8 with(0+8)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L8|lia|change(8+4<=36);lia|change(4|0+8);exists 2;reflexivity].
     * replace 12 with(0+12)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L12|lia|change(12+4<=36);lia|change(4|0+12);exists 3;reflexivity].
     * replace 16 with(0+16)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L16|lia|change(16+4<=36);lia|change(4|0+16);exists 4;reflexivity].
     * replace 24 with(0+24)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L24|lia|change(24+4<=36);lia|change(4|0+24);exists 6;reflexivity].
     * replace 28 with(0+28)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L28|lia|change(28+4<=36);lia|change(4|0+28);exists 7;reflexivity].
     * replace 32 with(0+32)by lia;eapply copy_typed_load;[exact BYTES|exact COPY|exact L32|lia|change(32+4<=36);lia|change(4|0+32);exists 8;reflexivity].
   + split.
     * intros ch b ofs p VA;split.
       -- intros z ZR;eapply Mem.perm_storebytes_1;[exact COPY|exact(proj1(KEEP _ _ _ _ VA)z ZR)].
       -- exact(proj2 VA).
     * split.
       -- intros ch b ofs VB DT DR;erewrite Mem.load_storebytes_other by(exact COPY||(left;exact DR));apply FRAME;assumption.
       -- intros b ofs n VB DT DR N;erewrite Mem.loadbytes_storebytes_other by(exact COPY||lia||(left;exact DR));apply BFRAME;assumption.
Qed.

Print Assumptions original_factory_tail_scope_certificate.
