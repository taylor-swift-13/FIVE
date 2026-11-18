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
  Definition source_file := "/home/yangfp/five/paparazzi/models/gh_update_ref_from_speed_sp/align/model/preprocessed.i".
End Info.

Definition _FiveSqrtBits : ident := $"FiveSqrtBits".
Definition _FloatVect2 : ident := $"FloatVect2".
Definition _GuidanceHRef : ident := $"GuidanceHRef".
Definition _Int64Vect2 : ident := $"Int64Vect2".
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
Definition _a_norm2 : ident := $"a_norm2".
Definition _accel : ident := $"accel".
Definition _accel_sp : ident := $"accel_sp".
Definition _candidate : ident := $"candidate".
Definition _dt : ident := $"dt".
Definition _f : ident := $"f".
Definition _factor : ident := $"factor".
Definition _five_sqrtf : ident := $"five_sqrtf".
Definition _gh_max_accel : ident := $"gh_max_accel".
Definition _gh_ref : ident := $"gh_ref".
Definition _gh_saturate_accel : ident := $"gh_saturate_accel".
Definition _gh_update_ref_from_speed_sp : ident := $"gh_update_ref_from_speed_sp".
Definition _hi : ident := $"hi".
Definition _inv_tau : ident := $"inv_tau".
Definition _lo : ident := $"lo".
Definition _lower : ident := $"lower".
Definition _magnitude : ident := $"magnitude".
Definition _main : ident := $"main".
Definition _max_speed : ident := $"max_speed".
Definition _mid : ident := $"mid".
Definition _midpoint : ident := $"midpoint".
Definition _midpoint_square : ident := $"midpoint_square".
Definition _omega : ident := $"omega".
Definition _omega_2 : ident := $"omega_2".
Definition _pos : ident := $"pos".
Definition _pos_step : ident := $"pos_step".
Definition _pos_update : ident := $"pos_update".
Definition _speed : ident := $"speed".
Definition _speed_err : ident := $"speed_err".
Definition _speed_sp : ident := $"speed_sp".
Definition _speed_step : ident := $"speed_step".
Definition _target : ident := $"target".
Definition _tau : ident := $"tau".
Definition _u : ident := $"u".
Definition _upper : ident := $"upper".
Definition _view : ident := $"view".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _zeta : ident := $"zeta".
Definition _zeta_omega : ident := $"zeta_omega".

