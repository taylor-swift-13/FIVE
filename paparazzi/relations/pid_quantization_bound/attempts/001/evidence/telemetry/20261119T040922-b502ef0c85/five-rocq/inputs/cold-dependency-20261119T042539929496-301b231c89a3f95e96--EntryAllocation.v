From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
From PidPositionSafety Require Import FactoryCall.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Notation ge:=FactorySemantics.ge.
Definition entry_declarations:=fn_params S.f_guidance_pid_h_run_pos++fn_vars S.f_guidance_pid_h_run_pos.
Record entry_setup(m:mem)(gh ret:block)(flight:bool):Type:={
 es_env:env;es_alloc:mem;es_body:mem;
 es_br:block;es_bf:block;es_bg:block;es_bs:block;
 es_allocation:alloc_variables ge empty_env m entry_declarations es_env es_alloc;
 es_binding:bind_parameters ge es_env es_alloc(fn_params S.f_guidance_pid_h_run_pos)(call_args gh ret flight)es_body;
 es_res_env:es_env!S.__res=Some(es_br,tptr sp_type);
 es_flight_env:es_env!S._in_flight=Some(es_bf,tbool);
 es_gh_env:es_env!S._gh=Some(es_bg,tptr gh_type);
 es_localret_env:es_env!S.__res__1=Some(es_bs,sp_type);
 es_separated:env_separated es_env;
 es_fresh:forall id b ty,es_env!id=Some(b,ty)->~Mem.valid_block m b;
 es_freeable:forall id b ty,es_env!id=Some(b,ty)->Mem.range_perm es_body b 0(sizeof ge ty)Cur Freeable;
 es_return_pointer:Mem.load Mint64 es_body es_br 0=Some(Vptr ret Ptrofs.zero);
 es_guidance_pointer:Mem.load Mint64 es_body es_bg 0=Some(Vptr gh Ptrofs.zero);
 es_flight_value:Mem.load Mbool es_body es_bf 0=Some(Vint(if flight then Int.one else Int.zero));
 es_old_load:forall ch b ofs v,Mem.load ch m b ofs=Some v ->Mem.load ch es_body b ofs=Some v;
 es_old_perm:forall b ofs k p,Mem.perm m b ofs k p->Mem.perm es_body b ofs k p;
 es_old_bytes:forall b ofs n,Mem.valid_block m b->0<=n->Mem.loadbytes es_body b ofs n=Mem.loadbytes m b ofs n
}.

