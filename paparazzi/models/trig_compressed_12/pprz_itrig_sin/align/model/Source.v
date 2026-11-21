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
  Definition source_file := "/home/yangfp/five/paparazzi/models/trig_compressed_12/pprz_itrig_sin/align/model/preprocessed.i".
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
Definition _angle : ident := $"angle".
Definition _cnt : ident := $"cnt".
Definition _data_buf_12 : ident := $"data_buf_12".
Definition _get_nibble : ident := $"get_nibble".
Definition _i : ident := $"i".
Definition _j : ident := $"j".
Definition _k : ident := $"k".
Definition _main : ident := $"main".
Definition _pos : ident := $"pos".
Definition _pprz_itrig_sin : ident := $"pprz_itrig_sin".
Definition _pprz_trig_int_12 : ident := $"pprz_trig_int_12".
Definition _pprz_trig_int_compr : ident := $"pprz_trig_int_compr".
Definition _pprz_trig_int_f : ident := $"pprz_trig_int_f".
Definition _pprz_trig_int_init : ident := $"pprz_trig_int_init".
Definition _tab : ident := $"tab".
Definition _tab_12 : ident := $"tab_12".
Definition _table_encode_12 : ident := $"table_encode_12".
Definition _temp : ident := $"temp".
Definition _val : ident := $"val".
Definition _val_prev : ident := $"val_prev".

