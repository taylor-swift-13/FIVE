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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/connected-models/delayed_filter_lifecycle/model/preprocessed.i".
End Info.

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
Definition _buffer : ident := $"buffer".
Definition _delay : ident := $"delay".
Definition _delayed_first_order_lowpass_filter_t : ident := $"delayed_first_order_lowpass_filter_t".
Definition _delayed_first_order_lowpass_initialize : ident := $"delayed_first_order_lowpass_initialize".
Definition _delayed_first_order_lowpass_propagate : ident := $"delayed_first_order_lowpass_propagate".
Definition _delayed_first_order_lowpass_set_delay : ident := $"delayed_first_order_lowpass_set_delay".
Definition _delayed_first_order_lowpass_set_omega : ident := $"delayed_first_order_lowpass_set_omega".
Definition _f : ident := $"f".
Definition _five_keep_delayed_first_order_lowpass_initialize : ident := $"five_keep_delayed_first_order_lowpass_initialize".
Definition _five_keep_delayed_first_order_lowpass_propagate : ident := $"five_keep_delayed_first_order_lowpass_propagate".
Definition _five_keep_delayed_first_order_lowpass_set_delay : ident := $"five_keep_delayed_first_order_lowpass_set_delay".
Definition _five_keep_delayed_first_order_lowpass_set_omega : ident := $"five_keep_delayed_first_order_lowpass_set_omega".
Definition _i : ident := $"i".
Definition _idx : ident := $"idx".
Definition _input : ident := $"input".
Definition _main : ident := $"main".
Definition _max_inc : ident := $"max_inc".
Definition _next_idx : ident := $"next_idx".
Definition _omega : ident := $"omega".
Definition _prev : ident := $"prev".
Definition _req_idx : ident := $"req_idx".
Definition _sample_frequency : ident := $"sample_frequency".

Definition f_delayed_first_order_lowpass_propagate := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_f,
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr))) ::
                (_input, tint) :: nil);
  fn_vars := ((_prev, tint) :: (_next_idx, tuchar) :: (_req_idx, tuchar) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _prev tint)
         (Evalof
           (Ederef
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                         (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   _buffer (tarray tint 20)) (tarray tint 20))
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                         (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   _idx tuchar) tuchar) (tptr tint)) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _next_idx tuchar)
           (Ebinop Omod
             (Eassignop Oadd
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                 _idx tuchar) (Eval (Vint (Int.repr 1)) tint) tint tuchar)
             (Eval (Vint (Int.repr 20)) tint) tint) tuchar))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                     (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                 (Tstruct _delayed_first_order_lowpass_filter_t noattr)) _idx
               tuchar) (Evalof (Evar _next_idx tuchar) tuchar) tuchar))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                             (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                           (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                         (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                       _buffer (tarray tint 20)) (tarray tint 20))
                   (Evalof (Evar _next_idx tuchar) tuchar) (tptr tint)) tint)
               (Ebinop Oshr
                 (Ebinop Oadd
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                               (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                             (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                           (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                         _alpha tint) tint) (Evalof (Evar _prev tint) tint)
                     tint)
                   (Ebinop Omul
                     (Ebinop Osub
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                             (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                           _alpha tint) tint) tint)
                     (Evalof (Evar _input tint) tint) tint) tint)
                 (Eval (Vint (Int.repr 14)) tint) tint) tint))
        (Ssequence
          (Sifthenelse (Ebinop Ogt
                         (Ebinop Osub
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                           (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                         (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                       (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                     _buffer (tarray tint 20))
                                   (tarray tint 20))
                                 (Evalof (Evar _next_idx tuchar) tuchar)
                                 (tptr tint)) tint) tint)
                           (Evalof (Evar _prev tint) tint) tint)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                   (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                 (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                             _max_inc tushort) tushort) tint)
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                             (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                           _buffer (tarray tint 20)) (tarray tint 20))
                       (Evalof (Evar _next_idx tuchar) tuchar) (tptr tint))
                     tint)
                   (Ebinop Oadd (Evalof (Evar _prev tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                               (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                             (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                           (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                         _max_inc tushort) tushort) tint) tint))
            Sskip)
          (Ssequence
            (Sifthenelse (Ebinop Olt
                           (Ebinop Osub
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                             (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                           (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                         (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                       _buffer (tarray tint 20))
                                     (tarray tint 20))
                                   (Evalof (Evar _next_idx tuchar) tuchar)
                                   (tptr tint)) tint) tint)
                             (Evalof (Evar _prev tint) tint) tint)
                           (Eunop Oneg
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                       (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                 _max_inc tushort) tushort) tint) tint)
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                   (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                 (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                             _buffer (tarray tint 20)) (tarray tint 20))
                         (Evalof (Evar _next_idx tuchar) tuchar) (tptr tint))
                       tint)
                     (Ebinop Osub (Evalof (Evar _prev tint) tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                             (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                           _max_inc tushort) tushort) tint) tint))
              Sskip)
            (Ssequence
              (Sdo (Eassign (Evar _req_idx tuchar)
                     (Ebinop Omod
                       (Ebinop Oadd
                         (Ebinop Osub
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                     (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                 (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                               _idx tuchar) tuchar)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                     (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                 (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                               _delay tuchar) tuchar) tint)
                         (Eval (Vint (Int.repr 20)) tint) tint)
                       (Eval (Vint (Int.repr 20)) tint) tint) tuchar))
              (Sreturn (Some (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                             (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                           (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                         (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                                       _buffer (tarray tint 20))
                                     (tarray tint 20))
                                   (Evalof (Evar _req_idx tuchar) tuchar)
                                   (tptr tint)) tint) tint))))))))))
