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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/navigation-vision-models/integer_navigation/model/preprocessed.i".
End Info.

Definition _EcefCoor_d : ident := $"EcefCoor_d".
Definition _EcefCoor_i : ident := $"EcefCoor_i".
Definition _EnuCoor_i : ident := $"EnuCoor_i".
Definition _Int32RMat : ident := $"Int32RMat".
Definition _LlaCoor_d : ident := $"LlaCoor_d".
Definition _LlaCoor_i : ident := $"LlaCoor_i".
Definition _LtpDef_i : ident := $"LtpDef_i".
Definition _NedCoor_i : ident := $"NedCoor_i".
Definition _UtmCoor_d : ident := $"UtmCoor_d".
Definition _UtmCoor_i : ident := $"UtmCoor_i".
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
Definition _alt : ident := $"alt".
Definition _cos : ident := $"cos".
Definition _cos_lat : ident := $"cos_lat".
Definition _cos_lon : ident := $"cos_lon".
Definition _def : ident := $"def".
Definition _delta : ident := $"delta".
Definition _east : ident := $"east".
Definition _ecef : ident := $"ecef".
Definition _ecef_of_enu_point_i : ident := $"ecef_of_enu_point_i".
Definition _ecef_of_enu_pos_i : ident := $"ecef_of_enu_pos_i".
Definition _ecef_of_enu_vect_i : ident := $"ecef_of_enu_vect_i".
Definition _ecef_of_lla_d : ident := $"ecef_of_lla_d".
Definition _ecef_of_lla_i : ident := $"ecef_of_lla_i".
Definition _ecef_of_ned_point_i : ident := $"ecef_of_ned_point_i".
Definition _ecef_of_ned_pos_i : ident := $"ecef_of_ned_pos_i".
Definition _ecef_of_ned_vect_i : ident := $"ecef_of_ned_vect_i".
Definition _enu : ident := $"enu".
Definition _enu_cm : ident := $"enu_cm".
Definition _enu_of_ecef_point_i : ident := $"enu_of_ecef_point_i".
Definition _enu_of_ecef_pos_i : ident := $"enu_of_ecef_pos_i".
Definition _enu_of_ecef_vect_i : ident := $"enu_of_ecef_vect_i".
Definition _enu_of_lla_point_i : ident := $"enu_of_lla_point_i".
Definition _enu_of_lla_pos_i : ident := $"enu_of_lla_pos_i".
Definition _enu_of_lla_vect_i : ident := $"enu_of_lla_vect_i".
Definition _five_keep_ecef_of_enu_point_i : ident := $"five_keep_ecef_of_enu_point_i".
Definition _five_keep_ecef_of_enu_pos_i : ident := $"five_keep_ecef_of_enu_pos_i".
Definition _five_keep_ecef_of_enu_vect_i : ident := $"five_keep_ecef_of_enu_vect_i".
Definition _five_keep_ecef_of_lla_i : ident := $"five_keep_ecef_of_lla_i".
Definition _five_keep_ecef_of_ned_point_i : ident := $"five_keep_ecef_of_ned_point_i".
Definition _five_keep_ecef_of_ned_pos_i : ident := $"five_keep_ecef_of_ned_pos_i".
Definition _five_keep_ecef_of_ned_vect_i : ident := $"five_keep_ecef_of_ned_vect_i".
Definition _five_keep_enu_of_ecef_point_i : ident := $"five_keep_enu_of_ecef_point_i".
Definition _five_keep_enu_of_ecef_pos_i : ident := $"five_keep_enu_of_ecef_pos_i".
Definition _five_keep_enu_of_ecef_vect_i : ident := $"five_keep_enu_of_ecef_vect_i".
Definition _five_keep_enu_of_lla_point_i : ident := $"five_keep_enu_of_lla_point_i".
Definition _five_keep_enu_of_lla_pos_i : ident := $"five_keep_enu_of_lla_pos_i".
Definition _five_keep_enu_of_lla_vect_i : ident := $"five_keep_enu_of_lla_vect_i".
Definition _five_keep_lla_of_ecef_i : ident := $"five_keep_lla_of_ecef_i".
Definition _five_keep_lla_of_utm_i : ident := $"five_keep_lla_of_utm_i".
Definition _five_keep_ltp_def_from_ecef_i : ident := $"five_keep_ltp_def_from_ecef_i".
Definition _five_keep_ltp_def_from_lla_i : ident := $"five_keep_ltp_def_from_lla_i".
Definition _five_keep_ltp_of_ecef_rmat_from_lla_i : ident := $"five_keep_ltp_of_ecef_rmat_from_lla_i".
Definition _five_keep_ned_of_ecef_point_i : ident := $"five_keep_ned_of_ecef_point_i".
Definition _five_keep_ned_of_ecef_pos_i : ident := $"five_keep_ned_of_ecef_pos_i".
Definition _five_keep_ned_of_ecef_vect_i : ident := $"five_keep_ned_of_ecef_vect_i".
Definition _five_keep_ned_of_lla_point_i : ident := $"five_keep_ned_of_lla_point_i".
Definition _five_keep_ned_of_lla_pos_i : ident := $"five_keep_ned_of_lla_pos_i".
Definition _five_keep_ned_of_lla_vect_i : ident := $"five_keep_ned_of_lla_vect_i".
Definition _five_keep_utm_of_lla_i : ident := $"five_keep_utm_of_lla_i".
Definition _hmsl : ident := $"hmsl".
Definition _in : ident := $"in".
Definition _in_d : ident := $"in_d".
Definition _lat : ident := $"lat".
Definition _lla : ident := $"lla".
Definition _lla_d : ident := $"lla_d".
Definition _lla_of_ecef_d : ident := $"lla_of_ecef_d".
Definition _lla_of_ecef_i : ident := $"lla_of_ecef_i".
Definition _lla_of_utm_d : ident := $"lla_of_utm_d".
Definition _lla_of_utm_i : ident := $"lla_of_utm_i".
Definition _lon : ident := $"lon".
Definition _ltp_def_from_ecef_i : ident := $"ltp_def_from_ecef_i".
Definition _ltp_def_from_lla_i : ident := $"ltp_def_from_lla_i".
Definition _ltp_of_ecef : ident := $"ltp_of_ecef".
Definition _ltp_of_ecef_rmat_from_lla_i : ident := $"ltp_of_ecef_rmat_from_lla_i".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _ned : ident := $"ned".
Definition _ned_of_ecef_point_i : ident := $"ned_of_ecef_point_i".
Definition _ned_of_ecef_pos_i : ident := $"ned_of_ecef_pos_i".
Definition _ned_of_ecef_vect_i : ident := $"ned_of_ecef_vect_i".
Definition _ned_of_lla_point_i : ident := $"ned_of_lla_point_i".
Definition _ned_of_lla_pos_i : ident := $"ned_of_lla_pos_i".
Definition _ned_of_lla_vect_i : ident := $"ned_of_lla_vect_i".
Definition _north : ident := $"north".
Definition _out : ident := $"out".
Definition _out_d : ident := $"out_d".
Definition _rint : ident := $"rint".
Definition _sin : ident := $"sin".
Definition _sin_lat : ident := $"sin_lat".
Definition _sin_lon : ident := $"sin_lon".
Definition _tmpx : ident := $"tmpx".
Definition _tmpy : ident := $"tmpy".
Definition _tmpz : ident := $"tmpz".
Definition _utm : ident := $"utm".
Definition _utm_d : ident := $"utm_d".
Definition _utm_of_lla_d : ident := $"utm_of_lla_d".
Definition _utm_of_lla_i : ident := $"utm_of_lla_i".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".
Definition _zone : ident := $"zone".

