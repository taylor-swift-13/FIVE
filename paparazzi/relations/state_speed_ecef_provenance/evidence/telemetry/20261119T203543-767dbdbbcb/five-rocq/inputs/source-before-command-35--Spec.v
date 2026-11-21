From Stdlib Require Import ZArith.
From compcert Require Import AST Integers Values Memory Ctypes Csyntax.
From StateSpeedMemory Require Import Protocol CBMCGuardSpec.
Open Scope Z_scope.
(* All276 actual emitted IDs are listed verbatim; positive counterexample goals retain nonblocking failure semantics. *)

(* ecef_of_enu_vect_f.pointer_dereference.1 | SUCCESS | dereference failure: pointer NULL in def->ltp_of_ecef *)
Definition property_0:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.2 | SUCCESS | dereference failure: pointer invalid in def->ltp_of_ecef *)
Definition property_1:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.3 | SUCCESS | dereference failure: deallocated dynamic object in def->ltp_of_ecef *)
Definition property_2:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.4 | SUCCESS | dereference failure: dead object in def->ltp_of_ecef *)
Definition property_3:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.5 | SUCCESS | dereference failure: pointer outside object bounds in def->ltp_of_ecef *)
Definition property_4:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.6 | SUCCESS | dereference failure: invalid integer address in def->ltp_of_ecef *)
Definition property_5:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.1 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)0] *)
Definition property_6:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.2 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)1] *)
Definition property_7:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.3 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)2] *)
Definition property_8:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.4 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)3] *)
Definition property_9:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.5 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)4] *)
Definition property_10:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.6 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)5] *)
Definition property_11:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.7 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)6] *)
Definition property_12:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.8 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)7] *)
Definition property_13:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.array_bounds.9 | SUCCESS | array.ltp_of_ecef.m dynamic object upper bound in def->ltp_of_ecef.m[(signed long int)8] *)
Definition property_14:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.7 | SUCCESS | dereference failure: pointer NULL in enu->x *)
Definition property_15:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.8 | SUCCESS | dereference failure: pointer invalid in enu->x *)
Definition property_16:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.9 | SUCCESS | dereference failure: deallocated dynamic object in enu->x *)
Definition property_17:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.10 | SUCCESS | dereference failure: dead object in enu->x *)
Definition property_18:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.11 | SUCCESS | dereference failure: pointer outside object bounds in enu->x *)
Definition property_19:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.12 | SUCCESS | dereference failure: invalid integer address in enu->x *)
Definition property_20:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.13 | SUCCESS | dereference failure: pointer NULL in enu->y *)
Definition property_21:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.14 | SUCCESS | dereference failure: pointer invalid in enu->y *)
Definition property_22:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.15 | SUCCESS | dereference failure: deallocated dynamic object in enu->y *)
Definition property_23:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.16 | SUCCESS | dereference failure: dead object in enu->y *)
Definition property_24:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.17 | SUCCESS | dereference failure: pointer outside object bounds in enu->y *)
Definition property_25:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.18 | SUCCESS | dereference failure: invalid integer address in enu->y *)
Definition property_26:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.19 | SUCCESS | dereference failure: pointer NULL in enu->z *)
Definition property_27:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.20 | SUCCESS | dereference failure: pointer invalid in enu->z *)
Definition property_28:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.21 | SUCCESS | dereference failure: deallocated dynamic object in enu->z *)
Definition property_29:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.22 | SUCCESS | dereference failure: dead object in enu->z *)
Definition property_30:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.23 | SUCCESS | dereference failure: pointer outside object bounds in enu->z *)
Definition property_31:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.24 | SUCCESS | dereference failure: invalid integer address in enu->z *)
Definition property_32:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.1 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 0)] * (double)enu_d.x *)
Definition property_33:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.1 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 0)] * (double)enu_d.x *)
Definition property_34:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.2 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(1 * 3 + 0)] * (double)enu_d.y *)
Definition property_35:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.2 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(1 * 3 + 0)] * (double)enu_d.y *)
Definition property_36:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.3 | SUCCESS | NaN on + in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 0)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 0)] * (double)enu_d.y *)
Definition property_37:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.3 | SUCCESS | arithmetic overflow on floating-point addition in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 0)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 0)] * (double)enu_d.y *)
Definition property_38:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.4 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(2 * 3 + 0)] * (double)enu_d.z *)
Definition property_39:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.4 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(2 * 3 + 0)] * (double)enu_d.z *)
Definition property_40:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.5 | SUCCESS | NaN on + in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 0)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 0)] * (double)enu_d.y + ltp_of_ecef_d.m[(signed long int)(2 * 3 + 0)] * (double)enu_d.z *)
Definition property_41:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.5 | SUCCESS | arithmetic overflow on floating-point addition in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 0)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 0)] * (double)enu_d.y + ltp_of_ecef_d.m[(signed long int)(2 * 3 + 0)] * (double)enu_d.z *)
Definition property_42:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.6 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 1)] * (double)enu_d.x *)
Definition property_43:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.6 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 1)] * (double)enu_d.x *)
Definition property_44:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.7 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(1 * 3 + 1)] * (double)enu_d.y *)
Definition property_45:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.7 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(1 * 3 + 1)] * (double)enu_d.y *)
Definition property_46:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.8 | SUCCESS | NaN on + in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 1)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 1)] * (double)enu_d.y *)
Definition property_47:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.8 | SUCCESS | arithmetic overflow on floating-point addition in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 1)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 1)] * (double)enu_d.y *)
Definition property_48:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.9 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(2 * 3 + 1)] * (double)enu_d.z *)
Definition property_49:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.9 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(2 * 3 + 1)] * (double)enu_d.z *)
Definition property_50:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.10 | SUCCESS | NaN on + in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 1)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 1)] * (double)enu_d.y + ltp_of_ecef_d.m[(signed long int)(2 * 3 + 1)] * (double)enu_d.z *)
Definition property_51:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.10 | SUCCESS | arithmetic overflow on floating-point addition in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 1)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 1)] * (double)enu_d.y + ltp_of_ecef_d.m[(signed long int)(2 * 3 + 1)] * (double)enu_d.z *)
Definition property_52:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.11 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 2)] * (double)enu_d.x *)
Definition property_53:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.11 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 2)] * (double)enu_d.x *)
Definition property_54:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.12 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(1 * 3 + 2)] * (double)enu_d.y *)
Definition property_55:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.12 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(1 * 3 + 2)] * (double)enu_d.y *)
Definition property_56:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.13 | SUCCESS | NaN on + in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 2)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 2)] * (double)enu_d.y *)
Definition property_57:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.13 | SUCCESS | arithmetic overflow on floating-point addition in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 2)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 2)] * (double)enu_d.y *)
Definition property_58:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.14 | SUCCESS | NaN on * in ltp_of_ecef_d.m[(signed long int)(2 * 3 + 2)] * (double)enu_d.z *)
Definition property_59:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.14 | SUCCESS | arithmetic overflow on floating-point multiplication in ltp_of_ecef_d.m[(signed long int)(2 * 3 + 2)] * (double)enu_d.z *)
Definition property_60:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.NaN.15 | SUCCESS | NaN on + in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 2)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 2)] * (double)enu_d.y + ltp_of_ecef_d.m[(signed long int)(2 * 3 + 2)] * (double)enu_d.z *)
Definition property_61:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.overflow.15 | SUCCESS | arithmetic overflow on floating-point addition in ltp_of_ecef_d.m[(signed long int)(0 * 3 + 2)] * (double)enu_d.x + ltp_of_ecef_d.m[(signed long int)(1 * 3 + 2)] * (double)enu_d.y + ltp_of_ecef_d.m[(signed long int)(2 * 3 + 2)] * (double)enu_d.z *)
Definition property_62:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.25 | SUCCESS | dereference failure: pointer NULL in ecef->x *)
Definition property_63:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.26 | SUCCESS | dereference failure: pointer invalid in ecef->x *)
Definition property_64:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.27 | SUCCESS | dereference failure: deallocated dynamic object in ecef->x *)
Definition property_65:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.28 | SUCCESS | dereference failure: dead object in ecef->x *)
Definition property_66:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.29 | SUCCESS | dereference failure: pointer outside object bounds in ecef->x *)
Definition property_67:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.30 | SUCCESS | dereference failure: invalid integer address in ecef->x *)
Definition property_68:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.31 | SUCCESS | dereference failure: pointer NULL in ecef->y *)
Definition property_69:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.32 | SUCCESS | dereference failure: pointer invalid in ecef->y *)
Definition property_70:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.33 | SUCCESS | dereference failure: deallocated dynamic object in ecef->y *)
Definition property_71:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.34 | SUCCESS | dereference failure: dead object in ecef->y *)
Definition property_72:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.35 | SUCCESS | dereference failure: pointer outside object bounds in ecef->y *)
Definition property_73:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.36 | SUCCESS | dereference failure: invalid integer address in ecef->y *)
Definition property_74:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.37 | SUCCESS | dereference failure: pointer NULL in ecef->z *)
Definition property_75:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.38 | SUCCESS | dereference failure: pointer invalid in ecef->z *)
Definition property_76:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.39 | SUCCESS | dereference failure: deallocated dynamic object in ecef->z *)
Definition property_77:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.40 | SUCCESS | dereference failure: dead object in ecef->z *)
Definition property_78:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.41 | SUCCESS | dereference failure: pointer outside object bounds in ecef->z *)
Definition property_79:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_enu_vect_f.pointer_dereference.42 | SUCCESS | dereference failure: invalid integer address in ecef->z *)
Definition property_80:Prop:=FallbackGuard G.S.f_ecef_of_enu_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.1 | SUCCESS | dereference failure: pointer NULL in ned->y *)
Definition property_81:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.2 | SUCCESS | dereference failure: pointer invalid in ned->y *)
Definition property_82:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.3 | SUCCESS | dereference failure: deallocated dynamic object in ned->y *)
Definition property_83:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.4 | SUCCESS | dereference failure: dead object in ned->y *)
Definition property_84:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.5 | SUCCESS | dereference failure: pointer outside object bounds in ned->y *)
Definition property_85:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.6 | SUCCESS | dereference failure: invalid integer address in ned->y *)
Definition property_86:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.7 | SUCCESS | dereference failure: pointer NULL in ned->x *)
Definition property_87:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.8 | SUCCESS | dereference failure: pointer invalid in ned->x *)
Definition property_88:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.9 | SUCCESS | dereference failure: deallocated dynamic object in ned->x *)
Definition property_89:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.10 | SUCCESS | dereference failure: dead object in ned->x *)
Definition property_90:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.11 | SUCCESS | dereference failure: pointer outside object bounds in ned->x *)
Definition property_91:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.12 | SUCCESS | dereference failure: invalid integer address in ned->x *)
Definition property_92:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.13 | SUCCESS | dereference failure: pointer NULL in ned->z *)
Definition property_93:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.14 | SUCCESS | dereference failure: pointer invalid in ned->z *)
Definition property_94:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.15 | SUCCESS | dereference failure: deallocated dynamic object in ned->z *)
Definition property_95:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.16 | SUCCESS | dereference failure: dead object in ned->z *)
Definition property_96:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.17 | SUCCESS | dereference failure: pointer outside object bounds in ned->z *)
Definition property_97:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* ecef_of_ned_vect_f.pointer_dereference.18 | SUCCESS | dereference failure: invalid integer address in ned->z *)
Definition property_98:Prop:=FallbackGuard G.S.f_ecef_of_ned_vect_f.

