From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport EffectfulSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail ControllerPrefix.
From PidPositionSafety Require Import FactoryCall.
From PidPositionTranslationCore Require Import MemoryShape FactoryShape.
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
Theorem original_core_return_shape_tail:forall e m br temp bp bh bf ret h heading x y,
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
 exists mf,exec_stmt ge e m core_return_tail E0 mf(Out_return None) /\
 stack_shape m mf 4%nat /\
 active_fields mf ret x y heading /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>temp ->b<>ret ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b ->b<>temp ->b<>ret ->0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros e m br temp bp bh bf ret h heading x y LR LC NP SP NH SH NF SF FF DRT DTR RES HEAD CAST LX LY RVS WT WR.
 destruct(original_factory_shape_funcall m bp temp(Ptrofs.repr 32)heading x y LX LY ltac:(change(4|32);exists 8;reflexivity)RVS WT)
 as[mc[CALL[FACTORYSHAPE[ACTIVE[KEEP[FRAME BFRAME]]]]]].
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
 assert(CALL_EXPR:eval_expr ge e m RV factory_call_expr E0 mc(Eval Vundef tvoid)).
 { unfold factory_call_expr at 1.
   eapply simple_call_expr with(vf:=Vptr bf Ptrofs.zero)(vargs:=[Vptr temp Ptrofs.zero;Vptr bp(Ptrofs.repr 32);Vint heading])
   (fd:=Internal S.f_stab_sp_from_ltp_i).
   - exact RF.
   - reflexivity.
   - exact ARGS.
   - reflexivity.
   - reflexivity.
   - exact FF.
   - reflexivity.
   - exact CALL. }
 assert(RHS:eval_expr ge e m RV return_rvalue E0 mc factory_result_expr).
 { unfold return_rvalue at 1;cbn[return_assignment core_return_tail drop_statements S.f_guidance_pid_h_run fn_body].
   replace E0 with(E0**E0)by reflexivity;eapply eval_comma.
   - exact CALL_EXPR.
   - constructor.
   - eapply(proj1(simple_eval_expr_refl ge e mc));[unfold factory_result_expr;cbn[return_rvalue return_assignment core_return_tail drop_statements S.f_guidance_pid_h_run fn_body];tail_rv LR LC NP SP NH SH NF SF|reflexivity].
   - reflexivity. }
 assert(TAILSHAPE:stack_shape m mf 4%nat).
 { destruct FACTORYSHAPE as[NB PERM];split.
   - erewrite Mem.nextblock_storebytes;[exact NB|exact COPY].
   - eapply same_permissions_trans;[exact PERM|].
     intros b0 z k0 p;split;[eapply Mem.perm_storebytes_2|eapply Mem.perm_storebytes_1];exact COPY. }
 exists mf;split.
 - unfold core_return_tail;cbn[drop_statements S.f_guidance_pid_h_run fn_body].
   eapply sequence_normal;[|constructor].
   eapply effectful_assign with(mr:=mc)(r':=factory_result_expr)(v:=Vptr temp Ptrofs.zero)(vc:=Vptr temp Ptrofs.zero).
   + tail_lv LR LC NP SP NH SH NF SF.
   + reflexivity.
   + exact RHS.
   + tail_lv LR LC NP SP NH SH NF SF.
   + unfold factory_result_expr;cbn[return_rvalue return_assignment core_return_tail drop_statements S.f_guidance_pid_h_run fn_body];tail_rv LR LC NP SP NH SH NF SF.
   + reflexivity.
   + eapply assign_loc_copy with(bytes:=bytes);[reflexivity|rewrite ge_ce;change(4|0);exists 0;reflexivity|rewrite ge_ce;change(4|0);exists 0;reflexivity|left;exact DTR|rewrite ge_ce;exact BYTES|exact COPY].
   + reflexivity.
 - split;[exact TAILSHAPE|].
   split.
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
Print Assumptions original_core_return_shape_tail.
