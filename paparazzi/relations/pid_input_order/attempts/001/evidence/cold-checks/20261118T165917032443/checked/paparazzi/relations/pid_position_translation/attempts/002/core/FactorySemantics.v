From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Cexec Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport FunctionAllocation.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory.
Import ListNotations.
Open Scope Z_scope.
Module S := PidPositionRunPos.Source.
Module E := PidPositionRunPos.Execution.
Definition ge := E.ge.
Lemma ge_ce : genv_cenv ge=ce.
Proof. unfold ge,E.ge,Csem.globalenv,ce. cbv beta iota zeta delta [genv_cenv]. reflexivity. Qed.
Global Opaque ge E.ge.
Definition spty := Tstruct S._StabilizationSetpoint noattr.
Definition vty := Tstruct S._Int32Vect2 noattr.

Definition zero_co : composite.
Proof.
 refine {| co_su:=Struct;co_members:=[];co_attr:=noattr;co_sizeof:=0;co_alignof:=1;co_rank:=O |}.
 - lia.
 - exists O;reflexivity.
 - exists 0;reflexivity.
Defined.
Definition co_for (id:ident) : composite := match PTree.get id ce with Some co=>co | None=>zero_co end.
Lemma co_for_lookup : forall id,
 (match PTree.get id ce with Some _=>true | None=>false end)=true ->
 PTree.get id ce=Some(co_for id).
Proof. intros id H;unfold co_for;destruct(PTree.get id ce);[reflexivity|discriminate]. Qed.
Ltac cenv_lookup := lazymatch goal with |- PTree.get ?id _ = Some ?co =>
 unify co (co_for id);rewrite ge_ce;apply co_for_lookup;vm_compute;reflexivity end.
Ltac cfield_lookup := rewrite ge_ce;vm_compute;reflexivity.
Ltac local_lvalue := eapply esl_var_local; eassumption.
Ltac simple_rv :=
 lazymatch goal with
 | |- eval_simple_rvalue _ _ _ (Eval _ _) _ => constructor
 | |- eval_simple_rvalue _ _ _ (Evalof ?l ?ty) _ =>
   let mode := eval hnf in (access_mode ty) in
   lazymatch mode with
   | By_copy=>eapply esr_rvalof;[simple_lv|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]
   | By_value ?ch=>eapply read_scalar with(chunk:=ch);
      [simple_lv|reflexivity|reflexivity|reflexivity|
       lazymatch goal with |- Mem.loadv ?c ?mm (Vptr ?bb ?oo)=Some ?vv =>
       let ox := eval vm_compute in (Ptrofs.unsigned oo) in
       change(Mem.load c mm bb ox=Some vv);eassumption end]
   end
 | |- eval_simple_rvalue _ _ _ (Eaddrof _ _) _ => apply esr_addrof;simple_lv
 end
with simple_lv :=
 lazymatch goal with
 | |- eval_simple_lvalue _ _ _ (Evar _ _) _ _ _ => local_lvalue
 | |- eval_simple_lvalue _ _ _ (Ederef _ _) _ _ _ => eapply esl_deref;simple_rv
 | |- eval_simple_lvalue _ _ _ (Efield ?r _ _) _ _ _ =>
   let rt := eval cbv beta iota zeta delta [typeof] in (typeof r) in
   lazymatch rt with
   | Tstruct _ _=>eapply esl_field_struct;[simple_rv|reflexivity|cenv_lookup|cfield_lookup]
   | Tunion _ _=>eapply esl_field_union;[simple_rv|reflexivity|idtac|cenv_lookup];cfield_lookup
   end
 end.
Ltac scalar_assignment STORE :=
 eapply atomic_assign;
 [simple_lv|reflexivity|simple_rv|reflexivity|reflexivity|
  eapply assign_loc_value;[reflexivity|reflexivity|exact STORE]|reflexivity].

Theorem original_factory_body : forall e br bv bh bs src ret o h
 m0 m1 m2 m3 m4 m5 m6 m7 m8 vecbytes spbytes,
 e!S.__res=Some(br,tptr spty) ->e!S._vect=Some(bv,tptr vty) ->
 e!S._heading=Some(bh,tint) ->e!S._sp=Some(bs,spty) ->
 Mem.load Mint64 m2 bv 0=Some(Vptr src o) ->
 Mem.load Mint32 m3 bh 0=Some(Vint h) ->
 Mem.load Mint64 m7 br 0=Some(Vptr ret Ptrofs.zero) ->
 (4 | Ptrofs.unsigned o) ->src<>bs ->ret<>bs ->
 Mem.store Mint32 m0 bs 0(Vint(Int.repr 2))=Some m1 ->
 Mem.store Mint32 m1 bs 4(Vint Int.zero)=Some m2 ->
 Mem.loadbytes m2 src(Ptrofs.unsigned o)8=Some vecbytes ->
 Mem.storebytes m2 bs 8 vecbytes=Some m3 ->
 Mem.store Mint32 m3 bs 16(Vint h)=Some m4 ->
 Mem.store Mint32 m4 bs 24(Vint Int.zero)=Some m5 ->
 Mem.store Mint32 m5 bs 28(Vint Int.zero)=Some m6 ->
 Mem.store Mint32 m6 bs 32(Vint Int.zero)=Some m7 ->
 Mem.loadbytes m7 bs 0 36=Some spbytes ->
 Mem.storebytes m7 ret 0 spbytes=Some m8 ->
 Cstrategy.exec_stmt ge e m0(fn_body S.f_stab_sp_from_ltp_i)E0 m8(Out_return None).
