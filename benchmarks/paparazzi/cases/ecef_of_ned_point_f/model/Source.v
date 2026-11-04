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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/float_geodetic_more/model/preprocessed.i".
End Info.

Definition _DoubleRMat : ident := $"DoubleRMat".
Definition _E2 : ident := $"E2".
Definition _EcefCoor_d : ident := $"EcefCoor_d".
Definition _EcefCoor_f : ident := $"EcefCoor_f".
Definition _EnuCoor_f : ident := $"EnuCoor_f".
Definition _F : ident := $"F".
Definition _FloatRMat : ident := $"FloatRMat".
Definition _G : ident := $"G".
Definition _LlaCoor_f : ident := $"LlaCoor_f".
Definition _LtpDef_f : ident := $"LtpDef_f".
Definition _NedCoor_f : ident := $"NedCoor_f".
Definition _P : ident := $"P".
Definition _Q : ident := $"Q".
Definition _U : ident := $"U".
Definition _UtmCoor_f : ident := $"UtmCoor_f".
Definition _V : ident := $"V".
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
Definition __z : ident := $"_z".
Definition _a : ident := $"a".
Definition _a__1 : ident := $"a__1".
Definition _a_chi : ident := $"a_chi".
Definition _alt : ident := $"alt".
Definition _asinf : ident := $"asinf".
Definition _atan2f : ident := $"atan2f".
Definition _atanf : ident := $"atanf".
Definition _b : ident := $"b".
Definition _b2 : ident := $"b2".
Definition _c : ident := $"c".
Definition _chi : ident := $"chi".
Definition _complex : ident := $"complex".
Definition _cos_lat : ident := $"cos_lat".
Definition _cos_lon : ident := $"cos_lon".
Definition _cos_z_im : ident := $"cos_z_im".
Definition _cosf : ident := $"cosf".
Definition _coshf : ident := $"coshf".
Definition _def : ident := $"def".
Definition _delta : ident := $"delta".
Definition _dl : ident := $"dl".
Definition _e : ident := $"e".
Definition _e2 : ident := $"e2".
Definition _east : ident := $"east".
Definition _ecef : ident := $"ecef".
Definition _ecef_d : ident := $"ecef_d".
Definition _ecef_of_enu_point_f : ident := $"ecef_of_enu_point_f".
Definition _ecef_of_enu_vect_f : ident := $"ecef_of_enu_vect_f".
Definition _ecef_of_lla_f : ident := $"ecef_of_lla_f".
Definition _ecef_of_ned_point_f : ident := $"ecef_of_ned_point_f".
Definition _ecef_of_ned_vect_f : ident := $"ecef_of_ned_vect_f".
Definition _enu : ident := $"enu".
Definition _enu_d : ident := $"enu_d".
Definition _enu_of_ecef_point_f : ident := $"enu_of_ecef_point_f".
Definition _enu_of_ecef_vect_f : ident := $"enu_of_ecef_vect_f".
Definition _enu_of_lla_point_f : ident := $"enu_of_lla_point_f".
Definition _ep2 : ident := $"ep2".
Definition _epsilon : ident := $"epsilon".
Definition _exp : ident := $"exp".
Definition _exp_l : ident := $"exp_l".
Definition _expf : ident := $"expf".
Definition _f : ident := $"f".
Definition _f__1 : ident := $"f__1".
Definition _fabsf : ident := $"fabsf".
Definition _five_keep_ecef_of_enu_vect_f : ident := $"five_keep_ecef_of_enu_vect_f".
Definition _five_keep_ecef_of_ned_point_f : ident := $"five_keep_ecef_of_ned_point_f".
Definition _five_keep_ecef_of_ned_vect_f : ident := $"five_keep_ecef_of_ned_vect_f".
Definition _five_keep_enu_of_ecef_vect_f : ident := $"five_keep_enu_of_ecef_vect_f".
Definition _five_keep_enu_of_lla_point_f : ident := $"five_keep_enu_of_lla_point_f".
Definition _five_keep_inverse_isometric_latitude_f : ident := $"five_keep_inverse_isometric_latitude_f".
Definition _five_keep_isometric_latitude_f : ident := $"five_keep_isometric_latitude_f".
Definition _five_keep_isometric_latitude_fast_f : ident := $"five_keep_isometric_latitude_fast_f".
Definition _five_keep_lla_of_utm_f : ident := $"five_keep_lla_of_utm_f".
Definition _five_keep_ltp_def_from_ecef_f : ident := $"five_keep_ltp_def_from_ecef_f".
Definition _five_keep_ltp_def_from_lla_f : ident := $"five_keep_ltp_def_from_lla_f".
Definition _five_keep_ned_of_ecef_point_f : ident := $"five_keep_ned_of_ecef_point_f".
Definition _five_keep_ned_of_lla_point_f : ident := $"five_keep_ned_of_lla_point_f".
Definition _five_keep_utm_of_lla_f : ident := $"five_keep_utm_of_lla_f".
Definition _floor : ident := $"floor".
Definition _hmsl : ident := $"hmsl".
Definition _il : ident := $"il".
Definition _im : ident := $"im".
Definition _img : ident := $"img".
Definition _in : ident := $"in".
Definition _inverse_isometric_latitude_f : ident := $"inverse_isometric_latitude_f".
Definition _isometric_latitude_f : ident := $"isometric_latitude_f".
Definition _isometric_latitude_fast_f : ident := $"isometric_latitude_fast_f".
Definition _k : ident := $"k".
Definition _lambda_ : ident := $"lambda_".
Definition _lambda_c : ident := $"lambda_c".
Definition _lat : ident := $"lat".
Definition _ll : ident := $"ll".
Definition _ll_ : ident := $"ll_".
Definition _lla : ident := $"lla".
Definition _lla_of_ecef_f : ident := $"lla_of_ecef_f".
Definition _lla_of_utm_f : ident := $"lla_of_utm_f".
Definition _logf : ident := $"logf".
Definition _lon : ident := $"lon".
Definition _ltp_def_from_ecef_f : ident := $"ltp_def_from_ecef_f".
Definition _ltp_def_from_lla_f : ident := $"ltp_def_from_lla_f".
Definition _ltp_of_ecef : ident := $"ltp_of_ecef".
Definition _ltp_of_ecef_d : ident := $"ltp_of_ecef_d".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _max_iter : ident := $"max_iter".
Definition _ned : ident := $"ned".
Definition _ned_of_ecef_point_f : ident := $"ned_of_ecef_point_f".
Definition _ned_of_lla_point_f : ident := $"ned_of_lla_point_f".
Definition _north : ident := $"north".
Definition _out : ident := $"out".
Definition _phi : ident := $"phi".
Definition _phi0 : ident := $"phi0".
Definition _phi_ : ident := $"phi_".
Definition _powf : ident := $"powf".
Definition _r : ident := $"r".
Definition _r2 : ident := $"r2".
Definition _re : ident := $"re".
Definition _real : ident := $"real".
Definition _ro : ident := $"ro".
Definition _s : ident := $"s".
Definition _s1 : ident := $"s1".
Definition _scale : ident := $"scale".
Definition _serie_coeff_proj_mercator : ident := $"serie_coeff_proj_mercator".
Definition _serie_coeff_proj_mercator_inverse : ident := $"serie_coeff_proj_mercator_inverse".
Definition _sin_lat : ident := $"sin_lat".
Definition _sin_lon : ident := $"sin_lon".
Definition _sin_phi : ident := $"sin_phi".
Definition _sin_z_im : ident := $"sin_z_im".
Definition _sinf : ident := $"sinf".
Definition _sinhf : ident := $"sinhf".
Definition _sqrtf : ident := $"sqrtf".
Definition _tanf : ident := $"tanf".
Definition _tmp : ident := $"tmp".
Definition _tmp__1 : ident := $"tmp__1".
Definition _utm : ident := $"utm".
Definition _utm_of_lla_f : ident := $"utm_of_lla_f".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".
Definition _z2 : ident := $"z2".
Definition _z_ : ident := $"z_".
Definition _zo : ident := $"zo".
Definition _zone : ident := $"zone".

Definition f_ltp_def_from_ecef_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_f noattr))) :: nil);
  fn_vars := ((_sin_lat, tfloat) :: (_cos_lat, tfloat) ::
              (_sin_lon, tfloat) :: (_cos_lon, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                       (tptr (Tstruct _LtpDef_f noattr)))
                     (Tstruct _LtpDef_f noattr)) (Tstruct _LtpDef_f noattr))
                 _ecef (Tstruct _EcefCoor_f noattr))
               (Tstruct _EcefCoor_f noattr)) _x tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                     (tptr (Tstruct _EcefCoor_f noattr)))
                   (Tstruct _EcefCoor_f noattr))
                 (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                         (tptr (Tstruct _LtpDef_f noattr)))
                       (Tstruct _LtpDef_f noattr))
                     (Tstruct _LtpDef_f noattr)) _ecef
                   (Tstruct _EcefCoor_f noattr))
                 (Tstruct _EcefCoor_f noattr)) _y tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                       (tptr (Tstruct _EcefCoor_f noattr)))
                     (Tstruct _EcefCoor_f noattr))
                   (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                         (tptr (Tstruct _LtpDef_f noattr)))
                       (Tstruct _LtpDef_f noattr))
                     (Tstruct _LtpDef_f noattr)) _ecef
                   (Tstruct _EcefCoor_f noattr))
                 (Tstruct _EcefCoor_f noattr)) _z tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                       (tptr (Tstruct _EcefCoor_f noattr)))
                     (Tstruct _EcefCoor_f noattr))
                   (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat) tfloat))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _lla_of_ecef_f (Tfunction
                                    ((tptr (Tstruct _LlaCoor_f noattr)) ::
                                     (tptr (Tstruct _EcefCoor_f noattr)) ::
                                     nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _LlaCoor_f noattr)) ::
                (tptr (Tstruct _EcefCoor_f noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                       (tptr (Tstruct _LtpDef_f noattr)))
                     (Tstruct _LtpDef_f noattr)) (Tstruct _LtpDef_f noattr))
                 _lla (Tstruct _LlaCoor_f noattr))
               (tptr (Tstruct _LlaCoor_f noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                         (tptr (Tstruct _LtpDef_f noattr)))
                       (Tstruct _LtpDef_f noattr))
                     (Tstruct _LtpDef_f noattr)) _ecef
                   (Tstruct _EcefCoor_f noattr))
                 (tptr (Tstruct _EcefCoor_f noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign (Evar _sin_lat tfloat)
             (Ecall
               (Evalof
                 (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Tfunction (tfloat :: nil) tfloat cc_default))
               (Econs
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
                           (Tstruct _LtpDef_f noattr)) _lla
                         (Tstruct _LlaCoor_f noattr))
                       (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat)
                 Enil) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _cos_lat tfloat)
               (Ecall
                 (Evalof
                   (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
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
                             (Tstruct _LtpDef_f noattr)) _lla
                           (Tstruct _LlaCoor_f noattr))
                         (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat)
                   Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _sin_lon tfloat)
                 (Ecall
                   (Evalof
                     (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
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
                               (Tstruct _LtpDef_f noattr)) _lla
                             (Tstruct _LlaCoor_f noattr))
                           (Tstruct _LlaCoor_f noattr)) _lon tfloat) tfloat)
                     Enil) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _cos_lon tfloat)
                   (Ecall
                     (Evalof
                       (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs
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
                                 (Tstruct _LtpDef_f noattr)) _lla
                               (Tstruct _LlaCoor_f noattr))
                             (Tstruct _LlaCoor_f noattr)) _lon tfloat)
                         tfloat) Enil) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
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
                         (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                       tfloat)
                     (Eunop Oneg (Evalof (Evar _sin_lon tfloat) tfloat)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
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
                           (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                         tfloat) (Evalof (Evar _cos_lon tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
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
                             (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                           tfloat)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
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
                               (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                             tfloat)
                           (Ebinop Omul
                             (Eunop Oneg
                               (Evalof (Evar _sin_lat tfloat) tfloat) tfloat)
                             (Evalof (Evar _cos_lon tfloat) tfloat) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
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
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Omul
                               (Eunop Oneg
                                 (Evalof (Evar _sin_lat tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _sin_lon tfloat) tfloat) tfloat)
                             tfloat))
                      (Ssequence
                        (Sdo (Eassign
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
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tfloat)) tfloat)
                               (Evalof (Evar _cos_lat tfloat) tfloat) tfloat))
                        (Ssequence
                          (Sdo (Eassign
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
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Omul
                                   (Evalof (Evar _cos_lat tfloat) tfloat)
                                   (Evalof (Evar _cos_lon tfloat) tfloat)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
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
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Ebinop Omul
                                     (Evalof (Evar _cos_lat tfloat) tfloat)
                                     (Evalof (Evar _sin_lon tfloat) tfloat)
                                     tfloat) tfloat))
                            (Sdo (Eassign
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
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 8)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Evalof (Evar _sin_lat tfloat) tfloat)
                                   tfloat))))))))))))))))
