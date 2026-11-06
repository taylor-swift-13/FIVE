From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Globalenvs Floats Csem Smallstep.
From FiveGhSetOmega Require Import Source Execution.
From FiveGhSetOmegaProof Require Import Public.
From FivePaparazziState Require Import State.
Import ListNotations.
From FiveGhSetOmega.proof Require Import Obligations.
Definition Goal:Prop:=Obligations.no_error_goal caller_precondition.
Definition SatisfiableGoal:Prop:=exists args m,caller_precondition args m.
