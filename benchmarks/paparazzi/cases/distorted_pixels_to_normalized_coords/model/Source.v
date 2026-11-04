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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/navigation-vision-models/vision_undistortion/model/preprocessed.i".
End Info.

Definition _Dhane_distortion : ident := $"Dhane_distortion".
Definition _Dhane_undistortion : ident := $"Dhane_undistortion".
Definition _K : ident := $"K".
Definition _R : ident := $"R".
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
Definition _asinf : ident := $"asinf".
Definition _atanf : ident := $"atanf".
Definition _distorted_pixels_to_normalized_coords : ident := $"distorted_pixels_to_normalized_coords".
Definition _enlargement_factor : ident := $"enlargement_factor".
Definition _fabs : ident := $"fabs".
Definition _five_keep_Dhane_distortion : ident := $"five_keep_Dhane_distortion".
Definition _five_keep_Dhane_undistortion : ident := $"five_keep_Dhane_undistortion".
Definition _five_keep_distorted_pixels_to_normalized_coords : ident := $"five_keep_distorted_pixels_to_normalized_coords".
Definition _five_keep_normalized_coords_to_distorted_pixels : ident := $"five_keep_normalized_coords_to_distorted_pixels".
Definition _five_keep_normalized_to_pixels : ident := $"five_keep_normalized_to_pixels".
Definition _five_keep_pixels_to_normalized : ident := $"five_keep_pixels_to_normalized".
Definition _inner_part : ident := $"inner_part".
Definition _k : ident := $"k".
Definition _main : ident := $"main".
Definition _normalized_coords_to_distorted_pixels : ident := $"normalized_coords_to_distorted_pixels".
Definition _normalized_to_pixels : ident := $"normalized_to_pixels".
Definition _pixels_to_normalized : ident := $"pixels_to_normalized".
Definition _r : ident := $"r".
Definition _reduction_factor : ident := $"reduction_factor".
Definition _sinf : ident := $"sinf".
Definition _sqrtf : ident := $"sqrtf".
Definition _success : ident := $"success".
Definition _tanf : ident := $"tanf".
Definition _x_n : ident := $"x_n".
Definition _x_n_ : ident := $"x_n_".
Definition _x_nd : ident := $"x_nd".
Definition _x_p : ident := $"x_p".
Definition _x_pd : ident := $"x_pd".
Definition _y_n : ident := $"y_n".
Definition _y_n_ : ident := $"y_n_".
Definition _y_nd : ident := $"y_nd".
Definition _y_p : ident := $"y_p".
Definition _y_pd : ident := $"y_pd".

Definition f_Dhane_distortion := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_x_n, tfloat) :: (_y_n, tfloat) :: (_x_nd, (tptr tfloat)) ::
                (_y_nd, (tptr tfloat)) :: (_k, tfloat) :: nil);
  fn_vars := ((_R, tfloat) :: (_r, tfloat) :: (_reduction_factor, tfloat) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _R tfloat)
         (Ecall
           (Evalof
             (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Oadd
               (Ebinop Omul (Evalof (Evar _x_n tfloat) tfloat)
                 (Evalof (Evar _x_n tfloat) tfloat) tfloat)
               (Ebinop Omul (Evalof (Evar _y_n tfloat) tfloat)
                 (Evalof (Evar _y_n tfloat) tfloat) tfloat) tfloat) Enil)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _r tfloat)
           (Ecall
             (Evalof
               (Evar _tanf (Tfunction (tfloat :: nil) tfloat cc_default))
               (Tfunction (tfloat :: nil) tfloat cc_default))
             (Econs
               (Ecall
                 (Evalof
                   (Evar _asinf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ebinop Omul
                     (Ebinop Odiv
                       (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                       (Evalof (Evar _k tfloat) tfloat) tfloat)
                     (Ecall
                       (Evalof
                         (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                         (Tfunction (tfloat :: nil) tfloat cc_default))
                       (Econs
                         (Ecall
                           (Evalof
                             (Evar _atanf (Tfunction (tfloat :: nil) tfloat
                                            cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _R tfloat) tfloat) Enil)
                           tfloat) Enil) tfloat) tfloat) Enil) tfloat) Enil)
             tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _reduction_factor tfloat)
             (Ebinop Odiv (Evalof (Evar _r tfloat) tfloat)
               (Evalof (Evar _R tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef (Evalof (Evar _x_nd (tptr tfloat)) (tptr tfloat))
                 tfloat)
               (Ebinop Omul (Evalof (Evar _reduction_factor tfloat) tfloat)
                 (Evalof (Evar _x_n tfloat) tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef (Evalof (Evar _y_nd (tptr tfloat)) (tptr tfloat))
                   tfloat)
                 (Ebinop Omul (Evalof (Evar _reduction_factor tfloat) tfloat)
                   (Evalof (Evar _y_n tfloat) tfloat) tfloat) tfloat))
          (Sreturn (Some (Eval (Vint (Int.repr 1)) tint))))))))
