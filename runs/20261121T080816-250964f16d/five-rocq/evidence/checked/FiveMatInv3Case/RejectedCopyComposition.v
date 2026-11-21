From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePprzFloatMatInv3d Require Import Execution.
From FiveMatInv3Case Require Import Contract Scalar Observer Memcpy36 RecheckSupport Assertions SequentialReplay PairExtend GuardWitness ObserverComposition.
From FiveMatrixInverseSupport Require Import Kernels.
Require FiveMatInv3Functional.Spec FiveMatInv3Functional.Proof.
Import ListNotations.
Local Open Scope Z_scope.
Definition OriginalOld:=RecheckSupport.OldFixed.
Definition PairWordEq(before after:block)(i:Z):expr:=Ebinop Oeq(Cell before i tuint)(Cell after i tuint)tint.
Definition PairAssertion(before after:block):expr:=
 fold_left(fun a i=>Eseqand a(PairWordEq before after i)tint)[1;2;3;4;5;6;7;8](PairWordEq before after 0).
Lemma pair_word_true:forall m before after i w,0<=i<9->
 Mem.load Mint32 m before(4*i)=Some(Vint w)->Mem.load Mint32 m after(4*i)=Some(Vint w)->
 Reduces m(PairWordEq before after i)(Eval(Vint Int.one)tint).
