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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/expansion-models/zoh_filter/model/preprocessed.i".
End Info.

Definition _FirstOrderZOHLowPass : ident := $"FirstOrderZOHLowPass".
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
Definition _discrete_time_constant : ident := $"discrete_time_constant".
Definition _exp : ident := $"exp".
Definition _filter : ident := $"filter".
Definition _five_keep_get_first_order_zoh_low_pass : ident := $"five_keep_get_first_order_zoh_low_pass".
Definition _five_keep_init_first_order_zoh_low_pass : ident := $"five_keep_init_first_order_zoh_low_pass".
Definition _five_keep_reset_first_order_zoh_low_pass : ident := $"five_keep_reset_first_order_zoh_low_pass".
Definition _five_keep_update_first_order_zoh_low_pass : ident := $"five_keep_update_first_order_zoh_low_pass".
Definition _five_keep_update_first_order_zoh_low_pass_tau : ident := $"five_keep_update_first_order_zoh_low_pass_tau".
Definition _get_first_order_zoh_low_pass : ident := $"get_first_order_zoh_low_pass".
Definition _init_first_order_zoh_low_pass : ident := $"init_first_order_zoh_low_pass".
Definition _last_in : ident := $"last_in".
Definition _last_out : ident := $"last_out".
Definition _main : ident := $"main".
Definition _out : ident := $"out".
Definition _reset_first_order_zoh_low_pass : ident := $"reset_first_order_zoh_low_pass".
Definition _sample_time : ident := $"sample_time".
Definition _tau : ident := $"tau".
Definition _update_first_order_zoh_low_pass : ident := $"update_first_order_zoh_low_pass".
Definition _update_first_order_zoh_low_pass_tau : ident := $"update_first_order_zoh_low_pass_tau".
Definition _value : ident := $"value".

Definition f_init_first_order_zoh_low_pass := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _FirstOrderZOHLowPass noattr))) ::
                (_tau, tfloat) :: (_sample_time, tfloat) ::
                (_value, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                 (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
               (Tstruct _FirstOrderZOHLowPass noattr))
             (Tstruct _FirstOrderZOHLowPass noattr)) _discrete_time_constant
           tfloat)
         (Ecall
           (Evalof
             (Evar _exp (Tfunction (tdouble :: nil) tdouble cc_default))
             (Tfunction (tdouble :: nil) tdouble cc_default))
           (Econs
             (Ebinop Odiv
               (Eunop Oneg (Evalof (Evar _sample_time tfloat) tfloat) tfloat)
               (Evalof (Evar _tau tfloat) tfloat) tfloat) Enil) tdouble)
         tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                   (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                 (Tstruct _FirstOrderZOHLowPass noattr))
               (Tstruct _FirstOrderZOHLowPass noattr)) _last_in tfloat)
           (Evalof (Evar _value tfloat) tfloat) tfloat))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                   (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                 (Tstruct _FirstOrderZOHLowPass noattr))
               (Tstruct _FirstOrderZOHLowPass noattr)) _last_out tfloat)
           (Evalof (Evar _value tfloat) tfloat) tfloat))))
|}.

Definition f_update_first_order_zoh_low_pass := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _FirstOrderZOHLowPass noattr))) ::
                (_value, tfloat) :: nil);
  fn_vars := ((_out, tfloat) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _out tfloat)
         (Ebinop Oadd
           (Ebinop Omul
             (Ebinop Osub
               (Eval (Vsingle (Float32.of_bits (Int.repr 1065353216))) tfloat)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                         (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                       (Tstruct _FirstOrderZOHLowPass noattr))
                     (Tstruct _FirstOrderZOHLowPass noattr))
                   _discrete_time_constant tfloat) tfloat) tfloat)
             (Evalof (Evar _value tfloat) tfloat) tfloat)
           (Ebinop Omul
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                       (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                     (Tstruct _FirstOrderZOHLowPass noattr))
                   (Tstruct _FirstOrderZOHLowPass noattr))
                 _discrete_time_constant tfloat) tfloat)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof
                       (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                       (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                     (Tstruct _FirstOrderZOHLowPass noattr))
                   (Tstruct _FirstOrderZOHLowPass noattr)) _last_out tfloat)
               tfloat) tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                   (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                 (Tstruct _FirstOrderZOHLowPass noattr))
               (Tstruct _FirstOrderZOHLowPass noattr)) _last_in tfloat)
           (Evalof (Evar _value tfloat) tfloat) tfloat))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof
                     (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                     (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                   (Tstruct _FirstOrderZOHLowPass noattr))
                 (Tstruct _FirstOrderZOHLowPass noattr)) _last_out tfloat)
             (Evalof (Evar _out tfloat) tfloat) tfloat))
      (Sreturn (Some (Evalof (Evar _out tfloat) tfloat))))))