|}.

Definition f_Dhane_undistortion := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_x_nd, tfloat) :: (_y_nd, tfloat) ::
                (_x_n, (tptr tfloat)) :: (_y_n, (tptr tfloat)) ::
                (_k, tfloat) :: nil);
  fn_vars := ((_r, tfloat) :: (_inner_part, tfloat) :: (_R, tfloat) ::
              (_enlargement_factor, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _r tfloat)
         (Ecall
           (Evalof
             (Evar _sqrtf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Oadd
               (Ebinop Omul (Evalof (Evar _x_nd tfloat) tfloat)
                 (Evalof (Evar _x_nd tfloat) tfloat) tfloat)
               (Ebinop Omul (Evalof (Evar _y_nd tfloat) tfloat)
                 (Evalof (Evar _y_nd tfloat) tfloat) tfloat) tfloat) Enil)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _inner_part tfloat)
           (Ebinop Omul
             (Ecall
               (Evalof
                 (Evar _sinf (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Tfunction (tfloat :: nil) tfloat cc_default))
               (Econs
                 (Ecall
                   (Evalof
                     (Evar _atanf (Tfunction (tfloat :: nil) tfloat
                                    cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs (Evalof (Evar _r tfloat) tfloat) Enil) tfloat)
                 Enil) tfloat) (Evalof (Evar _k tfloat) tfloat) tfloat)
           tfloat))
    (Ssequence
      (Sifthenelse (Ebinop Ogt
                     (Ecall
                       (Evalof
                         (Evar _fabs (Tfunction (tdouble :: nil) tdouble
                                       cc_default))
                         (Tfunction (tdouble :: nil) tdouble cc_default))
                       (Econs (Evalof (Evar _inner_part tfloat) tfloat) Enil)
                       tdouble)
                     (Eval (Vfloat (Float.of_bits (Int64.repr 4607181518080091934))) tdouble)
                     tint)
        (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))
        Sskip)
      (Ssequence
        (Sdo (Eassign (Evar _R tfloat)
               (Ecall
                 (Evalof
                   (Evar _tanf (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ecall
                     (Evalof
                       (Evar _asinf (Tfunction (tfloat :: nil) tfloat
                                      cc_default))
                       (Tfunction (tfloat :: nil) tfloat cc_default))
                     (Econs (Evalof (Evar _inner_part tfloat) tfloat) Enil)
                     tfloat) Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _enlargement_factor tfloat)
                 (Ebinop Odiv (Evalof (Evar _R tfloat) tfloat)
                   (Evalof (Evar _r tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef (Evalof (Evar _x_n (tptr tfloat)) (tptr tfloat))
                     tfloat)
                   (Ebinop Omul
                     (Evalof (Evar _enlargement_factor tfloat) tfloat)
                     (Evalof (Evar _x_nd tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef (Evalof (Evar _y_n (tptr tfloat)) (tptr tfloat))
                       tfloat)
                     (Ebinop Omul
                       (Evalof (Evar _enlargement_factor tfloat) tfloat)
                       (Evalof (Evar _y_nd tfloat) tfloat) tfloat) tfloat))
              (Sreturn (Some (Eval (Vint (Int.repr 1)) tint))))))))))
|}.

Definition f_normalized_to_pixels := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_x_n_, tfloat) :: (_y_n_, tfloat) ::
                (_x_p, (tptr tfloat)) :: (_y_p, (tptr tfloat)) ::
                (_K, (tptr tfloat)) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef (Evalof (Evar _x_p (tptr tfloat)) (tptr tfloat)) tfloat)
         (Ebinop Oadd
           (Ebinop Omul (Evalof (Evar _x_n_ tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                 (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
             tfloat) tfloat) tfloat))
  (Sdo (Eassign
         (Ederef (Evalof (Evar _y_p (tptr tfloat)) (tptr tfloat)) tfloat)
         (Ebinop Oadd
           (Ebinop Omul (Evalof (Evar _y_n_ tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 4)) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                 (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
             tfloat) tfloat) tfloat)))
|}.