Proof.
 intros m before after i w I B A;apply reduces_simple;unfold PairWordEq;
 eapply esr_binop with(v1:=Vint w)(v2:=Vint w);[apply cell_word_value;[exact I|exact B]|apply cell_word_value;[exact I|exact A]|].
 change(Some(Val.of_bool(Int.eq w w))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity.
Qed.
Lemma pair_assertion_true:forall m before after,
 (forall i,0<=i<9->exists w,Mem.load Mint32 m before(4*i)=Some(Vint w)/\Mem.load Mint32 m after(4*i)=Some(Vint w))->
 Reduces m(PairAssertion before after)(Eval(Vint Int.one)tint).
Proof.
 intros m before after LOAD;unfold PairAssertion;cbn[fold_left].
 repeat first[eapply reduces_and_true;[reflexivity|reflexivity| |]|
 match goal with|-Reduces _(PairWordEq _ _ ?i)_=>destruct(LOAD i ltac:(lia))as[w[B A]];eapply pair_word_true;[lia|exact B|exact A]end].
Qed.
Record PairPre(m:mem)(bo bi before after:block):Prop:={
 pair_initialized:Initialized m bo bi small3 OriginalOld;
 pair_before_copy:CopyPre m bo before;
 pair_after_copy:CopyPre m bo after;
 pair_before_input:bi<>before;
 pair_after_input:bi<>after;
 pair_destinations:before<>after
}.
Definition PairObservation(m:mem)(bo bi before after:block):Prop:=exists mb mf obs bytes t,
 Mem.loadbytes m bo 0 36=Some bytes /\Mem.storebytes m before 0 bytes=Some mb /\
 extcall_memcpy_sem 36 1(Genv.to_senv(Csem.genv_genv Execution.ge))[Vptr before Ptrofs.zero;Vptr bo Ptrofs.zero]m E0 Vundef mb /\
 CopyFrame m mb before /\
 star Csem.step Execution.ge(Execution.entry(Args bo bi Ptrofs.zero Ptrofs.zero)mb)t(Returnstate(Vint Int.one)Kstop mf) /\
 FiveMatInv3Functional.Spec.Post mb mf bo bi Ptrofs.zero Ptrofs.zero small3 /\
 Mem.loadbytes mf bo 0 36=Some bytes /\Mem.storebytes mf after 0 bytes=Some obs /\
 extcall_memcpy_sem 36 1(Genv.to_senv(Csem.genv_genv Execution.ge))[Vptr after Ptrofs.zero;Vptr bo Ptrofs.zero]mf E0 Vundef obs /\
 CopyFrame mf obs after /\
 (forall i,0<=i<9->Mem.load Mint32 obs before(4*i)=Some(Vint(Float32.to_bits(OriginalOld i)))/\Mem.load Mint32 obs after(4*i)=Some(Vint(Float32.to_bits(OriginalOld i)))) /\
 Reduces obs(PairAssertion before after)(Eval(Vint Int.one)tint).
Lemma copy_pre_after_post:forall m mf bo bi po pi f src dst,
 FiveMatInv3Functional.Spec.Post m mf bo bi po pi f->CopyPre m src dst->CopyPre mf src dst.
Proof.
 intros m mf bo bi po pi f src dst POST[NE RD WR];constructor;[exact NE| |].
 - intros z Z;assert(VA:Mem.valid_access m Mint8unsigned src z Readable).
   { split;[intros x X;apply RD;cbn[size_chunk]in X;lia|change(1|z);exists z;lia]. }
   destruct(post_access_preserved m mf bo bi po pi f Mint8unsigned src z Readable POST VA)as[RP AL];apply RP;cbn[size_chunk];lia.
 - intros z Z;assert(VA:Mem.valid_access m Mint8unsigned dst z Writable).
   { split;[intros x X;apply WR;cbn[size_chunk]in X;lia|change(1|z);exists z;lia]. }
   destruct(post_access_preserved m mf bo bi po pi f Mint8unsigned dst z Writable POST VA)as[RP AL];apply RP;cbn[size_chunk];lia.
Qed.
Lemma initialized_after_copy:forall m mb bo bi dst f old bytes,
 Initialized m bo bi f old->Mem.storebytes m dst 0 bytes=Some mb->bo<>dst->bi<>dst->Initialized mb bo bi f old.
Proof.
 intros m mb bo bi dst f old bytes[NE[W[RD CELLS]]]STORE OD ID;split;[exact NE|];split.
 - destruct W as[AL[NW RP]];repeat split;try assumption;intros z Z;eapply Mem.perm_storebytes_1;[exact STORE|apply RP;exact Z].
 - split.
   + destruct RD as[AL[NW R]];repeat split;try assumption;intros i I;rewrite(Mem.load_storebytes_other _ _ _ _ _ STORE Mfloat32 bi(Ptrofs.unsigned Ptrofs.zero+4*i)ltac:(left;exact ID));apply R;exact I.
   + intros i I;rewrite(Mem.loadbytes_storebytes_other _ _ _ _ _ STORE bo(4*i)4 ltac:(lia)ltac:(left;exact OD));apply CELLS;exact I.
Qed.
Theorem pair_observer:forall m bo bi before after,PairPre m bo bi before after->PairObservation m bo bi before after.
Proof.
 intros m bo bi before after[INIT CPB CPA IB IA BA].
 pose proof INIT as[NE[W[RD CELLS]]].
 pose proof(copy_separated _ _ _ CPB)as OB;pose proof(copy_separated _ _ _ CPA)as OA.
 destruct(copy36_exact(Genv.to_senv(Csem.genv_genv Execution.ge))m bo before CPB)as[mb[bytes[SAFE[READ[LEN[STOREB[CALLB[BYTESB FRAMEB]]]]]]]].
 assert(INITB:Initialized mb bo bi small3 OriginalOld)by(eapply initialized_after_copy;eauto).
 pose proof INITB as[NEB[WB[RDB CELLSB]]].
 assert(CPAB:CopyPre mb bo after)by(eapply copy36_preserves_pre;[exact STOREB|exact OB|congruence|exact CPA]).
 destruct(FiveMatInv3Functional.Proof.normal_call mb bo bi Ptrofs.zero Ptrofs.zero small3 NEB WB RDB)as[mf[[t PATH]POST]].
 assert(CPAF:CopyPre mf bo after)by(eapply copy_pre_after_post;eauto).
 destruct(copy36_exact(Genv.to_senv(Csem.genv_genv Execution.ge))mf bo after CPAF)as[obs[afterbytes[SAFEA[READA[LENA[STOREA[CALLA[BYTESA FRAMEA]]]]]]]].
 assert(SAME:afterbytes=bytes).
 { pose proof(proj1 POST)as BY;unfold OutputBytes in BY;rewrite small_rejects in BY;rewrite Ptrofs.unsigned_zero in BY;
   rewrite BY in READA;rewrite FRAMEB in READA by(left;exact OB);rewrite READ in READA;congruence. }
 subst afterbytes.
 assert(BEFORE:forall i,0<=i<9->Mem.load Mint32 mb before(4*i)=Some(Vint(Float32.to_bits(OriginalOld i)))).
 { intros i I;exact(FiveMatInv3Case.Observer.memcpy_word_observation m bo before mb bytes OriginalOld READ STOREB CELLS i I). }
 assert(BEFOREF:forall i,0<=i<9->Mem.load Mint32 mf before(4*i)=Some(Vint(Float32.to_bits(OriginalOld i)))).
 { intros i I;destruct POST as[BY[FR[WF[VB[AC INPUT]]]]];eapply frame_load_kept;[exact FR| |left;congruence|apply BEFORE;exact I].
   pose proof(Mem.load_valid_access _ _ _ _ _(BEFORE i I))as VA;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor]. }
 assert(CELLSF:forall i,0<=i<9->Mem.loadbytes mf bo(4*i)4=Some(encode_val Mfloat32(Vsingle(OriginalOld i)))).
 { intros i I;pose proof(same_bytes_cell m bo mf bo bytes(4*i)READ READA ltac:(lia)ltac:(lia))as EQ;rewrite <-EQ;apply CELLS;exact I. }
 assert(AFTER:forall i,0<=i<9->Mem.load Mint32 obs after(4*i)=Some(Vint(Float32.to_bits(OriginalOld i)))).
 { intros i I;exact(FiveMatInv3Case.Observer.memcpy_word_observation mf bo after obs bytes OriginalOld READA STOREA CELLSF i I). }
 assert(BEFOREOBS:forall i,0<=i<9->Mem.load Mint32 obs before(4*i)=Some(Vint(Float32.to_bits(OriginalOld i)))).
 { intros i I;rewrite(Mem.load_storebytes_other _ _ _ _ _ STOREA Mint32 before(4*i)ltac:(left;exact BA));apply BEFOREF;exact I. }
 exists mb,mf,obs,bytes,t;split;[exact READ|];split;[exact STOREB|];split;[exact CALLB|];split;[exact FRAMEB|];split.
 - rewrite <-(proj1 small3_kernel);exact PATH.
 - split;[exact POST|];split;[exact READA|];split;[exact STOREA|];split;[exact CALLA|];split;[exact FRAMEA|];split.
   + intros i I;split;[apply BEFOREOBS|apply AFTER];exact I.
   + apply pair_assertion_true;intros i I;exists(Float32.to_bits(OriginalOld i));split;[apply BEFOREOBS|apply AFTER];exact I.
