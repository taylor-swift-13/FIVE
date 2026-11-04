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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/float_vectors_matrices/model/preprocessed.i".
End Info.

Definition _FloatEulers : ident := $"FloatEulers".
Definition _FloatQuat : ident := $"FloatQuat".
Definition _FloatRMat : ident := $"FloatRMat".
Definition _FloatVect2 : ident := $"FloatVect2".
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
Definition _a : ident := $"a".
Definition _b : ident := $"b".
Definition _c : ident := $"c".
Definition _d : ident := $"d".
Definition _dot : ident := $"dot".
Definition _e : ident := $"e".
Definition _fabs : ident := $"fabs".
Definition _fabsf : ident := $"fabsf".
Definition _five_keep_float_eulers_norm : ident := $"five_keep_float_eulers_norm".
Definition _five_keep_float_log_n : ident := $"five_keep_float_log_n".
Definition _five_keep_float_mat_col : ident := $"five_keep_float_mat_col".
Definition _five_keep_float_mat_copy : ident := $"five_keep_float_mat_copy".
Definition _five_keep_float_mat_diagonal_scal : ident := $"five_keep_float_mat_diagonal_scal".
Definition _five_keep_float_mat_diff : ident := $"five_keep_float_mat_diff".
Definition _five_keep_float_mat_div_scalar : ident := $"five_keep_float_mat_div_scalar".
Definition _five_keep_float_mat_minor : ident := $"five_keep_float_mat_minor".
Definition _five_keep_float_mat_mul : ident := $"five_keep_float_mat_mul".
Definition _five_keep_float_mat_mul_scalar : ident := $"five_keep_float_mat_mul_scalar".
Definition _five_keep_float_mat_mul_transpose : ident := $"five_keep_float_mat_mul_transpose".
Definition _five_keep_float_mat_scale : ident := $"five_keep_float_mat_scale".
Definition _five_keep_float_mat_sum : ident := $"five_keep_float_mat_sum".
Definition _five_keep_float_mat_sum_scaled : ident := $"five_keep_float_mat_sum_scaled".
Definition _five_keep_float_mat_transpose : ident := $"five_keep_float_mat_transpose".
Definition _five_keep_float_mat_transpose_square : ident := $"five_keep_float_mat_transpose_square".
Definition _five_keep_float_mat_vect_mul : ident := $"five_keep_float_mat_vect_mul".
Definition _five_keep_float_mat_vmul : ident := $"five_keep_float_mat_vmul".
Definition _five_keep_float_mat_zero : ident := $"five_keep_float_mat_zero".
Definition _five_keep_float_quat_identity : ident := $"five_keep_float_quat_identity".
Definition _five_keep_float_quat_invert : ident := $"five_keep_float_quat_invert".
Definition _five_keep_float_quat_norm : ident := $"five_keep_float_quat_norm".
Definition _five_keep_float_quat_normalize : ident := $"five_keep_float_quat_normalize".
Definition _five_keep_float_quat_wrap_shortest : ident := $"five_keep_float_quat_wrap_shortest".
Definition _five_keep_float_rmat_identity : ident := $"five_keep_float_rmat_identity".
Definition _five_keep_float_vect2_norm : ident := $"five_keep_float_vect2_norm".
Definition _five_keep_float_vect2_norm2 : ident := $"five_keep_float_vect2_norm2".
Definition _five_keep_float_vect2_normalize : ident := $"five_keep_float_vect2_normalize".
Definition _five_keep_float_vect3_norm : ident := $"five_keep_float_vect3_norm".
Definition _five_keep_float_vect3_norm2 : ident := $"five_keep_float_vect3_norm2".
Definition _five_keep_float_vect3_normalize : ident := $"five_keep_float_vect3_normalize".
Definition _five_keep_float_vect_add : ident := $"five_keep_float_vect_add".
Definition _five_keep_float_vect_copy : ident := $"five_keep_float_vect_copy".
Definition _five_keep_float_vect_diff : ident := $"five_keep_float_vect_diff".
Definition _five_keep_float_vect_dot_product : ident := $"five_keep_float_vect_dot_product".
Definition _five_keep_float_vect_mul : ident := $"five_keep_float_vect_mul".
Definition _five_keep_float_vect_norm : ident := $"five_keep_float_vect_norm".
Definition _five_keep_float_vect_scale : ident := $"five_keep_float_vect_scale".
Definition _five_keep_float_vect_sdiv : ident := $"five_keep_float_vect_sdiv".
Definition _five_keep_float_vect_smul : ident := $"five_keep_float_vect_smul".
Definition _five_keep_float_vect_sub : ident := $"five_keep_float_vect_sub".
Definition _five_keep_float_vect_sum : ident := $"five_keep_float_vect_sum".
Definition _five_keep_float_vect_zero : ident := $"five_keep_float_vect_zero".
Definition _float_eulers_norm : ident := $"float_eulers_norm".
Definition _float_log_n : ident := $"float_log_n".
Definition _float_mat_col : ident := $"float_mat_col".
Definition _float_mat_copy : ident := $"float_mat_copy".
Definition _float_mat_diagonal_scal : ident := $"float_mat_diagonal_scal".
Definition _float_mat_diff : ident := $"float_mat_diff".
Definition _float_mat_div_scalar : ident := $"float_mat_div_scalar".
Definition _float_mat_minor : ident := $"float_mat_minor".
Definition _float_mat_mul : ident := $"float_mat_mul".
Definition _float_mat_mul_scalar : ident := $"float_mat_mul_scalar".
Definition _float_mat_mul_transpose : ident := $"float_mat_mul_transpose".
Definition _float_mat_scale : ident := $"float_mat_scale".
Definition _float_mat_sum : ident := $"float_mat_sum".
Definition _float_mat_sum_scaled : ident := $"float_mat_sum_scaled".
Definition _float_mat_transpose : ident := $"float_mat_transpose".
Definition _float_mat_transpose_square : ident := $"float_mat_transpose_square".
Definition _float_mat_vect_mul : ident := $"float_mat_vect_mul".
Definition _float_mat_vmul : ident := $"float_mat_vmul".
Definition _float_mat_zero : ident := $"float_mat_zero".
Definition _float_quat_identity : ident := $"float_quat_identity".
Definition _float_quat_invert : ident := $"float_quat_invert".
Definition _float_quat_norm : ident := $"float_quat_norm".
Definition _float_quat_normalize : ident := $"float_quat_normalize".
Definition _float_quat_wrap_shortest : ident := $"float_quat_wrap_shortest".
Definition _float_rmat_identity : ident := $"float_rmat_identity".
Definition _float_vect2_norm : ident := $"float_vect2_norm".
Definition _float_vect2_norm2 : ident := $"float_vect2_norm2".
Definition _float_vect2_normalize : ident := $"float_vect2_normalize".
Definition _float_vect3_norm : ident := $"float_vect3_norm".
Definition _float_vect3_norm2 : ident := $"float_vect3_norm2".
Definition _float_vect3_normalize : ident := $"float_vect3_normalize".
Definition _float_vect_add : ident := $"float_vect_add".
Definition _float_vect_copy : ident := $"float_vect_copy".
Definition _float_vect_diff : ident := $"float_vect_diff".
Definition _float_vect_dot_product : ident := $"float_vect_dot_product".
Definition _float_vect_mul : ident := $"float_vect_mul".
Definition _float_vect_norm : ident := $"float_vect_norm".
Definition _float_vect_scale : ident := $"float_vect_scale".
Definition _float_vect_sdiv : ident := $"float_vect_sdiv".
Definition _float_vect_smul : ident := $"float_vect_smul".
Definition _float_vect_sub : ident := $"float_vect_sub".
Definition _float_vect_sum : ident := $"float_vect_sum".
Definition _float_vect_zero : ident := $"float_vect_zero".
Definition _i : ident := $"i".
Definition _j : ident := $"j".
Definition _k : ident := $"k".
Definition _l : ident := $"l".
Definition _logf : ident := $"logf".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _n : ident := $"n".
Definition _o : ident := $"o".
Definition _phi : ident := $"phi".
Definition _psi : ident := $"psi".
Definition _q : ident := $"q".
Definition _qi : ident := $"qi".
Definition _qnorm : ident := $"qnorm".
Definition _qo : ident := $"qo".
Definition _qx : ident := $"qx".
Definition _qy : ident := $"qy".
Definition _qz : ident := $"qz".
Definition _rm : ident := $"rm".
Definition _s : ident := $"s".
Definition _scalar : ident := $"scalar".
Definition _sqrtf : ident := $"sqrtf".
Definition _sum : ident := $"sum".
Definition _t : ident := $"t".
Definition _theta : ident := $"theta".
Definition _v : ident := $"v".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".

