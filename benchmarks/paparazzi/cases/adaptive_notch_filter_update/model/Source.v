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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/adaptive_notch/model/preprocessed.i".
End Info.

Definition _AdaptiveNotchFilter : ident := $"AdaptiveNotchFilter".
Definition _K : ident := $"K".
Definition _Q : ident := $"Q".
Definition _SecondOrderLowPass : ident := $"SecondOrderLowPass".
Definition _SecondOrderNotchFilter : ident := $"SecondOrderNotchFilter".
Definition _Ts : ident := $"Ts".
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
Definition _a_est : ident := $"a_est".
Definition _a_ini : ident := $"a_ini".
Definition _adaptive_notch_filter_get_output : ident := $"adaptive_notch_filter_get_output".
Definition _adaptive_notch_filter_init : ident := $"adaptive_notch_filter_init".
Definition _adaptive_notch_filter_update : ident := $"adaptive_notch_filter_update".
Definition _b : ident := $"b".
Definition _bandwidth : ident := $"bandwidth".
Definition _beta : ident := $"beta".
Definition _cosf : ident := $"cosf".
Definition _costheta : ident := $"costheta".
Definition _cutoff_frequency : ident := $"cutoff_frequency".
Definition _d : ident := $"d".
Definition _d2 : ident := $"d2".
Definition _expf : ident := $"expf".
Definition _filter : ident := $"filter".
Definition _five_keep_adaptive_notch_filter_get_output : ident := $"five_keep_adaptive_notch_filter_get_output".
Definition _five_keep_adaptive_notch_filter_init : ident := $"five_keep_adaptive_notch_filter_init".
Definition _five_keep_adaptive_notch_filter_update : ident := $"five_keep_adaptive_notch_filter_update".
Definition _frequency : ident := $"frequency".
Definition _fs : ident := $"fs".
Definition _high_freq_bound : ident := $"high_freq_bound".
Definition _hp_cutoff_f : ident := $"hp_cutoff_f".
Definition _hp_filter : ident := $"hp_filter".
Definition _hp_tau : ident := $"hp_tau".
Definition _i : ident := $"i".
Definition _init_butterworth_2_low_pass : ident := $"init_butterworth_2_low_pass".
Definition _init_second_order_low_pass : ident := $"init_second_order_low_pass".
Definition _input_signal : ident := $"input_signal".
Definition _lambda : ident := $"lambda".
Definition _low_freq_bound : ident := $"low_freq_bound".
Definition _lp_cutoff_f : ident := $"lp_cutoff_f".
Definition _lp_filter : ident := $"lp_filter".
Definition _lp_tau : ident := $"lp_tau".
Definition _main : ident := $"main".
Definition _notch_filter_init : ident := $"notch_filter_init".
Definition _notch_filter_set_bandwidth : ident := $"notch_filter_set_bandwidth".
Definition _notch_filter_set_filter_frequency : ident := $"notch_filter_set_filter_frequency".
Definition _notch_filter_set_sampling_frequency : ident := $"notch_filter_set_sampling_frequency".
Definition _notch_filter_update : ident := $"notch_filter_update".
Definition _o : ident := $"o".
Definition _out : ident := $"out".
Definition _out_est : ident := $"out_est".
Definition _output_n_filter : ident := $"output_n_filter".
Definition _output_signal : ident := $"output_signal".
Definition _poly : ident := $"poly".
Definition _r : ident := $"r".
Definition _r2 : ident := $"r2".
Definition _sample_frequency : ident := $"sample_frequency".
Definition _sample_time : ident := $"sample_time".
Definition _tanf : ident := $"tanf".
Definition _tau : ident := $"tau".
Definition _theta : ident := $"theta".
Definition _update_butterworth_2_low_pass : ident := $"update_butterworth_2_low_pass".
Definition _update_second_order_low_pass : ident := $"update_second_order_low_pass".
Definition _value : ident := $"value".
Definition _xband : ident := $"xband".
Definition _xn1 : ident := $"xn1".
Definition _xn2 : ident := $"xn2".
Definition _y : ident := $"y".
Definition _y_est : ident := $"y_est".
Definition _yn1 : ident := $"yn1".
Definition _yn2 : ident := $"yn2".

