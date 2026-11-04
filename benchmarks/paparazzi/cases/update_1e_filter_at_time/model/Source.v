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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/one_euro/model/preprocessed.i".
End Info.

Definition _OneEuroFilter : ident := $"OneEuroFilter".
Definition _OneEuroLPFilter : ident := $"OneEuroLPFilter".
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
Definition _alpha : ident := $"alpha".
Definition _beta : ident := $"beta".
Definition _compute_1e_filter_alpha : ident := $"compute_1e_filter_alpha".
Definition _compute_1e_filter_lp : ident := $"compute_1e_filter_lp".
Definition _cutoff : ident := $"cutoff".
Definition _dcutoff : ident := $"dcutoff".
Definition _dx : ident := $"dx".
Definition _dxfilt : ident := $"dxfilt".
Definition _edx : ident := $"edx".
Definition _fabsf : ident := $"fabsf".
Definition _filter : ident := $"filter".
Definition _first_time : ident := $"first_time".
Definition _five_keep_compute_1e_filter_alpha : ident := $"five_keep_compute_1e_filter_alpha".
Definition _five_keep_compute_1e_filter_lp : ident := $"five_keep_compute_1e_filter_lp".
Definition _five_keep_init_1e_filter : ident := $"five_keep_init_1e_filter".
Definition _five_keep_reset_1e_filter : ident := $"five_keep_reset_1e_filter".
Definition _five_keep_update_1e_filter : ident := $"five_keep_update_1e_filter".
Definition _five_keep_update_1e_filter_at_time : ident := $"five_keep_update_1e_filter_at_time".
Definition _hatx : ident := $"hatx".
Definition _hatxprev : ident := $"hatxprev".
Definition _init_1e_filter : ident := $"init_1e_filter".
Definition _last_time : ident := $"last_time".
Definition _main : ident := $"main".
Definition _mincutoff : ident := $"mincutoff".
Definition _rate : ident := $"rate".
Definition _reset_1e_filter : ident := $"reset_1e_filter".
Definition _tau : ident := $"tau".
Definition _te : ident := $"te".
Definition _timestamp : ident := $"timestamp".
Definition _update_1e_filter : ident := $"update_1e_filter".
Definition _update_1e_filter_at_time : ident := $"update_1e_filter_at_time".
Definition _x : ident := $"x".
Definition _xfilt : ident := $"xfilt".

Definition f_init_1e_filter := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _OneEuroFilter noattr))) ::
                (_rate, tfloat) :: (_mincutoff, tfloat) :: (_beta, tfloat) ::
                (_dcutoff, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                 (tptr (Tstruct _OneEuroFilter noattr)))
               (Tstruct _OneEuroFilter noattr))
             (Tstruct _OneEuroFilter noattr)) _first_time tbool)
         (Eval (Vint (Int.repr 1)) tint) tbool))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                   (tptr (Tstruct _OneEuroFilter noattr)))
                 (Tstruct _OneEuroFilter noattr))
               (Tstruct _OneEuroFilter noattr)) _rate tfloat)
           (Evalof (Evar _rate tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                     (tptr (Tstruct _OneEuroFilter noattr)))
                   (Tstruct _OneEuroFilter noattr))
                 (Tstruct _OneEuroFilter noattr)) _mincutoff tfloat)
             (Evalof (Evar _mincutoff tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                       (tptr (Tstruct _OneEuroFilter noattr)))
                     (Tstruct _OneEuroFilter noattr))
                   (Tstruct _OneEuroFilter noattr)) _beta tfloat)
               (Evalof (Evar _beta tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Tstruct _OneEuroFilter noattr))
                     (Tstruct _OneEuroFilter noattr)) _dcutoff tfloat)
                 (Evalof (Evar _dcutoff tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                               (tptr (Tstruct _OneEuroFilter noattr)))
                             (Tstruct _OneEuroFilter noattr))
                           (Tstruct _OneEuroFilter noattr)) _xfilt
                         (Tstruct _OneEuroLPFilter noattr))
                       (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                   tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                 (tptr (Tstruct _OneEuroFilter noattr)))
                               (Tstruct _OneEuroFilter noattr))
                             (Tstruct _OneEuroFilter noattr)) _xfilt
                           (Tstruct _OneEuroLPFilter noattr))
                         (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
                     (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                     tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                   (tptr (Tstruct _OneEuroFilter noattr)))
                                 (Tstruct _OneEuroFilter noattr))
                               (Tstruct _OneEuroFilter noattr)) _xfilt
                             (Tstruct _OneEuroLPFilter noattr))
                           (Tstruct _OneEuroLPFilter noattr)) _first_time
                         tbool) (Eval (Vint (Int.repr 1)) tint) tbool))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                     (tptr (Tstruct _OneEuroFilter noattr)))
                                   (Tstruct _OneEuroFilter noattr))
                                 (Tstruct _OneEuroFilter noattr)) _dxfilt
                               (Tstruct _OneEuroLPFilter noattr))
                             (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat)
                         (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                       (tptr (Tstruct _OneEuroFilter noattr)))
                                     (Tstruct _OneEuroFilter noattr))
                                   (Tstruct _OneEuroFilter noattr)) _dxfilt
                                 (Tstruct _OneEuroLPFilter noattr))
                               (Tstruct _OneEuroLPFilter noattr)) _hatxprev
                             tfloat)
                           (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                         (tptr (Tstruct _OneEuroFilter noattr)))
                                       (Tstruct _OneEuroFilter noattr))
                                     (Tstruct _OneEuroFilter noattr)) _dxfilt
                                   (Tstruct _OneEuroLPFilter noattr))
                                 (Tstruct _OneEuroLPFilter noattr))
                               _first_time tbool)
                             (Eval (Vint (Int.repr 1)) tint) tbool))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                     (tptr (Tstruct _OneEuroFilter noattr)))
                                   (Tstruct _OneEuroFilter noattr))
                                 (Tstruct _OneEuroFilter noattr)) _last_time
                               tuint) (Eval (Vint (Int.repr 0)) tint) tuint)))))))))))))
