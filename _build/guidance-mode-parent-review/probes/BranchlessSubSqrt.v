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
  Definition source_file := "paparazzi/report/guidance_mode/evidence/software-sqrt-binding/branchless-sub/wrapper.c".
End Info.

Definition _FiveSqrtBits : ident := $"FiveSqrtBits".
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
Definition _exponent : ident := $"exponent".
Definition _exponent_bits : ident := $"exponent_bits".
Definition _f : ident := $"f".
Definition _five_sqrtf : ident := $"five_sqrtf".
Definition _magnitude : ident := $"magnitude".
Definition _main : ident := $"main".
Definition _mantissa : ident := $"mantissa".
Definition _mask : ident := $"mask".
Definition _pair : ident := $"pair".
Definition _probe : ident := $"probe".
Definition _radicand : ident := $"radicand".
Definition _remainder : ident := $"remainder".
Definition _result_exponent : ident := $"result_exponent".
Definition _root : ident := $"root".
Definition _take : ident := $"take".
Definition _trial : ident := $"trial".
Definition _u : ident := $"u".
Definition _view : ident := $"view".
Definition _x : ident := $"x".

Definition f_five_sqrtf := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: nil);
  fn_vars := ((_view, (Tunion _FiveSqrtBits noattr)) ::
              (_magnitude, tuint) :: (_exponent_bits, tuint) ::
              (_mantissa, tuint) :: (_exponent, tint) ::
              (_result_exponent, tint) :: (_radicand, tulong) ::
              (_pair, tuint) :: (_remainder, tuint) :: (_trial, tuint) ::
              (_root, tuint) :: (_take, tuint) :: (_mask, tuint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof (Evar _view (Tunion _FiveSqrtBits noattr))
             (Tunion _FiveSqrtBits noattr)) _f tfloat)
         (Evalof (Evar _x tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign (Evar _magnitude tuint)
           (Ebinop Oand
             (Evalof
               (Efield
                 (Evalof (Evar _view (Tunion _FiveSqrtBits noattr))
                   (Tunion _FiveSqrtBits noattr)) _u tuint) tuint)
             (Eval (Vint (Int.repr 2147483647)) tuint) tuint) tuint))
    (Ssequence
      (Sifthenelse (Ebinop Ogt (Evalof (Evar _magnitude tuint) tuint)
                     (Eval (Vint (Int.repr 2139095040)) tuint) tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _view (Tunion _FiveSqrtBits noattr))
                     (Tunion _FiveSqrtBits noattr)) _u tuint)
                 (Ebinop Oor
                   (Evalof
                     (Efield
                       (Evalof (Evar _view (Tunion _FiveSqrtBits noattr))
                         (Tunion _FiveSqrtBits noattr)) _u tuint) tuint)
                   (Eval (Vint (Int.repr 4194304)) tuint) tuint) tuint))
          (Sreturn (Some (Evalof
                           (Efield
                             (Evalof
                               (Evar _view (Tunion _FiveSqrtBits noattr))
                               (Tunion _FiveSqrtBits noattr)) _f tfloat)
                           tfloat))))
        Sskip)
      (Ssequence
        (Sifthenelse (Ebinop Oeq (Evalof (Evar _magnitude tuint) tuint)
                       (Eval (Vint (Int.repr 0)) tuint) tint)
          (Sreturn (Some (Evalof (Evar _x tfloat) tfloat)))
          Sskip)
        (Ssequence
          (Sifthenelse (Ebinop One
                         (Ebinop Oand
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _view (Tunion _FiveSqrtBits noattr))
                                 (Tunion _FiveSqrtBits noattr)) _u tuint)
                             tuint)
                           (Eval (Vint (Int.repr (-2147483648))) tuint)
                           tuint) (Eval (Vint (Int.repr 0)) tuint) tint)
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof (Evar _view (Tunion _FiveSqrtBits noattr))
                         (Tunion _FiveSqrtBits noattr)) _u tuint)
                     (Eval (Vint (Int.repr 2143289344)) tuint) tuint))
              (Sreturn (Some (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _view (Tunion _FiveSqrtBits noattr))
                                   (Tunion _FiveSqrtBits noattr)) _f tfloat)
                               tfloat))))
            Sskip)
          (Ssequence
            (Sifthenelse (Ebinop Oeq (Evalof (Evar _magnitude tuint) tuint)
                           (Eval (Vint (Int.repr 2139095040)) tuint) tint)
              (Sreturn (Some (Evalof (Evar _x tfloat) tfloat)))
              Sskip)
            (Ssequence
              (Sdo (Eassign (Evar _exponent_bits tuint)
                     (Ebinop Oshr (Evalof (Evar _magnitude tuint) tuint)
                       (Eval (Vint (Int.repr 23)) tint) tuint) tuint))
              (Ssequence
                (Sdo (Eassign (Evar _mantissa tuint)
                       (Ebinop Oand (Evalof (Evar _magnitude tuint) tuint)
                         (Eval (Vint (Int.repr 8388607)) tuint) tuint) tuint))
                (Ssequence
                  (Sifthenelse (Ebinop Oeq
                                 (Evalof (Evar _exponent_bits tuint) tuint)
                                 (Eval (Vint (Int.repr 0)) tuint) tint)
                    (Ssequence
                      (Sdo (Eassign (Evar _exponent tint)
                             (Eunop Oneg (Eval (Vint (Int.repr 126)) tint)
                               tint) tint))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign (Evar _take tuint)
                                 (Ecast
                                   (Ebinop Olt
                                     (Evalof (Evar _mantissa tuint) tuint)
                                     (Eval (Vint (Int.repr 8388608)) tuint)
                                     tint) tuint) tuint))
                          (Ssequence
                            (Sdo (Eassign (Evar _mantissa tuint)
                                   (Ebinop Oshl
                                     (Evalof (Evar _mantissa tuint) tuint)
                                     (Evalof (Evar _take tuint) tuint) tuint)
                                   tuint))
                            (Sdo (Eassign (Evar _exponent tint)
                                   (Ebinop Osub
                                     (Evalof (Evar _exponent tint) tint)
                                     (Ecast (Evalof (Evar _take tuint) tuint)
                                       tint) tint) tint))))
                        (Ssequence
                          (Ssequence
                            (Sdo (Eassign (Evar _take tuint)
                                   (Ecast
                                     (Ebinop Olt
                                       (Evalof (Evar _mantissa tuint) tuint)
                                       (Eval (Vint (Int.repr 8388608)) tuint)
                                       tint) tuint) tuint))
                            (Ssequence
                              (Sdo (Eassign (Evar _mantissa tuint)
                                     (Ebinop Oshl
                                       (Evalof (Evar _mantissa tuint) tuint)
                                       (Evalof (Evar _take tuint) tuint)
                                       tuint) tuint))
                              (Sdo (Eassign (Evar _exponent tint)
                                     (Ebinop Osub
                                       (Evalof (Evar _exponent tint) tint)
                                       (Ecast
                                         (Evalof (Evar _take tuint) tuint)
                                         tint) tint) tint))))
                          (Ssequence
                            (Ssequence
                              (Sdo (Eassign (Evar _take tuint)
                                     (Ecast
                                       (Ebinop Olt
                                         (Evalof (Evar _mantissa tuint)
                                           tuint)
                                         (Eval (Vint (Int.repr 8388608)) tuint)
                                         tint) tuint) tuint))
                              (Ssequence
                                (Sdo (Eassign (Evar _mantissa tuint)
                                       (Ebinop Oshl
                                         (Evalof (Evar _mantissa tuint)
                                           tuint)
                                         (Evalof (Evar _take tuint) tuint)
                                         tuint) tuint))
                                (Sdo (Eassign (Evar _exponent tint)
                                       (Ebinop Osub
                                         (Evalof (Evar _exponent tint) tint)
                                         (Ecast
                                           (Evalof (Evar _take tuint) tuint)
                                           tint) tint) tint))))
                            (Ssequence
                              (Ssequence
                                (Sdo (Eassign (Evar _take tuint)
                                       (Ecast
                                         (Ebinop Olt
                                           (Evalof (Evar _mantissa tuint)
                                             tuint)
                                           (Eval (Vint (Int.repr 8388608)) tuint)
                                           tint) tuint) tuint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _mantissa tuint)
                                         (Ebinop Oshl
                                           (Evalof (Evar _mantissa tuint)
                                             tuint)
                                           (Evalof (Evar _take tuint) tuint)
                                           tuint) tuint))
                                  (Sdo (Eassign (Evar _exponent tint)
                                         (Ebinop Osub
                                           (Evalof (Evar _exponent tint)
                                             tint)
                                           (Ecast
                                             (Evalof (Evar _take tuint)
                                               tuint) tint) tint) tint))))
                              (Ssequence
                                (Ssequence
                                  (Sdo (Eassign (Evar _take tuint)
                                         (Ecast
                                           (Ebinop Olt
                                             (Evalof (Evar _mantissa tuint)
                                               tuint)
                                             (Eval (Vint (Int.repr 8388608)) tuint)
                                             tint) tuint) tuint))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _mantissa tuint)
                                           (Ebinop Oshl
                                             (Evalof (Evar _mantissa tuint)
                                               tuint)
                                             (Evalof (Evar _take tuint)
                                               tuint) tuint) tuint))
                                    (Sdo (Eassign (Evar _exponent tint)
                                           (Ebinop Osub
                                             (Evalof (Evar _exponent tint)
                                               tint)
                                             (Ecast
                                               (Evalof (Evar _take tuint)
                                                 tuint) tint) tint) tint))))
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassign (Evar _take tuint)
                                           (Ecast
                                             (Ebinop Olt
                                               (Evalof (Evar _mantissa tuint)
                                                 tuint)
                                               (Eval (Vint (Int.repr 8388608)) tuint)
                                               tint) tuint) tuint))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _mantissa tuint)
                                             (Ebinop Oshl
                                               (Evalof (Evar _mantissa tuint)
                                                 tuint)
                                               (Evalof (Evar _take tuint)
                                                 tuint) tuint) tuint))
                                      (Sdo (Eassign (Evar _exponent tint)
                                             (Ebinop Osub
                                               (Evalof (Evar _exponent tint)
                                                 tint)
                                               (Ecast
                                                 (Evalof (Evar _take tuint)
                                                   tuint) tint) tint) tint))))
                                  (Ssequence
                                    (Ssequence
                                      (Sdo (Eassign (Evar _take tuint)
                                             (Ecast
                                               (Ebinop Olt
                                                 (Evalof
                                                   (Evar _mantissa tuint)
                                                   tuint)
                                                 (Eval (Vint (Int.repr 8388608)) tuint)
                                                 tint) tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _mantissa tuint)
                                               (Ebinop Oshl
                                                 (Evalof
                                                   (Evar _mantissa tuint)
                                                   tuint)
                                                 (Evalof (Evar _take tuint)
                                                   tuint) tuint) tuint))
                                        (Sdo (Eassign (Evar _exponent tint)
                                               (Ebinop Osub
                                                 (Evalof
                                                   (Evar _exponent tint)
                                                   tint)
                                                 (Ecast
                                                   (Evalof (Evar _take tuint)
                                                     tuint) tint) tint) tint))))
                                    (Ssequence
                                      (Ssequence
                                        (Sdo (Eassign (Evar _take tuint)
                                               (Ecast
                                                 (Ebinop Olt
                                                   (Evalof
                                                     (Evar _mantissa tuint)
                                                     tuint)
                                                   (Eval (Vint (Int.repr 8388608)) tuint)
                                                   tint) tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Evar _mantissa tuint)
                                                 (Ebinop Oshl
                                                   (Evalof
                                                     (Evar _mantissa tuint)
                                                     tuint)
                                                   (Evalof (Evar _take tuint)
                                                     tuint) tuint) tuint))
                                          (Sdo (Eassign (Evar _exponent tint)
                                                 (Ebinop Osub
                                                   (Evalof
                                                     (Evar _exponent tint)
                                                     tint)
                                                   (Ecast
                                                     (Evalof
                                                       (Evar _take tuint)
                                                       tuint) tint) tint)
                                                 tint))))
                                      (Ssequence
                                        (Ssequence
                                          (Sdo (Eassign (Evar _take tuint)
                                                 (Ecast
                                                   (Ebinop Olt
                                                     (Evalof
                                                       (Evar _mantissa tuint)
                                                       tuint)
                                                     (Eval (Vint (Int.repr 8388608)) tuint)
                                                     tint) tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Evar _mantissa tuint)
                                                   (Ebinop Oshl
                                                     (Evalof
                                                       (Evar _mantissa tuint)
                                                       tuint)
                                                     (Evalof
                                                       (Evar _take tuint)
                                                       tuint) tuint) tuint))
                                            (Sdo (Eassign
                                                   (Evar _exponent tint)
                                                   (Ebinop Osub
                                                     (Evalof
                                                       (Evar _exponent tint)
                                                       tint)
                                                     (Ecast
                                                       (Evalof
                                                         (Evar _take tuint)
                                                         tuint) tint) tint)
                                                   tint))))
                                        (Ssequence
                                          (Ssequence
                                            (Sdo (Eassign (Evar _take tuint)
                                                   (Ecast
                                                     (Ebinop Olt
                                                       (Evalof
                                                         (Evar _mantissa tuint)
                                                         tuint)
                                                       (Eval (Vint (Int.repr 8388608)) tuint)
                                                       tint) tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _mantissa tuint)
                                                     (Ebinop Oshl
                                                       (Evalof
                                                         (Evar _mantissa tuint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _take tuint)
                                                         tuint) tuint) tuint))
                                              (Sdo (Eassign
                                                     (Evar _exponent tint)
                                                     (Ebinop Osub
                                                       (Evalof
                                                         (Evar _exponent tint)
                                                         tint)
                                                       (Ecast
                                                         (Evalof
                                                           (Evar _take tuint)
                                                           tuint) tint) tint)
                                                     tint))))
                                          (Ssequence
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _take tuint)
                                                     (Ecast
                                                       (Ebinop Olt
                                                         (Evalof
                                                           (Evar _mantissa tuint)
                                                           tuint)
                                                         (Eval (Vint (Int.repr 8388608)) tuint)
                                                         tint) tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _mantissa tuint)
                                                       (Ebinop Oshl
                                                         (Evalof
                                                           (Evar _mantissa tuint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _take tuint)
                                                           tuint) tuint)
                                                       tuint))
                                                (Sdo (Eassign
                                                       (Evar _exponent tint)
                                                       (Ebinop Osub
                                                         (Evalof
                                                           (Evar _exponent tint)
                                                           tint)
                                                         (Ecast
                                                           (Evalof
                                                             (Evar _take tuint)
                                                             tuint) tint)
                                                         tint) tint))))
                                            (Ssequence
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _take tuint)
                                                       (Ecast
                                                         (Ebinop Olt
                                                           (Evalof
                                                             (Evar _mantissa tuint)
                                                             tuint)
                                                           (Eval (Vint (Int.repr 8388608)) tuint)
                                                           tint) tuint)
                                                       tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _mantissa tuint)
                                                         (Ebinop Oshl
                                                           (Evalof
                                                             (Evar _mantissa tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _take tuint)
                                                             tuint) tuint)
                                                         tuint))
                                                  (Sdo (Eassign
                                                         (Evar _exponent tint)
                                                         (Ebinop Osub
                                                           (Evalof
                                                             (Evar _exponent tint)
                                                             tint)
                                                           (Ecast
                                                             (Evalof
                                                               (Evar _take tuint)
                                                               tuint) tint)
                                                           tint) tint))))
                                              (Ssequence
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _take tuint)
                                                         (Ecast
                                                           (Ebinop Olt
                                                             (Evalof
                                                               (Evar _mantissa tuint)
                                                               tuint)
                                                             (Eval (Vint (Int.repr 8388608)) tuint)
                                                             tint) tuint)
                                                         tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _mantissa tuint)
                                                           (Ebinop Oshl
                                                             (Evalof
                                                               (Evar _mantissa tuint)
                                                               tuint)
                                                             (Evalof
                                                               (Evar _take tuint)
                                                               tuint) tuint)
                                                           tuint))
                                                    (Sdo (Eassign
                                                           (Evar _exponent tint)
                                                           (Ebinop Osub
                                                             (Evalof
                                                               (Evar _exponent tint)
                                                               tint)
                                                             (Ecast
                                                               (Evalof
                                                                 (Evar _take tuint)
                                                                 tuint) tint)
                                                             tint) tint))))
                                                (Ssequence
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _take tuint)
                                                           (Ecast
                                                             (Ebinop Olt
                                                               (Evalof
                                                                 (Evar _mantissa tuint)
                                                                 tuint)
                                                               (Eval (Vint (Int.repr 8388608)) tuint)
                                                               tint) tuint)
                                                           tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _mantissa tuint)
                                                             (Ebinop Oshl
                                                               (Evalof
                                                                 (Evar _mantissa tuint)
                                                                 tuint)
                                                               (Evalof
                                                                 (Evar _take tuint)
                                                                 tuint)
                                                               tuint) tuint))
                                                      (Sdo (Eassign
                                                             (Evar _exponent tint)
                                                             (Ebinop Osub
                                                               (Evalof
                                                                 (Evar _exponent tint)
                                                                 tint)
                                                               (Ecast
                                                                 (Evalof
                                                                   (Evar _take tuint)
                                                                   tuint)
                                                                 tint) tint)
                                                             tint))))
                                                  (Ssequence
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _take tuint)
                                                             (Ecast
                                                               (Ebinop Olt
                                                                 (Evalof
                                                                   (Evar _mantissa tuint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 8388608)) tuint)
                                                                 tint) tuint)
                                                             tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _mantissa tuint)
                                                               (Ebinop Oshl
                                                                 (Evalof
                                                                   (Evar _mantissa tuint)
                                                                   tuint)
                                                                 (Evalof
                                                                   (Evar _take tuint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Sdo (Eassign
                                                               (Evar _exponent tint)
                                                               (Ebinop Osub
                                                                 (Evalof
                                                                   (Evar _exponent tint)
                                                                   tint)
                                                                 (Ecast
                                                                   (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                   tint)
                                                                 tint) tint))))
                                                    (Ssequence
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _take tuint)
                                                               (Ecast
                                                                 (Ebinop Olt
                                                                   (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                   (Eval (Vint (Int.repr 8388608)) tuint)
                                                                   tint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _mantissa tuint)
                                                                 (Ebinop Oshl
                                                                   (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                   (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Sdo (Eassign
                                                                 (Evar _exponent tint)
                                                                 (Ebinop Osub
                                                                   (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                   (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                   tint)
                                                                 tint))))
                                                      (Ssequence
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _take tuint)
                                                                 (Ecast
                                                                   (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _mantissa tuint)
                                                                   (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Sdo (Eassign
                                                                   (Evar _exponent tint)
                                                                   (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                   tint))))
                                                        (Ssequence
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _take tuint)
                                                                   (Ecast
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _mantissa tuint)
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Sdo (Eassign
                                                                    (Evar _exponent tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint))))
                                                          (Ssequence
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _mantissa tuint)
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _exponent tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint))))
                                                            (Ssequence
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _mantissa tuint)
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _exponent tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint))))
                                                              (Ssequence
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mantissa tuint)
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _exponent tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint))))
                                                                (Ssequence
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mantissa tuint)
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _exponent tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint))))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388608)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mantissa tuint)
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _mantissa tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _exponent tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint)))))))))))))))))))))))))))
                    (Ssequence
                      (Sdo (Eassign (Evar _exponent tint)
                             (Ebinop Osub
                               (Ecast
                                 (Evalof (Evar _exponent_bits tuint) tuint)
                                 tint) (Eval (Vint (Int.repr 127)) tint)
                               tint) tint))
                      (Sdo (Eassign (Evar _mantissa tuint)
                             (Ebinop Oor
                               (Evalof (Evar _mantissa tuint) tuint)
                               (Eval (Vint (Int.repr 8388608)) tuint) tuint)
                             tuint))))
                  (Ssequence
                    (Sdo (Eassign (Evar _take tuint)
                           (Ecast
                             (Ebinop One
                               (Ebinop Omod
                                 (Evalof (Evar _exponent tint) tint)
                                 (Eval (Vint (Int.repr 2)) tint) tint)
                               (Eval (Vint (Int.repr 0)) tint) tint) tuint)
                           tuint))
                    (Ssequence
                      (Sdo (Eassign (Evar _mantissa tuint)
                             (Ebinop Oshl
                               (Evalof (Evar _mantissa tuint) tuint)
                               (Evalof (Evar _take tuint) tuint) tuint)
                             tuint))
                      (Ssequence
                        (Sdo (Eassign (Evar _exponent tint)
                               (Ebinop Osub
                                 (Evalof (Evar _exponent tint) tint)
                                 (Ecast (Evalof (Evar _take tuint) tuint)
                                   tint) tint) tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _radicand tulong)
                                 (Ebinop Oshl
                                   (Ecast
                                     (Evalof (Evar _mantissa tuint) tuint)
                                     tulong) (Eval (Vint (Int.repr 23)) tint)
                                   tulong) tulong))
                          (Ssequence
                            (Sdo (Eassign (Evar _remainder tuint)
                                   (Eval (Vint (Int.repr 0)) tuint) tuint))
                            (Ssequence
                              (Sdo (Eassign (Evar _root tuint)
                                     (Eval (Vint (Int.repr 0)) tuint) tuint))
                              (Ssequence
                                (Ssequence
                                  (Sdo (Eassign (Evar _pair tuint)
                                         (Ecast
                                           (Ebinop Oand
                                             (Ebinop Oshr
                                               (Evalof
                                                 (Evar _radicand tulong)
                                                 tulong)
                                               (Eval (Vint (Int.repr 46)) tint)
                                               tulong)
                                             (Eval (Vlong (Int64.repr 3)) tulong)
                                             tulong) tuint) tuint))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _remainder tuint)
                                           (Ebinop Oor
                                             (Ebinop Oshl
                                               (Evalof
                                                 (Evar _remainder tuint)
                                                 tuint)
                                               (Eval (Vint (Int.repr 2)) tint)
                                               tuint)
                                             (Evalof (Evar _pair tuint)
                                               tuint) tuint) tuint))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _trial tuint)
                                             (Ebinop Oor
                                               (Ebinop Oshl
                                                 (Evalof (Evar _root tuint)
                                                   tuint)
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 tuint)
                                               (Eval (Vint (Int.repr 1)) tuint)
                                               tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _take tuint)
                                               (Ecast
                                                 (Ebinop Oge
                                                   (Evalof
                                                     (Evar _remainder tuint)
                                                     tuint)
                                                   (Evalof
                                                     (Evar _trial tuint)
                                                     tuint) tint) tuint)
                                               tuint))
                                        (Ssequence
                                          (Sdo (Eassign (Evar _mask tuint)
                                                 (Ebinop Osub
                                                   (Eval (Vint (Int.repr 0)) tuint)
                                                   (Evalof (Evar _take tuint)
                                                     tuint) tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Evar _remainder tuint)
                                                   (Ebinop Osub
                                                     (Evalof
                                                       (Evar _remainder tuint)
                                                       tuint)
                                                     (Ebinop Oand
                                                       (Evalof
                                                         (Evar _trial tuint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _mask tuint)
                                                         tuint) tuint) tuint)
                                                   tuint))
                                            (Sdo (Eassign (Evar _root tuint)
                                                   (Ebinop Oor
                                                     (Ebinop Oshl
                                                       (Evalof
                                                         (Evar _root tuint)
                                                         tuint)
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       tuint)
                                                     (Evalof
                                                       (Evar _take tuint)
                                                       tuint) tuint) tuint))))))))
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassign (Evar _pair tuint)
                                           (Ecast
                                             (Ebinop Oand
                                               (Ebinop Oshr
                                                 (Evalof
                                                   (Evar _radicand tulong)
                                                   tulong)
                                                 (Eval (Vint (Int.repr 44)) tint)
                                                 tulong)
                                               (Eval (Vlong (Int64.repr 3)) tulong)
                                               tulong) tuint) tuint))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _remainder tuint)
                                             (Ebinop Oor
                                               (Ebinop Oshl
                                                 (Evalof
                                                   (Evar _remainder tuint)
                                                   tuint)
                                                 (Eval (Vint (Int.repr 2)) tint)
                                                 tuint)
                                               (Evalof (Evar _pair tuint)
                                                 tuint) tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _trial tuint)
                                               (Ebinop Oor
                                                 (Ebinop Oshl
                                                   (Evalof (Evar _root tuint)
                                                     tuint)
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   tuint)
                                                 (Eval (Vint (Int.repr 1)) tuint)
                                                 tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign (Evar _take tuint)
                                                 (Ecast
                                                   (Ebinop Oge
                                                     (Evalof
                                                       (Evar _remainder tuint)
                                                       tuint)
                                                     (Evalof
                                                       (Evar _trial tuint)
                                                       tuint) tint) tuint)
                                                 tuint))
                                          (Ssequence
                                            (Sdo (Eassign (Evar _mask tuint)
                                                   (Ebinop Osub
                                                     (Eval (Vint (Int.repr 0)) tuint)
                                                     (Evalof
                                                       (Evar _take tuint)
                                                       tuint) tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _remainder tuint)
                                                     (Ebinop Osub
                                                       (Evalof
                                                         (Evar _remainder tuint)
                                                         tuint)
                                                       (Ebinop Oand
                                                         (Evalof
                                                           (Evar _trial tuint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _mask tuint)
                                                           tuint) tuint)
                                                       tuint) tuint))
                                              (Sdo (Eassign
                                                     (Evar _root tuint)
                                                     (Ebinop Oor
                                                       (Ebinop Oshl
                                                         (Evalof
                                                           (Evar _root tuint)
                                                           tuint)
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _take tuint)
                                                         tuint) tuint) tuint))))))))
                                  (Ssequence
                                    (Ssequence
                                      (Sdo (Eassign (Evar _pair tuint)
                                             (Ecast
                                               (Ebinop Oand
                                                 (Ebinop Oshr
                                                   (Evalof
                                                     (Evar _radicand tulong)
                                                     tulong)
                                                   (Eval (Vint (Int.repr 42)) tint)
                                                   tulong)
                                                 (Eval (Vlong (Int64.repr 3)) tulong)
                                                 tulong) tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _remainder tuint)
                                               (Ebinop Oor
                                                 (Ebinop Oshl
                                                   (Evalof
                                                     (Evar _remainder tuint)
                                                     tuint)
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   tuint)
                                                 (Evalof (Evar _pair tuint)
                                                   tuint) tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign (Evar _trial tuint)
                                                 (Ebinop Oor
                                                   (Ebinop Oshl
                                                     (Evalof
                                                       (Evar _root tuint)
                                                       tuint)
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     tuint)
                                                   (Eval (Vint (Int.repr 1)) tuint)
                                                   tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign (Evar _take tuint)
                                                   (Ecast
                                                     (Ebinop Oge
                                                       (Evalof
                                                         (Evar _remainder tuint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _trial tuint)
                                                         tuint) tint) tuint)
                                                   tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _mask tuint)
                                                     (Ebinop Osub
                                                       (Eval (Vint (Int.repr 0)) tuint)
                                                       (Evalof
                                                         (Evar _take tuint)
                                                         tuint) tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _remainder tuint)
                                                       (Ebinop Osub
                                                         (Evalof
                                                           (Evar _remainder tuint)
                                                           tuint)
                                                         (Ebinop Oand
                                                           (Evalof
                                                             (Evar _trial tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _mask tuint)
                                                             tuint) tuint)
                                                         tuint) tuint))
                                                (Sdo (Eassign
                                                       (Evar _root tuint)
                                                       (Ebinop Oor
                                                         (Ebinop Oshl
                                                           (Evalof
                                                             (Evar _root tuint)
                                                             tuint)
                                                           (Eval (Vint (Int.repr 1)) tint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _take tuint)
                                                           tuint) tuint)
                                                       tuint))))))))
                                    (Ssequence
                                      (Ssequence
                                        (Sdo (Eassign (Evar _pair tuint)
                                               (Ecast
                                                 (Ebinop Oand
                                                   (Ebinop Oshr
                                                     (Evalof
                                                       (Evar _radicand tulong)
                                                       tulong)
                                                     (Eval (Vint (Int.repr 40)) tint)
                                                     tulong)
                                                   (Eval (Vlong (Int64.repr 3)) tulong)
                                                   tulong) tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Evar _remainder tuint)
                                                 (Ebinop Oor
                                                   (Ebinop Oshl
                                                     (Evalof
                                                       (Evar _remainder tuint)
                                                       tuint)
                                                     (Eval (Vint (Int.repr 2)) tint)
                                                     tuint)
                                                   (Evalof (Evar _pair tuint)
                                                     tuint) tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign (Evar _trial tuint)
                                                   (Ebinop Oor
                                                     (Ebinop Oshl
                                                       (Evalof
                                                         (Evar _root tuint)
                                                         tuint)
                                                       (Eval (Vint (Int.repr 2)) tint)
                                                       tuint)
                                                     (Eval (Vint (Int.repr 1)) tuint)
                                                     tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _take tuint)
                                                     (Ecast
                                                       (Ebinop Oge
                                                         (Evalof
                                                           (Evar _remainder tuint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _trial tuint)
                                                           tuint) tint)
                                                       tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _mask tuint)
                                                       (Ebinop Osub
                                                         (Eval (Vint (Int.repr 0)) tuint)
                                                         (Evalof
                                                           (Evar _take tuint)
                                                           tuint) tuint)
                                                       tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _remainder tuint)
                                                         (Ebinop Osub
                                                           (Evalof
                                                             (Evar _remainder tuint)
                                                             tuint)
                                                           (Ebinop Oand
                                                             (Evalof
                                                               (Evar _trial tuint)
                                                               tuint)
                                                             (Evalof
                                                               (Evar _mask tuint)
                                                               tuint) tuint)
                                                           tuint) tuint))
                                                  (Sdo (Eassign
                                                         (Evar _root tuint)
                                                         (Ebinop Oor
                                                           (Ebinop Oshl
                                                             (Evalof
                                                               (Evar _root tuint)
                                                               tuint)
                                                             (Eval (Vint (Int.repr 1)) tint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _take tuint)
                                                             tuint) tuint)
                                                         tuint))))))))
                                      (Ssequence
                                        (Ssequence
                                          (Sdo (Eassign (Evar _pair tuint)
                                                 (Ecast
                                                   (Ebinop Oand
                                                     (Ebinop Oshr
                                                       (Evalof
                                                         (Evar _radicand tulong)
                                                         tulong)
                                                       (Eval (Vint (Int.repr 38)) tint)
                                                       tulong)
                                                     (Eval (Vlong (Int64.repr 3)) tulong)
                                                     tulong) tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Evar _remainder tuint)
                                                   (Ebinop Oor
                                                     (Ebinop Oshl
                                                       (Evalof
                                                         (Evar _remainder tuint)
                                                         tuint)
                                                       (Eval (Vint (Int.repr 2)) tint)
                                                       tuint)
                                                     (Evalof
                                                       (Evar _pair tuint)
                                                       tuint) tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _trial tuint)
                                                     (Ebinop Oor
                                                       (Ebinop Oshl
                                                         (Evalof
                                                           (Evar _root tuint)
                                                           tuint)
                                                         (Eval (Vint (Int.repr 2)) tint)
                                                         tuint)
                                                       (Eval (Vint (Int.repr 1)) tuint)
                                                       tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _take tuint)
                                                       (Ecast
                                                         (Ebinop Oge
                                                           (Evalof
                                                             (Evar _remainder tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _trial tuint)
                                                             tuint) tint)
                                                         tuint) tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _mask tuint)
                                                         (Ebinop Osub
                                                           (Eval (Vint (Int.repr 0)) tuint)
                                                           (Evalof
                                                             (Evar _take tuint)
                                                             tuint) tuint)
                                                         tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _remainder tuint)
                                                           (Ebinop Osub
                                                             (Evalof
                                                               (Evar _remainder tuint)
                                                               tuint)
                                                             (Ebinop Oand
                                                               (Evalof
                                                                 (Evar _trial tuint)
                                                                 tuint)
                                                               (Evalof
                                                                 (Evar _mask tuint)
                                                                 tuint)
                                                               tuint) tuint)
                                                           tuint))
                                                    (Sdo (Eassign
                                                           (Evar _root tuint)
                                                           (Ebinop Oor
                                                             (Ebinop Oshl
                                                               (Evalof
                                                                 (Evar _root tuint)
                                                                 tuint)
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               tuint)
                                                             (Evalof
                                                               (Evar _take tuint)
                                                               tuint) tuint)
                                                           tuint))))))))
                                        (Ssequence
                                          (Ssequence
                                            (Sdo (Eassign (Evar _pair tuint)
                                                   (Ecast
                                                     (Ebinop Oand
                                                       (Ebinop Oshr
                                                         (Evalof
                                                           (Evar _radicand tulong)
                                                           tulong)
                                                         (Eval (Vint (Int.repr 36)) tint)
                                                         tulong)
                                                       (Eval (Vlong (Int64.repr 3)) tulong)
                                                       tulong) tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _remainder tuint)
                                                     (Ebinop Oor
                                                       (Ebinop Oshl
                                                         (Evalof
                                                           (Evar _remainder tuint)
                                                           tuint)
                                                         (Eval (Vint (Int.repr 2)) tint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _pair tuint)
                                                         tuint) tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _trial tuint)
                                                       (Ebinop Oor
                                                         (Ebinop Oshl
                                                           (Evalof
                                                             (Evar _root tuint)
                                                             tuint)
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           tuint)
                                                         (Eval (Vint (Int.repr 1)) tuint)
                                                         tuint) tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _take tuint)
                                                         (Ecast
                                                           (Ebinop Oge
                                                             (Evalof
                                                               (Evar _remainder tuint)
                                                               tuint)
                                                             (Evalof
                                                               (Evar _trial tuint)
                                                               tuint) tint)
                                                           tuint) tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _mask tuint)
                                                           (Ebinop Osub
                                                             (Eval (Vint (Int.repr 0)) tuint)
                                                             (Evalof
                                                               (Evar _take tuint)
                                                               tuint) tuint)
                                                           tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _remainder tuint)
                                                             (Ebinop Osub
                                                               (Evalof
                                                                 (Evar _remainder tuint)
                                                                 tuint)
                                                               (Ebinop Oand
                                                                 (Evalof
                                                                   (Evar _trial tuint)
                                                                   tuint)
                                                                 (Evalof
                                                                   (Evar _mask tuint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint) tuint))
                                                      (Sdo (Eassign
                                                             (Evar _root tuint)
                                                             (Ebinop Oor
                                                               (Ebinop Oshl
                                                                 (Evalof
                                                                   (Evar _root tuint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 tuint)
                                                               (Evalof
                                                                 (Evar _take tuint)
                                                                 tuint)
                                                               tuint) tuint))))))))
                                          (Ssequence
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _pair tuint)
                                                     (Ecast
                                                       (Ebinop Oand
                                                         (Ebinop Oshr
                                                           (Evalof
                                                             (Evar _radicand tulong)
                                                             tulong)
                                                           (Eval (Vint (Int.repr 34)) tint)
                                                           tulong)
                                                         (Eval (Vlong (Int64.repr 3)) tulong)
                                                         tulong) tuint)
                                                     tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _remainder tuint)
                                                       (Ebinop Oor
                                                         (Ebinop Oshl
                                                           (Evalof
                                                             (Evar _remainder tuint)
                                                             tuint)
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _pair tuint)
                                                           tuint) tuint)
                                                       tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _trial tuint)
                                                         (Ebinop Oor
                                                           (Ebinop Oshl
                                                             (Evalof
                                                               (Evar _root tuint)
                                                               tuint)
                                                             (Eval (Vint (Int.repr 2)) tint)
                                                             tuint)
                                                           (Eval (Vint (Int.repr 1)) tuint)
                                                           tuint) tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _take tuint)
                                                           (Ecast
                                                             (Ebinop Oge
                                                               (Evalof
                                                                 (Evar _remainder tuint)
                                                                 tuint)
                                                               (Evalof
                                                                 (Evar _trial tuint)
                                                                 tuint) tint)
                                                             tuint) tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _mask tuint)
                                                             (Ebinop Osub
                                                               (Eval (Vint (Int.repr 0)) tuint)
                                                               (Evalof
                                                                 (Evar _take tuint)
                                                                 tuint)
                                                               tuint) tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _remainder tuint)
                                                               (Ebinop Osub
                                                                 (Evalof
                                                                   (Evar _remainder tuint)
                                                                   tuint)
                                                                 (Ebinop Oand
                                                                   (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                   (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Sdo (Eassign
                                                               (Evar _root tuint)
                                                               (Ebinop Oor
                                                                 (Ebinop Oshl
                                                                   (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   tuint)
                                                                 (Evalof
                                                                   (Evar _take tuint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint))))))))
                                            (Ssequence
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _pair tuint)
                                                       (Ecast
                                                         (Ebinop Oand
                                                           (Ebinop Oshr
                                                             (Evalof
                                                               (Evar _radicand tulong)
                                                               tulong)
                                                             (Eval (Vint (Int.repr 32)) tint)
                                                             tulong)
                                                           (Eval (Vlong (Int64.repr 3)) tulong)
                                                           tulong) tuint)
                                                       tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _remainder tuint)
                                                         (Ebinop Oor
                                                           (Ebinop Oshl
                                                             (Evalof
                                                               (Evar _remainder tuint)
                                                               tuint)
                                                             (Eval (Vint (Int.repr 2)) tint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _pair tuint)
                                                             tuint) tuint)
                                                         tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _trial tuint)
                                                           (Ebinop Oor
                                                             (Ebinop Oshl
                                                               (Evalof
                                                                 (Evar _root tuint)
                                                                 tuint)
                                                               (Eval (Vint (Int.repr 2)) tint)
                                                               tuint)
                                                             (Eval (Vint (Int.repr 1)) tuint)
                                                             tuint) tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _take tuint)
                                                             (Ecast
                                                               (Ebinop Oge
                                                                 (Evalof
                                                                   (Evar _remainder tuint)
                                                                   tuint)
                                                                 (Evalof
                                                                   (Evar _trial tuint)
                                                                   tuint)
                                                                 tint) tuint)
                                                             tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _mask tuint)
                                                               (Ebinop Osub
                                                                 (Eval (Vint (Int.repr 0)) tuint)
                                                                 (Evalof
                                                                   (Evar _take tuint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _remainder tuint)
                                                                 (Ebinop Osub
                                                                   (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                   (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Sdo (Eassign
                                                                 (Evar _root tuint)
                                                                 (Ebinop Oor
                                                                   (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                   (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint))))))))
                                              (Ssequence
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _pair tuint)
                                                         (Ecast
                                                           (Ebinop Oand
                                                             (Ebinop Oshr
                                                               (Evalof
                                                                 (Evar _radicand tulong)
                                                                 tulong)
                                                               (Eval (Vint (Int.repr 30)) tint)
                                                               tulong)
                                                             (Eval (Vlong (Int64.repr 3)) tulong)
                                                             tulong) tuint)
                                                         tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _remainder tuint)
                                                           (Ebinop Oor
                                                             (Ebinop Oshl
                                                               (Evalof
                                                                 (Evar _remainder tuint)
                                                                 tuint)
                                                               (Eval (Vint (Int.repr 2)) tint)
                                                               tuint)
                                                             (Evalof
                                                               (Evar _pair tuint)
                                                               tuint) tuint)
                                                           tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _trial tuint)
                                                             (Ebinop Oor
                                                               (Ebinop Oshl
                                                                 (Evalof
                                                                   (Evar _root tuint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 2)) tint)
                                                                 tuint)
                                                               (Eval (Vint (Int.repr 1)) tuint)
                                                               tuint) tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _take tuint)
                                                               (Ecast
                                                                 (Ebinop Oge
                                                                   (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                   (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                   tint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _mask tuint)
                                                                 (Ebinop Osub
                                                                   (Eval (Vint (Int.repr 0)) tuint)
                                                                   (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _remainder tuint)
                                                                   (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Sdo (Eassign
                                                                   (Evar _root tuint)
                                                                   (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint))))))))
                                                (Ssequence
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _pair tuint)
                                                           (Ecast
                                                             (Ebinop Oand
                                                               (Ebinop Oshr
                                                                 (Evalof
                                                                   (Evar _radicand tulong)
                                                                   tulong)
                                                                 (Eval (Vint (Int.repr 28)) tint)
                                                                 tulong)
                                                               (Eval (Vlong (Int64.repr 3)) tulong)
                                                               tulong) tuint)
                                                           tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _remainder tuint)
                                                             (Ebinop Oor
                                                               (Ebinop Oshl
                                                                 (Evalof
                                                                   (Evar _remainder tuint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 2)) tint)
                                                                 tuint)
                                                               (Evalof
                                                                 (Evar _pair tuint)
                                                                 tuint)
                                                               tuint) tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _trial tuint)
                                                               (Ebinop Oor
                                                                 (Ebinop Oshl
                                                                   (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                   (Eval (Vint (Int.repr 2)) tint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 1)) tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _take tuint)
                                                                 (Ecast
                                                                   (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _mask tuint)
                                                                   (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Sdo (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                  (Ssequence
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _pair tuint)
                                                             (Ecast
                                                               (Ebinop Oand
                                                                 (Ebinop Oshr
                                                                   (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                   (Eval (Vint (Int.repr 26)) tint)
                                                                   tulong)
                                                                 (Eval (Vlong (Int64.repr 3)) tulong)
                                                                 tulong)
                                                               tuint) tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _remainder tuint)
                                                               (Ebinop Oor
                                                                 (Ebinop Oshl
                                                                   (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                   (Eval (Vint (Int.repr 2)) tint)
                                                                   tuint)
                                                                 (Evalof
                                                                   (Evar _pair tuint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _trial tuint)
                                                                 (Ebinop Oor
                                                                   (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                   (Eval (Vint (Int.repr 1)) tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _take tuint)
                                                                   (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                    (Ssequence
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _pair tuint)
                                                               (Ecast
                                                                 (Ebinop Oand
                                                                   (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 24)) tint)
                                                                    tulong)
                                                                   (Eval (Vlong (Int64.repr 3)) tulong)
                                                                   tulong)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _remainder tuint)
                                                                 (Ebinop Oor
                                                                   (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                   (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _trial tuint)
                                                                   (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                      (Ssequence
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _pair tuint)
                                                                 (Ecast
                                                                   (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 22)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _remainder tuint)
                                                                   (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                        (Ssequence
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _pair tuint)
                                                                   (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 20)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                          (Ssequence
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 18)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                            (Ssequence
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 16)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                              (Ssequence
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 14)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                (Ssequence
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 12)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                  (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 10)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 8)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 6)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 4)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _pair tuint)
                                                                    (Ecast
                                                                    (Ebinop Oand
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _radicand tulong)
                                                                    tulong)
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    tulong)
                                                                    (Eval (Vlong (Int64.repr 3)) tulong)
                                                                    tulong)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _pair tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _trial tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mask tuint)
                                                                    (Ebinop Osub
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _remainder tuint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _trial tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _mask tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))))))))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Ogt
                                                                    (Evalof
                                                                    (Evar _remainder tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _result_exponent tint)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Odiv
                                                                    (Evalof
                                                                    (Evar _exponent tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 127)) tint)
                                                                    tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _take tuint)
                                                                    (Ecast
                                                                    (Ebinop Oeq
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 16777216)) tuint)
                                                                    tint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _root tuint)
                                                                    (Ebinop Oshr
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _result_exponent tint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _result_exponent tint)
                                                                    tint)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _take tuint)
                                                                    tuint)
                                                                    tint)
                                                                    tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Ebinop Oor
                                                                    (Ebinop Oshl
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Evar _result_exponent tint)
                                                                    tint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 23)) tint)
                                                                    tuint)
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _root tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 8388607)) tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sreturn (Some 
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)))))))))))))))))))))))))))))))))))))))))))))))))
|}.

Definition f_probe := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _five_sqrtf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _x tfloat) tfloat) Enil) tfloat)))
|}.

Definition composites : list composite_definition :=
(Composite _FiveSqrtBits Union
   (Member_plain _f tfloat :: Member_plain _u tuint :: nil)
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
 (_five_sqrtf, Gfun(Internal f_five_sqrtf)) ::
 (_probe, Gfun(Internal f_probe)) :: nil).

Definition public_idents : list ident :=
(_probe :: ___builtin_debug :: ___builtin_write32_reversed ::
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