Definition f_five_sqrtf := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: nil);
  fn_vars := ((_view, (Tunion _FiveSqrtBits noattr)) ::
              (_magnitude, tuint) :: (_lo, tuint) :: (_hi, tuint) ::
              (_mid, tuint) :: (_candidate, tdouble) :: (_target, tdouble) ::
              (_lower, tdouble) :: (_upper, tdouble) ::
              (_midpoint, tdouble) :: (_midpoint_square, tdouble) :: nil);
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
              (Sdo (Eassign (Evar _target tdouble)
                     (Ecast (Evalof (Evar _x tfloat) tfloat) tdouble)
                     tdouble))
              (Ssequence
                (Sdo (Eassign (Evar _lo tuint)
                       (Eval (Vint (Int.repr 0)) tuint) tuint))
                (Ssequence
                  (Sdo (Eassign (Evar _hi tuint)
                         (Eval (Vint (Int.repr 2139095040)) tuint) tuint))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassign (Evar _mid tuint)
                             (Ebinop Oadd (Evalof (Evar _lo tuint) tuint)
                               (Ebinop Oshr
                                 (Ebinop Osub (Evalof (Evar _hi tuint) tuint)
                                   (Evalof (Evar _lo tuint) tuint) tuint)
                                 (Eval (Vint (Int.repr 1)) tint) tuint)
                               tuint) tuint))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Evar _view (Tunion _FiveSqrtBits noattr))
                                   (Tunion _FiveSqrtBits noattr)) _u tuint)
                               (Evalof (Evar _mid tuint) tuint) tuint))
                        (Ssequence
                          (Sdo (Eassign (Evar _candidate tdouble)
                                 (Ecast
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Evar _view (Tunion _FiveSqrtBits noattr))
                                         (Tunion _FiveSqrtBits noattr)) _f
                                       tfloat) tfloat) tdouble) tdouble))
                          (Sifthenelse (Ebinop Ole
                                         (Ebinop Omul
                                           (Evalof (Evar _candidate tdouble)
                                             tdouble)
                                           (Evalof (Evar _candidate tdouble)
                                             tdouble) tdouble)
                                         (Evalof (Evar _target tdouble)
                                           tdouble) tint)
                            (Sdo (Eassign (Evar _lo tuint)
                                   (Evalof (Evar _mid tuint) tuint) tuint))
                            (Sdo (Eassign (Evar _hi tuint)
                                   (Evalof (Evar _mid tuint) tuint) tuint))))))
                    (Ssequence
                      (Ssequence
                        (Sdo (Eassign (Evar _mid tuint)
                               (Ebinop Oadd (Evalof (Evar _lo tuint) tuint)
                                 (Ebinop Oshr
                                   (Ebinop Osub
                                     (Evalof (Evar _hi tuint) tuint)
                                     (Evalof (Evar _lo tuint) tuint) tuint)
                                   (Eval (Vint (Int.repr 1)) tint) tuint)
                                 tuint) tuint))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Evar _view (Tunion _FiveSqrtBits noattr))
                                     (Tunion _FiveSqrtBits noattr)) _u tuint)
                                 (Evalof (Evar _mid tuint) tuint) tuint))
                          (Ssequence
                            (Sdo (Eassign (Evar _candidate tdouble)
                                   (Ecast
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Evar _view (Tunion _FiveSqrtBits noattr))
                                           (Tunion _FiveSqrtBits noattr)) _f
                                         tfloat) tfloat) tdouble) tdouble))
                            (Sifthenelse (Ebinop Ole
                                           (Ebinop Omul
                                             (Evalof
                                               (Evar _candidate tdouble)
                                               tdouble)
                                             (Evalof
                                               (Evar _candidate tdouble)
                                               tdouble) tdouble)
                                           (Evalof (Evar _target tdouble)
                                             tdouble) tint)
                              (Sdo (Eassign (Evar _lo tuint)
                                     (Evalof (Evar _mid tuint) tuint) tuint))
                              (Sdo (Eassign (Evar _hi tuint)
                                     (Evalof (Evar _mid tuint) tuint) tuint))))))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign (Evar _mid tuint)
                                 (Ebinop Oadd (Evalof (Evar _lo tuint) tuint)
                                   (Ebinop Oshr
                                     (Ebinop Osub
                                       (Evalof (Evar _hi tuint) tuint)
                                       (Evalof (Evar _lo tuint) tuint) tuint)
                                     (Eval (Vint (Int.repr 1)) tint) tuint)
                                   tuint) tuint))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _view (Tunion _FiveSqrtBits noattr))
                                       (Tunion _FiveSqrtBits noattr)) _u
                                     tuint) (Evalof (Evar _mid tuint) tuint)
                                   tuint))
                            (Ssequence
                              (Sdo (Eassign (Evar _candidate tdouble)
                                     (Ecast
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Evar _view (Tunion _FiveSqrtBits noattr))
                                             (Tunion _FiveSqrtBits noattr))
                                           _f tfloat) tfloat) tdouble)
                                     tdouble))
                              (Sifthenelse (Ebinop Ole
                                             (Ebinop Omul
                                               (Evalof
                                                 (Evar _candidate tdouble)
                                                 tdouble)
                                               (Evalof
                                                 (Evar _candidate tdouble)
                                                 tdouble) tdouble)
                                             (Evalof (Evar _target tdouble)
                                               tdouble) tint)
                                (Sdo (Eassign (Evar _lo tuint)
                                       (Evalof (Evar _mid tuint) tuint)
                                       tuint))
                                (Sdo (Eassign (Evar _hi tuint)
                                       (Evalof (Evar _mid tuint) tuint)
                                       tuint))))))
                        (Ssequence
                          (Ssequence
                            (Sdo (Eassign (Evar _mid tuint)
                                   (Ebinop Oadd
                                     (Evalof (Evar _lo tuint) tuint)
                                     (Ebinop Oshr
                                       (Ebinop Osub
                                         (Evalof (Evar _hi tuint) tuint)
                                         (Evalof (Evar _lo tuint) tuint)
                                         tuint)
                                       (Eval (Vint (Int.repr 1)) tint) tuint)
                                     tuint) tuint))
                            (Ssequence
                              (Sdo (Eassign
                                     (Efield
                                       (Evalof
                                         (Evar _view (Tunion _FiveSqrtBits noattr))
                                         (Tunion _FiveSqrtBits noattr)) _u
                                       tuint)
                                     (Evalof (Evar _mid tuint) tuint) tuint))
                              (Ssequence
                                (Sdo (Eassign (Evar _candidate tdouble)
                                       (Ecast
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Evar _view (Tunion _FiveSqrtBits noattr))
                                               (Tunion _FiveSqrtBits noattr))
                                             _f tfloat) tfloat) tdouble)
                                       tdouble))
                                (Sifthenelse (Ebinop Ole
                                               (Ebinop Omul
                                                 (Evalof
                                                   (Evar _candidate tdouble)
                                                   tdouble)
                                                 (Evalof
                                                   (Evar _candidate tdouble)
                                                   tdouble) tdouble)
                                               (Evalof (Evar _target tdouble)
                                                 tdouble) tint)
                                  (Sdo (Eassign (Evar _lo tuint)
                                         (Evalof (Evar _mid tuint) tuint)
                                         tuint))
                                  (Sdo (Eassign (Evar _hi tuint)
                                         (Evalof (Evar _mid tuint) tuint)
                                         tuint))))))
                          (Ssequence
                            (Ssequence
                              (Sdo (Eassign (Evar _mid tuint)
                                     (Ebinop Oadd
                                       (Evalof (Evar _lo tuint) tuint)
                                       (Ebinop Oshr
                                         (Ebinop Osub
                                           (Evalof (Evar _hi tuint) tuint)
                                           (Evalof (Evar _lo tuint) tuint)
                                           tuint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tuint) tuint) tuint))
                              (Ssequence
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Evar _view (Tunion _FiveSqrtBits noattr))
                                           (Tunion _FiveSqrtBits noattr)) _u
                                         tuint)
                                       (Evalof (Evar _mid tuint) tuint)
                                       tuint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _candidate tdouble)
                                         (Ecast
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Evar _view (Tunion _FiveSqrtBits noattr))
                                                 (Tunion _FiveSqrtBits noattr))
                                               _f tfloat) tfloat) tdouble)
                                         tdouble))
                                  (Sifthenelse (Ebinop Ole
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _candidate tdouble)
                                                     tdouble)
                                                   (Evalof
                                                     (Evar _candidate tdouble)
                                                     tdouble) tdouble)
                                                 (Evalof
                                                   (Evar _target tdouble)
                                                   tdouble) tint)
                                    (Sdo (Eassign (Evar _lo tuint)
                                           (Evalof (Evar _mid tuint) tuint)
                                           tuint))
                                    (Sdo (Eassign (Evar _hi tuint)
                                           (Evalof (Evar _mid tuint) tuint)
                                           tuint))))))
                            (Ssequence
                              (Ssequence
                                (Sdo (Eassign (Evar _mid tuint)
                                       (Ebinop Oadd
                                         (Evalof (Evar _lo tuint) tuint)
                                         (Ebinop Oshr
                                           (Ebinop Osub
                                             (Evalof (Evar _hi tuint) tuint)
                                             (Evalof (Evar _lo tuint) tuint)
                                             tuint)
                                           (Eval (Vint (Int.repr 1)) tint)
                                           tuint) tuint) tuint))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Evar _view (Tunion _FiveSqrtBits noattr))
                                             (Tunion _FiveSqrtBits noattr))
                                           _u tuint)
                                         (Evalof (Evar _mid tuint) tuint)
                                         tuint))
                                  (Ssequence
                                    (Sdo (Eassign (Evar _candidate tdouble)
                                           (Ecast
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Evar _view (Tunion _FiveSqrtBits noattr))
                                                   (Tunion _FiveSqrtBits noattr))
                                                 _f tfloat) tfloat) tdouble)
                                           tdouble))
                                    (Sifthenelse (Ebinop Ole
                                                   (Ebinop Omul
                                                     (Evalof
                                                       (Evar _candidate tdouble)
                                                       tdouble)
                                                     (Evalof
                                                       (Evar _candidate tdouble)
                                                       tdouble) tdouble)
                                                   (Evalof
                                                     (Evar _target tdouble)
                                                     tdouble) tint)
                                      (Sdo (Eassign (Evar _lo tuint)
                                             (Evalof (Evar _mid tuint) tuint)
                                             tuint))
                                      (Sdo (Eassign (Evar _hi tuint)
                                             (Evalof (Evar _mid tuint) tuint)
                                             tuint))))))
                              (Ssequence
                                (Ssequence
                                  (Sdo (Eassign (Evar _mid tuint)
                                         (Ebinop Oadd
                                           (Evalof (Evar _lo tuint) tuint)
                                           (Ebinop Oshr
                                             (Ebinop Osub
                                               (Evalof (Evar _hi tuint)
                                                 tuint)
                                               (Evalof (Evar _lo tuint)
                                                 tuint) tuint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tuint) tuint) tuint))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Evar _view (Tunion _FiveSqrtBits noattr))
                                               (Tunion _FiveSqrtBits noattr))
                                             _u tuint)
                                           (Evalof (Evar _mid tuint) tuint)
                                           tuint))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _candidate tdouble)
                                             (Ecast
                                               (Evalof
                                                 (Efield
                                                   (Evalof
                                                     (Evar _view (Tunion _FiveSqrtBits noattr))
                                                     (Tunion _FiveSqrtBits noattr))
                                                   _f tfloat) tfloat)
                                               tdouble) tdouble))
                                      (Sifthenelse (Ebinop Ole
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _candidate tdouble)
                                                         tdouble)
                                                       (Evalof
                                                         (Evar _candidate tdouble)
                                                         tdouble) tdouble)
                                                     (Evalof
                                                       (Evar _target tdouble)
                                                       tdouble) tint)
                                        (Sdo (Eassign (Evar _lo tuint)
                                               (Evalof (Evar _mid tuint)
                                                 tuint) tuint))
                                        (Sdo (Eassign (Evar _hi tuint)
                                               (Evalof (Evar _mid tuint)
                                                 tuint) tuint))))))
                                (Ssequence
                                  (Ssequence
                                    (Sdo (Eassign (Evar _mid tuint)
                                           (Ebinop Oadd
                                             (Evalof (Evar _lo tuint) tuint)
                                             (Ebinop Oshr
                                               (Ebinop Osub
                                                 (Evalof (Evar _hi tuint)
                                                   tuint)
                                                 (Evalof (Evar _lo tuint)
                                                   tuint) tuint)
                                               (Eval (Vint (Int.repr 1)) tint)
                                               tuint) tuint) tuint))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _view (Tunion _FiveSqrtBits noattr))
                                                 (Tunion _FiveSqrtBits noattr))
                                               _u tuint)
                                             (Evalof (Evar _mid tuint) tuint)
                                             tuint))
                                      (Ssequence
                                        (Sdo (Eassign
                                               (Evar _candidate tdouble)
                                               (Ecast
                                                 (Evalof
                                                   (Efield
                                                     (Evalof
                                                       (Evar _view (Tunion _FiveSqrtBits noattr))
                                                       (Tunion _FiveSqrtBits noattr))
                                                     _f tfloat) tfloat)
                                                 tdouble) tdouble))
                                        (Sifthenelse (Ebinop Ole
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Evar _candidate tdouble)
                                                           tdouble)
                                                         (Evalof
                                                           (Evar _candidate tdouble)
                                                           tdouble) tdouble)
                                                       (Evalof
                                                         (Evar _target tdouble)
                                                         tdouble) tint)
                                          (Sdo (Eassign (Evar _lo tuint)
                                                 (Evalof (Evar _mid tuint)
                                                   tuint) tuint))
                                          (Sdo (Eassign (Evar _hi tuint)
                                                 (Evalof (Evar _mid tuint)
                                                   tuint) tuint))))))
                                  (Ssequence
                                    (Ssequence
                                      (Sdo (Eassign (Evar _mid tuint)
                                             (Ebinop Oadd
                                               (Evalof (Evar _lo tuint)
                                                 tuint)
                                               (Ebinop Oshr
                                                 (Ebinop Osub
                                                   (Evalof (Evar _hi tuint)
                                                     tuint)
                                                   (Evalof (Evar _lo tuint)
                                                     tuint) tuint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tuint) tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign
                                               (Efield
                                                 (Evalof
                                                   (Evar _view (Tunion _FiveSqrtBits noattr))
                                                   (Tunion _FiveSqrtBits noattr))
                                                 _u tuint)
                                               (Evalof (Evar _mid tuint)
                                                 tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Evar _candidate tdouble)
                                                 (Ecast
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Evar _view (Tunion _FiveSqrtBits noattr))
                                                         (Tunion _FiveSqrtBits noattr))
                                                       _f tfloat) tfloat)
                                                   tdouble) tdouble))
                                          (Sifthenelse (Ebinop Ole
                                                         (Ebinop Omul
                                                           (Evalof
                                                             (Evar _candidate tdouble)
                                                             tdouble)
                                                           (Evalof
                                                             (Evar _candidate tdouble)
                                                             tdouble)
                                                           tdouble)
                                                         (Evalof
                                                           (Evar _target tdouble)
                                                           tdouble) tint)
                                            (Sdo (Eassign (Evar _lo tuint)
                                                   (Evalof (Evar _mid tuint)
                                                     tuint) tuint))
                                            (Sdo (Eassign (Evar _hi tuint)
                                                   (Evalof (Evar _mid tuint)
                                                     tuint) tuint))))))
                                    (Ssequence
                                      (Ssequence
                                        (Sdo (Eassign (Evar _mid tuint)
                                               (Ebinop Oadd
                                                 (Evalof (Evar _lo tuint)
                                                   tuint)
                                                 (Ebinop Oshr
                                                   (Ebinop Osub
                                                     (Evalof (Evar _hi tuint)
                                                       tuint)
                                                     (Evalof (Evar _lo tuint)
                                                       tuint) tuint)
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   tuint) tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Efield
                                                   (Evalof
                                                     (Evar _view (Tunion _FiveSqrtBits noattr))
                                                     (Tunion _FiveSqrtBits noattr))
                                                   _u tuint)
                                                 (Evalof (Evar _mid tuint)
                                                   tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Evar _candidate tdouble)
                                                   (Ecast
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Evar _view (Tunion _FiveSqrtBits noattr))
                                                           (Tunion _FiveSqrtBits noattr))
                                                         _f tfloat) tfloat)
                                                     tdouble) tdouble))
                                            (Sifthenelse (Ebinop Ole
                                                           (Ebinop Omul
                                                             (Evalof
                                                               (Evar _candidate tdouble)
                                                               tdouble)
                                                             (Evalof
                                                               (Evar _candidate tdouble)
                                                               tdouble)
                                                             tdouble)
                                                           (Evalof
                                                             (Evar _target tdouble)
                                                             tdouble) tint)
                                              (Sdo (Eassign (Evar _lo tuint)
                                                     (Evalof
                                                       (Evar _mid tuint)
                                                       tuint) tuint))
                                              (Sdo (Eassign (Evar _hi tuint)
                                                     (Evalof
                                                       (Evar _mid tuint)
                                                       tuint) tuint))))))
                                      (Ssequence
                                        (Ssequence
                                          (Sdo (Eassign (Evar _mid tuint)
                                                 (Ebinop Oadd
                                                   (Evalof (Evar _lo tuint)
                                                     tuint)
                                                   (Ebinop Oshr
                                                     (Ebinop Osub
                                                       (Evalof
                                                         (Evar _hi tuint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _lo tuint)
                                                         tuint) tuint)
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     tuint) tuint) tuint))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Efield
                                                     (Evalof
                                                       (Evar _view (Tunion _FiveSqrtBits noattr))
                                                       (Tunion _FiveSqrtBits noattr))
                                                     _u tuint)
                                                   (Evalof (Evar _mid tuint)
                                                     tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Evar _candidate tdouble)
                                                     (Ecast
                                                       (Evalof
                                                         (Efield
                                                           (Evalof
                                                             (Evar _view (Tunion _FiveSqrtBits noattr))
                                                             (Tunion _FiveSqrtBits noattr))
                                                           _f tfloat) tfloat)
                                                       tdouble) tdouble))
                                              (Sifthenelse (Ebinop Ole
                                                             (Ebinop Omul
                                                               (Evalof
                                                                 (Evar _candidate tdouble)
                                                                 tdouble)
                                                               (Evalof
                                                                 (Evar _candidate tdouble)
                                                                 tdouble)
                                                               tdouble)
                                                             (Evalof
                                                               (Evar _target tdouble)
                                                               tdouble) tint)
                                                (Sdo (Eassign
                                                       (Evar _lo tuint)
                                                       (Evalof
                                                         (Evar _mid tuint)
                                                         tuint) tuint))
                                                (Sdo (Eassign
                                                       (Evar _hi tuint)
                                                       (Evalof
                                                         (Evar _mid tuint)
                                                         tuint) tuint))))))
                                        (Ssequence
                                          (Ssequence
                                            (Sdo (Eassign (Evar _mid tuint)
                                                   (Ebinop Oadd
                                                     (Evalof (Evar _lo tuint)
                                                       tuint)
                                                     (Ebinop Oshr
                                                       (Ebinop Osub
                                                         (Evalof
                                                           (Evar _hi tuint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _lo tuint)
                                                           tuint) tuint)
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       tuint) tuint) tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Efield
                                                       (Evalof
                                                         (Evar _view (Tunion _FiveSqrtBits noattr))
                                                         (Tunion _FiveSqrtBits noattr))
                                                       _u tuint)
                                                     (Evalof
                                                       (Evar _mid tuint)
                                                       tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _candidate tdouble)
                                                       (Ecast
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Evar _view (Tunion _FiveSqrtBits noattr))
                                                               (Tunion _FiveSqrtBits noattr))
                                                             _f tfloat)
                                                           tfloat) tdouble)
                                                       tdouble))
                                                (Sifthenelse (Ebinop Ole
                                                               (Ebinop Omul
                                                                 (Evalof
                                                                   (Evar _candidate tdouble)
                                                                   tdouble)
                                                                 (Evalof
                                                                   (Evar _candidate tdouble)
                                                                   tdouble)
                                                                 tdouble)
                                                               (Evalof
                                                                 (Evar _target tdouble)
                                                                 tdouble)
                                                               tint)
                                                  (Sdo (Eassign
                                                         (Evar _lo tuint)
                                                         (Evalof
                                                           (Evar _mid tuint)
                                                           tuint) tuint))
                                                  (Sdo (Eassign
                                                         (Evar _hi tuint)
                                                         (Evalof
                                                           (Evar _mid tuint)
                                                           tuint) tuint))))))
                                          (Ssequence
                                            (Ssequence
                                              (Sdo (Eassign (Evar _mid tuint)
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Evar _lo tuint)
                                                         tuint)
                                                       (Ebinop Oshr
                                                         (Ebinop Osub
                                                           (Evalof
                                                             (Evar _hi tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _lo tuint)
                                                             tuint) tuint)
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         tuint) tuint) tuint))
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Efield
                                                         (Evalof
                                                           (Evar _view (Tunion _FiveSqrtBits noattr))
                                                           (Tunion _FiveSqrtBits noattr))
                                                         _u tuint)
                                                       (Evalof
                                                         (Evar _mid tuint)
                                                         tuint) tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _candidate tdouble)
                                                         (Ecast
                                                           (Evalof
                                                             (Efield
                                                               (Evalof
                                                                 (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                 (Tunion _FiveSqrtBits noattr))
                                                               _f tfloat)
                                                             tfloat) tdouble)
                                                         tdouble))
                                                  (Sifthenelse (Ebinop Ole
                                                                 (Ebinop Omul
                                                                   (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                   (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                   tdouble)
                                                                 (Evalof
                                                                   (Evar _target tdouble)
                                                                   tdouble)
                                                                 tint)
                                                    (Sdo (Eassign
                                                           (Evar _lo tuint)
                                                           (Evalof
                                                             (Evar _mid tuint)
                                                             tuint) tuint))
                                                    (Sdo (Eassign
                                                           (Evar _hi tuint)
                                                           (Evalof
                                                             (Evar _mid tuint)
                                                             tuint) tuint))))))
                                            (Ssequence
                                              (Ssequence
                                                (Sdo (Eassign
                                                       (Evar _mid tuint)
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _lo tuint)
                                                           tuint)
                                                         (Ebinop Oshr
                                                           (Ebinop Osub
                                                             (Evalof
                                                               (Evar _hi tuint)
                                                               tuint)
                                                             (Evalof
                                                               (Evar _lo tuint)
                                                               tuint) tuint)
                                                           (Eval (Vint (Int.repr 1)) tint)
                                                           tuint) tuint)
                                                       tuint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Efield
                                                           (Evalof
                                                             (Evar _view (Tunion _FiveSqrtBits noattr))
                                                             (Tunion _FiveSqrtBits noattr))
                                                           _u tuint)
                                                         (Evalof
                                                           (Evar _mid tuint)
                                                           tuint) tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _candidate tdouble)
                                                           (Ecast
                                                             (Evalof
                                                               (Efield
                                                                 (Evalof
                                                                   (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                   (Tunion _FiveSqrtBits noattr))
                                                                 _f tfloat)
                                                               tfloat)
                                                             tdouble)
                                                           tdouble))
                                                    (Sifthenelse (Ebinop Ole
                                                                   (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                   (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                   tint)
                                                      (Sdo (Eassign
                                                             (Evar _lo tuint)
                                                             (Evalof
                                                               (Evar _mid tuint)
                                                               tuint) tuint))
                                                      (Sdo (Eassign
                                                             (Evar _hi tuint)
                                                             (Evalof
                                                               (Evar _mid tuint)
                                                               tuint) tuint))))))
                                              (Ssequence
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _mid tuint)
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _lo tuint)
                                                             tuint)
                                                           (Ebinop Oshr
                                                             (Ebinop Osub
                                                               (Evalof
                                                                 (Evar _hi tuint)
                                                                 tuint)
                                                               (Evalof
                                                                 (Evar _lo tuint)
                                                                 tuint)
                                                               tuint)
                                                             (Eval (Vint (Int.repr 1)) tint)
                                                             tuint) tuint)
                                                         tuint))
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Efield
                                                             (Evalof
                                                               (Evar _view (Tunion _FiveSqrtBits noattr))
                                                               (Tunion _FiveSqrtBits noattr))
                                                             _u tuint)
                                                           (Evalof
                                                             (Evar _mid tuint)
                                                             tuint) tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _candidate tdouble)
                                                             (Ecast
                                                               (Evalof
                                                                 (Efield
                                                                   (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                   _f tfloat)
                                                                 tfloat)
                                                               tdouble)
                                                             tdouble))
                                                      (Sifthenelse (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                        (Sdo (Eassign
                                                               (Evar _lo tuint)
                                                               (Evalof
                                                                 (Evar _mid tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Sdo (Eassign
                                                               (Evar _hi tuint)
                                                               (Evalof
                                                                 (Evar _mid tuint)
                                                                 tuint)
                                                               tuint))))))
                                                (Ssequence
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Evar _mid tuint)
                                                           (Ebinop Oadd
                                                             (Evalof
                                                               (Evar _lo tuint)
                                                               tuint)
                                                             (Ebinop Oshr
                                                               (Ebinop Osub
                                                                 (Evalof
                                                                   (Evar _hi tuint)
                                                                   tuint)
                                                                 (Evalof
                                                                   (Evar _lo tuint)
                                                                   tuint)
                                                                 tuint)
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               tuint) tuint)
                                                           tuint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Efield
                                                               (Evalof
                                                                 (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                 (Tunion _FiveSqrtBits noattr))
                                                               _u tuint)
                                                             (Evalof
                                                               (Evar _mid tuint)
                                                               tuint) tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _candidate tdouble)
                                                               (Ecast
                                                                 (Evalof
                                                                   (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                   tfloat)
                                                                 tdouble)
                                                               tdouble))
                                                        (Sifthenelse 
                                                          (Ebinop Ole
                                                            (Ebinop Omul
                                                              (Evalof
                                                                (Evar _candidate tdouble)
                                                                tdouble)
                                                              (Evalof
                                                                (Evar _candidate tdouble)
                                                                tdouble)
                                                              tdouble)
                                                            (Evalof
                                                              (Evar _target tdouble)
                                                              tdouble) tint)
                                                          (Sdo (Eassign
                                                                 (Evar _lo tuint)
                                                                 (Evalof
                                                                   (Evar _mid tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Sdo (Eassign
                                                                 (Evar _hi tuint)
                                                                 (Evalof
                                                                   (Evar _mid tuint)
                                                                   tuint)
                                                                 tuint))))))
                                                  (Ssequence
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _mid tuint)
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _lo tuint)
                                                                 tuint)
                                                               (Ebinop Oshr
                                                                 (Ebinop Osub
                                                                   (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                   (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 tuint)
                                                               tuint) tuint))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Efield
                                                                 (Evalof
                                                                   (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                   (Tunion _FiveSqrtBits noattr))
                                                                 _u tuint)
                                                               (Evalof
                                                                 (Evar _mid tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _candidate tdouble)
                                                                 (Ecast
                                                                   (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                   tdouble)
                                                                 tdouble))
                                                          (Sifthenelse 
                                                            (Ebinop Ole
                                                              (Ebinop Omul
                                                                (Evalof
                                                                  (Evar _candidate tdouble)
                                                                  tdouble)
                                                                (Evalof
                                                                  (Evar _candidate tdouble)
                                                                  tdouble)
                                                                tdouble)
                                                              (Evalof
                                                                (Evar _target tdouble)
                                                                tdouble)
                                                              tint)
                                                            (Sdo (Eassign
                                                                   (Evar _lo tuint)
                                                                   (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Sdo (Eassign
                                                                   (Evar _hi tuint)
                                                                   (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                   tuint))))))
                                                    (Ssequence
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _mid tuint)
                                                               (Ebinop Oadd
                                                                 (Evalof
                                                                   (Evar _lo tuint)
                                                                   tuint)
                                                                 (Ebinop Oshr
                                                                   (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   tuint)
                                                                 tuint)
                                                               tuint))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Efield
                                                                   (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                   _u tuint)
                                                                 (Evalof
                                                                   (Evar _mid tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _candidate tdouble)
                                                                   (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                   tdouble))
                                                            (Sifthenelse 
                                                              (Ebinop Ole
                                                                (Ebinop Omul
                                                                  (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                  (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                  tdouble)
                                                                (Evalof
                                                                  (Evar _target tdouble)
                                                                  tdouble)
                                                                tint)
                                                              (Sdo (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Sdo (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                      (Ssequence
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _mid tuint)
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                   (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                   tuint)
                                                                 tuint))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                   (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                              (Sifthenelse 
                                                                (Ebinop Ole
                                                                  (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                  (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                  tint)
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                        (Ssequence
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _mid tuint)
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                   tuint))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                (Sifthenelse 
                                                                  (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                          (Ssequence
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                  (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                            (Ssequence
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                              (Ssequence
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                (Ssequence
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                  (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _mid tuint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Ebinop Oshr
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _candidate tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ole
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _candidate tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lo tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _hi tuint)
                                                                    (Evalof
                                                                    (Evar _mid tuint)
                                                                    tuint)
                                                                    tuint))))))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _lower tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _upper tdouble)
                                                                    (Ecast
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _midpoint tdouble)
                                                                    (Ebinop Omul
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _lower tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _upper tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _midpoint_square tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _midpoint tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _midpoint tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sifthenelse 
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _midpoint_square tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sifthenelse 
                                                                    (Ebinop Ogt
                                                                    (Evalof
                                                                    (Evar _target tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _midpoint_square tdouble)
                                                                    tdouble)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sifthenelse 
                                                                    (Ebinop Oeq
                                                                    (Ebinop Oand
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 1)) tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 0)) tuint)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _lo tuint)
                                                                    tuint)
                                                                    tuint))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _u tuint)
                                                                    (Evalof
                                                                    (Evar _hi tuint)
                                                                    tuint)
                                                                    tuint)))))
                                                                    (Sreturn (Some 
                                                                    (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Evar _view (Tunion _FiveSqrtBits noattr))
                                                                    (Tunion _FiveSqrtBits noattr))
                                                                    _f
                                                                    tfloat)
                                                                    tfloat))))))))))))))))))))))))))))))))))))))))))))))))))
