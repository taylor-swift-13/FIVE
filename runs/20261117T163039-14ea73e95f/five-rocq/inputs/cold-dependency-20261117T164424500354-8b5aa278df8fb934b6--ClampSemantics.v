From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy IEEE754_extra Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationAttempt002 Require Import EntryPrefix FloatConstants.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.

Local Transparent Float.to_int Float.of_int.
Lemma signed_int_double_roundtrip : forall n,
 Float.to_int(Float.of_int n)=Some n.
Proof.
 intros n;unfold Float.to_int,Float.of_int,ZofB_range.
 rewrite ZofBofZ_exact.
 2:{ apply IEEE754_extra.integer_representable_n;try reflexivity.
     pose proof(Int.signed_range n) as RANGE;change(-2147483648<=Int.signed n<=2147483647)in RANGE;change(-9007199254740992<=Int.signed n<=9007199254740992);lia. }
 assert (LO : (Int.min_signed<=?Int.signed n)=true).
 { apply Z.leb_le;pose proof(Int.signed_range n);lia. }
 assert (HI : (Int.signed n<=?Int.max_signed)=true).
 { apply Z.leb_le;pose proof(Int.signed_range n);lia. }
 rewrite LO,HI;cbn;rewrite Int.repr_signed;reflexivity.
Qed.

Local Opaque Float.to_int Float.of_int.
Lemma conditional_expression : forall ge e m test yes no ty vt vb vbranch v,
 Cstrategy.eval_expression ge e m test E0 m vt ->
 bool_val vt(typeof test)m=Some vb ->
 Cstrategy.eval_expression ge e m(if vb then yes else no)E0 m vbranch ->
 sem_cast vbranch(typeof(if vb then yes else no))ty m=Some v ->
 Cstrategy.eval_expression ge e m(Econdition test yes no ty)E0 m v.
Proof.
 intros ge e m test yes no ty vt vb vbranch v TEST BOOL BRANCH CAST.
 inversion TEST as [e0 m0 a0 t0 m0' a0' vv0 EV0 VAL0];subst.
 inversion BRANCH as [e1 m1 a1 t1 m1' a1' vv1 EV1 VAL1];subst.
 eapply Cstrategy.eval_expression_intro with(a':=Eval v ty);[|constructor].
 replace E0 with(E0**E0)by reflexivity.
 eapply Cstrategy.eval_condition;eauto.
Qed.

Definition source_bound (shift:Z) :=
 Ebinop Omul(Eval(Vfloat(Float.of_bits(Int64.repr 4625196817309499392)))tdouble)
 (Ebinop Oshl(Eval(Vint(Int.repr 1))tint)(Eval(Vint(Int.repr shift))tint)tint)tdouble.
Definition source_clamp (r:expr) (shift:Z) :=
 Econdition(Ebinop Olt r(Eunop Oneg(source_bound shift)tdouble)tint)
 (Eunop Oneg(source_bound shift)tdouble)
 (Econdition(Ebinop Ogt r(source_bound shift)tint)(source_bound shift)r tdouble)tdouble.
Definition original_position_clamp (axis:ident) :=
 Sdo(Eassign(pid_axis_lvalue Source._guidance_pid_pos_err axis)
 (source_clamp(Evalof(pid_axis_lvalue Source._guidance_pid_pos_err axis)tint)8)tint).
Definition original_speed_clamp (axis:ident) :=
 Sdo(Eassign(pid_axis_lvalue Source._guidance_pid_speed_err axis)
 (source_clamp(Evalof(pid_axis_lvalue Source._guidance_pid_speed_err axis)tint)19)tint).

Local Opaque Execution.ge.
Local Transparent Float.of_int Float.mul Float.of_bits.
Lemma source_bound_8 : forall e m,
 Cstrategy.eval_simple_rvalue Execution.ge e m(source_bound 8)(Vfloat(Float.of_int(Int.repr 4096))).
Proof.
 intros;unfold source_bound;eapply Cstrategy.esr_binop.
 - constructor.
 - eapply Cstrategy.esr_binop;[constructor|constructor|reflexivity].
 - change(Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4625196817309499392))(Float.of_int(Int.repr 256))))=Some(Vfloat(Float.of_int(Int.repr 4096)))).
   apply(f_equal(fun f=>Some(Vfloat f)));apply float_bits_ext;reflexivity.
