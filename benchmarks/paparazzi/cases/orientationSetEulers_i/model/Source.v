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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/connected-models/orientation_cache/model/preprocessed.i".
End Info.

Definition _FloatEulers : ident := $"FloatEulers".
Definition _FloatQuat : ident := $"FloatQuat".
Definition _FloatRMat : ident := $"FloatRMat".
Definition _Int32Eulers : ident := $"Int32Eulers".
Definition _Int32Quat : ident := $"Int32Quat".
Definition _Int32RMat : ident := $"Int32RMat".
Definition _OrientationReps : ident := $"OrientationReps".
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
Definition _eulers : ident := $"eulers".
Definition _eulers_f : ident := $"eulers_f".
Definition _eulers_i : ident := $"eulers_i".
Definition _eulers_zxy_f : ident := $"eulers_zxy_f".
Definition _five_keep_orienationCheckValid : ident := $"five_keep_orienationCheckValid".
Definition _five_keep_orientationCalcEulersZxy_f : ident := $"five_keep_orientationCalcEulersZxy_f".
Definition _five_keep_orientationCalcEulers_f : ident := $"five_keep_orientationCalcEulers_f".
Definition _five_keep_orientationCalcEulers_i : ident := $"five_keep_orientationCalcEulers_i".
Definition _five_keep_orientationCalcQuat_f : ident := $"five_keep_orientationCalcQuat_f".
Definition _five_keep_orientationCalcQuat_i : ident := $"five_keep_orientationCalcQuat_i".
Definition _five_keep_orientationCalcRMat_f : ident := $"five_keep_orientationCalcRMat_f".
Definition _five_keep_orientationCalcRMat_i : ident := $"five_keep_orientationCalcRMat_i".
Definition _five_keep_orientationGetEulersZxy_f : ident := $"five_keep_orientationGetEulersZxy_f".
Definition _five_keep_orientationGetEulers_f : ident := $"five_keep_orientationGetEulers_f".
Definition _five_keep_orientationGetEulers_i : ident := $"five_keep_orientationGetEulers_i".
Definition _five_keep_orientationGetQuat_f : ident := $"five_keep_orientationGetQuat_f".
Definition _five_keep_orientationGetQuat_i : ident := $"five_keep_orientationGetQuat_i".
Definition _five_keep_orientationGetRMat_f : ident := $"five_keep_orientationGetRMat_f".
Definition _five_keep_orientationGetRMat_i : ident := $"five_keep_orientationGetRMat_i".
Definition _five_keep_orientationSetEulers_f : ident := $"five_keep_orientationSetEulers_f".
Definition _five_keep_orientationSetEulers_i : ident := $"five_keep_orientationSetEulers_i".
Definition _five_keep_orientationSetIdentity : ident := $"five_keep_orientationSetIdentity".
Definition _five_keep_orientationSetQuat_f : ident := $"five_keep_orientationSetQuat_f".
Definition _five_keep_orientationSetQuat_i : ident := $"five_keep_orientationSetQuat_i".
Definition _five_keep_orientationSetRMat_f : ident := $"five_keep_orientationSetRMat_f".
Definition _five_keep_orientationSetRMat_i : ident := $"five_keep_orientationSetRMat_i".
Definition _float_eulers_of_quat : ident := $"float_eulers_of_quat".
Definition _float_eulers_of_quat_zxy : ident := $"float_eulers_of_quat_zxy".
Definition _float_eulers_of_rmat : ident := $"float_eulers_of_rmat".
Definition _float_quat_of_eulers : ident := $"float_quat_of_eulers".
Definition _float_quat_of_rmat : ident := $"float_quat_of_rmat".
Definition _float_rmat_of_eulers_321 : ident := $"float_rmat_of_eulers_321".
Definition _float_rmat_of_quat : ident := $"float_rmat_of_quat".
Definition _int32_eulers_of_quat : ident := $"int32_eulers_of_quat".
Definition _int32_eulers_of_rmat : ident := $"int32_eulers_of_rmat".
Definition _int32_quat_identity : ident := $"int32_quat_identity".
Definition _int32_quat_of_eulers : ident := $"int32_quat_of_eulers".
Definition _int32_quat_of_rmat : ident := $"int32_quat_of_rmat".
Definition _int32_rmat_of_eulers_321 : ident := $"int32_rmat_of_eulers_321".
Definition _int32_rmat_of_quat : ident := $"int32_rmat_of_quat".
Definition _m : ident := $"m".
Definition _main : ident := $"main".
Definition _memcpy : ident := $"memcpy".
Definition _orienationCheckValid : ident := $"orienationCheckValid".
Definition _orientation : ident := $"orientation".
Definition _orientationCalcEulersZxy_f : ident := $"orientationCalcEulersZxy_f".
Definition _orientationCalcEulers_f : ident := $"orientationCalcEulers_f".
Definition _orientationCalcEulers_i : ident := $"orientationCalcEulers_i".
Definition _orientationCalcQuat_f : ident := $"orientationCalcQuat_f".
Definition _orientationCalcQuat_i : ident := $"orientationCalcQuat_i".
Definition _orientationCalcRMat_f : ident := $"orientationCalcRMat_f".
Definition _orientationCalcRMat_i : ident := $"orientationCalcRMat_i".
Definition _orientationGetEulersZxy_f : ident := $"orientationGetEulersZxy_f".
Definition _orientationGetEulers_f : ident := $"orientationGetEulers_f".
Definition _orientationGetEulers_i : ident := $"orientationGetEulers_i".
Definition _orientationGetQuat_f : ident := $"orientationGetQuat_f".
Definition _orientationGetQuat_i : ident := $"orientationGetQuat_i".
Definition _orientationGetRMat_f : ident := $"orientationGetRMat_f".
Definition _orientationGetRMat_i : ident := $"orientationGetRMat_i".
Definition _orientationSetEulers_f : ident := $"orientationSetEulers_f".
Definition _orientationSetEulers_i : ident := $"orientationSetEulers_i".
Definition _orientationSetIdentity : ident := $"orientationSetIdentity".
Definition _orientationSetQuat_f : ident := $"orientationSetQuat_f".
Definition _orientationSetQuat_i : ident := $"orientationSetQuat_i".
Definition _orientationSetRMat_f : ident := $"orientationSetRMat_f".
Definition _orientationSetRMat_i : ident := $"orientationSetRMat_i".
Definition _phi : ident := $"phi".
Definition _psi : ident := $"psi".
Definition _q : ident := $"q".
Definition _qi : ident := $"qi".
Definition _quat : ident := $"quat".
Definition _quat_f : ident := $"quat_f".
Definition _quat_i : ident := $"quat_i".
Definition _qx : ident := $"qx".
Definition _qy : ident := $"qy".
Definition _qz : ident := $"qz".
Definition _rmat : ident := $"rmat".
Definition _rmat_f : ident := $"rmat_f".
Definition _rmat_i : ident := $"rmat_i".
Definition _status : ident := $"status".
Definition _theta : ident := $"theta".

Definition f_int32_quat_identity := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_q, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                 (tptr (Tstruct _Int32Quat noattr)))
               (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr)) _qi
           tint)
         (Ebinop Omul (Eval (Vint (Int.repr 1)) tint)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 15)) tint) tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qx tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qy tint) (Eval (Vint (Int.repr 0)) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _q (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qz tint) (Eval (Vint (Int.repr 0)) tint) tint)))))
|}.

Definition f_orienationCheckValid := {|
  fn_return := tbool;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _status tuchar)
                 tuchar)))
|}.

Definition f_orientationSetIdentity := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _int32_quat_identity (Tfunction
                                        ((tptr (Tstruct _Int32Quat noattr)) ::
                                         nil) tvoid cc_default))
           (Tfunction ((tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
             cc_default))
         (Econs
           (Eaddrof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                     (tptr (Tstruct _OrientationReps noattr)))
                   (Tstruct _OrientationReps noattr))
                 (Tstruct _OrientationReps noattr)) _quat_i
               (Tstruct _Int32Quat noattr))
             (tptr (Tstruct _Int32Quat noattr))) Enil) tvoid))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 0)) tint) tint) tuchar)))
|}.

Definition f_orientationSetQuat_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                (_quat, (tptr (Tstruct _Int32Quat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                       (tptr (Tstruct _OrientationReps noattr)))
                     (Tstruct _OrientationReps noattr))
                   (Tstruct _OrientationReps noattr)) _quat_i
                 (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
             _qi tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _quat (tptr (Tstruct _Int32Quat noattr)))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qi tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _quat_i
                   (Tstruct _Int32Quat noattr)) (Tstruct _Int32Quat noattr))
               _qx tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _quat (tptr (Tstruct _Int32Quat noattr)))
                       (tptr (Tstruct _Int32Quat noattr)))
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qx tint) tint) tint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_i
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qy tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _quat (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qy tint) tint) tint))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_i
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qz tint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _quat (tptr (Tstruct _Int32Quat noattr)))
                         (tptr (Tstruct _Int32Quat noattr)))
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qz tint) tint) tint)))))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 0)) tint) tint) tuchar)))
|}.

Definition f_orientationSetRMat_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                (_rmat, (tptr (Tstruct _Int32RMat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _memcpy (Tfunction
                           ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                           (tptr tvoid) cc_default))
           (Tfunction ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
             (tptr tvoid) cc_default))
         (Econs
           (Eaddrof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                     (tptr (Tstruct _OrientationReps noattr)))
                   (Tstruct _OrientationReps noattr))
                 (Tstruct _OrientationReps noattr)) _rmat_i
               (Tstruct _Int32RMat noattr))
             (tptr (Tstruct _Int32RMat noattr)))
           (Econs
             (Eaddrof
               (Ederef
                 (Evalof (Evar _rmat (tptr (Tstruct _Int32RMat noattr)))
                   (tptr (Tstruct _Int32RMat noattr)))
                 (Tstruct _Int32RMat noattr))
               (tptr (Tstruct _Int32RMat noattr)))
             (Econs (Esizeof (Tstruct _Int32RMat noattr) tulong) Enil)))
         (tptr tvoid)))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 2)) tint) tint) tuchar)))
|}.

