From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Globalenvs Ctypes Csyntax Csyntaxdefs.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import CoreInputs ClampSemantics.
From CoreCBMC Require Import NumericBounds FloatBounds.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Lemma bounded_path_value:forall m b ty path lo hi value,
 bounded_path m b ty path lo hi ->load_path Mint32 m b ty path=Some(Vint value) ->
 lo<=Int.signed value<=hi.
Proof. intros m b ty path lo hi value[n[LOAD BOUND]]READ;rewrite READ in LOAD;injection LOAD as EQ;subst n;exact BOUND. Qed.
Lemma bounded_global_value:forall m id ty path lo hi value,
 bounded_global m id ty path lo hi ->load_global Mint32 m id ty path=Some(Vint value) ->
 lo<=Int.signed value<=hi.
Proof. intros m id ty path lo hi value[n[LOAD BOUND]]READ;rewrite READ in LOAD;injection LOAD as EQ;subst n;exact BOUND. Qed.
Theorem inputgood_gain_bounds:forall m gh ret(D:core_initial_data m gh),
 InputGood m gh ret ->
 0<=Int.signed(cid_kp _ _ D)<=100 /\0<=Int.signed(cid_kd _ _ D)<=100 /\
 0<=Int.signed(cid_ki _ _ D)<=100 /\0<=Int.signed(cid_kv _ _ D)<=100 /\
 0<=Int.signed(cid_ka _ _ D)<=100.
Proof.
 intros m gh ret D GOOD;pose proof(proj1 GOOD)as LEG.
 assert(GAIN:forall gain,In gain[S._kp;S._kd;S._ki;S._kv;S._ka]->
 bounded_global m S._guidance_pid pid_type[gain]0 100)
 by(unfold InputGoodLegacy in LEG;tauto).
 assert(P:0<=Int.signed(cid_kp _ _ D)<=100).
 { destruct(GAIN S._kp ltac:(cbn;intuition congruence))as[n[LOAD BOUND]].
   unfold load_global in LOAD;rewrite(cid_pid_symbol _ _ D)in LOAD.
   change(Mem.load Mint32 m(cid_pid _ _ D)0=Some(Vint n))in LOAD.
   rewrite(cid_gain_p _ _ D)in LOAD;injection LOAD as EQ;subst n;exact BOUND. }
 assert(Q:0<=Int.signed(cid_kd _ _ D)<=100).
 { destruct(GAIN S._kd ltac:(cbn;intuition congruence))as[n[LOAD BOUND]].
   unfold load_global in LOAD;rewrite(cid_pid_symbol _ _ D)in LOAD.
   change(Mem.load Mint32 m(cid_pid _ _ D)4=Some(Vint n))in LOAD.
   rewrite(cid_gain_d _ _ D)in LOAD;injection LOAD as EQ;subst n;exact BOUND. }
 assert(R:0<=Int.signed(cid_ki _ _ D)<=100).
 { destruct(GAIN S._ki ltac:(cbn;intuition congruence))as[n[LOAD BOUND]].
   unfold load_global in LOAD;rewrite(cid_pid_symbol _ _ D)in LOAD.
   change(Mem.load Mint32 m(cid_pid _ _ D)8=Some(Vint n))in LOAD.
   rewrite(cid_gain_i _ _ D)in LOAD;injection LOAD as EQ;subst n;exact BOUND. }
 assert(T:0<=Int.signed(cid_kv _ _ D)<=100).
 { destruct(GAIN S._kv ltac:(cbn;intuition congruence))as[n[LOAD BOUND]].
   unfold load_global in LOAD;rewrite(cid_pid_symbol _ _ D)in LOAD.
   change(Mem.load Mint32 m(cid_pid _ _ D)12=Some(Vint n))in LOAD.
   rewrite(cid_gain_v _ _ D)in LOAD;injection LOAD as EQ;subst n;exact BOUND. }
 assert(U:0<=Int.signed(cid_ka _ _ D)<=100).
 { destruct(GAIN S._ka ltac:(cbn;intuition congruence))as[n[LOAD BOUND]].
   unfold load_global in LOAD;rewrite(cid_pid_symbol _ _ D)in LOAD.
   change(Mem.load Mint32 m(cid_pid _ _ D)16=Some(Vint n))in LOAD.
   rewrite(cid_gain_a _ _ D)in LOAD;injection LOAD as EQ;subst n;exact BOUND. }
 tauto.
Qed.
Theorem inputgood_axis_bounds:forall m gh ret(D:core_initial_data m gh)axis r p speed measured accel integral,
 InputGood m gh ret ->In axis[S._x;S._y] ->
 load_path Mint32 m gh gh_type[S._ref;S._speed;axis]=Some(Vint speed) ->
 load_path Mint32 m gh gh_type[S._ref;S._accel;axis]=Some(Vint accel) ->
 load_global Mint32 m S._guidance_pid_trim_att_integrator vec_type[axis]=Some(Vint integral) ->
 axis_bounds(cid_kp _ _ D)(cid_kd _ _ D)(cid_ki _ _ D)(cid_kv _ _ D)(cid_ka _ _ D)
 (clamp_bits(Int.sub r p)(Int.repr 4096))
 (clamp_bits(Int.sub speed measured)(Int.repr 8388608))speed accel integral.
Proof.
 intros m gh ret D axis r p speed measured accel integral GOOD AX SPEED ACCEL INTEGRAL.
 destruct(inputgood_gain_bounds m gh ret D GOOD)as[P[Q[R[T U]]]].
 pose proof(proj1 GOOD)as LEG.
 assert(XY:bounded_global m S._guidance_pid_trim_att_integrator vec_type[axis](-100000000)100000000 /\
 bounded_path m gh gh_type[S._ref;S._speed;axis](-10000)10000 /\
 bounded_path m gh gh_type[S._ref;S._accel;axis](-10000)10000 /\
 bounded_global m S._state state_type[S._ned_speed_i;axis](-10000)10000).
 { unfold InputGoodLegacy in LEG;decompose[and]LEG.
   match goal with H:forall a,In a[S._x;S._y]->_|-_=>exact(H axis AX)end. }
 destruct XY as[IB[SB[AB MB]]].
 constructor;try assumption.
 - apply original_front_clamp_bound;lia.
 - apply original_front_clamp_bound;lia.
 - unfold int_bound;eapply bounded_path_value;[exact SB|exact SPEED].
 - unfold int_bound;eapply bounded_path_value;[exact AB|exact ACCEL].
 - unfold int_bound;eapply bounded_global_value;[exact IB|exact INTEGRAL].
Qed.
Print Assumptions inputgood_axis_bounds.
