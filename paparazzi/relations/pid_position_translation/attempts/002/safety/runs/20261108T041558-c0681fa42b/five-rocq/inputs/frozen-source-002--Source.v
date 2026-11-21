From Coq Require Import String List ZArith.
From compcert Require Import Coqlib Integers Floats Values AST Ctypes Cop Csyntax Csyntaxdefs.
Import Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope csyntax_scope.

Module Info.
  Definition version := "3.17".
  Definition build_number := "".
  Definition build_tag := "".
  Definition build_branch := "".
  Definition arch := "x86".
  Definition model := "64".
  Definition abi := "standard".
  Definition bitsize := 64.
  Definition big_endian := false.
  Definition source_file := "/home/yangfp/five/paparazzi/models/guidance_pid_h_run_pos/align/model/preprocessed.i".
End Info.

Definition _AttitudeRCInput : ident := $"AttitudeRCInput".
Definition _EcefCoor_f : ident := $"EcefCoor_f".
Definition _EcefCoor_i : ident := $"EcefCoor_i".
Definition _EnuCoor_f : ident := $"EnuCoor_f".
Definition _EnuCoor_i : ident := $"EnuCoor_i".
Definition _FloatEulers : ident := $"FloatEulers".
Definition _FloatQuat : ident := $"FloatQuat".
Definition _FloatRMat : ident := $"FloatRMat".
Definition _FloatRates : ident := $"FloatRates".
Definition _FloatVect2 : ident := $"FloatVect2".
Definition _FloatVect3 : ident := $"FloatVect3".
Definition _GuidancePID : ident := $"GuidancePID".
Definition _HorizontalGuidance : ident := $"HorizontalGuidance".
Definition _HorizontalGuidanceRCInput : ident := $"HorizontalGuidanceRCInput".
Definition _HorizontalGuidanceReference : ident := $"HorizontalGuidanceReference".
Definition _HorizontalGuidanceSetpoint : ident := $"HorizontalGuidanceSetpoint".
Definition _Int32Eulers : ident := $"Int32Eulers".
Definition _Int32Quat : ident := $"Int32Quat".
Definition _Int32RMat : ident := $"Int32RMat".
Definition _Int32Rates : ident := $"Int32Rates".
Definition _Int32Vect2 : ident := $"Int32Vect2".
Definition _Int32Vect3 : ident := $"Int32Vect3".
Definition _LlaCoor_f : ident := $"LlaCoor_f".
Definition _LlaCoor_i : ident := $"LlaCoor_i".
Definition _LtpDef_f : ident := $"LtpDef_f".
Definition _LtpDef_i : ident := $"LtpDef_i".
Definition _NedCoor_f : ident := $"NedCoor_f".
Definition _NedCoor_i : ident := $"NedCoor_i".
Definition _OrientationReps : ident := $"OrientationReps".
Definition _Stabilization : ident := $"Stabilization".
Definition _StabilizationSetpoint : ident := $"StabilizationSetpoint".
Definition _State : ident := $"State".
Definition _ThrustSetpoint : ident := $"ThrustSetpoint".
Definition _UtmCoor_f : ident := $"UtmCoor_f".
Definition _VerticalGuidance : ident := $"VerticalGuidance".
Definition __1084 : ident := $"_1084".
Definition __1085 : ident := $"_1085".
Definition __1097 : ident := $"_1097".
Definition __1098 : ident := $"_1098".
Definition __1099 : ident := $"_1099".
Definition __1100 : ident := $"_1100".
Definition __1109 : ident := $"_1109".
Definition ___builtin_ais_annot : ident := $"__builtin_ais_annot".
Definition ___builtin_annot : ident := $"__builtin_annot".
Definition ___builtin_annot_intval : ident := $"__builtin_annot_intval".
Definition ___builtin_bswap : ident := $"__builtin_bswap".
Definition ___builtin_bswap16 : ident := $"__builtin_bswap16".
Definition ___builtin_bswap32 : ident := $"__builtin_bswap32".
Definition ___builtin_bswap64 : ident := $"__builtin_bswap64".
Definition ___builtin_clz : ident := $"__builtin_clz".
Definition ___builtin_clzl : ident := $"__builtin_clzl".
Definition ___builtin_clzll : ident := $"__builtin_clzll".
Definition ___builtin_ctz : ident := $"__builtin_ctz".
Definition ___builtin_ctzl : ident := $"__builtin_ctzl".
Definition ___builtin_ctzll : ident := $"__builtin_ctzll".
Definition ___builtin_debug : ident := $"__builtin_debug".
Definition ___builtin_expect : ident := $"__builtin_expect".
Definition ___builtin_fabs : ident := $"__builtin_fabs".
Definition ___builtin_fabsf : ident := $"__builtin_fabsf".
Definition ___builtin_fmadd : ident := $"__builtin_fmadd".
Definition ___builtin_fmax : ident := $"__builtin_fmax".
Definition ___builtin_fmin : ident := $"__builtin_fmin".
Definition ___builtin_fmsub : ident := $"__builtin_fmsub".
Definition ___builtin_fnmadd : ident := $"__builtin_fnmadd".
Definition ___builtin_fnmsub : ident := $"__builtin_fnmsub".
Definition ___builtin_fsqrt : ident := $"__builtin_fsqrt".
Definition ___builtin_membar : ident := $"__builtin_membar".
Definition ___builtin_memcpy_aligned : ident := $"__builtin_memcpy_aligned".
Definition ___builtin_read16_reversed : ident := $"__builtin_read16_reversed".
Definition ___builtin_read32_reversed : ident := $"__builtin_read32_reversed".
Definition ___builtin_sel : ident := $"__builtin_sel".
Definition ___builtin_sqrt : ident := $"__builtin_sqrt".
Definition ___builtin_unreachable : ident := $"__builtin_unreachable".
Definition ___builtin_va_arg : ident := $"__builtin_va_arg".
Definition ___builtin_va_copy : ident := $"__builtin_va_copy".
Definition ___builtin_va_end : ident := $"__builtin_va_end".
Definition ___builtin_va_start : ident := $"__builtin_va_start".
Definition ___builtin_write16_reversed : ident := $"__builtin_write16_reversed".
Definition ___builtin_write32_reversed : ident := $"__builtin_write32_reversed".
Definition ___compcert_i64_dtos : ident := $"__compcert_i64_dtos".
Definition ___compcert_i64_dtou : ident := $"__compcert_i64_dtou".
Definition ___compcert_i64_sar : ident := $"__compcert_i64_sar".
Definition ___compcert_i64_sdiv : ident := $"__compcert_i64_sdiv".
Definition ___compcert_i64_shl : ident := $"__compcert_i64_shl".
Definition ___compcert_i64_shr : ident := $"__compcert_i64_shr".
Definition ___compcert_i64_smod : ident := $"__compcert_i64_smod".
Definition ___compcert_i64_smulh : ident := $"__compcert_i64_smulh".
Definition ___compcert_i64_stod : ident := $"__compcert_i64_stod".
Definition ___compcert_i64_stof : ident := $"__compcert_i64_stof".
Definition ___compcert_i64_udiv : ident := $"__compcert_i64_udiv".
Definition ___compcert_i64_umod : ident := $"__compcert_i64_umod".
Definition ___compcert_i64_umulh : ident := $"__compcert_i64_umulh".
Definition ___compcert_i64_utod : ident := $"__compcert_i64_utod".
Definition ___compcert_i64_utof : ident := $"__compcert_i64_utof".
Definition ___compcert_va_composite : ident := $"__compcert_va_composite".
Definition ___compcert_va_float64 : ident := $"__compcert_va_float64".
Definition ___compcert_va_int32 : ident := $"__compcert_va_int32".
Definition ___compcert_va_int64 : ident := $"__compcert_va_int64".
Definition __res : ident := $"_res".
Definition __res__1 : ident := $"_res__1".
Definition _accel : ident := $"accel".
Definition _accel_input_filter : ident := $"accel_input_filter".
Definition _accel_status : ident := $"accel_status".
Definition _adapt_throttle_enabled : ident := $"adapt_throttle_enabled".
Definition _airspeed_f : ident := $"airspeed_f".
Definition _airspeed_i : ident := $"airspeed_i".
Definition _alt : ident := $"alt".
Definition _alt_agl_f : ident := $"alt_agl_f".
Definition _angle_of_attack_f : ident := $"angle_of_attack_f".
Definition _approx_force_by_thrust : ident := $"approx_force_by_thrust".
Definition _atan2f : ident := $"atan2f".
Definition _att_submode : ident := $"att_submode".
Definition _attitude_input_filter : ident := $"attitude_input_filter".
Definition _body_accel_i : ident := $"body_accel_i".
Definition _body_rates_f : ident := $"body_rates_f".
Definition _body_rates_i : ident := $"body_rates_i".
Definition _care_free_heading : ident := $"care_free_heading".
Definition _cmd : ident := $"cmd".
Definition _cmd_earth : ident := $"cmd_earth".
Definition _cmd_thrust : ident := $"cmd_thrust".
Definition _east : ident := $"east".
Definition _ecef : ident := $"ecef".
Definition _ecef_accel_f : ident := $"ecef_accel_f".
Definition _ecef_accel_i : ident := $"ecef_accel_i".
Definition _ecef_pos_f : ident := $"ecef_pos_f".
Definition _ecef_pos_i : ident := $"ecef_pos_i".
Definition _ecef_speed_f : ident := $"ecef_speed_f".
Definition _ecef_speed_i : ident := $"ecef_speed_i".
Definition _enu_pos_f : ident := $"enu_pos_f".
Definition _enu_pos_i : ident := $"enu_pos_i".
Definition _enu_speed_f : ident := $"enu_speed_f".
Definition _enu_speed_i : ident := $"enu_speed_i".
Definition _eulers_f : ident := $"eulers_f".
Definition _eulers_i : ident := $"eulers_i".
Definition _eulers_zxy_f : ident := $"eulers_zxy_f".
Definition _format : ident := $"format".
Definition _gh : ident := $"gh".
Definition _guidance_h : ident := $"guidance_h".
Definition _guidance_pid : ident := $"guidance_pid".
Definition _guidance_pid_h_run : ident := $"guidance_pid_h_run".
Definition _guidance_pid_h_run_pos : ident := $"guidance_pid_h_run_pos".
Definition _guidance_pid_pos_err : ident := $"guidance_pid_pos_err".
Definition _guidance_pid_speed_err : ident := $"guidance_pid_speed_err".
Definition _guidance_pid_trim_att_integrator : ident := $"guidance_pid_trim_att_integrator".
Definition _guidance_v : ident := $"guidance_v".
Definition _h_mask : ident := $"h_mask".
Definition _h_speed_dir_f : ident := $"h_speed_dir_f".
Definition _h_speed_dir_i : ident := $"h_speed_dir_i".
Definition _h_speed_norm_f : ident := $"h_speed_norm_f".
Definition _h_speed_norm_i : ident := $"h_speed_norm_i".
Definition _heading : ident := $"heading".
Definition _heading_rate : ident := $"heading_rate".
Definition _hmsl : ident := $"hmsl".
Definition _in_flight : ident := $"in_flight".
Definition _ka : ident := $"ka".
Definition _kd : ident := $"kd".
Definition _ki : ident := $"ki".
Definition _kp : ident := $"kp".
Definition _kv : ident := $"kv".
Definition _last_ts : ident := $"last_ts".
Definition _lat : ident := $"lat".
Definition _lla : ident := $"lla".
Definition _lla_pos_f : ident := $"lla_pos_f".
Definition _lla_pos_i : ident := $"lla_pos_i".
Definition _lon : ident := $"lon".
Definition _ltp_f : ident := $"ltp_f".
Definition _ltp_i : ident := $"ltp_i".
Definition _ltp_of_ecef : ident := $"ltp_of_ecef".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _mode : ident := $"mode".
Definition _ned_accel_f : ident := $"ned_accel_f".
Definition _ned_accel_i : ident := $"ned_accel_i".
Definition _ned_initialized_f : ident := $"ned_initialized_f".
Definition _ned_initialized_i : ident := $"ned_initialized_i".
Definition _ned_origin_f : ident := $"ned_origin_f".
Definition _ned_origin_i : ident := $"ned_origin_i".
Definition _ned_pos_f : ident := $"ned_pos_f".
Definition _ned_pos_i : ident := $"ned_pos_i".
Definition _ned_speed_f : ident := $"ned_speed_f".
Definition _ned_speed_i : ident := $"ned_speed_i".
Definition _ned_to_body_orientation : ident := $"ned_to_body_orientation".
Definition _nominal_throttle : ident := $"nominal_throttle".
Definition _north : ident := $"north".
Definition _origin_input_filter : ident := $"origin_input_filter".
Definition _p : ident := $"p".
Definition _pd_x : ident := $"pd_x".
Definition _pd_y : ident := $"pd_y".
Definition _phi : ident := $"phi".
Definition _pos : ident := $"pos".
Definition _pos_input_filter : ident := $"pos_input_filter".
Definition _pos_status : ident := $"pos_status".
Definition _psi : ident := $"psi".
Definition _q : ident := $"q".
Definition _qi : ident := $"qi".
Definition _quat_f : ident := $"quat_f".
Definition _quat_i : ident := $"quat_i".
Definition _qx : ident := $"qx".
Definition _qy : ident := $"qy".
Definition _qz : ident := $"qz".
Definition _r : ident := $"r".
Definition _r_sp : ident := $"r_sp".
Definition _rate_status : ident := $"rate_status".
Definition _rates_f : ident := $"rates_f".
Definition _rates_i : ident := $"rates_i".
Definition _rates_input_filter : ident := $"rates_input_filter".
Definition _rc_delta_t : ident := $"rc_delta_t".
Definition _rc_eulers : ident := $"rc_eulers".
Definition _rc_in : ident := $"rc_in".
Definition _rc_quat : ident := $"rc_quat".
Definition _rc_sp : ident := $"rc_sp".
Definition _rc_zd_sp : ident := $"rc_zd_sp".
Definition _ref : ident := $"ref".
Definition _rmat_f : ident := $"rmat_f".
Definition _rmat_i : ident := $"rmat_i".
Definition _sideslip_f : ident := $"sideslip_f".
Definition _sp : ident := $"sp".
Definition _speed : ident := $"speed".
Definition _speed_input_filter : ident := $"speed_input_filter".
Definition _speed_status : ident := $"speed_status".
Definition _stab_sp_from_ltp_i : ident := $"stab_sp_from_ltp_i".
Definition _stabilization : ident := $"stabilization".
Definition _state : ident := $"state".
Definition _stateCalcPositionNed_i : ident := $"stateCalcPositionNed_i".
Definition _stateCalcSpeedNed_i : ident := $"stateCalcSpeedNed_i".
Definition _stateGetPositionNed_i : ident := $"stateGetPositionNed_i".
Definition _stateGetSpeedNed_i : ident := $"stateGetSpeedNed_i".
Definition _status : ident := $"status".
Definition _th_incr_f : ident := $"th_incr_f".
Definition _th_incr_i : ident := $"th_incr_i".
Definition _th_sp : ident := $"th_sp".
Definition _theta : ident := $"theta".
Definition _thrust : ident := $"thrust".
Definition _thrust_cmd_filt : ident := $"thrust_cmd_filt".
Definition _thrust_coeff : ident := $"thrust_coeff".
Definition _thrust_f : ident := $"thrust_f".
Definition _thrust_i : ident := $"thrust_i".
Definition _total_max_bank : ident := $"total_max_bank".
Definition _traj_max_bank : ident := $"traj_max_bank".
Definition _transition_ratio : ident := $"transition_ratio".
Definition _transition_theta_offset : ident := $"transition_theta_offset".
Definition _type : ident := $"type".
Definition _use_ref : ident := $"use_ref".
Definition _utm_initialized_f : ident := $"utm_initialized_f".
Definition _utm_origin_f : ident := $"utm_origin_f".
Definition _utm_pos_f : ident := $"utm_pos_f".
Definition _v_kd : ident := $"v_kd".
Definition _v_ki : ident := $"v_ki".
Definition _v_kp : ident := $"v_kp".
Definition _vect : ident := $"vect".
Definition _vect2 : ident := $"vect2".
Definition _vect3 : ident := $"vect3".
Definition _vertical_thrust : ident := $"vertical_thrust".
Definition _wind_air_input_filter : ident := $"wind_air_input_filter".
Definition _wind_air_status : ident := $"wind_air_status".
Definition _windspeed_f : ident := $"windspeed_f".
Definition _windspeed_i : ident := $"windspeed_i".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _yaw_mask : ident := $"yaw_mask".
Definition _z : ident := $"z".
Definition _z_ref : ident := $"z_ref".
Definition _z_sp : ident := $"z_sp".
Definition _zd_ref : ident := $"zd_ref".
Definition _zd_sp : ident := $"zd_sp".
Definition _zdd_ref : ident := $"zdd_ref".
Definition _zdd_sp : ident := $"zdd_sp".
Definition _zone : ident := $"zone".

