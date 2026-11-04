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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/double_algebra/model/preprocessed.i".
End Info.

Definition _DoubleEulers : ident := $"DoubleEulers".
Definition _DoubleQuat : ident := $"DoubleQuat".
Definition _DoubleRMat : ident := $"DoubleRMat".
Definition _DoubleVect3 : ident := $"DoubleVect3".
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
Definition __a : ident := $"_a".
Definition __b : ident := $"_b".
Definition __c : ident := $"_c".
Definition __d : ident := $"_d".
Definition _a2_1 : ident := $"a2_1".
Definition _a2b : ident := $"a2b".
Definition _a2c : ident := $"a2c".
Definition _ab : ident := $"ab".
Definition _ac : ident := $"ac".
Definition _ad : ident := $"ad".
Definition _asin : ident := $"asin".
Definition _atan2 : ident := $"atan2".
Definition _b2c : ident := $"b2c".
Definition _bc : ident := $"bc".
Definition _bd : ident := $"bd".
Definition _c_phi2 : ident := $"c_phi2".
Definition _c_psi2 : ident := $"c_psi2".
Definition _c_theta2 : ident := $"c_theta2".
Definition _cd : ident := $"cd".
Definition _cos : ident := $"cos".
Definition _cphi : ident := $"cphi".
Definition _cpsi : ident := $"cpsi".
Definition _ctheta : ident := $"ctheta".
Definition _dcm00 : ident := $"dcm00".
Definition _dcm01 : ident := $"dcm01".
Definition _dcm02 : ident := $"dcm02".
Definition _dcm12 : ident := $"dcm12".
Definition _dcm22 : ident := $"dcm22".
Definition _double_eulers_of_quat : ident := $"double_eulers_of_quat".
Definition _double_quat_comp : ident := $"double_quat_comp".
Definition _double_quat_of_eulers : ident := $"double_quat_of_eulers".
Definition _double_quat_vmult : ident := $"double_quat_vmult".
Definition _double_rmat_comp : ident := $"double_rmat_comp".
Definition _double_rmat_inv : ident := $"double_rmat_inv".
Definition _double_rmat_of_eulers_321 : ident := $"double_rmat_of_eulers_321".
Definition _double_rmat_of_quat : ident := $"double_rmat_of_quat".
Definition _double_rmat_transp_vmult : ident := $"double_rmat_transp_vmult".
Definition _double_rmat_vmult : ident := $"double_rmat_vmult".
Definition _e : ident := $"e".
Definition _five_keep_double_eulers_of_quat : ident := $"five_keep_double_eulers_of_quat".
Definition _five_keep_double_quat_comp : ident := $"five_keep_double_quat_comp".
Definition _five_keep_double_quat_of_eulers : ident := $"five_keep_double_quat_of_eulers".
Definition _five_keep_double_quat_vmult : ident := $"five_keep_double_quat_vmult".
Definition _five_keep_double_rmat_comp : ident := $"five_keep_double_rmat_comp".
Definition _five_keep_double_rmat_inv : ident := $"five_keep_double_rmat_inv".
Definition _five_keep_double_rmat_of_eulers_321 : ident := $"five_keep_double_rmat_of_eulers_321".
Definition _five_keep_double_rmat_of_quat : ident := $"five_keep_double_rmat_of_quat".
Definition _five_keep_double_rmat_transp_vmult : ident := $"five_keep_double_rmat_transp_vmult".
Definition _five_keep_double_rmat_vmult : ident := $"five_keep_double_rmat_vmult".
Definition _m : ident := $"m".
Definition _m00 : ident := $"m00".
Definition _m01 : ident := $"m01".
Definition _m02 : ident := $"m02".
Definition _m10 : ident := $"m10".
Definition _m11 : ident := $"m11".
Definition _m12 : ident := $"m12".
Definition _m20 : ident := $"m20".
Definition _m21 : ident := $"m21".
Definition _m22 : ident := $"m22".
Definition _m_a2b : ident := $"m_a2b".
Definition _m_a2c : ident := $"m_a2c".
Definition _m_b2a : ident := $"m_b2a".
Definition _m_b2c : ident := $"m_b2c".
Definition _main : ident := $"main".
Definition _phi : ident := $"phi".
Definition _phi2 : ident := $"phi2".
Definition _psi : ident := $"psi".
Definition _psi2 : ident := $"psi2".
Definition _q : ident := $"q".
Definition _qi : ident := $"qi".
Definition _qi2_M1_2 : ident := $"qi2_M1_2".
Definition _qiqx : ident := $"qiqx".
Definition _qiqy : ident := $"qiqy".
Definition _qiqz : ident := $"qiqz".
Definition _qx : ident := $"qx".
Definition _qx2 : ident := $"qx2".
Definition _qxqy : ident := $"qxqy".
Definition _qxqz : ident := $"qxqz".
Definition _qy : ident := $"qy".
Definition _qy2 : ident := $"qy2".
Definition _qyqz : ident := $"qyqz".
Definition _qz : ident := $"qz".
Definition _qz2 : ident := $"qz2".
Definition _rm : ident := $"rm".
Definition _s_phi2 : ident := $"s_phi2".
Definition _s_psi2 : ident := $"s_psi2".
Definition _s_theta2 : ident := $"s_theta2".
Definition _sin : ident := $"sin".
Definition _sphi : ident := $"sphi".
Definition _spsi : ident := $"spsi".
Definition _stheta : ident := $"stheta".
Definition _theta : ident := $"theta".
Definition _theta2 : ident := $"theta2".
Definition _v_in : ident := $"v_in".
Definition _v_out : ident := $"v_out".
Definition _va : ident := $"va".
Definition _vb : ident := $"vb".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".

