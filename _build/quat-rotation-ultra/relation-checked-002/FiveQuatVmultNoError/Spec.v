From Stdlib Require Import List.
From compcert Require Import Values Memory.
From FiveShared.verification Require Import Obligations.
From FiveQuatVmult Require Import Execution.
From FiveQuatVmultCase Require Import Contract.
Definition NoError : Prop := forall args m,Contract.Precondition args m->no_error Execution.ge(Execution.entry args m).
