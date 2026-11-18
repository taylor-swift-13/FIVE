From FiveGuidanceCbmcAdapters Require Import Adapters CanonicalCallScope.
From FiveGuidanceSoftwareProof Require Import GuardTrace GuardExecution GuardSiteMap.

(* Actual CBMC property memcpy.pointer.1: same object violation in (const unsigned char *)(const void *)&x >= (const unsigned char *)(void *)&u + (signed long int)(size_t)4 *)
Definition Goal001 : Prop := Adapters.memcpy_guard_id 1.
(* Actual CBMC property memcpy.pointer_arithmetic.1: pointer relation: dead object in (const unsigned char *)(const void *)&x *)
Definition Goal002 : Prop := Adapters.memcpy_guard_id 2.
(* Actual CBMC property memcpy.pointer_arithmetic.2: pointer relation: dead object in (const unsigned char *)(void *)&u + (signed long int)(size_t)4 *)
Definition Goal003 : Prop := Adapters.memcpy_guard_id 3.
(* Actual CBMC property memcpy.pointer.2: same object violation in (const unsigned char *)(void *)&u >= (const unsigned char *)(const void *)&x + (signed long int)(size_t)4 *)
Definition Goal004 : Prop := Adapters.memcpy_guard_id 4.
(* Actual CBMC property memcpy.pointer_arithmetic.3: pointer relation: dead object in (const unsigned char *)(void *)&u *)
Definition Goal005 : Prop := Adapters.memcpy_guard_id 5.
(* Actual CBMC property memcpy.pointer_arithmetic.4: pointer relation: dead object in (const unsigned char *)(const void *)&x + (signed long int)(size_t)4 *)
Definition Goal006 : Prop := Adapters.memcpy_guard_id 6.
(* Actual CBMC property bits.precondition_instance.1: memcpy src/dst overlap *)
Definition Goal007 : Prop := Adapters.bits_guard_id 1.
(* Actual CBMC property bits.precondition_instance.2: memcpy source region readable *)
Definition Goal008 : Prop := Adapters.bits_guard_id 2.
(* Actual CBMC property bits.precondition_instance.3: memcpy destination region writeable *)
Definition Goal009 : Prop := Adapters.bits_guard_id 3.
(* Actual CBMC property five_sqrtf.overflow.1: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal010 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 1.
(* Actual CBMC property five_sqrtf.overflow.2: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal011 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 2.
(* Actual CBMC property five_sqrtf.overflow.3: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal012 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 3.
(* Actual CBMC property five_sqrtf.overflow.4: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal013 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 4.
(* Actual CBMC property five_sqrtf.overflow.5: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal014 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 5.
(* Actual CBMC property five_sqrtf.overflow.6: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal015 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 6.
(* Actual CBMC property five_sqrtf.overflow.7: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal016 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 7.
(* Actual CBMC property five_sqrtf.overflow.8: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal017 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 8.
(* Actual CBMC property five_sqrtf.overflow.9: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal018 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 9.
(* Actual CBMC property five_sqrtf.overflow.10: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal019 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 10.
(* Actual CBMC property five_sqrtf.overflow.11: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal020 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 11.
(* Actual CBMC property five_sqrtf.overflow.12: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal021 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 12.
(* Actual CBMC property five_sqrtf.overflow.13: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal022 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 13.
(* Actual CBMC property five_sqrtf.overflow.14: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal023 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 14.
(* Actual CBMC property five_sqrtf.overflow.15: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal024 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 15.
(* Actual CBMC property five_sqrtf.overflow.16: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal025 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 16.
(* Actual CBMC property five_sqrtf.overflow.17: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal026 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 17.
(* Actual CBMC property five_sqrtf.overflow.18: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal027 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 18.
(* Actual CBMC property five_sqrtf.overflow.19: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal028 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 19.
(* Actual CBMC property five_sqrtf.overflow.20: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal029 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 20.
(* Actual CBMC property five_sqrtf.overflow.21: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal030 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 21.
(* Actual CBMC property five_sqrtf.overflow.22: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal031 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 22.
(* Actual CBMC property five_sqrtf.overflow.23: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal032 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 23.
(* Actual CBMC property five_sqrtf.overflow.24: arithmetic overflow on unsigned to signed type conversion in (signed int)exponent_bits *)
Definition Goal033 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 24.
(* Actual CBMC property five_sqrtf.overflow.25: arithmetic overflow on signed - in (signed int)exponent_bits - 127 *)
Definition Goal034 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 25.
(* Actual CBMC property five_sqrtf.overflow.26: arithmetic overflow on signed - in exponent - 1 *)
Definition Goal035 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 26.
(* Actual CBMC property five_sqrtf.overflow.27: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 46 & 3ull) *)
Definition Goal036 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 27.
(* Actual CBMC property five_sqrtf.overflow.28: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 44 & 3ull) *)
Definition Goal037 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 28.
(* Actual CBMC property five_sqrtf.overflow.29: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 42 & 3ull) *)
Definition Goal038 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 29.
(* Actual CBMC property five_sqrtf.overflow.30: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 40 & 3ull) *)
Definition Goal039 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 30.
(* Actual CBMC property five_sqrtf.overflow.31: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 38 & 3ull) *)
Definition Goal040 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 31.
(* Actual CBMC property five_sqrtf.overflow.32: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 36 & 3ull) *)
Definition Goal041 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 32.
(* Actual CBMC property five_sqrtf.overflow.33: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 34 & 3ull) *)
Definition Goal042 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 33.
(* Actual CBMC property five_sqrtf.overflow.34: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 32 & 3ull) *)
Definition Goal043 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 34.
(* Actual CBMC property five_sqrtf.overflow.35: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 30 & 3ull) *)
Definition Goal044 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 35.
(* Actual CBMC property five_sqrtf.overflow.36: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 28 & 3ull) *)
Definition Goal045 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 36.
(* Actual CBMC property five_sqrtf.overflow.37: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 26 & 3ull) *)
Definition Goal046 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 37.
(* Actual CBMC property five_sqrtf.overflow.38: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 24 & 3ull) *)
Definition Goal047 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 38.
(* Actual CBMC property five_sqrtf.overflow.39: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 22 & 3ull) *)
Definition Goal048 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 39.
(* Actual CBMC property five_sqrtf.overflow.40: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 20 & 3ull) *)
Definition Goal049 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 40.
(* Actual CBMC property five_sqrtf.overflow.41: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 18 & 3ull) *)
Definition Goal050 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 41.
(* Actual CBMC property five_sqrtf.overflow.42: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 16 & 3ull) *)
Definition Goal051 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 42.
(* Actual CBMC property five_sqrtf.overflow.43: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 14 & 3ull) *)
Definition Goal052 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 43.
(* Actual CBMC property five_sqrtf.overflow.44: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 12 & 3ull) *)
Definition Goal053 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 44.
(* Actual CBMC property five_sqrtf.overflow.45: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 10 & 3ull) *)
Definition Goal054 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 45.
(* Actual CBMC property five_sqrtf.overflow.46: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 8 & 3ull) *)
Definition Goal055 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 46.
(* Actual CBMC property five_sqrtf.overflow.47: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 6 & 3ull) *)
Definition Goal056 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 47.
(* Actual CBMC property five_sqrtf.overflow.48: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 4 & 3ull) *)
Definition Goal057 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 48.
(* Actual CBMC property five_sqrtf.overflow.49: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 2 & 3ull) *)
Definition Goal058 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 49.
(* Actual CBMC property five_sqrtf.overflow.50: arithmetic overflow on unsigned to unsigned type conversion in (uint32_t)(radicand >> 0 & 3ull) *)
Definition Goal059 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 50.
(* Actual CBMC property five_sqrtf.overflow.51: arithmetic overflow on signed + in exponent / 2 + 127 *)
Definition Goal060 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 51.
(* Actual CBMC property five_sqrtf.overflow.52: arithmetic overflow on signed + in result_exponent + 1 *)
Definition Goal061 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 52.
(* Actual CBMC property five_sqrtf.overflow.53: arithmetic overflow on signed to unsigned type conversion in (uint32_t)result_exponent *)
Definition Goal062 : Prop := CanonicalCallScope.SpeedCallScope /\ GuardTrace.helper_guard_sites = GuardSiteMap.expected_helper_sites /\ GuardExecution.SpeedExecutedHelperGuard 53.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.1: dereference failure: pointer NULL in accel_sp->x *)
Definition Goal063 : Prop := Adapters.saturation_pointer_guard_id 1.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.2: dereference failure: pointer invalid in accel_sp->x *)
Definition Goal064 : Prop := Adapters.saturation_pointer_guard_id 2.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.3: dereference failure: deallocated dynamic object in accel_sp->x *)
Definition Goal065 : Prop := Adapters.saturation_pointer_guard_id 3.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.4: dereference failure: dead object in accel_sp->x *)
Definition Goal066 : Prop := Adapters.saturation_pointer_guard_id 4.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.5: dereference failure: pointer outside object bounds in accel_sp->x *)
Definition Goal067 : Prop := Adapters.saturation_pointer_guard_id 5.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.6: dereference failure: invalid integer address in accel_sp->x *)
Definition Goal068 : Prop := Adapters.saturation_pointer_guard_id 6.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.7: dereference failure: pointer NULL in accel_sp->y *)
Definition Goal069 : Prop := Adapters.saturation_pointer_guard_id 7.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.8: dereference failure: pointer invalid in accel_sp->y *)
Definition Goal070 : Prop := Adapters.saturation_pointer_guard_id 8.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.9: dereference failure: deallocated dynamic object in accel_sp->y *)
Definition Goal071 : Prop := Adapters.saturation_pointer_guard_id 9.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.10: dereference failure: dead object in accel_sp->y *)
Definition Goal072 : Prop := Adapters.saturation_pointer_guard_id 10.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.11: dereference failure: pointer outside object bounds in accel_sp->y *)
Definition Goal073 : Prop := Adapters.saturation_pointer_guard_id 11.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.12: dereference failure: invalid integer address in accel_sp->y *)
Definition Goal074 : Prop := Adapters.saturation_pointer_guard_id 12.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.13: dereference failure: pointer NULL in accel_sp->x *)
Definition Goal075 : Prop := Adapters.saturation_pointer_guard_id 13.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.14: dereference failure: pointer invalid in accel_sp->x *)
Definition Goal076 : Prop := Adapters.saturation_pointer_guard_id 14.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.15: dereference failure: deallocated dynamic object in accel_sp->x *)
Definition Goal077 : Prop := Adapters.saturation_pointer_guard_id 15.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.16: dereference failure: dead object in accel_sp->x *)
Definition Goal078 : Prop := Adapters.saturation_pointer_guard_id 16.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.17: dereference failure: pointer outside object bounds in accel_sp->x *)
Definition Goal079 : Prop := Adapters.saturation_pointer_guard_id 17.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.18: dereference failure: invalid integer address in accel_sp->x *)
Definition Goal080 : Prop := Adapters.saturation_pointer_guard_id 18.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.19: dereference failure: pointer NULL in accel_sp->y *)
Definition Goal081 : Prop := Adapters.saturation_pointer_guard_id 19.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.20: dereference failure: pointer invalid in accel_sp->y *)
Definition Goal082 : Prop := Adapters.saturation_pointer_guard_id 20.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.21: dereference failure: deallocated dynamic object in accel_sp->y *)
Definition Goal083 : Prop := Adapters.saturation_pointer_guard_id 21.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.22: dereference failure: dead object in accel_sp->y *)
Definition Goal084 : Prop := Adapters.saturation_pointer_guard_id 22.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.23: dereference failure: pointer outside object bounds in accel_sp->y *)
Definition Goal085 : Prop := Adapters.saturation_pointer_guard_id 23.
(* Actual CBMC property gh_saturate_accel.pointer_dereference.24: dereference failure: invalid integer address in accel_sp->y *)
Definition Goal086 : Prop := Adapters.saturation_pointer_guard_id 24.
(* Actual CBMC property gh_update_ref_from_speed_sp.overflow.1: arithmetic overflow on float to signed integer type conversion in (int64_t)(pos_step.x * (float)(1ll << 37)) *)
Definition Goal087 : Prop := Adapters.entry_guard_id 1.
(* Actual CBMC property gh_update_ref_from_speed_sp.overflow.2: arithmetic overflow on float to signed integer type conversion in (int64_t)(pos_step.y * (float)(1ll << 37)) *)
Definition Goal088 : Prop := Adapters.entry_guard_id 2.
(* Actual CBMC property gh_update_ref_from_speed_sp.overflow.3: arithmetic overflow on signed + in gh_ref.pos.x + pos_update.x *)
Definition Goal089 : Prop := Adapters.entry_guard_id 3.
(* Actual CBMC property gh_update_ref_from_speed_sp.overflow.4: arithmetic overflow on signed + in gh_ref.pos.y + pos_update.y *)
Definition Goal090 : Prop := Adapters.entry_guard_id 4.
(* Actual CBMC property main.overflow.1: arithmetic overflow on float to signed integer type conversion in (int64_t)scaled_x *)
Definition Goal091 : Prop := Adapters.main_guard_id 1.
(* Actual CBMC property main.overflow.2: arithmetic overflow on signed - in 9223372036854775807l - delta_x *)
Definition Goal092 : Prop := Adapters.main_guard_id 2.
(* Actual CBMC property main.overflow.3: arithmetic overflow on signed - in (-9223372036854775807l - (signed long int)1) - delta_x *)
Definition Goal093 : Prop := Adapters.main_guard_id 3.
(* Actual CBMC property main.overflow.4: arithmetic overflow on float to signed integer type conversion in (int64_t)scaled_y *)
Definition Goal094 : Prop := Adapters.main_guard_id 4.
(* Actual CBMC property main.overflow.5: arithmetic overflow on signed - in 9223372036854775807l - delta_y *)
Definition Goal095 : Prop := Adapters.main_guard_id 5.
(* Actual CBMC property main.overflow.6: arithmetic overflow on signed - in (-9223372036854775807l - (signed long int)1) - delta_y *)
Definition Goal096 : Prop := Adapters.main_guard_id 6.
(* Actual CBMC property main.overflow.7: arithmetic overflow on signed + in old.pos.x + delta_x *)
Definition Goal097 : Prop := Adapters.main_guard_id 7.
(* Actual CBMC property main.assertion.1: position x integration [unsaturated] *)
Definition Goal098 : Prop := Adapters.manual_speed_id 1.
(* Actual CBMC property main.assertion.2: speed x source order bits [unsaturated] *)
Definition Goal099 : Prop := Adapters.manual_speed_id 2.
(* Actual CBMC property main.assertion.3: acceleration x saturation bits [unsaturated] *)
Definition Goal100 : Prop := Adapters.manual_speed_id 3.
(* Actual CBMC property main.overflow.8: arithmetic overflow on signed + in old.pos.y + delta_y *)
Definition Goal101 : Prop := Adapters.main_guard_id 8.
(* Actual CBMC property main.assertion.4: position y integration [unsaturated] *)
Definition Goal102 : Prop := Adapters.manual_speed_id 4.
(* Actual CBMC property main.assertion.5: speed y source order bits [unsaturated] *)
Definition Goal103 : Prop := Adapters.manual_speed_id 5.
(* Actual CBMC property main.assertion.6: acceleration y saturation bits [unsaturated] *)
Definition Goal104 : Prop := Adapters.manual_speed_id 6.
(* Actual CBMC property main.assertion.7: all eight parameter fields bit frame [unsaturated] *)
Definition Goal105 : Prop := Adapters.manual_speed_id 7.
(* Actual CBMC property main.overflow.9: arithmetic overflow on float to signed integer type conversion in (int64_t)scaled_x *)
Definition Goal106 : Prop := Adapters.main_guard_id 9.
(* Actual CBMC property main.overflow.10: arithmetic overflow on signed - in 9223372036854775807l - delta_x *)
Definition Goal107 : Prop := Adapters.main_guard_id 10.
(* Actual CBMC property main.overflow.11: arithmetic overflow on signed - in (-9223372036854775807l - (signed long int)1) - delta_x *)
Definition Goal108 : Prop := Adapters.main_guard_id 11.
(* Actual CBMC property main.overflow.12: arithmetic overflow on float to signed integer type conversion in (int64_t)scaled_y *)
Definition Goal109 : Prop := Adapters.main_guard_id 12.
(* Actual CBMC property main.overflow.13: arithmetic overflow on signed - in 9223372036854775807l - delta_y *)
Definition Goal110 : Prop := Adapters.main_guard_id 13.
(* Actual CBMC property main.overflow.14: arithmetic overflow on signed - in (-9223372036854775807l - (signed long int)1) - delta_y *)
Definition Goal111 : Prop := Adapters.main_guard_id 14.
(* Actual CBMC property main.overflow.15: arithmetic overflow on signed + in old.pos.x + delta_x *)
Definition Goal112 : Prop := Adapters.main_guard_id 15.
(* Actual CBMC property main.assertion.8: position x integration [saturated] *)
Definition Goal113 : Prop := Adapters.manual_speed_id 8.
(* Actual CBMC property main.assertion.9: speed x source order bits [saturated] *)
Definition Goal114 : Prop := Adapters.manual_speed_id 9.
(* Actual CBMC property main.assertion.10: acceleration x saturation bits [saturated] *)
Definition Goal115 : Prop := Adapters.manual_speed_id 10.
(* Actual CBMC property main.overflow.16: arithmetic overflow on signed + in old.pos.y + delta_y *)
Definition Goal116 : Prop := Adapters.main_guard_id 16.
(* Actual CBMC property main.assertion.11: position y integration [saturated] *)
Definition Goal117 : Prop := Adapters.manual_speed_id 11.
(* Actual CBMC property main.assertion.12: speed y source order bits [saturated] *)
Definition Goal118 : Prop := Adapters.manual_speed_id 12.
(* Actual CBMC property main.assertion.13: acceleration y saturation bits [saturated] *)
Definition Goal119 : Prop := Adapters.manual_speed_id 13.
(* Actual CBMC property main.assertion.14: all eight parameter fields bit frame [saturated] *)
Definition Goal120 : Prop := Adapters.manual_speed_id 14.
(* Actual CBMC property memcpy.overflow.1: arithmetic overflow on unsigned to signed type conversion in (signed long int)n *)
Definition Goal121 : Prop := Adapters.memcpy_guard_id 7.
(* Actual CBMC property memcpy.overflow.2: arithmetic overflow on signed to unsigned type conversion in (unsigned long int)(signed long int)n *)
Definition Goal122 : Prop := Adapters.memcpy_guard_id 8.