Definition f_init_second_order_low_pass := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderLowPass noattr))) ::
                (_tau, tfloat) :: (_Q, tfloat) :: (_sample_time, tfloat) ::
                (_value, tfloat) :: nil);
  fn_vars := ((_K, tfloat) :: (_poly, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _K tfloat)
         (Ecall
           (Evalof (Evar _tanf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Odiv (Evalof (Evar _sample_time tfloat) tfloat)
               (Ebinop Omul
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                 (Evalof (Evar _tau tfloat) tfloat) tfloat) tfloat) Enil)
           tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _poly tfloat)
           (Ebinop Oadd
             (Ebinop Oadd
               (Ebinop Omul (Evalof (Evar _K tfloat) tfloat)
                 (Evalof (Evar _K tfloat) tfloat) tfloat)
               (Ebinop Odiv (Evalof (Evar _K tfloat) tfloat)
                 (Evalof (Evar _Q tfloat) tfloat) tfloat) tfloat)
             (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
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
                           (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (tptr (Tstruct _SecondOrderLowPass noattr)))
                         (Tstruct _SecondOrderLowPass noattr))
                       (Tstruct _SecondOrderLowPass noattr)) _a
                     (tarray tfloat 2)) (tarray tfloat 2))
                 (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
             (Ebinop Odiv
               (Ebinop Omul
                 (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                 (Ebinop Osub
                   (Ebinop Omul (Evalof (Evar _K tfloat) tfloat)
                     (Evalof (Evar _K tfloat) tfloat) tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                   tfloat) tfloat) (Evalof (Evar _poly tfloat) tfloat)
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
                             (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (Tstruct _SecondOrderLowPass noattr))
                         (Tstruct _SecondOrderLowPass noattr)) _a
                       (tarray tfloat 2)) (tarray tfloat 2))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
               (Ebinop Odiv
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul (Evalof (Evar _K tfloat) tfloat)
                       (Evalof (Evar _K tfloat) tfloat) tfloat)
                     (Ebinop Odiv (Evalof (Evar _K tfloat) tfloat)
                       (Evalof (Evar _Q tfloat) tfloat) tfloat) tfloat)
                   (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
                   tfloat) (Evalof (Evar _poly tfloat) tfloat) tfloat)
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
                               (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (Tstruct _SecondOrderLowPass noattr))
                           (Tstruct _SecondOrderLowPass noattr)) _b
                         (tarray tfloat 2)) (tarray tfloat 2))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                 (Ebinop Odiv
                   (Ebinop Omul (Evalof (Evar _K tfloat) tfloat)
                     (Evalof (Evar _K tfloat) tfloat) tfloat)
                   (Evalof (Evar _poly tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (Tstruct _SecondOrderLowPass noattr))
                             (Tstruct _SecondOrderLowPass noattr)) _b
                           (tarray tfloat 2)) (tarray tfloat 2))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
                   (Ebinop Omul
                     (Eval (Vsingle (Float32.of_bits (Int.repr 1073741824))) tfloat)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                     (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (Tstruct _SecondOrderLowPass noattr))
                                 (Tstruct _SecondOrderLowPass noattr)) _b
                               (tarray tfloat 2)) (tarray tfloat 2))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat) tfloat))
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (Tstruct _SecondOrderLowPass noattr))
                             (Tstruct _SecondOrderLowPass noattr)) _i
                           (tarray tfloat 2)) (tarray tfloat 2))
                       (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                   (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (Tstruct _SecondOrderLowPass noattr))
                               (Tstruct _SecondOrderLowPass noattr)) _i
                             (tarray tfloat 2)) (tarray tfloat 2))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                       tfloat)
                     (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                     (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (Tstruct _SecondOrderLowPass noattr))
                                 (Tstruct _SecondOrderLowPass noattr)) _o
                               (tarray tfloat 2)) (tarray tfloat 2))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat)
                       (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                       (tptr (Tstruct _SecondOrderLowPass noattr)))
                                     (Tstruct _SecondOrderLowPass noattr))
                                   (Tstruct _SecondOrderLowPass noattr)) _o
                                 (tarray tfloat 2)) (tarray tfloat 2))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat) (Evalof (Evar _value tfloat) tfloat)
                         tfloat) tfloat) tfloat) tfloat))))))))
|}.

Definition f_update_second_order_low_pass := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderLowPass noattr))) ::
                (_value, tfloat) :: nil);
  fn_vars := ((_out, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _out tfloat)
         (Ebinop Osub
           (Ebinop Osub
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
                                   (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (Tstruct _SecondOrderLowPass noattr))
                               (Tstruct _SecondOrderLowPass noattr)) _b
                             (tarray tfloat 2)) (tarray tfloat 2))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                       tfloat) tfloat) (Evalof (Evar _value tfloat) tfloat)
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
                                   (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (Tstruct _SecondOrderLowPass noattr))
                               (Tstruct _SecondOrderLowPass noattr)) _b
                             (tarray tfloat 2)) (tarray tfloat 2))
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
                                   (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (Tstruct _SecondOrderLowPass noattr))
                               (Tstruct _SecondOrderLowPass noattr)) _i
                             (tarray tfloat 2)) (tarray tfloat 2))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
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
                                 (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (Tstruct _SecondOrderLowPass noattr))
                             (Tstruct _SecondOrderLowPass noattr)) _b
                           (tarray tfloat 2)) (tarray tfloat 2))
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
                                 (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (Tstruct _SecondOrderLowPass noattr))
                             (Tstruct _SecondOrderLowPass noattr)) _i
                           (tarray tfloat 2)) (tarray tfloat 2))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
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
                               (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (Tstruct _SecondOrderLowPass noattr))
                           (Tstruct _SecondOrderLowPass noattr)) _a
                         (tarray tfloat 2)) (tarray tfloat 2))
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
                               (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (Tstruct _SecondOrderLowPass noattr))
                           (Tstruct _SecondOrderLowPass noattr)) _o
                         (tarray tfloat 2)) (tarray tfloat 2))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
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
                             (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (Tstruct _SecondOrderLowPass noattr))
                         (Tstruct _SecondOrderLowPass noattr)) _a
                       (tarray tfloat 2)) (tarray tfloat 2))
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
                             (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (Tstruct _SecondOrderLowPass noattr))
                         (Tstruct _SecondOrderLowPass noattr)) _o
                       (tarray tfloat 2)) (tarray tfloat 2))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
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
                         (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                         (tptr (Tstruct _SecondOrderLowPass noattr)))
                       (Tstruct _SecondOrderLowPass noattr))
                     (Tstruct _SecondOrderLowPass noattr)) _i
                   (tarray tfloat 2)) (tarray tfloat 2))
               (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
           (Evalof
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (tptr (Tstruct _SecondOrderLowPass noattr)))
                         (Tstruct _SecondOrderLowPass noattr))
                       (Tstruct _SecondOrderLowPass noattr)) _i
                     (tarray tfloat 2)) (tarray tfloat 2))
                 (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
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
                           (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (tptr (Tstruct _SecondOrderLowPass noattr)))
                         (Tstruct _SecondOrderLowPass noattr))
                       (Tstruct _SecondOrderLowPass noattr)) _i
                     (tarray tfloat 2)) (tarray tfloat 2))
                 (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
             (Evalof (Evar _value tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (tptr (Tstruct _SecondOrderLowPass noattr)))
                           (Tstruct _SecondOrderLowPass noattr))
                         (Tstruct _SecondOrderLowPass noattr)) _o
                       (tarray tfloat 2)) (tarray tfloat 2))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (Tstruct _SecondOrderLowPass noattr))
                           (Tstruct _SecondOrderLowPass noattr)) _o
                         (tarray tfloat 2)) (tarray tfloat 2))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
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
                               (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                               (tptr (Tstruct _SecondOrderLowPass noattr)))
                             (Tstruct _SecondOrderLowPass noattr))
                           (Tstruct _SecondOrderLowPass noattr)) _o
                         (tarray tfloat 2)) (tarray tfloat 2))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                 (Evalof (Evar _out tfloat) tfloat) tfloat))
          (Sreturn (Some (Evalof (Evar _out tfloat) tfloat))))))))
