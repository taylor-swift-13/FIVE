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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/integer_algebra/model/preprocessed.i".
End Info.

Definition _Int32Eulers : ident := $"Int32Eulers".
Definition _Int32Quat : ident := $"Int32Quat".
Definition _Int32RMat : ident := $"Int32RMat".
Definition _Int32Rates : ident := $"Int32Rates".
Definition _Int32Vect3 : ident := $"Int32Vect3".
Definition _Int64Quat : ident := $"Int64Quat".
Definition __1176 : ident := $"_1176".
Definition __2qi2_m1 : ident := $"_2qi2_m1".
Definition __2qiqx : ident := $"_2qiqx".
Definition __2qiqy : ident := $"_2qiqy".
Definition __2qiqz : ident := $"_2qiqz".
Definition __2qx2 : ident := $"_2qx2".
Definition __2qy2 : ident := $"_2qy2".
Definition __2qz2 : ident := $"_2qz2".
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
Definition __div : ident := $"_div".
Definition __res : ident := $"_res".
Definition __res__1 : ident := $"_res__1".
Definition __res__2 : ident := $"_res__2".
Definition __res__3 : ident := $"_res__3".
Definition _a : ident := $"a".
Definition _a2b : ident := $"a2b".
Definition _a2c : ident := $"a2c".
Definition _angle : ident := $"angle".
Definition _asinf : ident := $"asinf".
Definition _atan2f : ident := $"atan2f".
Definition _b : ident := $"b".
Definition _b2c : ident := $"b2c".
Definition _c_phi2 : ident := $"c_phi2".
Definition _c_psi2 : ident := $"c_psi2".
Definition _c_th_c_ps : ident := $"c_th_c_ps".
Definition _c_th_s_ps : ident := $"c_th_s_ps".
Definition _c_theta2 : ident := $"c_theta2".
Definition _can2 : ident := $"can2".
Definition _cphi : ident := $"cphi".
Definition _cphi_cpsi : ident := $"cphi_cpsi".
Definition _cphi_ctheta : ident := $"cphi_ctheta".
Definition _cphi_spsi : ident := $"cphi_spsi".
Definition _cphi_stheta : ident := $"cphi_stheta".
Definition _cphi_stheta_cpsi : ident := $"cphi_stheta_cpsi".
Definition _cphi_stheta_spsi : ident := $"cphi_stheta_spsi".
Definition _cpsi : ident := $"cpsi".
Definition _ctheta : ident := $"ctheta".
Definition _ctheta_cpsi : ident := $"ctheta_cpsi".
Definition _ctheta_spsi : ident := $"ctheta_spsi".
Definition _dcm00 : ident := $"dcm00".
Definition _dcm01 : ident := $"dcm01".
Definition _dcm02 : ident := $"dcm02".
Definition _dcm12 : ident := $"dcm12".
Definition _dcm22 : ident := $"dcm22".
Definition _e : ident := $"e".
Definition _ed : ident := $"ed".
Definition _five_keep_int32_eulers_dot_321_of_rates : ident := $"five_keep_int32_eulers_dot_321_of_rates".
Definition _five_keep_int32_eulers_of_quat : ident := $"five_keep_int32_eulers_of_quat".
Definition _five_keep_int32_eulers_of_rmat : ident := $"five_keep_int32_eulers_of_rmat".
Definition _five_keep_int32_gcd : ident := $"five_keep_int32_gcd".
Definition _five_keep_int32_quat_comp : ident := $"five_keep_int32_quat_comp".
Definition _five_keep_int32_quat_comp_inv : ident := $"five_keep_int32_quat_comp_inv".
Definition _five_keep_int32_quat_comp_inv_norm_shortest : ident := $"five_keep_int32_quat_comp_inv_norm_shortest".
Definition _five_keep_int32_quat_comp_norm_shortest : ident := $"five_keep_int32_quat_comp_norm_shortest".
Definition _five_keep_int32_quat_derivative : ident := $"five_keep_int32_quat_derivative".
Definition _five_keep_int32_quat_integrate_fi : ident := $"five_keep_int32_quat_integrate_fi".
Definition _five_keep_int32_quat_inv_comp : ident := $"five_keep_int32_quat_inv_comp".
Definition _five_keep_int32_quat_inv_comp_norm_shortest : ident := $"five_keep_int32_quat_inv_comp_norm_shortest".
Definition _five_keep_int32_quat_of_axis_angle : ident := $"five_keep_int32_quat_of_axis_angle".
Definition _five_keep_int32_quat_of_eulers : ident := $"five_keep_int32_quat_of_eulers".
Definition _five_keep_int32_quat_of_rmat : ident := $"five_keep_int32_quat_of_rmat".
Definition _five_keep_int32_quat_vmult : ident := $"five_keep_int32_quat_vmult".
Definition _five_keep_int32_rates_of_eulers_dot_321 : ident := $"five_keep_int32_rates_of_eulers_dot_321".
Definition _five_keep_int32_rmat_comp : ident := $"five_keep_int32_rmat_comp".
Definition _five_keep_int32_rmat_comp_inv : ident := $"five_keep_int32_rmat_comp_inv".
Definition _five_keep_int32_rmat_of_eulers_312 : ident := $"five_keep_int32_rmat_of_eulers_312".
Definition _five_keep_int32_rmat_of_eulers_321 : ident := $"five_keep_int32_rmat_of_eulers_321".
Definition _five_keep_int32_rmat_of_quat : ident := $"five_keep_int32_rmat_of_quat".
Definition _five_keep_int32_rmat_ratemult : ident := $"five_keep_int32_rmat_ratemult".
Definition _five_keep_int32_rmat_transp_ratemult : ident := $"five_keep_int32_rmat_transp_ratemult".
Definition _five_keep_int32_rmat_transp_vmult : ident := $"five_keep_int32_rmat_transp_vmult".
Definition _five_keep_int32_rmat_vmult : ident := $"five_keep_int32_rmat_vmult".
Definition _five_keep_int32_sqrt : ident := $"five_keep_int32_sqrt".
Definition _freq : ident := $"freq".
Definition _hr : ident := $"hr".
Definition _idcm00 : ident := $"idcm00".
Definition _idcm01 : ident := $"idcm01".
Definition _idcm02 : ident := $"idcm02".
Definition _idcm12 : ident := $"idcm12".
Definition _idcm22 : ident := $"idcm22".
Definition _in : ident := $"in".
Definition _int32_eulers_dot_321_of_rates : ident := $"int32_eulers_dot_321_of_rates".
Definition _int32_eulers_of_quat : ident := $"int32_eulers_of_quat".
Definition _int32_eulers_of_rmat : ident := $"int32_eulers_of_rmat".
Definition _int32_gcd : ident := $"int32_gcd".
Definition _int32_quat_comp : ident := $"int32_quat_comp".
Definition _int32_quat_comp_inv : ident := $"int32_quat_comp_inv".
Definition _int32_quat_comp_inv_norm_shortest : ident := $"int32_quat_comp_inv_norm_shortest".
Definition _int32_quat_comp_norm_shortest : ident := $"int32_quat_comp_norm_shortest".
Definition _int32_quat_derivative : ident := $"int32_quat_derivative".
Definition _int32_quat_integrate_fi : ident := $"int32_quat_integrate_fi".
Definition _int32_quat_inv_comp : ident := $"int32_quat_inv_comp".
Definition _int32_quat_inv_comp_norm_shortest : ident := $"int32_quat_inv_comp_norm_shortest".
Definition _int32_quat_norm : ident := $"int32_quat_norm".
Definition _int32_quat_normalize : ident := $"int32_quat_normalize".
Definition _int32_quat_of_axis_angle : ident := $"int32_quat_of_axis_angle".
Definition _int32_quat_of_eulers : ident := $"int32_quat_of_eulers".
Definition _int32_quat_of_rmat : ident := $"int32_quat_of_rmat".
Definition _int32_quat_vmult : ident := $"int32_quat_vmult".
Definition _int32_quat_wrap_shortest : ident := $"int32_quat_wrap_shortest".
Definition _int32_rates_of_eulers_dot_321 : ident := $"int32_rates_of_eulers_dot_321".
Definition _int32_rmat_comp : ident := $"int32_rmat_comp".
Definition _int32_rmat_comp_inv : ident := $"int32_rmat_comp_inv".
Definition _int32_rmat_of_eulers_312 : ident := $"int32_rmat_of_eulers_312".
Definition _int32_rmat_of_eulers_321 : ident := $"int32_rmat_of_eulers_321".
Definition _int32_rmat_of_quat : ident := $"int32_rmat_of_quat".
Definition _int32_rmat_ratemult : ident := $"int32_rmat_ratemult".
Definition _int32_rmat_transp_ratemult : ident := $"int32_rmat_transp_ratemult".
Definition _int32_rmat_transp_vmult : ident := $"int32_rmat_transp_vmult".
Definition _int32_rmat_vmult : ident := $"int32_rmat_vmult".
Definition _int32_sqrt : ident := $"int32_sqrt".
Definition _iter : ident := $"iter".
Definition _lldiv : ident := $"lldiv".
Definition _m : ident := $"m".
Definition _m01 : ident := $"m01".
Definition _m02 : ident := $"m02".
Definition _m12 : ident := $"m12".
Definition _m_a2b : ident := $"m_a2b".
Definition _m_a2c : ident := $"m_a2c".
Definition _m_b2a : ident := $"m_b2a".
Definition _m_b2c : ident := $"m_b2c".
Definition _main : ident := $"main".
Definition _n : ident := $"n".
Definition _n2 : ident := $"n2".
Definition _omega : ident := $"omega".
Definition _one : ident := $"one".
Definition _p : ident := $"p".
Definition _phi : ident := $"phi".
Definition _phi2 : ident := $"phi2".
Definition _pprz_itrig_cos : ident := $"pprz_itrig_cos".
Definition _pprz_itrig_sin : ident := $"pprz_itrig_sin".
Definition _psi : ident := $"psi".
Definition _psi2 : ident := $"psi2".
Definition _q : ident := $"q".
Definition _qd : ident := $"qd".
Definition _qi : ident := $"qi".
Definition _qiqx : ident := $"qiqx".
Definition _qiqy : ident := $"qiqy".
Definition _qiqz : ident := $"qiqz".
Definition _quot : ident := $"quot".
Definition _qx : ident := $"qx".
Definition _qx2 : ident := $"qx2".
Definition _qxqy : ident := $"qxqy".
Definition _qxqz : ident := $"qxqz".
Definition _qy : ident := $"qy".
Definition _qy2 : ident := $"qy2".
Definition _qyqz : ident := $"qyqz".
Definition _qz : ident := $"qz".
Definition _qz2 : ident := $"qz2".
Definition _r : ident := $"r".
Definition _ra : ident := $"ra".
Definition _rb : ident := $"rb".
Definition _rem : ident := $"rem".
Definition _rm : ident := $"rm".
Definition _s1 : ident := $"s1".
Definition _s2 : ident := $"s2".
Definition _s_phi2 : ident := $"s_phi2".
Definition _s_psi2 : ident := $"s_psi2".
Definition _s_th_c_ps : ident := $"s_th_c_ps".
Definition _s_th_s_ps : ident := $"s_th_s_ps".
Definition _s_theta2 : ident := $"s_theta2".
Definition _san2 : ident := $"san2".
Definition _sphi : ident := $"sphi".
Definition _sphi_cpsi : ident := $"sphi_cpsi".
Definition _sphi_ctheta : ident := $"sphi_ctheta".
Definition _sphi_ctheta_cpsi : ident := $"sphi_ctheta_cpsi".
Definition _sphi_ctheta_spsi : ident := $"sphi_ctheta_spsi".
Definition _sphi_spsi : ident := $"sphi_spsi".
Definition _sphi_stheta : ident := $"sphi_stheta".
Definition _sphi_stheta_cpsi : ident := $"sphi_stheta_cpsi".
Definition _sphi_stheta_spsi : ident := $"sphi_stheta_spsi".
Definition _spsi : ident := $"spsi".
Definition _stheta : ident := $"stheta".
Definition _stheta_cpsi : ident := $"stheta_cpsi".
Definition _stheta_spsi : ident := $"stheta_spsi".
Definition _temp : ident := $"temp".
Definition _theta : ident := $"theta".
Definition _theta2 : ident := $"theta2".
Definition _tmp_p : ident := $"tmp_p".
Definition _tmp_q : ident := $"tmp_q".
Definition _tmp_r : ident := $"tmp_r".
Definition _tr : ident := $"tr".
Definition _two : ident := $"two".
Definition _two_qi : ident := $"two_qi".
Definition _two_qi_two : ident := $"two_qi_two".
Definition _two_qx : ident := $"two_qx".
Definition _two_qx_two : ident := $"two_qx_two".
Definition _two_qy : ident := $"two_qy".
Definition _two_qy_two : ident := $"two_qy_two".
Definition _two_qz : ident := $"two_qz".
Definition _two_qz_two : ident := $"two_qz_two".
Definition _uv : ident := $"uv".
Definition _v_in : ident := $"v_in".
Definition _v_out : ident := $"v_out".
Definition _va : ident := $"va".
Definition _vb : ident := $"vb".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".

Definition f_int32_quat_norm := {|
  fn_return := tuint;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := ((_n2, tuint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _n2 tuint)
         (Ebinop Oadd
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qi tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qx tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
               tint)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint) tint) tint) tint)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qz tint) tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qz tint) tint) tint) tint)
         tuint))
  (Sreturn (Some (Ecall
                   (Evalof
                     (Evar _int32_sqrt (Tfunction (tuint :: nil) tuint
                                         cc_default))
                     (Tfunction (tuint :: nil) tuint cc_default))
                   (Econs (Evalof (Evar _n2 tuint) tuint) Enil) tuint))))
|}.

Definition f_int32_quat_wrap_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sifthenelse (Ebinop Olt
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qi tint) tint)
               (Eval (Vint (Int.repr 0)) tint) tint)
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qi tint)
           (Eunop Oneg
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qi tint) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qx tint)
             (Eunop Oneg
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qx tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qy tint)
               (Eunop Oneg
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qz tint)
               (Eunop Oneg
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
               tint)))))
  Sskip)
|}.

Definition f_int32_quat_normalize := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := ((_n, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _n tint)
         (Ecall
           (Evalof
             (Evar _int32_quat_norm (Tfunction
                                      ((tptr (Tstruct _Int32Quat noattr)) ::
                                       nil) tuint cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tuint
               cc_default))
           (Econs
             (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tuint) tint))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _n tint) tint)
                 (Eval (Vint (Int.repr 0)) tint) tint)
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qi tint)
             (Ebinop Odiv
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qi tint) tint)
                 (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 15)) tint) tint) tint) tint)
               (Evalof (Evar _n tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qx tint)
               (Ebinop Odiv
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint)
                   (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 15)) tint) tint) tint) tint)
                 (Evalof (Evar _n tint) tint) tint) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint)
                 (Ebinop Odiv
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 15)) tint) tint) tint) tint)
                   (Evalof (Evar _n tint) tint) tint) tint))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint)
                 (Ebinop Odiv
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qz tint) tint)
                     (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 15)) tint) tint) tint) tint)
                   (Evalof (Evar _n tint) tint) tint) tint)))))
    Sskip))
|}.

Definition f_int32_sqrt := {|
  fn_return := tuint;
  fn_callconv := cc_default;
  fn_params := ((_in, tuint) :: nil);
  fn_vars := ((_s1, tuint) :: (_s2, tuint) :: (_iter, tuchar) :: nil);
  fn_body :=
(Sifthenelse (Ebinop Oeq (Evalof (Evar _in tuint) tuint)
               (Eval (Vint (Int.repr 0)) tint) tint)
  (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))
  (Ssequence
    (Sdo (Eassign (Evar _iter tuchar) (Eval (Vint (Int.repr 0)) tint) tuchar))
    (Ssequence
      (Sdo (Eassign (Evar _s2 tuint) (Evalof (Evar _in tuint) tuint) tuint))
      (Ssequence
        (Sdowhile
          (Eseqand
            (Ebinop Ogt
              (Ebinop Osub (Evalof (Evar _s1 tuint) tuint)
                (Evalof (Evar _s2 tuint) tuint) tuint)
              (Eval (Vint (Int.repr 1)) tint) tint)
            (Ebinop Olt (Evalof (Evar _iter tuchar) tuchar)
              (Eval (Vint (Int.repr 40)) tint) tint) tint)
          (Ssequence
            (Sdo (Eassign (Evar _s1 tuint) (Evalof (Evar _s2 tuint) tuint)
                   tuint))
            (Ssequence
              (Sdo (Eassign (Evar _s2 tuint)
                     (Ebinop Odiv (Evalof (Evar _in tuint) tuint)
                       (Evalof (Evar _s1 tuint) tuint) tuint) tuint))
              (Ssequence
                (Sdo (Eassignop Oadd (Evar _s2 tuint)
                       (Evalof (Evar _s1 tuint) tuint) tuint tuint))
                (Ssequence
                  (Sdo (Eassignop Odiv (Evar _s2 tuint)
                         (Eval (Vint (Int.repr 2)) tint) tuint tuint))
                  (Sdo (Epostincr Incr (Evar _iter tuchar) tuchar)))))))
        (Sreturn (Some (Evalof (Evar _s2 tuint) tuint)))))))
|}.

