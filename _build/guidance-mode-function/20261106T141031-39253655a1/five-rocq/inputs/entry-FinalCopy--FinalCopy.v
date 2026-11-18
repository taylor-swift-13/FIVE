From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePaparazziState Require Import State MemorySupport.
From FiveGuidanceEntry Require Import Entry BigstepSupport EffectfulSupport SymbolicPrefix.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Definition copy_component(coord:ident):statement:=Sdo(Eassign
 (global_vector_field S._accel coord vt tfloat)
 (f_read(local_field S._accel_sp coord vt tfloat))tfloat).
Lemma after_saturation_shape:after_saturation=Ssequence(copy_component S._x)(copy_component S._y).
Proof. reflexivity. Qed.
Lemma final_copy_exec:forall s a e m bg ba,
 e!S._gh_ref=None ->Genv.find_symbol ge S._gh_ref=Some bg ->e!S._accel_sp=Some(ba,vt) ->bg<>ba ->
 repr s m bg ->writable m bg ->Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 exists mf ma,Cstrategy.exec_stmt ge e m after_saturation E0 mf Out_normal /\
 repr(with_accel s a)mf bg /\writable mf bg /\access_preserved m mf /\
 Mem.store Mfloat32 m bg 0(Vsingle(vx a))=Some ma /\Mem.store Mfloat32 ma bg 4(Vsingle(vy a))=Some mf /\
 Mem.loadbytes mf bg 0 4=Some(encode_val Mfloat32(Vsingle(vx a))) /\
 Mem.loadbytes mf bg 4 4=Some(encode_val Mfloat32(Vsingle(vy a))).
Proof.
 intros s a e m bg ba ENV SYM LA D REP W LX LY.
 destruct(Mem.valid_access_store m Mfloat32 bg 0(Vsingle(vx a))
 (writable_float_access m bg 0 W ltac:(unfold float_offsets;simpl;auto)))as[m1 SX].
 assert(R1:repr(replace_float s 0(vx a))m1 bg).
 { eapply repr_store_float;[exact REP|unfold float_offsets;simpl;auto|exact SX]. }
 assert(W1:writable m1 bg)by(eapply writable_store;eauto).
 assert(LY1:Mem.load Mfloat32 m1 ba 4=Some(Vsingle(vy a)))by prior_store_load.
 destruct(Mem.valid_access_store m1 Mfloat32 bg 4(Vsingle(vy a))
 (writable_float_access m1 bg 4 W1 ltac:(unfold float_offsets;simpl;auto)))as[m2 SY].
 exists m2,m1;split.
 - rewrite after_saturation_shape;eapply sequence_normal.
   + unfold copy_component;eapply write_at_single with(b:=bg)(ofs:=0)(x:=vx a).
     * eapply global_vector_location;[exact ENV|exact SYM|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply read_local_vector;[exact LA|intuition congruence|exact LX].
     * vm_compute;intuition discriminate.
     * exact SX.
   + unfold copy_component;eapply write_at_single with(b:=bg)(ofs:=4)(x:=vy a).
     * eapply global_vector_location;[exact ENV|exact SYM|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply read_local_vector;[exact LA|intuition congruence|exact LY1].
     * vm_compute;intuition discriminate.
     * exact SY.
 - split.
   + change(repr(replace_float(replace_float s 0(vx a))4(vy a))m2 bg).
     eapply repr_store_float;[exact R1|unfold float_offsets;simpl;auto|exact SY].
   + split;[eapply writable_store;eauto|]. split.
     * unfold access_preserved;intros;prior_store_access.
     * split;[exact SX|]. split;[exact SY|]. split.
       -- erewrite Mem.loadbytes_store_other by(exact SY||(right;right;left;cbn;lia)).
          exact(Mem.loadbytes_store_same _ _ _ _ _ _ SX).
       -- exact(Mem.loadbytes_store_same _ _ _ _ _ _ SY).
Qed.
Lemma saturation_return_to_copy:forall f e m,
 star Csem.step ge
 (Returnstate Vundef(Kcall f e(fun x=>x)tvoid(Kdo(Kseq after_saturation Kstop)))m)E0
 (State f after_saturation Kstop e m).
Proof.
 intros;eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_returnstate| |reflexivity].
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_do_2| |reflexivity].
 apply star_one;right;apply Csem.step_skip_seq.
Qed.
Lemma copy_path:forall e m mf f,
 Cstrategy.exec_stmt ge e m after_saturation E0 mf Out_normal ->
 star Csem.step ge(State f after_saturation Kstop e m)E0(State f Sskip Kstop e mf).
Proof.
 intros e m mf f EVAL;destruct(Cstrategy.exec_stmt_to_steps ge e m after_saturation E0 mf Out_normal EVAL f Kstop)as[reached[PATH END]].
 inversion END;subst;apply strategy_star_csem;exact PATH.
Qed.
Print Assumptions final_copy_exec.
