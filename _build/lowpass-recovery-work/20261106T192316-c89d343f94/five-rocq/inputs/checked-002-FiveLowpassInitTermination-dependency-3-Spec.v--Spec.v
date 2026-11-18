From compcert Require Import Values Memory.
From FiveShared.verification Require Import Obligations.
From FiveLowpassInit Require Import Execution.
Definition AllSuccessorsTerminate : Prop := forall args m,Acc(successor Execution.ge)(Execution.entry args m).
