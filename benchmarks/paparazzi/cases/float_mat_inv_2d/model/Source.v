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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/models/algebra/model/preprocessed.i".
End Info.

Definition _FloatQuat : ident := $"FloatQuat".
Definition _FloatRMat : ident := $"FloatRMat".
Definition _FloatVect3 : ident := $"FloatVect3".
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
Definition __err : ident := $"_err".
Definition _a2b : ident := $"a2b".
Definition _a2c : ident := $"a2c".
Definition _b2c : ident := $"b2c".
Definition _det : ident := $"det".
Definition _dt : ident := $"dt".
Definition _dv : ident := $"dv".
Definition _fabs : ident := $"fabs".
Definition _fabsf : ident := $"fabsf".
Definition _float_mat_inv_2d : ident := $"float_mat_inv_2d".
Definition _float_mat_inv_3d : ident := $"float_mat_inv_3d".
Definition _float_quat_comp : ident := $"float_quat_comp".
Definition _float_quat_vmult : ident := $"float_quat_vmult".
Definition _float_rmat_comp : ident := $"float_rmat_comp".
Definition _float_rmat_reorthogonalize : ident := $"float_rmat_reorthogonalize".
Definition _float_rmat_vmult : ident := $"float_rmat_vmult".
Definition _float_vect3_integrate_fi : ident := $"float_vect3_integrate_fi".
Definition _inv_out : ident := $"inv_out".
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
Definition _m_b2c : ident := $"m_b2c".
Definition _main : ident := $"main".
Definition _mat_in : ident := $"mat_in".
Definition _n : ident := $"n".
Definition _q : ident := $"q".
Definition _qi : ident := $"qi".
Definition _qi2_M1_2 : ident := $"qi2_M1_2".
Definition _qiqx : ident := $"qiqx".
Definition _qiqy : ident := $"qiqy".
Definition _qiqz : ident := $"qiqz".
Definition _qx : ident := $"qx".
Definition _qy : ident := $"qy".
Definition _qz : ident := $"qz".
Definition _r0 : ident := $"r0".
Definition _r0_t : ident := $"r0_t".
Definition _r1 : ident := $"r1".
Definition _r1_t : ident := $"r1_t".
Definition _r2_t : ident := $"r2_t".
Definition _renorm_factor : ident := $"renorm_factor".
Definition _rm : ident := $"rm".
Definition _s : ident := $"s".
Definition _sqrtf : ident := $"sqrtf".
Definition _v_in : ident := $"v_in".
Definition _v_out : ident := $"v_out".
Definition _va : ident := $"va".
Definition _vb : ident := $"vb".
Definition _vec : ident := $"vec".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".

Definition f_float_vect3_integrate_fi := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vec, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_dv, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_dt, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassignop Oadd
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vec (tptr (Tstruct _FloatVect3 noattr)))
                 (tptr (Tstruct _FloatVect3 noattr)))
               (Tstruct _FloatVect3 noattr)) (Tstruct _FloatVect3 noattr)) _x
           tfloat)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _dv (tptr (Tstruct _FloatVect3 noattr)))
                     (tptr (Tstruct _FloatVect3 noattr)))
                   (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
           (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))
  (Ssequence
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vec (tptr (Tstruct _FloatVect3 noattr)))
                   (tptr (Tstruct _FloatVect3 noattr)))
                 (Tstruct _FloatVect3 noattr)) (Tstruct _FloatVect3 noattr))
             _y tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dv (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
             (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vec (tptr (Tstruct _FloatVect3 noattr)))
                   (tptr (Tstruct _FloatVect3 noattr)))
                 (Tstruct _FloatVect3 noattr)) (Tstruct _FloatVect3 noattr))
             _z tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dv (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
             (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))))
|}.

Definition f_float_rmat_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_a2c, (tptr (Tstruct _FloatRMat noattr))) ::
                (_m_a2b, (tptr (Tstruct _FloatRMat noattr))) ::
                (_m_b2c, (tptr (Tstruct _FloatRMat noattr))) :: nil);
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
                     (Evalof (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                       (tptr (Tstruct _FloatRMat noattr)))
                     (Tstruct _FloatRMat noattr))
                   (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
               (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
             (tptr tfloat)) tfloat)
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
                               (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 6)) tint)
                   (tptr tfloat)) tfloat) tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                         (tptr (Tstruct _FloatRMat noattr)))
                       (Tstruct _FloatRMat noattr))
                     (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                 (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tfloat)) tfloat)
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
                                 (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 4)) tint) (tptr tfloat)) tfloat)
                   tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 7)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                           (tptr (Tstruct _FloatRMat noattr)))
                         (Tstruct _FloatRMat noattr))
                       (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                   (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tfloat)) tfloat)
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
                                   (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                       tfloat) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                       tfloat) tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                       tfloat) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                       tfloat) tfloat) tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 8)) tint) (tptr tfloat)) tfloat)
                   tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tfloat)) tfloat)
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
                                     (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                       tfloat) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tfloat))
                       tfloat) tfloat) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 4)) tint)
                     (tptr tfloat)) tfloat)
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
                                       (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat) tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
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
                                         (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tfloat))
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
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 6)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 7)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 3)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 8)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 6)) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
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
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 6)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 7)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         tfloat) tfloat))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 8)) tint) (tptr tfloat))
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
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 6)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         tfloat) tfloat))))))))))
|}.

