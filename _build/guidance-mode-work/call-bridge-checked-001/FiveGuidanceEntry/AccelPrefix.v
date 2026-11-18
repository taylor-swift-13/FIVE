From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePaparazziState Require Import State MemorySupport.
From FiveGuidanceEntry Require Import Entry BigstepSupport.
Require FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhAccel.Source.
Definition ge:=FiveGhAccel.Execution.ge.
Definition vt:=Tstruct S._FloatVect2 noattr.
Definition it:=Tstruct S._Int64Vect2 noattr.
Definition gt:=Tstruct S._GuidanceHRef noattr.
Definition local_field (id coord : ident) (ty ft : type) : expr :=
 Efield (Evalof (Evar id ty) ty) coord ft.
Definition global_field (id : ident) (ty : type) : expr :=
 Efield (Evalof (Evar S._gh_ref gt) gt) id ty.
Definition global_vector_field (id coord : ident) (ty ft : type) : expr :=
 Efield (Evalof (global_field id ty) ty) coord ft.
Lemma local_vector_location : forall e m id b coord ofs,
 e!id=Some(b,vt) -> (coord=S._x /\ ofs=0 \/ coord=S._y /\ ofs=4) ->
 Cstrategy.eval_simple_lvalue ge e m (local_field id coord vt tfloat) b (Ptrofs.repr ofs) Full.