Definition f_ltp_of_ecef_rmat_from_lla_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ltp_of_ecef, (tptr (Tstruct _Int32RMat noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_sin_lat, tint) :: (_cos_lat, tint) :: (_sin_lon, tint) ::
              (_cos_lon, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sin_lat tint)
         (Ecall
           (Evalof
             (Evar _rint (Tfunction (tdouble :: nil) tdouble cc_default))
             (Tfunction (tdouble :: nil) tdouble cc_default))
           (Econs
             (Ebinop Omul
               (Ecall
                 (Evalof
                   (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Ebinop Odiv
                     (Ebinop Omul
                       (Ecast
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                                   (tptr (Tstruct _LlaCoor_i noattr)))
                                 (Tstruct _LlaCoor_i noattr))
                               (Tstruct _LlaCoor_i noattr)) _lat tint) tint)
                         tdouble)
                       (Ebinop Odiv
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                         tdouble) tdouble)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                     tdouble) Enil) tdouble)
               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                 (Eval (Vint (Int.repr 20)) tint) tint) tdouble) Enil)
           tdouble) tint))
  (Ssequence
    (Sdo (Eassign (Evar _cos_lat tint)
           (Ecall
             (Evalof
               (Evar _rint (Tfunction (tdouble :: nil) tdouble cc_default))
               (Tfunction (tdouble :: nil) tdouble cc_default))
             (Econs
               (Ebinop Omul
                 (Ecall
                   (Evalof
                     (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Ebinop Odiv
                       (Ebinop Omul
                         (Ecast
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                                     (tptr (Tstruct _LlaCoor_i noattr)))
                                   (Tstruct _LlaCoor_i noattr))
                                 (Tstruct _LlaCoor_i noattr)) _lat tint)
                             tint) tdouble)
                         (Ebinop Odiv
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                           tdouble) tdouble)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                       tdouble) Enil) tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 20)) tint) tint) tdouble) Enil)
             tdouble) tint))
    (Ssequence
      (Sdo (Eassign (Evar _sin_lon tint)
             (Ecall
               (Evalof
                 (Evar _rint (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Tfunction (tdouble :: nil) tdouble cc_default))
               (Econs
                 (Ebinop Omul
                   (Ecall
                     (Evalof
                       (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                    cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs
                       (Ebinop Odiv
                         (Ebinop Omul
                           (Ecast
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                                       (tptr (Tstruct _LlaCoor_i noattr)))
                                     (Tstruct _LlaCoor_i noattr))
                                   (Tstruct _LlaCoor_i noattr)) _lon tint)
                               tint) tdouble)
                           (Ebinop Odiv
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                             tdouble) tdouble)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                         tdouble) Enil) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 20)) tint) tint) tdouble) Enil)
               tdouble) tint))
      (Ssequence
        (Sdo (Eassign (Evar _cos_lon tint)
               (Ecall
                 (Evalof
                   (Evar _rint (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs
                   (Ebinop Omul
                     (Ecall
                       (Evalof
                         (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                      cc_default))
                         (Tfunction (tdouble :: nil) tdouble cc_default))
                       (Econs
                         (Ebinop Odiv
                           (Ebinop Omul
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                                         (tptr (Tstruct _LlaCoor_i noattr)))
                                       (Tstruct _LlaCoor_i noattr))
                                     (Tstruct _LlaCoor_i noattr)) _lon tint)
                                 tint) tdouble)
                             (Ebinop Odiv
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                               tdouble) tdouble)
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                           tdouble) Enil) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 20)) tint) tint) tdouble) Enil)
                 tdouble) tint))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tint)) tint)
                 (Eunop Oneg (Evalof (Evar _sin_lon tint) tint) tint) tint))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tint)) tint) (Evalof (Evar _cos_lon tint) tint)
                   tint))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 2)) tint) (tptr tint)) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tint)) tint)
                       (Ecast
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Eunop Oneg
                               (Ecast (Evalof (Evar _sin_lat tint) tint)
                                 tlong) tlong)
                             (Ecast (Evalof (Evar _cos_lon tint) tint) tlong)
                             tlong) (Eval (Vint (Int.repr 20)) tint) tlong)
                         tint) tint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                           tint)
                         (Ecast
                           (Ebinop Oshr
                             (Ebinop Omul
                               (Eunop Oneg
                                 (Ecast (Evalof (Evar _sin_lat tint) tint)
                                   tlong) tlong)
                               (Ecast (Evalof (Evar _sin_lon tint) tint)
                                 tlong) tlong)
                             (Eval (Vint (Int.repr 20)) tint) tlong) tint)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                             tint) (Evalof (Evar _cos_lat tint) tint) tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 6)) tint) (tptr tint))
                               tint)
                             (Ecast
                               (Ebinop Oshr
                                 (Ebinop Omul
                                   (Ecast (Evalof (Evar _cos_lat tint) tint)
                                     tlong)
                                   (Ecast (Evalof (Evar _cos_lon tint) tint)
                                     tlong) tlong)
                                 (Eval (Vint (Int.repr 20)) tint) tlong)
                               tint) tint))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tint)) tint)
                               (Ecast
                                 (Ebinop Oshr
                                   (Ebinop Omul
                                     (Ecast
                                       (Evalof (Evar _cos_lat tint) tint)
                                       tlong)
                                     (Ecast
                                       (Evalof (Evar _sin_lon tint) tint)
                                       tlong) tlong)
                                   (Eval (Vint (Int.repr 20)) tint) tlong)
                                 tint) tint))
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _ltp_of_ecef (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint)
                               (Evalof (Evar _sin_lat tint) tint) tint))))))))))))))
|}.

Definition f_ltp_def_from_ecef_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                       (tptr (Tstruct _LtpDef_i noattr)))
                     (Tstruct _LtpDef_i noattr)) (Tstruct _LtpDef_i noattr))
                 _ecef (Tstruct _EcefCoor_i noattr))
               (Tstruct _EcefCoor_i noattr)) _x tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                     (tptr (Tstruct _EcefCoor_i noattr)))
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _x tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _ecef
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _y tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _y tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _ecef
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _z tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _z tint) tint) tint))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _lla_of_ecef_i (Tfunction
                                    ((tptr (Tstruct _LlaCoor_i noattr)) ::
                                     (tptr (Tstruct _EcefCoor_i noattr)) ::
                                     nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _LlaCoor_i noattr)) ::
                (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                       (tptr (Tstruct _LtpDef_i noattr)))
                     (Tstruct _LtpDef_i noattr)) (Tstruct _LtpDef_i noattr))
                 _lla (Tstruct _LlaCoor_i noattr))
               (tptr (Tstruct _LlaCoor_i noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _ecef
                   (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil)) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _ltp_of_ecef_rmat_from_lla_i (Tfunction
                                                  ((tptr (Tstruct _Int32RMat noattr)) ::
                                                   (tptr (Tstruct _LlaCoor_i noattr)) ::
                                                   nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _Int32RMat noattr)) ::
                (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                       (tptr (Tstruct _LtpDef_i noattr)))
                     (Tstruct _LtpDef_i noattr)) (Tstruct _LtpDef_i noattr))
                 _ltp_of_ecef (Tstruct _Int32RMat noattr))
               (tptr (Tstruct _Int32RMat noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _lla
                   (Tstruct _LlaCoor_i noattr))
                 (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))))
|}.

Definition f_ltp_def_from_lla_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                       (tptr (Tstruct _LtpDef_i noattr)))
                     (Tstruct _LtpDef_i noattr)) (Tstruct _LtpDef_i noattr))
                 _lla (Tstruct _LlaCoor_i noattr))
               (Tstruct _LlaCoor_i noattr)) _lat tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                     (tptr (Tstruct _LlaCoor_i noattr)))
                   (Tstruct _LlaCoor_i noattr)) (Tstruct _LlaCoor_i noattr))
               _lat tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _lla
                   (Tstruct _LlaCoor_i noattr)) (Tstruct _LlaCoor_i noattr))
               _lon tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                       (tptr (Tstruct _LlaCoor_i noattr)))
                     (Tstruct _LlaCoor_i noattr))
                   (Tstruct _LlaCoor_i noattr)) _lon tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _lla
                   (Tstruct _LlaCoor_i noattr)) (Tstruct _LlaCoor_i noattr))
               _alt tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                       (tptr (Tstruct _LlaCoor_i noattr)))
                     (Tstruct _LlaCoor_i noattr))
                   (Tstruct _LlaCoor_i noattr)) _alt tint) tint) tint))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _ecef_of_lla_i (Tfunction
                                    ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                     (tptr (Tstruct _LlaCoor_i noattr)) ::
                                     nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _EcefCoor_i noattr)) ::
                (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                       (tptr (Tstruct _LtpDef_i noattr)))
                     (Tstruct _LtpDef_i noattr)) (Tstruct _LtpDef_i noattr))
                 _ecef (Tstruct _EcefCoor_i noattr))
               (tptr (Tstruct _EcefCoor_i noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _lla
                   (Tstruct _LlaCoor_i noattr))
                 (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _ltp_of_ecef_rmat_from_lla_i (Tfunction
                                                  ((tptr (Tstruct _Int32RMat noattr)) ::
                                                   (tptr (Tstruct _LlaCoor_i noattr)) ::
                                                   nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _Int32RMat noattr)) ::
                (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                       (tptr (Tstruct _LtpDef_i noattr)))
                     (Tstruct _LtpDef_i noattr)) (Tstruct _LtpDef_i noattr))
                 _ltp_of_ecef (Tstruct _Int32RMat noattr))
               (tptr (Tstruct _Int32RMat noattr)))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _lla
                   (Tstruct _LlaCoor_i noattr))
                 (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))))
|}.

