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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/model/preprocessed.i".
End Info.

Definition _FloatEulers : ident := $"FloatEulers".
Definition _FloatQuat : ident := $"FloatQuat".
Definition _FloatRMat : ident := $"FloatRMat".
Definition _FloatRates : ident := $"FloatRates".
Definition _FloatVect2 : ident := $"FloatVect2".
Definition _FloatVect3 : ident := $"FloatVect3".
Definition _K_LAGRANGE : ident := $"K_LAGRANGE".
Definition _R_tdt : ident := $"R_tdt".
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
Definition _a : ident := $"a".
Definition _a2_1 : ident := $"a2_1".
Definition _a2b : ident := $"a2b".
Definition _a2c : ident := $"a2c".
Definition _ab : ident := $"ab".
Definition _ac : ident := $"ac".
Definition _ad : ident := $"ad".
Definition _adjOut : ident := $"adjOut".
Definition _angle : ident := $"angle".
Definition _asinf : ident := $"asinf".
Definition _atan2f : ident := $"atan2f".
Definition _axis : ident := $"axis".
Definition _b2c : ident := $"b2c".
Definition _bc : ident := $"bc".
Definition _bd : ident := $"bd".
Definition _bound : ident := $"bound".
Definition _c : ident := $"c".
Definition _c0 : ident := $"c0".
Definition _c1 : ident := $"c1".
Definition _c2 : ident := $"c2".
Definition _c_phi2 : ident := $"c_phi2".
Definition _c_psi2 : ident := $"c_psi2".
Definition _c_theta2 : ident := $"c_theta2".
Definition _ca : ident := $"ca".
Definition _can : ident := $"can".
Definition _cd : ident := $"cd".
Definition _cos : ident := $"cos".
Definition _cosf : ident := $"cosf".
Definition _cphi : ident := $"cphi".
Definition _cpsi : ident := $"cpsi".
Definition _ctheta : ident := $"ctheta".
Definition _dcm00 : ident := $"dcm00".
Definition _dcm01 : ident := $"dcm01".
Definition _dcm02 : ident := $"dcm02".
Definition _dcm12 : ident := $"dcm12".
Definition _dcm22 : ident := $"dcm22".
Definition _det : ident := $"det".
Definition _dp : ident := $"dp".
Definition _dq : ident := $"dq".
Definition _dr : ident := $"dr".
Definition _dt : ident := $"dt".
Definition _e : ident := $"e".
Definition _edot : ident := $"edot".
Definition _exp_omega_dt : ident := $"exp_omega_dt".
Definition _fabsf : ident := $"fabsf".
Definition _five_keep_float_eulers_of_quat_yxz : ident := $"five_keep_float_eulers_of_quat_yxz".
Definition _five_keep_float_eulers_of_quat_zxy : ident := $"five_keep_float_eulers_of_quat_zxy".
Definition _five_keep_float_eulers_of_rmat : ident := $"five_keep_float_eulers_of_rmat".
Definition _five_keep_float_mat2_mult : ident := $"five_keep_float_mat2_mult".
Definition _five_keep_float_mat3_mult : ident := $"five_keep_float_mat3_mult".
Definition _five_keep_float_mat_adjoint_4d : ident := $"five_keep_float_mat_adjoint_4d".
Definition _five_keep_float_mat_det_4d : ident := $"five_keep_float_mat_det_4d".
Definition _five_keep_float_mat_inv_4d : ident := $"five_keep_float_mat_inv_4d".
Definition _five_keep_float_mat_minor_4d : ident := $"five_keep_float_mat_minor_4d".
Definition _five_keep_float_quat_comp_inv : ident := $"five_keep_float_quat_comp_inv".
Definition _five_keep_float_quat_comp_inv_norm_shortest : ident := $"five_keep_float_quat_comp_inv_norm_shortest".
Definition _five_keep_float_quat_comp_norm_shortest : ident := $"five_keep_float_quat_comp_norm_shortest".
Definition _five_keep_float_quat_derivative : ident := $"five_keep_float_quat_derivative".
Definition _five_keep_float_quat_derivative_lagrange : ident := $"five_keep_float_quat_derivative_lagrange".
Definition _five_keep_float_quat_differential : ident := $"five_keep_float_quat_differential".
Definition _five_keep_float_quat_integrate : ident := $"five_keep_float_quat_integrate".
Definition _five_keep_float_quat_integrate_fi : ident := $"five_keep_float_quat_integrate_fi".
Definition _five_keep_float_quat_inv_comp : ident := $"five_keep_float_quat_inv_comp".
Definition _five_keep_float_quat_inv_comp_norm_shortest : ident := $"five_keep_float_quat_inv_comp_norm_shortest".
Definition _five_keep_float_quat_of_axis_angle : ident := $"five_keep_float_quat_of_axis_angle".
Definition _five_keep_float_quat_of_eulers : ident := $"five_keep_float_quat_of_eulers".
Definition _five_keep_float_quat_of_eulers_yxz : ident := $"five_keep_float_quat_of_eulers_yxz".
Definition _five_keep_float_quat_of_eulers_zxy : ident := $"five_keep_float_quat_of_eulers_zxy".
Definition _five_keep_float_quat_of_orientation_vect : ident := $"five_keep_float_quat_of_orientation_vect".
Definition _five_keep_float_quat_of_rmat : ident := $"five_keep_float_quat_of_rmat".
Definition _five_keep_float_quat_tilt_twist : ident := $"five_keep_float_quat_tilt_twist".
Definition _five_keep_float_rates_integrate_fi : ident := $"five_keep_float_rates_integrate_fi".
Definition _five_keep_float_rates_of_euler_dot : ident := $"five_keep_float_rates_of_euler_dot".
Definition _five_keep_float_rates_vect3_integrate_fi : ident := $"five_keep_float_rates_vect3_integrate_fi".
Definition _five_keep_float_rmat_comp_inv : ident := $"five_keep_float_rmat_comp_inv".
Definition _five_keep_float_rmat_integrate_fi : ident := $"five_keep_float_rmat_integrate_fi".
Definition _five_keep_float_rmat_inv : ident := $"five_keep_float_rmat_inv".
Definition _five_keep_float_rmat_mult : ident := $"five_keep_float_rmat_mult".
Definition _five_keep_float_rmat_norm : ident := $"five_keep_float_rmat_norm".
Definition _five_keep_float_rmat_of_axis_angle : ident := $"five_keep_float_rmat_of_axis_angle".
Definition _five_keep_float_rmat_of_eulers_312 : ident := $"five_keep_float_rmat_of_eulers_312".
Definition _five_keep_float_rmat_of_quat : ident := $"five_keep_float_rmat_of_quat".
Definition _five_keep_float_rmat_ratemult : ident := $"five_keep_float_rmat_ratemult".
Definition _five_keep_float_rmat_transp_mult : ident := $"five_keep_float_rmat_transp_mult".
Definition _five_keep_float_rmat_transp_ratemult : ident := $"five_keep_float_rmat_transp_ratemult".
Definition _five_keep_float_rmat_transp_vmult : ident := $"five_keep_float_rmat_transp_vmult".
Definition _five_keep_float_vect2_bound_in_2d : ident := $"five_keep_float_vect2_bound_in_2d".
Definition _five_keep_float_vect2_scale_in_2d : ident := $"five_keep_float_vect2_scale_in_2d".
Definition _five_keep_float_vect3_bound_in_2d : ident := $"five_keep_float_vect3_bound_in_2d".
Definition _five_keep_float_vect3_bound_in_3d : ident := $"five_keep_float_vect3_bound_in_3d".
Definition _five_keep_float_vect3_scale_in_2d : ident := $"five_keep_float_vect3_scale_in_2d".
Definition _five_keep_renorm_factor : ident := $"five_keep_renorm_factor".
Definition _float_eulers_of_quat_yxz : ident := $"float_eulers_of_quat_yxz".
Definition _float_eulers_of_quat_zxy : ident := $"float_eulers_of_quat_zxy".
Definition _float_eulers_of_rmat : ident := $"float_eulers_of_rmat".
Definition _float_mat2_mult : ident := $"float_mat2_mult".
Definition _float_mat3_mult : ident := $"float_mat3_mult".
Definition _float_mat_adjoint_4d : ident := $"float_mat_adjoint_4d".
Definition _float_mat_det_4d : ident := $"float_mat_det_4d".
Definition _float_mat_inv_4d : ident := $"float_mat_inv_4d".
Definition _float_mat_minor_4d : ident := $"float_mat_minor_4d".
Definition _float_quat_comp : ident := $"float_quat_comp".
Definition _float_quat_comp_inv : ident := $"float_quat_comp_inv".
Definition _float_quat_comp_inv_norm_shortest : ident := $"float_quat_comp_inv_norm_shortest".
Definition _float_quat_comp_norm_shortest : ident := $"float_quat_comp_norm_shortest".
Definition _float_quat_derivative : ident := $"float_quat_derivative".
Definition _float_quat_derivative_lagrange : ident := $"float_quat_derivative_lagrange".
Definition _float_quat_differential : ident := $"float_quat_differential".
Definition _float_quat_integrate : ident := $"float_quat_integrate".
Definition _float_quat_integrate_fi : ident := $"float_quat_integrate_fi".
Definition _float_quat_inv_comp : ident := $"float_quat_inv_comp".
Definition _float_quat_inv_comp_norm_shortest : ident := $"float_quat_inv_comp_norm_shortest".
Definition _float_quat_invert : ident := $"float_quat_invert".
Definition _float_quat_norm : ident := $"float_quat_norm".
Definition _float_quat_normalize : ident := $"float_quat_normalize".
Definition _float_quat_of_axis_angle : ident := $"float_quat_of_axis_angle".
Definition _float_quat_of_eulers : ident := $"float_quat_of_eulers".
Definition _float_quat_of_eulers_yxz : ident := $"float_quat_of_eulers_yxz".
Definition _float_quat_of_eulers_zxy : ident := $"float_quat_of_eulers_zxy".
Definition _float_quat_of_orientation_vect : ident := $"float_quat_of_orientation_vect".
Definition _float_quat_of_rmat : ident := $"float_quat_of_rmat".
Definition _float_quat_tilt_twist : ident := $"float_quat_tilt_twist".
Definition _float_quat_vmult : ident := $"float_quat_vmult".
Definition _float_quat_wrap_shortest : ident := $"float_quat_wrap_shortest".
Definition _float_rates_integrate_fi : ident := $"float_rates_integrate_fi".
Definition _float_rates_of_euler_dot : ident := $"float_rates_of_euler_dot".
Definition _float_rates_vect3_integrate_fi : ident := $"float_rates_vect3_integrate_fi".
Definition _float_rmat_comp : ident := $"float_rmat_comp".
Definition _float_rmat_comp_inv : ident := $"float_rmat_comp_inv".
Definition _float_rmat_integrate_fi : ident := $"float_rmat_integrate_fi".
Definition _float_rmat_inv : ident := $"float_rmat_inv".
Definition _float_rmat_mult : ident := $"float_rmat_mult".
Definition _float_rmat_norm : ident := $"float_rmat_norm".
Definition _float_rmat_of_axis_angle : ident := $"float_rmat_of_axis_angle".
Definition _float_rmat_of_eulers_312 : ident := $"float_rmat_of_eulers_312".
Definition _float_rmat_of_quat : ident := $"float_rmat_of_quat".
Definition _float_rmat_ratemult : ident := $"float_rmat_ratemult".
Definition _float_rmat_transp_mult : ident := $"float_rmat_transp_mult".
Definition _float_rmat_transp_ratemult : ident := $"float_rmat_transp_ratemult".
Definition _float_rmat_transp_vmult : ident := $"float_rmat_transp_vmult".
Definition _float_vect2_bound_in_2d : ident := $"float_vect2_bound_in_2d".
Definition _float_vect2_scale_in_2d : ident := $"float_vect2_scale_in_2d".
Definition _float_vect3_bound_in_2d : ident := $"float_vect3_bound_in_2d".
Definition _float_vect3_bound_in_3d : ident := $"float_vect3_bound_in_3d".
Definition _float_vect3_scale_in_2d : ident := $"float_vect3_scale_in_2d".
Definition _four_qi : ident := $"four_qi".
Definition _four_qx : ident := $"four_qx".
Definition _four_qy : ident := $"four_qy".
Definition _four_qz : ident := $"four_qz".
Definition _i : ident := $"i".
Definition _invOut : ident := $"invOut".
Definition _inv_det : ident := $"inv_det".
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
Definition _mat : ident := $"mat".
Definition _mat_in : ident := $"mat_in".
Definition _memcpy : ident := $"memcpy".
Definition _n : ident := $"n".
Definition _no : ident := $"no".
Definition _norm : ident := $"norm".
Definition _norm_des : ident := $"norm_des".
Definition _omega : ident := $"omega".
Definition _one_m_can : ident := $"one_m_can".
Definition _ov : ident := $"ov".
Definition _ov_norm : ident := $"ov_norm".
Definition _p : ident := $"p".
Definition _phi : ident := $"phi".
Definition _phi2 : ident := $"phi2".
Definition _psi : ident := $"psi".
Definition _psi2 : ident := $"psi2".
Definition _q : ident := $"q".
Definition _q_out : ident := $"q_out".
Definition _qd : ident := $"qd".
Definition _qi : ident := $"qi".
Definition _qi2 : ident := $"qi2".
Definition _qi2_M1_2 : ident := $"qi2_M1_2".
Definition _qinv : ident := $"qinv".
Definition _qiqx : ident := $"qiqx".
Definition _qiqy : ident := $"qiqy".
Definition _qiqz : ident := $"qiqz".
Definition _qnorm : ident := $"qnorm".
Definition _qo : ident := $"qo".
Definition _quat : ident := $"quat".
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
Definition _r0 : ident := $"r0".
Definition _r1 : ident := $"r1".
Definition _r11 : ident := $"r11".
Definition _r12 : ident := $"r12".
Definition _r2 : ident := $"r2".
Definition _r21 : ident := $"r21".
Definition _r31 : ident := $"r31".
Definition _r32 : ident := $"r32".
Definition _ra : ident := $"ra".
Definition _rb : ident := $"rb".
Definition _renorm_factor : ident := $"renorm_factor".
Definition _rm : ident := $"rm".
Definition _s2 : ident := $"s2".
Definition _s2_normalized : ident := $"s2_normalized".
Definition _s_phi2 : ident := $"s_phi2".
Definition _s_psi2 : ident := $"s_psi2".
Definition _s_theta2 : ident := $"s_theta2".
Definition _sa_ov_no : ident := $"sa_ov_no".
Definition _san : ident := $"san".
Definition _scale : ident := $"scale".
Definition _sin : ident := $"sin".
Definition _sinf : ident := $"sinf".
Definition _sphi : ident := $"sphi".
Definition _spsi : ident := $"spsi".
Definition _sqrtf : ident := $"sqrtf".
Definition _stheta : ident := $"stheta".
Definition _theta : ident := $"theta".
Definition _theta2 : ident := $"theta2".
Definition _tilt : ident := $"tilt".
Definition _tr : ident := $"tr".
Definition _twist : ident := $"twist".
Definition _two_qi : ident := $"two_qi".
Definition _two_qx : ident := $"two_qx".
Definition _two_qy : ident := $"two_qy".
Definition _two_qz : ident := $"two_qz".
Definition _uv : ident := $"uv".
Definition _ux2 : ident := $"ux2".
Definition _uxuy : ident := $"uxuy".
Definition _uxuz : ident := $"uxuz".
Definition _uy2 : ident := $"uy2".
Definition _uyuz : ident := $"uyuz".
Definition _uz2 : ident := $"uz2".
Definition _v_in : ident := $"v_in".
Definition _v_norm : ident := $"v_norm".
Definition _v_out : ident := $"v_out".
Definition _va : ident := $"va".
Definition _vb : ident := $"vb".
Definition _vect2 : ident := $"vect2".
Definition _vect3 : ident := $"vect3".
Definition _vect_in : ident := $"vect_in".
Definition _vect_out : ident := $"vect_out".
Definition _w : ident := $"w".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".
Definition _z_rot : ident := $"z_rot".

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

Definition f_float_rates_integrate_fi := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_r, (tptr (Tstruct _FloatRates noattr))) ::
                (_dr, (tptr (Tstruct _FloatRates noattr))) ::
                (_dt, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassignop Oadd
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                 (tptr (Tstruct _FloatRates noattr)))
               (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr)) _p
           tfloat)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _dr (tptr (Tstruct _FloatRates noattr)))
                     (tptr (Tstruct _FloatRates noattr)))
                   (Tstruct _FloatRates noattr))
                 (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
           (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))
  (Ssequence
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _q tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dr (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
             (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _r tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dr (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
             (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))))
|}.

Definition f_float_rates_vect3_integrate_fi := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_r, (tptr (Tstruct _FloatRates noattr))) ::
                (_dr, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_dt, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassignop Oadd
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                 (tptr (Tstruct _FloatRates noattr)))
               (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr)) _p
           tfloat)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _dr (tptr (Tstruct _FloatVect3 noattr)))
                     (tptr (Tstruct _FloatVect3 noattr)))
                   (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
           (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))
  (Ssequence
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _q tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dr (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
             (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))
    (Sdo (Eassignop Oadd
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _r tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dr (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
             (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat tfloat))))
|}.

Definition f_float_rates_of_euler_dot := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_r, (tptr (Tstruct _FloatRates noattr))) ::
                (_e, (tptr (Tstruct _FloatEulers noattr))) ::
                (_edot, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                 (tptr (Tstruct _FloatRates noattr)))
               (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr)) _p
           tfloat)
         (Ebinop Osub
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _edot (tptr (Tstruct _FloatEulers noattr)))
                     (tptr (Tstruct _FloatEulers noattr)))
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
           (Ebinop Omul
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
                           (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
                 Enil) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _edot (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
             tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _q tfloat)
           (Ebinop Oadd
             (Ebinop Omul
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
                             (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                             (tptr (Tstruct _FloatEulers noattr)))
                           (Tstruct _FloatEulers noattr))
                         (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
                   Enil) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _edot (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
               tfloat)
             (Ebinop Omul
               (Ebinop Omul
                 (Ecall
                   (Evalof
                     (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _phi tfloat)
                       tfloat) Enil) tfloat)
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
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _theta tfloat)
                       tfloat) Enil) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _edot (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               tfloat) tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _r tfloat)
           (Ebinop Oadd
             (Ebinop Omul
               (Eunop Oneg
                 (Ecall
                   (Evalof
                     (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _phi tfloat)
                       tfloat) Enil) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _edot (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
               tfloat)
             (Ebinop Omul
               (Ebinop Omul
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
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _phi tfloat)
                       tfloat) Enil) tfloat)
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
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _theta tfloat)
                       tfloat) Enil) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _edot (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               tfloat) tfloat) tfloat))))
|}.

