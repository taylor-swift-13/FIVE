(* Generic memory proof reused unchanged from the retained omega BitsAdapter; source SHA256 87cceefde76314faeda151a5eb64d2f79dfb90ec0f72fc746d2ff8f066d28fca. No old program/model dependency. *)
From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csem.
Import ListNotations.
Local Open Scope Z_scope.
Record MemcpySafety (m:mem) (br bb:block) : Prop := {
 separated : br<>bb;
 src_live : Mem.valid_pointer m br 0=true;
 dst_end_live : Mem.weak_valid_pointer m bb 4=true;
 separated_rev : bb<>br;
 dst_live : Mem.valid_pointer m bb 0=true;
 src_end_live : Mem.weak_valid_pointer m br 4=true;
 nonoverlap : br<>bb \/ 0+4<=0 \/ 0+4<=0;
 src_readable : Mem.range_perm m br 0 4 Cur Readable;
 dst_writable : Mem.range_perm m bb 0 4 Cur Writable
}.
Lemma access_safety : forall m br bb,
 br<>bb -> Mem.valid_access m Mfloat32 br 0 Freeable ->
 Mem.valid_access m Mint32 bb 0 Freeable -> MemcpySafety m br bb.
Proof.
 intros m br bb DIFF [RP RA][BP BA]. 
 assert(R:Mem.range_perm m br 0 4 Cur Readable).
 { eapply Mem.range_perm_implies;[exact RP|constructor].  }
 assert(B:Mem.range_perm m bb 0 4 Cur Writable).
 { eapply Mem.range_perm_implies;[exact BP|constructor].  }
 constructor;auto.
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply R;lia|constructor]. 
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply B;change(0<=4-1<4);lia|constructor]. 
 - apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply B;lia|constructor]. 
 - apply Mem.weak_valid_pointer_spec;right;apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply R;change(0<=4-1<4);lia|constructor]. 
Qed.


Definition BitsObservation (ge:genv)(x:float32)(m:mem) : Prop :=
 exists ma br mb bb stored copied bytes,
 Mem.alloc m 0 4=(ma,br) /\ Mem.alloc ma 0 4=(mb,bb) /\
 Mem.store Mfloat32 mb br 0(Vsingle x)=Some stored /\
 MemcpySafety stored br bb /\
 Mem.loadbytes stored br 0 4=Some bytes /\ bytes=encode_val Mfloat32(Vsingle x) /\
 extcall_memcpy_sem 4 1 (Genv.to_senv(Csem.genv_genv ge))
 [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero]stored E0 Vundef copied /\
 Mem.loadbytes copied bb 0 4=Some bytes /\
 Mem.load Mint32 copied bb 0=Some(Vint(Float32.to_bits x)) /\
 Mem.loadbytes copied br 0 4=Some bytes.
Lemma bits_observation : forall ge x m,BitsObservation ge x m.
Proof.
 intros ge x m.
 destruct(Mem.alloc m 0 4)as[ma br]eqn:AR.
 destruct(Mem.alloc ma 0 4)as[mb bb]eqn:AB.
 assert(DIFF:br<>bb).
 { intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ AR)as V;rewrite EQ in V;exact(Mem.fresh_block_alloc _ _ _ _ _ AB V). }
 assert(RF:Mem.valid_access mb Mfloat32 br 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AB|]. eapply Mem.valid_access_alloc_same;[exact AR|lia|change(0+4<=4);lia|exists 0;reflexivity].  }
 assert(BF:Mem.valid_access mb Mint32 bb 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AB|lia|change(0+4<=4);lia|exists 0;reflexivity].  }
 destruct(Mem.valid_access_store mb Mfloat32 br 0(Vsingle x)(Mem.valid_access_freeable_any _ _ _ _ _ RF))as[stored STORE]. 
 assert(SAFE:MemcpySafety stored br bb).
 { apply access_safety;auto;eapply Mem.store_valid_access_1;eauto. }
 assert(READ:Mem.loadbytes stored br 0 4=Some(encode_val Mfloat32(Vsingle x))).
 { change(Mem.loadbytes stored br 0(size_chunk Mfloat32)=Some(encode_val Mfloat32(Vsingle x)));eapply Mem.loadbytes_store_same;exact STORE. }
 assert(WRITE:Mem.range_perm stored bb 0 (0+Z.of_nat(length(encode_val Mfloat32(Vsingle x))))Cur Writable).
 { rewrite encode_val_length;change(Mem.range_perm stored bb 0 4 Cur Writable);exact(dst_writable _ _ _ SAFE). }
 destruct(Mem.range_perm_storebytes _ _ _ _ WRITE)as[copied COPY]. 
 assert(BYTES:Mem.loadbytes copied bb 0 4=Some(encode_val Mfloat32(Vsingle x))).
 { pose proof(Mem.loadbytes_storebytes_same _ _ _ _ _ COPY)as E;rewrite encode_val_length in E;exact E. }
 assert(LOAD:Mem.load Mint32 copied bb 0=Some(Vint(Float32.to_bits x))).
 { pose proof(Mem.loadbytes_load Mint32 copied bb 0 _ BYTES(ex_intro _ 0 eq_refl))as E.
   pose proof(decode_encode_val_general(Vsingle x)Mfloat32 Mint32)as DE.
   change(decode_val Mint32(encode_val Mfloat32(Vsingle x))=Vint(Float32.to_bits x))in DE.
   rewrite DE in E;exact E. }
 unfold BitsObservation;exists ma,br,mb,bb,stored,copied,(encode_val Mfloat32(Vsingle x)).
 split;[exact AR|]. split;[exact AB|]. split;[exact STORE|]. split;[exact SAFE|]. split;[exact READ|]. split;[reflexivity|]. split.
 - econstructor;try rewrite Ptrofs.unsigned_zero;try exact READ;try exact COPY;try(left;reflexivity);try lia;try(exists 4;reflexivity);try(intros;exists 0;reflexivity);left;exact DIFF.
 - split;[exact BYTES|]. split;[exact LOAD|]. 
   erewrite Mem.loadbytes_storebytes_other;[exact READ|exact COPY|lia|left;exact DIFF]. 