Definition f_orientationSetEulers_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                (_eulers, (tptr (Tstruct _Int32Eulers noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                       (tptr (Tstruct _OrientationReps noattr)))
                     (Tstruct _OrientationReps noattr))
                   (Tstruct _OrientationReps noattr)) _eulers_i
                 (Tstruct _Int32Eulers noattr))
               (Tstruct _Int32Eulers noattr)) _phi tint)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _eulers (tptr (Tstruct _Int32Eulers noattr)))
                     (tptr (Tstruct _Int32Eulers noattr)))
                   (Tstruct _Int32Eulers noattr))
                 (Tstruct _Int32Eulers noattr)) _phi tint) tint) tint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _eulers_i
                   (Tstruct _Int32Eulers noattr))
                 (Tstruct _Int32Eulers noattr)) _theta tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _eulers (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _theta tint) tint) tint))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _eulers_i
                   (Tstruct _Int32Eulers noattr))
                 (Tstruct _Int32Eulers noattr)) _psi tint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _eulers (tptr (Tstruct _Int32Eulers noattr)))
                       (tptr (Tstruct _Int32Eulers noattr)))
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _psi tint) tint) tint))))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 1)) tint) tint) tuchar)))
|}.

Definition f_orientationSetQuat_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                (_quat, (tptr (Tstruct _FloatQuat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                       (tptr (Tstruct _OrientationReps noattr)))
                     (Tstruct _OrientationReps noattr))
                   (Tstruct _OrientationReps noattr)) _quat_f
                 (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
             _qi tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _quat (tptr (Tstruct _FloatQuat noattr)))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qi tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _quat_f
                   (Tstruct _FloatQuat noattr)) (Tstruct _FloatQuat noattr))
               _qx tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _quat (tptr (Tstruct _FloatQuat noattr)))
                       (tptr (Tstruct _FloatQuat noattr)))
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat) tfloat))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_f
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qy tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _quat (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat) tfloat))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_f
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qz tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _quat (tptr (Tstruct _FloatQuat noattr)))
                         (tptr (Tstruct _FloatQuat noattr)))
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat) tfloat)))))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 3)) tint) tint) tuchar)))
|}.

Definition f_orientationSetRMat_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                (_rmat, (tptr (Tstruct _FloatRMat noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _memcpy (Tfunction
                           ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                           (tptr tvoid) cc_default))
           (Tfunction ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
             (tptr tvoid) cc_default))
         (Econs
           (Eaddrof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                     (tptr (Tstruct _OrientationReps noattr)))
                   (Tstruct _OrientationReps noattr))
                 (Tstruct _OrientationReps noattr)) _rmat_f
               (Tstruct _FloatRMat noattr))
             (tptr (Tstruct _FloatRMat noattr)))
           (Econs
             (Eaddrof
               (Ederef
                 (Evalof (Evar _rmat (tptr (Tstruct _FloatRMat noattr)))
                   (tptr (Tstruct _FloatRMat noattr)))
                 (Tstruct _FloatRMat noattr))
               (tptr (Tstruct _FloatRMat noattr)))
             (Econs (Esizeof (Tstruct _FloatRMat noattr) tulong) Enil)))
         (tptr tvoid)))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 5)) tint) tint) tuchar)))
|}.

Definition f_orientationSetEulers_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                (_eulers, (tptr (Tstruct _FloatEulers noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                       (tptr (Tstruct _OrientationReps noattr)))
                     (Tstruct _OrientationReps noattr))
                   (Tstruct _OrientationReps noattr)) _eulers_f
                 (Tstruct _FloatEulers noattr))
               (Tstruct _FloatEulers noattr)) _phi tfloat)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _eulers (tptr (Tstruct _FloatEulers noattr)))
                     (tptr (Tstruct _FloatEulers noattr)))
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _eulers_f
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _theta tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _eulers (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _theta tfloat) tfloat)
             tfloat))
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _eulers_f
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)) _psi tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _eulers (tptr (Tstruct _FloatEulers noattr)))
                       (tptr (Tstruct _FloatEulers noattr)))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
             tfloat))))
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr)))
               (Tstruct _OrientationReps noattr))
             (Tstruct _OrientationReps noattr)) _status tuchar)
         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
           (Eval (Vint (Int.repr 4)) tint) tint) tuchar)))
|}.

Definition f_orientationGetQuat_i := {|
  fn_return := (tptr (Tstruct _Int32Quat noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 0)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcQuat_i (Tfunction
                                            ((tptr (Tstruct _OrientationReps noattr)) ::
                                             nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_i
                     (Tstruct _Int32Quat noattr))
                   (tptr (Tstruct _Int32Quat noattr))))))
|}.

Definition f_orientationGetRMat_i := {|
  fn_return := (tptr (Tstruct _Int32RMat noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 2)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcRMat_i (Tfunction
                                            ((tptr (Tstruct _OrientationReps noattr)) ::
                                             nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _rmat_i
                     (Tstruct _Int32RMat noattr))
                   (tptr (Tstruct _Int32RMat noattr))))))
|}.

Definition f_orientationGetEulers_i := {|
  fn_return := (tptr (Tstruct _Int32Eulers noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcEulers_i (Tfunction
                                              ((tptr (Tstruct _OrientationReps noattr)) ::
                                               nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_i
                     (Tstruct _Int32Eulers noattr))
                   (tptr (Tstruct _Int32Eulers noattr))))))
|}.

Definition f_orientationGetQuat_f := {|
  fn_return := (tptr (Tstruct _FloatQuat noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcQuat_f (Tfunction
                                            ((tptr (Tstruct _OrientationReps noattr)) ::
                                             nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_f
                     (Tstruct _FloatQuat noattr))
                   (tptr (Tstruct _FloatQuat noattr))))))
|}.

Definition f_orientationGetRMat_f := {|
  fn_return := (tptr (Tstruct _FloatRMat noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 5)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcRMat_f (Tfunction
                                            ((tptr (Tstruct _OrientationReps noattr)) ::
                                             nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _rmat_f
                     (Tstruct _FloatRMat noattr))
                   (tptr (Tstruct _FloatRMat noattr))))))
|}.

Definition f_orientationGetEulers_f := {|
  fn_return := (tptr (Tstruct _FloatEulers noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 4)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcEulers_f (Tfunction
                                              ((tptr (Tstruct _OrientationReps noattr)) ::
                                               nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_f
                     (Tstruct _FloatEulers noattr))
                   (tptr (Tstruct _FloatEulers noattr))))))
|}.

Definition f_orientationGetEulersZxy_f := {|
  fn_return := (tptr (Tstruct _FloatEulers noattr));
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Eunop Onotbool
                 (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 6)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint) tint)
    (Sdo (Ecall
           (Evalof
             (Evar _orientationCalcEulersZxy_f (Tfunction
                                                 ((tptr (Tstruct _OrientationReps noattr)) ::
                                                  nil) tvoid cc_default))
             (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
               tvoid cc_default))
           (Econs
             (Evalof
               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
               (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
    Sskip)
  (Sreturn (Some (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_zxy_f
                     (Tstruct _FloatEulers noattr))
                   (tptr (Tstruct _FloatEulers noattr))))))
|}.

Definition f_orientationCalcQuat_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 0)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 3)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_i
                     (Tstruct _Int32Quat noattr))
                   (Tstruct _Int32Quat noattr)) _qi tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_f
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qi tfloat) tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _quat_i
                       (Tstruct _Int32Quat noattr))
                     (Tstruct _Int32Quat noattr)) _qx tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _quat_f
                           (Tstruct _FloatQuat noattr))
                         (Tstruct _FloatQuat noattr)) _qx tfloat) tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tint))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_i
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qy tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_f
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qy tfloat) tfloat)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tint))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_i
                         (Tstruct _Int32Quat noattr))
                       (Tstruct _Int32Quat noattr)) _qz tint)
                   (Ebinop Omul
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_f
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qz tfloat) tfloat)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tint)))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 2)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _int32_quat_of_rmat (Tfunction
                                             ((tptr (Tstruct _Int32Quat noattr)) ::
                                              (tptr (Tstruct _Int32RMat noattr)) ::
                                              nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _Int32Quat noattr)) ::
                    (tptr (Tstruct _Int32RMat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_i
                     (Tstruct _Int32Quat noattr))
                   (tptr (Tstruct _Int32Quat noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _rmat_i
                       (Tstruct _Int32RMat noattr))
                     (tptr (Tstruct _Int32RMat noattr))) Enil)) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _status
                             tuchar) tuchar) (Eval (Vint (Int.repr 1)) tint)
                         tint) (Eval (Vint (Int.repr 1)) tint) tint)
          (Sdo (Ecall
                 (Evalof
                   (Evar _int32_quat_of_eulers (Tfunction
                                                 ((tptr (Tstruct _Int32Quat noattr)) ::
                                                  (tptr (Tstruct _Int32Eulers noattr)) ::
                                                  nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _Int32Quat noattr)) ::
                      (tptr (Tstruct _Int32Eulers noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _quat_i
                       (Tstruct _Int32Quat noattr))
                     (tptr (Tstruct _Int32Quat noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _eulers_i
                         (Tstruct _Int32Eulers noattr))
                       (tptr (Tstruct _Int32Eulers noattr))) Enil)) tvoid))
          (Sifthenelse (Ebinop Oand
                         (Ebinop Oshr
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _status
                               tuchar) tuchar)
                           (Eval (Vint (Int.repr 5)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_i (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                       (Ebinop Omul
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
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_f (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                       tint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_i (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                           tint)
                         (Ebinop Omul
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
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_i (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                             tint)
                           (Ebinop Omul
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
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_f
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                           tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                               tint)
                             (Ebinop Omul
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_f
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 3)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tint))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_i
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tint)) tint)
                               (Ebinop Omul
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
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_f
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 4)) tint)
                                       (tptr tfloat)) tfloat) tfloat)
                                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tfloat) tint))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_i
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tint)) tint)
                                 (Ebinop Omul
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
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_f
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 5)) tint)
                                         (tptr tfloat)) tfloat) tfloat)
                                   (Ebinop Oshl
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tfloat) tint))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_i
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 6)) tint)
                                       (tptr tint)) tint)
                                   (Ebinop Omul
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
                                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                         (tptr (Tstruct _OrientationReps noattr)))
                                                       (Tstruct _OrientationReps noattr))
                                                     (Tstruct _OrientationReps noattr))
                                                   _rmat_f
                                                   (Tstruct _FloatRMat noattr))
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Eval (Vint (Int.repr 6)) tint)
                                           (tptr tfloat)) tfloat) tfloat)
                                     (Ebinop Oshl
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tfloat) tint))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_i
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 7)) tint)
                                         (tptr tint)) tint)
                                     (Ebinop Omul
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
                                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                           (tptr (Tstruct _OrientationReps noattr)))
                                                         (Tstruct _OrientationReps noattr))
                                                       (Tstruct _OrientationReps noattr))
                                                     _rmat_f
                                                     (Tstruct _FloatRMat noattr))
                                                   (Tstruct _FloatRMat noattr))
                                                 _m (tarray tfloat 9))
                                               (tarray tfloat 9))
                                             (Eval (Vint (Int.repr 7)) tint)
                                             (tptr tfloat)) tfloat) tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tint))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_i
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 8)) tint)
                                         (tptr tint)) tint)
                                     (Ebinop Omul
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
                                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                           (tptr (Tstruct _OrientationReps noattr)))
                                                         (Tstruct _OrientationReps noattr))
                                                       (Tstruct _OrientationReps noattr))
                                                     _rmat_f
                                                     (Tstruct _FloatRMat noattr))
                                                   (Tstruct _FloatRMat noattr))
                                                 _m (tarray tfloat 9))
                                               (tarray tfloat 9))
                                             (Eval (Vint (Int.repr 8)) tint)
                                             (tptr tfloat)) tfloat) tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tint))))))))))
              (Ssequence
                (Sdo (Eassignop Oor
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint) tint tuchar))
                (Sdo (Ecall
                       (Evalof
                         (Evar _int32_quat_of_rmat (Tfunction
                                                     ((tptr (Tstruct _Int32Quat noattr)) ::
                                                      (tptr (Tstruct _Int32RMat noattr)) ::
                                                      nil) tvoid cc_default))
                         (Tfunction
                           ((tptr (Tstruct _Int32Quat noattr)) ::
                            (tptr (Tstruct _Int32RMat noattr)) :: nil) tvoid
                           cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_i
                             (Tstruct _Int32Quat noattr))
                           (tptr (Tstruct _Int32Quat noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_i
                               (Tstruct _Int32RMat noattr))
                             (tptr (Tstruct _Int32RMat noattr))) Enil))
                       tvoid))))
            (Sifthenelse (Ebinop Oand
                           (Ebinop Oshr
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _status
                                 tuchar) tuchar)
                             (Eval (Vint (Int.repr 4)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _eulers_i
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _phi tint)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _eulers_f (Tstruct _FloatEulers noattr))
                                 (Tstruct _FloatEulers noattr)) _phi tfloat)
                             tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_i (Tstruct _Int32Eulers noattr))
                               (Tstruct _Int32Eulers noattr)) _theta tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _eulers_f (Tstruct _FloatEulers noattr))
                                   (Tstruct _FloatEulers noattr)) _theta
                                 tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tint))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_i (Tstruct _Int32Eulers noattr))
                               (Tstruct _Int32Eulers noattr)) _psi tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _eulers_f (Tstruct _FloatEulers noattr))
                                   (Tstruct _FloatEulers noattr)) _psi
                                 tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tint))))
                (Ssequence
                  (Sdo (Eassignop Oor
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint) tint tuchar))
                  (Sdo (Ecall
                         (Evalof
                           (Evar _int32_quat_of_eulers (Tfunction
                                                         ((tptr (Tstruct _Int32Quat noattr)) ::
                                                          (tptr (Tstruct _Int32Eulers noattr)) ::
                                                          nil) tvoid
                                                         cc_default))
                           (Tfunction
                             ((tptr (Tstruct _Int32Quat noattr)) ::
                              (tptr (Tstruct _Int32Eulers noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_i
                               (Tstruct _Int32Quat noattr))
                             (tptr (Tstruct _Int32Quat noattr)))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_i (Tstruct _Int32Eulers noattr))
                               (tptr (Tstruct _Int32Eulers noattr))) Enil))
                         tvoid))))
              Sskip)))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                   (tptr (Tstruct _OrientationReps noattr)))
                 (Tstruct _OrientationReps noattr))
               (Tstruct _OrientationReps noattr)) _status tuchar)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 0)) tint) tint) tint tuchar))))