|}.

Definition f_ltp_def_from_lla_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_f noattr))) :: nil);
  fn_vars := ((_sin_lat, tfloat) :: (_cos_lat, tfloat) ::
              (_sin_lon, tfloat) :: (_cos_lon, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                       (tptr (Tstruct _LtpDef_f noattr)))
                     (Tstruct _LtpDef_f noattr)) (Tstruct _LtpDef_f noattr))
                 _lla (Tstruct _LlaCoor_f noattr))
               (Tstruct _LlaCoor_f noattr)) _lat tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                     (tptr (Tstruct _LlaCoor_f noattr)))
                   (Tstruct _LlaCoor_f noattr)) (Tstruct _LlaCoor_f noattr))
               _lat tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                         (tptr (Tstruct _LtpDef_f noattr)))
                       (Tstruct _LtpDef_f noattr))
                     (Tstruct _LtpDef_f noattr)) _lla
                   (Tstruct _LlaCoor_f noattr)) (Tstruct _LlaCoor_f noattr))
               _lon tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                       (tptr (Tstruct _LlaCoor_f noattr)))
                     (Tstruct _LlaCoor_f noattr))
                   (Tstruct _LlaCoor_f noattr)) _lon tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                         (tptr (Tstruct _LtpDef_f noattr)))
                       (Tstruct _LtpDef_f noattr))
                     (Tstruct _LtpDef_f noattr)) _lla
                   (Tstruct _LlaCoor_f noattr)) (Tstruct _LlaCoor_f noattr))
               _alt tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                       (tptr (Tstruct _LlaCoor_f noattr)))
                     (Tstruct _LlaCoor_f noattr))
                   (Tstruct _LlaCoor_f noattr)) _alt tfloat) tfloat) tfloat))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _ecef_of_lla_f (Tfunction
                                    ((tptr (Tstruct _EcefCoor_f noattr)) ::
                                     (tptr (Tstruct _LlaCoor_f noattr)) ::
                                     nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _EcefCoor_f noattr)) ::
                (tptr (Tstruct _LlaCoor_f noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                       (tptr (Tstruct _LtpDef_f noattr)))
                     (Tstruct _LtpDef_f noattr)) (Tstruct _LtpDef_f noattr))
                 _ecef (Tstruct _EcefCoor_f noattr))
               (tptr (Tstruct _EcefCoor_f noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
                         (tptr (Tstruct _LtpDef_f noattr)))
                       (Tstruct _LtpDef_f noattr))
                     (Tstruct _LtpDef_f noattr)) _lla
                   (Tstruct _LlaCoor_f noattr))
                 (tptr (Tstruct _LlaCoor_f noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign (Evar _sin_lat tfloat)
             (Ecall
               (Evalof
                 (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Tfunction (tfloat :: nil) tfloat cc_default))
               (Econs
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
                           (Tstruct _LtpDef_f noattr)) _lla
                         (Tstruct _LlaCoor_f noattr))
                       (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat)
                 Enil) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _cos_lat tfloat)
               (Ecall
                 (Evalof
                   (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
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
                             (Tstruct _LtpDef_f noattr)) _lla
                           (Tstruct _LlaCoor_f noattr))
                         (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat)
                   Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _sin_lon tfloat)
                 (Ecall
                   (Evalof
                     (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
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
                               (Tstruct _LtpDef_f noattr)) _lla
                             (Tstruct _LlaCoor_f noattr))
                           (Tstruct _LlaCoor_f noattr)) _lon tfloat) tfloat)
                     Enil) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _cos_lon tfloat)
                   (Ecall
                     (Evalof
                       (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs
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
                                 (Tstruct _LtpDef_f noattr)) _lla
                               (Tstruct _LlaCoor_f noattr))
                             (Tstruct _LlaCoor_f noattr)) _lon tfloat)
                         tfloat) Enil) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
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
                         (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                       tfloat)
                     (Eunop Oneg (Evalof (Evar _sin_lon tfloat) tfloat)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
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
                           (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                         tfloat) (Evalof (Evar _cos_lon tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
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
                             (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                           tfloat)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
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
                               (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                             tfloat)
                           (Ebinop Omul
                             (Eunop Oneg
                               (Evalof (Evar _sin_lat tfloat) tfloat) tfloat)
                             (Evalof (Evar _cos_lon tfloat) tfloat) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
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
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Omul
                               (Eunop Oneg
                                 (Evalof (Evar _sin_lat tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _sin_lon tfloat) tfloat) tfloat)
                             tfloat))
                      (Ssequence
                        (Sdo (Eassign
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
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tfloat)) tfloat)
                               (Evalof (Evar _cos_lat tfloat) tfloat) tfloat))
                        (Ssequence
                          (Sdo (Eassign
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
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Omul
                                   (Evalof (Evar _cos_lat tfloat) tfloat)
                                   (Evalof (Evar _cos_lon tfloat) tfloat)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
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
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Ebinop Omul
                                     (Evalof (Evar _cos_lat tfloat) tfloat)
                                     (Evalof (Evar _sin_lon tfloat) tfloat)
                                     tfloat) tfloat))
                            (Sdo (Eassign
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
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 8)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Evalof (Evar _sin_lat tfloat) tfloat)
                                   tfloat))))))))))))))))
|}.

Definition f_enu_of_ecef_point_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_f noattr))) :: nil);
  fn_vars := ((_delta, (Tstruct _EcefCoor_f noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
               (Tstruct _EcefCoor_f noattr)) _x tfloat)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                       (tptr (Tstruct _EcefCoor_f noattr)))
                     (Tstruct _EcefCoor_f noattr))
                   (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat)
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
                       (Tstruct _LtpDef_f noattr)) _ecef
                     (Tstruct _EcefCoor_f noattr))
                   (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                 (Tstruct _EcefCoor_f noattr)) _y tfloat)
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat)
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
                         (Tstruct _LtpDef_f noattr)) _ecef
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat) tfloat)
             tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                 (Tstruct _EcefCoor_f noattr)) _z tfloat)
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat)
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
                         (Tstruct _LtpDef_f noattr)) _ecef
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat) tfloat)
             tfloat))))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                   (tptr (Tstruct _EnuCoor_f noattr)))
                 (Tstruct _EnuCoor_f noattr)) (Tstruct _EnuCoor_f noattr)) _x
             tfloat)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
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
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                   tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                     (tptr (Tstruct _EnuCoor_f noattr)))
                   (Tstruct _EnuCoor_f noattr)) (Tstruct _EnuCoor_f noattr))
               _y tfloat)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
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
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                         (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat)
                   tfloat)
                 (Ebinop Omul
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
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                         (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat)
                 tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                     (tptr (Tstruct _EnuCoor_f noattr)))
                   (Tstruct _EnuCoor_f noattr)) (Tstruct _EnuCoor_f noattr))
               _z tfloat)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
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
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                         (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat)
                   tfloat)
                 (Ebinop Omul
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
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                         (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat)
                 tfloat) tfloat) tfloat)))))
|}.

Definition f_ned_of_ecef_point_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_f noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_f noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_f (Tfunction
                                        ((tptr (Tstruct _EnuCoor_f noattr)) ::
                                         (tptr (Tstruct _LtpDef_f noattr)) ::
                                         (tptr (Tstruct _EcefCoor_f noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_f noattr)) ::
              (tptr (Tstruct _LtpDef_f noattr)) ::
              (tptr (Tstruct _EcefCoor_f noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu (Tstruct _EnuCoor_f noattr))
             (tptr (Tstruct _EnuCoor_f noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
               (tptr (Tstruct _LtpDef_f noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                 (tptr (Tstruct _EcefCoor_f noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
                   (tptr (Tstruct _NedCoor_f noattr)))
                 (Tstruct _NedCoor_f noattr)) (Tstruct _NedCoor_f noattr)) _x
             tfloat)
           (Evalof
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_f noattr))
                 (Tstruct _EnuCoor_f noattr)) _y tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
                     (tptr (Tstruct _NedCoor_f noattr)))
                   (Tstruct _NedCoor_f noattr)) (Tstruct _NedCoor_f noattr))
               _y tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _enu (Tstruct _EnuCoor_f noattr))
                   (Tstruct _EnuCoor_f noattr)) _x tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
                     (tptr (Tstruct _NedCoor_f noattr)))
                   (Tstruct _NedCoor_f noattr)) (Tstruct _NedCoor_f noattr))
               _z tfloat)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof (Evar _enu (Tstruct _EnuCoor_f noattr))
                     (Tstruct _EnuCoor_f noattr)) _z tfloat) tfloat) tfloat)
             tfloat)))))
|}.

Definition f_enu_of_ecef_vect_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_f noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                 (tptr (Tstruct _EnuCoor_f noattr)))
               (Tstruct _EnuCoor_f noattr)) (Tstruct _EnuCoor_f noattr)) _x
           tfloat)
         (Ebinop Oadd
           (Ebinop Oadd
             (Ebinop Omul
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
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                   tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat) tfloat)
             (Ebinop Omul
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
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                   tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat) tfloat)
             tfloat)
           (Ebinop Omul
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
                     (tarray tfloat 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                 tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                       (tptr (Tstruct _EcefCoor_f noattr)))
                     (Tstruct _EcefCoor_f noattr))
                   (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                   (tptr (Tstruct _EnuCoor_f noattr)))
                 (Tstruct _EnuCoor_f noattr)) (Tstruct _EnuCoor_f noattr)) _y
             tfloat)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                           (tptr (Tstruct _EcefCoor_f noattr)))
                         (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                           (tptr (Tstruct _EcefCoor_f noattr)))
                         (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
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
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                   tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
                   (tptr (Tstruct _EnuCoor_f noattr)))
                 (Tstruct _EnuCoor_f noattr)) (Tstruct _EnuCoor_f noattr)) _z
             tfloat)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                           (tptr (Tstruct _EcefCoor_f noattr)))
                         (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                     tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                           (tptr (Tstruct _EcefCoor_f noattr)))
                         (Tstruct _EcefCoor_f noattr))
                       (Tstruct _EcefCoor_f noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
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
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                   tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_f noattr)))
                         (tptr (Tstruct _EcefCoor_f noattr)))
                       (Tstruct _EcefCoor_f noattr))
                     (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))))
|}.

