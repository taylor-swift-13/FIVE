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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/model/preprocessed.i".
End Info.

Definition _DoubleRMat : ident := $"DoubleRMat".
Definition _DoubleVect2 : ident := $"DoubleVect2".
Definition _E2 : ident := $"E2".
Definition _EcefCoor_d : ident := $"EcefCoor_d".
Definition _EnuCoor_d : ident := $"EnuCoor_d".
Definition _F : ident := $"F".
Definition _G : ident := $"G".
Definition _LlaCoor_d : ident := $"LlaCoor_d".
Definition _LtpDef_d : ident := $"LtpDef_d".
Definition _NedCoor_d : ident := $"NedCoor_d".
Definition _P : ident := $"P".
Definition _Q : ident := $"Q".
Definition _U : ident := $"U".
Definition _UtmCoor_d : ident := $"UtmCoor_d".
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
Definition _a : ident := $"a".
Definition _a__1 : ident := $"a__1".
Definition _a__2 : ident := $"a__2".
Definition _a_chi : ident := $"a_chi".
Definition _alt : ident := $"alt".
Definition _asin : ident := $"asin".
Definition _atan : ident := $"atan".
Definition _atan2 : ident := $"atan2".
Definition _b : ident := $"b".
Definition _b2 : ident := $"b2".
Definition _c : ident := $"c".
Definition _c2 : ident := $"c2".
Definition _chi : ident := $"chi".
Definition _cos : ident := $"cos".
Definition _cos_lat : ident := $"cos_lat".
Definition _cos_lon : ident := $"cos_lon".
Definition _cosh : ident := $"cosh".
Definition _def : ident := $"def".
Definition _delta : ident := $"delta".
Definition _dl : ident := $"dl".
Definition _e : ident := $"e".
Definition _e2 : ident := $"e2".
Definition _e__1 : ident := $"e__1".
Definition _east : ident := $"east".
Definition _ecef : ident := $"ecef".
Definition _ecef_of_enu_point_d : ident := $"ecef_of_enu_point_d".
Definition _ecef_of_enu_vect_d : ident := $"ecef_of_enu_vect_d".
Definition _ecef_of_lla_d : ident := $"ecef_of_lla_d".
Definition _ecef_of_ned_point_d : ident := $"ecef_of_ned_point_d".
Definition _ecef_of_ned_vect_d : ident := $"ecef_of_ned_vect_d".
Definition _enu : ident := $"enu".
Definition _enu_of_ecef_point_d : ident := $"enu_of_ecef_point_d".
Definition _enu_of_ecef_vect_d : ident := $"enu_of_ecef_vect_d".
Definition _enu_of_lla_point_d : ident := $"enu_of_lla_point_d".
Definition _ep2 : ident := $"ep2".
Definition _epsilon : ident := $"epsilon".
Definition _exp : ident := $"exp".
Definition _exp_l : ident := $"exp_l".
Definition _f : ident := $"f".
Definition _f__1 : ident := $"f__1".
Definition _f__2 : ident := $"f__2".
Definition _fabs : ident := $"fabs".
Definition _five_keep_ecef_of_enu_point_d : ident := $"five_keep_ecef_of_enu_point_d".
Definition _five_keep_ecef_of_enu_vect_d : ident := $"five_keep_ecef_of_enu_vect_d".
Definition _five_keep_ecef_of_lla_d : ident := $"five_keep_ecef_of_lla_d".
Definition _five_keep_ecef_of_ned_point_d : ident := $"five_keep_ecef_of_ned_point_d".
Definition _five_keep_ecef_of_ned_vect_d : ident := $"five_keep_ecef_of_ned_vect_d".
Definition _five_keep_enu_of_ecef_point_d : ident := $"five_keep_enu_of_ecef_point_d".
Definition _five_keep_enu_of_ecef_vect_d : ident := $"five_keep_enu_of_ecef_vect_d".
Definition _five_keep_enu_of_lla_point_d : ident := $"five_keep_enu_of_lla_point_d".
Definition _five_keep_gc_of_gd_lat_d : ident := $"five_keep_gc_of_gd_lat_d".
Definition _five_keep_inverse_isometric_latitude_d : ident := $"five_keep_inverse_isometric_latitude_d".
Definition _five_keep_isometric_latitude_d : ident := $"five_keep_isometric_latitude_d".
Definition _five_keep_isometric_latitude_fast_d : ident := $"five_keep_isometric_latitude_fast_d".
Definition _five_keep_lla_of_ecef_d : ident := $"five_keep_lla_of_ecef_d".
Definition _five_keep_lla_of_utm_d : ident := $"five_keep_lla_of_utm_d".
Definition _five_keep_ltp_def_from_ecef_d : ident := $"five_keep_ltp_def_from_ecef_d".
Definition _five_keep_ltp_def_from_lla_d : ident := $"five_keep_ltp_def_from_lla_d".
Definition _five_keep_ned_of_ecef_point_d : ident := $"five_keep_ned_of_ecef_point_d".
Definition _five_keep_ned_of_ecef_vect_d : ident := $"five_keep_ned_of_ecef_vect_d".
Definition _five_keep_ned_of_lla_point_d : ident := $"five_keep_ned_of_lla_point_d".
Definition _five_keep_utm_of_lla_d : ident := $"five_keep_utm_of_lla_d".
Definition _floor : ident := $"floor".
Definition _gc_of_gd_lat_d : ident := $"gc_of_gd_lat_d".
Definition _gd_lat : ident := $"gd_lat".
Definition _hmsl : ident := $"hmsl".
Definition _il : ident := $"il".
Definition _inverse_isometric_latitude_d : ident := $"inverse_isometric_latitude_d".
Definition _isometric_latitude_d : ident := $"isometric_latitude_d".
Definition _isometric_latitude_fast_d : ident := $"isometric_latitude_fast_d".
Definition _k : ident := $"k".
Definition _lambda_ : ident := $"lambda_".
Definition _lambda_c : ident := $"lambda_c".
Definition _lat : ident := $"lat".
Definition _ll : ident := $"ll".
Definition _ll_ : ident := $"ll_".
Definition _lla : ident := $"lla".
Definition _lla_of_ecef_d : ident := $"lla_of_ecef_d".
Definition _lla_of_utm_d : ident := $"lla_of_utm_d".
Definition _log : ident := $"log".
Definition _lon : ident := $"lon".
Definition _ls : ident := $"ls".
Definition _ltp_def_from_ecef_d : ident := $"ltp_def_from_ecef_d".
Definition _ltp_def_from_lla_d : ident := $"ltp_def_from_lla_d".
Definition _ltp_of_ecef : ident := $"ltp_of_ecef".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _max_iter : ident := $"max_iter".
Definition _ned : ident := $"ned".
Definition _ned_of_ecef_point_d : ident := $"ned_of_ecef_point_d".
Definition _ned_of_ecef_vect_d : ident := $"ned_of_ecef_vect_d".
Definition _ned_of_lla_point_d : ident := $"ned_of_lla_point_d".
Definition _north : ident := $"north".
Definition _phi : ident := $"phi".
Definition _phi0 : ident := $"phi0".
Definition _phi_ : ident := $"phi_".
Definition _pow : ident := $"pow".
Definition _r : ident := $"r".
Definition _r2 : ident := $"r2".
Definition _ro : ident := $"ro".
Definition _s : ident := $"s".
Definition _s1 : ident := $"s1".
Definition _scale : ident := $"scale".
Definition _serie_coeff_proj_mercator : ident := $"serie_coeff_proj_mercator".
Definition _serie_coeff_proj_mercator_inverse : ident := $"serie_coeff_proj_mercator_inverse".
Definition _sin : ident := $"sin".
Definition _sin_lat : ident := $"sin_lat".
Definition _sin_lon : ident := $"sin_lon".
Definition _sin_phi : ident := $"sin_phi".
Definition _sinh : ident := $"sinh".
Definition _sqrt : ident := $"sqrt".
Definition _tan : ident := $"tan".
Definition _tmp : ident := $"tmp".
Definition _tmp__1 : ident := $"tmp__1".
Definition _utm : ident := $"utm".
Definition _utm_of_lla_d : ident := $"utm_of_lla_d".
Definition _vstar : ident := $"vstar".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".
Definition _z2 : ident := $"z2".
Definition _z_ : ident := $"z_".
Definition _zo : ident := $"zo".
Definition _zone : ident := $"zone".

Definition f_ltp_def_from_ecef_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_d noattr))) :: nil);
  fn_vars := ((_sin_lat, tdouble) :: (_cos_lat, tdouble) ::
              (_sin_lon, tdouble) :: (_cos_lon, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                       (tptr (Tstruct _LtpDef_d noattr)))
                     (Tstruct _LtpDef_d noattr)) (Tstruct _LtpDef_d noattr))
                 _ecef (Tstruct _EcefCoor_d noattr))
               (Tstruct _EcefCoor_d noattr)) _x tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                     (tptr (Tstruct _EcefCoor_d noattr)))
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _ecef
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _y tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                       (tptr (Tstruct _EcefCoor_d noattr)))
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
             tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _ecef
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _z tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                       (tptr (Tstruct _EcefCoor_d noattr)))
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
             tdouble))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _lla_of_ecef_d (Tfunction
                                    ((tptr (Tstruct _LlaCoor_d noattr)) ::
                                     (tptr (Tstruct _EcefCoor_d noattr)) ::
                                     nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _LlaCoor_d noattr)) ::
                (tptr (Tstruct _EcefCoor_d noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                       (tptr (Tstruct _LtpDef_d noattr)))
                     (Tstruct _LtpDef_d noattr)) (Tstruct _LtpDef_d noattr))
                 _lla (Tstruct _LlaCoor_d noattr))
               (tptr (Tstruct _LlaCoor_d noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _ecef
                   (Tstruct _EcefCoor_d noattr))
                 (tptr (Tstruct _EcefCoor_d noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign (Evar _sin_lat tdouble)
             (Ecall
               (Evalof
                 (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Tfunction (tdouble :: nil) tdouble cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                               (tptr (Tstruct _LtpDef_d noattr)))
                             (Tstruct _LtpDef_d noattr))
                           (Tstruct _LtpDef_d noattr)) _lla
                         (Tstruct _LlaCoor_d noattr))
                       (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                 Enil) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _cos_lat tdouble)
               (Ecall
                 (Evalof
                   (Evar _cos (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                 (tptr (Tstruct _LtpDef_d noattr)))
                               (Tstruct _LtpDef_d noattr))
                             (Tstruct _LtpDef_d noattr)) _lla
                           (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                   Enil) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _sin_lon tdouble)
                 (Ecall
                   (Evalof
                     (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _lla
                             (Tstruct _LlaCoor_d noattr))
                           (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                       tdouble) Enil) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _cos_lon tdouble)
                   (Ecall
                     (Evalof
                       (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                    cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _lla
                               (Tstruct _LlaCoor_d noattr))
                             (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                         tdouble) Enil) tdouble) tdouble))
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tdouble))
                       tdouble)
                     (Eunop Oneg (Evalof (Evar _sin_lon tdouble) tdouble)
                       tdouble) tdouble))
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
                                         (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                         (tptr (Tstruct _LtpDef_d noattr)))
                                       (Tstruct _LtpDef_d noattr))
                                     (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                         tdouble) (Evalof (Evar _cos_lon tdouble) tdouble)
                       tdouble))
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
                                           (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                           (tptr (Tstruct _LtpDef_d noattr)))
                                         (Tstruct _LtpDef_d noattr))
                                       (Tstruct _LtpDef_d noattr))
                                     _ltp_of_ecef
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tdouble))
                           tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                         tdouble))
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
                                             (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                             (tptr (Tstruct _LtpDef_d noattr)))
                                           (Tstruct _LtpDef_d noattr))
                                         (Tstruct _LtpDef_d noattr))
                                       _ltp_of_ecef
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 3)) tint)
                               (tptr tdouble)) tdouble)
                           (Ebinop Omul
                             (Eunop Oneg
                               (Evalof (Evar _sin_lat tdouble) tdouble)
                               tdouble)
                             (Evalof (Evar _cos_lon tdouble) tdouble)
                             tdouble) tdouble))
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
                                               (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                               (tptr (Tstruct _LtpDef_d noattr)))
                                             (Tstruct _LtpDef_d noattr))
                                           (Tstruct _LtpDef_d noattr))
                                         _ltp_of_ecef
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr tdouble)) tdouble)
                             (Ebinop Omul
                               (Eunop Oneg
                                 (Evalof (Evar _sin_lat tdouble) tdouble)
                                 tdouble)
                               (Evalof (Evar _sin_lon tdouble) tdouble)
                               tdouble) tdouble))
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
                                                 (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                 (tptr (Tstruct _LtpDef_d noattr)))
                                               (Tstruct _LtpDef_d noattr))
                                             (Tstruct _LtpDef_d noattr))
                                           _ltp_of_ecef
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tdouble)) tdouble)
                               (Evalof (Evar _cos_lat tdouble) tdouble)
                               tdouble))
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
                                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                   (tptr (Tstruct _LtpDef_d noattr)))
                                                 (Tstruct _LtpDef_d noattr))
                                               (Tstruct _LtpDef_d noattr))
                                             _ltp_of_ecef
                                             (Tstruct _DoubleRMat noattr))
                                           (Tstruct _DoubleRMat noattr)) _m
                                         (tarray tdouble 9))
                                       (tarray tdouble 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tdouble)) tdouble)
                                 (Ebinop Omul
                                   (Evalof (Evar _cos_lat tdouble) tdouble)
                                   (Evalof (Evar _cos_lon tdouble) tdouble)
                                   tdouble) tdouble))
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
                                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                     (tptr (Tstruct _LtpDef_d noattr)))
                                                   (Tstruct _LtpDef_d noattr))
                                                 (Tstruct _LtpDef_d noattr))
                                               _ltp_of_ecef
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tdouble)) tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _cos_lat tdouble) tdouble)
                                     (Evalof (Evar _sin_lon tdouble) tdouble)
                                     tdouble) tdouble))
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
                                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                     (tptr (Tstruct _LtpDef_d noattr)))
                                                   (Tstruct _LtpDef_d noattr))
                                                 (Tstruct _LtpDef_d noattr))
                                               _ltp_of_ecef
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Eval (Vint (Int.repr 8)) tint)
                                       (tptr tdouble)) tdouble)
                                   (Evalof (Evar _sin_lat tdouble) tdouble)
                                   tdouble))))))))))))))))