Qed.
Lemma source_bound_19 : forall e m,
 Cstrategy.eval_simple_rvalue Execution.ge e m(source_bound 19)(Vfloat(Float.of_int(Int.repr 8388608))).
Proof.
 intros;unfold source_bound;eapply Cstrategy.esr_binop.
 - constructor.
 - eapply Cstrategy.esr_binop;[constructor|constructor|reflexivity].
 - change(Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4625196817309499392))(Float.of_int(Int.repr 524288))))=Some(Vfloat(Float.of_int(Int.repr 8388608)))).
   apply(f_equal(fun f=>Some(Vfloat f)));apply float_bits_ext;reflexivity.
Qed.

Local Opaque Float.of_int Float.mul Float.of_bits.
Lemma source_clamp_expression : forall e m r err shift bound,
 typeof r=tint -> source_simple r=true ->
 Cstrategy.eval_simple_rvalue Execution.ge e m r(Vint err) ->
 Cstrategy.eval_simple_rvalue Execution.ge e m(source_bound shift)(Vfloat(Float.of_int bound)) ->
 Float.neg(Float.of_int bound)=Float.of_int(Int.neg bound) ->
 exists chosen,
 Cstrategy.eval_expression Execution.ge e m(source_clamp r shift)E0 m(Vfloat(Float.of_int chosen)).
Proof.
 intros e m r err shift bound TY SIMPLE READ BOUND NEG.
 set (below:=Float.cmp Clt(Float.of_int err)(Float.of_int(Int.neg bound))).
 set (above:=Float.cmp Cgt(Float.of_int err)(Float.of_int bound)).
 assert (LOW : Cstrategy.eval_simple_rvalue Execution.ge e m
   (Eunop Oneg(source_bound shift)tdouble)(Vfloat(Float.of_int(Int.neg bound)))).
 { eapply Cstrategy.esr_unop;[exact BOUND|]. change(Some(Vfloat(Float.neg(Float.of_int bound)))=Some(Vfloat(Float.of_int(Int.neg bound)))). rewrite NEG;reflexivity. }
 assert (LT : Cstrategy.eval_expression Execution.ge e m
   (Ebinop Olt r(Eunop Oneg(source_bound shift)tdouble)tint)E0 m(Val.of_bool below)).
 { apply simple_expression.
   - eapply Cstrategy.esr_binop;[exact READ|exact LOW|].
     rewrite TY;reflexivity.
   - cbn[source_simple];rewrite SIMPLE;reflexivity. }
 assert (GT : Cstrategy.eval_expression Execution.ge e m
   (Ebinop Ogt r(source_bound shift)tint)E0 m(Val.of_bool above)).
 { apply simple_expression.
   - eapply Cstrategy.esr_binop;[exact READ|exact BOUND|]. rewrite TY;reflexivity.
   - cbn[source_simple];rewrite SIMPLE;reflexivity. }
 unfold source_clamp.
 destruct below eqn:BELOW.
 - exists(Int.neg bound).
   eapply conditional_expression with(vt:=Val.of_bool true)(vb:=true)
    (vbranch:=Vfloat(Float.of_int(Int.neg bound)));try exact LT;try reflexivity.
   apply simple_expression;[exact LOW|reflexivity].
 - destruct above eqn:ABOVE.
   + exists bound.
     eapply conditional_expression with(vt:=Val.of_bool false)(vb:=false)
      (vbranch:=Vfloat(Float.of_int bound));try exact LT;try reflexivity.
     eapply conditional_expression with(vt:=Val.of_bool true)(vb:=true)
      (vbranch:=Vfloat(Float.of_int bound));try exact GT;try reflexivity.
     apply simple_expression;[exact BOUND|reflexivity].
   + exists err.
     eapply conditional_expression with(vt:=Val.of_bool false)(vb:=false)
      (vbranch:=Vfloat(Float.of_int err));try exact LT;try reflexivity.
     eapply conditional_expression with(vt:=Val.of_bool false)(vb:=false)
      (vbranch:=Vint err);try exact GT;try reflexivity.
     * apply simple_expression;[exact READ|exact SIMPLE].
     * rewrite TY;reflexivity.