(* main.assertion.1 | SUCCESS | both NED setters accepted and selected NED_I *)
Definition property_99:Prop:=MainAssertion 1%nat.

(* main.assertion.2 | SUCCESS | both ECEF setters accepted and selected only ECEF_I *)
Definition property_100:Prop:=MainAssertion 2%nat.

(* main.assertion.3 | SUCCESS | both actual ECEF integer fields contain the new complete input *)
Definition property_101:Prop:=MainAssertion 3%nat.

(* main.assertion.4 | SUCCESS | ECEF setter preserves actual numeric NED history *)
Definition property_102:Prop:=MainAssertion 4%nat.

(* main.assertion.5 | SUCCESS | getter returns the actual ECEF float field pointer *)
Definition property_103:Prop:=MainAssertion 5%nat.

(* main.assertion.6 | SUCCESS | getter sets ECEF_F without restoring the NED validity bit *)
Definition property_104:Prop:=MainAssertion 6%nat.

(* main.array_bounds.1 | SUCCESS | array 'a'.before_get upper bound in a.before_get[(signed long int)i] *)
Definition property_105:Prop:=MainArrayGuard false.

(* main.array_bounds.2 | SUCCESS | array 'a'.after_get upper bound in a.after_get[(signed long int)i] *)
Definition property_106:Prop:=MainArrayGuard true.