|}.

Definition f_reset_1e_filter := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _OneEuroFilter noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                 (tptr (Tstruct _OneEuroFilter noattr)))
               (Tstruct _OneEuroFilter noattr))
             (Tstruct _OneEuroFilter noattr)) _first_time tbool)
         (Eval (Vint (Int.repr 1)) tint) tbool))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                       (tptr (Tstruct _OneEuroFilter noattr)))
                     (Tstruct _OneEuroFilter noattr))
                   (Tstruct _OneEuroFilter noattr)) _xfilt
                 (Tstruct _OneEuroLPFilter noattr))
               (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat)
           (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Tstruct _OneEuroFilter noattr))
                     (Tstruct _OneEuroFilter noattr)) _xfilt
                   (Tstruct _OneEuroLPFilter noattr))
                 (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                           (tptr (Tstruct _OneEuroFilter noattr)))
                         (Tstruct _OneEuroFilter noattr))
                       (Tstruct _OneEuroFilter noattr)) _xfilt
                     (Tstruct _OneEuroLPFilter noattr))
                   (Tstruct _OneEuroLPFilter noattr)) _first_time tbool)
               (Eval (Vint (Int.repr 1)) tint) tbool))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                             (tptr (Tstruct _OneEuroFilter noattr)))
                           (Tstruct _OneEuroFilter noattr))
                         (Tstruct _OneEuroFilter noattr)) _dxfilt
                       (Tstruct _OneEuroLPFilter noattr))
                     (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat)
                 (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                 tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                               (tptr (Tstruct _OneEuroFilter noattr)))
                             (Tstruct _OneEuroFilter noattr))
                           (Tstruct _OneEuroFilter noattr)) _dxfilt
                         (Tstruct _OneEuroLPFilter noattr))
                       (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat)
                   tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                 (tptr (Tstruct _OneEuroFilter noattr)))
                               (Tstruct _OneEuroFilter noattr))
                             (Tstruct _OneEuroFilter noattr)) _dxfilt
                           (Tstruct _OneEuroLPFilter noattr))
                         (Tstruct _OneEuroLPFilter noattr)) _first_time
                       tbool) (Eval (Vint (Int.repr 1)) tint) tbool))
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                             (tptr (Tstruct _OneEuroFilter noattr)))
                           (Tstruct _OneEuroFilter noattr))
                         (Tstruct _OneEuroFilter noattr)) _last_time tuint)
                     (Eval (Vint (Int.repr 0)) tint) tuint)))))))))
|}.

