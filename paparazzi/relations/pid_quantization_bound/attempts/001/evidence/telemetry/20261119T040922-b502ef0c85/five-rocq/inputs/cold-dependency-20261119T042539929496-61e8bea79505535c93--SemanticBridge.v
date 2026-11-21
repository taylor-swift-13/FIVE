From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import CoreSemantics FlightSemantics ControllerPrefix.
From PidPositionTranslationAttempt002 Require Import CoreInputs NormalReturn MainGoals ClampSemantics.
From CoreCBMC Require Import NumericBounds CanonicalDomain.
From PidMeasurementAttempt001 Require Import IntegerBounds MachineArithmetic RobustnessArithmetic.
From PidMeasurementProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Definition mpe(x:AxisSample):int:=clamp_bits(Int.sub(reference x)(measurement x))(Int.repr 4096).
Definition mse(x:AxisSample):int:=clamp_bits(Int.sub(reference_speed x)(measurement_speed x))(Int.repr 8388608).
Definition mi(g:Gains)(x:AxisSample):int:=next_integral true(old_integral x)(gain_i g)
 (pd_bits(gain_p g)(gain_d g)(mpe x)(mse x))(Int.repr 1429).
Definition mc(g:Gains)(x:AxisSample):int:=controller_command true(gain_p g)(gain_d g)(gain_i g)(gain_v g)(gain_a g)
 (mpe x)(mse x)(reference_speed x)(reference_accel x)(old_integral x)(Int.repr 1429)(Int.repr 3216).
Definition GainAgreement m gh(g:Gains)(D:core_initial_data m gh):Prop:=
 gain_p g=cid_kp _ _ D /\gain_d g=cid_kd _ _ D /\gain_i g=cid_ki _ _ D /\
 gain_v g=cid_kv _ _ D /\gain_a g=cid_ka _ _ D.
Lemma read_gain_agreement:forall axis gh m g x(D:core_initial_data m gh),
 ReadAxis axis gh m g x ->GainAgreement m gh g D.
Proof.
 intros axis gh m g x D(RP&RD&RI&RV&RA&REST).
 unfold GainAgreement,load_global in *;rewrite(cid_pid_symbol _ _ D)in RP,RD,RI,RV,RA.
 change(Mem.load Mint32 m(cid_pid _ _ D)0=Some(Vint(gain_p g)))in RP.
 change(Mem.load Mint32 m(cid_pid _ _ D)4=Some(Vint(gain_d g)))in RD.
 change(Mem.load Mint32 m(cid_pid _ _ D)8=Some(Vint(gain_i g)))in RI.
 change(Mem.load Mint32 m(cid_pid _ _ D)12=Some(Vint(gain_v g)))in RV.
 change(Mem.load Mint32 m(cid_pid _ _ D)16=Some(Vint(gain_a g)))in RA.
 rewrite(cid_gain_p _ _ D)in RP;rewrite(cid_gain_d _ _ D)in RD;
 rewrite(cid_gain_i _ _ D)in RI;rewrite(cid_gain_v _ _ D)in RV;rewrite(cid_gain_a _ _ D)in RA.
 repeat split;congruence.
Qed.
Lemma read_axis_bounds:forall axis gh ret m g x,
 In axis[P._x;P._y] ->InputGood m gh ret ->ReadAxis axis gh m g x ->
 axis_bounds(gain_p g)(gain_d g)(gain_i g)(gain_v g)(gain_a g)
 (mpe x)(mse x)(reference_speed x)(reference_accel x)(old_integral x).
Proof.
 intros axis gh ret m g x AX GOOD READ.
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 pose proof(read_gain_agreement axis gh m g x D READ)as(GP&GD&GI&GV&GA).
 destruct READ as(_&_&_&_&_&RP&MP&RS&MS&ACC&OLD).
 unfold mpe,mse;rewrite GP,GD,GI,GV,GA.
 eapply inputgood_axis_bounds;[exact GOOD|exact AX|exact RS|exact ACC|exact OLD].
Qed.
Lemma read_axis_position_exact:forall axis gh ret m g x,
 In axis[P._x;P._y] ->InputGood m gh ret ->ReadAxis axis gh m g x ->
 Int.signed(mpe x)=position_error(Int.signed(reference x))(Int.signed(measurement x)).
Proof.
 intros axis gh ret m g x AX GOOD READ.
 destruct READ as(_&_&_&_&_&RP&MP&REST).
 destruct(proj2(proj2 GOOD)axis AX)as[r[p[RP0[MP0 SAFE]]]].
 change(load_path Mint32 m gh gh_type[P._ref;P._pos;axis]=Some(Vint r))in RP0.
 change(load_global Mint32 m P._state state_type[P._ned_pos_i;axis]=Some(Vint p))in MP0.
 rewrite RP in RP0;rewrite MP in MP0;injection RP0 as EQ;subst r;injection MP0 as EQ;subst p.
 unfold mpe,position_error;rewrite front_clamp_signed by lia.
 rewrite Int.sub_signed,Int.signed_repr;[reflexivity|exact SAFE].