|}.

Definition f_reset_first_order_zoh_low_pass := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _FirstOrderZOHLowPass noattr))) ::
                (_value, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof
                 (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                 (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
               (Tstruct _FirstOrderZOHLowPass noattr))
             (Tstruct _FirstOrderZOHLowPass noattr)) _last_in tfloat)
         (Evalof (Evar _value tfloat) tfloat) tfloat))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof
                   (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                   (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                 (Tstruct _FirstOrderZOHLowPass noattr))
               (Tstruct _FirstOrderZOHLowPass noattr)) _last_out tfloat)
           (Evalof (Evar _value tfloat) tfloat) tfloat))
    (Sreturn (Some (Evalof (Evar _value tfloat) tfloat)))))
|}.

Definition f_get_first_order_zoh_low_pass := {|
  fn_return := tfloat;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _FirstOrderZOHLowPass noattr))) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                         (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
                       (Tstruct _FirstOrderZOHLowPass noattr))
                     (Tstruct _FirstOrderZOHLowPass noattr)) _last_out
                   tfloat) tfloat)))
|}.

Definition f_update_first_order_zoh_low_pass_tau := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_filter, (tptr (Tstruct _FirstOrderZOHLowPass noattr))) ::
                (_tau, tfloat) :: (_sample_time, tfloat) :: nil);
  fn_vars := nil;
  fn_body :=
(Sdo (Eassign
       (Efield
         (Evalof
           (Ederef
             (Evalof
               (Evar _filter (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
               (tptr (Tstruct _FirstOrderZOHLowPass noattr)))
             (Tstruct _FirstOrderZOHLowPass noattr))
           (Tstruct _FirstOrderZOHLowPass noattr)) _discrete_time_constant
         tfloat)
       (Ecall
         (Evalof (Evar _exp (Tfunction (tdouble :: nil) tdouble cc_default))
           (Tfunction (tdouble :: nil) tdouble cc_default))
         (Econs
           (Ebinop Odiv
             (Eunop Oneg (Evalof (Evar _sample_time tfloat) tfloat) tfloat)
             (Evalof (Evar _tau tfloat) tfloat) tfloat) Enil) tdouble)
       tfloat))
|}.

Definition v_five_keep_init_first_order_zoh_low_pass := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _init_first_order_zoh_low_pass (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_update_first_order_zoh_low_pass := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _update_first_order_zoh_low_pass (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_reset_first_order_zoh_low_pass := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _reset_first_order_zoh_low_pass (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_get_first_order_zoh_low_pass := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _get_first_order_zoh_low_pass (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_update_first_order_zoh_low_pass_tau := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _update_first_order_zoh_low_pass_tau (Ptrofs.repr 0) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _FirstOrderZOHLowPass Struct
   (Member_plain _discrete_time_constant tfloat ::
    Member_plain _last_in tfloat :: Member_plain _last_out tfloat :: nil)
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
 (_exp,
   Gfun(External (EF_external "exp"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_init_first_order_zoh_low_pass, Gfun(Internal f_init_first_order_zoh_low_pass)) ::
 (_update_first_order_zoh_low_pass, Gfun(Internal f_update_first_order_zoh_low_pass)) ::
 (_reset_first_order_zoh_low_pass, Gfun(Internal f_reset_first_order_zoh_low_pass)) ::
 (_get_first_order_zoh_low_pass, Gfun(Internal f_get_first_order_zoh_low_pass)) ::
 (_update_first_order_zoh_low_pass_tau, Gfun(Internal f_update_first_order_zoh_low_pass_tau)) ::
 (_five_keep_init_first_order_zoh_low_pass, Gvar v_five_keep_init_first_order_zoh_low_pass) ::
 (_five_keep_update_first_order_zoh_low_pass, Gvar v_five_keep_update_first_order_zoh_low_pass) ::
 (_five_keep_reset_first_order_zoh_low_pass, Gvar v_five_keep_reset_first_order_zoh_low_pass) ::
 (_five_keep_get_first_order_zoh_low_pass, Gvar v_five_keep_get_first_order_zoh_low_pass) ::
 (_five_keep_update_first_order_zoh_low_pass_tau, Gvar v_five_keep_update_first_order_zoh_low_pass_tau) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_update_first_order_zoh_low_pass_tau ::
 _five_keep_get_first_order_zoh_low_pass ::
 _five_keep_reset_first_order_zoh_low_pass ::
 _five_keep_update_first_order_zoh_low_pass ::
 _five_keep_init_first_order_zoh_low_pass :: _exp :: ___builtin_debug ::
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