|}.

Definition f_init_butterworth_2_low_pass := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderLowPass noattr))) ::
                (_tau, tfloat) :: (_sample_time, tfloat) ::
                (_value, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sdo (Ecall
       (Evalof
         (Evar _init_second_order_low_pass (Tfunction
                                             ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                              tfloat :: tfloat :: tfloat ::
                                              tfloat :: nil) tvoid
                                             cc_default))
         (Tfunction
           ((tptr (Tstruct _SecondOrderLowPass noattr)) :: tfloat ::
            tfloat :: tfloat :: tfloat :: nil) tvoid cc_default))
       (Econs
         (Ecast
           (Evalof (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
             (tptr (Tstruct _SecondOrderLowPass noattr)))
           (tptr (Tstruct _SecondOrderLowPass noattr)))
         (Econs (Evalof (Evar _tau tfloat) tfloat)
           (Econs
             (Eval (Vfloat (Float.of_bits (Int64.repr 4604544210138303771))) tdouble)
             (Econs (Evalof (Evar _sample_time tfloat) tfloat)
               (Econs (Evalof (Evar _value tfloat) tfloat) Enil))))) tvoid))
|}.

Definition f_update_butterworth_2_low_pass := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderLowPass noattr))) ::
                (_value, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _update_second_order_low_pass (Tfunction
                                                         ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                                          tfloat :: nil)
                                                         tfloat cc_default))
                   (Tfunction
                     ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                      tfloat :: nil) tfloat cc_default))
                 (Econs
                   (Ecast
                     (Evalof
                       (Evar _filter (tptr (Tstruct _SecondOrderLowPass noattr)))
                       (tptr (Tstruct _SecondOrderLowPass noattr)))
                     (tptr (Tstruct _SecondOrderLowPass noattr)))
                   (Econs (Evalof (Evar _value tfloat) tfloat) Enil)) tfloat)))
|}.

Definition f_notch_filter_set_sampling_frequency := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderNotchFilter noattr))) ::
                (_frequency, tushort) :: nil);
  fn_vars := nil;
  fn_body :=
(Sdo (Eassign
       (Efield
         (Evalof
           (Ederef
             (Evalof
               (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
               (tptr (Tstruct _SecondOrderNotchFilter noattr)))
             (Tstruct _SecondOrderNotchFilter noattr))
           (Tstruct _SecondOrderNotchFilter noattr)) _Ts tfloat)
       (Ebinop Odiv
         (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
         (Evalof (Evar _frequency tushort) tushort) tdouble) tfloat))
|}.

Definition f_notch_filter_set_bandwidth := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderNotchFilter noattr))) ::
                (_bandwidth, tfloat) :: nil);
  fn_vars := ((_d, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _d tfloat)
         (Ecall
           (Evalof (Evar _expf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs
             (Ebinop Omul
               (Ebinop Omul
                 (Eunop Oneg
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   tdouble) (Evalof (Evar _bandwidth tfloat) tfloat) tdouble)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (Tstruct _SecondOrderNotchFilter noattr))
                     (Tstruct _SecondOrderNotchFilter noattr)) _Ts tfloat)
                 tfloat) tdouble) Enil) tfloat) tfloat))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                 (tptr (Tstruct _SecondOrderNotchFilter noattr)))
               (Tstruct _SecondOrderNotchFilter noattr))
             (Tstruct _SecondOrderNotchFilter noattr)) _d2 tfloat)
         (Ebinop Omul (Evalof (Evar _d tfloat) tfloat)
           (Evalof (Evar _d tfloat) tfloat) tfloat) tfloat)))
|}.