|}.

Definition f_ltp_def_from_lla_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_d noattr))) :: nil);
  fn_vars := ((_sin_lat, tdouble) :: (_cos_lat, tdouble) ::
              (_sin_lon, tdouble) :: (_cos_lon, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                       (tptr (Tstruct _LtpDef_d noattr)))
                     (Tstruct _LtpDef_d noattr)) (Tstruct _LtpDef_d noattr))
                 _lla (Tstruct _LlaCoor_d noattr))
               (Tstruct _LlaCoor_d noattr)) _lat tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                     (tptr (Tstruct _LlaCoor_d noattr)))
                   (Tstruct _LlaCoor_d noattr)) (Tstruct _LlaCoor_d noattr))
               _lat tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _lla
                   (Tstruct _LlaCoor_d noattr)) (Tstruct _LlaCoor_d noattr))
               _lon tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                       (tptr (Tstruct _LlaCoor_d noattr)))
                     (Tstruct _LlaCoor_d noattr))
                   (Tstruct _LlaCoor_d noattr)) _lon tdouble) tdouble)
             tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _lla
                   (Tstruct _LlaCoor_d noattr)) (Tstruct _LlaCoor_d noattr))
               _alt tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                       (tptr (Tstruct _LlaCoor_d noattr)))
                     (Tstruct _LlaCoor_d noattr))
                   (Tstruct _LlaCoor_d noattr)) _alt tdouble) tdouble)
             tdouble))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _ecef_of_lla_d (Tfunction
                                    ((tptr (Tstruct _EcefCoor_d noattr)) ::
                                     (tptr (Tstruct _LlaCoor_d noattr)) ::
                                     nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _EcefCoor_d noattr)) ::
                (tptr (Tstruct _LlaCoor_d noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                       (tptr (Tstruct _LtpDef_d noattr)))
                     (Tstruct _LtpDef_d noattr)) (Tstruct _LtpDef_d noattr))
                 _ecef (Tstruct _EcefCoor_d noattr))
               (tptr (Tstruct _EcefCoor_d noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _lla
                   (Tstruct _LlaCoor_d noattr))
                 (tptr (Tstruct _LlaCoor_d noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign (Evar _sin_lat tdouble)
             (Ecall
               (Evalof
                 (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Tfunction (tdouble :: nil) tdouble cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                               (tptr (Tstruct _LtpDef_d noattr)))
                             (Tstruct _LtpDef_d noattr))
                           (Tstruct _LtpDef_d noattr)) _lla
                         (Tstruct _LlaCoor_d noattr))
                       (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                 Enil) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _cos_lat tdouble)
               (Ecall
                 (Evalof
                   (Evar _cos (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                 (tptr (Tstruct _LtpDef_d noattr)))
                               (Tstruct _LtpDef_d noattr))
                             (Tstruct _LtpDef_d noattr)) _lla
                           (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                   Enil) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _sin_lon tdouble)
                 (Ecall
                   (Evalof
                     (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _lla
                             (Tstruct _LlaCoor_d noattr))
                           (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                       tdouble) Enil) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _cos_lon tdouble)
                   (Ecall
                     (Evalof
                       (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                    cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _lla
                               (Tstruct _LlaCoor_d noattr))
                             (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                         tdouble) Enil) tdouble) tdouble))
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tdouble))
                       tdouble)
                     (Eunop Oneg (Evalof (Evar _sin_lon tdouble) tdouble)
                       tdouble) tdouble))
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
                                         (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                         (tptr (Tstruct _LtpDef_d noattr)))
                                       (Tstruct _LtpDef_d noattr))
                                     (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                         tdouble) (Evalof (Evar _cos_lon tdouble) tdouble)
                       tdouble))
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
                                           (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                           (tptr (Tstruct _LtpDef_d noattr)))
                                         (Tstruct _LtpDef_d noattr))
                                       (Tstruct _LtpDef_d noattr))
                                     _ltp_of_ecef
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tdouble))
                           tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                         tdouble))
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
                                             (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                             (tptr (Tstruct _LtpDef_d noattr)))
                                           (Tstruct _LtpDef_d noattr))
                                         (Tstruct _LtpDef_d noattr))
                                       _ltp_of_ecef
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 3)) tint)
                               (tptr tdouble)) tdouble)
                           (Ebinop Omul
                             (Eunop Oneg
                               (Evalof (Evar _sin_lat tdouble) tdouble)
                               tdouble)
                             (Evalof (Evar _cos_lon tdouble) tdouble)
                             tdouble) tdouble))
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
                                               (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                               (tptr (Tstruct _LtpDef_d noattr)))
                                             (Tstruct _LtpDef_d noattr))
                                           (Tstruct _LtpDef_d noattr))
                                         _ltp_of_ecef
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr tdouble)) tdouble)
                             (Ebinop Omul
                               (Eunop Oneg
                                 (Evalof (Evar _sin_lat tdouble) tdouble)
                                 tdouble)
                               (Evalof (Evar _sin_lon tdouble) tdouble)
                               tdouble) tdouble))
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
                                                 (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                 (tptr (Tstruct _LtpDef_d noattr)))
                                               (Tstruct _LtpDef_d noattr))
                                             (Tstruct _LtpDef_d noattr))
                                           _ltp_of_ecef
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tdouble)) tdouble)
                               (Evalof (Evar _cos_lat tdouble) tdouble)
                               tdouble))
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
                                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                   (tptr (Tstruct _LtpDef_d noattr)))
                                                 (Tstruct _LtpDef_d noattr))
                                               (Tstruct _LtpDef_d noattr))
                                             _ltp_of_ecef
                                             (Tstruct _DoubleRMat noattr))
                                           (Tstruct _DoubleRMat noattr)) _m
                                         (tarray tdouble 9))
                                       (tarray tdouble 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tdouble)) tdouble)
                                 (Ebinop Omul
                                   (Evalof (Evar _cos_lat tdouble) tdouble)
                                   (Evalof (Evar _cos_lon tdouble) tdouble)
                                   tdouble) tdouble))
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
                                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                     (tptr (Tstruct _LtpDef_d noattr)))
                                                   (Tstruct _LtpDef_d noattr))
                                                 (Tstruct _LtpDef_d noattr))
                                               _ltp_of_ecef
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tdouble)) tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _cos_lat tdouble) tdouble)
                                     (Evalof (Evar _sin_lon tdouble) tdouble)
                                     tdouble) tdouble))
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
                                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                                     (tptr (Tstruct _LtpDef_d noattr)))
                                                   (Tstruct _LtpDef_d noattr))
                                                 (Tstruct _LtpDef_d noattr))
                                               _ltp_of_ecef
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Eval (Vint (Int.repr 8)) tint)
                                       (tptr tdouble)) tdouble)
                                   (Evalof (Evar _sin_lat tdouble) tdouble)
                                   tdouble))))))))))))))))
|}.

