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
  Definition source_file := "/home/yangfp/five/paparazzi/models/stateGetSpeedEcef_f/align/model/preprocessed.i".
End Info.

Definition _DoubleRMat : ident := $"DoubleRMat".
Definition _EcefCoor_d : ident := $"EcefCoor_d".
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
Definition _State : ident := $"State".
Definition _UtmCoor_f : ident := $"UtmCoor_f".
Definition __212 : ident := $"_212".
Definition __213 : ident := $"_213".
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
Definition _accel_input_filter : ident := $"accel_input_filter".
Definition _accel_status : ident := $"accel_status".
Definition _airspeed_f : ident := $"airspeed_f".
Definition _airspeed_i : ident := $"airspeed_i".
Definition _alt : ident := $"alt".
Definition _alt_agl_f : ident := $"alt_agl_f".
Definition _angle_of_attack_f : ident := $"angle_of_attack_f".
Definition _attitude_input_filter : ident := $"attitude_input_filter".
Definition _body_accel_i : ident := $"body_accel_i".
Definition _body_rates_f : ident := $"body_rates_f".
Definition _body_rates_i : ident := $"body_rates_i".
Definition _def : ident := $"def".
Definition _east : ident := $"east".
Definition _ecef : ident := $"ecef".
Definition _ecef_accel_f : ident := $"ecef_accel_f".
Definition _ecef_accel_i : ident := $"ecef_accel_i".
Definition _ecef_d : ident := $"ecef_d".
Definition _ecef_of_enu_vect_f : ident := $"ecef_of_enu_vect_f".
Definition _ecef_of_ned_vect_f : ident := $"ecef_of_ned_vect_f".
Definition _ecef_pos_f : ident := $"ecef_pos_f".
Definition _ecef_pos_i : ident := $"ecef_pos_i".
Definition _ecef_speed_f : ident := $"ecef_speed_f".
Definition _ecef_speed_i : ident := $"ecef_speed_i".
Definition _enu : ident := $"enu".
Definition _enu_d : ident := $"enu_d".
Definition _enu_pos_f : ident := $"enu_pos_f".
Definition _enu_pos_i : ident := $"enu_pos_i".
Definition _enu_speed_f : ident := $"enu_speed_f".
Definition _enu_speed_i : ident := $"enu_speed_i".
Definition _eulers_f : ident := $"eulers_f".
Definition _eulers_i : ident := $"eulers_i".
Definition _eulers_zxy_f : ident := $"eulers_zxy_f".
Definition _h_speed_dir_f : ident := $"h_speed_dir_f".
Definition _h_speed_dir_i : ident := $"h_speed_dir_i".
Definition _h_speed_norm_f : ident := $"h_speed_norm_f".
Definition _h_speed_norm_i : ident := $"h_speed_norm_i".
Definition _hmsl : ident := $"hmsl".
Definition _lat : ident := $"lat".
Definition _lla : ident := $"lla".
Definition _lla_pos_f : ident := $"lla_pos_f".
Definition _lla_pos_i : ident := $"lla_pos_i".
Definition _lon : ident := $"lon".
Definition _ltp_of_ecef : ident := $"ltp_of_ecef".
Definition _ltp_of_ecef_d : ident := $"ltp_of_ecef_d".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _ned : ident := $"ned".
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
Definition _north : ident := $"north".
Definition _origin_input_filter : ident := $"origin_input_filter".
Definition _p : ident := $"p".
Definition _phi : ident := $"phi".
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
Definition _rate_status : ident := $"rate_status".
Definition _rates_input_filter : ident := $"rates_input_filter".
Definition _rmat_f : ident := $"rmat_f".
Definition _rmat_i : ident := $"rmat_i".
Definition _sideslip_f : ident := $"sideslip_f".
Definition _speed_input_filter : ident := $"speed_input_filter".
Definition _speed_status : ident := $"speed_status".
Definition _state : ident := $"state".
Definition _stateCalcSpeedEcef_f : ident := $"stateCalcSpeedEcef_f".
Definition _stateGetSpeedEcef_f : ident := $"stateGetSpeedEcef_f".
Definition _status : ident := $"status".
Definition _theta : ident := $"theta".
Definition _utm_initialized_f : ident := $"utm_initialized_f".
Definition _utm_origin_f : ident := $"utm_origin_f".
Definition _utm_pos_f : ident := $"utm_pos_f".
Definition _vect2 : ident := $"vect2".
Definition _vect3 : ident := $"vect3".
Definition _wind_air_input_filter : ident := $"wind_air_input_filter".
Definition _wind_air_status : ident := $"wind_air_status".
Definition _windspeed_f : ident := $"windspeed_f".
Definition _windspeed_i : ident := $"windspeed_i".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".
Definition _zone : ident := $"zone".

