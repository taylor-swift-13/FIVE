From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata.
From StateSpeedSetterSupport Require Import MemoryFacts HarnessMemory.
From StateSpeedSetNedISupport Require Import Setup Harness Original.
From StateSpeedSetNedIRecheckProblem Require Import Spec.
Open Scope Z_scope.
Lemma small_repr:forall i,0<=i<=656 ->Ptrofs.unsigned(Ptrofs.repr i)=i.
Proof. intros;apply Ptrofs.unsigned_repr;change(0<=i<=18446744073709551615);lia. Qed.
Lemma writable_weak:forall m b i,Mem.range_perm m b 0 656 Cur Writable ->0<=i<=656 ->
 Mem.weak_valid_pointer m b i=true.
Proof.
 intros m b i RP R;apply Mem.weak_valid_pointer_spec.
 destruct(Z.eq_dec i 656)as[EQ|NE];[right|left];
 apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;
 [apply RP;lia|constructor|apply RP;lia|constructor].
Qed.
Theorem proved_property_0:property_0.
Proof. intros m sb src before x y z HG;destruct(Mem.range_perm_storebytes m sb 0 zeros);[rewrite zeros_length;exact(raw_state _ _ _ _ _ _ _ HG)|eauto]. Qed.
Theorem proved_property_1:property_1.
Proof.
 intros m sb src before x y z HG;split.
 - eapply range_valid with(n:=656)(p:=Writable);[lia|exact(raw_before _ _ _ _ _ _ _ HG)].
 - split;[apply small_repr;lia|apply writable_weak;[exact(raw_before _ _ _ _ _ _ _ HG)|lia]].
Qed.
Theorem proved_property_2:property_2.
Proof. intros m sb src before x y z HG;split;[pose proof(raw_before_state _ _ _ _ _ _ _ HG);congruence|intro EQ;exfalso;exact(raw_before_state _ _ _ _ _ _ _ HG(eq_sym EQ))]. Qed.
Theorem proved_property_3:property_3.
Proof. intros m sb src before x y z HG;split;[exact(raw_before_state _ _ _ _ _ _ _ HG)|intro EQ;exfalso;exact(raw_before_state _ _ _ _ _ _ _ HG EQ)]. Qed.
Theorem proved_property_4:property_4.
Proof.
 intros m sb src before x y z HG;split.
 - eapply range_valid with(n:=656)(p:=Writable);[lia|exact(raw_before _ _ _ _ _ _ _ HG)].
 - apply writable_weak;[exact(raw_before _ _ _ _ _ _ _ HG)|lia].
Qed.
Theorem proved_property_5:property_5.
Proof. intros m sb src before x y z HG i j RI RJ EQ;injection EQ as EQ _;exact(raw_before_state _ _ _ _ _ _ _ HG(eq_sym EQ)). Qed.
Theorem proved_property_6:property_6.
Proof. intros m sb src before x y z HG i R;eapply Mem.perm_implies;[apply(raw_state _ _ _ _ _ _ _ HG);exact R|constructor]. Qed.
Theorem proved_property_7:property_7.
Proof. intros m sb src before x y z HG;exact(raw_before _ _ _ _ _ _ _ HG). Qed.
Theorem proved_property_8:property_8.
Proof.
 intros m sb src before x y z HG.
 destruct(original_normal_result m sb src(Int.repr 65535)x y z(harness_input _ _ _ _ _ _ _ HG))as(mf&CALL&POST&UNIQUE).
 exists mf;split;[exact CALL|];split;[|exact UNIQUE].
 repeat split;[exact(result_x _ _ _ _ _ _ _ POST)|exact(result_y _ _ _ _ _ _ _ POST)|exact(result_z _ _ _ _ _ _ _ POST)].
Qed.
Theorem proved_property_9:property_9.
Proof. intros m sb src before x y z mf HG CALL;eapply result_status;exact(every_normal_result _ _ _ _ _ _ _ _ HG CALL). Qed.
Theorem proved_property_10:property_10.
Proof. intros m sb src before x y z mf i HG CALL R;split;[apply small_repr;lia|apply writable_weak;[exact(state_output_writable _ _ _ _ _ _ _ _ HG CALL)|lia]]. Qed.
Theorem proved_property_11:property_11.
Proof. intros m sb src before x y z mf i HG CALL R;eapply Mem.valid_access_load;apply writable_byte;[exact(state_output_writable _ _ _ _ _ _ _ _ HG CALL)|assumption]. Qed.
Theorem proved_property_12:property_12.
Proof. intros m sb src before x y z mf i HG CALL R;split;[exact R|];eapply Mem.valid_access_load;apply writable_byte;[exact(before_output_writable _ _ _ _ _ _ _ _ HG CALL)|assumption]. Qed.
Theorem proved_property_13:property_13.
Proof. exact output_frame_byte. Qed.

Lemma loaded_source_facts:forall m b ofs v,
 Mem.load Mint32 m b ofs=Some(Vint v) ->0<=ofs<=8 ->
 pointer_nonnull m b ofs /\pointer_live m b ofs /\pointer_not_deallocated m b ofs /\
 pointer_not_dead m b ofs /\pointer_word_range m b ofs /\pointer_not_integer m b ofs.
