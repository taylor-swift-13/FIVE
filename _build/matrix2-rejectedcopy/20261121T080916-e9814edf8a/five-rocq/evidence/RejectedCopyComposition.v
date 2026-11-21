From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveMatInv3Case Require Import MatrixMemory PairExtend.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract Call Replay Memcpy16 Observer RecheckSupport TraceInputs WordObserver.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.

(** Caller-local names are resolved to their actual array blocks.  Both operands
    of each comparison remain Mint32 loads in the original Csem expression. *)
Definition PairEq(before after:block)(i:Z):expr :=
 Ebinop Oeq(Cell before i tuint)(Cell after i tuint)tint.
Definition PairAssertion(before after:block):expr :=
 fold_left(fun a i=>Eseqand a(PairEq before after i)tint)
 [1;2;3](PairEq before after 0).
Lemma pair_eq_true:forall m before after i w,0<=i<4->
 Mem.load Mint32 m before(4*i)=Some(Vint w)->
 Mem.load Mint32 m after(4*i)=Some(Vint w)->
 Reduces m(PairEq before after i)(Eval(Vint Int.one)tint).
Proof.
 intros m before after i w I A B;apply reduces_simple;unfold PairEq.
 eapply esr_binop with(v1:=Vint w)(v2:=Vint w).
 - apply cell_word_value;assumption.
 - apply cell_word_value;assumption.
 - change(Some(Val.of_bool(Int.eq w w))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity.
Qed.
Lemma pair_assertion_true:forall m before after words,
 (forall i,0<=i<4->Mem.load Mint32 m before(4*i)=Some(Vint(words i))/\
                         Mem.load Mint32 m after(4*i)=Some(Vint(words i)))->
 Reduces m(PairAssertion before after)(Eval(Vint Int.one)tint).
Proof.
 intros m before after words LOAD.
 assert(P:forall i,0<=i<4->Reduces m(PairEq before after i)(Eval(Vint Int.one)tint)).
 { intros i I;eapply pair_eq_true with(w:=words i);[exact I|exact(proj1(LOAD i I))|exact(proj2(LOAD i I))]. }
 unfold PairAssertion;cbn[fold_left].
 repeat first[eapply reduces_and_true;[reflexivity|reflexivity| |]|apply P;lia].
Qed.

Lemma storebytes_reads_other:forall m mf changed bytes b p n f,
 Mem.storebytes m changed 0 bytes=Some mf->b<>changed->
 Reads m b p n f->Reads mf b p n f.
Proof.
 intros m mf changed bytes b p n f ST NE[AL[NW LD]];repeat split;auto.
 intros i I;erewrite Mem.load_storebytes_other by(exact ST||(left;exact NE));apply LD;exact I.
Qed.
Lemma storebytes_inputs_other:forall m mf changed bytes bo bi pi f,
 Mem.storebytes m changed 0 bytes=Some mf->bi<>changed->
 Inputs m bo bi Ptrofs.zero pi f->Inputs mf bo bi Ptrofs.zero pi f.
Proof.
 intros m mf changed bytes bo bi pi f ST NE[OI[W RD]];split;[exact OI|];split.
 - destruct W as[AL[NW RP]];repeat split;auto;intros z Z.
   eapply Mem.perm_storebytes_1;[exact ST|apply RP;exact Z].
 - eapply storebytes_reads_other;eauto.
Qed.
Lemma copypre_destination_valid:forall m src dst,CopyPre m src dst->Mem.valid_block m dst.
Proof.
 intros m src dst P.
 assert(VA:Mem.valid_access m Mint8unsigned dst 0 Writable).
 { split;[intros z Z;apply(copy_writable _ _ _ P);cbn[size_chunk]in Z;lia|
 change(1|0);exists 0;lia]. }
 eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor].
Qed.
Lemma post_copypre:forall m mf bo bi pi f dst,
 Post m mf bo bi Ptrofs.zero pi f->CopyPre m bo dst->CopyPre mf bo dst.
