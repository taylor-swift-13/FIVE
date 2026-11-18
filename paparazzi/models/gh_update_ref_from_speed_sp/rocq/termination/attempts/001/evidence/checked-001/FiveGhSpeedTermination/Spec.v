From Stdlib Require Import List ZArith.
From compcert Require Import AST Values Memory Events Ctypes Csyntax Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGhSpeed Require Import Source Execution.
From FiveGuidanceSemantics Require Import SourceClosure SpeedSource.
Import ListNotations.
Definition source_state := SourceClosure.source_state SpeedSource.ge SpeedSource.allowed SpeedSource.budget.
Definition closed_step := SpeedSource.closed_step.
Definition Goal:Prop := forall args m,Acc(successor Execution.ge)(Execution.entry args m).