Definition f_float_log_n := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_v, tfloat) :: (_n, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Olt
                 (Ecall
                   (Evalof
                     (Evar _fabsf (Tfunction (tfloat :: nil) tfloat
                                    cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs (Evalof (Evar _v tfloat) tfloat) Enil) tfloat)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4547007122018943789))) tdouble)
                 tint)
    (Sreturn (Some (Eunop Oneg
                     (Eval (Vfloat (Float.of_bits (Int64.repr 5055640609639927018))) tdouble)
                     tdouble)))
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Olt
                   (Ecall
                     (Evalof
                       (Evar _fabsf (Tfunction (tfloat :: nil) tfloat
                                      cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _n tfloat) tfloat) Enil) tfloat)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4547007122018943789))) tdouble)
                   tint)
      (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))
      Sskip)
    (Sreturn (Some (Ebinop Odiv
                     (Ecall
                       (Evalof
                         (Evar _logf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs
                         (Ecall
                           (Evalof
                             (Evar _fabsf (Tfunction (tfloat :: nil) tfloat
                                            cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _v tfloat) tfloat) Enil)
                           tfloat) Enil) tfloat)
                     (Ecall
                       (Evalof
                         (Evar _logf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _n tfloat) tfloat) Enil) tfloat)
                     tfloat)))))
|}.

Definition f_float_vect2_norm2 := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_v, (tptr (Tstruct _FloatVect2 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                             (tptr (Tstruct _FloatVect2 noattr)))
                           (Tstruct _FloatVect2 noattr))
                         (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                             (tptr (Tstruct _FloatVect2 noattr)))
                           (Tstruct _FloatVect2 noattr))
                         (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
                   tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                             (tptr (Tstruct _FloatVect2 noattr)))
                           (Tstruct _FloatVect2 noattr))
                         (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                             (tptr (Tstruct _FloatVect2 noattr)))
                           (Tstruct _FloatVect2 noattr))
                         (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                   tfloat) tfloat)))
|}.