Proof.
 intros m mf bo bi pi f dst[W[RD[FR[VB[BY AC]]]]][NE RR WR];constructor;[exact NE| |].
 - destruct W as[AL[NW RP]];intros z Z.
   eapply Mem.perm_implies;[apply RP;rewrite Ptrofs.unsigned_zero;exact Z|constructor].
 - intros z Z.
   assert(VA:Mem.valid_access m Mint8unsigned dst z Writable).
   { split;[intros off O;apply WR;cbn[size_chunk]in O;lia|change(1|z);exists z;lia]. }
   assert(VD:Mem.valid_block m dst).
   { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|constructor]. }
   pose proof(AC Mint8unsigned dst z Writable VD VA)as[PF AL];apply PF;cbn[size_chunk];lia.
Qed.

(** This protocol is generic in every initial memval, including Undef and
    fragments.  It records the actual two 16-byte external memcpy calls around
    a real rejected normal Csem call.  No byte is replaced by a chosen value. *)
Record RejectedCopies(m:mem)(bo bi:block)(pi:ptrofs)(f:Z->float32)
 (before after:block)(mb mc obs:mem)(bytes:list memval):Prop := {
 protocol_original_bytes:Mem.loadbytes m bo 0 16=Some bytes;
 protocol_before_safety:MemcpySafety m bo before;
 protocol_before_store:Mem.storebytes m before 0 bytes=Some mb;
 protocol_before_call:extcall_memcpy_sem 16 1
  (Genv.to_senv(Csem.genv_genv Execution.ge))
  [Vptr before Ptrofs.zero;Vptr bo Ptrofs.zero]m E0 Vundef mb;
 protocol_before_bytes:Mem.loadbytes mb before 0 16=Some bytes;
 protocol_before_frame:CopyFrame m mb before;
 protocol_inputs:Inputs mb bo bi Ptrofs.zero pi f;
 protocol_normal_call:NormalCall mb bo bi Ptrofs.zero pi f mc;
 protocol_post:Post mb mc bo bi Ptrofs.zero pi f;
 protocol_normal_unique:forall t v mf,
  star Csem.step Execution.ge(Execution.entry(Args bo bi Ptrofs.zero pi)mb)t(Returnstate v Kstop mf)->
  v=Result f/\mf=mc;
 protocol_rejected_bytes:Mem.loadbytes mc bo 0 16=Some bytes;
 protocol_after_safety:MemcpySafety mc bo after;
 protocol_after_store:Mem.storebytes mc after 0 bytes=Some obs;
 protocol_after_call:extcall_memcpy_sem 16 1
  (Genv.to_senv(Csem.genv_genv Execution.ge))
  [Vptr after Ptrofs.zero;Vptr bo Ptrofs.zero]mc E0 Vundef obs;
 protocol_after_frame:CopyFrame mc obs after;
 protocol_final_before:Mem.loadbytes obs before 0 16=Some bytes;
 protocol_final_after:Mem.loadbytes obs after 0 16=Some bytes;
 protocol_final_input:Reads obs bi pi 4 f
}.

Theorem rejected_copy_protocol:forall m bo bi pi f before after,
 Reject f=true->Inputs m bo bi Ptrofs.zero pi f->
 CopyPre m bo before->CopyPre m bo after->
 before<>bi->after<>bi->before<>after->
 exists mb mc obs bytes,RejectedCopies m bo bi pi f before after mb mc obs bytes.