Definition v_pprz_trig_int_compr := {|
  gvar_info := (tarray tuchar 1690);
  gvar_init := (Init_int8 (Int.repr 243) :: Init_int8 (Int.repr 207) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 252) ::
                Init_int8 (Int.repr 207) :: Init_int8 (Int.repr 255) ::
                Init_int8 (Int.repr 252) :: Init_int8 (Int.repr 207) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 252) ::
                Init_int8 (Int.repr 207) :: Init_int8 (Int.repr 158) ::
                Init_int8 (Int.repr 243) :: Init_int8 (Int.repr 207) ::
                Init_int8 (Int.repr 143) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 252) ::
                Init_int8 (Int.repr 65) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 207) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 159) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 79) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 31) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 207) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 191) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 175) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 143) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 127) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 111) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 111) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 79) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 79) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 79) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 63) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 47) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 63) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 31) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 31) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 31) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 31) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 15) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 15) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 15) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 15) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 62) :: Init_int8 (Int.repr 238) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 62) :: Init_int8 (Int.repr 158) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 238) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 238) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 158) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 158) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 158) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 158) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 158) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 158) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 57) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 57) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 52) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 52) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 62) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 52) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 62) :: Init_int8 (Int.repr 78) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 62) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 62) :: Init_int8 (Int.repr 62) ::
                Init_int8 (Int.repr 78) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 227) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 227) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 147) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 147) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 72) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 141) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 141) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 141) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 141) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 141) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 212) :: Init_int8 (Int.repr 77) ::
                Init_int8 (Int.repr 221) :: Init_int8 (Int.repr 212) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 72) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 77) :: Init_int8 (Int.repr 15) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 31) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 47) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 79) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 127) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 207) ::
                Init_int8 (Int.repr 67) :: Init_int8 (Int.repr 255) ::
                Init_int8 (Int.repr 219) :: Init_int8 (Int.repr 67) ::
                Init_int8 (Int.repr 191) :: Init_int8 (Int.repr 35) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 219) ::
                Init_int8 (Int.repr 242) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 242) :: Init_int8 (Int.repr 54) ::
                Init_int8 (Int.repr 242) :: Init_int8 (Int.repr 52) ::
                Init_int8 (Int.repr 242) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 242) :: Init_int8 (Int.repr 49) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 141) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 45) ::
                Init_int8 (Int.repr 221) :: Init_int8 (Int.repr 35) ::
                Init_int8 (Int.repr 141) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 45) :: Init_int8 (Int.repr 221) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 40) ::
                Init_int8 (Int.repr 141) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 40) :: Init_int8 (Int.repr 141) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 40) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 40) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 35) ::
                Init_int8 (Int.repr 141) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 35) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 35) ::
                Init_int8 (Int.repr 45) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 35) ::
                Init_int8 (Int.repr 45) :: Init_int8 (Int.repr 61) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 35) :: Init_int8 (Int.repr 45) ::
                Init_int8 (Int.repr 61) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 210) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 210) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 130) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 130) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 60) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 195) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 60) ::
                Init_int8 (Int.repr 44) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 195) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 44) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 50) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 195) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 124) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 195) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 204) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 55) :: Init_int8 (Int.repr 204) ::
                Init_int8 (Int.repr 195) :: Init_int8 (Int.repr 55) ::
                Init_int8 (Int.repr 204) :: Init_int8 (Int.repr 50) ::
                Init_int8 (Int.repr 204) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 44) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 44) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 124) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 124) :: Init_int8 (Int.repr 195) ::
                Init_int8 (Int.repr 204) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 36) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 39) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 243) ::
                Init_int8 (Int.repr 175) :: Init_int8 (Int.repr 63) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 47) ::
                Init_int8 (Int.repr 26) :: Init_int8 (Int.repr 127) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 63) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 47) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 15) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 204) ::
                Init_int8 (Int.repr 28) :: Init_int8 (Int.repr 204) ::
                Init_int8 (Int.repr 23) :: Init_int8 (Int.repr 204) ::
                Init_int8 (Int.repr 23) :: Init_int8 (Int.repr 204) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 204) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 28) ::
                Init_int8 (Int.repr 204) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 23) :: Init_int8 (Int.repr 124) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 23) ::
                Init_int8 (Int.repr 124) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 23) :: Init_int8 (Int.repr 124) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 18) ::
                Init_int8 (Int.repr 44) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 18) ::
                Init_int8 (Int.repr 44) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 18) :: Init_int8 (Int.repr 28) ::
                Init_int8 (Int.repr 28) :: Init_int8 (Int.repr 44) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 193) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 193) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 113) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 113) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 27) :: Init_int8 (Int.repr 178) ::
                Init_int8 (Int.repr 178) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 27) ::
                Init_int8 (Int.repr 178) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 27) :: Init_int8 (Int.repr 178) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 27) ::
                Init_int8 (Int.repr 178) :: Init_int8 (Int.repr 33) ::
                Init_int8 (Int.repr 27) :: Init_int8 (Int.repr 178) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 107) ::
                Init_int8 (Int.repr 178) :: Init_int8 (Int.repr 38) ::
                Init_int8 (Int.repr 107) :: Init_int8 (Int.repr 178) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 187) ::
                Init_int8 (Int.repr 178) :: Init_int8 (Int.repr 43) ::
                Init_int8 (Int.repr 187) :: Init_int8 (Int.repr 178) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 187) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 187) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 187) ::
                Init_int8 (Int.repr 38) :: Init_int8 (Int.repr 187) ::
                Init_int8 (Int.repr 43) :: Init_int8 (Int.repr 31) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 31) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 95) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 175) ::
                Init_int8 (Int.repr 33) :: Init_int8 (Int.repr 255) ::
                Init_int8 (Int.repr 249) :: Init_int8 (Int.repr 155) ::
                Init_int8 (Int.repr 240) :: Init_int8 (Int.repr 26) ::
                Init_int8 (Int.repr 240) :: Init_int8 (Int.repr 21) ::
                Init_int8 (Int.repr 240) :: Init_int8 (Int.repr 17) ::
                Init_int8 (Int.repr 240) :: Init_int8 (Int.repr 16) ::
                Init_int8 (Int.repr 240) :: Init_int8 (Int.repr 16) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 107) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 27) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 27) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 27) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 187) :: Init_int8 (Int.repr 176) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 187) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 107) :: Init_int8 (Int.repr 176) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 107) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 27) :: Init_int8 (Int.repr 176) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 27) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 27) :: Init_int8 (Int.repr 176) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 27) :: Init_int8 (Int.repr 176) ::
                Init_int8 (Int.repr 176) :: Init_int8 (Int.repr 176) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 11) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 11) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 6) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 6) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 1) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 1) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 81) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 81) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 16) ::
                Init_int8 (Int.repr 26) :: Init_int8 (Int.repr 26) ::
                Init_int8 (Int.repr 26) :: Init_int8 (Int.repr 10) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 16) :: Init_int8 (Int.repr 26) ::
                Init_int8 (Int.repr 10) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 16) :: Init_int8 (Int.repr 10) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 16) ::
                Init_int8 (Int.repr 10) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 21) :: Init_int8 (Int.repr 10) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 21) ::
                Init_int8 (Int.repr 90) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 21) :: Init_int8 (Int.repr 170) ::
                Init_int8 (Int.repr 161) :: Init_int8 (Int.repr 21) ::
                Init_int8 (Int.repr 170) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 10) :: Init_int8 (Int.repr 161) ::
                Init_int8 (Int.repr 26) :: Init_int8 (Int.repr 170) ::
                Init_int8 (Int.repr 21) :: Init_int8 (Int.repr 170) ::
                Init_int8 (Int.repr 21) :: Init_int8 (Int.repr 170) ::
                Init_int8 (Int.repr 21) :: Init_int8 (Int.repr 15) ::
                Init_int8 (Int.repr 16) :: Init_int8 (Int.repr 31) ::
                Init_int8 (Int.repr 16) :: Init_int8 (Int.repr 63) ::
                Init_int8 (Int.repr 16) :: Init_int8 (Int.repr 143) ::
                Init_int8 (Int.repr 16) :: Init_int8 (Int.repr 255) ::
                Init_int8 (Int.repr 168) :: Init_int8 (Int.repr 0) :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_data_buf_12 := {|
  gvar_info := (tarray tuchar 9651);
  gvar_init := (Init_space 9651 :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_table_encode_12 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_val, tshort) :: (_val_prev, tshort) :: (_cnt, tshort) ::
                (_tab, (tptr tshort)) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof (Evar _data_buf_12 (tarray tuchar 9651))
               (tarray tuchar 9651)) (Evalof (Evar _cnt tshort) tshort)
             (tptr tuchar)) tuchar)
         (Ebinop Omod (Evalof (Evar _val tshort) tshort)
           (Eval (Vint (Int.repr 256)) tint) tint) tuchar))
  (Ssequence
    (Sifthenelse (Ebinop Oeq
                   (Ebinop Omod (Evalof (Evar _cnt tshort) tshort)
                     (Eval (Vint (Int.repr 2)) tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof (Evar _data_buf_12 (tarray tuchar 9651))
                   (tarray tuchar 9651))
                 (Ebinop Oadd (Eval (Vint (Int.repr 6434)) tint)
                   (Ebinop Odiv (Evalof (Evar _cnt tshort) tshort)
                     (Eval (Vint (Int.repr 2)) tint) tint) tint)
                 (tptr tuchar)) tuchar)
             (Ebinop Oshr
               (Ebinop Oand (Evalof (Evar _val tshort) tshort)
                 (Eval (Vint (Int.repr 3840)) tint) tint)
               (Eval (Vint (Int.repr 8)) tint) tint) tuchar))
      (Sdo (Eassignop Oor
             (Ederef
               (Ebinop Oadd
                 (Evalof (Evar _data_buf_12 (tarray tuchar 9651))
                   (tarray tuchar 9651))
                 (Ebinop Oadd (Eval (Vint (Int.repr 6434)) tint)
                   (Ebinop Odiv (Evalof (Evar _cnt tshort) tshort)
                     (Eval (Vint (Int.repr 2)) tint) tint) tint)
                 (tptr tuchar)) tuchar)
             (Ebinop Oshr
               (Ebinop Oand (Evalof (Evar _val tshort) tshort)
                 (Eval (Vint (Int.repr 3840)) tint) tint)
               (Eval (Vint (Int.repr 4)) tint) tint) tint tuchar)))
    (Ssequence
      (Sdo (Ecast (Evalof (Evar _val_prev tshort) tshort) tvoid))
      (Sdo (Ecast (Evalof (Evar _tab (tptr tshort)) (tptr tshort)) tvoid)))))