Definition v_state := {|
  gvar_info := (Tstruct _State noattr);
  gvar_init := (Init_space 656 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_ecef_of_enu_vect_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_enu, (tptr (Tstruct _EnuCoor_f noattr))) :: nil);
  fn_vars := ((_ltp_of_ecef_d, (Tstruct _DoubleRMat noattr)) ::
              (_enu_d, (Tstruct _EnuCoor_f noattr)) ::
              (_ecef_d, (Tstruct _EcefCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof
               (Efield
                 (Evalof (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                   (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
               (tarray tdouble 9)) (Eval (Vint (Int.repr 0)) tint)
             (tptr tdouble)) tdouble)
         (Ecast
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                               (tptr (Tstruct _LtpDef_f noattr)))
                             (Tstruct _LtpDef_f noattr))
                           (Tstruct _LtpDef_f noattr)) _ltp_of_ecef
                         (Tstruct _FloatRMat noattr))
                       (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                   (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                 (tptr tfloat)) tfloat) tfloat) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                     (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                 (tarray tdouble 9)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tdouble)) tdouble)
           (Ecast
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                 (tptr (Tstruct _LtpDef_f noattr)))
                               (Tstruct _LtpDef_f noattr))
                             (Tstruct _LtpDef_f noattr)) _ltp_of_ecef
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
                   (tptr tfloat)) tfloat) tfloat) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                       (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                   (tarray tdouble 9)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tdouble)) tdouble)
             (Ecast
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                   (tptr (Tstruct _LtpDef_f noattr)))
                                 (Tstruct _LtpDef_f noattr))
                               (Tstruct _LtpDef_f noattr)) _ltp_of_ecef
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tfloat)) tfloat) tfloat) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tdouble)) tdouble)
               (Ecast
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                     (tptr (Tstruct _LtpDef_f noattr)))
                                   (Tstruct _LtpDef_f noattr))
                                 (Tstruct _LtpDef_f noattr)) _ltp_of_ecef
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
                   tfloat) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 4)) tint) (tptr tdouble)) tdouble)
                 (Ecast
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                       (tptr (Tstruct _LtpDef_f noattr)))
                                     (Tstruct _LtpDef_f noattr))
                                   (Tstruct _LtpDef_f noattr)) _ltp_of_ecef
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                       tfloat) tfloat) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
                     tdouble)
                   (Ecast
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                         (tptr (Tstruct _LtpDef_f noattr)))
                                       (Tstruct _LtpDef_f noattr))
                                     (Tstruct _LtpDef_f noattr)) _ltp_of_ecef
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                         tfloat) tfloat) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tdouble))
                       tdouble)
                     (Ecast
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                           (tptr (Tstruct _LtpDef_f noattr)))
                                         (Tstruct _LtpDef_f noattr))
                                       (Tstruct _LtpDef_f noattr))
                                     _ltp_of_ecef
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 6)) tint) (tptr tfloat))
                           tfloat) tfloat) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tdouble))
                         tdouble)
                       (Ecast
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                             (tptr (Tstruct _LtpDef_f noattr)))
                                           (Tstruct _LtpDef_f noattr))
                                         (Tstruct _LtpDef_f noattr))
                                       _ltp_of_ecef
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                             tfloat) tfloat) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tdouble))
                           tdouble)
                         (Ecast
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                                               (tptr (Tstruct _LtpDef_f noattr)))
                                             (Tstruct _LtpDef_f noattr))
                                           (Tstruct _LtpDef_f noattr))
                                         _ltp_of_ecef
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tdouble)
                         tdouble))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                               (Tstruct _EnuCoor_f noattr)) _x tfloat)
                           (Ecast
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                                       (tptr (Tstruct _EnuCoor_f noattr)))
                                     (Tstruct _EnuCoor_f noattr))
                                   (Tstruct _EnuCoor_f noattr)) _x tfloat)
                               tfloat) tdouble) tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                 (Tstruct _EnuCoor_f noattr)) _y tfloat)
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                                         (tptr (Tstruct _EnuCoor_f noattr)))
                                       (Tstruct _EnuCoor_f noattr))
                                     (Tstruct _EnuCoor_f noattr)) _y tfloat)
                                 tfloat) tdouble) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                   (Tstruct _EnuCoor_f noattr)) _z tfloat)
                               (Ecast
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                                           (tptr (Tstruct _EnuCoor_f noattr)))
                                         (Tstruct _EnuCoor_f noattr))
                                       (Tstruct _EnuCoor_f noattr)) _z
                                     tfloat) tfloat) tdouble) tfloat))
                        (Ssequence
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                       (Tstruct _EcefCoor_d noattr)) _x
                                     tdouble)
                                   (Ebinop Oadd
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                     (Tstruct _DoubleRMat noattr))
                                                   _m (tarray tdouble 9))
                                                 (tarray tdouble 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 0)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 tint) (tptr tdouble))
                                             tdouble) tdouble)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                               (Tstruct _EnuCoor_f noattr))
                                             _x tfloat) tfloat) tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                     (Tstruct _DoubleRMat noattr))
                                                   _m (tarray tdouble 9))
                                                 (tarray tdouble 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 tint) (tptr tdouble))
                                             tdouble) tdouble)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                               (Tstruct _EnuCoor_f noattr))
                                             _y tfloat) tfloat) tdouble)
                                       tdouble)
                                     (Ebinop Omul
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                   (Tstruct _DoubleRMat noattr))
                                                 _m (tarray tdouble 9))
                                               (tarray tdouble 9))
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 0)) tint)
                                               tint) (tptr tdouble)) tdouble)
                                         tdouble)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                             (Tstruct _EnuCoor_f noattr)) _z
                                           tfloat) tfloat) tdouble) tdouble)
                                   tdouble))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                         (Tstruct _EcefCoor_d noattr)) _y
                                       tdouble)
                                     (Ebinop Oadd
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                       (Tstruct _DoubleRMat noattr))
                                                     _m (tarray tdouble 9))
                                                   (tarray tdouble 9))
                                                 (Ebinop Oadd
                                                   (Ebinop Omul
                                                     (Eval (Vint (Int.repr 0)) tint)
                                                     (Eval (Vint (Int.repr 3)) tint)
                                                     tint)
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   tint) (tptr tdouble))
                                               tdouble) tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                                 (Tstruct _EnuCoor_f noattr))
                                               _x tfloat) tfloat) tdouble)
                                         (Ebinop Omul
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                       (Tstruct _DoubleRMat noattr))
                                                     _m (tarray tdouble 9))
                                                   (tarray tdouble 9))
                                                 (Ebinop Oadd
                                                   (Ebinop Omul
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Eval (Vint (Int.repr 3)) tint)
                                                     tint)
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   tint) (tptr tdouble))
                                               tdouble) tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                                 (Tstruct _EnuCoor_f noattr))
                                               _y tfloat) tfloat) tdouble)
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                     (Tstruct _DoubleRMat noattr))
                                                   _m (tarray tdouble 9))
                                                 (tarray tdouble 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tint) (tptr tdouble))
                                             tdouble) tdouble)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                               (Tstruct _EnuCoor_f noattr))
                                             _z tfloat) tfloat) tdouble)
                                       tdouble) tdouble))
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                         (Tstruct _EcefCoor_d noattr)) _z
                                       tdouble)
                                     (Ebinop Oadd
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                       (Tstruct _DoubleRMat noattr))
                                                     _m (tarray tdouble 9))
                                                   (tarray tdouble 9))
                                                 (Ebinop Oadd
                                                   (Ebinop Omul
                                                     (Eval (Vint (Int.repr 0)) tint)
                                                     (Eval (Vint (Int.repr 3)) tint)
                                                     tint)
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   tint) (tptr tdouble))
                                               tdouble) tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                                 (Tstruct _EnuCoor_f noattr))
                                               _x tfloat) tfloat) tdouble)
                                         (Ebinop Omul
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                       (Tstruct _DoubleRMat noattr))
                                                     _m (tarray tdouble 9))
                                                   (tarray tdouble 9))
                                                 (Ebinop Oadd
                                                   (Ebinop Omul
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Eval (Vint (Int.repr 3)) tint)
                                                     tint)
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   tint) (tptr tdouble))
                                               tdouble) tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                                 (Tstruct _EnuCoor_f noattr))
                                               _y tfloat) tfloat) tdouble)
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _ltp_of_ecef_d (Tstruct _DoubleRMat noattr))
                                                     (Tstruct _DoubleRMat noattr))
                                                   _m (tarray tdouble 9))
                                                 (tarray tdouble 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 tint) (tptr tdouble))
                                             tdouble) tdouble)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _enu_d (Tstruct _EnuCoor_f noattr))
                                               (Tstruct _EnuCoor_f noattr))
                                             _z tfloat) tfloat) tdouble)
                                       tdouble) tdouble))))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                                           (tptr (Tstruct _EcefCoor_f noattr)))
                                         (Tstruct _EcefCoor_f noattr))
                                       (Tstruct _EcefCoor_f noattr)) _x
                                     tfloat)
                                   (Ecast
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                           (Tstruct _EcefCoor_d noattr)) _x
                                         tdouble) tdouble) tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                                             (tptr (Tstruct _EcefCoor_f noattr)))
                                           (Tstruct _EcefCoor_f noattr))
                                         (Tstruct _EcefCoor_f noattr)) _y
                                       tfloat)
                                     (Ecast
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                             (Tstruct _EcefCoor_d noattr)) _y
                                           tdouble) tdouble) tfloat) tfloat))
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                                             (tptr (Tstruct _EcefCoor_f noattr)))
                                           (Tstruct _EcefCoor_f noattr))
                                         (Tstruct _EcefCoor_f noattr)) _z
                                       tfloat)
                                     (Ecast
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                             (Tstruct _EcefCoor_d noattr)) _z
                                           tdouble) tdouble) tfloat) tfloat)))))))))))))))))
