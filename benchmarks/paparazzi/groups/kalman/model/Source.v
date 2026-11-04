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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/models/kalman/model/preprocessed.i".
End Info.

Definition _F : ident := $"F".
Definition _HX_tmp : ident := $"HX_tmp".
Definition _HinvS_tmp : ident := $"HinvS_tmp".
Definition _Hp : ident := $"Hp".
Definition _Hs : ident := $"Hs".
Definition _Ht : ident := $"Ht".
Definition _K : ident := $"K".
Definition _KH_tmp : ident := $"KH_tmp".
Definition _K_ZHX_tmp : ident := $"K_ZHX_tmp".
Definition _P : ident := $"P".
Definition _P0_pos : ident := $"P0_pos".
Definition _P0_speed : ident := $"P0_speed".
Definition _P_tmp : ident := $"P_tmp".
Definition _Q : ident := $"Q".
Definition _Q_sigma2 : ident := $"Q_sigma2".
Definition _S : ident := $"S".
Definition _SimpleKinematicKalman : ident := $"SimpleKinematicKalman".
Definition _Z : ident := $"Z".
Definition _Z_HX : ident := $"Z_HX".
Definition __H : ident := $"_H".
Definition __HinvS_tmp : ident := $"_HinvS_tmp".
Definition __Ht : ident := $"_Ht".
Definition __K : ident := $"_K".
Definition __KH_tmp : ident := $"_KH_tmp".
Definition __P : ident := $"_P".
Definition __S : ident := $"_S".
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
Definition ___i : ident := $"__i".
Definition ___i__1 : ident := $"__i__1".
Definition ___i__2 : ident := $"__i__2".
Definition ___i__3 : ident := $"__i__3".
Definition ___i__4 : ident := $"__i__4".
Definition ___i__5 : ident := $"__i__5".
Definition ___i__6 : ident := $"__i__6".
Definition __invS : ident := $"_invS".
Definition _a : ident := $"a".
Definition _b : ident := $"b".
Definition _d_dt : ident := $"d_dt".
Definition _dt : ident := $"dt".
Definition _dt2 : ident := $"dt2".
Definition _dt3 : ident := $"dt3".
Definition _dt4 : ident := $"dt4".
Definition _fabsf : ident := $"fabsf".
Definition _five_keep_simple_kinematic_kalman_init : ident := $"five_keep_simple_kinematic_kalman_init".
Definition _five_keep_simple_kinematic_kalman_predict : ident := $"five_keep_simple_kinematic_kalman_predict".
Definition _five_keep_simple_kinematic_kalman_update : ident := $"five_keep_simple_kinematic_kalman_update".
Definition _float_mat_invert : ident := $"float_mat_invert".
Definition _float_mat_mul : ident := $"float_mat_mul".
Definition _float_mat_transpose : ident := $"float_mat_transpose".
Definition _float_mat_vect_mul : ident := $"float_mat_vect_mul".
Definition _float_vect_add : ident := $"float_vect_add".
Definition _float_vect_diff : ident := $"float_vect_diff".
Definition _i : ident := $"i".
Definition _i__1 : ident := $"i__1".
Definition _i__2 : ident := $"i__2".
Definition _invS : ident := $"invS".
Definition _j : ident := $"j".
Definition _j__1 : ident := $"j__1".
Definition _j__2 : ident := $"j__2".
Definition _k : ident := $"k".
Definition _kalman : ident := $"kalman".
Definition _l : ident := $"l".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _n : ident := $"n".
Definition _o : ident := $"o".
Definition _r : ident := $"r".
Definition _simple_kinematic_kalman_init : ident := $"simple_kinematic_kalman_init".
Definition _simple_kinematic_kalman_predict : ident := $"simple_kinematic_kalman_predict".
Definition _simple_kinematic_kalman_update : ident := $"simple_kinematic_kalman_update".
Definition _state : ident := $"state".

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