|}.

Definition f_pprz_trig_int_12 := {|
  fn_return := tshort;
  fn_callconv := cc_default;
  fn_params := ((_val, tshort) :: nil);
  fn_vars := ((_k, tshort) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Olt (Evalof (Evar _val tshort) tshort)
                 (Eval (Vint (Int.repr 2145)) tint) tint)
    (Sifthenelse (Ebinop Olt (Evalof (Evar _val tshort) tshort)
                   (Eval (Vint (Int.repr 1035)) tint) tint)
      (Sdo (Eassign (Evar _k tshort)
             (Ebinop Oshl (Eval (Vint (Int.repr 0)) tint)
               (Eval (Vint (Int.repr 12)) tint) tint) tshort))
      (Sdo (Eassign (Evar _k tshort)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 12)) tint) tint) tshort)))
    (Sifthenelse (Ebinop Olt (Evalof (Evar _val tshort) tshort)
                   (Eval (Vint (Int.repr 3474)) tint) tint)
      (Sdo (Eassign (Evar _k tshort)
             (Ebinop Oshl (Eval (Vint (Int.repr 2)) tint)
               (Eval (Vint (Int.repr 12)) tint) tint) tshort))
      (Sdo (Eassign (Evar _k tshort)
             (Ebinop Oshl (Eval (Vint (Int.repr 3)) tint)
               (Eval (Vint (Int.repr 12)) tint) tint) tshort))))
  (Sreturn (Some (Ebinop Oor
                   (Ebinop Oor (Evalof (Evar _k tshort) tshort)
                     (Ebinop Oand
                       (Ebinop Oshl
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _data_buf_12 (tarray tuchar 9651))
                                 (tarray tuchar 9651))
                               (Ebinop Oadd
                                 (Eval (Vint (Int.repr 6434)) tint)
                                 (Ebinop Oshr
                                   (Evalof (Evar _val tshort) tshort)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 tint) (tptr tuchar)) tuchar) tuchar)
                         (Econdition
                           (Ebinop Omod (Evalof (Evar _val tshort) tshort)
                             (Eval (Vint (Int.repr 2)) tint) tint)
                           (Eval (Vint (Int.repr 4)) tint)
                           (Eval (Vint (Int.repr 8)) tint) tint) tint)
                       (Eval (Vint (Int.repr 3840)) tint) tint) tint)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _data_buf_12 (tarray tuchar 9651))
                           (tarray tuchar 9651))
                         (Evalof (Evar _val tshort) tshort) (tptr tuchar))
                       tuchar) tuchar) tint))))
