From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics.
From PidPositionTranslationAttempt002 Require Import EntryPrefix ClampSemantics PrefixFields.
Import ListNotations.
Open Scope Z_scope.
Module S := PidPositionRunPos.Source.
Module E := PidPositionRunPos.Execution.
Local Opaque E.ge.

Lemma global_axis_x_lvalue : forall e m id pb,
 e!id=None ->Genv.find_symbol E.ge id=Some pb ->
 eval_simple_lvalue E.ge e m(pid_axis_lvalue id S._x)pb Ptrofs.zero Full.
Proof.
 intros;unfold pid_axis_lvalue,pid_vec_expr,vec_type.
 change(eval_simple_lvalue E.ge e m
 (Efield(Evalof(Evar id(Tstruct S._Int32Vect2 noattr))(Tstruct S._Int32Vect2 noattr))S._x tint)
 pb(Ptrofs.add Ptrofs.zero(Ptrofs.repr 0))Full).
 p_lv.
Qed.
Lemma global_axis_y_lvalue : forall e m id pb,
 e!id=None ->Genv.find_symbol E.ge id=Some pb ->
 eval_simple_lvalue E.ge e m(pid_axis_lvalue id S._y)pb(Ptrofs.repr 4)Full.
Proof.
 intros;unfold pid_axis_lvalue,pid_vec_expr,vec_type.
 change(eval_simple_lvalue E.ge e m
 (Efield(Evalof(Evar id(Tstruct S._Int32Vect2 noattr))(Tstruct S._Int32Vect2 noattr))S._y tint)
 pb(Ptrofs.add Ptrofs.zero(Ptrofs.repr 4))Full).
 p_lv.
Qed.
Definition global_clamp_assignment(id axis:ident)(shift:Z):=
 Sdo(Eassign(pid_axis_lvalue id axis)(source_clamp(Evalof(pid_axis_lvalue id axis)tint)shift)tint).

Theorem original_two_global_clamps : forall e m id pb x y shift bound,
 e!id=None ->Genv.find_symbol E.ge id=Some pb ->
 Mem.load Mint32 m pb 0=Some(Vint x) ->
 Mem.load Mint32 m pb 4=Some(Vint y) ->
 Mem.range_perm m pb 0 8 Cur Writable ->
 (forall e' m',eval_simple_rvalue E.ge e' m'(source_bound shift)(Vfloat(Float.of_int bound))) ->
 Float.neg(Float.of_int bound)=Float.of_int(Int.neg bound) ->
 exists mf,
 Cstrategy.exec_stmt E.ge e m
 (Ssequence(global_clamp_assignment id S._x shift)(global_clamp_assignment id S._y shift))E0 mf Out_normal /\
 Mem.load Mint32 mf pb 0=Some(Vint(clamp_bits x bound)) /\
 Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits y bound)) /\
 raw_writes(fun b=>b=pb)m mf.
Proof.
 intros e m id pb x y shift bound LOCAL SYM X Y WRITE BOUND NEG.
 assert(A0:Mem.valid_access m Mint32 pb 0 Writable).
 { apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|0);try(exists 0;reflexivity);cbn;lia. }
 destruct(source_clamp_assignment_exact_exists e m(pid_axis_lvalue id S._x)x shift bound pb Ptrofs.zero
 eq_refl eq_refl ltac:(apply global_axis_x_lvalue;assumption)ltac:(change(Mem.load Mint32 m pb 0=Some(Vint x));exact X)
 ltac:(exact A0)(BOUND e m)NEG)as[m1[EX[STX POSTX]]].
 pose proof(Mem.storev_store _ _ _ _ _ _ STX)as ST0.
 assert(A4:Mem.valid_access m1 Mint32 pb 4 Writable).
 { eapply Mem.store_valid_access_1;[exact ST0|].
   apply scalar_access_inside with(n:=8);try exact WRITE;try change(4|4);try(exists 1;reflexivity);cbn;lia. }
 assert(Y1:Mem.loadv Mint32 m1(Vptr pb(Ptrofs.repr 4))=Some(Vint y)).
 { change(Mem.load Mint32 m1 pb 4=Some(Vint y)).
   rewrite(Mem.load_store_other Mint32 m pb 0(Vint(clamp_bits x bound))m1 ST0 Mint32 pb 4)
   by(right;right;cbn;lia);exact Y. }
 destruct(source_clamp_assignment_exact_exists e m1(pid_axis_lvalue id S._y)y shift bound pb(Ptrofs.repr 4)
 eq_refl eq_refl ltac:(apply global_axis_y_lvalue;assumption)Y1
 ltac:(change(Mem.valid_access m1 Mint32 pb 4 Writable);exact A4)(BOUND e m1)NEG)as[mf[EY[STY POSTY]]].
 pose proof(Mem.storev_store _ _ _ _ _ _ STY)as ST4.
 exists mf;split.
 - apply sequence_normal with(ma:=m1);assumption.
 - split.
   + change(Mem.load Mint32 m1 pb 0=Some(Vint(clamp_bits x bound)))in POSTX.
     rewrite(Mem.load_store_other Mint32 m1 pb 4(Vint(clamp_bits y bound))mf ST4 Mint32 pb 0)
      by(right;left;cbn;lia);exact POSTX.
   + split.
     * change(Mem.load Mint32 mf pb 4=Some(Vint(clamp_bits y bound)))in POSTY;exact POSTY.
     * eapply raw_writes_store;[reflexivity|exact ST0|].
       eapply raw_writes_store;[reflexivity|exact ST4|constructor].
Qed.
Print Assumptions original_two_global_clamps.