Definition f_float_rmat_inv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_b2a, (tptr (Tstruct _FloatRMat noattr))) ::
                (_m_a2b, (tptr (Tstruct _FloatRMat noattr))) :: nil);
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
                     (Evalof (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                       (tptr (Tstruct _FloatRMat noattr)))
                     (Tstruct _FloatRMat noattr))
                   (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
               (tarray tfloat 9))
             (Ebinop Oadd
               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                 (Eval (Vint (Int.repr 3)) tint) tint)
               (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat)) tfloat)
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
                 (tarray tfloat 9))
               (Ebinop Oadd
                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                   (Eval (Vint (Int.repr 3)) tint) tint)
                 (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat)) tfloat)
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
                         (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                         (tptr (Tstruct _FloatRMat noattr)))
                       (Tstruct _FloatRMat noattr))
                     (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                 (tarray tfloat 9))
               (Ebinop Oadd
                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                   (Eval (Vint (Int.repr 3)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat)) tfloat)
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
                   (tarray tfloat 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
               tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                           (tptr (Tstruct _FloatRMat noattr)))
                         (Tstruct _FloatRMat noattr))
                       (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                   (tarray tfloat 9))
                 (Ebinop Oadd
                   (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
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
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                 tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
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
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                   tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9))
                     (Ebinop Oadd
                       (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
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
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                     tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Ebinop Oadd
                         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
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
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                   (tptr (Tstruct _FloatRMat noattr)))
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Ebinop Oadd
                           (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tfloat)) tfloat)
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
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tfloat)) tfloat)
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
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 2)) tint) tint)
                             (tptr tfloat)) tfloat) tfloat) tfloat))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tfloat)) tfloat)
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
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 2)) tint) tint)
                             (tptr tfloat)) tfloat) tfloat) tfloat))))))))))
|}.

Definition f_float_rmat_norm := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) :: nil);
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
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Oadd
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
                                                     (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                     (tptr (Tstruct _FloatRMat noattr)))
                                                   (Tstruct _FloatRMat noattr))
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (tptr tfloat)) tfloat) tfloat)
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
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (tptr tfloat)) tfloat) tfloat)
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
                                                     (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                     (tptr (Tstruct _FloatRMat noattr)))
                                                   (Tstruct _FloatRMat noattr))
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tfloat)) tfloat) tfloat)
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
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tfloat)) tfloat) tfloat)
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
                                                   (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                   (tptr (Tstruct _FloatRMat noattr)))
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr tfloat)) tfloat) tfloat)
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
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr tfloat)) tfloat) tfloat)
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
                                                 (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                                 (tptr (Tstruct _FloatRMat noattr)))
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 3)) tint)
                                       (tptr tfloat)) tfloat) tfloat)
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
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
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
                                               (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                               (tptr (Tstruct _FloatRMat noattr)))
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 4)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
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
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
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
                                             (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                             (tptr (Tstruct _FloatRMat noattr)))
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
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
                                           (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
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
                                           (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 6)) tint)
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
                                         (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                             tfloat) tfloat)
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
                               (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
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
                                       (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
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
                                       (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                       (tptr (Tstruct _FloatRMat noattr)))
                                     (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat) tfloat) Enil) tfloat)))
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

Definition f_float_rmat_comp_inv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_m_a2b, (tptr (Tstruct _FloatRMat noattr))) ::
                (_m_a2c, (tptr (Tstruct _FloatRMat noattr))) ::
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
                     (Evalof (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                               (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
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
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 6)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
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
                         (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                 (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                       (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
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
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 6)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
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
                           (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                   (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                                   (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                       (Eval (Vint (Int.repr 6)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
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
                             (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                     (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                                     (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                         (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                       tfloat) tfloat)
                   (Evalof
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
                               (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                       (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                                       (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                           (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Evalof
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
                                 (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                         (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                                         (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                             (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
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
                                   (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                 (Eval (Vint (Int.repr 2)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
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
                                 (Eval (Vint (Int.repr 5)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
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
                                         (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                                     (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
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
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
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
                                           (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
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
                                     (Evar _m_a2b (tptr (Tstruct _FloatRMat noattr)))
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
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
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
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Evalof
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
                                           (Evar _m_a2c (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         tfloat) tfloat))))))))))
|}.

Definition f_float_rmat_transp_vmult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vb, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_m_b2a, (tptr (Tstruct _FloatRMat noattr))) ::
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
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
                             (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 6)) tint)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 7)) tint)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
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

Definition f_float_rmat_mult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rb, (tptr (Tstruct _FloatEulers noattr))) ::
                (_m_a2b, (tptr (Tstruct _FloatRMat noattr))) ::
                (_ra, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _rb (tptr (Tstruct _FloatEulers noattr)))
                 (tptr (Tstruct _FloatEulers noattr)))
               (Tstruct _FloatEulers noattr)) (Tstruct _FloatEulers noattr))
           _phi tfloat)
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
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
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
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
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
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
             tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatEulers noattr)))
                   (tptr (Tstruct _FloatEulers noattr)))
                 (Tstruct _FloatEulers noattr))
               (Tstruct _FloatEulers noattr)) _theta tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
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
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               tfloat) tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatEulers noattr)))
                   (tptr (Tstruct _FloatEulers noattr)))
                 (Tstruct _FloatEulers noattr))
               (Tstruct _FloatEulers noattr)) _psi tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
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
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               tfloat) tfloat) tfloat))))
|}.

Definition f_float_rmat_transp_mult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rb, (tptr (Tstruct _FloatEulers noattr))) ::
                (_m_b2a, (tptr (Tstruct _FloatRMat noattr))) ::
                (_ra, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _rb (tptr (Tstruct _FloatEulers noattr)))
                 (tptr (Tstruct _FloatEulers noattr)))
               (Tstruct _FloatEulers noattr)) (Tstruct _FloatEulers noattr))
           _phi tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
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
                             (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 6)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
             tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatEulers noattr)))
                   (tptr (Tstruct _FloatEulers noattr)))
                 (Tstruct _FloatEulers noattr))
               (Tstruct _FloatEulers noattr)) _theta tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
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
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 7)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               tfloat) tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatEulers noattr)))
                   (tptr (Tstruct _FloatEulers noattr)))
                 (Tstruct _FloatEulers noattr))
               (Tstruct _FloatEulers noattr)) _psi tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 8)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _ra (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               tfloat) tfloat) tfloat))))
|}.

Definition f_float_rmat_ratemult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rb, (tptr (Tstruct _FloatRates noattr))) ::
                (_m_a2b, (tptr (Tstruct _FloatRMat noattr))) ::
                (_ra, (tptr (Tstruct _FloatRates noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _rb (tptr (Tstruct _FloatRates noattr)))
                 (tptr (Tstruct _FloatRates noattr)))
               (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr)) _p
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
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _p tfloat) tfloat) tfloat)
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
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _q tfloat) tfloat) tfloat)
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
                     (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _q tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
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
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _r tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
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
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
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
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
             tfloat) tfloat))))
|}.

Definition f_float_rmat_transp_ratemult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rb, (tptr (Tstruct _FloatRates noattr))) ::
                (_m_b2a, (tptr (Tstruct _FloatRMat noattr))) ::
                (_ra, (tptr (Tstruct _FloatRates noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _rb (tptr (Tstruct _FloatRates noattr)))
                 (tptr (Tstruct _FloatRates noattr)))
               (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr)) _p
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _p tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _q tfloat) tfloat) tfloat)
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
                             (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 6)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _q tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
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
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 7)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _rb (tptr (Tstruct _FloatRates noattr)))
                   (tptr (Tstruct _FloatRates noattr)))
                 (Tstruct _FloatRates noattr)) (Tstruct _FloatRates noattr))
             _r tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
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
                                 (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
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
                               (Evar _m_b2a (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 8)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _ra (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
             tfloat) tfloat))))
|}.

Definition f_float_rmat_of_axis_angle := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) ::
                (_uv, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_angle, tfloat) :: nil);
  fn_vars := ((_ux2, tfloat) :: (_uy2, tfloat) :: (_uz2, tfloat) ::
              (_uxuy, tfloat) :: (_uyuz, tfloat) :: (_uxuz, tfloat) ::
              (_can, tfloat) :: (_san, tfloat) :: (_one_m_can, tfloat) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _ux2 tfloat)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                     (tptr (Tstruct _FloatVect3 noattr)))
                   (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                     (tptr (Tstruct _FloatVect3 noattr)))
                   (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat) tfloat)
         tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _uy2 tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _uz2 tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
             tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _uxuy tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _uyuz tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                   tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _uxuz tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _can tfloat)
                     (Ecall
                       (Evalof
                         (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _angle tfloat) tfloat) Enil)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _san tfloat)
                       (Ecall
                         (Evalof
                           (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                         cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _angle tfloat) tfloat) Enil)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _one_m_can tfloat)
                         (Ebinop Osub
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                           (Evalof (Evar _can tfloat) tfloat) tdouble)
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat)
                           (Ebinop Oadd (Evalof (Evar _ux2 tfloat) tfloat)
                             (Ebinop Omul
                               (Ebinop Osub
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                 (Evalof (Evar _ux2 tfloat) tfloat) tdouble)
                               (Evalof (Evar _can tfloat) tfloat) tdouble)
                             tdouble) tfloat))
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Evalof (Evar _uxuy tfloat) tfloat)
                                 (Evalof (Evar _one_m_can tfloat) tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                                           (tptr (Tstruct _FloatVect3 noattr)))
                                         (Tstruct _FloatVect3 noattr))
                                       (Tstruct _FloatVect3 noattr)) _z
                                     tfloat) tfloat)
                                 (Evalof (Evar _san tfloat) tfloat) tfloat)
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
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tfloat)) tfloat)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Evalof (Evar _uxuz tfloat) tfloat)
                                   (Evalof (Evar _one_m_can tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                                             (tptr (Tstruct _FloatVect3 noattr)))
                                           (Tstruct _FloatVect3 noattr))
                                         (Tstruct _FloatVect3 noattr)) _y
                                       tfloat) tfloat)
                                   (Evalof (Evar _san tfloat) tfloat) tfloat)
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
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tfloat)) tfloat)
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
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tfloat)) tfloat) tfloat)
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
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tfloat)) tfloat)
                                   (Ebinop Oadd
                                     (Evalof (Evar _uy2 tfloat) tfloat)
                                     (Ebinop Omul
                                       (Ebinop Osub
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                         (Evalof (Evar _uy2 tfloat) tfloat)
                                         tdouble)
                                       (Evalof (Evar _can tfloat) tfloat)
                                       tdouble) tdouble) tfloat))
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
                                           (Eval (Vint (Int.repr 2)) tint)
                                           tint) (tptr tfloat)) tfloat)
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _uyuz tfloat) tfloat)
                                         (Evalof (Evar _one_m_can tfloat)
                                           tfloat) tfloat)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                                                   (tptr (Tstruct _FloatVect3 noattr)))
                                                 (Tstruct _FloatVect3 noattr))
                                               (Tstruct _FloatVect3 noattr))
                                             _x tfloat) tfloat)
                                         (Evalof (Evar _san tfloat) tfloat)
                                         tfloat) tfloat) tfloat))
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
                                                   (Tstruct _FloatRMat noattr))
                                                 _m (tarray tfloat 9))
                                               (tarray tfloat 9))
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 2)) tint)
                                               tint) (tptr tfloat)) tfloat)
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
                                         (Ebinop Oadd
                                           (Evalof (Evar _uz2 tfloat) tfloat)
                                           (Ebinop Omul
                                             (Ebinop Osub
                                               (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                               (Evalof (Evar _uz2 tfloat)
                                                 tfloat) tdouble)
                                             (Evalof (Evar _can tfloat)
                                               tfloat) tdouble) tdouble)
                                         tfloat)))))))))))))))))))
|}.

Definition f_float_rmat_of_eulers_312 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) ::
                (_e, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := ((_sphi, tfloat) :: (_cphi, tfloat) :: (_stheta, tfloat) ::
              (_ctheta, tfloat) :: (_spsi, tfloat) :: (_cpsi, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sphi tfloat)
         (Ecall
           (Evalof (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat) Enil)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _cphi tfloat)
           (Ecall
             (Evalof
               (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
               (Tfunction (tfloat :: nil) tfloat cc_default))
             (Econs
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
               Enil) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _stheta tfloat)
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
                           (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
                 Enil) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tfloat)
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
                             (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                             (tptr (Tstruct _FloatEulers noattr)))
                           (Tstruct _FloatEulers noattr))
                         (Tstruct _FloatEulers noattr)) _theta tfloat)
                     tfloat) Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _spsi tfloat)
                 (Ecall
                   (Evalof
                     (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _psi tfloat)
                       tfloat) Enil) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _cpsi tfloat)
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
                                 (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                 (tptr (Tstruct _FloatEulers noattr)))
                               (Tstruct _FloatEulers noattr))
                             (Tstruct _FloatEulers noattr)) _psi tfloat)
                         tfloat) Enil) tfloat) tfloat))
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
                           (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (tptr tfloat)) tfloat)
                     (Ebinop Osub
                       (Ebinop Omul (Evalof (Evar _ctheta tfloat) tfloat)
                         (Evalof (Evar _cpsi tfloat) tfloat) tfloat)
                       (Ebinop Omul
                         (Ebinop Omul (Evalof (Evar _sphi tfloat) tfloat)
                           (Evalof (Evar _stheta tfloat) tfloat) tfloat)
                         (Evalof (Evar _spsi tfloat) tfloat) tfloat) tfloat)
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
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tfloat)) tfloat)
                       (Ebinop Oadd
                         (Ebinop Omul (Evalof (Evar _ctheta tfloat) tfloat)
                           (Evalof (Evar _spsi tfloat) tfloat) tfloat)
                         (Ebinop Omul
                           (Ebinop Omul (Evalof (Evar _sphi tfloat) tfloat)
                             (Evalof (Evar _stheta tfloat) tfloat) tfloat)
                           (Evalof (Evar _cpsi tfloat) tfloat) tfloat)
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
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Ebinop Oadd
                               (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 2)) tint) tint)
                             (tptr tfloat)) tfloat)
                         (Ebinop Omul
                           (Eunop Oneg (Evalof (Evar _cphi tfloat) tfloat)
                             tfloat) (Evalof (Evar _stheta tfloat) tfloat)
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
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Ebinop Oadd
                                 (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat)
                           (Ebinop Omul
                             (Eunop Oneg (Evalof (Evar _cphi tfloat) tfloat)
                               tfloat) (Evalof (Evar _spsi tfloat) tfloat)
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
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Omul (Evalof (Evar _cphi tfloat) tfloat)
                               (Evalof (Evar _cpsi tfloat) tfloat) tfloat)
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tfloat)) tfloat)
                               (Evalof (Evar _sphi tfloat) tfloat) tfloat))
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
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Evalof (Evar _stheta tfloat) tfloat)
                                     (Evalof (Evar _cpsi tfloat) tfloat)
                                     tfloat)
                                   (Ebinop Omul
                                     (Ebinop Omul
                                       (Evalof (Evar _sphi tfloat) tfloat)
                                       (Evalof (Evar _ctheta tfloat) tfloat)
                                       tfloat)
                                     (Evalof (Evar _spsi tfloat) tfloat)
                                     tfloat) tfloat) tfloat))
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
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr tfloat)) tfloat)
                                   (Ebinop Osub
                                     (Ebinop Omul
                                       (Evalof (Evar _stheta tfloat) tfloat)
                                       (Evalof (Evar _spsi tfloat) tfloat)
                                       tfloat)
                                     (Ebinop Omul
                                       (Ebinop Omul
                                         (Evalof (Evar _sphi tfloat) tfloat)
                                         (Evalof (Evar _ctheta tfloat)
                                           tfloat) tfloat)
                                       (Evalof (Evar _cpsi tfloat) tfloat)
                                       tfloat) tfloat) tfloat))
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
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Eval (Vint (Int.repr 3)) tint)
                                           tint)
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tfloat)) tfloat)
                                   (Ebinop Omul
                                     (Evalof (Evar _cphi tfloat) tfloat)
                                     (Evalof (Evar _ctheta tfloat) tfloat)
                                     tfloat) tfloat))))))))))))))))
|}.

Definition f_float_rmat_of_quat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) ::
                (_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := ((__a, tfloat) :: (__b, tfloat) :: (__c, tfloat) ::
              (__d, tfloat) :: (_a2_1, tfloat) :: (_ab, tfloat) ::
              (_ac, tfloat) :: (_ad, tfloat) :: (_bc, tfloat) ::
              (_bd, tfloat) :: (_cd, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar __a tfloat)
         (Ebinop Omul
           (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qi tfloat) tfloat) tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar __b tfloat)
           (Ebinop Omul
             (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat) tdouble)
           tfloat))
    (Ssequence
      (Sdo (Eassign (Evar __c tfloat)
             (Ebinop Omul
               (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
               tdouble) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar __d tfloat)
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4609047870845172685))) tdouble)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 tdouble) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _a2_1 tfloat)
                 (Ebinop Osub
                   (Ebinop Omul (Evalof (Evar __a tfloat) tfloat)
                     (Evalof (Evar __a tfloat) tfloat) tfloat)
                   (Eval (Vint (Int.repr 1)) tint) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _ab tfloat)
                   (Ebinop Omul (Evalof (Evar __a tfloat) tfloat)
                     (Evalof (Evar __b tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _ac tfloat)
                     (Ebinop Omul (Evalof (Evar __a tfloat) tfloat)
                       (Evalof (Evar __c tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _ad tfloat)
                       (Ebinop Omul (Evalof (Evar __a tfloat) tfloat)
                         (Evalof (Evar __d tfloat) tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _bc tfloat)
                         (Ebinop Omul (Evalof (Evar __b tfloat) tfloat)
                           (Evalof (Evar __c tfloat) tfloat) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _bd tfloat)
                           (Ebinop Omul (Evalof (Evar __b tfloat) tfloat)
                             (Evalof (Evar __d tfloat) tfloat) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign (Evar _cd tfloat)
                             (Ebinop Omul (Evalof (Evar __c tfloat) tfloat)
                               (Evalof (Evar __d tfloat) tfloat) tfloat)
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 0)) tint) tint)
                                   (tptr tfloat)) tfloat)
                               (Ebinop Oadd
                                 (Evalof (Evar _a2_1 tfloat) tfloat)
                                 (Ebinop Omul
                                   (Evalof (Evar __b tfloat) tfloat)
                                   (Evalof (Evar __b tfloat) tfloat) tfloat)
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
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Oadd
                                   (Evalof (Evar _bc tfloat) tfloat)
                                   (Evalof (Evar _ad tfloat) tfloat) tfloat)
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
                                         (Eval (Vint (Int.repr 2)) tint)
                                         tint) (tptr tfloat)) tfloat)
                                   (Ebinop Osub
                                     (Evalof (Evar _bd tfloat) tfloat)
                                     (Evalof (Evar _ac tfloat) tfloat)
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
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint) (tptr tfloat)) tfloat)
                                     (Ebinop Osub
                                       (Evalof (Evar _bc tfloat) tfloat)
                                       (Evalof (Evar _ad tfloat) tfloat)
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
                                       (Ebinop Oadd
                                         (Evalof (Evar _a2_1 tfloat) tfloat)
                                         (Ebinop Omul
                                           (Evalof (Evar __c tfloat) tfloat)
                                           (Evalof (Evar __c tfloat) tfloat)
                                           tfloat) tfloat) tfloat))
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
                                               (Eval (Vint (Int.repr 2)) tint)
                                               tint) (tptr tfloat)) tfloat)
                                         (Ebinop Oadd
                                           (Evalof (Evar _cd tfloat) tfloat)
                                           (Evalof (Evar _ab tfloat) tfloat)
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
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 tint) (tptr tfloat)) tfloat)
                                           (Ebinop Oadd
                                             (Evalof (Evar _bd tfloat)
                                               tfloat)
                                             (Evalof (Evar _ac tfloat)
                                               tfloat) tfloat) tfloat))
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
                                                   tint) (tptr tfloat))
                                               tfloat)
                                             (Ebinop Osub
                                               (Evalof (Evar _cd tfloat)
                                                 tfloat)
                                               (Evalof (Evar _ab tfloat)
                                                 tfloat) tfloat) tfloat))
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
                                                   tint) (tptr tfloat))
                                               tfloat)
                                             (Ebinop Oadd
                                               (Evalof (Evar _a2_1 tfloat)
                                                 tfloat)
                                               (Ebinop Omul
                                                 (Evalof (Evar __d tfloat)
                                                   tfloat)
                                                 (Evalof (Evar __d tfloat)
                                                   tfloat) tfloat) tfloat)
                                             tfloat)))))))))))))))))))))