Definition f_float_vect2_norm := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_v, (tptr (Tstruct _FloatVect2 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ecall
                     (Evalof
                       (Evar _float_vect2_norm2 (Tfunction
                                                  ((tptr (Tstruct _FloatVect2 noattr)) ::
                                                   nil) tfloat cc_default))
                       (Tfunction
                         ((tptr (Tstruct _FloatVect2 noattr)) :: nil) tfloat
                         cc_default))
                     (Econs
                       (Evalof (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                         (tptr (Tstruct _FloatVect2 noattr))) Enil) tfloat)
                   Enil) tfloat)))
|}.

Definition f_float_vect2_normalize := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_v, (tptr (Tstruct _FloatVect2 noattr))) :: nil);
  fn_vars := ((_n, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _n tfloat)
         (Ecall
           (Evalof
             (Evar _float_vect2_norm (Tfunction
                                       ((tptr (Tstruct _FloatVect2 noattr)) ::
                                        nil) tfloat cc_default))
             (Tfunction ((tptr (Tstruct _FloatVect2 noattr)) :: nil) tfloat
               cc_default))
           (Econs
             (Evalof (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
               (tptr (Tstruct _FloatVect2 noattr))) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _n tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 953267991))) tfloat)
                 tint)
    (Ssequence
      (Sdo (Eassignop Odiv
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                     (tptr (Tstruct _FloatVect2 noattr)))
                   (Tstruct _FloatVect2 noattr))
                 (Tstruct _FloatVect2 noattr)) _x tfloat)
             (Evalof (Evar _n tfloat) tfloat) tfloat tfloat))
      (Sdo (Eassignop Odiv
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _v (tptr (Tstruct _FloatVect2 noattr)))
                     (tptr (Tstruct _FloatVect2 noattr)))
                   (Tstruct _FloatVect2 noattr))
                 (Tstruct _FloatVect2 noattr)) _y tfloat)
             (Evalof (Evar _n tfloat) tfloat) tfloat tfloat)))
    Sskip))
|}.

Definition f_float_vect3_norm2 := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_v, (tptr (Tstruct _FloatVect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                     tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                     tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                   tfloat) tfloat)))
|}.

Definition f_float_vect3_norm := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_v, (tptr (Tstruct _FloatVect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ecall
                     (Evalof
                       (Evar _float_vect3_norm2 (Tfunction
                                                  ((tptr (Tstruct _FloatVect3 noattr)) ::
                                                   nil) tfloat cc_default))
                       (Tfunction
                         ((tptr (Tstruct _FloatVect3 noattr)) :: nil) tfloat
                         cc_default))
                     (Econs
                       (Evalof (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr))) Enil) tfloat)
                   Enil) tfloat)))
|}.

Definition f_float_vect3_normalize := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_v, (tptr (Tstruct _FloatVect3 noattr))) :: nil);
  fn_vars := ((_n, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _n tfloat)
         (Ecall
           (Evalof
             (Evar _float_vect3_norm (Tfunction
                                       ((tptr (Tstruct _FloatVect3 noattr)) ::
                                        nil) tfloat cc_default))
             (Tfunction ((tptr (Tstruct _FloatVect3 noattr)) :: nil) tfloat
               cc_default))
           (Econs
             (Evalof (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
               (tptr (Tstruct _FloatVect3 noattr))) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _n tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 953267991))) tfloat)
                 tint)
    (Ssequence
      (Sdo (Eassignop Odiv
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                     (tptr (Tstruct _FloatVect3 noattr)))
                   (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _x tfloat)
             (Evalof (Evar _n tfloat) tfloat) tfloat tfloat))
      (Ssequence
        (Sdo (Eassignop Odiv
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat)
               (Evalof (Evar _n tfloat) tfloat) tfloat tfloat))
        (Sdo (Eassignop Odiv
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _v (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _z tfloat)
               (Evalof (Evar _n tfloat) tfloat) tfloat tfloat))))
    Sskip))
|}.

Definition f_float_rmat_identity := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) :: nil);
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
                     (Evalof (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                       (tptr (Tstruct _FloatRMat noattr)))
                     (Tstruct _FloatRMat noattr))
                   (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
               (tarray tfloat 9))
             (Ebinop Oadd
               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                 (Eval (Vint (Int.repr 3)) tint) tint)
               (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat)) tfloat)
         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
         tfloat))
  (Ssequence
    (Sdo (Eassign
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
                 (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat)) tfloat)
           (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))
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
                       (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                   (tarray tfloat 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
               tfloat) (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
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
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                 tfloat)
               (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))
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
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                   tfloat)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
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
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
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
                               (Ederef
                                 (Evalof
                                   (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tfloat)) tfloat)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
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
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tfloat)) tfloat)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
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
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tfloat)) tfloat)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                       tfloat))))))))))
|}.

Definition f_float_quat_identity := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr)))
               (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr)) _qi
           tfloat)
         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
         tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qx tfloat) (Eval (Vint (Int.repr 0)) tint) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qy tfloat) (Eval (Vint (Int.repr 0)) tint) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qz tfloat) (Eval (Vint (Int.repr 0)) tint) tfloat)))))
|}.

Definition f_float_quat_norm := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ebinop Oadd
                     (Ebinop Oadd
                       (Ebinop Oadd
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qi tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qi tfloat)
                             tfloat) tfloat)
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
                             tfloat) tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qy tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qy tfloat)
                           tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                       tfloat) tfloat) Enil) tfloat)))
|}.

