From Stdlib Require Import List ZArith.
From compcert Require Import Integers AST Values Memory Events Globalenvs Ctypes Csyntax Csem Cexec Smallstep.
From PprzTrigInit Require Import Source.
From PprzTrigInitSupport Require Import PathCertificate.
Import ListNotations.

Definition init_ge := Csem.globalenv Source.prog.
Definition init_entry (m:mem) :=
  Callstate (Internal Source.f_pprz_trig_int_init) [] Kstop m.
Definition init_result (fuel:nat) :=
  match Genv.init_mem Source.prog with
  | Some m => PathCertificate.run init_ge fuel (init_entry m)
  | None => None
  end.
Definition init_ok (fuel:nat) :=
  match init_result fuel with
  | Some (Returnstate (Vint r) Kstop _) => Int.eq r Int.zero
  | _ => false
  end.

Time Eval vm_compute in init_ok 1000.