|}.

Definition f_ecef_of_ned_vect_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_ned, (tptr (Tstruct _NedCoor_f noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_f noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu (Tstruct _EnuCoor_f noattr))
               (Tstruct _EnuCoor_f noattr)) _x tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
                     (tptr (Tstruct _NedCoor_f noattr)))
                   (Tstruct _NedCoor_f noattr)) (Tstruct _NedCoor_f noattr))
               _y tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_f noattr))
                 (Tstruct _EnuCoor_f noattr)) _y tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
                       (tptr (Tstruct _NedCoor_f noattr)))
                     (Tstruct _NedCoor_f noattr))
                   (Tstruct _NedCoor_f noattr)) _x tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_f noattr))
                 (Tstruct _EnuCoor_f noattr)) _z tfloat)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
                         (tptr (Tstruct _NedCoor_f noattr)))
                       (Tstruct _NedCoor_f noattr))
                     (Tstruct _NedCoor_f noattr)) _z tfloat) tfloat) tfloat)
             tfloat))))
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_vect_f (Tfunction
                                       ((tptr (Tstruct _EcefCoor_f noattr)) ::
                                        (tptr (Tstruct _LtpDef_f noattr)) ::
                                        (tptr (Tstruct _EnuCoor_f noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_f noattr)) ::
              (tptr (Tstruct _LtpDef_f noattr)) ::
              (tptr (Tstruct _EnuCoor_f noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
             (tptr (Tstruct _EcefCoor_f noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
               (tptr (Tstruct _LtpDef_f noattr)))
             (Econs
               (Eaddrof (Evar _enu (Tstruct _EnuCoor_f noattr))
                 (tptr (Tstruct _EnuCoor_f noattr))) Enil))) tvoid)))
