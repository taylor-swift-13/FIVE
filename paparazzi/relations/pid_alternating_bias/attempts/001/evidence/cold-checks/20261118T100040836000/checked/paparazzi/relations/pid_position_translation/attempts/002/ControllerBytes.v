From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata.
From PidPositionTranslationCore Require Import CoreMemory CoreSemantics CoreClamp FlightSemantics ControllerPrefix PreciseFrame.
Import ListNotations.
Open Scope Z_scope.
Lemma replay_stores_word_bytes : forall updates(index:nat)ch b ofs v m mf,
 replay_stores m updates=Some mf ->
 nth_error updates index=Some(ch,b,ofs,v) ->
 Forall(misses_bytes b ofs(size_chunk ch))(skipn(S index)updates) ->
 Mem.loadbytes mf b ofs(size_chunk ch)=Some(encode_val ch v).
Proof.
 induction updates as[|[[[cu bu]ou]vu]tail IH];intros index ch b ofs v m mf RUN AT MISS.
 - destruct index;discriminate.
 - cbn[replay_stores]in RUN;destruct(Mem.store cu m bu ou vu)as[ma|]eqn:STORE;[|discriminate].
   destruct index as[|index].
   + cbn[nth_error]in AT;injection AT as<- <- <- <-.
     change(Forall(misses_bytes bu ou(size_chunk cu))tail)in MISS.
     rewrite(replay_stores_bytes_frame _ _ _ _ _ _ RUN MISS)by(pose proof(size_chunk_pos cu);lia).
     exact(Mem.loadbytes_store_same _ _ _ _ _ _ STORE).
   + cbn[nth_error]in AT;change(Forall(misses_bytes b ofs(size_chunk ch))(skipn(S index)tail))in MISS.
     eapply IH;[exact RUN|exact AT|exact MISS].
Qed.
Ltac every_word_miss :=
 lazymatch goal with
 | |-Forall _ []=>constructor
 | |-Forall _ (_::_)=>constructor;
   [cbn[misses_bytes size_chunk];first[left;congruence|right;left;lia|right;right;lia]|every_word_miss]
 end.
Theorem controller_updates_word_bytes :
 forall m mf bx bpy bp bi(flight:bool)kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total,
 bp<>bi ->
 replay_stores m(controller_updates flight bx bpy bp bi kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total)=Some mf ->
 Mem.loadbytes mf bi 0 4=Some(encode_val Mint32(Vint(next_integral flight ix ki(pd_bits kp kd pex sex)traj))) /\
 Mem.loadbytes mf bi 4 4=Some(encode_val Mint32(Vint(next_integral flight iy ki(pd_bits kp kd pey sey)traj))) /\
 Mem.loadbytes mf bp 32 4=Some(encode_val Mint32(Vint(controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total))) /\
 Mem.loadbytes mf bp 36 4=Some(encode_val Mint32(Vint(controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total))).
Proof.
 intros m mf bx bpy bp bi flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total DI RUN.
 destruct flight.
 - repeat split;
   [eapply replay_stores_word_bytes with(ch:=Mint32)(index:=8%nat)|eapply replay_stores_word_bytes with(ch:=Mint32)(index:=9%nat)|
    eapply replay_stores_word_bytes with(ch:=Mint32)(index:=12%nat)|eapply replay_stores_word_bytes with(ch:=Mint32)(index:=13%nat)];
   [exact RUN|reflexivity| |exact RUN|reflexivity| |exact RUN|reflexivity| |exact RUN|reflexivity|];
   cbv beta iota zeta delta[controller_updates first_four_updates clamp_updates flight_updates app skipn];every_word_miss.
 - repeat split;
   [eapply replay_stores_word_bytes with(ch:=Mint32)(index:=6%nat)|eapply replay_stores_word_bytes with(ch:=Mint32)(index:=7%nat)|
    eapply replay_stores_word_bytes with(ch:=Mint32)(index:=8%nat)|eapply replay_stores_word_bytes with(ch:=Mint32)(index:=9%nat)];
   [exact RUN|reflexivity| |exact RUN|reflexivity| |exact RUN|reflexivity| |exact RUN|reflexivity|];
   cbv beta iota zeta delta[controller_updates first_four_updates clamp_updates flight_updates app skipn];every_word_miss.
Qed.
Print Assumptions controller_updates_word_bytes.
