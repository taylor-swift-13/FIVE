From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveLowpassUpdate Require Import Source Execution.
From FiveLowpassUpdateCase Require Import Contract UpdateCall.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Import ListNotations.
Local Open Scope Z_scope.
Definition NoError:Prop:=forall args m,Precondition args m->no_error Execution.ge(Execution.entry args m).