Definition f_double_rmat_of_eulers_321 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_e, (tptr (Tstruct _DoubleEulers noattr))) :: nil);
  fn_vars := ((_sphi, tdouble) :: (_cphi, tdouble) :: (_stheta, tdouble) ::
              (_ctheta, tdouble) :: (_spsi, tdouble) :: (_cpsi, tdouble) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sphi tdouble)
         (Ecall
           (Evalof
             (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
             (Tfunction (tdouble :: nil) tdouble cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                       (tptr (Tstruct _DoubleEulers noattr)))
                     (Tstruct _DoubleEulers noattr))
                   (Tstruct _DoubleEulers noattr)) _phi tdouble) tdouble)
             Enil) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _cphi tdouble)
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
                         (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                         (tptr (Tstruct _DoubleEulers noattr)))
                       (Tstruct _DoubleEulers noattr))
                     (Tstruct _DoubleEulers noattr)) _phi tdouble) tdouble)
               Enil) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _stheta tdouble)
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
                           (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                           (tptr (Tstruct _DoubleEulers noattr)))
                         (Tstruct _DoubleEulers noattr))
                       (Tstruct _DoubleEulers noattr)) _theta tdouble)
                   tdouble) Enil) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tdouble)
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
                             (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                             (tptr (Tstruct _DoubleEulers noattr)))
                           (Tstruct _DoubleEulers noattr))
                         (Tstruct _DoubleEulers noattr)) _theta tdouble)
                     tdouble) Enil) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _spsi tdouble)
                 (Ecall
                   (Evalof
                     (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                               (tptr (Tstruct _DoubleEulers noattr)))
                             (Tstruct _DoubleEulers noattr))
                           (Tstruct _DoubleEulers noattr)) _psi tdouble)
                       tdouble) Enil) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _cpsi tdouble)
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
                                 (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                                 (tptr (Tstruct _DoubleEulers noattr)))
                               (Tstruct _DoubleEulers noattr))
                             (Tstruct _DoubleEulers noattr)) _psi tdouble)
                         tdouble) Enil) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tdouble)) tdouble)
                     (Ebinop Omul (Evalof (Evar _ctheta tdouble) tdouble)
                       (Evalof (Evar _cpsi tdouble) tdouble) tdouble)
                     tdouble))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tdouble)) tdouble)
                       (Ebinop Omul (Evalof (Evar _ctheta tdouble) tdouble)
                         (Evalof (Evar _spsi tdouble) tdouble) tdouble)
                       tdouble))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 2)) tint) tint)
                             (tptr tdouble)) tdouble)
                         (Eunop Oneg (Evalof (Evar _stheta tdouble) tdouble)
                           tdouble) tdouble))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Ebinop Oadd
                                 (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tdouble)) tdouble)
                           (Ebinop Osub
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _sphi tdouble) tdouble)
                                 (Evalof (Evar _stheta tdouble) tdouble)
                                 tdouble)
                               (Evalof (Evar _cpsi tdouble) tdouble) tdouble)
                             (Ebinop Omul
                               (Evalof (Evar _cphi tdouble) tdouble)
                               (Evalof (Evar _spsi tdouble) tdouble) tdouble)
                             tdouble) tdouble))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tdouble)) tdouble)
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _sphi tdouble) tdouble)
                                   (Evalof (Evar _stheta tdouble) tdouble)
                                   tdouble)
                                 (Evalof (Evar _spsi tdouble) tdouble)
                                 tdouble)
                               (Ebinop Omul
                                 (Evalof (Evar _cphi tdouble) tdouble)
                                 (Evalof (Evar _cpsi tdouble) tdouble)
                                 tdouble) tdouble) tdouble))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tdouble)) tdouble)
                               (Ebinop Omul
                                 (Evalof (Evar _sphi tdouble) tdouble)
                                 (Evalof (Evar _ctheta tdouble) tdouble)
                                 tdouble) tdouble))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                               (tptr (Tstruct _DoubleRMat noattr)))
                                             (Tstruct _DoubleRMat noattr))
                                           (Tstruct _DoubleRMat noattr)) _m
                                         (tarray tdouble 9))
                                       (tarray tdouble 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tdouble)) tdouble)
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Ebinop Omul
                                       (Evalof (Evar _cphi tdouble) tdouble)
                                       (Evalof (Evar _stheta tdouble)
                                         tdouble) tdouble)
                                     (Evalof (Evar _cpsi tdouble) tdouble)
                                     tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _sphi tdouble) tdouble)
                                     (Evalof (Evar _spsi tdouble) tdouble)
                                     tdouble) tdouble) tdouble))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                 (tptr (Tstruct _DoubleRMat noattr)))
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tdouble)) tdouble)
                                   (Ebinop Osub
                                     (Ebinop Omul
                                       (Ebinop Omul
                                         (Evalof (Evar _cphi tdouble)
                                           tdouble)
                                         (Evalof (Evar _stheta tdouble)
                                           tdouble) tdouble)
                                       (Evalof (Evar _spsi tdouble) tdouble)
                                       tdouble)
                                     (Ebinop Omul
                                       (Evalof (Evar _sphi tdouble) tdouble)
                                       (Evalof (Evar _cpsi tdouble) tdouble)
                                       tdouble) tdouble) tdouble))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                 (tptr (Tstruct _DoubleRMat noattr)))
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tdouble)) tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _cphi tdouble) tdouble)
                                     (Evalof (Evar _ctheta tdouble) tdouble)
                                     tdouble) tdouble))))))))))))))))
|}.

Definition f_double_quat_of_eulers := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _DoubleQuat noattr))) ::
                (_e, (tptr (Tstruct _DoubleEulers noattr))) :: nil);
  fn_vars := ((_phi2, tdouble) :: (_theta2, tdouble) :: (_psi2, tdouble) ::
              (_s_phi2, tdouble) :: (_c_phi2, tdouble) ::
              (_s_theta2, tdouble) :: (_c_theta2, tdouble) ::
              (_s_psi2, tdouble) :: (_c_psi2, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _phi2 tdouble)
         (Ebinop Odiv
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                     (tptr (Tstruct _DoubleEulers noattr)))
                   (Tstruct _DoubleEulers noattr))
                 (Tstruct _DoubleEulers noattr)) _phi tdouble) tdouble)
           (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
           tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _theta2 tdouble)
           (Ebinop Odiv
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                       (tptr (Tstruct _DoubleEulers noattr)))
                     (Tstruct _DoubleEulers noattr))
                   (Tstruct _DoubleEulers noattr)) _theta tdouble) tdouble)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _psi2 tdouble)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                         (tptr (Tstruct _DoubleEulers noattr)))
                       (Tstruct _DoubleEulers noattr))
                     (Tstruct _DoubleEulers noattr)) _psi tdouble) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
               tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _s_phi2 tdouble)
               (Ecall
                 (Evalof
                   (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs (Evalof (Evar _phi2 tdouble) tdouble) Enil) tdouble)
               tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _c_phi2 tdouble)
                 (Ecall
                   (Evalof
                     (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                  cc_default))
                     (Tfunction (tdouble :: nil) tdouble cc_default))
                   (Econs (Evalof (Evar _phi2 tdouble) tdouble) Enil)
                   tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _s_theta2 tdouble)
                   (Ecall
                     (Evalof
                       (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                    cc_default))
                       (Tfunction (tdouble :: nil) tdouble cc_default))
                     (Econs (Evalof (Evar _theta2 tdouble) tdouble) Enil)
                     tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _c_theta2 tdouble)
                     (Ecall
                       (Evalof
                         (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                      cc_default))
                         (Tfunction (tdouble :: nil) tdouble cc_default))
                       (Econs (Evalof (Evar _theta2 tdouble) tdouble) Enil)
                       tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _s_psi2 tdouble)
                       (Ecall
                         (Evalof
                           (Evar _sin (Tfunction (tdouble :: nil) tdouble
                                        cc_default))
                           (Tfunction (tdouble :: nil) tdouble cc_default))
                         (Econs (Evalof (Evar _psi2 tdouble) tdouble) Enil)
                         tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _c_psi2 tdouble)
                         (Ecall
                           (Evalof
                             (Evar _cos (Tfunction (tdouble :: nil) tdouble
                                          cc_default))
                             (Tfunction (tdouble :: nil) tdouble cc_default))
                           (Econs (Evalof (Evar _psi2 tdouble) tdouble) Enil)
                           tdouble) tdouble))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                   (tptr (Tstruct _DoubleQuat noattr)))
                                 (Tstruct _DoubleQuat noattr))
                               (Tstruct _DoubleQuat noattr)) _qi tdouble)
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _c_phi2 tdouble) tdouble)
                                 (Evalof (Evar _c_theta2 tdouble) tdouble)
                                 tdouble)
                               (Evalof (Evar _c_psi2 tdouble) tdouble)
                               tdouble)
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _s_phi2 tdouble) tdouble)
                                 (Evalof (Evar _s_theta2 tdouble) tdouble)
                                 tdouble)
                               (Evalof (Evar _s_psi2 tdouble) tdouble)
                               tdouble) tdouble) tdouble))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                     (tptr (Tstruct _DoubleQuat noattr)))
                                   (Tstruct _DoubleQuat noattr))
                                 (Tstruct _DoubleQuat noattr)) _qx tdouble)
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Eunop Oneg
                                     (Evalof (Evar _c_phi2 tdouble) tdouble)
                                     tdouble)
                                   (Evalof (Evar _s_theta2 tdouble) tdouble)
                                   tdouble)
                                 (Evalof (Evar _s_psi2 tdouble) tdouble)
                                 tdouble)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _s_phi2 tdouble) tdouble)
                                   (Evalof (Evar _c_theta2 tdouble) tdouble)
                                   tdouble)
                                 (Evalof (Evar _c_psi2 tdouble) tdouble)
                                 tdouble) tdouble) tdouble))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                       (tptr (Tstruct _DoubleQuat noattr)))
                                     (Tstruct _DoubleQuat noattr))
                                   (Tstruct _DoubleQuat noattr)) _qy tdouble)
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_phi2 tdouble) tdouble)
                                     (Evalof (Evar _s_theta2 tdouble)
                                       tdouble) tdouble)
                                   (Evalof (Evar _c_psi2 tdouble) tdouble)
                                   tdouble)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_phi2 tdouble) tdouble)
                                     (Evalof (Evar _c_theta2 tdouble)
                                       tdouble) tdouble)
                                   (Evalof (Evar _s_psi2 tdouble) tdouble)
                                   tdouble) tdouble) tdouble))
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                       (tptr (Tstruct _DoubleQuat noattr)))
                                     (Tstruct _DoubleQuat noattr))
                                   (Tstruct _DoubleQuat noattr)) _qz tdouble)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_phi2 tdouble) tdouble)
                                     (Evalof (Evar _c_theta2 tdouble)
                                       tdouble) tdouble)
                                   (Evalof (Evar _s_psi2 tdouble) tdouble)
                                   tdouble)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_phi2 tdouble) tdouble)
                                     (Evalof (Evar _s_theta2 tdouble)
                                       tdouble) tdouble)
                                   (Evalof (Evar _c_psi2 tdouble) tdouble)
                                   tdouble) tdouble) tdouble))))))))))))))