Definition f_enu_of_ecef_point_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_delta, (Tstruct _EcefCoor_i noattr)) :: (_tmpx, tlong) ::
              (_tmpy, tlong) :: (_tmpz, tlong) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
               (Tstruct _EcefCoor_i noattr)) _x tint)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _x tint) tint)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                           (tptr (Tstruct _LtpDef_i noattr)))
                         (Tstruct _LtpDef_i noattr))
                       (Tstruct _LtpDef_i noattr)) _ecef
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _x tint) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _y tint)
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _y tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                             (tptr (Tstruct _LtpDef_i noattr)))
                           (Tstruct _LtpDef_i noattr))
                         (Tstruct _LtpDef_i noattr)) _ecef
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _y tint) tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _z tint)
             (Ebinop Osub
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _z tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                             (tptr (Tstruct _LtpDef_i noattr)))
                           (Tstruct _LtpDef_i noattr))
                         (Tstruct _LtpDef_i noattr)) _ecef
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _z tint) tint) tint) tint))))
  (Ssequence
    (Sdo (Eassign (Evar _tmpx tlong)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
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
                                       (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                       (tptr (Tstruct _LtpDef_i noattr)))
                                     (Tstruct _LtpDef_i noattr))
                                   (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                     tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _x tint) tint) tlong)
               (Ebinop Omul
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
                                       (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                       (tptr (Tstruct _LtpDef_i noattr)))
                                     (Tstruct _LtpDef_i noattr))
                                   (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                     tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _y tint) tint) tlong)
               tlong) (Eval (Vint (Int.repr 0)) tint) tlong) tlong))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                     (tptr (Tstruct _EnuCoor_i noattr)))
                   (Tstruct _EnuCoor_i noattr)) (Tstruct _EnuCoor_i noattr))
               _x tint)
             (Ecast
               (Ebinop Oshr (Evalof (Evar _tmpx tlong) tlong)
                 (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _tmpy tlong)
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Omul
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
                                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                           (tptr (Tstruct _LtpDef_i noattr)))
                                         (Tstruct _LtpDef_i noattr))
                                       (Tstruct _LtpDef_i noattr))
                                     _ltp_of_ecef
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                           tint) tint) tlong)
                     (Evalof
                       (Efield
                         (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                           (Tstruct _EcefCoor_i noattr)) _x tint) tint)
                     tlong)
                   (Ebinop Omul
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
                                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                           (tptr (Tstruct _LtpDef_i noattr)))
                                         (Tstruct _LtpDef_i noattr))
                                       (Tstruct _LtpDef_i noattr))
                                     _ltp_of_ecef
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                           tint) tint) tlong)
                     (Evalof
                       (Efield
                         (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                           (Tstruct _EcefCoor_i noattr)) _y tint) tint)
                     tlong) tlong)
                 (Ebinop Omul
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
                                         (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                         (tptr (Tstruct _LtpDef_i noattr)))
                                       (Tstruct _LtpDef_i noattr))
                                     (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                         (Tstruct _EcefCoor_i noattr)) _z tint) tint) tlong)
                 tlong) tlong))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _y tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmpy tlong) tlong)
                     (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar _tmpz tlong)
                   (Ebinop Oadd
                     (Ebinop Oadd
                       (Ebinop Omul
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
                                               (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                               (tptr (Tstruct _LtpDef_i noattr)))
                                             (Tstruct _LtpDef_i noattr))
                                           (Tstruct _LtpDef_i noattr))
                                         _ltp_of_ecef
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 6)) tint) (tptr tint))
                               tint) tint) tlong)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _delta (Tstruct _EcefCoor_i noattr))
                               (Tstruct _EcefCoor_i noattr)) _x tint) tint)
                         tlong)
                       (Ebinop Omul
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
                                               (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                               (tptr (Tstruct _LtpDef_i noattr)))
                                             (Tstruct _LtpDef_i noattr))
                                           (Tstruct _LtpDef_i noattr))
                                         _ltp_of_ecef
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                               tint) tint) tlong)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _delta (Tstruct _EcefCoor_i noattr))
                               (Tstruct _EcefCoor_i noattr)) _y tint) tint)
                         tlong) tlong)
                     (Ebinop Omul
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
                                             (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                             (tptr (Tstruct _LtpDef_i noattr)))
                                           (Tstruct _LtpDef_i noattr))
                                         (Tstruct _LtpDef_i noattr))
                                       _ltp_of_ecef
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                             tint) tint) tlong)
                       (Evalof
                         (Efield
                           (Evalof (Evar _delta (Tstruct _EcefCoor_i noattr))
                             (Tstruct _EcefCoor_i noattr)) _z tint) tint)
                       tlong) tlong) tlong))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                           (tptr (Tstruct _EnuCoor_i noattr)))
                         (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _z tint)
                   (Ecast
                     (Ebinop Oshr (Evalof (Evar _tmpz tlong) tlong)
                       (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))))))))
|}.

Definition f_ned_of_ecef_point_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_i (Tfunction
                                        ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                         (tptr (Tstruct _LtpDef_i noattr)) ::
                                         (tptr (Tstruct _EcefCoor_i noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu (Tstruct _EnuCoor_i noattr))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                   (tptr (Tstruct _NedCoor_i noattr)))
                 (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr)) _x
             tint)
           (Evalof
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _y tint)
             (Evalof
               (Efield
                 (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _x tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _z tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _z tint) tint) tint) tint)))))
|}.

Definition f_enu_of_ecef_pos_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_enu_cm, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_i (Tfunction
                                        ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                         (tptr (Tstruct _LtpDef_i noattr)) ::
                                         (tptr (Tstruct _EcefCoor_i noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid))
  (Ssequence
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                     (tptr (Tstruct _EnuCoor_i noattr)))
                   (Tstruct _EnuCoor_i noattr)) (Tstruct _EnuCoor_i noattr))
               _x tint)
             (Ebinop Oshl
               (Evalof
                 (Efield
                   (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _x tint) tint)
               (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _y tint)
               (Ebinop Oshl
                 (Evalof
                   (Efield
                     (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _y tint) tint)
                 (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _z tint)
               (Ebinop Oshl
                 (Evalof
                   (Efield
                     (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _z tint) tint)
                 (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint) tint))))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                     (tptr (Tstruct _EnuCoor_i noattr)))
                   (Tstruct _EnuCoor_i noattr)) (Tstruct _EnuCoor_i noattr))
               _x tint)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _x tint) tint)
               (Eval (Vint (Int.repr 25)) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _y tint)
               (Ebinop Odiv
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                           (tptr (Tstruct _EnuCoor_i noattr)))
                         (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _y tint) tint)
                 (Eval (Vint (Int.repr 25)) tint) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _z tint)
               (Ebinop Odiv
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                           (tptr (Tstruct _EnuCoor_i noattr)))
                         (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _z tint) tint)
                 (Eval (Vint (Int.repr 25)) tint) tint) tint))))))
|}.

Definition f_ned_of_ecef_pos_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_pos_i (Tfunction
                                      ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                       (tptr (Tstruct _LtpDef_i noattr)) ::
                                       (tptr (Tstruct _EcefCoor_i noattr)) ::
                                       nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu (Tstruct _EnuCoor_i noattr))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                   (tptr (Tstruct _NedCoor_i noattr)))
                 (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr)) _x
             tint)
           (Evalof
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _y tint)
             (Evalof
               (Efield
                 (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _x tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _z tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _z tint) tint) tint) tint)))))
|}.