Qed.

Lemma source_clamp_assignment_exists : forall e m l err shift bound eb eofs,
 typeof l=tint -> source_simple l=true ->
 Cstrategy.eval_simple_lvalue Execution.ge e m l eb eofs Full ->
 Mem.loadv Mint32 m(Vptr eb eofs)=Some(Vint err) ->
 Mem.valid_access m Mint32 eb(Ptrofs.unsigned eofs) Writable ->
 Cstrategy.eval_simple_rvalue Execution.ge e m(source_bound shift)(Vfloat(Float.of_int bound)) ->
 Float.neg(Float.of_int bound)=Float.of_int(Int.neg bound) ->
 exists chosen mf,
 Cstrategy.exec_stmt Execution.ge e m
  (Sdo(Eassign l(source_clamp(Evalof l tint)shift)tint))E0 mf Out_normal /\
 Mem.storev Mint32 m(Vptr eb eofs)(Vint chosen)=Some mf /\
 Mem.loadv Mint32 mf(Vptr eb eofs)=Some(Vint chosen).
Proof.
 intros e m l err shift bound eb eofs TY SIMPLE LV LOAD ACCESS BOUND NEG.
 assert(READ : Cstrategy.eval_simple_rvalue Execution.ge e m(Evalof l tint)(Vint err)).
 { apply BigstepSupport.read_scalar with(b:=eb)(ofs:=eofs)(chunk:=Mint32);try exact LV;try exact LOAD.
   all:try rewrite TY;reflexivity. }
 destruct(source_clamp_expression e m(Evalof l tint)err shift bound eq_refl)
  as[chosen EVAL];[cbn[source_simple];rewrite TY,SIMPLE;reflexivity|exact READ|exact BOUND|exact NEG|].
 destruct(Mem.valid_access_store m Mint32 eb(Ptrofs.unsigned eofs)(Vint chosen) ACCESS)
  as[mf STORE].
 assert(NOWRAP : Ptrofs.unsigned eofs+size_chunk Mint32<=Ptrofs.modulus).
 { unfold Mem.loadv in LOAD;destruct(zle(Ptrofs.unsigned eofs+size_chunk Mint32)Ptrofs.modulus);[assumption|discriminate]. }
 assert(STOREV : Mem.storev Mint32 m(Vptr eb eofs)(Vint chosen)=Some mf).
 { unfold Mem.storev;destruct(zle(Ptrofs.unsigned eofs+size_chunk Mint32)Ptrofs.modulus);[exact STORE|lia]. }
 exists chosen,mf;split.
 - inversion EVAL as[e0 m0 a0 t0 m0' a0' v0 EVAL0 VAL];subst.
   eapply effectful_assignment with(r':=a0')(v:=Vfloat(Float.of_int chosen))(vc:=Vint chosen).
   + exact LV.
   + exact SIMPLE.
   + exact EVAL0.
   + exact VAL.
   + rewrite TY;change(match Float.to_int(Float.of_int chosen)with Some i=>Some(Vint i)|None=>None end=Some(Vint chosen)).
     rewrite signed_int_double_roundtrip;reflexivity.
   + rewrite TY;apply BigstepSupport.assign_scalar with(chunk:=Mint32);try reflexivity;exact STOREV.
   + symmetry;exact TY.
 - split;[exact STOREV|]. unfold Mem.loadv;destruct(zle(Ptrofs.unsigned eofs+size_chunk Mint32)Ptrofs.modulus);[|lia].
   rewrite(Mem.load_store_same Mint32 m eb(Ptrofs.unsigned eofs)(Vint chosen)mf STORE);reflexivity.
Qed.

Lemma original_clamp_prefix_binding :
 match fn_body Source.f_guidance_pid_h_run_pos with
 | Ssequence _ (Ssequence a (Ssequence _ (Ssequence b _))) =>
   a=Ssequence(original_position_clamp Source._x)(original_position_clamp Source._y) /\
   b=Ssequence(original_speed_clamp Source._x)(original_speed_clamp Source._y)
 | _=>False end.
