From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Globalenvs Ctypes Csem.
From StateSpeedSetterSupport Require Import MemoryFacts HarnessMemory.
From StateSpeedSetEcefISupport Require Import Setup Original.
Open Scope Z_scope.
Record RawHarnessGood(m:mem)(sb src before:block)(x y z:int):Prop:={
 raw_symbol:Genv.find_symbol ge S._state=Some sb;
 raw_state:Mem.range_perm m sb 0 656 Cur Writable;
 raw_before:Mem.range_perm m before 0 656 Cur Writable;
 raw_source:VecRead m src x y z;
 raw_separate:src<>sb;
 raw_before_state:before<>sb;
 raw_before_source:src<>before
}.
Record HarnessGood(m:mem)(sb src before:block)(x y z:int):Prop:={
 harness_input:InputGood m sb src(Int.repr 65535)x y z;
 harness_before:Mem.range_perm m before 0 656 Cur Writable;
 harness_before_state:before<>sb;
 harness_before_source:src<>before;
 harness_snapshot:Mem.loadbytes m before 0 656=Mem.loadbytes m sb 0 656
}.
Theorem harness_preparation:forall m sb src before x y z,
 RawHarnessGood m sb src before x y z ->exists m0,
 Preparation m m0 sb before /\HarnessGood m0 sb src before x y z.
Proof.
 intros m sb src before x y z[SY SW BW[RX[RY RZ]]NS BS NB].
 destruct(prepare_exists m sb before SW BW)as[m0 PREP];exists m0;split;[exact PREP|].
 assert(SW0:Mem.range_perm m0 sb 0 656 Cur Writable).
 { intros i R;apply(proj1(prepare_permissions m m0 sb before PREP sb i Cur Writable));apply SW;exact R. }
 assert(BW0:Mem.range_perm m0 before 0 656 Cur Writable).
 { intros i R;apply(proj1(prepare_permissions m m0 sb before PREP before i Cur Writable));apply BW;exact R. }
 constructor;try assumption.
 - constructor;try assumption.
   + apply(prepare_filter m m0 sb before PREP);congruence.
   + unfold VecRead;repeat split;rewrite(prepare_source m m0 sb before PREP Mint32 src _ NS NB);assumption.
 - apply(prepare_snapshot m m0 sb before PREP);congruence.
Qed.
Lemma every_normal_result:forall m sb src before x y z mf,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->
 SetterResult m mf sb src x y z.
Proof.
 intros m sb src before x y z mf HG CALL.
 destruct(original_normal_result m sb src(Int.repr 65535)x y z(harness_input _ _ _ _ _ _ _ HG))as(mf0&PATH&POST&UNIQUE).
 specialize(UNIQUE mf CALL);subst mf;exact POST.
Qed.
Lemma harness_state_valid:forall m sb src before x y z,
 HarnessGood m sb src before x y z ->Mem.valid_block m sb.
Proof. intros;eapply range_valid with(n:=656)(p:=Writable);[lia|exact(state_writable _ _ _ _ _ _ _(harness_input _ _ _ _ _ _ _ H))]. Qed.
Lemma harness_before_valid:forall m sb src before x y z,
 HarnessGood m sb src before x y z ->Mem.valid_block m before.
Proof. intros;eapply range_valid with(n:=656)(p:=Writable);[lia|exact(harness_before _ _ _ _ _ _ _ H)]. Qed.
Lemma writable_byte:forall m b i,
 Mem.range_perm m b 0 656 Cur Writable ->0<=i<656 ->Mem.valid_access m Mint8unsigned b i Readable.
Proof.
 intros m b i RP R;split.
 - intros j J;eapply Mem.perm_implies;[apply RP;cbn in J;lia|constructor].
 - change(1|i);exists i;lia.
Qed.
Lemma state_output_writable:forall m sb src before x y z mf,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->
 Mem.range_perm mf sb 0 656 Cur Writable.
Proof.
 intros m sb src before x y z mf HG CALL i R.
 pose proof(every_normal_result m sb src before x y z mf HG CALL)as POST.
 apply(proj1(result_permissions _ _ _ _ _ _ _ POST sb i Cur Writable(harness_state_valid _ _ _ _ _ _ _ HG))).
 apply(state_writable _ _ _ _ _ _ _(harness_input _ _ _ _ _ _ _ HG));exact R.
Qed.
Lemma before_output_writable:forall m sb src before x y z mf,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->
 Mem.range_perm mf before 0 656 Cur Writable.
Proof.
 intros m sb src before x y z mf HG CALL i R.
 pose proof(every_normal_result m sb src before x y z mf HG CALL)as POST.
 apply(proj1(result_permissions _ _ _ _ _ _ _ POST before i Cur Writable(harness_before_valid _ _ _ _ _ _ _ HG))).
 apply(harness_before _ _ _ _ _ _ _ HG);exact R.
Qed.
Lemma snapshot_slice:forall m sb src before x y z i,
 HarnessGood m sb src before x y z ->0<=i<656 ->
 Mem.loadbytes m before i 1=Mem.loadbytes m sb i 1.
Proof.
 intros m sb src before x y z i HG R.
 eapply equal_snapshot_slice with(n:=656);try lia.
 - intros j J;eapply Mem.perm_implies;[apply(harness_before _ _ _ _ _ _ _ HG);exact J|constructor].
 - intros j J;eapply Mem.perm_implies;[apply(state_writable _ _ _ _ _ _ _(harness_input _ _ _ _ _ _ _ HG));exact J|constructor].
 - exact(harness_snapshot _ _ _ _ _ _ _ HG).
Qed.
Lemma output_frame_byte:forall m sb src before x y z mf i,
 HarnessGood m sb src before x y z ->NormalCall(Int.repr 65535)src m mf ->
 0<=i<656 ->~writes sb sb i ->
 Mem.loadbytes mf sb i 1=Mem.loadbytes mf before i 1.
Proof.
 intros m sb src before x y z mf i HG CALL R MISS.
 pose proof(every_normal_result _ _ _ _ _ _ _ _ HG CALL)as POST.
 rewrite(result_frame _ _ _ _ _ _ _ POST sb i 1(harness_state_valid _ _ _ _ _ _ _ HG)ltac:(lia)).
 2:{ intros j J;replace j with i by lia;exact MISS. }
 rewrite(result_frame _ _ _ _ _ _ _ POST before i 1(harness_before_valid _ _ _ _ _ _ _ HG)ltac:(lia)).
 2:{ intros j J[EQ RR];exact(harness_before_state _ _ _ _ _ _ _ HG EQ). }
 symmetry;exact(snapshot_slice _ _ _ _ _ _ _ _ HG R).
Qed.