Definition f_enu_of_ecef_vect_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_tmpx, tlong) :: (_tmpy, tlong) :: (_tmpz, tlong) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tmpx tlong)
         (Ebinop Oadd
           (Ebinop Oadd
             (Ebinop Omul
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
                                     (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                     (tptr (Tstruct _LtpDef_i noattr)))
                                   (Tstruct _LtpDef_i noattr))
                                 (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _x tint) tint) tlong)
             (Ebinop Omul
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
                                     (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                     (tptr (Tstruct _LtpDef_i noattr)))
                                   (Tstruct _LtpDef_i noattr))
                                 (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _y tint) tint) tlong)
             tlong) (Eval (Vint (Int.repr 0)) tint) tlong) tlong))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                   (tptr (Tstruct _EnuCoor_i noattr)))
                 (Tstruct _EnuCoor_i noattr)) (Tstruct _EnuCoor_i noattr)) _x
             tint)
           (Ecast
             (Ebinop Oshr (Evalof (Evar _tmpx tlong) tlong)
               (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _tmpy tlong)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
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
                                         (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                         (tptr (Tstruct _LtpDef_i noattr)))
                                       (Tstruct _LtpDef_i noattr))
                                     (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                             (tptr (Tstruct _EcefCoor_i noattr)))
                           (Tstruct _EcefCoor_i noattr))
                         (Tstruct _EcefCoor_i noattr)) _x tint) tint) tlong)
                 (Ebinop Omul
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
                                         (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                         (tptr (Tstruct _LtpDef_i noattr)))
                                       (Tstruct _LtpDef_i noattr))
                                     (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                             (tptr (Tstruct _EcefCoor_i noattr)))
                           (Tstruct _EcefCoor_i noattr))
                         (Tstruct _EcefCoor_i noattr)) _y tint) tint) tlong)
                 tlong)
               (Ebinop Omul
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
                                       (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                       (tptr (Tstruct _LtpDef_i noattr)))
                                     (Tstruct _LtpDef_i noattr))
                                   (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                     tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                           (tptr (Tstruct _EcefCoor_i noattr)))
                         (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _z tint) tint) tlong)
               tlong) tlong))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _y tint)
               (Ecast
                 (Ebinop Oshr (Evalof (Evar _tmpy tlong) tlong)
                   (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _tmpz tlong)
                 (Ebinop Oadd
                   (Ebinop Oadd
                     (Ebinop Omul
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
                                             (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                             (tptr (Tstruct _LtpDef_i noattr)))
                                           (Tstruct _LtpDef_i noattr))
                                         (Tstruct _LtpDef_i noattr))
                                       _ltp_of_ecef
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 6)) tint) (tptr tint))
                             tint) tint) tlong)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                                 (tptr (Tstruct _EcefCoor_i noattr)))
                               (Tstruct _EcefCoor_i noattr))
                             (Tstruct _EcefCoor_i noattr)) _x tint) tint)
                       tlong)
                     (Ebinop Omul
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
                                             (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                             (tptr (Tstruct _LtpDef_i noattr)))
                                           (Tstruct _LtpDef_i noattr))
                                         (Tstruct _LtpDef_i noattr))
                                       _ltp_of_ecef
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                             tint) tint) tlong)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                                 (tptr (Tstruct _EcefCoor_i noattr)))
                               (Tstruct _EcefCoor_i noattr))
                             (Tstruct _EcefCoor_i noattr)) _y tint) tint)
                       tlong) tlong)
                   (Ebinop Omul
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
                                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                           (tptr (Tstruct _LtpDef_i noattr)))
                                         (Tstruct _LtpDef_i noattr))
                                       (Tstruct _LtpDef_i noattr))
                                     _ltp_of_ecef
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                           tint) tint) tlong)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                               (tptr (Tstruct _EcefCoor_i noattr)))
                             (Tstruct _EcefCoor_i noattr))
                           (Tstruct _EcefCoor_i noattr)) _z tint) tint)
                     tlong) tlong) tlong))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _z tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmpz tlong) tlong)
                     (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint)))))))
|}.

Definition f_ned_of_ecef_vect_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ecef, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_vect_i (Tfunction
                                       ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                        (tptr (Tstruct _LtpDef_i noattr)) ::
                                        (tptr (Tstruct _EcefCoor_i noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _enu (Tstruct _EnuCoor_i noattr))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                   (tptr (Tstruct _NedCoor_i noattr)))
                 (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr)) _x
             tint)
           (Evalof
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _y tint)
             (Evalof
               (Efield
                 (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _x tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _z tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _z tint) tint) tint) tint)))))
|}.

Definition f_ecef_of_enu_vect_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_enu, (tptr (Tstruct _EnuCoor_i noattr))) :: nil);
  fn_vars := ((_tmpx, tlong) :: (_tmpy, tlong) :: (_tmpz, tlong) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tmpx tlong)
         (Ebinop Oadd
           (Ebinop Oadd
             (Ebinop Omul
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
                                     (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                     (tptr (Tstruct _LtpDef_i noattr)))
                                   (Tstruct _LtpDef_i noattr))
                                 (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _x tint) tint) tlong)
             (Ebinop Omul
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
                                     (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                     (tptr (Tstruct _LtpDef_i noattr)))
                                   (Tstruct _LtpDef_i noattr))
                                 (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _y tint) tint) tlong)
             tlong)
           (Ebinop Omul
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
                                   (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                   (tptr (Tstruct _LtpDef_i noattr)))
                                 (Tstruct _LtpDef_i noattr))
                               (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tint)) tint) tint) tlong)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _z tint) tint) tlong) tlong)
         tlong))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                   (tptr (Tstruct _EcefCoor_i noattr)))
                 (Tstruct _EcefCoor_i noattr)) (Tstruct _EcefCoor_i noattr))
             _x tint)
           (Ecast
             (Ebinop Oshr (Evalof (Evar _tmpx tlong) tlong)
               (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _tmpy tlong)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
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
                                         (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                         (tptr (Tstruct _LtpDef_i noattr)))
                                       (Tstruct _LtpDef_i noattr))
                                     (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                             (tptr (Tstruct _EnuCoor_i noattr)))
                           (Tstruct _EnuCoor_i noattr))
                         (Tstruct _EnuCoor_i noattr)) _x tint) tint) tlong)
                 (Ebinop Omul
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
                                         (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                         (tptr (Tstruct _LtpDef_i noattr)))
                                       (Tstruct _LtpDef_i noattr))
                                     (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                             (tptr (Tstruct _EnuCoor_i noattr)))
                           (Tstruct _EnuCoor_i noattr))
                         (Tstruct _EnuCoor_i noattr)) _y tint) tint) tlong)
                 tlong)
               (Ebinop Omul
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
                                       (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                       (tptr (Tstruct _LtpDef_i noattr)))
                                     (Tstruct _LtpDef_i noattr))
                                   (Tstruct _LtpDef_i noattr)) _ltp_of_ecef
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 7)) tint) (tptr tint)) tint)
                     tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                           (tptr (Tstruct _EnuCoor_i noattr)))
                         (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _z tint) tint) tlong)
               tlong) tlong))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _y tint)
               (Ecast
                 (Ebinop Oshr (Evalof (Evar _tmpy tlong) tlong)
                   (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _tmpz tlong)
                 (Ebinop Oadd
                   (Ebinop Omul
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
                                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                           (tptr (Tstruct _LtpDef_i noattr)))
                                         (Tstruct _LtpDef_i noattr))
                                       (Tstruct _LtpDef_i noattr))
                                     _ltp_of_ecef
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                           tint) tint) tlong)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                               (tptr (Tstruct _EnuCoor_i noattr)))
                             (Tstruct _EnuCoor_i noattr))
                           (Tstruct _EnuCoor_i noattr)) _y tint) tint) tlong)
                   (Ebinop Omul
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
                                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                                           (tptr (Tstruct _LtpDef_i noattr)))
                                         (Tstruct _LtpDef_i noattr))
                                       (Tstruct _LtpDef_i noattr))
                                     _ltp_of_ecef
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                           tint) tint) tlong)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                               (tptr (Tstruct _EnuCoor_i noattr)))
                             (Tstruct _EnuCoor_i noattr))
                           (Tstruct _EnuCoor_i noattr)) _z tint) tint) tlong)
                   tlong) tlong))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _z tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmpz tlong) tlong)
                     (Eval (Vint (Int.repr 20)) tint) tlong) tint) tint)))))))
|}.

Definition f_ecef_of_ned_vect_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ned, (tptr (Tstruct _NedCoor_i noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
               (Tstruct _EnuCoor_i noattr)) _x tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _y tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                       (tptr (Tstruct _NedCoor_i noattr)))
                     (Tstruct _NedCoor_i noattr))
                   (Tstruct _NedCoor_i noattr)) _x tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _z tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                         (tptr (Tstruct _NedCoor_i noattr)))
                       (Tstruct _NedCoor_i noattr))
                     (Tstruct _NedCoor_i noattr)) _z tint) tint) tint) tint))))
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_vect_i (Tfunction
                                       ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                        (tptr (Tstruct _LtpDef_i noattr)) ::
                                        (tptr (Tstruct _EnuCoor_i noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EnuCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (tptr (Tstruct _EnuCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_ecef_of_enu_point_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_enu, (tptr (Tstruct _EnuCoor_i noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_vect_i (Tfunction
                                       ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                        (tptr (Tstruct _LtpDef_i noattr)) ::
                                        (tptr (Tstruct _EnuCoor_i noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EnuCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                 (tptr (Tstruct _EnuCoor_i noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                   (tptr (Tstruct _EcefCoor_i noattr)))
                 (Tstruct _EcefCoor_i noattr)) (Tstruct _EcefCoor_i noattr))
             _x tint)
           (Evalof
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                         (tptr (Tstruct _LtpDef_i noattr)))
                       (Tstruct _LtpDef_i noattr))
                     (Tstruct _LtpDef_i noattr)) _ecef
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _x tint) tint) tint tint))
    (Ssequence
      (Sdo (Eassignop Oadd
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                     (tptr (Tstruct _EcefCoor_i noattr)))
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _y tint)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                           (tptr (Tstruct _LtpDef_i noattr)))
                         (Tstruct _LtpDef_i noattr))
                       (Tstruct _LtpDef_i noattr)) _ecef
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _y tint) tint) tint tint))
      (Sdo (Eassignop Oadd
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                     (tptr (Tstruct _EcefCoor_i noattr)))
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _z tint)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                           (tptr (Tstruct _LtpDef_i noattr)))
                         (Tstruct _LtpDef_i noattr))
                       (Tstruct _LtpDef_i noattr)) _ecef
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _z tint) tint) tint tint)))))
|}.