Qed.
Lemma normal_axis_observation:forall axis gh ret m mf g x,
 In axis[P._x;P._y] ->InputGood m gh ret ->ReadAxis axis gh m g x ->
 NormalCall gh ret true m mf ->
 load_global Mint32 mf P._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint(mi g x)) /\
 load_global Mint32 mf P._guidance_pid pid_type[P._cmd_earth;axis]=Some(Vint(mc g x)) /\
 load_path Mint32 mf ret sp_type[P._sp;P._ltp_i;P._vect;axis]=Some(Vint(mc g x)).
Proof.
 intros axis gh ret m mf g x AX GOOD READ CALL.
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 pose proof(read_gain_agreement axis gh m g x D READ)as(GP&GD&GI&GV&GA).
 destruct(original_entry_normal_result m gh ret true D GOOD)
 as(out&rx&ry&px&py&sx&sy&vx&vy&sb&NC&STATE&RX&RY&PX&PY&SX&SY&VX&VY&ACTIVE&IX&IY&CX&CY).
 assert(EQ:mf=out)by(eapply original_entry_all_normal_memories_unique;[exact GOOD|exact CALL|exact NC]);subst mf.
 destruct READ as(_&_&_&_&_&RP&MP&RS&MS&ACC&OLD).
 unfold load_global in MP,MS,OLD;rewrite STATE in MP,MS;rewrite(cid_i_symbol _ _ D)in OLD.
 unfold mi,mc,mpe,mse;rewrite GP,GD,GI,GV,GA.
 destruct AX as[<-|[<-|[]]].
 - change(Mem.load Mint32 m sb 100=Some(Vint(measurement x)))in MP.
   change(Mem.load Mint32 m sb 296=Some(Vint(measurement_speed x)))in MS.
   change(Mem.load Mint32 m gh 60=Some(Vint(reference_accel x)))in ACC.
   change(Mem.load Mint32 m(cid_i _ _ D)0=Some(Vint(old_integral x)))in OLD.
   rewrite RX in RP;rewrite PX in MP;rewrite SX in RS;rewrite VX in MS;
   rewrite(cid_accel_x _ _ D)in ACC;rewrite(cid_integral_x _ _ D)in OLD.
   injection RP as R;injection MP as M;injection RS as S;injection MS as V;injection ACC as A;injection OLD as I.
   rewrite<-R,<-M,<-S,<-V,<-A,<-I.
   split;[unfold load_global;rewrite(cid_i_symbol _ _ D);exact IX|].
   split;[unfold load_global;rewrite(cid_pid_symbol _ _ D);exact CX|].
   destruct ACTIVE as(T&F&X&Y&H&REST);exact X.
 - change(Mem.load Mint32 m sb 104=Some(Vint(measurement x)))in MP.
   change(Mem.load Mint32 m sb 300=Some(Vint(measurement_speed x)))in MS.
   change(Mem.load Mint32 m gh 64=Some(Vint(reference_accel x)))in ACC.
   change(Mem.load Mint32 m(cid_i _ _ D)4=Some(Vint(old_integral x)))in OLD.
   rewrite RY in RP;rewrite PY in MP;rewrite SY in RS;rewrite VY in MS;
   rewrite(cid_accel_y _ _ D)in ACC;rewrite(cid_integral_y _ _ D)in OLD.
   injection RP as R;injection MP as M;injection RS as S;injection MS as V;injection ACC as A;injection OLD as I.
   rewrite<-R,<-M,<-S,<-V,<-A,<-I.
   split;[unfold load_global;rewrite(cid_i_symbol _ _ D);exact IY|].
   split;[unfold load_global;rewrite(cid_pid_symbol _ _ D);exact CY|].
   destruct ACTIVE as(T&F&X&Y&H&REST);exact Y.
Qed.
Lemma environment_integral_bound:forall axis gh a b qa qb distance,
 In axis[P._x;P._y] ->EnvironmentStep gh a qa ->EnvironmentStep gh b qb ->
 IntegralBound axis a b distance ->IntegralBound axis qa qb distance.
Proof.
 intros axis gh a b qa qb distance AX[_ EA][_ EB](ia&ib&LA&LB&D).
 exists ia,ib;rewrite(EA axis AX),(EB axis AX);auto.
Qed.
Print Assumptions normal_axis_observation.