Definition f_simple_kinematic_kalman_init := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_kalman, (tptr (Tstruct _SimpleKinematicKalman noattr))) ::
                (_P0_pos, tfloat) :: (_P0_speed, tfloat) ::
                (_Q_sigma2, tfloat) :: (_r, tfloat) :: (_dt, tfloat) :: nil);
  fn_vars := ((_i, tint) :: (_j, tint) :: (_dt2, tfloat) :: (_dt3, tfloat) ::
              (_dt4, tfloat) :: (_i__1, tint) :: (_j__1, tint) ::
              (_i__2, tint) :: (_j__2, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _dt2 tfloat)
         (Ebinop Omul (Evalof (Evar _dt tfloat) tfloat)
           (Evalof (Evar _dt tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _dt3 tfloat)
           (Ebinop Odiv
             (Ebinop Omul (Evalof (Evar _dt2 tfloat) tfloat)
               (Evalof (Evar _dt tfloat) tfloat) tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _dt4 tfloat)
             (Ebinop Odiv
               (Ebinop Omul (Evalof (Evar _dt2 tfloat) tfloat)
                 (Evalof (Evar _dt2 tfloat) tfloat) tfloat)
               (Eval (Vsingle (Float32.of_bits (Int.repr 1082130432))) tfloat)
               tfloat) tfloat))
      (Ssequence
        (Sfor
          (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
          (Ebinop Olt (Evalof (Evar _i tint) tint)
            (Eval (Vint (Int.repr 6)) tint) tint)
          (Sdo (Epostincr Incr (Evar _i tint) tint))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                               (Tstruct _SimpleKinematicKalman noattr))
                             (Tstruct _SimpleKinematicKalman noattr)) _state
                           (tarray tfloat 6)) (tarray tfloat 6))
                       (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                   tfloat))
            (Sfor
              (Sdo (Eassign (Evar _j tint) (Eval (Vint (Int.repr 0)) tint)
                     tint))
              (Ebinop Olt (Evalof (Evar _j tint) tint)
                (Eval (Vint (Int.repr 6)) tint) tint)
              (Sdo (Epostincr Incr (Evar _j tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     _P (tarray (tarray tfloat 6) 6))
                                   (tarray (tarray tfloat 6) 6))
                                 (Evalof (Evar _i tint) tint)
                                 (tptr (tarray tfloat 6))) (tarray tfloat 6))
                             (tarray tfloat 6)) (Evalof (Evar _j tint) tint)
                           (tptr tfloat)) tfloat)
                       (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                       tfloat))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     _Q (tarray (tarray tfloat 6) 6))
                                   (tarray (tarray tfloat 6) 6))
                                 (Evalof (Evar _i tint) tint)
                                 (tptr (tarray tfloat 6))) (tarray tfloat 6))
                             (tarray tfloat 6)) (Evalof (Evar _j tint) tint)
                           (tptr tfloat)) tfloat)
                       (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                       tfloat))))))
        (Ssequence
          (Sfor
            (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint)
                   tint))
            (Ebinop Olt (Evalof (Evar _i tint) tint)
              (Eval (Vint (Int.repr 6)) tint) tint)
            (Sdo (Eassignop Oadd (Evar _i tint)
                   (Eval (Vint (Int.repr 2)) tint) tint tint))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   _P (tarray (tarray tfloat 6) 6))
                                 (tarray (tarray tfloat 6) 6))
                               (Evalof (Evar _i tint) tint)
                               (tptr (tarray tfloat 6))) (tarray tfloat 6))
                           (tarray tfloat 6)) (Evalof (Evar _i tint) tint)
                         (tptr tfloat)) tfloat)
                     (Evalof (Evar _P0_pos tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     _P (tarray (tarray tfloat 6) 6))
                                   (tarray (tarray tfloat 6) 6))
                                 (Ebinop Oadd (Evalof (Evar _i tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr (tarray tfloat 6))) (tarray tfloat 6))
                             (tarray tfloat 6))
                           (Ebinop Oadd (Evalof (Evar _i tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr tfloat)) tfloat)
                       (Evalof (Evar _P0_speed tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                             (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (Tstruct _SimpleKinematicKalman noattr))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       _Q (tarray (tarray tfloat 6) 6))
                                     (tarray (tarray tfloat 6) 6))
                                   (Evalof (Evar _i tint) tint)
                                   (tptr (tarray tfloat 6)))
                                 (tarray tfloat 6)) (tarray tfloat 6))
                             (Evalof (Evar _i tint) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Omul (Evalof (Evar _Q_sigma2 tfloat) tfloat)
                           (Evalof (Evar _dt4 tfloat) tfloat) tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                               (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                             (Tstruct _SimpleKinematicKalman noattr))
                                           (Tstruct _SimpleKinematicKalman noattr))
                                         _Q (tarray (tarray tfloat 6) 6))
                                       (tarray (tarray tfloat 6) 6))
                                     (Ebinop Oadd
                                       (Evalof (Evar _i tint) tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (tptr (tarray tfloat 6)))
                                   (tarray tfloat 6)) (tarray tfloat 6))
                               (Evalof (Evar _i tint) tint) (tptr tfloat))
                             tfloat)
                           (Ebinop Omul
                             (Evalof (Evar _Q_sigma2 tfloat) tfloat)
                             (Evalof (Evar _dt3 tfloat) tfloat) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                               (Tstruct _SimpleKinematicKalman noattr))
                                             (Tstruct _SimpleKinematicKalman noattr))
                                           _Q (tarray (tarray tfloat 6) 6))
                                         (tarray (tarray tfloat 6) 6))
                                       (Evalof (Evar _i tint) tint)
                                       (tptr (tarray tfloat 6)))
                                     (tarray tfloat 6)) (tarray tfloat 6))
                                 (Ebinop Oadd (Evalof (Evar _i tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Omul
                               (Evalof (Evar _Q_sigma2 tfloat) tfloat)
                               (Evalof (Evar _dt3 tfloat) tfloat) tfloat)
                             tfloat))
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                               (Tstruct _SimpleKinematicKalman noattr))
                                             (Tstruct _SimpleKinematicKalman noattr))
                                           _Q (tarray (tarray tfloat 6) 6))
                                         (tarray (tarray tfloat 6) 6))
                                       (Ebinop Oadd
                                         (Evalof (Evar _i tint) tint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) (tptr (tarray tfloat 6)))
                                     (tarray tfloat 6)) (tarray tfloat 6))
                                 (Ebinop Oadd (Evalof (Evar _i tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Omul
                               (Evalof (Evar _Q_sigma2 tfloat) tfloat)
                               (Evalof (Evar _dt2 tfloat) tfloat) tfloat)
                             tfloat))))))))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                         (Tstruct _SimpleKinematicKalman noattr))
                       (Tstruct _SimpleKinematicKalman noattr)) _r tfloat)
                   (Evalof (Evar _r tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                             (tptr (Tstruct _SimpleKinematicKalman noattr)))
                           (Tstruct _SimpleKinematicKalman noattr))
                         (Tstruct _SimpleKinematicKalman noattr)) _dt tfloat)
                     (Evalof (Evar _dt tfloat) tfloat) tfloat))
              (Ssequence
                (Ssequence
                  (Sdo (Eassign (Evar _i__1 tint)
                         (Eval (Vint (Int.repr 0)) tint) tint))
                  (Sfor
                    Sskip
                    (Ebinop Olt (Evalof (Evar _i__1 tint) tint)
                      (Eval (Vint (Int.repr 6)) tint) tint)
                    (Sdo (Epostincr Incr (Evar _i__1 tint) tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _j__1 tint)
                             (Eval (Vint (Int.repr 0)) tint) tint))
                      (Sfor
                        Sskip
                        (Ebinop Olt (Evalof (Evar _j__1 tint) tint)
                          (Eval (Vint (Int.repr 6)) tint) tint)
                        (Sdo (Epostincr Incr (Evar _j__1 tint) tint))
                        (Sifthenelse (Ebinop Oeq
                                       (Evalof (Evar _i__1 tint) tint)
                                       (Evalof (Evar _j__1 tint) tint) tint)
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                 (Tstruct _SimpleKinematicKalman noattr))
                                               _F
                                               (tarray (tarray tfloat 6) 6))
                                             (tarray (tarray tfloat 6) 6))
                                           (Evalof (Evar _i__1 tint) tint)
                                           (tptr (tarray tfloat 6)))
                                         (tarray tfloat 6))
                                       (tarray tfloat 6))
                                     (Evalof (Evar _i__1 tint) tint)
                                     (tptr tfloat)) tfloat)
                                 (Eval (Vint (Int.repr 1)) tint) tfloat))
                          (Sifthenelse (Eseqand
                                         (Ebinop Oeq
                                           (Ebinop Omod
                                             (Evalof (Evar _i__1 tint) tint)
                                             (Eval (Vint (Int.repr 2)) tint)
                                             tint)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint)
                                         (Ebinop Oeq
                                           (Evalof (Evar _j__1 tint) tint)
                                           (Ebinop Oadd
                                             (Evalof (Evar _i__1 tint) tint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tint) tint) tint)
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                     (Tstruct _SimpleKinematicKalman noattr))
                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                 _F
                                                 (tarray (tarray tfloat 6) 6))
                                               (tarray (tarray tfloat 6) 6))
                                             (Evalof (Evar _i__1 tint) tint)
                                             (tptr (tarray tfloat 6)))
                                           (tarray tfloat 6))
                                         (tarray tfloat 6))
                                       (Evalof (Evar _j__1 tint) tint)
                                       (tptr tfloat)) tfloat)
                                   (Evalof (Evar _dt tfloat) tfloat) tfloat))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                     (Tstruct _SimpleKinematicKalman noattr))
                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                 _F
                                                 (tarray (tarray tfloat 6) 6))
                                               (tarray (tarray tfloat 6) 6))
                                             (Evalof (Evar _i__1 tint) tint)
                                             (tptr (tarray tfloat 6)))
                                           (tarray tfloat 6))
                                         (tarray tfloat 6))
                                       (Evalof (Evar _j__1 tint) tint)
                                       (tptr tfloat)) tfloat)
                                   (Eval (Vint (Int.repr 0)) tint) tfloat))))))))
                (Ssequence
                  (Sdo (Eassign (Evar _i__2 tint)
                         (Eval (Vint (Int.repr 0)) tint) tint))
                  (Sfor
                    Sskip
                    (Ebinop Olt (Evalof (Evar _i__2 tint) tint)
                      (Ebinop Odiv (Eval (Vint (Int.repr 6)) tint)
                        (Eval (Vint (Int.repr 2)) tint) tint) tint)
                    (Sdo (Epostincr Incr (Evar _i__2 tint) tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _j__2 tint)
                             (Eval (Vint (Int.repr 0)) tint) tint))
                      (Sfor
                        Sskip
                        (Ebinop Olt (Evalof (Evar _j__2 tint) tint)
                          (Eval (Vint (Int.repr 6)) tint) tint)
                        (Sdo (Epostincr Incr (Evar _j__2 tint) tint))
                        (Ssequence
                          (Sifthenelse (Ebinop Oeq
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Evalof (Evar _i__2 tint) tint)
                                           tint)
                                         (Evalof (Evar _j__2 tint) tint)
                                         tint)
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                     (Tstruct _SimpleKinematicKalman noattr))
                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                 _Hp
                                                 (tarray (tarray tfloat 6) 3))
                                               (tarray (tarray tfloat 6) 3))
                                             (Evalof (Evar _i__2 tint) tint)
                                             (tptr (tarray tfloat 6)))
                                           (tarray tfloat 6))
                                         (tarray tfloat 6))
                                       (Evalof (Evar _j__2 tint) tint)
                                       (tptr tfloat)) tfloat)
                                   (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                                   tfloat))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                     (Tstruct _SimpleKinematicKalman noattr))
                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                 _Hp
                                                 (tarray (tarray tfloat 6) 3))
                                               (tarray (tarray tfloat 6) 3))
                                             (Evalof (Evar _i__2 tint) tint)
                                             (tptr (tarray tfloat 6)))
                                           (tarray tfloat 6))
                                         (tarray tfloat 6))
                                       (Evalof (Evar _j__2 tint) tint)
                                       (tptr tfloat)) tfloat)
                                   (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                                   tfloat)))
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                 (Tstruct _SimpleKinematicKalman noattr))
                                               _Hs
                                               (tarray (tarray tfloat 6) 3))
                                             (tarray (tarray tfloat 6) 3))
                                           (Evalof (Evar _i__2 tint) tint)
                                           (tptr (tarray tfloat 6)))
                                         (tarray tfloat 6))
                                       (tarray tfloat 6))
                                     (Evalof (Evar _j__2 tint) tint)
                                     (tptr tfloat)) tfloat)
                                 (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                                 tfloat)))))))))))))))
