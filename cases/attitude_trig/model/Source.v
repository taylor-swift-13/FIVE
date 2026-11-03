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
  Definition source_file := "/home/yangfp/five/examples/paparazzi_trig/all.c".
End Info.

Definition _FloatEulers : ident := $"FloatEulers".
Definition _FloatRMat : ident := $"FloatRMat".
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
Definition _ax : ident := $"ax".
Definition _bit : ident := $"bit".
Definition _carry : ident := $"carry".
Definition _cosine : ident := $"cosine".
Definition _cphi : ident := $"cphi".
Definition _cpsi : ident := $"cpsi".
Definition _cs : ident := $"cs".
Definition _ctheta : ident := $"ctheta".
Definition _d : ident := $"d".
Definition _dst : ident := $"dst".
Definition _e : ident := $"e".
Definition _five_copy4 : ident := $"five_copy4".
Definition _five_cosf : ident := $"five_cosf".
Definition _five_float_bits : ident := $"five_float_bits".
Definition _five_float_from_bits : ident := $"five_float_from_bits".
Definition _five_product_bit : ident := $"five_product_bit".
Definition _five_sinf : ident := $"five_sinf".
Definition _five_trig : ident := $"five_trig".
Definition _five_two_over_pi : ident := $"five_two_over_pi".
Definition _float_rmat_of_eulers_321 : ident := $"float_rmat_of_eulers_321".
Definition _frac : ident := $"frac".
Definition _i : ident := $"i".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _neg : ident := $"neg".
Definition _p : ident := $"p".
Definition _phi : ident := $"phi".
Definition _psi : ident := $"psi".
Definition _q : ident := $"q".
Definition _r : ident := $"r".
Definition _rm : ident := $"rm".
Definition _round : ident := $"round".
Definition _s : ident := $"s".
Definition _shift : ident := $"shift".
Definition _sn : ident := $"sn".
Definition _sphi : ident := $"sphi".
Definition _spsi : ident := $"spsi".
Definition _src : ident := $"src".
Definition _stheta : ident := $"stheta".
Definition _t : ident := $"t".
Definition _theta : ident := $"theta".
Definition _u : ident := $"u".
Definition _ux : ident := $"ux".
Definition _x : ident := $"x".
Definition _y : ident := $"y".
Definition _z : ident := $"z".

Definition v_five_two_over_pi := {|
  gvar_info := (tarray tuint 8);
  gvar_init := (Init_int32 (Int.repr (-558119583)) ::
                Init_int32 (Int.repr (-28220501)) ::
                Init_int32 (Int.repr 1011060801) ::
                Init_int32 (Int.repr (-614296167)) ::
                Init_int32 (Int.repr (-181084736)) ::
                Init_int32 (Int.repr (-64530479)) ::
                Init_int32 (Int.repr 1313084713) ::
                Init_int32 (Int.repr (-1560706194)) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_five_copy4 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_dst, (tptr tvoid)) :: (_src, (tptr tvoid)) :: nil);
  fn_vars := ((_d, (tptr tuchar)) :: (_s, (tptr tuchar)) :: (_i, tint) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _d (tptr tuchar))
         (Evalof (Evar _dst (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
  (Ssequence
    (Sdo (Eassign (Evar _s (tptr tuchar))
           (Evalof (Evar _src (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
    (Sfor
      (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Ebinop Olt (Evalof (Evar _i tint) tint)
        (Eval (Vint (Int.repr 4)) tint) tint)
      (Sdo (Eassign (Evar _i tint)
             (Ebinop Oadd (Evalof (Evar _i tint) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint))
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd (Evalof (Evar _d (tptr tuchar)) (tptr tuchar))
                 (Evalof (Evar _i tint) tint) (tptr tuchar)) tuchar)
             (Evalof
               (Ederef
                 (Ebinop Oadd (Evalof (Evar _s (tptr tuchar)) (tptr tuchar))
                   (Evalof (Evar _i tint) tint) (tptr tuchar)) tuchar)
               tuchar) tuchar)))))
|}.

Definition f_five_float_bits := {|
  fn_return := tuint;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: nil);
  fn_vars := ((_u, tuint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _five_copy4 (Tfunction ((tptr tvoid) :: (tptr tvoid) :: nil)
                               tvoid cc_default))
           (Tfunction ((tptr tvoid) :: (tptr tvoid) :: nil) tvoid cc_default))
         (Econs (Eaddrof (Evar _u tuint) (tptr tuint))
           (Econs (Eaddrof (Evar _x tfloat) (tptr tfloat)) Enil)) tvoid))
  (Sreturn (Some (Evalof (Evar _u tuint) tuint))))
|}.

