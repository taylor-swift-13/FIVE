From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Floats Values Memory Globalenvs.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreSemantics FlightSemantics ControllerPrefix.
From PidPositionTranslationAttempt002 Require Import CoreInputs NormalReturn.
From PidSignSymmetryProblem Require Import Spec.
From PidSignSymmetryAttempt001 Require Import Witness.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.

Lemma computed_original_result : forall m gh ret r cmd integral,
 MirrorInput m gh ret r ->
 ((r=64 /\cmd=1 /\integral=1)\/(r= -64 /\cmd= -2 /\integral= -1)) ->
 exists mf,NormalCall gh ret true m mf /\ObservedX ret mf cmd integral.
Proof.
 intros m gh ret r cmd integral INPUT CASE.
 destruct INPUT as(GOOD&RX0&RY0&PX0&PY0&AXES&KP0&KD0&KI0&KV0&KA0&HEAD).
 destruct(AXES S._x ltac:(cbn;auto))as(SX0&AX0&VX0&IX0).
 destruct(AXES S._y ltac:(cbn;auto))as(SY0&AY0&VY0&IY0).
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 assert(KP:cid_kp _ _ D=Int.one).
 { pose proof(cid_gain_p _ _ D)as L;unfold load_global in KP0;
   rewrite(cid_pid_symbol _ _ D)in KP0;change(Mem.load Mint32 m(cid_pid _ _ D)0=Some(Vint Int.one))in KP0;congruence. }
 assert(KD:cid_kd _ _ D=Int.zero).
 { pose proof(cid_gain_d _ _ D)as L;unfold load_global in KD0;
   rewrite(cid_pid_symbol _ _ D)in KD0;change(Mem.load Mint32 m(cid_pid _ _ D)4=Some(Vint Int.zero))in KD0;congruence. }
 assert(KI:cid_ki _ _ D=Int.one).
 { pose proof(cid_gain_i _ _ D)as L;unfold load_global in KI0;
   rewrite(cid_pid_symbol _ _ D)in KI0;change(Mem.load Mint32 m(cid_pid _ _ D)8=Some(Vint Int.one))in KI0;congruence. }
 assert(KV:cid_kv _ _ D=Int.zero).
 { pose proof(cid_gain_v _ _ D)as L;unfold load_global in KV0;
   rewrite(cid_pid_symbol _ _ D)in KV0;change(Mem.load Mint32 m(cid_pid _ _ D)12=Some(Vint Int.zero))in KV0;congruence. }
 assert(KA:cid_ka _ _ D=Int.zero).
 { pose proof(cid_gain_a _ _ D)as L;unfold load_global in KA0;
   rewrite(cid_pid_symbol _ _ D)in KA0;change(Mem.load Mint32 m(cid_pid _ _ D)16=Some(Vint Int.zero))in KA0;congruence. }
 assert(AX:cid_ax _ _ D=Int.zero)by(pose proof(cid_accel_x _ _ D);change(Mem.load Mint32 m gh 60=Some(Vint Int.zero))in AX0;congruence).
 assert(IX:cid_ix _ _ D=Int.zero).
 { pose proof(cid_integral_x _ _ D)as L;unfold load_global in IX0;
   rewrite(cid_i_symbol _ _ D)in IX0;change(Mem.load Mint32 m(cid_i _ _ D)0=Some(Vint Int.zero))in IX0;congruence. }
 destruct(original_entry_normal_result m gh ret true D GOOD)
 as(mf&rx&ry&px&py&sx&sy&vx&vy&sb&CALL&SS&RX&RY&PX&PY&SX&SY&VX&VY&ACTIVE&IFX&IFY&CMDX&CMDY).
 assert(RXE:rx=Int.repr r)by(congruence).
 assert(SXE:sx=Int.zero)by(congruence).
 assert(PXE:px=Int.zero).
 { unfold load_global in PX0;rewrite SS in PX0;change(Mem.load Mint32 m sb 100=Some(Vint Int.zero))in PX0;congruence. }
 assert(VXE:vx=Int.zero).
 { unfold load_global in VX0;rewrite SS in VX0;change(Mem.load Mint32 m sb 296=Some(Vint Int.zero))in VX0;congruence. }
 unfold entry_axis_command in ACTIVE,CMDX.
 unfold entry_axis_integral in IFX.
 rewrite KP,KD,KI,KV,KA,AX,IX,RXE,SXE,PXE,VXE in ACTIVE,CMDX.
 rewrite KP,KD,KI,IX,RXE,SXE,PXE,VXE in IFX.
 assert(CALC:
 controller_command true Int.one Int.zero Int.one Int.zero Int.zero
 (ClampSemantics.clamp_bits(Int.sub(Int.repr r)Int.zero)(Int.repr 4096))
 (ClampSemantics.clamp_bits(Int.sub Int.zero Int.zero)(Int.repr 8388608))
 Int.zero Int.zero Int.zero(Int.repr 1429)(Int.repr 3216)=Int.repr cmd).
 { destruct CASE as[[R[C I]]|[R[C I]]];subst r cmd integral;apply Int.same_if_eq;vm_compute;reflexivity. }
 assert(ICALC:
 next_integral true Int.zero Int.one
 (pd_bits Int.one Int.zero
 (ClampSemantics.clamp_bits(Int.sub(Int.repr r)Int.zero)(Int.repr 4096))
 (ClampSemantics.clamp_bits(Int.sub Int.zero Int.zero)(Int.repr 8388608)))
 (Int.repr 1429)=Int.repr integral).
 { destruct CASE as[[R[C I]]|[R[C I]]];subst r cmd integral;apply Int.same_if_eq;vm_compute;reflexivity. }
 rewrite CALC in ACTIVE,CMDX;rewrite ICALC in IFX.
 exists mf;split;[exact CALL|].
 destruct ACTIVE as(TY&FMT&X&REST).
 unfold ObservedX;split;[exact TY|];split;[exact FMT|];split;[exact X|];split.
 - unfold load_global;rewrite(cid_pid_symbol _ _ D);exact CMDX.
 - unfold load_global;rewrite(cid_i_symbol _ _ D);exact IFX.