Proof.
 intros m bo bi pi f before after REJ IN PB PA BI AI BA.
 destruct(copy16_exact(Genv.to_senv(Csem.genv_genv Execution.ge))m bo before PB)
 as[mb[bytes[SB[READ[LEN[STORE[CALL[BYTES FRAME]]]]]]]].
 assert(INB:Inputs mb bo bi Ptrofs.zero pi f).
 { eapply storebytes_inputs_other;[exact STORE|congruence|exact IN]. }
 destruct(call_summary mb bo bi Ptrofs.zero pi f INB)
 as[mc[NORMAL[POST[SAFE UNIQUE]]]].
 assert(OUTB:Mem.loadbytes mb bo 0 16=Some bytes).
 { rewrite(FRAME bo 0 16 ltac:(left;exact(copy_separated _ _ _ PB)));exact READ. }
 assert(OUTC:Mem.loadbytes mc bo 0 16=Some bytes).
 { pose proof(proj1(proj2(proj2(proj2(proj2 POST)))))as OUT.
   rewrite REJ,Ptrofs.unsigned_zero in OUT;rewrite OUT;exact OUTB. }
 assert(PAB:CopyPre mb bo after).
 { eapply copy16_preserves_pre;[exact STORE|exact(copy_separated _ _ _ PB)|congruence|exact PA]. }
 assert(PAC:CopyPre mc bo after)by(eapply post_copypre;eauto).
 destruct(copy16_exact(Genv.to_senv(Csem.genv_genv Execution.ge))mc bo after PAC)
 as[obs[cbytes[SA[READC[LENC[STOREC[CALLC[BYTESC FRAMEC]]]]]]]].
 assert(CB:cbytes=bytes)by(congruence);subst cbytes.
 assert(VB:Mem.valid_block mb before).
 { eapply Mem.storebytes_valid_block_1;[exact STORE|eapply copypre_destination_valid;exact PB]. }
 assert(BEFOREC:Mem.loadbytes mc before 0 16=Some bytes).
 { pose proof(proj1(proj2(proj2 POST)))as FR.
   rewrite(FR before 0 16 VB ltac:(left;intro E;subst before;exact(copy_separated _ _ _ PB eq_refl)));exact BYTES. }
 assert(BEFOREF:Mem.loadbytes obs before 0 16=Some bytes).
 { rewrite(FRAMEC before 0 16 ltac:(left;exact BA));exact BEFOREC. }
 assert(RDF:Reads obs bi pi 4 f).
 { eapply storebytes_reads_other;[exact STOREC|congruence|exact(proj1(proj2 POST))]. }
 exists mb,mc,obs,bytes;constructor;assumption.
Qed.

Lemma decode_single_word:forall bytes x,
 decode_val Mfloat32 bytes=Vsingle x->
 decode_val Mint32 bytes=Vint(Float32.to_bits x).
Proof.
 intros bytes x H;unfold decode_val in *;destruct(proj_bytes bytes)as[bl|];try discriminate.
 injection H as E;subst x;rewrite Float32.to_of_bits;reflexivity.
Qed.
Lemma same_bytes_initial_word:forall m src obs dst bytes f i,
 Reads m src Ptrofs.zero 4 f->
 Mem.loadbytes m src 0 16=Some bytes->Mem.loadbytes obs dst 0 16=Some bytes->
 0<=i<4->Mem.load Mint32 obs dst(4*i)=Some(Vint(Float32.to_bits(f i))).
Proof.
 intros m src obs dst bytes f i RD OLD NEW I.
 pose proof(proj2(proj2 RD)i I)as LD;rewrite Ptrofs.unsigned_zero,Z.add_0_l in LD.
 destruct(Mem.load_loadbytes Mfloat32 m src(4*i)(Vsingle(f i))LD)as[cell[LB DE]].
 assert(LBN:Mem.loadbytes obs dst(4*i)4=Some cell).
 { rewrite <-(same_bytes_cell m src obs dst bytes(4*i)OLD NEW ltac:(lia)ltac:(lia));exact LB. }
 pose proof(Mem.loadbytes_load Mint32 obs dst(4*i)cell LBN ltac:(change(4|4*i);exists i;lia))as WORD.
 rewrite(decode_single_word cell(f i)ltac:(symmetry;exact DE))in WORD;exact WORD.
Qed.
Lemma fixture_bits:forall i,0<=i<4->
 Float32.to_bits(initial_fixture i)=Int.repr(nth(Z.to_nat i)[1099431936;0;0;1099431936]0).