|}.

Definition f_orientationCalcRMat_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 2)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 5)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _rmat_i
                           (Tstruct _Int32RMat noattr))
                         (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                     (tarray tint 9)) (Eval (Vint (Int.repr 0)) tint)
                   (tptr tint)) tint)
               (Ebinop Omul
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
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_f
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 0)) tint) (tptr tfloat)) tfloat)
                   tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tint))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _rmat_i
                             (Tstruct _Int32RMat noattr))
                           (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                       (tarray tint 9)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tint)) tint)
                 (Ebinop Omul
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
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _rmat_f
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                       tfloat) tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tint))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_i
                               (Tstruct _Int32RMat noattr))
                             (Tstruct _Int32RMat noattr)) _m (tarray tint 9))
                         (tarray tint 9)) (Eval (Vint (Int.repr 2)) tint)
                       (tptr tint)) tint)
                   (Ebinop Omul
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
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_f (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                         tfloat) tfloat)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tint))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _rmat_i
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 3)) tint) (tptr tint)) tint)
                     (Ebinop Omul
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
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_f (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                           tfloat) tfloat)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_i (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 4)) tint) (tptr tint)) tint)
                       (Ebinop Omul
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
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_f (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                       tint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_i (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 5)) tint) (tptr tint))
                           tint)
                         (Ebinop Omul
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
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 5)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_i (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 6)) tint) (tptr tint))
                             tint)
                           (Ebinop Omul
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
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_f
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 6)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                           tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 7)) tint) (tptr tint))
                               tint)
                             (Ebinop Omul
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_f
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 7)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tint))
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 8)) tint) (tptr tint))
                               tint)
                             (Ebinop Omul
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_f
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 8)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tint))))))))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 0)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _int32_rmat_of_quat (Tfunction
                                             ((tptr (Tstruct _Int32RMat noattr)) ::
                                              (tptr (Tstruct _Int32Quat noattr)) ::
                                              nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _Int32RMat noattr)) ::
                    (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _rmat_i
                     (Tstruct _Int32RMat noattr))
                   (tptr (Tstruct _Int32RMat noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _quat_i
                       (Tstruct _Int32Quat noattr))
                     (tptr (Tstruct _Int32Quat noattr))) Enil)) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _status
                             tuchar) tuchar) (Eval (Vint (Int.repr 1)) tint)
                         tint) (Eval (Vint (Int.repr 1)) tint) tint)
          (Sdo (Ecall
                 (Evalof
                   (Evar _int32_rmat_of_eulers_321 (Tfunction
                                                     ((tptr (Tstruct _Int32RMat noattr)) ::
                                                      (tptr (Tstruct _Int32Eulers noattr)) ::
                                                      nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _Int32RMat noattr)) ::
                      (tptr (Tstruct _Int32Eulers noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _rmat_i
                       (Tstruct _Int32RMat noattr))
                     (tptr (Tstruct _Int32RMat noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _eulers_i
                         (Tstruct _Int32Eulers noattr))
                       (tptr (Tstruct _Int32Eulers noattr))) Enil)) tvoid))
          (Sifthenelse (Ebinop Oand
                         (Ebinop Oshr
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _status
                               tuchar) tuchar)
                           (Eval (Vint (Int.repr 3)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_i
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qi tint)
                       (Ebinop Omul
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_f
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qi tfloat)
                           tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                       tint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_i
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qx tint)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_f (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qx tfloat)
                             tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_i
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qy tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _quat_f (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qy tfloat)
                               tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                           tint))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_i
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qz tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _quat_f (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qz tfloat)
                               tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                           tint)))))
              (Ssequence
                (Sdo (Eassignop Oor
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint) tint tuchar))
                (Sdo (Ecall
                       (Evalof
                         (Evar _int32_rmat_of_quat (Tfunction
                                                     ((tptr (Tstruct _Int32RMat noattr)) ::
                                                      (tptr (Tstruct _Int32Quat noattr)) ::
                                                      nil) tvoid cc_default))
                         (Tfunction
                           ((tptr (Tstruct _Int32RMat noattr)) ::
                            (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
                           cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _rmat_i
                             (Tstruct _Int32RMat noattr))
                           (tptr (Tstruct _Int32RMat noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_i
                               (Tstruct _Int32Quat noattr))
                             (tptr (Tstruct _Int32Quat noattr))) Enil))
                       tvoid))))
            (Sifthenelse (Ebinop Oand
                           (Ebinop Oshr
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _status
                                 tuchar) tuchar)
                             (Eval (Vint (Int.repr 4)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _eulers_i
                               (Tstruct _Int32Eulers noattr))
                             (Tstruct _Int32Eulers noattr)) _phi tint)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _eulers_f (Tstruct _FloatEulers noattr))
                                 (Tstruct _FloatEulers noattr)) _phi tfloat)
                             tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_i (Tstruct _Int32Eulers noattr))
                               (Tstruct _Int32Eulers noattr)) _theta tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _eulers_f (Tstruct _FloatEulers noattr))
                                   (Tstruct _FloatEulers noattr)) _theta
                                 tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tint))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_i (Tstruct _Int32Eulers noattr))
                               (Tstruct _Int32Eulers noattr)) _psi tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _eulers_f (Tstruct _FloatEulers noattr))
                                   (Tstruct _FloatEulers noattr)) _psi
                                 tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tint))))
                (Ssequence
                  (Sdo (Eassignop Oor
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint) tint tuchar))
                  (Sdo (Ecall
                         (Evalof
                           (Evar _int32_rmat_of_eulers_321 (Tfunction
                                                             ((tptr (Tstruct _Int32RMat noattr)) ::
                                                              (tptr (Tstruct _Int32Eulers noattr)) ::
                                                              nil) tvoid
                                                             cc_default))
                           (Tfunction
                             ((tptr (Tstruct _Int32RMat noattr)) ::
                              (tptr (Tstruct _Int32Eulers noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_i
                               (Tstruct _Int32RMat noattr))
                             (tptr (Tstruct _Int32RMat noattr)))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_i (Tstruct _Int32Eulers noattr))
                               (tptr (Tstruct _Int32Eulers noattr))) Enil))
                         tvoid))))
              Sskip)))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                   (tptr (Tstruct _OrientationReps noattr)))
                 (Tstruct _OrientationReps noattr))
               (Tstruct _OrientationReps noattr)) _status tuchar)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 2)) tint) tint) tint tuchar))))
|}.