Definition f_float_rmat_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vb, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_m_a2b, (tptr (Tstruct _FloatRMat noattr))) ::
                (_va, (tptr (Tstruct _FloatVect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vb (tptr (Tstruct _FloatVect3 noattr)))
                 (tptr (Tstruct _FloatVect3 noattr)))
               (Tstruct _FloatVect3 noattr)) (Tstruct _FloatVect3 noattr)) _x
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
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat) tfloat)
             tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _FloatVect3 noattr)))
                   (tptr (Tstruct _FloatVect3 noattr)))
                 (Tstruct _FloatVect3 noattr)) (Tstruct _FloatVect3 noattr))
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
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 4)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 5)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _FloatVect3 noattr)))
                   (tptr (Tstruct _FloatVect3 noattr)))
                 (Tstruct _FloatVect3 noattr)) (Tstruct _FloatVect3 noattr))
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
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 6)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 7)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 8)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _va (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))))
|}.

Definition f_renorm_factor := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_n, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sifthenelse (Eseqand
               (Ebinop Olt (Evalof (Evar _n tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1070071808))) tfloat)
                 tint)
               (Ebinop Ogt (Evalof (Evar _n tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1059313418))) tfloat)
                 tint) tint)
  (Sreturn (Some (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                   (Ebinop Osub (Eval (Vint (Int.repr 3)) tint)
                     (Evalof (Evar _n tfloat) tfloat) tfloat) tdouble)))
  (Sifthenelse (Eseqand
                 (Ebinop Olt (Evalof (Evar _n tfloat) tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 1120403456))) tfloat)
                   tint)
                 (Ebinop Ogt (Evalof (Evar _n tfloat) tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 1008981770))) tfloat)
                   tint) tint)
    (Sreturn (Some (Ebinop Odiv
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Ecall
                       (Evalof
                         (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat
                                        cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _n tfloat) tfloat) Enil) tfloat)
                     tdouble)))
    (Sreturn (Some (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)))))
|}.

