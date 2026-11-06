From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Ctypes Csyntaxdefs Cop Csem Smallstep Globalenvs.
From FiveGhSetOmega Require Import Source Execution.
From FiveGhSetOmegaProof Require Import BitsAdapter Public.
From FivePaparazziState Require Import State.
Import ListNotations.
Local Open Scope Z_scope.
Definition BitAssert(f g:float32)(m:mem):Prop:=
 sem_binary_operation FiveGhSetOmega.Execution.ge Oeq(Vint(Float32.to_bits f))tuint(Vint(Float32.to_bits g))tuint m=Some(Vint Int.one).
Definition Prefix(s:State.state)(o:float32)(m:mem)(b:block)(t:Events.trace)(v:val)(mf:mem):Prop:=
 Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref=Some b /\ repr s m b /\ writable m b /\
 star Csem.step FiveGhSetOmega.Execution.ge(FiveGhSetOmega.Execution.entry[Vsingle o]m)t(Returnstate v Kstop mf).
Definition Assertion1:Prop:=forall s o m b t v mf,Prefix s o m b t v mf ->
 exists returned stored,v=Vsingle returned /\ Mem.load Mfloat32 mf b 36=Some(Vsingle stored) /\
 BitAssert returned(clamp_omega o)mf /\ BitAssert stored(clamp_omega o)mf /\
 BitsObservation FiveGhSetOmega.Execution.ge returned mf /\ BitsObservation FiveGhSetOmega.Execution.ge stored mf.
Definition Assertion2:Prop:=forall s o m b t v mf,Prefix s o m b t v mf ->
 exists square,Mem.load Mfloat32 mf b 52=Some(Vsingle square) /\
 BitAssert square(Float32.mul(clamp_omega o)(clamp_omega o))mf /\ BitsObservation FiveGhSetOmega.Execution.ge square mf.
Definition Assertion3:Prop:=forall s o m b t v mf,Prefix s o m b t v mf ->
 exists product,Mem.load Mfloat32 mf b 48=Some(Vsingle product) /\
 BitAssert product(Float32.mul(zeta s)(clamp_omega o))mf /\ BitsObservation FiveGhSetOmega.Execution.ge product mf.
Definition frame_bits(s:State.state):list val:=
 [Vint(Float32.to_bits(accel_x s));Vint(Float32.to_bits(accel_y s));Vint(Float32.to_bits(speed_x s));Vint(Float32.to_bits(speed_y s));Vlong(pos_x s);Vlong(pos_y s);Vint(Float32.to_bits(tau s));Vint(Float32.to_bits(zeta s));Vint(Float32.to_bits(max_speed s));Vint(Float32.to_bits(inv_tau s));Vint(Float32.to_bits(dt s))].
Definition Assertion4:Prop:=forall s o m b t v mf,Prefix s o m b t v mf ->
 exists final,repr final mf b /\ frame_bits final=frame_bits s.
Definition AdapterGuards:Prop:=forall x m,
 BitsObservation FiveGhSetOmega.Execution.ge x m /\
 Int64.min_signed<=4<=Int64.max_signed /\ 0<=4<Int64.modulus /\
 Int64.signed(Int64.repr 4)=4 /\ Int64.unsigned(Int64.repr 4)=4.