Definition f_orientationCalcEulers_i := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 1)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 4)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_i
                     (Tstruct _Int32Eulers noattr))
                   (Tstruct _Int32Eulers noattr)) _phi tint)
               (Ebinop Omul
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _eulers_f
                         (Tstruct _FloatEulers noattr))
                       (Tstruct _FloatEulers noattr)) _phi tfloat) tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tfloat) tint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _eulers_i
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _theta tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _eulers_f
                           (Tstruct _FloatEulers noattr))
                         (Tstruct _FloatEulers noattr)) _theta tfloat)
                     tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 12)) tint) tint) tfloat) tint))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _eulers_i
                       (Tstruct _Int32Eulers noattr))
                     (Tstruct _Int32Eulers noattr)) _psi tint)
                 (Ebinop Omul
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _eulers_f
                           (Tstruct _FloatEulers noattr))
                         (Tstruct _FloatEulers noattr)) _psi tfloat) tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 12)) tint) tint) tfloat) tint))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 2)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _int32_eulers_of_rmat (Tfunction
                                               ((tptr (Tstruct _Int32Eulers noattr)) ::
                                                (tptr (Tstruct _Int32RMat noattr)) ::
                                                nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _Int32Eulers noattr)) ::
                    (tptr (Tstruct _Int32RMat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_i
                     (Tstruct _Int32Eulers noattr))
                   (tptr (Tstruct _Int32Eulers noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _rmat_i
                       (Tstruct _Int32RMat noattr))
                     (tptr (Tstruct _Int32RMat noattr))) Enil)) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _status
                             tuchar) tuchar) (Eval (Vint (Int.repr 0)) tint)
                         tint) (Eval (Vint (Int.repr 1)) tint) tint)
          (Sdo (Ecall
                 (Evalof
                   (Evar _int32_eulers_of_quat (Tfunction
                                                 ((tptr (Tstruct _Int32Eulers noattr)) ::
                                                  (tptr (Tstruct _Int32Quat noattr)) ::
                                                  nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _Int32Eulers noattr)) ::
                      (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _eulers_i
                       (Tstruct _Int32Eulers noattr))
                     (tptr (Tstruct _Int32Eulers noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_i
                         (Tstruct _Int32Quat noattr))
                       (tptr (Tstruct _Int32Quat noattr))) Enil)) tvoid))
          (Sifthenelse (Ebinop Oand
                         (Ebinop Oshr
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _status
                               tuchar) tuchar)
                           (Eval (Vint (Int.repr 5)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_i (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                       (Ebinop Omul
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
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_f (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                             tfloat) tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                       tint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_i (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                           tint)
                         (Ebinop Omul
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
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 1)) tint)
                                 (tptr tfloat)) tfloat) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_i (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                             tint)
                           (Ebinop Omul
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
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_f
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 2)) tint)
                                   (tptr tfloat)) tfloat) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                           tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                               tint)
                             (Ebinop Omul
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_f
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 3)) tint)
                                     (tptr tfloat)) tfloat) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tint))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_i
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tint)) tint)
                               (Ebinop Omul
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
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_f
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 4)) tint)
                                       (tptr tfloat)) tfloat) tfloat)
                                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tfloat) tint))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_i
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tint)) tint)
                                 (Ebinop Omul
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
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_f
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 5)) tint)
                                         (tptr tfloat)) tfloat) tfloat)
                                   (Ebinop Oshl
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tfloat) tint))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_i
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 6)) tint)
                                       (tptr tint)) tint)
                                   (Ebinop Omul
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
                                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                         (tptr (Tstruct _OrientationReps noattr)))
                                                       (Tstruct _OrientationReps noattr))
                                                     (Tstruct _OrientationReps noattr))
                                                   _rmat_f
                                                   (Tstruct _FloatRMat noattr))
                                                 (Tstruct _FloatRMat noattr))
                                               _m (tarray tfloat 9))
                                             (tarray tfloat 9))
                                           (Eval (Vint (Int.repr 6)) tint)
                                           (tptr tfloat)) tfloat) tfloat)
                                     (Ebinop Oshl
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tfloat) tint))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_i
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 7)) tint)
                                         (tptr tint)) tint)
                                     (Ebinop Omul
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
                                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                           (tptr (Tstruct _OrientationReps noattr)))
                                                         (Tstruct _OrientationReps noattr))
                                                       (Tstruct _OrientationReps noattr))
                                                     _rmat_f
                                                     (Tstruct _FloatRMat noattr))
                                                   (Tstruct _FloatRMat noattr))
                                                 _m (tarray tfloat 9))
                                               (tarray tfloat 9))
                                             (Eval (Vint (Int.repr 7)) tint)
                                             (tptr tfloat)) tfloat) tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tint))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_i
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 8)) tint)
                                         (tptr tint)) tint)
                                     (Ebinop Omul
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
                                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                           (tptr (Tstruct _OrientationReps noattr)))
                                                         (Tstruct _OrientationReps noattr))
                                                       (Tstruct _OrientationReps noattr))
                                                     _rmat_f
                                                     (Tstruct _FloatRMat noattr))
                                                   (Tstruct _FloatRMat noattr))
                                                 _m (tarray tfloat 9))
                                               (tarray tfloat 9))
                                             (Eval (Vint (Int.repr 8)) tint)
                                             (tptr tfloat)) tfloat) tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tint))))))))))
              (Ssequence
                (Sdo (Eassignop Oor
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint) tint tuchar))
                (Sdo (Ecall
                       (Evalof
                         (Evar _int32_eulers_of_rmat (Tfunction
                                                       ((tptr (Tstruct _Int32Eulers noattr)) ::
                                                        (tptr (Tstruct _Int32RMat noattr)) ::
                                                        nil) tvoid
                                                       cc_default))
                         (Tfunction
                           ((tptr (Tstruct _Int32Eulers noattr)) ::
                            (tptr (Tstruct _Int32RMat noattr)) :: nil) tvoid
                           cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _eulers_i
                             (Tstruct _Int32Eulers noattr))
                           (tptr (Tstruct _Int32Eulers noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_i
                               (Tstruct _Int32RMat noattr))
                             (tptr (Tstruct _Int32RMat noattr))) Enil))
                       tvoid))))
            (Sifthenelse (Ebinop Oand
                           (Ebinop Oshr
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _status
                                 tuchar) tuchar)
                             (Eval (Vint (Int.repr 3)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_i
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qi tint)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_f (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qi tfloat)
                             tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                         tint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_i
                                 (Tstruct _Int32Quat noattr))
                               (Tstruct _Int32Quat noattr)) _qx tint)
                           (Ebinop Omul
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _quat_f (Tstruct _FloatQuat noattr))
                                   (Tstruct _FloatQuat noattr)) _qx tfloat)
                               tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                           tint))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_i (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qy tint)
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _quat_f (Tstruct _FloatQuat noattr))
                                     (Tstruct _FloatQuat noattr)) _qy tfloat)
                                 tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               tfloat) tint))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_i (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qz tint)
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _quat_f (Tstruct _FloatQuat noattr))
                                     (Tstruct _FloatQuat noattr)) _qz tfloat)
                                 tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               tfloat) tint)))))
                (Ssequence
                  (Sdo (Eassignop Oor
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 0)) tint) tint) tint tuchar))
                  (Sdo (Ecall
                         (Evalof
                           (Evar _int32_eulers_of_quat (Tfunction
                                                         ((tptr (Tstruct _Int32Eulers noattr)) ::
                                                          (tptr (Tstruct _Int32Quat noattr)) ::
                                                          nil) tvoid
                                                         cc_default))
                           (Tfunction
                             ((tptr (Tstruct _Int32Eulers noattr)) ::
                              (tptr (Tstruct _Int32Quat noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _eulers_i
                               (Tstruct _Int32Eulers noattr))
                             (tptr (Tstruct _Int32Eulers noattr)))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_i
                                 (Tstruct _Int32Quat noattr))
                               (tptr (Tstruct _Int32Quat noattr))) Enil))
                         tvoid))))
              Sskip)))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                   (tptr (Tstruct _OrientationReps noattr)))
                 (Tstruct _OrientationReps noattr))
               (Tstruct _OrientationReps noattr)) _status tuchar)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 1)) tint) tint) tint tuchar))))
|}.

