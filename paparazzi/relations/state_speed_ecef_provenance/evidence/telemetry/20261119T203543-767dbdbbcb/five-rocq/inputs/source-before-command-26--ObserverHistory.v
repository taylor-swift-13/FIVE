
From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Floats Values Memory Memdata Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Smallstep.
From StateSpeedMemory Require Import Protocol SourceComparison InitialMemory ObserverCopy HarnessObservation Refutations.
From StateSpeedSetterSupport Require Import DefinedBytes.
Require StateSpeedGetterSupport.Original.
Import ListNotations.
Open Scope Z_scope.
Module GO:=StateSpeedGetterSupport.Original.
Lemma ready_allocate_observer:forall m sb ns es nx ny nz ex ey ez mo ob,
 InitialReady m sb ns es nx ny nz ex ey ez->
 Mem.alloc m 0 1360=(mo,ob)->
 InitialReady mo sb ns es nx ny nz ex ey ez /\
 Mem.range_perm mo ob 0 1360 Cur Writable /\ob<>sb /\ob<>ns /\ob<>es.
Proof.
 intros m sb ns es nx ny nz ex ey ez mo ob READY ALLOC.
 destruct READY as[SYM WR FILTER NV EV NS ES DIFF BYTES STATUS NWR EWR].
 assert(SV:Mem.valid_block m sb)by(eapply Mem.perm_valid_block;apply(WR 0);lia).
 assert(NVLD:Mem.valid_block m ns)by(eapply Mem.perm_valid_block;apply(NWR 0);lia).
 assert(EVLD:Mem.valid_block m es)by(eapply Mem.perm_valid_block;apply(EWR 0);lia).
 split.
 - constructor;auto.
   + eapply InitialMemory.range_allocate;eauto.
   + eapply Mem.load_alloc_other;eauto.
   + destruct NV as[X[Y ZS]];repeat split;eapply Mem.load_alloc_other;eauto.
   + destruct EV as[X[Y ZS]];repeat split;eapply Mem.load_alloc_other;eauto.
   + erewrite Mem.loadbytes_alloc_unchanged by eauto;exact BYTES.
   + eapply Mem.load_alloc_other;eauto.
   + eapply InitialMemory.range_allocate;eauto.
   + eapply InitialMemory.range_allocate;eauto.
 - split.
   + intros i R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;eauto|exact(perm_F_any Writable)].
   + repeat split;intro EQ;subst ob;eapply(Mem.fresh_block_alloc _ _ _ _ _ ALLOC);assumption.
Qed.
Lemma protocol_observer_writable:forall m mn me mf sb ns es nx ny nz ex ey ez ob,
 ProtocolInput m sb ns es nx ny nz ex ey ez->ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 Mem.range_perm m ob 0 1360 Cur Writable->Mem.range_perm me ob 0 1360 Cur Writable.
Proof.
 intros m mn me mf sb ns es nx ny nz ex ey ez ob INPUT RUN WR.
 assert(V0:Mem.valid_block m ob)by(eapply Mem.perm_valid_block;apply(WR 0);lia).
 assert(WN:Mem.range_perm mn ob 0 1360 Cur Writable).
 { intros i R;apply(proj1(N.result_permissions _ _ _ _ _ _ _(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)ob i Cur Writable V0));apply WR;exact R. }
 assert(VN:Mem.valid_block mn ob)by(eapply Mem.perm_valid_block;apply(WN 0);lia).
 intros i R;apply(proj1(EI.result_permissions _ _ _ _ _ _ _(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)ob i Cur Writable VN));apply WN;exact R.
Qed.
Lemma copy_preserves_getter_input:forall me mb sb ob srcOfs dstOfs n bytes x y z,
 CopiedBytes me mb sb ob srcOfs dstOfs n bytes->G.InputGood me sb x y z->G.InputGood mb sb x y z.
Proof.
 intros me mb sb ob srcOfs dstOfs n bytes x y z COPY[SYM[WR[STATUS[X[Y ZS]]]]].
 split;[exact SYM|];split.
 - intros i R;apply(proj1(copy_permissions _ _ _ _ _ _ _ _ COPY sb i Cur Writable));apply WR;exact R.
 - rewrite(copy_source_loads _ _ _ _ _ _ _ _ COPY Mint16unsigned 280),
 (copy_source_loads _ _ _ _ _ _ _ _ COPY Mint32 296),
 (copy_source_loads _ _ _ _ _ _ _ _ COPY Mint32 300),
 (copy_source_loads _ _ _ _ _ _ _ _ COPY Mint32 304);auto.