|}.

Definition f_simple_kinematic_kalman_predict := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_kalman, (tptr (Tstruct _SimpleKinematicKalman noattr))) ::
                nil);
  fn_vars := ((_i, tint) :: (_d_dt, tfloat) :: nil);
  fn_body :=
(Sfor
  (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ebinop Olt (Evalof (Evar _i tint) tint) (Eval (Vint (Int.repr 6)) tint)
    tint)
  (Sdo (Eassignop Oadd (Evar _i tint) (Eval (Vint (Int.repr 2)) tint)
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
                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                       (Tstruct _SimpleKinematicKalman noattr))
                     (Tstruct _SimpleKinematicKalman noattr)) _state
                   (tarray tfloat 6)) (tarray tfloat 6))
               (Evalof (Evar _i tint) tint) (tptr tfloat)) tfloat)
           (Ebinop Omul
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                             (tptr (Tstruct _SimpleKinematicKalman noattr)))
                           (Tstruct _SimpleKinematicKalman noattr))
                         (Tstruct _SimpleKinematicKalman noattr)) _state
                       (tarray tfloat 6)) (tarray tfloat 6))
                   (Ebinop Oadd (Evalof (Evar _i tint) tint)
                     (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                 tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                     (Tstruct _SimpleKinematicKalman noattr))
                   (Tstruct _SimpleKinematicKalman noattr)) _dt tfloat)
               tfloat) tfloat) tfloat tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _d_dt tfloat)
             (Ebinop Omul
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 (Tstruct _SimpleKinematicKalman noattr)) _P
                               (tarray (tarray tfloat 6) 6))
                             (tarray (tarray tfloat 6) 6))
                           (Ebinop Oadd (Evalof (Evar _i tint) tint)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (tptr (tarray tfloat 6))) (tarray tfloat 6))
                       (tarray tfloat 6))
                     (Ebinop Oadd (Evalof (Evar _i tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                   tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                       (Tstruct _SimpleKinematicKalman noattr))
                     (Tstruct _SimpleKinematicKalman noattr)) _dt tfloat)
                 tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassignop Oadd
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                   (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                 (Tstruct _SimpleKinematicKalman noattr))
                               (Tstruct _SimpleKinematicKalman noattr)) _P
                             (tarray (tarray tfloat 6) 6))
                           (tarray (tarray tfloat 6) 6))
                         (Evalof (Evar _i tint) tint)
                         (tptr (tarray tfloat 6))) (tarray tfloat 6))
                     (tarray tfloat 6)) (Evalof (Evar _i tint) tint)
                   (tptr tfloat)) tfloat)
               (Ebinop Oadd
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     _P (tarray (tarray tfloat 6) 6))
                                   (tarray (tarray tfloat 6) 6))
                                 (Ebinop Oadd (Evalof (Evar _i tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr (tarray tfloat 6))) (tarray tfloat 6))
                             (tarray tfloat 6)) (Evalof (Evar _i tint) tint)
                           (tptr tfloat)) tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                               (tptr (Tstruct _SimpleKinematicKalman noattr)))
                             (Tstruct _SimpleKinematicKalman noattr))
                           (Tstruct _SimpleKinematicKalman noattr)) _dt
                         tfloat) tfloat) tfloat)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                               (tptr (Tstruct _SimpleKinematicKalman noattr)))
                             (Tstruct _SimpleKinematicKalman noattr))
                           (Tstruct _SimpleKinematicKalman noattr)) _dt
                         tfloat) tfloat)
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                             (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (Tstruct _SimpleKinematicKalman noattr))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       _P (tarray (tarray tfloat 6) 6))
                                     (tarray (tarray tfloat 6) 6))
                                   (Evalof (Evar _i tint) tint)
                                   (tptr (tarray tfloat 6)))
                                 (tarray tfloat 6)) (tarray tfloat 6))
                             (Ebinop Oadd (Evalof (Evar _i tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (tptr tfloat)) tfloat) tfloat)
                       (Evalof (Evar _d_dt tfloat) tfloat) tfloat) tfloat)
                   tfloat)
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 _Q (tarray (tarray tfloat 6) 6))
                               (tarray (tarray tfloat 6) 6))
                             (Evalof (Evar _i tint) tint)
                             (tptr (tarray tfloat 6))) (tarray tfloat 6))
                         (tarray tfloat 6)) (Evalof (Evar _i tint) tint)
                       (tptr tfloat)) tfloat) tfloat) tfloat) tfloat tfloat))
        (Ssequence
          (Sdo (Eassignop Oadd
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 (Tstruct _SimpleKinematicKalman noattr)) _P
                               (tarray (tarray tfloat 6) 6))
                             (tarray (tarray tfloat 6) 6))
                           (Evalof (Evar _i tint) tint)
                           (tptr (tarray tfloat 6))) (tarray tfloat 6))
                       (tarray tfloat 6))
                     (Ebinop Oadd (Evalof (Evar _i tint) tint)
                       (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                   tfloat)
                 (Ebinop Oadd (Evalof (Evar _d_dt tfloat) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   _Q (tarray (tarray tfloat 6) 6))
                                 (tarray (tarray tfloat 6) 6))
                               (Evalof (Evar _i tint) tint)
                               (tptr (tarray tfloat 6))) (tarray tfloat 6))
                           (tarray tfloat 6))
                         (Ebinop Oadd (Evalof (Evar _i tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat)
                 tfloat tfloat))
          (Ssequence
            (Sdo (Eassignop Oadd
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 _P (tarray (tarray tfloat 6) 6))
                               (tarray (tarray tfloat 6) 6))
                             (Ebinop Oadd (Evalof (Evar _i tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (tptr (tarray tfloat 6))) (tarray tfloat 6))
                         (tarray tfloat 6)) (Evalof (Evar _i tint) tint)
                       (tptr tfloat)) tfloat)
                   (Ebinop Oadd (Evalof (Evar _d_dt tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     _Q (tarray (tarray tfloat 6) 6))
                                   (tarray (tarray tfloat 6) 6))
                                 (Ebinop Oadd (Evalof (Evar _i tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr (tarray tfloat 6))) (tarray tfloat 6))
                             (tarray tfloat 6)) (Evalof (Evar _i tint) tint)
                           (tptr tfloat)) tfloat) tfloat) tfloat)
                   tfloat tfloat))
            (Sdo (Eassignop Oadd
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 _P (tarray (tarray tfloat 6) 6))
                               (tarray (tarray tfloat 6) 6))
                             (Ebinop Oadd (Evalof (Evar _i tint) tint)
                               (Eval (Vint (Int.repr 1)) tint) tint)
                             (tptr (tarray tfloat 6))) (tarray tfloat 6))
                         (tarray tfloat 6))
                       (Ebinop Oadd (Evalof (Evar _i tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint) (tptr tfloat))
                     tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   _Q (tarray (tarray tfloat 6) 6))
                                 (tarray (tarray tfloat 6) 6))
                               (Ebinop Oadd (Evalof (Evar _i tint) tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (tptr (tarray tfloat 6))) (tarray tfloat 6))
                           (tarray tfloat 6))
                         (Ebinop Oadd (Evalof (Evar _i tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat tfloat))))))))