Proof. split;reflexivity. Qed.

Print Assumptions signed_int_double_roundtrip.
Print Assumptions source_clamp_assignment_exists.

Definition clamp_bits(err bound:int):int :=
 if Float.cmp Clt(Float.of_int err)(Float.of_int(Int.neg bound))
 then Int.neg bound
 else if Float.cmp Cgt(Float.of_int err)(Float.of_int bound)then bound else err.

Lemma source_clamp_expression_exact : forall e m r err shift bound,
 typeof r=tint -> source_simple r=true ->
 Cstrategy.eval_simple_rvalue Execution.ge e m r(Vint err) ->
 Cstrategy.eval_simple_rvalue Execution.ge e m(source_bound shift)(Vfloat(Float.of_int bound)) ->
 Float.neg(Float.of_int bound)=Float.of_int(Int.neg bound) ->
 Cstrategy.eval_expression Execution.ge e m(source_clamp r shift)E0 m(Vfloat(Float.of_int(clamp_bits err bound))).
Proof.
 intros e m r err shift bound TY SIMPLE READ BOUND NEG.
 set (below:=Float.cmp Clt(Float.of_int err)(Float.of_int(Int.neg bound))).
 set (above:=Float.cmp Cgt(Float.of_int err)(Float.of_int bound)).
 assert (LOW : Cstrategy.eval_simple_rvalue Execution.ge e m
   (Eunop Oneg(source_bound shift)tdouble)(Vfloat(Float.of_int(Int.neg bound)))).
 { eapply Cstrategy.esr_unop;[exact BOUND|]. change(Some(Vfloat(Float.neg(Float.of_int bound)))=Some(Vfloat(Float.of_int(Int.neg bound)))). rewrite NEG;reflexivity. }
 assert (LT : Cstrategy.eval_expression Execution.ge e m
   (Ebinop Olt r(Eunop Oneg(source_bound shift)tdouble)tint)E0 m(Val.of_bool below)).
 { apply simple_expression.
   - eapply Cstrategy.esr_binop;[exact READ|exact LOW|].
     rewrite TY;reflexivity.
   - cbn[source_simple];rewrite SIMPLE;reflexivity. }
 assert (GT : Cstrategy.eval_expression Execution.ge e m
   (Ebinop Ogt r(source_bound shift)tint)E0 m(Val.of_bool above)).
 { apply simple_expression.
   - eapply Cstrategy.esr_binop;[exact READ|exact BOUND|]. rewrite TY;reflexivity.
   - cbn[source_simple];rewrite SIMPLE;reflexivity. }
 unfold source_clamp,clamp_bits;fold below above.
 destruct below eqn:BELOW.
 -
   eapply conditional_expression with(vt:=Val.of_bool true)(vb:=true)
    (vbranch:=Vfloat(Float.of_int(Int.neg bound)));try exact LT;try reflexivity.
   apply simple_expression;[exact LOW|reflexivity].
 - destruct above eqn:ABOVE.
   +
     eapply conditional_expression with(vt:=Val.of_bool false)(vb:=false)
      (vbranch:=Vfloat(Float.of_int bound));try exact LT;try reflexivity.
     eapply conditional_expression with(vt:=Val.of_bool true)(vb:=true)
      (vbranch:=Vfloat(Float.of_int bound));try exact GT;try reflexivity.
     apply simple_expression;[exact BOUND|reflexivity].
   +
     eapply conditional_expression with(vt:=Val.of_bool false)(vb:=false)
      (vbranch:=Vfloat(Float.of_int err));try exact LT;try reflexivity.
     eapply conditional_expression with(vt:=Val.of_bool false)(vb:=false)
      (vbranch:=Vint err);try exact GT;try reflexivity.
     * apply simple_expression;[exact READ|exact SIMPLE].
     * rewrite TY;reflexivity.
Qed.