|}.

Definition f_float_rmat_integrate_fi := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rm, (tptr (Tstruct _FloatRMat noattr))) ::
                (_omega, (tptr (Tstruct _FloatRates noattr))) ::
                (_dt, tfloat) :: nil);
  fn_vars := ((_exp_omega_dt, (Tstruct _FloatRMat noattr)) ::
              (_R_tdt, (Tstruct _FloatRMat noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof
               (Efield
                 (Evalof (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                   (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
               (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
             (tptr tfloat)) tfloat)
         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
         tfloat))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                     (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                 (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tfloat)) tfloat)
           (Ebinop Omul (Evalof (Evar _dt tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                       (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                   (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tfloat)) tfloat)
             (Ebinop Omul
               (Eunop Oneg (Evalof (Evar _dt tfloat) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _q tfloat) tfloat) tfloat)
             tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tfloat)) tfloat)
               (Ebinop Omul
                 (Eunop Oneg (Evalof (Evar _dt tfloat) tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                 tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 4)) tint)
                     (tptr tfloat)) tfloat)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                 tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
                   (Ebinop Omul (Evalof (Evar _dt tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 6)) tint) (tptr tfloat))
                       tfloat)
                     (Ebinop Omul (Evalof (Evar _dt tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 7)) tint) (tptr tfloat))
                         tfloat)
                       (Ebinop Omul
                         (Eunop Oneg (Evalof (Evar _dt tfloat) tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _p tfloat)
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 8)) tint) (tptr tfloat))
                           tfloat)
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                         tfloat))
                  (Ssequence
                    (Sdo (Ecall
                           (Evalof
                             (Evar _float_rmat_comp (Tfunction
                                                      ((tptr (Tstruct _FloatRMat noattr)) ::
                                                       (tptr (Tstruct _FloatRMat noattr)) ::
                                                       (tptr (Tstruct _FloatRMat noattr)) ::
                                                       nil) tvoid cc_default))
                             (Tfunction
                               ((tptr (Tstruct _FloatRMat noattr)) ::
                                (tptr (Tstruct _FloatRMat noattr)) ::
                                (tptr (Tstruct _FloatRMat noattr)) :: nil)
                               tvoid cc_default))
                           (Econs
                             (Eaddrof
                               (Evar _R_tdt (Tstruct _FloatRMat noattr))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Econs
                               (Evalof
                                 (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Econs
                                 (Eaddrof
                                   (Evar _exp_omega_dt (Tstruct _FloatRMat noattr))
                                   (tptr (Tstruct _FloatRMat noattr))) Enil)))
                           tvoid))
                    (Sdo (Ecall
                           (Evalof
                             (Evar _memcpy (Tfunction
                                             ((tptr tvoid) :: (tptr tvoid) ::
                                              tulong :: nil) (tptr tvoid)
                                             cc_default))
                             (Tfunction
                               ((tptr tvoid) :: (tptr tvoid) :: tulong ::
                                nil) (tptr tvoid) cc_default))
                           (Econs
                             (Evalof
                               (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                               (tptr (Tstruct _FloatRMat noattr)))
                             (Econs
                               (Eaddrof
                                 (Evar _R_tdt (Tstruct _FloatRMat noattr))
                                 (tptr (Tstruct _FloatRMat noattr)))
                               (Econs
                                 (Esizeof (Tstruct _FloatRMat noattr) tulong)
                                 Enil))) (tptr tvoid)))))))))))))
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

Definition f_float_quat_comp_inv := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2b, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2c, (tptr (Tstruct _FloatQuat noattr))) ::
                (_b2c, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr)))
               (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr)) _qi
           tfloat)
         (Ebinop Oadd
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                       (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                     (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                 (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qx tfloat)
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                     tfloat)
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                       (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                   (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qy tfloat)
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
                                 (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                       tfloat)
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                   (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qz tfloat)
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
                                 (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                       tfloat)
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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

Definition f_float_quat_inv_comp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_b2c, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2b, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2c, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr)))
               (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr)) _qi
           tfloat)
         (Ebinop Oadd
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                       (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                     (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qx tfloat)
           (Ebinop Oadd
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                       (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qy tfloat)
             (Ebinop Osub
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                 tfloat) tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qz tfloat)
             (Ebinop Osub
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                               (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 tfloat) tfloat) tfloat)))))
|}.

Definition f_float_quat_comp_norm_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2c, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2b, (tptr (Tstruct _FloatQuat noattr))) ::
                (_b2c, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _float_quat_comp (Tfunction
                                    ((tptr (Tstruct _FloatQuat noattr)) ::
                                     (tptr (Tstruct _FloatQuat noattr)) ::
                                     (tptr (Tstruct _FloatQuat noattr)) ::
                                     nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _FloatQuat noattr)) ::
              (tptr (Tstruct _FloatQuat noattr)) ::
              (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
             (tptr (Tstruct _FloatQuat noattr)))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr)))
             (Econs
               (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _float_quat_wrap_shortest (Tfunction
                                               ((tptr (Tstruct _FloatQuat noattr)) ::
                                                nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _float_quat_normalize (Tfunction
                                           ((tptr (Tstruct _FloatQuat noattr)) ::
                                            nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tvoid))))
|}.

Definition f_float_quat_comp_inv_norm_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a2b, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2c, (tptr (Tstruct _FloatQuat noattr))) ::
                (_b2c, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _float_quat_comp_inv (Tfunction
                                        ((tptr (Tstruct _FloatQuat noattr)) ::
                                         (tptr (Tstruct _FloatQuat noattr)) ::
                                         (tptr (Tstruct _FloatQuat noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _FloatQuat noattr)) ::
              (tptr (Tstruct _FloatQuat noattr)) ::
              (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
             (tptr (Tstruct _FloatQuat noattr)))
           (Econs
             (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr)))
             (Econs
               (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _float_quat_wrap_shortest (Tfunction
                                               ((tptr (Tstruct _FloatQuat noattr)) ::
                                                nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _float_quat_normalize (Tfunction
                                           ((tptr (Tstruct _FloatQuat noattr)) ::
                                            nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tvoid))))
|}.

Definition f_float_quat_inv_comp_norm_shortest := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_b2c, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2b, (tptr (Tstruct _FloatQuat noattr))) ::
                (_a2c, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _float_quat_inv_comp (Tfunction
                                        ((tptr (Tstruct _FloatQuat noattr)) ::
                                         (tptr (Tstruct _FloatQuat noattr)) ::
                                         (tptr (Tstruct _FloatQuat noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _FloatQuat noattr)) ::
              (tptr (Tstruct _FloatQuat noattr)) ::
              (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
             (tptr (Tstruct _FloatQuat noattr)))
           (Econs
             (Evalof (Evar _a2b (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr)))
             (Econs
               (Evalof (Evar _a2c (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr))) Enil))) tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _float_quat_wrap_shortest (Tfunction
                                               ((tptr (Tstruct _FloatQuat noattr)) ::
                                                nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tvoid))
    (Sdo (Ecall
           (Evalof
             (Evar _float_quat_normalize (Tfunction
                                           ((tptr (Tstruct _FloatQuat noattr)) ::
                                            nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
               cc_default))
           (Econs
             (Evalof (Evar _b2c (tptr (Tstruct _FloatQuat noattr)))
               (tptr (Tstruct _FloatQuat noattr))) Enil) tvoid))))
|}.

Definition f_float_quat_differential := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q_out, (tptr (Tstruct _FloatQuat noattr))) ::
                (_w, (tptr (Tstruct _FloatRates noattr))) :: (_dt, tfloat) ::
                nil);
  fn_vars := ((_v_norm, tfloat) :: (_c2, tfloat) :: (_s2, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _v_norm tfloat)
         (Ecall
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
                             (Evar _w (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _w (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _w (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _w (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _w (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _w (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _c2 tfloat)
           (Ecall
             (Evalof
               (Evar _cos (Tfunction (tdouble :: nil) tdouble cc_default))
               (Tfunction (tdouble :: nil) tdouble cc_default))
             (Econs
               (Ebinop Odiv
                 (Ebinop Omul (Evalof (Evar _dt tfloat) tfloat)
                   (Evalof (Evar _v_norm tfloat) tfloat) tfloat)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                 tdouble) Enil) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _s2 tfloat)
             (Ecall
               (Evalof
                 (Evar _sin (Tfunction (tdouble :: nil) tdouble cc_default))
                 (Tfunction (tdouble :: nil) tdouble cc_default))
               (Econs
                 (Ebinop Odiv
                   (Ebinop Omul (Evalof (Evar _dt tfloat) tfloat)
                     (Evalof (Evar _v_norm tfloat) tfloat) tfloat)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   tdouble) Enil) tdouble) tfloat))
      (Sifthenelse (Ebinop Olt (Evalof (Evar _v_norm tfloat) tfloat)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4487126258331716666))) tdouble)
                     tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qi tfloat)
                 (Eval (Vint (Int.repr 1)) tint) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat)
                   (Eval (Vint (Int.repr 0)) tint) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat)
                     (Eval (Vint (Int.repr 0)) tint) tfloat))
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qz tfloat)
                     (Eval (Vint (Int.repr 0)) tint) tfloat)))))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qi tfloat)
                 (Evalof (Evar _c2 tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qx tfloat)
                   (Ebinop Omul
                     (Ebinop Odiv
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _w (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                       (Evalof (Evar _v_norm tfloat) tfloat) tfloat)
                     (Evalof (Evar _s2 tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat)
                     (Ebinop Omul
                       (Ebinop Odiv
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _w (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _q tfloat)
                           tfloat) (Evalof (Evar _v_norm tfloat) tfloat)
                         tfloat) (Evalof (Evar _s2 tfloat) tfloat) tfloat)
                     tfloat))
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q_out (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qz tfloat)
                     (Ebinop Omul
                       (Ebinop Odiv
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _w (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _r tfloat)
                           tfloat) (Evalof (Evar _v_norm tfloat) tfloat)
                         tfloat) (Evalof (Evar _s2 tfloat) tfloat) tfloat)
                     tfloat)))))))))
|}.

Definition f_float_quat_integrate_fi := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_omega, (tptr (Tstruct _FloatRates noattr))) ::
                (_dt, tfloat) :: nil);
  fn_vars := ((_qi, tfloat) :: (_qx, tfloat) :: (_qy, tfloat) ::
              (_qz, tfloat) :: (_dp, tfloat) :: (_dq, tfloat) ::
              (_dr, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qi tfloat)
         (Evalof
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qi tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _qx tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _qy tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _qz tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _dp tfloat)
                 (Ebinop Omul
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                     (Evalof (Evar _dt tfloat) tfloat) tdouble)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   tdouble) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _dq tfloat)
                   (Ebinop Omul
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                       (Evalof (Evar _dt tfloat) tfloat) tdouble)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     tdouble) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _dr tfloat)
                     (Ebinop Omul
                       (Ebinop Omul
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                         (Evalof (Evar _dt tfloat) tfloat) tdouble)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                       tdouble) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat)
                       (Ebinop Osub
                         (Ebinop Osub
                           (Ebinop Osub (Evalof (Evar _qi tfloat) tfloat)
                             (Ebinop Omul (Evalof (Evar _dp tfloat) tfloat)
                               (Evalof (Evar _qx tfloat) tfloat) tfloat)
                             tfloat)
                           (Ebinop Omul (Evalof (Evar _dq tfloat) tfloat)
                             (Evalof (Evar _qy tfloat) tfloat) tfloat)
                           tfloat)
                         (Ebinop Omul (Evalof (Evar _dr tfloat) tfloat)
                           (Evalof (Evar _qz tfloat) tfloat) tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qx tfloat)
                         (Ebinop Osub
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Omul (Evalof (Evar _dp tfloat) tfloat)
                                 (Evalof (Evar _qi tfloat) tfloat) tfloat)
                               (Evalof (Evar _qx tfloat) tfloat) tfloat)
                             (Ebinop Omul (Evalof (Evar _dr tfloat) tfloat)
                               (Evalof (Evar _qy tfloat) tfloat) tfloat)
                             tfloat)
                           (Ebinop Omul (Evalof (Evar _dq tfloat) tfloat)
                             (Evalof (Evar _qz tfloat) tfloat) tfloat)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qy tfloat)
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Evalof (Evar _dq tfloat) tfloat)
                                   (Evalof (Evar _qi tfloat) tfloat) tfloat)
                                 (Ebinop Omul
                                   (Evalof (Evar _dr tfloat) tfloat)
                                   (Evalof (Evar _qx tfloat) tfloat) tfloat)
                                 tfloat) (Evalof (Evar _qy tfloat) tfloat)
                               tfloat)
                             (Ebinop Omul (Evalof (Evar _dp tfloat) tfloat)
                               (Evalof (Evar _qz tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qz tfloat)
                           (Ebinop Oadd
                             (Ebinop Osub
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Evalof (Evar _dr tfloat) tfloat)
                                   (Evalof (Evar _qi tfloat) tfloat) tfloat)
                                 (Ebinop Omul
                                   (Evalof (Evar _dq tfloat) tfloat)
                                   (Evalof (Evar _qx tfloat) tfloat) tfloat)
                                 tfloat)
                               (Ebinop Omul (Evalof (Evar _dp tfloat) tfloat)
                                 (Evalof (Evar _qy tfloat) tfloat) tfloat)
                               tfloat) (Evalof (Evar _qz tfloat) tfloat)
                             tfloat) tfloat))))))))))))
|}.

Definition f_float_quat_integrate := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_omega, (tptr (Tstruct _FloatRates noattr))) ::
                (_dt, tfloat) :: nil);
  fn_vars := ((_no, tfloat) :: (_a, tfloat) :: (_ca, tfloat) ::
              (_sa_ov_no, tfloat) :: (_dp, tfloat) :: (_dq, tfloat) ::
              (_dr, tfloat) :: (_qi, tfloat) :: (_qx, tfloat) ::
              (_qy, tfloat) :: (_qz, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _no tfloat)
         (Ecall
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
                             (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                   tfloat) tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _no tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 8388608))) tfloat)
                 tint)
    (Ssequence
      (Sdo (Eassign (Evar _a tfloat)
             (Ebinop Omul
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                 (Evalof (Evar _no tfloat) tfloat) tdouble)
               (Evalof (Evar _dt tfloat) tfloat) tdouble) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _ca tfloat)
               (Ecall
                 (Evalof
                   (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _a tfloat) tfloat) Enil) tfloat)
               tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _sa_ov_no tfloat)
                 (Ebinop Odiv
                   (Ecall
                     (Evalof
                       (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _a tfloat) tfloat) Enil) tfloat)
                   (Evalof (Evar _no tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _dp tfloat)
                   (Ebinop Omul (Evalof (Evar _sa_ov_no tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _dq tfloat)
                     (Ebinop Omul (Evalof (Evar _sa_ov_no tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _dr tfloat)
                       (Ebinop Omul (Evalof (Evar _sa_ov_no tfloat) tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _omega (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _r tfloat)
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _qi tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qi tfloat)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _qx tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign (Evar _qy tfloat)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qy tfloat)
                               tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign (Evar _qz tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                         (tptr (Tstruct _FloatQuat noattr)))
                                       (Tstruct _FloatQuat noattr))
                                     (Tstruct _FloatQuat noattr)) _qz tfloat)
                                 tfloat) tfloat))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                         (tptr (Tstruct _FloatQuat noattr)))
                                       (Tstruct _FloatQuat noattr))
                                     (Tstruct _FloatQuat noattr)) _qi tfloat)
                                 (Ebinop Osub
                                   (Ebinop Osub
                                     (Ebinop Osub
                                       (Ebinop Omul
                                         (Evalof (Evar _ca tfloat) tfloat)
                                         (Evalof (Evar _qi tfloat) tfloat)
                                         tfloat)
                                       (Ebinop Omul
                                         (Evalof (Evar _dp tfloat) tfloat)
                                         (Evalof (Evar _qx tfloat) tfloat)
                                         tfloat) tfloat)
                                     (Ebinop Omul
                                       (Evalof (Evar _dq tfloat) tfloat)
                                       (Evalof (Evar _qy tfloat) tfloat)
                                       tfloat) tfloat)
                                   (Ebinop Omul
                                     (Evalof (Evar _dr tfloat) tfloat)
                                     (Evalof (Evar _qz tfloat) tfloat)
                                     tfloat) tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                           (tptr (Tstruct _FloatQuat noattr)))
                                         (Tstruct _FloatQuat noattr))
                                       (Tstruct _FloatQuat noattr)) _qx
                                     tfloat)
                                   (Ebinop Osub
                                     (Ebinop Oadd
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar _dp tfloat) tfloat)
                                           (Evalof (Evar _qi tfloat) tfloat)
                                           tfloat)
                                         (Ebinop Omul
                                           (Evalof (Evar _ca tfloat) tfloat)
                                           (Evalof (Evar _qx tfloat) tfloat)
                                           tfloat) tfloat)
                                       (Ebinop Omul
                                         (Evalof (Evar _dr tfloat) tfloat)
                                         (Evalof (Evar _qy tfloat) tfloat)
                                         tfloat) tfloat)
                                     (Ebinop Omul
                                       (Evalof (Evar _dq tfloat) tfloat)
                                       (Evalof (Evar _qz tfloat) tfloat)
                                       tfloat) tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                             (tptr (Tstruct _FloatQuat noattr)))
                                           (Tstruct _FloatQuat noattr))
                                         (Tstruct _FloatQuat noattr)) _qy
                                       tfloat)
                                     (Ebinop Oadd
                                       (Ebinop Oadd
                                         (Ebinop Osub
                                           (Ebinop Omul
                                             (Evalof (Evar _dq tfloat)
                                               tfloat)
                                             (Evalof (Evar _qi tfloat)
                                               tfloat) tfloat)
                                           (Ebinop Omul
                                             (Evalof (Evar _dr tfloat)
                                               tfloat)
                                             (Evalof (Evar _qx tfloat)
                                               tfloat) tfloat) tfloat)
                                         (Ebinop Omul
                                           (Evalof (Evar _ca tfloat) tfloat)
                                           (Evalof (Evar _qy tfloat) tfloat)
                                           tfloat) tfloat)
                                       (Ebinop Omul
                                         (Evalof (Evar _dp tfloat) tfloat)
                                         (Evalof (Evar _qz tfloat) tfloat)
                                         tfloat) tfloat) tfloat))
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                             (tptr (Tstruct _FloatQuat noattr)))
                                           (Tstruct _FloatQuat noattr))
                                         (Tstruct _FloatQuat noattr)) _qz
                                       tfloat)
                                     (Ebinop Oadd
                                       (Ebinop Osub
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _dr tfloat)
                                               tfloat)
                                             (Evalof (Evar _qi tfloat)
                                               tfloat) tfloat)
                                           (Ebinop Omul
                                             (Evalof (Evar _dq tfloat)
                                               tfloat)
                                             (Evalof (Evar _qx tfloat)
                                               tfloat) tfloat) tfloat)
                                         (Ebinop Omul
                                           (Evalof (Evar _dp tfloat) tfloat)
                                           (Evalof (Evar _qy tfloat) tfloat)
                                           tfloat) tfloat)
                                       (Ebinop Omul
                                         (Evalof (Evar _ca tfloat) tfloat)
                                         (Evalof (Evar _qz tfloat) tfloat)
                                         tfloat) tfloat) tfloat)))))))))))))))
    Sskip))
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