Definition f_ecef_of_ned_point_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ned, (tptr (Tstruct _NedCoor_i noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
               (Tstruct _EnuCoor_i noattr)) _x tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _y tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                       (tptr (Tstruct _NedCoor_i noattr)))
                     (Tstruct _NedCoor_i noattr))
                   (Tstruct _NedCoor_i noattr)) _x tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _z tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                         (tptr (Tstruct _NedCoor_i noattr)))
                       (Tstruct _NedCoor_i noattr))
                     (Tstruct _NedCoor_i noattr)) _z tint) tint) tint) tint))))
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_point_i (Tfunction
                                        ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                         (tptr (Tstruct _LtpDef_i noattr)) ::
                                         (tptr (Tstruct _EnuCoor_i noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EnuCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (tptr (Tstruct _EnuCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_ecef_of_enu_pos_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_enu, (tptr (Tstruct _EnuCoor_i noattr))) :: nil);
  fn_vars := ((_enu_cm, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
               (Tstruct _EnuCoor_i noattr)) _x tint)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                       (tptr (Tstruct _EnuCoor_i noattr)))
                     (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _x tint) tint)
             (Eval (Vint (Int.repr 25)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _y tint) tint)
               (Eval (Vint (Int.repr 25)) tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _z tint)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
                         (tptr (Tstruct _EnuCoor_i noattr)))
                       (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _z tint) tint)
               (Eval (Vint (Int.repr 25)) tint) tint) tint))))
  (Ssequence
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _x tint)
             (Ebinop Oshr
               (Evalof
                 (Efield
                   (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                     (Tstruct _EnuCoor_i noattr)) _x tint) tint)
               (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _y tint)
               (Ebinop Oshr
                 (Evalof
                   (Efield
                     (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _y tint) tint)
                 (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                   (Tstruct _EnuCoor_i noattr)) _z tint)
               (Ebinop Oshr
                 (Evalof
                   (Efield
                     (Evalof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                       (Tstruct _EnuCoor_i noattr)) _z tint) tint)
                 (Ebinop Osub (Eval (Vint (Int.repr 8)) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint) tint))))
    (Ssequence
      (Sdo (Ecall
             (Evalof
               (Evar _ecef_of_enu_vect_i (Tfunction
                                           ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                            (tptr (Tstruct _LtpDef_i noattr)) ::
                                            (tptr (Tstruct _EnuCoor_i noattr)) ::
                                            nil) tvoid cc_default))
               (Tfunction
                 ((tptr (Tstruct _EcefCoor_i noattr)) ::
                  (tptr (Tstruct _LtpDef_i noattr)) ::
                  (tptr (Tstruct _EnuCoor_i noattr)) :: nil) tvoid
                 cc_default))
             (Econs
               (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                 (tptr (Tstruct _EcefCoor_i noattr)))
               (Econs
                 (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                   (tptr (Tstruct _LtpDef_i noattr)))
                 (Econs
                   (Eaddrof (Evar _enu_cm (Tstruct _EnuCoor_i noattr))
                     (tptr (Tstruct _EnuCoor_i noattr))) Enil))) tvoid))
      (Ssequence
        (Sdo (Eassignop Oadd
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _x tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                             (tptr (Tstruct _LtpDef_i noattr)))
                           (Tstruct _LtpDef_i noattr))
                         (Tstruct _LtpDef_i noattr)) _ecef
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _x tint) tint) tint tint))
        (Ssequence
          (Sdo (Eassignop Oadd
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _y tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                               (tptr (Tstruct _LtpDef_i noattr)))
                             (Tstruct _LtpDef_i noattr))
                           (Tstruct _LtpDef_i noattr)) _ecef
                         (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _y tint) tint)
                 tint tint))
          (Sdo (Eassignop Oadd
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _z tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
                               (tptr (Tstruct _LtpDef_i noattr)))
                             (Tstruct _LtpDef_i noattr))
                           (Tstruct _LtpDef_i noattr)) _ecef
                         (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _z tint) tint)
                 tint tint)))))))
|}.