Definition f_enu_of_lla_point_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_f noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_f noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_f (Tfunction
                                  ((tptr (Tstruct _EcefCoor_f noattr)) ::
                                   (tptr (Tstruct _LlaCoor_f noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_f noattr)) ::
              (tptr (Tstruct _LlaCoor_f noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_f noattr))
             (tptr (Tstruct _EcefCoor_f noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
               (tptr (Tstruct _LlaCoor_f noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_f (Tfunction
                                        ((tptr (Tstruct _EnuCoor_f noattr)) ::
                                         (tptr (Tstruct _LtpDef_f noattr)) ::
                                         (tptr (Tstruct _EcefCoor_f noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_f noattr)) ::
              (tptr (Tstruct _LtpDef_f noattr)) ::
              (tptr (Tstruct _EcefCoor_f noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_f noattr)))
             (tptr (Tstruct _EnuCoor_f noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
               (tptr (Tstruct _LtpDef_f noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_f noattr))
                 (tptr (Tstruct _EcefCoor_f noattr))) Enil))) tvoid)))
|}.

Definition f_ned_of_lla_point_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_f noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_f noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_f noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_f noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_f (Tfunction
                                  ((tptr (Tstruct _EcefCoor_f noattr)) ::
                                   (tptr (Tstruct _LlaCoor_f noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_f noattr)) ::
              (tptr (Tstruct _LlaCoor_f noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_f noattr))
             (tptr (Tstruct _EcefCoor_f noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
               (tptr (Tstruct _LlaCoor_f noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _ned_of_ecef_point_f (Tfunction
                                        ((tptr (Tstruct _NedCoor_f noattr)) ::
                                         (tptr (Tstruct _LtpDef_f noattr)) ::
                                         (tptr (Tstruct _EcefCoor_f noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _NedCoor_f noattr)) ::
              (tptr (Tstruct _LtpDef_f noattr)) ::
              (tptr (Tstruct _EcefCoor_f noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ned (tptr (Tstruct _NedCoor_f noattr)))
             (tptr (Tstruct _NedCoor_f noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_f noattr)))
               (tptr (Tstruct _LtpDef_f noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_f noattr))
                 (tptr (Tstruct _EcefCoor_f noattr))) Enil))) tvoid)))
|}.

Definition f_ecef_of_enu_point_f := {|
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
                                   (Ebinop Oadd
                                     (Ecast
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                             (Tstruct _EcefCoor_d noattr)) _x
                                           tdouble) tdouble) tfloat)
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
                                             _ecef
                                             (Tstruct _EcefCoor_f noattr))
                                           (Tstruct _EcefCoor_f noattr)) _x
                                         tfloat) tfloat) tfloat) tfloat))
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
                                     (Ebinop Oadd
                                       (Ecast
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                               (Tstruct _EcefCoor_d noattr))
                                             _y tdouble) tdouble) tfloat)
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
                                               _ecef
                                               (Tstruct _EcefCoor_f noattr))
                                             (Tstruct _EcefCoor_f noattr)) _y
                                           tfloat) tfloat) tfloat) tfloat))
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
                                     (Ebinop Oadd
                                       (Ecast
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _ecef_d (Tstruct _EcefCoor_d noattr))
                                               (Tstruct _EcefCoor_d noattr))
                                             _z tdouble) tdouble) tfloat)
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
                                               _ecef
                                               (Tstruct _EcefCoor_f noattr))
                                             (Tstruct _EcefCoor_f noattr)) _z
                                           tfloat) tfloat) tfloat) tfloat)))))))))))))))))
|}.

Definition f_ecef_of_ned_point_f := {|
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
           (Evar _ecef_of_enu_point_f (Tfunction
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

Definition v_a := {|
  gvar_info := tfloat;
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 1254270258)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_f := {|
  gvar_info := tfloat;
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 995867348)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_lla_of_ecef_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_out, (tptr (Tstruct _LlaCoor_f noattr))) ::
                (_in, (tptr (Tstruct _EcefCoor_f noattr))) :: nil);
  fn_vars := ((_b, tfloat) :: (_b2, tfloat) :: (_e2, tfloat) ::
              (_ep2, tfloat) :: (_E2, tfloat) :: (_z2, tfloat) ::
              (_r2, tfloat) :: (_r, tfloat) :: (_F, tfloat) ::
              (_G, tfloat) :: (_c, tfloat) :: (_s, tfloat) ::
              (_s1, tfloat) :: (_P, tfloat) :: (_Q, tfloat) ::
              (_ro, tfloat) :: (_tmp, tfloat) :: (_U, tfloat) ::
              (_V, tfloat) :: (_zo, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _b tfloat)
         (Ebinop Omul (Evalof (Evar _a tfloat) tfloat)
           (Ebinop Osub
             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
             (Evalof (Evar _f tfloat) tfloat) tdouble) tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _b2 tfloat)
           (Ebinop Omul (Evalof (Evar _b tfloat) tfloat)
             (Evalof (Evar _b tfloat) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _e2 tfloat)
             (Ebinop Osub
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                 (Evalof (Evar _f tfloat) tfloat) tdouble)
               (Ebinop Omul (Evalof (Evar _f tfloat) tfloat)
                 (Evalof (Evar _f tfloat) tfloat) tfloat) tdouble) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _ep2 tfloat)
               (Ebinop Odiv
                 (Ebinop Omul (Evalof (Evar _f tfloat) tfloat)
                   (Ebinop Osub
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     (Evalof (Evar _f tfloat) tfloat) tdouble) tdouble)
                 (Ebinop Omul
                   (Ebinop Osub
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Evalof (Evar _f tfloat) tfloat) tdouble)
                   (Ebinop Osub
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Evalof (Evar _f tfloat) tfloat) tdouble) tdouble)
                 tdouble) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _E2 tfloat)
                 (Ebinop Osub
                   (Ebinop Omul (Evalof (Evar _a tfloat) tfloat)
                     (Evalof (Evar _a tfloat) tfloat) tfloat)
                   (Evalof (Evar _b2 tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _z2 tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                               (tptr (Tstruct _EcefCoor_f noattr)))
                             (Tstruct _EcefCoor_f noattr))
                           (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                               (tptr (Tstruct _EcefCoor_f noattr)))
                             (Tstruct _EcefCoor_f noattr))
                           (Tstruct _EcefCoor_f noattr)) _z tfloat) tfloat)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _r2 tfloat)
                     (Ebinop Oadd
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                   (tptr (Tstruct _EcefCoor_f noattr)))
                                 (Tstruct _EcefCoor_f noattr))
                               (Tstruct _EcefCoor_f noattr)) _x tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                   (tptr (Tstruct _EcefCoor_f noattr)))
                                 (Tstruct _EcefCoor_f noattr))
                               (Tstruct _EcefCoor_f noattr)) _x tfloat)
                           tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                   (tptr (Tstruct _EcefCoor_f noattr)))
                                 (Tstruct _EcefCoor_f noattr))
                               (Tstruct _EcefCoor_f noattr)) _y tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                   (tptr (Tstruct _EcefCoor_f noattr)))
                                 (Tstruct _EcefCoor_f noattr))
                               (Tstruct _EcefCoor_f noattr)) _y tfloat)
                           tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _r tfloat)
                       (Ecall
                         (Evalof
                           (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat
                                          cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _r2 tfloat) tfloat) Enil)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _F tfloat)
                         (Ebinop Omul
                           (Ebinop Omul
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4632796641680687104))) tdouble)
                             (Evalof (Evar _b2 tfloat) tfloat) tdouble)
                           (Evalof (Evar _z2 tfloat) tfloat) tdouble) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _G tfloat)
                           (Ebinop Osub
                             (Ebinop Oadd (Evalof (Evar _r2 tfloat) tfloat)
                               (Ebinop Omul
                                 (Ebinop Osub (Eval (Vint (Int.repr 1)) tint)
                                   (Evalof (Evar _e2 tfloat) tfloat) tfloat)
                                 (Evalof (Evar _z2 tfloat) tfloat) tfloat)
                               tfloat)
                             (Ebinop Omul (Evalof (Evar _e2 tfloat) tfloat)
                               (Evalof (Evar _E2 tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign (Evar _c tfloat)
                             (Ebinop Odiv
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _e2 tfloat) tfloat)
                                     (Evalof (Evar _e2 tfloat) tfloat)
                                     tfloat) (Evalof (Evar _F tfloat) tfloat)
                                   tfloat) (Evalof (Evar _r2 tfloat) tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _G tfloat) tfloat)
                                   (Evalof (Evar _G tfloat) tfloat) tfloat)
                                 (Evalof (Evar _G tfloat) tfloat) tfloat)
                               tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign (Evar _s tfloat)
                               (Ecall
                                 (Evalof
                                   (Evar _powf (Tfunction
                                                 (tfloat :: tfloat :: nil)
                                                 tfloat cc_default))
                                   (Tfunction (tfloat :: tfloat :: nil)
                                     tfloat cc_default))
                                 (Econs
                                   (Ebinop Oadd
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Evalof (Evar _c tfloat) tfloat)
                                       tfloat)
                                     (Ecall
                                       (Evalof
                                         (Evar _sqrtf (Tfunction
                                                        (tfloat :: nil)
                                                        tfloat cc_default))
                                         (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                                       (Econs
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _c tfloat) tfloat)
                                             (Evalof (Evar _c tfloat) tfloat)
                                             tfloat)
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Evalof (Evar _c tfloat) tfloat)
                                             tfloat) tfloat) Enil) tfloat)
                                     tfloat)
                                   (Econs
                                     (Ebinop Odiv
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4613937818241073152))) tdouble)
                                       tdouble) Enil)) tfloat) tfloat))
                        (Ssequence
                          (Sdo (Eassign (Evar _s1 tfloat)
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Evalof (Evar _s tfloat) tfloat) tfloat)
                                   (Ebinop Odiv
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Evalof (Evar _s tfloat) tfloat) tfloat)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign (Evar _P tfloat)
                                   (Ebinop Odiv
                                     (Evalof (Evar _F tfloat) tfloat)
                                     (Ebinop Omul
                                       (Ebinop Omul
                                         (Ebinop Omul
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 3)) tint)
                                             (Evalof (Evar _s1 tfloat)
                                               tfloat) tfloat)
                                           (Evalof (Evar _s1 tfloat) tfloat)
                                           tfloat)
                                         (Evalof (Evar _G tfloat) tfloat)
                                         tfloat)
                                       (Evalof (Evar _G tfloat) tfloat)
                                       tfloat) tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign (Evar _Q tfloat)
                                     (Ecall
                                       (Evalof
                                         (Evar _sqrtf (Tfunction
                                                        (tfloat :: nil)
                                                        tfloat cc_default))
                                         (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                                       (Econs
                                         (Ebinop Oadd
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Ebinop Omul
                                             (Ebinop Omul
                                               (Ebinop Omul
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 (Evalof (Evar _e2 tfloat)
                                                   tfloat) tfloat)
                                               (Evalof (Evar _e2 tfloat)
                                                 tfloat) tfloat)
                                             (Evalof (Evar _P tfloat) tfloat)
                                             tfloat) tfloat) Enil) tfloat)
                                     tfloat))
                              (Ssequence
                                (Sdo (Eassign (Evar _ro tfloat)
                                       (Ebinop Oadd
                                         (Ebinop Odiv
                                           (Eunop Oneg
                                             (Ebinop Omul
                                               (Ebinop Omul
                                                 (Evalof (Evar _e2 tfloat)
                                                   tfloat)
                                                 (Evalof (Evar _P tfloat)
                                                   tfloat) tfloat)
                                               (Evalof (Evar _r tfloat)
                                                 tfloat) tfloat) tfloat)
                                           (Ebinop Oadd
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Evalof (Evar _Q tfloat) tfloat)
                                             tfloat) tfloat)
                                         (Ecall
                                           (Evalof
                                             (Evar _sqrtf (Tfunction
                                                            (tfloat :: nil)
                                                            tfloat
                                                            cc_default))
                                             (Tfunction (tfloat :: nil)
                                               tfloat cc_default))
                                           (Econs
                                             (Ebinop Osub
                                               (Ebinop Osub
                                                 (Ebinop Omul
                                                   (Ebinop Odiv
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _a tfloat)
                                                         tfloat)
                                                       (Evalof
                                                         (Evar _a tfloat)
                                                         tfloat) tfloat)
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     tfloat)
                                                   (Ebinop Oadd
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Ebinop Odiv
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (Evalof
                                                         (Evar _Q tfloat)
                                                         tfloat) tfloat)
                                                     tfloat) tfloat)
                                                 (Ebinop Odiv
                                                   (Ebinop Omul
                                                     (Ebinop Omul
                                                       (Ebinop Osub
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         (Evalof
                                                           (Evar _e2 tfloat)
                                                           tfloat) tfloat)
                                                       (Evalof
                                                         (Evar _P tfloat)
                                                         tfloat) tfloat)
                                                     (Evalof
                                                       (Evar _z2 tfloat)
                                                       tfloat) tfloat)
                                                   (Ebinop Omul
                                                     (Evalof (Evar _Q tfloat)
                                                       tfloat)
                                                     (Ebinop Oadd
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (Evalof
                                                         (Evar _Q tfloat)
                                                         tfloat) tfloat)
                                                     tfloat) tfloat) tfloat)
                                               (Ebinop Odiv
                                                 (Ebinop Omul
                                                   (Evalof (Evar _P tfloat)
                                                     tfloat)
                                                   (Evalof (Evar _r2 tfloat)
                                                     tfloat) tfloat)
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 tfloat) tfloat) Enil)
                                           tfloat) tfloat) tfloat))
                                (Ssequence
                                  (Sdo (Eassign (Evar _tmp tfloat)
                                         (Ebinop Omul
                                           (Ebinop Osub
                                             (Evalof (Evar _r tfloat) tfloat)
                                             (Ebinop Omul
                                               (Evalof (Evar _e2 tfloat)
                                                 tfloat)
                                               (Evalof (Evar _ro tfloat)
                                                 tfloat) tfloat) tfloat)
                                           (Ebinop Osub
                                             (Evalof (Evar _r tfloat) tfloat)
                                             (Ebinop Omul
                                               (Evalof (Evar _e2 tfloat)
                                                 tfloat)
                                               (Evalof (Evar _ro tfloat)
                                                 tfloat) tfloat) tfloat)
                                           tfloat) tfloat))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _U tfloat)
                                           (Ecall
                                             (Evalof
                                               (Evar _sqrtf (Tfunction
                                                              (tfloat :: nil)
                                                              tfloat
                                                              cc_default))
                                               (Tfunction (tfloat :: nil)
                                                 tfloat cc_default))
                                             (Econs
                                               (Ebinop Oadd
                                                 (Evalof (Evar _tmp tfloat)
                                                   tfloat)
                                                 (Evalof (Evar _z2 tfloat)
                                                   tfloat) tfloat) Enil)
                                             tfloat) tfloat))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _V tfloat)
                                             (Ecall
                                               (Evalof
                                                 (Evar _sqrtf (Tfunction
                                                                (tfloat ::
                                                                 nil) tfloat
                                                                cc_default))
                                                 (Tfunction (tfloat :: nil)
                                                   tfloat cc_default))
                                               (Econs
                                                 (Ebinop Oadd
                                                   (Evalof (Evar _tmp tfloat)
                                                     tfloat)
                                                   (Ebinop Omul
                                                     (Ebinop Osub
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (Evalof
                                                         (Evar _e2 tfloat)
                                                         tfloat) tfloat)
                                                     (Evalof
                                                       (Evar _z2 tfloat)
                                                       tfloat) tfloat)
                                                   tfloat) Enil) tfloat)
                                             tfloat))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _zo tfloat)
                                               (Ebinop Odiv
                                                 (Ebinop Omul
                                                   (Evalof (Evar _b2 tfloat)
                                                     tfloat)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                                             (tptr (Tstruct _EcefCoor_f noattr)))
                                                           (Tstruct _EcefCoor_f noattr))
                                                         (Tstruct _EcefCoor_f noattr))
                                                       _z tfloat) tfloat)
                                                   tfloat)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _a tfloat)
                                                     tfloat)
                                                   (Evalof (Evar _V tfloat)
                                                     tfloat) tfloat) tfloat)
                                               tfloat))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _out (tptr (Tstruct _LlaCoor_f noattr)))
                                                         (tptr (Tstruct _LlaCoor_f noattr)))
                                                       (Tstruct _LlaCoor_f noattr))
                                                     (Tstruct _LlaCoor_f noattr))
                                                   _alt tfloat)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _U tfloat)
                                                     tfloat)
                                                   (Ebinop Osub
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Ebinop Odiv
                                                       (Evalof
                                                         (Evar _b2 tfloat)
                                                         tfloat)
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Evar _a tfloat)
                                                           tfloat)
                                                         (Evalof
                                                           (Evar _V tfloat)
                                                           tfloat) tfloat)
                                                       tfloat) tfloat)
                                                   tfloat) tfloat))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _out (tptr (Tstruct _LlaCoor_f noattr)))
                                                           (tptr (Tstruct _LlaCoor_f noattr)))
                                                         (Tstruct _LlaCoor_f noattr))
                                                       (Tstruct _LlaCoor_f noattr))
                                                     _lat tfloat)
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _atanf (Tfunction
                                                                    (tfloat ::
                                                                    nil)
                                                                    tfloat
                                                                    cc_default))
                                                       (Tfunction
                                                         (tfloat :: nil)
                                                         tfloat cc_default))
                                                     (Econs
                                                       (Ebinop Odiv
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                                                    (tptr (Tstruct _EcefCoor_f noattr)))
                                                                   (Tstruct _EcefCoor_f noattr))
                                                                 (Tstruct _EcefCoor_f noattr))
                                                               _z tfloat)
                                                             tfloat)
                                                           (Ebinop Omul
                                                             (Evalof
                                                               (Evar _ep2 tfloat)
                                                               tfloat)
                                                             (Evalof
                                                               (Evar _zo tfloat)
                                                               tfloat)
                                                             tfloat) tfloat)
                                                         (Evalof
                                                           (Evar _r tfloat)
                                                           tfloat) tfloat)
                                                       Enil) tfloat) tfloat))
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _out (tptr (Tstruct _LlaCoor_f noattr)))
                                                           (tptr (Tstruct _LlaCoor_f noattr)))
                                                         (Tstruct _LlaCoor_f noattr))
                                                       (Tstruct _LlaCoor_f noattr))
                                                     _lon tfloat)
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _atan2f 
                                                       (Tfunction
                                                         (tfloat :: tfloat ::
                                                          nil) tfloat
                                                         cc_default))
                                                       (Tfunction
                                                         (tfloat :: tfloat ::
                                                          nil) tfloat
                                                         cc_default))
                                                     (Econs
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Ederef
                                                               (Evalof
                                                                 (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                                                 (tptr (Tstruct _EcefCoor_f noattr)))
                                                               (Tstruct _EcefCoor_f noattr))
                                                             (Tstruct _EcefCoor_f noattr))
                                                           _y tfloat) tfloat)
                                                       (Econs
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Ederef
                                                                 (Evalof
                                                                   (Evar _in (tptr (Tstruct _EcefCoor_f noattr)))
                                                                   (tptr (Tstruct _EcefCoor_f noattr)))
                                                                 (Tstruct _EcefCoor_f noattr))
                                                               (Tstruct _EcefCoor_f noattr))
                                                             _x tfloat)
                                                           tfloat) Enil))
                                                     tfloat) tfloat))))))))))))))))))))))))
