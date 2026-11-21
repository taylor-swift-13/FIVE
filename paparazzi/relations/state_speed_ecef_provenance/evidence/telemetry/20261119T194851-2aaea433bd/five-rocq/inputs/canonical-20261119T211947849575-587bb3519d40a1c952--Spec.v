From Stdlib Require Import List ZArith.
From compcert Require Import Integers Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From StateSpeedGetterSupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
Definition OriginalResultGoal:Prop:=forall m sb x y z,InputGood m sb x y z->exists mf,NormalCall m mf sb /\ GetterResult m mf sb x y z /\ (forall t v mf2,star Csem.step ge(E.entry[]m)t(Returnstate v Kstop mf2)->v=Vptr sb(Ptrofs.repr 328) /\mf2=mf).
