From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Events Globalenvs Csem.
From StateSpeedMemory Require Import Protocol SourceComparison InitialMemory.
Import ListNotations.
Open Scope Z_scope.
Module IM:=StateSpeedMemory.InitialMemory.
Lemma ready_protocol:forall m sb ns es nx ny nz ex ey ez,
 IM.InitialReady m sb ns es nx ny nz ex ey ez->ProtocolInput m sb ns es nx ny nz ex ey ez.
Proof.
 intros m sb ns es nx ny nz ex ey ez READY.
 destruct READY as[SYM WR FILTER NV EV NS ES DIFF BYTES STATUS NWR EWR].
 constructor;[exact SYM|exact WR|exact FILTER|exact NS|exact ES|exact NV|exact EV].
Qed.
Lemma zero_bits:bits_of Int.zero Int.zero Int.zero=(Int.zero,Int.zero,Int.zero).
Proof. vm_compute;reflexivity. Qed.
Lemma one_bits:bits_of Protocol.S Int.zero Int.zero=(Int.repr 1065353216,Int.zero,Int.zero).
Proof. vm_compute;reflexivity. Qed.
Lemma expected_decode:bits_of Protocol.E Int.zero Int.zero=expected_bits.
Proof. vm_compute;reflexivity. Qed.
Theorem paired_counterexample:exists w:WitnessPair,
 observe_bits(witness_mfa w)(witness_sb w)=Some(Int.zero,Int.zero,Int.zero) /\observe_bits(witness_mfb w)(witness_sb w)=Some(Int.repr 1065353216,Int.zero,Int.zero).
Proof.
 destruct(IM.initial_ready_exists Int.zero Int.zero Int.zero Protocol.E Int.zero Int.zero)as[ma[sa[na[ea RA]]]].
 destruct(IM.initial_ready_exists Protocol.S Int.zero Int.zero Protocol.E Int.zero Int.zero)as[mb[sb[nb[eb RB]]]].
 pose proof(IM.getter_state_symbol _ _ _ _ _ _ _ _ _ _ RA)as SA.
 pose proof(IM.getter_state_symbol _ _ _ _ _ _ _ _ _ _ RB)as SB.
 rewrite SA in SB;injection SB as EQ;subst sb.
 pose proof(ready_protocol _ _ _ _ _ _ _ _ _ _ RA)as PA.
 pose proof(ready_protocol _ _ _ _ _ _ _ _ _ _ RB)as PB.
 destruct(actual_protocol _ _ _ _ _ _ _ _ _ _ PA)as[mna[mea[mfa[RUN_A OBS_A]]]].
 destruct(actual_protocol _ _ _ _ _ _ _ _ _ _ PB)as[mnb[meb[mfb[RUN_B OBS_B]]]].
 pose proof(IM.initial_state_bytes _ _ _ _ _ _ _ _ _ _ RA)as BA.
 pose proof(IM.initial_state_bytes _ _ _ _ _ _ _ _ _ _ RB)as BB.
 set(w:={|witness_ma:=ma;witness_mb:=mb;witness_sb:=sa;
 witness_na:=na;witness_ea:=ea;witness_nb:=nb;witness_eb:=eb;
 witness_mna:=mna;witness_mea:=mea;witness_mfa:=mfa;
 witness_mnb:=mnb;witness_meb:=meb;witness_mfb:=mfb;
 witness_initial_bytes:=IM.initial_state_contents;witness_input_a:=PA;witness_input_b:=PB;
 witness_initial_a:=BA;witness_initial_b:=BB;witness_run_a:=RUN_A;witness_run_b:=RUN_B|}:WitnessPair).
 exists w;change(observe_bits mfa sa=Some(Int.zero,Int.zero,Int.zero) /\observe_bits mfb sa=Some(Int.repr 1065353216,Int.zero,Int.zero)).
 split;[rewrite OBS_A,zero_bits;reflexivity|rewrite OBS_B,one_bits;reflexivity].
Qed.
Print Assumptions paired_counterexample.