|}.

Definition v_gh_ref := {|
  gvar_info := (Tstruct _GuidanceHRef noattr);
  gvar_init := (Init_space 64 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_gh_max_accel := {|
  gvar_info := tfloat;
  gvar_init := (Init_float32 (Float32.of_bits (Int.repr 1085611704)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_gh_update_ref_from_speed_sp := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_speed_sp, (Tstruct _FloatVect2 noattr)) :: nil);
  fn_vars := ((_pos_step, (Tstruct _FloatVect2 noattr)) ::
              (_speed_step, (Tstruct _FloatVect2 noattr)) ::
              (_pos_update, (Tstruct _Int64Vect2 noattr)) ::
              (_speed_err, (Tstruct _FloatVect2 noattr)) ::
              (_accel_sp, (Tstruct _FloatVect2 noattr)) :: nil);
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _pos_step (Tstruct _FloatVect2 noattr))
               (Tstruct _FloatVect2 noattr)) _x tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                       (Tstruct _GuidanceHRef noattr)) _speed
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                   (Tstruct _GuidanceHRef noattr)) _dt tfloat) tfloat)
             tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _pos_step (Tstruct _FloatVect2 noattr))
               (Tstruct _FloatVect2 noattr)) _y tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                       (Tstruct _GuidanceHRef noattr)) _speed
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                   (Tstruct _GuidanceHRef noattr)) _dt tfloat) tfloat)
             tfloat) tfloat)))
  (Ssequence
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _speed_step (Tstruct _FloatVect2 noattr))
                 (Tstruct _FloatVect2 noattr)) _x tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                         (Tstruct _GuidanceHRef noattr)) _accel
                       (Tstruct _FloatVect2 noattr))
                     (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                     (Tstruct _GuidanceHRef noattr)) _dt tfloat) tfloat)
               tfloat) tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _speed_step (Tstruct _FloatVect2 noattr))
                 (Tstruct _FloatVect2 noattr)) _y tfloat)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                         (Tstruct _GuidanceHRef noattr)) _accel
                       (Tstruct _FloatVect2 noattr))
                     (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
               (Evalof
                 (Efield
                   (Evalof (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                     (Tstruct _GuidanceHRef noattr)) _dt tfloat) tfloat)
               tfloat) tfloat)))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _pos_update (Tstruct _Int64Vect2 noattr))
                 (Tstruct _Int64Vect2 noattr)) _x tlong)
             (Ebinop Omul
               (Evalof
                 (Efield
                   (Evalof (Evar _pos_step (Tstruct _FloatVect2 noattr))
                     (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
               (Ebinop Oshl (Eval (Vlong (Int64.repr 1)) tlong)
                 (Eval (Vint (Int.repr 37)) tint) tlong) tfloat) tlong))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _pos_update (Tstruct _Int64Vect2 noattr))
                   (Tstruct _Int64Vect2 noattr)) _y tlong)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof (Evar _pos_step (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                 (Ebinop Oshl (Eval (Vlong (Int64.repr 1)) tlong)
                   (Eval (Vint (Int.repr 37)) tint) tlong) tfloat) tlong))
        (Ssequence
          (Ssequence
            (Sdo (Eassignop Oadd
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                           (Tstruct _GuidanceHRef noattr)) _pos
                         (Tstruct _Int64Vect2 noattr))
                       (Tstruct _Int64Vect2 noattr)) _x tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _pos_update (Tstruct _Int64Vect2 noattr))
                         (Tstruct _Int64Vect2 noattr)) _x tlong) tlong)
                   tlong tlong))
            (Sdo (Eassignop Oadd
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                           (Tstruct _GuidanceHRef noattr)) _pos
                         (Tstruct _Int64Vect2 noattr))
                       (Tstruct _Int64Vect2 noattr)) _y tlong)
                   (Evalof
                     (Efield
                       (Evalof
                         (Evar _pos_update (Tstruct _Int64Vect2 noattr))
                         (Tstruct _Int64Vect2 noattr)) _y tlong) tlong)
                   tlong tlong)))
          (Ssequence
            (Ssequence
              (Sdo (Eassignop Oadd
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                             (Tstruct _GuidanceHRef noattr)) _speed
                           (Tstruct _FloatVect2 noattr))
                         (Tstruct _FloatVect2 noattr)) _x tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _speed_step (Tstruct _FloatVect2 noattr))
                           (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
                     tfloat tfloat))
              (Sdo (Eassignop Oadd
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                             (Tstruct _GuidanceHRef noattr)) _speed
                           (Tstruct _FloatVect2 noattr))
                         (Tstruct _FloatVect2 noattr)) _y tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Evar _speed_step (Tstruct _FloatVect2 noattr))
                           (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                     tfloat tfloat)))
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Evar _speed_err (Tstruct _FloatVect2 noattr))
                           (Tstruct _FloatVect2 noattr)) _x tfloat)
                       (Ebinop Osub
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                                   (Tstruct _GuidanceHRef noattr)) _speed
                                 (Tstruct _FloatVect2 noattr))
                               (Tstruct _FloatVect2 noattr)) _x tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _speed_sp (Tstruct _FloatVect2 noattr))
                               (Tstruct _FloatVect2 noattr)) _x tfloat)
                           tfloat) tfloat) tfloat))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Evar _speed_err (Tstruct _FloatVect2 noattr))
                           (Tstruct _FloatVect2 noattr)) _y tfloat)
                       (Ebinop Osub
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                                   (Tstruct _GuidanceHRef noattr)) _speed
                                 (Tstruct _FloatVect2 noattr))
                               (Tstruct _FloatVect2 noattr)) _y tfloat)
                           tfloat)
                         (Evalof
                           (Efield
                             (Evalof
                               (Evar _speed_sp (Tstruct _FloatVect2 noattr))
                               (Tstruct _FloatVect2 noattr)) _y tfloat)
                           tfloat) tfloat) tfloat)))
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Evar _accel_sp (Tstruct _FloatVect2 noattr))
                             (Tstruct _FloatVect2 noattr)) _x tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _speed_err (Tstruct _FloatVect2 noattr))
                                 (Tstruct _FloatVect2 noattr)) _x tfloat)
                             tfloat)
                           (Eunop Oneg
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                                   (Tstruct _GuidanceHRef noattr)) _inv_tau
                                 tfloat) tfloat) tfloat) tfloat) tfloat))
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Evar _accel_sp (Tstruct _FloatVect2 noattr))
                             (Tstruct _FloatVect2 noattr)) _y tfloat)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _speed_err (Tstruct _FloatVect2 noattr))
                                 (Tstruct _FloatVect2 noattr)) _y tfloat)
                             tfloat)
                           (Eunop Oneg
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                                   (Tstruct _GuidanceHRef noattr)) _inv_tau
                                 tfloat) tfloat) tfloat) tfloat) tfloat)))
                (Ssequence
                  (Sdo (Ecall
                         (Evalof
                           (Evar _gh_saturate_accel (Tfunction
                                                      ((tptr (Tstruct _FloatVect2 noattr)) ::
                                                       nil) tvoid cc_default))
                           (Tfunction
                             ((tptr (Tstruct _FloatVect2 noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Evar _accel_sp (Tstruct _FloatVect2 noattr))
                             (tptr (Tstruct _FloatVect2 noattr))) Enil)
                         tvoid))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                                   (Tstruct _GuidanceHRef noattr)) _accel
                                 (Tstruct _FloatVect2 noattr))
                               (Tstruct _FloatVect2 noattr)) _x tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _accel_sp (Tstruct _FloatVect2 noattr))
                                 (Tstruct _FloatVect2 noattr)) _x tfloat)
                             tfloat) tfloat))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Evar _gh_ref (Tstruct _GuidanceHRef noattr))
                                   (Tstruct _GuidanceHRef noattr)) _accel
                                 (Tstruct _FloatVect2 noattr))
                               (Tstruct _FloatVect2 noattr)) _y tfloat)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Evar _accel_sp (Tstruct _FloatVect2 noattr))
                                 (Tstruct _FloatVect2 noattr)) _y tfloat)
                             tfloat) tfloat))))))))))))