Proof.
 intros i I;assert(i=0\/i=1\/i=2\/i=3)by lia.
 repeat destruct H as[H|H];subst i;vm_compute;reflexivity.
Qed.

Definition InitializedRejectedObservation(m:mem)(bo bi:block)(pi:ptrofs)
 (before after:block):Prop :=
 exists mb mc obs bytes,RejectedCopies m bo bi pi small2 before after mb mc obs bytes/\
 (forall i,0<=i<4->
  Mem.load Mint32 obs before(4*i)=Some(Vint(Int.repr(nth(Z.to_nat i)[1099431936;0;0;1099431936]0)))/\
  Mem.load Mint32 obs after(4*i)=Some(Vint(Int.repr(nth(Z.to_nat i)[1099431936;0;0;1099431936]0))))/\
 Reduces obs(PairAssertion before after)(Eval(Vint Int.one)tint).
Definition InitializedPairObserver:Prop := forall m bo bi pi before after,
 Inputs m bo bi Ptrofs.zero pi small2->Reads m bo Ptrofs.zero 4 initial_fixture->
 CopyPre m bo before->CopyPre m bo after->
 before<>bi->after<>bi->before<>after->
 InitializedRejectedObservation m bo bi pi before after.

Theorem initialized_pair_observer:InitializedPairObserver.
Proof.
 intros m bo bi pi before after IN OLD PB PA BI AI BA.
 assert(REJ:Reject small2=true)by(vm_compute;reflexivity).
 destruct(rejected_copy_protocol m bo bi pi small2 before after REJ IN PB PA BI AI BA)
 as[mb[mc[obs[bytes PROTOCOL]]]].
 assert(WORDS:forall i,0<=i<4->
  Mem.load Mint32 obs before(4*i)=Some(Vint(Int.repr(nth(Z.to_nat i)[1099431936;0;0;1099431936]0)))/\
  Mem.load Mint32 obs after(4*i)=Some(Vint(Int.repr(nth(Z.to_nat i)[1099431936;0;0;1099431936]0)))).
 { intros i I;rewrite <-(fixture_bits i I);split;eapply same_bytes_initial_word;
   [exact OLD|exact(protocol_original_bytes _ _ _ _ _ _ _ _ _ _ _ PROTOCOL)|exact(protocol_final_before _ _ _ _ _ _ _ _ _ _ _ PROTOCOL)|exact I|
    exact OLD|exact(protocol_original_bytes _ _ _ _ _ _ _ _ _ _ _ PROTOCOL)|exact(protocol_final_after _ _ _ _ _ _ _ _ _ _ _ PROTOCOL)|exact I]. }
 exists mb,mc,obs,bytes;split;[exact PROTOCOL|];split;[exact WORDS|].
 apply pair_assertion_true with(words:=fun i=>Int.repr(nth(Z.to_nat i)[1099431936;0;0;1099431936]0));exact WORDS.
Qed.


Record PairPre(m:mem)(bo bi before after:block):Prop := {
 pair_inputs:Inputs m bo bi Ptrofs.zero Ptrofs.zero small2;
 pair_initialized:Reads m bo Ptrofs.zero 4 initial_fixture;
 pair_before_copy:CopyPre m bo before;
 pair_after_copy:CopyPre m bo after;
 pair_before_input:before<>bi;
 pair_after_input:after<>bi;
 pair_destinations:before<>after
}.
Lemma initialized_alloc16:forall m ma fresh bo bi pi f old,
 Mem.alloc m 0 16=(ma,fresh)->
 Inputs m bo bi Ptrofs.zero pi f->Reads m bo Ptrofs.zero 4 old->
 Inputs ma bo bi Ptrofs.zero pi f/\Reads ma bo Ptrofs.zero 4 old.
Proof.
 intros m ma fresh bo bi pi f old AL[NE[W[IA[IW IL]]]][OA[OW OL]];split.
 - split;[exact NE|];split.
   + destruct W as[WA[WW WR]];repeat split;auto;intros z Z;eapply Mem.perm_alloc_1;[exact AL|apply WR;exact Z].
   + repeat split;auto;intros i I;eapply Mem.load_alloc_other;[exact AL|apply IL;exact I].
 - repeat split;auto;intros i I;eapply Mem.load_alloc_other;[exact AL|apply OL;exact I].
