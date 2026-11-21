From FiveShared.verification Require Import Obligations.
From StateSpeedSetNedISupport Require Import Setup.
Definition NoErrorGoal:Prop:=forall m sb src id x y z,
 InputGood m sb src id x y z ->Obligations.no_error ge(E.entry(Args id src)m).
Definition NormalResultGoal:Prop:=forall m sb src id x y z,
 InputGood m sb src id x y z ->exists mf,
 NormalCall id src m mf /\SetterResult m mf sb src x y z /\
 (forall mf',NormalCall id src m mf' ->mf'=mf).
