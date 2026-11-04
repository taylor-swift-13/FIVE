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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/connected-models/attitude_saturation/model/preprocessed.i".
End Info.

Definition _FloatRates : ident := $"FloatRates".
Definition _FloatRefSat : ident := $"FloatRefSat".
Definition _Int32Rates : ident := $"Int32Rates".
Definition _Int32RefSat : ident := $"Int32RefSat".
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
Definition _accel : ident := $"accel".
Definition _attitude_ref_float_saturate_naive : ident := $"attitude_ref_float_saturate_naive".
Definition _attitude_ref_int_saturate_naive : ident := $"attitude_ref_int_saturate_naive".
Definition _five_keep_attitude_ref_float_saturate_naive : ident := $"five_keep_attitude_ref_float_saturate_naive".
Definition _five_keep_attitude_ref_int_saturate_naive : ident := $"five_keep_attitude_ref_int_saturate_naive".
Definition _main : ident := $"main".
Definition _max_accel : ident := $"max_accel".
Definition _max_rate : ident := $"max_rate".
Definition _p : ident := $"p".
Definition _q : ident := $"q".
Definition _r : ident := $"r".
Definition _rate : ident := $"rate".
Definition _sat : ident := $"sat".

Definition f_attitude_ref_float_saturate_naive := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rate, (tptr (Tstruct _FloatRates noattr))) ::
                (_accel, (tptr (Tstruct _FloatRates noattr))) ::
                (_sat, (tptr (Tstruct _FloatRefSat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sifthenelse (Ebinop Ogt
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                 (tptr (Tstruct _FloatRefSat noattr)))
                               (Tstruct _FloatRefSat noattr))
                             (Tstruct _FloatRefSat noattr)) _max_accel
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   tint)
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                     (tptr (Tstruct _FloatRates noattr)))
                   (Tstruct _FloatRates noattr))
                 (Tstruct _FloatRates noattr)) _p tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                           (tptr (Tstruct _FloatRefSat noattr)))
                         (Tstruct _FloatRefSat noattr))
                       (Tstruct _FloatRefSat noattr)) _max_accel
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _p tfloat) tfloat) tfloat))
      (Sifthenelse (Ebinop Olt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                     (tptr (Tstruct _FloatRefSat noattr)))
                                   (Tstruct _FloatRefSat noattr))
                                 (Tstruct _FloatRefSat noattr)) _max_accel
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                       tfloat) tint)
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _p tfloat)
               (Eunop Oneg
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                               (tptr (Tstruct _FloatRefSat noattr)))
                             (Tstruct _FloatRefSat noattr))
                           (Tstruct _FloatRefSat noattr)) _max_accel
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                 tfloat) tfloat))
        Sskip))
    (Ssequence
      (Sifthenelse (Ebinop Ogt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                   (tptr (Tstruct _FloatRefSat noattr)))
                                 (Tstruct _FloatRefSat noattr))
                               (Tstruct _FloatRefSat noattr)) _max_accel
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     tint)
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _q tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                             (tptr (Tstruct _FloatRefSat noattr)))
                           (Tstruct _FloatRefSat noattr))
                         (Tstruct _FloatRefSat noattr)) _max_accel
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _q tfloat) tfloat) tfloat))
        (Sifthenelse (Ebinop Olt
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                       (tptr (Tstruct _FloatRefSat noattr)))
                                     (Tstruct _FloatRefSat noattr))
                                   (Tstruct _FloatRefSat noattr)) _max_accel
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _q tfloat)
                           tfloat) tfloat) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _q tfloat)
                 (Eunop Oneg
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                 (tptr (Tstruct _FloatRefSat noattr)))
                               (Tstruct _FloatRefSat noattr))
                             (Tstruct _FloatRefSat noattr)) _max_accel
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                   tfloat) tfloat))
          Sskip))
      (Sifthenelse (Ebinop Ogt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                   (tptr (Tstruct _FloatRefSat noattr)))
                                 (Tstruct _FloatRefSat noattr))
                               (Tstruct _FloatRefSat noattr)) _max_accel
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                     tint)
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _r tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                             (tptr (Tstruct _FloatRefSat noattr)))
                           (Tstruct _FloatRefSat noattr))
                         (Tstruct _FloatRefSat noattr)) _max_accel
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat) tfloat) tfloat))
        (Sifthenelse (Ebinop Olt
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                       (tptr (Tstruct _FloatRefSat noattr)))
                                     (Tstruct _FloatRefSat noattr))
                                   (Tstruct _FloatRefSat noattr)) _max_accel
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _r tfloat)
                           tfloat) tfloat) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat)
                 (Eunop Oneg
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                 (tptr (Tstruct _FloatRefSat noattr)))
                               (Tstruct _FloatRefSat noattr))
                             (Tstruct _FloatRefSat noattr)) _max_accel
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                   tfloat) tfloat))
          Sskip))))
  (Ssequence
    (Sifthenelse (Ebinop Oge
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                 (tptr (Tstruct _FloatRefSat noattr)))
                               (Tstruct _FloatRefSat noattr))
                             (Tstruct _FloatRefSat noattr)) _max_rate
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                       (tptr (Tstruct _FloatRates noattr)))
                     (Tstruct _FloatRates noattr))
                   (Tstruct _FloatRates noattr)) _p tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                             (tptr (Tstruct _FloatRefSat noattr)))
                           (Tstruct _FloatRefSat noattr))
                         (Tstruct _FloatRefSat noattr)) _max_rate
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _p tfloat) tfloat) tfloat))
        (Sifthenelse (Ebinop Ogt
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _p tfloat)
                 (Eval (Vint (Int.repr 0)) tint) tfloat))
          Sskip))
      (Sifthenelse (Ebinop Ole
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                     (tptr (Tstruct _FloatRefSat noattr)))
                                   (Tstruct _FloatRefSat noattr))
                                 (Tstruct _FloatRefSat noattr)) _max_rate
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                       tfloat) tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _p tfloat)
                 (Eunop Oneg
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                 (tptr (Tstruct _FloatRefSat noattr)))
                               (Tstruct _FloatRefSat noattr))
                             (Tstruct _FloatRefSat noattr)) _max_rate
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _p tfloat) tfloat)
                   tfloat) tfloat))
          (Sifthenelse (Ebinop Olt
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _p tfloat)
                           tfloat) (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _p tfloat)
                   (Eval (Vint (Int.repr 0)) tint) tfloat))
            Sskip))
        Sskip))
    (Ssequence
      (Sifthenelse (Ebinop Oge
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                   (tptr (Tstruct _FloatRefSat noattr)))
                                 (Tstruct _FloatRefSat noattr))
                               (Tstruct _FloatRefSat noattr)) _max_rate
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _q tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                               (tptr (Tstruct _FloatRefSat noattr)))
                             (Tstruct _FloatRefSat noattr))
                           (Tstruct _FloatRefSat noattr)) _max_rate
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                 tfloat))
          (Sifthenelse (Ebinop Ogt
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _q tfloat)
                           tfloat) (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat)
                   (Eval (Vint (Int.repr 0)) tint) tfloat))
            Sskip))
        (Sifthenelse (Ebinop Ole
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                       (tptr (Tstruct _FloatRefSat noattr)))
                                     (Tstruct _FloatRefSat noattr))
                                   (Tstruct _FloatRefSat noattr)) _max_rate
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _q tfloat)
                           tfloat) tfloat) tint)
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _q tfloat)
                   (Eunop Oneg
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                   (tptr (Tstruct _FloatRefSat noattr)))
                                 (Tstruct _FloatRefSat noattr))
                               (Tstruct _FloatRefSat noattr)) _max_rate
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _q tfloat) tfloat)
                     tfloat) tfloat))
            (Sifthenelse (Ebinop Olt
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                     (tptr (Tstruct _FloatRates noattr)))
                                   (Tstruct _FloatRates noattr))
                                 (Tstruct _FloatRates noattr)) _q tfloat)
                             tfloat) (Eval (Vint (Int.repr 0)) tint) tint)
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _q tfloat)
                     (Eval (Vint (Int.repr 0)) tint) tfloat))
              Sskip))
          Sskip))
      (Sifthenelse (Ebinop Oge
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                               (tptr (Tstruct _FloatRates noattr)))
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                   (tptr (Tstruct _FloatRefSat noattr)))
                                 (Tstruct _FloatRefSat noattr))
                               (Tstruct _FloatRefSat noattr)) _max_rate
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                     tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                         (tptr (Tstruct _FloatRates noattr)))
                       (Tstruct _FloatRates noattr))
                     (Tstruct _FloatRates noattr)) _r tfloat)
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                               (tptr (Tstruct _FloatRefSat noattr)))
                             (Tstruct _FloatRefSat noattr))
                           (Tstruct _FloatRefSat noattr)) _max_rate
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                 tfloat))
          (Sifthenelse (Ebinop Ogt
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                   (tptr (Tstruct _FloatRates noattr)))
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _r tfloat)
                           tfloat) (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat)
                   (Eval (Vint (Int.repr 0)) tint) tfloat))
            Sskip))
        (Sifthenelse (Ebinop Ole
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                                 (tptr (Tstruct _FloatRates noattr)))
                               (Tstruct _FloatRates noattr))
                             (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                       (tptr (Tstruct _FloatRefSat noattr)))
                                     (Tstruct _FloatRefSat noattr))
                                   (Tstruct _FloatRefSat noattr)) _max_rate
                                 (Tstruct _FloatRates noattr))
                               (Tstruct _FloatRates noattr)) _r tfloat)
                           tfloat) tfloat) tint)
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _rate (tptr (Tstruct _FloatRates noattr)))
                           (tptr (Tstruct _FloatRates noattr)))
                         (Tstruct _FloatRates noattr))
                       (Tstruct _FloatRates noattr)) _r tfloat)
                   (Eunop Oneg
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _FloatRefSat noattr)))
                                   (tptr (Tstruct _FloatRefSat noattr)))
                                 (Tstruct _FloatRefSat noattr))
                               (Tstruct _FloatRefSat noattr)) _max_rate
                             (Tstruct _FloatRates noattr))
                           (Tstruct _FloatRates noattr)) _r tfloat) tfloat)
                     tfloat) tfloat))
            (Sifthenelse (Ebinop Olt
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                                     (tptr (Tstruct _FloatRates noattr)))
                                   (Tstruct _FloatRates noattr))
                                 (Tstruct _FloatRates noattr)) _r tfloat)
                             tfloat) (Eval (Vint (Int.repr 0)) tint) tint)
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _accel (tptr (Tstruct _FloatRates noattr)))
                             (tptr (Tstruct _FloatRates noattr)))
                           (Tstruct _FloatRates noattr))
                         (Tstruct _FloatRates noattr)) _r tfloat)
                     (Eval (Vint (Int.repr 0)) tint) tfloat))
              Sskip))
          Sskip)))))