Definition f_notch_filter_set_filter_frequency := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderNotchFilter noattr))) ::
                (_frequency, tfloat) :: nil);
  fn_vars := ((_theta, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _theta tfloat)
         (Ebinop Omul
           (Ebinop Omul
             (Ebinop Omul
               (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
               (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
               tdouble) (Evalof (Evar _frequency tfloat) tfloat) tdouble)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                     (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                   (Tstruct _SecondOrderNotchFilter noattr))
                 (Tstruct _SecondOrderNotchFilter noattr)) _Ts tfloat)
             tfloat) tdouble) tfloat))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                 (tptr (Tstruct _SecondOrderNotchFilter noattr)))
               (Tstruct _SecondOrderNotchFilter noattr))
             (Tstruct _SecondOrderNotchFilter noattr)) _costheta tfloat)
         (Ecall
           (Evalof (Evar _cosf (Tfunction (tfloat :: nil) tfloat cc_default))
             (Tfunction (tfloat :: nil) tfloat cc_default))
           (Econs (Evalof (Evar _theta tfloat) tfloat) Enil) tfloat) tfloat)))
|}.

Definition f_notch_filter_update := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderNotchFilter noattr))) ::
                (_input_signal, (tptr tfloat)) ::
                (_output_signal, (tptr tfloat)) :: nil);
  fn_vars := ((_a, tfloat) :: (_b, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _a tfloat)
         (Ebinop Omul
           (Ebinop Oadd (Eval (Vint (Int.repr 1)) tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                     (Tstruct _SecondOrderNotchFilter noattr))
                   (Tstruct _SecondOrderNotchFilter noattr)) _d2 tfloat)
               tfloat) tfloat)
           (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
           tdouble) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _b tfloat)
           (Ebinop Omul
             (Ebinop Oadd (Eval (Vint (Int.repr 1)) tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (Tstruct _SecondOrderNotchFilter noattr))
                     (Tstruct _SecondOrderNotchFilter noattr)) _d2 tfloat)
                 tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                     (Tstruct _SecondOrderNotchFilter noattr))
                   (Tstruct _SecondOrderNotchFilter noattr)) _costheta
                 tfloat) tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Evalof (Evar _output_signal (tptr tfloat)) (tptr tfloat))
               tfloat)
             (Ebinop Oadd
               (Ebinop Osub
                 (Ebinop Oadd
                   (Ebinop Osub
                     (Ebinop Omul (Evalof (Evar _b tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                                 (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                               (Tstruct _SecondOrderNotchFilter noattr))
                             (Tstruct _SecondOrderNotchFilter noattr)) _yn1
                           tfloat) tfloat) tfloat)
                     (Ebinop Omul
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                                 (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                               (Tstruct _SecondOrderNotchFilter noattr))
                             (Tstruct _SecondOrderNotchFilter noattr)) _d2
                           tfloat) tfloat)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                                 (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                               (Tstruct _SecondOrderNotchFilter noattr))
                             (Tstruct _SecondOrderNotchFilter noattr)) _yn2
                           tfloat) tfloat) tfloat) tfloat)
                   (Ebinop Omul (Evalof (Evar _a tfloat) tfloat)
                     (Evalof
                       (Ederef
                         (Evalof (Evar _input_signal (tptr tfloat))
                           (tptr tfloat)) tfloat) tfloat) tfloat) tfloat)
                 (Ebinop Omul (Evalof (Evar _b tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                             (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (Tstruct _SecondOrderNotchFilter noattr))
                         (Tstruct _SecondOrderNotchFilter noattr)) _xn1
                       tfloat) tfloat) tfloat) tfloat)
               (Ebinop Omul (Evalof (Evar _a tfloat) tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (Tstruct _SecondOrderNotchFilter noattr))
                       (Tstruct _SecondOrderNotchFilter noattr)) _xn2 tfloat)
                   tfloat) tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                     (Tstruct _SecondOrderNotchFilter noattr))
                   (Tstruct _SecondOrderNotchFilter noattr)) _xn2 tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (Tstruct _SecondOrderNotchFilter noattr))
                     (Tstruct _SecondOrderNotchFilter noattr)) _xn1 tfloat)
                 tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (Tstruct _SecondOrderNotchFilter noattr))
                     (Tstruct _SecondOrderNotchFilter noattr)) _xn1 tfloat)
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input_signal (tptr tfloat))
                       (tptr tfloat)) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (Tstruct _SecondOrderNotchFilter noattr))
                       (Tstruct _SecondOrderNotchFilter noattr)) _yn2 tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                             (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (Tstruct _SecondOrderNotchFilter noattr))
                         (Tstruct _SecondOrderNotchFilter noattr)) _yn1
                       tfloat) tfloat) tfloat))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (Tstruct _SecondOrderNotchFilter noattr))
                       (Tstruct _SecondOrderNotchFilter noattr)) _yn1 tfloat)
                   (Evalof
                     (Ederef
                       (Evalof (Evar _output_signal (tptr tfloat))
                         (tptr tfloat)) tfloat) tfloat) tfloat))))))))
|}.