|}.

Definition f_double_eulers_of_quat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _DoubleEulers noattr))) ::
                (_q, (tptr (Tstruct _DoubleQuat noattr))) :: nil);
  fn_vars := ((_qx2, tdouble) :: (_qy2, tdouble) :: (_qz2, tdouble) ::
              (_qiqx, tdouble) :: (_qiqy, tdouble) :: (_qiqz, tdouble) ::
              (_qxqy, tdouble) :: (_qxqz, tdouble) :: (_qyqz, tdouble) ::
              (_dcm00, tdouble) :: (_dcm01, tdouble) :: (_dcm02, tdouble) ::
              (_dcm12, tdouble) :: (_dcm22, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qx2 tdouble)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                     (tptr (Tstruct _DoubleQuat noattr)))
                   (Tstruct _DoubleQuat noattr))
                 (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                     (tptr (Tstruct _DoubleQuat noattr)))
                   (Tstruct _DoubleQuat noattr))
                 (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _qy2 tdouble)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _qz2 tdouble)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
               tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _qiqx tdouble)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                 tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _qiqy tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
                   tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _qiqz tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qi tdouble)
                       tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qz tdouble)
                       tdouble) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _qxqy tdouble)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                 (tptr (Tstruct _DoubleQuat noattr)))
                               (Tstruct _DoubleQuat noattr))
                             (Tstruct _DoubleQuat noattr)) _qx tdouble)
                         tdouble)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                 (tptr (Tstruct _DoubleQuat noattr)))
                               (Tstruct _DoubleQuat noattr))
                             (Tstruct _DoubleQuat noattr)) _qy tdouble)
                         tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _qxqz tdouble)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                   (tptr (Tstruct _DoubleQuat noattr)))
                                 (Tstruct _DoubleQuat noattr))
                               (Tstruct _DoubleQuat noattr)) _qx tdouble)
                           tdouble)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                   (tptr (Tstruct _DoubleQuat noattr)))
                                 (Tstruct _DoubleQuat noattr))
                               (Tstruct _DoubleQuat noattr)) _qz tdouble)
                           tdouble) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _qyqz tdouble)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                     (tptr (Tstruct _DoubleQuat noattr)))
                                   (Tstruct _DoubleQuat noattr))
                                 (Tstruct _DoubleQuat noattr)) _qy tdouble)
                             tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                     (tptr (Tstruct _DoubleQuat noattr)))
                                   (Tstruct _DoubleQuat noattr))
                                 (Tstruct _DoubleQuat noattr)) _qz tdouble)
                             tdouble) tdouble) tdouble))
                  (Ssequence
                    (Sdo (Eassign (Evar _dcm00 tdouble)
                           (Ebinop Osub
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                             (Ebinop Omul
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                               (Ebinop Oadd
                                 (Evalof (Evar _qy2 tdouble) tdouble)
                                 (Evalof (Evar _qz2 tdouble) tdouble)
                                 tdouble) tdouble) tdouble) tdouble))
                    (Ssequence
                      (Sdo (Eassign (Evar _dcm01 tdouble)
                             (Ebinop Omul
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                               (Ebinop Oadd
                                 (Evalof (Evar _qxqy tdouble) tdouble)
                                 (Evalof (Evar _qiqz tdouble) tdouble)
                                 tdouble) tdouble) tdouble))
                      (Ssequence
                        (Sdo (Eassign (Evar _dcm02 tdouble)
                               (Ebinop Omul
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                 (Ebinop Osub
                                   (Evalof (Evar _qxqz tdouble) tdouble)
                                   (Evalof (Evar _qiqy tdouble) tdouble)
                                   tdouble) tdouble) tdouble))
                        (Ssequence
                          (Sdo (Eassign (Evar _dcm12 tdouble)
                                 (Ebinop Omul
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                   (Ebinop Oadd
                                     (Evalof (Evar _qyqz tdouble) tdouble)
                                     (Evalof (Evar _qiqx tdouble) tdouble)
                                     tdouble) tdouble) tdouble))
                          (Ssequence
                            (Sdo (Eassign (Evar _dcm22 tdouble)
                                   (Ebinop Osub
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                     (Ebinop Omul
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                       (Ebinop Oadd
                                         (Evalof (Evar _qx2 tdouble) tdouble)
                                         (Evalof (Evar _qy2 tdouble) tdouble)
                                         tdouble) tdouble) tdouble) tdouble))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                                             (tptr (Tstruct _DoubleEulers noattr)))
                                           (Tstruct _DoubleEulers noattr))
                                         (Tstruct _DoubleEulers noattr)) _phi
                                       tdouble)
                                     (Ecall
                                       (Evalof
                                         (Evar _atan2 (Tfunction
                                                        (tdouble ::
                                                         tdouble :: nil)
                                                        tdouble cc_default))
                                         (Tfunction
                                           (tdouble :: tdouble :: nil)
                                           tdouble cc_default))
                                       (Econs
                                         (Evalof (Evar _dcm12 tdouble)
                                           tdouble)
                                         (Econs
                                           (Evalof (Evar _dcm22 tdouble)
                                             tdouble) Enil)) tdouble)
                                     tdouble))
                              (Ssequence
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                                               (tptr (Tstruct _DoubleEulers noattr)))
                                             (Tstruct _DoubleEulers noattr))
                                           (Tstruct _DoubleEulers noattr))
                                         _theta tdouble)
                                       (Eunop Oneg
                                         (Ecall
                                           (Evalof
                                             (Evar _asin (Tfunction
                                                           (tdouble :: nil)
                                                           tdouble
                                                           cc_default))
                                             (Tfunction (tdouble :: nil)
                                               tdouble cc_default))
                                           (Econs
                                             (Evalof (Evar _dcm02 tdouble)
                                               tdouble) Enil) tdouble)
                                         tdouble) tdouble))
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _e (tptr (Tstruct _DoubleEulers noattr)))
                                               (tptr (Tstruct _DoubleEulers noattr)))
                                             (Tstruct _DoubleEulers noattr))
                                           (Tstruct _DoubleEulers noattr))
                                         _psi tdouble)
                                       (Ecall
                                         (Evalof
                                           (Evar _atan2 (Tfunction
                                                          (tdouble ::
                                                           tdouble :: nil)
                                                          tdouble cc_default))
                                           (Tfunction
                                             (tdouble :: tdouble :: nil)
                                             tdouble cc_default))
                                         (Econs
                                           (Evalof (Evar _dcm01 tdouble)
                                             tdouble)
                                           (Econs
                                             (Evalof (Evar _dcm00 tdouble)
                                               tdouble) Enil)) tdouble)
                                       tdouble))))))))))))))))))