Definition f_pixels_to_normalized := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_x_p, tfloat) :: (_y_p, tfloat) :: (_x_n_, (tptr tfloat)) ::
                (_y_n_, (tptr tfloat)) :: (_K, (tptr tfloat)) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef (Evalof (Evar _x_n_ (tptr tfloat)) (tptr tfloat)) tfloat)
         (Ebinop Odiv
           (Ebinop Osub (Evalof (Evar _x_p tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                 (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
             tfloat) tfloat) tfloat))
  (Sdo (Eassign
         (Ederef (Evalof (Evar _y_n_ (tptr tfloat)) (tptr tfloat)) tfloat)
         (Ebinop Odiv
           (Ebinop Osub (Evalof (Evar _y_p tfloat) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                   (Eval (Vint (Int.repr 5)) tint) (tptr tfloat)) tfloat)
               tfloat) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                 (Eval (Vint (Int.repr 4)) tint) (tptr tfloat)) tfloat)
             tfloat) tfloat) tfloat)))
|}.

Definition f_distorted_pixels_to_normalized_coords := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_x_pd, tfloat) :: (_y_pd, tfloat) ::
                (_x_n, (tptr tfloat)) :: (_y_n, (tptr tfloat)) ::
                (_k, tfloat) :: (_K, (tptr tfloat)) :: nil);
  fn_vars := ((_x_nd, tfloat) :: (_y_nd, tfloat) :: (_success, tbool) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _pixels_to_normalized (Tfunction
                                         (tfloat :: tfloat ::
                                          (tptr tfloat) :: (tptr tfloat) ::
                                          (tptr tfloat) :: nil) tvoid
                                         cc_default))
           (Tfunction
             (tfloat :: tfloat :: (tptr tfloat) :: (tptr tfloat) ::
              (tptr tfloat) :: nil) tvoid cc_default))
         (Econs (Evalof (Evar _x_pd tfloat) tfloat)
           (Econs (Evalof (Evar _y_pd tfloat) tfloat)
             (Econs (Eaddrof (Evar _x_nd tfloat) (tptr tfloat))
               (Econs (Eaddrof (Evar _y_nd tfloat) (tptr tfloat))
                 (Econs (Evalof (Evar _K (tptr tfloat)) (tptr tfloat)) Enil)))))
         tvoid))
  (Ssequence
    (Sdo (Eassign (Evar _success tbool)
           (Ecall
             (Evalof
               (Evar _Dhane_undistortion (Tfunction
                                           (tfloat :: tfloat ::
                                            (tptr tfloat) :: (tptr tfloat) ::
                                            tfloat :: nil) tbool cc_default))
               (Tfunction
                 (tfloat :: tfloat :: (tptr tfloat) :: (tptr tfloat) ::
                  tfloat :: nil) tbool cc_default))
             (Econs (Evalof (Evar _x_nd tfloat) tfloat)
               (Econs (Evalof (Evar _y_nd tfloat) tfloat)
                 (Econs (Evalof (Evar _x_n (tptr tfloat)) (tptr tfloat))
                   (Econs (Evalof (Evar _y_n (tptr tfloat)) (tptr tfloat))
                     (Econs (Evalof (Evar _k tfloat) tfloat) Enil))))) tbool)
           tbool))
    (Sreturn (Some (Evalof (Evar _success tbool) tbool)))))
|}.

