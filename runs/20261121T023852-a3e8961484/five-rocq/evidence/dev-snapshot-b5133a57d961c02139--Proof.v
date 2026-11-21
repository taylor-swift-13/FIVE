From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory Memdata Events Globalenvs Csem Smallstep.
From StateSpeedMemory Require Import Protocol SourceComparison Refutations.
From StateSpeedCacheProtocolProblem Require Import Spec.
Require StateSpeedGetterCacheAttempt001.Proof StateSpeedSetEcefISupport.Original StateSpeedGetterSupport.Original StateSpeedGetterSupport.Layout.
Import ListNotations.
Open Scope Z_scope.
Module HP:=StateSpeedGetterCacheAttempt001.Proof.
Module EO:=StateSpeedSetEcefISupport.Original.
Module GO:=StateSpeedGetterSupport.Original.
Lemma series_exists:forall n m sb,H.HitInput m sb->exists obs final,Reads sb n m obs final.
Proof.
 induction n;intros m sb INPUT.
 - exists [],m;constructor.
 - destruct(IHn m sb INPUT)as[obs[final REST]].
   exists(snapshot m sb::obs),final;eapply reads_next;[exact(proj1(HP.proved_exact_return m sb INPUT))|exact REST].
Qed.
Lemma series_exact:forall sb n m obs final,Reads sb n m obs final->H.HitInput m sb->
 final=m /\Forall(fun o=>o=snapshot m sb)obs /\length obs=n.
Proof.
 intros sb n m obs final RUN;induction RUN as[m|n m next obs final CALL REST IH];intros INPUT.
 - repeat split;constructor.
 - destruct(HP.proved_exact_return m sb INPUT)as[_ UNIQUE].
   destruct(UNIQUE E0(Vptr sb(Ptrofs.repr 328))next CALL)as[_ EQ];subst next.
   destruct(IH INPUT)as[EQ[ALL LEN]];subst final;split;[reflexivity|];split;[constructor;auto|cbn;lia].
Qed.
Theorem proved_repeated_hit:RepeatedHitGoal.
Proof.
 intros m sb INPUT n;split;[apply series_exists;exact INPUT|].
 intros obs final RUN;destruct(series_exact sb n m obs final RUN INPUT)as[EQ[ALL LEN]];subst final.
 split;[reflexivity|];split;[exact ALL|];split;[exact LEN|];split;[exact INPUT|intros;reflexivity].
Qed.
Lemma post_is_hot:forall m mf sb x y z,
 Genv.find_symbol G.ge G.S._state=Some sb->G.GetterResult m mf sb x y z->H.HitInput mf sb.
Proof.
 intros m mf sb x y z SYM RESULT;split;[exact SYM|].
 exists(Int.repr 33);split;[exact(G.result_status _ _ _ _ _ _ RESULT)|reflexivity].
Qed.
Theorem proved_protocol:ProtocolGoal.
Proof.
 intros m sb ns es nx ny nz ex ey ez INPUT.
 destruct(actual_protocol m sb ns es nx ny nz ex ey ez INPUT)as[mn[me[mf[RUN BITS]]]].
 exists mn,me,mf;split;[exact RUN|];split;[exact BITS|];split.
 - exact(G.result_bytes _ _ _ _ _ _(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)).
 - apply proved_repeated_hit;eapply post_is_hot;[exact(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT)|exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)].
Qed.
Theorem proved_invalidation:InvalidationGoal.
Proof.
 intros m sb src id x y z INPUT.
 destruct(EO.original_normal_result m sb src id x y z INPUT)as[mw[CALL[RES UNIQUE]]].
 assert(SYM:Genv.find_symbol G.ge G.S._state=Some sb).
 { pose proof(EI.state_symbol _ _ _ _ _ _ _ INPUT)as EIS.
   change(Genv.find_symbol MemoryLayout.EE.ge MemoryLayout.E._state=Some sb)in EIS.
   rewrite(proj2 MemoryLayout.common_state_symbols)in EIS;exact EIS. }
 assert(WR:Mem.range_perm m sb 0 656 Cur Writable)by exact(EI.state_writable _ _ _ _ _ _ _ INPUT).
 assert(VALID:Mem.valid_block m sb)by(eapply StateSpeedSetterSupport.MemoryFacts.range_valid;[lia|exact WR]).
 assert(STATUS:Mem.load Mint16unsigned mw sb 280=Some(Vint Int.one))by exact(EI.result_status _ _ _ _ _ _ _ RES).
 assert(WR2:Mem.range_perm mw sb 0 656 Cur Writable).
 { intros ofs RANGE;apply(proj1(EI.result_permissions _ _ _ _ _ _ _ RES sb ofs Cur Writable VALID));apply WR;exact RANGE. }
 exists mw;split;[exact CALL|];split;[exact RES|];split.
 - intros[_[q[LOAD HOT]]];rewrite STATUS in LOAD;inversion LOAD;subst q;discriminate HOT.
 - split.
   + apply(EI.result_frame _ _ _ _ _ _ _ RES sb 328 12 VALID ltac:(lia)).
     intros i I[EQ W];unfold EI.writes,EI.destination_offset in *;lia.
   + split;[eapply StateSpeedGetterSupport.Layout.getter_condition_value;[reflexivity|exact SYM|exact STATUS]|].
     intros nx ny nz NX NY NZ.
     assert(GOOD:G.InputGood mw sb nx ny nz).
     { split;[exact SYM|];split;[exact WR2|];split;[exact STATUS|].
       split;[|split];eapply ecef_frame_load;try exact RES;try eassumption.
       all:intros i I[EQ W];unfold EI.writes,EI.destination_offset in *;cbn[size_chunk]in I;lia. }
     destruct(GO.original_normal_result mw sb nx ny nz GOOD)as[mf[GC[GR GU]]].
     exists mf;split;[exact GC|];split;[exact GR|];split;[eapply observed_getter_result;exact GR|].
     apply proved_repeated_hit;eapply post_is_hot;eauto.
Qed.
Lemma witness_hot:forall w:WitnessPair,
 H.HitInput(witness_mfa w)(witness_sb w) /\H.HitInput(witness_mfb w)(witness_sb w).
Proof.
 intros w;split;eapply post_is_hot.
 - exact(input_symbol _ _ _ _ _ _ _ _ _ _(witness_input_a w)).
 - exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _(witness_run_a w)).
 - exact(input_symbol _ _ _ _ _ _ _ _ _ _(witness_input_b w)).
 - exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _(witness_run_b w)).
Qed.
Theorem proved_freshness_refutation:FreshnessRefutationGoal.
Proof.
 destruct Refutations.paired_counterexample as[w[A B]];exists w;split;[rewrite A;unfold expected_bits;discriminate|];split;[rewrite B;unfold expected_bits;discriminate|].
 intros n;destruct(witness_hot w)as[HA HB];split;apply proved_repeated_hit;assumption.
Qed.
Theorem proved_history_refutation:HistoryRefutationGoal.
Proof.
 destruct Refutations.paired_counterexample as[w[A B]];exists w;split;[rewrite A,B;discriminate|].
 intros n;destruct(witness_hot w)as[HA HB];split;apply proved_repeated_hit;assumption.
Qed.
Print Assumptions proved_repeated_hit.
Print Assumptions proved_protocol.
Print Assumptions proved_invalidation.
Print Assumptions proved_freshness_refutation.
Print Assumptions proved_history_refutation.