Definition f_notch_filter_init := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _SecondOrderNotchFilter noattr))) ::
                (_cutoff_frequency, tfloat) :: (_bandwidth, tfloat) ::
                (_sample_frequency, tushort) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _notch_filter_set_sampling_frequency (Tfunction
                                                        ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                                         tushort :: nil)
                                                        tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _SecondOrderNotchFilter noattr)) :: tushort ::
              nil) tvoid cc_default))
         (Econs
           (Evalof
             (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
             (tptr (Tstruct _SecondOrderNotchFilter noattr)))
           (Econs (Evalof (Evar _sample_frequency tushort) tushort) Enil))
         tvoid))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _notch_filter_set_filter_frequency (Tfunction
                                                        ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                                         tfloat :: nil) tvoid
                                                        cc_default))
             (Tfunction
               ((tptr (Tstruct _SecondOrderNotchFilter noattr)) :: tfloat ::
                nil) tvoid cc_default))
           (Econs
             (Evalof
               (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
               (tptr (Tstruct _SecondOrderNotchFilter noattr)))
             (Econs (Evalof (Evar _cutoff_frequency tfloat) tfloat) Enil))
           tvoid))
    (Ssequence
      (Sdo (Ecall
             (Evalof
               (Evar _notch_filter_set_bandwidth (Tfunction
                                                   ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                                    tfloat :: nil) tvoid
                                                   cc_default))
               (Tfunction
                 ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                  tfloat :: nil) tvoid cc_default))
             (Econs
               (Evalof
                 (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                 (tptr (Tstruct _SecondOrderNotchFilter noattr)))
               (Econs (Evalof (Evar _bandwidth tfloat) tfloat) Enil)) tvoid))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                     (Tstruct _SecondOrderNotchFilter noattr))
                   (Tstruct _SecondOrderNotchFilter noattr)) _xn1 tfloat)
               (Eval (Vint (Int.repr 0)) tint) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (Tstruct _SecondOrderNotchFilter noattr))
                     (Tstruct _SecondOrderNotchFilter noattr)) _xn2 tfloat)
                 (Eval (Vint (Int.repr 0)) tint) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (Tstruct _SecondOrderNotchFilter noattr))
                       (Tstruct _SecondOrderNotchFilter noattr)) _yn1 tfloat)
                   (Eval (Vint (Int.repr 0)) tint) tfloat))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                           (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                         (Tstruct _SecondOrderNotchFilter noattr))
                       (Tstruct _SecondOrderNotchFilter noattr)) _yn2 tfloat)
                   (Eval (Vint (Int.repr 0)) tint) tfloat))))))))
|}.

Definition f_adaptive_notch_filter_init := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _AdaptiveNotchFilter noattr))) ::
                (_sample_time, tfloat) :: (_low_freq_bound, tfloat) ::
                (_high_freq_bound, tfloat) :: (_bandwidth, tfloat) ::
                (_lambda, tfloat) :: (_a_ini, tfloat) :: (_value, tfloat) ::
                nil);
  fn_vars := ((_fs, tfloat) :: (_lp_tau, tfloat) :: (_hp_tau, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
               (Tstruct _AdaptiveNotchFilter noattr))
             (Tstruct _AdaptiveNotchFilter noattr)) _Ts tfloat)
         (Evalof (Evar _sample_time tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                   (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                 (Tstruct _AdaptiveNotchFilter noattr))
               (Tstruct _AdaptiveNotchFilter noattr)) _lp_cutoff_f tfloat)
           (Evalof (Evar _low_freq_bound tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                     (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                   (Tstruct _AdaptiveNotchFilter noattr))
                 (Tstruct _AdaptiveNotchFilter noattr)) _hp_cutoff_f tfloat)
             (Evalof (Evar _high_freq_bound tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                     (Tstruct _AdaptiveNotchFilter noattr))
                   (Tstruct _AdaptiveNotchFilter noattr)) _r tfloat)
               (Evalof (Evar _bandwidth tfloat) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                       (Tstruct _AdaptiveNotchFilter noattr))
                     (Tstruct _AdaptiveNotchFilter noattr)) _lambda tfloat)
                 (Evalof (Evar _lambda tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (Tstruct _AdaptiveNotchFilter noattr))
                             (Tstruct _AdaptiveNotchFilter noattr)) _y
                           (tarray tfloat 2)) (tarray tfloat 2))
                       (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                   (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                   (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                 (Tstruct _AdaptiveNotchFilter noattr))
                               (Tstruct _AdaptiveNotchFilter noattr)) _y
                             (tarray tfloat 2)) (tarray tfloat 2))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                       tfloat)
                     (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 (Tstruct _AdaptiveNotchFilter noattr))
                               _y_est (tarray tfloat 2)) (tarray tfloat 2))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat)
                       (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 _y_est (tarray tfloat 2)) (tarray tfloat 2))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat) (Evalof (Evar _value tfloat) tfloat)
                         tfloat) tfloat) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                           (Tstruct _AdaptiveNotchFilter noattr))
                         (Tstruct _AdaptiveNotchFilter noattr)) _a_est
                       tfloat) (Evalof (Evar _a_ini tfloat) tfloat) tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 (Tstruct _AdaptiveNotchFilter noattr))
                               _xband (tarray tfloat 3)) (tarray tfloat 3))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat)
                       (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 _xband (tarray tfloat 3)) (tarray tfloat 3))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat)
                         (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _xband (tarray tfloat 3))
                                 (tarray tfloat 3))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                             tfloat) (Evalof (Evar _value tfloat) tfloat)
                           tfloat) tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _fs tfloat)
                         (Ebinop Odiv
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 (Tstruct _AdaptiveNotchFilter noattr)) _Ts
                               tfloat) tfloat) tdouble) tfloat))
                  (Ssequence
                    (Sdo (Ecall
                           (Evalof
                             (Evar _notch_filter_init (Tfunction
                                                        ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                                         tfloat :: tfloat ::
                                                         tushort :: nil)
                                                        tvoid cc_default))
                             (Tfunction
                               ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                tfloat :: tfloat :: tushort :: nil) tvoid
                               cc_default))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 _output_n_filter
                                 (Tstruct _SecondOrderNotchFilter noattr))
                               (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                             (Econs
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _a_est tfloat) tfloat)
                               (Econs
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     _r tfloat) tfloat)
                                 (Econs (Evalof (Evar _fs tfloat) tfloat)
                                   Enil)))) tvoid))
                    (Ssequence
                      (Sdo (Eassign (Evar _lp_tau tfloat)
                             (Ebinop Odiv
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                                   tdouble)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     _lp_cutoff_f tfloat) tfloat) tdouble)
                               tdouble) tfloat))
                      (Ssequence
                        (Sdo (Ecall
                               (Evalof
                                 (Evar _init_butterworth_2_low_pass (Tfunction
                                                                    ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                                                    tfloat ::
                                                                    tfloat ::
                                                                    tfloat ::
                                                                    nil)
                                                                    tvoid
                                                                    cc_default))
                                 (Tfunction
                                   ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                    tfloat :: tfloat :: tfloat :: nil) tvoid
                                   cc_default))
                               (Econs
                                 (Eaddrof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     _lp_filter
                                     (Tstruct _SecondOrderLowPass noattr))
                                   (tptr (Tstruct _SecondOrderLowPass noattr)))
                                 (Econs (Evalof (Evar _lp_tau tfloat) tfloat)
                                   (Econs
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         _Ts tfloat) tfloat)
                                     (Econs
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                                       Enil)))) tvoid))
                        (Ssequence
                          (Sdo (Eassign (Evar _hp_tau tfloat)
                                 (Ebinop Odiv
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                   (Ebinop Omul
                                     (Ebinop Omul
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                                       tdouble)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         _hp_cutoff_f tfloat) tfloat)
                                     tdouble) tdouble) tfloat))
                          (Sdo (Ecall
                                 (Evalof
                                   (Evar _init_butterworth_2_low_pass 
                                   (Tfunction
                                     ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                      tfloat :: tfloat :: tfloat :: nil)
                                     tvoid cc_default))
                                   (Tfunction
                                     ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                      tfloat :: tfloat :: tfloat :: nil)
                                     tvoid cc_default))
                                 (Econs
                                   (Eaddrof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _hp_filter
                                       (Tstruct _SecondOrderLowPass noattr))
                                     (tptr (Tstruct _SecondOrderLowPass noattr)))
                                   (Econs
                                     (Evalof (Evar _hp_tau tfloat) tfloat)
                                     (Econs
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _Ts tfloat) tfloat)
                                       (Econs
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                                         Enil)))) tvoid)))))))))))))))
|}.

