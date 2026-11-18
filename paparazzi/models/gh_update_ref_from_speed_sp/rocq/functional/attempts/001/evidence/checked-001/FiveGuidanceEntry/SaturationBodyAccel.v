From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceEntry Require Import Entry SoftwareSqrt BigstepSupport EffectfulSupport AccelPrefix.
Require FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhAccel.Source.
Definition old_load_frame(m mf:mem):Prop:=forall ch b ofs,Mem.valid_block m b ->Mem.load ch mf b ofs=Mem.load ch m b ofs.
Definition old_bytes_frame(m mf:mem):Prop:=forall b ofs n,Mem.valid_block m b ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Definition sqrt_call_contract:Prop:=forall m x,exists mf,
 Cstrategy.eval_funcall ge m(Internal S.f_five_sqrtf)[Vsingle x]E0 mf(Vsingle(software_sqrt x)) /\
 access_preserved m mf /\old_load_frame m mf /\old_bytes_frame m mf.
Definition pointer_read:expr:=Evalof(Evar S._accel_sp(tptr vt))(tptr vt).
Definition accel_field(coord:ident):expr:=Efield(Evalof(Ederef pointer_read vt)vt)coord tfloat.
Definition accel_read(coord:ident):expr:=Evalof(accel_field coord)tfloat.
Definition named_read(id:ident):expr:=Evalof(Evar id tfloat)tfloat.
Definition norm_statement:statement:=Sdo(Eassign(Evar S._a_norm2 tfloat)
 (Ebinop Oadd(Ebinop Omul(accel_read S._x)(accel_read S._x)tfloat)
 (Ebinop Omul(accel_read S._y)(accel_read S._y)tfloat)tfloat)tfloat).
Definition sqrt_function_type:=Tfunction(tfloat::nil)tfloat cc_default.
Definition sqrt_rf:=Evalof(Evar S._five_sqrtf sqrt_function_type)sqrt_function_type.
Definition sqrt_call:=Ecall sqrt_rf(Econs(named_read S._a_norm2)Enil)tfloat.
Definition factor_statement:=Sdo(Eassign(Evar S._factor tfloat)
 (Ebinop Odiv(named_read S._gh_max_accel)sqrt_call tfloat)tfloat).
Definition scale_component(coord:ident):statement:=Sdo(Eassign(accel_field coord)
 (Ebinop Omul(accel_read coord)(named_read S._factor)tfloat)tfloat).
Definition scale_pair:=Ssequence(scale_component S._x)(scale_component S._y).
Definition sat_branch_statement:=Ssequence factor_statement scale_pair.
Definition condition_expr:=Ebinop Ogt(named_read S._a_norm2)
 (Ebinop Omul(named_read S._gh_max_accel)(named_read S._gh_max_accel)tfloat)tint.
Lemma saturation_body_shape:fn_body S.f_gh_saturate_accel=
 Ssequence norm_statement(Sifthenelse condition_expr sat_branch_statement Sskip).
Proof. reflexivity. Qed.
Lemma loaded_valid_block:forall ch m b ofs v,Mem.load ch m b ofs=Some v ->Mem.valid_block m b.
Proof.
 intros;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact H|constructor].
Qed.
Lemma read_named:forall e m id b x,
 e!id=Some(b,tfloat) ->Mem.load Mfloat32 m b 0=Some(Vsingle x) ->
 Cstrategy.eval_simple_rvalue ge e m(named_read id)(Vsingle x).
Proof.
 intros;eapply read_at_single with(b:=b)(ofs:=0).
 - apply Cstrategy.esl_var_local;exact H.
 - reflexivity.
 - vm_compute;intuition discriminate.
 - exact H0.
Qed.
Lemma read_maximum:forall e m bc maximum,
 e!S._gh_max_accel=None ->Genv.find_symbol ge S._gh_max_accel=Some bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Cstrategy.eval_simple_rvalue ge e m(named_read S._gh_max_accel)(Vsingle maximum).
Proof.
 intros;eapply read_at_single with(b:=bc)(ofs:=0).
 - eapply Cstrategy.esl_var_global;eauto.
 - reflexivity.
 - vm_compute;intuition discriminate.
 - exact H1.
Qed.
Lemma read_pointer:forall e m bp ba,
 e!S._accel_sp=Some(bp,tptr vt) ->Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 Cstrategy.eval_simple_rvalue ge e m pointer_read(Vptr ba Ptrofs.zero).