Definition f_ecef_of_ned_pos_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ecef, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_ned, (tptr (Tstruct _NedCoor_i noattr))) :: nil);
  fn_vars := ((_enu, (Tstruct _EnuCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
               (Tstruct _EnuCoor_i noattr)) _x tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                     (tptr (Tstruct _NedCoor_i noattr)))
                   (Tstruct _NedCoor_i noattr)) (Tstruct _NedCoor_i noattr))
               _y tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _y tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                       (tptr (Tstruct _NedCoor_i noattr)))
                     (Tstruct _NedCoor_i noattr))
                   (Tstruct _NedCoor_i noattr)) _x tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (Tstruct _EnuCoor_i noattr)) _z tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
                         (tptr (Tstruct _NedCoor_i noattr)))
                       (Tstruct _NedCoor_i noattr))
                     (Tstruct _NedCoor_i noattr)) _z tint) tint) tint) tint))))
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_enu_pos_i (Tfunction
                                      ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                       (tptr (Tstruct _LtpDef_i noattr)) ::
                                       (tptr (Tstruct _EnuCoor_i noattr)) ::
                                       nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EnuCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ecef (tptr (Tstruct _EcefCoor_i noattr)))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _enu (Tstruct _EnuCoor_i noattr))
                 (tptr (Tstruct _EnuCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_enu_of_lla_point_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_i (Tfunction
                                  ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                   (tptr (Tstruct _LlaCoor_i noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
               (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_point_i (Tfunction
                                        ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                         (tptr (Tstruct _LtpDef_i noattr)) ::
                                         (tptr (Tstruct _EcefCoor_i noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_ned_of_lla_point_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_i (Tfunction
                                  ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                   (tptr (Tstruct _LlaCoor_i noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
               (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _ned_of_ecef_point_i (Tfunction
                                        ((tptr (Tstruct _NedCoor_i noattr)) ::
                                         (tptr (Tstruct _LtpDef_i noattr)) ::
                                         (tptr (Tstruct _EcefCoor_i noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _NedCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
             (tptr (Tstruct _NedCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_enu_of_lla_pos_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_i (Tfunction
                                  ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                   (tptr (Tstruct _LlaCoor_i noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
               (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_pos_i (Tfunction
                                      ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                       (tptr (Tstruct _LtpDef_i noattr)) ::
                                       (tptr (Tstruct _EcefCoor_i noattr)) ::
                                       nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_ned_of_lla_pos_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_i (Tfunction
                                  ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                   (tptr (Tstruct _LlaCoor_i noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
               (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _ned_of_ecef_pos_i (Tfunction
                                      ((tptr (Tstruct _NedCoor_i noattr)) ::
                                       (tptr (Tstruct _LtpDef_i noattr)) ::
                                       (tptr (Tstruct _EcefCoor_i noattr)) ::
                                       nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _NedCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
             (tptr (Tstruct _NedCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_enu_of_lla_vect_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_enu, (tptr (Tstruct _EnuCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_i (Tfunction
                                  ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                   (tptr (Tstruct _LlaCoor_i noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
               (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _enu_of_ecef_vect_i (Tfunction
                                       ((tptr (Tstruct _EnuCoor_i noattr)) ::
                                        (tptr (Tstruct _LtpDef_i noattr)) ::
                                        (tptr (Tstruct _EcefCoor_i noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EnuCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _enu (tptr (Tstruct _EnuCoor_i noattr)))
             (tptr (Tstruct _EnuCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_ned_of_lla_vect_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ned, (tptr (Tstruct _NedCoor_i noattr))) ::
                (_def, (tptr (Tstruct _LtpDef_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_ecef, (Tstruct _EcefCoor_i noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _ecef_of_lla_i (Tfunction
                                  ((tptr (Tstruct _EcefCoor_i noattr)) ::
                                   (tptr (Tstruct _LlaCoor_i noattr)) :: nil)
                                  tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _EcefCoor_i noattr)) ::
              (tptr (Tstruct _LlaCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
             (tptr (Tstruct _EcefCoor_i noattr)))
           (Econs
             (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
               (tptr (Tstruct _LlaCoor_i noattr))) Enil)) tvoid))
  (Sdo (Ecall
         (Evalof
           (Evar _ned_of_ecef_vect_i (Tfunction
                                       ((tptr (Tstruct _NedCoor_i noattr)) ::
                                        (tptr (Tstruct _LtpDef_i noattr)) ::
                                        (tptr (Tstruct _EcefCoor_i noattr)) ::
                                        nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _NedCoor_i noattr)) ::
              (tptr (Tstruct _LtpDef_i noattr)) ::
              (tptr (Tstruct _EcefCoor_i noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _ned (tptr (Tstruct _NedCoor_i noattr)))
             (tptr (Tstruct _NedCoor_i noattr)))
           (Econs
             (Evalof (Evar _def (tptr (Tstruct _LtpDef_i noattr)))
               (tptr (Tstruct _LtpDef_i noattr)))
             (Econs
               (Eaddrof (Evar _ecef (Tstruct _EcefCoor_i noattr))
                 (tptr (Tstruct _EcefCoor_i noattr))) Enil))) tvoid)))
|}.

Definition f_lla_of_ecef_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_out, (tptr (Tstruct _LlaCoor_i noattr))) ::
                (_in, (tptr (Tstruct _EcefCoor_i noattr))) :: nil);
  fn_vars := ((_in_d, (Tstruct _EcefCoor_d noattr)) ::
              (_out_d, (Tstruct _LlaCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _in_d (Tstruct _EcefCoor_d noattr))
               (Tstruct _EcefCoor_d noattr)) _x tdouble)
           (Ebinop Odiv
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _in (tptr (Tstruct _EcefCoor_i noattr)))
                         (tptr (Tstruct _EcefCoor_i noattr)))
                       (Tstruct _EcefCoor_i noattr))
                     (Tstruct _EcefCoor_i noattr)) _x tint) tint) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _in_d (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _y tdouble)
             (Ebinop Odiv
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _in (tptr (Tstruct _EcefCoor_i noattr)))
                           (tptr (Tstruct _EcefCoor_i noattr)))
                         (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _y tint) tint) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
               tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _in_d (Tstruct _EcefCoor_d noattr))
                 (Tstruct _EcefCoor_d noattr)) _z tdouble)
             (Ebinop Odiv
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _in (tptr (Tstruct _EcefCoor_i noattr)))
                           (tptr (Tstruct _EcefCoor_i noattr)))
                         (Tstruct _EcefCoor_i noattr))
                       (Tstruct _EcefCoor_i noattr)) _z tint) tint) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
               tdouble) tdouble))))
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
             (Eaddrof (Evar _out_d (Tstruct _LlaCoor_d noattr))
               (tptr (Tstruct _LlaCoor_d noattr)))
             (Econs
               (Eaddrof (Evar _in_d (Tstruct _EcefCoor_d noattr))
                 (tptr (Tstruct _EcefCoor_d noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _out (tptr (Tstruct _LlaCoor_i noattr)))
                     (tptr (Tstruct _LlaCoor_i noattr)))
                   (Tstruct _LlaCoor_i noattr)) (Tstruct _LlaCoor_i noattr))
               _lat tint)
             (Ecast
               (Ebinop Omul
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _out_d (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                   (Ebinop Odiv
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                     tdouble) tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                 tdouble) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _out (tptr (Tstruct _LlaCoor_i noattr)))
                       (tptr (Tstruct _LlaCoor_i noattr)))
                     (Tstruct _LlaCoor_i noattr))
                   (Tstruct _LlaCoor_i noattr)) _lon tint)
               (Ecast
                 (Ebinop Omul
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof (Evar _out_d (Tstruct _LlaCoor_d noattr))
                           (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                       tdouble)
                     (Ebinop Odiv
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                       tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                   tdouble) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _out (tptr (Tstruct _LlaCoor_i noattr)))
                       (tptr (Tstruct _LlaCoor_i noattr)))
                     (Tstruct _LlaCoor_i noattr))
                   (Tstruct _LlaCoor_i noattr)) _alt tint)
               (Ecast
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _out_d (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _alt tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4652007308841189376))) tdouble)
                   tdouble) tint) tint))))))
|}.

Definition f_ecef_of_lla_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_out, (tptr (Tstruct _EcefCoor_i noattr))) ::
                (_in, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_in_d, (Tstruct _LlaCoor_d noattr)) ::
              (_out_d, (Tstruct _EcefCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _in_d (Tstruct _LlaCoor_d noattr))
               (Tstruct _LlaCoor_d noattr)) _lat tdouble)
           (Ebinop Odiv
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _in (tptr (Tstruct _LlaCoor_i noattr)))
                           (tptr (Tstruct _LlaCoor_i noattr)))
                         (Tstruct _LlaCoor_i noattr))
                       (Tstruct _LlaCoor_i noattr)) _lat tint) tint) tdouble)
               (Ebinop Odiv
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                 tdouble) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _in_d (Tstruct _LlaCoor_d noattr))
                 (Tstruct _LlaCoor_d noattr)) _lon tdouble)
             (Ebinop Odiv
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _in (tptr (Tstruct _LlaCoor_i noattr)))
                             (tptr (Tstruct _LlaCoor_i noattr)))
                           (Tstruct _LlaCoor_i noattr))
                         (Tstruct _LlaCoor_i noattr)) _lon tint) tint)
                   tdouble)
                 (Ebinop Odiv
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                   tdouble) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
               tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _in_d (Tstruct _LlaCoor_d noattr))
                 (Tstruct _LlaCoor_d noattr)) _alt tdouble)
             (Ebinop Odiv
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _in (tptr (Tstruct _LlaCoor_i noattr)))
                           (tptr (Tstruct _LlaCoor_i noattr)))
                         (Tstruct _LlaCoor_i noattr))
                       (Tstruct _LlaCoor_i noattr)) _alt tint) tint) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4652007308841189376))) tdouble)
               tdouble) tdouble))))
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
             (Eaddrof (Evar _out_d (Tstruct _EcefCoor_d noattr))
               (tptr (Tstruct _EcefCoor_d noattr)))
             (Econs
               (Eaddrof (Evar _in_d (Tstruct _LlaCoor_d noattr))
                 (tptr (Tstruct _LlaCoor_d noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _out (tptr (Tstruct _EcefCoor_i noattr)))
                     (tptr (Tstruct _EcefCoor_i noattr)))
                   (Tstruct _EcefCoor_i noattr))
                 (Tstruct _EcefCoor_i noattr)) _x tint)
             (Ecast
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof (Evar _out_d (Tstruct _EcefCoor_d noattr))
                       (Tstruct _EcefCoor_d noattr)) _x tdouble) tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
                 tdouble) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _out (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _y tint)
               (Ecast
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _out_d (Tstruct _EcefCoor_d noattr))
                         (Tstruct _EcefCoor_d noattr)) _y tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
                   tdouble) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _out (tptr (Tstruct _EcefCoor_i noattr)))
                       (tptr (Tstruct _EcefCoor_i noattr)))
                     (Tstruct _EcefCoor_i noattr))
                   (Tstruct _EcefCoor_i noattr)) _z tint)
               (Ecast
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _out_d (Tstruct _EcefCoor_d noattr))
                         (Tstruct _EcefCoor_d noattr)) _z tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
                   tdouble) tint) tint))))))
|}.

Definition f_utm_of_lla_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_utm, (tptr (Tstruct _UtmCoor_i noattr))) ::
                (_lla, (tptr (Tstruct _LlaCoor_i noattr))) :: nil);
  fn_vars := ((_lla_d, (Tstruct _LlaCoor_d noattr)) ::
              (_utm_d, (Tstruct _UtmCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
               (Tstruct _LlaCoor_d noattr)) _lat tdouble)
           (Ebinop Odiv
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                           (tptr (Tstruct _LlaCoor_i noattr)))
                         (Tstruct _LlaCoor_i noattr))
                       (Tstruct _LlaCoor_i noattr)) _lat tint) tint) tdouble)
               (Ebinop Odiv
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                 tdouble) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
                 (Tstruct _LlaCoor_d noattr)) _lon tdouble)
             (Ebinop Odiv
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                             (tptr (Tstruct _LlaCoor_i noattr)))
                           (Tstruct _LlaCoor_i noattr))
                         (Tstruct _LlaCoor_i noattr)) _lon tint) tint)
                   tdouble)
                 (Ebinop Odiv
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                   tdouble) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
               tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
                 (Tstruct _LlaCoor_d noattr)) _alt tdouble)
             (Ebinop Odiv
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                           (tptr (Tstruct _LlaCoor_i noattr)))
                         (Tstruct _LlaCoor_i noattr))
                       (Tstruct _LlaCoor_i noattr)) _alt tint) tint) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4652007308841189376))) tdouble)
               tdouble) tdouble))))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
               (Tstruct _UtmCoor_d noattr)) _zone tuchar)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                     (tptr (Tstruct _UtmCoor_i noattr)))
                   (Tstruct _UtmCoor_i noattr)) (Tstruct _UtmCoor_i noattr))
               _zone tuchar) tuchar) tuchar))
    (Ssequence
      (Sdo (Ecall
             (Evalof
               (Evar _utm_of_lla_d (Tfunction
                                     ((tptr (Tstruct _UtmCoor_d noattr)) ::
                                      (tptr (Tstruct _LlaCoor_d noattr)) ::
                                      nil) tvoid cc_default))
               (Tfunction
                 ((tptr (Tstruct _UtmCoor_d noattr)) ::
                  (tptr (Tstruct _LlaCoor_d noattr)) :: nil) tvoid
                 cc_default))
             (Econs
               (Eaddrof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                 (tptr (Tstruct _UtmCoor_d noattr)))
               (Econs
                 (Eaddrof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
                   (tptr (Tstruct _LlaCoor_d noattr))) Enil)) tvoid))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                       (tptr (Tstruct _UtmCoor_i noattr)))
                     (Tstruct _UtmCoor_i noattr))
                   (Tstruct _UtmCoor_i noattr)) _east tint)
               (Ecast
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                         (Tstruct _UtmCoor_d noattr)) _east tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
                   tdouble) tint) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                         (tptr (Tstruct _UtmCoor_i noattr)))
                       (Tstruct _UtmCoor_i noattr))
                     (Tstruct _UtmCoor_i noattr)) _north tint)
                 (Ecast
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                           (Tstruct _UtmCoor_d noattr)) _north tdouble)
                       tdouble)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
                     tdouble) tint) tint))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                           (tptr (Tstruct _UtmCoor_i noattr)))
                         (Tstruct _UtmCoor_i noattr))
                       (Tstruct _UtmCoor_i noattr)) _alt tint)
                   (Ecast
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                             (Tstruct _UtmCoor_d noattr)) _alt tdouble)
                         tdouble)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4652007308841189376))) tdouble)
                       tdouble) tint) tint))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                           (tptr (Tstruct _UtmCoor_i noattr)))
                         (Tstruct _UtmCoor_i noattr))
                       (Tstruct _UtmCoor_i noattr)) _zone tuchar)
                   (Evalof
                     (Efield
                       (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                         (Tstruct _UtmCoor_d noattr)) _zone tuchar) tuchar)
                   tuchar))))))))
