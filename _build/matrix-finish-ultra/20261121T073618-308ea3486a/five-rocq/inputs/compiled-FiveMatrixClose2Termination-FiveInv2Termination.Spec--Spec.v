From Stdlib Require Import List.
From compcert Require Import Values Memory Csem.
From FiveShared.verification Require Import Obligations.
From FivePprzFloatMatInv2d Require Import Source Execution.
Definition AllSuccessorsTerminate:Prop := forall args m,Acc(successor Execution.ge)(Execution.entry args m).