|}.

Definition f_double_quat_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_v_out, (tptr (Tstruct _DoubleVect3 noattr))) ::
                (_q, (tptr (Tstruct _DoubleQuat noattr))) ::
                (_v_in, (tptr (Tstruct _DoubleVect3 noattr))) :: nil);
  fn_vars := ((_qi2_M1_2, tdouble) :: (_qiqx, tdouble) :: (_qiqy, tdouble) ::
              (_qiqz, tdouble) :: (_m01, tdouble) :: (_m02, tdouble) ::
              (_m12, tdouble) :: (_m00, tdouble) :: (_m10, tdouble) ::
              (_m20, tdouble) :: (_m21, tdouble) :: (_m11, tdouble) ::
              (_m22, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qi2_M1_2 tdouble)
         (Ebinop Osub
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
             tdouble)
           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
           tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _qiqx tdouble)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _qiqy tdouble)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
               tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _qiqz tdouble)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
                 tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _m01 tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
                   tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _m02 tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qx tdouble)
                       tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qz tdouble)
                       tdouble) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _m12 tdouble)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                 (tptr (Tstruct _DoubleQuat noattr)))
                               (Tstruct _DoubleQuat noattr))
                             (Tstruct _DoubleQuat noattr)) _qy tdouble)
                         tdouble)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                 (tptr (Tstruct _DoubleQuat noattr)))
                               (Tstruct _DoubleQuat noattr))
                             (Tstruct _DoubleQuat noattr)) _qz tdouble)
                         tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _m00 tdouble)
                       (Ebinop Oadd (Evalof (Evar _qi2_M1_2 tdouble) tdouble)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                     (tptr (Tstruct _DoubleQuat noattr)))
                                   (Tstruct _DoubleQuat noattr))
                                 (Tstruct _DoubleQuat noattr)) _qx tdouble)
                             tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                     (tptr (Tstruct _DoubleQuat noattr)))
                                   (Tstruct _DoubleQuat noattr))
                                 (Tstruct _DoubleQuat noattr)) _qx tdouble)
                             tdouble) tdouble) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _m10 tdouble)
                         (Ebinop Osub (Evalof (Evar _m01 tdouble) tdouble)
                           (Evalof (Evar _qiqz tdouble) tdouble) tdouble)
                         tdouble))
                  (Ssequence
                    (Sdo (Eassign (Evar _m20 tdouble)
                           (Ebinop Oadd (Evalof (Evar _m02 tdouble) tdouble)
                             (Evalof (Evar _qiqy tdouble) tdouble) tdouble)
                           tdouble))
                    (Ssequence
                      (Sdo (Eassign (Evar _m21 tdouble)
                             (Ebinop Osub
                               (Evalof (Evar _m12 tdouble) tdouble)
                               (Evalof (Evar _qiqx tdouble) tdouble) tdouble)
                             tdouble))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _m01 tdouble)
                               (Evalof (Evar _qiqz tdouble) tdouble)
                               tdouble tdouble))
                        (Ssequence
                          (Sdo (Eassignop Osub (Evar _m02 tdouble)
                                 (Evalof (Evar _qiqy tdouble) tdouble)
                                 tdouble tdouble))
                          (Ssequence
                            (Sdo (Eassignop Oadd (Evar _m12 tdouble)
                                   (Evalof (Evar _qiqx tdouble) tdouble)
                                   tdouble tdouble))
                            (Ssequence
                              (Sdo (Eassign (Evar _m11 tdouble)
                                     (Ebinop Oadd
                                       (Evalof (Evar _qi2_M1_2 tdouble)
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                                   (tptr (Tstruct _DoubleQuat noattr)))
                                                 (Tstruct _DoubleQuat noattr))
                                               (Tstruct _DoubleQuat noattr))
                                             _qy tdouble) tdouble)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                                   (tptr (Tstruct _DoubleQuat noattr)))
                                                 (Tstruct _DoubleQuat noattr))
                                               (Tstruct _DoubleQuat noattr))
                                             _qy tdouble) tdouble) tdouble)
                                       tdouble) tdouble))
                              (Ssequence
                                (Sdo (Eassign (Evar _m22 tdouble)
                                       (Ebinop Oadd
                                         (Evalof (Evar _qi2_M1_2 tdouble)
                                           tdouble)
                                         (Ebinop Omul
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                                     (tptr (Tstruct _DoubleQuat noattr)))
                                                   (Tstruct _DoubleQuat noattr))
                                                 (Tstruct _DoubleQuat noattr))
                                               _qz tdouble) tdouble)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                                                     (tptr (Tstruct _DoubleQuat noattr)))
                                                   (Tstruct _DoubleQuat noattr))
                                                 (Tstruct _DoubleQuat noattr))
                                               _qz tdouble) tdouble) tdouble)
                                         tdouble) tdouble))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _v_out (tptr (Tstruct _DoubleVect3 noattr)))
                                                 (tptr (Tstruct _DoubleVect3 noattr)))
                                               (Tstruct _DoubleVect3 noattr))
                                             (Tstruct _DoubleVect3 noattr))
                                           _x tdouble)
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Ebinop Oadd
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Evalof (Evar _m00 tdouble)
                                                   tdouble)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (tptr (Tstruct _DoubleVect3 noattr)))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       (Tstruct _DoubleVect3 noattr))
                                                     _x tdouble) tdouble)
                                                 tdouble)
                                               (Ebinop Omul
                                                 (Evalof (Evar _m01 tdouble)
                                                   tdouble)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (tptr (Tstruct _DoubleVect3 noattr)))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       (Tstruct _DoubleVect3 noattr))
                                                     _y tdouble) tdouble)
                                                 tdouble) tdouble)
                                             (Ebinop Omul
                                               (Evalof (Evar _m02 tdouble)
                                                 tdouble)
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                         (tptr (Tstruct _DoubleVect3 noattr)))
                                                       (Tstruct _DoubleVect3 noattr))
                                                     (Tstruct _DoubleVect3 noattr))
                                                   _z tdouble) tdouble)
                                               tdouble) tdouble) tdouble)
                                         tdouble))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _v_out (tptr (Tstruct _DoubleVect3 noattr)))
                                                   (tptr (Tstruct _DoubleVect3 noattr)))
                                                 (Tstruct _DoubleVect3 noattr))
                                               (Tstruct _DoubleVect3 noattr))
                                             _y tdouble)
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Ebinop Oadd
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _m10 tdouble)
                                                     tdouble)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                             (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (Tstruct _DoubleVect3 noattr))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       _x tdouble) tdouble)
                                                   tdouble)
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _m11 tdouble)
                                                     tdouble)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                             (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (Tstruct _DoubleVect3 noattr))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       _y tdouble) tdouble)
                                                   tdouble) tdouble)
                                               (Ebinop Omul
                                                 (Evalof (Evar _m12 tdouble)
                                                   tdouble)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (tptr (Tstruct _DoubleVect3 noattr)))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       (Tstruct _DoubleVect3 noattr))
                                                     _z tdouble) tdouble)
                                                 tdouble) tdouble) tdouble)
                                           tdouble))
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _v_out (tptr (Tstruct _DoubleVect3 noattr)))
                                                   (tptr (Tstruct _DoubleVect3 noattr)))
                                                 (Tstruct _DoubleVect3 noattr))
                                               (Tstruct _DoubleVect3 noattr))
                                             _z tdouble)
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Ebinop Oadd
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _m20 tdouble)
                                                     tdouble)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                             (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (Tstruct _DoubleVect3 noattr))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       _x tdouble) tdouble)
                                                   tdouble)
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _m21 tdouble)
                                                     tdouble)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                             (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (Tstruct _DoubleVect3 noattr))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       _y tdouble) tdouble)
                                                   tdouble) tdouble)
                                               (Ebinop Omul
                                                 (Evalof (Evar _m22 tdouble)
                                                   tdouble)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _DoubleVect3 noattr)))
                                                           (tptr (Tstruct _DoubleVect3 noattr)))
                                                         (Tstruct _DoubleVect3 noattr))
                                                       (Tstruct _DoubleVect3 noattr))
                                                     _z tdouble) tdouble)
                                                 tdouble) tdouble) tdouble)
                                           tdouble))))))))))))))))))))