Definition f_compute_1e_filter_lp := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _OneEuroLPFilter noattr))) ::
                (_x, tfloat) :: (_alpha, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                         (tptr (Tstruct _OneEuroLPFilter noattr)))
                       (Tstruct _OneEuroLPFilter noattr))
                     (Tstruct _OneEuroLPFilter noattr)) _first_time tbool)
                 tbool)
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                     (tptr (Tstruct _OneEuroLPFilter noattr)))
                   (Tstruct _OneEuroLPFilter noattr))
                 (Tstruct _OneEuroLPFilter noattr)) _first_time tbool)
             (Eval (Vint (Int.repr 0)) tint) tbool))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                     (tptr (Tstruct _OneEuroLPFilter noattr)))
                   (Tstruct _OneEuroLPFilter noattr))
                 (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
             (Evalof (Evar _x tfloat) tfloat) tfloat)))
    Sskip)
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                   (tptr (Tstruct _OneEuroLPFilter noattr)))
                 (Tstruct _OneEuroLPFilter noattr))
               (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat)
           (Ebinop Oadd
             (Ebinop Omul (Evalof (Evar _alpha tfloat) tfloat)
               (Evalof (Evar _x tfloat) tfloat) tfloat)
             (Ebinop Omul
               (Ebinop Osub
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                 (Evalof (Evar _alpha tfloat) tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                         (tptr (Tstruct _OneEuroLPFilter noattr)))
                       (Tstruct _OneEuroLPFilter noattr))
                     (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
                 tfloat) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                     (tptr (Tstruct _OneEuroLPFilter noattr)))
                   (Tstruct _OneEuroLPFilter noattr))
                 (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                       (tptr (Tstruct _OneEuroLPFilter noattr)))
                     (Tstruct _OneEuroLPFilter noattr))
                   (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat) tfloat)
             tfloat))
      (Sreturn (Some (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _OneEuroLPFilter noattr)))
                               (tptr (Tstruct _OneEuroLPFilter noattr)))
                             (Tstruct _OneEuroLPFilter noattr))
                           (Tstruct _OneEuroLPFilter noattr)) _hatx tfloat)
                       tfloat))))))
|}.

Definition f_compute_1e_filter_alpha := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _OneEuroFilter noattr))) ::
                (_cutoff, tfloat) :: nil);
  fn_vars := ((_tau, tfloat) :: (_te, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tau tfloat)
         (Ebinop Odiv
           (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
           (Ebinop Omul
             (Ebinop Omul
               (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
               tdouble) (Evalof (Evar _cutoff tfloat) tfloat) tdouble)
           tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _te tfloat)
           (Ebinop Odiv
             (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                       (tptr (Tstruct _OneEuroFilter noattr)))
                     (Tstruct _OneEuroFilter noattr))
                   (Tstruct _OneEuroFilter noattr)) _rate tfloat) tfloat)
             tfloat) tfloat))
    (Sreturn (Some (Ebinop Odiv
                     (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                     (Ebinop Oadd
                       (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                       (Ebinop Odiv (Evalof (Evar _tau tfloat) tfloat)
                         (Evalof (Evar _te tfloat) tfloat) tfloat) tfloat)
                     tfloat)))))
|}.

