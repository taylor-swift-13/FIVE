From Stdlib Require Import List ZArith.
From compcert Require Import AST Values Memory Events Ctypes Csyntax Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGhAccel Require Import Source Execution.
From FiveGuidanceSemantics Require Import SourceClosure AccelSource.
Import ListNotations.
Definition source_state := SourceClosure.source_state AccelSource.ge AccelSource.allowed AccelSource.budget.
Definition closed_step := AccelSource.closed_step.
Definition Goal:Prop := forall args m,Acc(successor Execution.ge)(Execution.entry args m).