Definition v_a := {|
  gvar_info := tdouble;
  gvar_init := (Init_float64 (Float.of_bits (Int64.repr 4708606483430899712)) ::
                nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_f := {|
  gvar_info := tdouble;
  gvar_init := (Init_float64 (Float.of_bits (Int64.repr 4569877477558837544)) ::
                nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_lla_of_ecef_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_lla, (tptr (Tstruct _LlaCoor_d noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_d noattr))) :: nil);
  fn_vars := ((_b, tdouble) :: (_b2, tdouble) :: (_e2, tdouble) ::
              (_ep2, tdouble) :: (_E2, tdouble) :: (_z2, tdouble) ::
              (_r2, tdouble) :: (_r, tdouble) :: (_F, tdouble) ::
              (_G, tdouble) :: (_c, tdouble) :: (_s, tdouble) ::
              (_s1, tdouble) :: (_P, tdouble) :: (_Q, tdouble) ::
              (_ro, tdouble) :: (_tmp, tdouble) :: (_U, tdouble) ::
              (_V, tdouble) :: (_zo, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _b tdouble)
         (Ebinop Omul (Evalof (Evar _a tdouble) tdouble)
           (Ebinop Osub
             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
             (Evalof (Evar _f tdouble) tdouble) tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _b2 tdouble)
           (Ebinop Omul (Evalof (Evar _b tdouble) tdouble)
             (Evalof (Evar _b tdouble) tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _e2 tdouble)
             (Ebinop Osub
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                 (Evalof (Evar _f tdouble) tdouble) tdouble)
               (Ebinop Omul (Evalof (Evar _f tdouble) tdouble)
                 (Evalof (Evar _f tdouble) tdouble) tdouble) tdouble)
             tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _ep2 tdouble)
               (Ebinop Odiv
                 (Ebinop Omul (Evalof (Evar _f tdouble) tdouble)
                   (Ebinop Osub
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     (Evalof (Evar _f tdouble) tdouble) tdouble) tdouble)
                 (Ebinop Omul
                   (Ebinop Osub
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Evalof (Evar _f tdouble) tdouble) tdouble)
                   (Ebinop Osub
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Evalof (Evar _f tdouble) tdouble) tdouble) tdouble)
                 tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _E2 tdouble)
                 (Ebinop Osub
                   (Ebinop Omul (Evalof (Evar _a tdouble) tdouble)
                     (Evalof (Evar _a tdouble) tdouble) tdouble)
                   (Evalof (Evar _b2 tdouble) tdouble) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _z2 tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                               (tptr (Tstruct _EcefCoor_d noattr)))
                             (Tstruct _EcefCoor_d noattr))
                           (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                               (tptr (Tstruct _EcefCoor_d noattr)))
                             (Tstruct _EcefCoor_d noattr))
                           (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
                     tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _r2 tdouble)
                     (Ebinop Oadd
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                   (tptr (Tstruct _EcefCoor_d noattr)))
                                 (Tstruct _EcefCoor_d noattr))
                               (Tstruct _EcefCoor_d noattr)) _x tdouble)
                           tdouble)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                   (tptr (Tstruct _EcefCoor_d noattr)))
                                 (Tstruct _EcefCoor_d noattr))
                               (Tstruct _EcefCoor_d noattr)) _x tdouble)
                           tdouble) tdouble)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                   (tptr (Tstruct _EcefCoor_d noattr)))
                                 (Tstruct _EcefCoor_d noattr))
                               (Tstruct _EcefCoor_d noattr)) _y tdouble)
                           tdouble)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                   (tptr (Tstruct _EcefCoor_d noattr)))
                                 (Tstruct _EcefCoor_d noattr))
                               (Tstruct _EcefCoor_d noattr)) _y tdouble)
                           tdouble) tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _r tdouble)
                       (Ecall
                         (Evalof
                           (Evar _sqrt (Tfunction (tdouble :: nil) tdouble
                                         cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs (Evalof (Evar _r2 tdouble) tdouble) Enil)
                         tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _F tdouble)
                         (Ebinop Omul
                           (Ebinop Omul
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4632796641680687104))) tdouble)
                             (Evalof (Evar _b2 tdouble) tdouble) tdouble)
                           (Evalof (Evar _z2 tdouble) tdouble) tdouble)
                         tdouble))
                  (Ssequence
                    (Sdo (Eassign (Evar _G tdouble)
                           (Ebinop Osub
                             (Ebinop Oadd (Evalof (Evar _r2 tdouble) tdouble)
                               (Ebinop Omul
                                 (Ebinop Osub (Eval (Vint (Int.repr 1)) tint)
                                   (Evalof (Evar _e2 tdouble) tdouble)
                                   tdouble)
                                 (Evalof (Evar _z2 tdouble) tdouble) tdouble)
                               tdouble)
                             (Ebinop Omul (Evalof (Evar _e2 tdouble) tdouble)
                               (Evalof (Evar _E2 tdouble) tdouble) tdouble)
                             tdouble) tdouble))
                    (Ssequence
                      (Sdo (Eassign (Evar _c tdouble)
                             (Ebinop Odiv
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _e2 tdouble) tdouble)
                                     (Evalof (Evar _e2 tdouble) tdouble)
                                     tdouble)
                                   (Evalof (Evar _F tdouble) tdouble)
                                   tdouble)
                                 (Evalof (Evar _r2 tdouble) tdouble) tdouble)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _G tdouble) tdouble)
                                   (Evalof (Evar _G tdouble) tdouble)
                                   tdouble)
                                 (Evalof (Evar _G tdouble) tdouble) tdouble)
                               tdouble) tdouble))
                      (Ssequence
                        (Sdo (Eassign (Evar _s tdouble)
                               (Ecall
                                 (Evalof
                                   (Evar _pow (Tfunction
                                                (tdouble :: tdouble :: nil)
                                                tdouble cc_default))
                                   (Tfunction (tdouble :: tdouble :: nil)
                                     tdouble cc_default))
                                 (Econs
                                   (Ebinop Oadd
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Evalof (Evar _c tdouble) tdouble)
                                       tdouble)
                                     (Ecall
                                       (Evalof
                                         (Evar _sqrt (Tfunction
                                                       (tdouble :: nil)
                                                       tdouble cc_default))
                                         (Tfunction (tdouble :: nil) tdouble
                                           cc_default))
                                       (Econs
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _c tdouble)
                                               tdouble)
                                             (Evalof (Evar _c tdouble)
                                               tdouble) tdouble)
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Evalof (Evar _c tdouble)
                                               tdouble) tdouble) tdouble)
                                         Enil) tdouble) tdouble)
                                   (Econs
                                     (Ebinop Odiv
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4613937818241073152))) tdouble)
                                       tdouble) Enil)) tdouble) tdouble))
                        (Ssequence
                          (Sdo (Eassign (Evar _s1 tdouble)
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Evalof (Evar _s tdouble) tdouble)
                                     tdouble)
                                   (Ebinop Odiv
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Evalof (Evar _s tdouble) tdouble)
                                     tdouble) tdouble) tdouble))
                          (Ssequence
                            (Sdo (Eassign (Evar _P tdouble)
                                   (Ebinop Odiv
                                     (Evalof (Evar _F tdouble) tdouble)
                                     (Ebinop Omul
                                       (Ebinop Omul
                                         (Ebinop Omul
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 3)) tint)
                                             (Evalof (Evar _s1 tdouble)
                                               tdouble) tdouble)
                                           (Evalof (Evar _s1 tdouble)
                                             tdouble) tdouble)
                                         (Evalof (Evar _G tdouble) tdouble)
                                         tdouble)
                                       (Evalof (Evar _G tdouble) tdouble)
                                       tdouble) tdouble) tdouble))
                            (Ssequence
                              (Sdo (Eassign (Evar _Q tdouble)
                                     (Ecall
                                       (Evalof
                                         (Evar _sqrt (Tfunction
                                                       (tdouble :: nil)
                                                       tdouble cc_default))
                                         (Tfunction (tdouble :: nil) tdouble
                                           cc_default))
                                       (Econs
                                         (Ebinop Oadd
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Ebinop Omul
                                             (Ebinop Omul
                                               (Ebinop Omul
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 (Evalof (Evar _e2 tdouble)
                                                   tdouble) tdouble)
                                               (Evalof (Evar _e2 tdouble)
                                                 tdouble) tdouble)
                                             (Evalof (Evar _P tdouble)
                                               tdouble) tdouble) tdouble)
                                         Enil) tdouble) tdouble))
                              (Ssequence
                                (Sdo (Eassign (Evar _ro tdouble)
                                       (Ebinop Oadd
                                         (Ebinop Odiv
                                           (Eunop Oneg
                                             (Ebinop Omul
                                               (Ebinop Omul
                                                 (Evalof (Evar _e2 tdouble)
                                                   tdouble)
                                                 (Evalof (Evar _P tdouble)
                                                   tdouble) tdouble)
                                               (Evalof (Evar _r tdouble)
                                                 tdouble) tdouble) tdouble)
                                           (Ebinop Oadd
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Evalof (Evar _Q tdouble)
                                               tdouble) tdouble) tdouble)
                                         (Ecall
                                           (Evalof
                                             (Evar _sqrt (Tfunction
                                                           (tdouble :: nil)
                                                           tdouble
                                                           cc_default))
                                             (Tfunction (tdouble :: nil)
                                               tdouble cc_default))
                                           (Econs
                                             (Ebinop Osub
                                               (Ebinop Osub
                                                 (Ebinop Omul
                                                   (Ebinop Odiv
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _a tdouble)
                                                         tdouble)
                                                       (Evalof
                                                         (Evar _a tdouble)
                                                         tdouble) tdouble)
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     tdouble)
                                                   (Ebinop Oadd
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Ebinop Odiv
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (Evalof
                                                         (Evar _Q tdouble)
                                                         tdouble) tdouble)
                                                     tdouble) tdouble)
                                                 (Ebinop Odiv
                                                   (Ebinop Omul
                                                     (Ebinop Omul
                                                       (Ebinop Osub
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         (Evalof
                                                           (Evar _e2 tdouble)
                                                           tdouble) tdouble)
                                                       (Evalof
                                                         (Evar _P tdouble)
                                                         tdouble) tdouble)
                                                     (Evalof
                                                       (Evar _z2 tdouble)
                                                       tdouble) tdouble)
                                                   (Ebinop Omul
                                                     (Evalof
                                                       (Evar _Q tdouble)
                                                       tdouble)
                                                     (Ebinop Oadd
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (Evalof
                                                         (Evar _Q tdouble)
                                                         tdouble) tdouble)
                                                     tdouble) tdouble)
                                                 tdouble)
                                               (Ebinop Odiv
                                                 (Ebinop Omul
                                                   (Evalof (Evar _P tdouble)
                                                     tdouble)
                                                   (Evalof (Evar _r2 tdouble)
                                                     tdouble) tdouble)
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 tdouble) tdouble) Enil)
                                           tdouble) tdouble) tdouble))
                                (Ssequence
                                  (Sdo (Eassign (Evar _tmp tdouble)
                                         (Ebinop Omul
                                           (Ebinop Osub
                                             (Evalof (Evar _r tdouble)
                                               tdouble)
                                             (Ebinop Omul
                                               (Evalof (Evar _e2 tdouble)
                                                 tdouble)
                                               (Evalof (Evar _ro tdouble)
                                                 tdouble) tdouble) tdouble)
                                           (Ebinop Osub
                                             (Evalof (Evar _r tdouble)
                                               tdouble)
                                             (Ebinop Omul
                                               (Evalof (Evar _e2 tdouble)
                                                 tdouble)
                                               (Evalof (Evar _ro tdouble)
                                                 tdouble) tdouble) tdouble)
                                           tdouble) tdouble))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _U tdouble)
                                           (Ecall
                                             (Evalof
                                               (Evar _sqrt (Tfunction
                                                             (tdouble :: nil)
                                                             tdouble
                                                             cc_default))
                                               (Tfunction (tdouble :: nil)
                                                 tdouble cc_default))
                                             (Econs
                                               (Ebinop Oadd
                                                 (Evalof (Evar _tmp tdouble)
                                                   tdouble)
                                                 (Evalof (Evar _z2 tdouble)
                                                   tdouble) tdouble) Enil)
                                             tdouble) tdouble))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _V tdouble)
                                             (Ecall
                                               (Evalof
                                                 (Evar _sqrt (Tfunction
                                                               (tdouble ::
                                                                nil) tdouble
                                                               cc_default))
                                                 (Tfunction (tdouble :: nil)
                                                   tdouble cc_default))
                                               (Econs
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _tmp tdouble)
                                                     tdouble)
                                                   (Ebinop Omul
                                                     (Ebinop Osub
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (Evalof
                                                         (Evar _e2 tdouble)
                                                         tdouble) tdouble)
                                                     (Evalof
                                                       (Evar _z2 tdouble)
                                                       tdouble) tdouble)
                                                   tdouble) Enil) tdouble)
                                             tdouble))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _zo tdouble)
                                               (Ebinop Odiv
                                                 (Ebinop Omul
                                                   (Evalof (Evar _b2 tdouble)
                                                     tdouble)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                                             (tptr (Tstruct _EcefCoor_d noattr)))
                                                           (Tstruct _EcefCoor_d noattr))
                                                         (Tstruct _EcefCoor_d noattr))
                                                       _z tdouble) tdouble)
                                                   tdouble)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _a tdouble)
                                                     tdouble)
                                                   (Evalof (Evar _V tdouble)
                                                     tdouble) tdouble)
                                                 tdouble) tdouble))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                                         (tptr (Tstruct _LlaCoor_d noattr)))
                                                       (Tstruct _LlaCoor_d noattr))
                                                     (Tstruct _LlaCoor_d noattr))
                                                   _alt tdouble)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _U tdouble)
                                                     tdouble)
                                                   (Ebinop Osub
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Ebinop Odiv
                                                       (Evalof
                                                         (Evar _b2 tdouble)
                                                         tdouble)
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Evar _a tdouble)
                                                           tdouble)
                                                         (Evalof
                                                           (Evar _V tdouble)
                                                           tdouble) tdouble)
                                                       tdouble) tdouble)
                                                   tdouble) tdouble))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                                           (tptr (Tstruct _LlaCoor_d noattr)))
                                                         (Tstruct _LlaCoor_d noattr))
                                                       (Tstruct _LlaCoor_d noattr))
                                                     _lat tdouble)
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _atan (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                       (Tfunction
                                                         (tdouble :: nil)
                                                         tdouble cc_default))
                                                     (Econs
                                                       (Ebinop Odiv
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                                                    (tptr (Tstruct _EcefCoor_d noattr)))
                                                                   (Tstruct _EcefCoor_d noattr))
                                                                 (Tstruct _EcefCoor_d noattr))
                                                               _z tdouble)
                                                             tdouble)
                                                           (Ebinop Omul
                                                             (Evalof
                                                               (Evar _ep2 tdouble)
                                                               tdouble)
                                                             (Evalof
                                                               (Evar _zo tdouble)
                                                               tdouble)
                                                             tdouble)
                                                           tdouble)
                                                         (Evalof
                                                           (Evar _r tdouble)
                                                           tdouble) tdouble)
                                                       Enil) tdouble)
                                                   tdouble))
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                                           (tptr (Tstruct _LlaCoor_d noattr)))
                                                         (Tstruct _LlaCoor_d noattr))
                                                       (Tstruct _LlaCoor_d noattr))
                                                     _lon tdouble)
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _atan2 (Tfunction
                                                                    (tdouble ::
                                                                    tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                       (Tfunction
                                                         (tdouble ::
                                                          tdouble :: nil)
                                                         tdouble cc_default))
                                                     (Econs
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Ederef
                                                               (Evalof
                                                                 (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                                                 (tptr (Tstruct _EcefCoor_d noattr)))
                                                               (Tstruct _EcefCoor_d noattr))
                                                             (Tstruct _EcefCoor_d noattr))
                                                           _y tdouble)
                                                         tdouble)
                                                       (Econs
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Ederef
                                                                 (Evalof
                                                                   (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                                                   (tptr (Tstruct _EcefCoor_d noattr)))
                                                                 (Tstruct _EcefCoor_d noattr))
                                                               (Tstruct _EcefCoor_d noattr))
                                                             _x tdouble)
                                                           tdouble) Enil))
                                                     tdouble) tdouble))))))))))))))))))))))))
|}.