|}.

Definition v_a__1 := {|
  gvar_info := tfloat;
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 1254270258)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_f__1 := {|
  gvar_info := tfloat;
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 995867348)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_ecef_of_lla_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_out, (tptr (Tstruct _EcefCoor_f noattr))) ::
                (_in, (tptr (Tstruct _LlaCoor_f noattr))) :: nil);
  fn_vars := ((_e2, tfloat) :: (_sin_lat, tfloat) :: (_cos_lat, tfloat) ::
              (_sin_lon, tfloat) :: (_cos_lon, tfloat) :: (_chi, tfloat) ::
              (_a_chi, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _e2 tfloat)
         (Ebinop Osub
           (Ebinop Omul
             (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
             (Evalof (Evar _f__1 tfloat) tfloat) tdouble)
           (Ebinop Omul (Evalof (Evar _f__1 tfloat) tfloat)
             (Evalof (Evar _f__1 tfloat) tfloat) tfloat) tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _sin_lat tfloat)
           (Ecall
             (Evalof
               (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
               (Tfunction (tfloat :: nil) tfloat cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                         (tptr (Tstruct _LlaCoor_f noattr)))
                       (Tstruct _LlaCoor_f noattr))
                     (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat) Enil)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _cos_lat tfloat)
             (Ecall
               (Evalof
                 (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Tfunction (tfloat :: nil) tfloat cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                           (tptr (Tstruct _LlaCoor_f noattr)))
                         (Tstruct _LlaCoor_f noattr))
                       (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat)
                 Enil) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _sin_lon tfloat)
               (Ecall
                 (Evalof
                   (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                             (tptr (Tstruct _LlaCoor_f noattr)))
                           (Tstruct _LlaCoor_f noattr))
                         (Tstruct _LlaCoor_f noattr)) _lon tfloat) tfloat)
                   Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _cos_lon tfloat)
                 (Ecall
                   (Evalof
                     (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                               (tptr (Tstruct _LlaCoor_f noattr)))
                             (Tstruct _LlaCoor_f noattr))
                           (Tstruct _LlaCoor_f noattr)) _lon tfloat) tfloat)
                     Enil) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _chi tfloat)
                   (Ecall
                     (Evalof
                       (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat
                                      cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs
                       (Ebinop Osub
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                         (Ebinop Omul
                           (Ebinop Omul (Evalof (Evar _e2 tfloat) tfloat)
                             (Evalof (Evar _sin_lat tfloat) tfloat) tfloat)
                           (Evalof (Evar _sin_lat tfloat) tfloat) tfloat)
                         tdouble) Enil) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _a_chi tfloat)
                     (Ebinop Odiv (Evalof (Evar _a__1 tfloat) tfloat)
                       (Evalof (Evar _chi tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _out (tptr (Tstruct _EcefCoor_f noattr)))
                               (tptr (Tstruct _EcefCoor_f noattr)))
                             (Tstruct _EcefCoor_f noattr))
                           (Tstruct _EcefCoor_f noattr)) _x tfloat)
                       (Ebinop Omul
                         (Ebinop Omul
                           (Ebinop Oadd (Evalof (Evar _a_chi tfloat) tfloat)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                                       (tptr (Tstruct _LlaCoor_f noattr)))
                                     (Tstruct _LlaCoor_f noattr))
                                   (Tstruct _LlaCoor_f noattr)) _alt tfloat)
                               tfloat) tfloat)
                           (Evalof (Evar _cos_lat tfloat) tfloat) tfloat)
                         (Evalof (Evar _cos_lon tfloat) tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _out (tptr (Tstruct _EcefCoor_f noattr)))
                                 (tptr (Tstruct _EcefCoor_f noattr)))
                               (Tstruct _EcefCoor_f noattr))
                             (Tstruct _EcefCoor_f noattr)) _y tfloat)
                         (Ebinop Omul
                           (Ebinop Omul
                             (Ebinop Oadd
                               (Evalof (Evar _a_chi tfloat) tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                                         (tptr (Tstruct _LlaCoor_f noattr)))
                                       (Tstruct _LlaCoor_f noattr))
                                     (Tstruct _LlaCoor_f noattr)) _alt
                                   tfloat) tfloat) tfloat)
                             (Evalof (Evar _cos_lat tfloat) tfloat) tfloat)
                           (Evalof (Evar _sin_lon tfloat) tfloat) tfloat)
                         tfloat))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _out (tptr (Tstruct _EcefCoor_f noattr)))
                                 (tptr (Tstruct _EcefCoor_f noattr)))
                               (Tstruct _EcefCoor_f noattr))
                             (Tstruct _EcefCoor_f noattr)) _z tfloat)
                         (Ebinop Omul
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Evalof (Evar _a_chi tfloat) tfloat)
                               (Ebinop Osub
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                 (Evalof (Evar _e2 tfloat) tfloat) tdouble)
                               tdouble)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _in (tptr (Tstruct _LlaCoor_f noattr)))
                                       (tptr (Tstruct _LlaCoor_f noattr)))
                                     (Tstruct _LlaCoor_f noattr))
                                   (Tstruct _LlaCoor_f noattr)) _alt tfloat)
                               tfloat) tdouble)
                           (Evalof (Evar _sin_lat tfloat) tfloat) tdouble)
                         tfloat)))))))))))