|}.

Definition f_gh_saturate_accel := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_accel_sp, (tptr (Tstruct _FloatVect2 noattr))) :: nil);
  fn_vars := ((_a_norm2, tfloat) :: (_factor, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _a_norm2 tfloat)
         (Ebinop Oadd
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat) tfloat)
           tfloat) tfloat))
  (Sifthenelse (Ebinop Ogt (Evalof (Evar _a_norm2 tfloat) tfloat)
                 (Ebinop Omul (Evalof (Evar _gh_max_accel tfloat) tfloat)
                   (Evalof (Evar _gh_max_accel tfloat) tfloat) tfloat) tint)
    (Ssequence
      (Sdo (Eassign (Evar _factor tfloat)
             (Ebinop Odiv (Evalof (Evar _gh_max_accel tfloat) tfloat)
               (Ecall
                 (Evalof
                   (Evar _five_sqrtf (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                   (Tfunction (tfloat :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _a_norm2 tfloat) tfloat) Enil) tfloat)
               tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _x tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _x tfloat) tfloat)
                 (Evalof (Evar _factor tfloat) tfloat) tfloat) tfloat))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                       (tptr (Tstruct _FloatVect2 noattr)))
                     (Tstruct _FloatVect2 noattr))
                   (Tstruct _FloatVect2 noattr)) _y tfloat)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel_sp (tptr (Tstruct _FloatVect2 noattr)))
                           (tptr (Tstruct _FloatVect2 noattr)))
                         (Tstruct _FloatVect2 noattr))
                       (Tstruct _FloatVect2 noattr)) _y tfloat) tfloat)
                 (Evalof (Evar _factor tfloat) tfloat) tfloat) tfloat))))
    Sskip))