Proof.
 intros e m bp ba LOOK LOAD;unfold pointer_read;eapply Cstrategy.esr_rvalof.
 - apply Cstrategy.esl_var_local;exact LOOK.
 - reflexivity.
 - reflexivity.
 - eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact LOAD|change(0+8<=18446744073709551616);lia].
Qed.
Lemma accel_location:forall e m bp ba coord ofs,
 e!S._accel_sp=Some(bp,tptr vt) ->Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 (coord=S._x /\ofs=0 \/coord=S._y /\ofs=4) ->
 Cstrategy.eval_simple_lvalue ge e m(accel_field coord)ba(Ptrofs.repr ofs)Full.
Proof.
 intros e m bp ba coord ofs LOOK LOAD [[-> ->]|[-> ->]];unfold accel_field;
 rewrite <-Ptrofs.add_zero_l at 1.
 all:eapply Cstrategy.esl_field_struct;
 [eapply Cstrategy.esr_rvalof;
 [eapply Cstrategy.esl_deref;eapply read_pointer;eauto|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]|
 reflexivity|reflexivity|reflexivity].
Qed.
Lemma read_accel:forall e m bp ba coord ofs x,
 e!S._accel_sp=Some(bp,tptr vt) ->Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 (coord=S._x /\ofs=0 \/coord=S._y /\ofs=4) ->Mem.load Mfloat32 m ba ofs=Some(Vsingle x) ->
 Cstrategy.eval_simple_rvalue ge e m(accel_read coord)(Vsingle x).
Proof.
 intros e m bp ba coord ofs x LP PTR OFF LOAD;unfold accel_read;eapply read_at_single with(b:=ba)(ofs:=ofs).
 - eapply accel_location;eauto.
 - reflexivity.
 - destruct OFF as[[-> ->]|[-> ->]];vm_compute;intuition discriminate.
 - exact LOAD.
Qed.
Print Assumptions accel_location.
Definition sqrt_block:block:=match Genv.find_symbol ge S._five_sqrtf with Some b=>b|None=>1%positive end.
Lemma sqrt_symbol:Genv.find_symbol ge S._five_sqrtf=Some sqrt_block.
Proof. reflexivity. Qed.
Lemma sqrt_funct:Genv.find_funct ge(Vptr sqrt_block Ptrofs.zero)=Some(Internal S.f_five_sqrtf).
Proof. reflexivity. Qed.
Lemma read_sqrt_function:forall e m,e!S._five_sqrtf=None ->
 Cstrategy.eval_simple_rvalue ge e m sqrt_rf(Vptr sqrt_block Ptrofs.zero).
Proof.
 intros e m ENV;unfold sqrt_rf;eapply Cstrategy.esr_rvalof.
 - eapply Cstrategy.esl_var_global;[exact ENV|exact sqrt_symbol].
 - reflexivity.
 - reflexivity.
 - apply deref_loc_reference;reflexivity.