|}.

Definition f_double_quat_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2c, (tptr (Tstruct _DoubleQuat noattr))) ::
                (_a2b, (tptr (Tstruct _DoubleQuat noattr))) ::
                (_b2c, (tptr (Tstruct _DoubleQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _a2c (tptr (Tstruct _DoubleQuat noattr)))
                 (tptr (Tstruct _DoubleQuat noattr)))
               (Tstruct _DoubleQuat noattr)) (Tstruct _DoubleQuat noattr))
           _qi tdouble)
         (Ebinop Osub
           (Ebinop Osub
             (Ebinop Osub
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                 tdouble)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
               tdouble) tdouble)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
             tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _a2c (tptr (Tstruct _DoubleQuat noattr)))
                   (tptr (Tstruct _DoubleQuat noattr)))
                 (Tstruct _DoubleQuat noattr)) (Tstruct _DoubleQuat noattr))
             _qx tdouble)
           (Ebinop Osub
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                   tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                   tdouble) tdouble)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2c (tptr (Tstruct _DoubleQuat noattr)))
                     (tptr (Tstruct _DoubleQuat noattr)))
                   (Tstruct _DoubleQuat noattr))
                 (Tstruct _DoubleQuat noattr)) _qy tdouble)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qi tdouble)
                       tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qy tdouble)
                       tdouble) tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qx tdouble)
                       tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qz tdouble)
                       tdouble) tdouble) tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                   tdouble) tdouble)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                 tdouble) tdouble) tdouble))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2c (tptr (Tstruct _DoubleQuat noattr)))
                     (tptr (Tstruct _DoubleQuat noattr)))
                   (Tstruct _DoubleQuat noattr))
                 (Tstruct _DoubleQuat noattr)) _qz tdouble)
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qi tdouble)
                       tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qz tdouble)
                       tdouble) tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qx tdouble)
                       tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                               (tptr (Tstruct _DoubleQuat noattr)))
                             (Tstruct _DoubleQuat noattr))
                           (Tstruct _DoubleQuat noattr)) _qy tdouble)
                       tdouble) tdouble) tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                             (tptr (Tstruct _DoubleQuat noattr)))
                           (Tstruct _DoubleQuat noattr))
                         (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
                   tdouble) tdouble)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble)
                 tdouble) tdouble) tdouble)))))
|}.

Definition f_double_rmat_inv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_b2a, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_m_a2b, (tptr (Tstruct _DoubleRMat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                       (tptr (Tstruct _DoubleRMat noattr)))
                     (Tstruct _DoubleRMat noattr))
                   (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
               (tarray tdouble 9))
             (Ebinop Oadd
               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                 (Eval (Vint (Int.repr 3)) tint) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) (tptr tdouble)) tdouble)
         (Evalof
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                         (tptr (Tstruct _DoubleRMat noattr)))
                       (Tstruct _DoubleRMat noattr))
                     (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                 (tarray tdouble 9))
               (Ebinop Oadd
                 (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 3)) tint) tint)
                 (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
             tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                         (tptr (Tstruct _DoubleRMat noattr)))
                       (Tstruct _DoubleRMat noattr))
                     (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                 (tarray tdouble 9))
               (Ebinop Oadd
                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                   (Eval (Vint (Int.repr 3)) tint) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
             tdouble)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                           (tptr (Tstruct _DoubleRMat noattr)))
                         (Tstruct _DoubleRMat noattr))
                       (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                   (tarray tdouble 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
               tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                           (tptr (Tstruct _DoubleRMat noattr)))
                         (Tstruct _DoubleRMat noattr))
                       (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                   (tarray tdouble 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
               tdouble)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 1)) tint) tint) (tptr tdouble))
                 tdouble) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 2)) tint) tint) (tptr tdouble))
                 tdouble)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tdouble))
                   tdouble) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tdouble))
                   tdouble)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble) tdouble))
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tdouble))
                   tdouble)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
                       (tptr tdouble)) tdouble) tdouble) tdouble)))))))
|}.