Qed.
Lemma initialized_alloc36:forall m ma bo bi f old b,
 Initialized m bo bi f old->Mem.alloc m 0 36=(ma,b)->Initialized ma bo bi f old.
Proof.
 intros m ma bo bi f old b[NE[W[RD CELLS]]]A.
 assert(LP:LoadPreserved m ma)by(intros ch bx z VB;eapply Mem.load_alloc_unchanged;eauto).
 assert(AP:AccessPreserved m ma)by(intros ch bx z p VA;eapply Mem.valid_access_alloc_other;eauto).
 split;[exact NE|];split.
 - eapply region_preserved;[exact AP|exact(writable_valid m bo Ptrofs.zero 9 ltac:(lia)W)|exact W].
 - split;[eapply reads_preserved;[exact LP|lia|exact RD]|].
   intros i I;rewrite(Mem.loadbytes_alloc_unchanged m 0 36 ma b A bo(4*i)4(writable_valid m bo Ptrofs.zero 9 ltac:(lia)W));apply CELLS;exact I.
Qed.
Lemma pair_pre_inhabited:exists m bo bi before after,PairPre m bo bi before after.
Proof.
 destruct(initialized_exists small3 OriginalOld)as[m0[bo[bi INIT0]]].
 pose proof INIT0 as[NE[W[RD CELLS]]].
 pose proof(writable_valid m0 bo Ptrofs.zero 9 ltac:(lia)W)as VO.
 pose proof(reads_valid m0 bi Ptrofs.zero 9 small3 ltac:(lia)RD)as VI.
 destruct(Mem.alloc m0 0 36)as[mb before]eqn:B.
 assert(INITB:Initialized mb bo bi small3 OriginalOld)by(eapply initialized_alloc36;eauto).
 destruct(Mem.alloc mb 0 36)as[m after]eqn:A.
 assert(INIT:Initialized m bo bi small3 OriginalOld)by(eapply initialized_alloc36;eauto).
 assert(OB:bo<>before)by(intro EQ;rewrite EQ in VO;exact(Mem.fresh_block_alloc _ _ _ _ _ B VO)).
 assert(IB:bi<>before)by(intro EQ;rewrite EQ in VI;exact(Mem.fresh_block_alloc _ _ _ _ _ B VI)).
 assert(OVA:Mem.valid_block mb bo)by(eapply Mem.valid_block_alloc;eauto).
 assert(IVA:Mem.valid_block mb bi)by(eapply Mem.valid_block_alloc;eauto).
 assert(OA:bo<>after)by(intro EQ;rewrite EQ in OVA;exact(Mem.fresh_block_alloc _ _ _ _ _ A OVA)).
 assert(IA:bi<>after)by(intro EQ;rewrite EQ in IVA;exact(Mem.fresh_block_alloc _ _ _ _ _ A IVA)).
 assert(BA:before<>after)by(intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ B)as VB;rewrite EQ in VB;exact(Mem.fresh_block_alloc _ _ _ _ _ A VB)).
 assert(R:Mem.range_perm m bo 0 36 Cur Readable).
 { destruct INIT as[_[WO _]];destruct WO as[_[_ RP]];rewrite Ptrofs.unsigned_zero in RP;intros z Z;eapply Mem.perm_implies;[apply RP;exact Z|constructor]. }
 assert(WB:Mem.range_perm m before 0 36 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact B|exact Z]|constructor]. }
 assert(WA:Mem.range_perm m after 0 36 Cur Writable).
 { intros z Z;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|exact Z]|constructor]. }
 exists m,bo,bi,before,after;constructor;try assumption;constructor;assumption.
Qed.
Definition ComposedAssert6:Prop:=(forall m bo bi before after,PairPre m bo bi before after->PairObservation m bo bi before after)/\
 (exists m bo bi before after,PairPre m bo bi before after/\PairObservation m bo bi before after).
Theorem composed_assertion6:ComposedAssert6.
Proof. split;[exact pair_observer|];destruct pair_pre_inhabited as[m[bo[bi[before[after P]]]]];exists m,bo,bi,before,after;split;[exact P|apply pair_observer;exact P]. Qed.
Lemma original_fixture_bits:map(fun i=>Float32.to_bits(OriginalOld i))[0;1;2;3;4;5;6;7;8]=map Int.repr[1099431936;0;0;0;1099431936;0;0;0;1099431936].
Proof. vm_compute;reflexivity. Qed.
Print Assumptions composed_assertion6.

