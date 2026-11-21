From compcert Require Import Values Memory Csem.
From FiveShared.verification Require Import Obligations.
From StateSpeedSetEcefI Require Import Execution.
Definition AllSuccessorsTerminate:Prop:=forall args m,Acc(successor Execution.ge)(Execution.entry args m).