Definition f_orientationCalcQuat_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 3)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 0)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_f
                     (Tstruct _FloatQuat noattr))
                   (Tstruct _FloatQuat noattr)) _qi tfloat)
               (Ebinop Odiv
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _quat_i
                           (Tstruct _Int32Quat noattr))
                         (Tstruct _Int32Quat noattr)) _qi tint) tint) tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _quat_f
                       (Tstruct _FloatQuat noattr))
                     (Tstruct _FloatQuat noattr)) _qx tfloat)
                 (Ebinop Odiv
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_i
                             (Tstruct _Int32Quat noattr))
                           (Tstruct _Int32Quat noattr)) _qx tint) tint)
                     tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_f
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qy tfloat)
                   (Ebinop Odiv
                     (Ecast
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_i
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qy tint) tint)
                       tfloat)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tfloat))
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_f
                         (Tstruct _FloatQuat noattr))
                       (Tstruct _FloatQuat noattr)) _qz tfloat)
                   (Ebinop Odiv
                     (Ecast
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_i
                               (Tstruct _Int32Quat noattr))
                             (Tstruct _Int32Quat noattr)) _qz tint) tint)
                       tfloat)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 15)) tint) tint) tfloat) tfloat)))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 5)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _float_quat_of_rmat (Tfunction
                                             ((tptr (Tstruct _FloatQuat noattr)) ::
                                              (tptr (Tstruct _FloatRMat noattr)) ::
                                              nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _FloatQuat noattr)) ::
                    (tptr (Tstruct _FloatRMat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_f
                     (Tstruct _FloatQuat noattr))
                   (tptr (Tstruct _FloatQuat noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _rmat_f
                       (Tstruct _FloatRMat noattr))
                     (tptr (Tstruct _FloatRMat noattr))) Enil)) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _status
                             tuchar) tuchar) (Eval (Vint (Int.repr 4)) tint)
                         tint) (Eval (Vint (Int.repr 1)) tint) tint)
          (Sdo (Ecall
                 (Evalof
                   (Evar _float_quat_of_eulers (Tfunction
                                                 ((tptr (Tstruct _FloatQuat noattr)) ::
                                                  (tptr (Tstruct _FloatEulers noattr)) ::
                                                  nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _FloatQuat noattr)) ::
                      (tptr (Tstruct _FloatEulers noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _quat_f
                       (Tstruct _FloatQuat noattr))
                     (tptr (Tstruct _FloatQuat noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _eulers_f
                         (Tstruct _FloatEulers noattr))
                       (tptr (Tstruct _FloatEulers noattr))) Enil)) tvoid))
          (Sifthenelse (Ebinop Oand
                         (Ebinop Oshr
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _status
                               tuchar) tuchar)
                           (Eval (Vint (Int.repr 2)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_f (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat)
                       (Ebinop Odiv
                         (Ecast
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
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 0)) tint) (tptr tint))
                               tint) tint) tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_f (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Odiv
                           (Ecast
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
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_i
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tint)) tint) tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_f (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                             tfloat)
                           (Ebinop Odiv
                             (Ecast
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_i
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tint)) tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 3)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Odiv
                               (Ecast
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
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_i
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 3)) tint)
                                       (tptr tint)) tint) tint) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_f
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tfloat)) tfloat)
                               (Ebinop Odiv
                                 (Ecast
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
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_i
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 4)) tint)
                                         (tptr tint)) tint) tint) tfloat)
                                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tfloat) tfloat))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_f
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Odiv
                                   (Ecast
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
                                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                         (tptr (Tstruct _OrientationReps noattr)))
                                                       (Tstruct _OrientationReps noattr))
                                                     (Tstruct _OrientationReps noattr))
                                                   _rmat_i
                                                   (Tstruct _Int32RMat noattr))
                                                 (Tstruct _Int32RMat noattr))
                                               _m (tarray tint 9))
                                             (tarray tint 9))
                                           (Eval (Vint (Int.repr 5)) tint)
                                           (tptr tint)) tint) tint) tfloat)
                                   (Ebinop Oshl
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_f
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 6)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Ebinop Odiv
                                     (Ecast
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
                                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                           (tptr (Tstruct _OrientationReps noattr)))
                                                         (Tstruct _OrientationReps noattr))
                                                       (Tstruct _OrientationReps noattr))
                                                     _rmat_i
                                                     (Tstruct _Int32RMat noattr))
                                                   (Tstruct _Int32RMat noattr))
                                                 _m (tarray tint 9))
                                               (tarray tint 9))
                                             (Eval (Vint (Int.repr 6)) tint)
                                             (tptr tint)) tint) tint) tfloat)
                                     (Ebinop Oshl
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_f
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 7)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Ebinop Odiv
                                       (Ecast
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
                                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                             (tptr (Tstruct _OrientationReps noattr)))
                                                           (Tstruct _OrientationReps noattr))
                                                         (Tstruct _OrientationReps noattr))
                                                       _rmat_i
                                                       (Tstruct _Int32RMat noattr))
                                                     (Tstruct _Int32RMat noattr))
                                                   _m (tarray tint 9))
                                                 (tarray tint 9))
                                               (Eval (Vint (Int.repr 7)) tint)
                                               (tptr tint)) tint) tint)
                                         tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tfloat))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_f
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 8)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Ebinop Odiv
                                       (Ecast
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
                                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                             (tptr (Tstruct _OrientationReps noattr)))
                                                           (Tstruct _OrientationReps noattr))
                                                         (Tstruct _OrientationReps noattr))
                                                       _rmat_i
                                                       (Tstruct _Int32RMat noattr))
                                                     (Tstruct _Int32RMat noattr))
                                                   _m (tarray tint 9))
                                                 (tarray tint 9))
                                               (Eval (Vint (Int.repr 8)) tint)
                                               (tptr tint)) tint) tint)
                                         tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tfloat))))))))))
              (Ssequence
                (Sdo (Eassignop Oor
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 5)) tint) tint) tint tuchar))
                (Sdo (Ecall
                       (Evalof
                         (Evar _float_quat_of_rmat (Tfunction
                                                     ((tptr (Tstruct _FloatQuat noattr)) ::
                                                      (tptr (Tstruct _FloatRMat noattr)) ::
                                                      nil) tvoid cc_default))
                         (Tfunction
                           ((tptr (Tstruct _FloatQuat noattr)) ::
                            (tptr (Tstruct _FloatRMat noattr)) :: nil) tvoid
                           cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_f
                             (Tstruct _FloatQuat noattr))
                           (tptr (Tstruct _FloatQuat noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_f
                               (Tstruct _FloatRMat noattr))
                             (tptr (Tstruct _FloatRMat noattr))) Enil))
                       tvoid))))
            (Sifthenelse (Ebinop Oand
                           (Ebinop Oshr
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _status
                                 tuchar) tuchar)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _eulers_f
                               (Tstruct _FloatEulers noattr))
                             (Tstruct _FloatEulers noattr)) _phi tfloat)
                         (Ebinop Odiv
                           (Ecast
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _eulers_i (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _phi tint)
                               tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_f (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _theta tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _eulers_i
                                       (Tstruct _Int32Eulers noattr))
                                     (Tstruct _Int32Eulers noattr)) _theta
                                   tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tfloat))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_f (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _psi tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _eulers_i
                                       (Tstruct _Int32Eulers noattr))
                                     (Tstruct _Int32Eulers noattr)) _psi
                                   tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tfloat))))
                (Ssequence
                  (Sdo (Eassignop Oor
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 4)) tint) tint) tint tuchar))
                  (Sdo (Ecall
                         (Evalof
                           (Evar _float_quat_of_eulers (Tfunction
                                                         ((tptr (Tstruct _FloatQuat noattr)) ::
                                                          (tptr (Tstruct _FloatEulers noattr)) ::
                                                          nil) tvoid
                                                         cc_default))
                           (Tfunction
                             ((tptr (Tstruct _FloatQuat noattr)) ::
                              (tptr (Tstruct _FloatEulers noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_f
                               (Tstruct _FloatQuat noattr))
                             (tptr (Tstruct _FloatQuat noattr)))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_f (Tstruct _FloatEulers noattr))
                               (tptr (Tstruct _FloatEulers noattr))) Enil))
                         tvoid))))
              Sskip)))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                   (tptr (Tstruct _OrientationReps noattr)))
                 (Tstruct _OrientationReps noattr))
               (Tstruct _OrientationReps noattr)) _status tuchar)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 3)) tint) tint) tint tuchar))))
|}.

Definition f_orientationCalcRMat_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 5)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 2)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _rmat_f
                           (Tstruct _FloatRMat noattr))
                         (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                     (tarray tfloat 9)) (Eval (Vint (Int.repr 0)) tint)
                   (tptr tfloat)) tfloat)
               (Ebinop Odiv
                 (Ecast
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
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _rmat_i
                                 (Tstruct _Int32RMat noattr))
                               (Tstruct _Int32RMat noattr)) _m
                             (tarray tint 9)) (tarray tint 9))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                     tint) tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _rmat_f
                             (Tstruct _FloatRMat noattr))
                           (Tstruct _FloatRMat noattr)) _m (tarray tfloat 9))
                       (tarray tfloat 9)) (Eval (Vint (Int.repr 1)) tint)
                     (tptr tfloat)) tfloat)
                 (Ebinop Odiv
                   (Ecast
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
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_i (Tstruct _Int32RMat noattr))
                                 (Tstruct _Int32RMat noattr)) _m
                               (tarray tint 9)) (tarray tint 9))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                       tint) tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_f
                               (Tstruct _FloatRMat noattr))
                             (Tstruct _FloatRMat noattr)) _m
                           (tarray tfloat 9)) (tarray tfloat 9))
                       (Eval (Vint (Int.repr 2)) tint) (tptr tfloat)) tfloat)
                   (Ebinop Odiv
                     (Ecast
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
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_i (Tstruct _Int32RMat noattr))
                                   (Tstruct _Int32RMat noattr)) _m
                                 (tarray tint 9)) (tarray tint 9))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                           tint) tint) tfloat)
                     (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tfloat) tfloat))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _rmat_f
                                 (Tstruct _FloatRMat noattr))
                               (Tstruct _FloatRMat noattr)) _m
                             (tarray tfloat 9)) (tarray tfloat 9))
                         (Eval (Vint (Int.repr 3)) tint) (tptr tfloat))
                       tfloat)
                     (Ebinop Odiv
                       (Ecast
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
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_i (Tstruct _Int32RMat noattr))
                                     (Tstruct _Int32RMat noattr)) _m
                                   (tarray tint 9)) (tarray tint 9))
                               (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                             tint) tint) tfloat)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                     tfloat))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_f (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 4)) tint) (tptr tfloat))
                         tfloat)
                       (Ebinop Odiv
                         (Ecast
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
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 4)) tint) (tptr tint))
                               tint) tint) tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_f (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 5)) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Odiv
                           (Ecast
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
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_i
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tint)) tint) tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_f (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 6)) tint) (tptr tfloat))
                             tfloat)
                           (Ebinop Odiv
                             (Ecast
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_i
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tint)) tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 7)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Odiv
                               (Ecast
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
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_i
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tint)) tint) tint) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tfloat))
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Odiv
                               (Ecast
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
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_i
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 8)) tint)
                                       (tptr tint)) tint) tint) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tfloat))))))))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 3)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _float_rmat_of_quat (Tfunction
                                             ((tptr (Tstruct _FloatRMat noattr)) ::
                                              (tptr (Tstruct _FloatQuat noattr)) ::
                                              nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _FloatRMat noattr)) ::
                    (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _rmat_f
                     (Tstruct _FloatRMat noattr))
                   (tptr (Tstruct _FloatRMat noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _quat_f
                       (Tstruct _FloatQuat noattr))
                     (tptr (Tstruct _FloatQuat noattr))) Enil)) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _status
                             tuchar) tuchar) (Eval (Vint (Int.repr 4)) tint)
                         tint) (Eval (Vint (Int.repr 1)) tint) tint)
          (Sdo (Ecall
                 (Evalof
                   (Evar _float_rmat_of_eulers_321 (Tfunction
                                                     ((tptr (Tstruct _FloatRMat noattr)) ::
                                                      (tptr (Tstruct _FloatEulers noattr)) ::
                                                      nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _FloatRMat noattr)) ::
                      (tptr (Tstruct _FloatEulers noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _rmat_f
                       (Tstruct _FloatRMat noattr))
                     (tptr (Tstruct _FloatRMat noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _eulers_f
                         (Tstruct _FloatEulers noattr))
                       (tptr (Tstruct _FloatEulers noattr))) Enil)) tvoid))
          (Sifthenelse (Ebinop Oand
                         (Ebinop Oshr
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _status
                               tuchar) tuchar)
                           (Eval (Vint (Int.repr 0)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _quat_f
                             (Tstruct _FloatQuat noattr))
                           (Tstruct _FloatQuat noattr)) _qi tfloat)
                       (Ebinop Odiv
                         (Ecast
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_i (Tstruct _Int32Quat noattr))
                                 (Tstruct _Int32Quat noattr)) _qi tint) tint)
                           tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_f
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qx tfloat)
                         (Ebinop Odiv
                           (Ecast
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _quat_i (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qx tint)
                               tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_f
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qy tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _quat_i (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qy tint)
                                 tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                           tfloat))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_f
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qz tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _quat_i (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qz tint)
                                 tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                           tfloat)))))
              (Ssequence
                (Sdo (Eassignop Oor
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 3)) tint) tint) tint tuchar))
                (Sdo (Ecall
                       (Evalof
                         (Evar _float_rmat_of_quat (Tfunction
                                                     ((tptr (Tstruct _FloatRMat noattr)) ::
                                                      (tptr (Tstruct _FloatQuat noattr)) ::
                                                      nil) tvoid cc_default))
                         (Tfunction
                           ((tptr (Tstruct _FloatRMat noattr)) ::
                            (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
                           cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _rmat_f
                             (Tstruct _FloatRMat noattr))
                           (tptr (Tstruct _FloatRMat noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_f
                               (Tstruct _FloatQuat noattr))
                             (tptr (Tstruct _FloatQuat noattr))) Enil))
                       tvoid))))
            (Sifthenelse (Ebinop Oand
                           (Ebinop Oshr
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _status
                                 tuchar) tuchar)
                             (Eval (Vint (Int.repr 1)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _eulers_f
                               (Tstruct _FloatEulers noattr))
                             (Tstruct _FloatEulers noattr)) _phi tfloat)
                         (Ebinop Odiv
                           (Ecast
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _eulers_i (Tstruct _Int32Eulers noattr))
                                   (Tstruct _Int32Eulers noattr)) _phi tint)
                               tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_f (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _theta tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _eulers_i
                                       (Tstruct _Int32Eulers noattr))
                                     (Tstruct _Int32Eulers noattr)) _theta
                                   tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tfloat))
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_f (Tstruct _FloatEulers noattr))
                               (Tstruct _FloatEulers noattr)) _psi tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _eulers_i
                                       (Tstruct _Int32Eulers noattr))
                                     (Tstruct _Int32Eulers noattr)) _psi
                                   tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 12)) tint) tint) tfloat)
                           tfloat))))
                (Ssequence
                  (Sdo (Eassignop Oor
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 4)) tint) tint) tint tuchar))
                  (Sdo (Ecall
                         (Evalof
                           (Evar _float_rmat_of_eulers_321 (Tfunction
                                                             ((tptr (Tstruct _FloatRMat noattr)) ::
                                                              (tptr (Tstruct _FloatEulers noattr)) ::
                                                              nil) tvoid
                                                             cc_default))
                           (Tfunction
                             ((tptr (Tstruct _FloatRMat noattr)) ::
                              (tptr (Tstruct _FloatEulers noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_f
                               (Tstruct _FloatRMat noattr))
                             (tptr (Tstruct _FloatRMat noattr)))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr))
                                 _eulers_f (Tstruct _FloatEulers noattr))
                               (tptr (Tstruct _FloatEulers noattr))) Enil))
                         tvoid))))
              Sskip)))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                   (tptr (Tstruct _OrientationReps noattr)))
                 (Tstruct _OrientationReps noattr))
               (Tstruct _OrientationReps noattr)) _status tuchar)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 5)) tint) tint) tint tuchar))))