|}.

Definition f_attitude_ref_int_saturate_naive := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_rate, (tptr (Tstruct _Int32Rates noattr))) ::
                (_accel, (tptr (Tstruct _Int32Rates noattr))) ::
                (_sat, (tptr (Tstruct _Int32RefSat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sifthenelse (Ebinop Ogt
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                 (tptr (Tstruct _Int32RefSat noattr)))
                               (Tstruct _Int32RefSat noattr))
                             (Tstruct _Int32RefSat noattr)) _max_accel
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tint)
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                     (tptr (Tstruct _Int32Rates noattr)))
                   (Tstruct _Int32Rates noattr))
                 (Tstruct _Int32Rates noattr)) _p tint)
             (Evalof
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                           (tptr (Tstruct _Int32RefSat noattr)))
                         (Tstruct _Int32RefSat noattr))
                       (Tstruct _Int32RefSat noattr)) _max_accel
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _p tint) tint) tint))
      (Sifthenelse (Ebinop Olt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _p tint) tint)
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                     (tptr (Tstruct _Int32RefSat noattr)))
                                   (Tstruct _Int32RefSat noattr))
                                 (Tstruct _Int32RefSat noattr)) _max_accel
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _p tint) tint)
                       tint) tint)
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _p tint)
               (Eunop Oneg
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                               (tptr (Tstruct _Int32RefSat noattr)))
                             (Tstruct _Int32RefSat noattr))
                           (Tstruct _Int32RefSat noattr)) _max_accel
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _p tint) tint) tint)
               tint))
        Sskip))
    (Ssequence
      (Sifthenelse (Ebinop Ogt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                   (tptr (Tstruct _Int32RefSat noattr)))
                                 (Tstruct _Int32RefSat noattr))
                               (Tstruct _Int32RefSat noattr)) _max_accel
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint) tint) tint)
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _q tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                             (tptr (Tstruct _Int32RefSat noattr)))
                           (Tstruct _Int32RefSat noattr))
                         (Tstruct _Int32RefSat noattr)) _max_accel
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint) tint) tint))
        (Sifthenelse (Ebinop Olt
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _q tint) tint)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                       (tptr (Tstruct _Int32RefSat noattr)))
                                     (Tstruct _Int32RefSat noattr))
                                   (Tstruct _Int32RefSat noattr)) _max_accel
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _q tint) tint)
                         tint) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint)
                 (Eunop Oneg
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                 (tptr (Tstruct _Int32RefSat noattr)))
                               (Tstruct _Int32RefSat noattr))
                             (Tstruct _Int32RefSat noattr)) _max_accel
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _q tint) tint) tint)
                 tint))
          Sskip))
      (Sifthenelse (Ebinop Ogt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                   (tptr (Tstruct _Int32RefSat noattr)))
                                 (Tstruct _Int32RefSat noattr))
                               (Tstruct _Int32RefSat noattr)) _max_accel
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint) tint)
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _r tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                             (tptr (Tstruct _Int32RefSat noattr)))
                           (Tstruct _Int32RefSat noattr))
                         (Tstruct _Int32RefSat noattr)) _max_accel
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint) tint) tint))
        (Sifthenelse (Ebinop Olt
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _r tint) tint)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                       (tptr (Tstruct _Int32RefSat noattr)))
                                     (Tstruct _Int32RefSat noattr))
                                   (Tstruct _Int32RefSat noattr)) _max_accel
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _r tint) tint)
                         tint) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint)
                 (Eunop Oneg
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                 (tptr (Tstruct _Int32RefSat noattr)))
                               (Tstruct _Int32RefSat noattr))
                             (Tstruct _Int32RefSat noattr)) _max_accel
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _r tint) tint) tint)
                 tint))
          Sskip))))
  (Ssequence
    (Sifthenelse (Ebinop Oge
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                 (tptr (Tstruct _Int32RefSat noattr)))
                               (Tstruct _Int32RefSat noattr))
                             (Tstruct _Int32RefSat noattr)) _max_rate
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                       (tptr (Tstruct _Int32Rates noattr)))
                     (Tstruct _Int32Rates noattr))
                   (Tstruct _Int32Rates noattr)) _p tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                             (tptr (Tstruct _Int32RefSat noattr)))
                           (Tstruct _Int32RefSat noattr))
                         (Tstruct _Int32RefSat noattr)) _max_rate
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _p tint) tint) tint))
        (Sifthenelse (Ebinop Ogt
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _p tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _p tint)
                 (Eval (Vint (Int.repr 0)) tint) tint))
          Sskip))
      (Sifthenelse (Ebinop Ole
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _p tint) tint)
                     (Eunop Oneg
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                     (tptr (Tstruct _Int32RefSat noattr)))
                                   (Tstruct _Int32RefSat noattr))
                                 (Tstruct _Int32RefSat noattr)) _max_rate
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _p tint) tint)
                       tint) tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _p tint)
                 (Eunop Oneg
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                 (tptr (Tstruct _Int32RefSat noattr)))
                               (Tstruct _Int32RefSat noattr))
                             (Tstruct _Int32RefSat noattr)) _max_rate
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _p tint) tint) tint)
                 tint))
          (Sifthenelse (Ebinop Olt
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                   (tptr (Tstruct _Int32Rates noattr)))
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _p tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _p tint)
                   (Eval (Vint (Int.repr 0)) tint) tint))
            Sskip))
        Sskip))
    (Ssequence
      (Sifthenelse (Ebinop Oge
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                   (tptr (Tstruct _Int32RefSat noattr)))
                                 (Tstruct _Int32RefSat noattr))
                               (Tstruct _Int32RefSat noattr)) _max_rate
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint) tint) tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _q tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                               (tptr (Tstruct _Int32RefSat noattr)))
                             (Tstruct _Int32RefSat noattr))
                           (Tstruct _Int32RefSat noattr)) _max_rate
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint) tint) tint))
          (Sifthenelse (Ebinop Ogt
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                   (tptr (Tstruct _Int32Rates noattr)))
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _q tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint)
                   (Eval (Vint (Int.repr 0)) tint) tint))
            Sskip))
        (Sifthenelse (Ebinop Ole
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _q tint) tint)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                       (tptr (Tstruct _Int32RefSat noattr)))
                                     (Tstruct _Int32RefSat noattr))
                                   (Tstruct _Int32RefSat noattr)) _max_rate
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _q tint) tint)
                         tint) tint)
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _q tint)
                   (Eunop Oneg
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                   (tptr (Tstruct _Int32RefSat noattr)))
                                 (Tstruct _Int32RefSat noattr))
                               (Tstruct _Int32RefSat noattr)) _max_rate
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _q tint) tint) tint)
                   tint))
            (Sifthenelse (Ebinop Olt
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                     (tptr (Tstruct _Int32Rates noattr)))
                                   (Tstruct _Int32Rates noattr))
                                 (Tstruct _Int32Rates noattr)) _q tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _q tint)
                     (Eval (Vint (Int.repr 0)) tint) tint))
              Sskip))
          Sskip))
      (Sifthenelse (Ebinop Oge
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                               (tptr (Tstruct _Int32Rates noattr)))
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                   (tptr (Tstruct _Int32RefSat noattr)))
                                 (Tstruct _Int32RefSat noattr))
                               (Tstruct _Int32RefSat noattr)) _max_rate
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint) tint)
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                         (tptr (Tstruct _Int32Rates noattr)))
                       (Tstruct _Int32Rates noattr))
                     (Tstruct _Int32Rates noattr)) _r tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                               (tptr (Tstruct _Int32RefSat noattr)))
                             (Tstruct _Int32RefSat noattr))
                           (Tstruct _Int32RefSat noattr)) _max_rate
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _r tint) tint) tint))
          (Sifthenelse (Ebinop Ogt
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                   (tptr (Tstruct _Int32Rates noattr)))
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _r tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _r tint)
                   (Eval (Vint (Int.repr 0)) tint) tint))
            Sskip))
        (Sifthenelse (Ebinop Ole
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                                 (tptr (Tstruct _Int32Rates noattr)))
                               (Tstruct _Int32Rates noattr))
                             (Tstruct _Int32Rates noattr)) _r tint) tint)
                       (Eunop Oneg
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                       (tptr (Tstruct _Int32RefSat noattr)))
                                     (Tstruct _Int32RefSat noattr))
                                   (Tstruct _Int32RefSat noattr)) _max_rate
                                 (Tstruct _Int32Rates noattr))
                               (Tstruct _Int32Rates noattr)) _r tint) tint)
                         tint) tint)
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _rate (tptr (Tstruct _Int32Rates noattr)))
                           (tptr (Tstruct _Int32Rates noattr)))
                         (Tstruct _Int32Rates noattr))
                       (Tstruct _Int32Rates noattr)) _r tint)
                   (Eunop Oneg
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _sat (tptr (Tstruct _Int32RefSat noattr)))
                                   (tptr (Tstruct _Int32RefSat noattr)))
                                 (Tstruct _Int32RefSat noattr))
                               (Tstruct _Int32RefSat noattr)) _max_rate
                             (Tstruct _Int32Rates noattr))
                           (Tstruct _Int32Rates noattr)) _r tint) tint) tint)
                   tint))
            (Sifthenelse (Ebinop Olt
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                                     (tptr (Tstruct _Int32Rates noattr)))
                                   (Tstruct _Int32Rates noattr))
                                 (Tstruct _Int32Rates noattr)) _r tint) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint)
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _accel (tptr (Tstruct _Int32Rates noattr)))
                             (tptr (Tstruct _Int32Rates noattr)))
                           (Tstruct _Int32Rates noattr))
                         (Tstruct _Int32Rates noattr)) _r tint)
                     (Eval (Vint (Int.repr 0)) tint) tint))
              Sskip))
          Sskip)))))