|}.

Definition f_get_nibble := {|
  fn_return := tuchar;
  fn_callconv := cc_default;
  fn_params := ((_pos, tushort) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ebinop Oand
                 (Ebinop Oshr
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof
                           (Evar _pprz_trig_int_compr (tarray tuchar 1690))
                           (tarray tuchar 1690))
                         (Ebinop Odiv (Evalof (Evar _pos tushort) tushort)
                           (Eval (Vint (Int.repr 2)) tint) tint)
                         (tptr tuchar)) tuchar) tuchar)
                   (Ebinop Omul (Eval (Vint (Int.repr 4)) tint)
                     (Ebinop Omod (Evalof (Evar _pos tushort) tushort)
                       (Eval (Vint (Int.repr 2)) tint) tint) tint) tint)
                 (Eval (Vint (Int.repr 15)) tint) tint)))
|}.

Definition f_pprz_trig_int_init := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := nil;
  fn_vars := ((_i, tshort) :: (_j, tshort) :: (_k, tshort) ::
              (_cnt, tshort) :: (_temp, tshort) :: (_val, tshort) ::
              (_val_prev, tshort) :: (_tab_12, tshort) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _tab_12 tshort) (Eval (Vint (Int.repr 0)) tint) tshort))
  (Ssequence
    (Sdo (Eassign (Evar _cnt tshort) (Eval (Vint (Int.repr 0)) tint) tshort))
    (Ssequence
      (Sdo (Eassign (Evar _val tshort) (Eval (Vint (Int.repr 0)) tint)
             tshort))
      (Ssequence
        (Sdo (Eassign (Evar _val_prev tshort) (Eval (Vint (Int.repr 0)) tint)
               tshort))
        (Ssequence
          (Sfor
            (Sdo (Eassign (Evar _i tshort) (Eval (Vint (Int.repr 0)) tint)
                   tshort))
            (Ebinop Olt (Evalof (Evar _i tshort) tshort)
              (Eval (Vint (Int.repr 3379)) tint) tint)
            Sskip
            (Ssequence
              (Sdo (Eassign (Evar _temp tshort)
                     (Ecall
                       (Evalof
                         (Evar _get_nibble (Tfunction (tushort :: nil) tuchar
                                             cc_default))
                         (Tfunction (tushort :: nil) tuchar cc_default))
                       (Econs (Epostincr Incr (Evar _i tshort) tshort) Enil)
                       tuchar) tshort))
              (Sifthenelse (Ebinop Olt (Evalof (Evar _temp tshort) tshort)
                             (Eval (Vint (Int.repr 15)) tint) tint)
                (Sfor
                  (Sdo (Eassign (Evar _j tshort)
                         (Eval (Vint (Int.repr 0)) tint) tshort))
                  (Ebinop Olt (Evalof (Evar _j tshort) tshort)
                    (Ebinop Oadd
                      (Ebinop Odiv (Evalof (Evar _temp tshort) tshort)
                        (Eval (Vint (Int.repr 5)) tint) tint)
                      (Eval (Vint (Int.repr 1)) tint) tint) tint)
                  (Sdo (Epostincr Incr (Evar _j tshort) tshort))
                  (Ssequence
                    (Sdo (Ecall
                           (Evalof
                             (Evar _table_encode_12 (Tfunction
                                                      (tshort :: tshort ::
                                                       tshort ::
                                                       (tptr tshort) :: nil)
                                                      tvoid cc_default))
                             (Tfunction
                               (tshort :: tshort :: tshort ::
                                (tptr tshort) :: nil) tvoid cc_default))
                           (Econs (Evalof (Evar _val tshort) tshort)
                             (Econs (Evalof (Evar _val_prev tshort) tshort)
                               (Econs (Evalof (Evar _cnt tshort) tshort)
                                 (Econs
                                   (Eaddrof (Evar _tab_12 tshort)
                                     (tptr tshort)) Enil)))) tvoid))
                    (Ssequence
                      (Sdo (Eassign (Evar _val_prev tshort)
                             (Evalof (Evar _val tshort) tshort) tshort))
                      (Ssequence
                        (Sdo (Epostincr Incr (Evar _cnt tshort) tshort))
                        (Ssequence
                          (Sdo (Eassignop Oadd (Evar _val tshort)
                                 (Ebinop Omod
                                   (Evalof (Evar _temp tshort) tshort)
                                   (Eval (Vint (Int.repr 5)) tint) tint)
                                 tint tshort))
                          (Sifthenelse (Ebinop Ogt
                                         (Evalof (Evar _cnt tshort) tshort)
                                         (Eval (Vint (Int.repr 6434)) tint)
                                         tint)
                            (Sreturn (Some (Eunop Oneg
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tint)))
                            Sskip))))))
                (Ssequence
                  (Sdo (Eassign (Evar _k tshort)
                         (Ecall
                           (Evalof
                             (Evar _get_nibble (Tfunction (tushort :: nil)
                                                 tuchar cc_default))
                             (Tfunction (tushort :: nil) tuchar cc_default))
                           (Econs (Epostincr Incr (Evar _i tshort) tshort)
                             Enil) tuchar) tshort))
                  (Ssequence
                    (Sifthenelse (Ebinop Ogt (Evalof (Evar _i tshort) tshort)
                                   (Eval (Vint (Int.repr 3379)) tint) tint)
                      (Sreturn (Some (Eunop Oneg
                                       (Eval (Vint (Int.repr 1)) tint) tint)))
                      Sskip)
                    (Ssequence
                      (Sdo (Eassign (Evar _temp tshort)
                             (Ecall
                               (Evalof
                                 (Evar _get_nibble (Tfunction
                                                     (tushort :: nil) tuchar
                                                     cc_default))
                                 (Tfunction (tushort :: nil) tuchar
                                   cc_default))
                               (Econs
                                 (Epostincr Incr (Evar _i tshort) tshort)
                                 Enil) tuchar) tshort))
                      (Ssequence
                        (Sifthenelse (Ebinop Ogt
                                       (Evalof (Evar _i tshort) tshort)
                                       (Eval (Vint (Int.repr 3379)) tint)
                                       tint)
                          (Sreturn (Some (Eunop Oneg
                                           (Eval (Vint (Int.repr 1)) tint)
                                           tint)))
                          Sskip)
                        (Ssequence
                          (Sdo (Eassignop Oor (Evar _k tshort)
                                 (Ebinop Oshl
                                   (Ebinop Oand
                                     (Evalof (Evar _temp tshort) tshort)
                                     (Eval (Vint (Int.repr 8)) tint) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 tint tshort))
                          (Sfor
                            (Sdo (Eassign (Evar _j tshort)
                                   (Eval (Vint (Int.repr 0)) tint) tshort))
                            (Ebinop Olt (Evalof (Evar _j tshort) tshort)
                              (Ebinop Oadd (Evalof (Evar _k tshort) tshort)
                                (Ebinop Oadd
                                  (Ebinop Omul
                                    (Eval (Vint (Int.repr 3)) tint)
                                    (Eval (Vint (Int.repr 3)) tint) tint)
                                  (Eval (Vint (Int.repr 1)) tint) tint) tint)
                              tint)
                            (Sdo (Epostincr Incr (Evar _j tshort) tshort))
                            (Ssequence
                              (Sdo (Ecall
                                     (Evalof
                                       (Evar _table_encode_12 (Tfunction
                                                                (tshort ::
                                                                 tshort ::
                                                                 tshort ::
                                                                 (tptr tshort) ::
                                                                 nil) tvoid
                                                                cc_default))
                                       (Tfunction
                                         (tshort :: tshort :: tshort ::
                                          (tptr tshort) :: nil) tvoid
                                         cc_default))
                                     (Econs
                                       (Evalof (Evar _val tshort) tshort)
                                       (Econs
                                         (Evalof (Evar _val_prev tshort)
                                           tshort)
                                         (Econs
                                           (Evalof (Evar _cnt tshort) tshort)
                                           (Econs
                                             (Eaddrof (Evar _tab_12 tshort)
                                               (tptr tshort)) Enil)))) tvoid))
                              (Ssequence
                                (Sdo (Eassign (Evar _val_prev tshort)
                                       (Evalof (Evar _val tshort) tshort)
                                       tshort))
                                (Ssequence
                                  (Sdo (Epostincr Incr (Evar _cnt tshort)
                                         tshort))
                                  (Ssequence
                                    (Sdo (Eassignop Oadd (Evar _val tshort)
                                           (Ebinop Oand
                                             (Evalof (Evar _temp tshort)
                                               tshort)
                                             (Eval (Vint (Int.repr 7)) tint)
                                             tint) tint tshort))
                                    (Sifthenelse (Ebinop Ogt
                                                   (Evalof (Evar _cnt tshort)
                                                     tshort)
                                                   (Eval (Vint (Int.repr 6434)) tint)
                                                   tint)
                                      (Sreturn (Some (Eunop Oneg
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       tint)))
                                      Sskip))))))))))))))
          (Ssequence
            (Sifthenelse (Ebinop One (Evalof (Evar _cnt tshort) tshort)
                           (Eval (Vint (Int.repr 6434)) tint) tint)
              (Sreturn (Some (Eunop Oneg (Eval (Vint (Int.repr 1)) tint)
                               tint)))
              Sskip)
            (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))))))))