Definition f_normalized_coords_to_distorted_pixels := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_x_n, tfloat) :: (_y_n, tfloat) :: (_x_pd, (tptr tfloat)) ::
                (_y_pd, (tptr tfloat)) :: (_k, tfloat) ::
                (_K, (tptr tfloat)) :: nil);
  fn_vars := ((_x_nd, tfloat) :: (_y_nd, tfloat) :: (_success, tbool) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _success tbool)
         (Ecall
           (Evalof
             (Evar _Dhane_distortion (Tfunction
                                       (tfloat :: tfloat :: (tptr tfloat) ::
                                        (tptr tfloat) :: tfloat :: nil) tbool
                                       cc_default))
             (Tfunction
               (tfloat :: tfloat :: (tptr tfloat) :: (tptr tfloat) ::
                tfloat :: nil) tbool cc_default))
           (Econs (Evalof (Evar _x_n tfloat) tfloat)
             (Econs (Evalof (Evar _y_n tfloat) tfloat)
               (Econs (Eaddrof (Evar _x_nd tfloat) (tptr tfloat))
                 (Econs (Eaddrof (Evar _y_nd tfloat) (tptr tfloat))
                   (Econs (Evalof (Evar _k tfloat) tfloat) Enil))))) tbool)
         tbool))
  (Ssequence
    (Sifthenelse (Eunop Onotbool (Evalof (Evar _success tbool) tbool) tint)
      (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))
      (Sdo (Ecall
             (Evalof
               (Evar _normalized_to_pixels (Tfunction
                                             (tfloat :: tfloat ::
                                              (tptr tfloat) ::
                                              (tptr tfloat) ::
                                              (tptr tfloat) :: nil) tvoid
                                             cc_default))
               (Tfunction
                 (tfloat :: tfloat :: (tptr tfloat) :: (tptr tfloat) ::
                  (tptr tfloat) :: nil) tvoid cc_default))
             (Econs (Evalof (Evar _x_nd tfloat) tfloat)
               (Econs (Evalof (Evar _y_nd tfloat) tfloat)
                 (Econs (Evalof (Evar _x_pd (tptr tfloat)) (tptr tfloat))
                   (Econs (Evalof (Evar _y_pd (tptr tfloat)) (tptr tfloat))
                     (Econs (Evalof (Evar _K (tptr tfloat)) (tptr tfloat))
                       Enil))))) tvoid)))
    (Sreturn (Some (Evalof (Evar _success tbool) tbool)))))
|}.

Definition v_five_keep_Dhane_distortion := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _Dhane_distortion (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_Dhane_undistortion := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _Dhane_undistortion (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_normalized_to_pixels := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _normalized_to_pixels (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_pixels_to_normalized := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _pixels_to_normalized (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_distorted_pixels_to_normalized_coords := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _distorted_pixels_to_normalized_coords (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_normalized_coords_to_distorted_pixels := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _normalized_coords_to_distorted_pixels (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
nil.

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
 (_asinf,
   Gfun(External (EF_external "asinf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_atanf,
   Gfun(External (EF_external "atanf"
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
 (_sqrtf,
   Gfun(External (EF_external "sqrtf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_Dhane_distortion, Gfun(Internal f_Dhane_distortion)) ::
 (_Dhane_undistortion, Gfun(Internal f_Dhane_undistortion)) ::
 (_normalized_to_pixels, Gfun(Internal f_normalized_to_pixels)) ::
 (_pixels_to_normalized, Gfun(Internal f_pixels_to_normalized)) ::
 (_distorted_pixels_to_normalized_coords, Gfun(Internal f_distorted_pixels_to_normalized_coords)) ::
 (_normalized_coords_to_distorted_pixels, Gfun(Internal f_normalized_coords_to_distorted_pixels)) ::
 (_five_keep_Dhane_distortion, Gvar v_five_keep_Dhane_distortion) ::
 (_five_keep_Dhane_undistortion, Gvar v_five_keep_Dhane_undistortion) ::
 (_five_keep_normalized_to_pixels, Gvar v_five_keep_normalized_to_pixels) ::
 (_five_keep_pixels_to_normalized, Gvar v_five_keep_pixels_to_normalized) ::
 (_five_keep_distorted_pixels_to_normalized_coords, Gvar v_five_keep_distorted_pixels_to_normalized_coords) ::
 (_five_keep_normalized_coords_to_distorted_pixels, Gvar v_five_keep_normalized_coords_to_distorted_pixels) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_normalized_coords_to_distorted_pixels ::
 _five_keep_distorted_pixels_to_normalized_coords ::
 _five_keep_pixels_to_normalized :: _five_keep_normalized_to_pixels ::
 _five_keep_Dhane_undistortion :: _five_keep_Dhane_distortion ::
 _normalized_coords_to_distorted_pixels ::
 _distorted_pixels_to_normalized_coords :: _pixels_to_normalized ::
 _normalized_to_pixels :: _Dhane_undistortion :: _Dhane_distortion ::
 _sqrtf :: _tanf :: _sinf :: _atanf :: _asinf :: _fabs :: ___builtin_debug ::
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