Definition f_float_quat_derivative := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_qd, (tptr (Tstruct _FloatQuat noattr))) ::
                (_r, (tptr (Tstruct _FloatRates noattr))) ::
                (_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                 (tptr (Tstruct _FloatQuat noattr)))
               (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr)) _qi
           tfloat)
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
                       (Ederef
                         (Evalof
                           (Evar _r (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _r (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _r (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)
             tfloat) tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qx tfloat)
           (Ebinop Omul
             (Eunop Oneg
               (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
               tdouble)
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Omul
                   (Eunop Oneg
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _r (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                     tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _r (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                           (Evar _r (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                 tfloat) tfloat) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qy tfloat)
             (Ebinop Omul
               (Eunop Oneg
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                 tdouble)
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                       tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                               (Evar _r (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _r (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                   tfloat) tfloat) tdouble) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qz tfloat)
             (Ebinop Omul
               (Eunop Oneg
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                 tdouble)
               (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Omul
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                       tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                               (Evar _r (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _r (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                   tfloat) tfloat) tdouble) tfloat)))))
|}.

Definition f_float_quat_derivative_lagrange := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_qd, (tptr (Tstruct _FloatQuat noattr))) ::
                (_r, (tptr (Tstruct _FloatRates noattr))) ::
                (_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := ((_K_LAGRANGE, tfloat) :: (_c, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _K_LAGRANGE tfloat)
         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
         tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _c tfloat)
           (Ebinop Odiv
             (Ebinop Omul (Evalof (Evar _K_LAGRANGE tfloat) tfloat)
               (Ebinop Osub (Eval (Vint (Int.repr 1)) tint)
                 (Ecall
                   (Evalof
                     (Evar _float_quat_norm (Tfunction
                                              ((tptr (Tstruct _FloatQuat noattr)) ::
                                               nil) tfloat cc_default))
                     (Tfunction ((tptr (Tstruct _FloatQuat noattr)) :: nil)
                       tfloat cc_default))
                   (Econs
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr))) Enil) tfloat)
                 tfloat) tfloat)
             (Eunop Oneg
               (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
               tdouble) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qi tfloat)
             (Ebinop Omul
               (Eunop Oneg
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                 tdouble)
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Oadd
                     (Ebinop Omul (Evalof (Evar _c tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                                 (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                               (Evar _r (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                             (Evar _r (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                   tfloat) tfloat) tdouble) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat)
               (Ebinop Omul
                 (Eunop Oneg
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                   tdouble)
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
                                     (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                     (tptr (Tstruct _FloatRates noattr)))
                                   (Tstruct _FloatRates noattr))
                                 (Tstruct _FloatRates noattr)) _p tfloat)
                             tfloat) tfloat)
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
                       (Ebinop Omul (Evalof (Evar _c tfloat) tfloat)
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
                                 (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
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
                               (Evar _r (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                     tfloat) tfloat) tdouble) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat)
                 (Ebinop Omul
                   (Eunop Oneg
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                     tdouble)
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
                                       (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                       (tptr (Tstruct _FloatRates noattr)))
                                     (Tstruct _FloatRates noattr))
                                   (Tstruct _FloatRates noattr)) _q tfloat)
                               tfloat) tfloat)
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
                                     (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                     (tptr (Tstruct _FloatRates noattr)))
                                   (Tstruct _FloatRates noattr))
                                 (Tstruct _FloatRates noattr)) _r tfloat)
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
                       (Ebinop Omul (Evalof (Evar _c tfloat) tfloat)
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
                                 (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                       tfloat) tfloat) tdouble) tfloat))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _qd (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat)
                 (Ebinop Omul
                   (Eunop Oneg
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                     tdouble)
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
                                       (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                       (tptr (Tstruct _FloatRates noattr)))
                                     (Tstruct _FloatRates noattr))
                                   (Tstruct _FloatRates noattr)) _r tfloat)
                               tfloat) tfloat)
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
                                     (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                     (tptr (Tstruct _FloatRates noattr)))
                                   (Tstruct _FloatRates noattr))
                                 (Tstruct _FloatRates noattr)) _q tfloat)
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
                                   (Evar _r (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _p tfloat)
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
                     (Ebinop Omul (Evalof (Evar _c tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                       tfloat) tfloat) tdouble) tfloat)))))))
|}.

Definition f_float_quat_of_eulers := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_e, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := ((_phi2, tfloat) :: (_theta2, tfloat) :: (_psi2, tfloat) ::
              (_s_phi2, tfloat) :: (_c_phi2, tfloat) ::
              (_s_theta2, tfloat) :: (_c_theta2, tfloat) ::
              (_s_psi2, tfloat) :: (_c_psi2, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _phi2 tfloat)
         (Ebinop Odiv
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                     (tptr (Tstruct _FloatEulers noattr)))
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
           (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _theta2 tfloat)
           (Ebinop Odiv
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _psi2 tfloat)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
               tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _s_phi2 tfloat)
               (Ecall
                 (Evalof
                   (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _phi2 tfloat) tfloat) Enil) tfloat)
               tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _c_phi2 tfloat)
                 (Ecall
                   (Evalof
                     (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs (Evalof (Evar _phi2 tfloat) tfloat) Enil) tfloat)
                 tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _s_theta2 tfloat)
                   (Ecall
                     (Evalof
                       (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _theta2 tfloat) tfloat) Enil)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _c_theta2 tfloat)
                     (Ecall
                       (Evalof
                         (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _theta2 tfloat) tfloat) Enil)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _s_psi2 tfloat)
                       (Ecall
                         (Evalof
                           (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                         cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _psi2 tfloat) tfloat) Enil)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _c_psi2 tfloat)
                         (Ecall
                           (Evalof
                             (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _psi2 tfloat) tfloat) Enil)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qi tfloat)
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _c_phi2 tfloat) tfloat)
                                 (Evalof (Evar _c_theta2 tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _c_psi2 tfloat) tfloat) tfloat)
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _s_phi2 tfloat) tfloat)
                                 (Evalof (Evar _s_theta2 tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _s_psi2 tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Eunop Oneg
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_theta2 tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _s_psi2 tfloat) tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _s_phi2 tfloat) tfloat)
                                   (Evalof (Evar _c_theta2 tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _c_psi2 tfloat) tfloat)
                                 tfloat) tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qy tfloat)
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     (Evalof (Evar _s_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _c_psi2 tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_phi2 tfloat) tfloat)
                                     (Evalof (Evar _c_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_psi2 tfloat) tfloat)
                                   tfloat) tfloat) tfloat))
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qz tfloat)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     (Evalof (Evar _c_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_psi2 tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_phi2 tfloat) tfloat)
                                     (Evalof (Evar _s_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _c_psi2 tfloat) tfloat)
                                   tfloat) tfloat) tfloat))))))))))))))
|}.

Definition f_float_quat_of_eulers_zxy := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_e, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := ((_phi2, tfloat) :: (_theta2, tfloat) :: (_psi2, tfloat) ::
              (_s_phi2, tfloat) :: (_c_phi2, tfloat) ::
              (_s_theta2, tfloat) :: (_c_theta2, tfloat) ::
              (_s_psi2, tfloat) :: (_c_psi2, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _phi2 tfloat)
         (Ebinop Odiv
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                     (tptr (Tstruct _FloatEulers noattr)))
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
           (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _theta2 tfloat)
           (Ebinop Odiv
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _psi2 tfloat)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
               tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _s_phi2 tfloat)
               (Ecall
                 (Evalof
                   (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _phi2 tfloat) tfloat) Enil) tfloat)
               tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _c_phi2 tfloat)
                 (Ecall
                   (Evalof
                     (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs (Evalof (Evar _phi2 tfloat) tfloat) Enil) tfloat)
                 tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _s_theta2 tfloat)
                   (Ecall
                     (Evalof
                       (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _theta2 tfloat) tfloat) Enil)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _c_theta2 tfloat)
                     (Ecall
                       (Evalof
                         (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _theta2 tfloat) tfloat) Enil)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _s_psi2 tfloat)
                       (Ecall
                         (Evalof
                           (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                         cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _psi2 tfloat) tfloat) Enil)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _c_psi2 tfloat)
                         (Ecall
                           (Evalof
                             (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _psi2 tfloat) tfloat) Enil)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qi tfloat)
                           (Ebinop Osub
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _c_phi2 tfloat) tfloat)
                                 (Evalof (Evar _c_theta2 tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _c_psi2 tfloat) tfloat) tfloat)
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _s_phi2 tfloat) tfloat)
                                 (Evalof (Evar _s_theta2 tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _s_psi2 tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             (Ebinop Osub
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _s_phi2 tfloat) tfloat)
                                   (Evalof (Evar _c_theta2 tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _c_psi2 tfloat) tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _c_phi2 tfloat) tfloat)
                                   (Evalof (Evar _s_theta2 tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _s_psi2 tfloat) tfloat)
                                 tfloat) tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qy tfloat)
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     (Evalof (Evar _s_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _c_psi2 tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_phi2 tfloat) tfloat)
                                     (Evalof (Evar _c_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_psi2 tfloat) tfloat)
                                   tfloat) tfloat) tfloat))
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qz tfloat)
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_phi2 tfloat) tfloat)
                                     (Evalof (Evar _s_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _c_psi2 tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     (Evalof (Evar _c_theta2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_psi2 tfloat) tfloat)
                                   tfloat) tfloat) tfloat))))))))))))))
|}.

Definition f_float_quat_of_eulers_yxz := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_e, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := ((_phi2, tfloat) :: (_theta2, tfloat) :: (_psi2, tfloat) ::
              (_s_phi2, tfloat) :: (_c_phi2, tfloat) ::
              (_s_theta2, tfloat) :: (_c_theta2, tfloat) ::
              (_s_psi2, tfloat) :: (_c_psi2, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _phi2 tfloat)
         (Ebinop Odiv
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                     (tptr (Tstruct _FloatEulers noattr)))
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
           (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _theta2 tfloat)
           (Ebinop Odiv
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _psi2 tfloat)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                         (tptr (Tstruct _FloatEulers noattr)))
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
               (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
               tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _s_phi2 tfloat)
               (Ecall
                 (Evalof
                   (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _phi2 tfloat) tfloat) Enil) tfloat)
               tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _c_phi2 tfloat)
                 (Ecall
                   (Evalof
                     (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                   cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs (Evalof (Evar _phi2 tfloat) tfloat) Enil) tfloat)
                 tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _s_theta2 tfloat)
                   (Ecall
                     (Evalof
                       (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                     cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _theta2 tfloat) tfloat) Enil)
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign (Evar _c_theta2 tfloat)
                     (Ecall
                       (Evalof
                         (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _theta2 tfloat) tfloat) Enil)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign (Evar _s_psi2 tfloat)
                       (Ecall
                         (Evalof
                           (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                         cc_default))
                           (Tfunction (tfloat :: nil) tfloat cc_default))
                         (Econs (Evalof (Evar _psi2 tfloat) tfloat) Enil)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _c_psi2 tfloat)
                         (Ecall
                           (Evalof
                             (Evar _cosf (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _psi2 tfloat) tfloat) Enil)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qi tfloat)
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _c_theta2 tfloat) tfloat)
                                 (Evalof (Evar _c_phi2 tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _c_psi2 tfloat) tfloat) tfloat)
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _s_theta2 tfloat) tfloat)
                                 (Evalof (Evar _s_phi2 tfloat) tfloat)
                                 tfloat)
                               (Evalof (Evar _s_psi2 tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _c_theta2 tfloat) tfloat)
                                   (Evalof (Evar _s_phi2 tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _c_psi2 tfloat) tfloat)
                                 tfloat)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _s_theta2 tfloat) tfloat)
                                   (Evalof (Evar _c_phi2 tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _s_psi2 tfloat) tfloat)
                                 tfloat) tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qy tfloat)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_theta2 tfloat) tfloat)
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _c_psi2 tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_theta2 tfloat) tfloat)
                                     (Evalof (Evar _s_phi2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_psi2 tfloat) tfloat)
                                   tfloat) tfloat) tfloat))
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                       (tptr (Tstruct _FloatQuat noattr)))
                                     (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qz tfloat)
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _c_theta2 tfloat) tfloat)
                                     (Evalof (Evar _c_phi2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _s_psi2 tfloat) tfloat)
                                   tfloat)
                                 (Ebinop Omul
                                   (Ebinop Omul
                                     (Evalof (Evar _s_theta2 tfloat) tfloat)
                                     (Evalof (Evar _s_phi2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _c_psi2 tfloat) tfloat)
                                   tfloat) tfloat) tfloat))))))))))))))
|}.

Definition f_float_quat_of_axis_angle := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_uv, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_angle, tfloat) :: nil);
  fn_vars := ((_san, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _san tfloat)
         (Ecall
           (Evalof (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Odiv (Evalof (Evar _angle tfloat) tfloat)
               (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
               tfloat) Enil) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qi tfloat)
           (Ecall
             (Evalof
               (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
               (Tfunction (tfloat :: nil) tfloat cc_default))
             (Econs
               (Ebinop Odiv (Evalof (Evar _angle tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                 tfloat) Enil) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat)
             (Ebinop Omul (Evalof (Evar _san tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat) tfloat)
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
               (Ebinop Omul (Evalof (Evar _san tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qz tfloat)
               (Ebinop Omul (Evalof (Evar _san tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _uv (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                 tfloat) tfloat))))))
|}.

Definition f_float_quat_of_orientation_vect := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_ov, (tptr (Tstruct _FloatVect3 noattr))) :: nil);
  fn_vars := ((_ov_norm, tfloat) :: (_s2_normalized, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _ov_norm tfloat)
         (Ecall
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
                             (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
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
                             (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
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
                           (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Olt (Evalof (Evar _ov_norm tfloat) tfloat)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4487126258331716666))) tdouble)
                 tint)
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qi tfloat) (Eval (Vint (Int.repr 1)) tint) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat)
               (Eval (Vint (Int.repr 0)) tint) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat)
                 (Eval (Vint (Int.repr 0)) tint) tfloat))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat)
                 (Eval (Vint (Int.repr 0)) tint) tfloat)))))
    (Ssequence
      (Sdo (Eassign (Evar _s2_normalized tfloat)
             (Ebinop Odiv
               (Ecall
                 (Evalof
                   (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ebinop Odiv (Evalof (Evar _ov_norm tfloat) tfloat)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     tdouble) Enil) tfloat)
               (Evalof (Evar _ov_norm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qi tfloat)
               (Ecall
                 (Evalof
                   (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ebinop Odiv (Evalof (Evar _ov_norm tfloat) tfloat)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     tdouble) Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qx tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                   (Evalof (Evar _s2_normalized tfloat) tfloat) tfloat)
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
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                     (Evalof (Evar _s2_normalized tfloat) tfloat) tfloat)
                   tfloat))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _ov (tptr (Tstruct _FloatVect3 noattr)))
                               (tptr (Tstruct _FloatVect3 noattr)))
                             (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                     (Evalof (Evar _s2_normalized tfloat) tfloat) tfloat)
                   tfloat))))))))
|}.

Definition f_float_quat_of_rmat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _FloatQuat noattr))) ::
                (_rm, (tptr (Tstruct _FloatRMat noattr))) :: nil);
  fn_vars := ((_tr, tfloat) :: (_two_qi, tfloat) :: (_four_qi, tfloat) ::
              (_two_qx, tfloat) :: (_four_qx, tfloat) :: (_two_qy, tfloat) ::
              (_four_qy, tfloat) :: (_two_qz, tfloat) ::
              (_four_qz, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tr tfloat)
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
                             (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9))
                   (Ebinop Oadd
                     (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                       (Eval (Vint (Int.repr 3)) tint) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint) (tptr tfloat))
                 tfloat) tfloat)
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
                     (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                 tfloat) tfloat) tfloat)
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
                   (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                     (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) (tptr tfloat))
               tfloat) tfloat) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _tr tfloat) tfloat)
                 (Eval (Vint (Int.repr 0)) tint) tint)
    (Ssequence
      (Sdo (Eassign (Evar _two_qi tfloat)
             (Ecall
               (Evalof
                 (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Tfunction (tfloat :: nil) tfloat cc_default))
               (Econs
                 (Ebinop Oadd
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                   (Evalof (Evar _tr tfloat) tfloat) tdouble) Enil) tfloat)
             tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _four_qi tfloat)
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                 (Evalof (Evar _two_qi tfloat) tfloat) tdouble) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qi tfloat)
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                   (Evalof (Evar _two_qi tfloat) tfloat) tdouble) tfloat))
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
                     (Ebinop Osub
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
                             (tptr tfloat)) tfloat) tfloat)
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
                               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (tptr tfloat)) tfloat) tfloat) tfloat)
                     (Evalof (Evar _four_qi tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qy tfloat)
                     (Ebinop Odiv
                       (Ebinop Osub
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat)
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 2)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
                       (Evalof (Evar _four_qi tfloat) tfloat) tfloat) tfloat))
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qz tfloat)
                     (Ebinop Odiv
                       (Ebinop Osub
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat)
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
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
                       (Evalof (Evar _four_qi tfloat) tfloat) tfloat) tfloat)))))))
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
                                     (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                     (tptr (Tstruct _FloatRMat noattr)))
                                   (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Ebinop Oadd
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat)
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
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat) tint)
                   (Ebinop Ogt
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
                             (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat)
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
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat) tint) tint)
      (Ssequence
        (Sdo (Eassign (Evar _two_qx tfloat)
               (Ecall
                 (Evalof
                   (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
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
                                         (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                         (tptr (Tstruct _FloatRMat noattr)))
                                       (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Ebinop Oadd
                                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat)
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
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
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
                               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 2)) tint) tint)
                             (tptr tfloat)) tfloat) tfloat) tfloat)
                     (Eval (Vint (Int.repr 1)) tint) tfloat) Enil) tfloat)
               tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _four_qx tfloat)
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   (Evalof (Evar _two_qx tfloat) tfloat) tdouble) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat)
                   (Ebinop Odiv
                     (Ebinop Osub
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
                             (tptr tfloat)) tfloat) tfloat)
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
                               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                 (Eval (Vint (Int.repr 3)) tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (tptr tfloat)) tfloat) tfloat) tfloat)
                     (Evalof (Evar _four_qx tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat)
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                       (Evalof (Evar _two_qx tfloat) tfloat) tdouble) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qy tfloat)
                       (Ebinop Odiv
                         (Ebinop Oadd
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat)
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         (Evalof (Evar _four_qx tfloat) tfloat) tfloat)
                       tfloat))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qz tfloat)
                       (Ebinop Odiv
                         (Ebinop Oadd
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat)
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 2)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         (Evalof (Evar _four_qx tfloat) tfloat) tfloat)
                       tfloat)))))))
      (Sifthenelse (Ebinop Ogt
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
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat)
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
                             (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                               (Eval (Vint (Int.repr 3)) tint) tint)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (tptr tfloat)) tfloat) tfloat) tint)
        (Ssequence
          (Sdo (Eassign (Evar _two_qy tfloat)
                 (Ecall
                   (Evalof
                     (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat
                                    cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
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
                                           (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat)
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 2)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
                       (Eval (Vint (Int.repr 1)) tint) tfloat) Enil) tfloat)
                 tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _four_qy tfloat)
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     (Evalof (Evar _two_qy tfloat) tfloat) tdouble) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat)
                     (Ebinop Odiv
                       (Ebinop Osub
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat)
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 2)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
                       (Evalof (Evar _four_qy tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qx tfloat)
                       (Ebinop Odiv
                         (Ebinop Oadd
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat)
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         (Evalof (Evar _four_qy tfloat) tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qy tfloat)
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                           (Evalof (Evar _two_qy tfloat) tfloat) tdouble)
                         tfloat))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat)
                         (Ebinop Odiv
                           (Ebinop Oadd
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tfloat)) tfloat) tfloat)
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Evalof (Evar _four_qy tfloat) tfloat) tfloat)
                         tfloat)))))))
        (Ssequence
          (Sdo (Eassign (Evar _two_qz tfloat)
                 (Ecall
                   (Evalof
                     (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat
                                    cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs
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
                                           (Evar _rm (tptr (Tstruct _FloatRMat noattr)))
                                           (tptr (Tstruct _FloatRMat noattr)))
                                         (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 2)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat)
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
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
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
                       (Eval (Vint (Int.repr 1)) tint) tfloat) Enil) tfloat)
                 tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _four_qz tfloat)
                   (Ebinop Omul
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                     (Evalof (Evar _two_qz tfloat) tfloat) tdouble) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat)
                     (Ebinop Odiv
                       (Ebinop Osub
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
                                 (Ebinop Omul (Eval (Vint (Int.repr 0)) tint)
                                   (Eval (Vint (Int.repr 3)) tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat)
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
                                 (Eval (Vint (Int.repr 0)) tint) tint)
                               (tptr tfloat)) tfloat) tfloat) tfloat)
                       (Evalof (Evar _four_qz tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qx tfloat)
                       (Ebinop Odiv
                         (Ebinop Oadd
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat)
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
                                   (Ebinop Omul
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (Eval (Vint (Int.repr 3)) tint) tint)
                                   (Eval (Vint (Int.repr 2)) tint) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         (Evalof (Evar _four_qz tfloat) tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qy tfloat)
                         (Ebinop Odiv
                           (Ebinop Oadd
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tfloat)) tfloat) tfloat)
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Evalof (Evar _four_qz tfloat) tfloat) tfloat)
                         tfloat))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qz tfloat)
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                           (Evalof (Evar _two_qz tfloat) tfloat) tdouble)
                         tfloat)))))))))))