|}.

Definition v_serie_coeff_proj_mercator := {|
  gvar_info := (tarray tfloat 5);
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 1065325102)) ::
                Init_float32 (Float32.of_bits (Int.repr 979057926)) ::
                Init_float32 (Float32.of_bits (Int.repr 894166475)) ::
                Init_float32 (Float32.of_bits (Int.repr 816075658)) ::
                Init_float32 (Float32.of_bits (Int.repr 740926745)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_serie_coeff_proj_mercator_inverse := {|
  gvar_info := (tarray tfloat 5);
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 1065325102)) ::
                Init_float32 (Float32.of_bits (Int.repr 979082049)) ::
                Init_float32 (Float32.of_bits (Int.repr 863872952)) ::
                Init_float32 (Float32.of_bits (Int.repr 792198728)) ::
                Init_float32 (Float32.of_bits (Int.repr 712036286)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_isometric_latitude_f := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_phi, tfloat) :: (_e, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Osub
                 (Ecall
                   (Evalof
                     (Evar _logf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
                     (Ecall
                       (Evalof
                         (Evar _tanf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs
                         (Ebinop Oadd
                           (Ebinop Odiv
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                             (Eval (Vint (Int.repr 4)) tint) tdouble)
                           (Ebinop Odiv (Evalof (Evar _phi tfloat) tfloat)
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                             tdouble) tdouble) Enil) tfloat) Enil) tfloat)
                 (Ebinop Omul
                   (Ebinop Odiv (Evalof (Evar _e tfloat) tfloat)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     tdouble)
                   (Ecall
                     (Evalof
                       (Evar _logf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs
                       (Ebinop Odiv
                         (Ebinop Oadd
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                           (Ebinop Omul (Evalof (Evar _e tfloat) tfloat)
                             (Ecall
                               (Evalof
                                 (Evar _sinf (Tfunction (tfloat :: nil)
                                               tfloat cc_default))
                                 (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                               (Econs (Evalof (Evar _phi tfloat) tfloat)
                                 Enil) tfloat) tfloat) tdouble)
                         (Ebinop Osub
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                           (Ebinop Omul (Evalof (Evar _e tfloat) tfloat)
                             (Ecall
                               (Evalof
                                 (Evar _sinf (Tfunction (tfloat :: nil)
                                               tfloat cc_default))
                                 (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                               (Econs (Evalof (Evar _phi tfloat) tfloat)
                                 Enil) tfloat) tfloat) tdouble) tdouble)
                       Enil) tfloat) tdouble) tdouble)))
|}.

Definition f_isometric_latitude_fast_f := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_phi, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _logf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ecall
                     (Evalof
                       (Evar _tanf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs
                       (Ebinop Oadd
                         (Ebinop Odiv
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                           (Eval (Vint (Int.repr 4)) tint) tdouble)
                         (Ebinop Odiv (Evalof (Evar _phi tfloat) tfloat)
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                           tdouble) tdouble) Enil) tfloat) Enil) tfloat)))
|}.

Definition f_inverse_isometric_latitude_f := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_lat, tfloat) :: (_e, tfloat) :: (_epsilon, tfloat) :: nil);
  fn_vars := ((_exp_l, tfloat) :: (_phi0, tfloat) :: (_phi_, tfloat) ::
              (_max_iter, tuchar) :: (_sin_phi, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _exp_l tfloat)
         (Ecall
           (Evalof (Evar _expf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs (Evalof (Evar _lat tfloat) tfloat) Enil) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _phi0 tfloat)
           (Ebinop Osub
             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
               (Ecall
                 (Evalof
                   (Evar _atanf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _exp_l tfloat) tfloat) Enil) tfloat)
               tfloat)
             (Ebinop Odiv
               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
               (Eval (Vint (Int.repr 2)) tint) tdouble) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _max_iter tuchar) (Eval (Vint (Int.repr 3)) tint)
             tuchar))
      (Ssequence
        (Sdowhile
          (Eseqand (Evalof (Evar _max_iter tuchar) tuchar)
            (Ebinop Ogt
              (Ecall
                (Evalof
                  (Evar _fabsf (Tfunction (tfloat :: nil) tfloat cc_default))
                  (Tfunction (tfloat :: nil) tfloat cc_default))
                (Econs
                  (Ebinop Osub (Evalof (Evar _phi_ tfloat) tfloat)
                    (Evalof (Evar _phi0 tfloat) tfloat) tfloat) Enil) tfloat)
              (Evalof (Evar _epsilon tfloat) tfloat) tint) tint)
          (Ssequence
            (Sdo (Eassign (Evar _phi_ tfloat)
                   (Evalof (Evar _phi0 tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _sin_phi tfloat)
                     (Ebinop Omul (Evalof (Evar _e tfloat) tfloat)
                       (Ecall
                         (Evalof
                           (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                         cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _phi_ tfloat) tfloat) Enil)
                         tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _phi0 tfloat)
                       (Ebinop Osub
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Ecall
                             (Evalof
                               (Evar _atanf (Tfunction (tfloat :: nil) tfloat
                                              cc_default))
                               (Tfunction (tfloat :: nil) tfloat cc_default))
                             (Econs
                               (Ebinop Omul
                                 (Ecall
                                   (Evalof
                                     (Evar _powf (Tfunction
                                                   (tfloat :: tfloat :: nil)
                                                   tfloat cc_default))
                                     (Tfunction (tfloat :: tfloat :: nil)
                                       tfloat cc_default))
                                   (Econs
                                     (Ebinop Odiv
                                       (Ebinop Oadd
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Evalof (Evar _sin_phi tfloat)
                                           tfloat) tfloat)
                                       (Ebinop Osub
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                         (Evalof (Evar _sin_phi tfloat)
                                           tfloat) tdouble) tdouble)
                                     (Econs
                                       (Ebinop Odiv
                                         (Evalof (Evar _e tfloat) tfloat)
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                         tdouble) Enil)) tfloat)
                                 (Evalof (Evar _exp_l tfloat) tfloat) tfloat)
                               Enil) tfloat) tfloat)
                         (Ebinop Odiv
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                           (Eval (Vint (Int.repr 2)) tint) tdouble) tdouble)
                       tfloat))
                (Sdo (Epostincr Decr (Evar _max_iter tuchar) tuchar))))))
        (Sreturn (Some (Evalof (Evar _phi0 tfloat) tfloat)))))))
|}.

