From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Ctypes Csem Smallstep.
From StateSpeedSetterSupport Require Import MemoryFacts.
From StateSpeedGetterSupport Require Import ControlExclusion.
From StateSpeedMemory Require Import Protocol SourceComparison HarnessObservation CBMCGuardSpec.
Import ListNotations.
Open Scope Z_scope.
Lemma pointer_condition_valid:forall kind ch extent mode m b ofs,
 Mem.valid_access m ch b ofs mode->0<=ofs->ofs+size_chunk ch<=extent->extent<=Ptrofs.modulus->
 pointer_condition kind ch extent mode m b ofs.
Proof.
 intros kind ch extent mode m b ofs ACCESS NONNEG END EXT.
 assert(PERM:Mem.perm m b ofs Cur Nonempty).
 { eapply Mem.perm_implies;[exact(Mem.valid_access_perm _ _ _ _ Cur _ ACCESS)|constructor]. }
 assert(REPR:Ptrofs.unsigned(Ptrofs.repr ofs)=ofs).
 { apply Ptrofs.unsigned_repr;split;[exact NONNEG|].
   pose proof(size_chunk_pos ch);unfold Ptrofs.max_unsigned;lia. }
 destruct kind as[|[|[|[|[|kind]]]]];cbn[pointer_condition].
 - discriminate.
 - eapply Mem.perm_valid_block;exact PERM.
 - apply Mem.perm_cur_max;exact PERM.
 - exact PERM.
 - split;[exact ACCESS|];split;[exact REPR|];split;[exact NONNEG|];split;[exact END|lia].
 - split;intros;discriminate.
Qed.
Lemma words_access:forall m b x y z ofs,
 (Mem.load Mint32 m b 0=Some(Vint x) /\Mem.load Mint32 m b 4=Some(Vint y) /\Mem.load Mint32 m b 8=Some(Vint z))->
 (ofs=0 \/ofs=4 \/ofs=8)->Mem.valid_access m Mint32 b ofs Readable.
Proof.
 intros m b x y z ofs[X[Y ZS]] OFF;destruct OFF as[EQ|[EQ|EQ]];subst ofs;eapply Mem.load_valid_access;[exact X|exact Y|exact ZS].
Qed.
Theorem n_source_guard:forall ofs kind,(ofs=0 \/ofs=4 \/ofs=8)->NSourceGuard ofs kind.
Proof.
 intros ofs kind OFF m sb ns es nx ny nz ex ey ez INPUT.
 eapply pointer_condition_valid.
 - eapply words_access;[exact(input_ned_words _ _ _ _ _ _ _ _ _ _ INPUT)|exact OFF].
 - destruct OFF as[EQ|[EQ|EQ]];subst ofs;lia.
 - cbn[size_chunk];destruct OFF as[EQ|[EQ|EQ]];subst ofs;lia.
 - change(12<=18446744073709551616);lia.
Qed.
Theorem e_source_guard:forall ofs kind,(ofs=0 \/ofs=4 \/ofs=8)->ESourceGuard ofs kind.
Proof.
 intros ofs kind OFF m mn sb ns es nx ny nz ex ey ez INPUT RN.
 pose proof(ecef_input_after_ned m mn sb ns es nx ny nz ex ey ez INPUT RN)as EINPUT.
 eapply pointer_condition_valid.
 - eapply words_access;[exact(EI.input_words _ _ _ _ _ _ _ EINPUT)|exact OFF].
 - destruct OFF as[EQ|[EQ|EQ]];subst ofs;lia.
 - cbn[size_chunk];destruct OFF as[EQ|[EQ|EQ]];subst ofs;lia.
 - change(12<=18446744073709551616);lia.
Qed.
Theorem observer_pointer_guard:forall ofs ch kind,
 0<=ofs->ofs+size_chunk ch<=1360->(align_chunk ch|ofs)->ObserverPointerGuard ofs ch kind.
Proof.
 intros ofs ch kind NONNEG END ALIGN m ob WR.
 eapply pointer_condition_valid;[eapply range_access;[exact WR|exact NONNEG|exact END|exact ALIGN]|exact NONNEG|exact END|].
 change(1360<=18446744073709551616);lia.