|}.

Definition f_float_quat_tilt_twist := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_tilt, (tptr (Tstruct _FloatQuat noattr))) ::
                (_twist, (tptr (Tstruct _FloatQuat noattr))) ::
                (_quat, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := ((_z, (Tstruct _FloatVect3 noattr)) ::
              (_z_rot, (Tstruct _FloatVect3 noattr)) ::
              (_qinv, (Tstruct _FloatQuat noattr)) ::
              (_axis, (Tstruct _FloatVect3 noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
             (Tstruct _FloatVect3 noattr)) _x tfloat)
         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
               (Tstruct _FloatVect3 noattr)) _y tfloat)
           (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                 (Tstruct _FloatVect3 noattr)) _z tfloat)
             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
             tfloat))
      (Ssequence
        (Sdo (Ecall
               (Evalof
                 (Evar _float_quat_invert (Tfunction
                                            ((tptr (Tstruct _FloatQuat noattr)) ::
                                             (tptr (Tstruct _FloatQuat noattr)) ::
                                             nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _FloatQuat noattr)) ::
                    (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof (Evar _qinv (Tstruct _FloatQuat noattr))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Econs
                   (Evalof (Evar _quat (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr))) Enil)) tvoid))
        (Ssequence
          (Sdo (Ecall
                 (Evalof
                   (Evar _float_quat_vmult (Tfunction
                                             ((tptr (Tstruct _FloatVect3 noattr)) ::
                                              (tptr (Tstruct _FloatQuat noattr)) ::
                                              (tptr (Tstruct _FloatVect3 noattr)) ::
                                              nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _FloatVect3 noattr)) ::
                      (tptr (Tstruct _FloatQuat noattr)) ::
                      (tptr (Tstruct _FloatVect3 noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof (Evar _z_rot (Tstruct _FloatVect3 noattr))
                     (tptr (Tstruct _FloatVect3 noattr)))
                   (Econs
                     (Eaddrof (Evar _qinv (Tstruct _FloatQuat noattr))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Econs
                       (Eaddrof (Evar _z (Tstruct _FloatVect3 noattr))
                         (tptr (Tstruct _FloatVect3 noattr))) Enil))) tvoid))
          (Ssequence
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof (Evar _axis (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _x tfloat)
                     (Ebinop Osub
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _y tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _z_rot (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _z tfloat)
                           tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _z tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _z_rot (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _y tfloat)
                           tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _axis (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _y tfloat)
                       (Ebinop Osub
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _z tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_rot (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _x tfloat)
                             tfloat) tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _x tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_rot (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _z tfloat)
                             tfloat) tfloat) tfloat) tfloat))
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _axis (Tstruct _FloatVect3 noattr))
                           (Tstruct _FloatVect3 noattr)) _z tfloat)
                       (Ebinop Osub
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _x tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_rot (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _y tfloat)
                             tfloat) tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof (Evar _z (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _y tfloat)
                             tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _z_rot (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _x tfloat)
                             tfloat) tfloat) tfloat) tfloat))))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _tilt (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat)
                     (Ebinop Oadd (Eval (Vint (Int.repr 1)) tint)
                       (Evalof
                         (Efield
                           (Evalof (Evar _z_rot (Tstruct _FloatVect3 noattr))
                             (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                       tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _tilt (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qx tfloat)
                       (Evalof
                         (Efield
                           (Evalof (Evar _axis (Tstruct _FloatVect3 noattr))
                             (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _tilt (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qy tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _axis (Tstruct _FloatVect3 noattr))
                               (Tstruct _FloatVect3 noattr)) _y tfloat)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _tilt (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qz tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _axis (Tstruct _FloatVect3 noattr))
                                 (Tstruct _FloatVect3 noattr)) _z tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sdo (Ecall
                             (Evalof
                               (Evar _float_quat_normalize (Tfunction
                                                             ((tptr (Tstruct _FloatQuat noattr)) ::
                                                              nil) tvoid
                                                             cc_default))
                               (Tfunction
                                 ((tptr (Tstruct _FloatQuat noattr)) :: nil)
                                 tvoid cc_default))
                             (Econs
                               (Evalof
                                 (Evar _tilt (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr))) Enil)
                             tvoid))
                      (Sdo (Ecall
                             (Evalof
                               (Evar _float_quat_inv_comp_norm_shortest 
                               (Tfunction
                                 ((tptr (Tstruct _FloatQuat noattr)) ::
                                  (tptr (Tstruct _FloatQuat noattr)) ::
                                  (tptr (Tstruct _FloatQuat noattr)) :: nil)
                                 tvoid cc_default))
                               (Tfunction
                                 ((tptr (Tstruct _FloatQuat noattr)) ::
                                  (tptr (Tstruct _FloatQuat noattr)) ::
                                  (tptr (Tstruct _FloatQuat noattr)) :: nil)
                                 tvoid cc_default))
                             (Econs
                               (Evalof
                                 (Evar _twist (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Econs
                                 (Evalof
                                   (Evar _tilt (tptr (Tstruct _FloatQuat noattr)))
                                   (tptr (Tstruct _FloatQuat noattr)))
                                 (Econs
                                   (Evalof
                                     (Evar _quat (tptr (Tstruct _FloatQuat noattr)))
                                     (tptr (Tstruct _FloatQuat noattr)))
                                   Enil))) tvoid)))))))))))))
|}.

Definition f_float_eulers_of_rmat := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _FloatEulers noattr))) ::
                (_rm, (tptr (Tstruct _FloatRMat noattr))) :: nil);
  fn_vars := ((_dcm00, tfloat) :: (_dcm01, tfloat) :: (_dcm02, tfloat) ::
              (_dcm12, tfloat) :: (_dcm22, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _dcm00 tfloat)
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
                 (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
               (tptr tfloat)) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _dcm01 tfloat)
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
                   (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
                 (tptr tfloat)) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _dcm02 tfloat)
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
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _dcm12 tfloat)
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
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 5)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _dcm22 tfloat)
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
                       (Eval (Vint (Int.repr 8)) tint) (tptr tfloat)) tfloat)
                   tfloat) tfloat))
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
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                             (tptr (Tstruct _FloatEulers noattr)))
                           (Tstruct _FloatEulers noattr))
                         (Tstruct _FloatEulers noattr)) _phi tfloat)
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
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _theta tfloat)
                       (Eunop Oneg
                         (Ecall
                           (Evalof
                             (Evar _asinf (Tfunction (tfloat :: nil) tfloat
                                            cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _dcm02 tfloat) tfloat) Enil)
                           tfloat) tfloat) tfloat))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                               (tptr (Tstruct _FloatEulers noattr)))
                             (Tstruct _FloatEulers noattr))
                           (Tstruct _FloatEulers noattr)) _psi tfloat)
                       (Ecall
                         (Evalof
                           (Evar _atan2f (Tfunction (tfloat :: tfloat :: nil)
                                           tfloat cc_default))
                           (Tfunction (tfloat :: tfloat :: nil) tfloat
                             cc_default))
                         (Econs (Evalof (Evar _dcm01 tfloat) tfloat)
                           (Econs (Evalof (Evar _dcm00 tfloat) tfloat) Enil))
                         tfloat) tfloat))))))))))
|}.

Definition f_float_eulers_of_quat_yxz := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _FloatEulers noattr))) ::
                (_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := ((_qx2, tfloat) :: (_qy2, tfloat) :: (_qz2, tfloat) ::
              (_qi2, tfloat) :: (_qiqx, tfloat) :: (_qiqy, tfloat) ::
              (_qiqz, tfloat) :: (_qxqy, tfloat) :: (_qxqz, tfloat) ::
              (_qyqz, tfloat) :: (_r11, tfloat) :: (_r12, tfloat) ::
              (_r21, tfloat) :: (_r31, tfloat) :: (_r32, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qx2 tfloat)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat) tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _qy2 tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
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
      (Sdo (Eassign (Evar _qz2 tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)
             tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _qi2 tfloat)
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
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _qiqx tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _qiqy tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
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
              (Sdo (Eassign (Evar _qiqz tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
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
                (Sdo (Eassign (Evar _qxqy tfloat)
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
                               (Tstruct _FloatQuat noattr)) _qy tfloat)
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _qxqz tfloat)
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
                                 (Tstruct _FloatQuat noattr)) _qz tfloat)
                             tfloat) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _qyqz tfloat)
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
                                   (Tstruct _FloatQuat noattr)) _qz tfloat)
                               tfloat) tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign (Evar _r11 tfloat)
                             (Ebinop Omul
                               (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                               (Ebinop Oadd
                                 (Evalof (Evar _qxqz tfloat) tfloat)
                                 (Evalof (Evar _qiqy tfloat) tfloat) tfloat)
                               tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign (Evar _r12 tfloat)
                               (Ebinop Oadd
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Evalof (Evar _qi2 tfloat) tfloat)
                                     (Evalof (Evar _qx2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _qy2 tfloat) tfloat) tfloat)
                                 (Evalof (Evar _qz2 tfloat) tfloat) tfloat)
                               tfloat))
                        (Ssequence
                          (Sdo (Eassign (Evar _r21 tfloat)
                                 (Ebinop Omul
                                   (Eunop Oneg
                                     (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                                     tfloat)
                                   (Ebinop Osub
                                     (Evalof (Evar _qyqz tfloat) tfloat)
                                     (Evalof (Evar _qiqx tfloat) tfloat)
                                     tfloat) tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign (Evar _r31 tfloat)
                                   (Ebinop Omul
                                     (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                                     (Ebinop Oadd
                                       (Evalof (Evar _qxqy tfloat) tfloat)
                                       (Evalof (Evar _qiqz tfloat) tfloat)
                                       tfloat) tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign (Evar _r32 tfloat)
                                     (Ebinop Osub
                                       (Ebinop Oadd
                                         (Ebinop Osub
                                           (Evalof (Evar _qi2 tfloat) tfloat)
                                           (Evalof (Evar _qx2 tfloat) tfloat)
                                           tfloat)
                                         (Evalof (Evar _qy2 tfloat) tfloat)
                                         tfloat)
                                       (Evalof (Evar _qz2 tfloat) tfloat)
                                       tfloat) tfloat))
                              (Ssequence
                                (Sifthenelse (Eunop Onotbool
                                               (Ebinop Ogt
                                                 (Evalof (Evar _r21 tfloat)
                                                   tfloat)
                                                 (Eunop Oneg
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                   tdouble) tint) tint)
                                  (Sdo (Eassign (Evar _r21 tfloat)
                                         (Eunop Oneg
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                           tdouble) tfloat))
                                  (Sifthenelse (Eunop Onotbool
                                                 (Ebinop Olt
                                                   (Evalof (Evar _r21 tfloat)
                                                     tfloat)
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                   tint) tint)
                                    (Sdo (Eassign (Evar _r21 tfloat)
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                           tfloat))
                                    Sskip))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                                 (tptr (Tstruct _FloatEulers noattr)))
                                               (Tstruct _FloatEulers noattr))
                                             (Tstruct _FloatEulers noattr))
                                           _theta tfloat)
                                         (Ecall
                                           (Evalof
                                             (Evar _atan2f (Tfunction
                                                             (tfloat ::
                                                              tfloat :: nil)
                                                             tfloat
                                                             cc_default))
                                             (Tfunction
                                               (tfloat :: tfloat :: nil)
                                               tfloat cc_default))
                                           (Econs
                                             (Evalof (Evar _r11 tfloat)
                                               tfloat)
                                             (Econs
                                               (Evalof (Evar _r12 tfloat)
                                                 tfloat) Enil)) tfloat)
                                         tfloat))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                                   (tptr (Tstruct _FloatEulers noattr)))
                                                 (Tstruct _FloatEulers noattr))
                                               (Tstruct _FloatEulers noattr))
                                             _phi tfloat)
                                           (Ecall
                                             (Evalof
                                               (Evar _asinf (Tfunction
                                                              (tfloat :: nil)
                                                              tfloat
                                                              cc_default))
                                               (Tfunction (tfloat :: nil)
                                                 tfloat cc_default))
                                             (Econs
                                               (Evalof (Evar _r21 tfloat)
                                                 tfloat) Enil) tfloat)
                                           tfloat))
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                                   (tptr (Tstruct _FloatEulers noattr)))
                                                 (Tstruct _FloatEulers noattr))
                                               (Tstruct _FloatEulers noattr))
                                             _psi tfloat)
                                           (Ecall
                                             (Evalof
                                               (Evar _atan2f (Tfunction
                                                               (tfloat ::
                                                                tfloat ::
                                                                nil) tfloat
                                                               cc_default))
                                               (Tfunction
                                                 (tfloat :: tfloat :: nil)
                                                 tfloat cc_default))
                                             (Econs
                                               (Evalof (Evar _r31 tfloat)
                                                 tfloat)
                                               (Econs
                                                 (Evalof (Evar _r32 tfloat)
                                                   tfloat) Enil)) tfloat)
                                           tfloat))))))))))))))))))))
|}.

Definition f_float_eulers_of_quat_zxy := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_e, (tptr (Tstruct _FloatEulers noattr))) ::
                (_q, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := ((_qx2, tfloat) :: (_qy2, tfloat) :: (_qz2, tfloat) ::
              (_qi2, tfloat) :: (_qiqx, tfloat) :: (_qiqy, tfloat) ::
              (_qiqz, tfloat) :: (_qxqy, tfloat) :: (_qxqz, tfloat) ::
              (_qyqz, tfloat) :: (_r11, tfloat) :: (_r12, tfloat) ::
              (_r21, tfloat) :: (_r31, tfloat) :: (_r32, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _qx2 tfloat)
         (Ebinop Omul
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat) tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _qy2 tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
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
      (Sdo (Eassign (Evar _qz2 tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)
             tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _qi2 tfloat)
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
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _qiqx tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign (Evar _qiqy tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                               (tptr (Tstruct _FloatQuat noattr)))
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
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
              (Sdo (Eassign (Evar _qiqz tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _q (tptr (Tstruct _FloatQuat noattr)))
                                 (tptr (Tstruct _FloatQuat noattr)))
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
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
                (Sdo (Eassign (Evar _qxqy tfloat)
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
                               (Tstruct _FloatQuat noattr)) _qy tfloat)
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _qxqz tfloat)
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
                                 (Tstruct _FloatQuat noattr)) _qz tfloat)
                             tfloat) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign (Evar _qyqz tfloat)
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
                                   (Tstruct _FloatQuat noattr)) _qz tfloat)
                               tfloat) tfloat) tfloat))
                    (Ssequence
                      (Sdo (Eassign (Evar _r11 tfloat)
                             (Ebinop Omul
                               (Eunop Oneg (Eval (Vint (Int.repr 2)) tint)
                                 tint)
                               (Ebinop Osub
                                 (Evalof (Evar _qxqy tfloat) tfloat)
                                 (Evalof (Evar _qiqz tfloat) tfloat) tfloat)
                               tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign (Evar _r12 tfloat)
                               (Ebinop Osub
                                 (Ebinop Oadd
                                   (Ebinop Osub
                                     (Evalof (Evar _qi2 tfloat) tfloat)
                                     (Evalof (Evar _qx2 tfloat) tfloat)
                                     tfloat)
                                   (Evalof (Evar _qy2 tfloat) tfloat) tfloat)
                                 (Evalof (Evar _qz2 tfloat) tfloat) tfloat)
                               tfloat))
                        (Ssequence
                          (Sdo (Eassign (Evar _r21 tfloat)
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Ebinop Oadd
                                     (Evalof (Evar _qyqz tfloat) tfloat)
                                     (Evalof (Evar _qiqx tfloat) tfloat)
                                     tfloat) tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign (Evar _r31 tfloat)
                                   (Ebinop Omul
                                     (Eunop Oneg
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     (Ebinop Osub
                                       (Evalof (Evar _qxqz tfloat) tfloat)
                                       (Evalof (Evar _qiqy tfloat) tfloat)
                                       tfloat) tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign (Evar _r32 tfloat)
                                     (Ebinop Oadd
                                       (Ebinop Osub
                                         (Ebinop Osub
                                           (Evalof (Evar _qi2 tfloat) tfloat)
                                           (Evalof (Evar _qx2 tfloat) tfloat)
                                           tfloat)
                                         (Evalof (Evar _qy2 tfloat) tfloat)
                                         tfloat)
                                       (Evalof (Evar _qz2 tfloat) tfloat)
                                       tfloat) tfloat))
                              (Ssequence
                                (Sifthenelse (Eunop Onotbool
                                               (Ebinop Ogt
                                                 (Evalof (Evar _r21 tfloat)
                                                   tfloat)
                                                 (Eunop Oneg
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                   tdouble) tint) tint)
                                  (Sdo (Eassign (Evar _r21 tfloat)
                                         (Eunop Oneg
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                           tdouble) tfloat))
                                  (Sifthenelse (Eunop Onotbool
                                                 (Ebinop Olt
                                                   (Evalof (Evar _r21 tfloat)
                                                     tfloat)
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                   tint) tint)
                                    (Sdo (Eassign (Evar _r21 tfloat)
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                           tfloat))
                                    Sskip))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                                 (tptr (Tstruct _FloatEulers noattr)))
                                               (Tstruct _FloatEulers noattr))
                                             (Tstruct _FloatEulers noattr))
                                           _psi tfloat)
                                         (Ecall
                                           (Evalof
                                             (Evar _atan2f (Tfunction
                                                             (tfloat ::
                                                              tfloat :: nil)
                                                             tfloat
                                                             cc_default))
                                             (Tfunction
                                               (tfloat :: tfloat :: nil)
                                               tfloat cc_default))
                                           (Econs
                                             (Evalof (Evar _r11 tfloat)
                                               tfloat)
                                             (Econs
                                               (Evalof (Evar _r12 tfloat)
                                                 tfloat) Enil)) tfloat)
                                         tfloat))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                                   (tptr (Tstruct _FloatEulers noattr)))
                                                 (Tstruct _FloatEulers noattr))
                                               (Tstruct _FloatEulers noattr))
                                             _phi tfloat)
                                           (Ecall
                                             (Evalof
                                               (Evar _asinf (Tfunction
                                                              (tfloat :: nil)
                                                              tfloat
                                                              cc_default))
                                               (Tfunction (tfloat :: nil)
                                                 tfloat cc_default))
                                             (Econs
                                               (Evalof (Evar _r21 tfloat)
                                                 tfloat) Enil) tfloat)
                                           tfloat))
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _e (tptr (Tstruct _FloatEulers noattr)))
                                                   (tptr (Tstruct _FloatEulers noattr)))
                                                 (Tstruct _FloatEulers noattr))
                                               (Tstruct _FloatEulers noattr))
                                             _theta tfloat)
                                           (Ecall
                                             (Evalof
                                               (Evar _atan2f (Tfunction
                                                               (tfloat ::
                                                                tfloat ::
                                                                nil) tfloat
                                                               cc_default))
                                               (Tfunction
                                                 (tfloat :: tfloat :: nil)
                                                 tfloat cc_default))
                                             (Econs
                                               (Evalof (Evar _r31 tfloat)
                                                 tfloat)
                                               (Econs
                                                 (Evalof (Evar _r32 tfloat)
                                                   tfloat) Enil)) tfloat)
                                           tfloat))))))))))))))))))))