|}.

Definition f_lla_of_utm_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_lla, (tptr (Tstruct _LlaCoor_i noattr))) ::
                (_utm, (tptr (Tstruct _UtmCoor_i noattr))) :: nil);
  fn_vars := ((_utm_d, (Tstruct _UtmCoor_d noattr)) ::
              (_lla_d, (Tstruct _LlaCoor_d noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
               (Tstruct _UtmCoor_d noattr)) _east tdouble)
           (Ebinop Odiv
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                         (tptr (Tstruct _UtmCoor_i noattr)))
                       (Tstruct _UtmCoor_i noattr))
                     (Tstruct _UtmCoor_i noattr)) _east tint) tint) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                 (Tstruct _UtmCoor_d noattr)) _north tdouble)
             (Ebinop Odiv
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                           (tptr (Tstruct _UtmCoor_i noattr)))
                         (Tstruct _UtmCoor_i noattr))
                       (Tstruct _UtmCoor_i noattr)) _north tint) tint)
                 tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4636737291354636288))) tdouble)
               tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                   (Tstruct _UtmCoor_d noattr)) _alt tdouble)
               (Ebinop Odiv
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                             (tptr (Tstruct _UtmCoor_i noattr)))
                           (Tstruct _UtmCoor_i noattr))
                         (Tstruct _UtmCoor_i noattr)) _alt tint) tint)
                   tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4652007308841189376))) tdouble)
                 tdouble) tdouble))
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                   (Tstruct _UtmCoor_d noattr)) _zone tuchar)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _utm (tptr (Tstruct _UtmCoor_i noattr)))
                         (tptr (Tstruct _UtmCoor_i noattr)))
                       (Tstruct _UtmCoor_i noattr))
                     (Tstruct _UtmCoor_i noattr)) _zone tuchar) tuchar)
               tuchar)))))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _lla_of_utm_d (Tfunction
                                   ((tptr (Tstruct _LlaCoor_d noattr)) ::
                                    (tptr (Tstruct _UtmCoor_d noattr)) ::
                                    nil) tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _LlaCoor_d noattr)) ::
                (tptr (Tstruct _UtmCoor_d noattr)) :: nil) tvoid cc_default))
           (Econs
             (Eaddrof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
               (tptr (Tstruct _LlaCoor_d noattr)))
             (Econs
               (Eaddrof (Evar _utm_d (Tstruct _UtmCoor_d noattr))
                 (tptr (Tstruct _UtmCoor_d noattr))) Enil)) tvoid))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                     (tptr (Tstruct _LlaCoor_i noattr)))
                   (Tstruct _LlaCoor_i noattr)) (Tstruct _LlaCoor_i noattr))
               _lat tint)
             (Ecast
               (Ebinop Omul
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _lat tdouble) tdouble)
                   (Ebinop Odiv
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                     tdouble) tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                 tdouble) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                       (tptr (Tstruct _LlaCoor_i noattr)))
                     (Tstruct _LlaCoor_i noattr))
                   (Tstruct _LlaCoor_i noattr)) _lon tint)
               (Ecast
                 (Ebinop Omul
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
                           (Tstruct _LlaCoor_d noattr)) _lon tdouble)
                       tdouble)
                     (Ebinop Odiv
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4640537203540230144))) tdouble)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                       tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4711630319722168320))) tdouble)
                   tdouble) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _lla (tptr (Tstruct _LlaCoor_i noattr)))
                       (tptr (Tstruct _LlaCoor_i noattr)))
                     (Tstruct _LlaCoor_i noattr))
                   (Tstruct _LlaCoor_i noattr)) _alt tint)
               (Ecast
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof (Evar _lla_d (Tstruct _LlaCoor_d noattr))
                         (Tstruct _LlaCoor_d noattr)) _alt tdouble) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4652007308841189376))) tdouble)
                   tdouble) tint) tint))))))
|}.