Definition v_guidance_pid := {|
  gvar_info := (Tstruct _GuidancePID noattr);
  gvar_init := (Init_space 48 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_guidance_pid_pos_err := {|
  gvar_info := (Tstruct _Int32Vect2 noattr);
  gvar_init := (Init_space 8 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_guidance_pid_speed_err := {|
  gvar_info := (Tstruct _Int32Vect2 noattr);
  gvar_init := (Init_space 8 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_guidance_pid_trim_att_integrator := {|
  gvar_info := (Tstruct _Int32Vect2 noattr);
  gvar_init := (Init_space 8 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_guidance_h := {|
  gvar_info := (Tstruct _HorizontalGuidance noattr);
  gvar_init := (Init_space 84 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_guidance_v := {|
  gvar_info := (Tstruct _VerticalGuidance noattr);
  gvar_init := (Init_space 68 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_stabilization := {|
  gvar_info := (Tstruct _Stabilization noattr);
  gvar_init := (Init_space 136 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_state := {|
  gvar_info := (Tstruct _State noattr);
  gvar_init := (Init_space 656 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_stateGetPositionNed_i := {|
  fn_return := (tptr (Tstruct _NedCoor_i noattr));
  fn_callconv := cc_default;
  fn_params := nil;
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof (Evar _state (Tstruct _State noattr))
                           (Tstruct _State noattr)) _pos_status tushort)
                       tushort) (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _stateCalcPositionNed_i (Tfunction nil tvoid cc_default))
             (Tfunction nil tvoid cc_default)) Enil tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof (Evar _state (Tstruct _State noattr))
                       (Tstruct _State noattr)) _ned_pos_i
                     (Tstruct _NedCoor_i noattr))
                   (tptr (Tstruct _NedCoor_i noattr))))))
|}.

Definition f_stateGetSpeedNed_i := {|
  fn_return := (tptr (Tstruct _NedCoor_i noattr));
  fn_callconv := cc_default;
  fn_params := nil;
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof (Evar _state (Tstruct _State noattr))
                           (Tstruct _State noattr)) _speed_status tushort)
                       tushort) (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _stateCalcSpeedNed_i (Tfunction nil tvoid cc_default))
             (Tfunction nil tvoid cc_default)) Enil tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof (Evar _state (Tstruct _State noattr))
                       (Tstruct _State noattr)) _ned_speed_i
                     (Tstruct _NedCoor_i noattr))
                   (tptr (Tstruct _NedCoor_i noattr))))))