Qed.
Lemma pair_pre_inhabited:exists m bo bi before after,PairPre m bo bi before after.
Proof.
 destruct(pair4_extend Mem.empty small2 initial_fixture)as[m0[bo[bi[NE[W[RD[OLD0 REST]]]]]]].
 assert(IN0:Inputs m0 bo bi Ptrofs.zero Ptrofs.zero small2)by(split;[exact NE|];split;assumption).
 pose proof(writable_valid m0 bo Ptrofs.zero 4 ltac:(lia)W)as VO.
 pose proof(reads_valid m0 bi Ptrofs.zero 4 small2 ltac:(lia)RD)as VI.
 destruct(Mem.alloc m0 0 16)as[mb before]eqn:B.
 destruct(initialized_alloc16 m0 mb before bo bi Ptrofs.zero small2 initial_fixture B IN0 OLD0)as[INB OLDB].
 destruct(Mem.alloc mb 0 16)as[m after]eqn:A.
 destruct(initialized_alloc16 mb m after bo bi Ptrofs.zero small2 initial_fixture A INB OLDB)as[IN OLD].
 assert(OB:bo<>before)by(intro EQ;rewrite EQ in VO;exact(Mem.fresh_block_alloc _ _ _ _ _ B VO)).
 assert(IB:before<>bi)by(intro EQ;rewrite <-EQ in VI;exact(Mem.fresh_block_alloc _ _ _ _ _ B VI)).
 assert(OVA:Mem.valid_block mb bo)by(eapply Mem.valid_block_alloc;eauto).
 assert(IVA:Mem.valid_block mb bi)by(eapply Mem.valid_block_alloc;eauto).
 assert(OA:bo<>after)by(intro EQ;rewrite EQ in OVA;exact(Mem.fresh_block_alloc _ _ _ _ _ A OVA)).
 assert(IA:after<>bi)by(intro EQ;rewrite <-EQ in IVA;exact(Mem.fresh_block_alloc _ _ _ _ _ A IVA)).
 assert(BA:before<>after)by(intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ B)as VB;rewrite EQ in VB;exact(Mem.fresh_block_alloc _ _ _ _ _ A VB)).
 assert(R:Mem.range_perm m bo 0 16 Cur Readable).
 { destruct IN as[_[[AL[NW RP]]_]];rewrite Ptrofs.unsigned_zero in RP.
   intros z Z;eapply Mem.perm_implies;[apply RP;exact Z|constructor]. }
 assert(WB:Mem.range_perm m before 0 16 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact B|exact Z]|constructor]. }
 assert(WA:Mem.range_perm m after 0 16 Cur Writable).
 { intros z Z;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A|exact Z]|constructor]. }
 exists m,bo,bi,before,after;constructor;try assumption;constructor;assumption.
Qed.
Lemma pair_observer:forall m bo bi before after,PairPre m bo bi before after->
 InitializedRejectedObservation m bo bi Ptrofs.zero before after.
Proof. intros m bo bi before after[P I B A BI AI BA];apply initialized_pair_observer;assumption. Qed.
Definition ComposedAssert6:Prop :=
 (forall m bo bi before after,PairPre m bo bi before after->
  InitializedRejectedObservation m bo bi Ptrofs.zero before after)/\
 (exists m bo bi before after,PairPre m bo bi before after/\
  InitializedRejectedObservation m bo bi Ptrofs.zero before after).
Theorem composed_assertion6:ComposedAssert6.
Proof.
 split;[exact pair_observer|].
 destruct pair_pre_inhabited as[m[bo[bi[before[after P]]]]].
 exists m,bo,bi,before,after;split;[exact P|apply pair_observer;exact P].
Qed.
Print Assumptions rejected_copy_protocol.
Print Assumptions composed_assertion6.