Lemma source_clamp_assignment_exact_exists : forall e m l err shift bound eb eofs,
 typeof l=tint -> source_simple l=true ->
 Cstrategy.eval_simple_lvalue Execution.ge e m l eb eofs Full ->
 Mem.loadv Mint32 m(Vptr eb eofs)=Some(Vint err) ->
 Mem.valid_access m Mint32 eb(Ptrofs.unsigned eofs) Writable ->
 Cstrategy.eval_simple_rvalue Execution.ge e m(source_bound shift)(Vfloat(Float.of_int bound)) ->
 Float.neg(Float.of_int bound)=Float.of_int(Int.neg bound) ->
 exists mf,
 Cstrategy.exec_stmt Execution.ge e m
  (Sdo(Eassign l(source_clamp(Evalof l tint)shift)tint))E0 mf Out_normal /\
 Mem.storev Mint32 m(Vptr eb eofs)(Vint(clamp_bits err bound))=Some mf /\
 Mem.loadv Mint32 mf(Vptr eb eofs)=Some(Vint(clamp_bits err bound)).
Proof.
 intros e m l err shift bound eb eofs TY SIMPLE LV LOAD ACCESS BOUND NEG.
 assert(READ : Cstrategy.eval_simple_rvalue Execution.ge e m(Evalof l tint)(Vint err)).
 { apply BigstepSupport.read_scalar with(b:=eb)(ofs:=eofs)(chunk:=Mint32);try exact LV;try exact LOAD.
   all:try rewrite TY;reflexivity. }
 pose proof(source_clamp_expression_exact e m(Evalof l tint)err shift bound eq_refl
  ltac:(cbn[source_simple];rewrite TY,SIMPLE;reflexivity)READ BOUND NEG)as EVAL.
 set(chosen:=clamp_bits err bound)in *. 
 destruct(Mem.valid_access_store m Mint32 eb(Ptrofs.unsigned eofs)(Vint(clamp_bits err bound)) ACCESS)
  as[mf STORE].
 assert(NOWRAP : Ptrofs.unsigned eofs+size_chunk Mint32<=Ptrofs.modulus).
 { unfold Mem.loadv in LOAD;destruct(zle(Ptrofs.unsigned eofs+size_chunk Mint32)Ptrofs.modulus);[assumption|discriminate]. }
 assert(STOREV : Mem.storev Mint32 m(Vptr eb eofs)(Vint(clamp_bits err bound))=Some mf).
 { unfold Mem.storev;destruct(zle(Ptrofs.unsigned eofs+size_chunk Mint32)Ptrofs.modulus);[exact STORE|lia]. }
 exists mf;split.
 - inversion EVAL as[e0 m0 a0 t0 m0' a0' v0 EVAL0 VAL];subst.
   eapply effectful_assignment with(r':=a0')(v:=Vfloat(Float.of_int chosen))(vc:=Vint chosen).
   + exact LV.
   + exact SIMPLE.
   + exact EVAL0.
   + exact VAL.
   + rewrite TY;change(match Float.to_int(Float.of_int chosen)with Some i=>Some(Vint i)|None=>None end=Some(Vint(clamp_bits err bound))).
     rewrite signed_int_double_roundtrip;reflexivity.
   + rewrite TY;apply BigstepSupport.assign_scalar with(chunk:=Mint32);try reflexivity;exact STOREV.
   + symmetry;exact TY.
 - split;[exact STOREV|]. unfold Mem.loadv;destruct(zle(Ptrofs.unsigned eofs+size_chunk Mint32)Ptrofs.modulus);[|lia].
   rewrite(Mem.load_store_same Mint32 m eb(Ptrofs.unsigned eofs)(Vint(clamp_bits err bound))mf STORE);reflexivity.
Qed.


Local Transparent Float.neg Float.of_int.
Lemma position_bound_neg : Float.neg(Float.of_int(Int.repr 4096))=Float.of_int(Int.neg(Int.repr 4096)).
Proof. apply float_bits_ext;reflexivity. Qed.
Lemma speed_bound_neg : Float.neg(Float.of_int(Int.repr 8388608))=Float.of_int(Int.neg(Int.repr 8388608)).
Proof. apply float_bits_ext;reflexivity. Qed.
Local Opaque Float.neg Float.of_int.