|}.

Definition f_stab_sp_from_ltp_i := {|
  fn_return := tvoid;
  fn_callconv := {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|};
  fn_params := ((__res, (tptr (Tstruct _StabilizationSetpoint noattr))) ::
                (_vect, (tptr (Tstruct _Int32Vect2 noattr))) ::
                (_heading, tint) :: nil);
  fn_vars := ((_sp, (Tstruct _StabilizationSetpoint noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof (Evar _sp (Tstruct _StabilizationSetpoint noattr))
             (Tstruct _StabilizationSetpoint noattr)) _type tint)
         (Eval (Vint (Int.repr 2)) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _sp (Tstruct _StabilizationSetpoint noattr))
               (Tstruct _StabilizationSetpoint noattr)) _format tint)
           (Eval (Vint (Int.repr 0)) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _sp (Tstruct _StabilizationSetpoint noattr))
                         (Tstruct _StabilizationSetpoint noattr)) _sp
                       (Tunion __1097 noattr)) (Tunion __1097 noattr)) _ltp_i
                   (Tstruct __1098 noattr)) (Tstruct __1098 noattr)) _vect
               (Tstruct _Int32Vect2 noattr))
             (Evalof
               (Ederef
                 (Evalof (Evar _vect (tptr (Tstruct _Int32Vect2 noattr)))
                   (tptr (Tstruct _Int32Vect2 noattr)))
                 (Tstruct _Int32Vect2 noattr)) (Tstruct _Int32Vect2 noattr))
             (Tstruct _Int32Vect2 noattr)))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _sp (Tstruct _StabilizationSetpoint noattr))
                           (Tstruct _StabilizationSetpoint noattr)) _sp
                         (Tunion __1097 noattr)) (Tunion __1097 noattr))
                     _ltp_i (Tstruct __1098 noattr)) (Tstruct __1098 noattr))
                 _heading tint) (Evalof (Evar _heading tint) tint) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _sp (Tstruct _StabilizationSetpoint noattr))
                             (Tstruct _StabilizationSetpoint noattr)) _r_sp
                           (Tunion __1100 noattr)) (Tunion __1100 noattr))
                       _rates_i (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _p tint)
                 (Eval (Vint (Int.repr 0)) tint) tint))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _sp (Tstruct _StabilizationSetpoint noattr))
                               (Tstruct _StabilizationSetpoint noattr)) _r_sp
                             (Tunion __1100 noattr)) (Tunion __1100 noattr))
                         _rates_i (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint)
                   (Eval (Vint (Int.repr 0)) tint) tint))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _sp (Tstruct _StabilizationSetpoint noattr))
                                 (Tstruct _StabilizationSetpoint noattr))
                               _r_sp (Tunion __1100 noattr))
                             (Tunion __1100 noattr)) _rates_i
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _r tint)
                     (Eval (Vint (Int.repr 0)) tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Evalof
                           (Evar __res (tptr (Tstruct _StabilizationSetpoint noattr)))
                           (tptr (Tstruct _StabilizationSetpoint noattr)))
                         (Tstruct _StabilizationSetpoint noattr))
                       (Evalof
                         (Evar _sp (Tstruct _StabilizationSetpoint noattr))
                         (Tstruct _StabilizationSetpoint noattr))
                       (Tstruct _StabilizationSetpoint noattr)))
                (Sreturn None)))))))))
|}.

