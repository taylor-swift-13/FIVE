
From compcert Require Import Integers Memory Globalenvs Ctypes Csyntax.
From StateSpeedGetEcefF Require Import Source.
From StateSpeedMemory Require Import InitialMemory.
Definition ActualProgramInitializes:exists m,Genv.init_mem Source.prog=Some m:=actual_init_mem_exists.
Definition EverySixWordsHaveReadyMemory:
 forall(nx ny nz ex ey ez:int),exists m sb nsrc esrc,
 InitialReady m sb nsrc esrc nx ny nz ex ey ez:=initial_ready_exists.
Print Assumptions ActualProgramInitializes.
Print Assumptions EverySixWordsHaveReadyMemory.