Proof.
 intros e m id b coord ofs LOOK [[-> ->]|[-> ->]];
 unfold local_field,vt;
 rewrite <- Ptrofs.add_zero_l at 1.
 all: eapply Cstrategy.esl_field_struct;
 [eapply Cstrategy.esr_rvalof;[apply Cstrategy.esl_var_local;exact LOOK|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
 reflexivity|reflexivity|reflexivity].
Qed.
Lemma global_scalar_location : forall e m b id ofs ty,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some b ->
 (id=S._dt /\ ofs=60 /\ ty=tfloat \/ id=S._inv_tau /\ ofs=56 /\ ty=tfloat) ->
 Cstrategy.eval_simple_lvalue ge e m (global_field id ty) b (Ptrofs.repr ofs) Full.
Proof.
 intros e m b id ofs ty ENV SYM OFF;
 destruct OFF as [[-> [-> ->]]|[-> [-> ->]]]; unfold global_field,gt.
 all: rewrite <- Ptrofs.add_zero_l at 1.
 all: eapply Cstrategy.esl_field_struct;
 [eapply Cstrategy.esr_rvalof;[eapply Cstrategy.esl_var_global;[exact ENV|exact SYM]|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
 reflexivity|reflexivity|reflexivity].
Qed.
Lemma global_aggregate_location : forall e m b id ofs ty,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some b ->
 (id=S._accel /\ ofs=0 /\ ty=vt \/
 id=S._speed /\ ofs=8 /\ ty=vt \/ id=S._pos /\ ofs=16 /\ ty=it) ->
 Cstrategy.eval_simple_lvalue ge e m (global_field id ty) b (Ptrofs.repr ofs) Full.
Proof.
 intros e m b id ofs ty ENV SYM OFF;
 destruct OFF as [[-> [-> ->]]|[[-> [-> ->]]|[-> [-> ->]]]]; unfold global_field,gt;
 rewrite <- Ptrofs.add_zero_l at 1.
 all: eapply Cstrategy.esl_field_struct;
 [eapply Cstrategy.esr_rvalof;[eapply Cstrategy.esl_var_global;[exact ENV|exact SYM]|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
 reflexivity|reflexivity|reflexivity].
Qed.
Lemma global_vector_location : forall e m b id coord ofs,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some b ->
 (id=S._accel /\ coord=S._x /\ ofs=0 \/
  id=S._accel /\ coord=S._y /\ ofs=4 \/
  id=S._speed /\ coord=S._x /\ ofs=8 \/
  id=S._speed /\ coord=S._y /\ ofs=12) ->
 Cstrategy.eval_simple_lvalue ge e m (global_vector_field id coord vt tfloat) b (Ptrofs.repr ofs) Full.
Proof.
 intros e m b id coord ofs ENV SYM OFF;
 destruct OFF as [[-> [-> ->]]|[[-> [-> ->]]|[[-> [-> ->]]|[-> [-> ->]]]]];
 unfold global_vector_field;
 first [change (Cstrategy.eval_simple_lvalue ge e m
 (Efield (Evalof (global_field S._accel vt) vt) S._x tfloat) b
 (Ptrofs.add (Ptrofs.repr 0) (Ptrofs.repr 0)) Full)|
 change (Cstrategy.eval_simple_lvalue ge e m
 (Efield (Evalof (global_field S._accel vt) vt) S._y tfloat) b
 (Ptrofs.add (Ptrofs.repr 0) (Ptrofs.repr 4)) Full)|
 change (Cstrategy.eval_simple_lvalue ge e m
 (Efield (Evalof (global_field S._speed vt) vt) S._x tfloat) b
 (Ptrofs.add (Ptrofs.repr 8) (Ptrofs.repr 0)) Full)|
 change (Cstrategy.eval_simple_lvalue ge e m
 (Efield (Evalof (global_field S._speed vt) vt) S._y tfloat) b
 (Ptrofs.add (Ptrofs.repr 8) (Ptrofs.repr 4)) Full)].
 all: eapply Cstrategy.esl_field_struct;
 [eapply Cstrategy.esr_rvalof;
 [eapply global_aggregate_location;[exact ENV|exact SYM|intuition congruence]|
 reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
 reflexivity|reflexivity|reflexivity].
Qed.
Lemma read_at_single : forall e m l b ofs x,
 Cstrategy.eval_simple_lvalue ge e m l b (Ptrofs.repr ofs) Full ->
 typeof l=tfloat -> 0<=ofs<=Ptrofs.max_unsigned-4 ->
 Mem.load Mfloat32 m b ofs=Some(Vsingle x) ->
 Cstrategy.eval_simple_rvalue ge e m (Evalof l tfloat) (Vsingle x).
Proof.
 intros e m l b ofs x LOC TY RNG LOAD.
 eapply read_scalar;[exact LOC|symmetry;exact TY|reflexivity|reflexivity|].
 change (0<=ofs<=18446744073709551611) in RNG.
 unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by (change(0<=ofs<=18446744073709551615);lia).
 rewrite zle_true by (change(ofs+4<=18446744073709551616);lia);exact LOAD.
Qed.
Lemma write_at_single : forall e m l r b ofs x mf,
 Cstrategy.eval_simple_lvalue ge e m l b (Ptrofs.repr ofs) Full ->
 typeof l=tfloat -> source_simple l=true -> typeof r=tfloat ->
 source_simple r=true -> Cstrategy.eval_simple_rvalue ge e m r (Vsingle x) ->
 0<=ofs<=Ptrofs.max_unsigned-4 -> Mem.store Mfloat32 m b ofs(Vsingle x)=Some mf ->
 Cstrategy.exec_stmt ge e m (Sdo(Eassign l r tfloat)) E0 mf Out_normal.
Proof.
 intros e m l r b ofs x mf LOC TL SL TR SR RV RNG STORE.
 eapply atomic_assign with (vc:=Vsingle x)(v':=Vsingle x);
 [exact LOC|exact SL|exact RV|exact SR|rewrite TL,TR;reflexivity| |symmetry;exact TL].
 rewrite TL;eapply assign_scalar;[reflexivity|reflexivity|].
 change (0<=ofs<=18446744073709551611) in RNG.
 unfold Mem.storev;rewrite Ptrofs.unsigned_repr by (change(0<=ofs<=18446744073709551615);lia).
 rewrite zle_true by (change(ofs+4<=18446744073709551616);lia);exact STORE.
Qed.
Print Assumptions global_vector_location.
Print Assumptions write_at_single.
Definition f_read (l:expr) : expr := Evalof l tfloat.
Definition smul_component (local global coord:ident) : statement :=
 Sdo(Eassign (local_field local coord vt tfloat)
 (Ebinop Omul (f_read(global_vector_field global coord vt tfloat))
 (f_read(global_field S._dt tfloat)) tfloat) tfloat).
Definition source_pos_step : statement :=
 Ssequence (smul_component S._pos_step S._speed S._x)
           (smul_component S._pos_step S._speed S._y).
Lemma source_pos_step_shape :
 match fn_body S.f_gh_update_ref_from_accel_sp with
 |Ssequence a _=>a|_=>Sskip end=source_pos_step.
Proof. reflexivity. Qed.
Lemma read_speed_component : forall s e m bg coord ofs x,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg -> repr s m bg ->
 (coord=S._x /\ ofs=8 /\ x=speed_x s \/ coord=S._y /\ ofs=12 /\ x=speed_y s) ->
 Cstrategy.eval_simple_rvalue ge e m (f_read(global_vector_field S._speed coord vt tfloat))(Vsingle x).
Proof.
 intros s e m bg coord ofs x ENV SYM REP OFF.
 eapply read_at_single with (b:=bg)(ofs:=ofs).
 - eapply global_vector_location;[exact ENV|exact SYM|destruct OFF as [[-> [-> ->]]|[-> [-> ->]]];intuition congruence].
 - reflexivity.
 - destruct OFF as [[-> [-> ->]]|[-> [-> ->]]];vm_compute;intuition discriminate.
 - unfold repr in REP;destruct OFF as [[-> [-> ->]]|[-> [-> ->]]];tauto.
Qed.
Lemma read_dt : forall s e m bg,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg -> repr s m bg ->
 Cstrategy.eval_simple_rvalue ge e m (f_read(global_field S._dt tfloat))(Vsingle(dt s)).
Proof.
 intros s e m bg ENV SYM REP.
 eapply read_at_single with (b:=bg)(ofs:=60).
 - eapply global_scalar_location;[exact ENV|exact SYM|intuition congruence].
 - reflexivity.
 - vm_compute;intuition discriminate.
 - unfold repr in REP;tauto.
Qed.
Lemma source_pos_step_exec : forall s e m bg bp,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg ->
 e!S._pos_step=Some(bp,vt) -> bg<>bp -> repr s m bg -> writable m bg ->
 Mem.valid_access m Mfloat32 bp 0 Writable ->
 Mem.valid_access m Mfloat32 bp 4 Writable ->
 exists mf,
 Cstrategy.exec_stmt ge e m source_pos_step E0 mf Out_normal /\
 repr s mf bg /\ writable mf bg /\
 Mem.load Mfloat32 mf bp 0=Some(Vsingle(Float32.mul(speed_x s)(dt s))) /\
 Mem.load Mfloat32 mf bp 4=Some(Vsingle(Float32.mul(speed_y s)(dt s))) /\
 (exists m1, Mem.store Mfloat32 m bp 0 (Vsingle(Float32.mul(speed_x s)(dt s)))=Some m1 /\
 Mem.store Mfloat32 m1 bp 4 (Vsingle(Float32.mul(speed_y s)(dt s)))=Some mf).
Proof.
 intros s e m bg bp ENV SYM LOOK DIFF REP WR A0 A4.
 destruct(Mem.valid_access_store m Mfloat32 bp 0
 (Vsingle(Float32.mul(speed_x s)(dt s))) A0)as[m1 SX].
 assert(REP1:repr s m1 bg)by(eapply repr_store_other;eauto).
 assert(WR1:writable m1 bg)by(eapply writable_store_other;eauto).
 assert(A41:Mem.valid_access m1 Mfloat32 bp 4 Writable)by(eapply Mem.store_valid_access_1;eauto).
 destruct(Mem.valid_access_store m1 Mfloat32 bp 4
 (Vsingle(Float32.mul(speed_y s)(dt s))) A41)as[m2 SY].
 exists m2;split.
 - unfold source_pos_step;eapply sequence_normal.
   + unfold smul_component;eapply write_at_single with(b:=bp)(ofs:=0).
     * eapply local_vector_location;[exact LOOK|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply Cstrategy.esr_binop.
       -- eapply read_speed_component;[exact ENV|exact SYM|exact REP|intuition congruence].
       -- eapply read_dt;eauto.
       -- reflexivity.
     * vm_compute;intuition discriminate.
     * exact SX.
   + unfold smul_component;eapply write_at_single with(b:=bp)(ofs:=4).
     * eapply local_vector_location;[exact LOOK|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply Cstrategy.esr_binop.
       -- eapply read_speed_component;[exact ENV|exact SYM|exact REP1|intuition congruence].
       -- eapply read_dt;eauto.
       -- reflexivity.
     * vm_compute;intuition discriminate.
     * exact SY.
 - split;[eapply repr_store_other;eauto|].
   split;[eapply writable_store_other;eauto|].
   split.
   + erewrite Mem.load_store_other by(exact SY||(right;cbn;lia)).
     erewrite Mem.load_store_same by exact SX;reflexivity.
   + split;[erewrite Mem.load_store_same by exact SY;reflexivity|exists m1;auto].
Qed.
Print Assumptions source_pos_step_exec.

Definition source_speed_step : statement :=
 Ssequence (smul_component S._speed_step S._accel S._x)
 (smul_component S._speed_step S._accel S._y).
Lemma source_speed_step_shape :
 match fn_body S.f_gh_update_ref_from_accel_sp with
 |Ssequence _ (Ssequence a _)=>a|_=>Sskip end=source_speed_step.
Proof. reflexivity. Qed.
Lemma read_accel_component : forall s e m bg coord ofs x,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg -> repr s m bg ->
 (coord=S._x /\ ofs=0 /\ x=accel_x s \/ coord=S._y /\ ofs=4 /\ x=accel_y s) ->
 Cstrategy.eval_simple_rvalue ge e m (f_read(global_vector_field S._accel coord vt tfloat))(Vsingle x).
Proof.
 intros s e m bg coord ofs x ENV SYM REP OFF.
 eapply read_at_single with (b:=bg)(ofs:=ofs).
 - eapply global_vector_location;[exact ENV|exact SYM|destruct OFF as [[-> [-> ->]]|[-> [-> ->]]];intuition congruence].
 - reflexivity.
 - destruct OFF as [[-> [-> ->]]|[-> [-> ->]]];vm_compute;intuition discriminate.
 - unfold repr in REP;destruct OFF as [[-> [-> ->]]|[-> [-> ->]]];tauto.
Qed.
Lemma source_speed_step_exec : forall s e m bg bp,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg ->
 e!S._speed_step=Some(bp,vt) -> bg<>bp -> repr s m bg -> writable m bg ->
 Mem.valid_access m Mfloat32 bp 0 Writable ->
 Mem.valid_access m Mfloat32 bp 4 Writable ->
 exists mf,
 Cstrategy.exec_stmt ge e m source_speed_step E0 mf Out_normal /\
 repr s mf bg /\ writable mf bg /\
 Mem.load Mfloat32 mf bp 0=Some(Vsingle(Float32.mul(accel_x s)(dt s))) /\
 Mem.load Mfloat32 mf bp 4=Some(Vsingle(Float32.mul(accel_y s)(dt s))) /\
 (exists m1, Mem.store Mfloat32 m bp 0 (Vsingle(Float32.mul(accel_x s)(dt s)))=Some m1 /\
 Mem.store Mfloat32 m1 bp 4 (Vsingle(Float32.mul(accel_y s)(dt s)))=Some mf).
Proof.
 intros s e m bg bp ENV SYM LOOK DIFF REP WR A0 A4.
 destruct(Mem.valid_access_store m Mfloat32 bp 0
 (Vsingle(Float32.mul(accel_x s)(dt s))) A0)as[m1 SX].
 assert(REP1:repr s m1 bg)by(eapply repr_store_other;eauto).
 assert(WR1:writable m1 bg)by(eapply writable_store_other;eauto).
 assert(A41:Mem.valid_access m1 Mfloat32 bp 4 Writable)by(eapply Mem.store_valid_access_1;eauto).
 destruct(Mem.valid_access_store m1 Mfloat32 bp 4
 (Vsingle(Float32.mul(accel_y s)(dt s))) A41)as[m2 SY].
 exists m2;split.
 - unfold source_speed_step;eapply sequence_normal.
   + unfold smul_component;eapply write_at_single with(b:=bp)(ofs:=0).
     * eapply local_vector_location;[exact LOOK|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply Cstrategy.esr_binop.
       -- eapply read_accel_component;[exact ENV|exact SYM|exact REP|intuition congruence].
       -- eapply read_dt;eauto.
       -- reflexivity.
     * vm_compute;intuition discriminate.
     * exact SX.
   + unfold smul_component;eapply write_at_single with(b:=bp)(ofs:=4).
     * eapply local_vector_location;[exact LOOK|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply Cstrategy.esr_binop.
       -- eapply read_accel_component;[exact ENV|exact SYM|exact REP1|intuition congruence].
       -- eapply read_dt;eauto.
       -- reflexivity.
     * vm_compute;intuition discriminate.
     * exact SY.
 - split;[eapply repr_store_other;eauto|].
   split;[eapply writable_store_other;eauto|].
   split.
   + erewrite Mem.load_store_other by(exact SY||(right;cbn;lia)).
     erewrite Mem.load_store_same by exact SX;reflexivity.
   + split;[erewrite Mem.load_store_same by exact SY;reflexivity|exists m1;auto].
Qed.
Print Assumptions source_speed_step_exec.
Lemma local_int64_location : forall e m id b coord ofs,
 e!id=Some(b,it) -> (coord=S._x /\ ofs=0 \/ coord=S._y /\ ofs=8) ->
 Cstrategy.eval_simple_lvalue ge e m (local_field id coord it tlong) b (Ptrofs.repr ofs) Full.
Proof.
 intros e m id b coord ofs LOOK [[-> ->]|[-> ->]];
 unfold local_field,it;rewrite <- Ptrofs.add_zero_l at 1.
 all: eapply Cstrategy.esl_field_struct;
 [eapply Cstrategy.esr_rvalof;[apply Cstrategy.esl_var_local;exact LOOK|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
 reflexivity|reflexivity|reflexivity].
Qed.
Lemma write_at_long : forall e m l r b ofs v x mf,
 Cstrategy.eval_simple_lvalue ge e m l b (Ptrofs.repr ofs) Full ->
 typeof l=tlong -> source_simple l=true -> source_simple r=true ->
 Cstrategy.eval_simple_rvalue ge e m r v ->
 sem_cast v (typeof r) tlong m=Some(Vlong x) ->
 0<=ofs<=Ptrofs.max_unsigned-8 -> Mem.store Mint64 m b ofs(Vlong x)=Some mf ->
 Cstrategy.exec_stmt ge e m (Sdo(Eassign l r tlong)) E0 mf Out_normal.
Proof.
 intros e m l r b ofs v x mf LOC TL SL SR RV CAST RNG STORE.
 eapply atomic_assign with (vc:=Vlong x)(v':=Vlong x);
 [exact LOC|exact SL|exact RV|exact SR|rewrite TL;exact CAST| |symmetry;exact TL].
 rewrite TL;eapply assign_scalar;[reflexivity|reflexivity|].
 change (0<=ofs<=18446744073709551607) in RNG.
 unfold Mem.storev;rewrite Ptrofs.unsigned_repr by (change(0<=ofs<=18446744073709551615);lia).
 rewrite zle_true by (change(ofs+8<=18446744073709551616);lia);exact STORE.
Qed.
Definition q37_expr : expr := Ebinop Oshl
 (Eval(Vlong(Int64.repr 1))tlong)(Eval(Vint(Int.repr 37))tint)tlong.
Definition pos_conversion_expr (coord:ident) : expr :=
 Ebinop Omul (f_read(local_field S._pos_step coord vt tfloat)) q37_expr tfloat.
Definition pos_conversion (coord:ident) : statement :=
 Sdo(Eassign (local_field S._pos_update coord it tlong)(pos_conversion_expr coord)tlong).
Lemma source_conversion_shape :
 match fn_body S.f_gh_update_ref_from_accel_sp with
 |Ssequence _ (Ssequence _ (Ssequence x (Ssequence y _)))=> (x,y)
 |_ =>(Sskip,Sskip) end=(pos_conversion S._x,pos_conversion S._y).
Proof. reflexivity. Qed.
Lemma conversion_rvalue : forall e m bp coord ofs step,
 e!S._pos_step=Some(bp,vt) ->
 (coord=S._x /\ ofs=0 \/ coord=S._y /\ ofs=4) ->
 Mem.load Mfloat32 m bp ofs=Some(Vsingle step) ->
 Cstrategy.eval_simple_rvalue ge e m (pos_conversion_expr coord) (Vsingle(Float32.mul step q37)).
Proof.
 intros e m bp coord ofs step LOOK OFF LOAD.
 unfold pos_conversion_expr;eapply Cstrategy.esr_binop.
 - eapply read_at_single with(b:=bp)(ofs:=ofs).
   + eapply local_vector_location;eauto.
   + reflexivity.
   + destruct OFF as [[-> ->]|[-> ->]];vm_compute;intuition discriminate.
   + exact LOAD.
 - unfold q37_expr;eapply Cstrategy.esr_binop;[constructor|constructor|reflexivity].
 - reflexivity.
Qed.
Lemma source_pos_conversion_exec : forall s e m bg bp bu px py dx dy,
 e!S._pos_step=Some(bp,vt) -> e!S._pos_update=Some(bu,it) ->
 bg<>bu -> bp<>bu -> repr s m bg -> writable m bg ->
 Mem.load Mfloat32 m bp 0=Some(Vsingle px) ->
 Mem.load Mfloat32 m bp 4=Some(Vsingle py) ->
 Float32.to_long(Float32.mul px q37)=Some dx ->
 Float32.to_long(Float32.mul py q37)=Some dy ->
 Mem.valid_access m Mint64 bu 0 Writable ->
 Mem.valid_access m Mint64 bu 8 Writable ->
 exists mf, Cstrategy.exec_stmt ge e m
 (Ssequence(pos_conversion S._x)(pos_conversion S._y)) E0 mf Out_normal /\
 repr s mf bg /\ writable mf bg /\
 Mem.load Mint64 mf bu 0=Some(Vlong dx) /\ Mem.load Mint64 mf bu 8=Some(Vlong dy) /\
 exists ma, Mem.store Mint64 m bu 0 (Vlong dx)=Some ma /\
 Mem.store Mint64 ma bu 8 (Vlong dy)=Some mf.
Proof.
 intros s e m bg bp bu px py dx dy LP LU DGU DPU REP W LOADX LOADY CX CY A0 A8.
 destruct(Mem.valid_access_store m Mint64 bu 0(Vlong dx) A0)as[m1 SX].
 assert(R1:repr s m1 bg)by(eapply repr_store_other;eauto).
 assert(W1:writable m1 bg)by(eapply writable_store_other;eauto).
 assert(Y1:Mem.load Mfloat32 m1 bp 4=Some(Vsingle py)).
 { erewrite Mem.load_store_other by(exact SX||(left;exact DPU));exact LOADY. }
 assert(A81:Mem.valid_access m1 Mint64 bu 8 Writable)by(eapply Mem.store_valid_access_1;eauto).
 destruct(Mem.valid_access_store m1 Mint64 bu 8(Vlong dy) A81)as[m2 SY].
 exists m2;split.
 - eapply sequence_normal.
   + unfold pos_conversion;eapply write_at_long with(b:=bu)(ofs:=0)(x:=dx)(v:=Vsingle(Float32.mul px q37)).
     * eapply local_int64_location;[exact LU|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply conversion_rvalue;[exact LP|intuition congruence|exact LOADX].
     * change(option_map Vlong(Float32.to_long(Float32.mul px q37))=Some(Vlong dx));rewrite CX;reflexivity.
     * vm_compute;intuition discriminate.
     * exact SX.
   + unfold pos_conversion;eapply write_at_long with(b:=bu)(ofs:=8)(x:=dy)(v:=Vsingle(Float32.mul py q37)).
     * eapply local_int64_location;[exact LU|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply conversion_rvalue;[exact LP|intuition congruence|exact Y1].
     * change(option_map Vlong(Float32.to_long(Float32.mul py q37))=Some(Vlong dy));rewrite CY;reflexivity.
     * vm_compute;intuition discriminate.
     * exact SY.
 - split;[eapply repr_store_other;eauto|].
   split;[eapply writable_store_other;eauto|]. split.
   + erewrite Mem.load_store_other by(exact SY||(right;cbn;lia)).
     erewrite Mem.load_store_same by exact SX;reflexivity.
   + split;[erewrite Mem.load_store_same by exact SY;reflexivity|exists m1;auto].
Qed.
Print Assumptions source_pos_conversion_exec.
Lemma global_position_location : forall e m bg coord ofs,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg ->
 (coord=S._x /\ ofs=16 \/ coord=S._y /\ ofs=24) ->
 Cstrategy.eval_simple_lvalue ge e m (global_vector_field S._pos coord it tlong) bg (Ptrofs.repr ofs) Full.
Proof.
 intros e m bg coord ofs ENV SYM OFF;destruct OFF as [[-> ->]|[-> ->]];
 unfold global_vector_field.
 - change(Cstrategy.eval_simple_lvalue ge e m
 (Efield(Evalof(global_field S._pos it)it)S._x tlong)bg
 (Ptrofs.add(Ptrofs.repr 16)(Ptrofs.repr 0))Full).
   eapply Cstrategy.esl_field_struct;
   [eapply Cstrategy.esr_rvalof;
   [eapply global_aggregate_location;[exact ENV|exact SYM|intuition congruence]|
   reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
   reflexivity|reflexivity|reflexivity].
 - change(Cstrategy.eval_simple_lvalue ge e m
 (Efield(Evalof(global_field S._pos it)it)S._y tlong)bg
 (Ptrofs.add(Ptrofs.repr 16)(Ptrofs.repr 8))Full).
   eapply Cstrategy.esl_field_struct;
   [eapply Cstrategy.esr_rvalof;
   [eapply global_aggregate_location;[exact ENV|exact SYM|intuition congruence]|
   reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
   reflexivity|reflexivity|reflexivity].
Qed.
Lemma read_at_long : forall e m l b ofs x,
 Cstrategy.eval_simple_lvalue ge e m l b(Ptrofs.repr ofs)Full ->
 typeof l=tlong -> 0<=ofs<=Ptrofs.max_unsigned-8 ->
 Mem.load Mint64 m b ofs=Some(Vlong x) ->
 Cstrategy.eval_simple_rvalue ge e m(Evalof l tlong)(Vlong x).
Proof.
 intros e m l b ofs x LOC TY RNG LOAD.
 eapply read_scalar;[exact LOC|symmetry;exact TY|reflexivity|reflexivity|].
 change(0<=ofs<=18446744073709551607)in RNG.
 unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change(0<=ofs<=18446744073709551615);lia).
 rewrite zle_true by(change(ofs+8<=18446744073709551616);lia);exact LOAD.
Qed.
Lemma add_at_long : forall e m l r b ofs old delta mf,
 Cstrategy.eval_simple_lvalue ge e m l b(Ptrofs.repr ofs)Full ->
 typeof l=tlong -> source_simple l=true -> typeof r=tlong -> source_simple r=true ->
 Cstrategy.eval_simple_rvalue ge e m r(Vlong delta) ->
 0<=ofs<=Ptrofs.max_unsigned-8 -> Mem.load Mint64 m b ofs=Some(Vlong old) ->
 Mem.store Mint64 m b ofs(Vlong(Int64.add old delta))=Some mf ->
 Cstrategy.exec_stmt ge e m(Sdo(Eassignop Oadd l r tlong tlong))E0 mf Out_normal.
Proof.
 intros e m l r b ofs old delta mf LOC TL SL TR SR RR RNG LOAD STORE.
 eapply atomic_assignop with(vl:=Vlong old)(vr:=Vlong delta)
 (vop:=Vlong(Int64.add old delta))(vc:=Vlong(Int64.add old delta))(v':=Vlong(Int64.add old delta));
 [exact LOC|exact SL|exact RR|exact SR| |rewrite TL,TR;reflexivity|rewrite TL;reflexivity| |symmetry;exact TL].
 - rewrite TL;eapply deref_loc_value;[reflexivity|reflexivity|].
   change(0<=ofs<=18446744073709551607)in RNG.
   unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change(0<=ofs<=18446744073709551615);lia).
   rewrite zle_true by(change(ofs+8<=18446744073709551616);lia);exact LOAD.
 - rewrite TL;eapply assign_scalar;[reflexivity|reflexivity|].
   change(0<=ofs<=18446744073709551607)in RNG.
   unfold Mem.storev;rewrite Ptrofs.unsigned_repr by(change(0<=ofs<=18446744073709551615);lia).
   rewrite zle_true by(change(ofs+8<=18446744073709551616);lia);exact STORE.
Qed.
Definition pos_add (coord:ident) : statement :=
 Sdo(Eassignop Oadd(global_vector_field S._pos coord it tlong)
 (Evalof(local_field S._pos_update coord it tlong)tlong)tlong tlong).
Definition source_pos_add : statement :=Ssequence(pos_add S._x)(pos_add S._y).
Lemma source_pos_add_shape :
 match fn_body S.f_gh_update_ref_from_accel_sp with
 |Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ (Ssequence a _))))=>a
 |_=>Sskip end=source_pos_add.
Proof. reflexivity. Qed.
Lemma source_pos_add_exec : forall s e m bg bu dx dy,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg ->
 e!S._pos_update=Some(bu,it) -> bg<>bu -> repr s m bg -> writable m bg ->
 Mem.load Mint64 m bu 0=Some(Vlong dx) -> Mem.load Mint64 m bu 8=Some(Vlong dy) ->
 exists mf, Cstrategy.exec_stmt ge e m source_pos_add E0 mf Out_normal /\
 repr (replace_long (replace_long s 16(Int64.add(pos_x s)dx)) 24(Int64.add(pos_y s)dy)) mf bg /\
 writable mf bg /\
 exists ma, Mem.store Mint64 m bg 16(Vlong(Int64.add(pos_x s)dx))=Some ma /\
 Mem.store Mint64 ma bg 24(Vlong(Int64.add(pos_y s)dy))=Some mf.
Proof.
 intros s e m bg bu dx dy ENV SYM LU D REP W LX LY.
 destruct(Mem.valid_access_store m Mint64 bg 16(Vlong(Int64.add(pos_x s)dx))
 (writable_long_access m bg 16 W (or_introl eq_refl)))as[m1 SX].
 assert(R1:repr(replace_long s 16(Int64.add(pos_x s)dx))m1 bg)by(eapply repr_store_long;eauto).
 assert(W1:writable m1 bg)by(eapply writable_store_long;eauto).
 assert(LY1:Mem.load Mint64 m1 bu 8=Some(Vlong dy)).
 { erewrite Mem.load_store_other by(exact SX||(left;congruence));exact LY. }
 destruct(Mem.valid_access_store m1 Mint64 bg 24(Vlong(Int64.add(pos_y s)dy))
 (writable_long_access m1 bg 24 W1 (or_intror eq_refl)))as[m2 SY].
 exists m2;split.
 - unfold source_pos_add;eapply sequence_normal.
   + unfold pos_add;eapply add_at_long with(b:=bg)(ofs:=16)(old:=pos_x s)(delta:=dx).
     * eapply global_position_location;[exact ENV|exact SYM|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply read_at_long with(b:=bu)(ofs:=0).
       -- eapply local_int64_location;[exact LU|intuition congruence].
       -- reflexivity.
       -- vm_compute;intuition discriminate.
       -- exact LX.
     * vm_compute;intuition discriminate.
     * unfold repr in REP;tauto.
     * exact SX.
   + unfold pos_add;eapply add_at_long with(b:=bg)(ofs:=24)(old:=pos_y s)(delta:=dy).
     * eapply global_position_location;[exact ENV|exact SYM|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply read_at_long with(b:=bu)(ofs:=8).
       -- eapply local_int64_location;[exact LU|intuition congruence].
       -- reflexivity.
       -- vm_compute;intuition discriminate.
       -- exact LY1.
     * vm_compute;intuition discriminate.
     * unfold repr,replace_long in R1;cbn in R1;tauto.
     * exact SY.
 - split;[eapply repr_store_long;[exact R1|right;reflexivity|exact SY]|].
   split;[eapply writable_store_long;eauto|exists m1;auto].
Qed.
Print Assumptions source_pos_add_exec.
Lemma add_at_single : forall e m l r b ofs old delta mf,
 Cstrategy.eval_simple_lvalue ge e m l b(Ptrofs.repr ofs)Full ->
 typeof l=tfloat -> source_simple l=true -> typeof r=tfloat -> source_simple r=true ->
 Cstrategy.eval_simple_rvalue ge e m r(Vsingle delta) ->
 0<=ofs<=Ptrofs.max_unsigned-4 -> Mem.load Mfloat32 m b ofs=Some(Vsingle old) ->
 Mem.store Mfloat32 m b ofs(Vsingle(Float32.add old delta))=Some mf ->
 Cstrategy.exec_stmt ge e m(Sdo(Eassignop Oadd l r tfloat tfloat))E0 mf Out_normal.
Proof.
 intros e m l r b ofs old delta mf LOC TL SL TR SR RR RNG LOAD STORE.
 eapply atomic_assignop with(vl:=Vsingle old)(vr:=Vsingle delta)
 (vop:=Vsingle(Float32.add old delta))(vc:=Vsingle(Float32.add old delta))(v':=Vsingle(Float32.add old delta));
 [exact LOC|exact SL|exact RR|exact SR| |rewrite TL,TR;reflexivity|rewrite TL;reflexivity| |symmetry;exact TL].
 - rewrite TL;eapply deref_loc_value;[reflexivity|reflexivity|].
   change(0<=ofs<=18446744073709551611)in RNG.
   unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change(0<=ofs<=18446744073709551615);lia).
   rewrite zle_true by(change(ofs+4<=18446744073709551616);lia);exact LOAD.
 - rewrite TL;eapply assign_scalar;[reflexivity|reflexivity|].
   change(0<=ofs<=18446744073709551611)in RNG.
   unfold Mem.storev;rewrite Ptrofs.unsigned_repr by(change(0<=ofs<=18446744073709551615);lia).
   rewrite zle_true by(change(ofs+4<=18446744073709551616);lia);exact STORE.
Qed.

Definition speed_add (coord:ident) : statement :=
 Sdo(Eassignop Oadd(global_vector_field S._speed coord vt tfloat)
 (Evalof(local_field S._speed_step coord vt tfloat)tfloat)tfloat tfloat).
Definition source_speed_add : statement :=Ssequence(speed_add S._x)(speed_add S._y).
Lemma source_speed_add_shape :
 match fn_body S.f_gh_update_ref_from_accel_sp with
 |Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ (Ssequence a _)))))=>a
 |_=>Sskip end=source_speed_add.
Proof. reflexivity. Qed.
Lemma source_speed_add_exec : forall s e m bg bu dx dy,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg ->
 e!S._speed_step=Some(bu,vt) -> bg<>bu -> repr s m bg -> writable m bg ->
 Mem.load Mfloat32 m bu 0=Some(Vsingle dx) -> Mem.load Mfloat32 m bu 4=Some(Vsingle dy) ->
 exists mf, Cstrategy.exec_stmt ge e m source_speed_add E0 mf Out_normal /\
 repr (replace_float (replace_float s 8(Float32.add(speed_x s)dx)) 12(Float32.add(speed_y s)dy)) mf bg /\
 writable mf bg /\
 exists ma, Mem.store Mfloat32 m bg 8(Vsingle(Float32.add(speed_x s)dx))=Some ma /\
 Mem.store Mfloat32 ma bg 12(Vsingle(Float32.add(speed_y s)dy))=Some mf.
Proof.
 intros s e m bg bu dx dy ENV SYM LU D REP W LX LY.
 destruct(Mem.valid_access_store m Mfloat32 bg 8(Vsingle(Float32.add(speed_x s)dx))
 (writable_float_access m bg 8 W ltac:(unfold float_offsets;simpl;intuition congruence)))as[m1 SX].
 assert(R1:repr(replace_float s 8(Float32.add(speed_x s)dx))m1 bg)by(eapply repr_store_float;[exact REP|unfold float_offsets;simpl;intuition congruence|exact SX]).
 assert(W1:writable m1 bg)by(eapply writable_store;eauto).
 assert(LY1:Mem.load Mfloat32 m1 bu 4=Some(Vsingle dy)).
 { erewrite Mem.load_store_other by(exact SX||(left;congruence));exact LY. }
 destruct(Mem.valid_access_store m1 Mfloat32 bg 12(Vsingle(Float32.add(speed_y s)dy))
 (writable_float_access m1 bg 12 W1 ltac:(unfold float_offsets;simpl;intuition congruence)))as[m2 SY].
 exists m2;split.
 - unfold source_speed_add;eapply sequence_normal.
   + unfold speed_add;eapply add_at_single with(b:=bg)(ofs:=8)(old:=speed_x s)(delta:=dx).
     * eapply global_vector_location;[exact ENV|exact SYM|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply read_at_single with(b:=bu)(ofs:=0).
       -- eapply local_vector_location;[exact LU|intuition congruence].
       -- reflexivity.
       -- vm_compute;intuition discriminate.
       -- exact LX.
     * vm_compute;intuition discriminate.
     * unfold repr in REP;tauto.
     * exact SX.
   + unfold speed_add;eapply add_at_single with(b:=bg)(ofs:=12)(old:=speed_y s)(delta:=dy).
     * eapply global_vector_location;[exact ENV|exact SYM|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply read_at_single with(b:=bu)(ofs:=4).
       -- eapply local_vector_location;[exact LU|intuition congruence].
       -- reflexivity.
       -- vm_compute;intuition discriminate.
       -- exact LY1.
     * vm_compute;intuition discriminate.
     * unfold repr,replace_float in R1;cbn in R1;tauto.
     * exact SY.
 - split;[eapply repr_store_float;[exact R1|unfold float_offsets;simpl;intuition congruence|exact SY]|].
   split;[eapply writable_store;eauto|exists m1;auto].
Qed.
Print Assumptions source_speed_add_exec.
Ltac prior_store_access :=
 first [assumption|
 match goal with |-Mem.valid_access ?mf _ _ _ _=>
 match goal with H:Mem.store _ _ _ _ _=Some mf|-_=>
 eapply Mem.store_valid_access_1;[exact H|prior_store_access]end end].
Ltac prior_store_load :=
 first [assumption|
 match goal with |-Mem.load _ ?mf _ _=Some _=>
 match goal with H:Mem.store _ _ _ _ _=Some mf|-_=>
 first[erewrite Mem.load_store_same by exact H;reflexivity|
 erewrite Mem.load_store_other by(exact H||(left;congruence)||(right;cbn;lia));prior_store_load]end end].
Definition integration_context (tail:statement) : statement :=
 Ssequence source_pos_step(Ssequence source_speed_step
 (Ssequence(pos_conversion S._x)(Ssequence(pos_conversion S._y)
 (Ssequence source_pos_add(Ssequence source_speed_add tail))))).
Definition actual_post_integration : statement :=
 match fn_body S.f_gh_update_ref_from_accel_sp with
 |Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ (Ssequence _ tail)))))=>tail
 |_=>Sskip end.
Lemma integration_context_shape :
 fn_body S.f_gh_update_ref_from_accel_sp=integration_context actual_post_integration.
Proof. reflexivity. Qed.
Ltac run_prefix E :=eapply star_trans with(t1:=E0)(t2:=E0);[eapply statement_prefix_path;exact E| |reflexivity].
Lemma source_integration_exec : forall s e m bg bp bs bu dx dy,
 e!S._gh_ref=None -> Genv.find_symbol ge S._gh_ref=Some bg ->
 e!S._pos_step=Some(bp,vt) -> e!S._speed_step=Some(bs,vt) -> e!S._pos_update=Some(bu,it) ->
 bg<>bp -> bg<>bs -> bg<>bu -> bp<>bs -> bp<>bu -> bs<>bu ->
 repr s m bg -> writable m bg ->
 Mem.valid_access m Mfloat32 bp 0 Writable -> Mem.valid_access m Mfloat32 bp 4 Writable ->
 Mem.valid_access m Mfloat32 bs 0 Writable -> Mem.valid_access m Mfloat32 bs 4 Writable ->
 Mem.valid_access m Mint64 bu 0 Writable -> Mem.valid_access m Mint64 bu 8 Writable ->
 pos_increment(speed_x s)(dt s)=Some dx -> pos_increment(speed_y s)(dt s)=Some dy ->
 exists mf before mx my ms,
 (forall tail out final,
 Cstrategy.exec_stmt ge e mf tail E0 final out ->
 Cstrategy.exec_stmt ge e m(integration_context tail)E0 final out) /\
 (forall f k tail,star Csem.step ge(State f(integration_context tail)k e m)E0(State f tail k e mf)) /\
 repr(integrated s dx dy)mf bg /\ writable mf bg /\ access_preserved m mf /\
 stores_to(fun b=>b=bp \/ b=bs \/ b=bu)m before /\
 Mem.store Mint64 before bg 16(Vlong(Int64.add(pos_x s)dx))=Some mx /\
 Mem.store Mint64 mx bg 24(Vlong(Int64.add(pos_y s)dy))=Some my /\
 Mem.store Mfloat32 my bg 8(Vsingle(Float32.add(speed_x s)(Float32.mul(accel_x s)(dt s))))=Some ms /\
 Mem.store Mfloat32 ms bg 12(Vsingle(Float32.add(speed_y s)(Float32.mul(accel_y s)(dt s))))=Some mf.
Proof.
 intros s e m bg bp bs bu dx dy ENV SYM LP LS LU DGP DGS DGU DPS DPU DSU REP W AP0 AP4 AS0 AS4 AU0 AU8 CX CY.
 destruct(source_pos_step_exec s e m bg bp ENV SYM LP DGP REP W AP0 AP4)
 as[m1[E1[R1[W1[PX1[PY1[p1[SPX SPY]]]]]]]].
 assert(AS01:Mem.valid_access m1 Mfloat32 bs 0 Writable)by prior_store_access.
 assert(AS41:Mem.valid_access m1 Mfloat32 bs 4 Writable)by prior_store_access.
 destruct(source_speed_step_exec s e m1 bg bs ENV SYM LS DGS R1 W1 AS01 AS41)
 as[m2[E2[R2[W2[SX2[SY2[p2[SSX SSY]]]]]]]].
 assert(PX2:Mem.load Mfloat32 m2 bp 0=Some(Vsingle(Float32.mul(speed_x s)(dt s))))by prior_store_load.
 assert(PY2:Mem.load Mfloat32 m2 bp 4=Some(Vsingle(Float32.mul(speed_y s)(dt s))))by prior_store_load.
 assert(AU02:Mem.valid_access m2 Mint64 bu 0 Writable)by prior_store_access.
 assert(AU82:Mem.valid_access m2 Mint64 bu 8 Writable)by prior_store_access.
 unfold pos_increment in CX,CY.
 destruct(source_pos_conversion_exec s e m2 bg bp bu _ _ dx dy LP LU DGU DPU R2 W2 PX2 PY2 CX CY AU02 AU82)
 as[m3[E3[R3[W3[UX3[UY3[p3[SUX SUY]]]]]]]].
 destruct(source_pos_add_exec s e m3 bg bu dx dy ENV SYM LU DGU R3 W3 UX3 UY3)
 as[m4[E4[R4[W4[p4[SGPX SGPY]]]]]].
 assert(SX4:Mem.load Mfloat32 m4 bs 0=Some(Vsingle(Float32.mul(accel_x s)(dt s))))by prior_store_load.
 assert(SY4:Mem.load Mfloat32 m4 bs 4=Some(Vsingle(Float32.mul(accel_y s)(dt s))))by prior_store_load.
 destruct(source_speed_add_exec _ e m4 bg bs _ _ ENV SYM LS DGS R4 W4 SX4 SY4)
 as[m5[E5[R5[W5[p5[SGSX SGSY]]]]]].
 change(repr(integrated s dx dy)m5 bg)in R5.
 assert(HISTORY:stores_to(fun b=>b=bg \/ b=bp \/ b=bs \/ b=bu)m m5).
 { eapply stores_to_step;[right;left;reflexivity|exact SPX|].
   eapply stores_to_step;[right;left;reflexivity|exact SPY|].
   eapply stores_to_step;[right;right;left;reflexivity|exact SSX|].
   eapply stores_to_step;[right;right;left;reflexivity|exact SSY|].
   eapply stores_to_step;[right;right;right;reflexivity|exact SUX|].
   eapply stores_to_step;[right;right;right;reflexivity|exact SUY|].
   eapply stores_to_step;[left;reflexivity|exact SGPX|].
   eapply stores_to_step;[left;reflexivity|exact SGPY|].
   eapply stores_to_step;[left;reflexivity|exact SGSX|].
   eapply stores_to_step;[left;reflexivity|exact SGSY|constructor]. }
 exists m5,m3,p4,m4,p5;split.
 - intros tail out final TAIL;unfold integration_context.
   destruct(sequence_normal_inv ge e _ _ _ _ E3)as[mc[EX EY]].
   eapply sequence_normal;[exact E1|]. eapply sequence_normal;[exact E2|].
   eapply sequence_normal;[exact EX|]. eapply sequence_normal;[exact EY|].
   eapply sequence_normal;[exact E4|]. eapply sequence_normal;[exact E5|exact TAIL].
 - split.
 {   intros f k tail;unfold integration_context.
   destruct(sequence_normal_inv ge e _ _ _ _ E3)as[mc[EX EY]].
   run_prefix E1. run_prefix E2. run_prefix EX. run_prefix EY. run_prefix E4.
   eapply statement_prefix_path;exact E5.
 }
 split;[exact R5|]. split;[exact W5|]. split;[eapply stores_to_access;exact HISTORY|].
   split.
   + eapply stores_to_step;[left;reflexivity|exact SPX|].
     eapply stores_to_step;[left;reflexivity|exact SPY|].
     eapply stores_to_step;[right;left;reflexivity|exact SSX|].
     eapply stores_to_step;[right;left;reflexivity|exact SSY|].
     eapply stores_to_step;[right;right;reflexivity|exact SUX|].
     eapply stores_to_step;[right;right;reflexivity|exact SUY|constructor].
   + repeat split;assumption.
Qed.
Print Assumptions source_integration_exec.
Definition saturation_function_type:=Tfunction((tptr vt)::nil)tvoid cc_default.
Definition saturation_call:statement:=Sdo(Ecall
 (Evalof(Evar S._gh_saturate_accel saturation_function_type)saturation_function_type)
 (Econs(Eaddrof(Evar S._accel_sp vt)(tptr vt))Enil)tvoid).
Definition after_saturation:statement:=match actual_post_integration with Ssequence _ tail=>tail|_=>Sskip end.
Lemma saturation_tail_shape:actual_post_integration=Ssequence saturation_call after_saturation.
Proof. reflexivity. Qed.
Definition saturation_block:block:=
 match Genv.find_symbol ge S._gh_saturate_accel with Some b=>b|None=>1%positive end.
Lemma saturation_symbol:Genv.find_symbol ge S._gh_saturate_accel=Some saturation_block.
Proof. reflexivity. Qed.
Lemma saturation_funct:Genv.find_funct ge(Vptr saturation_block Ptrofs.zero)=Some(Internal S.f_gh_saturate_accel).
Proof. reflexivity. Qed.
Lemma saturation_call_original_exact_path:forall e m ba f k tail,
 e!S._gh_saturate_accel=None ->e!S._accel_sp=Some(ba,vt) ->
 star Csem.step ge(State f(Ssequence saturation_call tail)k e m)E0
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero](Kcall f e(fun x=>x)tvoid(Kdo(Kseq tail k)))m).
Proof.
 intros e m ba f k tail EH LA.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_seq| |reflexivity].
 unfold saturation_call.
 eapply star_step with(t1:=E0)(t2:=E0);[right;apply Csem.step_do_1| |reflexivity].
 apply plus_star;apply Cstrategy.step_simulation;left.
 change(Cstrategy.estep ge
 (ExprState f((fun x=>x)(Ecall
 (Evalof(Evar S._gh_saturate_accel saturation_function_type)saturation_function_type)
 (Econs(Eaddrof(Evar S._accel_sp vt)(tptr vt))Enil)tvoid))(Kdo(Kseq tail k))e m)
 E0(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]
 (Kcall f e(fun x=>x)tvoid(Kdo(Kseq tail k)))m)).
 eapply Cstrategy.step_call with(vf:=Vptr saturation_block Ptrofs.zero).
 - constructor.
 - reflexivity.
 - eapply Cstrategy.esr_rvalof.
   + eapply Cstrategy.esl_var_global;[exact EH|exact saturation_symbol].
   + reflexivity.
   + reflexivity.
   + apply deref_loc_reference;reflexivity.
 - econstructor.
   + eapply Cstrategy.esr_addrof;apply Cstrategy.esl_var_local;exact LA.
   + reflexivity.
   + constructor.
 - exact saturation_funct.
 - reflexivity.
Qed.
Lemma read_local_vector : forall e m id b coord ofs x,
 e!id=Some(b,vt) -> (coord=S._x /\ ofs=0 \/ coord=S._y /\ ofs=4) ->
 Mem.load Mfloat32 m b ofs=Some(Vsingle x) ->
 Cstrategy.eval_simple_rvalue ge e m(f_read(local_field id coord vt tfloat))(Vsingle x).
Proof.
 intros e m id b coord ofs x LOOK OFF LOAD.
 eapply read_at_single with(b:=b)(ofs:=ofs).
 - eapply local_vector_location;eauto.
 - reflexivity.
 - destruct OFF as[[-> ->]|[-> ->]];vm_compute;intuition discriminate.
 - exact LOAD.
Qed.