|}.

Definition f_stateCalcSpeedEcef_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := nil;
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof (Evar _state (Tstruct _State noattr))
                         (Tstruct _State noattr)) _speed_status tushort)
                     tushort) (Eval (Vint (Int.repr 5)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof (Evar _state (Tstruct _State noattr))
                           (Tstruct _State noattr)) _speed_status tushort)
                       tushort) (Eval (Vint (Int.repr 0)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof (Evar _state (Tstruct _State noattr))
                       (Tstruct _State noattr)) _ecef_speed_f
                     (Tstruct _EcefCoor_f noattr))
                   (Tstruct _EcefCoor_f noattr)) _x tfloat)
               (Ebinop Odiv
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof (Evar _state (Tstruct _State noattr))
                             (Tstruct _State noattr)) _ned_speed_i
                           (Tstruct _NedCoor_i noattr))
                         (Tstruct _NedCoor_i noattr)) _x tint) tint) tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 19)) tint) tint) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof (Evar _state (Tstruct _State noattr))
                         (Tstruct _State noattr)) _ecef_speed_f
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _y tfloat)
                 (Ebinop Odiv
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof (Evar _state (Tstruct _State noattr))
                               (Tstruct _State noattr)) _ned_speed_i
                             (Tstruct _NedCoor_i noattr))
                           (Tstruct _NedCoor_i noattr)) _y tint) tint)
                     tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 19)) tint) tint) tfloat) tfloat))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof (Evar _state (Tstruct _State noattr))
                         (Tstruct _State noattr)) _ecef_speed_f
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _z tfloat)
                 (Ebinop Odiv
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof (Evar _state (Tstruct _State noattr))
                               (Tstruct _State noattr)) _ned_speed_i
                             (Tstruct _NedCoor_i noattr))
                           (Tstruct _NedCoor_i noattr)) _z tint) tint)
                     tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 19)) tint) tint) tfloat) tfloat))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof (Evar _state (Tstruct _State noattr))
                             (Tstruct _State noattr)) _speed_status tushort)
                         tushort) (Eval (Vint (Int.repr 6)) tint) tint)
                     (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _ecef_of_ned_vect_f (Tfunction
                                             ((tptr (Tstruct _EcefCoor_f noattr)) ::
                                              (tptr (Tstruct _LtpDef_f noattr)) ::
                                              (tptr (Tstruct _NedCoor_f noattr)) ::
                                              nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _EcefCoor_f noattr)) ::
                    (tptr (Tstruct _LtpDef_f noattr)) ::
                    (tptr (Tstruct _NedCoor_f noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof (Evar _state (Tstruct _State noattr))
                       (Tstruct _State noattr)) _ecef_speed_f
                     (Tstruct _EcefCoor_f noattr))
                   (tptr (Tstruct _EcefCoor_f noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof (Evar _state (Tstruct _State noattr))
                         (Tstruct _State noattr)) _ned_origin_f
                       (Tstruct _LtpDef_f noattr))
                     (tptr (Tstruct _LtpDef_f noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof (Evar _state (Tstruct _State noattr))
                           (Tstruct _State noattr)) _ned_speed_f
                         (Tstruct _NedCoor_f noattr))
                       (tptr (Tstruct _NedCoor_f noattr))) Enil))) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof (Evar _state (Tstruct _State noattr))
                               (Tstruct _State noattr)) _speed_status
                             tushort) tushort)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint)
          (Ssequence
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof (Evar _state (Tstruct _State noattr))
                             (Tstruct _State noattr)) _ned_speed_f
                           (Tstruct _NedCoor_f noattr))
                         (Tstruct _NedCoor_f noattr)) _x tfloat)
                     (Ebinop Odiv
                       (Ecast
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _state (Tstruct _State noattr))
                                   (Tstruct _State noattr)) _ned_speed_i
                                 (Tstruct _NedCoor_i noattr))
                               (Tstruct _NedCoor_i noattr)) _x tint) tint)
                         tfloat)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 19)) tint) tint) tfloat)
                     tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof (Evar _state (Tstruct _State noattr))
                               (Tstruct _State noattr)) _ned_speed_f
                             (Tstruct _NedCoor_f noattr))
                           (Tstruct _NedCoor_f noattr)) _y tfloat)
                       (Ebinop Odiv
                         (Ecast
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _state (Tstruct _State noattr))
                                     (Tstruct _State noattr)) _ned_speed_i
                                   (Tstruct _NedCoor_i noattr))
                                 (Tstruct _NedCoor_i noattr)) _y tint) tint)
                           tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 19)) tint) tint) tfloat)
                       tfloat))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof (Evar _state (Tstruct _State noattr))
                               (Tstruct _State noattr)) _ned_speed_f
                             (Tstruct _NedCoor_f noattr))
                           (Tstruct _NedCoor_f noattr)) _z tfloat)
                       (Ebinop Odiv
                         (Ecast
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _state (Tstruct _State noattr))
                                     (Tstruct _State noattr)) _ned_speed_i
                                   (Tstruct _NedCoor_i noattr))
                                 (Tstruct _NedCoor_i noattr)) _z tint) tint)
                           tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 19)) tint) tint) tfloat)
                       tfloat))))
            (Ssequence
              (Sdo (Eassignop Oor
                     (Efield
                       (Evalof (Evar _state (Tstruct _State noattr))
                         (Tstruct _State noattr)) _speed_status tushort)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 6)) tint) tint) tint tushort))
              (Sdo (Ecall
                     (Evalof
                       (Evar _ecef_of_ned_vect_f (Tfunction
                                                   ((tptr (Tstruct _EcefCoor_f noattr)) ::
                                                    (tptr (Tstruct _LtpDef_f noattr)) ::
                                                    (tptr (Tstruct _NedCoor_f noattr)) ::
                                                    nil) tvoid cc_default))
                       (Tfunction
                         ((tptr (Tstruct _EcefCoor_f noattr)) ::
                          (tptr (Tstruct _LtpDef_f noattr)) ::
                          (tptr (Tstruct _NedCoor_f noattr)) :: nil) tvoid
                         cc_default))
                     (Econs
                       (Eaddrof
                         (Efield
                           (Evalof (Evar _state (Tstruct _State noattr))
                             (Tstruct _State noattr)) _ecef_speed_f
                           (Tstruct _EcefCoor_f noattr))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof (Evar _state (Tstruct _State noattr))
                               (Tstruct _State noattr)) _ned_origin_f
                             (Tstruct _LtpDef_f noattr))
                           (tptr (Tstruct _LtpDef_f noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof (Evar _state (Tstruct _State noattr))
                                 (Tstruct _State noattr)) _ned_speed_f
                               (Tstruct _NedCoor_f noattr))
                             (tptr (Tstruct _NedCoor_f noattr))) Enil)))
                     tvoid))))
          (Sreturn None))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof (Evar _state (Tstruct _State noattr))
               (Tstruct _State noattr)) _speed_status tushort)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 5)) tint) tint) tint tushort))))