Definition f_float_rmat_reorthogonalize := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) :: nil);
  fn_vars := ((_r0, (Tstruct _FloatVect3 noattr)) ::
              (_r1, (Tstruct _FloatVect3 noattr)) :: (__err, tfloat) ::
              (_r0_t, (Tstruct _FloatVect3 noattr)) ::
              (_r1_t, (Tstruct _FloatVect3 noattr)) ::
              (_r2_t, (Tstruct _FloatVect3 noattr)) :: (_s, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof (Evar _r0 (Tstruct _FloatVect3 noattr))
             (Tstruct _FloatVect3 noattr)) _x tfloat)
         (Evalof
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                         (tptr (Tstruct _FloatRMat noattr)))
                       (Tstruct _FloatRMat noattr))
                     (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                 (tarray tfloat 9))
               (Ebinop Oadd
                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                   (Eval (Vint (Int.repr 3)) tint) tint)
                 (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat)) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _r0 (Tstruct _FloatVect3 noattr))
               (Tstruct _FloatVect3 noattr)) _y tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                           (tptr (Tstruct _FloatRMat noattr)))
                         (Tstruct _FloatRMat noattr))
                       (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                   (tarray tfloat 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
               tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _r0 (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _z tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
                 tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _r1 (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _x tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                   tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _r1 (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _y tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                     tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof (Evar _r1 (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _z tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 2)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar __err tfloat)
                     (Ebinop Omul
                       (Eunop Oneg
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                         tdouble)
                       (Ebinop Oadd
                         (Ebinop Oadd
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r0 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _x tfloat)
                               tfloat)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r1 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _x tfloat)
                               tfloat) tfloat)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r0 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _y tfloat)
                               tfloat)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r1 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _y tfloat)
                               tfloat) tfloat) tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _r0 (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _z tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _r1 (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _z tfloat)
                             tfloat) tfloat) tfloat) tdouble) tfloat))
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _r0_t (Tstruct _FloatVect3 noattr))
                             (Tstruct _FloatVect3 noattr)) _x tfloat)
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _r0 (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _x tfloat)
                             tfloat)
                           (Ebinop Omul (Evalof (Evar __err tfloat) tfloat)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r1 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _x tfloat)
                               tfloat) tfloat) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Evar _r0_t (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _y tfloat)
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r0 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _y tfloat)
                               tfloat)
                             (Ebinop Omul (Evalof (Evar __err tfloat) tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _r1 (Tstruct _FloatVect3 noattr))
                                     (Tstruct _FloatVect3 noattr)) _y tfloat)
                                 tfloat) tfloat) tfloat) tfloat))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Evar _r0_t (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _z tfloat)
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r0 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _z tfloat)
                               tfloat)
                             (Ebinop Omul (Evalof (Evar __err tfloat) tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _r1 (Tstruct _FloatVect3 noattr))
                                     (Tstruct _FloatVect3 noattr)) _z tfloat)
                                 tfloat) tfloat) tfloat) tfloat))))
                (Ssequence
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Evar _r1_t (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _x tfloat)
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _r1 (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _x tfloat)
                               tfloat)
                             (Ebinop Omul (Evalof (Evar __err tfloat) tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _r0 (Tstruct _FloatVect3 noattr))
                                     (Tstruct _FloatVect3 noattr)) _x tfloat)
                                 tfloat) tfloat) tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _y tfloat)
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _r1 (Tstruct _FloatVect3 noattr))
                                     (Tstruct _FloatVect3 noattr)) _y tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Evalof (Evar __err tfloat) tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _r0 (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _y
                                     tfloat) tfloat) tfloat) tfloat) tfloat))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _z tfloat)
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Evar _r1 (Tstruct _FloatVect3 noattr))
                                     (Tstruct _FloatVect3 noattr)) _z tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Evalof (Evar __err tfloat) tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _r0 (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _z
                                     tfloat) tfloat) tfloat) tfloat) tfloat))))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _x tfloat)
                             (Ebinop Osub
                               (Ebinop Omul
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _y
                                     tfloat) tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _z
                                     tfloat) tfloat) tfloat)
                               (Ebinop Omul
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _z
                                     tfloat) tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _y
                                     tfloat) tfloat) tfloat) tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _y tfloat)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _z
                                       tfloat) tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _x
                                       tfloat) tfloat) tfloat)
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _x
                                       tfloat) tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _z
                                       tfloat) tfloat) tfloat) tfloat)
                               tfloat))
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                   (Tstruct _FloatVect3 noattr)) _z tfloat)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _x
                                       tfloat) tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _y
                                       tfloat) tfloat) tfloat)
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _y
                                       tfloat) tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _x
                                       tfloat) tfloat) tfloat) tfloat)
                               tfloat))))
                    (Ssequence
                      (Sdo (Eassign (Evar _s tfloat)
                             (Ecall
                               (Evalof
                                 (Evar _renorm_factor (Tfunction
                                                        (tfloat :: nil)
                                                        tfloat cc_default))
                                 (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                               (Econs
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                             (Tstruct _FloatVect3 noattr)) _x
                                           tfloat) tfloat)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                             (Tstruct _FloatVect3 noattr)) _x
                                           tfloat) tfloat) tfloat)
                                     (Ebinop Omul
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                             (Tstruct _FloatVect3 noattr)) _y
                                           tfloat) tfloat)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                             (Tstruct _FloatVect3 noattr)) _y
                                           tfloat) tfloat) tfloat) tfloat)
                                   (Ebinop Omul
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                           (Tstruct _FloatVect3 noattr)) _z
                                         tfloat) tfloat)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                           (Tstruct _FloatVect3 noattr)) _z
                                         tfloat) tfloat) tfloat) tfloat)
                                 Enil) tfloat) tfloat))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                               (tptr (Tstruct _FloatRMat noattr)))
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _x
                                       tfloat) tfloat)
                                   (Evalof (Evar _s tfloat) tfloat) tfloat)
                                 tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                 (tptr (Tstruct _FloatRMat noattr)))
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tfloat)) tfloat)
                                   (Ebinop Omul
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                           (Tstruct _FloatVect3 noattr)) _y
                                         tfloat) tfloat)
                                     (Evalof (Evar _s tfloat) tfloat) tfloat)
                                   tfloat))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                 (tptr (Tstruct _FloatRMat noattr)))
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tfloat)) tfloat)
                                   (Ebinop Omul
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _r0_t (Tstruct _FloatVect3 noattr))
                                           (Tstruct _FloatVect3 noattr)) _z
                                         tfloat) tfloat)
                                     (Evalof (Evar _s tfloat) tfloat) tfloat)
                                   tfloat))))
                        (Ssequence
                          (Sdo (Eassign (Evar _s tfloat)
                                 (Ecall
                                   (Evalof
                                     (Evar _renorm_factor (Tfunction
                                                            (tfloat :: nil)
                                                            tfloat
                                                            cc_default))
                                     (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                                   (Econs
                                     (Ebinop Oadd
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                                 (Tstruct _FloatVect3 noattr))
                                               _x tfloat) tfloat)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                                 (Tstruct _FloatVect3 noattr))
                                               _x tfloat) tfloat) tfloat)
                                         (Ebinop Omul
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                                 (Tstruct _FloatVect3 noattr))
                                               _y tfloat) tfloat)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                                 (Tstruct _FloatVect3 noattr))
                                               _y tfloat) tfloat) tfloat)
                                         tfloat)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _z tfloat) tfloat)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _z tfloat) tfloat) tfloat)
                                       tfloat) Enil) tfloat) tfloat))
                          (Ssequence
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                   (tptr (Tstruct _FloatRMat noattr)))
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Eval (Vint (Int.repr 3)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint) (tptr tfloat)) tfloat)
                                     (Ebinop Omul
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                             (Tstruct _FloatVect3 noattr)) _x
                                           tfloat) tfloat)
                                       (Evalof (Evar _s tfloat) tfloat)
                                       tfloat) tfloat))
                              (Ssequence
                                (Sdo (Eassign
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                     (tptr (Tstruct _FloatRMat noattr)))
                                                   (Tstruct _FloatRMat noattr))
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Ebinop Oadd
                                             (Ebinop Omul
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Eval (Vint (Int.repr 3)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tint) (tptr tfloat)) tfloat)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _y tfloat) tfloat)
                                         (Evalof (Evar _s tfloat) tfloat)
                                         tfloat) tfloat))
                                (Sdo (Eassign
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                     (tptr (Tstruct _FloatRMat noattr)))
                                                   (Tstruct _FloatRMat noattr))
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Ebinop Oadd
                                             (Ebinop Omul
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Eval (Vint (Int.repr 3)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 2)) tint)
                                             tint) (tptr tfloat)) tfloat)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _r1_t (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _z tfloat) tfloat)
                                         (Evalof (Evar _s tfloat) tfloat)
                                         tfloat) tfloat))))
                            (Ssequence
                              (Sdo (Eassign (Evar _s tfloat)
                                     (Ecall
                                       (Evalof
                                         (Evar _renorm_factor (Tfunction
                                                                (tfloat ::
                                                                 nil) tfloat
                                                                cc_default))
                                         (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                                       (Econs
                                         (Ebinop Oadd
                                           (Ebinop Oadd
                                             (Ebinop Omul
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                     (Tstruct _FloatVect3 noattr))
                                                   _x tfloat) tfloat)
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                     (Tstruct _FloatVect3 noattr))
                                                   _x tfloat) tfloat) tfloat)
                                             (Ebinop Omul
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                     (Tstruct _FloatVect3 noattr))
                                                   _y tfloat) tfloat)
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                     (Tstruct _FloatVect3 noattr))
                                                   _y tfloat) tfloat) tfloat)
                                             tfloat)
                                           (Ebinop Omul
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                   (Tstruct _FloatVect3 noattr))
                                                 _z tfloat) tfloat)
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                   (Tstruct _FloatVect3 noattr))
                                                 _z tfloat) tfloat) tfloat)
                                           tfloat) Enil) tfloat) tfloat))
                              (Ssequence
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                       (tptr (Tstruct _FloatRMat noattr)))
                                                     (Tstruct _FloatRMat noattr))
                                                   (Tstruct _FloatRMat noattr))
                                                 _m (tarray tfloat 9))
                                               (tarray tfloat 9))
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 0)) tint)
                                               tint) (tptr tfloat)) tfloat)
                                         (Ebinop Omul
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                 (Tstruct _FloatVect3 noattr))
                                               _x tfloat) tfloat)
                                           (Evalof (Evar _s tfloat) tfloat)
                                           tfloat) tfloat))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                         (tptr (Tstruct _FloatRMat noattr)))
                                                       (Tstruct _FloatRMat noattr))
                                                     (Tstruct _FloatRMat noattr))
                                                   _m (tarray tfloat 9))
                                                 (tarray tfloat 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tint) (tptr tfloat)) tfloat)
                                           (Ebinop Omul
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                   (Tstruct _FloatVect3 noattr))
                                                 _y tfloat) tfloat)
                                             (Evalof (Evar _s tfloat) tfloat)
                                             tfloat) tfloat))
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                         (tptr (Tstruct _FloatRMat noattr)))
                                                       (Tstruct _FloatRMat noattr))
                                                     (Tstruct _FloatRMat noattr))
                                                   _m (tarray tfloat 9))
                                                 (tarray tfloat 9))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 tint) (tptr tfloat)) tfloat)
                                           (Ebinop Omul
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _r2_t (Tstruct _FloatVect3 noattr))
                                                   (Tstruct _FloatVect3 noattr))
                                                 _z tfloat) tfloat)
                                             (Evalof (Evar _s tfloat) tfloat)
                                             tfloat) tfloat))))
                                (Sreturn (Some (Evalof (Evar __err tfloat)
                                                 tfloat)))))))))))))))))))