Definition v_traj_max_bank := {|
  gvar_info := tint;
  gvar_init := (Init_int32 (Int.repr 1429) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_total_max_bank := {|
  gvar_info := tint;
  gvar_init := (Init_int32 (Int.repr 3216) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_thrust_cmd_filt := {|
  gvar_info := tint;
  gvar_init := (Init_space 4 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_guidance_pid_h_run := {|
  fn_return := tvoid;
  fn_callconv := {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|};
  fn_params := ((__res, (tptr (Tstruct _StabilizationSetpoint noattr))) ::
                (_in_flight, tbool) ::
                (_gh, (tptr (Tstruct _HorizontalGuidance noattr))) :: nil);
  fn_vars := ((_pd_x, tint) :: (_pd_y, tint) :: (_vertical_thrust, tint) ::
              (__res__1, (Tstruct _StabilizationSetpoint noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _pd_x tint)
         (Ebinop Oadd
           (Ebinop Oshr
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                     (Tstruct _GuidancePID noattr)) _kp tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                     (Tstruct _Int32Vect2 noattr)) _x tint) tint) tint)
             (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
               (Eval (Vint (Int.repr 2)) tint) tint) tint)
           (Ebinop Oshr
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                     (Tstruct _GuidancePID noattr)) _kd tint) tint)
               (Ebinop Oshr
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) tint)
             (Ebinop Osub
               (Ebinop Osub (Eval (Vint (Int.repr 19)) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint)
               (Eval (Vint (Int.repr 2)) tint) tint) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _pd_y tint)
           (Ebinop Oadd
             (Ebinop Oshr
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                       (Tstruct _GuidancePID noattr)) _kp tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _y tint) tint) tint)
               (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) tint)
             (Ebinop Oshr
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                       (Tstruct _GuidancePID noattr)) _kd tint) tint)
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                         (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint)
               (Ebinop Osub
                 (Ebinop Osub (Eval (Vint (Int.repr 19)) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                     (Tstruct _GuidancePID noattr)) _cmd_earth
                   (Tstruct _Int32Vect2 noattr))
                 (Tstruct _Int32Vect2 noattr)) _x tint)
             (Ebinop Oadd
               (Ebinop Oadd (Evalof (Evar _pd_x tint) tint)
                 (Ebinop Oshr
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                           (Tstruct _GuidancePID noattr)) _kv tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                                       (tptr (Tstruct _HorizontalGuidance noattr)))
                                     (Tstruct _HorizontalGuidance noattr))
                                   (Tstruct _HorizontalGuidance noattr)) _ref
                                 (Tstruct _HorizontalGuidanceReference noattr))
                               (Tstruct _HorizontalGuidanceReference noattr))
                             _speed (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _x tint) tint) tint)
                   (Ebinop Osub (Eval (Vint (Int.repr 19)) tint)
                     (Eval (Vint (Int.repr 2)) tint) tint) tint) tint)
               (Ebinop Oshr
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                         (Tstruct _GuidancePID noattr)) _ka tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                                     (tptr (Tstruct _HorizontalGuidance noattr)))
                                   (Tstruct _HorizontalGuidance noattr))
                                 (Tstruct _HorizontalGuidance noattr)) _ref
                               (Tstruct _HorizontalGuidanceReference noattr))
                             (Tstruct _HorizontalGuidanceReference noattr))
                           _accel (Tstruct _Int32Vect2 noattr))
                         (Tstruct _Int32Vect2 noattr)) _x tint) tint) tint)
                 (Ebinop Osub (Eval (Vint (Int.repr 10)) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                       (Tstruct _GuidancePID noattr)) _cmd_earth
                     (Tstruct _Int32Vect2 noattr))
                   (Tstruct _Int32Vect2 noattr)) _y tint)
               (Ebinop Oadd
                 (Ebinop Oadd (Evalof (Evar _pd_y tint) tint)
                   (Ebinop Oshr
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                             (Tstruct _GuidancePID noattr)) _kv tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                                         (tptr (Tstruct _HorizontalGuidance noattr)))
                                       (Tstruct _HorizontalGuidance noattr))
                                     (Tstruct _HorizontalGuidance noattr))
                                   _ref
                                   (Tstruct _HorizontalGuidanceReference noattr))
                                 (Tstruct _HorizontalGuidanceReference noattr))
                               _speed (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                       tint)
                     (Ebinop Osub (Eval (Vint (Int.repr 19)) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) tint) tint)
                 (Ebinop Oshr
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                           (Tstruct _GuidancePID noattr)) _ka tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                                       (tptr (Tstruct _HorizontalGuidance noattr)))
                                     (Tstruct _HorizontalGuidance noattr))
                                   (Tstruct _HorizontalGuidance noattr)) _ref
                                 (Tstruct _HorizontalGuidanceReference noattr))
                               (Tstruct _HorizontalGuidanceReference noattr))
                             _accel (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _y tint) tint) tint)
                   (Ebinop Osub (Eval (Vint (Int.repr 10)) tint)
                     (Eval (Vint (Int.repr 2)) tint) tint) tint) tint) tint))
        (Ssequence
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                           (Tstruct _GuidancePID noattr)) _cmd_earth
                         (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _x tint)
                   (Econdition
                     (Ebinop Olt
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _cmd_earth
                               (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                       (Eunop Oneg (Evalof (Evar _traj_max_bank tint) tint)
                         tint) tint)
                     (Eunop Oneg (Evalof (Evar _traj_max_bank tint) tint)
                       tint)
                     (Econdition
                       (Ebinop Ogt
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                   (Tstruct _GuidancePID noattr)) _cmd_earth
                                 (Tstruct _Int32Vect2 noattr))
                               (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                         (Evalof (Evar _traj_max_bank tint) tint) tint)
                       (Evalof (Evar _traj_max_bank tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _cmd_earth
                               (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                       tint) tint) tint))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                           (Tstruct _GuidancePID noattr)) _cmd_earth
                         (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _y tint)
                   (Econdition
                     (Ebinop Olt
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _cmd_earth
                               (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                       (Eunop Oneg (Evalof (Evar _traj_max_bank tint) tint)
                         tint) tint)
                     (Eunop Oneg (Evalof (Evar _traj_max_bank tint) tint)
                       tint)
                     (Econdition
                       (Ebinop Ogt
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                   (Tstruct _GuidancePID noattr)) _cmd_earth
                                 (Tstruct _Int32Vect2 noattr))
                               (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                         (Evalof (Evar _traj_max_bank tint) tint) tint)
                       (Evalof (Evar _traj_max_bank tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _cmd_earth
                               (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                       tint) tint) tint)))
          (Ssequence
            (Sifthenelse (Evalof (Evar _in_flight tbool) tbool)
              (Ssequence
                (Sdo (Eassignop Oadd
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _x tint)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                               (Tstruct _GuidancePID noattr)) _ki tint) tint)
                         (Evalof (Evar _pd_x tint) tint) tint) tint tint))
                (Ssequence
                  (Sdo (Eassignop Oadd
                         (Efield
                           (Evalof
                             (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _y tint)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _ki tint)
                             tint) (Evalof (Evar _pd_y tint) tint) tint)
                         tint tint))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                 (Tstruct _Int32Vect2 noattr)) _x tint)
                             (Econdition
                               (Ebinop Olt
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                       (Tstruct _Int32Vect2 noattr)) _x tint)
                                   tint)
                                 (Eunop Oneg
                                   (Ebinop Oshl
                                     (Evalof (Evar _traj_max_bank tint) tint)
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 12)) tint)
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) tint) tint) tint) tint)
                               (Eunop Oneg
                                 (Ebinop Oshl
                                   (Evalof (Evar _traj_max_bank tint) tint)
                                   (Ebinop Oadd
                                     (Eval (Vint (Int.repr 12)) tint)
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     tint) tint) tint)
                               (Econdition
                                 (Ebinop Ogt
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                         (Tstruct _Int32Vect2 noattr)) _x
                                       tint) tint)
                                   (Ebinop Oshl
                                     (Evalof (Evar _traj_max_bank tint) tint)
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 12)) tint)
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) tint) tint) tint)
                                 (Ebinop Oshl
                                   (Evalof (Evar _traj_max_bank tint) tint)
                                   (Ebinop Oadd
                                     (Eval (Vint (Int.repr 12)) tint)
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     tint) tint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                       (Tstruct _Int32Vect2 noattr)) _x tint)
                                   tint) tint) tint) tint))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                 (Tstruct _Int32Vect2 noattr)) _y tint)
                             (Econdition
                               (Ebinop Olt
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                       (Tstruct _Int32Vect2 noattr)) _y tint)
                                   tint)
                                 (Eunop Oneg
                                   (Ebinop Oshl
                                     (Evalof (Evar _traj_max_bank tint) tint)
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 12)) tint)
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) tint) tint) tint) tint)
                               (Eunop Oneg
                                 (Ebinop Oshl
                                   (Evalof (Evar _traj_max_bank tint) tint)
                                   (Ebinop Oadd
                                     (Eval (Vint (Int.repr 12)) tint)
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     tint) tint) tint)
                               (Econdition
                                 (Ebinop Ogt
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                         (Tstruct _Int32Vect2 noattr)) _y
                                       tint) tint)
                                   (Ebinop Oshl
                                     (Evalof (Evar _traj_max_bank tint) tint)
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 12)) tint)
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) tint) tint) tint)
                                 (Ebinop Oshl
                                   (Evalof (Evar _traj_max_bank tint) tint)
                                   (Ebinop Oadd
                                     (Eval (Vint (Int.repr 12)) tint)
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     tint) tint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                       (Tstruct _Int32Vect2 noattr)) _y tint)
                                   tint) tint) tint) tint)))
                    (Ssequence
                      (Sdo (Eassignop Oadd
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                     (Tstruct _GuidancePID noattr))
                                   _cmd_earth (Tstruct _Int32Vect2 noattr))
                                 (Tstruct _Int32Vect2 noattr)) _x tint)
                             (Ebinop Oshr
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                     (Tstruct _Int32Vect2 noattr)) _x tint)
                                 tint)
                               (Ebinop Oadd (Eval (Vint (Int.repr 12)) tint)
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Eval (Vint (Int.repr 2)) tint) tint)
                                 tint) tint) tint tint))
                      (Sdo (Eassignop Oadd
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                     (Tstruct _GuidancePID noattr))
                                   _cmd_earth (Tstruct _Int32Vect2 noattr))
                                 (Tstruct _Int32Vect2 noattr)) _y tint)
                             (Ebinop Oshr
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                                     (Tstruct _Int32Vect2 noattr)) _y tint)
                                 tint)
                               (Ebinop Oadd (Eval (Vint (Int.repr 12)) tint)
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Eval (Vint (Int.repr 2)) tint) tint)
                                 tint) tint) tint tint))))))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _x tint)
                       (Eval (Vint (Int.repr 0)) tint) tint))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_trim_att_integrator (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _y tint)
                       (Eval (Vint (Int.repr 0)) tint) tint))))
            (Ssequence
              (Sifthenelse (Eseqand
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                   (Tstruct _GuidancePID noattr))
                                 _approx_force_by_thrust tbool) tbool)
                             (Evalof (Evar _in_flight tbool) tbool) tint)
                (Ssequence
                  (Sdo (Eassign (Evar _vertical_thrust tint)
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _stabilization (Tstruct _Stabilization noattr))
                                         (Tstruct _Stabilization noattr))
                                       _cmd (tarray tint 4)) (tarray tint 4))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _guidance_v (Tstruct _VerticalGuidance noattr))
                                   (Tstruct _VerticalGuidance noattr))
                                 _thrust_coeff tint) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tint))
                  (Ssequence
                    (Sdo (Eassign (Evar _thrust_cmd_filt tint)
                           (Ebinop Odiv
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Evalof (Evar _thrust_cmd_filt tint) tint)
                                 (Eval (Vint (Int.repr 10)) tint) tint)
                               (Evalof (Evar _vertical_thrust tint) tint)
                               tint)
                             (Ebinop Oadd (Eval (Vint (Int.repr 10)) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                     (Tstruct _GuidancePID noattr))
                                   _cmd_earth (Tstruct _Int32Vect2 noattr))
                                 (Tstruct _Int32Vect2 noattr)) _x tint)
                             (Ebinop Omul
                               (Ecall
                                 (Evalof
                                   (Evar _atan2f (Tfunction
                                                   (tfloat :: tfloat :: nil)
                                                   tfloat cc_default))
                                   (Tfunction (tfloat :: tfloat :: nil)
                                     tfloat cc_default))
                                 (Econs
                                   (Ebinop Odiv
                                     (Ebinop Omul
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                                 (Tstruct _GuidancePID noattr))
                                               _cmd_earth
                                               (Tstruct _Int32Vect2 noattr))
                                             (Tstruct _Int32Vect2 noattr)) _x
                                           tint) tint)
                                       (Eval (Vint (Int.repr 9600)) tint)
                                       tint)
                                     (Ecast
                                       (Ebinop Omul
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                                         (Ebinop Oshl
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Eval (Vint (Int.repr 12)) tint)
                                           tint) tdouble) tint) tint)
                                   (Econs
                                     (Evalof (Evar _thrust_cmd_filt tint)
                                       tint) Enil)) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 12)) tint) tint)
                               tfloat) tint))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                     (Tstruct _GuidancePID noattr))
                                   _cmd_earth (Tstruct _Int32Vect2 noattr))
                                 (Tstruct _Int32Vect2 noattr)) _y tint)
                             (Ebinop Omul
                               (Ecall
                                 (Evalof
                                   (Evar _atan2f (Tfunction
                                                   (tfloat :: tfloat :: nil)
                                                   tfloat cc_default))
                                   (Tfunction (tfloat :: tfloat :: nil)
                                     tfloat cc_default))
                                 (Econs
                                   (Ebinop Odiv
                                     (Ebinop Omul
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                                 (Tstruct _GuidancePID noattr))
                                               _cmd_earth
                                               (Tstruct _Int32Vect2 noattr))
                                             (Tstruct _Int32Vect2 noattr)) _y
                                           tint) tint)
                                       (Eval (Vint (Int.repr 9600)) tint)
                                       tint)
                                     (Ecast
                                       (Ebinop Omul
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                                         (Ebinop Oshl
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Eval (Vint (Int.repr 12)) tint)
                                           tint) tdouble) tint) tint)
                                   (Econs
                                     (Evalof (Evar _thrust_cmd_filt tint)
                                       tint) Enil)) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 12)) tint) tint)
                               tfloat) tint)))))
                Sskip)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _cmd_earth
                               (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _x tint)
                         (Econdition
                           (Ebinop Olt
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                       (Tstruct _GuidancePID noattr))
                                     _cmd_earth (Tstruct _Int32Vect2 noattr))
                                   (Tstruct _Int32Vect2 noattr)) _x tint)
                               tint)
                             (Eunop Oneg
                               (Evalof (Evar _total_max_bank tint) tint)
                               tint) tint)
                           (Eunop Oneg
                             (Evalof (Evar _total_max_bank tint) tint) tint)
                           (Econdition
                             (Ebinop Ogt
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                         (Tstruct _GuidancePID noattr))
                                       _cmd_earth
                                       (Tstruct _Int32Vect2 noattr))
                                     (Tstruct _Int32Vect2 noattr)) _x tint)
                                 tint)
                               (Evalof (Evar _total_max_bank tint) tint)
                               tint)
                             (Evalof (Evar _total_max_bank tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                       (Tstruct _GuidancePID noattr))
                                     _cmd_earth (Tstruct _Int32Vect2 noattr))
                                   (Tstruct _Int32Vect2 noattr)) _x tint)
                               tint) tint) tint) tint))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                 (Tstruct _GuidancePID noattr)) _cmd_earth
                               (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _y tint)
                         (Econdition
                           (Ebinop Olt
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                       (Tstruct _GuidancePID noattr))
                                     _cmd_earth (Tstruct _Int32Vect2 noattr))
                                   (Tstruct _Int32Vect2 noattr)) _y tint)
                               tint)
                             (Eunop Oneg
                               (Evalof (Evar _total_max_bank tint) tint)
                               tint) tint)
                           (Eunop Oneg
                             (Evalof (Evar _total_max_bank tint) tint) tint)
                           (Econdition
                             (Ebinop Ogt
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                         (Tstruct _GuidancePID noattr))
                                       _cmd_earth
                                       (Tstruct _Int32Vect2 noattr))
                                     (Tstruct _Int32Vect2 noattr)) _y tint)
                                 tint)
                               (Evalof (Evar _total_max_bank tint) tint)
                               tint)
                             (Evalof (Evar _total_max_bank tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                       (Tstruct _GuidancePID noattr))
                                     _cmd_earth (Tstruct _Int32Vect2 noattr))
                                   (Tstruct _Int32Vect2 noattr)) _y tint)
                               tint) tint) tint) tint)))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Evalof
                             (Evar __res (tptr (Tstruct _StabilizationSetpoint noattr)))
                             (tptr (Tstruct _StabilizationSetpoint noattr)))
                           (Tstruct _StabilizationSetpoint noattr))
                         (Ecomma
                           (Ecall
                             (Evalof
                               (Evar _stab_sp_from_ltp_i (Tfunction
                                                           ((tptr (Tstruct _StabilizationSetpoint noattr)) ::
                                                            (tptr (Tstruct _Int32Vect2 noattr)) ::
                                                            tint :: nil)
                                                           tvoid
                                                           {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                               (Tfunction
                                 ((tptr (Tstruct _StabilizationSetpoint noattr)) ::
                                  (tptr (Tstruct _Int32Vect2 noattr)) ::
                                  tint :: nil) tvoid
                                 {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                             (Econs
                               (Eaddrof
                                 (Evar __res__1 (Tstruct _StabilizationSetpoint noattr))
                                 (tptr (Tstruct _StabilizationSetpoint noattr)))
                               (Econs
                                 (Eaddrof
                                   (Efield
                                     (Evalof
                                       (Evar _guidance_pid (Tstruct _GuidancePID noattr))
                                       (Tstruct _GuidancePID noattr))
                                     _cmd_earth (Tstruct _Int32Vect2 noattr))
                                   (tptr (Tstruct _Int32Vect2 noattr)))
                                 (Econs
                                   (Ebinop Omul
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _guidance_h (Tstruct _HorizontalGuidance noattr))
                                               (Tstruct _HorizontalGuidance noattr))
                                             _sp
                                             (Tstruct _HorizontalGuidanceSetpoint noattr))
                                           (Tstruct _HorizontalGuidanceSetpoint noattr))
                                         _heading tfloat) tfloat)
                                     (Ebinop Oshl
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 12)) tint) tint)
                                     tfloat) Enil))) tvoid)
                           (Evalof
                             (Evar __res__1 (Tstruct _StabilizationSetpoint noattr))
                             (Tstruct _StabilizationSetpoint noattr))
                           (Tstruct _StabilizationSetpoint noattr))
                         (Tstruct _StabilizationSetpoint noattr)))
                  (Sreturn None))))))))))