Definition f_int32_gcd := {|
  fn_return := tuint;
  fn_callconv := cc_default;
  fn_params := ((_a, tuint) :: (_b, tuint) :: nil);
  fn_vars := ((_temp, tuint) :: nil);
  fn_body :=
(Ssequence
  (Swhile
    (Ebinop One (Evalof (Evar _b tuint) tuint)
      (Eval (Vint (Int.repr 0)) tint) tint)
    (Ssequence
      (Sdo (Eassign (Evar _temp tuint)
             (Ebinop Omod (Evalof (Evar _a tuint) tuint)
               (Evalof (Evar _b tuint) tuint) tuint) tuint))
      (Ssequence
        (Sdo (Eassign (Evar _a tuint) (Evalof (Evar _b tuint) tuint) tuint))
        (Sdo (Eassign (Evar _b tuint) (Evalof (Evar _temp tuint) tuint)
               tuint)))))
  (Sreturn (Some (Evalof (Evar _a tuint) tuint))))
|}.

Definition f_int32_rmat_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_a2c, (tptr (Tstruct _Int32RMat noattr))) ::
                (_m_a2b, (tptr (Tstruct _Int32RMat noattr))) ::
                (_m_b2c, (tptr (Tstruct _Int32RMat noattr))) :: nil);
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
                     (Evalof (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                       (tptr (Tstruct _Int32RMat noattr)))
                     (Tstruct _Int32RMat noattr))
                   (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
               (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint) (tptr tint))
           tint)
         (Ebinop Oshr
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
                                 (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                       (tptr tint)) tint) tint) tint) tint)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tint)) tint) tint)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tint)) tint) tint) tint) tint)
           (Eval (Vint (Int.repr 14)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                         (tptr (Tstruct _Int32RMat noattr)))
                       (Tstruct _Int32RMat noattr))
                     (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                 (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tint)) tint)
           (Ebinop Oshr
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
                                   (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                     tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                     tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 7)) tint)
                       (tptr tint)) tint) tint) tint) tint)
             (Eval (Vint (Int.repr 14)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                           (tptr (Tstruct _Int32RMat noattr)))
                         (Tstruct _Int32RMat noattr))
                       (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                   (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tint)) tint)
             (Ebinop Oshr
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
                                     (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                       tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tint)) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                       tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                       tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 2)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                     tint) tint) tint) (Eval (Vint (Int.repr 14)) tint) tint)
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
                             (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tint)) tint)
               (Ebinop Oshr
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
                                       (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                           tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 0)) tint) (tptr tint))
                           tint) tint) tint)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                           tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                           tint) tint) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                       tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                       tint) tint) tint) (Eval (Vint (Int.repr 14)) tint)
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
                               (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 4)) tint)
                     (tptr tint)) tint)
                 (Ebinop Oshr
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
                                         (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                             tint) tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                             tint) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                             tint) tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                             tint) tint) tint) tint)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                           tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                           tint) tint) tint) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tint))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 5)) tint)
                       (tptr tint)) tint)
                   (Ebinop Oshr
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
                                           (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                               tint) tint)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                               tint) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                               tint) tint)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                               tint) tint) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                             tint) tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                             tint) tint) tint) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tint))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                     (Ebinop Oshr
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
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 6)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tint)) tint) tint) tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr tint)) tint) tint) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                               tint) tint)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 6)) tint) (tptr tint))
                               tint) tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tint)) tint)
                       (Ebinop Oshr
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
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 7)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 4)) tint)
                                     (tptr tint)) tint) tint) tint) tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tint)) tint) tint) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tint))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                       (Ebinop Oshr
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
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 7)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tint)) tint) tint) tint) tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint) tint) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tint))))))))))
|}.

Definition f_int32_rmat_comp_inv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_a2b, (tptr (Tstruct _Int32RMat noattr))) ::
                (_m_a2c, (tptr (Tstruct _Int32RMat noattr))) ::
                (_m_b2c, (tptr (Tstruct _Int32RMat noattr))) :: nil);
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
                     (Evalof (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                       (tptr (Tstruct _Int32RMat noattr)))
                     (Tstruct _Int32RMat noattr))
                   (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
               (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint) (tptr tint))
           tint)
         (Ebinop Oshr
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
                                 (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                       (tptr tint)) tint) tint) tint) tint)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tint)) tint) tint)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tint)) tint) tint) tint) tint)
           (Eval (Vint (Int.repr 14)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                         (tptr (Tstruct _Int32RMat noattr)))
                       (Tstruct _Int32RMat noattr))
                     (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                 (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tint)) tint)
           (Ebinop Oshr
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
                                   (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                     tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 3)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                     tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 7)) tint)
                       (tptr tint)) tint) tint) tint) tint)
             (Eval (Vint (Int.repr 14)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                           (tptr (Tstruct _Int32RMat noattr)))
                         (Tstruct _Int32RMat noattr))
                       (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                   (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tint)) tint)
             (Ebinop Oshr
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
                                     (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                       tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tint)) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tint)) tint)
                       tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                       tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                     tint) tint) tint) (Eval (Vint (Int.repr 14)) tint) tint)
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
                             (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tint)) tint)
               (Ebinop Oshr
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
                                       (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                           tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 0)) tint) (tptr tint))
                           tint) tint) tint)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                           tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                           tint) tint) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tint)) tint)
                       tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                       tint) tint) tint) (Eval (Vint (Int.repr 14)) tint)
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
                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 4)) tint)
                     (tptr tint)) tint)
                 (Ebinop Oshr
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
                                         (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                             tint) tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                             tint) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                             tint) tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                             tint) tint) tint) tint)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                           tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                           tint) tint) tint) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tint))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 5)) tint)
                       (tptr tint)) tint)
                   (Ebinop Oshr
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
                                           (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                               tint) tint)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                               tint) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                               tint) tint)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                               tint) tint) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                             tint) tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                             tint) tint) tint) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tint))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                     (Ebinop Oshr
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
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tint)) tint) tint) tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr tint)) tint) tint) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                               tint) tint)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 6)) tint) (tptr tint))
                               tint) tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tint)) tint)
                       (Ebinop Oshr
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
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 4)) tint)
                                     (tptr tint)) tint) tint) tint) tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tint)) tint) tint) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tint))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                       (Ebinop Oshr
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
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tint)) tint) tint) tint) tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_b2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _m_a2c (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 8)) tint)
                                   (tptr tint)) tint) tint) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tint))))))))))
|}.

Definition f_int32_rmat_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vb, (tptr (Tstruct _Int32Vect3 noattr))) ::
                (_m_a2b, (tptr (Tstruct _Int32RMat noattr))) ::
                (_va, (tptr (Tstruct _Int32Vect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vb (tptr (Tstruct _Int32Vect3 noattr)))
                 (tptr (Tstruct _Int32Vect3 noattr)))
               (Tstruct _Int32Vect3 noattr)) (Tstruct _Int32Vect3 noattr)) _x
           tint)
         (Ebinop Oshr
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
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
               tint)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tint)) tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                         (tptr (Tstruct _Int32Vect3 noattr)))
                       (Tstruct _Int32Vect3 noattr))
                     (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint) tint)
           (Eval (Vint (Int.repr 14)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _Int32Vect3 noattr)))
                   (tptr (Tstruct _Int32Vect3 noattr)))
                 (Tstruct _Int32Vect3 noattr)) (Tstruct _Int32Vect3 noattr))
             _y tint)
           (Ebinop Oshr
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
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 3)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 5)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint)
               tint) (Eval (Vint (Int.repr 14)) tint) tint) tint))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _Int32Vect3 noattr)))
                   (tptr (Tstruct _Int32Vect3 noattr)))
                 (Tstruct _Int32Vect3 noattr)) (Tstruct _Int32Vect3 noattr))
             _z tint)
           (Ebinop Oshr
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
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 7)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 8)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint)
               tint) (Eval (Vint (Int.repr 14)) tint) tint) tint))))
|}.

Definition f_int32_rmat_transp_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vb, (tptr (Tstruct _Int32Vect3 noattr))) ::
                (_m_b2a, (tptr (Tstruct _Int32RMat noattr))) ::
                (_va, (tptr (Tstruct _Int32Vect3 noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vb (tptr (Tstruct _Int32Vect3 noattr)))
                 (tptr (Tstruct _Int32Vect3 noattr)))
               (Tstruct _Int32Vect3 noattr)) (Tstruct _Int32Vect3 noattr)) _x
           tint)
         (Ebinop Oshr
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
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
               tint)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tint)) tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                         (tptr (Tstruct _Int32Vect3 noattr)))
                       (Tstruct _Int32Vect3 noattr))
                     (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint) tint)
           (Eval (Vint (Int.repr 14)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _Int32Vect3 noattr)))
                   (tptr (Tstruct _Int32Vect3 noattr)))
                 (Tstruct _Int32Vect3 noattr)) (Tstruct _Int32Vect3 noattr))
             _y tint)
           (Ebinop Oshr
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
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 7)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint)
               tint) (Eval (Vint (Int.repr 14)) tint) tint) tint))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vb (tptr (Tstruct _Int32Vect3 noattr)))
                   (tptr (Tstruct _Int32Vect3 noattr)))
                 (Tstruct _Int32Vect3 noattr)) (Tstruct _Int32Vect3 noattr))
             _z tint)
           (Ebinop Oshr
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
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 2)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                     tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 8)) tint)
                       (tptr tint)) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _va (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint)
               tint) (Eval (Vint (Int.repr 14)) tint) tint) tint))))
|}.

Definition f_int32_rmat_ratemult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rb, (tptr (Tstruct _Int32Rates noattr))) ::
                (_m_a2b, (tptr (Tstruct _Int32RMat noattr))) ::
                (_ra, (tptr (Tstruct _Int32Rates noattr))) :: nil);
  fn_vars := ((_tmp_p, tlong) :: (_tmp_q, tlong) :: (_tmp_r, tlong) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tmp_p tlong)
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
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
             tlong)
           (Ebinop Omul
             (Ecast
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tint)) tint) tint) tlong)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _r tint) tint) tlong) tlong)
         tlong))
  (Ssequence
    (Sdo (Eassign (Evar _tmp_q tlong)
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
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
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
                           (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
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
                           (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
               tlong)
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 5)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint) tint) tlong)
             tlong) tlong))
    (Ssequence
      (Sdo (Eassign (Evar _tmp_r tlong)
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
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 6)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
                 (Ebinop Omul
                   (Ecast
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
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
                             (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
                 tlong)
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_a2b (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                     tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _r tint) tint) tlong)
               tlong) tlong))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _rb (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _p tint)
               (Ecast
                 (Ebinop Oshr (Evalof (Evar _tmp_p tlong) tlong)
                   (Eval (Vint (Int.repr 14)) tint) tlong) tint) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _rb (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmp_q tlong) tlong)
                     (Eval (Vint (Int.repr 14)) tint) tlong) tint) tint))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _rb (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmp_r tlong) tlong)
                     (Eval (Vint (Int.repr 14)) tint) tlong) tint) tint)))))))
|}.

Definition f_int32_rmat_transp_ratemult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rb, (tptr (Tstruct _Int32Rates noattr))) ::
                (_m_b2a, (tptr (Tstruct _Int32RMat noattr))) ::
                (_ra, (tptr (Tstruct _Int32Rates noattr))) :: nil);
  fn_vars := ((_tmp_p, tlong) :: (_tmp_q, tlong) :: (_tmp_r, tlong) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tmp_p tlong)
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
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 3)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
             tlong)
           (Ebinop Omul
             (Ecast
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tint)) tint) tint) tlong)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _r tint) tint) tlong) tlong)
         tlong))
  (Ssequence
    (Sdo (Eassign (Evar _tmp_q tlong)
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
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
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
                           (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
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
                           (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
               tlong)
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 7)) tint)
                       (tptr tint)) tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint) tint) tlong)
             tlong) tlong))
    (Ssequence
      (Sdo (Eassign (Evar _tmp_r tlong)
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
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tint)) tint)
                       tint) tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
                 (Ebinop Omul
                   (Ecast
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
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
                             (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
                 tlong)
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2a (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                     tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _r tint) tint) tlong)
               tlong) tlong))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _rb (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _p tint)
               (Ecast
                 (Ebinop Oshr (Evalof (Evar _tmp_p tlong) tlong)
                   (Eval (Vint (Int.repr 14)) tint) tlong) tint) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _rb (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmp_q tlong) tlong)
                     (Eval (Vint (Int.repr 14)) tint) tlong) tint) tint))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _rb (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint)
                 (Ecast
                   (Ebinop Oshr (Evalof (Evar _tmp_r tlong) tlong)
                     (Eval (Vint (Int.repr 14)) tint) tlong) tint) tint)))))))
|}.

Definition f_int32_rmat_of_quat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _Int32RMat noattr))) ::
                (_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := ((__2qi2_m1, tint) :: (__2qiqx, tint) :: (__2qiqy, tint) ::
              (__2qiqz, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar __2qi2_m1 tint)
         (Ebinop Osub
           (Ebinop Oshr
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qi tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
             (Ebinop Osub
               (Ebinop Osub
                 (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                   (Eval (Vint (Int.repr 15)) tint) tint)
                 (Eval (Vint (Int.repr 14)) tint) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint)
           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 14)) tint) tint) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                         (tptr (Tstruct _Int32RMat noattr)))
                       (Tstruct _Int32RMat noattr))
                     (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                 (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
               (tptr tint)) tint)
           (Ebinop Oshr
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qx tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
             (Ebinop Osub
               (Ebinop Osub
                 (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                   (Eval (Vint (Int.repr 15)) tint) tint)
                 (Eval (Vint (Int.repr 14)) tint) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                           (tptr (Tstruct _Int32RMat noattr)))
                         (Tstruct _Int32RMat noattr))
                       (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                   (tarray tint 9)) (Eval (Vint (Int.repr 4)) tint)
                 (tptr tint)) tint)
             (Ebinop Oshr
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               (Ebinop Osub
                 (Ebinop Osub
                   (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                     (Eval (Vint (Int.repr 15)) tint) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9)) (Eval (Vint (Int.repr 8)) tint)
                   (tptr tint)) tint)
               (Ebinop Oshr
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
                 (Ebinop Osub
                   (Ebinop Osub
                     (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                       (Eval (Vint (Int.repr 15)) tint) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar __2qiqx tint)
                 (Ebinop Oshr
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   (Ebinop Osub
                     (Ebinop Osub
                       (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                         (Eval (Vint (Int.repr 15)) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint)
                     (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar __2qiqy tint)
                   (Ebinop Oshr
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint)
                     (Ebinop Osub
                       (Ebinop Osub
                         (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                           (Eval (Vint (Int.repr 15)) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
            (Ssequence
              (Sdo (Eassign (Evar __2qiqz tint)
                     (Ebinop Oshr
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qi tint) tint)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qz tint) tint)
                         tint)
                       (Ebinop Osub
                         (Ebinop Osub
                           (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                             (Eval (Vint (Int.repr 15)) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                       (Ebinop Oshr
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qx tint) tint)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qy tint) tint)
                           tint)
                         (Ebinop Osub
                           (Ebinop Osub
                             (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                           tint)
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qx tint)
                               tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qz tint)
                               tint) tint)
                           (Ebinop Osub
                             (Ebinop Osub
                               (Ebinop Oadd (Eval (Vint (Int.repr 15)) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint) tint)
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
                                         (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                         (tptr (Tstruct _Int32RMat noattr)))
                                       (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                             tint)
                           (Ebinop Oshr
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                         (tptr (Tstruct _Int32Quat noattr)))
                                       (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qy tint)
                                 tint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                         (tptr (Tstruct _Int32Quat noattr)))
                                       (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qz tint)
                                 tint) tint)
                             (Ebinop Osub
                               (Ebinop Osub
                                 (Ebinop Oadd
                                   (Eval (Vint (Int.repr 15)) tint)
                                   (Eval (Vint (Int.repr 15)) tint) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           tint))
                    (Ssequence
                      (Sdo (Eassignop Oadd
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                           (tptr (Tstruct _Int32RMat noattr)))
                                         (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 0)) tint) (tptr tint))
                               tint) (Evalof (Evar __2qi2_m1 tint) tint)
                             tint tint))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr tint)) tint)
                               (Ebinop Osub
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tint)) tint) tint)
                                 (Evalof (Evar __2qiqz tint) tint) tint)
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
                                               (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tint)) tint)
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr tint)) tint) tint)
                                   (Evalof (Evar __2qiqy tint) tint) tint)
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
                                                 (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tint)) tint)
                                   (Ebinop Osub
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                     (tptr (Tstruct _Int32RMat noattr)))
                                                   (Tstruct _Int32RMat noattr))
                                                 (Tstruct _Int32RMat noattr))
                                               _m (tarray tint 9))
                                             (tarray tint 9))
                                           (Eval (Vint (Int.repr 5)) tint)
                                           (tptr tint)) tint) tint)
                                     (Evalof (Evar __2qiqx tint) tint) tint)
                                   tint))
                            (Ssequence
                              (Sdo (Eassignop Oadd
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 4)) tint)
                                         (tptr tint)) tint)
                                     (Evalof (Evar __2qi2_m1 tint) tint)
                                     tint tint))
                              (Ssequence
                                (Sdo (Eassignop Oadd
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                     (tptr (Tstruct _Int32RMat noattr)))
                                                   (Tstruct _Int32RMat noattr))
                                                 (Tstruct _Int32RMat noattr))
                                               _m (tarray tint 9))
                                             (tarray tint 9))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tint)) tint)
                                       (Evalof (Evar __2qiqz tint) tint)
                                       tint tint))
                                (Ssequence
                                  (Sdo (Eassignop Osub
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                       (tptr (Tstruct _Int32RMat noattr)))
                                                     (Tstruct _Int32RMat noattr))
                                                   (Tstruct _Int32RMat noattr))
                                                 _m (tarray tint 9))
                                               (tarray tint 9))
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (tptr tint)) tint)
                                         (Evalof (Evar __2qiqy tint) tint)
                                         tint tint))
                                  (Ssequence
                                    (Sdo (Eassignop Oadd
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                         (tptr (Tstruct _Int32RMat noattr)))
                                                       (Tstruct _Int32RMat noattr))
                                                     (Tstruct _Int32RMat noattr))
                                                   _m (tarray tint 9))
                                                 (tarray tint 9))
                                               (Eval (Vint (Int.repr 5)) tint)
                                               (tptr tint)) tint)
                                           (Evalof (Evar __2qiqx tint) tint)
                                           tint tint))
                                    (Sdo (Eassignop Oadd
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Ederef
                                                       (Evalof
                                                         (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                         (tptr (Tstruct _Int32RMat noattr)))
                                                       (Tstruct _Int32RMat noattr))
                                                     (Tstruct _Int32RMat noattr))
                                                   _m (tarray tint 9))
                                                 (tarray tint 9))
                                               (Eval (Vint (Int.repr 8)) tint)
                                               (tptr tint)) tint)
                                           (Evalof (Evar __2qi2_m1 tint)
                                             tint) tint tint))))))))))))))))))))