|}.

Definition f_float_quat_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2c, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2b, (tptr (Tstruct _FloatQuat noattr))) ::
                (_b2c, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr)))
               (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr)) _qi
           tfloat)
         (Ebinop Osub
           (Ebinop Osub
             (Ebinop Osub
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat)
             tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qx tfloat)
           (Ebinop Osub
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qy tfloat)
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                     tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                     tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                 tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qz tfloat)
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                     tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                     tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 tfloat) tfloat) tfloat)))))
|}.

Definition f_float_quat_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_v_out, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_v_in, (tptr (Tstruct _FloatVect3 noattr))) :: nil);
  fn_vars := ((_qi2_M1_2, tfloat) :: (_qiqx, tfloat) :: (_qiqy, tfloat) ::
              (_qiqz, tfloat) :: (_m01, tfloat) :: (_m02, tfloat) ::
              (_m12, tfloat) :: (_m00, tfloat) :: (_m10, tfloat) ::
              (_m20, tfloat) :: (_m21, tfloat) :: (_m11, tfloat) ::
              (_m22, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qi2_M1_2 tfloat)
         (Ebinop Osub
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat) tfloat)
           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
           tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _qiqx tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _qiqy tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat)
             tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _qiqz tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _m01 tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                   tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _m02 tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _m12 tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _m00 tfloat)
                       (Ebinop Oadd (Evalof (Evar _qi2_M1_2 tfloat) tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             tfloat) tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _m10 tfloat)
                         (Ebinop Osub (Evalof (Evar _m01 tfloat) tfloat)
                           (Evalof (Evar _qiqz tfloat) tfloat) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _m20 tfloat)
                           (Ebinop Oadd (Evalof (Evar _m02 tfloat) tfloat)
                             (Evalof (Evar _qiqy tfloat) tfloat) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign (Evar _m21 tfloat)
                             (Ebinop Osub (Evalof (Evar _m12 tfloat) tfloat)
                               (Evalof (Evar _qiqx tfloat) tfloat) tfloat)
                             tfloat))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _m01 tfloat)
                               (Evalof (Evar _qiqz tfloat) tfloat)
                               tfloat tfloat))
                        (Ssequence
                          (Sdo (Eassignop Osub (Evar _m02 tfloat)
                                 (Evalof (Evar _qiqy tfloat) tfloat)
                                 tfloat tfloat))
                          (Ssequence
                            (Sdo (Eassignop Oadd (Evar _m12 tfloat)
                                   (Evalof (Evar _qiqx tfloat) tfloat)
                                   tfloat tfloat))
                            (Ssequence
                              (Sdo (Eassign (Evar _m11 tfloat)
                                     (Ebinop Oadd
                                       (Evalof (Evar _qi2_M1_2 tfloat)
                                         tfloat)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                                   (tptr (Tstruct _FloatQuat noattr)))
                                                 (Tstruct _FloatQuat noattr))
                                               (Tstruct _FloatQuat noattr))
                                             _qy tfloat) tfloat)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                                   (tptr (Tstruct _FloatQuat noattr)))
                                                 (Tstruct _FloatQuat noattr))
                                               (Tstruct _FloatQuat noattr))
                                             _qy tfloat) tfloat) tfloat)
                                       tfloat) tfloat))
                              (Ssequence
                                (Sdo (Eassign (Evar _m22 tfloat)
                                       (Ebinop Oadd
                                         (Evalof (Evar _qi2_M1_2 tfloat)
                                           tfloat)
                                         (Ebinop Omul
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                                     (tptr (Tstruct _FloatQuat noattr)))
                                                   (Tstruct _FloatQuat noattr))
                                                 (Tstruct _FloatQuat noattr))
                                               _qz tfloat) tfloat)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                                     (tptr (Tstruct _FloatQuat noattr)))
                                                   (Tstruct _FloatQuat noattr))
                                                 (Tstruct _FloatQuat noattr))
                                               _qz tfloat) tfloat) tfloat)
                                         tfloat) tfloat))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _v_out (tptr (Tstruct _FloatVect3 noattr)))
                                                 (tptr (Tstruct _FloatVect3 noattr)))
                                               (Tstruct _FloatVect3 noattr))
                                             (Tstruct _FloatVect3 noattr)) _x
                                           tfloat)
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Ebinop Oadd
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Evalof (Evar _m00 tfloat)
                                                   tfloat)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                           (tptr (Tstruct _FloatVect3 noattr)))
                                                         (Tstruct _FloatVect3 noattr))
                                                       (Tstruct _FloatVect3 noattr))
                                                     _x tfloat) tfloat)
                                                 tfloat)
                                               (Ebinop Omul
                                                 (Evalof (Evar _m01 tfloat)
                                                   tfloat)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                           (tptr (Tstruct _FloatVect3 noattr)))
                                                         (Tstruct _FloatVect3 noattr))
                                                       (Tstruct _FloatVect3 noattr))
                                                     _y tfloat) tfloat)
                                                 tfloat) tfloat)
                                             (Ebinop Omul
                                               (Evalof (Evar _m02 tfloat)
                                                 tfloat)
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                         (tptr (Tstruct _FloatVect3 noattr)))
                                                       (Tstruct _FloatVect3 noattr))
                                                     (Tstruct _FloatVect3 noattr))
                                                   _z tfloat) tfloat) tfloat)
                                             tfloat) tfloat) tfloat))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _v_out (tptr (Tstruct _FloatVect3 noattr)))
                                                   (tptr (Tstruct _FloatVect3 noattr)))
                                                 (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _y tfloat)
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Ebinop Oadd
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof (Evar _m10 tfloat)
                                                     tfloat)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                             (tptr (Tstruct _FloatVect3 noattr)))
                                                           (Tstruct _FloatVect3 noattr))
                                                         (Tstruct _FloatVect3 noattr))
                                                       _x tfloat) tfloat)
                                                   tfloat)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _m11 tfloat)
                                                     tfloat)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                             (tptr (Tstruct _FloatVect3 noattr)))
                                                           (Tstruct _FloatVect3 noattr))
                                                         (Tstruct _FloatVect3 noattr))
                                                       _y tfloat) tfloat)
                                                   tfloat) tfloat)
                                               (Ebinop Omul
                                                 (Evalof (Evar _m12 tfloat)
                                                   tfloat)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                           (tptr (Tstruct _FloatVect3 noattr)))
                                                         (Tstruct _FloatVect3 noattr))
                                                       (Tstruct _FloatVect3 noattr))
                                                     _z tfloat) tfloat)
                                                 tfloat) tfloat) tfloat)
                                           tfloat))
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _v_out (tptr (Tstruct _FloatVect3 noattr)))
                                                   (tptr (Tstruct _FloatVect3 noattr)))
                                                 (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _z tfloat)
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Ebinop Oadd
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof (Evar _m20 tfloat)
                                                     tfloat)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                             (tptr (Tstruct _FloatVect3 noattr)))
                                                           (Tstruct _FloatVect3 noattr))
                                                         (Tstruct _FloatVect3 noattr))
                                                       _x tfloat) tfloat)
                                                   tfloat)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _m21 tfloat)
                                                     tfloat)
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                             (tptr (Tstruct _FloatVect3 noattr)))
                                                           (Tstruct _FloatVect3 noattr))
                                                         (Tstruct _FloatVect3 noattr))
                                                       _y tfloat) tfloat)
                                                   tfloat) tfloat)
                                               (Ebinop Omul
                                                 (Evalof (Evar _m22 tfloat)
                                                   tfloat)
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Ederef
                                                         (Evalof
                                                           (Evar _v_in (tptr (Tstruct _FloatVect3 noattr)))
                                                           (tptr (Tstruct _FloatVect3 noattr)))
                                                         (Tstruct _FloatVect3 noattr))
                                                       (Tstruct _FloatVect3 noattr))
                                                     _z tfloat) tfloat)
                                                 tfloat) tfloat) tfloat)
                                           tfloat))))))))))))))))))))