Definition f_float_quat_normalize := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := ((_qnorm, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qnorm tfloat)
         (Ecall
           (Evalof
             (Evar _float_quat_norm (Tfunction
                                      ((tptr (Tstruct _FloatQuat noattr)) ::
                                       nil) tfloat cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tfloat
               cc_default))
           (Econs
             (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _qnorm tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 8388608))) tfloat)
                 tint)
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qi tfloat)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
               (Evalof (Evar _qnorm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat)
               (Ebinop Odiv
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                 (Evalof (Evar _qnorm tfloat) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat)
                 (Ebinop Odiv
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                   (Evalof (Evar _qnorm tfloat) tfloat) tfloat) tfloat))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat)
                 (Ebinop Odiv
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                   (Evalof (Evar _qnorm tfloat) tfloat) tfloat) tfloat)))))
    Sskip))
|}.

Definition f_float_quat_invert := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_qo, (tptr (Tstruct _FloatQuat noattr))) ::
                (_qi, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _qo (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr)))
               (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr)) _qi
           tfloat)
         (Evalof
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _qi (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qi tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _qo (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qx tfloat)
           (Eunop Oneg
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _qi (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qo (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qy tfloat)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _qi (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat)
             tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qo (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qz tfloat)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _qi (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)
             tfloat)))))
|}.

Definition f_float_quat_wrap_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sifthenelse (Ebinop Olt
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
               (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tint)
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qi tfloat)
           (Eunop Oneg
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat)
             (Eunop Oneg
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
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qy tfloat)
               (Eunop Oneg
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                 tfloat) tfloat))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qz tfloat)
               (Eunop Oneg
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 tfloat) tfloat)))))
  Sskip)
|}.

Definition f_float_eulers_norm := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ebinop Oadd
                     (Ebinop Oadd
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                   (tptr (Tstruct _FloatEulers noattr)))
                                 (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _phi tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                   (tptr (Tstruct _FloatEulers noattr)))
                                 (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _phi tfloat)
                           tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                   (tptr (Tstruct _FloatEulers noattr)))
                                 (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _theta tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                   (tptr (Tstruct _FloatEulers noattr)))
                                 (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _theta tfloat)
                           tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                 (tptr (Tstruct _FloatEulers noattr)))
                               (Tstruct _FloatEulers noattr))
                             (Tstruct _FloatEulers noattr)) _psi tfloat)
                         tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                 (tptr (Tstruct _FloatEulers noattr)))
                               (Tstruct _FloatEulers noattr))
                             (Tstruct _FloatEulers noattr)) _psi tfloat)
                         tfloat) tfloat) tfloat) Enil) tfloat)))
|}.

Definition f_float_vect_zero := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat)))
|}.

Definition f_float_vect_copy := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_b, (tptr tfloat)) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Evalof
           (Ederef
             (Ebinop Oadd (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
         tfloat)))
|}.

Definition f_float_vect_sum := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr tfloat)) ::
                (_b, (tptr tfloat)) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Ebinop Oadd
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           tfloat) tfloat)))
|}.

Definition f_float_vect_diff := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr tfloat)) ::
                (_b, (tptr tfloat)) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Ebinop Osub
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           tfloat) tfloat)))
|}.

Definition f_float_vect_mul := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr tfloat)) ::
                (_b, (tptr tfloat)) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Ebinop Omul
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           tfloat) tfloat)))
|}.

Definition f_float_vect_add := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_b, (tptr tfloat)) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassignop Oadd
         (Ederef
           (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Evalof
           (Ederef
             (Ebinop Oadd (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
         tfloat tfloat)))
|}.

Definition f_float_vect_sub := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_b, (tptr tfloat)) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassignop Osub
         (Ederef
           (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Evalof
           (Ederef
             (Ebinop Oadd (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
         tfloat tfloat)))
|}.

Definition f_float_vect_smul := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr tfloat)) :: (_s, tfloat) ::
                (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Ebinop Omul
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat) tfloat)
           (Evalof (Evar _s tfloat) tfloat) tfloat) tfloat)))
|}.

Definition f_float_vect_sdiv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr tfloat)) :: (_s, tfloat) ::
                (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sifthenelse (Ebinop Ogt
               (Ecall
                 (Evalof
                   (Evar _fabs (Tfunction (tdouble :: nil) tdouble
                                 cc_default))
                   (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Econs (Evalof (Evar _s tfloat) tfloat) Enil) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4532020583610935537))) tdouble)
               tint)
  (Sfor
    (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _i tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Odiv
             (Evalof
               (Ederef
                 (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
               tfloat) (Evalof (Evar _s tfloat) tfloat) tfloat) tfloat)))
  Sskip)
|}.

Definition f_float_vect_norm := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_sum, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sum tfloat) (Eval (Vint (Int.repr 0)) tint) tfloat))
  (Ssequence
    (Sfor
      (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint)
        tint)
      (Sdo (Epostincr Incr (Evar _i tint) tint))
      (Sdo (Eassignop Oadd (Evar _sum tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                 tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                 tfloat) tfloat) tfloat tfloat)))
    (Sreturn (Some (Ecall
                     (Evalof
                       (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat
                                      cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _sum tfloat) tfloat) Enil) tfloat)))))
|}.

Definition f_float_vect_scale := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_s, tfloat) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassignop Omul
         (Ederef
           (Ebinop Oadd (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Evalof (Evar _s tfloat) tfloat) tfloat tfloat)))
|}.