|}.

Definition f_orientationCalcEulers_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 4)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop Oand
                   (Ebinop Oshr
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       tuchar) (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 1)) tint) tint)
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_f
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)) _phi tfloat)
               (Ebinop Odiv
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _eulers_i
                           (Tstruct _Int32Eulers noattr))
                         (Tstruct _Int32Eulers noattr)) _phi tint) tint)
                   tfloat)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tfloat) tfloat))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _eulers_f
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _theta tfloat)
                 (Ebinop Odiv
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _eulers_i
                             (Tstruct _Int32Eulers noattr))
                           (Tstruct _Int32Eulers noattr)) _theta tint) tint)
                     tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 12)) tint) tint) tfloat) tfloat))
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _eulers_f
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr)) _psi tfloat)
                 (Ebinop Odiv
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _eulers_i
                             (Tstruct _Int32Eulers noattr))
                           (Tstruct _Int32Eulers noattr)) _psi tint) tint)
                     tfloat)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 12)) tint) tint) tfloat) tfloat))))
      (Sifthenelse (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 5)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint)
        (Sdo (Ecall
               (Evalof
                 (Evar _float_eulers_of_rmat (Tfunction
                                               ((tptr (Tstruct _FloatEulers noattr)) ::
                                                (tptr (Tstruct _FloatRMat noattr)) ::
                                                nil) tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _FloatEulers noattr)) ::
                    (tptr (Tstruct _FloatRMat noattr)) :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _eulers_f
                     (Tstruct _FloatEulers noattr))
                   (tptr (Tstruct _FloatEulers noattr)))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _rmat_f
                       (Tstruct _FloatRMat noattr))
                     (tptr (Tstruct _FloatRMat noattr))) Enil)) tvoid))
        (Sifthenelse (Ebinop Oand
                       (Ebinop Oshr
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _status
                             tuchar) tuchar) (Eval (Vint (Int.repr 3)) tint)
                         tint) (Eval (Vint (Int.repr 1)) tint) tint)
          (Sdo (Ecall
                 (Evalof
                   (Evar _float_eulers_of_quat (Tfunction
                                                 ((tptr (Tstruct _FloatEulers noattr)) ::
                                                  (tptr (Tstruct _FloatQuat noattr)) ::
                                                  nil) tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _FloatEulers noattr)) ::
                      (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _eulers_f
                       (Tstruct _FloatEulers noattr))
                     (tptr (Tstruct _FloatEulers noattr)))
                   (Econs
                     (Eaddrof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _quat_f
                         (Tstruct _FloatQuat noattr))
                       (tptr (Tstruct _FloatQuat noattr))) Enil)) tvoid))
          (Sifthenelse (Ebinop Oand
                         (Ebinop Oshr
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _status
                               tuchar) tuchar)
                           (Eval (Vint (Int.repr 2)) tint) tint)
                         (Eval (Vint (Int.repr 1)) tint) tint)
            (Ssequence
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _rmat_f (Tstruct _FloatRMat noattr))
                                 (Tstruct _FloatRMat noattr)) _m
                               (tarray tfloat 9)) (tarray tfloat 9))
                           (Eval (Vint (Int.repr 0)) tint) (tptr tfloat))
                         tfloat)
                       (Ebinop Odiv
                         (Ecast
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
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_i (Tstruct _Int32RMat noattr))
                                       (Tstruct _Int32RMat noattr)) _m
                                     (tarray tint 9)) (tarray tint 9))
                                 (Eval (Vint (Int.repr 0)) tint) (tptr tint))
                               tint) tint) tfloat)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                       tfloat))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _rmat_f (Tstruct _FloatRMat noattr))
                                   (Tstruct _FloatRMat noattr)) _m
                                 (tarray tfloat 9)) (tarray tfloat 9))
                             (Eval (Vint (Int.repr 1)) tint) (tptr tfloat))
                           tfloat)
                         (Ebinop Odiv
                           (Ecast
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
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_i
                                           (Tstruct _Int32RMat noattr))
                                         (Tstruct _Int32RMat noattr)) _m
                                       (tarray tint 9)) (tarray tint 9))
                                   (Eval (Vint (Int.repr 1)) tint)
                                   (tptr tint)) tint) tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _rmat_f (Tstruct _FloatRMat noattr))
                                     (Tstruct _FloatRMat noattr)) _m
                                   (tarray tfloat 9)) (tarray tfloat 9))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tfloat))
                             tfloat)
                           (Ebinop Odiv
                             (Ecast
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
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_i
                                             (Tstruct _Int32RMat noattr))
                                           (Tstruct _Int32RMat noattr)) _m
                                         (tarray tint 9)) (tarray tint 9))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tint)) tint) tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 14)) tint) tint) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _rmat_f (Tstruct _FloatRMat noattr))
                                       (Tstruct _FloatRMat noattr)) _m
                                     (tarray tfloat 9)) (tarray tfloat 9))
                                 (Eval (Vint (Int.repr 3)) tint)
                                 (tptr tfloat)) tfloat)
                             (Ebinop Odiv
                               (Ecast
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
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_i
                                               (Tstruct _Int32RMat noattr))
                                             (Tstruct _Int32RMat noattr)) _m
                                           (tarray tint 9)) (tarray tint 9))
                                       (Eval (Vint (Int.repr 3)) tint)
                                       (tptr tint)) tint) tint) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 14)) tint) tint)
                               tfloat) tfloat))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                 (tptr (Tstruct _OrientationReps noattr)))
                                               (Tstruct _OrientationReps noattr))
                                             (Tstruct _OrientationReps noattr))
                                           _rmat_f
                                           (Tstruct _FloatRMat noattr))
                                         (Tstruct _FloatRMat noattr)) _m
                                       (tarray tfloat 9)) (tarray tfloat 9))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tfloat)) tfloat)
                               (Ebinop Odiv
                                 (Ecast
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
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_i
                                                 (Tstruct _Int32RMat noattr))
                                               (Tstruct _Int32RMat noattr))
                                             _m (tarray tint 9))
                                           (tarray tint 9))
                                         (Eval (Vint (Int.repr 4)) tint)
                                         (tptr tint)) tint) tint) tfloat)
                                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 14)) tint) tint)
                                 tfloat) tfloat))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                   (tptr (Tstruct _OrientationReps noattr)))
                                                 (Tstruct _OrientationReps noattr))
                                               (Tstruct _OrientationReps noattr))
                                             _rmat_f
                                             (Tstruct _FloatRMat noattr))
                                           (Tstruct _FloatRMat noattr)) _m
                                         (tarray tfloat 9))
                                       (tarray tfloat 9))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tfloat)) tfloat)
                                 (Ebinop Odiv
                                   (Ecast
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
                                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                         (tptr (Tstruct _OrientationReps noattr)))
                                                       (Tstruct _OrientationReps noattr))
                                                     (Tstruct _OrientationReps noattr))
                                                   _rmat_i
                                                   (Tstruct _Int32RMat noattr))
                                                 (Tstruct _Int32RMat noattr))
                                               _m (tarray tint 9))
                                             (tarray tint 9))
                                           (Eval (Vint (Int.repr 5)) tint)
                                           (tptr tint)) tint) tint) tfloat)
                                   (Ebinop Oshl
                                     (Eval (Vint (Int.repr 1)) tint)
                                     (Eval (Vint (Int.repr 14)) tint) tint)
                                   tfloat) tfloat))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                     (tptr (Tstruct _OrientationReps noattr)))
                                                   (Tstruct _OrientationReps noattr))
                                                 (Tstruct _OrientationReps noattr))
                                               _rmat_f
                                               (Tstruct _FloatRMat noattr))
                                             (Tstruct _FloatRMat noattr)) _m
                                           (tarray tfloat 9))
                                         (tarray tfloat 9))
                                       (Eval (Vint (Int.repr 6)) tint)
                                       (tptr tfloat)) tfloat)
                                   (Ebinop Odiv
                                     (Ecast
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
                                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                           (tptr (Tstruct _OrientationReps noattr)))
                                                         (Tstruct _OrientationReps noattr))
                                                       (Tstruct _OrientationReps noattr))
                                                     _rmat_i
                                                     (Tstruct _Int32RMat noattr))
                                                   (Tstruct _Int32RMat noattr))
                                                 _m (tarray tint 9))
                                               (tarray tint 9))
                                             (Eval (Vint (Int.repr 6)) tint)
                                             (tptr tint)) tint) tint) tfloat)
                                     (Ebinop Oshl
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (Eval (Vint (Int.repr 14)) tint) tint)
                                     tfloat) tfloat))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_f
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 7)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Ebinop Odiv
                                       (Ecast
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
                                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                             (tptr (Tstruct _OrientationReps noattr)))
                                                           (Tstruct _OrientationReps noattr))
                                                         (Tstruct _OrientationReps noattr))
                                                       _rmat_i
                                                       (Tstruct _Int32RMat noattr))
                                                     (Tstruct _Int32RMat noattr))
                                                   _m (tarray tint 9))
                                                 (tarray tint 9))
                                               (Eval (Vint (Int.repr 7)) tint)
                                               (tptr tint)) tint) tint)
                                         tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tfloat))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                       (tptr (Tstruct _OrientationReps noattr)))
                                                     (Tstruct _OrientationReps noattr))
                                                   (Tstruct _OrientationReps noattr))
                                                 _rmat_f
                                                 (Tstruct _FloatRMat noattr))
                                               (Tstruct _FloatRMat noattr))
                                             _m (tarray tfloat 9))
                                           (tarray tfloat 9))
                                         (Eval (Vint (Int.repr 8)) tint)
                                         (tptr tfloat)) tfloat)
                                     (Ebinop Odiv
                                       (Ecast
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
                                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                                             (tptr (Tstruct _OrientationReps noattr)))
                                                           (Tstruct _OrientationReps noattr))
                                                         (Tstruct _OrientationReps noattr))
                                                       _rmat_i
                                                       (Tstruct _Int32RMat noattr))
                                                     (Tstruct _Int32RMat noattr))
                                                   _m (tarray tint 9))
                                                 (tarray tint 9))
                                               (Eval (Vint (Int.repr 8)) tint)
                                               (tptr tint)) tint) tint)
                                         tfloat)
                                       (Ebinop Oshl
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (Eval (Vint (Int.repr 14)) tint)
                                         tint) tfloat) tfloat))))))))))
              (Ssequence
                (Sdo (Eassignop Oor
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                               (tptr (Tstruct _OrientationReps noattr)))
                             (Tstruct _OrientationReps noattr))
                           (Tstruct _OrientationReps noattr)) _status tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 5)) tint) tint) tint tuchar))
                (Sdo (Ecall
                       (Evalof
                         (Evar _float_eulers_of_rmat (Tfunction
                                                       ((tptr (Tstruct _FloatEulers noattr)) ::
                                                        (tptr (Tstruct _FloatRMat noattr)) ::
                                                        nil) tvoid
                                                       cc_default))
                         (Tfunction
                           ((tptr (Tstruct _FloatEulers noattr)) ::
                            (tptr (Tstruct _FloatRMat noattr)) :: nil) tvoid
                           cc_default))
                       (Econs
                         (Eaddrof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                   (tptr (Tstruct _OrientationReps noattr)))
                                 (Tstruct _OrientationReps noattr))
                               (Tstruct _OrientationReps noattr)) _eulers_f
                             (Tstruct _FloatEulers noattr))
                           (tptr (Tstruct _FloatEulers noattr)))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _rmat_f
                               (Tstruct _FloatRMat noattr))
                             (tptr (Tstruct _FloatRMat noattr))) Enil))
                       tvoid))))
            (Sifthenelse (Ebinop Oand
                           (Ebinop Oshr
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _status
                                 tuchar) tuchar)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                           (Eval (Vint (Int.repr 1)) tint) tint)
              (Ssequence
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _quat_f
                               (Tstruct _FloatQuat noattr))
                             (Tstruct _FloatQuat noattr)) _qi tfloat)
                         (Ebinop Odiv
                           (Ecast
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                           (tptr (Tstruct _OrientationReps noattr)))
                                         (Tstruct _OrientationReps noattr))
                                       (Tstruct _OrientationReps noattr))
                                     _quat_i (Tstruct _Int32Quat noattr))
                                   (Tstruct _Int32Quat noattr)) _qi tint)
                               tint) tfloat)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                         tfloat))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_f
                                 (Tstruct _FloatQuat noattr))
                               (Tstruct _FloatQuat noattr)) _qx tfloat)
                           (Ebinop Odiv
                             (Ecast
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                             (tptr (Tstruct _OrientationReps noattr)))
                                           (Tstruct _OrientationReps noattr))
                                         (Tstruct _OrientationReps noattr))
                                       _quat_i (Tstruct _Int32Quat noattr))
                                     (Tstruct _Int32Quat noattr)) _qx tint)
                                 tint) tfloat)
                             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                               (Eval (Vint (Int.repr 15)) tint) tint) tfloat)
                           tfloat))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_f (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qy tfloat)
                             (Ebinop Odiv
                               (Ecast
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _quat_i (Tstruct _Int32Quat noattr))
                                       (Tstruct _Int32Quat noattr)) _qy tint)
                                   tint) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               tfloat) tfloat))
                      (Sdo (Eassign
                             (Efield
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                         (tptr (Tstruct _OrientationReps noattr)))
                                       (Tstruct _OrientationReps noattr))
                                     (Tstruct _OrientationReps noattr))
                                   _quat_f (Tstruct _FloatQuat noattr))
                                 (Tstruct _FloatQuat noattr)) _qz tfloat)
                             (Ebinop Odiv
                               (Ecast
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                               (tptr (Tstruct _OrientationReps noattr)))
                                             (Tstruct _OrientationReps noattr))
                                           (Tstruct _OrientationReps noattr))
                                         _quat_i (Tstruct _Int32Quat noattr))
                                       (Tstruct _Int32Quat noattr)) _qz tint)
                                   tint) tfloat)
                               (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                 (Eval (Vint (Int.repr 15)) tint) tint)
                               tfloat) tfloat)))))
                (Ssequence
                  (Sdo (Eassignop Oor
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint) tint tuchar))
                  (Sdo (Ecall
                         (Evalof
                           (Evar _float_eulers_of_quat (Tfunction
                                                         ((tptr (Tstruct _FloatEulers noattr)) ::
                                                          (tptr (Tstruct _FloatQuat noattr)) ::
                                                          nil) tvoid
                                                         cc_default))
                           (Tfunction
                             ((tptr (Tstruct _FloatEulers noattr)) ::
                              (tptr (Tstruct _FloatQuat noattr)) :: nil)
                             tvoid cc_default))
                         (Econs
                           (Eaddrof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                     (tptr (Tstruct _OrientationReps noattr)))
                                   (Tstruct _OrientationReps noattr))
                                 (Tstruct _OrientationReps noattr)) _eulers_f
                               (Tstruct _FloatEulers noattr))
                             (tptr (Tstruct _FloatEulers noattr)))
                           (Econs
                             (Eaddrof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                       (tptr (Tstruct _OrientationReps noattr)))
                                     (Tstruct _OrientationReps noattr))
                                   (Tstruct _OrientationReps noattr)) _quat_f
                                 (Tstruct _FloatQuat noattr))
                               (tptr (Tstruct _FloatQuat noattr))) Enil))
                         tvoid))))
              Sskip)))))
    (Sdo (Eassignop Oor
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                   (tptr (Tstruct _OrientationReps noattr)))
                 (Tstruct _OrientationReps noattr))
               (Tstruct _OrientationReps noattr)) _status tuchar)
           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
             (Eval (Vint (Int.repr 4)) tint) tint) tint tuchar))))