Definition v_five_keep_ltp_of_ecef_rmat_from_lla_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_of_ecef_rmat_from_lla_i (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ltp_def_from_ecef_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_def_from_ecef_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ltp_def_from_lla_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ltp_def_from_lla_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_ecef_point_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_ecef_point_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_ecef_point_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_ecef_point_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_ecef_pos_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_ecef_pos_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_ecef_pos_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_ecef_pos_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_ecef_vect_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_ecef_vect_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_ecef_vect_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_ecef_vect_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_enu_vect_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_enu_vect_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_vect_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_vect_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_enu_point_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_enu_point_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_point_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_point_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_enu_pos_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_enu_pos_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_ned_pos_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_ned_pos_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_lla_point_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_lla_point_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_lla_point_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_lla_point_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_lla_pos_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_lla_pos_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_lla_pos_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_lla_pos_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_enu_of_lla_vect_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _enu_of_lla_vect_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ned_of_lla_vect_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ned_of_lla_vect_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_lla_of_ecef_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _lla_of_ecef_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ecef_of_lla_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ecef_of_lla_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_utm_of_lla_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _utm_of_lla_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_lla_of_utm_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _lla_of_utm_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _Int32RMat Struct (Member_plain _m (tarray tint 9) :: nil) noattr ::
 Composite _EcefCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _LlaCoor_i Struct
   (Member_plain _lat tint :: Member_plain _lon tint ::
    Member_plain _alt tint :: nil)
   noattr ::
 Composite _NedCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _EnuCoor_i Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _UtmCoor_i Struct
   (Member_plain _north tint :: Member_plain _east tint ::
    Member_plain _alt tint :: Member_plain _zone tuchar :: nil)
   noattr ::
 Composite _LtpDef_i Struct
   (Member_plain _ecef (Tstruct _EcefCoor_i noattr) ::
    Member_plain _lla (Tstruct _LlaCoor_i noattr) ::
    Member_plain _ltp_of_ecef (Tstruct _Int32RMat noattr) ::
    Member_plain _hmsl tint :: nil)
   noattr ::
 Composite _EcefCoor_d Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _LlaCoor_d Struct
   (Member_plain _lat tdouble :: Member_plain _lon tdouble ::
    Member_plain _alt tdouble :: nil)
   noattr ::
 Composite _UtmCoor_d Struct
   (Member_plain _north tdouble :: Member_plain _east tdouble ::
    Member_plain _alt tdouble :: Member_plain _zone tuchar :: nil)
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
 (_cos,
   Gfun(External (EF_external "cos"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_sin,
   Gfun(External (EF_external "sin"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_rint,
   Gfun(External (EF_external "rint"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_ltp_of_ecef_rmat_from_lla_i, Gfun(Internal f_ltp_of_ecef_rmat_from_lla_i)) ::
 (_ltp_def_from_ecef_i, Gfun(Internal f_ltp_def_from_ecef_i)) ::
 (_ltp_def_from_lla_i, Gfun(Internal f_ltp_def_from_lla_i)) ::
 (_enu_of_ecef_point_i, Gfun(Internal f_enu_of_ecef_point_i)) ::
 (_ned_of_ecef_point_i, Gfun(Internal f_ned_of_ecef_point_i)) ::
 (_enu_of_ecef_pos_i, Gfun(Internal f_enu_of_ecef_pos_i)) ::
 (_ned_of_ecef_pos_i, Gfun(Internal f_ned_of_ecef_pos_i)) ::
 (_enu_of_ecef_vect_i, Gfun(Internal f_enu_of_ecef_vect_i)) ::
 (_ned_of_ecef_vect_i, Gfun(Internal f_ned_of_ecef_vect_i)) ::
 (_ecef_of_enu_vect_i, Gfun(Internal f_ecef_of_enu_vect_i)) ::
 (_ecef_of_ned_vect_i, Gfun(Internal f_ecef_of_ned_vect_i)) ::
 (_ecef_of_enu_point_i, Gfun(Internal f_ecef_of_enu_point_i)) ::
 (_ecef_of_ned_point_i, Gfun(Internal f_ecef_of_ned_point_i)) ::
 (_ecef_of_enu_pos_i, Gfun(Internal f_ecef_of_enu_pos_i)) ::
 (_ecef_of_ned_pos_i, Gfun(Internal f_ecef_of_ned_pos_i)) ::
 (_enu_of_lla_point_i, Gfun(Internal f_enu_of_lla_point_i)) ::
 (_ned_of_lla_point_i, Gfun(Internal f_ned_of_lla_point_i)) ::
 (_enu_of_lla_pos_i, Gfun(Internal f_enu_of_lla_pos_i)) ::
 (_ned_of_lla_pos_i, Gfun(Internal f_ned_of_lla_pos_i)) ::
 (_enu_of_lla_vect_i, Gfun(Internal f_enu_of_lla_vect_i)) ::
 (_ned_of_lla_vect_i, Gfun(Internal f_ned_of_lla_vect_i)) ::
 (_lla_of_utm_d,
   Gfun(External (EF_external "lla_of_utm_d"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _LlaCoor_d noattr)) ::
      (tptr (Tstruct _UtmCoor_d noattr)) :: nil) tvoid cc_default)) ::
 (_utm_of_lla_d,
   Gfun(External (EF_external "utm_of_lla_d"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _UtmCoor_d noattr)) ::
      (tptr (Tstruct _LlaCoor_d noattr)) :: nil) tvoid cc_default)) ::
 (_lla_of_ecef_d,
   Gfun(External (EF_external "lla_of_ecef_d"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _LlaCoor_d noattr)) ::
      (tptr (Tstruct _EcefCoor_d noattr)) :: nil) tvoid cc_default)) ::
 (_ecef_of_lla_d,
   Gfun(External (EF_external "ecef_of_lla_d"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _EcefCoor_d noattr)) ::
      (tptr (Tstruct _LlaCoor_d noattr)) :: nil) tvoid cc_default)) ::
 (_lla_of_ecef_i, Gfun(Internal f_lla_of_ecef_i)) ::
 (_ecef_of_lla_i, Gfun(Internal f_ecef_of_lla_i)) ::
 (_utm_of_lla_i, Gfun(Internal f_utm_of_lla_i)) ::
 (_lla_of_utm_i, Gfun(Internal f_lla_of_utm_i)) ::
 (_five_keep_ltp_of_ecef_rmat_from_lla_i, Gvar v_five_keep_ltp_of_ecef_rmat_from_lla_i) ::
 (_five_keep_ltp_def_from_ecef_i, Gvar v_five_keep_ltp_def_from_ecef_i) ::
 (_five_keep_ltp_def_from_lla_i, Gvar v_five_keep_ltp_def_from_lla_i) ::
 (_five_keep_enu_of_ecef_point_i, Gvar v_five_keep_enu_of_ecef_point_i) ::
 (_five_keep_ned_of_ecef_point_i, Gvar v_five_keep_ned_of_ecef_point_i) ::
 (_five_keep_enu_of_ecef_pos_i, Gvar v_five_keep_enu_of_ecef_pos_i) ::
 (_five_keep_ned_of_ecef_pos_i, Gvar v_five_keep_ned_of_ecef_pos_i) ::
 (_five_keep_enu_of_ecef_vect_i, Gvar v_five_keep_enu_of_ecef_vect_i) ::
 (_five_keep_ned_of_ecef_vect_i, Gvar v_five_keep_ned_of_ecef_vect_i) ::
 (_five_keep_ecef_of_enu_vect_i, Gvar v_five_keep_ecef_of_enu_vect_i) ::
 (_five_keep_ecef_of_ned_vect_i, Gvar v_five_keep_ecef_of_ned_vect_i) ::
 (_five_keep_ecef_of_enu_point_i, Gvar v_five_keep_ecef_of_enu_point_i) ::
 (_five_keep_ecef_of_ned_point_i, Gvar v_five_keep_ecef_of_ned_point_i) ::
 (_five_keep_ecef_of_enu_pos_i, Gvar v_five_keep_ecef_of_enu_pos_i) ::
 (_five_keep_ecef_of_ned_pos_i, Gvar v_five_keep_ecef_of_ned_pos_i) ::
 (_five_keep_enu_of_lla_point_i, Gvar v_five_keep_enu_of_lla_point_i) ::
 (_five_keep_ned_of_lla_point_i, Gvar v_five_keep_ned_of_lla_point_i) ::
 (_five_keep_enu_of_lla_pos_i, Gvar v_five_keep_enu_of_lla_pos_i) ::
 (_five_keep_ned_of_lla_pos_i, Gvar v_five_keep_ned_of_lla_pos_i) ::
 (_five_keep_enu_of_lla_vect_i, Gvar v_five_keep_enu_of_lla_vect_i) ::
 (_five_keep_ned_of_lla_vect_i, Gvar v_five_keep_ned_of_lla_vect_i) ::
 (_five_keep_lla_of_ecef_i, Gvar v_five_keep_lla_of_ecef_i) ::
 (_five_keep_ecef_of_lla_i, Gvar v_five_keep_ecef_of_lla_i) ::
 (_five_keep_utm_of_lla_i, Gvar v_five_keep_utm_of_lla_i) ::
 (_five_keep_lla_of_utm_i, Gvar v_five_keep_lla_of_utm_i) :: nil).

Definition public_idents : list ident :=
(_five_keep_lla_of_utm_i :: _five_keep_utm_of_lla_i ::
 _five_keep_ecef_of_lla_i :: _five_keep_lla_of_ecef_i ::
 _five_keep_ned_of_lla_vect_i :: _five_keep_enu_of_lla_vect_i ::
 _five_keep_ned_of_lla_pos_i :: _five_keep_enu_of_lla_pos_i ::
 _five_keep_ned_of_lla_point_i :: _five_keep_enu_of_lla_point_i ::
 _five_keep_ecef_of_ned_pos_i :: _five_keep_ecef_of_enu_pos_i ::
 _five_keep_ecef_of_ned_point_i :: _five_keep_ecef_of_enu_point_i ::
 _five_keep_ecef_of_ned_vect_i :: _five_keep_ecef_of_enu_vect_i ::
 _five_keep_ned_of_ecef_vect_i :: _five_keep_enu_of_ecef_vect_i ::
 _five_keep_ned_of_ecef_pos_i :: _five_keep_enu_of_ecef_pos_i ::
 _five_keep_ned_of_ecef_point_i :: _five_keep_enu_of_ecef_point_i ::
 _five_keep_ltp_def_from_lla_i :: _five_keep_ltp_def_from_ecef_i ::
 _five_keep_ltp_of_ecef_rmat_from_lla_i :: _lla_of_utm_i :: _utm_of_lla_i ::
 _ecef_of_lla_i :: _lla_of_ecef_i :: _ecef_of_lla_d :: _lla_of_ecef_d ::
 _utm_of_lla_d :: _lla_of_utm_d :: _ned_of_lla_vect_i ::
 _enu_of_lla_vect_i :: _ned_of_lla_pos_i :: _enu_of_lla_pos_i ::
 _ned_of_lla_point_i :: _enu_of_lla_point_i :: _ecef_of_ned_pos_i ::
 _ecef_of_enu_pos_i :: _ecef_of_ned_point_i :: _ecef_of_enu_point_i ::
 _ecef_of_ned_vect_i :: _ecef_of_enu_vect_i :: _ned_of_ecef_vect_i ::
 _enu_of_ecef_vect_i :: _ned_of_ecef_pos_i :: _enu_of_ecef_pos_i ::
 _ned_of_ecef_point_i :: _enu_of_ecef_point_i :: _ltp_def_from_lla_i ::
 _ltp_def_from_ecef_i :: _ltp_of_ecef_rmat_from_lla_i :: _rint :: _sin ::
 _cos :: ___builtin_debug :: ___builtin_write32_reversed ::
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