Qed.
Lemma copy_writable:forall m mf sb ob srcOfs dstOfs n bytes,
 CopiedBytes m mf sb ob srcOfs dstOfs n bytes->
 Mem.range_perm m ob 0 1360 Cur Writable->Mem.range_perm mf ob 0 1360 Cur Writable.
Proof.
 intros m mf sb ob srcOfs dstOfs n bytes COPY WR i R.
 apply(proj1(copy_permissions _ _ _ _ _ _ _ _ COPY ob i Cur Writable));apply WR;exact R.
Qed.
Lemma getter_observer_writable:forall m mf sb x y z ob,
 G.GetterResult m mf sb x y z->Mem.range_perm m ob 0 1360 Cur Writable->
 Mem.range_perm mf ob 0 1360 Cur Writable.
Proof.
 intros m mf sb x y z ob RESULT WR i R;apply(proj1(G.result_permissions _ _ _ _ _ _ RESULT ob i Cur Writable));apply WR;exact R.
Qed.
Lemma subrange_readable:forall m b lo hi ofs n,
 Mem.range_perm m b lo hi Cur Writable->lo<=ofs->ofs+n<=hi->
 Mem.range_perm m b ofs(ofs+n)Cur Readable.
Proof. intros m b lo hi ofs n WR L H i R;eapply Mem.perm_implies;[apply WR;lia|exact perm_W_R]. Qed.
Lemma subrange_writable:forall m b lo hi ofs n,
 Mem.range_perm m b lo hi Cur Writable->lo<=ofs->ofs+n<=hi->
 Mem.range_perm m b ofs(ofs+n)Cur Writable.
Proof. intros m b lo hi ofs n WR L H i R;apply WR;lia. Qed.

Record CopyHistory(m mn me mb mg mk ma:mem)(sb ns es ob:block)(nx ny nz ex ey ez:int)(before bits after:list memval):Prop:={
 history_input:ProtocolInput m sb ns es nx ny nz ex ey ez;
 history_ned:N.NormalCall accepted_id ns m mn;
 history_ecef:EI.NormalCall accepted_id es mn me;
 history_before:CopiedBytes me mb sb ob 0 48 656 before;
 history_getter:G.NormalCall mb mg sb;
 history_getter_result:G.GetterResult mb mg sb nx ny nz;
 history_bits:CopiedBytes mg mk sb ob 328 36 12 bits;
 history_after:CopiedBytes mk ma sb ob 0 704 656 after;
 history_initial_observer_writable:Mem.range_perm m ob 0 1360 Cur Writable;
 history_observer_separate:sb<>ob;
 history_defined_before:defined_range mb sb 0 656;
 history_before_source:Mem.loadbytes mb sb 0 656=Some before;
 history_after_source:Mem.loadbytes mg sb 0 656=Some after;
 history_final_before:Mem.loadbytes ma ob 48 656=Some before;
 history_final_bits:Mem.loadbytes ma ob 36 12=Some(three_int_bytes(bits_of nx ny nz));
 history_final_after:Mem.loadbytes ma ob 704 656=Some after;
 history_final_state:forall ofs n,0<=n->Mem.loadbytes ma sb ofs n=Mem.loadbytes mg sb ofs n
}.
Theorem actual_observer_history:forall m sb ns es nx ny nz ex ey ez ob,
 InitialReady m sb ns es nx ny nz ex ey ez->
 Mem.range_perm m ob 0 1360 Cur Writable->sb<>ob->
 exists mn me mb mg mk ma before bits after,
 CopyHistory m mn me mb mg mk ma sb ns es ob nx ny nz ex ey ez before bits after.