|}.

Definition composites : list composite_definition :=
(Composite _FiveSqrtBits Union
   (Member_plain _f tfloat :: Member_plain _u tuint :: nil)
   noattr ::
 Composite _FloatVect2 Struct
   (Member_plain _x tfloat :: Member_plain _y tfloat :: nil)
   noattr ::
 Composite _Int64Vect2 Struct
   (Member_plain _x tlong :: Member_plain _y tlong :: nil)
   noattr ::
 Composite _GuidanceHRef Struct
   (Member_plain _accel (Tstruct _FloatVect2 noattr) ::
    Member_plain _speed (Tstruct _FloatVect2 noattr) ::
    Member_plain _pos (Tstruct _Int64Vect2 noattr) ::
    Member_plain _tau tfloat :: Member_plain _omega tfloat ::
    Member_plain _zeta tfloat :: Member_plain _max_speed tfloat ::
    Member_plain _zeta_omega tfloat :: Member_plain _omega_2 tfloat ::
    Member_plain _inv_tau tfloat :: Member_plain _dt tfloat :: nil)
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
 (_five_sqrtf, Gfun(Internal f_five_sqrtf)) :: (_gh_ref, Gvar v_gh_ref) ::
 (_gh_max_accel, Gvar v_gh_max_accel) ::
 (_gh_update_ref_from_speed_sp, Gfun(Internal f_gh_update_ref_from_speed_sp)) ::
 (_gh_saturate_accel, Gfun(Internal f_gh_saturate_accel)) :: nil).

Definition public_idents : list ident :=
(_gh_update_ref_from_speed_sp :: _gh_ref :: ___builtin_debug ::
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


