From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Ctypes Csyntax Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
From PidPositionSafety Require Import FactoryCall.
From FiveGuidanceAllOrder Require Import CallfreeExecution ContinuationLift PhaseComposition.
Import ListNotations.
Open Scope Z_scope.
Module F:=FactorySemantics.
Module S:=PidPositionRunPos.Source.
Definition args(src ret:block)(o:ptrofs)(h:int):list val :=
 [Vptr ret Ptrofs.zero;Vptr src o;Vint h].
Lemma factory_normal_syntax:forall src ret o h m,
 normal_state(Callstate(Internal S.f_stab_sp_from_ltp_i)(args src ret o h)Kstop m)=true.
Proof. intros;vm_compute;reflexivity. Qed.
Lemma factory_names:forall src ret o h m,
 call_names(Callstate(Internal S.f_stab_sp_from_ltp_i)(args src ret o h)Kstop m).
Proof. intros;repeat constructor;simpl;intuition discriminate. Qed.

Theorem original_factory_all_orders:forall m src ret o h x y,
 Mem.load Mint32 m src(Ptrofs.unsigned o)=Some(Vint x) ->
 Mem.load Mint32 m src(Ptrofs.unsigned o+4)=Some(Vint y) ->
 (4|Ptrofs.unsigned o) ->
 Mem.range_perm m src(Ptrofs.unsigned o)(Ptrofs.unsigned o+8)Cur Readable ->
 Mem.range_perm m ret 0 36 Cur Writable ->
 exists mf,
 active_fields mf ret x y h /\
 (forall t reached,
 star Csem.step F.ge(Callstate(Internal S.f_stab_sp_from_ltp_i)(args src ret o h)Kstop m)t reached ->
 normal_return reached \/ exists tr next,Csem.step F.ge reached tr next) /\
 (forall t v mr,
 star Csem.step F.ge(Callstate(Internal S.f_stab_sp_from_ltp_i)(args src ret o h)Kstop m)t(Returnstate v Kstop mr) ->
 v=Vundef /\ mr=mf) /\
 (forall base,is_call_cont base ->
 certificate F.ge(callee_invariant F.ge base Vundef mf)(Returnstate Vundef base mf) /\
 callee_invariant F.ge base Vundef mf
 (Callstate(Internal S.f_stab_sp_from_ltp_i)(args src ret o h)base m)).
Proof.
 intros m src ret o h x y LX LY AL RP WR.
 destruct(FactoryCall.original_factory_csem_normal m src ret o h x y LX LY AL RP WR)
 as[mf[PATH ACTIVE]].
 pose proof(factory_normal_syntax src ret o h m)as SYNTAX.
 pose proof(factory_names src ret o h m)as NAMES.
 destruct(normal_witness_certifies_all_orders F.ge _ E0 Vundef mf SYNTAX NAMES PATH)
 as[PROGRESS UNIQUE].
 exists mf;split;[exact ACTIVE|];split;[exact PROGRESS|];split;[exact UNIQUE|].
 intros base BASE;split.
 - split.
   + intros s INV;eapply callee_invariant_progress;eauto.
   + intros s t next INV ND STEP;eapply callee_invariant_all_successors;eauto.
 - pose proof(callee_invariant_entry F.ge base _ E0 Vundef mf SYNTAX NAMES PATH)as ENTRY.
   exact ENTRY.
Qed.
Print Assumptions original_factory_all_orders.
