From Stdlib Require Import List ZArith.
From compcert Require Import Errors Maps AST Ctypes Csem.
Require FiveGhSetOmega.Source FiveGhSetOmega.Execution FiveGhSetZeta.Source FiveGhSetZeta.Execution.
Definition members_of (ge:Csem.genv)(sid:ident) := match PTree.get sid (genv_cenv ge) with Some co=>co_members co |None=>nil end.
Theorem omega_layout : sizeof FiveGhSetOmega.Execution.ge (Tstruct FiveGhSetOmega.Source._GuidanceHRef noattr)=64%Z /\
alignof FiveGhSetOmega.Execution.ge (Tstruct FiveGhSetOmega.Source._GuidanceHRef noattr)=8%Z /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._accel (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(0%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._speed (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(8%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._pos (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(16%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._tau (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(32%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._omega (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(36%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._zeta (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(40%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._max_speed (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(44%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._zeta_omega (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(48%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._omega_2 (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(52%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._inv_tau (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(56%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._dt (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._GuidanceHRef)=OK(60%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._x (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._FloatVect2)=OK(0%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._y (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._FloatVect2)=OK(4%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._x (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._Int64Vect2)=OK(0%Z,Full) /\
field_offset FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._y (members_of FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._Int64Vect2)=OK(8%Z,Full).
Proof. repeat split;reflexivity. Qed.
Print Assumptions omega_layout.
Theorem zeta_layout : sizeof FiveGhSetZeta.Execution.ge (Tstruct FiveGhSetZeta.Source._GuidanceHRef noattr)=64%Z /\
alignof FiveGhSetZeta.Execution.ge (Tstruct FiveGhSetZeta.Source._GuidanceHRef noattr)=8%Z /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._accel (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(0%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._speed (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(8%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._pos (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(16%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._tau (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(32%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._omega (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(36%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._zeta (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(40%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._max_speed (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(44%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._zeta_omega (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(48%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._omega_2 (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(52%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._inv_tau (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(56%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._dt (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._GuidanceHRef)=OK(60%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._x (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._FloatVect2)=OK(0%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._y (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._FloatVect2)=OK(4%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._x (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._Int64Vect2)=OK(0%Z,Full) /\
field_offset FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._y (members_of FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._Int64Vect2)=OK(8%Z,Full).
Proof. repeat split;reflexivity. Qed.
Print Assumptions zeta_layout.