(* main.array_bounds.3 | SUCCESS | array 'b'.before_get upper bound in b.before_get[(signed long int)i] *)
Definition property_107:Prop:=MainArrayGuard false.

(* main.array_bounds.4 | SUCCESS | array 'b'.after_get upper bound in b.after_get[(signed long int)i] *)
Definition property_108:Prop:=MainArrayGuard true.

(* main.assertion.7 | SUCCESS | getter preserves every State byte outside actual ECEF float/status writes *)
Definition property_109:Prop:=MainAssertion 7%nat.

(* main.assertion.8 | FAILURE | first actual read after ECEF write decodes new ECEF input *)
Definition property_110:Prop:=MainAssertion 8%nat.

(* main.assertion.9 | FAILURE | second actual read after ECEF write decodes new ECEF input *)
Definition property_111:Prop:=MainAssertion 9%nat.

(* main.assertion.10 | FAILURE | ECEF getter output is independent of overwritten NED history *)
Definition property_112:Prop:=MainAssertion 10%nat.

(* protocol.precondition_instance.1 | SUCCESS | memset destination region writeable *)
Definition property_113:Prop:=ZeroInitializationGuard.

(* protocol.pointer_dereference.1 | SUCCESS | dereference failure: pointer NULL in out->ned_status *)
Definition property_114:Prop:=ObserverPointerGuard 0 Mint16unsigned 0%nat.

(* protocol.pointer_dereference.2 | SUCCESS | dereference failure: pointer invalid in out->ned_status *)
Definition property_115:Prop:=ObserverPointerGuard 0 Mint16unsigned 1%nat.

(* protocol.pointer_dereference.3 | SUCCESS | dereference failure: deallocated dynamic object in out->ned_status *)
Definition property_116:Prop:=ObserverPointerGuard 0 Mint16unsigned 2%nat.

(* protocol.pointer_dereference.4 | SUCCESS | dereference failure: dead object in out->ned_status *)
Definition property_117:Prop:=ObserverPointerGuard 0 Mint16unsigned 3%nat.

(* protocol.pointer_dereference.5 | SUCCESS | dereference failure: pointer outside object bounds in out->ned_status *)
Definition property_118:Prop:=ObserverPointerGuard 0 Mint16unsigned 4%nat.

(* protocol.pointer_dereference.6 | SUCCESS | dereference failure: invalid integer address in out->ned_status *)
Definition property_119:Prop:=ObserverPointerGuard 0 Mint16unsigned 5%nat.

(* protocol.pointer_dereference.7 | SUCCESS | dereference failure: pointer NULL in out->ecef_status *)
Definition property_120:Prop:=ObserverPointerGuard 2 Mint16unsigned 0%nat.

(* protocol.pointer_dereference.8 | SUCCESS | dereference failure: pointer invalid in out->ecef_status *)
Definition property_121:Prop:=ObserverPointerGuard 2 Mint16unsigned 1%nat.

(* protocol.pointer_dereference.9 | SUCCESS | dereference failure: deallocated dynamic object in out->ecef_status *)
Definition property_122:Prop:=ObserverPointerGuard 2 Mint16unsigned 2%nat.

(* protocol.pointer_dereference.10 | SUCCESS | dereference failure: dead object in out->ecef_status *)
Definition property_123:Prop:=ObserverPointerGuard 2 Mint16unsigned 3%nat.

(* protocol.pointer_dereference.11 | SUCCESS | dereference failure: pointer outside object bounds in out->ecef_status *)
Definition property_124:Prop:=ObserverPointerGuard 2 Mint16unsigned 4%nat.

(* protocol.pointer_dereference.12 | SUCCESS | dereference failure: invalid integer address in out->ecef_status *)
Definition property_125:Prop:=ObserverPointerGuard 2 Mint16unsigned 5%nat.

(* protocol.pointer_dereference.13 | SUCCESS | dereference failure: pointer NULL in out->copied_ecef *)
Definition property_126:Prop:=ObserverPointerGuard 8 Mint32 0%nat.

(* protocol.pointer_dereference.14 | SUCCESS | dereference failure: pointer invalid in out->copied_ecef *)
Definition property_127:Prop:=ObserverPointerGuard 8 Mint32 1%nat.

(* protocol.pointer_dereference.15 | SUCCESS | dereference failure: deallocated dynamic object in out->copied_ecef *)
Definition property_128:Prop:=ObserverPointerGuard 8 Mint32 2%nat.

(* protocol.pointer_dereference.16 | SUCCESS | dereference failure: dead object in out->copied_ecef *)
Definition property_129:Prop:=ObserverPointerGuard 8 Mint32 3%nat.

(* protocol.pointer_dereference.17 | SUCCESS | dereference failure: pointer outside object bounds in out->copied_ecef *)
Definition property_130:Prop:=ObserverPointerGuard 8 Mint32 4%nat.

(* protocol.pointer_dereference.18 | SUCCESS | dereference failure: invalid integer address in out->copied_ecef *)
Definition property_131:Prop:=ObserverPointerGuard 8 Mint32 5%nat.

(* protocol.array_bounds.1 | SUCCESS | array.copied_ecef dynamic object upper bound in out->copied_ecef[(signed long int)0] *)
Definition property_132:Prop:=ObserverArrayGuard 8 0.

(* protocol.pointer_dereference.19 | SUCCESS | dereference failure: pointer NULL in out->copied_ecef *)
Definition property_133:Prop:=ObserverPointerGuard 12 Mint32 0%nat.

(* protocol.pointer_dereference.20 | SUCCESS | dereference failure: pointer invalid in out->copied_ecef *)
Definition property_134:Prop:=ObserverPointerGuard 12 Mint32 1%nat.

(* protocol.pointer_dereference.21 | SUCCESS | dereference failure: deallocated dynamic object in out->copied_ecef *)
Definition property_135:Prop:=ObserverPointerGuard 12 Mint32 2%nat.