Definition f_five_float_from_bits := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_u, tuint) :: nil);
  fn_vars := ((_x, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _five_copy4 (Tfunction ((tptr tvoid) :: (tptr tvoid) :: nil)
                               tvoid cc_default))
           (Tfunction ((tptr tvoid) :: (tptr tvoid) :: nil) tvoid cc_default))
         (Econs (Eaddrof (Evar _x tfloat) (tptr tfloat))
           (Econs (Eaddrof (Evar _u tuint) (tptr tuint)) Enil)) tvoid))
  (Sreturn (Some (Evalof (Evar _x tfloat) tfloat))))
|}.

Definition f_five_product_bit := {|
  fn_return := tuint;
  fn_callconv := cc_default;
  fn_params := ((_p, (tptr tuint)) :: (_bit, tint) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eseqor
                 (Ebinop Olt (Evalof (Evar _bit tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
                 (Ebinop Oge (Evalof (Evar _bit tint) tint)
                   (Eval (Vint (Int.repr 288)) tint) tint) tint)
    (Sreturn (Some (Eval (Vint (Int.repr 0)) tuint)))
    Sskip)
  (Sreturn (Some (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _p (tptr tuint)) (tptr tuint))
                           (Ebinop Odiv (Evalof (Evar _bit tint) tint)
                             (Eval (Vint (Int.repr 32)) tint) tint)
                           (tptr tuint)) tuint) tuint)
                     (Ebinop Omod (Evalof (Evar _bit tint) tint)
                       (Eval (Vint (Int.repr 32)) tint) tint) tuint)
                   (Eval (Vint (Int.repr 1)) tuint) tuint))))
|}.