|}.

Definition f_guidance_pid_h_run_pos := {|
  fn_return := tvoid;
  fn_callconv := {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|};
  fn_params := ((__res, (tptr (Tstruct _StabilizationSetpoint noattr))) ::
                (_in_flight, tbool) ::
                (_gh, (tptr (Tstruct _HorizontalGuidance noattr))) :: nil);
  fn_vars := ((__res__1, (Tstruct _StabilizationSetpoint noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
               (Tstruct _Int32Vect2 noattr)) _x tint)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                               (tptr (Tstruct _HorizontalGuidance noattr)))
                             (Tstruct _HorizontalGuidance noattr))
                           (Tstruct _HorizontalGuidance noattr)) _ref
                         (Tstruct _HorizontalGuidanceReference noattr))
                       (Tstruct _HorizontalGuidanceReference noattr)) _pos
                     (Tstruct _Int32Vect2 noattr))
                   (Tstruct _Int32Vect2 noattr)) _x tint) tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Ecall
                       (Evalof
                         (Evar _stateGetPositionNed_i (Tfunction nil
                                                        (tptr (Tstruct _NedCoor_i noattr))
                                                        cc_default))
                         (Tfunction nil (tptr (Tstruct _NedCoor_i noattr))
                           cc_default)) Enil
                       (tptr (Tstruct _NedCoor_i noattr)))
                     (Tstruct _NedCoor_i noattr))
                   (Tstruct _NedCoor_i noattr)) _x tint) tint) tint) tint))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
               (Tstruct _Int32Vect2 noattr)) _y tint)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                               (tptr (Tstruct _HorizontalGuidance noattr)))
                             (Tstruct _HorizontalGuidance noattr))
                           (Tstruct _HorizontalGuidance noattr)) _ref
                         (Tstruct _HorizontalGuidanceReference noattr))
                       (Tstruct _HorizontalGuidanceReference noattr)) _pos
                     (Tstruct _Int32Vect2 noattr))
                   (Tstruct _Int32Vect2 noattr)) _y tint) tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Ecall
                       (Evalof
                         (Evar _stateGetPositionNed_i (Tfunction nil
                                                        (tptr (Tstruct _NedCoor_i noattr))
                                                        cc_default))
                         (Tfunction nil (tptr (Tstruct _NedCoor_i noattr))
                           cc_default)) Enil
                       (tptr (Tstruct _NedCoor_i noattr)))
                     (Tstruct _NedCoor_i noattr))
                   (Tstruct _NedCoor_i noattr)) _y tint) tint) tint) tint)))
  (Ssequence
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                 (Tstruct _Int32Vect2 noattr)) _x tint)
             (Econdition
               (Ebinop Olt
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                 (Eunop Oneg
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 8)) tint) tint) tdouble)
                   tdouble) tint)
               (Eunop Oneg
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 8)) tint) tint) tdouble) tdouble)
               (Econdition
                 (Ebinop Ogt
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                         (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 8)) tint) tint) tdouble) tint)
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 8)) tint) tint) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _x tint) tint) tdouble)
               tdouble) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                 (Tstruct _Int32Vect2 noattr)) _y tint)
             (Econdition
               (Ebinop Olt
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                 (Eunop Oneg
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 8)) tint) tint) tdouble)
                   tdouble) tint)
               (Eunop Oneg
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 8)) tint) tint) tdouble) tdouble)
               (Econdition
                 (Ebinop Ogt
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                         (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 8)) tint) tint) tdouble) tint)
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 8)) tint) tint) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _guidance_pid_pos_err (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _y tint) tint) tdouble)
               tdouble) tint)))
    (Ssequence
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                   (Tstruct _Int32Vect2 noattr)) _x tint)
               (Ebinop Osub
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                                   (tptr (Tstruct _HorizontalGuidance noattr)))
                                 (Tstruct _HorizontalGuidance noattr))
                               (Tstruct _HorizontalGuidance noattr)) _ref
                             (Tstruct _HorizontalGuidanceReference noattr))
                           (Tstruct _HorizontalGuidanceReference noattr))
                         _speed (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Ecall
                           (Evalof
                             (Evar _stateGetSpeedNed_i (Tfunction nil
                                                         (tptr (Tstruct _NedCoor_i noattr))
                                                         cc_default))
                             (Tfunction nil
                               (tptr (Tstruct _NedCoor_i noattr)) cc_default))
                           Enil (tptr (Tstruct _NedCoor_i noattr)))
                         (Tstruct _NedCoor_i noattr))
                       (Tstruct _NedCoor_i noattr)) _x tint) tint) tint)
               tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                   (Tstruct _Int32Vect2 noattr)) _y tint)
               (Ebinop Osub
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                                   (tptr (Tstruct _HorizontalGuidance noattr)))
                                 (Tstruct _HorizontalGuidance noattr))
                               (Tstruct _HorizontalGuidance noattr)) _ref
                             (Tstruct _HorizontalGuidanceReference noattr))
                           (Tstruct _HorizontalGuidanceReference noattr))
                         _speed (Tstruct _Int32Vect2 noattr))
                       (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Ecall
                           (Evalof
                             (Evar _stateGetSpeedNed_i (Tfunction nil
                                                         (tptr (Tstruct _NedCoor_i noattr))
                                                         cc_default))
                             (Tfunction nil
                               (tptr (Tstruct _NedCoor_i noattr)) cc_default))
                           Enil (tptr (Tstruct _NedCoor_i noattr)))
                         (Tstruct _NedCoor_i noattr))
                       (Tstruct _NedCoor_i noattr)) _y tint) tint) tint)
               tint)))
      (Ssequence
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                     (Tstruct _Int32Vect2 noattr)) _x tint)
                 (Econdition
                   (Ebinop Olt
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                     (Eunop Oneg
                       (Ebinop Omul
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                       tdouble) tint)
                   (Eunop Oneg
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                     tdouble)
                   (Econdition
                     (Ebinop Ogt
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                       (Ebinop Omul
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                       tint)
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _x tint) tint)
                     tdouble) tdouble) tint))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                     (Tstruct _Int32Vect2 noattr)) _y tint)
                 (Econdition
                   (Ebinop Olt
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                     (Eunop Oneg
                       (Ebinop Omul
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                       tdouble) tint)
                   (Eunop Oneg
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                     tdouble)
                   (Econdition
                     (Ebinop Ogt
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                             (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                       (Ebinop Omul
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                       tint)
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4625196817309499392))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 19)) tint) tint) tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _guidance_pid_speed_err (Tstruct _Int32Vect2 noattr))
                           (Tstruct _Int32Vect2 noattr)) _y tint) tint)
                     tdouble) tdouble) tint)))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Evalof
                     (Evar __res (tptr (Tstruct _StabilizationSetpoint noattr)))
                     (tptr (Tstruct _StabilizationSetpoint noattr)))
                   (Tstruct _StabilizationSetpoint noattr))
                 (Ecomma
                   (Ecall
                     (Evalof
                       (Evar _guidance_pid_h_run (Tfunction
                                                   ((tptr (Tstruct _StabilizationSetpoint noattr)) ::
                                                    tbool ::
                                                    (tptr (Tstruct _HorizontalGuidance noattr)) ::
                                                    nil) tvoid
                                                   {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                       (Tfunction
                         ((tptr (Tstruct _StabilizationSetpoint noattr)) ::
                          tbool ::
                          (tptr (Tstruct _HorizontalGuidance noattr)) :: nil)
                         tvoid
                         {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                     (Econs
                       (Eaddrof
                         (Evar __res__1 (Tstruct _StabilizationSetpoint noattr))
                         (tptr (Tstruct _StabilizationSetpoint noattr)))
                       (Econs (Evalof (Evar _in_flight tbool) tbool)
                         (Econs
                           (Evalof
                             (Evar _gh (tptr (Tstruct _HorizontalGuidance noattr)))
                             (tptr (Tstruct _HorizontalGuidance noattr)))
                           Enil))) tvoid)
                   (Evalof
                     (Evar __res__1 (Tstruct _StabilizationSetpoint noattr))
                     (Tstruct _StabilizationSetpoint noattr))
                   (Tstruct _StabilizationSetpoint noattr))
                 (Tstruct _StabilizationSetpoint noattr)))
          (Sreturn None))))))