Qed.
Lemma factor_statement_exec:forall e m bn bf bc n maximum,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 Mem.load Mfloat32 m bn 0=Some(Vsingle n) ->Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bf 0 Writable ->
 exists mf mc,
 Cstrategy.exec_stmt ge e m factor_statement E0 mf Out_normal /\
 Mem.store Mfloat32 mc bf 0(Vsingle(Float32.div maximum(software_sqrt n)))=Some mf /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bf ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bf ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bn bf bc n maximum CONTRACT ES EM SYM LN LF LOADN LOADC ACCESS.
 destruct(CONTRACT m n)as[mc[CALL[KEEP[FRAME BFRAME]]]].
 assert(RF:Cstrategy.eval_simple_rvalue ge e m sqrt_rf(Vptr sqrt_block Ptrofs.zero))by(eapply read_sqrt_function;exact ES).
 assert(RN:Cstrategy.eval_simple_rvalue ge e m(named_read S._a_norm2)(Vsingle n))by(eapply read_named;eauto).
 assert(RM:Cstrategy.eval_simple_rvalue ge e m(named_read S._gh_max_accel)(Vsingle maximum))by(eapply read_maximum;eauto).
 assert(EXPR:Cstrategy.eval_expr ge e m RV
 (Ebinop Odiv(named_read S._gh_max_accel)sqrt_call tfloat)E0 mc
 (Ebinop Odiv(named_read S._gh_max_accel)(Eval(Vsingle(software_sqrt n))tfloat)tfloat)).
 { replace E0 with(E0**E0)by reflexivity;eapply Cstrategy.eval_binop.
   - eapply(proj1(simple_eval_expr_refl ge e m));[exact RM|reflexivity].
   - unfold sqrt_call;eapply simple_call_expr with(vf:=Vptr sqrt_block Ptrofs.zero)(fd:=Internal S.f_five_sqrtf)(targs:=[tfloat])(tres:=tfloat)(cc:=cc_default)(vargs:=[Vsingle n]).
     + exact RF.
     + reflexivity.
     + econstructor;[exact RN|reflexivity|constructor].
     + reflexivity.
     + reflexivity.
     + exact sqrt_funct.
     + reflexivity.
     + exact CALL. }
 assert(CVALID:Mem.valid_block m bc)by(eapply loaded_valid_block;exact LOADC).
 assert(LOADMC:Mem.load Mfloat32 mc bc 0=Some(Vsingle maximum))by(rewrite FRAME by exact CVALID;exact LOADC).
 assert(RMC:Cstrategy.eval_simple_rvalue ge e mc(named_read S._gh_max_accel)(Vsingle maximum))by(eapply read_maximum;eauto).
 destruct(Mem.valid_access_store mc Mfloat32 bf 0(Vsingle(Float32.div maximum(software_sqrt n)))(KEEP _ _ _ _ ACCESS))as[mf STORE].
 exists mf,mc;split.
 - unfold factor_statement;eapply effectful_assign with(mr:=mc)
 (r':=Ebinop Odiv(named_read S._gh_max_accel)(Eval(Vsingle(software_sqrt n))tfloat)tfloat)
 (v:=Vsingle(Float32.div maximum(software_sqrt n)))(vc:=Vsingle(Float32.div maximum(software_sqrt n)))
 (v':=Vsingle(Float32.div maximum(software_sqrt n)))(b:=bf)(ofs:=Ptrofs.zero)(bf:=Full).
   + apply Cstrategy.esl_var_local;exact LF.
   + reflexivity.
   + exact EXPR.
   + apply Cstrategy.esl_var_local;exact LF.
   + eapply Cstrategy.esr_binop;[exact RMC|constructor|reflexivity].
   + reflexivity.
   + eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact STORE|change(0+4<=18446744073709551616);lia].
   + reflexivity.
 - split;[exact STORE|]. split.
   + unfold access_preserved in *;intros;eapply Mem.store_valid_access_1;[exact STORE|apply KEEP;assumption].
   + split.
     * intros ch b ofs VB D;erewrite Mem.load_store_other by(exact STORE||(left;exact D));apply FRAME;exact VB.
     * intros b ofs nbytes VB D;erewrite Mem.loadbytes_store_other by(exact STORE||(left;exact D));apply BFRAME;exact VB.
Qed.
Print Assumptions factor_statement_exec.
Lemma scale_pair_exec:forall e m bp ba bf a factor,
 e!S._accel_sp=Some(bp,tptr vt) ->e!S._factor=Some(bf,tfloat) ->ba<>bp ->ba<>bf ->
 Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.load Mfloat32 m bf 0=Some(Vsingle factor) ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf ma,Cstrategy.exec_stmt ge e m scale_pair E0 mf Out_normal /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(Float32.mul(vx a)factor)) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(Float32.mul(vy a)factor)) /\access_preserved m mf /\
 Mem.store Mfloat32 m ba 0(Vsingle(Float32.mul(vx a)factor))=Some ma /\
 Mem.store Mfloat32 ma ba 4(Vsingle(Float32.mul(vy a)factor))=Some mf.