|}.

Definition f_int32_rmat_of_eulers_321 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _Int32RMat noattr))) ::
                (_e, (tptr (Tstruct _Int32Eulers noattr))) :: nil);
  fn_vars := ((_sphi, tint) :: (_cphi, tint) :: (_stheta, tint) ::
              (_ctheta, tint) :: (_spsi, tint) :: (_cpsi, tint) ::
              (_ctheta_cpsi, tint) :: (_ctheta_spsi, tint) ::
              (_cphi_spsi, tint) :: (_cphi_cpsi, tint) ::
              (_cphi_ctheta, tint) :: (_cphi_stheta, tint) ::
              (_sphi_ctheta, tint) :: (_sphi_stheta, tint) ::
              (_sphi_spsi, tint) :: (_sphi_cpsi, tint) ::
              (_sphi_stheta_cpsi, tint) :: (_sphi_stheta_spsi, tint) ::
              (_cphi_stheta_cpsi, tint) :: (_cphi_stheta_spsi, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sphi tint)
         (Ecall
           (Evalof
             (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint cc_default))
             (Tfunction (tint :: nil) tint cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
           tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _cphi tint)
           (Ecall
             (Evalof
               (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                       cc_default))
               (Tfunction (tint :: nil) tint cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                         (tptr (Tstruct _Int32Eulers noattr)))
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
             tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _stheta tint)
             (Ecall
               (Evalof
                 (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                         cc_default))
                 (Tfunction (tint :: nil) tint cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                           (tptr (Tstruct _Int32Eulers noattr)))
                         (Tstruct _Int32Eulers noattr))
                       (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                 Enil) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tint)
               (Ecall
                 (Evalof
                   (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                           cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                   Enil) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _spsi tint)
                 (Ecall
                   (Evalof
                     (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                             cc_default))
                     (Tfunction (tint :: nil) tint cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                               (tptr (Tstruct _Int32Eulers noattr)))
                             (Tstruct _Int32Eulers noattr))
                           (Tstruct _Int32Eulers noattr)) _psi tint) tint)
                     Enil) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar _cpsi tint)
                   (Ecall
                     (Evalof
                       (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                               cc_default))
                       (Tfunction (tint :: nil) tint cc_default))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                 (tptr (Tstruct _Int32Eulers noattr)))
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _psi tint) tint)
                       Enil) tint) tint))
            (Ssequence
              (Sdo (Eassign (Evar _ctheta_cpsi tint)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _ctheta tint) tint)
                         (Evalof (Evar _cpsi tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign (Evar _ctheta_spsi tint)
                       (Ebinop Oshr
                         (Ebinop Omul (Evalof (Evar _ctheta tint) tint)
                           (Evalof (Evar _spsi tint) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tint))
                (Ssequence
                  (Sdo (Eassign (Evar _cphi_spsi tint)
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                             (Evalof (Evar _spsi tint) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tint))
                  (Ssequence
                    (Sdo (Eassign (Evar _cphi_cpsi tint)
                           (Ebinop Oshr
                             (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                               (Evalof (Evar _cpsi tint) tint) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _cphi_ctheta tint)
                             (Ebinop Oshr
                               (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                                 (Evalof (Evar _ctheta tint) tint) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _cphi_stheta tint)
                               (Ebinop Oshr
                                 (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                                   (Evalof (Evar _stheta tint) tint) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint) tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _sphi_ctheta tint)
                                 (Ebinop Oshr
                                   (Ebinop Omul
                                     (Evalof (Evar _sphi tint) tint)
                                     (Evalof (Evar _ctheta tint) tint) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tint))
                          (Ssequence
                            (Sdo (Eassign (Evar _sphi_stheta tint)
                                   (Ebinop Oshr
                                     (Ebinop Omul
                                       (Evalof (Evar _sphi tint) tint)
                                       (Evalof (Evar _stheta tint) tint)
                                       tint) (Eval (Vint (Int.repr 14)) tint)
                                     tint) tint))
                            (Ssequence
                              (Sdo (Eassign (Evar _sphi_spsi tint)
                                     (Ebinop Oshr
                                       (Ebinop Omul
                                         (Evalof (Evar _sphi tint) tint)
                                         (Evalof (Evar _spsi tint) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tint))
                              (Ssequence
                                (Sdo (Eassign (Evar _sphi_cpsi tint)
                                       (Ebinop Oshr
                                         (Ebinop Omul
                                           (Evalof (Evar _sphi tint) tint)
                                           (Evalof (Evar _cpsi tint) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _sphi_stheta_cpsi tint)
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Evalof (Evar _sphi_stheta tint)
                                               tint)
                                             (Evalof (Evar _cpsi tint) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 14)) tint)
                                           tint) tint))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Evar _sphi_stheta_spsi tint)
                                           (Ebinop Oshr
                                             (Ebinop Omul
                                               (Evalof
                                                 (Evar _sphi_stheta tint)
                                                 tint)
                                               (Evalof (Evar _spsi tint)
                                                 tint) tint)
                                             (Eval (Vint (Int.repr 14)) tint)
                                             tint) tint))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Evar _cphi_stheta_cpsi tint)
                                             (Ebinop Oshr
                                               (Ebinop Omul
                                                 (Evalof
                                                   (Evar _cphi_stheta tint)
                                                   tint)
                                                 (Evalof (Evar _cpsi tint)
                                                   tint) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint) tint))
                                      (Ssequence
                                        (Sdo (Eassign
                                               (Evar _cphi_stheta_spsi tint)
                                               (Ebinop Oshr
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _cphi_stheta tint)
                                                     tint)
                                                   (Evalof (Evar _spsi tint)
                                                     tint) tint)
                                                 (Eval (Vint (Int.repr 14)) tint)
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
                                                               (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                               (tptr (Tstruct _Int32RMat noattr)))
                                                             (Tstruct _Int32RMat noattr))
                                                           (Tstruct _Int32RMat noattr))
                                                         _m (tarray tint 9))
                                                       (tarray tint 9))
                                                     (Ebinop Oadd
                                                       (Ebinop Omul
                                                         (Eval (Vint (Int.repr 0)) tint)
                                                         (Eval (Vint (Int.repr 3)) tint)
                                                         tint)
                                                       (Eval (Vint (Int.repr 0)) tint)
                                                       tint) (tptr tint))
                                                   tint)
                                                 (Evalof
                                                   (Evar _ctheta_cpsi tint)
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
                                                                 (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                 (tptr (Tstruct _Int32RMat noattr)))
                                                               (Tstruct _Int32RMat noattr))
                                                             (Tstruct _Int32RMat noattr))
                                                           _m
                                                           (tarray tint 9))
                                                         (tarray tint 9))
                                                       (Ebinop Oadd
                                                         (Ebinop Omul
                                                           (Eval (Vint (Int.repr 0)) tint)
                                                           (Eval (Vint (Int.repr 3)) tint)
                                                           tint)
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         tint) (tptr tint))
                                                     tint)
                                                   (Evalof
                                                     (Evar _ctheta_spsi tint)
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
                                                                   (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                                 (Tstruct _Int32RMat noattr))
                                                               (Tstruct _Int32RMat noattr))
                                                             _m
                                                             (tarray tint 9))
                                                           (tarray tint 9))
                                                         (Ebinop Oadd
                                                           (Ebinop Omul
                                                             (Eval (Vint (Int.repr 0)) tint)
                                                             (Eval (Vint (Int.repr 3)) tint)
                                                             tint)
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           tint) (tptr tint))
                                                       tint)
                                                     (Eunop Oneg
                                                       (Evalof
                                                         (Evar _stheta tint)
                                                         tint) tint) tint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                   (Tstruct _Int32RMat noattr))
                                                                 (Tstruct _Int32RMat noattr))
                                                               _m
                                                               (tarray tint 9))
                                                             (tarray tint 9))
                                                           (Ebinop Oadd
                                                             (Ebinop Omul
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               (Eval (Vint (Int.repr 3)) tint)
                                                               tint)
                                                             (Eval (Vint (Int.repr 0)) tint)
                                                             tint)
                                                           (tptr tint)) tint)
                                                       (Ebinop Osub
                                                         (Evalof
                                                           (Evar _sphi_stheta_cpsi tint)
                                                           tint)
                                                         (Evalof
                                                           (Evar _cphi_spsi tint)
                                                           tint) tint) tint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Ederef
                                                           (Ebinop Oadd
                                                             (Evalof
                                                               (Efield
                                                                 (Evalof
                                                                   (Ederef
                                                                    (Evalof
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                   (Tstruct _Int32RMat noattr))
                                                                 _m
                                                                 (tarray tint 9))
                                                               (tarray tint 9))
                                                             (Ebinop Oadd
                                                               (Ebinop Omul
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 (Eval (Vint (Int.repr 3)) tint)
                                                                 tint)
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               tint)
                                                             (tptr tint))
                                                           tint)
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _sphi_stheta_spsi tint)
                                                             tint)
                                                           (Evalof
                                                             (Evar _cphi_cpsi tint)
                                                             tint) tint)
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
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                   _m
                                                                   (tarray tint 9))
                                                                 (tarray tint 9))
                                                               (Ebinop Oadd
                                                                 (Ebinop Omul
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   (Eval (Vint (Int.repr 3)) tint)
                                                                   tint)
                                                                 (Eval (Vint (Int.repr 2)) tint)
                                                                 tint)
                                                               (tptr tint))
                                                             tint)
                                                           (Evalof
                                                             (Evar _sphi_ctheta tint)
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
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    _m
                                                                    (tarray tint 9))
                                                                   (tarray tint 9))
                                                                 (Ebinop Oadd
                                                                   (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tint)
                                                                   (Eval (Vint (Int.repr 0)) tint)
                                                                   tint)
                                                                 (tptr tint))
                                                               tint)
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _cphi_stheta_cpsi tint)
                                                                 tint)
                                                               (Evalof
                                                                 (Evar _sphi_spsi tint)
                                                                 tint) tint)
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
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    _m
                                                                    (tarray tint 9))
                                                                    (tarray tint 9))
                                                                   (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                   (tptr tint))
                                                                 tint)
                                                               (Ebinop Osub
                                                                 (Evalof
                                                                   (Evar _cphi_stheta_spsi tint)
                                                                   tint)
                                                                 (Evalof
                                                                   (Evar _sphi_cpsi tint)
                                                                   tint)
                                                                 tint) tint))
                                                        (Sdo (Eassign
                                                               (Ederef
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    _m
                                                                    (tarray tint 9))
                                                                    (tarray tint 9))
                                                                   (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tint)
                                                                   (tptr tint))
                                                                 tint)
                                                               (Evalof
                                                                 (Evar _cphi_ctheta tint)
                                                                 tint) tint))))))))))))))))))))))))))))))
|}.

Definition f_int32_rmat_of_eulers_312 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _Int32RMat noattr))) ::
                (_e, (tptr (Tstruct _Int32Eulers noattr))) :: nil);
  fn_vars := ((_sphi, tint) :: (_cphi, tint) :: (_stheta, tint) ::
              (_ctheta, tint) :: (_spsi, tint) :: (_cpsi, tint) ::
              (_stheta_spsi, tint) :: (_stheta_cpsi, tint) ::
              (_ctheta_spsi, tint) :: (_ctheta_cpsi, tint) ::
              (_cphi_stheta, tint) :: (_cphi_ctheta, tint) ::
              (_cphi_spsi, tint) :: (_cphi_cpsi, tint) ::
              (_sphi_stheta, tint) :: (_sphi_ctheta, tint) ::
              (_sphi_stheta_spsi, tint) :: (_sphi_stheta_cpsi, tint) ::
              (_sphi_ctheta_spsi, tint) :: (_sphi_ctheta_cpsi, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sphi tint)
         (Ecall
           (Evalof
             (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint cc_default))
             (Tfunction (tint :: nil) tint cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
           tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _cphi tint)
           (Ecall
             (Evalof
               (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                       cc_default))
               (Tfunction (tint :: nil) tint cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                         (tptr (Tstruct _Int32Eulers noattr)))
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
             tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _stheta tint)
             (Ecall
               (Evalof
                 (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                         cc_default))
                 (Tfunction (tint :: nil) tint cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                           (tptr (Tstruct _Int32Eulers noattr)))
                         (Tstruct _Int32Eulers noattr))
                       (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                 Enil) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tint)
               (Ecall
                 (Evalof
                   (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                           cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                   Enil) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _spsi tint)
                 (Ecall
                   (Evalof
                     (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                             cc_default))
                     (Tfunction (tint :: nil) tint cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                               (tptr (Tstruct _Int32Eulers noattr)))
                             (Tstruct _Int32Eulers noattr))
                           (Tstruct _Int32Eulers noattr)) _psi tint) tint)
                     Enil) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar _cpsi tint)
                   (Ecall
                     (Evalof
                       (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                               cc_default))
                       (Tfunction (tint :: nil) tint cc_default))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                 (tptr (Tstruct _Int32Eulers noattr)))
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _psi tint) tint)
                       Enil) tint) tint))
            (Ssequence
              (Sdo (Eassign (Evar _stheta_spsi tint)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _stheta tint) tint)
                         (Evalof (Evar _spsi tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign (Evar _stheta_cpsi tint)
                       (Ebinop Oshr
                         (Ebinop Omul (Evalof (Evar _stheta tint) tint)
                           (Evalof (Evar _cpsi tint) tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tint))
                (Ssequence
                  (Sdo (Eassign (Evar _ctheta_spsi tint)
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _ctheta tint) tint)
                             (Evalof (Evar _spsi tint) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tint))
                  (Ssequence
                    (Sdo (Eassign (Evar _ctheta_cpsi tint)
                           (Ebinop Oshr
                             (Ebinop Omul (Evalof (Evar _ctheta tint) tint)
                               (Evalof (Evar _cpsi tint) tint) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _cphi_stheta tint)
                             (Ebinop Oshr
                               (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                                 (Evalof (Evar _stheta tint) tint) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _cphi_ctheta tint)
                               (Ebinop Oshr
                                 (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                                   (Evalof (Evar _ctheta tint) tint) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint) tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _cphi_spsi tint)
                                 (Ebinop Oshr
                                   (Ebinop Omul
                                     (Evalof (Evar _cphi tint) tint)
                                     (Evalof (Evar _spsi tint) tint) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tint))
                          (Ssequence
                            (Sdo (Eassign (Evar _cphi_cpsi tint)
                                   (Ebinop Oshr
                                     (Ebinop Omul
                                       (Evalof (Evar _cphi tint) tint)
                                       (Evalof (Evar _cpsi tint) tint) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tint))
                            (Ssequence
                              (Sdo (Eassign (Evar _sphi_stheta tint)
                                     (Ebinop Oshr
                                       (Ebinop Omul
                                         (Evalof (Evar _sphi tint) tint)
                                         (Evalof (Evar _stheta tint) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tint))
                              (Ssequence
                                (Sdo (Eassign (Evar _sphi_ctheta tint)
                                       (Ebinop Oshr
                                         (Ebinop Omul
                                           (Evalof (Evar _sphi tint) tint)
                                           (Evalof (Evar _ctheta tint) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _sphi_stheta_spsi tint)
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Evalof (Evar _sphi_stheta tint)
                                               tint)
                                             (Evalof (Evar _spsi tint) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 14)) tint)
                                           tint) tint))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Evar _sphi_stheta_cpsi tint)
                                           (Ebinop Oshr
                                             (Ebinop Omul
                                               (Evalof
                                                 (Evar _sphi_stheta tint)
                                                 tint)
                                               (Evalof (Evar _cpsi tint)
                                                 tint) tint)
                                             (Eval (Vint (Int.repr 14)) tint)
                                             tint) tint))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Evar _sphi_ctheta_spsi tint)
                                             (Ebinop Oshr
                                               (Ebinop Omul
                                                 (Evalof
                                                   (Evar _sphi_ctheta tint)
                                                   tint)
                                                 (Evalof (Evar _spsi tint)
                                                   tint) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint) tint))
                                      (Ssequence
                                        (Sdo (Eassign
                                               (Evar _sphi_ctheta_cpsi tint)
                                               (Ebinop Oshr
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _sphi_ctheta tint)
                                                     tint)
                                                   (Evalof (Evar _cpsi tint)
                                                     tint) tint)
                                                 (Eval (Vint (Int.repr 14)) tint)
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
                                                               (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                               (tptr (Tstruct _Int32RMat noattr)))
                                                             (Tstruct _Int32RMat noattr))
                                                           (Tstruct _Int32RMat noattr))
                                                         _m (tarray tint 9))
                                                       (tarray tint 9))
                                                     (Ebinop Oadd
                                                       (Ebinop Omul
                                                         (Eval (Vint (Int.repr 0)) tint)
                                                         (Eval (Vint (Int.repr 3)) tint)
                                                         tint)
                                                       (Eval (Vint (Int.repr 0)) tint)
                                                       tint) (tptr tint))
                                                   tint)
                                                 (Ebinop Osub
                                                   (Evalof
                                                     (Evar _ctheta_cpsi tint)
                                                     tint)
                                                   (Evalof
                                                     (Evar _sphi_stheta_spsi tint)
                                                     tint) tint) tint))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Ederef
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Ederef
                                                               (Evalof
                                                                 (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                 (tptr (Tstruct _Int32RMat noattr)))
                                                               (Tstruct _Int32RMat noattr))
                                                             (Tstruct _Int32RMat noattr))
                                                           _m
                                                           (tarray tint 9))
                                                         (tarray tint 9))
                                                       (Ebinop Oadd
                                                         (Ebinop Omul
                                                           (Eval (Vint (Int.repr 0)) tint)
                                                           (Eval (Vint (Int.repr 3)) tint)
                                                           tint)
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         tint) (tptr tint))
                                                     tint)
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _ctheta_spsi tint)
                                                       tint)
                                                     (Evalof
                                                       (Evar _sphi_stheta_cpsi tint)
                                                       tint) tint) tint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Ederef
                                                                 (Evalof
                                                                   (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                                 (Tstruct _Int32RMat noattr))
                                                               (Tstruct _Int32RMat noattr))
                                                             _m
                                                             (tarray tint 9))
                                                           (tarray tint 9))
                                                         (Ebinop Oadd
                                                           (Ebinop Omul
                                                             (Eval (Vint (Int.repr 0)) tint)
                                                             (Eval (Vint (Int.repr 3)) tint)
                                                             tint)
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           tint) (tptr tint))
                                                       tint)
                                                     (Eunop Oneg
                                                       (Evalof
                                                         (Evar _cphi_stheta tint)
                                                         tint) tint) tint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                   (Tstruct _Int32RMat noattr))
                                                                 (Tstruct _Int32RMat noattr))
                                                               _m
                                                               (tarray tint 9))
                                                             (tarray tint 9))
                                                           (Ebinop Oadd
                                                             (Ebinop Omul
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               (Eval (Vint (Int.repr 3)) tint)
                                                               tint)
                                                             (Eval (Vint (Int.repr 0)) tint)
                                                             tint)
                                                           (tptr tint)) tint)
                                                       (Eunop Oneg
                                                         (Evalof
                                                           (Evar _cphi_spsi tint)
                                                           tint) tint) tint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Ederef
                                                           (Ebinop Oadd
                                                             (Evalof
                                                               (Efield
                                                                 (Evalof
                                                                   (Ederef
                                                                    (Evalof
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                   (Tstruct _Int32RMat noattr))
                                                                 _m
                                                                 (tarray tint 9))
                                                               (tarray tint 9))
                                                             (Ebinop Oadd
                                                               (Ebinop Omul
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 (Eval (Vint (Int.repr 3)) tint)
                                                                 tint)
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               tint)
                                                             (tptr tint))
                                                           tint)
                                                         (Evalof
                                                           (Evar _cphi_cpsi tint)
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
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                   _m
                                                                   (tarray tint 9))
                                                                 (tarray tint 9))
                                                               (Ebinop Oadd
                                                                 (Ebinop Omul
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   (Eval (Vint (Int.repr 3)) tint)
                                                                   tint)
                                                                 (Eval (Vint (Int.repr 2)) tint)
                                                                 tint)
                                                               (tptr tint))
                                                             tint)
                                                           (Evalof
                                                             (Evar _sphi tint)
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
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    _m
                                                                    (tarray tint 9))
                                                                   (tarray tint 9))
                                                                 (Ebinop Oadd
                                                                   (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tint)
                                                                   (Eval (Vint (Int.repr 0)) tint)
                                                                   tint)
                                                                 (tptr tint))
                                                               tint)
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _stheta_cpsi tint)
                                                                 tint)
                                                               (Evalof
                                                                 (Evar _sphi_ctheta_spsi tint)
                                                                 tint) tint)
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
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    _m
                                                                    (tarray tint 9))
                                                                    (tarray tint 9))
                                                                   (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                   (tptr tint))
                                                                 tint)
                                                               (Ebinop Osub
                                                                 (Evalof
                                                                   (Evar _stheta_spsi tint)
                                                                   tint)
                                                                 (Evalof
                                                                   (Evar _sphi_ctheta_cpsi tint)
                                                                   tint)
                                                                 tint) tint))
                                                        (Sdo (Eassign
                                                               (Ederef
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                                                    (tptr (Tstruct _Int32RMat noattr)))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    (Tstruct _Int32RMat noattr))
                                                                    _m
                                                                    (tarray tint 9))
                                                                    (tarray tint 9))
                                                                   (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tint)
                                                                   (tptr tint))
                                                                 tint)
                                                               (Evalof
                                                                 (Evar _cphi_ctheta tint)
                                                                 tint) tint))))))))))))))))))))))))))))))