Definition f_float_vect_dot_product := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr tfloat)) :: (_b, (tptr tfloat)) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: (_dot, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _dot tfloat)
         (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat) tfloat))
  (Ssequence
    (Sfor
      (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint)
        tint)
      (Sdo (Epostincr Incr (Evar _i tint) tint))
      (Sdo (Eassignop Oadd (Evar _dot tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                 tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                 tfloat) tfloat) tfloat tfloat)))
    (Sreturn (Some (Evalof (Evar _dot tfloat) tfloat)))))
|}.

Definition f_float_mat_zero := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr (tptr tfloat))) :: (_m, tint) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))))
|}.

Definition f_float_mat_copy := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr (tptr tfloat))) :: (_b, (tptr (tptr tfloat))) ::
                (_m, tint) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _b (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat) tfloat)
           tfloat))))
|}.

Definition f_float_mat_sum := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_b, (tptr (tptr tfloat))) :: (_m, tint) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _o (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Oadd
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _b (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat) tfloat))))
|}.

Definition f_float_mat_diff := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_b, (tptr (tptr tfloat))) :: (_m, tint) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _o (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Osub
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _b (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat) tfloat))))
|}.

Definition f_float_mat_transpose_square := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr (tptr tfloat))) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: (_t, tfloat) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _i tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _t tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _a (tptr (tptr tfloat)))
                             (tptr (tptr tfloat)))
                           (Evalof (Evar _j tint) tint) (tptr (tptr tfloat)))
                         (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                 tfloat) tfloat))
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _j tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
               (Evalof (Evar _t tfloat) tfloat) tfloat))))))
|}.

Definition f_float_mat_transpose := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_n, tint) :: (_m, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _m tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _o (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _j tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _a (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat) tfloat)
           tfloat))))
|}.

Definition f_float_mat_mul := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_b, (tptr (tptr tfloat))) :: (_m, tint) :: (_n, tint) ::
                (_l, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: (_k, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _l tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _o (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
             (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))
      (Sfor
        (Sdo (Eassign (Evar _k tint) (Eval (Vint (Int.repr 0)) tint) tint))
        (Ebinop Olt (Evalof (Evar _k tint) tint) (Evalof (Evar _n tint) tint)
          tint)
        (Sdo (Epostincr Incr (Evar _k tint) tint))
        (Sdo (Eassignop Oadd
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _o (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _a (tptr (tptr tfloat)))
                               (tptr (tptr tfloat)))
                             (Evalof (Evar _i tint) tint)
                             (tptr (tptr tfloat))) (tptr tfloat))
                         (tptr tfloat)) (Evalof (Evar _k tint) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _b (tptr (tptr tfloat)))
                               (tptr (tptr tfloat)))
                             (Evalof (Evar _k tint) tint)
                             (tptr (tptr tfloat))) (tptr tfloat))
                         (tptr tfloat)) (Evalof (Evar _j tint) tint)
                       (tptr tfloat)) tfloat) tfloat) tfloat) tfloat tfloat))))))
|}.

Definition f_float_mat_mul_transpose := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_b, (tptr (tptr tfloat))) :: (_m, tint) :: (_n, tint) ::
                (_l, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: (_k, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _l tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _o (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
             (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))
      (Sfor
        (Sdo (Eassign (Evar _k tint) (Eval (Vint (Int.repr 0)) tint) tint))
        (Ebinop Olt (Evalof (Evar _k tint) tint) (Evalof (Evar _n tint) tint)
          tint)
        (Sdo (Epostincr Incr (Evar _k tint) tint))
        (Sdo (Eassignop Oadd
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _o (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _a (tptr (tptr tfloat)))
                               (tptr (tptr tfloat)))
                             (Evalof (Evar _i tint) tint)
                             (tptr (tptr tfloat))) (tptr tfloat))
                         (tptr tfloat)) (Evalof (Evar _k tint) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _b (tptr (tptr tfloat)))
                               (tptr (tptr tfloat)))
                             (Evalof (Evar _j tint) tint)
                             (tptr (tptr tfloat))) (tptr tfloat))
                         (tptr tfloat)) (Evalof (Evar _k tint) tint)
                       (tptr tfloat)) tfloat) tfloat) tfloat) tfloat tfloat))))))
|}.

Definition f_float_mat_vect_mul := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr (tptr tfloat))) ::
                (_b, (tptr tfloat)) :: (_m, tint) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
           (Eval (Vint (Int.repr 0)) tint) tfloat))
    (Sfor
      (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
        tint)
      (Sdo (Epostincr Incr (Evar _j tint) tint))
      (Sdo (Eassignop Oadd
             (Ederef
               (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _a (tptr (tptr tfloat)))
                             (tptr (tptr tfloat)))
                           (Evalof (Evar _i tint) tint) (tptr (tptr tfloat)))
                         (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
                 tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _b (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
                 tfloat) tfloat) tfloat tfloat)))))
|}.

Definition f_float_mat_scale := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr (tptr tfloat))) :: (_k, tfloat) :: (_m, tint) ::
                (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassignop Omul
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Evalof (Evar _k tfloat) tfloat) tfloat tfloat))))
|}.

Definition f_float_mat_sum_scaled := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr (tptr tfloat))) :: (_b, (tptr (tptr tfloat))) ::
                (_k, tfloat) :: (_m, tint) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassignop Oadd
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Omul (Evalof (Evar _k tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _b (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat) tfloat tfloat))))
|}.