Definition f_utm_of_lla_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_utm, (tptr (Tstruct _UtmCoor_f noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_f noattr))) :: nil);
  fn_vars := ((_lambda_c, tfloat) :: (_ll, tfloat) :: (_dl, tfloat) ::
              (_phi_, tfloat) :: (_ll_, tfloat) :: (_lambda_, tfloat) ::
              (_z_, (Tstruct _complex noattr)) :: (_k, tschar) ::
              (_z, (Tstruct _complex noattr)) :: (_tmp, tfloat) ::
              (__z, (Tstruct _complex noattr)) :: (_e, tfloat) ::
              (_cos_z_im, tfloat) :: (_sin_z_im, tfloat) ::
              (_tmp__1, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oeq
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                           (tptr (Tstruct _UtmCoor_f noattr)))
                         (Tstruct _UtmCoor_f noattr))
                       (Tstruct _UtmCoor_f noattr)) _zone tuchar) tuchar)
                 (Eval (Vint (Int.repr 0)) tint) tint)
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                   (tptr (Tstruct _UtmCoor_f noattr)))
                 (Tstruct _UtmCoor_f noattr)) (Tstruct _UtmCoor_f noattr))
             _zone tuchar)
           (Ebinop Oadd
             (Ebinop Odiv
               (Ecall
                 (Evalof
                   (Evar _floor (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Ebinop Oadd
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                                 (tptr (Tstruct _LlaCoor_f noattr)))
                               (Tstruct _LlaCoor_f noattr))
                             (Tstruct _LlaCoor_f noattr)) _lon tfloat)
                         tfloat)
                       (Ebinop Odiv
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                         tdouble) tdouble) (Eval (Vint (Int.repr 180)) tint)
                     tdouble) Enil) tdouble) (Eval (Vint (Int.repr 6)) tint)
               tdouble) (Eval (Vint (Int.repr 1)) tint) tdouble) tuchar))
    Sskip)
  (Ssequence
    (Sdo (Eassign (Evar _lambda_c tfloat)
           (Ebinop Omul
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Omul
                   (Ebinop Osub
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                               (tptr (Tstruct _UtmCoor_f noattr)))
                             (Tstruct _UtmCoor_f noattr))
                           (Tstruct _UtmCoor_f noattr)) _zone tuchar) tuchar)
                     (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 6)) tint) tint)
                 (Eval (Vint (Int.repr 180)) tint) tint)
               (Eval (Vint (Int.repr 3)) tint) tint)
             (Ebinop Odiv
               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
               tdouble) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _ll tfloat)
             (Ecall
               (Evalof
                 (Evar _isometric_latitude_f (Tfunction
                                               (tfloat :: tfloat :: nil)
                                               tfloat cc_default))
                 (Tfunction (tfloat :: tfloat :: nil) tfloat cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                           (tptr (Tstruct _LlaCoor_f noattr)))
                         (Tstruct _LlaCoor_f noattr))
                       (Tstruct _LlaCoor_f noattr)) _lat tfloat) tfloat)
                 (Econs
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4590560114717078071))) tdouble)
                   Enil)) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _dl tfloat)
               (Ebinop Osub
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                           (tptr (Tstruct _LlaCoor_f noattr)))
                         (Tstruct _LlaCoor_f noattr))
                       (Tstruct _LlaCoor_f noattr)) _lon tfloat) tfloat)
                 (Evalof (Evar _lambda_c tfloat) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _phi_ tfloat)
                 (Ecall
                   (Evalof
                     (Evar _asinf (Tfunction (tfloat :: nil) tfloat
                                    cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
                     (Ebinop Odiv
                       (Ecall
                         (Evalof
                           (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                         cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _dl tfloat) tfloat) Enil)
                         tfloat)
                       (Ecall
                         (Evalof
                           (Evar _coshf (Tfunction (tfloat :: nil) tfloat
                                          cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _ll tfloat) tfloat) Enil)
                         tfloat) tfloat) Enil) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _ll_ tfloat)
                   (Ecall
                     (Evalof
                       (Evar _isometric_latitude_fast_f (Tfunction
                                                          (tfloat :: nil)
                                                          tfloat cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _phi_ tfloat) tfloat) Enil) tfloat)
                   tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _lambda_ tfloat)
                     (Ecall
                       (Evalof
                         (Evar _atanf (Tfunction (tfloat :: nil) tfloat
                                        cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs
                         (Ebinop Odiv
                           (Ecall
                             (Evalof
                               (Evar _sinhf (Tfunction (tfloat :: nil) tfloat
                                              cc_default))
                               (Tfunction (tfloat :: nil) tfloat cc_default))
                             (Econs (Evalof (Evar _ll tfloat) tfloat) Enil)
                             tfloat)
                           (Ecall
                             (Evalof
                               (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                               (Tfunction (tfloat :: nil) tfloat cc_default))
                             (Econs (Evalof (Evar _dl tfloat) tfloat) Enil)
                             tfloat) tfloat) Enil) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _z_ (Tstruct _complex noattr))
                           (Tstruct _complex noattr)) _re tfloat)
                       (Evalof (Evar _lambda_ tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _z_ (Tstruct _complex noattr))
                             (Tstruct _complex noattr)) _im tfloat)
                         (Evalof (Evar _ll_ tfloat) tfloat) tfloat))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassignop Omul
                             (Efield
                               (Evalof (Evar _z_ (Tstruct _complex noattr))
                                 (Tstruct _complex noattr)) _re tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                     (tarray tfloat 5))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             tfloat tfloat))
                      (Sdo (Eassignop Omul
                             (Efield
                               (Evalof (Evar _z_ (Tstruct _complex noattr))
                                 (Tstruct _complex noattr)) _im tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                     (tarray tfloat 5))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             tfloat tfloat)))
                    (Ssequence
                      (Sfor
                        (Sdo (Eassign (Evar _k tschar)
                               (Eval (Vint (Int.repr 1)) tint) tschar))
                        (Ebinop Olt (Evalof (Evar _k tschar) tschar)
                          (Eval (Vint (Int.repr 3)) tint) tint)
                        (Sdo (Epostincr Incr (Evar _k tschar) tschar))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Evar _z (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _re tfloat)
                                 (Evalof (Evar _lambda_ tfloat) tfloat)
                                 tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _z (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _im tfloat)
                                   (Evalof (Evar _ll_ tfloat) tfloat) tfloat))
                            (Ssequence
                              (Ssequence
                                (Sdo (Eassignop Omul
                                       (Efield
                                         (Evalof
                                           (Evar _z (Tstruct _complex noattr))
                                           (Tstruct _complex noattr)) _re
                                         tfloat)
                                       (Ebinop Omul
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                         (Evalof (Evar _k tschar) tschar)
                                         tdouble) tdouble tfloat))
                                (Sdo (Eassignop Omul
                                       (Efield
                                         (Evalof
                                           (Evar _z (Tstruct _complex noattr))
                                           (Tstruct _complex noattr)) _im
                                         tfloat)
                                       (Ebinop Omul
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                         (Evalof (Evar _k tschar) tschar)
                                         tdouble) tdouble tfloat)))
                              (Ssequence
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassign (Evar _tmp tfloat)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _re tfloat) tfloat) tfloat))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _re tfloat)
                                             (Eunop Oneg
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _z (Tstruct _complex noattr))
                                                     (Tstruct _complex noattr))
                                                   _im tfloat) tfloat)
                                               tfloat) tfloat))
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _im tfloat)
                                             (Evalof (Evar _tmp tfloat)
                                               tfloat) tfloat))))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Evar __z (Tstruct _complex noattr))
                                               (Tstruct _complex noattr)) _re
                                             tfloat)
                                           (Eunop Oneg
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _z (Tstruct _complex noattr))
                                                   (Tstruct _complex noattr))
                                                 _re tfloat) tfloat) tfloat)
                                           tfloat))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar __z (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _im tfloat)
                                             (Eunop Oneg
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _z (Tstruct _complex noattr))
                                                     (Tstruct _complex noattr))
                                                   _im tfloat) tfloat)
                                               tfloat) tfloat))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _e tfloat)
                                               (Ecall
                                                 (Evalof
                                                   (Evar _exp (Tfunction
                                                                (tdouble ::
                                                                 nil) tdouble
                                                                cc_default))
                                                   (Tfunction
                                                     (tdouble :: nil) tdouble
                                                     cc_default))
                                                 (Econs
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Evar _z (Tstruct _complex noattr))
                                                         (Tstruct _complex noattr))
                                                       _re tfloat) tfloat)
                                                   Enil) tdouble) tfloat))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Evar _cos_z_im tfloat)
                                                 (Ecall
                                                   (Evalof
                                                     (Evar _cosf (Tfunction
                                                                   (tfloat ::
                                                                    nil)
                                                                   tfloat
                                                                   cc_default))
                                                     (Tfunction
                                                       (tfloat :: nil) tfloat
                                                       cc_default))
                                                   (Econs
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z (Tstruct _complex noattr))
                                                           (Tstruct _complex noattr))
                                                         _im tfloat) tfloat)
                                                     Enil) tfloat) tfloat))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Evar _z (Tstruct _complex noattr))
                                                       (Tstruct _complex noattr))
                                                     _re tfloat)
                                                   (Ebinop Omul
                                                     (Evalof (Evar _e tfloat)
                                                       tfloat)
                                                     (Evalof
                                                       (Evar _cos_z_im tfloat)
                                                       tfloat) tfloat)
                                                   tfloat))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _sin_z_im tfloat)
                                                     (Ecall
                                                       (Evalof
                                                         (Evar _sinf 
                                                         (Tfunction
                                                           (tfloat :: nil)
                                                           tfloat cc_default))
                                                         (Tfunction
                                                           (tfloat :: nil)
                                                           tfloat cc_default))
                                                       (Econs
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Evar _z (Tstruct _complex noattr))
                                                               (Tstruct _complex noattr))
                                                             _im tfloat)
                                                           tfloat) Enil)
                                                       tfloat) tfloat))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z (Tstruct _complex noattr))
                                                           (Tstruct _complex noattr))
                                                         _im tfloat)
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Evar _e tfloat)
                                                           tfloat)
                                                         (Evalof
                                                           (Evar _sin_z_im tfloat)
                                                           tfloat) tfloat)
                                                       tfloat))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Efield
                                                           (Evalof
                                                             (Evar __z (Tstruct _complex noattr))
                                                             (Tstruct _complex noattr))
                                                           _re tfloat)
                                                         (Ebinop Odiv
                                                           (Evalof
                                                             (Evar _cos_z_im tfloat)
                                                             tfloat)
                                                           (Evalof
                                                             (Evar _e tfloat)
                                                             tfloat) tfloat)
                                                         tfloat))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Efield
                                                             (Evalof
                                                               (Evar __z (Tstruct _complex noattr))
                                                               (Tstruct _complex noattr))
                                                             _im tfloat)
                                                           (Ebinop Odiv
                                                             (Eunop Oneg
                                                               (Evalof
                                                                 (Evar _sin_z_im tfloat)
                                                                 tfloat)
                                                               tfloat)
                                                             (Evalof
                                                               (Evar _e tfloat)
                                                               tfloat)
                                                             tfloat) tfloat))
                                                    (Ssequence
                                                      (Ssequence
                                                        (Sdo (Eassignop Osub
                                                               (Efield
                                                                 (Evalof
                                                                   (Evar _z (Tstruct _complex noattr))
                                                                   (Tstruct _complex noattr))
                                                                 _re tfloat)
                                                               (Evalof
                                                                 (Efield
                                                                   (Evalof
                                                                    (Evar __z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                   _re
                                                                   tfloat)
                                                                 tfloat)
                                                               tfloat tfloat))
                                                        (Sdo (Eassignop Osub
                                                               (Efield
                                                                 (Evalof
                                                                   (Evar _z (Tstruct _complex noattr))
                                                                   (Tstruct _complex noattr))
                                                                 _im tfloat)
                                                               (Evalof
                                                                 (Efield
                                                                   (Evalof
                                                                    (Evar __z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                   _im
                                                                   tfloat)
                                                                 tfloat)
                                                               tfloat tfloat)))
                                                      (Ssequence
                                                        (Ssequence
                                                          (Sdo (Eassignop
                                                                 Omul
                                                                 (Efield
                                                                   (Evalof
                                                                    (Evar _z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                   _re
                                                                   tfloat)
                                                                 (Eunop Oneg
                                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                                   tdouble)
                                                                 tdouble tfloat))
                                                          (Sdo (Eassignop
                                                                 Omul
                                                                 (Efield
                                                                   (Evalof
                                                                    (Evar _z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                   _im
                                                                   tfloat)
                                                                 (Eunop Oneg
                                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                                   tdouble)
                                                                 tdouble tfloat)))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _tmp__1 tfloat)
                                                                 (Evalof
                                                                   (Efield
                                                                    (Evalof
                                                                    (Evar _z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                    _re
                                                                    tfloat)
                                                                   tfloat)
                                                                 tfloat))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Efield
                                                                    (Evalof
                                                                    (Evar _z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                    _re
                                                                    tfloat)
                                                                   (Eunop Oneg
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                    _im
                                                                    tfloat)
                                                                    tfloat)
                                                                    tfloat)
                                                                   tfloat))
                                                            (Sdo (Eassign
                                                                   (Efield
                                                                    (Evalof
                                                                    (Evar _z (Tstruct _complex noattr))
                                                                    (Tstruct _complex noattr))
                                                                    _im
                                                                    tfloat)
                                                                   (Evalof
                                                                    (Evar _tmp__1 tfloat)
                                                                    tfloat)
                                                                   tfloat))))))))))))))))
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassignop Omul
                                           (Efield
                                             (Evalof
                                               (Evar _z (Tstruct _complex noattr))
                                               (Tstruct _complex noattr)) _re
                                             tfloat)
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                                   (tarray tfloat 5))
                                                 (Evalof (Evar _k tschar)
                                                   tschar) (tptr tfloat))
                                               tfloat) tfloat) tfloat tfloat))
                                    (Sdo (Eassignop Omul
                                           (Efield
                                             (Evalof
                                               (Evar _z (Tstruct _complex noattr))
                                               (Tstruct _complex noattr)) _im
                                             tfloat)
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                                   (tarray tfloat 5))
                                                 (Evalof (Evar _k tschar)
                                                   tschar) (tptr tfloat))
                                               tfloat) tfloat) tfloat tfloat)))
                                  (Ssequence
                                    (Sdo (Eassignop Oadd
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _complex noattr))
                                               (Tstruct _complex noattr)) _re
                                             tfloat)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _re tfloat) tfloat)
                                           tfloat tfloat))
                                    (Sdo (Eassignop Oadd
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _complex noattr))
                                               (Tstruct _complex noattr)) _im
                                             tfloat)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _im tfloat) tfloat)
                                           tfloat tfloat)))))))))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassignop Omul
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _re tfloat)
                                 (Ebinop Omul
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607178815920315512))) tdouble)
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
                                   tdouble) tdouble tfloat))
                          (Sdo (Eassignop Omul
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _im tfloat)
                                 (Ebinop Omul
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607178815920315512))) tdouble)
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
                                   tdouble) tdouble tfloat)))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                                         (tptr (Tstruct _UtmCoor_f noattr)))
                                       (Tstruct _UtmCoor_f noattr))
                                     (Tstruct _UtmCoor_f noattr)) _east
                                   tfloat)
                                 (Ebinop Oadd
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4692333547057315840))) tdouble)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _complex noattr))
                                         (Tstruct _complex noattr)) _im
                                       tfloat) tfloat) tdouble) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                                           (tptr (Tstruct _UtmCoor_f noattr)))
                                         (Tstruct _UtmCoor_f noattr))
                                       (Tstruct _UtmCoor_f noattr)) _north
                                     tfloat)
                                   (Ebinop Oadd
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _complex noattr))
                                           (Tstruct _complex noattr)) _re
                                         tfloat) tfloat) tdouble) tfloat))
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                                           (tptr (Tstruct _UtmCoor_f noattr)))
                                         (Tstruct _UtmCoor_f noattr))
                                       (Tstruct _UtmCoor_f noattr)) _alt
                                     tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                                             (tptr (Tstruct _LlaCoor_f noattr)))
                                           (Tstruct _LlaCoor_f noattr))
                                         (Tstruct _LlaCoor_f noattr)) _alt
                                       tfloat) tfloat) tfloat))))))))))))))))
|}.