Definition v_a__1 := {|
  gvar_info := tdouble;
  gvar_init := (Init_float64 (Float.of_bits (Int64.repr 4708606483430899712)) ::
                nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_f__1 := {|
  gvar_info := tdouble;
  gvar_init := (Init_float64 (Float.of_bits (Int64.repr 4569877477558837544)) ::
                nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_ecef_of_lla_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_d noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_d noattr))) :: nil);
  fn_vars := ((_e2, tdouble) :: (_sin_lat, tdouble) :: (_cos_lat, tdouble) ::
              (_sin_lon, tdouble) :: (_cos_lon, tdouble) ::
              (_chi, tdouble) :: (_a_chi, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _e2 tdouble)
         (Ebinop Osub
           (Ebinop Omul
             (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
             (Evalof (Evar _f__1 tdouble) tdouble) tdouble)
           (Ebinop Omul (Evalof (Evar _f__1 tdouble) tdouble)
             (Evalof (Evar _f__1 tdouble) tdouble) tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _sin_lat tdouble)
           (Ecall
             (Evalof
               (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
               (Tfunction (tdouble :: nil) tdouble cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                         (tptr (Tstruct _LlaCoor_d noattr)))
                       (Tstruct _LlaCoor_d noattr))
                     (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
               Enil) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _cos_lat tdouble)
             (Ecall
               (Evalof
                 (Evar _cos (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Tfunction (tdouble :: nil) tdouble cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                           (tptr (Tstruct _LlaCoor_d noattr)))
                         (Tstruct _LlaCoor_d noattr))
                       (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                 Enil) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _sin_lon tdouble)
               (Ecall
                 (Evalof
                   (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                             (tptr (Tstruct _LlaCoor_d noattr)))
                           (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _lon tdouble) tdouble)
                   Enil) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _cos_lon tdouble)
                 (Ecall
                   (Evalof
                     (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                               (tptr (Tstruct _LlaCoor_d noattr)))
                             (Tstruct _LlaCoor_d noattr))
                           (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                       tdouble) Enil) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _chi tdouble)
                   (Ecall
                     (Evalof
                       (Evar _sqrt (Tfunction (tdouble :: nil) tdouble
                                     cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs
                       (Ebinop Osub
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                         (Ebinop Omul
                           (Ebinop Omul (Evalof (Evar _e2 tdouble) tdouble)
                             (Evalof (Evar _sin_lat tdouble) tdouble)
                             tdouble)
                           (Evalof (Evar _sin_lat tdouble) tdouble) tdouble)
                         tdouble) Enil) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _a_chi tdouble)
                     (Ebinop Odiv (Evalof (Evar _a__1 tdouble) tdouble)
                       (Evalof (Evar _chi tdouble) tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                               (tptr (Tstruct _EcefCoor_d noattr)))
                             (Tstruct _EcefCoor_d noattr))
                           (Tstruct _EcefCoor_d noattr)) _x tdouble)
                       (Ebinop Omul
                         (Ebinop Omul
                           (Ebinop Oadd
                             (Evalof (Evar _a_chi tdouble) tdouble)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                       (tptr (Tstruct _LlaCoor_d noattr)))
                                     (Tstruct _LlaCoor_d noattr))
                                   (Tstruct _LlaCoor_d noattr)) _alt tdouble)
                               tdouble) tdouble)
                           (Evalof (Evar _cos_lat tdouble) tdouble) tdouble)
                         (Evalof (Evar _cos_lon tdouble) tdouble) tdouble)
                       tdouble))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                 (tptr (Tstruct _EcefCoor_d noattr)))
                               (Tstruct _EcefCoor_d noattr))
                             (Tstruct _EcefCoor_d noattr)) _y tdouble)
                         (Ebinop Omul
                           (Ebinop Omul
                             (Ebinop Oadd
                               (Evalof (Evar _a_chi tdouble) tdouble)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                         (tptr (Tstruct _LlaCoor_d noattr)))
                                       (Tstruct _LlaCoor_d noattr))
                                     (Tstruct _LlaCoor_d noattr)) _alt
                                   tdouble) tdouble) tdouble)
                             (Evalof (Evar _cos_lat tdouble) tdouble)
                             tdouble)
                           (Evalof (Evar _sin_lon tdouble) tdouble) tdouble)
                         tdouble))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                                 (tptr (Tstruct _EcefCoor_d noattr)))
                               (Tstruct _EcefCoor_d noattr))
                             (Tstruct _EcefCoor_d noattr)) _z tdouble)
                         (Ebinop Omul
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Evalof (Evar _a_chi tdouble) tdouble)
                               (Ebinop Osub
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                 (Evalof (Evar _e2 tdouble) tdouble) tdouble)
                               tdouble)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                       (tptr (Tstruct _LlaCoor_d noattr)))
                                     (Tstruct _LlaCoor_d noattr))
                                   (Tstruct _LlaCoor_d noattr)) _alt tdouble)
                               tdouble) tdouble)
                           (Evalof (Evar _sin_lat tdouble) tdouble) tdouble)
                         tdouble)))))))))))
|}.

Definition f_enu_of_ecef_point_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_d noattr))) :: nil);
  fn_vars := ((_delta, (Tstruct _EcefCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
               (Tstruct _EcefCoor_d noattr)) _x tdouble)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                       (tptr (Tstruct _EcefCoor_d noattr)))
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                           (tptr (Tstruct _LtpDef_d noattr)))
                         (Tstruct _LtpDef_d noattr))
                       (Tstruct _LtpDef_d noattr)) _ecef
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _y tdouble)
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                         (tptr (Tstruct _EcefCoor_d noattr)))
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                             (tptr (Tstruct _LtpDef_d noattr)))
                           (Tstruct _LtpDef_d noattr))
                         (Tstruct _LtpDef_d noattr)) _ecef
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
               tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _z tdouble)
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                         (tptr (Tstruct _EcefCoor_d noattr)))
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                             (tptr (Tstruct _LtpDef_d noattr)))
                           (Tstruct _LtpDef_d noattr))
                         (Tstruct _LtpDef_d noattr)) _ecef
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble))))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                   (tptr (Tstruct _EnuCoor_d noattr)))
                 (Tstruct _EnuCoor_d noattr)) (Tstruct _EnuCoor_d noattr)) _x
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
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
                 tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                     (tptr (Tstruct _EnuCoor_d noattr)))
                   (Tstruct _EnuCoor_d noattr)) (Tstruct _EnuCoor_d noattr))
               _y tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                         (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
                   tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                         (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
                   tdouble) tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
                 tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                     (tptr (Tstruct _EnuCoor_d noattr)))
                   (Tstruct _EnuCoor_d noattr)) (Tstruct _EnuCoor_d noattr))
               _z tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                         (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
                   tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                         (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
                   tdouble) tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
                 tdouble) tdouble) tdouble)))))
|}.

Definition f_ned_of_ecef_point_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_d noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_d (Tfunction
                                        ((tptr (Tstruct _EnuCoor_d noattr)) ::
                                         (tptr (Tstruct _LtpDef_d noattr)) ::
                                         (tptr (Tstruct _EcefCoor_d noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_d noattr)) ::
              (tptr (Tstruct _LtpDef_d noattr)) ::
              (tptr (Tstruct _EcefCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu (Tstruct _EnuCoor_d noattr))
             (tptr (Tstruct _EnuCoor_d noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
               (tptr (Tstruct _LtpDef_d noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                 (tptr (Tstruct _EcefCoor_d noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                   (tptr (Tstruct _NedCoor_d noattr)))
                 (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr)) _x
             tdouble)
           (Evalof
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                     (tptr (Tstruct _NedCoor_d noattr)))
                   (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr))
               _y tdouble)
             (Evalof
               (Efield
                 (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                   (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                     (tptr (Tstruct _NedCoor_d noattr)))
                   (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr))
               _z tdouble)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble)))))
|}.

Definition f_enu_of_ecef_vect_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_d noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                 (tptr (Tstruct _EnuCoor_d noattr)))
               (Tstruct _EnuCoor_d noattr)) (Tstruct _EnuCoor_d noattr)) _x
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
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                         (tptr (Tstruct _EcefCoor_d noattr)))
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
               tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                         (tptr (Tstruct _EcefCoor_d noattr)))
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
               tdouble) tdouble)
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
                                 (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                 (tptr (Tstruct _LtpDef_d noattr)))
                               (Tstruct _LtpDef_d noattr))
                             (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
                 tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                       (tptr (Tstruct _EcefCoor_d noattr)))
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
             tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                   (tptr (Tstruct _EnuCoor_d noattr)))
                 (Tstruct _EnuCoor_d noattr)) (Tstruct _EnuCoor_d noattr)) _y
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
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                           (tptr (Tstruct _EcefCoor_d noattr)))
                         (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
                 tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                           (tptr (Tstruct _EcefCoor_d noattr)))
                         (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                         (tptr (Tstruct _EcefCoor_d noattr)))
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                   (tptr (Tstruct _EnuCoor_d noattr)))
                 (Tstruct _EnuCoor_d noattr)) (Tstruct _EnuCoor_d noattr)) _z
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
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                           (tptr (Tstruct _EcefCoor_d noattr)))
                         (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
                 tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                           (tptr (Tstruct _EcefCoor_d noattr)))
                         (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                         (tptr (Tstruct _EcefCoor_d noattr)))
                       (Tstruct _EcefCoor_d noattr))
                     (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))))
|}.

Definition f_ned_of_ecef_vect_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_d noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_vect_d (Tfunction
                                       ((tptr (Tstruct _EnuCoor_d noattr)) ::
                                        (tptr (Tstruct _LtpDef_d noattr)) ::
                                        (tptr (Tstruct _EcefCoor_d noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_d noattr)) ::
              (tptr (Tstruct _LtpDef_d noattr)) ::
              (tptr (Tstruct _EcefCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu (Tstruct _EnuCoor_d noattr))
             (tptr (Tstruct _EnuCoor_d noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
               (tptr (Tstruct _LtpDef_d noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                 (tptr (Tstruct _EcefCoor_d noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                   (tptr (Tstruct _NedCoor_d noattr)))
                 (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr)) _x
             tdouble)
           (Evalof
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                     (tptr (Tstruct _NedCoor_d noattr)))
                   (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr))
               _y tdouble)
             (Evalof
               (Efield
                 (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                   (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                     (tptr (Tstruct _NedCoor_d noattr)))
                   (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr))
               _z tdouble)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble)))))
|}.

Definition f_ecef_of_enu_point_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_enu, (tptr (Tstruct _EnuCoor_d noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                   (tptr (Tstruct _EcefCoor_d noattr)))
                 (Tstruct _EcefCoor_d noattr)) (Tstruct _EcefCoor_d noattr))
             _x tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble)
                 tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                         (tptr (Tstruct _EnuCoor_d noattr)))
                       (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                     (tptr (Tstruct _EcefCoor_d noattr)))
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _y tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                             (tptr (Tstruct _EnuCoor_d noattr)))
                           (Tstruct _EnuCoor_d noattr))
                         (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble)
                   tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                             (tptr (Tstruct _EnuCoor_d noattr)))
                           (Tstruct _EnuCoor_d noattr))
                         (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble)
                   tdouble) tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
                 tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                     (tptr (Tstruct _EcefCoor_d noattr)))
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _z tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 2)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                             (tptr (Tstruct _EnuCoor_d noattr)))
                           (Tstruct _EnuCoor_d noattr))
                         (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble)
                   tdouble)
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
                                       (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                       (tptr (Tstruct _LtpDef_d noattr)))
                                     (Tstruct _LtpDef_d noattr))
                                   (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 2)) tint) tint)
                         (tptr tdouble)) tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                             (tptr (Tstruct _EnuCoor_d noattr)))
                           (Tstruct _EnuCoor_d noattr))
                         (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble)
                   tdouble) tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
                 tdouble) tdouble) tdouble))))
  (Ssequence
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                   (tptr (Tstruct _EcefCoor_d noattr)))
                 (Tstruct _EcefCoor_d noattr)) (Tstruct _EcefCoor_d noattr))
             _x tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                         (tptr (Tstruct _LtpDef_d noattr)))
                       (Tstruct _LtpDef_d noattr))
                     (Tstruct _LtpDef_d noattr)) _ecef
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
           tdouble tdouble))
    (Ssequence
      (Sdo (Eassignop Oadd
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                     (tptr (Tstruct _EcefCoor_d noattr)))
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _y tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                           (tptr (Tstruct _LtpDef_d noattr)))
                         (Tstruct _LtpDef_d noattr))
                       (Tstruct _LtpDef_d noattr)) _ecef
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
             tdouble tdouble))
      (Sdo (Eassignop Oadd
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                     (tptr (Tstruct _EcefCoor_d noattr)))
                   (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _z tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                           (tptr (Tstruct _LtpDef_d noattr)))
                         (Tstruct _LtpDef_d noattr))
                       (Tstruct _LtpDef_d noattr)) _ecef
                     (Tstruct _EcefCoor_d noattr))
                   (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
             tdouble tdouble)))))
|}.

Definition f_ecef_of_ned_point_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ned, (tptr (Tstruct _NedCoor_d noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
               (Tstruct _EnuCoor_d noattr)) _x tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                     (tptr (Tstruct _NedCoor_d noattr)))
                   (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr))
               _y tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (Tstruct _EnuCoor_d noattr)) _y tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                       (tptr (Tstruct _NedCoor_d noattr)))
                     (Tstruct _NedCoor_d noattr))
                   (Tstruct _NedCoor_d noattr)) _x tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (Tstruct _EnuCoor_d noattr)) _z tdouble)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                         (tptr (Tstruct _NedCoor_d noattr)))
                       (Tstruct _NedCoor_d noattr))
                     (Tstruct _NedCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble))))
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_point_d (Tfunction
                                        ((tptr (Tstruct _EcefCoor_d noattr)) ::
                                         (tptr (Tstruct _LtpDef_d noattr)) ::
                                         (tptr (Tstruct _EnuCoor_d noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_d noattr)) ::
              (tptr (Tstruct _LtpDef_d noattr)) ::
              (tptr (Tstruct _EnuCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
             (tptr (Tstruct _EcefCoor_d noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
               (tptr (Tstruct _LtpDef_d noattr)))
             (Econs
               (Eaddrof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (tptr (Tstruct _EnuCoor_d noattr))) Enil))) tvoid)))
|}.