|}.

Definition composites : list composite_definition :=
(Composite _Int32Vect2 Struct
   (Member_plain _x tint :: Member_plain _y tint :: nil)
   noattr ::
 Composite _GuidancePID Struct
   (Member_plain _kp tint :: Member_plain _kd tint ::
    Member_plain _ki tint :: Member_plain _kv tint ::
    Member_plain _ka tint :: Member_plain _v_kp tint ::
    Member_plain _v_kd tint :: Member_plain _v_ki tint ::
    Member_plain _cmd_earth (Tstruct _Int32Vect2 noattr) ::
    Member_plain _cmd_thrust tint ::
    Member_plain _approx_force_by_thrust tbool ::
    Member_plain _adapt_throttle_enabled tbool :: nil)
   noattr ::
 Composite _HorizontalGuidanceSetpoint Struct
   (Member_plain _pos (Tstruct _Int32Vect2 noattr) ::
    Member_plain _speed (Tstruct _Int32Vect2 noattr) ::
    Member_plain _accel (Tstruct _Int32Vect2 noattr) ::
    Member_plain _heading tfloat :: Member_plain _heading_rate tfloat ::
    Member_plain _h_mask tint :: Member_plain _yaw_mask tint :: nil)
   noattr ::
 Composite _HorizontalGuidanceReference Struct
   (Member_plain _pos (Tstruct _Int32Vect2 noattr) ::
    Member_plain _speed (Tstruct _Int32Vect2 noattr) ::
    Member_plain _accel (Tstruct _Int32Vect2 noattr) :: nil)
   noattr ::
 Composite _HorizontalGuidanceRCInput Struct
   (Member_plain _vect (Tstruct _Int32Vect2 noattr) ::
    Member_plain _heading tfloat :: Member_plain _last_ts tfloat :: nil)
   noattr ::
 Composite _HorizontalGuidance Struct
   (Member_plain _mode tuchar :: Member_plain _use_ref tbool ::
    Member_plain _sp (Tstruct _HorizontalGuidanceSetpoint noattr) ::
    Member_plain _ref (Tstruct _HorizontalGuidanceReference noattr) ::
    Member_plain _rc_sp (Tstruct _HorizontalGuidanceRCInput noattr) :: nil)
   noattr ::
 Composite _EcefCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _LlaCoor_i Struct
   (Member_plain _lat tint :: Member_plain _lon tint ::
    Member_plain _alt tint :: nil)
   noattr ::
 Composite _Int32RMat Struct (Member_plain _m (tarray tint 9) :: nil) noattr ::
 Composite _LtpDef_i Struct
   (Member_plain _ecef (Tstruct _EcefCoor_i noattr) ::
    Member_plain _lla (Tstruct _LlaCoor_i noattr) ::
    Member_plain _ltp_of_ecef (Tstruct _Int32RMat noattr) ::
    Member_plain _hmsl tint :: nil)
   noattr ::
 Composite _NedCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _EnuCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _UtmCoor_f Struct
   (Member_plain _north tfloat :: Member_plain _east tfloat ::
    Member_plain _alt tfloat :: Member_plain _zone tuchar :: nil)
   noattr ::
 Composite _LlaCoor_f Struct
   (Member_plain _lat tfloat :: Member_plain _lon tfloat ::
    Member_plain _alt tfloat :: nil)
   noattr ::
 Composite _EcefCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _FloatRMat Struct
   (Member_plain _m (tarray tfloat 9) :: nil)
   noattr ::
 Composite _LtpDef_f Struct
   (Member_plain _ecef (Tstruct _EcefCoor_f noattr) ::
    Member_plain _lla (Tstruct _LlaCoor_f noattr) ::
    Member_plain _ltp_of_ecef (Tstruct _FloatRMat noattr) ::
    Member_plain _hmsl tfloat :: nil)
   noattr ::
 Composite _NedCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _EnuCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _Int32Vect3 Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _Int32Quat Struct
   (Member_plain _qi tint :: Member_plain _qx tint ::
    Member_plain _qy tint :: Member_plain _qz tint :: nil)
   noattr ::
 Composite _Int32Eulers Struct
   (Member_plain _phi tint :: Member_plain _theta tint ::
    Member_plain _psi tint :: nil)
   noattr ::
 Composite _FloatQuat Struct
   (Member_plain _qi tfloat :: Member_plain _qx tfloat ::
    Member_plain _qy tfloat :: Member_plain _qz tfloat :: nil)
   noattr ::
 Composite _FloatEulers Struct
   (Member_plain _phi tfloat :: Member_plain _theta tfloat ::
    Member_plain _psi tfloat :: nil)
   noattr ::
 Composite _OrientationReps Struct
   (Member_plain _status tuchar ::
    Member_plain _quat_i (Tstruct _Int32Quat noattr) ::
    Member_plain _eulers_i (Tstruct _Int32Eulers noattr) ::
    Member_plain _rmat_i (Tstruct _Int32RMat noattr) ::
    Member_plain _quat_f (Tstruct _FloatQuat noattr) ::
    Member_plain _eulers_f (Tstruct _FloatEulers noattr) ::
    Member_plain _eulers_zxy_f (Tstruct _FloatEulers noattr) ::
    Member_plain _rmat_f (Tstruct _FloatRMat noattr) :: nil)
   noattr ::
 Composite _Int32Rates Struct
   (Member_plain _p tint :: Member_plain _q tint :: Member_plain _r tint ::
    nil)
   noattr ::
 Composite _FloatRates Struct
   (Member_plain _p tfloat :: Member_plain _q tfloat ::
    Member_plain _r tfloat :: nil)
   noattr ::
 Composite _FloatVect3 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _FloatVect2 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat :: nil)
   noattr ::
 Composite __1084 Union
   (Member_plain _vect3 (Tstruct _Int32Vect3 noattr) ::
    Member_plain _vect2 (Tstruct _Int32Vect2 noattr) :: nil)
   noattr ::
 Composite __1085 Union
   (Member_plain _vect3 (Tstruct _FloatVect3 noattr) ::
    Member_plain _vect2 (Tstruct _FloatVect2 noattr) :: nil)
   noattr ::
 Composite _State Struct
   (Member_plain _origin_input_filter tushort ::
    Member_plain _pos_status tushort ::
    Member_plain _pos_input_filter tushort ::
    Member_plain _ecef_pos_i (Tstruct _EcefCoor_i noattr) ::
    Member_plain _lla_pos_i (Tstruct _LlaCoor_i noattr) ::
    Member_plain _ned_origin_i (Tstruct _LtpDef_i noattr) ::
    Member_plain _ned_initialized_i tbool ::
    Member_plain _ned_pos_i (Tstruct _NedCoor_i noattr) ::
    Member_plain _enu_pos_i (Tstruct _EnuCoor_i noattr) ::
    Member_plain _utm_pos_f (Tstruct _UtmCoor_f noattr) ::
    Member_plain _alt_agl_f tfloat ::
    Member_plain _lla_pos_f (Tstruct _LlaCoor_f noattr) ::
    Member_plain _ecef_pos_f (Tstruct _EcefCoor_f noattr) ::
    Member_plain _ned_origin_f (Tstruct _LtpDef_f noattr) ::
    Member_plain _ned_initialized_f tbool ::
    Member_plain _utm_origin_f (Tstruct _UtmCoor_f noattr) ::
    Member_plain _utm_initialized_f tbool ::
    Member_plain _ned_pos_f (Tstruct _NedCoor_f noattr) ::
    Member_plain _enu_pos_f (Tstruct _EnuCoor_f noattr) ::
    Member_plain _speed_status tushort ::
    Member_plain _speed_input_filter tushort ::
    Member_plain _ecef_speed_i (Tstruct _EcefCoor_i noattr) ::
    Member_plain _ned_speed_i (Tstruct _NedCoor_i noattr) ::
    Member_plain _enu_speed_i (Tstruct _EnuCoor_i noattr) ::
    Member_plain _h_speed_norm_i tuint :: Member_plain _h_speed_dir_i tint ::
    Member_plain _ecef_speed_f (Tstruct _EcefCoor_f noattr) ::
    Member_plain _ned_speed_f (Tstruct _NedCoor_f noattr) ::
    Member_plain _enu_speed_f (Tstruct _EnuCoor_f noattr) ::
    Member_plain _h_speed_norm_f tfloat ::
    Member_plain _h_speed_dir_f tfloat ::
    Member_plain _accel_status tuchar ::
    Member_plain _accel_input_filter tushort ::
    Member_plain _body_accel_i (Tstruct _Int32Vect3 noattr) ::
    Member_plain _ned_accel_i (Tstruct _NedCoor_i noattr) ::
    Member_plain _ecef_accel_i (Tstruct _EcefCoor_i noattr) ::
    Member_plain _ned_accel_f (Tstruct _NedCoor_f noattr) ::
    Member_plain _ecef_accel_f (Tstruct _EcefCoor_f noattr) ::
    Member_plain _ned_to_body_orientation (Tstruct _OrientationReps noattr) ::
    Member_plain _attitude_input_filter tushort ::
    Member_plain _rate_status tuchar ::
    Member_plain _rates_input_filter tushort ::
    Member_plain _body_rates_i (Tstruct _Int32Rates noattr) ::
    Member_plain _body_rates_f (Tstruct _FloatRates noattr) ::
    Member_plain _wind_air_status tuchar ::
    Member_plain _wind_air_input_filter tushort ::
    Member_plain _windspeed_i (Tunion __1084 noattr) ::
    Member_plain _airspeed_i tint ::
    Member_plain _windspeed_f (Tunion __1085 noattr) ::
    Member_plain _airspeed_f tfloat ::
    Member_plain _angle_of_attack_f tfloat ::
    Member_plain _sideslip_f tfloat :: nil)
   noattr ::
 Composite _AttitudeRCInput Struct
   (Member_plain _rc_quat (Tstruct _FloatQuat noattr) ::
    Member_plain _rc_eulers (Tstruct _FloatEulers noattr) ::
    Member_plain _care_free_heading tfloat ::
    Member_plain _transition_theta_offset tfloat ::
    Member_plain _last_ts tfloat :: nil)
   noattr ::
 Composite __1098 Struct
   (Member_plain _vect (Tstruct _Int32Vect2 noattr) ::
    Member_plain _heading tint :: nil)
   noattr ::
 Composite __1099 Struct
   (Member_plain _vect (Tstruct _FloatVect2 noattr) ::
    Member_plain _heading tfloat :: nil)
   noattr ::
 Composite __1097 Union
   (Member_plain _quat_i (Tstruct _Int32Quat noattr) ::
    Member_plain _quat_f (Tstruct _FloatQuat noattr) ::
    Member_plain _eulers_i (Tstruct _Int32Eulers noattr) ::
    Member_plain _eulers_f (Tstruct _FloatEulers noattr) ::
    Member_plain _ltp_i (Tstruct __1098 noattr) ::
    Member_plain _ltp_f (Tstruct __1099 noattr) :: nil)
   noattr ::
 Composite __1100 Union
   (Member_plain _rates_i (Tstruct _Int32Rates noattr) ::
    Member_plain _rates_f (Tstruct _FloatRates noattr) :: nil)
   noattr ::
 Composite _StabilizationSetpoint Struct
   (Member_plain _type tint :: Member_plain _format tint ::
    Member_plain _sp (Tunion __1097 noattr) ::
    Member_plain _r_sp (Tunion __1100 noattr) :: nil)
   noattr ::
 Composite _Stabilization Struct
   (Member_plain _mode tuchar :: Member_plain _att_submode tuchar ::
    Member_plain _rc_in (Tstruct _AttitudeRCInput noattr) ::
    Member_plain _rc_sp (Tstruct _StabilizationSetpoint noattr) ::
    Member_plain _sp (Tstruct _StabilizationSetpoint noattr) ::
    Member_plain _cmd (tarray tint 4) ::
    Member_plain _transition_ratio tfloat :: nil)
   noattr ::
 Composite __1109 Union
   (Member_plain _thrust_i (tarray tint 3) ::
    Member_plain _thrust_f (tarray tfloat 3) ::
    Member_plain _th_incr_i (tarray tint 3) ::
    Member_plain _th_incr_f (tarray tfloat 3) :: nil)
   noattr ::
 Composite _ThrustSetpoint Struct
   (Member_plain _type tint :: Member_plain _format tint ::
    Member_plain _sp (Tunion __1109 noattr) :: nil)
   noattr ::
 Composite _VerticalGuidance Struct
   (Member_plain _mode tuchar :: Member_plain _z_sp tint ::
    Member_plain _zd_sp tint :: Member_plain _zdd_sp tint ::
    Member_plain _z_ref tint :: Member_plain _zd_ref tint ::
    Member_plain _zdd_ref tint :: Member_plain _rc_delta_t tint ::
    Member_plain _rc_zd_sp tint :: Member_plain _th_sp tint ::
    Member_plain _thrust (Tstruct _ThrustSetpoint noattr) ::
    Member_plain _nominal_throttle tfloat ::
    Member_plain _thrust_coeff tint :: nil)
   noattr :: nil).