Definition f_adaptive_notch_filter_update := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _AdaptiveNotchFilter noattr))) ::
                (_value, tfloat) :: (_output_signal, (tptr tfloat)) :: nil);
  fn_vars := ((_out_est, tfloat) :: (_beta, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _update_butterworth_2_low_pass (Tfunction
                                                  ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                                   tfloat :: nil) tfloat
                                                  cc_default))
           (Tfunction
             ((tptr (Tstruct _SecondOrderLowPass noattr)) :: tfloat :: nil)
             tfloat cc_default))
         (Econs
           (Eaddrof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                     (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                   (Tstruct _AdaptiveNotchFilter noattr))
                 (Tstruct _AdaptiveNotchFilter noattr)) _lp_filter
               (Tstruct _SecondOrderLowPass noattr))
             (tptr (Tstruct _SecondOrderLowPass noattr)))
           (Econs (Evalof (Evar _value tfloat) tfloat) Enil)) tfloat))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _update_butterworth_2_low_pass (Tfunction
                                                    ((tptr (Tstruct _SecondOrderLowPass noattr)) ::
                                                     tfloat :: nil) tfloat
                                                    cc_default))
             (Tfunction
               ((tptr (Tstruct _SecondOrderLowPass noattr)) :: tfloat :: nil)
               tfloat cc_default))
           (Econs
             (Eaddrof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                     (Tstruct _AdaptiveNotchFilter noattr))
                   (Tstruct _AdaptiveNotchFilter noattr)) _hp_filter
                 (Tstruct _SecondOrderLowPass noattr))
               (tptr (Tstruct _SecondOrderLowPass noattr)))
             (Econs (Evalof (Evar _value tfloat) tfloat) Enil)) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                         (Tstruct _AdaptiveNotchFilter noattr))
                       (Tstruct _AdaptiveNotchFilter noattr)) _xband
                     (tarray tfloat 3)) (tarray tfloat 3))
                 (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
             (Evalof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                           (Tstruct _AdaptiveNotchFilter noattr))
                         (Tstruct _AdaptiveNotchFilter noattr)) _xband
                       (tarray tfloat 3)) (tarray tfloat 3))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
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
                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                           (Tstruct _AdaptiveNotchFilter noattr))
                         (Tstruct _AdaptiveNotchFilter noattr)) _xband
                       (tarray tfloat 3)) (tarray tfloat 3))
                   (Eval (Vint (Int.repr 1)) tint) (tptr tfloat)) tfloat)
               (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (Tstruct _AdaptiveNotchFilter noattr))
                           (Tstruct _AdaptiveNotchFilter noattr)) _xband
                         (tarray tfloat 3)) (tarray tfloat 3))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
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
                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (Tstruct _AdaptiveNotchFilter noattr))
                           (Tstruct _AdaptiveNotchFilter noattr)) _xband
                         (tarray tfloat 3)) (tarray tfloat 3))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                 (Ebinop Osub
                   (Ebinop Osub (Evalof (Evar _value tfloat) tfloat)
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
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _lp_filter
                                   (Tstruct _SecondOrderLowPass noattr))
                                 (Tstruct _SecondOrderLowPass noattr)) _o
                               (tarray tfloat 2)) (tarray tfloat 2))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat)
                   (Ebinop Osub (Evalof (Evar _value tfloat) tfloat)
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
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _hp_filter
                                   (Tstruct _SecondOrderLowPass noattr))
                                 (Tstruct _SecondOrderLowPass noattr)) _o
                               (tarray tfloat 2)) (tarray tfloat 2))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat) tfloat) tfloat) tfloat) tfloat))
          (Ssequence
            (Sdo (Ecall
                   (Evalof
                     (Evar _notch_filter_set_filter_frequency (Tfunction
                                                                ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                                                 tfloat ::
                                                                 nil) tvoid
                                                                cc_default))
                     (Tfunction
                       ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                        tfloat :: nil) tvoid cc_default))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (Tstruct _AdaptiveNotchFilter noattr))
                           (Tstruct _AdaptiveNotchFilter noattr))
                         _output_n_filter
                         (Tstruct _SecondOrderNotchFilter noattr))
                       (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (Tstruct _AdaptiveNotchFilter noattr))
                             (Tstruct _AdaptiveNotchFilter noattr)) _a_est
                           tfloat) tfloat) Enil)) tvoid))
            (Ssequence
              (Sdo (Ecall
                     (Evalof
                       (Evar _notch_filter_update (Tfunction
                                                    ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                                                     (tptr tfloat) ::
                                                     (tptr tfloat) :: nil)
                                                    tvoid cc_default))
                       (Tfunction
                         ((tptr (Tstruct _SecondOrderNotchFilter noattr)) ::
                          (tptr tfloat) :: (tptr tfloat) :: nil) tvoid
                         cc_default))
                     (Econs
                       (Eaddrof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (Tstruct _AdaptiveNotchFilter noattr))
                             (Tstruct _AdaptiveNotchFilter noattr))
                           _output_n_filter
                           (Tstruct _SecondOrderNotchFilter noattr))
                         (tptr (Tstruct _SecondOrderNotchFilter noattr)))
                       (Econs (Eaddrof (Evar _value tfloat) (tptr tfloat))
                         (Econs
                           (Evalof (Evar _output_signal (tptr tfloat))
                             (tptr tfloat)) Enil))) tvoid))
              (Ssequence
                (Sdo (Eassign (Evar _out_est tfloat)
                       (Ebinop Osub
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Osub
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         _xband (tarray tfloat 3))
                                       (tarray tfloat 3))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
                               (Ebinop Omul
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     _a_est tfloat) tfloat)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _xband (tarray tfloat 3))
                                         (tarray tfloat 3))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tfloat)) tfloat) tfloat) tfloat)
                               tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _xband (tarray tfloat 3))
                                     (tarray tfloat 3))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Ebinop Omul
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _r tfloat) tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _a_est tfloat) tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _y_est (tarray tfloat 2))
                                     (tarray tfloat 2))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 (Tstruct _AdaptiveNotchFilter noattr)) _r2
                               tfloat) tfloat)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     _y_est (tarray tfloat 2))
                                   (tarray tfloat 2))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr tfloat)) tfloat) tfloat) tfloat)
                         tfloat) tfloat))
                (Ssequence
                  (Sdo (Eassign (Evar _beta tfloat)
                         (Ebinop Oadd
                           (Eunop Oneg
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _xband (tarray tfloat 3))
                                     (tarray tfloat 3))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   (Tstruct _AdaptiveNotchFilter noattr)) _r
                                 tfloat) tfloat)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _y_est (tarray tfloat 2))
                                     (tarray tfloat 2))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tfloat)) tfloat) tfloat) tfloat)
                           tfloat) tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                   (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                 (Tstruct _AdaptiveNotchFilter noattr))
                               (Tstruct _AdaptiveNotchFilter noattr)) _a_est
                             tfloat)
                           (Ebinop Osub
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 _a_est tfloat) tfloat)
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _lambda tfloat) tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _Ts tfloat) tfloat) tfloat)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _y_est (tarray tfloat 2))
                                         (tarray tfloat 2))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tfloat)) tfloat) tfloat) tfloat)
                               (Evalof (Evar _beta tfloat) tfloat) tfloat)
                             tfloat) tfloat))
                    (Ssequence
                      (Sifthenelse (Eunop Onotbool
                                     (Ebinop Ogt
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _a_est tfloat) tfloat)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _lp_cutoff_f tfloat) tfloat) tint)
                                     tint)
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   (Tstruct _AdaptiveNotchFilter noattr))
                                 _a_est tfloat)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _lp_cutoff_f tfloat) tfloat) tfloat))
                        (Sifthenelse (Eunop Onotbool
                                       (Ebinop Olt
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                   (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (Tstruct _AdaptiveNotchFilter noattr))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             _a_est tfloat) tfloat)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                   (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (Tstruct _AdaptiveNotchFilter noattr))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             _hp_cutoff_f tfloat) tfloat)
                                         tint) tint)
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     (Tstruct _AdaptiveNotchFilter noattr))
                                   _a_est tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       (Tstruct _AdaptiveNotchFilter noattr))
                                     _hp_cutoff_f tfloat) tfloat) tfloat))
                          Sskip))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         (Tstruct _AdaptiveNotchFilter noattr))
                                       _y (tarray tfloat 2))
                                     (tarray tfloat 2))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tfloat)) tfloat)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         _y (tarray tfloat 2))
                                       (tarray tfloat 2))
                                     (Eval (Vint (Int.repr 0)) tint)
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
                                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           (Tstruct _AdaptiveNotchFilter noattr))
                                         _y (tarray tfloat 2))
                                       (tarray tfloat 2))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _output_signal (tptr tfloat))
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
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _y_est (tarray tfloat 2))
                                         (tarray tfloat 2))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                   (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (Tstruct _AdaptiveNotchFilter noattr))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             _y_est (tarray tfloat 2))
                                           (tarray tfloat 2))
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (tptr tfloat)) tfloat) tfloat)
                                   tfloat))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                                 (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                                               (Tstruct _AdaptiveNotchFilter noattr))
                                             (Tstruct _AdaptiveNotchFilter noattr))
                                           _y_est (tarray tfloat 2))
                                         (tarray tfloat 2))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Evalof (Evar _out_est tfloat) tfloat)
                                   tfloat))))))))))))))))