|}.

Definition f_float_mat_inv_2d := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_inv_out, (tptr tfloat)) :: (_mat_in, (tptr tfloat)) :: nil);
  fn_vars := ((_det, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _det tfloat)
         (Ebinop Osub
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat_in (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat_in (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat_in (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat_in (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sifthenelse (Ebinop Olt
                   (Ecall
                     (Evalof
                       (Evar _fabsf (Tfunction (tfloat :: nil) tfloat
                                      cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _det tfloat) tfloat) Enil) tfloat)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4547007122018943789))) tdouble)
                   tint)
      (Sreturn (Some (Eval (Vint (Int.repr 1)) tint)))
      Sskip)
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof (Evar _inv_out (tptr tfloat)) (tptr tfloat))
                 (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
             (Ebinop Odiv
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _mat_in (tptr tfloat)) (tptr tfloat))
                     (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
                 tfloat) (Evalof (Evar _det tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _inv_out (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
               (Ebinop Odiv
                 (Eunop Oneg
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _mat_in (tptr tfloat)) (tptr tfloat))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                       tfloat) tfloat) tfloat)
                 (Evalof (Evar _det tfloat) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _inv_out (tptr tfloat)) (tptr tfloat))
                     (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
                 (Ebinop Odiv
                   (Eunop Oneg
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat_in (tptr tfloat))
                             (tptr tfloat)) (Eval (Vint (Int.repr 2)) tint)
                           (tptr tfloat)) tfloat) tfloat) tfloat)
                   (Evalof (Evar _det tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _inv_out (tptr tfloat)) (tptr tfloat))
                       (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
                   (Ebinop Odiv
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat_in (tptr tfloat))
                             (tptr tfloat)) (Eval (Vint (Int.repr 0)) tint)
                           (tptr tfloat)) tfloat) tfloat)
                     (Evalof (Evar _det tfloat) tfloat) tfloat) tfloat))
            (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))))))))