Qed.
Theorem observer_array_guard:forall base i,0<=base->base<=1348->0<=i<3->ObserverArrayGuard base i.
Proof.
 intros base i BASE END INDEX;split;[exact INDEX|];split;[lia|].
 apply Ptrofs.unsigned_repr;change(0<=base+4*i<=18446744073709551615);lia.
Qed.
Lemma observation_array_lengths:forall mn me mf sb o,Observes mn me mf sb o->
 length(before_get o)=656%nat /\length(after_get o)=656%nat.
Proof.
 intros mn me mf sb o OBS;split.
 - exact(Mem.loadbytes_length _ _ _ _ _(observed_before _ _ _ _ _ OBS)).
 - exact(Mem.loadbytes_length _ _ _ _ _(observed_after _ _ _ _ _ OBS)).
Qed.
Theorem main_array_guard:forall after,MainArrayGuard after.
Proof.
 intros after w a b[OA OB]i RANGE.
 destruct(observation_array_lengths _ _ _ _ _ OA)as[AL BL].
 destruct(observation_array_lengths _ _ _ _ _ OB)as[AR BR].
 assert(MAX:Ptrofs.max_unsigned=18446744073709551615)by reflexivity.
 destruct after.
 - change(0<=i<Z.of_nat(length(after_get a)) /\ 0<=i<Z.of_nat(length(after_get b)) /\ Ptrofs.unsigned(Ptrofs.repr(704+i))=704+i).
   rewrite BL,BR;split;[exact RANGE|];split;[exact RANGE|].
   apply Ptrofs.unsigned_repr;rewrite MAX;lia.
 - change(0<=i<Z.of_nat(length(before_get a)) /\ 0<=i<Z.of_nat(length(before_get b)) /\ Ptrofs.unsigned(Ptrofs.repr(48+i))=48+i).
   rewrite AL,AR;split;[exact RANGE|];split;[exact RANGE|].
   apply Ptrofs.unsigned_repr;rewrite MAX;lia.
Qed.
Theorem zero_initialization_guard:ZeroInitializationGuard.
Proof.
 intros m sb WR;apply Mem.range_perm_storebytes.
 rewrite repeat_length;change(Mem.range_perm m sb 0 656 Cur Writable);exact WR.
Qed.
Theorem observer_destination_writable:forall ofs n,0<=ofs->ofs+n<=1360->ObserverDestinationWritable ofs n.
Proof. intros ofs n LOW HIGH m ob WR i RANGE;apply WR;lia. Qed.
Theorem copy_nonoverlap:forall srcOfs dstOfs n,CopyNonoverlap srcOfs dstOfs n.
Proof. intros srcOfs dstOfs n sb ob NE i j IR JR EQ;injection EQ as SAME OFF;apply NE;exact SAME. Qed.
Theorem guarded_memcpy_pointer:forall second source srcOfs dstOfs n point kind,
 GuardedMemcpyPointer second source srcOfs dstOfs n point kind.
Proof. intros second source srcOfs dstOfs n point kind m sb ob NE[EQ REST];contradiction. Qed.
Theorem guarded_memcpy_same_object:forall second srcOfs dstOfs n,GuardedMemcpySameObject second srcOfs dstOfs n.
Proof. intros second srcOfs dstOfs n sb ob NE[EQ REST];contradiction. Qed.
Lemma fallback_guard_nonempty:forall f,fn_params f<>[]->FallbackGuard f.
Proof.
 intros f NONEMPTY m sb x y z GOOD t reached PATH EQ.
 pose proof(all_reachable_zero_parameter_functions m sb x y z GOOD t reached PATH)as EMPTY.
 destruct reached;cbn[active_function zero_parameters]in *;try discriminate.
 - injection EQ as SAME;subst f;contradiction.
 - injection EQ as SAME;subst f;contradiction.
 - destruct fd;cbn[active_function zero_parameters]in *;try discriminate;injection EQ as SAME;subst f;contradiction.
Qed.
Theorem fallback_enu_guard:FallbackGuard G.S.f_ecef_of_enu_vect_f.
Proof. apply fallback_guard_nonempty;discriminate. Qed.
Theorem fallback_ned_guard:FallbackGuard G.S.f_ecef_of_ned_vect_f.
Proof. apply fallback_guard_nonempty;discriminate. Qed.
Print Assumptions pointer_condition_valid.
Print Assumptions main_array_guard.
Print Assumptions fallback_enu_guard.
Print Assumptions fallback_ned_guard.