|}.

Definition f_simple_kinematic_kalman_update := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_kalman, (tptr (Tstruct _SimpleKinematicKalman noattr))) ::
                (__H, (tptr (tptr tfloat))) :: (_Z, (tptr tfloat)) :: nil);
  fn_vars := ((_S, (tarray (tarray tfloat 3) 3)) ::
              (__S, (tarray (tptr tfloat) 3)) :: (___i, tint) ::
              (_invS, (tarray (tarray tfloat 3) 3)) ::
              (__invS, (tarray (tptr tfloat) 3)) :: (___i__1, tint) ::
              (_HinvS_tmp, (tarray (tarray tfloat 3) 6)) ::
              (__HinvS_tmp, (tarray (tptr tfloat) 6)) :: (___i__2, tint) ::
              (_Ht, (tarray (tarray tfloat 3) 6)) ::
              (__Ht, (tarray (tptr tfloat) 6)) :: (___i__3, tint) ::
              (_K, (tarray (tarray tfloat 3) 6)) ::
              (__K, (tarray (tptr tfloat) 6)) :: (___i__4, tint) ::
              (_HX_tmp, (tarray tfloat 3)) :: (_Z_HX, (tarray tfloat 3)) ::
              (_K_ZHX_tmp, (tarray tfloat 6)) ::
              (_KH_tmp, (tarray (tarray tfloat 6) 6)) ::
              (__KH_tmp, (tarray (tptr tfloat) 6)) :: (___i__5, tint) ::
              (__P, (tarray (tptr tfloat) 6)) :: (___i__6, tint) ::
              (_P_tmp, (tarray (tarray tfloat 6) 6)) :: (_i, tint) ::
              (_j, tint) :: (_i__1, tint) :: (_j__1, tint) :: (_k, tint) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                     (tarray (tarray tfloat 3) 3))
                   (Eval (Vint (Int.repr 0)) tint) (tptr (tarray tfloat 3)))
                 (tarray tfloat 3)) (tarray tfloat 3))
             (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
         (Ebinop Oadd
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                               (Tstruct _SimpleKinematicKalman noattr))
                             (Tstruct _SimpleKinematicKalman noattr)) _P
                           (tarray (tarray tfloat 6) 6))
                         (tarray (tarray tfloat 6) 6))
                       (Eval (Vint (Int.repr 0)) tint)
                       (tptr (tarray tfloat 6))) (tarray tfloat 6))
                   (tarray tfloat 6)) (Eval (Vint (Int.repr 0)) tint)
                 (tptr tfloat)) tfloat) tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                   (Tstruct _SimpleKinematicKalman noattr))
                 (Tstruct _SimpleKinematicKalman noattr)) _r tfloat) tfloat)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                       (tarray (tarray tfloat 3) 3))
                     (Eval (Vint (Int.repr 0)) tint)
                     (tptr (tarray tfloat 3))) (tarray tfloat 3))
                 (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
               (tptr tfloat)) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                               (Tstruct _SimpleKinematicKalman noattr))
                             (Tstruct _SimpleKinematicKalman noattr)) _P
                           (tarray (tarray tfloat 6) 6))
                         (tarray (tarray tfloat 6) 6))
                       (Eval (Vint (Int.repr 0)) tint)
                       (tptr (tarray tfloat 6))) (tarray tfloat 6))
                   (tarray tfloat 6)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tfloat)) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                         (tarray (tarray tfloat 3) 3))
                       (Eval (Vint (Int.repr 0)) tint)
                       (tptr (tarray tfloat 3))) (tarray tfloat 3))
                   (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                 (tptr tfloat)) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                   (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                 (Tstruct _SimpleKinematicKalman noattr))
                               (Tstruct _SimpleKinematicKalman noattr)) _P
                             (tarray (tarray tfloat 6) 6))
                           (tarray (tarray tfloat 6) 6))
                         (Eval (Vint (Int.repr 0)) tint)
                         (tptr (tarray tfloat 6))) (tarray tfloat 6))
                     (tarray tfloat 6)) (Eval (Vint (Int.repr 4)) tint)
                   (tptr tfloat)) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                           (tarray (tarray tfloat 3) 3))
                         (Eval (Vint (Int.repr 1)) tint)
                         (tptr (tarray tfloat 3))) (tarray tfloat 3))
                     (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                   (tptr tfloat)) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 (Tstruct _SimpleKinematicKalman noattr)) _P
                               (tarray (tarray tfloat 6) 6))
                             (tarray (tarray tfloat 6) 6))
                           (Eval (Vint (Int.repr 2)) tint)
                           (tptr (tarray tfloat 6))) (tarray tfloat 6))
                       (tarray tfloat 6)) (Eval (Vint (Int.repr 0)) tint)
                     (tptr tfloat)) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                             (tarray (tarray tfloat 3) 3))
                           (Eval (Vint (Int.repr 1)) tint)
                           (tptr (tarray tfloat 3))) (tarray tfloat 3))
                       (tarray tfloat 3)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat)
                 (Ebinop Oadd
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   _P (tarray (tarray tfloat 6) 6))
                                 (tarray (tarray tfloat 6) 6))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr (tarray tfloat 6))) (tarray tfloat 6))
                           (tarray tfloat 6)) (Eval (Vint (Int.repr 2)) tint)
                         (tptr tfloat)) tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                             (tptr (Tstruct _SimpleKinematicKalman noattr)))
                           (Tstruct _SimpleKinematicKalman noattr))
                         (Tstruct _SimpleKinematicKalman noattr)) _r tfloat)
                     tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                               (tarray (tarray tfloat 3) 3))
                             (Eval (Vint (Int.repr 1)) tint)
                             (tptr (tarray tfloat 3))) (tarray tfloat 3))
                         (tarray tfloat 3)) (Eval (Vint (Int.repr 2)) tint)
                       (tptr tfloat)) tfloat)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     (Tstruct _SimpleKinematicKalman noattr))
                                   _P (tarray (tarray tfloat 6) 6))
                                 (tarray (tarray tfloat 6) 6))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr (tarray tfloat 6))) (tarray tfloat 6))
                           (tarray tfloat 6)) (Eval (Vint (Int.repr 4)) tint)
                         (tptr tfloat)) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _S (tarray (tarray tfloat 3) 3))
                                 (tarray (tarray tfloat 3) 3))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr (tarray tfloat 3))) (tarray tfloat 3))
                           (tarray tfloat 3)) (Eval (Vint (Int.repr 0)) tint)
                         (tptr tfloat)) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       (Tstruct _SimpleKinematicKalman noattr))
                                     _P (tarray (tarray tfloat 6) 6))
                                   (tarray (tarray tfloat 6) 6))
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr (tarray tfloat 6))) (tarray tfloat 6))
                             (tarray tfloat 6))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Evar _S (tarray (tarray tfloat 3) 3))
                                   (tarray (tarray tfloat 3) 3))
                                 (Eval (Vint (Int.repr 2)) tint)
                                 (tptr (tarray tfloat 3))) (tarray tfloat 3))
                             (tarray tfloat 3))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                         tfloat)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                             (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                           (Tstruct _SimpleKinematicKalman noattr))
                                         (Tstruct _SimpleKinematicKalman noattr))
                                       _P (tarray (tarray tfloat 6) 6))
                                     (tarray (tarray tfloat 6) 6))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr (tarray tfloat 6)))
                                 (tarray tfloat 6)) (tarray tfloat 6))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar _S (tarray (tarray tfloat 3) 3))
                                     (tarray (tarray tfloat 3) 3))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr (tarray tfloat 3)))
                                 (tarray tfloat 3)) (tarray tfloat 3))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Oadd
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                               (Tstruct _SimpleKinematicKalman noattr))
                                             (Tstruct _SimpleKinematicKalman noattr))
                                           _P (tarray (tarray tfloat 6) 6))
                                         (tarray (tarray tfloat 6) 6))
                                       (Eval (Vint (Int.repr 4)) tint)
                                       (tptr (tarray tfloat 6)))
                                     (tarray tfloat 6)) (tarray tfloat 6))
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                     (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                   (Tstruct _SimpleKinematicKalman noattr))
                                 (Tstruct _SimpleKinematicKalman noattr)) _r
                               tfloat) tfloat) tfloat) tfloat))
                  (Ssequence
                    (Sifthenelse (Ebinop Olt
                                   (Ebinop Oadd
                                     (Ebinop Oadd
                                       (Ecall
                                         (Evalof
                                           (Evar _fabsf (Tfunction
                                                          (tfloat :: nil)
                                                          tfloat cc_default))
                                           (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                                         (Econs
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Ederef
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Evar _S (tarray (tarray tfloat 3) 3))
                                                         (tarray (tarray tfloat 3) 3))
                                                       (Eval (Vint (Int.repr 0)) tint)
                                                       (tptr (tarray tfloat 3)))
                                                     (tarray tfloat 3))
                                                   (tarray tfloat 3))
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 (tptr tfloat)) tfloat)
                                             tfloat) Enil) tfloat)
                                       (Ecall
                                         (Evalof
                                           (Evar _fabsf (Tfunction
                                                          (tfloat :: nil)
                                                          tfloat cc_default))
                                           (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                                         (Econs
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Ederef
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Evar _S (tarray (tarray tfloat 3) 3))
                                                         (tarray (tarray tfloat 3) 3))
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       (tptr (tarray tfloat 3)))
                                                     (tarray tfloat 3))
                                                   (tarray tfloat 3))
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 (tptr tfloat)) tfloat)
                                             tfloat) Enil) tfloat) tfloat)
                                     (Ecall
                                       (Evalof
                                         (Evar _fabsf (Tfunction
                                                        (tfloat :: nil)
                                                        tfloat cc_default))
                                         (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                                       (Econs
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Ederef
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _S (tarray (tarray tfloat 3) 3))
                                                       (tarray (tarray tfloat 3) 3))
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     (tptr (tarray tfloat 3)))
                                                   (tarray tfloat 3))
                                                 (tarray tfloat 3))
                                               (Eval (Vint (Int.repr 2)) tint)
                                               (tptr tfloat)) tfloat) tfloat)
                                         Enil) tfloat) tfloat)
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4532020583610935537))) tdouble)
                                   tint)
                      (Sreturn None)
                      Sskip)
                    (Ssequence
                      (Sfor
                        (Sdo (Eassign (Evar ___i tint)
                               (Eval (Vint (Int.repr 0)) tint) tint))
                        (Ebinop Olt (Evalof (Evar ___i tint) tint)
                          (Eval (Vint (Int.repr 3)) tint) tint)
                        (Sdo (Epostincr Incr (Evar ___i tint) tint))
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Evar __S (tarray (tptr tfloat) 3))
                                     (tarray (tptr tfloat) 3))
                                   (Evalof (Evar ___i tint) tint)
                                   (tptr (tptr tfloat))) (tptr tfloat))
                               (Eaddrof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _S (tarray (tarray tfloat 3) 3))
                                             (tarray (tarray tfloat 3) 3))
                                           (Evalof (Evar ___i tint) tint)
                                           (tptr (tarray tfloat 3)))
                                         (tarray tfloat 3))
                                       (tarray tfloat 3))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat) (tptr tfloat))
                               (tptr tfloat))))
                      (Ssequence
                        (Sfor
                          (Sdo (Eassign (Evar ___i__1 tint)
                                 (Eval (Vint (Int.repr 0)) tint) tint))
                          (Ebinop Olt (Evalof (Evar ___i__1 tint) tint)
                            (Eval (Vint (Int.repr 3)) tint) tint)
                          (Sdo (Epostincr Incr (Evar ___i__1 tint) tint))
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar __invS (tarray (tptr tfloat) 3))
                                       (tarray (tptr tfloat) 3))
                                     (Evalof (Evar ___i__1 tint) tint)
                                     (tptr (tptr tfloat))) (tptr tfloat))
                                 (Eaddrof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _invS (tarray (tarray tfloat 3) 3))
                                               (tarray (tarray tfloat 3) 3))
                                             (Evalof (Evar ___i__1 tint)
                                               tint)
                                             (tptr (tarray tfloat 3)))
                                           (tarray tfloat 3))
                                         (tarray tfloat 3))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tfloat)) tfloat) (tptr tfloat))
                                 (tptr tfloat))))
                        (Ssequence
                          (Sfor
                            (Sdo (Eassign (Evar ___i__2 tint)
                                   (Eval (Vint (Int.repr 0)) tint) tint))
                            (Ebinop Olt (Evalof (Evar ___i__2 tint) tint)
                              (Eval (Vint (Int.repr 6)) tint) tint)
                            (Sdo (Epostincr Incr (Evar ___i__2 tint) tint))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar __HinvS_tmp (tarray (tptr tfloat) 6))
                                         (tarray (tptr tfloat) 6))
                                       (Evalof (Evar ___i__2 tint) tint)
                                       (tptr (tptr tfloat))) (tptr tfloat))
                                   (Eaddrof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _HinvS_tmp (tarray (tarray tfloat 3) 6))
                                                 (tarray (tarray tfloat 3) 6))
                                               (Evalof (Evar ___i__2 tint)
                                                 tint)
                                               (tptr (tarray tfloat 3)))
                                             (tarray tfloat 3))
                                           (tarray tfloat 3))
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (tptr tfloat)) tfloat)
                                     (tptr tfloat)) (tptr tfloat))))
                          (Ssequence
                            (Sfor
                              (Sdo (Eassign (Evar ___i__3 tint)
                                     (Eval (Vint (Int.repr 0)) tint) tint))
                              (Ebinop Olt (Evalof (Evar ___i__3 tint) tint)
                                (Eval (Vint (Int.repr 6)) tint) tint)
                              (Sdo (Epostincr Incr (Evar ___i__3 tint) tint))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar __Ht (tarray (tptr tfloat) 6))
                                           (tarray (tptr tfloat) 6))
                                         (Evalof (Evar ___i__3 tint) tint)
                                         (tptr (tptr tfloat))) (tptr tfloat))
                                     (Eaddrof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _Ht (tarray (tarray tfloat 3) 6))
                                                   (tarray (tarray tfloat 3) 6))
                                                 (Evalof (Evar ___i__3 tint)
                                                   tint)
                                                 (tptr (tarray tfloat 3)))
                                               (tarray tfloat 3))
                                             (tarray tfloat 3))
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (tptr tfloat)) tfloat)
                                       (tptr tfloat)) (tptr tfloat))))
                            (Ssequence
                              (Sfor
                                (Sdo (Eassign (Evar ___i__4 tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint))
                                (Ebinop Olt (Evalof (Evar ___i__4 tint) tint)
                                  (Eval (Vint (Int.repr 6)) tint) tint)
                                (Sdo (Epostincr Incr (Evar ___i__4 tint)
                                       tint))
                                (Sdo (Eassign
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar __K (tarray (tptr tfloat) 6))
                                             (tarray (tptr tfloat) 6))
                                           (Evalof (Evar ___i__4 tint) tint)
                                           (tptr (tptr tfloat)))
                                         (tptr tfloat))
                                       (Eaddrof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _K (tarray (tarray tfloat 3) 6))
                                                     (tarray (tarray tfloat 3) 6))
                                                   (Evalof
                                                     (Evar ___i__4 tint)
                                                     tint)
                                                   (tptr (tarray tfloat 3)))
                                                 (tarray tfloat 3))
                                               (tarray tfloat 3))
                                             (Eval (Vint (Int.repr 0)) tint)
                                             (tptr tfloat)) tfloat)
                                         (tptr tfloat)) (tptr tfloat))))
                              (Ssequence
                                (Sfor
                                  (Sdo (Eassign (Evar ___i__5 tint)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tint))
                                  (Ebinop Olt
                                    (Evalof (Evar ___i__5 tint) tint)
                                    (Eval (Vint (Int.repr 6)) tint) tint)
                                  (Sdo (Epostincr Incr (Evar ___i__5 tint)
                                         tint))
                                  (Sdo (Eassign
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar __KH_tmp (tarray (tptr tfloat) 6))
                                               (tarray (tptr tfloat) 6))
                                             (Evalof (Evar ___i__5 tint)
                                               tint) (tptr (tptr tfloat)))
                                           (tptr tfloat))
                                         (Eaddrof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Ederef
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _KH_tmp (tarray (tarray tfloat 6) 6))
                                                       (tarray (tarray tfloat 6) 6))
                                                     (Evalof
                                                       (Evar ___i__5 tint)
                                                       tint)
                                                     (tptr (tarray tfloat 6)))
                                                   (tarray tfloat 6))
                                                 (tarray tfloat 6))
                                               (Eval (Vint (Int.repr 0)) tint)
                                               (tptr tfloat)) tfloat)
                                           (tptr tfloat)) (tptr tfloat))))
                                (Ssequence
                                  (Sfor
                                    (Sdo (Eassign (Evar ___i__6 tint)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint))
                                    (Ebinop Olt
                                      (Evalof (Evar ___i__6 tint) tint)
                                      (Eval (Vint (Int.repr 6)) tint) tint)
                                    (Sdo (Epostincr Incr (Evar ___i__6 tint)
                                           tint))
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar __P (tarray (tptr tfloat) 6))
                                                 (tarray (tptr tfloat) 6))
                                               (Evalof (Evar ___i__6 tint)
                                                 tint) (tptr (tptr tfloat)))
                                             (tptr tfloat))
                                           (Eaddrof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Ederef
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Ederef
                                                               (Evalof
                                                                 (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                 (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                               (Tstruct _SimpleKinematicKalman noattr))
                                                             (Tstruct _SimpleKinematicKalman noattr))
                                                           _P
                                                           (tarray (tarray tfloat 6) 6))
                                                         (tarray (tarray tfloat 6) 6))
                                                       (Evalof
                                                         (Evar ___i__6 tint)
                                                         tint)
                                                       (tptr (tarray tfloat 6)))
                                                     (tarray tfloat 6))
                                                   (tarray tfloat 6))
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 (tptr tfloat)) tfloat)
                                             (tptr tfloat)) (tptr tfloat))))
                                  (Ssequence
                                    (Sdo (Ecall
                                           (Evalof
                                             (Evar _float_mat_invert 
                                             (Tfunction
                                               ((tptr (tptr tfloat)) ::
                                                (tptr (tptr tfloat)) ::
                                                tint :: nil) tvoid
                                               cc_default))
                                             (Tfunction
                                               ((tptr (tptr tfloat)) ::
                                                (tptr (tptr tfloat)) ::
                                                tint :: nil) tvoid
                                               cc_default))
                                           (Econs
                                             (Evalof
                                               (Evar __invS (tarray (tptr tfloat) 3))
                                               (tarray (tptr tfloat) 3))
                                             (Econs
                                               (Evalof
                                                 (Evar __S (tarray (tptr tfloat) 3))
                                                 (tarray (tptr tfloat) 3))
                                               (Econs
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 Enil))) tvoid))
                                    (Ssequence
                                      (Sdo (Ecall
                                             (Evalof
                                               (Evar _float_mat_transpose 
                                               (Tfunction
                                                 ((tptr (tptr tfloat)) ::
                                                  (tptr (tptr tfloat)) ::
                                                  tint :: tint :: nil) tvoid
                                                 cc_default))
                                               (Tfunction
                                                 ((tptr (tptr tfloat)) ::
                                                  (tptr (tptr tfloat)) ::
                                                  tint :: tint :: nil) tvoid
                                                 cc_default))
                                             (Econs
                                               (Evalof
                                                 (Evar __Ht (tarray (tptr tfloat) 6))
                                                 (tarray (tptr tfloat) 6))
                                               (Econs
                                                 (Evalof
                                                   (Evar __H (tptr (tptr tfloat)))
                                                   (tptr (tptr tfloat)))
                                                 (Econs
                                                   (Eval (Vint (Int.repr 3)) tint)
                                                   (Econs
                                                     (Eval (Vint (Int.repr 6)) tint)
                                                     Enil)))) tvoid))
                                      (Ssequence
                                        (Sdo (Ecall
                                               (Evalof
                                                 (Evar _float_mat_mul 
                                                 (Tfunction
                                                   ((tptr (tptr tfloat)) ::
                                                    (tptr (tptr tfloat)) ::
                                                    (tptr (tptr tfloat)) ::
                                                    tint :: tint :: tint ::
                                                    nil) tvoid cc_default))
                                                 (Tfunction
                                                   ((tptr (tptr tfloat)) ::
                                                    (tptr (tptr tfloat)) ::
                                                    (tptr (tptr tfloat)) ::
                                                    tint :: tint :: tint ::
                                                    nil) tvoid cc_default))
                                               (Econs
                                                 (Evalof
                                                   (Evar __HinvS_tmp (tarray (tptr tfloat) 6))
                                                   (tarray (tptr tfloat) 6))
                                                 (Econs
                                                   (Evalof
                                                     (Evar __Ht (tarray (tptr tfloat) 6))
                                                     (tarray (tptr tfloat) 6))
                                                   (Econs
                                                     (Evalof
                                                       (Evar __invS (tarray (tptr tfloat) 3))
                                                       (tarray (tptr tfloat) 3))
                                                     (Econs
                                                       (Eval (Vint (Int.repr 6)) tint)
                                                       (Econs
                                                         (Eval (Vint (Int.repr 3)) tint)
                                                         (Econs
                                                           (Eval (Vint (Int.repr 3)) tint)
                                                           Enil)))))) tvoid))
                                        (Ssequence
                                          (Sdo (Ecall
                                                 (Evalof
                                                   (Evar _float_mat_mul 
                                                   (Tfunction
                                                     ((tptr (tptr tfloat)) ::
                                                      (tptr (tptr tfloat)) ::
                                                      (tptr (tptr tfloat)) ::
                                                      tint :: tint :: tint ::
                                                      nil) tvoid cc_default))
                                                   (Tfunction
                                                     ((tptr (tptr tfloat)) ::
                                                      (tptr (tptr tfloat)) ::
                                                      (tptr (tptr tfloat)) ::
                                                      tint :: tint :: tint ::
                                                      nil) tvoid cc_default))
                                                 (Econs
                                                   (Evalof
                                                     (Evar __K (tarray (tptr tfloat) 6))
                                                     (tarray (tptr tfloat) 6))
                                                   (Econs
                                                     (Evalof
                                                       (Evar __P (tarray (tptr tfloat) 6))
                                                       (tarray (tptr tfloat) 6))
                                                     (Econs
                                                       (Evalof
                                                         (Evar __HinvS_tmp (tarray (tptr tfloat) 6))
                                                         (tarray (tptr tfloat) 6))
                                                       (Econs
                                                         (Eval (Vint (Int.repr 6)) tint)
                                                         (Econs
                                                           (Eval (Vint (Int.repr 6)) tint)
                                                           (Econs
                                                             (Eval (Vint (Int.repr 3)) tint)
                                                             Enil))))))
                                                 tvoid))
                                          (Ssequence
                                            (Sdo (Ecall
                                                   (Evalof
                                                     (Evar _float_mat_vect_mul 
                                                     (Tfunction
                                                       ((tptr tfloat) ::
                                                        (tptr (tptr tfloat)) ::
                                                        (tptr tfloat) ::
                                                        tint :: tint :: nil)
                                                       tvoid cc_default))
                                                     (Tfunction
                                                       ((tptr tfloat) ::
                                                        (tptr (tptr tfloat)) ::
                                                        (tptr tfloat) ::
                                                        tint :: tint :: nil)
                                                       tvoid cc_default))
                                                   (Econs
                                                     (Evalof
                                                       (Evar _HX_tmp (tarray tfloat 3))
                                                       (tarray tfloat 3))
                                                     (Econs
                                                       (Evalof
                                                         (Evar __H (tptr (tptr tfloat)))
                                                         (tptr (tptr tfloat)))
                                                       (Econs
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Ederef
                                                                 (Evalof
                                                                   (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                   (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                 (Tstruct _SimpleKinematicKalman noattr))
                                                               (Tstruct _SimpleKinematicKalman noattr))
                                                             _state
                                                             (tarray tfloat 6))
                                                           (tarray tfloat 6))
                                                         (Econs
                                                           (Eval (Vint (Int.repr 3)) tint)
                                                           (Econs
                                                             (Eval (Vint (Int.repr 6)) tint)
                                                             Enil))))) tvoid))
                                            (Ssequence
                                              (Sdo (Ecall
                                                     (Evalof
                                                       (Evar _float_vect_diff 
                                                       (Tfunction
                                                         ((tptr tfloat) ::
                                                          (tptr tfloat) ::
                                                          (tptr tfloat) ::
                                                          tint :: nil) tvoid
                                                         cc_default))
                                                       (Tfunction
                                                         ((tptr tfloat) ::
                                                          (tptr tfloat) ::
                                                          (tptr tfloat) ::
                                                          tint :: nil) tvoid
                                                         cc_default))
                                                     (Econs
                                                       (Evalof
                                                         (Evar _Z_HX (tarray tfloat 3))
                                                         (tarray tfloat 3))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _Z (tptr tfloat))
                                                           (tptr tfloat))
                                                         (Econs
                                                           (Evalof
                                                             (Evar _HX_tmp (tarray tfloat 3))
                                                             (tarray tfloat 3))
                                                           (Econs
                                                             (Eval (Vint (Int.repr 3)) tint)
                                                             Enil)))) tvoid))
                                              (Ssequence
                                                (Sdo (Ecall
                                                       (Evalof
                                                         (Evar _float_mat_vect_mul 
                                                         (Tfunction
                                                           ((tptr tfloat) ::
                                                            (tptr (tptr tfloat)) ::
                                                            (tptr tfloat) ::
                                                            tint :: tint ::
                                                            nil) tvoid
                                                           cc_default))
                                                         (Tfunction
                                                           ((tptr tfloat) ::
                                                            (tptr (tptr tfloat)) ::
                                                            (tptr tfloat) ::
                                                            tint :: tint ::
                                                            nil) tvoid
                                                           cc_default))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _K_ZHX_tmp (tarray tfloat 6))
                                                           (tarray tfloat 6))
                                                         (Econs
                                                           (Evalof
                                                             (Evar __K (tarray (tptr tfloat) 6))
                                                             (tarray (tptr tfloat) 6))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _Z_HX (tarray tfloat 3))
                                                               (tarray tfloat 3))
                                                             (Econs
                                                               (Eval (Vint (Int.repr 6)) tint)
                                                               (Econs
                                                                 (Eval (Vint (Int.repr 3)) tint)
                                                                 Enil)))))
                                                       tvoid))
                                                (Ssequence
                                                  (Sdo (Ecall
                                                         (Evalof
                                                           (Evar _float_vect_add 
                                                           (Tfunction
                                                             ((tptr tfloat) ::
                                                              (tptr tfloat) ::
                                                              tint :: nil)
                                                             tvoid
                                                             cc_default))
                                                           (Tfunction
                                                             ((tptr tfloat) ::
                                                              (tptr tfloat) ::
                                                              tint :: nil)
                                                             tvoid
                                                             cc_default))
                                                         (Econs
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Ederef
                                                                   (Evalof
                                                                    (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                    (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                   (Tstruct _SimpleKinematicKalman noattr))
                                                                 (Tstruct _SimpleKinematicKalman noattr))
                                                               _state
                                                               (tarray tfloat 6))
                                                             (tarray tfloat 6))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _K_ZHX_tmp (tarray tfloat 6))
                                                               (tarray tfloat 6))
                                                             (Econs
                                                               (Eval (Vint (Int.repr 6)) tint)
                                                               Enil))) tvoid))
                                                  (Ssequence
                                                    (Sdo (Ecall
                                                           (Evalof
                                                             (Evar _float_mat_mul 
                                                             (Tfunction
                                                               ((tptr (tptr tfloat)) ::
                                                                (tptr (tptr tfloat)) ::
                                                                (tptr (tptr tfloat)) ::
                                                                tint ::
                                                                tint ::
                                                                tint :: nil)
                                                               tvoid
                                                               cc_default))
                                                             (Tfunction
                                                               ((tptr (tptr tfloat)) ::
                                                                (tptr (tptr tfloat)) ::
                                                                (tptr (tptr tfloat)) ::
                                                                tint ::
                                                                tint ::
                                                                tint :: nil)
                                                               tvoid
                                                               cc_default))
                                                           (Econs
                                                             (Evalof
                                                               (Evar __KH_tmp (tarray (tptr tfloat) 6))
                                                               (tarray (tptr tfloat) 6))
                                                             (Econs
                                                               (Evalof
                                                                 (Evar __K (tarray (tptr tfloat) 6))
                                                                 (tarray (tptr tfloat) 6))
                                                               (Econs
                                                                 (Evalof
                                                                   (Evar __H (tptr (tptr tfloat)))
                                                                   (tptr (tptr tfloat)))
                                                                 (Econs
                                                                   (Eval (Vint (Int.repr 6)) tint)
                                                                   (Econs
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    (Econs
                                                                    (Eval (Vint (Int.repr 6)) tint)
                                                                    Enil))))))
                                                           tvoid))
                                                    (Ssequence
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _i tint)
                                                               (Eval (Vint (Int.repr 0)) tint)
                                                               tint))
                                                        (Sfor
                                                          Sskip
                                                          (Ebinop Olt
                                                            (Evalof
                                                              (Evar _i tint)
                                                              tint)
                                                            (Eval (Vint (Int.repr 6)) tint)
                                                            tint)
                                                          (Sdo (Epostincr
                                                                 Incr
                                                                 (Evar _i tint)
                                                                 tint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _j tint)
                                                                   (Eval (Vint (Int.repr 0)) tint)
                                                                   tint))
                                                            (Sfor
                                                              Sskip
                                                              (Ebinop Olt
                                                                (Evalof
                                                                  (Evar _j tint)
                                                                  tint)
                                                                (Eval (Vint (Int.repr 6)) tint)
                                                                tint)
                                                              (Sdo (Epostincr
                                                                    Incr
                                                                    (Evar _j tint)
                                                                    tint))
                                                              (Sdo (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _P_tmp (tarray (tarray tfloat 6) 6))
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (Evalof
                                                                    (Evar _i tint)
                                                                    tint)
                                                                    (tptr (tarray tfloat 6)))
                                                                    (tarray tfloat 6))
                                                                    (tarray tfloat 6))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                    (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                    (Tstruct _SimpleKinematicKalman noattr))
                                                                    (Tstruct _SimpleKinematicKalman noattr))
                                                                    _P
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (Evalof
                                                                    (Evar _i tint)
                                                                    tint)
                                                                    (tptr (tarray tfloat 6)))
                                                                    (tarray tfloat 6))
                                                                    (tarray tfloat 6))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tfloat))))))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _i__1 tint)
                                                               (Eval (Vint (Int.repr 0)) tint)
                                                               tint))
                                                        (Sfor
                                                          Sskip
                                                          (Ebinop Olt
                                                            (Evalof
                                                              (Evar _i__1 tint)
                                                              tint)
                                                            (Eval (Vint (Int.repr 6)) tint)
                                                            tint)
                                                          (Sdo (Epostincr
                                                                 Incr
                                                                 (Evar _i__1 tint)
                                                                 tint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _j__1 tint)
                                                                   (Eval (Vint (Int.repr 0)) tint)
                                                                   tint))
                                                            (Sfor
                                                              Sskip
                                                              (Ebinop Olt
                                                                (Evalof
                                                                  (Evar _j__1 tint)
                                                                  tint)
                                                                (Eval (Vint (Int.repr 6)) tint)
                                                                tint)
                                                              (Sdo (Epostincr
                                                                    Incr
                                                                    (Evar _j__1 tint)
                                                                    tint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _k tint)
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    tint))
                                                                (Sfor
                                                                  Sskip
                                                                  (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 6)) tint)
                                                                    tint)
                                                                  (Sdo 
                                                                    (Epostincr
                                                                    Incr
                                                                    (Evar _k tint)
                                                                    tint))
                                                                  (Sdo 
                                                                    (Eassignop
                                                                    Osub
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _kalman (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                    (tptr (Tstruct _SimpleKinematicKalman noattr)))
                                                                    (Tstruct _SimpleKinematicKalman noattr))
                                                                    (Tstruct _SimpleKinematicKalman noattr))
                                                                    _P
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (Evalof
                                                                    (Evar _i__1 tint)
                                                                    tint)
                                                                    (tptr (tarray tfloat 6)))
                                                                    (tarray tfloat 6))
                                                                    (tarray tfloat 6))
                                                                    (Evalof
                                                                    (Evar _j__1 tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _KH_tmp (tarray (tarray tfloat 6) 6))
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (Evalof
                                                                    (Evar _i__1 tint)
                                                                    tint)
                                                                    (tptr (tarray tfloat 6)))
                                                                    (tarray tfloat 6))
                                                                    (tarray tfloat 6))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _P_tmp (tarray (tarray tfloat 6) 6))
                                                                    (tarray (tarray tfloat 6) 6))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr (tarray tfloat 6)))
                                                                    (tarray tfloat 6))
                                                                    (tarray tfloat 6))
                                                                    (Evalof
                                                                    (Evar _j__1 tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tfloat)
                                                                    tfloat tfloat)))))))))))))))))))))))))))))))))))