|}.

Definition f_orientationCalcEulersZxy_f := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_orientation, (tptr (Tstruct _OrientationReps noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                             (tptr (Tstruct _OrientationReps noattr)))
                           (Tstruct _OrientationReps noattr))
                         (Tstruct _OrientationReps noattr)) _status tuchar)
                     tuchar) (Eval (Vint (Int.repr 6)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sifthenelse (Eunop Onotbool
                   (Ebinop Oand
                     (Ebinop Oshr
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                                 (tptr (Tstruct _OrientationReps noattr)))
                               (Tstruct _OrientationReps noattr))
                             (Tstruct _OrientationReps noattr)) _status
                           tuchar) tuchar) (Eval (Vint (Int.repr 3)) tint)
                       tint) (Eval (Vint (Int.repr 1)) tint) tint) tint)
      (Sdo (Ecall
             (Evalof
               (Evar _orientationCalcQuat_f (Tfunction
                                              ((tptr (Tstruct _OrientationReps noattr)) ::
                                               nil) tvoid cc_default))
               (Tfunction ((tptr (Tstruct _OrientationReps noattr)) :: nil)
                 tvoid cc_default))
             (Econs
               (Evalof
                 (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                 (tptr (Tstruct _OrientationReps noattr))) Enil) tvoid))
      Sskip)
    (Ssequence
      (Sdo (Ecall
             (Evalof
               (Evar _float_eulers_of_quat_zxy (Tfunction
                                                 ((tptr (Tstruct _FloatEulers noattr)) ::
                                                  (tptr (Tstruct _FloatQuat noattr)) ::
                                                  nil) tvoid cc_default))
               (Tfunction
                 ((tptr (Tstruct _FloatEulers noattr)) ::
                  (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid
                 cc_default))
             (Econs
               (Eaddrof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                         (tptr (Tstruct _OrientationReps noattr)))
                       (Tstruct _OrientationReps noattr))
                     (Tstruct _OrientationReps noattr)) _eulers_zxy_f
                   (Tstruct _FloatEulers noattr))
                 (tptr (Tstruct _FloatEulers noattr)))
               (Econs
                 (Eaddrof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                           (tptr (Tstruct _OrientationReps noattr)))
                         (Tstruct _OrientationReps noattr))
                       (Tstruct _OrientationReps noattr)) _quat_f
                     (Tstruct _FloatQuat noattr))
                   (tptr (Tstruct _FloatQuat noattr))) Enil)) tvoid))
      (Sdo (Eassignop Oor
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _orientation (tptr (Tstruct _OrientationReps noattr)))
                     (tptr (Tstruct _OrientationReps noattr)))
                   (Tstruct _OrientationReps noattr))
                 (Tstruct _OrientationReps noattr)) _status tuchar)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 6)) tint) tint) tint tuchar)))))
|}.

