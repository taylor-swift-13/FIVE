From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationCore Require Import FactoryMemory CoreMemory.
From PidPositionTranslationAttempt002 Require Import ByteAgreement WitnessMemory.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Definition witness_updates(gh sb:block)(shift:Z):list scalar_update:=[
 (Mint16unsigned,sb,2,Vint(Int.repr 2));
 (Mint16unsigned,sb,280,Vint(Int.repr 2));
 (Mint32,gh,44,Vint(Int.repr(512+shift)));
 (Mint32,gh,48,Vint Int.zero);
 (Mint32,gh,52,Vint Int.zero);
 (Mint32,gh,56,Vint Int.zero);
 (Mint32,gh,60,Vint Int.zero);
 (Mint32,gh,64,Vint Int.zero);
 (Mint32,sb,100,Vint(Int.repr shift))].
Ltac witness_forall tac :=
 lazymatch goal with
 | |-Forall _ []=>apply Forall_nil
 | |-Forall _ (_::_)=>apply Forall_cons;[tac|witness_forall tac]
 end.
Ltac witness_align :=
 lazymatch goal with |-Z.divide ?a ?p=>
 let q:=eval vm_compute in(p/a)in exists q;reflexivity end.
Ltac witness_miss :=
 cbn[misses_chunk];first[left;congruence|right;left;cbn;lia|right;right;cbn;lia].
Theorem witness_updates_exist : forall base gh sb shift,
 Mem.range_perm base gh 0 84 Cur Writable ->
 Mem.range_perm base sb 0 656 Cur Writable ->
 exists mf,replay_stores base(witness_updates gh sb shift)=Some mf.
Proof.
 intros base gh sb shift WG WS;apply replay_stores_exists.
 unfold witness_updates;witness_forall ltac:(
 cbn;first[
 eapply scalar_access_inside with(n:=84);[exact WG|lia|cbn;lia|witness_align]|
 eapply scalar_access_inside with(n:=656);[exact WS|lia|cbn;lia|witness_align]]).
Qed.
Lemma zero_preserved_by_disjoint_replay : forall us base mf b len,
 Genv.read_as_zero base b 0 len ->
 Forall(fun u=>let '(_,dst,_,_):=u in b<>dst)us ->
 replay_stores base us=Some mf ->
 Genv.read_as_zero mf b 0 len.
Proof.
 intros us base mf b len ZERO MISS RUN ch ofs LO HI ALIGN.
 rewrite(replay_stores_load_frame us base mf ch b ofs RUN).
 - apply ZERO;assumption.
 - eapply Forall_impl;[|exact MISS].
   intros[[[cu dst]ou]v]NOT;left;exact NOT.
Qed.
Theorem witness_updated_loads : forall base mf gh sb shift,
 gh<>sb ->Genv.read_as_zero base sb 0 656 ->
 replay_stores base(witness_updates gh sb shift)=Some mf ->
 Mem.load Mint16unsigned mf sb 2=Some(Vint(Int.repr 2)) /\
 Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr 2)) /\
 Mem.load Mint32 mf gh 44=Some(Vint(Int.repr(512+shift))) /\
 Mem.load Mint32 mf gh 48=Some(Vint Int.zero) /\
 Mem.load Mint32 mf gh 52=Some(Vint Int.zero) /\
 Mem.load Mint32 mf gh 56=Some(Vint Int.zero) /\
 Mem.load Mint32 mf gh 60=Some(Vint Int.zero) /\
 Mem.load Mint32 mf gh 64=Some(Vint Int.zero) /\
 Mem.load Mint32 mf sb 100=Some(Vint(Int.repr shift)) /\
 Mem.load Mint32 mf sb 104=Some(Vint Int.zero) /\
 Mem.load Mint32 mf sb 296=Some(Vint Int.zero) /\
 Mem.load Mint32 mf sb 300=Some(Vint Int.zero).