Definition f_lla_of_utm_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_lla, (tptr (Tstruct _LlaCoor_f noattr))) ::
                (_utm, (tptr (Tstruct _UtmCoor_f noattr))) :: nil);
  fn_vars := ((_scale, tfloat) :: (_real, tfloat) :: (_img, tfloat) ::
              (_z, (Tstruct _complex noattr)) :: (_k, tschar) ::
              (_z_, (Tstruct _complex noattr)) :: (_tmp, tfloat) ::
              (__z, (Tstruct _complex noattr)) :: (_e, tfloat) ::
              (_cos_z_im, tfloat) :: (_sin_z_im, tfloat) ::
              (_tmp__1, tfloat) :: (_lambda_c, tfloat) :: (_phi_, tfloat) ::
              (_il, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _scale tfloat)
         (Ebinop Odiv
           (Ebinop Odiv (Eval (Vint (Int.repr 1)) tint)
             (Ebinop Omul
               (Eval (Vfloat (Float.of_bits (Int64.repr 4607178815920315512))) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
               tdouble) tdouble)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                   (tarray tfloat 5)) (Eval (Vint (Int.repr 0)) tint)
                 (tptr tfloat)) tfloat) tfloat) tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _real tfloat)
           (Ebinop Omul
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                         (tptr (Tstruct _UtmCoor_f noattr)))
                       (Tstruct _UtmCoor_f noattr))
                     (Tstruct _UtmCoor_f noattr)) _north tfloat) tfloat)
               (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
               tdouble) (Evalof (Evar _scale tfloat) tfloat) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _img tfloat)
             (Ebinop Omul
               (Ebinop Osub
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                           (tptr (Tstruct _UtmCoor_f noattr)))
                         (Tstruct _UtmCoor_f noattr))
                       (Tstruct _UtmCoor_f noattr)) _east tfloat) tfloat)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4692333547057315840))) tdouble)
                 tdouble) (Evalof (Evar _scale tfloat) tfloat) tdouble)
             tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _z (Tstruct _complex noattr))
                   (Tstruct _complex noattr)) _re tfloat)
               (Evalof (Evar _real tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _z (Tstruct _complex noattr))
                     (Tstruct _complex noattr)) _im tfloat)
                 (Evalof (Evar _img tfloat) tfloat) tfloat))
          (Ssequence
            (Sfor
              (Sdo (Eassign (Evar _k tschar) (Eval (Vint (Int.repr 1)) tint)
                     tschar))
              (Ebinop Olt (Evalof (Evar _k tschar) tschar)
                (Eval (Vint (Int.repr 2)) tint) tint)
              (Sdo (Epostincr Incr (Evar _k tschar) tschar))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _z_ (Tstruct _complex noattr))
                           (Tstruct _complex noattr)) _re tfloat)
                       (Evalof (Evar _real tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _z_ (Tstruct _complex noattr))
                             (Tstruct _complex noattr)) _im tfloat)
                         (Evalof (Evar _img tfloat) tfloat) tfloat))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassignop Omul
                             (Efield
                               (Evalof (Evar _z_ (Tstruct _complex noattr))
                                 (Tstruct _complex noattr)) _re tfloat)
                             (Ebinop Omul
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                               (Evalof (Evar _k tschar) tschar) tdouble)
                             tdouble tfloat))
                      (Sdo (Eassignop Omul
                             (Efield
                               (Evalof (Evar _z_ (Tstruct _complex noattr))
                                 (Tstruct _complex noattr)) _im tfloat)
                             (Ebinop Omul
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                               (Evalof (Evar _k tschar) tschar) tdouble)
                             tdouble tfloat)))
                    (Ssequence
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign (Evar _tmp tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _re tfloat)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _re tfloat)
                                   (Eunop Oneg
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _complex noattr))
                                           (Tstruct _complex noattr)) _im
                                         tfloat) tfloat) tfloat) tfloat))
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _im tfloat)
                                   (Evalof (Evar _tmp tfloat) tfloat) tfloat))))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Evar __z (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _re tfloat)
                                 (Eunop Oneg
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _complex noattr))
                                         (Tstruct _complex noattr)) _re
                                       tfloat) tfloat) tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar __z (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _im tfloat)
                                   (Eunop Oneg
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _complex noattr))
                                           (Tstruct _complex noattr)) _im
                                         tfloat) tfloat) tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign (Evar _e tfloat)
                                     (Ecall
                                       (Evalof
                                         (Evar _exp (Tfunction
                                                      (tdouble :: nil)
                                                      tdouble cc_default))
                                         (Tfunction (tdouble :: nil) tdouble
                                           cc_default))
                                       (Econs
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _complex noattr))
                                               (Tstruct _complex noattr)) _re
                                             tfloat) tfloat) Enil) tdouble)
                                     tfloat))
                              (Ssequence
                                (Sdo (Eassign (Evar _cos_z_im tfloat)
                                       (Ecall
                                         (Evalof
                                           (Evar _cosf (Tfunction
                                                         (tfloat :: nil)
                                                         tfloat cc_default))
                                           (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                                         (Econs
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z_ (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _im tfloat) tfloat) Enil)
                                         tfloat) tfloat))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Evar _z_ (Tstruct _complex noattr))
                                             (Tstruct _complex noattr)) _re
                                           tfloat)
                                         (Ebinop Omul
                                           (Evalof (Evar _e tfloat) tfloat)
                                           (Evalof (Evar _cos_z_im tfloat)
                                             tfloat) tfloat) tfloat))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _sin_z_im tfloat)
                                           (Ecall
                                             (Evalof
                                               (Evar _sinf (Tfunction
                                                             (tfloat :: nil)
                                                             tfloat
                                                             cc_default))
                                               (Tfunction (tfloat :: nil)
                                                 tfloat cc_default))
                                             (Econs
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _z_ (Tstruct _complex noattr))
                                                     (Tstruct _complex noattr))
                                                   _im tfloat) tfloat) Enil)
                                             tfloat) tfloat))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _z_ (Tstruct _complex noattr))
                                                 (Tstruct _complex noattr))
                                               _im tfloat)
                                             (Ebinop Omul
                                               (Evalof (Evar _e tfloat)
                                                 tfloat)
                                               (Evalof
                                                 (Evar _sin_z_im tfloat)
                                                 tfloat) tfloat) tfloat))
                                      (Ssequence
                                        (Sdo (Eassign
                                               (Efield
                                                 (Evalof
                                                   (Evar __z (Tstruct _complex noattr))
                                                   (Tstruct _complex noattr))
                                                 _re tfloat)
                                               (Ebinop Odiv
                                                 (Evalof
                                                   (Evar _cos_z_im tfloat)
                                                   tfloat)
                                                 (Evalof (Evar _e tfloat)
                                                   tfloat) tfloat) tfloat))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Efield
                                                   (Evalof
                                                     (Evar __z (Tstruct _complex noattr))
                                                     (Tstruct _complex noattr))
                                                   _im tfloat)
                                                 (Ebinop Odiv
                                                   (Eunop Oneg
                                                     (Evalof
                                                       (Evar _sin_z_im tfloat)
                                                       tfloat) tfloat)
                                                   (Evalof (Evar _e tfloat)
                                                     tfloat) tfloat) tfloat))
                                          (Ssequence
                                            (Ssequence
                                              (Sdo (Eassignop Osub
                                                     (Efield
                                                       (Evalof
                                                         (Evar _z_ (Tstruct _complex noattr))
                                                         (Tstruct _complex noattr))
                                                       _re tfloat)
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar __z (Tstruct _complex noattr))
                                                           (Tstruct _complex noattr))
                                                         _re tfloat) tfloat)
                                                     tfloat tfloat))
                                              (Sdo (Eassignop Osub
                                                     (Efield
                                                       (Evalof
                                                         (Evar _z_ (Tstruct _complex noattr))
                                                         (Tstruct _complex noattr))
                                                       _im tfloat)
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar __z (Tstruct _complex noattr))
                                                           (Tstruct _complex noattr))
                                                         _im tfloat) tfloat)
                                                     tfloat tfloat)))
                                            (Ssequence
                                              (Ssequence
                                                (Sdo (Eassignop Omul
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z_ (Tstruct _complex noattr))
                                                           (Tstruct _complex noattr))
                                                         _re tfloat)
                                                       (Eunop Oneg
                                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                         tdouble)
                                                       tdouble tfloat))
                                                (Sdo (Eassignop Omul
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z_ (Tstruct _complex noattr))
                                                           (Tstruct _complex noattr))
                                                         _im tfloat)
                                                       (Eunop Oneg
                                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                         tdouble)
                                                       tdouble tfloat)))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _tmp__1 tfloat)
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Evar _z_ (Tstruct _complex noattr))
                                                             (Tstruct _complex noattr))
                                                           _re tfloat)
                                                         tfloat) tfloat))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Efield
                                                           (Evalof
                                                             (Evar _z_ (Tstruct _complex noattr))
                                                             (Tstruct _complex noattr))
                                                           _re tfloat)
                                                         (Eunop Oneg
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Evar _z_ (Tstruct _complex noattr))
                                                                 (Tstruct _complex noattr))
                                                               _im tfloat)
                                                             tfloat) tfloat)
                                                         tfloat))
                                                  (Sdo (Eassign
                                                         (Efield
                                                           (Evalof
                                                             (Evar _z_ (Tstruct _complex noattr))
                                                             (Tstruct _complex noattr))
                                                           _im tfloat)
                                                         (Evalof
                                                           (Evar _tmp__1 tfloat)
                                                           tfloat) tfloat))))))))))))))))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassignop Omul
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _re tfloat)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _serie_coeff_proj_mercator_inverse (tarray tfloat 5))
                                         (tarray tfloat 5))
                                       (Evalof (Evar _k tschar) tschar)
                                       (tptr tfloat)) tfloat) tfloat)
                                 tfloat tfloat))
                          (Sdo (Eassignop Omul
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _im tfloat)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _serie_coeff_proj_mercator_inverse (tarray tfloat 5))
                                         (tarray tfloat 5))
                                       (Evalof (Evar _k tschar) tschar)
                                       (tptr tfloat)) tfloat) tfloat)
                                 tfloat tfloat)))
                        (Ssequence
                          (Sdo (Eassignop Osub
                                 (Efield
                                   (Evalof
                                     (Evar _z (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _re tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _re tfloat)
                                   tfloat) tfloat tfloat))
                          (Sdo (Eassignop Osub
                                 (Efield
                                   (Evalof
                                     (Evar _z (Tstruct _complex noattr))
                                     (Tstruct _complex noattr)) _im tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _complex noattr))
                                       (Tstruct _complex noattr)) _im tfloat)
                                   tfloat) tfloat tfloat)))))))))
            (Ssequence
              (Sdo (Eassign (Evar _lambda_c tfloat)
                     (Ebinop Omul
                       (Ebinop Oadd
                         (Ebinop Osub
                           (Ebinop Omul
                             (Ebinop Osub
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                                         (tptr (Tstruct _UtmCoor_f noattr)))
                                       (Tstruct _UtmCoor_f noattr))
                                     (Tstruct _UtmCoor_f noattr)) _zone
                                   tuchar) tuchar)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (Eval (Vint (Int.repr 6)) tint) tint)
                           (Eval (Vint (Int.repr 180)) tint) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Ebinop Odiv
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                         tdouble) tdouble) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                               (tptr (Tstruct _LlaCoor_f noattr)))
                             (Tstruct _LlaCoor_f noattr))
                           (Tstruct _LlaCoor_f noattr)) _lon tfloat)
                       (Ebinop Oadd (Evalof (Evar _lambda_c tfloat) tfloat)
                         (Ecall
                           (Evalof
                             (Evar _atanf (Tfunction (tfloat :: nil) tfloat
                                            cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs
                             (Ebinop Odiv
                               (Ecall
                                 (Evalof
                                   (Evar _sinhf (Tfunction (tfloat :: nil)
                                                  tfloat cc_default))
                                   (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                                 (Econs
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z (Tstruct _complex noattr))
                                         (Tstruct _complex noattr)) _im
                                       tfloat) tfloat) Enil) tfloat)
                               (Ecall
                                 (Evalof
                                   (Evar _cosf (Tfunction (tfloat :: nil)
                                                 tfloat cc_default))
                                   (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                                 (Econs
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z (Tstruct _complex noattr))
                                         (Tstruct _complex noattr)) _re
                                       tfloat) tfloat) Enil) tfloat) tfloat)
                             Enil) tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _phi_ tfloat)
                         (Ecall
                           (Evalof
                             (Evar _asinf (Tfunction (tfloat :: nil) tfloat
                                            cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs
                             (Ebinop Odiv
                               (Ecall
                                 (Evalof
                                   (Evar _sinf (Tfunction (tfloat :: nil)
                                                 tfloat cc_default))
                                   (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                                 (Econs
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z (Tstruct _complex noattr))
                                         (Tstruct _complex noattr)) _re
                                       tfloat) tfloat) Enil) tfloat)
                               (Ecall
                                 (Evalof
                                   (Evar _coshf (Tfunction (tfloat :: nil)
                                                  tfloat cc_default))
                                   (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                                 (Econs
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z (Tstruct _complex noattr))
                                         (Tstruct _complex noattr)) _im
                                       tfloat) tfloat) Enil) tfloat) tfloat)
                             Enil) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _il tfloat)
                           (Ecall
                             (Evalof
                               (Evar _isometric_latitude_fast_f (Tfunction
                                                                  (tfloat ::
                                                                   nil)
                                                                  tfloat
                                                                  cc_default))
                               (Tfunction (tfloat :: nil) tfloat cc_default))
                             (Econs (Evalof (Evar _phi_ tfloat) tfloat) Enil)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                                     (tptr (Tstruct _LlaCoor_f noattr)))
                                   (Tstruct _LlaCoor_f noattr))
                                 (Tstruct _LlaCoor_f noattr)) _lat tfloat)
                             (Ecall
                               (Evalof
                                 (Evar _inverse_isometric_latitude_f 
                                 (Tfunction
                                   (tfloat :: tfloat :: tfloat :: nil) tfloat
                                   cc_default))
                                 (Tfunction
                                   (tfloat :: tfloat :: tfloat :: nil) tfloat
                                   cc_default))
                               (Econs (Evalof (Evar _il tfloat) tfloat)
                                 (Econs
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4590560114717078071))) tdouble)
                                   (Econs
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4487126258331716666))) tdouble)
                                     Enil))) tfloat) tfloat))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _lla (tptr (Tstruct _LlaCoor_f noattr)))
                                     (tptr (Tstruct _LlaCoor_f noattr)))
                                   (Tstruct _LlaCoor_f noattr))
                                 (Tstruct _LlaCoor_f noattr)) _alt tfloat)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _utm (tptr (Tstruct _UtmCoor_f noattr)))
                                       (tptr (Tstruct _UtmCoor_f noattr)))
                                     (Tstruct _UtmCoor_f noattr))
                                   (Tstruct _UtmCoor_f noattr)) _alt tfloat)
                               tfloat) tfloat)))))))))))))