Definition v_five_keep_orientationCalcQuat_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcQuat_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationCalcRMat_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcRMat_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationCalcEulers_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcEulers_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationCalcQuat_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcQuat_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationCalcRMat_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcRMat_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationCalcEulers_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcEulers_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationCalcEulersZxy_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationCalcEulersZxy_f (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orienationCheckValid := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orienationCheckValid (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetIdentity := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetIdentity (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetQuat_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetQuat_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetRMat_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetRMat_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetEulers_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetEulers_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetQuat_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetQuat_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetRMat_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetRMat_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationSetEulers_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationSetEulers_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetQuat_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetQuat_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetRMat_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetRMat_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetEulers_i := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetEulers_i (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetQuat_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetQuat_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetRMat_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetRMat_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetEulers_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetEulers_f (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_orientationGetEulersZxy_f := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _orientationGetEulersZxy_f (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _Int32Quat Struct
   (Member_plain _qi tint :: Member_plain _qx tint ::
    Member_plain _qy tint :: Member_plain _qz tint :: nil)
   noattr ::
 Composite _Int32Eulers Struct
   (Member_plain _phi tint :: Member_plain _theta tint ::
    Member_plain _psi tint :: nil)
   noattr ::
 Composite _Int32RMat Struct (Member_plain _m (tarray tint 9) :: nil) noattr ::
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
 Composite _OrientationReps Struct
   (Member_plain _status tuchar ::
    Member_plain _quat_i (Tstruct _Int32Quat noattr) ::
    Member_plain _eulers_i (Tstruct _Int32Eulers noattr) ::
    Member_plain _rmat_i (Tstruct _Int32RMat noattr) ::
    Member_plain _quat_f (Tstruct _FloatQuat noattr) ::
    Member_plain _eulers_f (Tstruct _FloatEulers noattr) ::
    Member_plain _eulers_zxy_f (Tstruct _FloatEulers noattr) ::
    Member_plain _rmat_f (Tstruct _FloatRMat noattr) :: nil)
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
 (_int32_rmat_of_quat,
   Gfun(External (EF_external "int32_rmat_of_quat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _Int32RMat noattr)) ::
      (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid cc_default)) ::
 (_int32_rmat_of_eulers_321,
   Gfun(External (EF_external "int32_rmat_of_eulers_321"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _Int32RMat noattr)) ::
      (tptr (Tstruct _Int32Eulers noattr)) :: nil) tvoid cc_default)) ::
 (_int32_quat_identity, Gfun(Internal f_int32_quat_identity)) ::
 (_int32_quat_of_eulers,
   Gfun(External (EF_external "int32_quat_of_eulers"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _Int32Quat noattr)) ::
      (tptr (Tstruct _Int32Eulers noattr)) :: nil) tvoid cc_default)) ::
 (_int32_quat_of_rmat,
   Gfun(External (EF_external "int32_quat_of_rmat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _Int32Quat noattr)) ::
      (tptr (Tstruct _Int32RMat noattr)) :: nil) tvoid cc_default)) ::
 (_int32_eulers_of_rmat,
   Gfun(External (EF_external "int32_eulers_of_rmat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _Int32Eulers noattr)) ::
      (tptr (Tstruct _Int32RMat noattr)) :: nil) tvoid cc_default)) ::
 (_int32_eulers_of_quat,
   Gfun(External (EF_external "int32_eulers_of_quat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _Int32Eulers noattr)) ::
      (tptr (Tstruct _Int32Quat noattr)) :: nil) tvoid cc_default)) ::
 (_float_rmat_of_eulers_321,
   Gfun(External (EF_external "float_rmat_of_eulers_321"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatRMat noattr)) ::
      (tptr (Tstruct _FloatEulers noattr)) :: nil) tvoid cc_default)) ::
 (_float_rmat_of_quat,
   Gfun(External (EF_external "float_rmat_of_quat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatRMat noattr)) ::
      (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid cc_default)) ::
 (_float_quat_of_eulers,
   Gfun(External (EF_external "float_quat_of_eulers"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatQuat noattr)) ::
      (tptr (Tstruct _FloatEulers noattr)) :: nil) tvoid cc_default)) ::
 (_float_quat_of_rmat,
   Gfun(External (EF_external "float_quat_of_rmat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatQuat noattr)) ::
      (tptr (Tstruct _FloatRMat noattr)) :: nil) tvoid cc_default)) ::
 (_float_eulers_of_rmat,
   Gfun(External (EF_external "float_eulers_of_rmat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatEulers noattr)) ::
      (tptr (Tstruct _FloatRMat noattr)) :: nil) tvoid cc_default)) ::
 (_float_eulers_of_quat,
   Gfun(External (EF_external "float_eulers_of_quat"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatEulers noattr)) ::
      (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid cc_default)) ::
 (_float_eulers_of_quat_zxy,
   Gfun(External (EF_external "float_eulers_of_quat_zxy"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default))
     ((tptr (Tstruct _FloatEulers noattr)) ::
      (tptr (Tstruct _FloatQuat noattr)) :: nil) tvoid cc_default)) ::
 (_orienationCheckValid, Gfun(Internal f_orienationCheckValid)) ::
 (_orientationSetIdentity, Gfun(Internal f_orientationSetIdentity)) ::
 (_orientationSetQuat_i, Gfun(Internal f_orientationSetQuat_i)) ::
 (_orientationSetRMat_i, Gfun(Internal f_orientationSetRMat_i)) ::
 (_orientationSetEulers_i, Gfun(Internal f_orientationSetEulers_i)) ::
 (_orientationSetQuat_f, Gfun(Internal f_orientationSetQuat_f)) ::
 (_orientationSetRMat_f, Gfun(Internal f_orientationSetRMat_f)) ::
 (_orientationSetEulers_f, Gfun(Internal f_orientationSetEulers_f)) ::
 (_orientationGetQuat_i, Gfun(Internal f_orientationGetQuat_i)) ::
 (_orientationGetRMat_i, Gfun(Internal f_orientationGetRMat_i)) ::
 (_orientationGetEulers_i, Gfun(Internal f_orientationGetEulers_i)) ::
 (_orientationGetQuat_f, Gfun(Internal f_orientationGetQuat_f)) ::
 (_orientationGetRMat_f, Gfun(Internal f_orientationGetRMat_f)) ::
 (_orientationGetEulers_f, Gfun(Internal f_orientationGetEulers_f)) ::
 (_orientationGetEulersZxy_f, Gfun(Internal f_orientationGetEulersZxy_f)) ::
 (_orientationCalcQuat_i, Gfun(Internal f_orientationCalcQuat_i)) ::
 (_orientationCalcRMat_i, Gfun(Internal f_orientationCalcRMat_i)) ::
 (_orientationCalcEulers_i, Gfun(Internal f_orientationCalcEulers_i)) ::
 (_orientationCalcQuat_f, Gfun(Internal f_orientationCalcQuat_f)) ::
 (_orientationCalcRMat_f, Gfun(Internal f_orientationCalcRMat_f)) ::
 (_orientationCalcEulers_f, Gfun(Internal f_orientationCalcEulers_f)) ::
 (_orientationCalcEulersZxy_f, Gfun(Internal f_orientationCalcEulersZxy_f)) ::
 (_five_keep_orientationCalcQuat_i, Gvar v_five_keep_orientationCalcQuat_i) ::
 (_five_keep_orientationCalcRMat_i, Gvar v_five_keep_orientationCalcRMat_i) ::
 (_five_keep_orientationCalcEulers_i, Gvar v_five_keep_orientationCalcEulers_i) ::
 (_five_keep_orientationCalcQuat_f, Gvar v_five_keep_orientationCalcQuat_f) ::
 (_five_keep_orientationCalcRMat_f, Gvar v_five_keep_orientationCalcRMat_f) ::
 (_five_keep_orientationCalcEulers_f, Gvar v_five_keep_orientationCalcEulers_f) ::
 (_five_keep_orientationCalcEulersZxy_f, Gvar v_five_keep_orientationCalcEulersZxy_f) ::
 (_five_keep_orienationCheckValid, Gvar v_five_keep_orienationCheckValid) ::
 (_five_keep_orientationSetIdentity, Gvar v_five_keep_orientationSetIdentity) ::
 (_five_keep_orientationSetQuat_i, Gvar v_five_keep_orientationSetQuat_i) ::
 (_five_keep_orientationSetRMat_i, Gvar v_five_keep_orientationSetRMat_i) ::
 (_five_keep_orientationSetEulers_i, Gvar v_five_keep_orientationSetEulers_i) ::
 (_five_keep_orientationSetQuat_f, Gvar v_five_keep_orientationSetQuat_f) ::
 (_five_keep_orientationSetRMat_f, Gvar v_five_keep_orientationSetRMat_f) ::
 (_five_keep_orientationSetEulers_f, Gvar v_five_keep_orientationSetEulers_f) ::
 (_five_keep_orientationGetQuat_i, Gvar v_five_keep_orientationGetQuat_i) ::
 (_five_keep_orientationGetRMat_i, Gvar v_five_keep_orientationGetRMat_i) ::
 (_five_keep_orientationGetEulers_i, Gvar v_five_keep_orientationGetEulers_i) ::
 (_five_keep_orientationGetQuat_f, Gvar v_five_keep_orientationGetQuat_f) ::
 (_five_keep_orientationGetRMat_f, Gvar v_five_keep_orientationGetRMat_f) ::
 (_five_keep_orientationGetEulers_f, Gvar v_five_keep_orientationGetEulers_f) ::
 (_five_keep_orientationGetEulersZxy_f, Gvar v_five_keep_orientationGetEulersZxy_f) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_orientationGetEulersZxy_f :: _five_keep_orientationGetEulers_f ::
 _five_keep_orientationGetRMat_f :: _five_keep_orientationGetQuat_f ::
 _five_keep_orientationGetEulers_i :: _five_keep_orientationGetRMat_i ::
 _five_keep_orientationGetQuat_i :: _five_keep_orientationSetEulers_f ::
 _five_keep_orientationSetRMat_f :: _five_keep_orientationSetQuat_f ::
 _five_keep_orientationSetEulers_i :: _five_keep_orientationSetRMat_i ::
 _five_keep_orientationSetQuat_i :: _five_keep_orientationSetIdentity ::
 _five_keep_orienationCheckValid :: _five_keep_orientationCalcEulersZxy_f ::
 _five_keep_orientationCalcEulers_f :: _five_keep_orientationCalcRMat_f ::
 _five_keep_orientationCalcQuat_f :: _five_keep_orientationCalcEulers_i ::
 _five_keep_orientationCalcRMat_i :: _five_keep_orientationCalcQuat_i ::
 _orientationCalcEulersZxy_f :: _orientationCalcEulers_f ::
 _orientationCalcRMat_f :: _orientationCalcQuat_f ::
 _orientationCalcEulers_i :: _orientationCalcRMat_i ::
 _orientationCalcQuat_i :: _float_eulers_of_quat_zxy ::
 _float_eulers_of_quat :: _float_eulers_of_rmat :: _float_quat_of_rmat ::
 _float_quat_of_eulers :: _float_rmat_of_quat :: _float_rmat_of_eulers_321 ::
 _int32_eulers_of_quat :: _int32_eulers_of_rmat :: _int32_quat_of_rmat ::
 _int32_quat_of_eulers :: _int32_rmat_of_eulers_321 :: _int32_rmat_of_quat ::
 _memcpy :: ___builtin_debug :: ___builtin_write32_reversed ::
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