|}.

Definition f_stateGetSpeedEcef_f := {|
  fn_return := (tptr (Tstruct _EcefCoor_f noattr));
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
                       tushort) (Eval (Vint (Int.repr 5)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _stateCalcSpeedEcef_f (Tfunction nil tvoid cc_default))
             (Tfunction nil tvoid cc_default)) Enil tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof (Evar _state (Tstruct _State noattr))
                       (Tstruct _State noattr)) _ecef_speed_f
                     (Tstruct _EcefCoor_f noattr))
                   (tptr (Tstruct _EcefCoor_f noattr))))))
|}.

Definition composites : list composite_definition :=
(Composite _DoubleRMat Struct
   (Member_plain _m (tarray tdouble 9) :: nil)
   noattr ::
 Composite _EcefCoor_d Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _EcefCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _EcefCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _EnuCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _FloatRMat Struct
   (Member_plain _m (tarray tfloat 9) :: nil)
   noattr ::
 Composite _LlaCoor_f Struct
   (Member_plain _lat tfloat :: Member_plain _lon tfloat ::
    Member_plain _alt tfloat :: nil)
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
 Composite _NedCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _EnuCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _FloatRates Struct
   (Member_plain _p tfloat :: Member_plain _q tfloat ::
    Member_plain _r tfloat :: nil)
   noattr ::
 Composite _FloatVect2 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat :: nil)
   noattr ::
 Composite _FloatVect3 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _Int32Rates Struct
   (Member_plain _p tint :: Member_plain _q tint :: Member_plain _r tint ::
    nil)
   noattr ::
 Composite _Int32Vect2 Struct
   (Member_plain _x tint :: Member_plain _y tint :: nil)
   noattr ::
 Composite _Int32Vect3 Struct
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
 Composite _FloatEulers Struct
   (Member_plain _phi tfloat :: Member_plain _theta tfloat ::
    Member_plain _psi tfloat :: nil)
   noattr ::
 Composite _FloatQuat Struct
   (Member_plain _qi tfloat :: Member_plain _qx tfloat ::
    Member_plain _qy tfloat :: Member_plain _qz tfloat :: nil)
   noattr ::
 Composite _Int32Eulers Struct
   (Member_plain _phi tint :: Member_plain _theta tint ::
    Member_plain _psi tint :: nil)
   noattr ::
 Composite _Int32Quat Struct
   (Member_plain _qi tint :: Member_plain _qx tint ::
    Member_plain _qy tint :: Member_plain _qz tint :: nil)
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
 Composite _UtmCoor_f Struct
   (Member_plain _north tfloat :: Member_plain _east tfloat ::
    Member_plain _alt tfloat :: Member_plain _zone tuchar :: nil)
   noattr ::
 Composite __212 Union
   (Member_plain _vect3 (Tstruct _Int32Vect3 noattr) ::
    Member_plain _vect2 (Tstruct _Int32Vect2 noattr) :: nil)
   noattr ::
 Composite __213 Union
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
    Member_plain _windspeed_i (Tunion __212 noattr) ::
    Member_plain _airspeed_i tint ::
    Member_plain _windspeed_f (Tunion __213 noattr) ::
    Member_plain _airspeed_f tfloat ::
    Member_plain _angle_of_attack_f tfloat ::
    Member_plain _sideslip_f tfloat :: nil)
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
 (_state, Gvar v_state) ::
 (_ecef_of_enu_vect_f, Gfun(Internal f_ecef_of_enu_vect_f)) ::
 (_ecef_of_ned_vect_f, Gfun(Internal f_ecef_of_ned_vect_f)) ::
 (_stateCalcSpeedEcef_f, Gfun(Internal f_stateCalcSpeedEcef_f)) ::
 (_stateGetSpeedEcef_f, Gfun(Internal f_stateGetSpeedEcef_f)) :: nil).