Definition f_ecef_of_enu_vect_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_enu, (tptr (Tstruct _EnuCoor_d noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                 (tptr (Tstruct _EcefCoor_d noattr)))
               (Tstruct _EcefCoor_d noattr)) (Tstruct _EcefCoor_d noattr)) _x
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
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                         (tptr (Tstruct _EnuCoor_d noattr)))
                       (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble)
               tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                         (tptr (Tstruct _EnuCoor_d noattr)))
                       (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble)
               tdouble) tdouble)
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
                                 (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                 (tptr (Tstruct _LtpDef_d noattr)))
                               (Tstruct _LtpDef_d noattr))
                             (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
                 tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                       (tptr (Tstruct _EnuCoor_d noattr)))
                     (Tstruct _EnuCoor_d noattr))
                   (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble) tdouble)
           tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                   (tptr (Tstruct _EcefCoor_d noattr)))
                 (Tstruct _EcefCoor_d noattr)) (Tstruct _EcefCoor_d noattr))
             _y tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble)
                 tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                         (tptr (Tstruct _EnuCoor_d noattr)))
                       (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
                   (tptr (Tstruct _EcefCoor_d noattr)))
                 (Tstruct _EcefCoor_d noattr)) (Tstruct _EcefCoor_d noattr))
             _z tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _x tdouble) tdouble)
                 tdouble)
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
                                     (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                     (tptr (Tstruct _LtpDef_d noattr)))
                                   (Tstruct _LtpDef_d noattr))
                                 (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                           (tptr (Tstruct _EnuCoor_d noattr)))
                         (Tstruct _EnuCoor_d noattr))
                       (Tstruct _EnuCoor_d noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
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
                                   (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
                                   (tptr (Tstruct _LtpDef_d noattr)))
                                 (Tstruct _LtpDef_d noattr))
                               (Tstruct _LtpDef_d noattr)) _ltp_of_ecef
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
                   tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
                         (tptr (Tstruct _EnuCoor_d noattr)))
                       (Tstruct _EnuCoor_d noattr))
                     (Tstruct _EnuCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))))
|}.

Definition f_ecef_of_ned_vect_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_ned, (tptr (Tstruct _NedCoor_d noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
               (Tstruct _EnuCoor_d noattr)) _x tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                     (tptr (Tstruct _NedCoor_d noattr)))
                   (Tstruct _NedCoor_d noattr)) (Tstruct _NedCoor_d noattr))
               _y tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (Tstruct _EnuCoor_d noattr)) _y tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                       (tptr (Tstruct _NedCoor_d noattr)))
                     (Tstruct _NedCoor_d noattr))
                   (Tstruct _NedCoor_d noattr)) _x tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (Tstruct _EnuCoor_d noattr)) _z tdouble)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
                         (tptr (Tstruct _NedCoor_d noattr)))
                       (Tstruct _NedCoor_d noattr))
                     (Tstruct _NedCoor_d noattr)) _z tdouble) tdouble)
               tdouble) tdouble))))
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_vect_d (Tfunction
                                       ((tptr (Tstruct _EcefCoor_d noattr)) ::
                                        (tptr (Tstruct _LtpDef_d noattr)) ::
                                        (tptr (Tstruct _EnuCoor_d noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_d noattr)) ::
              (tptr (Tstruct _LtpDef_d noattr)) ::
              (tptr (Tstruct _EnuCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_d noattr)))
             (tptr (Tstruct _EcefCoor_d noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
               (tptr (Tstruct _LtpDef_d noattr)))
             (Econs
               (Eaddrof (Evar _enu (Tstruct _EnuCoor_d noattr))
                 (tptr (Tstruct _EnuCoor_d noattr))) Enil))) tvoid)))
|}.

Definition f_enu_of_lla_point_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_d noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_d (Tfunction
                                  ((tptr (Tstruct _EcefCoor_d noattr)) ::
                                   (tptr (Tstruct _LlaCoor_d noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_d noattr)) ::
              (tptr (Tstruct _LlaCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_d noattr))
             (tptr (Tstruct _EcefCoor_d noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
               (tptr (Tstruct _LlaCoor_d noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_d (Tfunction
                                        ((tptr (Tstruct _EnuCoor_d noattr)) ::
                                         (tptr (Tstruct _LtpDef_d noattr)) ::
                                         (tptr (Tstruct _EcefCoor_d noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_d noattr)) ::
              (tptr (Tstruct _LtpDef_d noattr)) ::
              (tptr (Tstruct _EcefCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_d noattr)))
             (tptr (Tstruct _EnuCoor_d noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
               (tptr (Tstruct _LtpDef_d noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_d noattr))
                 (tptr (Tstruct _EcefCoor_d noattr))) Enil))) tvoid)))
|}.

Definition f_ned_of_lla_point_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_d noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_d noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_d noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_d (Tfunction
                                  ((tptr (Tstruct _EcefCoor_d noattr)) ::
                                   (tptr (Tstruct _LlaCoor_d noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_d noattr)) ::
              (tptr (Tstruct _LlaCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_d noattr))
             (tptr (Tstruct _EcefCoor_d noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
               (tptr (Tstruct _LlaCoor_d noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _ned_of_ecef_point_d (Tfunction
                                        ((tptr (Tstruct _NedCoor_d noattr)) ::
                                         (tptr (Tstruct _LtpDef_d noattr)) ::
                                         (tptr (Tstruct _EcefCoor_d noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _NedCoor_d noattr)) ::
              (tptr (Tstruct _LtpDef_d noattr)) ::
              (tptr (Tstruct _EcefCoor_d noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ned (tptr (Tstruct _NedCoor_d noattr)))
             (tptr (Tstruct _NedCoor_d noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_d noattr)))
               (tptr (Tstruct _LtpDef_d noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_d noattr))
                 (tptr (Tstruct _EcefCoor_d noattr))) Enil))) tvoid)))
|}.

Definition f_gc_of_gd_lat_d := {|
  fn_return := tdouble;
  fn_callconv := cc_default;
  fn_params := ((_gd_lat, tdouble) :: (_hmsl, tdouble) :: nil);
  fn_vars := ((_a__2, tdouble) :: (_f__2, tdouble) :: (_c2, tdouble) ::
              (_ls, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _a__2 tdouble)
         (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _f__2 tdouble)
           (Ebinop Odiv
             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4643954612757622152))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _c2 tdouble)
             (Ebinop Omul
               (Ebinop Osub
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                 (Evalof (Evar _f__2 tdouble) tdouble) tdouble)
               (Ebinop Osub
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                 (Evalof (Evar _f__2 tdouble) tdouble) tdouble) tdouble)
             tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _ls tdouble)
               (Ecall
                 (Evalof
                   (Evar _atan (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Ebinop Omul (Evalof (Evar _c2 tdouble) tdouble)
                     (Ecall
                       (Evalof
                         (Evar _tan (Tfunction (tdouble :: nil) tdouble
                                      cc_default))
                         (Tfunction (tdouble :: nil) tdouble cc_default))
                       (Econs (Evalof (Evar _gd_lat tdouble) tdouble) Enil)
                       tdouble) tdouble) Enil) tdouble) tdouble))
        (Sreturn (Some (Ecall
                         (Evalof
                           (Evar _atan2 (Tfunction
                                          (tdouble :: tdouble :: nil) tdouble
                                          cc_default))
                           (Tfunction (tdouble :: tdouble :: nil) tdouble
                             cc_default))
                         (Econs
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Evalof (Evar _hmsl tdouble) tdouble)
                               (Ecall
                                 (Evalof
                                   (Evar _sin (Tfunction (tdouble :: nil)
                                                tdouble cc_default))
                                   (Tfunction (tdouble :: nil) tdouble
                                     cc_default))
                                 (Econs
                                   (Evalof (Evar _gd_lat tdouble) tdouble)
                                   Enil) tdouble) tdouble)
                             (Ebinop Omul
                               (Evalof (Evar _a__2 tdouble) tdouble)
                               (Ecall
                                 (Evalof
                                   (Evar _sin (Tfunction (tdouble :: nil)
                                                tdouble cc_default))
                                   (Tfunction (tdouble :: nil) tdouble
                                     cc_default))
                                 (Econs (Evalof (Evar _ls tdouble) tdouble)
                                   Enil) tdouble) tdouble) tdouble)
                           (Econs
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Evalof (Evar _hmsl tdouble) tdouble)
                                 (Ecall
                                   (Evalof
                                     (Evar _cos (Tfunction (tdouble :: nil)
                                                  tdouble cc_default))
                                     (Tfunction (tdouble :: nil) tdouble
                                       cc_default))
                                   (Econs
                                     (Evalof (Evar _gd_lat tdouble) tdouble)
                                     Enil) tdouble) tdouble)
                               (Ebinop Omul
                                 (Evalof (Evar _a__2 tdouble) tdouble)
                                 (Ecall
                                   (Evalof
                                     (Evar _cos (Tfunction (tdouble :: nil)
                                                  tdouble cc_default))
                                     (Tfunction (tdouble :: nil) tdouble
                                       cc_default))
                                   (Econs (Evalof (Evar _ls tdouble) tdouble)
                                     Enil) tdouble) tdouble) tdouble) Enil))
                         tdouble)))))))
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