Proof.
 intros m sb ns es nx ny nz ex ey ez ob READY OWR NE.
 pose proof(ready_protocol _ _ _ _ _ _ _ _ _ _ READY)as INPUT.
 destruct(actual_protocol _ _ _ _ _ _ _ _ _ _ INPUT)as[mn[me[mf0[RUN OBS]]]].
 pose proof(ecef_input_after_ned _ _ _ _ _ _ _ _ _ _ _ INPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN))as EINPUT.
 pose proof(getter_input_after_ecef _ _ _ _ _ _ _ _ _ _ _ _ EINPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT))as GINPUT.
 assert(STATEW:Mem.range_perm me sb 0 656 Cur Writable)by exact(proj1(proj2 GINPUT)).
 pose proof(protocol_observer_writable _ _ _ _ _ _ _ _ _ _ _ _ _ _ INPUT RUN OWR)as OWE.
 pose proof(subrange_readable me sb 0 656 0 656 STATEW ltac:(lia)ltac:(lia))as SR.
 destruct(Mem.range_perm_loadbytes _ _ _ _ SR)as[before BEFORE].
 destruct(observer_copy me sb ob 0 48 656 before ltac:(lia)NE SR
 (subrange_writable me ob 0 1360 48 656 OWE ltac:(lia)ltac:(lia))BEFORE)as[mb BCOPY].
 pose proof(copy_preserves_getter_input _ _ _ _ _ _ _ _ _ _ _ BCOPY GINPUT)as BINPUT.
 destruct(GO.original_normal_result mb sb nx ny nz BINPUT)as[mg[NORMAL[RESULT UNIQUE]]].
 pose proof(copy_writable _ _ _ _ _ _ _ _ BCOPY OWE)as OWB.
 pose proof(getter_observer_writable _ _ _ _ _ _ _ RESULT OWB)as OWG.
 assert(STATEWG:Mem.range_perm mg sb 0 656 Cur Writable).
 { intros i R;apply(proj1(G.result_permissions _ _ _ _ _ _ RESULT sb i Cur Writable));apply(proj1(proj2 BINPUT));exact R. }
 pose proof(G.result_bytes _ _ _ _ _ _ RESULT)as BITS.
 destruct(observer_copy mg sb ob 328 36 12(G.float_bytes nx ny nz)ltac:(lia)NE
 (subrange_readable mg sb 0 656 328 12 STATEWG ltac:(lia)ltac:(lia))
 (subrange_writable mg ob 0 1360 36 12 OWG ltac:(lia)ltac:(lia))BITS)as[mk KCOPY].
 pose proof(copy_writable _ _ _ _ _ _ _ _ KCOPY OWG)as OWK.
 assert(STATEWK:Mem.range_perm mk sb 0 656 Cur Writable).
 { intros i R;apply(proj1(copy_permissions _ _ _ _ _ _ _ _ KCOPY sb i Cur Writable));apply STATEWG;exact R. }
 pose proof(subrange_readable mk sb 0 656 0 656 STATEWK ltac:(lia)ltac:(lia))as SAR.
 destruct(Mem.range_perm_loadbytes _ _ _ _ SAR)as[after AFTER].
 destruct(observer_copy mk sb ob 0 704 656 after ltac:(lia)NE SAR
 (subrange_writable mk ob 0 1360 704 656 OWK ltac:(lia)ltac:(lia))AFTER)as[ma ACOPY].
 assert(DEFM:defined_range m sb 0 656).
 { exact(loadbytes_defined m sb 0 656 InitialMemory.initial_state_contents(initial_state_bytes _ _ _ _ _ _ _ _ _ _ READY)initial_contents_defined). }
 destruct(protocol_result_defined _ _ _ _ _ _ _ _ _ _ _ _ _ INPUT RUN DEFM)as[DEFME _].
 assert(DEFMB:defined_range mb sb 0 656).
 { intros i R;destruct(DEFME i R)as[octet BYTE];exists octet;rewrite(copy_source_bytes _ _ _ _ _ _ _ _ BCOPY i 1 ltac:(lia));exact BYTE. }
 exists mn,me,mb,mg,mk,ma,before,(G.float_bytes nx ny nz),after;constructor;auto.
 - exact(run_ned _ _ _ _ _ _ _ _ _ _ _ _ _ RUN).
 - exact(run_ecef _ _ _ _ _ _ _ _ _ _ _ _ _ RUN).
 - rewrite(copy_source_bytes _ _ _ _ _ _ _ _ BCOPY 0 656 ltac:(lia));exact BEFORE.
 - rewrite(copy_source_bytes _ _ _ _ _ _ _ _ KCOPY 0 656 ltac:(lia))in AFTER;exact AFTER.
 - rewrite(copy_other_bytes _ _ _ _ _ _ _ _ ACOPY ob 48 656 ltac:(lia))by(right;left;lia).
   rewrite(copy_other_bytes _ _ _ _ _ _ _ _ KCOPY ob 48 656 ltac:(lia))by(right;right;lia).
   rewrite(G.result_frame _ _ _ _ _ _ RESULT ob 48 656)by(first[lia|intros i R[EQ W];apply NE;congruence]).
   exact(copy_destination _ _ _ _ _ _ _ _ BCOPY).
 - rewrite(copy_other_bytes _ _ _ _ _ _ _ _ ACOPY ob 36 12 ltac:(lia))by(right;left;lia).
   rewrite <-complete_float_bit_bytes;exact(copy_destination _ _ _ _ _ _ _ _ KCOPY).
 - exact(copy_destination _ _ _ _ _ _ _ _ ACOPY).
 - intros ofs n NN;rewrite(copy_source_bytes _ _ _ _ _ _ _ _ ACOPY ofs n NN),
 (copy_source_bytes _ _ _ _ _ _ _ _ KCOPY ofs n NN);reflexivity.