Proof.
 intros e br bv bh bs src ret o h m0 m1 m2 m3 m4 m5 m6 m7 m8 vecbytes spbytes
 LR LV LH LS LP PH PR OA DS DR T F V VC H P Q R BY COPY.
 cbn[S.f_stab_sp_from_ltp_i fn_body].
 eapply sequence_normal;[scalar_assignment T|].
 eapply sequence_normal;[scalar_assignment F|].
 eapply sequence_normal.
 - eapply atomic_assign.
   + simple_lv.
   + reflexivity.
   + eapply esr_rvalof.
     * eapply esl_deref.
       eapply read_scalar with(b:=bv)(ofs:=Ptrofs.zero)(chunk:=Mint64).
       -- local_lvalue.
       -- reflexivity.
       -- reflexivity.
       -- reflexivity.
       -- unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact LP|change(0+8<=18446744073709551616);lia].
     * reflexivity.
     * reflexivity.
     * apply deref_loc_copy;reflexivity.
   + reflexivity.
   + reflexivity.
   +
   eapply assign_loc_copy with(bytes:=vecbytes).
     * reflexivity.
     * exact OA.
     * rewrite ge_ce;change(4|8);exists 2;reflexivity.
     * left;exact DS.
     * rewrite ge_ce;exact V.
     * exact VC.
   + reflexivity.
 - eapply sequence_normal;[scalar_assignment H|].
   eapply sequence_normal;[scalar_assignment P|].
   eapply sequence_normal;[scalar_assignment Q|].
   eapply sequence_normal;[scalar_assignment R|].
   eapply sequence_normal.
   + eapply atomic_assign;
     [simple_lv|reflexivity|simple_rv|reflexivity|reflexivity| |reflexivity].
     eapply assign_loc_copy with(bytes:=spbytes).
     * reflexivity.
     * rewrite ge_ce;change(4|0);exists 0;reflexivity.
     * rewrite ge_ce;change(4|0);exists 0;reflexivity.
     * left;congruence.
     * rewrite ge_ce;exact BY.
     * exact COPY.
   + constructor.
Qed.
Print Assumptions original_factory_body.

Theorem original_factory_body_normal:forall e m br bv bh bs src ret o h x y,
 e!S.__res=Some(br,tptr spty) ->e!S._vect=Some(bv,tptr vty) ->
 e!S._heading=Some(bh,tint) ->e!S._sp=Some(bs,spty) ->
 br<>bs ->bv<>bs ->bh<>bs ->src<>bs ->ret<>bs ->
 Mem.load Mint64 m bv 0=Some(Vptr src o) ->
 Mem.load Mint32 m bh 0=Some(Vint h) ->
 Mem.load Mint64 m br 0=Some(Vptr ret Ptrofs.zero) ->
 Mem.load Mint32 m src(Ptrofs.unsigned o)=Some(Vint x) ->
 Mem.load Mint32 m src(Ptrofs.unsigned o+4)=Some(Vint y) ->
 (4|Ptrofs.unsigned o) ->
 Mem.range_perm m bs 0 36 Cur Writable ->
 Mem.range_perm m src(Ptrofs.unsigned o)(Ptrofs.unsigned o+8)Cur Readable ->
 Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,
 Cstrategy.exec_stmt ge e m(fn_body S.f_stab_sp_from_ltp_i)E0 mf(Out_return None) /\
 factory_trace m bs src ret o h mf /\ active_fields mf ret x y h /\
 raw_writes(fun b=>b=bs\/b=ret)m mf.
Proof.
 intros e m br bv bh bs src ret o h x y LR LV LH LS DR DV DH DS DRET LP PH PR LX LY OA WSP RV WR.
 destruct(factory_trace_exists m bs src ret o h WSP RV WR)as[mf TRACE].
 pose proof TRACE as TRACE0;destruct TRACE as(m1&m2&m3&m4&m5&m6&m7&vb&sb&T&F&V&VC&H&P&Q&R&BY&COPY).
 exists mf;split.
 - eapply original_factory_body with(src:=src)(ret:=ret)(o:=o)(h:=h)(br:=br)(bv:=bv)(bh:=bh)(bs:=bs)(m1:=m1)(m2:=m2)(m3:=m3)(m4:=m4)(m5:=m5)(m6:=m6)(m7:=m7)(vecbytes:=vb)(spbytes:=sb);eauto;
   scalar_frame;assumption.
 - split;[exact TRACE0|]. split.
   + eapply factory_trace_active;eauto.
   + eapply factory_trace_writes;exact TRACE0.
Qed.
Print Assumptions original_factory_body_normal.
