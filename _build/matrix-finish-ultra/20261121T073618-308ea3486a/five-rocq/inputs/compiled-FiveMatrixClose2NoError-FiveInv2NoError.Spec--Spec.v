From compcert Require Import Values Memory Csem.
From FiveShared.verification Require Import Obligations.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract.
Definition NoError:Prop:=forall args m,Precondition args m->no_error Execution.ge(Execution.entry args m).