Definition global_definitions : list (ident * globdef fundef type) :=
((___compcert_va_int32,
   Gfun(External (EF_runtime "__compcert_va_int32"
                   (mksignature (AST.Xptr :: nil) AST.Xint cc_default))
     ((tptr tvoid) :: nil) tuint cc_default)) ::
 (___compcert_va_int64,
   Gfun(External (EF_runtime "__compcert_va_int64"
                   (mksignature (AST.Xptr :: nil) AST.Xlong cc_default))
     ((tptr tvoid) :: nil) tulong cc_default)) ::
 (___compcert_va_float64,
   Gfun(External (EF_runtime "__compcert_va_float64"
                   (mksignature (AST.Xptr :: nil) AST.Xfloat cc_default))
     ((tptr tvoid) :: nil) tdouble cc_default)) ::
 (___compcert_va_composite,
   Gfun(External (EF_runtime "__compcert_va_composite"
                   (mksignature (AST.Xptr :: AST.Xlong :: nil) AST.Xptr
                     cc_default)) ((tptr tvoid) :: tulong :: nil)
     (tptr tvoid) cc_default)) ::
 (___compcert_i64_dtos,
   Gfun(External (EF_runtime "__compcert_i64_dtos"
                   (mksignature (AST.Xfloat :: nil) AST.Xlong cc_default))
     (tdouble :: nil) tlong cc_default)) ::
 (___compcert_i64_dtou,
   Gfun(External (EF_runtime "__compcert_i64_dtou"
                   (mksignature (AST.Xfloat :: nil) AST.Xlong cc_default))
     (tdouble :: nil) tulong cc_default)) ::
 (___compcert_i64_stod,
   Gfun(External (EF_runtime "__compcert_i64_stod"
                   (mksignature (AST.Xlong :: nil) AST.Xfloat cc_default))
     (tlong :: nil) tdouble cc_default)) ::
 (___compcert_i64_utod,
   Gfun(External (EF_runtime "__compcert_i64_utod"
                   (mksignature (AST.Xlong :: nil) AST.Xfloat cc_default))
     (tulong :: nil) tdouble cc_default)) ::
 (___compcert_i64_stof,
   Gfun(External (EF_runtime "__compcert_i64_stof"
                   (mksignature (AST.Xlong :: nil) AST.Xsingle cc_default))
     (tlong :: nil) tfloat cc_default)) ::
 (___compcert_i64_utof,
   Gfun(External (EF_runtime "__compcert_i64_utof"
                   (mksignature (AST.Xlong :: nil) AST.Xsingle cc_default))
     (tulong :: nil) tfloat cc_default)) ::
 (___compcert_i64_sdiv,
   Gfun(External (EF_runtime "__compcert_i64_sdiv"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___compcert_i64_udiv,
   Gfun(External (EF_runtime "__compcert_i64_udiv"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tulong :: tulong :: nil) tulong
     cc_default)) ::
 (___compcert_i64_smod,
   Gfun(External (EF_runtime "__compcert_i64_smod"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___compcert_i64_umod,
   Gfun(External (EF_runtime "__compcert_i64_umod"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tulong :: tulong :: nil) tulong
     cc_default)) ::
 (___compcert_i64_shl,
   Gfun(External (EF_runtime "__compcert_i64_shl"
                   (mksignature (AST.Xlong :: AST.Xint :: nil) AST.Xlong
                     cc_default)) (tlong :: tint :: nil) tlong cc_default)) ::
 (___compcert_i64_shr,
   Gfun(External (EF_runtime "__compcert_i64_shr"
                   (mksignature (AST.Xlong :: AST.Xint :: nil) AST.Xlong
                     cc_default)) (tulong :: tint :: nil) tulong cc_default)) ::
 (___compcert_i64_sar,
   Gfun(External (EF_runtime "__compcert_i64_sar"
                   (mksignature (AST.Xlong :: AST.Xint :: nil) AST.Xlong
                     cc_default)) (tlong :: tint :: nil) tlong cc_default)) ::
 (___compcert_i64_smulh,
   Gfun(External (EF_runtime "__compcert_i64_smulh"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___compcert_i64_umulh,
   Gfun(External (EF_runtime "__compcert_i64_umulh"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tulong :: tulong :: nil) tulong
     cc_default)) ::
 (___builtin_ais_annot,
   Gfun(External (EF_builtin "__builtin_ais_annot"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     ((tptr tschar) :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (___builtin_bswap64,
   Gfun(External (EF_builtin "__builtin_bswap64"
                   (mksignature (AST.Xlong :: nil) AST.Xlong cc_default))
     (tulong :: nil) tulong cc_default)) ::
 (___builtin_bswap,
   Gfun(External (EF_builtin "__builtin_bswap"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tuint cc_default)) ::
 (___builtin_bswap32,
   Gfun(External (EF_builtin "__builtin_bswap32"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tuint cc_default)) ::
 (___builtin_bswap16,
   Gfun(External (EF_builtin "__builtin_bswap16"
                   (mksignature (AST.Xint16unsigned :: nil)
                     AST.Xint16unsigned cc_default)) (tushort :: nil) tushort
     cc_default)) ::
 (___builtin_clz,
   Gfun(External (EF_builtin "__builtin_clz"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tint cc_default)) ::
 (___builtin_clzl,
   Gfun(External (EF_builtin "__builtin_clzl"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_clzll,
   Gfun(External (EF_builtin "__builtin_clzll"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_ctz,
   Gfun(External (EF_builtin "__builtin_ctz"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tint cc_default)) ::
 (___builtin_ctzl,
   Gfun(External (EF_builtin "__builtin_ctzl"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_ctzll,
   Gfun(External (EF_builtin "__builtin_ctzll"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_fabs,
   Gfun(External (EF_builtin "__builtin_fabs"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fabsf,
   Gfun(External (EF_builtin "__builtin_fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (___builtin_fsqrt,
   Gfun(External (EF_builtin "__builtin_fsqrt"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (___builtin_sqrt,
   Gfun(External (EF_builtin "__builtin_sqrt"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (___builtin_memcpy_aligned,
   Gfun(External (EF_builtin "__builtin_memcpy_aligned"
                   (mksignature
                     (AST.Xptr :: AST.Xptr :: AST.Xlong :: AST.Xlong :: nil)
                     AST.Xvoid cc_default))
     ((tptr tvoid) :: (tptr tvoid) :: tulong :: tulong :: nil) tvoid
     cc_default)) ::
 (___builtin_sel,
   Gfun(External (EF_builtin "__builtin_sel"
                   (mksignature (AST.Xbool :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     (tbool :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (___builtin_annot,
   Gfun(External (EF_builtin "__builtin_annot"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     ((tptr tschar) :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (___builtin_annot_intval,
   Gfun(External (EF_builtin "__builtin_annot_intval"
                   (mksignature (AST.Xptr :: AST.Xint :: nil) AST.Xint
                     cc_default)) ((tptr tschar) :: tint :: nil) tint
     cc_default)) ::
 (___builtin_membar,
   Gfun(External (EF_builtin "__builtin_membar"
                   (mksignature nil AST.Xvoid cc_default)) nil tvoid
     cc_default)) ::
 (___builtin_va_start,
   Gfun(External (EF_builtin "__builtin_va_start"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid cc_default))
     ((tptr tvoid) :: nil) tvoid cc_default)) ::
 (___builtin_va_arg,
   Gfun(External (EF_builtin "__builtin_va_arg"
                   (mksignature (AST.Xptr :: AST.Xint :: nil) AST.Xvoid
                     cc_default)) ((tptr tvoid) :: tuint :: nil) tvoid
     cc_default)) ::
 (___builtin_va_copy,
   Gfun(External (EF_builtin "__builtin_va_copy"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default)) ((tptr tvoid) :: (tptr tvoid) :: nil) tvoid
     cc_default)) ::
 (___builtin_va_end,
   Gfun(External (EF_builtin "__builtin_va_end"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid cc_default))
     ((tptr tvoid) :: nil) tvoid cc_default)) ::
 (___builtin_unreachable,
   Gfun(External (EF_builtin "__builtin_unreachable"
                   (mksignature nil AST.Xvoid cc_default)) nil tvoid
     cc_default)) ::
 (___builtin_expect,
   Gfun(External (EF_builtin "__builtin_expect"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___builtin_fmax,
   Gfun(External (EF_builtin "__builtin_fmax"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (___builtin_fmin,
   Gfun(External (EF_builtin "__builtin_fmin"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (___builtin_fmadd,
   Gfun(External (EF_builtin "__builtin_fmadd"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fmsub,
   Gfun(External (EF_builtin "__builtin_fmsub"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fnmadd,
   Gfun(External (EF_builtin "__builtin_fnmadd"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fnmsub,
   Gfun(External (EF_builtin "__builtin_fnmsub"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_read16_reversed,
   Gfun(External (EF_builtin "__builtin_read16_reversed"
                   (mksignature (AST.Xptr :: nil) AST.Xint16unsigned
                     cc_default)) ((tptr tushort) :: nil) tushort
     cc_default)) ::
 (___builtin_read32_reversed,
   Gfun(External (EF_builtin "__builtin_read32_reversed"
                   (mksignature (AST.Xptr :: nil) AST.Xint cc_default))
     ((tptr tuint) :: nil) tuint cc_default)) ::
 (___builtin_write16_reversed,
   Gfun(External (EF_builtin "__builtin_write16_reversed"
                   (mksignature (AST.Xptr :: AST.Xint16unsigned :: nil)
                     AST.Xvoid cc_default))
     ((tptr tushort) :: tushort :: nil) tvoid cc_default)) ::
 (___builtin_write32_reversed,
   Gfun(External (EF_builtin "__builtin_write32_reversed"
                   (mksignature (AST.Xptr :: AST.Xint :: nil) AST.Xvoid
                     cc_default)) ((tptr tuint) :: tuint :: nil) tvoid
     cc_default)) ::
 (___builtin_debug,
   Gfun(External (EF_external "__builtin_debug"
                   (mksignature (AST.Xint :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     (tint :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (_atan2f,
   Gfun(External (EF_external "atan2f"
                   (mksignature (AST.Xsingle :: AST.Xsingle :: nil)
                     AST.Xsingle cc_default)) (tfloat :: tfloat :: nil)
     tfloat cc_default)) :: (_guidance_pid, Gvar v_guidance_pid) ::
 (_guidance_pid_pos_err, Gvar v_guidance_pid_pos_err) ::
 (_guidance_pid_speed_err, Gvar v_guidance_pid_speed_err) ::
 (_guidance_pid_trim_att_integrator, Gvar v_guidance_pid_trim_att_integrator) ::
 (_guidance_h, Gvar v_guidance_h) :: (_guidance_v, Gvar v_guidance_v) ::
 (_stabilization, Gvar v_stabilization) :: (_state, Gvar v_state) ::
 (_stateCalcPositionNed_i,
   Gfun(External (EF_external "stateCalcPositionNed_i"
                   (mksignature nil AST.Xvoid cc_default)) nil tvoid
     cc_default)) ::
 (_stateCalcSpeedNed_i,
   Gfun(External (EF_external "stateCalcSpeedNed_i"
                   (mksignature nil AST.Xvoid cc_default)) nil tvoid
     cc_default)) ::
 (_stateGetPositionNed_i, Gfun(Internal f_stateGetPositionNed_i)) ::
 (_stateGetSpeedNed_i, Gfun(Internal f_stateGetSpeedNed_i)) ::
 (_stab_sp_from_ltp_i, Gfun(Internal f_stab_sp_from_ltp_i)) ::
 (_traj_max_bank, Gvar v_traj_max_bank) ::
 (_total_max_bank, Gvar v_total_max_bank) ::
 (_thrust_cmd_filt, Gvar v_thrust_cmd_filt) ::
 (_guidance_pid_h_run, Gfun(Internal f_guidance_pid_h_run)) ::
 (_guidance_pid_h_run_pos, Gfun(Internal f_guidance_pid_h_run_pos)) :: nil).

Definition public_idents : list ident :=
(_guidance_pid_h_run_pos :: _stab_sp_from_ltp_i :: _stateCalcSpeedNed_i ::
 _stateCalcPositionNed_i :: _state :: _stabilization :: _guidance_v ::
 _guidance_h :: _guidance_pid_trim_att_integrator ::
 _guidance_pid_speed_err :: _guidance_pid_pos_err :: _guidance_pid ::
 _atan2f :: ___builtin_debug :: ___builtin_write32_reversed ::
 ___builtin_write16_reversed :: ___builtin_read32_reversed ::
 ___builtin_read16_reversed :: ___builtin_fnmsub :: ___builtin_fnmadd ::
 ___builtin_fmsub :: ___builtin_fmadd :: ___builtin_fmin ::
 ___builtin_fmax :: ___builtin_expect :: ___builtin_unreachable ::
 ___builtin_va_end :: ___builtin_va_copy :: ___builtin_va_arg ::
 ___builtin_va_start :: ___builtin_membar :: ___builtin_annot_intval ::
 ___builtin_annot :: ___builtin_sel :: ___builtin_memcpy_aligned ::
 ___builtin_sqrt :: ___builtin_fsqrt :: ___builtin_fabsf ::
 ___builtin_fabs :: ___builtin_ctzll :: ___builtin_ctzl :: ___builtin_ctz ::
 ___builtin_clzll :: ___builtin_clzl :: ___builtin_clz ::
 ___builtin_bswap16 :: ___builtin_bswap32 :: ___builtin_bswap ::
 ___builtin_bswap64 :: ___builtin_ais_annot :: ___compcert_i64_umulh ::
 ___compcert_i64_smulh :: ___compcert_i64_sar :: ___compcert_i64_shr ::
 ___compcert_i64_shl :: ___compcert_i64_umod :: ___compcert_i64_smod ::
 ___compcert_i64_udiv :: ___compcert_i64_sdiv :: ___compcert_i64_utof ::
 ___compcert_i64_stof :: ___compcert_i64_utod :: ___compcert_i64_stod ::
 ___compcert_i64_dtou :: ___compcert_i64_dtos :: ___compcert_va_composite ::
 ___compcert_va_float64 :: ___compcert_va_int64 :: ___compcert_va_int32 ::
 nil).

Definition prog : Csyntax.program := 
  mkprogram composites global_definitions public_idents _main Logic.I.


