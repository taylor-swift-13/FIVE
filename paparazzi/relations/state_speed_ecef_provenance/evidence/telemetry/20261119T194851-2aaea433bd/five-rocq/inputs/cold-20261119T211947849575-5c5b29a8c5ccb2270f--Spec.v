From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From StateSpeedGetterSupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
Definition NoErrorGoal:Prop:=forall m sb x y z,InputGood m sb x y z->no_error ge(E.entry[]m).