Proof.
 intros e m bp ba bf a factor LP LF DBP DBF PTR LX LY LOADF A0 A4.
 destruct(Mem.valid_access_store m Mfloat32 ba 0(Vsingle(Float32.mul(vx a)factor))A0)as[m1 SX].
 assert(A41:Mem.valid_access m1 Mfloat32 ba 4 Writable)by prior_store_access.
 assert(PTR1:Mem.load Mint64 m1 bp 0=Some(Vptr ba Ptrofs.zero))by prior_store_load.
 assert(LY1:Mem.load Mfloat32 m1 ba 4=Some(Vsingle(vy a)))by prior_store_load.
 assert(LF1:Mem.load Mfloat32 m1 bf 0=Some(Vsingle factor))by prior_store_load.
 destruct(Mem.valid_access_store m1 Mfloat32 ba 4(Vsingle(Float32.mul(vy a)factor))A41)as[m2 SY].
 exists m2,m1;split.
 - unfold scale_pair;eapply sequence_normal.
   + unfold scale_component;eapply write_at_single with(b:=ba)(ofs:=0)(x:=Float32.mul(vx a)factor).
     * eapply accel_location;[exact LP|exact PTR|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply Cstrategy.esr_binop.
       -- eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       -- eapply read_named;[exact LF|exact LOADF].
       -- reflexivity.
     * vm_compute;intuition discriminate.
     * exact SX.
   + unfold scale_component;eapply write_at_single with(b:=ba)(ofs:=4)(x:=Float32.mul(vy a)factor).
     * eapply accel_location;[exact LP|exact PTR1|intuition congruence].
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * eapply Cstrategy.esr_binop.
       -- eapply read_accel;[exact LP|exact PTR1|intuition congruence|exact LY1].
       -- eapply read_named;[exact LF|exact LF1].
       -- reflexivity.
     * vm_compute;intuition discriminate.
     * exact SY.
 - split;[prior_store_load|]. split;[prior_store_load|]. split.
   + unfold access_preserved;intros;prior_store_access.
   + auto.
Qed.
Print Assumptions scale_pair_exec.
Lemma saturation_body_exec:forall e m bp bn bf ba bc a maximum,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._accel_sp=Some(bp,tptr vt) ->e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 ba<>bp ->bn<>bp ->bn<>ba ->bn<>bc ->bf<>bp ->bf<>ba ->
 Mem.load Mint64 m bp 0=Some(Vptr ba Ptrofs.zero) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bn 0 Writable ->Mem.valid_access m Mfloat32 bf 0 Writable ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf,Cstrategy.exec_stmt ge e m(fn_body S.f_gh_saturate_accel)E0 mf Out_normal /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bn ->b<>bf ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bn ->b<>bf ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bp bn bf ba bc a maximum CONTRACT ES EM SYM LP LN LF DAP DNP DNA DNC DFP DFA PTR LX LY LC AN AF AA0 AA4.
 destruct(Mem.valid_access_store m Mfloat32 bn 0(Vsingle(norm2 a))AN)as[m1 SN].
 assert(NORM:Cstrategy.exec_stmt ge e m norm_statement E0 m1 Out_normal).
 { unfold norm_statement;eapply write_at_single with(b:=bn)(ofs:=0)(x:=norm2 a).
   - apply Cstrategy.esl_var_local;exact LN.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - reflexivity.
   - unfold norm2;eapply Cstrategy.esr_binop.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LX].
       * reflexivity.
     + eapply Cstrategy.esr_binop.
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LY].
       * eapply read_accel;[exact LP|exact PTR|intuition congruence|exact LY].
       * reflexivity.
     + reflexivity.
   - vm_compute;intuition discriminate.
   - exact SN. }
 assert(PTR1:Mem.load Mint64 m1 bp 0=Some(Vptr ba Ptrofs.zero))by prior_store_load.
 assert(LX1:Mem.load Mfloat32 m1 ba 0=Some(Vsingle(vx a)))by prior_store_load.
 assert(LY1:Mem.load Mfloat32 m1 ba 4=Some(Vsingle(vy a)))by prior_store_load.
 assert(LC1:Mem.load Mfloat32 m1 bc 0=Some(Vsingle maximum))by prior_store_load.
 assert(LN1:Mem.load Mfloat32 m1 bn 0=Some(Vsingle(norm2 a)))by prior_store_load.
 assert(AF1:Mem.valid_access m1 Mfloat32 bf 0 Writable)by prior_store_access.
 assert(AA01:Mem.valid_access m1 Mfloat32 ba 0 Writable)by prior_store_access.
 assert(AA41:Mem.valid_access m1 Mfloat32 ba 4 Writable)by prior_store_access.
 assert(CMP:Cstrategy.eval_simple_rvalue ge e m1 condition_expr(Val.of_bool(saturation_branch maximum a))).
 { unfold condition_expr,saturation_branch;eapply Cstrategy.esr_binop.
   - eapply read_named;[exact LN|exact LN1].
   - eapply Cstrategy.esr_binop;
     [eapply read_maximum;[exact EM|exact SYM|exact LC1]|
      eapply read_maximum;[exact EM|exact SYM|exact LC1]|reflexivity].
   - reflexivity. }
 destruct(saturation_branch maximum a)eqn:BR.
 - destruct(factor_statement_exec e m1 bn bf bc(norm2 a)maximum CONTRACT ES EM SYM LN LF LN1 LC1 AF1)
   as[m2[mc[FACTOR[SF[APF[FRAME BFRAME]]]]]].
   assert(PTR2:Mem.load Mint64 m2 bp 0=Some(Vptr ba Ptrofs.zero)).
   { rewrite FRAME;[exact PTR1|eapply loaded_valid_block;exact PTR1|congruence]. }
   assert(LX2:Mem.load Mfloat32 m2 ba 0=Some(Vsingle(vx a))).
   { rewrite FRAME;[exact LX1|eapply loaded_valid_block;exact LX1|congruence]. }
   assert(LY2:Mem.load Mfloat32 m2 ba 4=Some(Vsingle(vy a))).
   { rewrite FRAME;[exact LY1|eapply loaded_valid_block;exact LY1|congruence]. }
   assert(LF2:Mem.load Mfloat32 m2 bf 0=Some(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))).
   { erewrite Mem.load_store_same by exact SF;reflexivity. }
   destruct(scale_pair_exec e m2 bp ba bf a(Float32.div maximum(software_sqrt(norm2 a)))
   LP LF DAP ltac:(congruence) PTR2 LX2 LY2 LF2(APF _ _ _ _ AA01)(APF _ _ _ _ AA41))
   as[mf[ms[SCALE[AX[AY[APS[SX SY]]]]]]].
   exists mf;split.
   + rewrite saturation_body_shape;eapply sequence_normal;[exact NORM|].
     replace E0 with(E0**E0)by reflexivity;eapply Cstrategy.exec_Sifthenelse with(v1:=Val.of_bool true)(b:=true)(m1:=m1).
     * eapply simple_expression;[exact CMP|reflexivity].
     * reflexivity.
     * cbn;eapply sequence_normal;[exact FACTOR|exact SCALE].
   + unfold saturate,saturate_using;rewrite BR;cbn;split;[exact AX|]. split;[exact AY|]. split.
     * unfold access_preserved in *;intros;apply APS;apply APF;prior_store_access.
     * split.
       { intros ch b ofs VB DBN DBF DBA.
         erewrite Mem.load_store_other by(exact SY||(left;exact DBA)).
         erewrite Mem.load_store_other by(exact SX||(left;exact DBA)).
         rewrite FRAME;[|eapply Mem.store_valid_block_1;eauto|exact DBF].
         erewrite Mem.load_store_other by(exact SN||(left;exact DBN));reflexivity. }
       intros b ofs nbytes VB DBN DBF DBA.
       erewrite Mem.loadbytes_store_other by(exact SY||(left;exact DBA)).
       erewrite Mem.loadbytes_store_other by(exact SX||(left;exact DBA)).
       rewrite BFRAME;[|eapply Mem.store_valid_block_1;eauto|exact DBF].
       erewrite Mem.loadbytes_store_other by(exact SN||(left;exact DBN));reflexivity.
 - exists m1;split.
   + rewrite saturation_body_shape;eapply sequence_normal;[exact NORM|].
     replace E0 with(E0**E0)by reflexivity;eapply Cstrategy.exec_Sifthenelse with(v1:=Val.of_bool false)(b:=false)(m1:=m1).
     * eapply simple_expression;[exact CMP|reflexivity].
     * reflexivity.
     * cbn;constructor.
   + unfold saturate,saturate_using;rewrite BR;cbn;split;[exact LX1|]. split;[exact LY1|]. split.
     * unfold access_preserved;intros;prior_store_access.
     * split.
       { intros ch b ofs VB DBN DBF DBA;erewrite Mem.load_store_other by(exact SN||(left;exact DBN));reflexivity. }
       intros b ofs nbytes VB DBN DBF DBA;erewrite Mem.loadbytes_store_other by(exact SN||(left;exact DBN));reflexivity.
Qed.
Print Assumptions saturation_body_exec.