|}.

Definition f_float_mat_inv_3d := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_inv_out, (tptr (tarray tfloat 3))) ::
                (_mat_in, (tptr (tarray tfloat 3))) :: nil);
  fn_vars := ((_m00, tfloat) :: (_m10, tfloat) :: (_m20, tfloat) ::
              (_m01, tfloat) :: (_m11, tfloat) :: (_m21, tfloat) ::
              (_m02, tfloat) :: (_m12, tfloat) :: (_m22, tfloat) ::
              (_det, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _m00 tfloat)
         (Ebinop Osub
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                           (tptr (tarray tfloat 3)))
                         (Eval (Vint (Int.repr 1)) tint)
                         (tptr (tarray tfloat 3))) (tarray tfloat 3))
                     (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                           (tptr (tarray tfloat 3)))
                         (Eval (Vint (Int.repr 2)) tint)
                         (tptr (tarray tfloat 3))) (tarray tfloat 3))
                     (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                           (tptr (tarray tfloat 3)))
                         (Eval (Vint (Int.repr 1)) tint)
                         (tptr (tarray tfloat 3))) (tarray tfloat 3))
                     (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                           (tptr (tarray tfloat 3)))
                         (Eval (Vint (Int.repr 2)) tint)
                         (tptr (tarray tfloat 3))) (tarray tfloat 3))
                     (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                   (tptr tfloat)) tfloat) tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _m10 tfloat)
           (Ebinop Osub
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 0)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 2)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 0)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 2)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _m20 tfloat)
             (Ebinop Osub
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 0)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 1)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                       (tptr tfloat)) tfloat) tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 0)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat_in (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 1)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tfloat)) tfloat) tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _m01 tfloat)
               (Ebinop Osub
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _mat_in (tptr (tarray tfloat 3)))
                                 (tptr (tarray tfloat 3)))
                               (Eval (Vint (Int.repr 1)) tint)
                               (tptr (tarray tfloat 3))) (tarray tfloat 3))
                           (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _mat_in (tptr (tarray tfloat 3)))
                                 (tptr (tarray tfloat 3)))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr (tarray tfloat 3))) (tarray tfloat 3))
                           (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _mat_in (tptr (tarray tfloat 3)))
                                 (tptr (tarray tfloat 3)))
                               (Eval (Vint (Int.repr 1)) tint)
                               (tptr (tarray tfloat 3))) (tarray tfloat 3))
                           (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _mat_in (tptr (tarray tfloat 3)))
                                 (tptr (tarray tfloat 3)))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr (tarray tfloat 3))) (tarray tfloat 3))
                           (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat) tfloat)
               tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _m11 tfloat)
                 (Ebinop Osub
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _mat_in (tptr (tarray tfloat 3)))
                                   (tptr (tarray tfloat 3)))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr (tarray tfloat 3))) (tarray tfloat 3))
                             (tarray tfloat 3))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _mat_in (tptr (tarray tfloat 3)))
                                   (tptr (tarray tfloat 3)))
                                 (Eval (Vint (Int.repr 2)) tint)
                                 (tptr (tarray tfloat 3))) (tarray tfloat 3))
                             (tarray tfloat 3))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _mat_in (tptr (tarray tfloat 3)))
                                   (tptr (tarray tfloat 3)))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr (tarray tfloat 3))) (tarray tfloat 3))
                             (tarray tfloat 3))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _mat_in (tptr (tarray tfloat 3)))
                                   (tptr (tarray tfloat 3)))
                                 (Eval (Vint (Int.repr 2)) tint)
                                 (tptr (tarray tfloat 3))) (tarray tfloat 3))
                             (tarray tfloat 3))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _m21 tfloat)
                   (Ebinop Osub
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _mat_in (tptr (tarray tfloat 3)))
                                     (tptr (tarray tfloat 3)))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr (tarray tfloat 3)))
                                 (tarray tfloat 3)) (tarray tfloat 3))
                             (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _mat_in (tptr (tarray tfloat 3)))
                                     (tptr (tarray tfloat 3)))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr (tarray tfloat 3)))
                                 (tarray tfloat 3)) (tarray tfloat 3))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _mat_in (tptr (tarray tfloat 3)))
                                     (tptr (tarray tfloat 3)))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr (tarray tfloat 3)))
                                 (tarray tfloat 3)) (tarray tfloat 3))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _mat_in (tptr (tarray tfloat 3)))
                                     (tptr (tarray tfloat 3)))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr (tarray tfloat 3)))
                                 (tarray tfloat 3)) (tarray tfloat 3))
                             (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _m02 tfloat)
                     (Ebinop Osub
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _mat_in (tptr (tarray tfloat 3)))
                                       (tptr (tarray tfloat 3)))
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (tptr (tarray tfloat 3)))
                                   (tarray tfloat 3)) (tarray tfloat 3))
                               (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _mat_in (tptr (tarray tfloat 3)))
                                       (tptr (tarray tfloat 3)))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr (tarray tfloat 3)))
                                   (tarray tfloat 3)) (tarray tfloat 3))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _mat_in (tptr (tarray tfloat 3)))
                                       (tptr (tarray tfloat 3)))
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (tptr (tarray tfloat 3)))
                                   (tarray tfloat 3)) (tarray tfloat 3))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _mat_in (tptr (tarray tfloat 3)))
                                       (tptr (tarray tfloat 3)))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr (tarray tfloat 3)))
                                   (tarray tfloat 3)) (tarray tfloat 3))
                               (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _m12 tfloat)
                       (Ebinop Osub
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _mat_in (tptr (tarray tfloat 3)))
                                         (tptr (tarray tfloat 3)))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr (tarray tfloat 3)))
                                     (tarray tfloat 3)) (tarray tfloat 3))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _mat_in (tptr (tarray tfloat 3)))
                                         (tptr (tarray tfloat 3)))
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (tptr (tarray tfloat 3)))
                                     (tarray tfloat 3)) (tarray tfloat 3))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _mat_in (tptr (tarray tfloat 3)))
                                         (tptr (tarray tfloat 3)))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr (tarray tfloat 3)))
                                     (tarray tfloat 3)) (tarray tfloat 3))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _mat_in (tptr (tarray tfloat 3)))
                                         (tptr (tarray tfloat 3)))
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (tptr (tarray tfloat 3)))
                                     (tarray tfloat 3)) (tarray tfloat 3))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _m22 tfloat)
                         (Ebinop Osub
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _mat_in (tptr (tarray tfloat 3)))
                                           (tptr (tarray tfloat 3)))
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (tptr (tarray tfloat 3)))
                                       (tarray tfloat 3)) (tarray tfloat 3))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _mat_in (tptr (tarray tfloat 3)))
                                           (tptr (tarray tfloat 3)))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr (tarray tfloat 3)))
                                       (tarray tfloat 3)) (tarray tfloat 3))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _mat_in (tptr (tarray tfloat 3)))
                                           (tptr (tarray tfloat 3)))
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (tptr (tarray tfloat 3)))
                                       (tarray tfloat 3)) (tarray tfloat 3))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _mat_in (tptr (tarray tfloat 3)))
                                           (tptr (tarray tfloat 3)))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr (tarray tfloat 3)))
                                       (tarray tfloat 3)) (tarray tfloat 3))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _det tfloat)
                           (Ebinop Oadd
                             (Ebinop Osub
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _mat_in (tptr (tarray tfloat 3)))
                                               (tptr (tarray tfloat 3)))
                                             (Eval (Vint (Int.repr 0)) tint)
                                             (tptr (tarray tfloat 3)))
                                           (tarray tfloat 3))
                                         (tarray tfloat 3))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tfloat)) tfloat) tfloat)
                                 (Evalof (Evar _m00 tfloat) tfloat) tfloat)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _mat_in (tptr (tarray tfloat 3)))
                                               (tptr (tarray tfloat 3)))
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (tptr (tarray tfloat 3)))
                                           (tarray tfloat 3))
                                         (tarray tfloat 3))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tfloat)) tfloat) tfloat)
                                 (Evalof (Evar _m10 tfloat) tfloat) tfloat)
                               tfloat)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _mat_in (tptr (tarray tfloat 3)))
                                             (tptr (tarray tfloat 3)))
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (tptr (tarray tfloat 3)))
                                         (tarray tfloat 3))
                                       (tarray tfloat 3))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
                               (Evalof (Evar _m20 tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sifthenelse (Ebinop Ogt
                                     (Ecall
                                       (Evalof
                                         (Evar _fabs (Tfunction
                                                       (tdouble :: nil)
                                                       tdouble cc_default))
                                         (Tfunction (tdouble :: nil) tdouble
                                           cc_default))
                                       (Econs
                                         (Evalof (Evar _det tfloat) tfloat)
                                         Enil) tdouble)
                                     (Eval (Vsingle (Float32.of_bits (Int.repr 872415232))) tfloat)
                                     tint)
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _inv_out (tptr (tarray tfloat 3)))
                                             (tptr (tarray tfloat 3)))
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (tptr (tarray tfloat 3)))
                                         (tarray tfloat 3))
                                       (tarray tfloat 3))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Odiv
                                   (Evalof (Evar _m00 tfloat) tfloat)
                                   (Evalof (Evar _det tfloat) tfloat) tfloat)
                                 tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _inv_out (tptr (tarray tfloat 3)))
                                               (tptr (tarray tfloat 3)))
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (tptr (tarray tfloat 3)))
                                           (tarray tfloat 3))
                                         (tarray tfloat 3))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Ebinop Odiv
                                     (Eunop Oneg
                                       (Evalof (Evar _m01 tfloat) tfloat)
                                       tfloat)
                                     (Evalof (Evar _det tfloat) tfloat)
                                     tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _inv_out (tptr (tarray tfloat 3)))
                                                 (tptr (tarray tfloat 3)))
                                               (Eval (Vint (Int.repr 2)) tint)
                                               (tptr (tarray tfloat 3)))
                                             (tarray tfloat 3))
                                           (tarray tfloat 3))
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Ebinop Odiv
                                       (Evalof (Evar _m02 tfloat) tfloat)
                                       (Evalof (Evar _det tfloat) tfloat)
                                       tfloat) tfloat))
                              (Ssequence
                                (Sdo (Eassign
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _inv_out (tptr (tarray tfloat 3)))
                                                   (tptr (tarray tfloat 3)))
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 (tptr (tarray tfloat 3)))
                                               (tarray tfloat 3))
                                             (tarray tfloat 3))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tfloat)) tfloat)
                                       (Ebinop Odiv
                                         (Eunop Oneg
                                           (Evalof (Evar _m10 tfloat) tfloat)
                                           tfloat)
                                         (Evalof (Evar _det tfloat) tfloat)
                                         tfloat) tfloat))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _inv_out (tptr (tarray tfloat 3)))
                                                     (tptr (tarray tfloat 3)))
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (tptr (tarray tfloat 3)))
                                                 (tarray tfloat 3))
                                               (tarray tfloat 3))
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (tptr tfloat)) tfloat)
                                         (Ebinop Odiv
                                           (Evalof (Evar _m11 tfloat) tfloat)
                                           (Evalof (Evar _det tfloat) tfloat)
                                           tfloat) tfloat))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Ederef
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _inv_out (tptr (tarray tfloat 3)))
                                                       (tptr (tarray tfloat 3)))
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     (tptr (tarray tfloat 3)))
                                                   (tarray tfloat 3))
                                                 (tarray tfloat 3))
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (tptr tfloat)) tfloat)
                                           (Ebinop Odiv
                                             (Eunop Oneg
                                               (Evalof (Evar _m12 tfloat)
                                                 tfloat) tfloat)
                                             (Evalof (Evar _det tfloat)
                                               tfloat) tfloat) tfloat))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Ederef
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Evar _inv_out (tptr (tarray tfloat 3)))
                                                         (tptr (tarray tfloat 3)))
                                                       (Eval (Vint (Int.repr 0)) tint)
                                                       (tptr (tarray tfloat 3)))
                                                     (tarray tfloat 3))
                                                   (tarray tfloat 3))
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 (tptr tfloat)) tfloat)
                                             (Ebinop Odiv
                                               (Evalof (Evar _m20 tfloat)
                                                 tfloat)
                                               (Evalof (Evar _det tfloat)
                                                 tfloat) tfloat) tfloat))
                                      (Ssequence
                                        (Sdo (Eassign
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _inv_out (tptr (tarray tfloat 3)))
                                                           (tptr (tarray tfloat 3)))
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         (tptr (tarray tfloat 3)))
                                                       (tarray tfloat 3))
                                                     (tarray tfloat 3))
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (tptr tfloat)) tfloat)
                                               (Ebinop Odiv
                                                 (Eunop Oneg
                                                   (Evalof (Evar _m21 tfloat)
                                                     tfloat) tfloat)
                                                 (Evalof (Evar _det tfloat)
                                                   tfloat) tfloat) tfloat))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Ederef
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _inv_out (tptr (tarray tfloat 3)))
                                                             (tptr (tarray tfloat 3)))
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (tptr (tarray tfloat 3)))
                                                         (tarray tfloat 3))
                                                       (tarray tfloat 3))
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     (tptr tfloat)) tfloat)
                                                 (Ebinop Odiv
                                                   (Evalof (Evar _m22 tfloat)
                                                     tfloat)
                                                   (Evalof (Evar _det tfloat)
                                                     tfloat) tfloat) tfloat))
                                          (Sreturn (Some (Eval (Vint (Int.repr 0)) tint))))))))))))
                        Sskip)
                      (Sreturn (Some (Eval (Vint (Int.repr 1)) tint))))))))))))))
