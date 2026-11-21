From Stdlib Require Import List ZArith.
From compcert Require Import Integers Values Memory Memdata Events Globalenvs Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From StateSpeedGetterSupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
Definition HitWord(q:int):Prop:=Int.and(Int.shr q(Int.repr 5))Int.one=Int.one.
Definition HitInput(m:mem)(sb:block):Prop:=
 Genv.find_symbol ge S._state=Some sb /\exists q,Mem.load Mint16unsigned m sb 280=Some(Vint q) /\HitWord q.
Definition SafetyGoal:Prop:=forall m sb,HitInput m sb->no_error ge(E.entry[]m).
Definition TerminationGoal:Prop:=forall m sb,HitInput m sb->Acc(successor ge)(E.entry[]m).
Definition ExactReturnGoal:Prop:=forall m sb,HitInput m sb->NormalCall m m sb /\
 (forall t v mf,star Csem.step ge(E.entry[]m)t(Returnstate v Kstop mf)->v=Vptr sb(Ptrofs.repr 328) /\mf=m).
Definition ByteFrameGoal:Prop:=forall m sb,HitInput m sb->forall t v mf,
 star Csem.step ge(E.entry[]m)t(Returnstate v Kstop mf)->
 (forall b ofs n,Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n) /\HitInput mf sb.