(* protocol.pointer_dereference.22 | SUCCESS | dereference failure: dead object in out->copied_ecef *)
Definition property_136:Prop:=ObserverPointerGuard 12 Mint32 3%nat.

(* protocol.pointer_dereference.23 | SUCCESS | dereference failure: pointer outside object bounds in out->copied_ecef *)
Definition property_137:Prop:=ObserverPointerGuard 12 Mint32 4%nat.

(* protocol.pointer_dereference.24 | SUCCESS | dereference failure: invalid integer address in out->copied_ecef *)
Definition property_138:Prop:=ObserverPointerGuard 12 Mint32 5%nat.

(* protocol.array_bounds.2 | SUCCESS | array.copied_ecef dynamic object upper bound in out->copied_ecef[(signed long int)1] *)
Definition property_139:Prop:=ObserverArrayGuard 8 1.

(* protocol.pointer_dereference.25 | SUCCESS | dereference failure: pointer NULL in out->copied_ecef *)
Definition property_140:Prop:=ObserverPointerGuard 16 Mint32 0%nat.

(* protocol.pointer_dereference.26 | SUCCESS | dereference failure: pointer invalid in out->copied_ecef *)
Definition property_141:Prop:=ObserverPointerGuard 16 Mint32 1%nat.

(* protocol.pointer_dereference.27 | SUCCESS | dereference failure: deallocated dynamic object in out->copied_ecef *)
Definition property_142:Prop:=ObserverPointerGuard 16 Mint32 2%nat.

(* protocol.pointer_dereference.28 | SUCCESS | dereference failure: dead object in out->copied_ecef *)
Definition property_143:Prop:=ObserverPointerGuard 16 Mint32 3%nat.

(* protocol.pointer_dereference.29 | SUCCESS | dereference failure: pointer outside object bounds in out->copied_ecef *)
Definition property_144:Prop:=ObserverPointerGuard 16 Mint32 4%nat.

(* protocol.pointer_dereference.30 | SUCCESS | dereference failure: invalid integer address in out->copied_ecef *)
Definition property_145:Prop:=ObserverPointerGuard 16 Mint32 5%nat.

(* protocol.array_bounds.3 | SUCCESS | array.copied_ecef dynamic object upper bound in out->copied_ecef[(signed long int)2] *)
Definition property_146:Prop:=ObserverArrayGuard 8 2.

(* protocol.pointer_dereference.31 | SUCCESS | dereference failure: pointer NULL in out->stale_ned *)
Definition property_147:Prop:=ObserverPointerGuard 20 Mint32 0%nat.

(* protocol.pointer_dereference.32 | SUCCESS | dereference failure: pointer invalid in out->stale_ned *)
Definition property_148:Prop:=ObserverPointerGuard 20 Mint32 1%nat.

(* protocol.pointer_dereference.33 | SUCCESS | dereference failure: deallocated dynamic object in out->stale_ned *)
Definition property_149:Prop:=ObserverPointerGuard 20 Mint32 2%nat.

(* protocol.pointer_dereference.34 | SUCCESS | dereference failure: dead object in out->stale_ned *)
Definition property_150:Prop:=ObserverPointerGuard 20 Mint32 3%nat.

(* protocol.pointer_dereference.35 | SUCCESS | dereference failure: pointer outside object bounds in out->stale_ned *)
Definition property_151:Prop:=ObserverPointerGuard 20 Mint32 4%nat.

(* protocol.pointer_dereference.36 | SUCCESS | dereference failure: invalid integer address in out->stale_ned *)
Definition property_152:Prop:=ObserverPointerGuard 20 Mint32 5%nat.

(* protocol.array_bounds.4 | SUCCESS | array.stale_ned dynamic object upper bound in out->stale_ned[(signed long int)0] *)
Definition property_153:Prop:=ObserverArrayGuard 20 0.

(* protocol.pointer_dereference.37 | SUCCESS | dereference failure: pointer NULL in out->stale_ned *)
Definition property_154:Prop:=ObserverPointerGuard 24 Mint32 0%nat.

(* protocol.pointer_dereference.38 | SUCCESS | dereference failure: pointer invalid in out->stale_ned *)
Definition property_155:Prop:=ObserverPointerGuard 24 Mint32 1%nat.

(* protocol.pointer_dereference.39 | SUCCESS | dereference failure: deallocated dynamic object in out->stale_ned *)
Definition property_156:Prop:=ObserverPointerGuard 24 Mint32 2%nat.

(* protocol.pointer_dereference.40 | SUCCESS | dereference failure: dead object in out->stale_ned *)
Definition property_157:Prop:=ObserverPointerGuard 24 Mint32 3%nat.

(* protocol.pointer_dereference.41 | SUCCESS | dereference failure: pointer outside object bounds in out->stale_ned *)
Definition property_158:Prop:=ObserverPointerGuard 24 Mint32 4%nat.

(* protocol.pointer_dereference.42 | SUCCESS | dereference failure: invalid integer address in out->stale_ned *)
Definition property_159:Prop:=ObserverPointerGuard 24 Mint32 5%nat.

(* protocol.array_bounds.5 | SUCCESS | array.stale_ned dynamic object upper bound in out->stale_ned[(signed long int)1] *)
Definition property_160:Prop:=ObserverArrayGuard 20 1.

(* protocol.pointer_dereference.43 | SUCCESS | dereference failure: pointer NULL in out->stale_ned *)
Definition property_161:Prop:=ObserverPointerGuard 28 Mint32 0%nat.

(* protocol.pointer_dereference.44 | SUCCESS | dereference failure: pointer invalid in out->stale_ned *)
Definition property_162:Prop:=ObserverPointerGuard 28 Mint32 1%nat.

(* protocol.pointer_dereference.45 | SUCCESS | dereference failure: deallocated dynamic object in out->stale_ned *)
Definition property_163:Prop:=ObserverPointerGuard 28 Mint32 2%nat.

(* protocol.pointer_dereference.46 | SUCCESS | dereference failure: dead object in out->stale_ned *)
Definition property_164:Prop:=ObserverPointerGuard 28 Mint32 3%nat.

(* protocol.pointer_dereference.47 | SUCCESS | dereference failure: pointer outside object bounds in out->stale_ned *)
Definition property_165:Prop:=ObserverPointerGuard 28 Mint32 4%nat.