|}.

Definition f_int32_quat_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2c, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2b, (tptr (Tstruct _Int32Quat noattr))) ::
                (_b2c, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr)))
               (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr)) _qi
           tint)
         (Ebinop Oshr
           (Ebinop Osub
             (Ebinop Osub
               (Ebinop Osub
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint) tint) tint)
           (Eval (Vint (Int.repr 15)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qx tint)
           (Ebinop Oshr
             (Ebinop Osub
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qy tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qy tint)
             (Ebinop Oshr
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qz tint)
             (Ebinop Oshr
               (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Oadd
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                 tint) (Eval (Vint (Int.repr 15)) tint) tint) tint)))))
|}.

Definition f_int32_quat_comp_inv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2b, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2c, (tptr (Tstruct _Int32Quat noattr))) ::
                (_b2c, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr)))
               (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr)) _qi
           tint)
         (Ebinop Oshr
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint) tint) tint)
           (Eval (Vint (Int.repr 15)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qx tint)
           (Ebinop Oshr
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qy tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qy tint)
             (Ebinop Oshr
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Oadd
                     (Ebinop Omul
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qi tint) tint)
                         tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qz tint)
             (Ebinop Oshr
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qi tint) tint)
                         tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                 tint) (Eval (Vint (Int.repr 15)) tint) tint) tint)))))
|}.

Definition f_int32_quat_inv_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_b2c, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2b, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2c, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr)))
               (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr)) _qi
           tint)
         (Ebinop Oshr
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint) tint) tint)
           (Eval (Vint (Int.repr 15)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qx tint)
           (Ebinop Oshr
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Osub
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qy tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
               tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qy tint)
             (Ebinop Oshr
               (Ebinop Osub
                 (Ebinop Osub
                   (Ebinop Oadd
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qz tint)
             (Ebinop Oshr
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                 tint) (Eval (Vint (Int.repr 15)) tint) tint) tint)))))
|}.

Definition f_int32_quat_comp_norm_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2c, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2b, (tptr (Tstruct _Int32Quat noattr))) ::
                (_b2c, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _int32_quat_comp (Tfunction
                                    ((tptr (Tstruct _Int32Quat noattr)) ::
                                     (tptr (Tstruct _Int32Quat noattr)) ::
                                     (tptr (Tstruct _Int32Quat noattr)) ::
                                     nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _Int32Quat noattr)) ::
              (tptr (Tstruct _Int32Quat noattr)) ::
              (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
             (tptr (Tstruct _Int32Quat noattr)))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr)))
             (Econs
               (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _int32_quat_wrap_shortest (Tfunction
                                               ((tptr (Tstruct _Int32Quat noattr)) ::
                                                nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _int32_quat_normalize (Tfunction
                                           ((tptr (Tstruct _Int32Quat noattr)) ::
                                            nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))))
|}.

Definition f_int32_quat_comp_inv_norm_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2b, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2c, (tptr (Tstruct _Int32Quat noattr))) ::
                (_b2c, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _int32_quat_comp_inv (Tfunction
                                        ((tptr (Tstruct _Int32Quat noattr)) ::
                                         (tptr (Tstruct _Int32Quat noattr)) ::
                                         (tptr (Tstruct _Int32Quat noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _Int32Quat noattr)) ::
              (tptr (Tstruct _Int32Quat noattr)) ::
              (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
             (tptr (Tstruct _Int32Quat noattr)))
           (Econs
             (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr)))
             (Econs
               (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _int32_quat_wrap_shortest (Tfunction
                                               ((tptr (Tstruct _Int32Quat noattr)) ::
                                                nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _int32_quat_normalize (Tfunction
                                           ((tptr (Tstruct _Int32Quat noattr)) ::
                                            nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))))
|}.

Definition f_int32_quat_inv_comp_norm_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_b2c, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2b, (tptr (Tstruct _Int32Quat noattr))) ::
                (_a2c, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _int32_quat_inv_comp (Tfunction
                                        ((tptr (Tstruct _Int32Quat noattr)) ::
                                         (tptr (Tstruct _Int32Quat noattr)) ::
                                         (tptr (Tstruct _Int32Quat noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _Int32Quat noattr)) ::
              (tptr (Tstruct _Int32Quat noattr)) ::
              (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
             (tptr (Tstruct _Int32Quat noattr)))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr)))
             (Econs
               (Evalof (Evar _a2c (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _int32_quat_wrap_shortest (Tfunction
                                               ((tptr (Tstruct _Int32Quat noattr)) ::
                                                nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _int32_quat_normalize (Tfunction
                                           ((tptr (Tstruct _Int32Quat noattr)) ::
                                            nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _b2c (tptr (Tstruct _Int32Quat noattr)))
               (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))))
|}.

Definition f_int32_quat_derivative := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_qd, (tptr (Tstruct _Int32Quat noattr))) ::
                (_r, (tptr (Tstruct _Int32Rates noattr))) ::
                (_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _qd (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr)))
               (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr)) _qi
           tint)
         (Ebinop Oshr
           (Eunop Oneg
             (Ebinop Oadd
               (Ebinop Oadd
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _q tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
                 tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _r tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
               tint) tint)
           (Ebinop Oadd (Eval (Vint (Int.repr 12)) tint)
             (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _qd (tptr (Tstruct _Int32Quat noattr)))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qx tint)
           (Ebinop Oshr
             (Eunop Oneg
               (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Omul
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _p tint) tint)
                       tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
                   tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _q tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
                 tint) tint)
             (Ebinop Oadd (Eval (Vint (Int.repr 12)) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qd (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qy tint)
             (Ebinop Oshr
               (Eunop Oneg
                 (Ebinop Osub
                   (Ebinop Oadd
                     (Ebinop Omul
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                   (tptr (Tstruct _Int32Rates noattr)))
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _q tint) tint)
                         tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _r tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _p tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
                   tint) tint)
               (Ebinop Oadd (Eval (Vint (Int.repr 12)) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qd (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qz tint)
             (Ebinop Oshr
               (Eunop Oneg
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                   (tptr (Tstruct _Int32Rates noattr)))
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _r tint) tint)
                         tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       tint)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _q tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint) tint)
                       tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _p tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
                   tint) tint)
               (Ebinop Oadd (Eval (Vint (Int.repr 12)) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) tint) tint)))))
|}.

Definition f_int32_quat_integrate_fi := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) ::
                (_hr, (tptr (Tstruct _Int64Quat noattr))) ::
                (_omega, (tptr (Tstruct _Int32Rates noattr))) ::
                (_freq, tint) :: nil);
  fn_vars := ((__div, (Tstruct __1176 noattr)) ::
              (__res, (Tstruct __1176 noattr)) ::
              (__res__1, (Tstruct __1176 noattr)) ::
              (__res__2, (Tstruct __1176 noattr)) ::
              (__res__3, (Tstruct __1176 noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassignop Oadd
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                 (tptr (Tstruct _Int64Quat noattr)))
               (Tstruct _Int64Quat noattr)) (Tstruct _Int64Quat noattr)) _qi
           tlong)
         (Ebinop Osub
           (Ebinop Osub
             (Ebinop Omul
               (Eunop Oneg
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
                 tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qx tint) tint) tlong)
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint) tint) tlong)
             tlong)
           (Ebinop Omul
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint) tint) tlong)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qz tint) tint) tlong) tlong)
         tlong tlong))
  (Ssequence
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                   (tptr (Tstruct _Int64Quat noattr)))
                 (Tstruct _Int64Quat noattr)) (Tstruct _Int64Quat noattr))
             _qx tlong)
           (Ebinop Osub
             (Ebinop Oadd
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qi tint) tint) tlong)
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _r tint) tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tlong)
               tlong)
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint) tlong)
             tlong) tlong tlong))
    (Ssequence
      (Sdo (Eassignop Oadd
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                     (tptr (Tstruct _Int64Quat noattr)))
                   (Tstruct _Int64Quat noattr)) (Tstruct _Int64Quat noattr))
               _qy tlong)
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Omul
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint) tint)
                     tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tlong)
                 (Ebinop Omul
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint)
                     tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tlong)
                 tlong)
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint) tlong)
               tlong) tlong tlong))
      (Ssequence
        (Sdo (Eassignop Oadd
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                       (tptr (Tstruct _Int64Quat noattr)))
                     (Tstruct _Int64Quat noattr))
                   (Tstruct _Int64Quat noattr)) _qz tlong)
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Ecast
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _r tint) tint)
                       tlong)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint)
                     tlong)
                   (Ebinop Omul
                     (Ecast
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _q tint) tint)
                       tlong)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint)
                     tlong) tlong)
                 (Ebinop Omul
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _omega (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _p tint) tint)
                     tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qy tint) tint) tlong)
                 tlong) tlong tlong))
        (Ssequence
          (Sdo (Ecomma
                 (Ecall
                   (Evalof
                     (Evar _lldiv (Tfunction
                                    ((tptr (Tstruct __1176 noattr)) ::
                                     tlong :: tlong :: nil) tvoid
                                    {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                     (Tfunction
                       ((tptr (Tstruct __1176 noattr)) :: tlong :: tlong ::
                        nil) tvoid
                       {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                   (Econs
                     (Eaddrof (Evar __res__3 (Tstruct __1176 noattr))
                       (tptr (Tstruct __1176 noattr)))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                 (tptr (Tstruct _Int64Quat noattr)))
                               (Tstruct _Int64Quat noattr))
                             (Tstruct _Int64Quat noattr)) _qi tlong) tlong)
                       (Econs
                         (Ebinop Omul
                           (Ebinop Omul
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint)
                             (Evalof (Evar _freq tint) tint) tint)
                           (Eval (Vint (Int.repr 2)) tint) tint) Enil)))
                   tvoid)
                 (Eassign (Evar __div (Tstruct __1176 noattr))
                   (Evalof (Evar __res__3 (Tstruct __1176 noattr))
                     (Tstruct __1176 noattr)) (Tstruct __1176 noattr))
                 (Tstruct __1176 noattr)))
          (Ssequence
            (Sdo (Eassignop Oadd
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qi tint)
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof (Evar __div (Tstruct __1176 noattr))
                           (Tstruct __1176 noattr)) _quot tlong) tlong) tint)
                   tint tint))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                             (tptr (Tstruct _Int64Quat noattr)))
                           (Tstruct _Int64Quat noattr))
                         (Tstruct _Int64Quat noattr)) _qi tlong)
                     (Evalof
                       (Efield
                         (Evalof (Evar __div (Tstruct __1176 noattr))
                           (Tstruct __1176 noattr)) _rem tlong) tlong) tlong))
              (Ssequence
                (Sdo (Ecomma
                       (Ecall
                         (Evalof
                           (Evar _lldiv (Tfunction
                                          ((tptr (Tstruct __1176 noattr)) ::
                                           tlong :: tlong :: nil) tvoid
                                          {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                           (Tfunction
                             ((tptr (Tstruct __1176 noattr)) :: tlong ::
                              tlong :: nil) tvoid
                             {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                         (Econs
                           (Eaddrof (Evar __res__2 (Tstruct __1176 noattr))
                             (tptr (Tstruct __1176 noattr)))
                           (Econs
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                       (tptr (Tstruct _Int64Quat noattr)))
                                     (Tstruct _Int64Quat noattr))
                                   (Tstruct _Int64Quat noattr)) _qx tlong)
                               tlong)
                             (Econs
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Ebinop Oshl
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 12)) tint) tint)
                                   (Evalof (Evar _freq tint) tint) tint)
                                 (Eval (Vint (Int.repr 2)) tint) tint) Enil)))
                         tvoid)
                       (Eassign (Evar __div (Tstruct __1176 noattr))
                         (Evalof (Evar __res__2 (Tstruct __1176 noattr))
                           (Tstruct __1176 noattr)) (Tstruct __1176 noattr))
                       (Tstruct __1176 noattr)))
                (Ssequence
                  (Sdo (Eassignop Oadd
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint)
                         (Ecast
                           (Evalof
                             (Efield
                               (Evalof (Evar __div (Tstruct __1176 noattr))
                                 (Tstruct __1176 noattr)) _quot tlong) tlong)
                           tint) tint tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                   (tptr (Tstruct _Int64Quat noattr)))
                                 (Tstruct _Int64Quat noattr))
                               (Tstruct _Int64Quat noattr)) _qx tlong)
                           (Evalof
                             (Efield
                               (Evalof (Evar __div (Tstruct __1176 noattr))
                                 (Tstruct __1176 noattr)) _rem tlong) tlong)
                           tlong))
                    (Ssequence
                      (Sdo (Ecomma
                             (Ecall
                               (Evalof
                                 (Evar _lldiv (Tfunction
                                                ((tptr (Tstruct __1176 noattr)) ::
                                                 tlong :: tlong :: nil) tvoid
                                                {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                                 (Tfunction
                                   ((tptr (Tstruct __1176 noattr)) ::
                                    tlong :: tlong :: nil) tvoid
                                   {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                               (Econs
                                 (Eaddrof
                                   (Evar __res__1 (Tstruct __1176 noattr))
                                   (tptr (Tstruct __1176 noattr)))
                                 (Econs
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                             (tptr (Tstruct _Int64Quat noattr)))
                                           (Tstruct _Int64Quat noattr))
                                         (Tstruct _Int64Quat noattr)) _qy
                                       tlong) tlong)
                                   (Econs
                                     (Ebinop Omul
                                       (Ebinop Omul
                                         (Ebinop Oshl
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Eval (Vint (Int.repr 12)) tint)
                                           tint)
                                         (Evalof (Evar _freq tint) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     Enil))) tvoid)
                             (Eassign (Evar __div (Tstruct __1176 noattr))
                               (Evalof
                                 (Evar __res__1 (Tstruct __1176 noattr))
                                 (Tstruct __1176 noattr))
                               (Tstruct __1176 noattr))
                             (Tstruct __1176 noattr)))
                      (Ssequence
                        (Sdo (Eassignop Oadd
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qy tint)
                               (Ecast
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar __div (Tstruct __1176 noattr))
                                       (Tstruct __1176 noattr)) _quot tlong)
                                   tlong) tint) tint tint))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                         (tptr (Tstruct _Int64Quat noattr)))
                                       (Tstruct _Int64Quat noattr))
                                     (Tstruct _Int64Quat noattr)) _qy tlong)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Evar __div (Tstruct __1176 noattr))
                                       (Tstruct __1176 noattr)) _rem tlong)
                                   tlong) tlong))
                          (Ssequence
                            (Sdo (Ecomma
                                   (Ecall
                                     (Evalof
                                       (Evar _lldiv (Tfunction
                                                      ((tptr (Tstruct __1176 noattr)) ::
                                                       tlong :: tlong :: nil)
                                                      tvoid
                                                      {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                                       (Tfunction
                                         ((tptr (Tstruct __1176 noattr)) ::
                                          tlong :: tlong :: nil) tvoid
                                         {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
                                     (Econs
                                       (Eaddrof
                                         (Evar __res (Tstruct __1176 noattr))
                                         (tptr (Tstruct __1176 noattr)))
                                       (Econs
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                                   (tptr (Tstruct _Int64Quat noattr)))
                                                 (Tstruct _Int64Quat noattr))
                                               (Tstruct _Int64Quat noattr))
                                             _qz tlong) tlong)
                                         (Econs
                                           (Ebinop Omul
                                             (Ebinop Omul
                                               (Ebinop Oshl
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 (Eval (Vint (Int.repr 12)) tint)
                                                 tint)
                                               (Evalof (Evar _freq tint)
                                                 tint) tint)
                                             (Eval (Vint (Int.repr 2)) tint)
                                             tint) Enil))) tvoid)
                                   (Eassign
                                     (Evar __div (Tstruct __1176 noattr))
                                     (Evalof
                                       (Evar __res (Tstruct __1176 noattr))
                                       (Tstruct __1176 noattr))
                                     (Tstruct __1176 noattr))
                                   (Tstruct __1176 noattr)))
                            (Ssequence
                              (Sdo (Eassignop Oadd
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                             (tptr (Tstruct _Int32Quat noattr)))
                                           (Tstruct _Int32Quat noattr))
                                         (Tstruct _Int32Quat noattr)) _qz
                                       tint)
                                     (Ecast
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar __div (Tstruct __1176 noattr))
                                             (Tstruct __1176 noattr)) _quot
                                           tlong) tlong) tint) tint tint))
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _hr (tptr (Tstruct _Int64Quat noattr)))
                                             (tptr (Tstruct _Int64Quat noattr)))
                                           (Tstruct _Int64Quat noattr))
                                         (Tstruct _Int64Quat noattr)) _qz
                                       tlong)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar __div (Tstruct __1176 noattr))
                                           (Tstruct __1176 noattr)) _rem
                                         tlong) tlong) tlong)))))))))))))))))