Definition f_double_rmat_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_a2c, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_m_a2b, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_m_b2c, (tptr (Tstruct _DoubleRMat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                       (tptr (Tstruct _DoubleRMat noattr)))
                     (Tstruct _DoubleRMat noattr))
                   (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
               (tarray tdouble 9)) (Eval (Vint (Int.repr 0)) tint)
             (tptr tdouble)) tdouble)
         (Ebinop Oadd
           (Ebinop Oadd
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tdouble)) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 1)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 3)) tint) (tptr tdouble)) tdouble)
                 tdouble) tdouble) tdouble)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tdouble)) tdouble) tdouble)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9)) (Eval (Vint (Int.repr 6)) tint)
                   (tptr tdouble)) tdouble) tdouble) tdouble) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                         (tptr (Tstruct _DoubleRMat noattr)))
                       (Tstruct _DoubleRMat noattr))
                     (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                 (tarray tdouble 9)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tdouble)) tdouble)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 0)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                     tdouble) tdouble) tdouble)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 4)) tint) (tptr tdouble))
                     tdouble) tdouble) tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 2)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 7)) tint) (tptr tdouble)) tdouble)
                 tdouble) tdouble) tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                           (tptr (Tstruct _DoubleRMat noattr)))
                         (Tstruct _DoubleRMat noattr))
                       (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                   (tarray tdouble 9)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tdouble)) tdouble)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tdouble))
                       tdouble) tdouble)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 2)) tint) (tptr tdouble))
                       tdouble) tdouble) tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                       tdouble) tdouble)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
                       tdouble) tdouble) tdouble) tdouble)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 8)) tint) (tptr tdouble))
                     tdouble) tdouble) tdouble) tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tdouble)) tdouble)
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tdouble))
                         tdouble) tdouble)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tdouble))
                         tdouble) tdouble) tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 4)) tint) (tptr tdouble))
                         tdouble) tdouble)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tdouble))
                         tdouble) tdouble) tdouble) tdouble)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
                       tdouble) tdouble)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tdouble))
                       tdouble) tdouble) tdouble) tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 4)) tint) (tptr tdouble)) tdouble)
                 (Ebinop Oadd
                   (Ebinop Oadd
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tdouble))
                           tdouble) tdouble)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                           tdouble) tdouble) tdouble)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tdouble))
                           tdouble) tdouble)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tdouble))
                           tdouble) tdouble) tdouble) tdouble)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
                         tdouble) tdouble)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tdouble))
                         tdouble) tdouble) tdouble) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
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
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 3)) tint)
                               (tptr tdouble)) tdouble) tdouble)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr tdouble)) tdouble) tdouble) tdouble)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 4)) tint)
                               (tptr tdouble)) tdouble) tdouble)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 5)) tint)
                               (tptr tdouble)) tdouble) tdouble) tdouble)
                       tdouble)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
                           tdouble) tdouble)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                       (tptr (Tstruct _DoubleRMat noattr)))
                                     (Tstruct _DoubleRMat noattr))
                                   (Tstruct _DoubleRMat noattr)) _m
                                 (tarray tdouble 9)) (tarray tdouble 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tdouble))
                           tdouble) tdouble) tdouble) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                                   (tptr (Tstruct _DoubleRMat noattr)))
                                 (Tstruct _DoubleRMat noattr))
                               (Tstruct _DoubleRMat noattr)) _m
                             (tarray tdouble 9)) (tarray tdouble 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tdouble))
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
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 6)) tint)
                                 (tptr tdouble)) tdouble) tdouble)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr tdouble)) tdouble) tdouble) tdouble)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 7)) tint)
                                 (tptr tdouble)) tdouble) tdouble)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 3)) tint)
                                 (tptr tdouble)) tdouble) tdouble) tdouble)
                         tdouble)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 8)) tint)
                               (tptr tdouble)) tdouble) tdouble)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                         (tptr (Tstruct _DoubleRMat noattr)))
                                       (Tstruct _DoubleRMat noattr))
                                     (Tstruct _DoubleRMat noattr)) _m
                                   (tarray tdouble 9)) (tarray tdouble 9))
                               (Eval (Vint (Int.repr 6)) tint)
                               (tptr tdouble)) tdouble) tdouble) tdouble)
                       tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tdouble))
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
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 6)) tint)
                                   (tptr tdouble)) tdouble) tdouble)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tdouble)) tdouble) tdouble) tdouble)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tdouble)) tdouble) tdouble)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tdouble)) tdouble) tdouble) tdouble)
                           tdouble)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tdouble)) tdouble) tdouble)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 7)) tint)
                                 (tptr tdouble)) tdouble) tdouble) tdouble)
                         tdouble) tdouble))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _DoubleRMat noattr)))
                                     (tptr (Tstruct _DoubleRMat noattr)))
                                   (Tstruct _DoubleRMat noattr))
                                 (Tstruct _DoubleRMat noattr)) _m
                               (tarray tdouble 9)) (tarray tdouble 9))
                           (Eval (Vint (Int.repr 8)) tint) (tptr tdouble))
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
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 6)) tint)
                                   (tptr tdouble)) tdouble) tdouble)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tdouble)) tdouble) tdouble) tdouble)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tdouble)) tdouble) tdouble)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tdouble)) tdouble) tdouble) tdouble)
                           tdouble)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tdouble)) tdouble) tdouble)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                           (tptr (Tstruct _DoubleRMat noattr)))
                                         (Tstruct _DoubleRMat noattr))
                                       (Tstruct _DoubleRMat noattr)) _m
                                     (tarray tdouble 9)) (tarray tdouble 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tdouble)) tdouble) tdouble) tdouble)
                         tdouble) tdouble))))))))))
|}.

Definition f_double_rmat_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vb, (tptr (Tstruct _DoubleVect3 noattr))) ::
                (_m_a2b, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_va, (tptr (Tstruct _DoubleVect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vb (tptr (Tstruct _DoubleVect3 noattr)))
                 (tptr (Tstruct _DoubleVect3 noattr)))
               (Tstruct _DoubleVect3 noattr)) (Tstruct _DoubleVect3 noattr))
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
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _x tdouble) tdouble)
               tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 1)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _y tdouble) tdouble)
               tdouble) tdouble)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tdouble)) tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                       (tptr (Tstruct _DoubleVect3 noattr)))
                     (Tstruct _DoubleVect3 noattr))
                   (Tstruct _DoubleVect3 noattr)) _z tdouble) tdouble)
             tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _DoubleVect3 noattr)))
                   (tptr (Tstruct _DoubleVect3 noattr)))
                 (Tstruct _DoubleVect3 noattr))
               (Tstruct _DoubleVect3 noattr)) _y tdouble)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 3)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _x tdouble) tdouble)
                 tdouble)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 4)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 5)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _DoubleVect3 noattr)))
                   (tptr (Tstruct _DoubleVect3 noattr)))
                 (Tstruct _DoubleVect3 noattr))
               (Tstruct _DoubleVect3 noattr)) _z tdouble)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 6)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _x tdouble) tdouble)
                 tdouble)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 7)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 8)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))))
|}.