|}.

Definition composites : list composite_definition :=
(Composite _FloatVect3 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _FloatQuat Struct
   (Member_plain _qi tfloat :: Member_plain _qx tfloat ::
    Member_plain _qy tfloat :: Member_plain _qz tfloat :: nil)
   noattr ::
 Composite _FloatRMat Struct
   (Member_plain _m (tarray tfloat 9) :: nil)
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
 (_fabs,
   Gfun(External (EF_external "fabs"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_sqrtf,
   Gfun(External (EF_external "sqrtf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_fabsf,
   Gfun(External (EF_external "fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_float_vect3_integrate_fi, Gfun(Internal f_float_vect3_integrate_fi)) ::
 (_float_rmat_comp, Gfun(Internal f_float_rmat_comp)) ::
 (_float_rmat_vmult, Gfun(Internal f_float_rmat_vmult)) ::
 (_renorm_factor, Gfun(Internal f_renorm_factor)) ::
 (_float_rmat_reorthogonalize, Gfun(Internal f_float_rmat_reorthogonalize)) ::
 (_float_quat_comp, Gfun(Internal f_float_quat_comp)) ::
 (_float_quat_vmult, Gfun(Internal f_float_quat_vmult)) ::
 (_float_mat_inv_2d, Gfun(Internal f_float_mat_inv_2d)) ::
 (_float_mat_inv_3d, Gfun(Internal f_float_mat_inv_3d)) :: nil).

Definition public_idents : list ident :=
(_float_mat_inv_3d :: _float_mat_inv_2d :: _float_quat_vmult ::
 _float_quat_comp :: _float_rmat_reorthogonalize :: _float_rmat_vmult ::
 _float_rmat_comp :: _float_vect3_integrate_fi :: _fabsf :: _sqrtf ::
 _fabs :: ___builtin_debug :: ___builtin_write32_reversed ::
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