|}.

Definition f_int32_quat_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_v_out, (tptr (Tstruct _Int32Vect3 noattr))) ::
                (_q, (tptr (Tstruct _Int32Quat noattr))) ::
                (_v_in, (tptr (Tstruct _Int32Vect3 noattr))) :: nil);
  fn_vars := ((__2qi2_m1, tlong) :: (__2qx2, tlong) :: (__2qy2, tlong) ::
              (__2qz2, tlong) :: (__2qiqx, tlong) :: (__2qiqy, tlong) ::
              (__2qiqz, tlong) :: (_m01, tlong) :: (_m02, tlong) ::
              (_m12, tlong) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar __2qi2_m1 tlong)
         (Ebinop Osub
           (Ebinop Oshr
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qi tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qi tint) tint) tint)
             (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint)
           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 15)) tint) tint) tint) tint) tlong))
  (Ssequence
    (Sdo (Eassign (Evar __2qx2 tlong)
           (Ebinop Oshr
             (Ebinop Omul
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qx tint) tint) tlong)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qx tint) tint) tlong)
             (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tlong) tlong))
    (Ssequence
      (Sdo (Eassign (Evar __2qy2 tlong)
             (Ebinop Oshr
               (Ebinop Omul
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qy tint) tint) tlong)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint) tint) tlong)
               (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) tlong) tlong))
      (Ssequence
        (Sdo (Eassign (Evar __2qz2 tlong)
               (Ebinop Oshr
                 (Ebinop Omul
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qz tint) tint)
                     tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qz tint) tint) tlong)
                 (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tlong) tlong))
        (Ssequence
          (Sdo (Eassign (Evar __2qiqx tlong)
                 (Ebinop Oshr
                   (Ebinop Omul
                     (Ecast
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       tlong)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint)
                     tlong)
                   (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                     (Eval (Vint (Int.repr 1)) tint) tint) tlong) tlong))
          (Ssequence
            (Sdo (Eassign (Evar __2qiqy tlong)
                   (Ebinop Oshr
                     (Ebinop Omul
                       (Ecast
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qi tint) tint)
                         tlong)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tlong)
                     (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) tlong) tlong))
            (Ssequence
              (Sdo (Eassign (Evar __2qiqz tlong)
                     (Ebinop Oshr
                       (Ebinop Omul
                         (Ecast
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qi tint) tint)
                           tlong)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qz tint) tint)
                         tlong)
                       (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) tlong) tlong))
              (Ssequence
                (Sdo (Eassign (Evar _m01 tlong)
                       (Ebinop Oadd
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qx tint)
                               tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qy tint)
                               tint) tint)
                           (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint) tint)
                         (Evalof (Evar __2qiqz tlong) tlong) tlong) tlong))
                (Ssequence
                  (Sdo (Eassign (Evar _m02 tlong)
                         (Ebinop Osub
                           (Ebinop Oshr
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                         (tptr (Tstruct _Int32Quat noattr)))
                                       (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qx tint)
                                 tint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                         (tptr (Tstruct _Int32Quat noattr)))
                                       (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qz tint)
                                 tint) tint)
                             (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (Evalof (Evar __2qiqy tlong) tlong) tlong) tlong))
                  (Ssequence
                    (Sdo (Eassign (Evar _m12 tlong)
                           (Ebinop Oadd
                             (Ebinop Oshr
                               (Ebinop Omul
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                           (tptr (Tstruct _Int32Quat noattr)))
                                         (Tstruct _Int32Quat noattr))
                                       (Tstruct _Int32Quat noattr)) _qy tint)
                                   tint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                           (tptr (Tstruct _Int32Quat noattr)))
                                         (Tstruct _Int32Quat noattr))
                                       (Tstruct _Int32Quat noattr)) _qz tint)
                                   tint) tint)
                               (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint) tint)
                             (Evalof (Evar __2qiqx tlong) tlong) tlong)
                           tlong))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _v_out (tptr (Tstruct _Int32Vect3 noattr)))
                                     (tptr (Tstruct _Int32Vect3 noattr)))
                                   (Tstruct _Int32Vect3 noattr))
                                 (Tstruct _Int32Vect3 noattr)) _x tint)
                             (Ebinop Oshr
                               (Ebinop Oadd
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Evalof (Evar __2qi2_m1 tlong) tlong)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                 (tptr (Tstruct _Int32Vect3 noattr)))
                                               (Tstruct _Int32Vect3 noattr))
                                             (Tstruct _Int32Vect3 noattr)) _x
                                           tint) tint) tlong)
                                     (Ebinop Omul
                                       (Evalof (Evar __2qx2 tlong) tlong)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                 (tptr (Tstruct _Int32Vect3 noattr)))
                                               (Tstruct _Int32Vect3 noattr))
                                             (Tstruct _Int32Vect3 noattr)) _x
                                           tint) tint) tlong) tlong)
                                   (Ebinop Omul
                                     (Evalof (Evar _m01 tlong) tlong)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                               (tptr (Tstruct _Int32Vect3 noattr)))
                                             (Tstruct _Int32Vect3 noattr))
                                           (Tstruct _Int32Vect3 noattr)) _y
                                         tint) tint) tlong) tlong)
                                 (Ebinop Omul
                                   (Evalof (Evar _m02 tlong) tlong)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                             (tptr (Tstruct _Int32Vect3 noattr)))
                                           (Tstruct _Int32Vect3 noattr))
                                         (Tstruct _Int32Vect3 noattr)) _z
                                       tint) tint) tlong) tlong)
                               (Eval (Vint (Int.repr 15)) tint) tlong) tint))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _v_out (tptr (Tstruct _Int32Vect3 noattr)))
                                       (tptr (Tstruct _Int32Vect3 noattr)))
                                     (Tstruct _Int32Vect3 noattr))
                                   (Tstruct _Int32Vect3 noattr)) _y tint)
                               (Ebinop Oshr
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Ebinop Osub
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar __2qi2_m1 tlong)
                                             tlong)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                     (tptr (Tstruct _Int32Vect3 noattr)))
                                                   (Tstruct _Int32Vect3 noattr))
                                                 (Tstruct _Int32Vect3 noattr))
                                               _y tint) tint) tlong)
                                         (Ebinop Omul
                                           (Evalof (Evar _m01 tlong) tlong)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                     (tptr (Tstruct _Int32Vect3 noattr)))
                                                   (Tstruct _Int32Vect3 noattr))
                                                 (Tstruct _Int32Vect3 noattr))
                                               _x tint) tint) tlong) tlong)
                                       (Ebinop Omul
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Evalof (Evar __2qiqz tlong)
                                             tlong) tlong)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                   (tptr (Tstruct _Int32Vect3 noattr)))
                                                 (Tstruct _Int32Vect3 noattr))
                                               (Tstruct _Int32Vect3 noattr))
                                             _x tint) tint) tlong) tlong)
                                     (Ebinop Omul
                                       (Evalof (Evar __2qy2 tlong) tlong)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                 (tptr (Tstruct _Int32Vect3 noattr)))
                                               (Tstruct _Int32Vect3 noattr))
                                             (Tstruct _Int32Vect3 noattr)) _y
                                           tint) tint) tlong) tlong)
                                   (Ebinop Omul
                                     (Evalof (Evar _m12 tlong) tlong)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                               (tptr (Tstruct _Int32Vect3 noattr)))
                                             (Tstruct _Int32Vect3 noattr))
                                           (Tstruct _Int32Vect3 noattr)) _z
                                         tint) tint) tlong) tlong)
                                 (Eval (Vint (Int.repr 15)) tint) tlong)
                               tint))
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _v_out (tptr (Tstruct _Int32Vect3 noattr)))
                                       (tptr (Tstruct _Int32Vect3 noattr)))
                                     (Tstruct _Int32Vect3 noattr))
                                   (Tstruct _Int32Vect3 noattr)) _z tint)
                               (Ebinop Oshr
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Ebinop Oadd
                                       (Ebinop Oadd
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar __2qi2_m1 tlong)
                                               tlong)
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                       (tptr (Tstruct _Int32Vect3 noattr)))
                                                     (Tstruct _Int32Vect3 noattr))
                                                   (Tstruct _Int32Vect3 noattr))
                                                 _z tint) tint) tlong)
                                           (Ebinop Omul
                                             (Evalof (Evar _m02 tlong) tlong)
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                       (tptr (Tstruct _Int32Vect3 noattr)))
                                                     (Tstruct _Int32Vect3 noattr))
                                                   (Tstruct _Int32Vect3 noattr))
                                                 _x tint) tint) tlong) tlong)
                                         (Ebinop Omul
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Evalof (Evar __2qiqy tlong)
                                               tlong) tlong)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                     (tptr (Tstruct _Int32Vect3 noattr)))
                                                   (Tstruct _Int32Vect3 noattr))
                                                 (Tstruct _Int32Vect3 noattr))
                                               _x tint) tint) tlong) tlong)
                                       (Ebinop Omul
                                         (Evalof (Evar _m12 tlong) tlong)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                   (tptr (Tstruct _Int32Vect3 noattr)))
                                                 (Tstruct _Int32Vect3 noattr))
                                               (Tstruct _Int32Vect3 noattr))
                                             _y tint) tint) tlong) tlong)
                                     (Ebinop Omul
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Evalof (Evar __2qiqx tlong) tlong)
                                         tlong)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                                 (tptr (Tstruct _Int32Vect3 noattr)))
                                               (Tstruct _Int32Vect3 noattr))
                                             (Tstruct _Int32Vect3 noattr)) _y
                                           tint) tint) tlong) tlong)
                                   (Ebinop Omul
                                     (Evalof (Evar __2qz2 tlong) tlong)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _v_in (tptr (Tstruct _Int32Vect3 noattr)))
                                               (tptr (Tstruct _Int32Vect3 noattr)))
                                             (Tstruct _Int32Vect3 noattr))
                                           (Tstruct _Int32Vect3 noattr)) _z
                                         tint) tint) tlong) tlong)
                                 (Eval (Vint (Int.repr 15)) tint) tlong)
                               tint))))))))))))))
|}.

Definition f_int32_quat_of_eulers := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) ::
                (_e, (tptr (Tstruct _Int32Eulers noattr))) :: nil);
  fn_vars := ((_phi2, tint) :: (_theta2, tint) :: (_psi2, tint) ::
              (_s_phi2, tint) :: (_c_phi2, tint) :: (_s_theta2, tint) ::
              (_c_theta2, tint) :: (_s_psi2, tint) :: (_c_psi2, tint) ::
              (_c_th_c_ps, tint) :: (_c_th_s_ps, tint) ::
              (_s_th_s_ps, tint) :: (_s_th_c_ps, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _phi2 tint)
         (Ebinop Odiv
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                     (tptr (Tstruct _Int32Eulers noattr)))
                   (Tstruct _Int32Eulers noattr))
                 (Tstruct _Int32Eulers noattr)) _phi tint) tint)
           (Eval (Vint (Int.repr 2)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _theta2 tint)
           (Ebinop Odiv
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _theta tint) tint)
             (Eval (Vint (Int.repr 2)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _psi2 tint)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                         (tptr (Tstruct _Int32Eulers noattr)))
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _psi tint) tint)
               (Eval (Vint (Int.repr 2)) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _s_phi2 tint)
               (Ecall
                 (Evalof
                   (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                           cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs (Evalof (Evar _phi2 tint) tint) Enil) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _c_phi2 tint)
                 (Ecall
                   (Evalof
                     (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                             cc_default))
                     (Tfunction (tint :: nil) tint cc_default))
                   (Econs (Evalof (Evar _phi2 tint) tint) Enil) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar _s_theta2 tint)
                   (Ecall
                     (Evalof
                       (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                               cc_default))
                       (Tfunction (tint :: nil) tint cc_default))
                     (Econs (Evalof (Evar _theta2 tint) tint) Enil) tint)
                   tint))
            (Ssequence
              (Sdo (Eassign (Evar _c_theta2 tint)
                     (Ecall
                       (Evalof
                         (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                                 cc_default))
                         (Tfunction (tint :: nil) tint cc_default))
                       (Econs (Evalof (Evar _theta2 tint) tint) Enil) tint)
                     tint))
              (Ssequence
                (Sdo (Eassign (Evar _s_psi2 tint)
                       (Ecall
                         (Evalof
                           (Evar _pprz_itrig_sin (Tfunction (tint :: nil)
                                                   tint cc_default))
                           (Tfunction (tint :: nil) tint cc_default))
                         (Econs (Evalof (Evar _psi2 tint) tint) Enil) tint)
                       tint))
                (Ssequence
                  (Sdo (Eassign (Evar _c_psi2 tint)
                         (Ecall
                           (Evalof
                             (Evar _pprz_itrig_cos (Tfunction (tint :: nil)
                                                     tint cc_default))
                             (Tfunction (tint :: nil) tint cc_default))
                           (Econs (Evalof (Evar _psi2 tint) tint) Enil) tint)
                         tint))
                  (Ssequence
                    (Sdo (Eassign (Evar _c_th_c_ps tint)
                           (Ebinop Oshr
                             (Ebinop Omul (Evalof (Evar _c_theta2 tint) tint)
                               (Evalof (Evar _c_psi2 tint) tint) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _c_th_s_ps tint)
                             (Ebinop Oshr
                               (Ebinop Omul
                                 (Evalof (Evar _c_theta2 tint) tint)
                                 (Evalof (Evar _s_psi2 tint) tint) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _s_th_s_ps tint)
                               (Ebinop Oshr
                                 (Ebinop Omul
                                   (Evalof (Evar _s_theta2 tint) tint)
                                   (Evalof (Evar _s_psi2 tint) tint) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint) tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _s_th_c_ps tint)
                                 (Ebinop Oshr
                                   (Ebinop Omul
                                     (Evalof (Evar _s_theta2 tint) tint)
                                     (Evalof (Evar _c_psi2 tint) tint) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tint))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                           (tptr (Tstruct _Int32Quat noattr)))
                                         (Tstruct _Int32Quat noattr))
                                       (Tstruct _Int32Quat noattr)) _qi tint)
                                   (Ebinop Oadd
                                     (Ebinop Oshr
                                       (Ebinop Omul
                                         (Evalof (Evar _c_phi2 tint) tint)
                                         (Evalof (Evar _c_th_c_ps tint) tint)
                                         tint)
                                       (Ebinop Osub
                                         (Ebinop Oadd
                                           (Eval (Vint (Int.repr 14)) tint)
                                           (Eval (Vint (Int.repr 14)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 15)) tint)
                                         tint) tint)
                                     (Ebinop Oshr
                                       (Ebinop Omul
                                         (Evalof (Evar _s_phi2 tint) tint)
                                         (Evalof (Evar _s_th_s_ps tint) tint)
                                         tint)
                                       (Ebinop Osub
                                         (Ebinop Oadd
                                           (Eval (Vint (Int.repr 14)) tint)
                                           (Eval (Vint (Int.repr 14)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 15)) tint)
                                         tint) tint) tint) tint))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                             (tptr (Tstruct _Int32Quat noattr)))
                                           (Tstruct _Int32Quat noattr))
                                         (Tstruct _Int32Quat noattr)) _qx
                                       tint)
                                     (Ebinop Oadd
                                       (Ebinop Oshr
                                         (Ebinop Omul
                                           (Eunop Oneg
                                             (Evalof (Evar _c_phi2 tint)
                                               tint) tint)
                                           (Evalof (Evar _s_th_s_ps tint)
                                             tint) tint)
                                         (Ebinop Osub
                                           (Ebinop Oadd
                                             (Eval (Vint (Int.repr 14)) tint)
                                             (Eval (Vint (Int.repr 14)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 15)) tint)
                                           tint) tint)
                                       (Ebinop Oshr
                                         (Ebinop Omul
                                           (Evalof (Evar _s_phi2 tint) tint)
                                           (Evalof (Evar _c_th_c_ps tint)
                                             tint) tint)
                                         (Ebinop Osub
                                           (Ebinop Oadd
                                             (Eval (Vint (Int.repr 14)) tint)
                                             (Eval (Vint (Int.repr 14)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 15)) tint)
                                           tint) tint) tint) tint))
                              (Ssequence
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                               (tptr (Tstruct _Int32Quat noattr)))
                                             (Tstruct _Int32Quat noattr))
                                           (Tstruct _Int32Quat noattr)) _qy
                                         tint)
                                       (Ebinop Oadd
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Evalof (Evar _c_phi2 tint)
                                               tint)
                                             (Evalof (Evar _s_th_c_ps tint)
                                               tint) tint)
                                           (Ebinop Osub
                                             (Ebinop Oadd
                                               (Eval (Vint (Int.repr 14)) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 15)) tint)
                                             tint) tint)
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Evalof (Evar _s_phi2 tint)
                                               tint)
                                             (Evalof (Evar _c_th_s_ps tint)
                                               tint) tint)
                                           (Ebinop Osub
                                             (Ebinop Oadd
                                               (Eval (Vint (Int.repr 14)) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 15)) tint)
                                             tint) tint) tint) tint))
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                               (tptr (Tstruct _Int32Quat noattr)))
                                             (Tstruct _Int32Quat noattr))
                                           (Tstruct _Int32Quat noattr)) _qz
                                         tint)
                                       (Ebinop Oadd
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Evalof (Evar _c_phi2 tint)
                                               tint)
                                             (Evalof (Evar _c_th_s_ps tint)
                                               tint) tint)
                                           (Ebinop Osub
                                             (Ebinop Oadd
                                               (Eval (Vint (Int.repr 14)) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 15)) tint)
                                             tint) tint)
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Eunop Oneg
                                               (Evalof (Evar _s_phi2 tint)
                                                 tint) tint)
                                             (Evalof (Evar _s_th_c_ps tint)
                                               tint) tint)
                                           (Ebinop Osub
                                             (Ebinop Oadd
                                               (Eval (Vint (Int.repr 14)) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 15)) tint)
                                             tint) tint) tint) tint))))))))))))))))))
