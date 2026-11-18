From Stdlib Require Import Lia ZArith.
From compcert Require Import Ctypes Csyntax Csyntaxdefs.
From FiveGuidanceSoftwareProof Require Import ValueSound SourceCertificate GuardTrace GuardMemorySound GuardExecution GuardSiteMap.
Definition actual_sites_target:helper_guard_sites=expected_helper_sites:=actual_helper_guard_site_map.
Definition helper_execution_target:forall ge,
 union_layout FiveGhSpeed.Source._FiveSqrtBits FiveGhSpeed.Source._f FiveGhSpeed.Source._u ge->
 sizeof ge(Tunion FiveGhSpeed.Source._FiveSqrtBits noattr)=4%Z->
 forall m x,helper_instrumented_call ge m x:=helper_instrumented_funcall.
Definition speed_guard_001:SpeedExecutedHelperGuard 1:=speed_executed_helper_guard 1 ltac:(lia).
Definition speed_guard_002:SpeedExecutedHelperGuard 2:=speed_executed_helper_guard 2 ltac:(lia).
Definition speed_guard_003:SpeedExecutedHelperGuard 3:=speed_executed_helper_guard 3 ltac:(lia).
Definition speed_guard_004:SpeedExecutedHelperGuard 4:=speed_executed_helper_guard 4 ltac:(lia).
Definition speed_guard_005:SpeedExecutedHelperGuard 5:=speed_executed_helper_guard 5 ltac:(lia).
Definition speed_guard_006:SpeedExecutedHelperGuard 6:=speed_executed_helper_guard 6 ltac:(lia).
Definition speed_guard_007:SpeedExecutedHelperGuard 7:=speed_executed_helper_guard 7 ltac:(lia).
Definition speed_guard_008:SpeedExecutedHelperGuard 8:=speed_executed_helper_guard 8 ltac:(lia).
Definition speed_guard_009:SpeedExecutedHelperGuard 9:=speed_executed_helper_guard 9 ltac:(lia).
Definition speed_guard_010:SpeedExecutedHelperGuard 10:=speed_executed_helper_guard 10 ltac:(lia).
Definition speed_guard_011:SpeedExecutedHelperGuard 11:=speed_executed_helper_guard 11 ltac:(lia).
Definition speed_guard_012:SpeedExecutedHelperGuard 12:=speed_executed_helper_guard 12 ltac:(lia).
Definition speed_guard_013:SpeedExecutedHelperGuard 13:=speed_executed_helper_guard 13 ltac:(lia).
Definition speed_guard_014:SpeedExecutedHelperGuard 14:=speed_executed_helper_guard 14 ltac:(lia).
Definition speed_guard_015:SpeedExecutedHelperGuard 15:=speed_executed_helper_guard 15 ltac:(lia).
Definition speed_guard_016:SpeedExecutedHelperGuard 16:=speed_executed_helper_guard 16 ltac:(lia).
Definition speed_guard_017:SpeedExecutedHelperGuard 17:=speed_executed_helper_guard 17 ltac:(lia).
Definition speed_guard_018:SpeedExecutedHelperGuard 18:=speed_executed_helper_guard 18 ltac:(lia).
Definition speed_guard_019:SpeedExecutedHelperGuard 19:=speed_executed_helper_guard 19 ltac:(lia).
Definition speed_guard_020:SpeedExecutedHelperGuard 20:=speed_executed_helper_guard 20 ltac:(lia).
Definition speed_guard_021:SpeedExecutedHelperGuard 21:=speed_executed_helper_guard 21 ltac:(lia).
Definition speed_guard_022:SpeedExecutedHelperGuard 22:=speed_executed_helper_guard 22 ltac:(lia).
Definition speed_guard_023:SpeedExecutedHelperGuard 23:=speed_executed_helper_guard 23 ltac:(lia).
Definition speed_guard_024:SpeedExecutedHelperGuard 24:=speed_executed_helper_guard 24 ltac:(lia).
Definition speed_guard_025:SpeedExecutedHelperGuard 25:=speed_executed_helper_guard 25 ltac:(lia).
Definition speed_guard_026:SpeedExecutedHelperGuard 26:=speed_executed_helper_guard 26 ltac:(lia).
Definition speed_guard_027:SpeedExecutedHelperGuard 27:=speed_executed_helper_guard 27 ltac:(lia).
Definition speed_guard_028:SpeedExecutedHelperGuard 28:=speed_executed_helper_guard 28 ltac:(lia).
Definition speed_guard_029:SpeedExecutedHelperGuard 29:=speed_executed_helper_guard 29 ltac:(lia).
Definition speed_guard_030:SpeedExecutedHelperGuard 30:=speed_executed_helper_guard 30 ltac:(lia).
Definition speed_guard_031:SpeedExecutedHelperGuard 31:=speed_executed_helper_guard 31 ltac:(lia).
Definition speed_guard_032:SpeedExecutedHelperGuard 32:=speed_executed_helper_guard 32 ltac:(lia).
Definition speed_guard_033:SpeedExecutedHelperGuard 33:=speed_executed_helper_guard 33 ltac:(lia).
Definition speed_guard_034:SpeedExecutedHelperGuard 34:=speed_executed_helper_guard 34 ltac:(lia).
Definition speed_guard_035:SpeedExecutedHelperGuard 35:=speed_executed_helper_guard 35 ltac:(lia).
Definition speed_guard_036:SpeedExecutedHelperGuard 36:=speed_executed_helper_guard 36 ltac:(lia).
Definition speed_guard_037:SpeedExecutedHelperGuard 37:=speed_executed_helper_guard 37 ltac:(lia).
Definition speed_guard_038:SpeedExecutedHelperGuard 38:=speed_executed_helper_guard 38 ltac:(lia).
Definition speed_guard_039:SpeedExecutedHelperGuard 39:=speed_executed_helper_guard 39 ltac:(lia).
Definition speed_guard_040:SpeedExecutedHelperGuard 40:=speed_executed_helper_guard 40 ltac:(lia).
Definition speed_guard_041:SpeedExecutedHelperGuard 41:=speed_executed_helper_guard 41 ltac:(lia).
Definition speed_guard_042:SpeedExecutedHelperGuard 42:=speed_executed_helper_guard 42 ltac:(lia).
Definition speed_guard_043:SpeedExecutedHelperGuard 43:=speed_executed_helper_guard 43 ltac:(lia).
Definition speed_guard_044:SpeedExecutedHelperGuard 44:=speed_executed_helper_guard 44 ltac:(lia).
Definition speed_guard_045:SpeedExecutedHelperGuard 45:=speed_executed_helper_guard 45 ltac:(lia).
Definition speed_guard_046:SpeedExecutedHelperGuard 46:=speed_executed_helper_guard 46 ltac:(lia).
Definition speed_guard_047:SpeedExecutedHelperGuard 47:=speed_executed_helper_guard 47 ltac:(lia).
Definition speed_guard_048:SpeedExecutedHelperGuard 48:=speed_executed_helper_guard 48 ltac:(lia).
Definition speed_guard_049:SpeedExecutedHelperGuard 49:=speed_executed_helper_guard 49 ltac:(lia).
Definition speed_guard_050:SpeedExecutedHelperGuard 50:=speed_executed_helper_guard 50 ltac:(lia).
Definition speed_guard_051:SpeedExecutedHelperGuard 51:=speed_executed_helper_guard 51 ltac:(lia).
Definition speed_guard_052:SpeedExecutedHelperGuard 52:=speed_executed_helper_guard 52 ltac:(lia).
Definition speed_guard_053:SpeedExecutedHelperGuard 53:=speed_executed_helper_guard 53 ltac:(lia).
Definition accel_guard_001:AccelExecutedHelperGuard 1:=accel_executed_helper_guard 1 ltac:(lia).
Definition accel_guard_002:AccelExecutedHelperGuard 2:=accel_executed_helper_guard 2 ltac:(lia).
Definition accel_guard_003:AccelExecutedHelperGuard 3:=accel_executed_helper_guard 3 ltac:(lia).
Definition accel_guard_004:AccelExecutedHelperGuard 4:=accel_executed_helper_guard 4 ltac:(lia).
Definition accel_guard_005:AccelExecutedHelperGuard 5:=accel_executed_helper_guard 5 ltac:(lia).
Definition accel_guard_006:AccelExecutedHelperGuard 6:=accel_executed_helper_guard 6 ltac:(lia).
Definition accel_guard_007:AccelExecutedHelperGuard 7:=accel_executed_helper_guard 7 ltac:(lia).
Definition accel_guard_008:AccelExecutedHelperGuard 8:=accel_executed_helper_guard 8 ltac:(lia).
Definition accel_guard_009:AccelExecutedHelperGuard 9:=accel_executed_helper_guard 9 ltac:(lia).
Definition accel_guard_010:AccelExecutedHelperGuard 10:=accel_executed_helper_guard 10 ltac:(lia).
Definition accel_guard_011:AccelExecutedHelperGuard 11:=accel_executed_helper_guard 11 ltac:(lia).
Definition accel_guard_012:AccelExecutedHelperGuard 12:=accel_executed_helper_guard 12 ltac:(lia).
Definition accel_guard_013:AccelExecutedHelperGuard 13:=accel_executed_helper_guard 13 ltac:(lia).
Definition accel_guard_014:AccelExecutedHelperGuard 14:=accel_executed_helper_guard 14 ltac:(lia).
Definition accel_guard_015:AccelExecutedHelperGuard 15:=accel_executed_helper_guard 15 ltac:(lia).
Definition accel_guard_016:AccelExecutedHelperGuard 16:=accel_executed_helper_guard 16 ltac:(lia).
Definition accel_guard_017:AccelExecutedHelperGuard 17:=accel_executed_helper_guard 17 ltac:(lia).
Definition accel_guard_018:AccelExecutedHelperGuard 18:=accel_executed_helper_guard 18 ltac:(lia).
Definition accel_guard_019:AccelExecutedHelperGuard 19:=accel_executed_helper_guard 19 ltac:(lia).
Definition accel_guard_020:AccelExecutedHelperGuard 20:=accel_executed_helper_guard 20 ltac:(lia).
Definition accel_guard_021:AccelExecutedHelperGuard 21:=accel_executed_helper_guard 21 ltac:(lia).
Definition accel_guard_022:AccelExecutedHelperGuard 22:=accel_executed_helper_guard 22 ltac:(lia).
Definition accel_guard_023:AccelExecutedHelperGuard 23:=accel_executed_helper_guard 23 ltac:(lia).
Definition accel_guard_024:AccelExecutedHelperGuard 24:=accel_executed_helper_guard 24 ltac:(lia).
Definition accel_guard_025:AccelExecutedHelperGuard 25:=accel_executed_helper_guard 25 ltac:(lia).
Definition accel_guard_026:AccelExecutedHelperGuard 26:=accel_executed_helper_guard 26 ltac:(lia).
Definition accel_guard_027:AccelExecutedHelperGuard 27:=accel_executed_helper_guard 27 ltac:(lia).
Definition accel_guard_028:AccelExecutedHelperGuard 28:=accel_executed_helper_guard 28 ltac:(lia).
Definition accel_guard_029:AccelExecutedHelperGuard 29:=accel_executed_helper_guard 29 ltac:(lia).
Definition accel_guard_030:AccelExecutedHelperGuard 30:=accel_executed_helper_guard 30 ltac:(lia).
Definition accel_guard_031:AccelExecutedHelperGuard 31:=accel_executed_helper_guard 31 ltac:(lia).
Definition accel_guard_032:AccelExecutedHelperGuard 32:=accel_executed_helper_guard 32 ltac:(lia).
Definition accel_guard_033:AccelExecutedHelperGuard 33:=accel_executed_helper_guard 33 ltac:(lia).
Definition accel_guard_034:AccelExecutedHelperGuard 34:=accel_executed_helper_guard 34 ltac:(lia).
Definition accel_guard_035:AccelExecutedHelperGuard 35:=accel_executed_helper_guard 35 ltac:(lia).
Definition accel_guard_036:AccelExecutedHelperGuard 36:=accel_executed_helper_guard 36 ltac:(lia).
Definition accel_guard_037:AccelExecutedHelperGuard 37:=accel_executed_helper_guard 37 ltac:(lia).
Definition accel_guard_038:AccelExecutedHelperGuard 38:=accel_executed_helper_guard 38 ltac:(lia).
Definition accel_guard_039:AccelExecutedHelperGuard 39:=accel_executed_helper_guard 39 ltac:(lia).
Definition accel_guard_040:AccelExecutedHelperGuard 40:=accel_executed_helper_guard 40 ltac:(lia).
Definition accel_guard_041:AccelExecutedHelperGuard 41:=accel_executed_helper_guard 41 ltac:(lia).
Definition accel_guard_042:AccelExecutedHelperGuard 42:=accel_executed_helper_guard 42 ltac:(lia).
Definition accel_guard_043:AccelExecutedHelperGuard 43:=accel_executed_helper_guard 43 ltac:(lia).
Definition accel_guard_044:AccelExecutedHelperGuard 44:=accel_executed_helper_guard 44 ltac:(lia).
Definition accel_guard_045:AccelExecutedHelperGuard 45:=accel_executed_helper_guard 45 ltac:(lia).
Definition accel_guard_046:AccelExecutedHelperGuard 46:=accel_executed_helper_guard 46 ltac:(lia).
Definition accel_guard_047:AccelExecutedHelperGuard 47:=accel_executed_helper_guard 47 ltac:(lia).
Definition accel_guard_048:AccelExecutedHelperGuard 48:=accel_executed_helper_guard 48 ltac:(lia).
Definition accel_guard_049:AccelExecutedHelperGuard 49:=accel_executed_helper_guard 49 ltac:(lia).
Definition accel_guard_050:AccelExecutedHelperGuard 50:=accel_executed_helper_guard 50 ltac:(lia).
Definition accel_guard_051:AccelExecutedHelperGuard 51:=accel_executed_helper_guard 51 ltac:(lia).
Definition accel_guard_052:AccelExecutedHelperGuard 52:=accel_executed_helper_guard 52 ltac:(lia).
Definition accel_guard_053:AccelExecutedHelperGuard 53:=accel_executed_helper_guard 53 ltac:(lia).
Print Assumptions actual_sites_target.
Print Assumptions helper_execution_target.
Print Assumptions speed_guard_001.
Print Assumptions speed_guard_002.
Print Assumptions speed_guard_003.
Print Assumptions speed_guard_004.
Print Assumptions speed_guard_005.
Print Assumptions speed_guard_006.
Print Assumptions speed_guard_007.
Print Assumptions speed_guard_008.
Print Assumptions speed_guard_009.
Print Assumptions speed_guard_010.
Print Assumptions speed_guard_011.
Print Assumptions speed_guard_012.
Print Assumptions speed_guard_013.
Print Assumptions speed_guard_014.
Print Assumptions speed_guard_015.
Print Assumptions speed_guard_016.
Print Assumptions speed_guard_017.
Print Assumptions speed_guard_018.
Print Assumptions speed_guard_019.
Print Assumptions speed_guard_020.
Print Assumptions speed_guard_021.
Print Assumptions speed_guard_022.
Print Assumptions speed_guard_023.
Print Assumptions speed_guard_024.
Print Assumptions speed_guard_025.
Print Assumptions speed_guard_026.
Print Assumptions speed_guard_027.
Print Assumptions speed_guard_028.
Print Assumptions speed_guard_029.
Print Assumptions speed_guard_030.
Print Assumptions speed_guard_031.
Print Assumptions speed_guard_032.
Print Assumptions speed_guard_033.
Print Assumptions speed_guard_034.
Print Assumptions speed_guard_035.
Print Assumptions speed_guard_036.
Print Assumptions speed_guard_037.
Print Assumptions speed_guard_038.
Print Assumptions speed_guard_039.
Print Assumptions speed_guard_040.
Print Assumptions speed_guard_041.
Print Assumptions speed_guard_042.
Print Assumptions speed_guard_043.
Print Assumptions speed_guard_044.
Print Assumptions speed_guard_045.
Print Assumptions speed_guard_046.
Print Assumptions speed_guard_047.
Print Assumptions speed_guard_048.
Print Assumptions speed_guard_049.
Print Assumptions speed_guard_050.
Print Assumptions speed_guard_051.
Print Assumptions speed_guard_052.
Print Assumptions speed_guard_053.
Print Assumptions accel_guard_001.
Print Assumptions accel_guard_002.
Print Assumptions accel_guard_003.
Print Assumptions accel_guard_004.
Print Assumptions accel_guard_005.
Print Assumptions accel_guard_006.
Print Assumptions accel_guard_007.
Print Assumptions accel_guard_008.
Print Assumptions accel_guard_009.
Print Assumptions accel_guard_010.
Print Assumptions accel_guard_011.
Print Assumptions accel_guard_012.
Print Assumptions accel_guard_013.
Print Assumptions accel_guard_014.
Print Assumptions accel_guard_015.
Print Assumptions accel_guard_016.
Print Assumptions accel_guard_017.
Print Assumptions accel_guard_018.
Print Assumptions accel_guard_019.
Print Assumptions accel_guard_020.
Print Assumptions accel_guard_021.
Print Assumptions accel_guard_022.
Print Assumptions accel_guard_023.
Print Assumptions accel_guard_024.
Print Assumptions accel_guard_025.
Print Assumptions accel_guard_026.
Print Assumptions accel_guard_027.
Print Assumptions accel_guard_028.
Print Assumptions accel_guard_029.
Print Assumptions accel_guard_030.
Print Assumptions accel_guard_031.
Print Assumptions accel_guard_032.
Print Assumptions accel_guard_033.
Print Assumptions accel_guard_034.
Print Assumptions accel_guard_035.
Print Assumptions accel_guard_036.
Print Assumptions accel_guard_037.
Print Assumptions accel_guard_038.
Print Assumptions accel_guard_039.
Print Assumptions accel_guard_040.
Print Assumptions accel_guard_041.
Print Assumptions accel_guard_042.
Print Assumptions accel_guard_043.
Print Assumptions accel_guard_044.
Print Assumptions accel_guard_045.
Print Assumptions accel_guard_046.
Print Assumptions accel_guard_047.
Print Assumptions accel_guard_048.
Print Assumptions accel_guard_049.
Print Assumptions accel_guard_050.
Print Assumptions accel_guard_051.
Print Assumptions accel_guard_052.
Print Assumptions accel_guard_053.