|}.

Definition f_pprz_trig_int_f := {|
  fn_return := tshort;
  fn_callconv := cc_default;
  fn_params := ((_angle, tint) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _pprz_trig_int_12 (Tfunction (tshort :: nil) tshort
                                             cc_default))
                   (Tfunction (tshort :: nil) tshort cc_default))
                 (Econs (Evalof (Evar _angle tint) tint) Enil) tshort)))
|}.

Definition f_pprz_itrig_sin := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_angle, tint) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Swhile
      (Ebinop Ogt (Evalof (Evar _angle tint) tint)
        (Ecast
          (Ebinop Omul
            (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
            (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
              (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint) tint)
      (Sdo (Eassignop Osub (Evar _angle tint)
             (Ecast
               (Ebinop Omul
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
             tint tint)))
    (Swhile
      (Ebinop Olt (Evalof (Evar _angle tint) tint)
        (Eunop Oneg
          (Ecast
            (Ebinop Omul
              (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
              (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint) tint)
        tint)
      (Sdo (Eassignop Oadd (Evar _angle tint)
             (Ecast
               (Ebinop Omul
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
             tint tint))))
  (Ssequence
    (Sifthenelse (Ebinop Ogt (Evalof (Evar _angle tint) tint)
                   (Ecast
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                     tint) tint)
      (Sdo (Eassign (Evar _angle tint)
             (Ebinop Osub
               (Ecast
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
               (Evalof (Evar _angle tint) tint) tint) tint))
      (Sifthenelse (Ebinop Olt (Evalof (Evar _angle tint) tint)
                     (Eunop Oneg
                       (Ecast
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                         tint) tint) tint)
        (Sdo (Eassign (Evar _angle tint)
               (Ebinop Osub
                 (Eunop Oneg
                   (Ecast
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                     tint) tint) (Evalof (Evar _angle tint) tint) tint) tint))
        Sskip))
    (Sifthenelse (Ebinop Oge (Evalof (Evar _angle tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
      (Sreturn (Some (Ecall
                       (Evalof
                         (Evar _pprz_trig_int_f (Tfunction (tint :: nil)
                                                  tshort cc_default))
                         (Tfunction (tint :: nil) tshort cc_default))
                       (Econs (Evalof (Evar _angle tint) tint) Enil) tshort)))
      (Sreturn (Some (Eunop Oneg
                       (Ecall
                         (Evalof
                           (Evar _pprz_trig_int_f (Tfunction (tint :: nil)
                                                    tshort cc_default))
                           (Tfunction (tint :: nil) tshort cc_default))
                         (Econs
                           (Eunop Oneg (Evalof (Evar _angle tint) tint) tint)
                           Enil) tshort) tint))))))
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
 (_pprz_trig_int_compr, Gvar v_pprz_trig_int_compr) ::
 (_data_buf_12, Gvar v_data_buf_12) ::
 (_table_encode_12, Gfun(Internal f_table_encode_12)) ::
 (_pprz_trig_int_12, Gfun(Internal f_pprz_trig_int_12)) ::
 (_get_nibble, Gfun(Internal f_get_nibble)) ::
 (_pprz_trig_int_init, Gfun(Internal f_pprz_trig_int_init)) ::
 (_pprz_trig_int_f, Gfun(Internal f_pprz_trig_int_f)) ::
 (_pprz_itrig_sin, Gfun(Internal f_pprz_itrig_sin)) :: nil).

Definition public_idents : list ident :=
(_pprz_itrig_sin :: _pprz_trig_int_f :: _pprz_trig_int_init :: _get_nibble ::
 _pprz_trig_int_12 :: _table_encode_12 :: _data_buf_12 ::
 _pprz_trig_int_compr :: ___builtin_debug :: ___builtin_write32_reversed ::
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