Qed.
Theorem observer_history_nonvacuous:forall nx ny nz ex ey ez,
 exists mi m sb ns es ob mn me mb mg mk ma before bits after,
 Genv.init_mem InitialMemory.S.prog=Some mi /\
 CopyHistory m mn me mb mg mk ma sb ns es ob nx ny nz ex ey ez before bits after.
Proof.
 intros nx ny nz ex ey ez.
 destruct(initial_ready_from_program nx ny nz ex ey ez)as[mi[mN[mE[mNW[mEW[m0[sb[ns[es[INIT[AN[AE[SN[SE[FILTER READY]]]]]]]]]]]]]]].
 destruct(Mem.alloc m0 0 1360)as[m ob]eqn:ALLOC.
 destruct(ready_allocate_observer _ _ _ _ _ _ _ _ _ _ _ _ READY ALLOC)as[NEW[WR[NE REST]]].
 destruct(actual_observer_history _ _ _ _ _ _ _ _ _ _ _ NEW WR ltac:(congruence))as[mn[me[mb[mg[mk[ma[before[bits[after HISTORY]]]]]]]]].
 exists mi,m,sb,ns,es,ob,mn,me,mb,mg,mk,ma,before,bits,after;auto.
Qed.
Print Assumptions actual_observer_history.
Print Assumptions observer_history_nonvacuous.


Local Transparent Mem.loadbytes.
Lemma same_complete_bytes_cell:forall m1 m2 b1 b2 ofs1 ofs2 n bytes i,
 Mem.loadbytes m1 b1 ofs1 n=Some bytes->
 Mem.loadbytes m2 b2 ofs2 n=Some bytes->0<=i<n->
 Mem.loadbytes m1 b1(ofs1+i)1=Mem.loadbytes m2 b2(ofs2+i)1.
Proof.
 intros m1 m2 b1 b2 ofs1 ofs2 n bytes i A B RANGE.
 unfold Mem.loadbytes in A,B.
 destruct(Mem.range_perm_dec m1 b1 ofs1(ofs1+n)Cur Readable)as[R1|N1];try discriminate.
 destruct(Mem.range_perm_dec m2 b2 ofs2(ofs2+n)Cur Readable)as[R2|N2];try discriminate.
 injection A as A;injection B as B.
 assert(CELLS:nth_error(Mem.getN(Z.to_nat n)ofs1(PMap.get b1(Mem.mem_contents m1)))(Z.to_nat i)=
 nth_error(Mem.getN(Z.to_nat n)ofs2(PMap.get b2(Mem.mem_contents m2)))(Z.to_nat i))by congruence.
 rewrite!nth_getN in CELLS by(apply Nat2Z.inj_lt;rewrite!Z2Nat.id by lia;lia).
 rewrite!Z2Nat.id in CELLS by lia;injection CELLS as CELL.
 unfold Mem.loadbytes;rewrite!pred_dec_true by(intros j R;apply R1||apply R2;lia).
 change(Some[ZMap.get(ofs1+i)(PMap.get b1(Mem.mem_contents m1))]=Some[ZMap.get(ofs2+i)(PMap.get b2(Mem.mem_contents m2))]).
 rewrite CELL;reflexivity.
Qed.
Definition ObserverFrameCComparison(ma:mem)(ob:block):Prop:=
 forall i,0<=i<656->~(280<=i<282 \/328<=i<340)->
 exists v,Mem.load Mint8unsigned ma ob(48+i)=Some(Vint v) /\
 Mem.load Mint8unsigned ma ob(704+i)=Some(Vint v) /\
 Cop.sem_binary_operation G.ge Oeq(Vint v)tuchar(Vint v)tuchar ma=Some(Vint Int.one).