(* protocol.pointer_dereference.48 | SUCCESS | dereference failure: invalid integer address in out->stale_ned *)
Definition property_166:Prop:=ObserverPointerGuard 28 Mint32 5%nat.

(* protocol.array_bounds.6 | SUCCESS | array.stale_ned dynamic object upper bound in out->stale_ned[(signed long int)2] *)
Definition property_167:Prop:=ObserverArrayGuard 20 2.

(* memcpy.pointer_arithmetic.1 | SUCCESS | pointer arithmetic: pointer NULL in (const unsigned char *)(void *)out->before_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_168:Prop:=GuardedMemcpyPointer false false 0 48 656 704 0%nat.

(* memcpy.pointer_arithmetic.2 | SUCCESS | pointer arithmetic: deallocated dynamic object in (const unsigned char *)(void *)out->before_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_169:Prop:=GuardedMemcpyPointer false false 0 48 656 704 2%nat.

(* memcpy.pointer_arithmetic.3 | SUCCESS | pointer arithmetic: dead object in (const unsigned char *)(void *)out->before_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_170:Prop:=GuardedMemcpyPointer false false 0 48 656 704 3%nat.

(* memcpy.pointer_arithmetic.4 | SUCCESS | pointer arithmetic: pointer outside object bounds in (const unsigned char *)(void *)out->before_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_171:Prop:=GuardedMemcpyPointer false false 0 48 656 704 4%nat.

(* memcpy.pointer_arithmetic.5 | SUCCESS | pointer arithmetic: invalid integer address in (const unsigned char *)(void *)out->before_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_172:Prop:=GuardedMemcpyPointer false false 0 48 656 704 5%nat.

(* memcpy.pointer.1 | SUCCESS | same object violation in (const unsigned char *)(const void *)&state >= (const unsigned char *)(void *)out->before_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_173:Prop:=GuardedMemcpySameObject false 0 48 656.

(* memcpy.pointer.2 | SUCCESS | same object violation in (const unsigned char *)(void *)out->before_get >= (const unsigned char *)(const void *)&state + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_174:Prop:=GuardedMemcpySameObject true 0 48 656.

(* memcpy.pointer_arithmetic.6 | SUCCESS | pointer relation: pointer NULL in (const unsigned char *)(void *)out->before_get *)
Definition property_175:Prop:=GuardedMemcpyPointer true false 0 48 656 48 0%nat.

(* memcpy.pointer_arithmetic.7 | SUCCESS | pointer relation: deallocated dynamic object in (const unsigned char *)(void *)out->before_get *)
Definition property_176:Prop:=GuardedMemcpyPointer true false 0 48 656 48 2%nat.

(* memcpy.pointer_arithmetic.8 | SUCCESS | pointer relation: dead object in (const unsigned char *)(void *)out->before_get *)
Definition property_177:Prop:=GuardedMemcpyPointer true false 0 48 656 48 3%nat.

(* memcpy.pointer_arithmetic.9 | SUCCESS | pointer relation: pointer outside object bounds in (const unsigned char *)(void *)out->before_get *)
Definition property_178:Prop:=GuardedMemcpyPointer true false 0 48 656 48 4%nat.

(* protocol.precondition_instance.2 | SUCCESS | memcpy src/dst overlap *)
Definition property_179:Prop:=CopyNonoverlap 0 48 656.

(* protocol.precondition_instance.3 | SUCCESS | memcpy source region readable *)
Definition property_180:Prop:=(ProtocolSourceReadable false 0 656 /\ProtocolCopy false 0 48 656).

(* protocol.precondition_instance.4 | SUCCESS | memcpy destination region writeable *)
Definition property_181:Prop:=ObserverDestinationWritable 48 656.

(* protocol.pointer_dereference.49 | SUCCESS | dereference failure: pointer NULL in out->pointer_is_state *)
Definition property_182:Prop:=ObserverPointerGuard 32 Mbool 0%nat.

(* protocol.pointer_dereference.50 | SUCCESS | dereference failure: pointer invalid in out->pointer_is_state *)
Definition property_183:Prop:=ObserverPointerGuard 32 Mbool 1%nat.

(* protocol.pointer_dereference.51 | SUCCESS | dereference failure: deallocated dynamic object in out->pointer_is_state *)
Definition property_184:Prop:=ObserverPointerGuard 32 Mbool 2%nat.

(* protocol.pointer_dereference.52 | SUCCESS | dereference failure: dead object in out->pointer_is_state *)
Definition property_185:Prop:=ObserverPointerGuard 32 Mbool 3%nat.

(* protocol.pointer_dereference.53 | SUCCESS | dereference failure: pointer outside object bounds in out->pointer_is_state *)
Definition property_186:Prop:=ObserverPointerGuard 32 Mbool 4%nat.

(* protocol.pointer_dereference.54 | SUCCESS | dereference failure: invalid integer address in out->pointer_is_state *)
Definition property_187:Prop:=ObserverPointerGuard 32 Mbool 5%nat.

(* memcpy.pointer_arithmetic.10 | SUCCESS | pointer arithmetic: pointer NULL in (const unsigned char *)(void *)out->bits + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_188:Prop:=GuardedMemcpyPointer false false 328 36 12 48 0%nat.

(* memcpy.pointer_arithmetic.11 | SUCCESS | pointer arithmetic: deallocated dynamic object in (const unsigned char *)(void *)out->bits + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_189:Prop:=GuardedMemcpyPointer false false 328 36 12 48 2%nat.

(* memcpy.pointer_arithmetic.12 | SUCCESS | pointer arithmetic: dead object in (const unsigned char *)(void *)out->bits + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_190:Prop:=GuardedMemcpyPointer false false 328 36 12 48 3%nat.

(* memcpy.pointer_arithmetic.13 | SUCCESS | pointer arithmetic: pointer outside object bounds in (const unsigned char *)(void *)out->bits + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_191:Prop:=GuardedMemcpyPointer false false 328 36 12 48 4%nat.

(* memcpy.pointer_arithmetic.14 | SUCCESS | pointer arithmetic: invalid integer address in (const unsigned char *)(void *)out->bits + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_192:Prop:=GuardedMemcpyPointer false false 328 36 12 48 5%nat.

(* memcpy.pointer.3 | SUCCESS | same object violation in (const unsigned char *)(const void *)returned >= (const unsigned char *)(void *)out->bits + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_193:Prop:=GuardedMemcpySameObject false 328 36 12.

(* memcpy.pointer_arithmetic.15 | SUCCESS | pointer relation: pointer NULL in (const unsigned char *)(const void *)returned *)
Definition property_194:Prop:=GuardedMemcpyPointer false true 328 36 12 328 0%nat.

(* memcpy.pointer_arithmetic.16 | SUCCESS | pointer relation: pointer invalid in (const unsigned char *)(const void *)returned *)
Definition property_195:Prop:=GuardedMemcpyPointer false true 328 36 12 328 1%nat.

(* memcpy.pointer_arithmetic.17 | SUCCESS | pointer relation: deallocated dynamic object in (const unsigned char *)(const void *)returned *)
Definition property_196:Prop:=GuardedMemcpyPointer false true 328 36 12 328 2%nat.

(* memcpy.pointer_arithmetic.18 | SUCCESS | pointer relation: dead object in (const unsigned char *)(const void *)returned *)
Definition property_197:Prop:=GuardedMemcpyPointer false true 328 36 12 328 3%nat.

(* memcpy.pointer_arithmetic.19 | SUCCESS | pointer relation: pointer outside object bounds in (const unsigned char *)(const void *)returned *)
Definition property_198:Prop:=GuardedMemcpyPointer false true 328 36 12 328 4%nat.

(* memcpy.pointer_arithmetic.20 | SUCCESS | pointer relation: invalid integer address in (const unsigned char *)(const void *)returned *)
Definition property_199:Prop:=GuardedMemcpyPointer false true 328 36 12 328 5%nat.

(* memcpy.pointer_arithmetic.21 | SUCCESS | pointer arithmetic: pointer NULL in (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_200:Prop:=GuardedMemcpyPointer true true 328 36 12 340 0%nat.

(* memcpy.pointer_arithmetic.22 | SUCCESS | pointer arithmetic: pointer invalid in (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_201:Prop:=GuardedMemcpyPointer true true 328 36 12 340 1%nat.

(* memcpy.pointer_arithmetic.23 | SUCCESS | pointer arithmetic: deallocated dynamic object in (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_202:Prop:=GuardedMemcpyPointer true true 328 36 12 340 2%nat.

(* memcpy.pointer_arithmetic.24 | SUCCESS | pointer arithmetic: dead object in (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_203:Prop:=GuardedMemcpyPointer true true 328 36 12 340 3%nat.

(* memcpy.pointer_arithmetic.25 | SUCCESS | pointer arithmetic: pointer outside object bounds in (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_204:Prop:=GuardedMemcpyPointer true true 328 36 12 340 4%nat.

(* memcpy.pointer_arithmetic.26 | SUCCESS | pointer arithmetic: invalid integer address in (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_205:Prop:=GuardedMemcpyPointer true true 328 36 12 340 5%nat.

(* memcpy.pointer.4 | SUCCESS | same object violation in (const unsigned char *)(void *)out->bits >= (const unsigned char *)(const void *)returned + (signed long int)sizeof(uint32_t [3l]) /*12ul*/  *)
Definition property_206:Prop:=GuardedMemcpySameObject true 328 36 12.

(* memcpy.pointer_arithmetic.27 | SUCCESS | pointer relation: pointer NULL in (const unsigned char *)(void *)out->bits *)
Definition property_207:Prop:=GuardedMemcpyPointer true false 328 36 12 36 0%nat.

(* memcpy.pointer_arithmetic.28 | SUCCESS | pointer relation: deallocated dynamic object in (const unsigned char *)(void *)out->bits *)
Definition property_208:Prop:=GuardedMemcpyPointer true false 328 36 12 36 2%nat.

(* memcpy.pointer_arithmetic.29 | SUCCESS | pointer relation: dead object in (const unsigned char *)(void *)out->bits *)
Definition property_209:Prop:=GuardedMemcpyPointer true false 328 36 12 36 3%nat.

(* memcpy.pointer_arithmetic.30 | SUCCESS | pointer relation: pointer outside object bounds in (const unsigned char *)(void *)out->bits *)
Definition property_210:Prop:=GuardedMemcpyPointer true false 328 36 12 36 4%nat.

(* protocol.precondition_instance.5 | SUCCESS | memcpy src/dst overlap *)
Definition property_211:Prop:=CopyNonoverlap 328 36 12.

(* protocol.precondition_instance.6 | SUCCESS | memcpy source region readable *)
Definition property_212:Prop:=(ProtocolSourceReadable true 328 12 /\ProtocolCopy true 328 36 12).

(* protocol.precondition_instance.7 | SUCCESS | memcpy destination region writeable *)
Definition property_213:Prop:=ObserverDestinationWritable 36 12.

(* protocol.pointer_dereference.55 | SUCCESS | dereference failure: pointer NULL in out->returned_status *)
Definition property_214:Prop:=ObserverPointerGuard 4 Mint16unsigned 0%nat.

(* protocol.pointer_dereference.56 | SUCCESS | dereference failure: pointer invalid in out->returned_status *)
Definition property_215:Prop:=ObserverPointerGuard 4 Mint16unsigned 1%nat.

(* protocol.pointer_dereference.57 | SUCCESS | dereference failure: deallocated dynamic object in out->returned_status *)
Definition property_216:Prop:=ObserverPointerGuard 4 Mint16unsigned 2%nat.

(* protocol.pointer_dereference.58 | SUCCESS | dereference failure: dead object in out->returned_status *)
Definition property_217:Prop:=ObserverPointerGuard 4 Mint16unsigned 3%nat.

(* protocol.pointer_dereference.59 | SUCCESS | dereference failure: pointer outside object bounds in out->returned_status *)
Definition property_218:Prop:=ObserverPointerGuard 4 Mint16unsigned 4%nat.

(* protocol.pointer_dereference.60 | SUCCESS | dereference failure: invalid integer address in out->returned_status *)
Definition property_219:Prop:=ObserverPointerGuard 4 Mint16unsigned 5%nat.

(* memcpy.pointer_arithmetic.31 | SUCCESS | pointer arithmetic: pointer NULL in (const unsigned char *)(void *)out->after_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_220:Prop:=GuardedMemcpyPointer false false 0 704 656 1360 0%nat.

(* memcpy.pointer_arithmetic.32 | SUCCESS | pointer arithmetic: deallocated dynamic object in (const unsigned char *)(void *)out->after_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_221:Prop:=GuardedMemcpyPointer false false 0 704 656 1360 2%nat.

(* memcpy.pointer_arithmetic.33 | SUCCESS | pointer arithmetic: dead object in (const unsigned char *)(void *)out->after_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_222:Prop:=GuardedMemcpyPointer false false 0 704 656 1360 3%nat.

(* memcpy.pointer_arithmetic.34 | SUCCESS | pointer arithmetic: pointer outside object bounds in (const unsigned char *)(void *)out->after_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_223:Prop:=GuardedMemcpyPointer false false 0 704 656 1360 4%nat.

(* memcpy.pointer_arithmetic.35 | SUCCESS | pointer arithmetic: invalid integer address in (const unsigned char *)(void *)out->after_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_224:Prop:=GuardedMemcpyPointer false false 0 704 656 1360 5%nat.

(* memcpy.pointer.5 | SUCCESS | same object violation in (const unsigned char *)(const void *)&state >= (const unsigned char *)(void *)out->after_get + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_225:Prop:=GuardedMemcpySameObject false 0 704 656.

(* memcpy.pointer.6 | SUCCESS | same object violation in (const unsigned char *)(void *)out->after_get >= (const unsigned char *)(const void *)&state + (signed long int)sizeof(struct State) /*656ul*/  *)
Definition property_226:Prop:=GuardedMemcpySameObject true 0 704 656.

(* memcpy.pointer_arithmetic.36 | SUCCESS | pointer relation: pointer NULL in (const unsigned char *)(void *)out->after_get *)
Definition property_227:Prop:=GuardedMemcpyPointer true false 0 704 656 704 0%nat.

(* memcpy.pointer_arithmetic.37 | SUCCESS | pointer relation: deallocated dynamic object in (const unsigned char *)(void *)out->after_get *)
Definition property_228:Prop:=GuardedMemcpyPointer true false 0 704 656 704 2%nat.

(* memcpy.pointer_arithmetic.38 | SUCCESS | pointer relation: dead object in (const unsigned char *)(void *)out->after_get *)
Definition property_229:Prop:=GuardedMemcpyPointer true false 0 704 656 704 3%nat.

(* memcpy.pointer_arithmetic.39 | SUCCESS | pointer relation: pointer outside object bounds in (const unsigned char *)(void *)out->after_get *)
Definition property_230:Prop:=GuardedMemcpyPointer true false 0 704 656 704 4%nat.

(* protocol.precondition_instance.8 | SUCCESS | memcpy src/dst overlap *)
Definition property_231:Prop:=CopyNonoverlap 0 704 656.

(* protocol.precondition_instance.9 | SUCCESS | memcpy source region readable *)
Definition property_232:Prop:=(ProtocolSourceReadable true 0 656 /\ProtocolCopy true 0 704 656).

(* protocol.precondition_instance.10 | SUCCESS | memcpy destination region writeable *)
Definition property_233:Prop:=ObserverDestinationWritable 704 656.

(* stateCalcSpeedEcef_f.overflow.1 | SUCCESS | arithmetic overflow on floating-point division in (float)state.ned_speed_i.x / (float)(1 << 19) *)
Definition property_234:Prop:=DivisionGuard false 0%nat.

(* stateCalcSpeedEcef_f.overflow.2 | SUCCESS | arithmetic overflow on floating-point division in (float)state.ned_speed_i.y / (float)(1 << 19) *)
Definition property_235:Prop:=DivisionGuard false 1%nat.

(* stateCalcSpeedEcef_f.overflow.3 | SUCCESS | arithmetic overflow on floating-point division in (float)state.ned_speed_i.z / (float)(1 << 19) *)
Definition property_236:Prop:=DivisionGuard false 2%nat.

(* stateCalcSpeedEcef_f.overflow.4 | SUCCESS | arithmetic overflow on floating-point division in (float)state.ned_speed_i.x / (float)(1 << 19) *)
Definition property_237:Prop:=DivisionGuard true 0%nat.

(* stateCalcSpeedEcef_f.overflow.5 | SUCCESS | arithmetic overflow on floating-point division in (float)state.ned_speed_i.y / (float)(1 << 19) *)
Definition property_238:Prop:=DivisionGuard true 1%nat.

(* stateCalcSpeedEcef_f.overflow.6 | SUCCESS | arithmetic overflow on floating-point division in (float)state.ned_speed_i.z / (float)(1 << 19) *)
Definition property_239:Prop:=DivisionGuard true 2%nat.

(* stateSetSpeedEcef_i.pointer_dereference.1 | SUCCESS | dereference failure: pointer NULL in ecef_speed->x *)
Definition property_240:Prop:=ESourceGuard 0 0%nat.

(* stateSetSpeedEcef_i.pointer_dereference.2 | SUCCESS | dereference failure: pointer invalid in ecef_speed->x *)
Definition property_241:Prop:=ESourceGuard 0 1%nat.

(* stateSetSpeedEcef_i.pointer_dereference.3 | SUCCESS | dereference failure: deallocated dynamic object in ecef_speed->x *)
Definition property_242:Prop:=ESourceGuard 0 2%nat.

(* stateSetSpeedEcef_i.pointer_dereference.4 | SUCCESS | dereference failure: dead object in ecef_speed->x *)
Definition property_243:Prop:=ESourceGuard 0 3%nat.

(* stateSetSpeedEcef_i.pointer_dereference.5 | SUCCESS | dereference failure: pointer outside object bounds in ecef_speed->x *)
Definition property_244:Prop:=ESourceGuard 0 4%nat.

(* stateSetSpeedEcef_i.pointer_dereference.6 | SUCCESS | dereference failure: invalid integer address in ecef_speed->x *)
Definition property_245:Prop:=ESourceGuard 0 5%nat.

(* stateSetSpeedEcef_i.pointer_dereference.7 | SUCCESS | dereference failure: pointer NULL in ecef_speed->y *)
Definition property_246:Prop:=ESourceGuard 4 0%nat.

(* stateSetSpeedEcef_i.pointer_dereference.8 | SUCCESS | dereference failure: pointer invalid in ecef_speed->y *)
Definition property_247:Prop:=ESourceGuard 4 1%nat.

(* stateSetSpeedEcef_i.pointer_dereference.9 | SUCCESS | dereference failure: deallocated dynamic object in ecef_speed->y *)
Definition property_248:Prop:=ESourceGuard 4 2%nat.

(* stateSetSpeedEcef_i.pointer_dereference.10 | SUCCESS | dereference failure: dead object in ecef_speed->y *)
Definition property_249:Prop:=ESourceGuard 4 3%nat.

(* stateSetSpeedEcef_i.pointer_dereference.11 | SUCCESS | dereference failure: pointer outside object bounds in ecef_speed->y *)
Definition property_250:Prop:=ESourceGuard 4 4%nat.

(* stateSetSpeedEcef_i.pointer_dereference.12 | SUCCESS | dereference failure: invalid integer address in ecef_speed->y *)
Definition property_251:Prop:=ESourceGuard 4 5%nat.

(* stateSetSpeedEcef_i.pointer_dereference.13 | SUCCESS | dereference failure: pointer NULL in ecef_speed->z *)
Definition property_252:Prop:=ESourceGuard 8 0%nat.

(* stateSetSpeedEcef_i.pointer_dereference.14 | SUCCESS | dereference failure: pointer invalid in ecef_speed->z *)
Definition property_253:Prop:=ESourceGuard 8 1%nat.

(* stateSetSpeedEcef_i.pointer_dereference.15 | SUCCESS | dereference failure: deallocated dynamic object in ecef_speed->z *)
Definition property_254:Prop:=ESourceGuard 8 2%nat.

(* stateSetSpeedEcef_i.pointer_dereference.16 | SUCCESS | dereference failure: dead object in ecef_speed->z *)
Definition property_255:Prop:=ESourceGuard 8 3%nat.

(* stateSetSpeedEcef_i.pointer_dereference.17 | SUCCESS | dereference failure: pointer outside object bounds in ecef_speed->z *)
Definition property_256:Prop:=ESourceGuard 8 4%nat.

(* stateSetSpeedEcef_i.pointer_dereference.18 | SUCCESS | dereference failure: invalid integer address in ecef_speed->z *)
Definition property_257:Prop:=ESourceGuard 8 5%nat.

(* stateSetSpeedNed_i.pointer_dereference.1 | SUCCESS | dereference failure: pointer NULL in ned_speed->x *)
Definition property_258:Prop:=NSourceGuard 0 0%nat.

(* stateSetSpeedNed_i.pointer_dereference.2 | SUCCESS | dereference failure: pointer invalid in ned_speed->x *)
Definition property_259:Prop:=NSourceGuard 0 1%nat.

(* stateSetSpeedNed_i.pointer_dereference.3 | SUCCESS | dereference failure: deallocated dynamic object in ned_speed->x *)
Definition property_260:Prop:=NSourceGuard 0 2%nat.

(* stateSetSpeedNed_i.pointer_dereference.4 | SUCCESS | dereference failure: dead object in ned_speed->x *)
Definition property_261:Prop:=NSourceGuard 0 3%nat.

(* stateSetSpeedNed_i.pointer_dereference.5 | SUCCESS | dereference failure: pointer outside object bounds in ned_speed->x *)
Definition property_262:Prop:=NSourceGuard 0 4%nat.

(* stateSetSpeedNed_i.pointer_dereference.6 | SUCCESS | dereference failure: invalid integer address in ned_speed->x *)
Definition property_263:Prop:=NSourceGuard 0 5%nat.

(* stateSetSpeedNed_i.pointer_dereference.7 | SUCCESS | dereference failure: pointer NULL in ned_speed->y *)
Definition property_264:Prop:=NSourceGuard 4 0%nat.

(* stateSetSpeedNed_i.pointer_dereference.8 | SUCCESS | dereference failure: pointer invalid in ned_speed->y *)
Definition property_265:Prop:=NSourceGuard 4 1%nat.

(* stateSetSpeedNed_i.pointer_dereference.9 | SUCCESS | dereference failure: deallocated dynamic object in ned_speed->y *)
Definition property_266:Prop:=NSourceGuard 4 2%nat.

(* stateSetSpeedNed_i.pointer_dereference.10 | SUCCESS | dereference failure: dead object in ned_speed->y *)
Definition property_267:Prop:=NSourceGuard 4 3%nat.

(* stateSetSpeedNed_i.pointer_dereference.11 | SUCCESS | dereference failure: pointer outside object bounds in ned_speed->y *)
Definition property_268:Prop:=NSourceGuard 4 4%nat.

(* stateSetSpeedNed_i.pointer_dereference.12 | SUCCESS | dereference failure: invalid integer address in ned_speed->y *)
Definition property_269:Prop:=NSourceGuard 4 5%nat.

(* stateSetSpeedNed_i.pointer_dereference.13 | SUCCESS | dereference failure: pointer NULL in ned_speed->z *)
Definition property_270:Prop:=NSourceGuard 8 0%nat.

(* stateSetSpeedNed_i.pointer_dereference.14 | SUCCESS | dereference failure: pointer invalid in ned_speed->z *)
Definition property_271:Prop:=NSourceGuard 8 1%nat.

(* stateSetSpeedNed_i.pointer_dereference.15 | SUCCESS | dereference failure: deallocated dynamic object in ned_speed->z *)
Definition property_272:Prop:=NSourceGuard 8 2%nat.

(* stateSetSpeedNed_i.pointer_dereference.16 | SUCCESS | dereference failure: dead object in ned_speed->z *)
Definition property_273:Prop:=NSourceGuard 8 3%nat.

(* stateSetSpeedNed_i.pointer_dereference.17 | SUCCESS | dereference failure: pointer outside object bounds in ned_speed->z *)
Definition property_274:Prop:=NSourceGuard 8 4%nat.

(* stateSetSpeedNed_i.pointer_dereference.18 | SUCCESS | dereference failure: invalid integer address in ned_speed->z *)
Definition property_275:Prop:=NSourceGuard 8 5%nat.

Definition ObserverPreparationGoal:Prop:=OrderedObserverPreparation /\ActualPointerComparison.