Qed.
Print Assumptions computed_original_result.

Lemma one_minus_two_not_opposite : forall ret af bf,
 ObservedX ret af 1 1 ->ObservedX ret bf (-2) (-1) ->
 ~OppositeReturnedX ret af bf.
Proof.
 intros ret af bf[_[_[A _]]][_[_[B _]]][x[y[LA[LB OPP]]]].
 rewrite A in LA;injection LA as<-;rewrite B in LB;injection LB as<-.
 vm_compute in OPP;lia.
Qed.

Theorem proved_actual_counterexample : ActualCounterexampleGoal.
Proof.
 destruct mirrored_inputs_exist as(gh&ret&a&b&PAIR).
 destruct(computed_original_result a gh ret 64 1 1(proj1 PAIR)ltac:(auto))as[af[CA OA]].
 destruct(computed_original_result b gh ret (-64)(-2)(-1)(proj1(proj2 PAIR))ltac:(auto))as[bf[CB OB]].
 exists gh,ret,a,b,af,bf;repeat(first[assumption|split]).
 eapply one_minus_two_not_opposite;eassumption.
Qed.
Theorem proved_strict_symmetry_refuted : StrictSymmetryRefutedGoal.
Proof.
 intros UNIVERSAL.
 destruct proved_actual_counterexample as(gh&ret&a&b&af&bf&PAIR&CA&CB&OA&OB&FAIL).
 apply FAIL;exact(UNIVERSAL gh ret a b 64 af bf PAIR CA CB).
Qed.
Print Assumptions proved_actual_counterexample.
Print Assumptions proved_strict_symmetry_refuted.