Definition f_update_1e_filter := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _OneEuroFilter noattr))) ::
                (_x, tfloat) :: nil);
  fn_vars := ((_dx, tfloat) :: (_edx, tfloat) :: (_cutoff, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Tstruct _OneEuroFilter noattr))
                     (Tstruct _OneEuroFilter noattr)) _first_time tbool)
                 tbool)
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                     (tptr (Tstruct _OneEuroFilter noattr)))
                   (Tstruct _OneEuroFilter noattr))
                 (Tstruct _OneEuroFilter noattr)) _first_time tbool)
             (Eval (Vint (Int.repr 0)) tint) tbool))
      (Sdo (Eassign (Evar _dx tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 0))) tfloat) tfloat)))
    (Sdo (Eassign (Evar _dx tfloat)
           (Ebinop Omul
             (Ebinop Osub (Evalof (Evar _x tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                             (tptr (Tstruct _OneEuroFilter noattr)))
                           (Tstruct _OneEuroFilter noattr))
                         (Tstruct _OneEuroFilter noattr)) _xfilt
                       (Tstruct _OneEuroLPFilter noattr))
                     (Tstruct _OneEuroLPFilter noattr)) _hatxprev tfloat)
                 tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                       (tptr (Tstruct _OneEuroFilter noattr)))
                     (Tstruct _OneEuroFilter noattr))
                   (Tstruct _OneEuroFilter noattr)) _rate tfloat) tfloat)
             tfloat) tfloat)))
  (Ssequence
    (Sdo (Eassign (Evar _edx tfloat)
           (Ecall
             (Evalof
               (Evar _compute_1e_filter_lp (Tfunction
                                             ((tptr (Tstruct _OneEuroLPFilter noattr)) ::
                                              tfloat :: tfloat :: nil) tfloat
                                             cc_default))
               (Tfunction
                 ((tptr (Tstruct _OneEuroLPFilter noattr)) :: tfloat ::
                  tfloat :: nil) tfloat cc_default))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Tstruct _OneEuroFilter noattr))
                     (Tstruct _OneEuroFilter noattr)) _dxfilt
                   (Tstruct _OneEuroLPFilter noattr))
                 (tptr (Tstruct _OneEuroLPFilter noattr)))
               (Econs (Evalof (Evar _dx tfloat) tfloat)
                 (Econs
                   (Ecall
                     (Evalof
                       (Evar _compute_1e_filter_alpha (Tfunction
                                                        ((tptr (Tstruct _OneEuroFilter noattr)) ::
                                                         tfloat :: nil)
                                                        tfloat cc_default))
                       (Tfunction
                         ((tptr (Tstruct _OneEuroFilter noattr)) :: tfloat ::
                          nil) tfloat cc_default))
                     (Econs
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Econs
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                   (tptr (Tstruct _OneEuroFilter noattr)))
                                 (Tstruct _OneEuroFilter noattr))
                               (Tstruct _OneEuroFilter noattr)) _dcutoff
                             tfloat) tfloat) Enil)) tfloat) Enil))) tfloat)
           tfloat))
    (Ssequence
      (Sdo (Eassign (Evar _cutoff tfloat)
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Tstruct _OneEuroFilter noattr))
                     (Tstruct _OneEuroFilter noattr)) _mincutoff tfloat)
                 tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                           (tptr (Tstruct _OneEuroFilter noattr)))
                         (Tstruct _OneEuroFilter noattr))
                       (Tstruct _OneEuroFilter noattr)) _beta tfloat) tfloat)
                 (Ecall
                   (Evalof
                     (Evar _fabsf (Tfunction (tfloat :: nil) tfloat
                                    cc_default))
                     (Tfunction (tfloat :: nil) tfloat cc_default))
                   (Econs (Evalof (Evar _edx tfloat) tfloat) Enil) tfloat)
                 tfloat) tfloat) tfloat))
      (Sreturn (Some (Ecall
                       (Evalof
                         (Evar _compute_1e_filter_lp (Tfunction
                                                       ((tptr (Tstruct _OneEuroLPFilter noattr)) ::
                                                        tfloat :: tfloat ::
                                                        nil) tfloat
                                                       cc_default))
                         (Tfunction
                           ((tptr (Tstruct _OneEuroLPFilter noattr)) ::
                            tfloat :: tfloat :: nil) tfloat cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                   (tptr (Tstruct _OneEuroFilter noattr)))
                                 (Tstruct _OneEuroFilter noattr))
                               (Tstruct _OneEuroFilter noattr)) _xfilt
                             (Tstruct _OneEuroLPFilter noattr))
                           (tptr (Tstruct _OneEuroLPFilter noattr)))
                         (Econs (Evalof (Evar _x tfloat) tfloat)
                           (Econs
                             (Ecall
                               (Evalof
                                 (Evar _compute_1e_filter_alpha (Tfunction
                                                                  ((tptr (Tstruct _OneEuroFilter noattr)) ::
                                                                   tfloat ::
                                                                   nil)
                                                                  tfloat
                                                                  cc_default))
                                 (Tfunction
                                   ((tptr (Tstruct _OneEuroFilter noattr)) ::
                                    tfloat :: nil) tfloat cc_default))
                               (Econs
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                                   (tptr (Tstruct _OneEuroFilter noattr)))
                                 (Econs (Evalof (Evar _cutoff tfloat) tfloat)
                                   Enil)) tfloat) Enil))) tfloat))))))
|}.