Definition f_double_rmat_transp_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vb, (tptr (Tstruct _DoubleVect3 noattr))) ::
                (_m_b2a, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_va, (tptr (Tstruct _DoubleVect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vb (tptr (Tstruct _DoubleVect3 noattr)))
                 (tptr (Tstruct _DoubleVect3 noattr)))
               (Tstruct _DoubleVect3 noattr)) (Tstruct _DoubleVect3 noattr))
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
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _x tdouble) tdouble)
               tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 3)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _y tdouble) tdouble)
               tdouble) tdouble)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                             (tptr (Tstruct _DoubleRMat noattr)))
                           (Tstruct _DoubleRMat noattr))
                         (Tstruct _DoubleRMat noattr)) _m (tarray tdouble 9))
                     (tarray tdouble 9)) (Eval (Vint (Int.repr 6)) tint)
                   (tptr tdouble)) tdouble) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                       (tptr (Tstruct _DoubleVect3 noattr)))
                     (Tstruct _DoubleVect3 noattr))
                   (Tstruct _DoubleVect3 noattr)) _z tdouble) tdouble)
             tdouble) tdouble) tdouble))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _DoubleVect3 noattr)))
                   (tptr (Tstruct _DoubleVect3 noattr)))
                 (Tstruct _DoubleVect3 noattr))
               (Tstruct _DoubleVect3 noattr)) _y tdouble)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _x tdouble) tdouble)
                 tdouble)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 4)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 7)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _DoubleVect3 noattr)))
                   (tptr (Tstruct _DoubleVect3 noattr)))
                 (Tstruct _DoubleVect3 noattr))
               (Tstruct _DoubleVect3 noattr)) _z tdouble)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _x tdouble) tdouble)
                 tdouble)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                                 (tptr (Tstruct _DoubleRMat noattr)))
                               (Tstruct _DoubleRMat noattr))
                             (Tstruct _DoubleRMat noattr)) _m
                           (tarray tdouble 9)) (tarray tdouble 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tdouble))
                     tdouble) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                           (tptr (Tstruct _DoubleVect3 noattr)))
                         (Tstruct _DoubleVect3 noattr))
                       (Tstruct _DoubleVect3 noattr)) _y tdouble) tdouble)
                 tdouble) tdouble)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _DoubleRMat noattr)))
                               (tptr (Tstruct _DoubleRMat noattr)))
                             (Tstruct _DoubleRMat noattr))
                           (Tstruct _DoubleRMat noattr)) _m
                         (tarray tdouble 9)) (tarray tdouble 9))
                     (Eval (Vint (Int.repr 8)) tint) (tptr tdouble)) tdouble)
                 tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _va (tptr (Tstruct _DoubleVect3 noattr)))
                         (tptr (Tstruct _DoubleVect3 noattr)))
                       (Tstruct _DoubleVect3 noattr))
                     (Tstruct _DoubleVect3 noattr)) _z tdouble) tdouble)
               tdouble) tdouble) tdouble))))
|}.

Definition f_double_rmat_of_quat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _DoubleRMat noattr))) ::
                (_q, (tptr (Tstruct _DoubleQuat noattr))) :: nil);
  fn_vars := ((__a, tdouble) :: (__b, tdouble) :: (__c, tdouble) ::
              (__d, tdouble) :: (_a2_1, tdouble) :: (_ab, tdouble) ::
              (_ac, tdouble) :: (_ad, tdouble) :: (_bc, tdouble) ::
              (_bd, tdouble) :: (_cd, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar __a tdouble)
         (Ebinop Omul
           (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                     (tptr (Tstruct _DoubleQuat noattr)))
                   (Tstruct _DoubleQuat noattr))
                 (Tstruct _DoubleQuat noattr)) _qi tdouble) tdouble) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign (Evar __b tdouble)
           (Ebinop Omul
             (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                       (tptr (Tstruct _DoubleQuat noattr)))
                     (Tstruct _DoubleQuat noattr))
                   (Tstruct _DoubleQuat noattr)) _qx tdouble) tdouble)
             tdouble) tdouble))
    (Ssequence
      (Sdo (Eassign (Evar __c tdouble)
             (Ebinop Omul
               (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                         (tptr (Tstruct _DoubleQuat noattr)))
                       (Tstruct _DoubleQuat noattr))
                     (Tstruct _DoubleQuat noattr)) _qy tdouble) tdouble)
               tdouble) tdouble))
      (Ssequence
        (Sdo (Eassign (Evar __d tdouble)
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q (tptr (Tstruct _DoubleQuat noattr)))
                           (tptr (Tstruct _DoubleQuat noattr)))
                         (Tstruct _DoubleQuat noattr))
                       (Tstruct _DoubleQuat noattr)) _qz tdouble) tdouble)
                 tdouble) tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _a2_1 tdouble)
                 (Ebinop Osub
                   (Ebinop Omul (Evalof (Evar __a tdouble) tdouble)
                     (Evalof (Evar __a tdouble) tdouble) tdouble)
                   (Eval (Vint (Int.repr 1)) tint) tdouble) tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _ab tdouble)
                   (Ebinop Omul (Evalof (Evar __a tdouble) tdouble)
                     (Evalof (Evar __b tdouble) tdouble) tdouble) tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _ac tdouble)
                     (Ebinop Omul (Evalof (Evar __a tdouble) tdouble)
                       (Evalof (Evar __c tdouble) tdouble) tdouble) tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _ad tdouble)
                       (Ebinop Omul (Evalof (Evar __a tdouble) tdouble)
                         (Evalof (Evar __d tdouble) tdouble) tdouble)
                       tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _bc tdouble)
                         (Ebinop Omul (Evalof (Evar __b tdouble) tdouble)
                           (Evalof (Evar __c tdouble) tdouble) tdouble)
                         tdouble))
                  (Ssequence
                    (Sdo (Eassign (Evar _bd tdouble)
                           (Ebinop Omul (Evalof (Evar __b tdouble) tdouble)
                             (Evalof (Evar __d tdouble) tdouble) tdouble)
                           tdouble))
                    (Ssequence
                      (Sdo (Eassign (Evar _cd tdouble)
                             (Ebinop Omul (Evalof (Evar __c tdouble) tdouble)
                               (Evalof (Evar __d tdouble) tdouble) tdouble)
                             tdouble))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                             (tptr (Tstruct _DoubleRMat noattr)))
                                           (Tstruct _DoubleRMat noattr))
                                         (Tstruct _DoubleRMat noattr)) _m
                                       (tarray tdouble 9))
                                     (tarray tdouble 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 0)) tint) tint)
                                   (tptr tdouble)) tdouble)
                               (Ebinop Oadd
                                 (Evalof (Evar _a2_1 tdouble) tdouble)
                                 (Ebinop Omul
                                   (Evalof (Evar __b tdouble) tdouble)
                                   (Evalof (Evar __b tdouble) tdouble)
                                   tdouble) tdouble) tdouble))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                               (tptr (Tstruct _DoubleRMat noattr)))
                                             (Tstruct _DoubleRMat noattr))
                                           (Tstruct _DoubleRMat noattr)) _m
                                         (tarray tdouble 9))
                                       (tarray tdouble 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (tptr tdouble)) tdouble)
                                 (Ebinop Oadd
                                   (Evalof (Evar _bc tdouble) tdouble)
                                   (Evalof (Evar _ad tdouble) tdouble)
                                   tdouble) tdouble))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                 (tptr (Tstruct _DoubleRMat noattr)))
                                               (Tstruct _DoubleRMat noattr))
                                             (Tstruct _DoubleRMat noattr)) _m
                                           (tarray tdouble 9))
                                         (tarray tdouble 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tdouble)) tdouble)
                                   (Ebinop Osub
                                     (Evalof (Evar _bd tdouble) tdouble)
                                     (Evalof (Evar _ac tdouble) tdouble)
                                     tdouble) tdouble))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                   (tptr (Tstruct _DoubleRMat noattr)))
                                                 (Tstruct _DoubleRMat noattr))
                                               (Tstruct _DoubleRMat noattr))
                                             _m (tarray tdouble 9))
                                           (tarray tdouble 9))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Eval (Vint (Int.repr 3)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint) (tptr tdouble)) tdouble)
                                     (Ebinop Osub
                                       (Evalof (Evar _bc tdouble) tdouble)
                                       (Evalof (Evar _ad tdouble) tdouble)
                                       tdouble) tdouble))
                              (Ssequence
                                (Sdo (Eassign
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                     (tptr (Tstruct _DoubleRMat noattr)))
                                                   (Tstruct _DoubleRMat noattr))
                                                 (Tstruct _DoubleRMat noattr))
                                               _m (tarray tdouble 9))
                                             (tarray tdouble 9))
                                           (Ebinop Oadd
                                             (Ebinop Omul
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Eval (Vint (Int.repr 3)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tint) (tptr tdouble)) tdouble)
                                       (Ebinop Oadd
                                         (Evalof (Evar _a2_1 tdouble)
                                           tdouble)
                                         (Ebinop Omul
                                           (Evalof (Evar __c tdouble)
                                             tdouble)
                                           (Evalof (Evar __c tdouble)
                                             tdouble) tdouble) tdouble)
                                       tdouble))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                       (tptr (Tstruct _DoubleRMat noattr)))
                                                     (Tstruct _DoubleRMat noattr))
                                                   (Tstruct _DoubleRMat noattr))
                                                 _m (tarray tdouble 9))
                                               (tarray tdouble 9))
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 2)) tint)
                                               tint) (tptr tdouble)) tdouble)
                                         (Ebinop Oadd
                                           (Evalof (Evar _cd tdouble)
                                             tdouble)
                                           (Evalof (Evar _ab tdouble)
                                             tdouble) tdouble) tdouble))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                         (tptr (Tstruct _DoubleRMat noattr)))
                                                       (Tstruct _DoubleRMat noattr))
                                                     (Tstruct _DoubleRMat noattr))
                                                   _m (tarray tdouble 9))
                                                 (tarray tdouble 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 tint) (tptr tdouble))
                                             tdouble)
                                           (Ebinop Oadd
                                             (Evalof (Evar _bd tdouble)
                                               tdouble)
                                             (Evalof (Evar _ac tdouble)
                                               tdouble) tdouble) tdouble))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                           (tptr (Tstruct _DoubleRMat noattr)))
                                                         (Tstruct _DoubleRMat noattr))
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
                                               tdouble)
                                             (Ebinop Osub
                                               (Evalof (Evar _cd tdouble)
                                                 tdouble)
                                               (Evalof (Evar _ab tdouble)
                                                 tdouble) tdouble) tdouble))
                                      (Sdo (Eassign
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _rm (tptr (Tstruct _DoubleRMat noattr)))
                                                           (tptr (Tstruct _DoubleRMat noattr)))
                                                         (Tstruct _DoubleRMat noattr))
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
                                               tdouble)
                                             (Ebinop Oadd
                                               (Evalof (Evar _a2_1 tdouble)
                                                 tdouble)
                                               (Ebinop Omul
                                                 (Evalof (Evar __d tdouble)
                                                   tdouble)
                                                 (Evalof (Evar __d tdouble)
                                                   tdouble) tdouble) tdouble)
                                             tdouble)))))))))))))))))))))