|}.

Definition f_int32_quat_of_axis_angle := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) ::
                (_uv, (tptr (Tstruct _Int32Vect3 noattr))) ::
                (_angle, tint) :: nil);
  fn_vars := ((_san2, tint) :: (_can2, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _san2 tint)
         (Ecall
           (Evalof
             (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint cc_default))
             (Tfunction (tint :: nil) tint cc_default))
           (Econs
             (Ebinop Odiv (Evalof (Evar _angle tint) tint)
               (Eval (Vint (Int.repr 2)) tint) tint) Enil) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _can2 tint)
           (Ecall
             (Evalof
               (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                       cc_default))
               (Tfunction (tint :: nil) tint cc_default))
             (Econs
               (Ebinop Odiv (Evalof (Evar _angle tint) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint) Enil) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qi tint)
             (Ebinop Oshl (Evalof (Evar _can2 tint) tint)
               (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                 (Eval (Vint (Int.repr 14)) tint) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qx tint)
               (Ebinop Omul
                 (Ebinop Oshl (Evalof (Evar _san2 tint) tint)
                   (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _uv (tptr (Tstruct _Int32Vect3 noattr)))
                           (tptr (Tstruct _Int32Vect3 noattr)))
                         (Tstruct _Int32Vect3 noattr))
                       (Tstruct _Int32Vect3 noattr)) _x tint) tint) tint)
               tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint)
                 (Ebinop Omul
                   (Ebinop Oshl (Evalof (Evar _san2 tint) tint)
                     (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _uv (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _y tint) tint) tint)
                 tint))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint)
                 (Ebinop Omul
                   (Ebinop Oshl (Evalof (Evar _san2 tint) tint)
                     (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _uv (tptr (Tstruct _Int32Vect3 noattr)))
                             (tptr (Tstruct _Int32Vect3 noattr)))
                           (Tstruct _Int32Vect3 noattr))
                         (Tstruct _Int32Vect3 noattr)) _z tint) tint) tint)
                 tint)))))))
|}.

Definition f_int32_quat_of_rmat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) ::
                (_r, (tptr (Tstruct _Int32RMat noattr))) :: nil);
  fn_vars := ((_tr, tint) :: (_two_qi_two, tint) :: (_two_qi, tuint) ::
              (_two_qx_two, tint) :: (_two_qx, tuint) ::
              (_two_qy_two, tint) :: (_two_qy, tuint) ::
              (_two_qz_two, tint) :: (_two_qz, tuint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tr tint)
         (Ebinop Oadd
           (Ebinop Oadd
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint) (tptr tint)) tint)
               tint)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 1)) tint) tint) (tptr tint)) tint)
               tint) tint)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                           (tptr (Tstruct _Int32RMat noattr)))
                         (Tstruct _Int32RMat noattr))
                       (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                   (tarray tint 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) (tptr tint)) tint)
             tint) tint) tint))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _tr tint) tint)
                 (Eval (Vint (Int.repr 0)) tint) tint)
    (Ssequence
      (Sdo (Eassign (Evar _two_qi_two tint)
             (Ebinop Oadd
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tdouble)
               (Evalof (Evar _tr tint) tint) tdouble) tint))
      (Ssequence
        (Sdo (Eassign (Evar _two_qi tuint)
               (Ecall
                 (Evalof
                   (Evar _int32_sqrt (Tfunction (tuint :: nil) tuint
                                       cc_default))
                   (Tfunction (tuint :: nil) tuint cc_default))
                 (Econs
                   (Ebinop Oshl (Evalof (Evar _two_qi_two tint) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) Enil) tuint)
               tuint))
        (Ssequence
          (Sdo (Eassign (Evar _two_qi tuint)
                 (Ebinop Oshl (Evalof (Evar _two_qi tuint) tuint)
                   (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tuint) tuint))
          (Sifthenelse (Ebinop One (Evalof (Evar _two_qi tuint) tuint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint)
                     (Ebinop Odiv (Evalof (Evar _two_qi tuint) tuint)
                       (Eval (Vint (Int.repr 2)) tint) tuint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint)
                       (Ebinop Odiv
                         (Ebinop Oshl
                           (Ebinop Osub
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   (tptr tint)) tint) tint) tint)
                           (Ebinop Osub
                             (Ebinop Oadd
                               (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint) tint)
                         (Evalof (Evar _two_qi tuint) tuint) tuint) tint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint)
                         (Ebinop Odiv
                           (Ebinop Oshl
                             (Ebinop Osub
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Osub
                               (Ebinop Oadd
                                 (Ebinop Osub
                                   (Eval (Vint (Int.repr 15)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (Evalof (Evar _two_qi tuint) tuint) tuint) tint))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint)
                         (Ebinop Odiv
                           (Ebinop Oshl
                             (Ebinop Osub
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Osub
                               (Ebinop Oadd
                                 (Ebinop Osub
                                   (Eval (Vint (Int.repr 15)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (Evalof (Evar _two_qi tuint) tuint) tuint) tint)))))
            Sskip))))
    (Sifthenelse (Eseqand
                   (Ebinop Ogt
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                           (tptr tint)) tint) tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tint)) tint) tint) tint)
                   (Ebinop Ogt
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                           (tptr tint)) tint) tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tint)) tint) tint) tint) tint)
      (Ssequence
        (Sdo (Eassign (Evar _two_qx_two tint)
               (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Osub
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                           (tptr tint)) tint) tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tint)) tint) tint) tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 2)) tint) tint) (tptr tint))
                       tint) tint) tint)
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tdouble) tdouble)
               tint))
        (Ssequence
          (Sdo (Eassign (Evar _two_qx tuint)
                 (Ecall
                   (Evalof
                     (Evar _int32_sqrt (Tfunction (tuint :: nil) tuint
                                         cc_default))
                     (Tfunction (tuint :: nil) tuint cc_default))
                   (Econs
                     (Ebinop Oshl (Evalof (Evar _two_qx_two tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) Enil) tuint)
                 tuint))
          (Ssequence
            (Sdo (Eassign (Evar _two_qx tuint)
                   (Ebinop Oshl (Evalof (Evar _two_qx tuint) tuint)
                     (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tuint) tuint))
            (Sifthenelse (Ebinop One (Evalof (Evar _two_qx tuint) tuint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint)
                       (Ebinop Odiv
                         (Ebinop Oshl
                           (Ebinop Osub
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tint)) tint) tint)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                             (tptr (Tstruct _Int32RMat noattr)))
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   (tptr tint)) tint) tint) tint)
                           (Ebinop Osub
                             (Ebinop Oadd
                               (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint) tint)
                         (Evalof (Evar _two_qx tuint) tuint) tuint) tint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint)
                         (Ebinop Odiv (Evalof (Evar _two_qx tuint) tuint)
                           (Eval (Vint (Int.repr 2)) tint) tuint) tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qy tint)
                           (Ebinop Odiv
                             (Ebinop Oshl
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tint)) tint) tint)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tint) (tptr tint)) tint) tint) tint)
                               (Ebinop Osub
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Eval (Vint (Int.repr 15)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   (Eval (Vint (Int.repr 15)) tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint) tint)
                             (Evalof (Evar _two_qx tuint) tuint) tuint) tint))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qz tint)
                           (Ebinop Odiv
                             (Ebinop Oshl
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tint) (tptr tint)) tint) tint)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tint)) tint) tint) tint)
                               (Ebinop Osub
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Eval (Vint (Int.repr 15)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   (Eval (Vint (Int.repr 15)) tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint) tint)
                             (Evalof (Evar _two_qx tuint) tuint) tuint) tint)))))
              Sskip))))
      (Sifthenelse (Ebinop Ogt
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tint)) tint) tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tint)) tint) tint) tint)
        (Ssequence
          (Sdo (Eassign (Evar _two_qy_two tint)
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Osub
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (tptr tint)) tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 0)) tint) tint)
                             (tptr tint)) tint) tint) tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tint)) tint) tint) tint)
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tdouble)
                   tdouble) tint))
          (Ssequence
            (Sdo (Eassign (Evar _two_qy tuint)
                   (Ecall
                     (Evalof
                       (Evar _int32_sqrt (Tfunction (tuint :: nil) tuint
                                           cc_default))
                       (Tfunction (tuint :: nil) tuint cc_default))
                     (Econs
                       (Ebinop Oshl (Evalof (Evar _two_qy_two tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) Enil) tuint)
                   tuint))
            (Ssequence
              (Sdo (Eassign (Evar _two_qy tuint)
                     (Ebinop Oshl (Evalof (Evar _two_qy tuint) tuint)
                       (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tuint) tuint))
              (Sifthenelse (Ebinop One (Evalof (Evar _two_qy tuint) tuint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint)
                         (Ebinop Odiv
                           (Ebinop Oshl
                             (Ebinop Osub
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Osub
                               (Ebinop Oadd
                                 (Ebinop Osub
                                   (Eval (Vint (Int.repr 15)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (Evalof (Evar _two_qy tuint) tuint) tuint) tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qx tint)
                           (Ebinop Odiv
                             (Ebinop Oshl
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tint)) tint) tint)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tint) (tptr tint)) tint) tint) tint)
                               (Ebinop Osub
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Eval (Vint (Int.repr 15)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   (Eval (Vint (Int.repr 15)) tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint) tint)
                             (Evalof (Evar _two_qy tuint) tuint) tuint) tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qy tint)
                             (Ebinop Odiv (Evalof (Evar _two_qy tuint) tuint)
                               (Eval (Vint (Int.repr 2)) tint) tuint) tint))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qz tint)
                             (Ebinop Odiv
                               (Ebinop Oshl
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Eval (Vint (Int.repr 3)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 2)) tint)
                                           tint) (tptr tint)) tint) tint)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Eval (Vint (Int.repr 3)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 1)) tint)
                                           tint) (tptr tint)) tint) tint)
                                   tint)
                                 (Ebinop Osub
                                   (Ebinop Oadd
                                     (Ebinop Osub
                                       (Eval (Vint (Int.repr 15)) tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     (Eval (Vint (Int.repr 15)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 tint) (Evalof (Evar _two_qy tuint) tuint)
                               tuint) tint)))))
                Sskip))))
        (Ssequence
          (Sdo (Eassign (Evar _two_qz_two tint)
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Osub
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 2)) tint) tint)
                             (tptr tint)) tint) tint)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                       (tptr (Tstruct _Int32RMat noattr)))
                                     (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 0)) tint) tint)
                             (tptr tint)) tint) tint) tint)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tint)) tint) tint) tint)
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tdouble)
                   tdouble) tint))
          (Ssequence
            (Sdo (Eassign (Evar _two_qz tuint)
                   (Ecall
                     (Evalof
                       (Evar _int32_sqrt (Tfunction (tuint :: nil) tuint
                                           cc_default))
                       (Tfunction (tuint :: nil) tuint cc_default))
                     (Econs
                       (Ebinop Oshl (Evalof (Evar _two_qz_two tint) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) Enil) tuint)
                   tuint))
            (Ssequence
              (Sdo (Eassign (Evar _two_qz tuint)
                     (Ebinop Oshl (Evalof (Evar _two_qz tuint) tuint)
                       (Ebinop Osub (Eval (Vint (Int.repr 15)) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tuint) tuint))
              (Sifthenelse (Ebinop One (Evalof (Evar _two_qz tuint) tuint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint)
                         (Ebinop Odiv
                           (Ebinop Oshl
                             (Ebinop Osub
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (tptr tint)) tint) tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                               (tptr (Tstruct _Int32RMat noattr)))
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tint)) tint) tint) tint)
                             (Ebinop Osub
                               (Ebinop Oadd
                                 (Ebinop Osub
                                   (Eval (Vint (Int.repr 15)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (Evalof (Evar _two_qz tuint) tuint) tuint) tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qx tint)
                           (Ebinop Odiv
                             (Ebinop Oshl
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tint) (tptr tint)) tint) tint)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                 (tptr (Tstruct _Int32RMat noattr)))
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tint)) tint) tint) tint)
                               (Ebinop Osub
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Eval (Vint (Int.repr 15)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   (Eval (Vint (Int.repr 15)) tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint) tint)
                             (Evalof (Evar _two_qz tuint) tuint) tuint) tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qy tint)
                             (Ebinop Odiv
                               (Ebinop Oshl
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Eval (Vint (Int.repr 3)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 2)) tint)
                                           tint) (tptr tint)) tint) tint)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _r (tptr (Tstruct _Int32RMat noattr)))
                                                   (tptr (Tstruct _Int32RMat noattr)))
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (Eval (Vint (Int.repr 3)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 1)) tint)
                                           tint) (tptr tint)) tint) tint)
                                   tint)
                                 (Ebinop Osub
                                   (Ebinop Oadd
                                     (Ebinop Osub
                                       (Eval (Vint (Int.repr 15)) tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     (Eval (Vint (Int.repr 15)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 tint) (Evalof (Evar _two_qz tuint) tuint)
                               tuint) tint))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qz tint)
                             (Ebinop Odiv (Evalof (Evar _two_qz tuint) tuint)
                               (Eval (Vint (Int.repr 2)) tint) tuint) tint)))))
                Sskip))))))))
|}.

