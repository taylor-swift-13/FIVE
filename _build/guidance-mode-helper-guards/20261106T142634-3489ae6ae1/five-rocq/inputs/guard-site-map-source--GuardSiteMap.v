From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats Values Ctypes Cop Csyntax Csyntaxdefs.
From FiveGuidanceSoftwareProof Require Import SourceCertificate GuardTrace.
Import ListNotations.
Local Open Scope Z_scope.
Definition local_read(id:positive)(ty:type):expr:=Evalof(Evar id ty)ty.
Definition int_literal(n:Z):expr:=Eval(Vint(Int.repr n))tint.
Definition normalization_guard:=SignedSub(local_read S._exponent tint)(int_literal 1).
Definition restoring_guard(shift:Z):integer_guard:=Unsigned64ToUnsigned32
 (Ebinop Oand(Ebinop Oshr(local_read S._radicand tulong)(int_literal shift)tulong)
 (Eval(Vlong(Int64.repr 3))tulong)tulong).
Definition expected_helper_sites:list integer_guard:=
 repeat normalization_guard 23++
 [Unsigned32ToSigned(local_read S._exponent_bits tuint);
 SignedSub(Ecast(local_read S._exponent_bits tuint)tint)(int_literal 127);
 normalization_guard]++
 map restoring_guard[46;44;42;40;38;36;34;32;30;28;26;24;22;20;18;16;14;12;10;8;6;4;2;0]++
 [SignedAdd(Ebinop Odiv(local_read S._exponent tint)(int_literal 2)tint)(int_literal 127);
 SignedAdd(local_read S._result_exponent tint)(int_literal 1);
 Signed32ToUnsigned(local_read S._result_exponent tint)].
Theorem actual_helper_guard_site_map:helper_guard_sites=expected_helper_sites.
Proof. vm_compute;reflexivity. Qed.
Print Assumptions actual_helper_guard_site_map.
