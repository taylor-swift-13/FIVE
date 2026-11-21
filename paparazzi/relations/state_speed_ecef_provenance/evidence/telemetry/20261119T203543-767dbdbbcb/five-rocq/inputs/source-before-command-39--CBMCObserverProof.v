
From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Ctypes Cop Csyntax Csem.
From FiveGuidanceAllOrder Require Import PureDenotation.
From StateSpeedGetterSupport Require Import Layout ControlExclusion.
From StateSpeedMemory Require Import Protocol SourceComparison HarnessObservation CBMCGuardSpec ObserverCopy Refutations InitialMemory ObserverHistory.
From StateSpeedSetterSupport Require Import DefinedBytes.
Import ListNotations.
Open Scope Z_scope.
Lemma protocol_state_writable:forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 Mem.range_perm me sb 0 656 Cur Writable /\Mem.range_perm mf sb 0 656 Cur Writable.
Proof.
 intros m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN.
 pose proof(ecef_input_after_ned _ _ _ _ _ _ _ _ _ _ _ INPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN))as EINPUT.
 pose proof(getter_input_after_ecef _ _ _ _ _ _ _ _ _ _ _ _ EINPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT))as GINPUT.
 destruct GINPUT as[SYM[WR REST]];split;[exact WR|].
 intros i R;apply(proj1(G.result_permissions _ _ _ _ _ _(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)sb i Cur Writable));apply WR;exact R.
Qed.
Lemma protocol_source_readable:forall after ofs n,0<=ofs->ofs+n<=656->ProtocolSourceReadable after ofs n.
Proof.
 intros after ofs n LO HI m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN.
 destruct(protocol_state_writable _ _ _ _ _ _ _ _ _ _ _ _ _ INPUT RUN)as[A B].
 destruct after;intros i R.
 - eapply Mem.perm_implies;[apply B;lia|exact perm_W_R].
 - eapply Mem.perm_implies;[apply A;lia|exact perm_W_R].
Qed.
Lemma protocol_copy:forall after srcOfs dstOfs n,
 0<=n->0<=srcOfs->srcOfs+n<=656->0<=dstOfs->dstOfs+n<=1360->
 ProtocolCopy after srcOfs dstOfs n.
Proof.
 intros after srcOfs dstOfs n NN SLO SHI DLO DHI m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN ob NE WR.
 pose proof(protocol_source_readable after srcOfs n SLO SHI _ _ _ _ _ _ _ _ _ _ _ _ _ INPUT RUN)as READ.
 destruct(Mem.range_perm_loadbytes _ _ _ _ READ)as[bytes BYTES].
 assert(DST:Mem.range_perm(if after then mf else me)ob dstOfs(dstOfs+n)Cur Writable)by(intros i R;apply WR;lia).
 destruct(observer_copy _ _ _ _ _ _ _ NN NE READ DST BYTES)as[copied COPY].
 exists bytes,copied;auto.
Qed.
Lemma division_guard:forall fallback axis,(axis<3)%nat->DivisionGuard fallback axis.
Proof.
 intros fallback axis AX;split.
 - destruct fallback;destruct axis as[|[|[|rest]]];try lia;reflexivity.
 - intros m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN NX NY NZ;subst ny;subst nz.
   pose proof(ecef_input_after_ned _ _ _ _ _ _ _ _ _ _ _ INPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN))as EINPUT.
   pose proof(getter_input_after_ecef _ _ _ _ _ _ _ _ _ _ _ _ EINPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT))as GINPUT.
   destruct GINPUT as[SYM[WR[STATUS[X[Y ZS]]]]].
   destruct axis as[|[|[|rest]]];try lia;cbn[axis_ident].
   + exists(G.decode nx);split.
     * eapply conversion_value with(sb:=sb)(delta:=0);[reflexivity|exact SYM|reflexivity|lia|exact X].
     * apply harness_division_values_finite;exact NX.
   + exists(G.decode Int.zero);split.
     * eapply conversion_value with(sb:=sb)(delta:=4);[reflexivity|exact SYM|reflexivity|lia|exact Y].
     * apply harness_division_values_finite;left;reflexivity.
   + exists(G.decode Int.zero);split.
     * eapply conversion_value with(sb:=sb)(delta:=8);[reflexivity|exact SYM|reflexivity|lia|exact ZS].
     * apply harness_division_values_finite;left;reflexivity.
Qed.
Theorem main_assertions:forall k,(1<=k<=10)%nat->MainAssertion k.
Proof.
 intros k RANGE.
 destruct paired_counterexample_initialized as[w[INIT[A B]]].
 destruct(witness_observers w)as[a[b[[OA OB]GOOD]]].
 assert(TYPED:TypedFrameComparisons w).
 { apply initialized_witness_typed_frame;rewrite INIT;apply initial_contents_defined. }
 exists w,a,b;split;[exact INIT|];split;[split;assumption|];split;[exact TYPED|];split;[exact observer_preparation_typed|];split;[exact returned_pointer_c_comparison|].
 destruct(Nat.leb k 7)eqn:K.
 - apply Nat.leb_le in K;apply GOOD;lia.
 - apply Nat.leb_gt in K.
   pose proof(observed_bits _ _ _ _ _ OA)as BA;pose proof(observed_bits _ _ _ _ _ OB)as BB.
   rewrite A in BA;rewrite B in BB;injection BA as BA;injection BB as BB.
   destruct k as[|[|[|[|[|[|[|[|[|[|[|n]]]]]]]]]]];try lia;
   cbn[harness_assertion];rewrite <-BA||rewrite <-BB||idtac;
   try(rewrite <-BB);unfold expected_bits;intro EQ;vm_compute in EQ;discriminate.
Qed.
Print Assumptions division_guard.
Print Assumptions main_assertions.