|}.

Definition f_float_mat2_mult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect_out, (tptr (Tstruct _FloatVect2 noattr))) ::
                (_mat, (tptr tfloat)) ::
                (_vect_in, (Tstruct _FloatVect2 noattr)) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vect_out (tptr (Tstruct _FloatVect2 noattr)))
                 (tptr (Tstruct _FloatVect2 noattr)))
               (Tstruct _FloatVect2 noattr)) (Tstruct _FloatVect2 noattr)) _x
           tfloat)
         (Ebinop Oadd
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _vect_in (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _vect_in (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vect_out (tptr (Tstruct _FloatVect2 noattr)))
                 (tptr (Tstruct _FloatVect2 noattr)))
               (Tstruct _FloatVect2 noattr)) (Tstruct _FloatVect2 noattr)) _y
           tfloat)
         (Ebinop Oadd
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _vect_in (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _mat (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 3)) tint) (tptr tfloat)) tfloat)
               tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _vect_in (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat) tfloat)
           tfloat) tfloat)))
|}.

Definition f_float_mat3_mult := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect_out, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_mat, (tptr (tarray tfloat 3))) ::
                (_vect_in, (Tstruct _FloatVect3 noattr)) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _vect_out (tptr (Tstruct _FloatVect3 noattr)))
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
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 0)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 0)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat) tfloat)
             tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                           (tptr (tarray tfloat 3)))
                         (Eval (Vint (Int.repr 0)) tint)
                         (tptr (tarray tfloat 3))) (tarray tfloat 3))
                     (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                   (tptr tfloat)) tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vect_out (tptr (Tstruct _FloatVect3 noattr)))
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
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 1)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 1)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 1)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _vect_out (tptr (Tstruct _FloatVect3 noattr)))
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
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 2)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 tfloat)
               (Ebinop Omul
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                               (tptr (tarray tfloat 3)))
                             (Eval (Vint (Int.repr 2)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tfloat)) tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _mat (tptr (tarray tfloat 3)))
                             (tptr (tarray tfloat 3)))
                           (Eval (Vint (Int.repr 2)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                     (tptr tfloat)) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _vect_in (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat) tfloat)
             tfloat) tfloat))))
|}.

Definition f_float_mat_minor_4d := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_m, (tptr (tarray tfloat 4))) :: (_r0, tint) ::
                (_r1, tint) :: (_r2, tint) :: (_c0, tint) :: (_c1, tint) ::
                (_c2, tint) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Oadd
                 (Ebinop Osub
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Evalof (Evar _r0 tint) tint)
                                 (tptr (tarray tfloat 4))) (tarray tfloat 4))
                             (tarray tfloat 4)) (Evalof (Evar _c0 tint) tint)
                           (tptr tfloat)) tfloat) tfloat)
                     (Ebinop Osub
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r1 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c1 tint) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r2 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c2 tint) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r2 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c1 tint) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r1 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c2 tint) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat) tfloat) tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Evalof (Evar _r0 tint) tint)
                                 (tptr (tarray tfloat 4))) (tarray tfloat 4))
                             (tarray tfloat 4)) (Evalof (Evar _c1 tint) tint)
                           (tptr tfloat)) tfloat) tfloat)
                     (Ebinop Osub
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r1 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c0 tint) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r2 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c2 tint) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r2 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c0 tint) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Evalof (Evar _r1 tint) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _c2 tint) tint) (tptr tfloat))
                             tfloat) tfloat) tfloat) tfloat) tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                 (tptr (tarray tfloat 4)))
                               (Evalof (Evar _r0 tint) tint)
                               (tptr (tarray tfloat 4))) (tarray tfloat 4))
                           (tarray tfloat 4)) (Evalof (Evar _c2 tint) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Ebinop Osub
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Evalof (Evar _r1 tint) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _c0 tint) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Evalof (Evar _r2 tint) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _c1 tint) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Evalof (Evar _r2 tint) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _c0 tint) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Evalof (Evar _r1 tint) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _c1 tint) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat) tfloat) tfloat) tfloat)))
|}.

Definition f_float_mat_adjoint_4d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_adjOut, (tptr (tarray tfloat 4))) ::
                (_m, (tptr (tarray tfloat 4))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _adjOut (tptr (tarray tfloat 4)))
                     (tptr (tarray tfloat 4)))
                   (Eval (Vint (Int.repr 0)) tint) (tptr (tarray tfloat 4)))
                 (tarray tfloat 4)) (tarray tfloat 4))
             (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
         (Ecall
           (Evalof
             (Evar _float_mat_minor_4d (Tfunction
                                         ((tptr (tarray tfloat 4)) :: tint ::
                                          tint :: tint :: tint :: tint ::
                                          tint :: nil) tfloat cc_default))
             (Tfunction
               ((tptr (tarray tfloat 4)) :: tint :: tint :: tint :: tint ::
                tint :: tint :: nil) tfloat cc_default))
           (Econs
             (Evalof (Evar _m (tptr (tarray tfloat 4)))
               (tptr (tarray tfloat 4)))
             (Econs (Eval (Vint (Int.repr 1)) tint)
               (Econs (Eval (Vint (Int.repr 2)) tint)
                 (Econs (Eval (Vint (Int.repr 3)) tint)
                   (Econs (Eval (Vint (Int.repr 1)) tint)
                     (Econs (Eval (Vint (Int.repr 2)) tint)
                       (Econs (Eval (Vint (Int.repr 3)) tint) Enil)))))))
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _adjOut (tptr (tarray tfloat 4)))
                       (tptr (tarray tfloat 4)))
                     (Eval (Vint (Int.repr 0)) tint)
                     (tptr (tarray tfloat 4))) (tarray tfloat 4))
                 (tarray tfloat 4)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tfloat)) tfloat)
           (Eunop Oneg
             (Ecall
               (Evalof
                 (Evar _float_mat_minor_4d (Tfunction
                                             ((tptr (tarray tfloat 4)) ::
                                              tint :: tint :: tint :: tint ::
                                              tint :: tint :: nil) tfloat
                                             cc_default))
                 (Tfunction
                   ((tptr (tarray tfloat 4)) :: tint :: tint :: tint ::
                    tint :: tint :: tint :: nil) tfloat cc_default))
               (Econs
                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                   (tptr (tarray tfloat 4)))
                 (Econs (Eval (Vint (Int.repr 0)) tint)
                   (Econs (Eval (Vint (Int.repr 2)) tint)
                     (Econs (Eval (Vint (Int.repr 3)) tint)
                       (Econs (Eval (Vint (Int.repr 1)) tint)
                         (Econs (Eval (Vint (Int.repr 2)) tint)
                           (Econs (Eval (Vint (Int.repr 3)) tint) Enil)))))))
               tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _adjOut (tptr (tarray tfloat 4)))
                         (tptr (tarray tfloat 4)))
                       (Eval (Vint (Int.repr 0)) tint)
                       (tptr (tarray tfloat 4))) (tarray tfloat 4))
                   (tarray tfloat 4)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tfloat)) tfloat)
             (Ecall
               (Evalof
                 (Evar _float_mat_minor_4d (Tfunction
                                             ((tptr (tarray tfloat 4)) ::
                                              tint :: tint :: tint :: tint ::
                                              tint :: tint :: nil) tfloat
                                             cc_default))
                 (Tfunction
                   ((tptr (tarray tfloat 4)) :: tint :: tint :: tint ::
                    tint :: tint :: tint :: nil) tfloat cc_default))
               (Econs
                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                   (tptr (tarray tfloat 4)))
                 (Econs (Eval (Vint (Int.repr 0)) tint)
                   (Econs (Eval (Vint (Int.repr 1)) tint)
                     (Econs (Eval (Vint (Int.repr 3)) tint)
                       (Econs (Eval (Vint (Int.repr 1)) tint)
                         (Econs (Eval (Vint (Int.repr 2)) tint)
                           (Econs (Eval (Vint (Int.repr 3)) tint) Enil)))))))
               tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _adjOut (tptr (tarray tfloat 4)))
                           (tptr (tarray tfloat 4)))
                         (Eval (Vint (Int.repr 0)) tint)
                         (tptr (tarray tfloat 4))) (tarray tfloat 4))
                     (tarray tfloat 4)) (Eval (Vint (Int.repr 3)) tint)
                   (tptr tfloat)) tfloat)
               (Eunop Oneg
                 (Ecall
                   (Evalof
                     (Evar _float_mat_minor_4d (Tfunction
                                                 ((tptr (tarray tfloat 4)) ::
                                                  tint :: tint :: tint ::
                                                  tint :: tint :: tint ::
                                                  nil) tfloat cc_default))
                     (Tfunction
                       ((tptr (tarray tfloat 4)) :: tint :: tint :: tint ::
                        tint :: tint :: tint :: nil) tfloat cc_default))
                   (Econs
                     (Evalof (Evar _m (tptr (tarray tfloat 4)))
                       (tptr (tarray tfloat 4)))
                     (Econs (Eval (Vint (Int.repr 0)) tint)
                       (Econs (Eval (Vint (Int.repr 1)) tint)
                         (Econs (Eval (Vint (Int.repr 2)) tint)
                           (Econs (Eval (Vint (Int.repr 1)) tint)
                             (Econs (Eval (Vint (Int.repr 2)) tint)
                               (Econs (Eval (Vint (Int.repr 3)) tint) Enil)))))))
                   tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _adjOut (tptr (tarray tfloat 4)))
                             (tptr (tarray tfloat 4)))
                           (Eval (Vint (Int.repr 1)) tint)
                           (tptr (tarray tfloat 4))) (tarray tfloat 4))
                       (tarray tfloat 4)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat)
                 (Eunop Oneg
                   (Ecall
                     (Evalof
                       (Evar _float_mat_minor_4d (Tfunction
                                                   ((tptr (tarray tfloat 4)) ::
                                                    tint :: tint :: tint ::
                                                    tint :: tint :: tint ::
                                                    nil) tfloat cc_default))
                       (Tfunction
                         ((tptr (tarray tfloat 4)) :: tint :: tint :: tint ::
                          tint :: tint :: tint :: nil) tfloat cc_default))
                     (Econs
                       (Evalof (Evar _m (tptr (tarray tfloat 4)))
                         (tptr (tarray tfloat 4)))
                       (Econs (Eval (Vint (Int.repr 1)) tint)
                         (Econs (Eval (Vint (Int.repr 2)) tint)
                           (Econs (Eval (Vint (Int.repr 3)) tint)
                             (Econs (Eval (Vint (Int.repr 0)) tint)
                               (Econs (Eval (Vint (Int.repr 2)) tint)
                                 (Econs (Eval (Vint (Int.repr 3)) tint) Enil)))))))
                     tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _adjOut (tptr (tarray tfloat 4)))
                               (tptr (tarray tfloat 4)))
                             (Eval (Vint (Int.repr 1)) tint)
                             (tptr (tarray tfloat 4))) (tarray tfloat 4))
                         (tarray tfloat 4)) (Eval (Vint (Int.repr 1)) tint)
                       (tptr tfloat)) tfloat)
                   (Ecall
                     (Evalof
                       (Evar _float_mat_minor_4d (Tfunction
                                                   ((tptr (tarray tfloat 4)) ::
                                                    tint :: tint :: tint ::
                                                    tint :: tint :: tint ::
                                                    nil) tfloat cc_default))
                       (Tfunction
                         ((tptr (tarray tfloat 4)) :: tint :: tint :: tint ::
                          tint :: tint :: tint :: nil) tfloat cc_default))
                     (Econs
                       (Evalof (Evar _m (tptr (tarray tfloat 4)))
                         (tptr (tarray tfloat 4)))
                       (Econs (Eval (Vint (Int.repr 0)) tint)
                         (Econs (Eval (Vint (Int.repr 2)) tint)
                           (Econs (Eval (Vint (Int.repr 3)) tint)
                             (Econs (Eval (Vint (Int.repr 0)) tint)
                               (Econs (Eval (Vint (Int.repr 2)) tint)
                                 (Econs (Eval (Vint (Int.repr 3)) tint) Enil)))))))
                     tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _adjOut (tptr (tarray tfloat 4)))
                                 (tptr (tarray tfloat 4)))
                               (Eval (Vint (Int.repr 1)) tint)
                               (tptr (tarray tfloat 4))) (tarray tfloat 4))
                           (tarray tfloat 4)) (Eval (Vint (Int.repr 2)) tint)
                         (tptr tfloat)) tfloat)
                     (Eunop Oneg
                       (Ecall
                         (Evalof
                           (Evar _float_mat_minor_4d (Tfunction
                                                       ((tptr (tarray tfloat 4)) ::
                                                        tint :: tint ::
                                                        tint :: tint ::
                                                        tint :: tint :: nil)
                                                       tfloat cc_default))
                           (Tfunction
                             ((tptr (tarray tfloat 4)) :: tint :: tint ::
                              tint :: tint :: tint :: tint :: nil) tfloat
                             cc_default))
                         (Econs
                           (Evalof (Evar _m (tptr (tarray tfloat 4)))
                             (tptr (tarray tfloat 4)))
                           (Econs (Eval (Vint (Int.repr 0)) tint)
                             (Econs (Eval (Vint (Int.repr 1)) tint)
                               (Econs (Eval (Vint (Int.repr 3)) tint)
                                 (Econs (Eval (Vint (Int.repr 0)) tint)
                                   (Econs (Eval (Vint (Int.repr 2)) tint)
                                     (Econs (Eval (Vint (Int.repr 3)) tint)
                                       Enil))))))) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _adjOut (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr (tarray tfloat 4))) (tarray tfloat 4))
                             (tarray tfloat 4))
                           (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                         tfloat)
                       (Ecall
                         (Evalof
                           (Evar _float_mat_minor_4d (Tfunction
                                                       ((tptr (tarray tfloat 4)) ::
                                                        tint :: tint ::
                                                        tint :: tint ::
                                                        tint :: tint :: nil)
                                                       tfloat cc_default))
                           (Tfunction
                             ((tptr (tarray tfloat 4)) :: tint :: tint ::
                              tint :: tint :: tint :: tint :: nil) tfloat
                             cc_default))
                         (Econs
                           (Evalof (Evar _m (tptr (tarray tfloat 4)))
                             (tptr (tarray tfloat 4)))
                           (Econs (Eval (Vint (Int.repr 0)) tint)
                             (Econs (Eval (Vint (Int.repr 1)) tint)
                               (Econs (Eval (Vint (Int.repr 2)) tint)
                                 (Econs (Eval (Vint (Int.repr 0)) tint)
                                   (Econs (Eval (Vint (Int.repr 2)) tint)
                                     (Econs (Eval (Vint (Int.repr 3)) tint)
                                       Enil))))))) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _adjOut (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                           tfloat)
                         (Ecall
                           (Evalof
                             (Evar _float_mat_minor_4d (Tfunction
                                                         ((tptr (tarray tfloat 4)) ::
                                                          tint :: tint ::
                                                          tint :: tint ::
                                                          tint :: tint ::
                                                          nil) tfloat
                                                         cc_default))
                             (Tfunction
                               ((tptr (tarray tfloat 4)) :: tint :: tint ::
                                tint :: tint :: tint :: tint :: nil) tfloat
                               cc_default))
                           (Econs
                             (Evalof (Evar _m (tptr (tarray tfloat 4)))
                               (tptr (tarray tfloat 4)))
                             (Econs (Eval (Vint (Int.repr 1)) tint)
                               (Econs (Eval (Vint (Int.repr 2)) tint)
                                 (Econs (Eval (Vint (Int.repr 3)) tint)
                                   (Econs (Eval (Vint (Int.repr 0)) tint)
                                     (Econs (Eval (Vint (Int.repr 1)) tint)
                                       (Econs (Eval (Vint (Int.repr 3)) tint)
                                         Enil))))))) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _adjOut (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                             tfloat)
                           (Eunop Oneg
                             (Ecall
                               (Evalof
                                 (Evar _float_mat_minor_4d (Tfunction
                                                             ((tptr (tarray tfloat 4)) ::
                                                              tint :: tint ::
                                                              tint :: tint ::
                                                              tint :: tint ::
                                                              nil) tfloat
                                                             cc_default))
                                 (Tfunction
                                   ((tptr (tarray tfloat 4)) :: tint ::
                                    tint :: tint :: tint :: tint :: tint ::
                                    nil) tfloat cc_default))
                               (Econs
                                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Econs (Eval (Vint (Int.repr 0)) tint)
                                   (Econs (Eval (Vint (Int.repr 2)) tint)
                                     (Econs (Eval (Vint (Int.repr 3)) tint)
                                       (Econs (Eval (Vint (Int.repr 0)) tint)
                                         (Econs
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Econs
                                             (Eval (Vint (Int.repr 3)) tint)
                                             Enil))))))) tfloat) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _adjOut (tptr (tarray tfloat 4)))
                                         (tptr (tarray tfloat 4)))
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (tptr (tarray tfloat 4)))
                                     (tarray tfloat 4)) (tarray tfloat 4))
                                 (Eval (Vint (Int.repr 2)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ecall
                               (Evalof
                                 (Evar _float_mat_minor_4d (Tfunction
                                                             ((tptr (tarray tfloat 4)) ::
                                                              tint :: tint ::
                                                              tint :: tint ::
                                                              tint :: tint ::
                                                              nil) tfloat
                                                             cc_default))
                                 (Tfunction
                                   ((tptr (tarray tfloat 4)) :: tint ::
                                    tint :: tint :: tint :: tint :: tint ::
                                    nil) tfloat cc_default))
                               (Econs
                                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Econs (Eval (Vint (Int.repr 0)) tint)
                                   (Econs (Eval (Vint (Int.repr 1)) tint)
                                     (Econs (Eval (Vint (Int.repr 3)) tint)
                                       (Econs (Eval (Vint (Int.repr 0)) tint)
                                         (Econs
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (Econs
                                             (Eval (Vint (Int.repr 3)) tint)
                                             Enil))))))) tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _adjOut (tptr (tarray tfloat 4)))
                                           (tptr (tarray tfloat 4)))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr (tarray tfloat 4)))
                                       (tarray tfloat 4)) (tarray tfloat 4))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr tfloat)) tfloat)
                               (Eunop Oneg
                                 (Ecall
                                   (Evalof
                                     (Evar _float_mat_minor_4d (Tfunction
                                                                 ((tptr (tarray tfloat 4)) ::
                                                                  tint ::
                                                                  tint ::
                                                                  tint ::
                                                                  tint ::
                                                                  tint ::
                                                                  tint ::
                                                                  nil) tfloat
                                                                 cc_default))
                                     (Tfunction
                                       ((tptr (tarray tfloat 4)) :: tint ::
                                        tint :: tint :: tint :: tint ::
                                        tint :: nil) tfloat cc_default))
                                   (Econs
                                     (Evalof
                                       (Evar _m (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Econs (Eval (Vint (Int.repr 0)) tint)
                                       (Econs (Eval (Vint (Int.repr 1)) tint)
                                         (Econs
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Econs
                                             (Eval (Vint (Int.repr 0)) tint)
                                             (Econs
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Econs
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 Enil))))))) tfloat) tfloat)
                               tfloat))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _adjOut (tptr (tarray tfloat 4)))
                                             (tptr (tarray tfloat 4)))
                                           (Eval (Vint (Int.repr 3)) tint)
                                           (tptr (tarray tfloat 4)))
                                         (tarray tfloat 4))
                                       (tarray tfloat 4))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Eunop Oneg
                                   (Ecall
                                     (Evalof
                                       (Evar _float_mat_minor_4d (Tfunction
                                                                   ((tptr (tarray tfloat 4)) ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                   tfloat
                                                                   cc_default))
                                       (Tfunction
                                         ((tptr (tarray tfloat 4)) :: tint ::
                                          tint :: tint :: tint :: tint ::
                                          tint :: nil) tfloat cc_default))
                                     (Econs
                                       (Evalof
                                         (Evar _m (tptr (tarray tfloat 4)))
                                         (tptr (tarray tfloat 4)))
                                       (Econs (Eval (Vint (Int.repr 1)) tint)
                                         (Econs
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Econs
                                             (Eval (Vint (Int.repr 3)) tint)
                                             (Econs
                                               (Eval (Vint (Int.repr 0)) tint)
                                               (Econs
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   Enil))))))) tfloat)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _adjOut (tptr (tarray tfloat 4)))
                                               (tptr (tarray tfloat 4)))
                                             (Eval (Vint (Int.repr 3)) tint)
                                             (tptr (tarray tfloat 4)))
                                           (tarray tfloat 4))
                                         (tarray tfloat 4))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Ecall
                                     (Evalof
                                       (Evar _float_mat_minor_4d (Tfunction
                                                                   ((tptr (tarray tfloat 4)) ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                   tfloat
                                                                   cc_default))
                                       (Tfunction
                                         ((tptr (tarray tfloat 4)) :: tint ::
                                          tint :: tint :: tint :: tint ::
                                          tint :: nil) tfloat cc_default))
                                     (Econs
                                       (Evalof
                                         (Evar _m (tptr (tarray tfloat 4)))
                                         (tptr (tarray tfloat 4)))
                                       (Econs (Eval (Vint (Int.repr 0)) tint)
                                         (Econs
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Econs
                                             (Eval (Vint (Int.repr 3)) tint)
                                             (Econs
                                               (Eval (Vint (Int.repr 0)) tint)
                                               (Econs
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   Enil))))))) tfloat)
                                   tfloat))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _adjOut (tptr (tarray tfloat 4)))
                                                 (tptr (tarray tfloat 4)))
                                               (Eval (Vint (Int.repr 3)) tint)
                                               (tptr (tarray tfloat 4)))
                                             (tarray tfloat 4))
                                           (tarray tfloat 4))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Eunop Oneg
                                       (Ecall
                                         (Evalof
                                           (Evar _float_mat_minor_4d 
                                           (Tfunction
                                             ((tptr (tarray tfloat 4)) ::
                                              tint :: tint :: tint :: tint ::
                                              tint :: tint :: nil) tfloat
                                             cc_default))
                                           (Tfunction
                                             ((tptr (tarray tfloat 4)) ::
                                              tint :: tint :: tint :: tint ::
                                              tint :: tint :: nil) tfloat
                                             cc_default))
                                         (Econs
                                           (Evalof
                                             (Evar _m (tptr (tarray tfloat 4)))
                                             (tptr (tarray tfloat 4)))
                                           (Econs
                                             (Eval (Vint (Int.repr 0)) tint)
                                             (Econs
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Econs
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 0)) tint)
                                                   (Econs
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     (Econs
                                                       (Eval (Vint (Int.repr 2)) tint)
                                                       Enil))))))) tfloat)
                                       tfloat) tfloat))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _adjOut (tptr (tarray tfloat 4)))
                                                 (tptr (tarray tfloat 4)))
                                               (Eval (Vint (Int.repr 3)) tint)
                                               (tptr (tarray tfloat 4)))
                                             (tarray tfloat 4))
                                           (tarray tfloat 4))
                                         (Eval (Vint (Int.repr 3)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Ecall
                                       (Evalof
                                         (Evar _float_mat_minor_4d (Tfunction
                                                                    ((tptr (tarray tfloat 4)) ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                    tfloat
                                                                    cc_default))
                                         (Tfunction
                                           ((tptr (tarray tfloat 4)) ::
                                            tint :: tint :: tint :: tint ::
                                            tint :: tint :: nil) tfloat
                                           cc_default))
                                       (Econs
                                         (Evalof
                                           (Evar _m (tptr (tarray tfloat 4)))
                                           (tptr (tarray tfloat 4)))
                                         (Econs
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (Econs
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (Econs
                                               (Eval (Vint (Int.repr 2)) tint)
                                               (Econs
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (Econs
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     Enil))))))) tfloat)
                                     tfloat)))))))))))))))))