|}.

Definition f_delayed_first_order_lowpass_set_omega := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_f,
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr))) ::
                (_omega, tuint) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
             (Tstruct _delayed_first_order_lowpass_filter_t noattr)) _omega
           tuint) (Evalof (Evar _omega tuint) tuint) tuint))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
             (Tstruct _delayed_first_order_lowpass_filter_t noattr)) _alpha
           tint)
         (Ebinop Odiv
           (Ebinop Oshl
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                 _sample_frequency tushort) tushort)
             (Eval (Vint (Int.repr 14)) tint) tint)
           (Ebinop Oadd
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                 _sample_frequency tushort) tushort)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                 _omega tuint) tuint) tuint) tuint) tint)))
|}.

Definition f_delayed_first_order_lowpass_set_delay := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_f,
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr))) ::
                (_delay, tuchar) :: nil);
  fn_vars := nil;
  fn_body :=
(Sifthenelse (Ebinop Oge (Evalof (Evar _delay tuchar) tuchar)
               (Eval (Vint (Int.repr 20)) tint) tint)
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
             (Tstruct _delayed_first_order_lowpass_filter_t noattr)) _delay
           tuchar)
         (Ebinop Osub (Eval (Vint (Int.repr 20)) tint)
           (Eval (Vint (Int.repr 1)) tint) tint) tuchar))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
             (Tstruct _delayed_first_order_lowpass_filter_t noattr)) _delay
           tuchar) (Evalof (Evar _delay tuchar) tuchar) tuchar)))
|}.