|}.

Definition v_five_keep_attitude_ref_float_saturate_naive := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _attitude_ref_float_saturate_naive (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_attitude_ref_int_saturate_naive := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _attitude_ref_int_saturate_naive (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _FloatRates Struct
   (Member_plain _p tfloat :: Member_plain _q tfloat ::
    Member_plain _r tfloat :: nil)
   noattr ::
 Composite _Int32Rates Struct
   (Member_plain _p tint :: Member_plain _q tint :: Member_plain _r tint ::
    nil)
   noattr ::
 Composite _FloatRefSat Struct
   (Member_plain _max_rate (Tstruct _FloatRates noattr) ::
    Member_plain _max_accel (Tstruct _FloatRates noattr) :: nil)
   noattr ::
 Composite _Int32RefSat Struct
   (Member_plain _max_rate (Tstruct _Int32Rates noattr) ::
    Member_plain _max_accel (Tstruct _Int32Rates noattr) :: nil)
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
 (_attitude_ref_float_saturate_naive, Gfun(Internal f_attitude_ref_float_saturate_naive)) ::
 (_attitude_ref_int_saturate_naive, Gfun(Internal f_attitude_ref_int_saturate_naive)) ::
 (_five_keep_attitude_ref_float_saturate_naive, Gvar v_five_keep_attitude_ref_float_saturate_naive) ::
 (_five_keep_attitude_ref_int_saturate_naive, Gvar v_five_keep_attitude_ref_int_saturate_naive) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_attitude_ref_int_saturate_naive ::
 _five_keep_attitude_ref_float_saturate_naive :: ___builtin_debug ::
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