Definition f_update_1e_filter_at_time := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _OneEuroFilter noattr))) ::
                (_x, tfloat) :: (_timestamp, tuint) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eseqand
                 (Ebinop One
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                             (tptr (Tstruct _OneEuroFilter noattr)))
                           (Tstruct _OneEuroFilter noattr))
                         (Tstruct _OneEuroFilter noattr)) _last_time tuint)
                     tuint) (Eval (Vint (Int.repr 0)) tint) tint)
                 (Ebinop One (Evalof (Evar _timestamp tuint) tuint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                             (tptr (Tstruct _OneEuroFilter noattr)))
                           (Tstruct _OneEuroFilter noattr))
                         (Tstruct _OneEuroFilter noattr)) _last_time tuint)
                     tuint) tint) tint)
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                   (tptr (Tstruct _OneEuroFilter noattr)))
                 (Tstruct _OneEuroFilter noattr))
               (Tstruct _OneEuroFilter noattr)) _rate tfloat)
           (Ebinop Odiv
             (Eval (Vsingle (Float32.of_bits (Int.repr 1232348160))) tfloat)
             (Ecast
               (Ebinop Osub (Evalof (Evar _timestamp tuint) tuint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                           (tptr (Tstruct _OneEuroFilter noattr)))
                         (Tstruct _OneEuroFilter noattr))
                       (Tstruct _OneEuroFilter noattr)) _last_time tuint)
                   tuint) tuint) tfloat) tfloat) tfloat))
    Sskip)
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                   (tptr (Tstruct _OneEuroFilter noattr)))
                 (Tstruct _OneEuroFilter noattr))
               (Tstruct _OneEuroFilter noattr)) _last_time tuint)
           (Evalof (Evar _timestamp tuint) tuint) tuint))
    (Sreturn (Some (Ecall
                     (Evalof
                       (Evar _update_1e_filter (Tfunction
                                                 ((tptr (Tstruct _OneEuroFilter noattr)) ::
                                                  tfloat :: nil) tfloat
                                                 cc_default))
                       (Tfunction
                         ((tptr (Tstruct _OneEuroFilter noattr)) :: tfloat ::
                          nil) tfloat cc_default))
                     (Econs
                       (Evalof
                         (Evar _filter (tptr (Tstruct _OneEuroFilter noattr)))
                         (tptr (Tstruct _OneEuroFilter noattr)))
                       (Econs (Evalof (Evar _x tfloat) tfloat) Enil)) tfloat)))))
|}.

Definition v_five_keep_init_1e_filter := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _init_1e_filter (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_reset_1e_filter := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _reset_1e_filter (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_compute_1e_filter_lp := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _compute_1e_filter_lp (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_compute_1e_filter_alpha := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _compute_1e_filter_alpha (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_update_1e_filter := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _update_1e_filter (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_update_1e_filter_at_time := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _update_1e_filter_at_time (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _OneEuroLPFilter Struct
   (Member_plain _hatx tfloat :: Member_plain _hatxprev tfloat ::
    Member_plain _first_time tbool :: nil)
   noattr ::
 Composite _OneEuroFilter Struct
   (Member_plain _first_time tbool :: Member_plain _rate tfloat ::
    Member_plain _mincutoff tfloat :: Member_plain _beta tfloat ::
    Member_plain _dcutoff tfloat ::
    Member_plain _xfilt (Tstruct _OneEuroLPFilter noattr) ::
    Member_plain _dxfilt (Tstruct _OneEuroLPFilter noattr) ::
    Member_plain _last_time tuint :: nil)
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
 (_init_1e_filter, Gfun(Internal f_init_1e_filter)) ::
 (_reset_1e_filter, Gfun(Internal f_reset_1e_filter)) ::
 (_compute_1e_filter_lp, Gfun(Internal f_compute_1e_filter_lp)) ::
 (_compute_1e_filter_alpha, Gfun(Internal f_compute_1e_filter_alpha)) ::
 (_update_1e_filter, Gfun(Internal f_update_1e_filter)) ::
 (_update_1e_filter_at_time, Gfun(Internal f_update_1e_filter_at_time)) ::
 (_five_keep_init_1e_filter, Gvar v_five_keep_init_1e_filter) ::
 (_five_keep_reset_1e_filter, Gvar v_five_keep_reset_1e_filter) ::
 (_five_keep_compute_1e_filter_lp, Gvar v_five_keep_compute_1e_filter_lp) ::
 (_five_keep_compute_1e_filter_alpha, Gvar v_five_keep_compute_1e_filter_alpha) ::
 (_five_keep_update_1e_filter, Gvar v_five_keep_update_1e_filter) ::
 (_five_keep_update_1e_filter_at_time, Gvar v_five_keep_update_1e_filter_at_time) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_update_1e_filter_at_time :: _five_keep_update_1e_filter ::
 _five_keep_compute_1e_filter_alpha :: _five_keep_compute_1e_filter_lp ::
 _five_keep_reset_1e_filter :: _five_keep_init_1e_filter :: _fabsf ::
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


