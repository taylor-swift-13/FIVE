From compcert Require Import Values Memory.
From FiveShared.verification Require Import Obligations.
From FivePprzFloatMatInv3d Require Import Execution.
Definition Termination:Prop:=forall args m,Acc(successor Execution.ge)(Execution.entry args m).