|}.

Definition f_float_mat_det_4d := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_m, (tptr (tarray tfloat 4))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Ecall
                         (Evalof
                           (Evar _float_mat_minor_4d (Tfunction
                                                       ((tptr (tarray tfloat 4)) ::
                                                        tint :: tint ::
                                                        tint :: tint ::
                                                        tint :: tint :: nil)
                                                       tfloat cc_default))
                           (Tfunction
                             ((tptr (tarray tfloat 4)) :: tint :: tint ::
                              tint :: tint :: tint :: tint :: nil) tfloat
                             cc_default))
                         (Econs
                           (Evalof (Evar _m (tptr (tarray tfloat 4)))
                             (tptr (tarray tfloat 4)))
                           (Econs (Eval (Vint (Int.repr 1)) tint)
                             (Econs (Eval (Vint (Int.repr 2)) tint)
                               (Econs (Eval (Vint (Int.repr 3)) tint)
                                 (Econs (Eval (Vint (Int.repr 1)) tint)
                                   (Econs (Eval (Vint (Int.repr 2)) tint)
                                     (Econs (Eval (Vint (Int.repr 3)) tint)
                                       Enil))))))) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Ecall
                         (Evalof
                           (Evar _float_mat_minor_4d (Tfunction
                                                       ((tptr (tarray tfloat 4)) ::
                                                        tint :: tint ::
                                                        tint :: tint ::
                                                        tint :: tint :: nil)
                                                       tfloat cc_default))
                           (Tfunction
                             ((tptr (tarray tfloat 4)) :: tint :: tint ::
                              tint :: tint :: tint :: tint :: nil) tfloat
                             cc_default))
                         (Econs
                           (Evalof (Evar _m (tptr (tarray tfloat 4)))
                             (tptr (tarray tfloat 4)))
                           (Econs (Eval (Vint (Int.repr 1)) tint)
                             (Econs (Eval (Vint (Int.repr 2)) tint)
                               (Econs (Eval (Vint (Int.repr 3)) tint)
                                 (Econs (Eval (Vint (Int.repr 0)) tint)
                                   (Econs (Eval (Vint (Int.repr 2)) tint)
                                     (Econs (Eval (Vint (Int.repr 3)) tint)
                                       Enil))))))) tfloat) tfloat) tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Eval (Vint (Int.repr 0)) tint)
                                 (tptr (tarray tfloat 4))) (tarray tfloat 4))
                             (tarray tfloat 4))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Ecall
                       (Evalof
                         (Evar _float_mat_minor_4d (Tfunction
                                                     ((tptr (tarray tfloat 4)) ::
                                                      tint :: tint :: tint ::
                                                      tint :: tint :: tint ::
                                                      nil) tfloat cc_default))
                         (Tfunction
                           ((tptr (tarray tfloat 4)) :: tint :: tint ::
                            tint :: tint :: tint :: tint :: nil) tfloat
                           cc_default))
                       (Econs
                         (Evalof (Evar _m (tptr (tarray tfloat 4)))
                           (tptr (tarray tfloat 4)))
                         (Econs (Eval (Vint (Int.repr 1)) tint)
                           (Econs (Eval (Vint (Int.repr 2)) tint)
                             (Econs (Eval (Vint (Int.repr 3)) tint)
                               (Econs (Eval (Vint (Int.repr 0)) tint)
                                 (Econs (Eval (Vint (Int.repr 1)) tint)
                                   (Econs (Eval (Vint (Int.repr 3)) tint)
                                     Enil))))))) tfloat) tfloat) tfloat)
                 (Ebinop Omul
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _m (tptr (tarray tfloat 4)))
                                 (tptr (tarray tfloat 4)))
                               (Eval (Vint (Int.repr 0)) tint)
                               (tptr (tarray tfloat 4))) (tarray tfloat 4))
                           (tarray tfloat 4)) (Eval (Vint (Int.repr 3)) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Ecall
                     (Evalof
                       (Evar _float_mat_minor_4d (Tfunction
                                                   ((tptr (tarray tfloat 4)) ::
                                                    tint :: tint :: tint ::
                                                    tint :: tint :: tint ::
                                                    nil) tfloat cc_default))
                       (Tfunction
                         ((tptr (tarray tfloat 4)) :: tint :: tint :: tint ::
                          tint :: tint :: tint :: nil) tfloat cc_default))
                     (Econs
                       (Evalof (Evar _m (tptr (tarray tfloat 4)))
                         (tptr (tarray tfloat 4)))
                       (Econs (Eval (Vint (Int.repr 1)) tint)
                         (Econs (Eval (Vint (Int.repr 2)) tint)
                           (Econs (Eval (Vint (Int.repr 3)) tint)
                             (Econs (Eval (Vint (Int.repr 0)) tint)
                               (Econs (Eval (Vint (Int.repr 1)) tint)
                                 (Econs (Eval (Vint (Int.repr 2)) tint) Enil)))))))
                     tfloat) tfloat) tfloat)))
|}.

Definition f_float_mat_inv_4d := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_invOut, (tptr (tarray tfloat 4))) ::
                (_mat_in, (tptr (tarray tfloat 4))) :: nil);
  fn_vars := ((_det, tfloat) :: (_inv_det, tfloat) :: (_i, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _float_mat_adjoint_4d (Tfunction
                                         ((tptr (tarray tfloat 4)) ::
                                          (tptr (tarray tfloat 4)) :: nil)
                                         tvoid cc_default))
           (Tfunction
             ((tptr (tarray tfloat 4)) :: (tptr (tarray tfloat 4)) :: nil)
             tvoid cc_default))
         (Econs
           (Evalof (Evar _invOut (tptr (tarray tfloat 4)))
             (tptr (tarray tfloat 4)))
           (Econs
             (Evalof (Evar _mat_in (tptr (tarray tfloat 4)))
               (tptr (tarray tfloat 4))) Enil)) tvoid))
  (Ssequence
    (Sdo (Eassign (Evar _det tfloat)
           (Ecall
             (Evalof
               (Evar _float_mat_det_4d (Tfunction
                                         ((tptr (tarray tfloat 4)) :: nil)
                                         tfloat cc_default))
               (Tfunction ((tptr (tarray tfloat 4)) :: nil) tfloat
                 cc_default))
             (Econs
               (Evalof (Evar _mat_in (tptr (tarray tfloat 4)))
                 (tptr (tarray tfloat 4))) Enil) tfloat) tfloat))
    (Ssequence
      (Sifthenelse (Ebinop Olt
                     (Ecall
                       (Evalof
                         (Evar _fabsf (Tfunction (tfloat :: nil) tfloat
                                        cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs (Evalof (Evar _det tfloat) tfloat) Enil)
                       tfloat)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4547007122018943789))) tdouble)
                     tint)
        (Sreturn (Some (Eval (Vint (Int.repr 1)) tint)))
        Sskip)
      (Ssequence
        (Sdo (Eassign (Evar _inv_det tfloat)
               (Ebinop Odiv
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                 (Evalof (Evar _det tfloat) tfloat) tfloat) tfloat))
        (Ssequence
          (Sfor
            (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint)
                   tint))
            (Ebinop Olt (Evalof (Evar _i tint) tint)
              (Eval (Vint (Int.repr 4)) tint) tint)
            (Sdo (Eassignop Oadd (Evar _i tint)
                   (Eval (Vint (Int.repr 1)) tint) tint tint))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _invOut (tptr (tarray tfloat 4)))
                                 (tptr (tarray tfloat 4)))
                               (Eval (Vint (Int.repr 0)) tint)
                               (tptr (tarray tfloat 4))) (tarray tfloat 4))
                           (tarray tfloat 4)) (Evalof (Evar _i tint) tint)
                         (tptr tfloat)) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _invOut (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _i tint) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Evalof (Evar _inv_det tfloat) tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _invOut (tptr (tarray tfloat 4)))
                                   (tptr (tarray tfloat 4)))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr (tarray tfloat 4))) (tarray tfloat 4))
                             (tarray tfloat 4)) (Evalof (Evar _i tint) tint)
                           (tptr tfloat)) tfloat)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _invOut (tptr (tarray tfloat 4)))
                                       (tptr (tarray tfloat 4)))
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (tptr (tarray tfloat 4)))
                                   (tarray tfloat 4)) (tarray tfloat 4))
                               (Evalof (Evar _i tint) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Evalof (Evar _inv_det tfloat) tfloat) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _invOut (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _i tint) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _invOut (tptr (tarray tfloat 4)))
                                         (tptr (tarray tfloat 4)))
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (tptr (tarray tfloat 4)))
                                     (tarray tfloat 4)) (tarray tfloat 4))
                                 (Evalof (Evar _i tint) tint) (tptr tfloat))
                               tfloat) tfloat)
                           (Evalof (Evar _inv_det tfloat) tfloat) tfloat)
                         tfloat))
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _invOut (tptr (tarray tfloat 4)))
                                     (tptr (tarray tfloat 4)))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr (tarray tfloat 4)))
                                 (tarray tfloat 4)) (tarray tfloat 4))
                             (Evalof (Evar _i tint) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _invOut (tptr (tarray tfloat 4)))
                                         (tptr (tarray tfloat 4)))
                                       (Eval (Vint (Int.repr 3)) tint)
                                       (tptr (tarray tfloat 4)))
                                     (tarray tfloat 4)) (tarray tfloat 4))
                                 (Evalof (Evar _i tint) tint) (tptr tfloat))
                               tfloat) tfloat)
                           (Evalof (Evar _inv_det tfloat) tfloat) tfloat)
                         tfloat))))))
          (Sreturn (Some (Eval (Vint (Int.repr 0)) tint))))))))
|}.

Definition f_float_vect3_bound_in_2d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect3, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_bound, tfloat) :: nil);
  fn_vars := ((_norm, tfloat) :: (_scale, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _norm tfloat)
         (Ecall
           (Evalof
             (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
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
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _norm tfloat) tfloat)
                 (Evalof (Evar _bound tfloat) tfloat) tint)
    (Ssequence
      (Sdo (Eassign (Evar _scale tfloat)
             (Ebinop Odiv (Evalof (Evar _bound tfloat) tfloat)
               (Evalof (Evar _norm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _x tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))))
    Sskip))
|}.

Definition f_float_vect3_bound_in_3d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect3, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_bound, tfloat) :: nil);
  fn_vars := ((_norm, tfloat) :: (_scale, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _norm tfloat)
         (Ecall
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
                             (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
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
                             (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                             (tptr (Tstruct _FloatVect3 noattr)))
                           (Tstruct _FloatVect3 noattr))
                         (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
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
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _z tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _norm tfloat) tfloat)
                 (Evalof (Evar _bound tfloat) tfloat) tint)
    (Ssequence
      (Sdo (Eassign (Evar _scale tfloat)
             (Ebinop Odiv (Evalof (Evar _bound tfloat) tfloat)
               (Evalof (Evar _norm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _x tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))
        (Ssequence
          (Sdo (Eassignop Omul
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _y tfloat)
                 (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))
          (Sdo (Eassignop Omul
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                         (tptr (Tstruct _FloatVect3 noattr)))
                       (Tstruct _FloatVect3 noattr))
                     (Tstruct _FloatVect3 noattr)) _z tfloat)
                 (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat)))))
    Sskip))
|}.

Definition f_float_vect3_scale_in_2d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect3, (tptr (Tstruct _FloatVect3 noattr))) ::
                (_norm_des, tfloat) :: nil);
  fn_vars := ((_norm, tfloat) :: (_scale, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _norm tfloat)
         (Ecall
           (Evalof
             (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _x tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
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
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                           (tptr (Tstruct _FloatVect3 noattr)))
                         (Tstruct _FloatVect3 noattr))
                       (Tstruct _FloatVect3 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _norm tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1008981770))) tfloat)
                 tint)
    (Ssequence
      (Sdo (Eassign (Evar _scale tfloat)
             (Ebinop Odiv (Evalof (Evar _norm_des tfloat) tfloat)
               (Evalof (Evar _norm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _x tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect3 (tptr (Tstruct _FloatVect3 noattr)))
                       (tptr (Tstruct _FloatVect3 noattr)))
                     (Tstruct _FloatVect3 noattr))
                   (Tstruct _FloatVect3 noattr)) _y tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))))
    Sskip))
|}.