Definition f_float_mat_minor := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_m, tint) :: (_n, tint) :: (_d, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _float_mat_zero (Tfunction
                                   ((tptr (tptr tfloat)) :: tint :: tint ::
                                    nil) tvoid cc_default))
           (Tfunction ((tptr (tptr tfloat)) :: tint :: tint :: nil) tvoid
             cc_default))
         (Econs (Evalof (Evar _o (tptr (tptr tfloat))) (tptr (tptr tfloat)))
           (Econs (Evalof (Evar _m tint) tint)
             (Econs (Evalof (Evar _n tint) tint) Enil))) tvoid))
  (Ssequence
    (Sfor
      (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _d tint) tint)
        tint)
      (Sdo (Epostincr Incr (Evar _i tint) tint))
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _o (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
             tfloat)))
    (Sfor
      (Sdo (Eassign (Evar _i tint) (Evalof (Evar _d tint) tint) tint))
      (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint)
        tint)
      (Sdo (Epostincr Incr (Evar _i tint) tint))
      (Sfor
        (Sdo (Eassign (Evar _j tint) (Evalof (Evar _d tint) tint) tint))
        (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
          tint)
        (Sdo (Epostincr Incr (Evar _j tint) tint))
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _o (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _a (tptr (tptr tfloat)))
                             (tptr (tptr tfloat)))
                           (Evalof (Evar _i tint) tint) (tptr (tptr tfloat)))
                         (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
                 tfloat) tfloat))))))
|}.

Definition f_float_mat_vmul := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_v, (tptr tfloat)) ::
                (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Ssequence
  (Sfor
    (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _i tint) tint))
    (Sfor
      (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
        tint)
      (Sdo (Epostincr Incr (Evar _j tint) tint))
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _o (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
             (Ebinop Omul
               (Ebinop Omul
                 (Eunop Oneg
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   tdouble)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _v (tptr tfloat)) (tptr tfloat))
                       (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                   tfloat) tdouble)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _v (tptr tfloat)) (tptr tfloat))
                     (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
                 tfloat) tdouble) tfloat))))
  (Sfor
    (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _i tint) tint))
    (Sdo (Eassignop Oadd
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _o (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
           tdouble tfloat))))
|}.

Definition f_float_mat_col := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr tfloat)) :: (_a, (tptr (tptr tfloat))) ::
                (_m, tint) :: (_c, tint) :: nil);
  fn_vars := ((_i, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd (Evalof (Evar _o (tptr tfloat)) (tptr tfloat))
             (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
         (Evalof
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _a (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _c tint) tint) (tptr tfloat)) tfloat) tfloat)
         tfloat)))
|}.

Definition f_float_mat_diagonal_scal := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_v, tfloat) :: (_n, tint) ::
                nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _n tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sifthenelse (Ebinop Oeq (Evalof (Evar _i tint) tint)
                   (Evalof (Evar _j tint) tint) tint)
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _o (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
             (Evalof (Evar _v tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _o (tptr (tptr tfloat)))
                         (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                       (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                 (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
             (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat)))))
|}.

Definition f_float_mat_div_scalar := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_scalar, tfloat) :: (_m, tint) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _o (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Odiv
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat) (Evalof (Evar _scalar tfloat) tfloat) tfloat) tfloat))))
|}.

Definition f_float_mat_mul_scalar := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_o, (tptr (tptr tfloat))) :: (_a, (tptr (tptr tfloat))) ::
                (_scalar, tfloat) :: (_m, tint) :: (_n, tint) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Evalof (Evar _m tint) tint) tint)
  (Sdo (Epostincr Incr (Evar _i tint) tint))
  (Sfor
    (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ebinop Olt (Evalof (Evar _j tint) tint) (Evalof (Evar _n tint) tint)
      tint)
    (Sdo (Epostincr Incr (Evar _j tint) tint))
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _o (tptr (tptr tfloat)))
                       (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                     (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
               (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _a (tptr (tptr tfloat)))
                           (tptr (tptr tfloat))) (Evalof (Evar _i tint) tint)
                         (tptr (tptr tfloat))) (tptr tfloat)) (tptr tfloat))
                   (Evalof (Evar _j tint) tint) (tptr tfloat)) tfloat)
               tfloat) (Evalof (Evar _scalar tfloat) tfloat) tfloat) tfloat))))
|}.