Definition f_int32_eulers_of_rmat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _Int32Eulers noattr))) ::
                (_rm, (tptr (Tstruct _Int32RMat noattr))) :: nil);
  fn_vars := ((_dcm00, tfloat) :: (_dcm01, tfloat) :: (_dcm02, tfloat) ::
              (_dcm12, tfloat) :: (_dcm22, tfloat) :: (_phi, tfloat) ::
              (_theta, tfloat) :: (_psi, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _dcm00 tfloat)
         (Ebinop Odiv
           (Ecast
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                   (tptr tint)) tint) tint) tfloat)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _dcm01 tfloat)
           (Ebinop Odiv
             (Ecast
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                               (tptr (Tstruct _Int32RMat noattr)))
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tint)) tint) tint) tfloat)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _dcm02 tfloat)
             (Ebinop Odiv
               (Ecast
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                 (tptr (Tstruct _Int32RMat noattr)))
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                       (tptr tint)) tint) tint) tfloat)
               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                 (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _dcm12 tfloat)
               (Ebinop Odiv
                 (Ecast
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                   (tptr (Tstruct _Int32RMat noattr)))
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 5)) tint) (tptr tint)) tint)
                     tint) tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _dcm22 tfloat)
                 (Ebinop Odiv
                   (Ecast
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _rm (tptr (Tstruct _Int32RMat noattr)))
                                     (tptr (Tstruct _Int32RMat noattr)))
                                   (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 8)) tint) (tptr tint)) tint)
                       tint) tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
          (Ssequence
            (Sifthenelse (Eunop Onotbool
                           (Ebinop Ogt (Evalof (Evar _dcm02 tfloat) tfloat)
                             (Eunop Oneg
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                               tdouble) tint) tint)
              (Sdo (Eassign (Evar _dcm02 tfloat)
                     (Eunop Oneg
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                       tdouble) tfloat))
              (Sifthenelse (Eunop Onotbool
                             (Ebinop Olt (Evalof (Evar _dcm02 tfloat) tfloat)
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                               tint) tint)
                (Sdo (Eassign (Evar _dcm02 tfloat)
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                       tfloat))
                Sskip))
            (Ssequence
              (Sdo (Eassign (Evar _phi tfloat)
                     (Ecall
                       (Evalof
                         (Evar _atan2f (Tfunction (tfloat :: tfloat :: nil)
                                         tfloat cc_default))
                         (Tfunction (tfloat :: tfloat :: nil) tfloat
                           cc_default))
                       (Econs (Evalof (Evar _dcm12 tfloat) tfloat)
                         (Econs (Evalof (Evar _dcm22 tfloat) tfloat) Enil))
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _theta tfloat)
                       (Eunop Oneg
                         (Ecall
                           (Evalof
                             (Evar _asinf (Tfunction (tfloat :: nil) tfloat
                                            cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _dcm02 tfloat) tfloat) Enil)
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _psi tfloat)
                         (Ecall
                           (Evalof
                             (Evar _atan2f (Tfunction
                                             (tfloat :: tfloat :: nil) tfloat
                                             cc_default))
                             (Tfunction (tfloat :: tfloat :: nil) tfloat
                               cc_default))
                           (Econs (Evalof (Evar _dcm01 tfloat) tfloat)
                             (Econs (Evalof (Evar _dcm00 tfloat) tfloat)
                               Enil)) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                   (tptr (Tstruct _Int32Eulers noattr)))
                                 (Tstruct _Int32Eulers noattr))
                               (Tstruct _Int32Eulers noattr)) _phi tint)
                           (Ebinop Omul (Evalof (Evar _phi tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                     (tptr (Tstruct _Int32Eulers noattr)))
                                   (Tstruct _Int32Eulers noattr))
                                 (Tstruct _Int32Eulers noattr)) _theta tint)
                             (Ebinop Omul
                               (Evalof (Evar _theta tfloat) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 12)) tint) tint)
                               tfloat) tint))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                     (tptr (Tstruct _Int32Eulers noattr)))
                                   (Tstruct _Int32Eulers noattr))
                                 (Tstruct _Int32Eulers noattr)) _psi tint)
                             (Ebinop Omul (Evalof (Evar _psi tfloat) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 12)) tint) tint)
                               tfloat) tint)))))))))))))
|}.

Definition f_int32_eulers_of_quat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _Int32Eulers noattr))) ::
                (_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := ((_qx2, tint) :: (_qy2, tint) :: (_qz2, tint) ::
              (_qiqx, tint) :: (_qiqy, tint) :: (_qiqz, tint) ::
              (_qxqy, tint) :: (_qxqz, tint) :: (_qyqz, tint) ::
              (_one, tint) :: (_two, tint) :: (_idcm00, tint) ::
              (_idcm01, tint) :: (_idcm02, tint) :: (_idcm12, tint) ::
              (_idcm22, tint) :: (_dcm00, tfloat) :: (_dcm01, tfloat) ::
              (_dcm02, tfloat) :: (_dcm12, tfloat) :: (_dcm22, tfloat) ::
              (_phi, tfloat) :: (_theta, tfloat) :: (_psi, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qx2 tint)
         (Ebinop Oshr
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qx tint) tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
           (Eval (Vint (Int.repr 15)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _qy2 tint)
           (Ebinop Oshr
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
             (Eval (Vint (Int.repr 15)) tint) tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _qz2 tint)
             (Ebinop Oshr
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)
               (Eval (Vint (Int.repr 15)) tint) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _qiqx tint)
               (Ebinop Oshr
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qx tint) tint) tint)
                 (Eval (Vint (Int.repr 15)) tint) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _qiqy tint)
                 (Ebinop Oshr
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                               (tptr (Tstruct _Int32Quat noattr)))
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qy tint) tint) tint)
                   (Eval (Vint (Int.repr 15)) tint) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar _qiqz tint)
                   (Ebinop Oshr
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                 (tptr (Tstruct _Int32Quat noattr)))
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
            (Ssequence
              (Sdo (Eassign (Evar _qxqy tint)
                     (Ebinop Oshr
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qx tint) tint)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                   (tptr (Tstruct _Int32Quat noattr)))
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qy tint) tint)
                         tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign (Evar _qxqz tint)
                       (Ebinop Oshr
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qx tint) tint)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                     (tptr (Tstruct _Int32Quat noattr)))
                                   (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qz tint) tint)
                           tint) (Eval (Vint (Int.repr 15)) tint) tint) tint))
                (Ssequence
                  (Sdo (Eassign (Evar _qyqz tint)
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qy tint)
                               tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                                       (tptr (Tstruct _Int32Quat noattr)))
                                     (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qz tint)
                               tint) tint) (Eval (Vint (Int.repr 15)) tint)
                           tint) tint))
                  (Ssequence
                    (Sdo (Eassign (Evar _one tint)
                           (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tint)
                           tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _two tint)
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint) tint)
                             tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _idcm00 tint)
                               (Ebinop Osub (Evalof (Evar _one tint) tint)
                                 (Ebinop Oshr
                                   (Ebinop Omul
                                     (Evalof (Evar _two tint) tint)
                                     (Ebinop Oadd
                                       (Evalof (Evar _qy2 tint) tint)
                                       (Evalof (Evar _qz2 tint) tint) tint)
                                     tint)
                                   (Ebinop Osub
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 14)) tint)
                                       (Eval (Vint (Int.repr 15)) tint) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tint) tint) tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _idcm01 tint)
                                 (Ebinop Oshr
                                   (Ebinop Omul
                                     (Evalof (Evar _two tint) tint)
                                     (Ebinop Oadd
                                       (Evalof (Evar _qxqy tint) tint)
                                       (Evalof (Evar _qiqz tint) tint) tint)
                                     tint)
                                   (Ebinop Osub
                                     (Ebinop Oadd
                                       (Eval (Vint (Int.repr 14)) tint)
                                       (Eval (Vint (Int.repr 15)) tint) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tint) tint))
                          (Ssequence
                            (Sdo (Eassign (Evar _idcm02 tint)
                                   (Ebinop Oshr
                                     (Ebinop Omul
                                       (Evalof (Evar _two tint) tint)
                                       (Ebinop Osub
                                         (Evalof (Evar _qxqz tint) tint)
                                         (Evalof (Evar _qiqy tint) tint)
                                         tint) tint)
                                     (Ebinop Osub
                                       (Ebinop Oadd
                                         (Eval (Vint (Int.repr 14)) tint)
                                         (Eval (Vint (Int.repr 15)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tint) tint))
                            (Ssequence
                              (Sdo (Eassign (Evar _idcm12 tint)
                                     (Ebinop Oshr
                                       (Ebinop Omul
                                         (Evalof (Evar _two tint) tint)
                                         (Ebinop Oadd
                                           (Evalof (Evar _qyqz tint) tint)
                                           (Evalof (Evar _qiqx tint) tint)
                                           tint) tint)
                                       (Ebinop Osub
                                         (Ebinop Oadd
                                           (Eval (Vint (Int.repr 14)) tint)
                                           (Eval (Vint (Int.repr 15)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tint) tint))
                              (Ssequence
                                (Sdo (Eassign (Evar _idcm22 tint)
                                       (Ebinop Osub
                                         (Evalof (Evar _one tint) tint)
                                         (Ebinop Oshr
                                           (Ebinop Omul
                                             (Evalof (Evar _two tint) tint)
                                             (Ebinop Oadd
                                               (Evalof (Evar _qx2 tint) tint)
                                               (Evalof (Evar _qy2 tint) tint)
                                               tint) tint)
                                           (Ebinop Osub
                                             (Ebinop Oadd
                                               (Eval (Vint (Int.repr 14)) tint)
                                               (Eval (Vint (Int.repr 15)) tint)
                                               tint)
                                             (Eval (Vint (Int.repr 14)) tint)
                                             tint) tint) tint) tint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _dcm00 tfloat)
                                         (Ebinop Odiv
                                           (Ecast
                                             (Evalof (Evar _idcm00 tint)
                                               tint) tfloat)
                                           (Ebinop Oshl
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Eval (Vint (Int.repr 14)) tint)
                                             tint) tfloat) tfloat))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _dcm01 tfloat)
                                           (Ebinop Odiv
                                             (Ecast
                                               (Evalof (Evar _idcm01 tint)
                                                 tint) tfloat)
                                             (Ebinop Oshl
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Eval (Vint (Int.repr 14)) tint)
                                               tint) tfloat) tfloat))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _dcm02 tfloat)
                                             (Ebinop Odiv
                                               (Ecast
                                                 (Evalof (Evar _idcm02 tint)
                                                   tint) tfloat)
                                               (Ebinop Oshl
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 (Eval (Vint (Int.repr 14)) tint)
                                                 tint) tfloat) tfloat))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _dcm12 tfloat)
                                               (Ebinop Odiv
                                                 (Ecast
                                                   (Evalof
                                                     (Evar _idcm12 tint)
                                                     tint) tfloat)
                                                 (Ebinop Oshl
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (Eval (Vint (Int.repr 14)) tint)
                                                   tint) tfloat) tfloat))
                                        (Ssequence
                                          (Sdo (Eassign (Evar _dcm22 tfloat)
                                                 (Ebinop Odiv
                                                   (Ecast
                                                     (Evalof
                                                       (Evar _idcm22 tint)
                                                       tint) tfloat)
                                                   (Ebinop Oshl
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Eval (Vint (Int.repr 14)) tint)
                                                     tint) tfloat) tfloat))
                                          (Ssequence
                                            (Sifthenelse (Eunop Onotbool
                                                           (Ebinop Ogt
                                                             (Evalof
                                                               (Evar _dcm02 tfloat)
                                                               tfloat)
                                                             (Eunop Oneg
                                                               (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                               tdouble) tint)
                                                           tint)
                                              (Sdo (Eassign
                                                     (Evar _dcm02 tfloat)
                                                     (Eunop Oneg
                                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                       tdouble) tfloat))
                                              (Sifthenelse (Eunop Onotbool
                                                             (Ebinop Olt
                                                               (Evalof
                                                                 (Evar _dcm02 tfloat)
                                                                 tfloat)
                                                               (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                               tint) tint)
                                                (Sdo (Eassign
                                                       (Evar _dcm02 tfloat)
                                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                       tfloat))
                                                Sskip))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _phi tfloat)
                                                     (Ecall
                                                       (Evalof
                                                         (Evar _atan2f 
                                                         (Tfunction
                                                           (tfloat ::
                                                            tfloat :: nil)
                                                           tfloat cc_default))
                                                         (Tfunction
                                                           (tfloat ::
                                                            tfloat :: nil)
                                                           tfloat cc_default))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _dcm12 tfloat)
                                                           tfloat)
                                                         (Econs
                                                           (Evalof
                                                             (Evar _dcm22 tfloat)
                                                             tfloat) Enil))
                                                       tfloat) tfloat))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _theta tfloat)
                                                       (Eunop Oneg
                                                         (Ecall
                                                           (Evalof
                                                             (Evar _asinf 
                                                             (Tfunction
                                                               (tfloat ::
                                                                nil) tfloat
                                                               cc_default))
                                                             (Tfunction
                                                               (tfloat ::
                                                                nil) tfloat
                                                               cc_default))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _dcm02 tfloat)
                                                               tfloat) Enil)
                                                           tfloat) tfloat)
                                                       tfloat))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _psi tfloat)
                                                         (Ecall
                                                           (Evalof
                                                             (Evar _atan2f 
                                                             (Tfunction
                                                               (tfloat ::
                                                                tfloat ::
                                                                nil) tfloat
                                                               cc_default))
                                                             (Tfunction
                                                               (tfloat ::
                                                                tfloat ::
                                                                nil) tfloat
                                                               cc_default))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _dcm01 tfloat)
                                                               tfloat)
                                                             (Econs
                                                               (Evalof
                                                                 (Evar _dcm00 tfloat)
                                                                 tfloat)
                                                               Enil)) tfloat)
                                                         tfloat))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Efield
                                                             (Evalof
                                                               (Ederef
                                                                 (Evalof
                                                                   (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                                                   (tptr (Tstruct _Int32Eulers noattr)))
                                                                 (Tstruct _Int32Eulers noattr))
                                                               (Tstruct _Int32Eulers noattr))
                                                             _phi tint)
                                                           (Ebinop Omul
                                                             (Evalof
                                                               (Evar _phi tfloat)
                                                               tfloat)
                                                             (Ebinop Oshl
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               (Eval (Vint (Int.repr 12)) tint)
                                                               tint) tfloat)
                                                           tint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                                                    (tptr (Tstruct _Int32Eulers noattr)))
                                                                   (Tstruct _Int32Eulers noattr))
                                                                 (Tstruct _Int32Eulers noattr))
                                                               _theta tint)
                                                             (Ebinop Omul
                                                               (Evalof
                                                                 (Evar _theta tfloat)
                                                                 tfloat)
                                                               (Ebinop Oshl
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 (Eval (Vint (Int.repr 12)) tint)
                                                                 tint)
                                                               tfloat) tint))
                                                      (Sdo (Eassign
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                                                                    (tptr (Tstruct _Int32Eulers noattr)))
                                                                   (Tstruct _Int32Eulers noattr))
                                                                 (Tstruct _Int32Eulers noattr))
                                                               _psi tint)
                                                             (Ebinop Omul
                                                               (Evalof
                                                                 (Evar _psi tfloat)
                                                                 tfloat)
                                                               (Ebinop Oshl
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 (Eval (Vint (Int.repr 12)) tint)
                                                                 tint)
                                                               tfloat) tint)))))))))))))))))))))))))))))
|}.

Definition f_int32_rates_of_eulers_dot_321 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_r, (tptr (Tstruct _Int32Rates noattr))) ::
                (_e, (tptr (Tstruct _Int32Eulers noattr))) ::
                (_ed, (tptr (Tstruct _Int32Eulers noattr))) :: nil);
  fn_vars := ((_sphi, tint) :: (_cphi, tint) :: (_stheta, tint) ::
              (_ctheta, tint) :: (_cphi_ctheta, tint) ::
              (_sphi_ctheta, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sphi tint)
         (Ecall
           (Evalof
             (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint cc_default))
             (Tfunction (tint :: nil) tint cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
           tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _cphi tint)
           (Ecall
             (Evalof
               (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                       cc_default))
               (Tfunction (tint :: nil) tint cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                         (tptr (Tstruct _Int32Eulers noattr)))
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
             tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _stheta tint)
             (Ecall
               (Evalof
                 (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                         cc_default))
                 (Tfunction (tint :: nil) tint cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                           (tptr (Tstruct _Int32Eulers noattr)))
                         (Tstruct _Int32Eulers noattr))
                       (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                 Enil) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tint)
               (Ecall
                 (Evalof
                   (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                           cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                   Enil) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _cphi_ctheta tint)
                 (Ebinop Oshr
                   (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                     (Evalof (Evar _ctheta tint) tint) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tint))
          (Ssequence
            (Sdo (Eassign (Evar _sphi_ctheta tint)
                   (Ebinop Oshr
                     (Ebinop Omul (Evalof (Evar _sphi tint) tint)
                       (Evalof (Evar _ctheta tint) tint) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tint))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint)
                     (Ebinop Oadd
                       (Eunop Oneg
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _stheta tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                       (tptr (Tstruct _Int32Eulers noattr)))
                                     (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _psi tint)
                               tint) tint) (Eval (Vint (Int.repr 14)) tint)
                           tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                 (tptr (Tstruct _Int32Eulers noattr)))
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _phi tint) tint)
                       tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint)
                       (Ebinop Oadd
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Evalof (Evar _sphi_ctheta tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                       (tptr (Tstruct _Int32Eulers noattr)))
                                     (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _psi tint)
                               tint) tint) (Eval (Vint (Int.repr 14)) tint)
                           tint)
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                       (tptr (Tstruct _Int32Eulers noattr)))
                                     (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _theta
                                 tint) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tint) tint))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint)
                       (Ebinop Osub
                         (Ebinop Oshr
                           (Ebinop Omul
                             (Evalof (Evar _cphi_ctheta tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                       (tptr (Tstruct _Int32Eulers noattr)))
                                     (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _psi tint)
                               tint) tint) (Eval (Vint (Int.repr 14)) tint)
                           tint)
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _sphi tint) tint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                       (tptr (Tstruct _Int32Eulers noattr)))
                                     (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _theta
                                 tint) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tint) tint))))))))))
|}.