Definition f_delayed_first_order_lowpass_initialize := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_f,
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr))) ::
                (_omega, tuint) :: (_delay, tuchar) :: (_max_inc, tushort) ::
                (_sample_frequency, tushort) :: nil);
  fn_vars := ((_i, tuchar) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
             (Tstruct _delayed_first_order_lowpass_filter_t noattr))
           _sample_frequency tushort)
         (Evalof (Evar _sample_frequency tushort) tushort) tushort))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _delayed_first_order_lowpass_set_delay (Tfunction
                                                            ((tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)) ::
                                                             tuchar :: nil)
                                                            tvoid cc_default))
             (Tfunction
               ((tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)) ::
                tuchar :: nil) tvoid cc_default))
           (Econs
             (Evalof
               (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
             (Econs (Evalof (Evar _delay tuchar) tuchar) Enil)) tvoid))
    (Ssequence
      (Sdo (Ecall
             (Evalof
               (Evar _delayed_first_order_lowpass_set_omega (Tfunction
                                                              ((tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)) ::
                                                               tuint :: nil)
                                                              tvoid
                                                              cc_default))
               (Tfunction
                 ((tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)) ::
                  tuint :: nil) tvoid cc_default))
             (Econs
               (Evalof
                 (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                 (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
               (Econs (Evalof (Evar _omega tuint) tuint) Enil)) tvoid))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                 _max_inc tushort) (Evalof (Evar _max_inc tushort) tushort)
               tushort))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                         (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                       (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                     (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                   _idx tuchar) (Eval (Vint (Int.repr 0)) tint) tuchar))
          (Ssequence
            (Sdo (Eassign (Evar _i tuchar) (Eval (Vint (Int.repr 0)) tint)
                   tuchar))
            (Sfor
              Sskip
              (Ebinop Olt (Evalof (Evar _i tuchar) tuchar)
                (Eval (Vint (Int.repr 20)) tint) tint)
              (Sdo (Epostincr Incr (Evar _i tuchar) tuchar))
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _f (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                   (tptr (Tstruct _delayed_first_order_lowpass_filter_t noattr)))
                                 (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                               (Tstruct _delayed_first_order_lowpass_filter_t noattr))
                             _buffer (tarray tint 20)) (tarray tint 20))
                         (Evalof (Evar _i tuchar) tuchar) (tptr tint)) tint)
                     (Eval (Vint (Int.repr 0)) tint) tint)))))))))
|}.

Definition v_five_keep_delayed_first_order_lowpass_propagate := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _delayed_first_order_lowpass_propagate (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_delayed_first_order_lowpass_set_omega := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _delayed_first_order_lowpass_set_omega (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_delayed_first_order_lowpass_set_delay := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _delayed_first_order_lowpass_set_delay (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_delayed_first_order_lowpass_initialize := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _delayed_first_order_lowpass_initialize (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _delayed_first_order_lowpass_filter_t Struct
   (Member_plain _sample_frequency tushort :: Member_plain _omega tuint ::
    Member_plain _delay tuchar :: Member_plain _alpha tint ::
    Member_plain _max_inc tushort :: Member_plain _buffer (tarray tint 20) ::
    Member_plain _idx tuchar :: nil)
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
 (_delayed_first_order_lowpass_propagate, Gfun(Internal f_delayed_first_order_lowpass_propagate)) ::
 (_delayed_first_order_lowpass_set_omega, Gfun(Internal f_delayed_first_order_lowpass_set_omega)) ::
 (_delayed_first_order_lowpass_set_delay, Gfun(Internal f_delayed_first_order_lowpass_set_delay)) ::
 (_delayed_first_order_lowpass_initialize, Gfun(Internal f_delayed_first_order_lowpass_initialize)) ::
 (_five_keep_delayed_first_order_lowpass_propagate, Gvar v_five_keep_delayed_first_order_lowpass_propagate) ::
 (_five_keep_delayed_first_order_lowpass_set_omega, Gvar v_five_keep_delayed_first_order_lowpass_set_omega) ::
 (_five_keep_delayed_first_order_lowpass_set_delay, Gvar v_five_keep_delayed_first_order_lowpass_set_delay) ::
 (_five_keep_delayed_first_order_lowpass_initialize, Gvar v_five_keep_delayed_first_order_lowpass_initialize) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_delayed_first_order_lowpass_initialize ::
 _five_keep_delayed_first_order_lowpass_set_delay ::
 _five_keep_delayed_first_order_lowpass_set_omega ::
 _five_keep_delayed_first_order_lowpass_propagate :: ___builtin_debug ::
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