Definition v_five_keep_float_log_n := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_log_n (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect2_norm2 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect2_norm2 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect2_norm := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect2_norm (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect2_normalize := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect2_normalize (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect3_norm2 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect3_norm2 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect3_norm := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect3_norm (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect3_normalize := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect3_normalize (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_identity := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_identity (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_identity := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_identity (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_norm := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_norm (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_normalize := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_normalize (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_invert := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_invert (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_wrap_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_wrap_shortest (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_eulers_norm := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_eulers_norm (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_zero := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_zero (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_copy := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_copy (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_sum := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_sum (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_diff := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_diff (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_mul := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_mul (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_add := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_add (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_sub := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_sub (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_smul := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_smul (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_sdiv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_sdiv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_norm := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_norm (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_scale := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_scale (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect_dot_product := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect_dot_product (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_zero := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_zero (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_copy := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_copy (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_sum := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_sum (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_diff := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_diff (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_transpose_square := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_transpose_square (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_transpose := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_transpose (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_mul := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_mul (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_mul_transpose := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_mul_transpose (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_vect_mul := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_vect_mul (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_scale := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_scale (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_sum_scaled := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_sum_scaled (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_minor := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_minor (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_vmul := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_vmul (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_col := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_col (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_diagonal_scal := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_diagonal_scal (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_div_scalar := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_div_scalar (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_mul_scalar := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_mul_scalar (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _FloatVect2 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat :: nil)
   noattr ::
 Composite _FloatVect3 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat ::
    Member_plain _z tfloat :: nil)
   noattr ::
 Composite _FloatQuat Struct
   (Member_plain _qi tfloat :: Member_plain _qx tfloat ::
    Member_plain _qy tfloat :: Member_plain _qz tfloat :: nil)
   noattr ::
 Composite _FloatRMat Struct
   (Member_plain _m (tarray tfloat 9) :: nil)
   noattr ::
 Composite _FloatEulers Struct
   (Member_plain _phi tfloat :: Member_plain _theta tfloat ::
    Member_plain _psi tfloat :: nil)
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
 (_logf,
   Gfun(External (EF_external "logf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_sqrtf,
   Gfun(External (EF_external "sqrtf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_fabsf,
   Gfun(External (EF_external "fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_float_log_n, Gfun(Internal f_float_log_n)) ::
 (_float_vect2_norm2, Gfun(Internal f_float_vect2_norm2)) ::
 (_float_vect2_norm, Gfun(Internal f_float_vect2_norm)) ::
 (_float_vect2_normalize, Gfun(Internal f_float_vect2_normalize)) ::
 (_float_vect3_norm2, Gfun(Internal f_float_vect3_norm2)) ::
 (_float_vect3_norm, Gfun(Internal f_float_vect3_norm)) ::
 (_float_vect3_normalize, Gfun(Internal f_float_vect3_normalize)) ::
 (_float_rmat_identity, Gfun(Internal f_float_rmat_identity)) ::
 (_float_quat_identity, Gfun(Internal f_float_quat_identity)) ::
 (_float_quat_norm, Gfun(Internal f_float_quat_norm)) ::
 (_float_quat_normalize, Gfun(Internal f_float_quat_normalize)) ::
 (_float_quat_invert, Gfun(Internal f_float_quat_invert)) ::
 (_float_quat_wrap_shortest, Gfun(Internal f_float_quat_wrap_shortest)) ::
 (_float_eulers_norm, Gfun(Internal f_float_eulers_norm)) ::
 (_float_vect_zero, Gfun(Internal f_float_vect_zero)) ::
 (_float_vect_copy, Gfun(Internal f_float_vect_copy)) ::
 (_float_vect_sum, Gfun(Internal f_float_vect_sum)) ::
 (_float_vect_diff, Gfun(Internal f_float_vect_diff)) ::
 (_float_vect_mul, Gfun(Internal f_float_vect_mul)) ::
 (_float_vect_add, Gfun(Internal f_float_vect_add)) ::
 (_float_vect_sub, Gfun(Internal f_float_vect_sub)) ::
 (_float_vect_smul, Gfun(Internal f_float_vect_smul)) ::
 (_float_vect_sdiv, Gfun(Internal f_float_vect_sdiv)) ::
 (_float_vect_norm, Gfun(Internal f_float_vect_norm)) ::
 (_float_vect_scale, Gfun(Internal f_float_vect_scale)) ::
 (_float_vect_dot_product, Gfun(Internal f_float_vect_dot_product)) ::
 (_float_mat_zero, Gfun(Internal f_float_mat_zero)) ::
 (_float_mat_copy, Gfun(Internal f_float_mat_copy)) ::
 (_float_mat_sum, Gfun(Internal f_float_mat_sum)) ::
 (_float_mat_diff, Gfun(Internal f_float_mat_diff)) ::
 (_float_mat_transpose_square, Gfun(Internal f_float_mat_transpose_square)) ::
 (_float_mat_transpose, Gfun(Internal f_float_mat_transpose)) ::
 (_float_mat_mul, Gfun(Internal f_float_mat_mul)) ::
 (_float_mat_mul_transpose, Gfun(Internal f_float_mat_mul_transpose)) ::
 (_float_mat_vect_mul, Gfun(Internal f_float_mat_vect_mul)) ::
 (_float_mat_scale, Gfun(Internal f_float_mat_scale)) ::
 (_float_mat_sum_scaled, Gfun(Internal f_float_mat_sum_scaled)) ::
 (_float_mat_minor, Gfun(Internal f_float_mat_minor)) ::
 (_float_mat_vmul, Gfun(Internal f_float_mat_vmul)) ::
 (_float_mat_col, Gfun(Internal f_float_mat_col)) ::
 (_float_mat_diagonal_scal, Gfun(Internal f_float_mat_diagonal_scal)) ::
 (_float_mat_div_scalar, Gfun(Internal f_float_mat_div_scalar)) ::
 (_float_mat_mul_scalar, Gfun(Internal f_float_mat_mul_scalar)) ::
 (_five_keep_float_log_n, Gvar v_five_keep_float_log_n) ::
 (_five_keep_float_vect2_norm2, Gvar v_five_keep_float_vect2_norm2) ::
 (_five_keep_float_vect2_norm, Gvar v_five_keep_float_vect2_norm) ::
 (_five_keep_float_vect2_normalize, Gvar v_five_keep_float_vect2_normalize) ::
 (_five_keep_float_vect3_norm2, Gvar v_five_keep_float_vect3_norm2) ::
 (_five_keep_float_vect3_norm, Gvar v_five_keep_float_vect3_norm) ::
 (_five_keep_float_vect3_normalize, Gvar v_five_keep_float_vect3_normalize) ::
 (_five_keep_float_rmat_identity, Gvar v_five_keep_float_rmat_identity) ::
 (_five_keep_float_quat_identity, Gvar v_five_keep_float_quat_identity) ::
 (_five_keep_float_quat_norm, Gvar v_five_keep_float_quat_norm) ::
 (_five_keep_float_quat_normalize, Gvar v_five_keep_float_quat_normalize) ::
 (_five_keep_float_quat_invert, Gvar v_five_keep_float_quat_invert) ::
 (_five_keep_float_quat_wrap_shortest, Gvar v_five_keep_float_quat_wrap_shortest) ::
 (_five_keep_float_eulers_norm, Gvar v_five_keep_float_eulers_norm) ::
 (_five_keep_float_vect_zero, Gvar v_five_keep_float_vect_zero) ::
 (_five_keep_float_vect_copy, Gvar v_five_keep_float_vect_copy) ::
 (_five_keep_float_vect_sum, Gvar v_five_keep_float_vect_sum) ::
 (_five_keep_float_vect_diff, Gvar v_five_keep_float_vect_diff) ::
 (_five_keep_float_vect_mul, Gvar v_five_keep_float_vect_mul) ::
 (_five_keep_float_vect_add, Gvar v_five_keep_float_vect_add) ::
 (_five_keep_float_vect_sub, Gvar v_five_keep_float_vect_sub) ::
 (_five_keep_float_vect_smul, Gvar v_five_keep_float_vect_smul) ::
 (_five_keep_float_vect_sdiv, Gvar v_five_keep_float_vect_sdiv) ::
 (_five_keep_float_vect_norm, Gvar v_five_keep_float_vect_norm) ::
 (_five_keep_float_vect_scale, Gvar v_five_keep_float_vect_scale) ::
 (_five_keep_float_vect_dot_product, Gvar v_five_keep_float_vect_dot_product) ::
 (_five_keep_float_mat_zero, Gvar v_five_keep_float_mat_zero) ::
 (_five_keep_float_mat_copy, Gvar v_five_keep_float_mat_copy) ::
 (_five_keep_float_mat_sum, Gvar v_five_keep_float_mat_sum) ::
 (_five_keep_float_mat_diff, Gvar v_five_keep_float_mat_diff) ::
 (_five_keep_float_mat_transpose_square, Gvar v_five_keep_float_mat_transpose_square) ::
 (_five_keep_float_mat_transpose, Gvar v_five_keep_float_mat_transpose) ::
 (_five_keep_float_mat_mul, Gvar v_five_keep_float_mat_mul) ::
 (_five_keep_float_mat_mul_transpose, Gvar v_five_keep_float_mat_mul_transpose) ::
 (_five_keep_float_mat_vect_mul, Gvar v_five_keep_float_mat_vect_mul) ::
 (_five_keep_float_mat_scale, Gvar v_five_keep_float_mat_scale) ::
 (_five_keep_float_mat_sum_scaled, Gvar v_five_keep_float_mat_sum_scaled) ::
 (_five_keep_float_mat_minor, Gvar v_five_keep_float_mat_minor) ::
 (_five_keep_float_mat_vmul, Gvar v_five_keep_float_mat_vmul) ::
 (_five_keep_float_mat_col, Gvar v_five_keep_float_mat_col) ::
 (_five_keep_float_mat_diagonal_scal, Gvar v_five_keep_float_mat_diagonal_scal) ::
 (_five_keep_float_mat_div_scalar, Gvar v_five_keep_float_mat_div_scalar) ::
 (_five_keep_float_mat_mul_scalar, Gvar v_five_keep_float_mat_mul_scalar) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_float_mat_mul_scalar :: _five_keep_float_mat_div_scalar ::
 _five_keep_float_mat_diagonal_scal :: _five_keep_float_mat_col ::
 _five_keep_float_mat_vmul :: _five_keep_float_mat_minor ::
 _five_keep_float_mat_sum_scaled :: _five_keep_float_mat_scale ::
 _five_keep_float_mat_vect_mul :: _five_keep_float_mat_mul_transpose ::
 _five_keep_float_mat_mul :: _five_keep_float_mat_transpose ::
 _five_keep_float_mat_transpose_square :: _five_keep_float_mat_diff ::
 _five_keep_float_mat_sum :: _five_keep_float_mat_copy ::
 _five_keep_float_mat_zero :: _five_keep_float_vect_dot_product ::
 _five_keep_float_vect_scale :: _five_keep_float_vect_norm ::
 _five_keep_float_vect_sdiv :: _five_keep_float_vect_smul ::
 _five_keep_float_vect_sub :: _five_keep_float_vect_add ::
 _five_keep_float_vect_mul :: _five_keep_float_vect_diff ::
 _five_keep_float_vect_sum :: _five_keep_float_vect_copy ::
 _five_keep_float_vect_zero :: _five_keep_float_eulers_norm ::
 _five_keep_float_quat_wrap_shortest :: _five_keep_float_quat_invert ::
 _five_keep_float_quat_normalize :: _five_keep_float_quat_norm ::
 _five_keep_float_quat_identity :: _five_keep_float_rmat_identity ::
 _five_keep_float_vect3_normalize :: _five_keep_float_vect3_norm ::
 _five_keep_float_vect3_norm2 :: _five_keep_float_vect2_normalize ::
 _five_keep_float_vect2_norm :: _five_keep_float_vect2_norm2 ::
 _five_keep_float_log_n :: _fabsf :: _sqrtf :: _logf :: _fabs ::
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