Theorem original_entry_setup : forall m gh ret flight,exists setup:entry_setup m gh ret flight,True.
Proof.
 intros m gh ret flight.
 set(decl:=entry_declarations).
 assert(ND:NoDup(map fst decl))by(unfold decl,entry_declarations;repeat constructor;simpl;intuition discriminate).
 destruct(Cexec.do_alloc_variables ge empty_env m decl)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables ge empty_env m decl e ma).
 { pose proof(Cexec.do_alloc_variables_sound ge decl empty_env m)as A;rewrite ALLOC in A;exact A. }
 assert(ALL:forall id ty,In(id,ty)decl->exists b,
 e!id=Some(b,ty) /\~Mem.valid_block m b /\Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id ty IN;pose proof(allocated_variable ge decl empty_env m id ty ND IN)as A.
 rewrite ALLOC in A;destruct A as(b&L&FR&VB&RP);exists b;auto. }
 destruct(ALL S.__res(tptr sp_type)ltac:(unfold decl,entry_declarations;simpl;intuition congruence))as(br&LR&FR&PR).
 destruct(ALL S._in_flight tbool ltac:(unfold decl,entry_declarations;simpl;intuition congruence))as(bf&LF&FF&PF).
 destruct(ALL S._gh(tptr gh_type)ltac:(unfold decl,entry_declarations;simpl;intuition congruence))as(bg&LG&FG&PG).
 destruct(ALL S.__res__1 sp_type ltac:(unfold decl,entry_declarations;simpl;intuition congruence))as(bs&LS&FS&PS).
 assert(SEP:env_separated e).
 { pose proof(allocation_env_separated ge decl empty_env m
 ltac:(intros id b ty BAD;discriminate BAD)
 ltac:(intros id1 id2 b t1 t2 BAD;discriminate BAD))as A;rewrite ALLOC in A;exact A. }
 assert(FRESH:forall id b ty,e!id=Some(b,ty)->~Mem.valid_block m b).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
 destruct(ALL id ty IN)as(bx&L&FB&RP);rewrite LOOK in L;injection L as EQ;subst bx;exact FB. }
 assert(FREEA:forall id b ty,e!id=Some(b,ty)->Mem.range_perm ma b 0(sizeof ge ty)Cur Freeable).
 { intros id b ty LOOK;pose proof(allocated_environment_origin ge decl m e ma AV id b ty LOOK)as IN.
 destruct(ALL id ty IN)as(bx&L&FB&RP);rewrite LOOK in L;injection L as EQ;subst bx;exact RP. }
 assert(DRF:br<>bf)by(eapply environment_distinct;[exact SEP| |exact LR|exact LF];discriminate).
 assert(DRG:br<>bg)by(eapply environment_distinct;[exact SEP| |exact LR|exact LG];discriminate).
 assert(DFG:bf<>bg)by(eapply environment_distinct;[exact SEP| |exact LF|exact LG];discriminate).
 assert(AR:Mem.valid_access ma Mint64 br 0 Writable)by(apply zero_freeable_access;exact PR).
 destruct(Mem.valid_access_store ma Mint64 br 0(Vptr ret Ptrofs.zero)AR)as[mr SR].
 assert(AF:Mem.valid_access mr Mbool bf 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SR|apply zero_freeable_access;exact PF]. }
 destruct(Mem.valid_access_store mr Mbool bf 0(Vint(if flight then Int.one else Int.zero))AF)as[mv SF].
 assert(AG:Mem.valid_access mv Mint64 bg 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SF|];eapply Mem.store_valid_access_1;[exact SR|apply zero_freeable_access;exact PG]. }
 destruct(Mem.valid_access_store mv Mint64 bg 0(Vptr gh Ptrofs.zero)AG)as[mb SG].
 assert(BW:raw_writes(fun b=>b=br\/b=bf\/b=bg)ma mb).
 { eapply raw_writes_store;[left;reflexivity|exact SR|].
 eapply raw_writes_store;[right;left;reflexivity|exact SF|].
 eapply raw_writes_store;[right;right;reflexivity|exact SG|constructor]. }
 assert(BIND:bind_parameters ge e ma(fn_params S.f_guidance_pid_h_run_pos)(call_args gh ret flight)mb).
 { cbn[S.f_guidance_pid_h_run_pos fn_params call_args].
 eapply bind_parameters_cons;[exact LR| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|].
   unfold Mem.storev;rewrite Ptrofs.unsigned_zero,zle_true;[exact SR|change(0+8<=18446744073709551616);lia].
 - eapply bind_parameters_cons;[exact LF| |].
   + eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero,zle_true;[exact SF|change(0+1<=18446744073709551616);lia].
   + eapply bind_parameters_cons;[exact LG| |constructor].
     eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero,zle_true;[exact SG|change(0+8<=18446744073709551616);lia]. }
 assert(LPR:Mem.load Mint64 mb br 0=Some(Vptr ret Ptrofs.zero)).
 { erewrite Mem.load_store_other by(exact SG||(left;congruence)).
 erewrite Mem.load_store_other by(exact SF||(left;congruence)).
 erewrite Mem.load_store_same by exact SR;reflexivity. }
 assert(LPG:Mem.load Mint64 mb bg 0=Some(Vptr gh Ptrofs.zero)).
 { erewrite Mem.load_store_same by exact SG;reflexivity. }
 assert(LPF:Mem.load Mbool mb bf 0=Some(Vint(if flight then Int.one else Int.zero))).
 { erewrite Mem.load_store_other by(exact SG||(left;congruence)).
 erewrite Mem.load_store_same by exact SF;destruct flight;reflexivity. }
 assert(OLDOUT:forall b,Mem.valid_block m b->~(b=br\/b=bf\/b=bg)).
 { intros b VB[EQ|[EQ|EQ]];subst;contradiction. }
 refine(ex_intro _ {|es_env:=e;es_alloc:=ma;es_body:=mb;es_br:=br;es_bf:=bf;es_bg:=bg;es_bs:=bs;
 es_allocation:=AV;es_binding:=BIND;es_res_env:=LR;es_flight_env:=LF;es_gh_env:=LG;es_localret_env:=LS;
 es_separated:=SEP;es_fresh:=FRESH;es_return_pointer:=LPR;es_guidance_pointer:=LPG;es_flight_value:=LPF|} I).
 - intros;apply(raw_writes_range _ _ _ BW);eapply FREEA;eauto.
 - intros ch b ofs v LOAD.
   rewrite(raw_writes_load_frame _ _ _ BW)by(apply OLDOUT;eapply loaded_block;exact LOAD).
   pose proof(allocation_load ge decl empty_env m ch b ofs v LOAD)as A;rewrite ALLOC in A;exact A.
 - intros b ofs k p PERM.
   apply(proj1(raw_writes_perm _ _ _ BW b ofs k p)).
   pose proof(allocation_perm ge decl empty_env m b ofs k p PERM)as A;rewrite ALLOC in A;exact A.
 - intros b ofs n VB NN.
   rewrite(raw_writes_bytes_frame _ _ _ BW)by(first[exact NN|apply OLDOUT;exact VB]).
   pose proof(allocation_bytes_frame ge decl empty_env m b ofs n VB)as A;rewrite ALLOC in A;exact A.
Qed.
Print Assumptions original_entry_setup.