Proof.
 intros base mf gh sb shift DIFF ZERO RUN.
 assert(P:Mem.load Mint16unsigned mf sb 2=Some(Vint(Int.repr 2))).
 { eapply replay_stores_value_at with(i:=0%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.repr 2));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(S:Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr 2))).
 { eapply replay_stores_value_at with(i:=1%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.repr 2));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(R:Mem.load Mint32 mf gh 44=Some(Vint(Int.repr(512+shift)))).
 { eapply replay_stores_value_at with(i:=2%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.repr(512+shift)));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(Y:Mem.load Mint32 mf gh 48=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=3%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.zero));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(VX:Mem.load Mint32 mf gh 52=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=4%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.zero));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(VY:Mem.load Mint32 mf gh 56=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=5%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.zero));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(AX:Mem.load Mint32 mf gh 60=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=6%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.zero));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(AY:Mem.load Mint32 mf gh 64=Some(Vint(Int.zero))).
 { eapply replay_stores_value_at with(i:=7%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.zero));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 assert(N:Mem.load Mint32 mf sb 100=Some(Vint(Int.repr shift))).
 { eapply replay_stores_value_at with(i:=8%nat)(us:=witness_updates gh sb shift)(m:=base)(v:=Vint(Int.repr shift));
   [reflexivity|exact RUN|cbn[witness_updates skipn];witness_forall ltac:(witness_miss)]. }
 repeat(first[assumption|split]).
 all:rewrite(replay_stores_load_frame _ _ _ _ _ _ RUN);
 [apply ZERO;[lia|cbn;lia|witness_align]|unfold witness_updates;witness_forall ltac:(witness_miss)].
Qed.
Lemma reference_position_written_bytes : forall gh i,
 44<=i<48 ->translated_byte gh gh i.
Proof.
 intros gh i R;left;exists S._x;split;[cbn;auto|];split;[reflexivity|].
 exists tint,44;split;[reflexivity|exact R].
Qed.
Lemma measured_position_written_bytes : forall gh sb i,
 Genv.find_symbol E.ge S._state=Some sb ->100<=i<104 ->translated_byte gh sb i.
Proof.
 intros gh sb i SYM R;right;exists sb,S._x;split;[exact SYM|];split;[cbn;auto|].
 split;[reflexivity|];exists tint,100;split;[reflexivity|exact R].
Qed.
Lemma compatible_update_same : forall gh ch dst ofs v,
 compatible_update gh(ch,dst,ofs,v)(ch,dst,ofs,v).
Proof. intros;exists ch,dst,ofs,v,v;split;[reflexivity|];split;[reflexivity|];left;reflexivity. Qed.
Lemma compatible_update_translated : forall gh ch dst ofs va vb,
 (forall i,ofs<=i<ofs+size_chunk ch->translated_byte gh dst i) ->
 compatible_update gh(ch,dst,ofs,va)(ch,dst,ofs,vb).
Proof. intros;exists ch,dst,ofs,va,vb;split;[reflexivity|];split;[reflexivity|];right;assumption. Qed.
Theorem witness_replays_related : forall base gh ret sb a b,
 Genv.find_symbol E.ge S._state=Some sb ->
 replay_stores base(witness_updates gh sb 0)=Some a ->
 replay_stores base(witness_updates gh sb 25600)=Some b ->
 same_except_positions_and_return gh ret a b.
Proof.
 intros base gh ret sb a b SYM A B.
 eapply compatible_replay_preserves_canonical_frame;[| |exact A|exact B].
 - unfold witness_updates.
   repeat(apply Forall2_cons;[apply compatible_update_same|]).
   apply Forall2_cons.
   + apply compatible_update_translated;intros i R;apply reference_position_written_bytes;exact R.
   + repeat(apply Forall2_cons;[apply compatible_update_same|]).
     apply Forall2_cons.
     * apply compatible_update_translated;intros i R;apply measured_position_written_bytes with(sb:=sb);assumption.
     * constructor.
 - split;[reflexivity|];split;[intros;tauto|intros;reflexivity].
Qed.
Print Assumptions witness_replays_related.