|}.

Definition v_five_keep_double_rmat_of_eulers_321 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_rmat_of_eulers_321 (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_quat_of_eulers := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_quat_of_eulers (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_eulers_of_quat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_eulers_of_quat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_quat_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_quat_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_quat_comp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_quat_comp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_rmat_inv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_rmat_inv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_rmat_comp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_rmat_comp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_rmat_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_rmat_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_rmat_transp_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_rmat_transp_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_double_rmat_of_quat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _double_rmat_of_quat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _DoubleVect3 Struct
   (Member_plain _x tdouble :: Member_plain _y tdouble ::
    Member_plain _z tdouble :: nil)
   noattr ::
 Composite _DoubleQuat Struct
   (Member_plain _qi tdouble :: Member_plain _qx tdouble ::
    Member_plain _qy tdouble :: Member_plain _qz tdouble :: nil)
   noattr ::
 Composite _DoubleRMat Struct
   (Member_plain _m (tarray tdouble 9) :: nil)
   noattr ::
 Composite _DoubleEulers Struct
   (Member_plain _phi tdouble :: Member_plain _theta tdouble ::
    Member_plain _psi tdouble :: nil)
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
 (_double_rmat_of_eulers_321, Gfun(Internal f_double_rmat_of_eulers_321)) ::
 (_double_quat_of_eulers, Gfun(Internal f_double_quat_of_eulers)) ::
 (_double_eulers_of_quat, Gfun(Internal f_double_eulers_of_quat)) ::
 (_double_quat_vmult, Gfun(Internal f_double_quat_vmult)) ::
 (_double_quat_comp, Gfun(Internal f_double_quat_comp)) ::
 (_double_rmat_inv, Gfun(Internal f_double_rmat_inv)) ::
 (_double_rmat_comp, Gfun(Internal f_double_rmat_comp)) ::
 (_double_rmat_vmult, Gfun(Internal f_double_rmat_vmult)) ::
 (_double_rmat_transp_vmult, Gfun(Internal f_double_rmat_transp_vmult)) ::
 (_double_rmat_of_quat, Gfun(Internal f_double_rmat_of_quat)) ::
 (_five_keep_double_rmat_of_eulers_321, Gvar v_five_keep_double_rmat_of_eulers_321) ::
 (_five_keep_double_quat_of_eulers, Gvar v_five_keep_double_quat_of_eulers) ::
 (_five_keep_double_eulers_of_quat, Gvar v_five_keep_double_eulers_of_quat) ::
 (_five_keep_double_quat_vmult, Gvar v_five_keep_double_quat_vmult) ::
 (_five_keep_double_quat_comp, Gvar v_five_keep_double_quat_comp) ::
 (_five_keep_double_rmat_inv, Gvar v_five_keep_double_rmat_inv) ::
 (_five_keep_double_rmat_comp, Gvar v_five_keep_double_rmat_comp) ::
 (_five_keep_double_rmat_vmult, Gvar v_five_keep_double_rmat_vmult) ::
 (_five_keep_double_rmat_transp_vmult, Gvar v_five_keep_double_rmat_transp_vmult) ::
 (_five_keep_double_rmat_of_quat, Gvar v_five_keep_double_rmat_of_quat) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_double_rmat_of_quat :: _five_keep_double_rmat_transp_vmult ::
 _five_keep_double_rmat_vmult :: _five_keep_double_rmat_comp ::
 _five_keep_double_rmat_inv :: _five_keep_double_quat_comp ::
 _five_keep_double_quat_vmult :: _five_keep_double_eulers_of_quat ::
 _five_keep_double_quat_of_eulers :: _five_keep_double_rmat_of_eulers_321 ::
 _double_rmat_of_quat :: _double_rmat_transp_vmult :: _double_rmat_vmult ::
 _double_rmat_comp :: _double_rmat_inv :: _double_quat_comp ::
 _double_quat_vmult :: _double_eulers_of_quat :: _double_quat_of_eulers ::
 _double_rmat_of_eulers_321 :: _sin :: _cos :: _atan2 :: _asin ::
 ___builtin_debug :: ___builtin_write32_reversed ::
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