Definition f_isometric_latitude_d := {|
  fn_return := tdouble;
  fn_callconv := cc_default;
  fn_params := ((_phi, tdouble) :: (_e, tdouble) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Osub
                 (Ecall
                   (Evalof
                     (Evar _log (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Ecall
                       (Evalof
                         (Evar _tan (Tfunction (tdouble :: nil) tdouble
                                      cc_default))
                         (Tfunction (tdouble :: nil) tdouble cc_default))
                       (Econs
                         (Ebinop Oadd
                           (Ebinop Odiv
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                             (Eval (Vint (Int.repr 4)) tint) tdouble)
                           (Ebinop Odiv (Evalof (Evar _phi tdouble) tdouble)
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                             tdouble) tdouble) Enil) tdouble) Enil) tdouble)
                 (Ebinop Omul
                   (Ebinop Odiv (Evalof (Evar _e tdouble) tdouble)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     tdouble)
                   (Ecall
                     (Evalof
                       (Evar _log (Tfunction (tdouble :: nil) tdouble
                                    cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs
                       (Ebinop Odiv
                         (Ebinop Oadd
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                           (Ebinop Omul (Evalof (Evar _e tdouble) tdouble)
                             (Ecall
                               (Evalof
                                 (Evar _sin (Tfunction (tdouble :: nil)
                                              tdouble cc_default))
                                 (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                               (Econs (Evalof (Evar _phi tdouble) tdouble)
                                 Enil) tdouble) tdouble) tdouble)
                         (Ebinop Osub
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                           (Ebinop Omul (Evalof (Evar _e tdouble) tdouble)
                             (Ecall
                               (Evalof
                                 (Evar _sin (Tfunction (tdouble :: nil)
                                              tdouble cc_default))
                                 (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                               (Econs (Evalof (Evar _phi tdouble) tdouble)
                                 Enil) tdouble) tdouble) tdouble) tdouble)
                       Enil) tdouble) tdouble) tdouble)))
|}.

Definition f_isometric_latitude_fast_d := {|
  fn_return := tdouble;
  fn_callconv := cc_default;
  fn_params := ((_phi, tdouble) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _log (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Ecall
                     (Evalof
                       (Evar _tan (Tfunction (tdouble :: nil) tdouble
                                    cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs
                       (Ebinop Oadd
                         (Ebinop Odiv
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                           (Eval (Vint (Int.repr 4)) tint) tdouble)
                         (Ebinop Odiv (Evalof (Evar _phi tdouble) tdouble)
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                           tdouble) tdouble) Enil) tdouble) Enil) tdouble)))
|}.

Definition f_inverse_isometric_latitude_d := {|
  fn_return := tdouble;
  fn_callconv := cc_default;
  fn_params := ((_lat, tdouble) :: (_e, tdouble) :: (_epsilon, tdouble) ::
                nil);
  fn_vars := ((_exp_l, tdouble) :: (_phi0, tdouble) :: (_phi_, tdouble) ::
              (_max_iter, tuchar) :: (_sin_phi, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _exp_l tdouble)
         (Ecall
           (Evalof
             (Evar _exp (Tfunction (tdouble :: nil) tdouble cc_default))
             (Tfunction (tdouble :: nil) tdouble cc_default))
           (Econs (Evalof (Evar _lat tdouble) tdouble) Enil) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _phi0 tdouble)
           (Ebinop Osub
             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
               (Ecall
                 (Evalof
                   (Evar _atan (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs (Evalof (Evar _exp_l tdouble) tdouble) Enil) tdouble)
               tdouble)
             (Ebinop Odiv
               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
               (Eval (Vint (Int.repr 2)) tint) tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _max_iter tuchar) (Eval (Vint (Int.repr 3)) tint)
             tuchar))
      (Ssequence
        (Sdowhile
          (Eseqand (Evalof (Evar _max_iter tuchar) tuchar)
            (Ebinop Ogt
              (Ecall
                (Evalof
                  (Evar _fabs (Tfunction (tdouble :: nil) tdouble cc_default))
                  (Tfunction (tdouble :: nil) tdouble cc_default))
                (Econs
                  (Ebinop Osub (Evalof (Evar _phi_ tdouble) tdouble)
                    (Evalof (Evar _phi0 tdouble) tdouble) tdouble) Enil)
                tdouble) (Evalof (Evar _epsilon tdouble) tdouble) tint) tint)
          (Ssequence
            (Sdo (Eassign (Evar _phi_ tdouble)
                   (Evalof (Evar _phi0 tdouble) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _sin_phi tdouble)
                     (Ebinop Omul (Evalof (Evar _e tdouble) tdouble)
                       (Ecall
                         (Evalof
                           (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                        cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs (Evalof (Evar _phi_ tdouble) tdouble) Enil)
                         tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _phi0 tdouble)
                       (Ebinop Osub
                         (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                           (Ecall
                             (Evalof
                               (Evar _atan (Tfunction (tdouble :: nil)
                                             tdouble cc_default))
                               (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                             (Econs
                               (Ebinop Omul
                                 (Ecall
                                   (Evalof
                                     (Evar _pow (Tfunction
                                                  (tdouble :: tdouble :: nil)
                                                  tdouble cc_default))
                                     (Tfunction (tdouble :: tdouble :: nil)
                                       tdouble cc_default))
                                   (Econs
                                     (Ebinop Odiv
                                       (Ebinop Oadd
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Evalof (Evar _sin_phi tdouble)
                                           tdouble) tdouble)
                                       (Ebinop Osub
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                         (Evalof (Evar _sin_phi tdouble)
                                           tdouble) tdouble) tdouble)
                                     (Econs
                                       (Ebinop Odiv
                                         (Evalof (Evar _e tdouble) tdouble)
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                         tdouble) Enil)) tdouble)
                                 (Evalof (Evar _exp_l tdouble) tdouble)
                                 tdouble) Enil) tdouble) tdouble)
                         (Ebinop Odiv
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                           (Eval (Vint (Int.repr 2)) tint) tdouble) tdouble)
                       tdouble))
                (Sdo (Epostincr Decr (Evar _max_iter tuchar) tuchar))))))
        (Sreturn (Some (Evalof (Evar _phi0 tdouble) tdouble)))))))
|}.

Definition f_utm_of_lla_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_utm, (tptr (Tstruct _UtmCoor_d noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_d noattr))) :: nil);
  fn_vars := ((_lambda_c, tdouble) :: (_ll, tdouble) :: (_dl, tdouble) ::
              (_phi_, tdouble) :: (_ll_, tdouble) :: (_lambda_, tdouble) ::
              (_z_, (Tstruct _DoubleVect2 noattr)) :: (_k, tschar) ::
              (_z, (Tstruct _DoubleVect2 noattr)) :: (_tmp, tdouble) ::
              (_vstar, (Tstruct _DoubleVect2 noattr)) :: (_e, tdouble) ::
              (_e__1, tdouble) :: (_tmp__1, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oeq
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                           (tptr (Tstruct _UtmCoor_d noattr)))
                         (Tstruct _UtmCoor_d noattr))
                       (Tstruct _UtmCoor_d noattr)) _zone tuchar) tuchar)
                 (Eval (Vint (Int.repr 0)) tint) tint)
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                   (tptr (Tstruct _UtmCoor_d noattr)))
                 (Tstruct _UtmCoor_d noattr)) (Tstruct _UtmCoor_d noattr))
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
                                 (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                 (tptr (Tstruct _LlaCoor_d noattr)))
                               (Tstruct _LlaCoor_d noattr))
                             (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                         tdouble)
                       (Ebinop Odiv
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                         tdouble) tdouble) (Eval (Vint (Int.repr 180)) tint)
                     tdouble) Enil) tdouble) (Eval (Vint (Int.repr 6)) tint)
               tdouble) (Eval (Vint (Int.repr 1)) tint) tdouble) tuchar))
    Sskip)
  (Ssequence
    (Sdo (Eassign (Evar _lambda_c tdouble)
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
                               (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                               (tptr (Tstruct _UtmCoor_d noattr)))
                             (Tstruct _UtmCoor_d noattr))
                           (Tstruct _UtmCoor_d noattr)) _zone tuchar) tuchar)
                     (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 6)) tint) tint)
                 (Eval (Vint (Int.repr 180)) tint) tint)
               (Eval (Vint (Int.repr 3)) tint) tint)
             (Ebinop Odiv
               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
               tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _ll tdouble)
             (Ecall
               (Evalof
                 (Evar _isometric_latitude_d (Tfunction
                                               (tdouble :: tdouble :: nil)
                                               tdouble cc_default))
                 (Tfunction (tdouble :: tdouble :: nil) tdouble cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                           (tptr (Tstruct _LlaCoor_d noattr)))
                         (Tstruct _LlaCoor_d noattr))
                       (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                 (Econs
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4590560114717078071))) tdouble)
                   Enil)) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _dl tdouble)
               (Ebinop Osub
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                           (tptr (Tstruct _LlaCoor_d noattr)))
                         (Tstruct _LlaCoor_d noattr))
                       (Tstruct _LlaCoor_d noattr)) _lon tdouble) tdouble)
                 (Evalof (Evar _lambda_c tdouble) tdouble) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _phi_ tdouble)
                 (Ecall
                   (Evalof
                     (Evar _asin (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Ebinop Odiv
                       (Ecall
                         (Evalof
                           (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                        cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs (Evalof (Evar _dl tdouble) tdouble) Enil)
                         tdouble)
                       (Ecall
                         (Evalof
                           (Evar _cosh (Tfunction (tdouble :: nil) tdouble
                                         cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs (Evalof (Evar _ll tdouble) tdouble) Enil)
                         tdouble) tdouble) Enil) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _ll_ tdouble)
                   (Ecall
                     (Evalof
                       (Evar _isometric_latitude_fast_d (Tfunction
                                                          (tdouble :: nil)
                                                          tdouble cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs (Evalof (Evar _phi_ tdouble) tdouble) Enil)
                     tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _lambda_ tdouble)
                     (Ecall
                       (Evalof
                         (Evar _atan (Tfunction (tdouble :: nil) tdouble
                                       cc_default))
                         (Tfunction (tdouble :: nil) tdouble cc_default))
                       (Econs
                         (Ebinop Odiv
                           (Ecall
                             (Evalof
                               (Evar _sinh (Tfunction (tdouble :: nil)
                                             tdouble cc_default))
                               (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                             (Econs (Evalof (Evar _ll tdouble) tdouble) Enil)
                             tdouble)
                           (Ecall
                             (Evalof
                               (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                            cc_default))
                               (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                             (Econs (Evalof (Evar _dl tdouble) tdouble) Enil)
                             tdouble) tdouble) Enil) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _z_ (Tstruct _DoubleVect2 noattr))
                           (Tstruct _DoubleVect2 noattr)) _x tdouble)
                       (Evalof (Evar _lambda_ tdouble) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _z_ (Tstruct _DoubleVect2 noattr))
                             (Tstruct _DoubleVect2 noattr)) _y tdouble)
                         (Evalof (Evar _ll_ tdouble) tdouble) tdouble))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _x tdouble)
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _x
                                   tdouble) tdouble)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                       (tarray tfloat 5))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat) tfloat) tdouble)
                             tdouble))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _y tdouble)
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _y
                                   tdouble) tdouble)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                       (tarray tfloat 5))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat) tfloat) tdouble)
                             tdouble)))
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
                                     (Evar _z (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _x
                                   tdouble)
                                 (Evalof (Evar _lambda_ tdouble) tdouble)
                                 tdouble))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _y
                                     tdouble)
                                   (Evalof (Evar _ll_ tdouble) tdouble)
                                   tdouble))
                            (Ssequence
                              (Ssequence
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Evar _z (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _x
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _x tdouble) tdouble)
                                         (Ebinop Omul
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                           (Evalof (Evar _k tschar) tschar)
                                           tdouble) tdouble) tdouble))
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Evar _z (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _y
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _y tdouble) tdouble)
                                         (Ebinop Omul
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                           (Evalof (Evar _k tschar) tschar)
                                           tdouble) tdouble) tdouble)))
                              (Ssequence
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassign (Evar _tmp tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _x tdouble) tdouble) tdouble))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _x tdouble)
                                             (Eunop Oneg
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _z (Tstruct _DoubleVect2 noattr))
                                                     (Tstruct _DoubleVect2 noattr))
                                                   _y tdouble) tdouble)
                                               tdouble) tdouble))
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _y tdouble)
                                             (Evalof (Evar _tmp tdouble)
                                               tdouble) tdouble))))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _x tdouble)
                                           (Eunop Oneg
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _z (Tstruct _DoubleVect2 noattr))
                                                   (Tstruct _DoubleVect2 noattr))
                                                 _x tdouble) tdouble)
                                             tdouble) tdouble))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _y tdouble)
                                             (Eunop Oneg
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _z (Tstruct _DoubleVect2 noattr))
                                                     (Tstruct _DoubleVect2 noattr))
                                                   _y tdouble) tdouble)
                                               tdouble) tdouble))
                                      (Ssequence
                                        (Ssequence
                                          (Sdo (Eassign (Evar _e tdouble)
                                                 (Ecall
                                                   (Evalof
                                                     (Evar _exp (Tfunction
                                                                  (tdouble ::
                                                                   nil)
                                                                  tdouble
                                                                  cc_default))
                                                     (Tfunction
                                                       (tdouble :: nil)
                                                       tdouble cc_default))
                                                   (Econs
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z (Tstruct _DoubleVect2 noattr))
                                                           (Tstruct _DoubleVect2 noattr))
                                                         _x tdouble) tdouble)
                                                     Enil) tdouble) tdouble))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                                       (Tstruct _DoubleVect2 noattr))
                                                     _x tdouble)
                                                   (Ebinop Omul
                                                     (Evalof
                                                       (Evar _e tdouble)
                                                       tdouble)
                                                     (Ecall
                                                       (Evalof
                                                         (Evar _cos (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                         (Tfunction
                                                           (tdouble :: nil)
                                                           tdouble
                                                           cc_default))
                                                       (Econs
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                                               (Tstruct _DoubleVect2 noattr))
                                                             _y tdouble)
                                                           tdouble) Enil)
                                                       tdouble) tdouble)
                                                   tdouble))
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                                       (Tstruct _DoubleVect2 noattr))
                                                     _y tdouble)
                                                   (Ebinop Omul
                                                     (Evalof
                                                       (Evar _e tdouble)
                                                       tdouble)
                                                     (Ecall
                                                       (Evalof
                                                         (Evar _sin (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                         (Tfunction
                                                           (tdouble :: nil)
                                                           tdouble
                                                           cc_default))
                                                       (Econs
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                                               (Tstruct _DoubleVect2 noattr))
                                                             _y tdouble)
                                                           tdouble) Enil)
                                                       tdouble) tdouble)
                                                   tdouble))))
                                        (Ssequence
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Evar _e__1 tdouble)
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _exp (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                       (Tfunction
                                                         (tdouble :: nil)
                                                         tdouble cc_default))
                                                     (Econs
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                             (Tstruct _DoubleVect2 noattr))
                                                           _x tdouble)
                                                         tdouble) Enil)
                                                     tdouble) tdouble))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Efield
                                                       (Evalof
                                                         (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                         (Tstruct _DoubleVect2 noattr))
                                                       _x tdouble)
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _e__1 tdouble)
                                                         tdouble)
                                                       (Ecall
                                                         (Evalof
                                                           (Evar _cos 
                                                           (Tfunction
                                                             (tdouble :: nil)
                                                             tdouble
                                                             cc_default))
                                                           (Tfunction
                                                             (tdouble :: nil)
                                                             tdouble
                                                             cc_default))
                                                         (Econs
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                                 (Tstruct _DoubleVect2 noattr))
                                                               _y tdouble)
                                                             tdouble) Enil)
                                                         tdouble) tdouble)
                                                     tdouble))
                                              (Sdo (Eassign
                                                     (Efield
                                                       (Evalof
                                                         (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                         (Tstruct _DoubleVect2 noattr))
                                                       _y tdouble)
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _e__1 tdouble)
                                                         tdouble)
                                                       (Ecall
                                                         (Evalof
                                                           (Evar _sin 
                                                           (Tfunction
                                                             (tdouble :: nil)
                                                             tdouble
                                                             cc_default))
                                                           (Tfunction
                                                             (tdouble :: nil)
                                                             tdouble
                                                             cc_default))
                                                         (Econs
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                                 (Tstruct _DoubleVect2 noattr))
                                                               _y tdouble)
                                                             tdouble) Enil)
                                                         tdouble) tdouble)
                                                     tdouble))))
                                          (Ssequence
                                            (Ssequence
                                              (Sdo (Eassignop Osub
                                                     (Efield
                                                       (Evalof
                                                         (Evar _z (Tstruct _DoubleVect2 noattr))
                                                         (Tstruct _DoubleVect2 noattr))
                                                       _x tdouble)
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                           (Tstruct _DoubleVect2 noattr))
                                                         _x tdouble) tdouble)
                                                     tdouble tdouble))
                                              (Sdo (Eassignop Osub
                                                     (Efield
                                                       (Evalof
                                                         (Evar _z (Tstruct _DoubleVect2 noattr))
                                                         (Tstruct _DoubleVect2 noattr))
                                                       _y tdouble)
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                           (Tstruct _DoubleVect2 noattr))
                                                         _y tdouble) tdouble)
                                                     tdouble tdouble)))
                                            (Ssequence
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z (Tstruct _DoubleVect2 noattr))
                                                           (Tstruct _DoubleVect2 noattr))
                                                         _x tdouble)
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                                               (Tstruct _DoubleVect2 noattr))
                                                             _x tdouble)
                                                           tdouble)
                                                         (Eunop Oneg
                                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                           tdouble) tdouble)
                                                       tdouble))
                                                (Sdo (Eassign
                                                       (Efield
                                                         (Evalof
                                                           (Evar _z (Tstruct _DoubleVect2 noattr))
                                                           (Tstruct _DoubleVect2 noattr))
                                                         _y tdouble)
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                                               (Tstruct _DoubleVect2 noattr))
                                                             _y tdouble)
                                                           tdouble)
                                                         (Eunop Oneg
                                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                           tdouble) tdouble)
                                                       tdouble)))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _tmp__1 tdouble)
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Evar _z (Tstruct _DoubleVect2 noattr))
                                                             (Tstruct _DoubleVect2 noattr))
                                                           _x tdouble)
                                                         tdouble) tdouble))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Efield
                                                           (Evalof
                                                             (Evar _z (Tstruct _DoubleVect2 noattr))
                                                             (Tstruct _DoubleVect2 noattr))
                                                           _x tdouble)
                                                         (Eunop Oneg
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Evar _z (Tstruct _DoubleVect2 noattr))
                                                                 (Tstruct _DoubleVect2 noattr))
                                                               _y tdouble)
                                                             tdouble)
                                                           tdouble) tdouble))
                                                  (Sdo (Eassign
                                                         (Efield
                                                           (Evalof
                                                             (Evar _z (Tstruct _DoubleVect2 noattr))
                                                             (Tstruct _DoubleVect2 noattr))
                                                           _y tdouble)
                                                         (Evalof
                                                           (Evar _tmp__1 tdouble)
                                                           tdouble) tdouble)))))))))))
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _x tdouble)
                                           (Ebinop Omul
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _z (Tstruct _DoubleVect2 noattr))
                                                   (Tstruct _DoubleVect2 noattr))
                                                 _x tdouble) tdouble)
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                                     (tarray tfloat 5))
                                                   (Evalof (Evar _k tschar)
                                                     tschar) (tptr tfloat))
                                                 tfloat) tfloat) tdouble)
                                           tdouble))
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Evar _z (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _y tdouble)
                                           (Ebinop Omul
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _z (Tstruct _DoubleVect2 noattr))
                                                   (Tstruct _DoubleVect2 noattr))
                                                 _y tdouble) tdouble)
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                                                     (tarray tfloat 5))
                                                   (Evalof (Evar _k tschar)
                                                     tschar) (tptr tfloat))
                                                 tfloat) tfloat) tdouble)
                                           tdouble)))
                                  (Ssequence
                                    (Sdo (Eassignop Oadd
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _x tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _x tdouble) tdouble)
                                           tdouble tdouble))
                                    (Sdo (Eassignop Oadd
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _y tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _y tdouble) tdouble)
                                           tdouble tdouble)))))))))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _x
                                   tdouble)
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _x
                                       tdouble) tdouble)
                                   (Ebinop Omul
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607178815920315512))) tdouble)
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
                                     tdouble) tdouble) tdouble))
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _y
                                   tdouble)
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _y
                                       tdouble) tdouble)
                                   (Ebinop Omul
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607178815920315512))) tdouble)
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
                                     tdouble) tdouble) tdouble)))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                                         (tptr (Tstruct _UtmCoor_d noattr)))
                                       (Tstruct _UtmCoor_d noattr))
                                     (Tstruct _UtmCoor_d noattr)) _east
                                   tdouble)
                                 (Ebinop Oadd
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4692333547057315840))) tdouble)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _y
                                       tdouble) tdouble) tdouble) tdouble))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                                           (tptr (Tstruct _UtmCoor_d noattr)))
                                         (Tstruct _UtmCoor_d noattr))
                                       (Tstruct _UtmCoor_d noattr)) _north
                                     tdouble)
                                   (Ebinop Oadd
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _x
                                         tdouble) tdouble) tdouble) tdouble))
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                                           (tptr (Tstruct _UtmCoor_d noattr)))
                                         (Tstruct _UtmCoor_d noattr))
                                       (Tstruct _UtmCoor_d noattr)) _alt
                                     tdouble)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                             (tptr (Tstruct _LlaCoor_d noattr)))
                                           (Tstruct _LlaCoor_d noattr))
                                         (Tstruct _LlaCoor_d noattr)) _alt
                                       tdouble) tdouble) tdouble))))))))))))))))