Definition f_five_trig := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: (_cosine, tuint) :: nil);
  fn_vars := ((_ux, tuint) :: (_ax, tuint) :: (_neg, tuint) :: (_q, tuint) ::
              (_r, tdouble) :: (_z, tdouble) :: (_sn, tdouble) ::
              (_cs, tdouble) :: (_y, tdouble) :: (_p, (tarray tuint 9)) ::
              (_m, tuint) :: (_e, tint) :: (_shift, tint) ::
              (_carry, tulong) :: (_t, tulong) :: (_frac, tdouble) ::
              (_round, tuint) :: (_i, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _ux tuint)
         (Ecall
           (Evalof
             (Evar _five_float_bits (Tfunction (tfloat :: nil) tuint
                                      cc_default))
             (Tfunction (tfloat :: nil) tuint cc_default))
           (Econs (Evalof (Evar _x tfloat) tfloat) Enil) tuint) tuint))
  (Ssequence
    (Sdo (Eassign (Evar _ax tuint)
           (Ebinop Oand (Evalof (Evar _ux tuint) tuint)
             (Eval (Vint (Int.repr 2147483647)) tuint) tuint) tuint))
    (Ssequence
      (Sdo (Eassign (Evar _neg tuint)
             (Ebinop Oshr (Evalof (Evar _ux tuint) tuint)
               (Eval (Vint (Int.repr 31)) tint) tuint) tuint))
      (Ssequence
        (Sdo (Eassign (Evar _q tuint) (Eval (Vint (Int.repr 0)) tint) tuint))
        (Ssequence
          (Sifthenelse (Ebinop Oge (Evalof (Evar _ax tuint) tuint)
                         (Eval (Vint (Int.repr 2139095040)) tuint) tint)
            (Ssequence
              (Sifthenelse (Ebinop Ogt (Evalof (Evar _ax tuint) tuint)
                             (Eval (Vint (Int.repr 2139095040)) tuint) tint)
                (Sreturn (Some (Ecall
                                 (Evalof
                                   (Evar _five_float_from_bits (Tfunction
                                                                 (tuint ::
                                                                  nil) tfloat
                                                                 cc_default))
                                   (Tfunction (tuint :: nil) tfloat
                                     cc_default))
                                 (Econs
                                   (Ebinop Oor
                                     (Evalof (Evar _ux tuint) tuint)
                                     (Eval (Vint (Int.repr 4194304)) tuint)
                                     tuint) Enil) tfloat)))
                Sskip)
              (Sreturn (Some (Ecall
                               (Evalof
                                 (Evar _five_float_from_bits (Tfunction
                                                               (tuint :: nil)
                                                               tfloat
                                                               cc_default))
                                 (Tfunction (tuint :: nil) tfloat cc_default))
                               (Econs
                                 (Eval (Vint (Int.repr 2143289344)) tuint)
                                 Enil) tfloat))))
            Sskip)
          (Ssequence
            (Sifthenelse (Ebinop Oeq (Evalof (Evar _ax tuint) tuint)
                           (Eval (Vint (Int.repr 0)) tuint) tint)
              (Ssequence
                (Sifthenelse (Evalof (Evar _cosine tuint) tuint)
                  (Sreturn (Some (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)))
                  Sskip)
                (Sreturn (Some (Evalof (Evar _x tfloat) tfloat))))
              Sskip)
            (Ssequence
              (Sifthenelse (Ebinop Ole (Evalof (Evar _ax tuint) tuint)
                             (Eval (Vint (Int.repr 1061752794)) tuint) tint)
                (Sdo (Eassign (Evar _r tdouble)
                       (Ecast
                         (Ecall
                           (Evalof
                             (Evar _five_float_from_bits (Tfunction
                                                           (tuint :: nil)
                                                           tfloat cc_default))
                             (Tfunction (tuint :: nil) tfloat cc_default))
                           (Econs (Evalof (Evar _ax tuint) tuint) Enil)
                           tfloat) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _m tuint)
                         (Ebinop Oor
                           (Ebinop Oand (Evalof (Evar _ax tuint) tuint)
                             (Eval (Vint (Int.repr 8388607)) tuint) tuint)
                           (Eval (Vint (Int.repr 8388608)) tuint) tuint)
                         tuint))
                  (Ssequence
                    (Sdo (Eassign (Evar _e tint)
                           (Ebinop Osub
                             (Ecast
                               (Ebinop Oshr (Evalof (Evar _ax tuint) tuint)
                                 (Eval (Vint (Int.repr 23)) tint) tuint)
                               tint) (Eval (Vint (Int.repr 150)) tint) tint)
                           tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _shift tint)
                             (Ebinop Osub (Eval (Vint (Int.repr 256)) tint)
                               (Evalof (Evar _e tint) tint) tint) tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _carry tulong)
                               (Eval (Vint (Int.repr 0)) tint) tulong))
                        (Ssequence
                          (Sdo (Eassign (Evar _frac tdouble)
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                                 tdouble))
                          (Ssequence
                            (Sfor
                              (Sdo (Eassign (Evar _i tint)
                                     (Eval (Vint (Int.repr 0)) tint) tint))
                              (Ebinop Olt (Evalof (Evar _i tint) tint)
                                (Eval (Vint (Int.repr 8)) tint) tint)
                              (Sdo (Eassign (Evar _i tint)
                                     (Ebinop Oadd
                                       (Evalof (Evar _i tint) tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     tint))
                              (Ssequence
                                (Sdo (Eassign (Evar _t tulong)
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Ecast
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _five_two_over_pi (tarray tuint 8))
                                                     (tarray tuint 8))
                                                   (Evalof (Evar _i tint)
                                                     tint) (tptr tuint))
                                                 tuint) tuint) tulong)
                                           (Ecast
                                             (Evalof (Evar _m tuint) tuint)
                                             tulong) tulong)
                                         (Evalof (Evar _carry tulong) tulong)
                                         tulong) tulong))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _p (tarray tuint 9))
                                               (tarray tuint 9))
                                             (Evalof (Evar _i tint) tint)
                                             (tptr tuint)) tuint)
                                         (Ecast
                                           (Evalof (Evar _t tulong) tulong)
                                           tuint) tuint))
                                  (Sdo (Eassign (Evar _carry tulong)
                                         (Ebinop Oshr
                                           (Evalof (Evar _t tulong) tulong)
                                           (Eval (Vint (Int.repr 32)) tint)
                                           tulong) tulong)))))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _p (tarray tuint 9))
                                           (tarray tuint 9))
                                         (Eval (Vint (Int.repr 8)) tint)
                                         (tptr tuint)) tuint)
                                     (Ecast
                                       (Evalof (Evar _carry tulong) tulong)
                                       tuint) tuint))
                              (Ssequence
                                (Sdo (Eassign (Evar _q tuint)
                                       (Ebinop Oadd
                                         (Ecall
                                           (Evalof
                                             (Evar _five_product_bit 
                                             (Tfunction
                                               ((tptr tuint) :: tint :: nil)
                                               tuint cc_default))
                                             (Tfunction
                                               ((tptr tuint) :: tint :: nil)
                                               tuint cc_default))
                                           (Econs
                                             (Evalof
                                               (Evar _p (tarray tuint 9))
                                               (tarray tuint 9))
                                             (Econs
                                               (Evalof (Evar _shift tint)
                                                 tint) Enil)) tuint)
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tuint)
                                           (Ecall
                                             (Evalof
                                               (Evar _five_product_bit 
                                               (Tfunction
                                                 ((tptr tuint) :: tint ::
                                                  nil) tuint cc_default))
                                               (Tfunction
                                                 ((tptr tuint) :: tint ::
                                                  nil) tuint cc_default))
                                             (Econs
                                               (Evalof
                                                 (Evar _p (tarray tuint 9))
                                                 (tarray tuint 9))
                                               (Econs
                                                 (Ebinop Oadd
                                                   (Evalof (Evar _shift tint)
                                                     tint)
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   tint) Enil)) tuint) tuint)
                                         tuint) tuint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _round tuint)
                                         (Ecall
                                           (Evalof
                                             (Evar _five_product_bit 
                                             (Tfunction
                                               ((tptr tuint) :: tint :: nil)
                                               tuint cc_default))
                                             (Tfunction
                                               ((tptr tuint) :: tint :: nil)
                                               tuint cc_default))
                                           (Econs
                                             (Evalof
                                               (Evar _p (tarray tuint 9))
                                               (tarray tuint 9))
                                             (Econs
                                               (Ebinop Osub
                                                 (Evalof (Evar _shift tint)
                                                   tint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tint) Enil)) tuint) tuint))
                                  (Ssequence
                                    (Sfor
                                      (Sdo (Eassign (Evar _i tint)
                                             (Eval (Vint (Int.repr 0)) tint)
                                             tint))
                                      (Ebinop Olt
                                        (Evalof (Evar _i tint) tint)
                                        (Eval (Vint (Int.repr 64)) tint)
                                        tint)
                                      (Sdo (Eassign (Evar _i tint)
                                             (Ebinop Oadd
                                               (Evalof (Evar _i tint) tint)
                                               (Eval (Vint (Int.repr 1)) tint)
                                               tint) tint))
                                      (Sdo (Eassign (Evar _frac tdouble)
                                             (Ebinop Oadd
                                               (Ebinop Omul
                                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                 (Evalof (Evar _frac tdouble)
                                                   tdouble) tdouble)
                                               (Ebinop Omul
                                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                 (Ecast
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _five_product_bit 
                                                       (Tfunction
                                                         ((tptr tuint) ::
                                                          tint :: nil) tuint
                                                         cc_default))
                                                       (Tfunction
                                                         ((tptr tuint) ::
                                                          tint :: nil) tuint
                                                         cc_default))
                                                     (Econs
                                                       (Evalof
                                                         (Evar _p (tarray tuint 9))
                                                         (tarray tuint 9))
                                                       (Econs
                                                         (Ebinop Oadd
                                                           (Ebinop Osub
                                                             (Evalof
                                                               (Evar _shift tint)
                                                               tint)
                                                             (Eval (Vint (Int.repr 64)) tint)
                                                             tint)
                                                           (Evalof
                                                             (Evar _i tint)
                                                             tint) tint)
                                                         Enil)) tuint)
                                                   tdouble) tdouble) tdouble)
                                             tdouble)))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _q tuint)
                                             (Ebinop Oand
                                               (Ebinop Oadd
                                                 (Evalof (Evar _q tuint)
                                                   tuint)
                                                 (Evalof (Evar _round tuint)
                                                   tuint) tuint)
                                               (Eval (Vint (Int.repr 3)) tuint)
                                               tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _frac tdouble)
                                               (Ebinop Osub
                                                 (Evalof (Evar _frac tdouble)
                                                   tdouble)
                                                 (Ecast
                                                   (Evalof
                                                     (Evar _round tuint)
                                                     tuint) tdouble) tdouble)
                                               tdouble))
                                        (Sdo (Eassign (Evar _r tdouble)
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _frac tdouble)
                                                     tdouble)
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                                                   tdouble)
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _frac tdouble)
                                                     tdouble)
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4364452196894661639))) tdouble)
                                                   tdouble) tdouble) tdouble)))))))))))))))
              (Ssequence
                (Sdo (Eassign (Evar _z tdouble)
                       (Ebinop Omul (Evalof (Evar _r tdouble) tdouble)
                         (Evalof (Evar _r tdouble) tdouble) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _sn tdouble)
                         (Ebinop Oadd (Evalof (Evar _r tdouble) tdouble)
                           (Ebinop Omul
                             (Ebinop Omul (Evalof (Evar _r tdouble) tdouble)
                               (Evalof (Evar _z tdouble) tdouble) tdouble)
                             (Ebinop Oadd
                               (Eunop Oneg
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4595172819793696085))) tdouble)
                                 tdouble)
                               (Ebinop Omul
                                 (Evalof (Evar _z tdouble) tdouble)
                                 (Ebinop Oadd
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4575957461383581969))) tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _z tdouble) tdouble)
                                     (Ebinop Oadd
                                       (Eunop Oneg
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4551452160554016794))) tdouble)
                                         tdouble)
                                       (Ebinop Omul
                                         (Evalof (Evar _z tdouble) tdouble)
                                         (Ebinop Oadd
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4523617214285662004))) tdouble)
                                           (Ebinop Omul
                                             (Evalof (Evar _z tdouble)
                                               tdouble)
                                             (Ebinop Oadd
                                               (Eunop Oneg
                                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4493156764026750180))) tdouble)
                                                 tdouble)
                                               (Ebinop Omul
                                                 (Evalof (Evar _z tdouble)
                                                   tdouble)
                                                 (Ebinop Oadd
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4460272573143870729))) tdouble)
                                                   (Ebinop Omul
                                                     (Evalof
                                                       (Evar _z tdouble)
                                                       tdouble)
                                                     (Ebinop Oadd
                                                       (Eunop Oneg
                                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4425604618586929183))) tdouble)
                                                         tdouble)
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Evar _z tdouble)
                                                           tdouble)
                                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4389130328383466826))) tdouble)
                                                         tdouble) tdouble)
                                                     tdouble) tdouble)
                                                 tdouble) tdouble) tdouble)
                                           tdouble) tdouble) tdouble)
                                     tdouble) tdouble) tdouble) tdouble)
                             tdouble) tdouble) tdouble))
                  (Ssequence
                    (Sdo (Eassign (Evar _cs tdouble)
                           (Ebinop Oadd
                             (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                             (Ebinop Omul (Evalof (Evar _z tdouble) tdouble)
                               (Ebinop Oadd
                                 (Eunop Oneg
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                   tdouble)
                                 (Ebinop Omul
                                   (Evalof (Evar _z tdouble) tdouble)
                                   (Ebinop Oadd
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4586165620538955093))) tdouble)
                                     (Ebinop Omul
                                       (Evalof (Evar _z tdouble) tdouble)
                                       (Ebinop Oadd
                                         (Eunop Oneg
                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4564047942368979991))) tdouble)
                                           tdouble)
                                         (Ebinop Omul
                                           (Evalof (Evar _z tdouble) tdouble)
                                           (Ebinop Oadd
                                             (Eval (Vfloat (Float.of_bits (Int64.repr 4537941361671905306))) tdouble)
                                             (Ebinop Omul
                                               (Evalof (Evar _z tdouble)
                                                 tdouble)
                                               (Ebinop Oadd
                                                 (Eunop Oneg
                                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4508805057796939612))) tdouble)
                                                   tdouble)
                                                 (Ebinop Omul
                                                   (Evalof (Evar _z tdouble)
                                                     tdouble)
                                                   (Ebinop Oadd
                                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4477122120089393304))) tdouble)
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _z tdouble)
                                                         tdouble)
                                                       (Ebinop Oadd
                                                         (Eunop Oneg
                                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4443145680587881629))) tdouble)
                                                           tdouble)
                                                         (Ebinop Omul
                                                           (Evalof
                                                             (Evar _z tdouble)
                                                             tdouble)
                                                           (Eval (Vfloat (Float.of_bits (Int64.repr 4407590220077447199))) tdouble)
                                                           tdouble) tdouble)
                                                       tdouble) tdouble)
                                                   tdouble) tdouble) tdouble)
                                             tdouble) tdouble) tdouble)
                                       tdouble) tdouble) tdouble) tdouble)
                               tdouble) tdouble) tdouble))
                    (Ssequence
                      (Sifthenelse (Evalof (Evar _cosine tuint) tuint)
                        (Sifthenelse (Ebinop Oeq
                                       (Evalof (Evar _q tuint) tuint)
                                       (Eval (Vint (Int.repr 0)) tuint) tint)
                          (Sdo (Eassign (Evar _y tdouble)
                                 (Evalof (Evar _cs tdouble) tdouble) tdouble))
                          (Sifthenelse (Ebinop Oeq
                                         (Evalof (Evar _q tuint) tuint)
                                         (Eval (Vint (Int.repr 1)) tuint)
                                         tint)
                            (Sdo (Eassign (Evar _y tdouble)
                                   (Eunop Oneg
                                     (Evalof (Evar _sn tdouble) tdouble)
                                     tdouble) tdouble))
                            (Sifthenelse (Ebinop Oeq
                                           (Evalof (Evar _q tuint) tuint)
                                           (Eval (Vint (Int.repr 2)) tuint)
                                           tint)
                              (Sdo (Eassign (Evar _y tdouble)
                                     (Eunop Oneg
                                       (Evalof (Evar _cs tdouble) tdouble)
                                       tdouble) tdouble))
                              (Sdo (Eassign (Evar _y tdouble)
                                     (Evalof (Evar _sn tdouble) tdouble)
                                     tdouble)))))
                        (Ssequence
                          (Sifthenelse (Ebinop Oeq
                                         (Evalof (Evar _q tuint) tuint)
                                         (Eval (Vint (Int.repr 0)) tuint)
                                         tint)
                            (Sdo (Eassign (Evar _y tdouble)
                                   (Evalof (Evar _sn tdouble) tdouble)
                                   tdouble))
                            (Sifthenelse (Ebinop Oeq
                                           (Evalof (Evar _q tuint) tuint)
                                           (Eval (Vint (Int.repr 1)) tuint)
                                           tint)
                              (Sdo (Eassign (Evar _y tdouble)
                                     (Evalof (Evar _cs tdouble) tdouble)
                                     tdouble))
                              (Sifthenelse (Ebinop Oeq
                                             (Evalof (Evar _q tuint) tuint)
                                             (Eval (Vint (Int.repr 2)) tuint)
                                             tint)
                                (Sdo (Eassign (Evar _y tdouble)
                                       (Eunop Oneg
                                         (Evalof (Evar _sn tdouble) tdouble)
                                         tdouble) tdouble))
                                (Sdo (Eassign (Evar _y tdouble)
                                       (Eunop Oneg
                                         (Evalof (Evar _cs tdouble) tdouble)
                                         tdouble) tdouble)))))
                          (Sifthenelse (Evalof (Evar _neg tuint) tuint)
                            (Sdo (Eassign (Evar _y tdouble)
                                   (Eunop Oneg
                                     (Evalof (Evar _y tdouble) tdouble)
                                     tdouble) tdouble))
                            Sskip)))
                      (Sreturn (Some (Ecast
                                       (Evalof (Evar _y tdouble) tdouble)
                                       tfloat))))))))))))))