Qed.
Print Assumptions bits_observation.

From compcert Require Import Cop Csyntax Csyntaxdefs Smallstep.
Require FiveShared.compcert_libc.Library.
Module Lib:=FiveShared.compcert_libc.Library.
Definition BitsRun(ge:genv)(x:float32)(m mf:mem)(result:int):Prop:=
 exists ma br mb bb stored bytes,
 Mem.alloc m 0 4=(ma,br) /\Mem.alloc ma 0 4=(mb,bb) /\
 Mem.store Mfloat32 mb br 0(Vsingle x)=Some stored /\MemcpySafety stored br bb /\
 Mem.loadbytes stored br 0 4=Some bytes /\bytes=encode_val Mfloat32(Vsingle x) /\
 Lib.official_memcpy(Genv.to_senv(Csem.genv_genv ge))
 [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero;Vlong(Int64.repr 4)]stored E0(Vptr bb Ptrofs.zero)mf /\
 Mem.loadbytes mf bb 0 4=Some bytes /\Mem.load Mint32 mf bb 0=Some(Vint result) /\
 result=Float32.to_bits x /\Mem.loadbytes mf br 0 4=Some bytes.
Theorem bits_run_exists:forall ge x m,exists mf,BitsRun ge x m mf(Float32.to_bits x).
Proof.
 intros ge x m;destruct(bits_observation ge x m)
 as(ma&br&mb&bb&stored&copied&bytes&AR&AB&ST&SAFE&READ&ENC&COPY&BYTES&LOAD&SOURCE).
 exists copied;unfold BitsRun;exists ma,br,mb,bb,stored,bytes.
 split;[exact AR|]. split;[exact AB|]. split;[exact ST|]. split;[exact SAFE|].
 split;[exact READ|]. split;[exact ENC|]. split.
 - eapply Lib.official_memcpy_intro.
   + unfold Lib.disjoint;left;exact(separated_rev _ _ _ SAFE).
   + change(extcall_memcpy_sem 4 1(Genv.to_senv(Csem.genv_genv ge))
      [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero]stored E0 Vundef copied);exact COPY.
 - split;[exact BYTES|]. split;[exact LOAD|]. split;[reflexivity|exact SOURCE].
Qed.
Definition int32_test(a b:int):expr:=Ebinop Oeq(Eval(Vint a)tuint)(Eval(Vint b)tuint)tint.
Definition Int32AssertionTrue(ge:genv)(a b:int)(m:mem):Prop:=
 sem_binary_operation ge Oeq(Vint a)tuint(Vint b)tuint m=Some(Vint Int.one) /\
 forall f k e,star Csem.step ge(ExprState f(int32_test a b)k e m)E0
 (ExprState f(Eval(Vint Int.one)tint)k e m).
