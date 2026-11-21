From compcert Require Import Values Memory.
From FiveShared.verification Require Import Obligations.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract.
Definition NoError:Prop:=forall args m,FunctionalPre args m->no_error Execution.ge(Execution.entry args m).