|}.

Definition f_five_sinf := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _five_trig (Tfunction (tfloat :: tuint :: nil)
                                      tfloat cc_default))
                   (Tfunction (tfloat :: tuint :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _x tfloat) tfloat)
                   (Econs (Eval (Vint (Int.repr 0)) tuint) Enil)) tfloat)))
|}.

Definition f_five_cosf := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_x, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _five_trig (Tfunction (tfloat :: tuint :: nil)
                                      tfloat cc_default))
                   (Tfunction (tfloat :: tuint :: nil) tfloat cc_default))
                 (Econs (Evalof (Evar _x tfloat) tfloat)
                   (Econs (Eval (Vint (Int.repr 1)) tuint) Enil)) tfloat)))
|}.

Definition f_float_rmat_of_eulers_321 := {|
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
           (Evalof
             (Evar _five_sinf (Tfunction (tfloat :: nil) tfloat cc_default))
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
               (Evar _five_cosf (Tfunction (tfloat :: nil) tfloat cc_default))
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
                 (Evar _five_sinf (Tfunction (tfloat :: nil) tfloat
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
                       (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
                 Enil) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign (Evar _ctheta tfloat)
               (Ecall
                 (Evalof
                   (Evar _five_cosf (Tfunction (tfloat :: nil) tfloat
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
                     tfloat) Enil) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign (Evar _spsi tfloat)
                 (Ecall
                   (Evalof
                     (Evar _five_sinf (Tfunction (tfloat :: nil) tfloat
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
                       (Evar _five_cosf (Tfunction (tfloat :: nil) tfloat
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
                     (Ebinop Omul (Evalof (Evar _ctheta tfloat) tfloat)
                       (Evalof (Evar _cpsi tfloat) tfloat) tfloat) tfloat))
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
                       (Ebinop Omul (Evalof (Evar _ctheta tfloat) tfloat)
                         (Evalof (Evar _spsi tfloat) tfloat) tfloat) tfloat))
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
                         (Eunop Oneg (Evalof (Evar _stheta tfloat) tfloat)
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
                           (Ebinop Osub
                             (Ebinop Omul
                               (Ebinop Omul
                                 (Evalof (Evar _sphi tfloat) tfloat)
                                 (Evalof (Evar _stheta tfloat) tfloat)
                                 tfloat) (Evalof (Evar _cpsi tfloat) tfloat)
                               tfloat)
                             (Ebinop Omul (Evalof (Evar _cphi tfloat) tfloat)
                               (Evalof (Evar _spsi tfloat) tfloat) tfloat)
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
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof (Evar _sphi tfloat) tfloat)
                                   (Evalof (Evar _stheta tfloat) tfloat)
                                   tfloat)
                                 (Evalof (Evar _spsi tfloat) tfloat) tfloat)
                               (Ebinop Omul
                                 (Evalof (Evar _cphi tfloat) tfloat)
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
                                     (Ebinop Omul
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 3)) tint) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   (tptr tfloat)) tfloat)
                               (Ebinop Omul
                                 (Evalof (Evar _sphi tfloat) tfloat)
                                 (Evalof (Evar _ctheta tfloat) tfloat)
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
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (Eval (Vint (Int.repr 3)) tint)
                                         tint)
                                       (Eval (Vint (Int.repr 0)) tint) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Ebinop Omul
                                       (Evalof (Evar _cphi tfloat) tfloat)
                                       (Evalof (Evar _stheta tfloat) tfloat)
                                       tfloat)
                                     (Evalof (Evar _cpsi tfloat) tfloat)
                                     tfloat)
                                   (Ebinop Omul
                                     (Evalof (Evar _sphi tfloat) tfloat)
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
                                       (Ebinop Omul
                                         (Evalof (Evar _cphi tfloat) tfloat)
                                         (Evalof (Evar _stheta tfloat)
                                           tfloat) tfloat)
                                       (Evalof (Evar _spsi tfloat) tfloat)
                                       tfloat)
                                     (Ebinop Omul
                                       (Evalof (Evar _sphi tfloat) tfloat)
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

Definition composites : list composite_definition :=
(Composite _FloatRMat Struct
   (Member_plain _m (tarray tfloat 9) :: nil)
   noattr ::
 Composite _FloatEulers Struct
   (Member_plain _phi tfloat :: Member_plain _theta tfloat ::
    Member_plain _psi tfloat :: nil)
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
 (_five_two_over_pi, Gvar v_five_two_over_pi) ::
 (_five_copy4, Gfun(Internal f_five_copy4)) ::
 (_five_float_bits, Gfun(Internal f_five_float_bits)) ::
 (_five_float_from_bits, Gfun(Internal f_five_float_from_bits)) ::
 (_five_product_bit, Gfun(Internal f_five_product_bit)) ::
 (_five_trig, Gfun(Internal f_five_trig)) ::
 (_five_sinf, Gfun(Internal f_five_sinf)) ::
 (_five_cosf, Gfun(Internal f_five_cosf)) ::
 (_float_rmat_of_eulers_321, Gfun(Internal f_float_rmat_of_eulers_321)) ::
 nil).

Definition public_idents : list ident :=
(_float_rmat_of_eulers_321 :: _five_cosf :: _five_sinf ::
 _five_float_from_bits :: _five_float_bits :: ___builtin_debug ::
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