Lemma int32_assertion_true:forall ge a b m,a=b->Int32AssertionTrue ge a b m.
Proof.
 intros ge a b m EQ;subst b.
 assert(OP:sem_binary_operation ge Oeq(Vint a)tuint(Vint a)tuint m=Some(Vint Int.one)).
 { change(Some(Val.of_bool(Int.eq a a))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity. }
 split;[exact OP|]. intros f k e;apply star_one;left.
 unfold int32_test;eapply step_rred with(C:=fun x=>x);[apply red_binop;exact OP|apply ctx_top].
Qed.
Definition CopiedBitsEqual(ge:genv)(actual expected:float32)(m:mem):Prop:=
 exists m1 m2,BitsRun ge actual m m1(Float32.to_bits actual) /\
 BitsRun ge expected m1 m2(Float32.to_bits expected) /\
 Int32AssertionTrue ge(Float32.to_bits actual)(Float32.to_bits expected)m2.
Definition CopiedBitsEqualBothOrders(ge:genv)(actual expected:float32)(m:mem):Prop:=
 CopiedBitsEqual ge actual expected m /\CopiedBitsEqual ge expected actual m.
Theorem copied_bits_equal:forall ge actual expected m,
 Float32.to_bits actual=Float32.to_bits expected->CopiedBitsEqualBothOrders ge actual expected m.
Proof.
 intros ge actual expected m EQ;split;unfold CopiedBitsEqual.
 - destruct(bits_run_exists ge actual m)as[m1 A];destruct(bits_run_exists ge expected m1)as[m2 B].
   exists m1,m2;split;[exact A|]. split;[exact B|]. apply int32_assertion_true;exact EQ.
 - destruct(bits_run_exists ge expected m)as[m1 A];destruct(bits_run_exists ge actual m1)as[m2 B].
   exists m1,m2;split;[exact A|]. split;[exact B|]. apply int32_assertion_true;symmetry;exact EQ.
Qed.
Definition int64_test(a b:int64):expr:=Ebinop Oeq(Eval(Vlong a)tlong)(Eval(Vlong b)tlong)tint.
Definition Int64AssertionTrue(ge:genv)(a b:int64)(m:mem):Prop:=
 sem_binary_operation ge Oeq(Vlong a)tlong(Vlong b)tlong m=Some(Vint Int.one) /\
 forall f k e,star Csem.step ge(ExprState f(int64_test a b)k e m)E0
 (ExprState f(Eval(Vint Int.one)tint)k e m).
Lemma int64_assertion_true:forall ge a b m,a=b->Int64AssertionTrue ge a b m.
Proof.
 intros ge a b m EQ;subst b.
 assert(OP:sem_binary_operation ge Oeq(Vlong a)tlong(Vlong a)tlong m=Some(Vint Int.one)).
 { change(Some(Val.of_bool(Int64.eq a a))=Some(Vint Int.one));rewrite Int64.eq_true;reflexivity. }
 split;[exact OP|]. intros f k e;apply star_one;left.
 unfold int64_test;eapply step_rred with(C:=fun x=>x);[apply red_binop;exact OP|apply ctx_top].
Qed.
Print Assumptions copied_bits_equal.
Print Assumptions int64_assertion_true.
Theorem bits_run_old_frame:forall ge x m mf result,BitsRun ge x m mf result->
 (forall ch b ofs,Mem.valid_block m b->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b->0<=n->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros ge x m mf result(ma&br&mb&bb&stored&bytes&AR&AB&ST&SAFE&READ&ENC&OFF&BYTES&LOAD&RESULT&SOURCE).
 assert(SRC:forall b,Mem.valid_block m b->b<>br).
 { intros b VB EQ;subst b;exact(Mem.fresh_block_alloc _ _ _ _ _ AR VB). }
 assert(DST:forall b,Mem.valid_block m b->b<>bb).
 { intros b VB EQ;subst b;eapply Mem.fresh_block_alloc;[exact AB|eapply Mem.valid_block_alloc;eauto]. }
 apply(proj2(Lib.memcpy_spec_is_official _ _ _ _ _ _))in OFF.
 inversion OFF;subst;rewrite ?Ptrofs.unsigned_zero in *.
 split.
 - intros ch b ofs VB.
   match goal with COPY:Mem.storebytes stored bb _ _=Some mf|-_=>
    erewrite Mem.load_storebytes_other by(exact COPY||(left;apply DST;exact VB))end.
   erewrite Mem.load_store_other by(exact ST||(left;apply SRC;exact VB)).
   erewrite Mem.load_alloc_unchanged by(exact AB||eapply Mem.valid_block_alloc;eauto).
   eapply Mem.load_alloc_unchanged;eauto.
 - intros b ofs n VB N.
   match goal with COPY:Mem.storebytes stored bb _ _=Some mf|-_=>
    erewrite Mem.loadbytes_storebytes_other by(exact COPY||lia||(left;apply DST;exact VB))end.
   erewrite Mem.loadbytes_store_other by(exact ST||(left;apply SRC;exact VB)).
   erewrite Mem.loadbytes_alloc_unchanged by(exact AB||eapply Mem.valid_block_alloc;eauto).
   eapply Mem.loadbytes_alloc_unchanged;eauto.
Qed.
Print Assumptions bits_run_old_frame.
Theorem bits_run_old_valid:forall ge x m mf result,BitsRun ge x m mf result->
 forall b,Mem.valid_block m b->Mem.valid_block mf b.
Proof.
 intros ge x m mf result(ma&br&mb&bb&stored&bytes&AR&AB&ST&SAFE&READ&ENC&OFF&BYTES&LOAD&RESULT&SOURCE)b VB.
 apply(proj2(Lib.memcpy_spec_is_official _ _ _ _ _ _))in OFF.
 inversion OFF;subst;rewrite ?Ptrofs.unsigned_zero in *.
 match goal with COPY:Mem.storebytes stored bb _ _=Some mf|-_=>
 eapply Mem.storebytes_valid_block_1;[exact COPY|]end.
 eapply Mem.store_valid_block_1;[exact ST|].
 eapply Mem.valid_block_alloc;[exact AB|]. eapply Mem.valid_block_alloc;[exact AR|exact VB].
Qed.
