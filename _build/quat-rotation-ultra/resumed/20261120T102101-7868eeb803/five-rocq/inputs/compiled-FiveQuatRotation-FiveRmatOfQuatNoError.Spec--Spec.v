From Stdlib Require Import List.
From compcert Require Import Values Memory Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Contract.
Definition NoError:Prop:=forall args m,Precondition args m->no_error Execution.ge(Execution.entry args m).