|}.

Definition f_lla_of_utm_d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_lla, (tptr (Tstruct _LlaCoor_d noattr))) ::
                (_utm, (tptr (Tstruct _UtmCoor_d noattr))) :: nil);
  fn_vars := ((_z, (Tstruct _DoubleVect2 noattr)) :: (_scale, tdouble) ::
              (_k, tschar) :: (_z_, (Tstruct _DoubleVect2 noattr)) ::
              (_tmp, tdouble) :: (_vstar, (Tstruct _DoubleVect2 noattr)) ::
              (_e, tdouble) :: (_e__1, tdouble) :: (_tmp__1, tdouble) ::
              (_lambda_c, tdouble) :: (_phi, tdouble) :: (_il, tdouble) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
             (Tstruct _DoubleVect2 noattr)) _x tdouble)
         (Ebinop Osub
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                     (tptr (Tstruct _UtmCoor_d noattr)))
                   (Tstruct _UtmCoor_d noattr)) (Tstruct _UtmCoor_d noattr))
               _north tdouble) tdouble)
           (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
               (Tstruct _DoubleVect2 noattr)) _y tdouble)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                       (tptr (Tstruct _UtmCoor_d noattr)))
                     (Tstruct _UtmCoor_d noattr))
                   (Tstruct _UtmCoor_d noattr)) _east tdouble) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4692333547057315840))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _scale tdouble)
             (Ebinop Odiv
               (Ebinop Odiv (Eval (Vint (Int.repr 1)) tint)
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607178815920315512))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4708606483430899712))) tdouble)
                   tdouble) tdouble)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Evar _serie_coeff_proj_mercator (tarray tfloat 5))
                       (tarray tfloat 5)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat) tdouble) tdouble))
      (Ssequence
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                     (Tstruct _DoubleVect2 noattr)) _x tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                         (Tstruct _DoubleVect2 noattr)) _x tdouble) tdouble)
                   (Evalof (Evar _scale tdouble) tdouble) tdouble) tdouble))
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                     (Tstruct _DoubleVect2 noattr)) _y tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                         (Tstruct _DoubleVect2 noattr)) _y tdouble) tdouble)
                   (Evalof (Evar _scale tdouble) tdouble) tdouble) tdouble)))
        (Ssequence
          (Sfor
            (Sdo (Eassign (Evar _k tschar) (Eval (Vint (Int.repr 1)) tint)
                   tschar))
            (Ebinop Olt (Evalof (Evar _k tschar) tschar)
              (Eval (Vint (Int.repr 2)) tint) tint)
            (Sdo (Epostincr Incr (Evar _k tschar) tschar))
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _z_ (Tstruct _DoubleVect2 noattr))
                           (Tstruct _DoubleVect2 noattr)) _x tdouble)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _x tdouble)
                           tdouble)
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                           (Evalof (Evar _k tschar) tschar) tdouble) tdouble)
                       tdouble))
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _z_ (Tstruct _DoubleVect2 noattr))
                           (Tstruct _DoubleVect2 noattr)) _y tdouble)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _y tdouble)
                           tdouble)
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                           (Evalof (Evar _k tschar) tschar) tdouble) tdouble)
                       tdouble)))
              (Ssequence
                (Ssequence
                  (Ssequence
                    (Sdo (Eassign (Evar _tmp tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _x tdouble)
                             tdouble) tdouble))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _x tdouble)
                             (Eunop Oneg
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _y
                                   tdouble) tdouble) tdouble) tdouble))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _y tdouble)
                             (Evalof (Evar _tmp tdouble) tdouble) tdouble))))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Evar _vstar (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _x tdouble)
                           (Eunop Oneg
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                   (Tstruct _DoubleVect2 noattr)) _x tdouble)
                               tdouble) tdouble) tdouble))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _y tdouble)
                             (Eunop Oneg
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                     (Tstruct _DoubleVect2 noattr)) _y
                                   tdouble) tdouble) tdouble) tdouble))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign (Evar _e tdouble)
                                 (Ecall
                                   (Evalof
                                     (Evar _exp (Tfunction (tdouble :: nil)
                                                  tdouble cc_default))
                                     (Tfunction (tdouble :: nil) tdouble
                                       cc_default))
                                   (Econs
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _x
                                         tdouble) tdouble) Enil) tdouble)
                                 tdouble))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _x
                                     tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _e tdouble) tdouble)
                                     (Ecall
                                       (Evalof
                                         (Evar _cos (Tfunction
                                                      (tdouble :: nil)
                                                      tdouble cc_default))
                                         (Tfunction (tdouble :: nil) tdouble
                                           cc_default))
                                       (Econs
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _y tdouble) tdouble) Enil)
                                       tdouble) tdouble) tdouble))
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _y
                                     tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _e tdouble) tdouble)
                                     (Ecall
                                       (Evalof
                                         (Evar _sin (Tfunction
                                                      (tdouble :: nil)
                                                      tdouble cc_default))
                                         (Tfunction (tdouble :: nil) tdouble
                                           cc_default))
                                       (Econs
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _y tdouble) tdouble) Enil)
                                       tdouble) tdouble) tdouble))))
                        (Ssequence
                          (Ssequence
                            (Sdo (Eassign (Evar _e__1 tdouble)
                                   (Ecall
                                     (Evalof
                                       (Evar _exp (Tfunction (tdouble :: nil)
                                                    tdouble cc_default))
                                       (Tfunction (tdouble :: nil) tdouble
                                         cc_default))
                                     (Econs
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                             (Tstruct _DoubleVect2 noattr))
                                           _x tdouble) tdouble) Enil)
                                     tdouble) tdouble))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _x
                                       tdouble)
                                     (Ebinop Omul
                                       (Evalof (Evar _e__1 tdouble) tdouble)
                                       (Ecall
                                         (Evalof
                                           (Evar _cos (Tfunction
                                                        (tdouble :: nil)
                                                        tdouble cc_default))
                                           (Tfunction (tdouble :: nil)
                                             tdouble cc_default))
                                         (Econs
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _y tdouble) tdouble) Enil)
                                         tdouble) tdouble) tdouble))
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _y
                                       tdouble)
                                     (Ebinop Omul
                                       (Evalof (Evar _e__1 tdouble) tdouble)
                                       (Ecall
                                         (Evalof
                                           (Evar _sin (Tfunction
                                                        (tdouble :: nil)
                                                        tdouble cc_default))
                                           (Tfunction (tdouble :: nil)
                                             tdouble cc_default))
                                         (Econs
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _y tdouble) tdouble) Enil)
                                         tdouble) tdouble) tdouble))))
                          (Ssequence
                            (Ssequence
                              (Sdo (Eassignop Osub
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _x
                                       tdouble)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _x
                                         tdouble) tdouble) tdouble tdouble))
                              (Sdo (Eassignop Osub
                                     (Efield
                                       (Evalof
                                         (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                         (Tstruct _DoubleVect2 noattr)) _y
                                       tdouble)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _vstar (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _y
                                         tdouble) tdouble) tdouble tdouble)))
                            (Ssequence
                              (Ssequence
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _x
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _x tdouble) tdouble)
                                         (Eunop Oneg
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                           tdouble) tdouble) tdouble))
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                           (Tstruct _DoubleVect2 noattr)) _y
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                               (Tstruct _DoubleVect2 noattr))
                                             _y tdouble) tdouble)
                                         (Eunop Oneg
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                           tdouble) tdouble) tdouble)))
                              (Ssequence
                                (Sdo (Eassign (Evar _tmp__1 tdouble)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                             (Tstruct _DoubleVect2 noattr))
                                           _x tdouble) tdouble) tdouble))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                             (Tstruct _DoubleVect2 noattr))
                                           _x tdouble)
                                         (Eunop Oneg
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                                 (Tstruct _DoubleVect2 noattr))
                                               _y tdouble) tdouble) tdouble)
                                         tdouble))
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                             (Tstruct _DoubleVect2 noattr))
                                           _y tdouble)
                                         (Evalof (Evar _tmp__1 tdouble)
                                           tdouble) tdouble)))))))))))
                (Ssequence
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof (Evar _z_ (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _x tdouble)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                   (Tstruct _DoubleVect2 noattr)) _x tdouble)
                               tdouble)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _serie_coeff_proj_mercator_inverse (tarray tfloat 5))
                                     (tarray tfloat 5))
                                   (Evalof (Evar _k tschar) tschar)
                                   (tptr tfloat)) tfloat) tfloat) tdouble)
                           tdouble))
                    (Sdo (Eassign
                           (Efield
                             (Evalof (Evar _z_ (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _y tdouble)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                   (Tstruct _DoubleVect2 noattr)) _y tdouble)
                               tdouble)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _serie_coeff_proj_mercator_inverse (tarray tfloat 5))
                                     (tarray tfloat 5))
                                   (Evalof (Evar _k tschar) tschar)
                                   (tptr tfloat)) tfloat) tfloat) tdouble)
                           tdouble)))
                  (Ssequence
                    (Sdo (Eassignop Osub
                           (Efield
                             (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _x tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _x tdouble)
                             tdouble) tdouble tdouble))
                    (Sdo (Eassignop Osub
                           (Efield
                             (Evalof (Evar _z (Tstruct _DoubleVect2 noattr))
                               (Tstruct _DoubleVect2 noattr)) _y tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_ (Tstruct _DoubleVect2 noattr))
                                 (Tstruct _DoubleVect2 noattr)) _y tdouble)
                             tdouble) tdouble tdouble)))))))
          (Ssequence
            (Sdo (Eassign (Evar _lambda_c tdouble)
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
                                       (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                                       (tptr (Tstruct _UtmCoor_d noattr)))
                                     (Tstruct _UtmCoor_d noattr))
                                   (Tstruct _UtmCoor_d noattr)) _zone tuchar)
                               tuchar) (Eval (Vint (Int.repr 1)) tint) tint)
                           (Eval (Vint (Int.repr 6)) tint) tint)
                         (Eval (Vint (Int.repr 180)) tint) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Ebinop Odiv
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                       tdouble) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                             (tptr (Tstruct _LlaCoor_d noattr)))
                           (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                     (Ebinop Oadd (Evalof (Evar _lambda_c tdouble) tdouble)
                       (Ecall
                         (Evalof
                           (Evar _atan (Tfunction (tdouble :: nil) tdouble
                                         cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs
                           (Ebinop Odiv
                             (Ecall
                               (Evalof
                                 (Evar _sinh (Tfunction (tdouble :: nil)
                                               tdouble cc_default))
                                 (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                               (Econs
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _y
                                     tdouble) tdouble) Enil) tdouble)
                             (Ecall
                               (Evalof
                                 (Evar _cos (Tfunction (tdouble :: nil)
                                              tdouble cc_default))
                                 (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                               (Econs
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _x
                                     tdouble) tdouble) Enil) tdouble)
                             tdouble) Enil) tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _phi tdouble)
                       (Ecall
                         (Evalof
                           (Evar _asin (Tfunction (tdouble :: nil) tdouble
                                         cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs
                           (Ebinop Odiv
                             (Ecall
                               (Evalof
                                 (Evar _sin (Tfunction (tdouble :: nil)
                                              tdouble cc_default))
                                 (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                               (Econs
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _x
                                     tdouble) tdouble) Enil) tdouble)
                             (Ecall
                               (Evalof
                                 (Evar _cosh (Tfunction (tdouble :: nil)
                                               tdouble cc_default))
                                 (Tfunction (tdouble :: nil) tdouble
                                   cc_default))
                               (Econs
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _z (Tstruct _DoubleVect2 noattr))
                                       (Tstruct _DoubleVect2 noattr)) _y
                                     tdouble) tdouble) Enil) tdouble)
                             tdouble) Enil) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _il tdouble)
                         (Ecall
                           (Evalof
                             (Evar _isometric_latitude_fast_d (Tfunction
                                                                (tdouble ::
                                                                 nil) tdouble
                                                                cc_default))
                             (Tfunction (tdouble :: nil) tdouble cc_default))
                           (Econs (Evalof (Evar _phi tdouble) tdouble) Enil)
                           tdouble) tdouble))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                   (tptr (Tstruct _LlaCoor_d noattr)))
                                 (Tstruct _LlaCoor_d noattr))
                               (Tstruct _LlaCoor_d noattr)) _lat tdouble)
                           (Ecall
                             (Evalof
                               (Evar _inverse_isometric_latitude_d (Tfunction
                                                                    (tdouble ::
                                                                    tdouble ::
                                                                    tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                               (Tfunction
                                 (tdouble :: tdouble :: tdouble :: nil)
                                 tdouble cc_default))
                             (Econs (Evalof (Evar _il tdouble) tdouble)
                               (Econs
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4590560114717078071))) tdouble)
                                 (Econs
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4487126258331716666))) tdouble)
                                   Enil))) tdouble) tdouble))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _lla (tptr (Tstruct _LlaCoor_d noattr)))
                                   (tptr (Tstruct _LlaCoor_d noattr)))
                                 (Tstruct _LlaCoor_d noattr))
                               (Tstruct _LlaCoor_d noattr)) _alt tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _utm (tptr (Tstruct _UtmCoor_d noattr)))
                                     (tptr (Tstruct _UtmCoor_d noattr)))
                                   (Tstruct _UtmCoor_d noattr))
                                 (Tstruct _UtmCoor_d noattr)) _alt tdouble)
                             tdouble) tdouble))))))))))))
