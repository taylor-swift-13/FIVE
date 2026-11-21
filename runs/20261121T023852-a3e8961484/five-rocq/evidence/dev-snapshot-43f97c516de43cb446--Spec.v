From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory Memdata Events Globalenvs Csem Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation.
From StateSpeedMemory Require Import Protocol.
From StateSpeedGetterCacheProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module H:=StateSpeedGetterCacheProblem.Spec.
Record Observation:Type:={
 observed_memory:mem;
 observed_return:val;
 observed_bytes:option(list memval);
 observed_bits:option(int*int*int);
 observed_state:option(list memval)
}.
Definition snapshot(m:mem)(sb:block):Observation:={|
 observed_memory:=m;observed_return:=Vptr sb(Ptrofs.repr 328);
 observed_bytes:=Mem.loadbytes m sb 328 12;observed_bits:=observe_bits m sb;
 observed_state:=Mem.loadbytes m sb 0 656|}.
Inductive Reads(sb:block):nat->mem->list Observation->mem->Prop:=
| reads_zero:forall m,Reads sb O m [] m
| reads_next:forall n m next obs final,
 G.NormalCall m next sb->Reads sb n next obs final->
 Reads sb(Nat.S n)m(snapshot next sb::obs)final.
Definition CacheSeries(m:mem)(sb:block)(n:nat):Prop:=
 (exists obs final,Reads sb n m obs final) /\
 forall obs final,Reads sb n m obs final->final=m /\
 Forall(fun o=>o=snapshot m sb)obs /\length obs=n /\H.HitInput final sb /\
 (forall b ofs len,Mem.loadbytes final b ofs len=Mem.loadbytes m b ofs len).
Definition RepeatedHitGoal:Prop:=forall m sb,H.HitInput m sb->forall n,CacheSeries m sb n.
Definition ProtocolGoal:Prop:=forall m sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->exists mn me mf,
 ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez /\
 observe_bits mf sb=Some(bits_of nx ny nz) /\
 Mem.loadbytes mf sb 328 12=Some(G.float_bytes nx ny nz) /\
 forall n,CacheSeries mf sb n.
Definition InvalidationGoal:Prop:=forall m sb src id x y z,
 EI.InputGood m sb src id x y z->exists mw,
 EI.NormalCall id src m mw /\EI.SetterResult m mw sb src x y z /\
 ~H.HitInput mw sb /\
 Mem.loadbytes mw sb 328 12=Mem.loadbytes m sb 328 12 /\
 pure_rval G.ge empty_env mw G.getter_condition=Some(Vint Int.one) /\
 forall nx ny nz,
 Mem.load Mint32 m sb 296=Some(Vint nx)->Mem.load Mint32 m sb 300=Some(Vint ny)->Mem.load Mint32 m sb 304=Some(Vint nz)->
 exists mf,G.NormalCall mw mf sb /\G.GetterResult mw mf sb nx ny nz /\
 observe_bits mf sb=Some(bits_of nx ny nz) /\forall n,CacheSeries mf sb n.
Definition FreshnessRefutationGoal:Prop:=exists w:WitnessPair,
 observe_bits(witness_mfa w)(witness_sb w)<>Some expected_bits /\
 observe_bits(witness_mfb w)(witness_sb w)<>Some expected_bits /\
 forall n,CacheSeries(witness_mfa w)(witness_sb w)n /\CacheSeries(witness_mfb w)(witness_sb w)n.
Definition HistoryRefutationGoal:Prop:=exists w:WitnessPair,
 observe_bits(witness_mfa w)(witness_sb w)<>observe_bits(witness_mfb w)(witness_sb w) /\
 forall n,CacheSeries(witness_mfa w)(witness_sb w)n /\CacheSeries(witness_mfb w)(witness_sb w)n.