Definition f_int32_eulers_dot_321_of_rates := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_ed, (tptr (Tstruct _Int32Eulers noattr))) ::
                (_e, (tptr (Tstruct _Int32Eulers noattr))) ::
                (_r, (tptr (Tstruct _Int32Rates noattr))) :: nil);
  fn_vars := ((_sphi, tint) :: (_cphi, tint) :: (_stheta, tint) ::
              (_ctheta, tlong) :: (_cphi_stheta, tlong) ::
              (_sphi_stheta, tlong) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sphi tint)
         (Ecall
           (Evalof
             (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint cc_default))
             (Tfunction (tint :: nil) tint cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
           tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _cphi tint)
           (Ecall
             (Evalof
               (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                       cc_default))
               (Tfunction (tint :: nil) tint cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                         (tptr (Tstruct _Int32Eulers noattr)))
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _phi tint) tint) Enil)
             tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _stheta tint)
             (Ecall
               (Evalof
                 (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                         cc_default))
                 (Tfunction (tint :: nil) tint cc_default))
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                           (tptr (Tstruct _Int32Eulers noattr)))
                         (Tstruct _Int32Eulers noattr))
                       (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                 Enil) tint) tint))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tlong)
               (Ecall
                 (Evalof
                   (Evar _pprz_itrig_cos (Tfunction (tint :: nil) tint
                                           cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _e (tptr (Tstruct _Int32Eulers noattr)))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                   Enil) tint) tlong))
        (Sifthenelse (Ebinop One (Evalof (Evar _ctheta tlong) tlong)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Ssequence
            (Sdo (Eassign (Evar _cphi_stheta tlong)
                   (Ebinop Oshr
                     (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                       (Evalof (Evar _stheta tint) tint) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tlong))
            (Ssequence
              (Sdo (Eassign (Evar _sphi_stheta tlong)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _sphi tint) tint)
                         (Evalof (Evar _stheta tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tlong))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                               (tptr (Tstruct _Int32Eulers noattr)))
                             (Tstruct _Int32Eulers noattr))
                           (Tstruct _Int32Eulers noattr)) _phi tint)
                       (Ebinop Oadd
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                     (tptr (Tstruct _Int32Rates noattr)))
                                   (Tstruct _Int32Rates noattr))
                                 (Tstruct _Int32Rates noattr)) _p tint) tint)
                           (Ecast
                             (Ebinop Odiv
                               (Ebinop Omul
                                 (Evalof (Evar _sphi_stheta tlong) tlong)
                                 (Ecast
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                             (tptr (Tstruct _Int32Rates noattr)))
                                           (Tstruct _Int32Rates noattr))
                                         (Tstruct _Int32Rates noattr)) _q
                                       tint) tint) tlong) tlong)
                               (Evalof (Evar _ctheta tlong) tlong) tlong)
                             tint) tint)
                         (Ecast
                           (Ebinop Odiv
                             (Ebinop Omul
                               (Evalof (Evar _cphi_stheta tlong) tlong)
                               (Ecast
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                           (tptr (Tstruct _Int32Rates noattr)))
                                         (Tstruct _Int32Rates noattr))
                                       (Tstruct _Int32Rates noattr)) _r tint)
                                   tint) tlong) tlong)
                             (Evalof (Evar _ctheta tlong) tlong) tlong) tint)
                         tint) tint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                 (tptr (Tstruct _Int32Eulers noattr)))
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _theta tint)
                         (Ebinop Osub
                           (Ebinop Oshr
                             (Ebinop Omul (Evalof (Evar _cphi tint) tint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                         (tptr (Tstruct _Int32Rates noattr)))
                                       (Tstruct _Int32Rates noattr))
                                     (Tstruct _Int32Rates noattr)) _q tint)
                                 tint) tint) (Eval (Vint (Int.repr 14)) tint)
                             tint)
                           (Ebinop Oshr
                             (Ebinop Omul (Evalof (Evar _sphi tint) tint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                         (tptr (Tstruct _Int32Rates noattr)))
                                       (Tstruct _Int32Rates noattr))
                                     (Tstruct _Int32Rates noattr)) _r tint)
                                 tint) tint) (Eval (Vint (Int.repr 14)) tint)
                             tint) tint) tint))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                                 (tptr (Tstruct _Int32Eulers noattr)))
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _psi tint)
                         (Ebinop Oadd
                           (Ecast
                             (Ebinop Odiv
                               (Ebinop Omul
                                 (Ecast (Evalof (Evar _sphi tint) tint)
                                   tlong)
                                 (Ecast
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                             (tptr (Tstruct _Int32Rates noattr)))
                                           (Tstruct _Int32Rates noattr))
                                         (Tstruct _Int32Rates noattr)) _q
                                       tint) tint) tlong) tlong)
                               (Evalof (Evar _ctheta tlong) tlong) tlong)
                             tint)
                           (Ecast
                             (Ebinop Odiv
                               (Ebinop Omul
                                 (Ecast (Evalof (Evar _cphi tint) tint)
                                   tlong)
                                 (Ecast
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _r (tptr (Tstruct _Int32Rates noattr)))
                                             (tptr (Tstruct _Int32Rates noattr)))
                                           (Tstruct _Int32Rates noattr))
                                         (Tstruct _Int32Rates noattr)) _r
                                       tint) tint) tlong) tlong)
                               (Evalof (Evar _ctheta tlong) tlong) tlong)
                             tint) tint) tint))))))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                           (tptr (Tstruct _Int32Eulers noattr)))
                         (Tstruct _Int32Eulers noattr))
                       (Tstruct _Int32Eulers noattr)) _phi tint)
                   (Eval (Vint (Int.repr 0)) tint) tint))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _theta tint)
                     (Eval (Vint (Int.repr 0)) tint) tint))
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ed (tptr (Tstruct _Int32Eulers noattr)))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _psi tint)
                     (Eval (Vint (Int.repr 0)) tint) tint)))))))))
|}.

Definition v_five_keep_int32_sqrt := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_sqrt (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_gcd := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_gcd (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_comp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_comp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_comp_inv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_comp_inv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_transp_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_transp_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_ratemult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_ratemult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_transp_ratemult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_transp_ratemult (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_of_quat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_of_quat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_of_eulers_321 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_of_eulers_321 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rmat_of_eulers_312 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rmat_of_eulers_312 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_comp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_comp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_comp_inv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_comp_inv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_inv_comp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_inv_comp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_comp_norm_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_comp_norm_shortest (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_comp_inv_norm_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_comp_inv_norm_shortest (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_inv_comp_norm_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_inv_comp_norm_shortest (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_derivative := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_derivative (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_integrate_fi := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_integrate_fi (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_of_eulers := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_of_eulers (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_of_axis_angle := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_of_axis_angle (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_quat_of_rmat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_quat_of_rmat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_eulers_of_rmat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_eulers_of_rmat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_eulers_of_quat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_eulers_of_quat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_rates_of_eulers_dot_321 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_rates_of_eulers_dot_321 (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_eulers_dot_321_of_rates := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_eulers_dot_321_of_rates (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite __1176 Struct
   (Member_plain _quot tlong :: Member_plain _rem tlong :: nil)
   noattr ::
 Composite _Int32Vect3 Struct
   (Member_plain _x tint :: Member_plain _y tint :: Member_plain _z tint ::
    nil)
   noattr ::
 Composite _Int32Quat Struct
   (Member_plain _qi tint :: Member_plain _qx tint ::
    Member_plain _qy tint :: Member_plain _qz tint :: nil)
   noattr ::
 Composite _Int64Quat Struct
   (Member_plain _qi tlong :: Member_plain _qx tlong ::
    Member_plain _qy tlong :: Member_plain _qz tlong :: nil)
   noattr ::
 Composite _Int32Eulers Struct
   (Member_plain _phi tint :: Member_plain _theta tint ::
    Member_plain _psi tint :: nil)
   noattr ::
 Composite _Int32RMat Struct (Member_plain _m (tarray tint 9) :: nil) noattr ::
 Composite _Int32Rates Struct
   (Member_plain _p tint :: Member_plain _q tint :: Member_plain _r tint ::
    nil)
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
 (_asinf,
   Gfun(External (EF_external "asinf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_atan2f,
   Gfun(External (EF_external "atan2f"
                   (mksignature (AST.Xsingle :: AST.Xsingle :: nil)
                     AST.Xsingle cc_default)) (tfloat :: tfloat :: nil)
     tfloat cc_default)) ::
 (_pprz_itrig_sin,
   Gfun(External (EF_external "pprz_itrig_sin"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tint :: nil) tint cc_default)) ::
 (_pprz_itrig_cos,
   Gfun(External (EF_external "pprz_itrig_cos"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tint :: nil) tint cc_default)) ::
 (_lldiv,
   Gfun(External (EF_external "lldiv"
                   (mksignature (AST.Xptr :: AST.Xlong :: AST.Xlong :: nil)
                     AST.Xvoid
                     {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|}))
     ((tptr (Tstruct __1176 noattr)) :: tlong :: tlong :: nil) tvoid
     {|cc_vararg:=None; cc_unproto:=false; cc_structret:=true|})) ::
 (_int32_quat_norm, Gfun(Internal f_int32_quat_norm)) ::
 (_int32_quat_wrap_shortest, Gfun(Internal f_int32_quat_wrap_shortest)) ::
 (_int32_quat_normalize, Gfun(Internal f_int32_quat_normalize)) ::
 (_int32_sqrt, Gfun(Internal f_int32_sqrt)) ::
 (_int32_gcd, Gfun(Internal f_int32_gcd)) ::
 (_int32_rmat_comp, Gfun(Internal f_int32_rmat_comp)) ::
 (_int32_rmat_comp_inv, Gfun(Internal f_int32_rmat_comp_inv)) ::
 (_int32_rmat_vmult, Gfun(Internal f_int32_rmat_vmult)) ::
 (_int32_rmat_transp_vmult, Gfun(Internal f_int32_rmat_transp_vmult)) ::
 (_int32_rmat_ratemult, Gfun(Internal f_int32_rmat_ratemult)) ::
 (_int32_rmat_transp_ratemult, Gfun(Internal f_int32_rmat_transp_ratemult)) ::
 (_int32_rmat_of_quat, Gfun(Internal f_int32_rmat_of_quat)) ::
 (_int32_rmat_of_eulers_321, Gfun(Internal f_int32_rmat_of_eulers_321)) ::
 (_int32_rmat_of_eulers_312, Gfun(Internal f_int32_rmat_of_eulers_312)) ::
 (_int32_quat_comp, Gfun(Internal f_int32_quat_comp)) ::
 (_int32_quat_comp_inv, Gfun(Internal f_int32_quat_comp_inv)) ::
 (_int32_quat_inv_comp, Gfun(Internal f_int32_quat_inv_comp)) ::
 (_int32_quat_comp_norm_shortest, Gfun(Internal f_int32_quat_comp_norm_shortest)) ::
 (_int32_quat_comp_inv_norm_shortest, Gfun(Internal f_int32_quat_comp_inv_norm_shortest)) ::
 (_int32_quat_inv_comp_norm_shortest, Gfun(Internal f_int32_quat_inv_comp_norm_shortest)) ::
 (_int32_quat_derivative, Gfun(Internal f_int32_quat_derivative)) ::
 (_int32_quat_integrate_fi, Gfun(Internal f_int32_quat_integrate_fi)) ::
 (_int32_quat_vmult, Gfun(Internal f_int32_quat_vmult)) ::
 (_int32_quat_of_eulers, Gfun(Internal f_int32_quat_of_eulers)) ::
 (_int32_quat_of_axis_angle, Gfun(Internal f_int32_quat_of_axis_angle)) ::
 (_int32_quat_of_rmat, Gfun(Internal f_int32_quat_of_rmat)) ::
 (_int32_eulers_of_rmat, Gfun(Internal f_int32_eulers_of_rmat)) ::
 (_int32_eulers_of_quat, Gfun(Internal f_int32_eulers_of_quat)) ::
 (_int32_rates_of_eulers_dot_321, Gfun(Internal f_int32_rates_of_eulers_dot_321)) ::
 (_int32_eulers_dot_321_of_rates, Gfun(Internal f_int32_eulers_dot_321_of_rates)) ::
 (_five_keep_int32_sqrt, Gvar v_five_keep_int32_sqrt) ::
 (_five_keep_int32_gcd, Gvar v_five_keep_int32_gcd) ::
 (_five_keep_int32_rmat_comp, Gvar v_five_keep_int32_rmat_comp) ::
 (_five_keep_int32_rmat_comp_inv, Gvar v_five_keep_int32_rmat_comp_inv) ::
 (_five_keep_int32_rmat_vmult, Gvar v_five_keep_int32_rmat_vmult) ::
 (_five_keep_int32_rmat_transp_vmult, Gvar v_five_keep_int32_rmat_transp_vmult) ::
 (_five_keep_int32_rmat_ratemult, Gvar v_five_keep_int32_rmat_ratemult) ::
 (_five_keep_int32_rmat_transp_ratemult, Gvar v_five_keep_int32_rmat_transp_ratemult) ::
 (_five_keep_int32_rmat_of_quat, Gvar v_five_keep_int32_rmat_of_quat) ::
 (_five_keep_int32_rmat_of_eulers_321, Gvar v_five_keep_int32_rmat_of_eulers_321) ::
 (_five_keep_int32_rmat_of_eulers_312, Gvar v_five_keep_int32_rmat_of_eulers_312) ::
 (_five_keep_int32_quat_comp, Gvar v_five_keep_int32_quat_comp) ::
 (_five_keep_int32_quat_comp_inv, Gvar v_five_keep_int32_quat_comp_inv) ::
 (_five_keep_int32_quat_inv_comp, Gvar v_five_keep_int32_quat_inv_comp) ::
 (_five_keep_int32_quat_comp_norm_shortest, Gvar v_five_keep_int32_quat_comp_norm_shortest) ::
 (_five_keep_int32_quat_comp_inv_norm_shortest, Gvar v_five_keep_int32_quat_comp_inv_norm_shortest) ::
 (_five_keep_int32_quat_inv_comp_norm_shortest, Gvar v_five_keep_int32_quat_inv_comp_norm_shortest) ::
 (_five_keep_int32_quat_derivative, Gvar v_five_keep_int32_quat_derivative) ::
 (_five_keep_int32_quat_integrate_fi, Gvar v_five_keep_int32_quat_integrate_fi) ::
 (_five_keep_int32_quat_vmult, Gvar v_five_keep_int32_quat_vmult) ::
 (_five_keep_int32_quat_of_eulers, Gvar v_five_keep_int32_quat_of_eulers) ::
 (_five_keep_int32_quat_of_axis_angle, Gvar v_five_keep_int32_quat_of_axis_angle) ::
 (_five_keep_int32_quat_of_rmat, Gvar v_five_keep_int32_quat_of_rmat) ::
 (_five_keep_int32_eulers_of_rmat, Gvar v_five_keep_int32_eulers_of_rmat) ::
 (_five_keep_int32_eulers_of_quat, Gvar v_five_keep_int32_eulers_of_quat) ::
 (_five_keep_int32_rates_of_eulers_dot_321, Gvar v_five_keep_int32_rates_of_eulers_dot_321) ::
 (_five_keep_int32_eulers_dot_321_of_rates, Gvar v_five_keep_int32_eulers_dot_321_of_rates) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_int32_eulers_dot_321_of_rates ::
 _five_keep_int32_rates_of_eulers_dot_321 ::
 _five_keep_int32_eulers_of_quat :: _five_keep_int32_eulers_of_rmat ::
 _five_keep_int32_quat_of_rmat :: _five_keep_int32_quat_of_axis_angle ::
 _five_keep_int32_quat_of_eulers :: _five_keep_int32_quat_vmult ::
 _five_keep_int32_quat_integrate_fi :: _five_keep_int32_quat_derivative ::
 _five_keep_int32_quat_inv_comp_norm_shortest ::
 _five_keep_int32_quat_comp_inv_norm_shortest ::
 _five_keep_int32_quat_comp_norm_shortest ::
 _five_keep_int32_quat_inv_comp :: _five_keep_int32_quat_comp_inv ::
 _five_keep_int32_quat_comp :: _five_keep_int32_rmat_of_eulers_312 ::
 _five_keep_int32_rmat_of_eulers_321 :: _five_keep_int32_rmat_of_quat ::
 _five_keep_int32_rmat_transp_ratemult :: _five_keep_int32_rmat_ratemult ::
 _five_keep_int32_rmat_transp_vmult :: _five_keep_int32_rmat_vmult ::
 _five_keep_int32_rmat_comp_inv :: _five_keep_int32_rmat_comp ::
 _five_keep_int32_gcd :: _five_keep_int32_sqrt ::
 _int32_eulers_dot_321_of_rates :: _int32_rates_of_eulers_dot_321 ::
 _int32_eulers_of_quat :: _int32_eulers_of_rmat :: _int32_quat_of_rmat ::
 _int32_quat_of_axis_angle :: _int32_quat_of_eulers :: _int32_quat_vmult ::
 _int32_quat_integrate_fi :: _int32_quat_derivative ::
 _int32_quat_inv_comp_norm_shortest :: _int32_quat_comp_inv_norm_shortest ::
 _int32_quat_comp_norm_shortest :: _int32_quat_inv_comp ::
 _int32_quat_comp_inv :: _int32_quat_comp :: _int32_rmat_of_eulers_312 ::
 _int32_rmat_of_eulers_321 :: _int32_rmat_of_quat ::
 _int32_rmat_transp_ratemult :: _int32_rmat_ratemult ::
 _int32_rmat_transp_vmult :: _int32_rmat_vmult :: _int32_rmat_comp_inv ::
 _int32_rmat_comp :: _int32_gcd :: _int32_sqrt :: _lldiv ::
 _pprz_itrig_cos :: _pprz_itrig_sin :: _atan2f :: _asinf ::
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