Definition public_idents : list ident :=
(_stateGetSpeedEcef_f :: _stateCalcSpeedEcef_f :: _ecef_of_ned_vect_f ::
 _ecef_of_enu_vect_f :: _state :: ___builtin_debug ::
 ___builtin_write32_reversed :: ___builtin_write16_reversed ::
 ___builtin_read32_reversed :: ___builtin_read16_reversed ::
 ___builtin_fnmsub :: ___builtin_fnmadd :: ___builtin_fmsub ::
 ___builtin_fmadd :: ___builtin_fmin :: ___builtin_fmax ::
 ___builtin_expect :: ___builtin_unreachable :: ___builtin_va_end ::
 ___builtin_va_copy :: ___builtin_va_arg :: ___builtin_va_start ::
 ___builtin_membar :: ___builtin_annot_intval :: ___builtin_annot ::
 ___builtin_sel :: ___builtin_memcpy_aligned :: ___builtin_sqrt ::
 ___builtin_fsqrt :: ___builtin_fabsf :: ___builtin_fabs ::
 ___builtin_ctzll :: ___builtin_ctzl :: ___builtin_ctz :: ___builtin_clzll ::
 ___builtin_clzl :: ___builtin_clz :: ___builtin_bswap16 ::
 ___builtin_bswap32 :: ___builtin_bswap :: ___builtin_bswap64 ::
 ___builtin_ais_annot :: ___compcert_i64_umulh :: ___compcert_i64_smulh ::
 ___compcert_i64_sar :: ___compcert_i64_shr :: ___compcert_i64_shl ::
 ___compcert_i64_umod :: ___compcert_i64_smod :: ___compcert_i64_udiv ::
 ___compcert_i64_sdiv :: ___compcert_i64_utof :: ___compcert_i64_stof ::
 ___compcert_i64_utod :: ___compcert_i64_stod :: ___compcert_i64_dtou ::
 ___compcert_i64_dtos :: ___compcert_va_composite ::
 ___compcert_va_float64 :: ___compcert_va_int64 :: ___compcert_va_int32 ::
 nil).

Definition prog : Csyntax.program := 
  mkprogram composites global_definitions public_idents _main Logic.I.