|}.

Definition f_adaptive_notch_filter_get_output := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _AdaptiveNotchFilter noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Evalof
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _filter (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                               (tptr (Tstruct _AdaptiveNotchFilter noattr)))
                             (Tstruct _AdaptiveNotchFilter noattr))
                           (Tstruct _AdaptiveNotchFilter noattr)) _y_est
                         (tarray tfloat 2)) (tarray tfloat 2))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                 tfloat)))
|}.

Definition v_five_keep_adaptive_notch_filter_init := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _adaptive_notch_filter_init (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_adaptive_notch_filter_update := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _adaptive_notch_filter_update (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_adaptive_notch_filter_get_output := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _adaptive_notch_filter_get_output (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _SecondOrderLowPass Struct
   (Member_plain _a (tarray tfloat 2) :: Member_plain _b (tarray tfloat 2) ::
    Member_plain _i (tarray tfloat 2) :: Member_plain _o (tarray tfloat 2) ::
    nil)
   noattr ::
 Composite _SecondOrderNotchFilter Struct
   (Member_plain _Ts tfloat :: Member_plain _d2 tfloat ::
    Member_plain _costheta tfloat :: Member_plain _xn1 tfloat ::
    Member_plain _xn2 tfloat :: Member_plain _yn1 tfloat ::
    Member_plain _yn2 tfloat :: nil)
   noattr ::
 Composite _AdaptiveNotchFilter Struct
   (Member_plain _Ts tfloat :: Member_plain _lp_cutoff_f tfloat ::
    Member_plain _hp_cutoff_f tfloat :: Member_plain _r tfloat ::
    Member_plain _r2 tfloat :: Member_plain _lambda tfloat ::
    Member_plain _a_est tfloat :: Member_plain _y (tarray tfloat 2) ::
    Member_plain _y_est (tarray tfloat 2) ::
    Member_plain _output_n_filter (Tstruct _SecondOrderNotchFilter noattr) ::
    Member_plain _lp_filter (Tstruct _SecondOrderLowPass noattr) ::
    Member_plain _hp_filter (Tstruct _SecondOrderLowPass noattr) ::
    Member_plain _xband (tarray tfloat 3) :: nil)
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
 (_cosf,
   Gfun(External (EF_external "cosf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_tanf,
   Gfun(External (EF_external "tanf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_expf,
   Gfun(External (EF_external "expf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_init_second_order_low_pass, Gfun(Internal f_init_second_order_low_pass)) ::
 (_update_second_order_low_pass, Gfun(Internal f_update_second_order_low_pass)) ::
 (_init_butterworth_2_low_pass, Gfun(Internal f_init_butterworth_2_low_pass)) ::
 (_update_butterworth_2_low_pass, Gfun(Internal f_update_butterworth_2_low_pass)) ::
 (_notch_filter_set_sampling_frequency, Gfun(Internal f_notch_filter_set_sampling_frequency)) ::
 (_notch_filter_set_bandwidth, Gfun(Internal f_notch_filter_set_bandwidth)) ::
 (_notch_filter_set_filter_frequency, Gfun(Internal f_notch_filter_set_filter_frequency)) ::
 (_notch_filter_update, Gfun(Internal f_notch_filter_update)) ::
 (_notch_filter_init, Gfun(Internal f_notch_filter_init)) ::
 (_adaptive_notch_filter_init, Gfun(Internal f_adaptive_notch_filter_init)) ::
 (_adaptive_notch_filter_update, Gfun(Internal f_adaptive_notch_filter_update)) ::
 (_adaptive_notch_filter_get_output, Gfun(Internal f_adaptive_notch_filter_get_output)) ::
 (_five_keep_adaptive_notch_filter_init, Gvar v_five_keep_adaptive_notch_filter_init) ::
 (_five_keep_adaptive_notch_filter_update, Gvar v_five_keep_adaptive_notch_filter_update) ::
 (_five_keep_adaptive_notch_filter_get_output, Gvar v_five_keep_adaptive_notch_filter_get_output) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_adaptive_notch_filter_get_output ::
 _five_keep_adaptive_notch_filter_update ::
 _five_keep_adaptive_notch_filter_init :: _expf :: _tanf :: _cosf ::
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