|}.

Definition v_five_keep_ltp_def_from_ecef_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_def_from_ecef_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ltp_def_from_lla_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_def_from_lla_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_ecef_point_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_ecef_point_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_ecef_vect_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_ecef_vect_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_lla_point_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_lla_point_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_lla_point_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_lla_point_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_point_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_point_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_enu_vect_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_enu_vect_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_vect_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_vect_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_isometric_latitude_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _isometric_latitude_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_isometric_latitude_fast_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _isometric_latitude_fast_f (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_inverse_isometric_latitude_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _inverse_isometric_latitude_f (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_utm_of_lla_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _utm_of_lla_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_lla_of_utm_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _lla_of_utm_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _FloatRMat Struct
   (Member_plain _m (tarray tfloat 9) :: nil)
   noattr ::
 Composite _EcefCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _LlaCoor_f Struct
   (Member_plain _lat tfloat :: Member_plain _lon tfloat ::
    Member_plain _alt tfloat :: nil)
   noattr ::
 Composite _NedCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _EnuCoor_f Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _UtmCoor_f Struct
   (Member_plain _north tfloat :: Member_plain _east tfloat ::
    Member_plain _alt tfloat :: Member_plain _zone tuchar :: nil)
   noattr ::
 Composite _LtpDef_f Struct
   (Member_plain _ecef (Tstruct _EcefCoor_f noattr) ::
    Member_plain _lla (Tstruct _LlaCoor_f noattr) ::
    Member_plain _ltp_of_ecef (Tstruct _FloatRMat noattr) ::
    Member_plain _hmsl tfloat :: nil)
   noattr ::
 Composite _DoubleRMat Struct
   (Member_plain _m (tarray tdouble 9) :: nil)
   noattr ::
 Composite _EcefCoor_d Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _complex Struct
   (Member_plain _re tfloat :: Member_plain _im tfloat :: nil)
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
 (_exp,
   Gfun(External (EF_external "exp"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_floor,
   Gfun(External (EF_external "floor"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_asinf,
   Gfun(External (EF_external "asinf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_atanf,
   Gfun(External (EF_external "atanf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_atan2f,
   Gfun(External (EF_external "atan2f"
                   (mksignature (AST.Xsingle :: AST.Xsingle :: nil)
                     AST.Xsingle cc_default)) (tfloat :: tfloat :: nil)
     tfloat cc_default)) ::
 (_cosf,
   Gfun(External (EF_external "cosf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_sinf,
   Gfun(External (EF_external "sinf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_tanf,
   Gfun(External (EF_external "tanf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_coshf,
   Gfun(External (EF_external "coshf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_sinhf,
   Gfun(External (EF_external "sinhf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_expf,
   Gfun(External (EF_external "expf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_logf,
   Gfun(External (EF_external "logf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_powf,
   Gfun(External (EF_external "powf"
                   (mksignature (AST.Xsingle :: AST.Xsingle :: nil)
                     AST.Xsingle cc_default)) (tfloat :: tfloat :: nil)
     tfloat cc_default)) ::
 (_sqrtf,
   Gfun(External (EF_external "sqrtf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_fabsf,
   Gfun(External (EF_external "fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_ltp_def_from_ecef_f, Gfun(Internal f_ltp_def_from_ecef_f)) ::
 (_ltp_def_from_lla_f, Gfun(Internal f_ltp_def_from_lla_f)) ::
 (_enu_of_ecef_point_f, Gfun(Internal f_enu_of_ecef_point_f)) ::
 (_ned_of_ecef_point_f, Gfun(Internal f_ned_of_ecef_point_f)) ::
 (_enu_of_ecef_vect_f, Gfun(Internal f_enu_of_ecef_vect_f)) ::
 (_enu_of_lla_point_f, Gfun(Internal f_enu_of_lla_point_f)) ::
 (_ned_of_lla_point_f, Gfun(Internal f_ned_of_lla_point_f)) ::
 (_ecef_of_enu_point_f, Gfun(Internal f_ecef_of_enu_point_f)) ::
 (_ecef_of_ned_point_f, Gfun(Internal f_ecef_of_ned_point_f)) ::
 (_ecef_of_enu_vect_f, Gfun(Internal f_ecef_of_enu_vect_f)) ::
 (_ecef_of_ned_vect_f, Gfun(Internal f_ecef_of_ned_vect_f)) ::
 (_a, Gvar v_a) :: (_f, Gvar v_f) ::
 (_lla_of_ecef_f, Gfun(Internal f_lla_of_ecef_f)) :: (_a__1, Gvar v_a__1) ::
 (_f__1, Gvar v_f__1) :: (_ecef_of_lla_f, Gfun(Internal f_ecef_of_lla_f)) ::
 (_serie_coeff_proj_mercator, Gvar v_serie_coeff_proj_mercator) ::
 (_serie_coeff_proj_mercator_inverse, Gvar v_serie_coeff_proj_mercator_inverse) ::
 (_isometric_latitude_f, Gfun(Internal f_isometric_latitude_f)) ::
 (_isometric_latitude_fast_f, Gfun(Internal f_isometric_latitude_fast_f)) ::
 (_inverse_isometric_latitude_f, Gfun(Internal f_inverse_isometric_latitude_f)) ::
 (_utm_of_lla_f, Gfun(Internal f_utm_of_lla_f)) ::
 (_lla_of_utm_f, Gfun(Internal f_lla_of_utm_f)) ::
 (_five_keep_ltp_def_from_ecef_f, Gvar v_five_keep_ltp_def_from_ecef_f) ::
 (_five_keep_ltp_def_from_lla_f, Gvar v_five_keep_ltp_def_from_lla_f) ::
 (_five_keep_ned_of_ecef_point_f, Gvar v_five_keep_ned_of_ecef_point_f) ::
 (_five_keep_enu_of_ecef_vect_f, Gvar v_five_keep_enu_of_ecef_vect_f) ::
 (_five_keep_enu_of_lla_point_f, Gvar v_five_keep_enu_of_lla_point_f) ::
 (_five_keep_ned_of_lla_point_f, Gvar v_five_keep_ned_of_lla_point_f) ::
 (_five_keep_ecef_of_ned_point_f, Gvar v_five_keep_ecef_of_ned_point_f) ::
 (_five_keep_ecef_of_enu_vect_f, Gvar v_five_keep_ecef_of_enu_vect_f) ::
 (_five_keep_ecef_of_ned_vect_f, Gvar v_five_keep_ecef_of_ned_vect_f) ::
 (_five_keep_isometric_latitude_f, Gvar v_five_keep_isometric_latitude_f) ::
 (_five_keep_isometric_latitude_fast_f, Gvar v_five_keep_isometric_latitude_fast_f) ::
 (_five_keep_inverse_isometric_latitude_f, Gvar v_five_keep_inverse_isometric_latitude_f) ::
 (_five_keep_utm_of_lla_f, Gvar v_five_keep_utm_of_lla_f) ::
 (_five_keep_lla_of_utm_f, Gvar v_five_keep_lla_of_utm_f) :: nil).

Definition public_idents : list ident :=
(_five_keep_lla_of_utm_f :: _five_keep_utm_of_lla_f ::
 _five_keep_inverse_isometric_latitude_f ::
 _five_keep_isometric_latitude_fast_f :: _five_keep_isometric_latitude_f ::
 _five_keep_ecef_of_ned_vect_f :: _five_keep_ecef_of_enu_vect_f ::
 _five_keep_ecef_of_ned_point_f :: _five_keep_ned_of_lla_point_f ::
 _five_keep_enu_of_lla_point_f :: _five_keep_enu_of_ecef_vect_f ::
 _five_keep_ned_of_ecef_point_f :: _five_keep_ltp_def_from_lla_f ::
 _five_keep_ltp_def_from_ecef_f :: _lla_of_utm_f :: _utm_of_lla_f ::
 _ecef_of_lla_f :: _lla_of_ecef_f :: _ecef_of_ned_vect_f ::
 _ecef_of_enu_vect_f :: _ecef_of_ned_point_f :: _ecef_of_enu_point_f ::
 _ned_of_lla_point_f :: _enu_of_lla_point_f :: _enu_of_ecef_vect_f ::
 _ned_of_ecef_point_f :: _enu_of_ecef_point_f :: _ltp_def_from_lla_f ::
 _ltp_def_from_ecef_f :: _fabsf :: _sqrtf :: _powf :: _logf :: _expf ::
 _sinhf :: _coshf :: _tanf :: _sinf :: _cosf :: _atan2f :: _atanf ::
 _asinf :: _floor :: _exp :: ___builtin_debug ::
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