Theorem history_observer_c_comparison:forall m mn me mb mg mk ma sb ns es ob nx ny nz ex ey ez before bits after,
 CopyHistory m mn me mb mg mk ma sb ns es ob nx ny nz ex ey ez before bits after->
 ObserverFrameCComparison ma ob.
Proof.
 intros m mn me mb mg mk ma sb ns es ob nx ny nz ex ey ez before bits after HIST i R OUT.
 destruct(history_defined_before _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ HIST i R)as[octet BYTE].
 assert(GFRAME:Mem.loadbytes mg sb i 1=Some[Byte octet]).
 { rewrite(G.result_frame _ _ _ _ _ _(history_getter_result _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ HIST)sb i 1)by(intros;unfold G.write_byte in *;intuition lia);exact BYTE. }
 assert(OB:Mem.loadbytes ma ob(48+i)1=Some[Byte octet]).
 { rewrite <-(same_complete_bytes_cell mb ma sb ob 0 48 656 before i
 (history_before_source _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ HIST)
 (history_final_before _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ HIST)R).
   change(Mem.loadbytes mb sb i 1=Some[Byte octet]);exact BYTE. }
 assert(OA:Mem.loadbytes ma ob(704+i)1=Some[Byte octet]).
 { rewrite <-(same_complete_bytes_cell mg ma sb ob 0 704 656 after i
 (history_after_source _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ HIST)
 (history_final_after _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ HIST)R).
   change(Mem.loadbytes mg sb i 1=Some[Byte octet]);exact GFRAME. }
 exists(Int.zero_ext 8(Int.repr(decode_int[octet])));split.
 - exact(Mem.loadbytes_load Mint8unsigned ma ob(48+i)[Byte octet]OB(Z.divide_1_l _)).
 - split;[exact(Mem.loadbytes_load Mint8unsigned ma ob(704+i)[Byte octet]OA(Z.divide_1_l _))|].
   change(Some(Val.of_bool(Int.eq(Int.zero_ext 8(Int.repr(decode_int[octet])))(Int.zero_ext 8(Int.repr(decode_int[octet])))))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity.
Qed.
Print Assumptions history_observer_c_comparison.

Theorem observer_preparation:forall nx ny nz ex ey ez,
 exists mi m sb ns es ob mn me mb mg mk ma before bits after,
 Genv.init_mem InitialMemory.S.prog=Some mi /\
 CopyHistory m mn me mb mg mk ma sb ns es ob nx ny nz ex ey ez before bits after /\
 ObserverFrameCComparison ma ob.
Proof.
 intros;destruct(observer_history_nonvacuous nx ny nz ex ey ez)as[mi[m[sb[ns[es[ob[mn[me[mb[mg[mk[ma[before[bits[after[INIT HIST]]]]]]]]]]]]]]]].
 exists mi,m,sb,ns,es,ob,mn,me,mb,mg,mk,ma,before,bits,after;split;[exact INIT|];split;[exact HIST|].
 eapply history_observer_c_comparison;exact HIST.
Qed.
Theorem returned_pointer_c_comparison:forall m sb,
 Mem.range_perm m sb 0 656 Cur Writable->
 Cop.sem_binary_operation G.ge Oeq(Vptr sb(Ptrofs.repr 328))(tptr(Tstruct G.S._EcefCoor_f noattr))
 (Vptr sb(Ptrofs.repr 328))(tptr(Tstruct G.S._EcefCoor_f noattr))m=Some(Vint Int.one).
Proof.
 intros m sb WR.
 assert(V:Mem.valid_pointer m sb 328=true).
 { apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply WR;lia|exact(perm_any_N Writable)]. }
 assert(REPR:Ptrofs.unsigned(Ptrofs.repr 328)=328)by(vm_compute;reflexivity).
 unfold tptr;cbn[Cop.sem_binary_operation Cop.sem_cmp Cop.classify_cmp Cop.cmp_ptr Val.cmplu_bool Archi.ptr64].
 rewrite dec_eq_true,REPR,V;cbn;rewrite Ptrofs.eq_true;reflexivity.
Qed.
Print Assumptions observer_preparation.
Print Assumptions returned_pointer_c_comparison.