Definition f_float_vect2_bound_in_2d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect2, (tptr (Tstruct _FloatVect2 noattr))) ::
                (_bound, tfloat) :: nil);
  fn_vars := ((_norm, tfloat) :: (_scale, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _norm tfloat)
         (Ecall
           (Evalof
             (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
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
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _norm tfloat) tfloat)
                 (Evalof (Evar _bound tfloat) tfloat) tint)
    (Ssequence
      (Sdo (Eassign (Evar _scale tfloat)
             (Ebinop Odiv (Evalof (Evar _bound tfloat) tfloat)
               (Evalof (Evar _norm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))))
    Sskip))
|}.

Definition f_float_vect2_scale_in_2d := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_vect2, (tptr (Tstruct _FloatVect2 noattr))) ::
                (_norm_des, tfloat) :: nil);
  fn_vars := ((_norm, tfloat) :: (_scale, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _norm tfloat)
         (Ecall
           (Evalof
             (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Oadd
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
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
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                 tfloat) tfloat) Enil) tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _norm tfloat) tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1008981770))) tfloat)
                 tint)
    (Ssequence
      (Sdo (Eassign (Evar _scale tfloat)
             (Ebinop Odiv (Evalof (Evar _norm_des tfloat) tfloat)
               (Evalof (Evar _norm tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))
        (Sdo (Eassignop Omul
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _vect2 (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat)
               (Evalof (Evar _scale tfloat) tfloat) tfloat tfloat))))
    Sskip))
|}.

Definition v_five_keep_float_rates_integrate_fi := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rates_integrate_fi (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rates_vect3_integrate_fi := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rates_vect3_integrate_fi (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rates_of_euler_dot := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rates_of_euler_dot (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_inv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_inv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_norm := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_norm (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_comp_inv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_comp_inv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_transp_vmult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_transp_vmult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_mult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_mult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_transp_mult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_transp_mult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_ratemult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_ratemult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_transp_ratemult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_transp_ratemult (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_of_axis_angle := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_of_axis_angle (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_of_eulers_312 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_of_eulers_312 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_of_quat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_of_quat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_rmat_integrate_fi := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_rmat_integrate_fi (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_renorm_factor := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _renorm_factor (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_comp_inv := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_comp_inv (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_inv_comp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_inv_comp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_comp_norm_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_comp_norm_shortest (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_comp_inv_norm_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_comp_inv_norm_shortest (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_inv_comp_norm_shortest := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_inv_comp_norm_shortest (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_differential := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_differential (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_integrate_fi := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_integrate_fi (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_integrate := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_integrate (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_derivative := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_derivative (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_derivative_lagrange := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_derivative_lagrange (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_of_eulers := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_of_eulers (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_of_eulers_zxy := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_of_eulers_zxy (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_of_eulers_yxz := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_of_eulers_yxz (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_of_axis_angle := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_of_axis_angle (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_of_orientation_vect := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_of_orientation_vect (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_of_rmat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_of_rmat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_quat_tilt_twist := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_quat_tilt_twist (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_eulers_of_rmat := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_eulers_of_rmat (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_eulers_of_quat_yxz := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_eulers_of_quat_yxz (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_eulers_of_quat_zxy := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_eulers_of_quat_zxy (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat2_mult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat2_mult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat3_mult := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat3_mult (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_minor_4d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_minor_4d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_adjoint_4d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_adjoint_4d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_det_4d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_det_4d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_mat_inv_4d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_mat_inv_4d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect3_bound_in_2d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect3_bound_in_2d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect3_bound_in_3d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect3_bound_in_3d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect3_scale_in_2d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect3_scale_in_2d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect2_bound_in_2d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect2_bound_in_2d (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_float_vect2_scale_in_2d := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _float_vect2_scale_in_2d (Ptrofs.repr 0) :: nil);
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
   noattr ::
 Composite _FloatRates Struct
   (Member_plain _p tfloat :: Member_plain _q tfloat ::
    Member_plain _r tfloat :: nil)
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
 (_memcpy,
   Gfun(External (EF_external "memcpy"
                   (mksignature (AST.Xptr :: AST.Xptr :: AST.Xlong :: nil)
                     AST.Xptr cc_default))
     ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil) (tptr tvoid)
     cc_default)) ::
 (_cos,
   Gfun(External (EF_external "cos"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_sin,
   Gfun(External (EF_external "sin"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_asinf,
   Gfun(External (EF_external "asinf"
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
 (_sqrtf,
   Gfun(External (EF_external "sqrtf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_fabsf,
   Gfun(External (EF_external "fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_float_quat_norm, Gfun(Internal f_float_quat_norm)) ::
 (_float_quat_normalize, Gfun(Internal f_float_quat_normalize)) ::
 (_float_quat_invert, Gfun(Internal f_float_quat_invert)) ::
 (_float_quat_wrap_shortest, Gfun(Internal f_float_quat_wrap_shortest)) ::
 (_float_rates_integrate_fi, Gfun(Internal f_float_rates_integrate_fi)) ::
 (_float_rates_vect3_integrate_fi, Gfun(Internal f_float_rates_vect3_integrate_fi)) ::
 (_float_rates_of_euler_dot, Gfun(Internal f_float_rates_of_euler_dot)) ::
 (_float_rmat_inv, Gfun(Internal f_float_rmat_inv)) ::
 (_float_rmat_norm, Gfun(Internal f_float_rmat_norm)) ::
 (_float_rmat_comp, Gfun(Internal f_float_rmat_comp)) ::
 (_float_rmat_comp_inv, Gfun(Internal f_float_rmat_comp_inv)) ::
 (_float_rmat_transp_vmult, Gfun(Internal f_float_rmat_transp_vmult)) ::
 (_float_rmat_mult, Gfun(Internal f_float_rmat_mult)) ::
 (_float_rmat_transp_mult, Gfun(Internal f_float_rmat_transp_mult)) ::
 (_float_rmat_ratemult, Gfun(Internal f_float_rmat_ratemult)) ::
 (_float_rmat_transp_ratemult, Gfun(Internal f_float_rmat_transp_ratemult)) ::
 (_float_rmat_of_axis_angle, Gfun(Internal f_float_rmat_of_axis_angle)) ::
 (_float_rmat_of_eulers_312, Gfun(Internal f_float_rmat_of_eulers_312)) ::
 (_float_rmat_of_quat, Gfun(Internal f_float_rmat_of_quat)) ::
 (_float_rmat_integrate_fi, Gfun(Internal f_float_rmat_integrate_fi)) ::
 (_renorm_factor, Gfun(Internal f_renorm_factor)) ::
 (_float_quat_comp, Gfun(Internal f_float_quat_comp)) ::
 (_float_quat_comp_inv, Gfun(Internal f_float_quat_comp_inv)) ::
 (_float_quat_inv_comp, Gfun(Internal f_float_quat_inv_comp)) ::
 (_float_quat_comp_norm_shortest, Gfun(Internal f_float_quat_comp_norm_shortest)) ::
 (_float_quat_comp_inv_norm_shortest, Gfun(Internal f_float_quat_comp_inv_norm_shortest)) ::
 (_float_quat_inv_comp_norm_shortest, Gfun(Internal f_float_quat_inv_comp_norm_shortest)) ::
 (_float_quat_differential, Gfun(Internal f_float_quat_differential)) ::
 (_float_quat_integrate_fi, Gfun(Internal f_float_quat_integrate_fi)) ::
 (_float_quat_integrate, Gfun(Internal f_float_quat_integrate)) ::
 (_float_quat_vmult, Gfun(Internal f_float_quat_vmult)) ::
 (_float_quat_derivative, Gfun(Internal f_float_quat_derivative)) ::
 (_float_quat_derivative_lagrange, Gfun(Internal f_float_quat_derivative_lagrange)) ::
 (_float_quat_of_eulers, Gfun(Internal f_float_quat_of_eulers)) ::
 (_float_quat_of_eulers_zxy, Gfun(Internal f_float_quat_of_eulers_zxy)) ::
 (_float_quat_of_eulers_yxz, Gfun(Internal f_float_quat_of_eulers_yxz)) ::
 (_float_quat_of_axis_angle, Gfun(Internal f_float_quat_of_axis_angle)) ::
 (_float_quat_of_orientation_vect, Gfun(Internal f_float_quat_of_orientation_vect)) ::
 (_float_quat_of_rmat, Gfun(Internal f_float_quat_of_rmat)) ::
 (_float_quat_tilt_twist, Gfun(Internal f_float_quat_tilt_twist)) ::
 (_float_eulers_of_rmat, Gfun(Internal f_float_eulers_of_rmat)) ::
 (_float_eulers_of_quat_yxz, Gfun(Internal f_float_eulers_of_quat_yxz)) ::
 (_float_eulers_of_quat_zxy, Gfun(Internal f_float_eulers_of_quat_zxy)) ::
 (_float_mat2_mult, Gfun(Internal f_float_mat2_mult)) ::
 (_float_mat3_mult, Gfun(Internal f_float_mat3_mult)) ::
 (_float_mat_minor_4d, Gfun(Internal f_float_mat_minor_4d)) ::
 (_float_mat_adjoint_4d, Gfun(Internal f_float_mat_adjoint_4d)) ::
 (_float_mat_det_4d, Gfun(Internal f_float_mat_det_4d)) ::
 (_float_mat_inv_4d, Gfun(Internal f_float_mat_inv_4d)) ::
 (_float_vect3_bound_in_2d, Gfun(Internal f_float_vect3_bound_in_2d)) ::
 (_float_vect3_bound_in_3d, Gfun(Internal f_float_vect3_bound_in_3d)) ::
 (_float_vect3_scale_in_2d, Gfun(Internal f_float_vect3_scale_in_2d)) ::
 (_float_vect2_bound_in_2d, Gfun(Internal f_float_vect2_bound_in_2d)) ::
 (_float_vect2_scale_in_2d, Gfun(Internal f_float_vect2_scale_in_2d)) ::
 (_five_keep_float_rates_integrate_fi, Gvar v_five_keep_float_rates_integrate_fi) ::
 (_five_keep_float_rates_vect3_integrate_fi, Gvar v_five_keep_float_rates_vect3_integrate_fi) ::
 (_five_keep_float_rates_of_euler_dot, Gvar v_five_keep_float_rates_of_euler_dot) ::
 (_five_keep_float_rmat_inv, Gvar v_five_keep_float_rmat_inv) ::
 (_five_keep_float_rmat_norm, Gvar v_five_keep_float_rmat_norm) ::
 (_five_keep_float_rmat_comp_inv, Gvar v_five_keep_float_rmat_comp_inv) ::
 (_five_keep_float_rmat_transp_vmult, Gvar v_five_keep_float_rmat_transp_vmult) ::
 (_five_keep_float_rmat_mult, Gvar v_five_keep_float_rmat_mult) ::
 (_five_keep_float_rmat_transp_mult, Gvar v_five_keep_float_rmat_transp_mult) ::
 (_five_keep_float_rmat_ratemult, Gvar v_five_keep_float_rmat_ratemult) ::
 (_five_keep_float_rmat_transp_ratemult, Gvar v_five_keep_float_rmat_transp_ratemult) ::
 (_five_keep_float_rmat_of_axis_angle, Gvar v_five_keep_float_rmat_of_axis_angle) ::
 (_five_keep_float_rmat_of_eulers_312, Gvar v_five_keep_float_rmat_of_eulers_312) ::
 (_five_keep_float_rmat_of_quat, Gvar v_five_keep_float_rmat_of_quat) ::
 (_five_keep_float_rmat_integrate_fi, Gvar v_five_keep_float_rmat_integrate_fi) ::
 (_five_keep_renorm_factor, Gvar v_five_keep_renorm_factor) ::
 (_five_keep_float_quat_comp_inv, Gvar v_five_keep_float_quat_comp_inv) ::
 (_five_keep_float_quat_inv_comp, Gvar v_five_keep_float_quat_inv_comp) ::
 (_five_keep_float_quat_comp_norm_shortest, Gvar v_five_keep_float_quat_comp_norm_shortest) ::
 (_five_keep_float_quat_comp_inv_norm_shortest, Gvar v_five_keep_float_quat_comp_inv_norm_shortest) ::
 (_five_keep_float_quat_inv_comp_norm_shortest, Gvar v_five_keep_float_quat_inv_comp_norm_shortest) ::
 (_five_keep_float_quat_differential, Gvar v_five_keep_float_quat_differential) ::
 (_five_keep_float_quat_integrate_fi, Gvar v_five_keep_float_quat_integrate_fi) ::
 (_five_keep_float_quat_integrate, Gvar v_five_keep_float_quat_integrate) ::
 (_five_keep_float_quat_derivative, Gvar v_five_keep_float_quat_derivative) ::
 (_five_keep_float_quat_derivative_lagrange, Gvar v_five_keep_float_quat_derivative_lagrange) ::
 (_five_keep_float_quat_of_eulers, Gvar v_five_keep_float_quat_of_eulers) ::
 (_five_keep_float_quat_of_eulers_zxy, Gvar v_five_keep_float_quat_of_eulers_zxy) ::
 (_five_keep_float_quat_of_eulers_yxz, Gvar v_five_keep_float_quat_of_eulers_yxz) ::
 (_five_keep_float_quat_of_axis_angle, Gvar v_five_keep_float_quat_of_axis_angle) ::
 (_five_keep_float_quat_of_orientation_vect, Gvar v_five_keep_float_quat_of_orientation_vect) ::
 (_five_keep_float_quat_of_rmat, Gvar v_five_keep_float_quat_of_rmat) ::
 (_five_keep_float_quat_tilt_twist, Gvar v_five_keep_float_quat_tilt_twist) ::
 (_five_keep_float_eulers_of_rmat, Gvar v_five_keep_float_eulers_of_rmat) ::
 (_five_keep_float_eulers_of_quat_yxz, Gvar v_five_keep_float_eulers_of_quat_yxz) ::
 (_five_keep_float_eulers_of_quat_zxy, Gvar v_five_keep_float_eulers_of_quat_zxy) ::
 (_five_keep_float_mat2_mult, Gvar v_five_keep_float_mat2_mult) ::
 (_five_keep_float_mat3_mult, Gvar v_five_keep_float_mat3_mult) ::
 (_five_keep_float_mat_minor_4d, Gvar v_five_keep_float_mat_minor_4d) ::
 (_five_keep_float_mat_adjoint_4d, Gvar v_five_keep_float_mat_adjoint_4d) ::
 (_five_keep_float_mat_det_4d, Gvar v_five_keep_float_mat_det_4d) ::
 (_five_keep_float_mat_inv_4d, Gvar v_five_keep_float_mat_inv_4d) ::
 (_five_keep_float_vect3_bound_in_2d, Gvar v_five_keep_float_vect3_bound_in_2d) ::
 (_five_keep_float_vect3_bound_in_3d, Gvar v_five_keep_float_vect3_bound_in_3d) ::
 (_five_keep_float_vect3_scale_in_2d, Gvar v_five_keep_float_vect3_scale_in_2d) ::
 (_five_keep_float_vect2_bound_in_2d, Gvar v_five_keep_float_vect2_bound_in_2d) ::
 (_five_keep_float_vect2_scale_in_2d, Gvar v_five_keep_float_vect2_scale_in_2d) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_float_vect2_scale_in_2d :: _five_keep_float_vect2_bound_in_2d ::
 _five_keep_float_vect3_scale_in_2d :: _five_keep_float_vect3_bound_in_3d ::
 _five_keep_float_vect3_bound_in_2d :: _five_keep_float_mat_inv_4d ::
 _five_keep_float_mat_det_4d :: _five_keep_float_mat_adjoint_4d ::
 _five_keep_float_mat_minor_4d :: _five_keep_float_mat3_mult ::
 _five_keep_float_mat2_mult :: _five_keep_float_eulers_of_quat_zxy ::
 _five_keep_float_eulers_of_quat_yxz :: _five_keep_float_eulers_of_rmat ::
 _five_keep_float_quat_tilt_twist :: _five_keep_float_quat_of_rmat ::
 _five_keep_float_quat_of_orientation_vect ::
 _five_keep_float_quat_of_axis_angle ::
 _five_keep_float_quat_of_eulers_yxz ::
 _five_keep_float_quat_of_eulers_zxy :: _five_keep_float_quat_of_eulers ::
 _five_keep_float_quat_derivative_lagrange ::
 _five_keep_float_quat_derivative :: _five_keep_float_quat_integrate ::
 _five_keep_float_quat_integrate_fi :: _five_keep_float_quat_differential ::
 _five_keep_float_quat_inv_comp_norm_shortest ::
 _five_keep_float_quat_comp_inv_norm_shortest ::
 _five_keep_float_quat_comp_norm_shortest ::
 _five_keep_float_quat_inv_comp :: _five_keep_float_quat_comp_inv ::
 _five_keep_renorm_factor :: _five_keep_float_rmat_integrate_fi ::
 _five_keep_float_rmat_of_quat :: _five_keep_float_rmat_of_eulers_312 ::
 _five_keep_float_rmat_of_axis_angle ::
 _five_keep_float_rmat_transp_ratemult :: _five_keep_float_rmat_ratemult ::
 _five_keep_float_rmat_transp_mult :: _five_keep_float_rmat_mult ::
 _five_keep_float_rmat_transp_vmult :: _five_keep_float_rmat_comp_inv ::
 _five_keep_float_rmat_norm :: _five_keep_float_rmat_inv ::
 _five_keep_float_rates_of_euler_dot ::
 _five_keep_float_rates_vect3_integrate_fi ::
 _five_keep_float_rates_integrate_fi :: _float_vect2_scale_in_2d ::
 _float_vect2_bound_in_2d :: _float_vect3_scale_in_2d ::
 _float_vect3_bound_in_3d :: _float_vect3_bound_in_2d :: _float_mat_inv_4d ::
 _float_mat3_mult :: _float_mat2_mult :: _float_eulers_of_quat_zxy ::
 _float_eulers_of_quat_yxz :: _float_eulers_of_rmat ::
 _float_quat_tilt_twist :: _float_quat_of_rmat ::
 _float_quat_of_orientation_vect :: _float_quat_of_axis_angle ::
 _float_quat_of_eulers_yxz :: _float_quat_of_eulers_zxy ::
 _float_quat_of_eulers :: _float_quat_derivative_lagrange ::
 _float_quat_derivative :: _float_quat_vmult :: _float_quat_integrate ::
 _float_quat_integrate_fi :: _float_quat_differential ::
 _float_quat_inv_comp_norm_shortest :: _float_quat_comp_inv_norm_shortest ::
 _float_quat_comp_norm_shortest :: _float_quat_inv_comp ::
 _float_quat_comp_inv :: _float_quat_comp :: _float_rmat_integrate_fi ::
 _float_rmat_of_quat :: _float_rmat_of_eulers_312 ::
 _float_rmat_of_axis_angle :: _float_rmat_transp_ratemult ::
 _float_rmat_ratemult :: _float_rmat_transp_mult :: _float_rmat_mult ::
 _float_rmat_transp_vmult :: _float_rmat_comp_inv :: _float_rmat_comp ::
 _float_rmat_norm :: _float_rmat_inv :: _float_rates_of_euler_dot ::
 _float_rates_vect3_integrate_fi :: _float_rates_integrate_fi :: _fabsf ::
 _sqrtf :: _sinf :: _cosf :: _atan2f :: _asinf :: _sin :: _cos :: _memcpy ::
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