|}.

Definition v_five_keep_ltp_def_from_ecef_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_def_from_ecef_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ltp_def_from_lla_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_def_from_lla_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_lla_of_ecef_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _lla_of_ecef_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_lla_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_lla_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_ecef_point_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_ecef_point_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_ecef_point_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_ecef_point_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_ecef_vect_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_ecef_vect_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_ecef_vect_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_ecef_vect_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_enu_point_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_enu_point_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_point_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_point_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_enu_vect_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_enu_vect_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_vect_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_vect_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_lla_point_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_lla_point_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_lla_point_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_lla_point_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_gc_of_gd_lat_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _gc_of_gd_lat_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_isometric_latitude_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _isometric_latitude_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_isometric_latitude_fast_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _isometric_latitude_fast_d (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_inverse_isometric_latitude_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _inverse_isometric_latitude_d (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_utm_of_lla_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _utm_of_lla_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_lla_of_utm_d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _lla_of_utm_d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _DoubleVect2 Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble :: nil)
   noattr ::
 Composite _DoubleRMat Struct
   (Member_plain _m (tarray tdouble 9) :: nil)
   noattr ::
 Composite _EcefCoor_d Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _LlaCoor_d Struct
   (Member_plain _lat tdouble :: Member_plain _lon tdouble ::
    Member_plain _alt tdouble :: nil)
   noattr ::
 Composite _NedCoor_d Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _EnuCoor_d Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _UtmCoor_d Struct
   (Member_plain _north tdouble :: Member_plain _east tdouble ::
    Member_plain _alt tdouble :: Member_plain _zone tuchar :: nil)
   noattr ::
 Composite _LtpDef_d Struct
   (Member_plain _ecef (Tstruct _EcefCoor_d noattr) ::
    Member_plain _lla (Tstruct _LlaCoor_d noattr) ::
    Member_plain _ltp_of_ecef (Tstruct _DoubleRMat noattr) ::
    Member_plain _hmsl tdouble :: nil)
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
 (_asin,
   Gfun(External (EF_external "asin"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_atan,
   Gfun(External (EF_external "atan"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_atan2,
   Gfun(External (EF_external "atan2"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (_cos,
   Gfun(External (EF_external "cos"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_sin,
   Gfun(External (EF_external "sin"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_tan,
   Gfun(External (EF_external "tan"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_cosh,
   Gfun(External (EF_external "cosh"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_sinh,
   Gfun(External (EF_external "sinh"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_exp,
   Gfun(External (EF_external "exp"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_log,
   Gfun(External (EF_external "log"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_pow,
   Gfun(External (EF_external "pow"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (_sqrt,
   Gfun(External (EF_external "sqrt"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_fabs,
   Gfun(External (EF_external "fabs"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_floor,
   Gfun(External (EF_external "floor"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_ltp_def_from_ecef_d, Gfun(Internal f_ltp_def_from_ecef_d)) ::
 (_ltp_def_from_lla_d, Gfun(Internal f_ltp_def_from_lla_d)) ::
 (_a, Gvar v_a) :: (_f, Gvar v_f) ::
 (_lla_of_ecef_d, Gfun(Internal f_lla_of_ecef_d)) :: (_a__1, Gvar v_a__1) ::
 (_f__1, Gvar v_f__1) :: (_ecef_of_lla_d, Gfun(Internal f_ecef_of_lla_d)) ::
 (_enu_of_ecef_point_d, Gfun(Internal f_enu_of_ecef_point_d)) ::
 (_ned_of_ecef_point_d, Gfun(Internal f_ned_of_ecef_point_d)) ::
 (_enu_of_ecef_vect_d, Gfun(Internal f_enu_of_ecef_vect_d)) ::
 (_ned_of_ecef_vect_d, Gfun(Internal f_ned_of_ecef_vect_d)) ::
 (_ecef_of_enu_point_d, Gfun(Internal f_ecef_of_enu_point_d)) ::
 (_ecef_of_ned_point_d, Gfun(Internal f_ecef_of_ned_point_d)) ::
 (_ecef_of_enu_vect_d, Gfun(Internal f_ecef_of_enu_vect_d)) ::
 (_ecef_of_ned_vect_d, Gfun(Internal f_ecef_of_ned_vect_d)) ::
 (_enu_of_lla_point_d, Gfun(Internal f_enu_of_lla_point_d)) ::
 (_ned_of_lla_point_d, Gfun(Internal f_ned_of_lla_point_d)) ::
 (_gc_of_gd_lat_d, Gfun(Internal f_gc_of_gd_lat_d)) ::
 (_serie_coeff_proj_mercator, Gvar v_serie_coeff_proj_mercator) ::
 (_serie_coeff_proj_mercator_inverse, Gvar v_serie_coeff_proj_mercator_inverse) ::
 (_isometric_latitude_d, Gfun(Internal f_isometric_latitude_d)) ::
 (_isometric_latitude_fast_d, Gfun(Internal f_isometric_latitude_fast_d)) ::
 (_inverse_isometric_latitude_d, Gfun(Internal f_inverse_isometric_latitude_d)) ::
 (_utm_of_lla_d, Gfun(Internal f_utm_of_lla_d)) ::
 (_lla_of_utm_d, Gfun(Internal f_lla_of_utm_d)) ::
 (_five_keep_ltp_def_from_ecef_d, Gvar v_five_keep_ltp_def_from_ecef_d) ::
 (_five_keep_ltp_def_from_lla_d, Gvar v_five_keep_ltp_def_from_lla_d) ::
 (_five_keep_lla_of_ecef_d, Gvar v_five_keep_lla_of_ecef_d) ::
 (_five_keep_ecef_of_lla_d, Gvar v_five_keep_ecef_of_lla_d) ::
 (_five_keep_enu_of_ecef_point_d, Gvar v_five_keep_enu_of_ecef_point_d) ::
 (_five_keep_ned_of_ecef_point_d, Gvar v_five_keep_ned_of_ecef_point_d) ::
 (_five_keep_enu_of_ecef_vect_d, Gvar v_five_keep_enu_of_ecef_vect_d) ::
 (_five_keep_ned_of_ecef_vect_d, Gvar v_five_keep_ned_of_ecef_vect_d) ::
 (_five_keep_ecef_of_enu_point_d, Gvar v_five_keep_ecef_of_enu_point_d) ::
 (_five_keep_ecef_of_ned_point_d, Gvar v_five_keep_ecef_of_ned_point_d) ::
 (_five_keep_ecef_of_enu_vect_d, Gvar v_five_keep_ecef_of_enu_vect_d) ::
 (_five_keep_ecef_of_ned_vect_d, Gvar v_five_keep_ecef_of_ned_vect_d) ::
 (_five_keep_enu_of_lla_point_d, Gvar v_five_keep_enu_of_lla_point_d) ::
 (_five_keep_ned_of_lla_point_d, Gvar v_five_keep_ned_of_lla_point_d) ::
 (_five_keep_gc_of_gd_lat_d, Gvar v_five_keep_gc_of_gd_lat_d) ::
 (_five_keep_isometric_latitude_d, Gvar v_five_keep_isometric_latitude_d) ::
 (_five_keep_isometric_latitude_fast_d, Gvar v_five_keep_isometric_latitude_fast_d) ::
 (_five_keep_inverse_isometric_latitude_d, Gvar v_five_keep_inverse_isometric_latitude_d) ::
 (_five_keep_utm_of_lla_d, Gvar v_five_keep_utm_of_lla_d) ::
 (_five_keep_lla_of_utm_d, Gvar v_five_keep_lla_of_utm_d) :: nil).

Definition public_idents : list ident :=
(_five_keep_lla_of_utm_d :: _five_keep_utm_of_lla_d ::
 _five_keep_inverse_isometric_latitude_d ::
 _five_keep_isometric_latitude_fast_d :: _five_keep_isometric_latitude_d ::
 _five_keep_gc_of_gd_lat_d :: _five_keep_ned_of_lla_point_d ::
 _five_keep_enu_of_lla_point_d :: _five_keep_ecef_of_ned_vect_d ::
 _five_keep_ecef_of_enu_vect_d :: _five_keep_ecef_of_ned_point_d ::
 _five_keep_ecef_of_enu_point_d :: _five_keep_ned_of_ecef_vect_d ::
 _five_keep_enu_of_ecef_vect_d :: _five_keep_ned_of_ecef_point_d ::
 _five_keep_enu_of_ecef_point_d :: _five_keep_ecef_of_lla_d ::
 _five_keep_lla_of_ecef_d :: _five_keep_ltp_def_from_lla_d ::
 _five_keep_ltp_def_from_ecef_d :: _lla_of_utm_d :: _utm_of_lla_d ::
 _gc_of_gd_lat_d :: _ned_of_lla_point_d :: _enu_of_lla_point_d ::
 _ecef_of_ned_vect_d :: _ecef_of_enu_vect_d :: _ecef_of_ned_point_d ::
 _ecef_of_enu_point_d :: _ned_of_ecef_vect_d :: _enu_of_ecef_vect_d ::
 _ned_of_ecef_point_d :: _enu_of_ecef_point_d :: _ecef_of_lla_d ::
 _lla_of_ecef_d :: _ltp_def_from_lla_d :: _ltp_def_from_ecef_d :: _floor ::
 _fabs :: _sqrt :: _pow :: _log :: _exp :: _sinh :: _cosh :: _tan :: _sin ::
 _cos :: _atan2 :: _atan :: _asin :: ___builtin_debug ::
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