|}.

Definition v_five_keep_simple_kinematic_kalman_init := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _simple_kinematic_kalman_init (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_simple_kinematic_kalman_predict := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _simple_kinematic_kalman_predict (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_simple_kinematic_kalman_update := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _simple_kinematic_kalman_update (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _SimpleKinematicKalman Struct
   (Member_plain _state (tarray tfloat 6) ::
    Member_plain _P (tarray (tarray tfloat 6) 6) ::
    Member_plain _Q (tarray (tarray tfloat 6) 6) ::
    Member_plain _F (tarray (tarray tfloat 6) 6) ::
    Member_plain _Hp (tarray (tarray tfloat 6) 3) ::
    Member_plain _Hs (tarray (tarray tfloat 6) 3) ::
    Member_plain _r tfloat :: Member_plain _dt tfloat :: nil)
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
 (_fabsf,
   Gfun(External (EF_external "fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_float_vect_diff, Gfun(Internal f_float_vect_diff)) ::
 (_float_vect_add, Gfun(Internal f_float_vect_add)) ::
 (_float_mat_invert,
   Gfun(External (EF_external "float_mat_invert"
                   (mksignature (AST.Xptr :: AST.Xptr :: AST.Xint :: nil)
                     AST.Xvoid cc_default))
     ((tptr (tptr tfloat)) :: (tptr (tptr tfloat)) :: tint :: nil) tvoid
     cc_default)) ::
 (_float_mat_transpose, Gfun(Internal f_float_mat_transpose)) ::
 (_float_mat_mul, Gfun(Internal f_float_mat_mul)) ::
 (_float_mat_vect_mul, Gfun(Internal f_float_mat_vect_mul)) ::
 (_simple_kinematic_kalman_init, Gfun(Internal f_simple_kinematic_kalman_init)) ::
 (_simple_kinematic_kalman_predict, Gfun(Internal f_simple_kinematic_kalman_predict)) ::
 (_simple_kinematic_kalman_update, Gfun(Internal f_simple_kinematic_kalman_update)) ::
 (_five_keep_simple_kinematic_kalman_init, Gvar v_five_keep_simple_kinematic_kalman_init) ::
 (_five_keep_simple_kinematic_kalman_predict, Gvar v_five_keep_simple_kinematic_kalman_predict) ::
 (_five_keep_simple_kinematic_kalman_update, Gvar v_five_keep_simple_kinematic_kalman_update) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_simple_kinematic_kalman_update ::
 _five_keep_simple_kinematic_kalman_predict ::
 _five_keep_simple_kinematic_kalman_init ::
 _simple_kinematic_kalman_predict :: _simple_kinematic_kalman_init ::
 _float_mat_invert :: _fabsf :: ___builtin_debug ::
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