Proof.
 intros m b ofs v LOAD R;pose proof(Mem.load_valid_access _ _ _ _ _ LOAD)as VA.
 assert(PERM:Mem.perm m b ofs Cur Readable)by(apply(proj1 VA);cbn;lia).
 split;[discriminate|];split;[exact(loaded_valid _ _ _ _ _ LOAD)|];split.
 - eapply Mem.perm_implies;[apply Mem.perm_cur_max;exact PERM|constructor].
 - split.
   + eapply Mem.perm_implies;[exact PERM|constructor].
   + split.
     * split;[exact VA|];split;[apply small_repr;lia|change(ofs+4<=18446744073709551616);lia].
     * split;intros i;discriminate.
Qed.
Lemma source_checks:forall ofs P,
 (forall m b v,Mem.load Mint32 m b ofs=Some(Vint v) ->P m b ofs) ->
 (forall m src x y z,VecRead m src x y z ->exists v,Mem.load Mint32 m src ofs=Some(Vint v)) ->SourceGuard ofs P.
Proof.
 intros ofs P DERIVE WORD m sb src before x y z HG;split.
 - exact(original_no_error _ _ _ _ _ _ _(harness_input _ _ _ _ _ _ _ HG)).
 - destruct(WORD m src x y z(input_words _ _ _ _ _ _ _(harness_input _ _ _ _ _ _ _ HG)))as[v LOAD].
   exact(DERIVE m src v LOAD).
Qed.
Theorem proved_property_14:property_14.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 0 v LOAD ltac:(lia))as ALL;destruct ALL as[FACT REST]. exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists x;exact RX.
Qed.
Theorem proved_property_15:property_15.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 0 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists x;exact RX.
Qed.
Theorem proved_property_16:property_16.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 0 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists x;exact RX.
Qed.
Theorem proved_property_17:property_17.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 0 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists x;exact RX.
Qed.
Theorem proved_property_18:property_18.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 0 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists x;exact RX.
Qed.
Theorem proved_property_19:property_19.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 0 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. exact REST. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists x;exact RX.
Qed.
Theorem proved_property_20:property_20.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 4 v LOAD ltac:(lia))as ALL;destruct ALL as[FACT REST]. exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists y;exact RY.
Qed.
Theorem proved_property_21:property_21.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 4 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists y;exact RY.
Qed.
Theorem proved_property_22:property_22.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 4 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists y;exact RY.
Qed.
Theorem proved_property_23:property_23.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 4 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists y;exact RY.
Qed.
Theorem proved_property_24:property_24.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 4 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists y;exact RY.
Qed.
Theorem proved_property_25:property_25.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 4 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. exact REST. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists y;exact RY.
Qed.
Theorem proved_property_26:property_26.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 8 v LOAD ltac:(lia))as ALL;destruct ALL as[FACT REST]. exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists z;exact RZ.
Qed.
Theorem proved_property_27:property_27.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 8 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists z;exact RZ.
Qed.
Theorem proved_property_28:property_28.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 8 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists z;exact RZ.
Qed.
Theorem proved_property_29:property_29.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 8 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists z;exact RZ.
Qed.
Theorem proved_property_30:property_30.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 8 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[FACT REST];exact FACT. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists z;exact RZ.
Qed.
Theorem proved_property_31:property_31.
Proof.
 apply source_checks.
 - intros m b v LOAD;pose proof(loaded_source_facts m b 8 v LOAD ltac:(lia))as ALL;destruct ALL as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. destruct REST as[_ REST]. exact REST. 
 - intros m src x y z GOOD;destruct GOOD as[RX[RY RZ]];exists z;exact RZ.
Qed.
Theorem proved_harness_preparation:HarnessPreparationGoal.
Proof. exact harness_preparation. Qed.
Print Assumptions proved_property_0.
Print Assumptions proved_property_1.
Print Assumptions proved_property_2.
Print Assumptions proved_property_3.
Print Assumptions proved_property_4.
Print Assumptions proved_property_5.
Print Assumptions proved_property_6.
Print Assumptions proved_property_7.
Print Assumptions proved_property_8.
Print Assumptions proved_property_9.
Print Assumptions proved_property_10.
Print Assumptions proved_property_11.
Print Assumptions proved_property_12.
Print Assumptions proved_property_13.
Print Assumptions proved_property_14.
Print Assumptions proved_property_15.
Print Assumptions proved_property_16.
Print Assumptions proved_property_17.
Print Assumptions proved_property_18.
Print Assumptions proved_property_19.
Print Assumptions proved_property_20.
Print Assumptions proved_property_21.
Print Assumptions proved_property_22.
Print Assumptions proved_property_23.
Print Assumptions proved_property_24.
Print Assumptions proved_property_25.
Print Assumptions proved_property_26.
Print Assumptions proved_property_27.
Print Assumptions proved_property_28.
Print Assumptions proved_property_29.
Print Assumptions proved_property_30.
Print Assumptions proved_property_31.
Print Assumptions proved_harness_preparation.
