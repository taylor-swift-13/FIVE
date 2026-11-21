From compcert Require Import Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
Eval vm_compute in (Genv.find_symbol Execution.ge Source._guidance_pid).
Eval vm_compute in (Genv.find_symbol Execution.ge Source._state).
Eval vm_compute in (Genv.find_symbol Execution.ge Source._traj_max_bank).
Eval vm_compute in (Genv.find_symbol Execution.ge Source._total_max_bank).
Eval vm_compute in (sizeof ce gh_type, sizeof ce state_type, sizeof ce sp_type).
