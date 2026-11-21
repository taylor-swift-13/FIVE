
From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Memdata Globalenvs Ctypes Csyntax Csyntaxdefs Csem.
From StateSpeedGetEcefF Require Import Source Execution.
From StateSpeedMemory Require Import MemoryLayout.
Import ListNotations.
Open Scope Z_scope.
Module S:=StateSpeedGetEcefF.Source.
Module E:=StateSpeedGetEcefF.Execution.

Fixpoint variables_of(defs:list(ident*globdef Csyntax.fundef type)):list(ident*globvar type):=
 match defs with
 | []=>[]
 | (id,Gfun _)::rest=>variables_of rest
 | (id,Gvar v)::rest=>(id,v)::variables_of rest end.
Lemma variable_in_projection:forall defs id v,
 In(id,Gvar v)defs->In(id,v)(variables_of defs).
Proof.
 induction defs as[|[name[fn|gv]]rest IH];simpl;intros id v IN;try contradiction;
 destruct IN as[EQ|IN];try discriminate;auto;inversion EQ;subst;auto.
Qed.
Lemma only_state_variable:forall id v,In(id,Gvar v)S.global_definitions->id=S._state /\ v=S.v_state.
Proof.
 intros id v IN;apply variable_in_projection in IN.
 change(In(id,v)[(S._state,S.v_state)])in IN.
 destruct IN as[EQ|[]];inversion EQ;auto.
Qed.
Theorem actual_init_mem_exists:exists m,Genv.init_mem S.prog=Some m.
Proof.
 apply Genv.init_mem_exists;intros id v IN.
 change(In(id,Gvar v)S.global_definitions)in IN.
 destruct(only_state_variable _ _ IN)as[ID V];subst;split.
 - cbn[Genv.init_data_list_aligned S.v_state];split;[apply Z.divide_1_l|exact I].
 - intros i o ADDR;cbn[S.v_state]in ADDR;destruct ADDR as[EQ|[]];discriminate.
Qed.

Lemma repeat_app_inverse:forall(A:Type)(x:A)left n right,
 repeat x n=left++right->
 left=repeat x(length left) /\ right=repeat x(n-length left).
Proof.
 intros A x left;induction left as[|a left IH];intros n right EQ;simpl in *.
 - split;[reflexivity|rewrite Nat.sub_0_r;symmetry;exact EQ].
 - destruct n;[discriminate|]. simpl in EQ;inversion EQ;subst a.
   destruct(IH n right H1)as[L R];split;[simpl;f_equal;exact L|exact R].
Qed.
Lemma zero_bytes_split:forall m b ofs n1 n2,
 0<=n1->0<=n2->
 Mem.loadbytes m b ofs(n1+n2)=Some(repeat(Byte Byte.zero)(Z.to_nat(n1+n2)))->
 Mem.loadbytes m b ofs n1=Some(repeat(Byte Byte.zero)(Z.to_nat n1)) /\
 Mem.loadbytes m b(ofs+n1)n2=Some(repeat(Byte Byte.zero)(Z.to_nat n2)).
Proof.
 intros m b ofs n1 n2 NN1 NN2 LOAD.
 destruct(Mem.loadbytes_split _ _ _ _ _ _ LOAD ltac:(lia)ltac:(lia))as[l[r[LL[LR EQ]]]].
 pose proof(Mem.loadbytes_length _ _ _ _ _ LL)as LEN.
 destruct(repeat_app_inverse _ _ l _ r EQ)as[L R].
 rewrite LEN in L,R;rewrite Z2Nat.inj_add in R by lia.
 replace(Z.to_nat n1+Z.to_nat n2-Z.to_nat n1)%nat with(Z.to_nat n2)in R by lia.
 subst l;subst r;auto.
Qed.

Definition zero_variable(ty:type):globvar type:=
 {|gvar_info:=ty;gvar_init:=[Init_space 656];gvar_readonly:=false;gvar_volatile:=false|}.
Lemma initialized_zero_variable:forall(p:AST.program Csyntax.fundef type)m sb ty,
 Genv.find_var_info(Genv.globalenv p)sb=Some(zero_variable ty)->
 Genv.init_mem p=Some m->
 Mem.range_perm m sb 0 656 Cur Writable /\
 Genv.read_as_zero m sb 0 656 /\
 Mem.loadbytes m sb 0 656=Some(repeat(Byte Byte.zero)656).
Proof.
 intros p m sb ty INFO INIT.
 destruct(Genv.init_mem_characterization p sb INFO INIT)as[PERM[_[ZERO BYTES]]].
 cbn[zero_variable Genv.perm_globvar init_data_list_size]in PERM.
 split;[exact PERM|].
 specialize(ZERO eq_refl);specialize(BYTES eq_refl).
 cbn[zero_variable Genv.load_store_init_data]in ZERO.
 destruct ZERO as[ZERO _];split;[exact ZERO|].
 cbn[zero_variable Genv.bytes_of_init_data_list Genv.bytes_of_init_data]in BYTES.
 exact BYTES.
Qed.
Lemma actual_state_info:forall sb,
 Genv.find_symbol E.ge S._state=Some sb->
 Genv.find_var_info(Genv.globalenv S.prog)sb=Some(zero_variable(Tstruct S._State noattr)).
Proof. intros sb SYM;lazy in SYM;inversion SYM;subst sb;lazy;reflexivity. Qed.
Theorem actual_initial_state:forall m sb,
 Genv.init_mem S.prog=Some m->
 Genv.find_symbol E.ge S._state=Some sb->
 Mem.range_perm m sb 0 656 Cur Writable /\
 Genv.read_as_zero m sb 0 656 /\
 Mem.loadbytes m sb 0 656=Some(repeat(Byte Byte.zero)656).
Proof.
 intros m sb INIT SYMBOL.
 exact(initialized_zero_variable S.prog m sb(Tstruct S._State noattr)(actual_state_info sb SYMBOL)INIT).
Qed.

Definition Words(m:mem)(b:block)(x y z:int):Prop:=
 Mem.load Mint32 m b 0=Some(Vint x) /\
 Mem.load Mint32 m b 4=Some(Vint y) /\
 Mem.load Mint32 m b 8=Some(Vint z).
Definition store_words(m:mem)(b:block)(x y z:int):option mem:=
 match Mem.store Mint32 m b 0(Vint x)with None=>None|Some m1=>
 match Mem.store Mint32 m1 b 4(Vint y)with None=>None|Some m2=>
 Mem.store Mint32 m2 b 8(Vint z)end end.
Lemma store_permissions:forall ch m b ofs v m',
 Mem.store ch m b ofs v=Some m'->
 forall bb oo k p,Mem.perm m bb oo k p<->Mem.perm m' bb oo k p.
Proof. intros;split;[eapply Mem.perm_store_1|eapply Mem.perm_store_2];eauto. Qed.
Lemma store_range:forall ch m b ofs v m' bb lo hi,
 Mem.store ch m b ofs v=Some m'->
 Mem.range_perm m bb lo hi Cur Writable->Mem.range_perm m' bb lo hi Cur Writable.
Proof. intros ch m b ofs v m' bb lo hi STORE RP o RANGE;eapply Mem.perm_store_1;eauto. Qed.
Lemma writable_word:forall m b ofs,
 Mem.range_perm m b 0 12 Cur Writable->
 0<=ofs->ofs+4<=12->(4|ofs)->Mem.valid_access m Mint32 b ofs Writable.
Proof. intros;split;[intros o RANGE;apply H;simpl in RANGE;lia|exact H2]. Qed.
Lemma store_words_exists:forall m b x y z,
 Mem.range_perm m b 0 12 Cur Writable->
 exists m',store_words m b x y z=Some m'.
Proof.
 intros m b x y z RP.
 destruct(Mem.valid_access_store m Mint32 b 0(Vint x)(writable_word m b 0 RP ltac:(lia)ltac:(lia)ltac:(exists 0;reflexivity)))as[m1 S1].
 assert(R1:Mem.range_perm m1 b 0 12 Cur Writable)by(eapply store_range;eauto).
 destruct(Mem.valid_access_store m1 Mint32 b 4(Vint y)(writable_word m1 b 4 R1 ltac:(lia)ltac:(lia)ltac:(exists 1;reflexivity)))as[m2 S2].
 assert(R2:Mem.range_perm m2 b 0 12 Cur Writable)by(eapply store_range;eauto).
 destruct(Mem.valid_access_store m2 Mint32 b 8(Vint z)(writable_word m2 b 8 R2 ltac:(lia)ltac:(lia)ltac:(exists 2;reflexivity)))as[m3 S3].
 exists m3;unfold store_words;rewrite S1,S2;exact S3.
Qed.
Lemma store_words_spec:forall m b x y z m',
 store_words m b x y z=Some m'->
 Words m' b x y z /\
 (forall bb oo k p,Mem.perm m bb oo k p<->Mem.perm m' bb oo k p) /\
 (forall ch bb oo,bb<>b->Mem.load ch m' bb oo=Mem.load ch m bb oo) /\
 (forall bb oo n,bb<>b->Mem.loadbytes m' bb oo n=Mem.loadbytes m bb oo n).
Proof.
 intros m b x y z m' STORE;unfold store_words in STORE.
 destruct(Mem.store Mint32 m b 0(Vint x))as[m1|]eqn:S1;try discriminate.
 destruct(Mem.store Mint32 m1 b 4(Vint y))as[m2|]eqn:S2;try discriminate.
 split.
 - unfold Words;repeat split.
   + erewrite Mem.load_store_other by(eauto;right;left;simpl;lia).
     erewrite Mem.load_store_other by(eauto;right;left;simpl;lia).
     erewrite Mem.load_store_same by eauto;reflexivity.
   + erewrite Mem.load_store_other by(eauto;right;left;simpl;lia).
     erewrite Mem.load_store_same by eauto;reflexivity.
   + erewrite Mem.load_store_same by eauto;reflexivity.
 - split.
   + intros;rewrite(store_permissions _ _ _ _ _ _ S1),(store_permissions _ _ _ _ _ _ S2).
     apply(store_permissions _ _ _ _ _ _ STORE).
   + split;intros.
     * erewrite Mem.load_store_other by(eauto;left;assumption).
       erewrite Mem.load_store_other by(eauto;left;assumption).
       erewrite Mem.load_store_other by(eauto;left;assumption);reflexivity.
     * erewrite Mem.loadbytes_store_other by(eauto;left;assumption).
       erewrite Mem.loadbytes_store_other by(eauto;left;assumption).
       erewrite Mem.loadbytes_store_other by(eauto;left;assumption);reflexivity.
Qed.

Definition initial_state_contents:list memval:=
 repeat(Byte Byte.zero)282++[Byte(Byte.repr 255);Byte(Byte.repr 255)]++repeat(Byte Byte.zero)372.
Definition any_filter:int:=Int.repr 65535.
Lemma any_filter_encoding:encode_val Mint16unsigned(Vint any_filter)=[Byte(Byte.repr 255);Byte(Byte.repr 255)].
Proof.
 assert(B:Byte.repr 65535=Byte.repr 255)by(apply Byte.same_if_eq;vm_compute;reflexivity).
 change([Byte(Byte.repr 65535);Byte(Byte.repr 255)]=[Byte(Byte.repr 255);Byte(Byte.repr 255)]).
 rewrite B;reflexivity.
Qed.
Record InitialReady(m:mem)(sb nsrc esrc:block)(nx ny nz ex ey ez:int):Prop:={
 getter_state_symbol:Genv.find_symbol E.ge S._state=Some sb;
 rangeStateWritable:Mem.range_perm m sb 0 656 Cur Writable;
 loadfilterANY:Mem.load Mint16unsigned m sb 282=Some(Vint any_filter);
 typedsourcewordsN:Words m nsrc nx ny nz;
 typedsourcewordsE:Words m esrc ex ey ez;
 nsrc_ne_state:nsrc<>sb;
 esrc_ne_state:esrc<>sb;
 sources_distinct:nsrc<>esrc;
 initial_state_bytes:Mem.loadbytes m sb 0 656=Some initial_state_contents;
 initial_status_zero:Mem.load Mint16unsigned m sb 280=Some(Vint Int.zero);
 rangeNWritable:Mem.range_perm m nsrc 0 12 Cur Writable;
 rangeEWritable:Mem.range_perm m esrc 0 12 Cur Writable
}.
Lemma set_filter_exists:forall m sb,
 Mem.range_perm m sb 0 656 Cur Writable->
 Mem.loadbytes m sb 0 656=Some(repeat(Byte Byte.zero)656)->
 Mem.load Mint16unsigned m sb 280=Some(Vint Int.zero)->
 exists mf,Mem.store Mint16unsigned m sb 282(Vint any_filter)=Some mf /\
 Mem.range_perm mf sb 0 656 Cur Writable /\
 Mem.load Mint16unsigned mf sb 282=Some(Vint any_filter) /\
 Mem.load Mint16unsigned mf sb 280=Some(Vint Int.zero) /\
 Mem.loadbytes mf sb 0 656=Some initial_state_contents.
Proof.
 intros m sb RP ZERO STATUS.
 assert(ACCESS:Mem.valid_access m Mint16unsigned sb 282 Writable).
 { split;[intros o RANGE;apply RP;simpl in RANGE;lia|exists 141;reflexivity]. }
 destruct(Mem.valid_access_store _ _ _ _ (Vint any_filter)ACCESS)as[mf STORE].
 assert(ZERO':Mem.loadbytes m sb 0(282+374)=Some(repeat(Byte Byte.zero)(Z.to_nat(282+374))))by exact ZERO.
 destruct(zero_bytes_split m sb 0 282 374 ltac:(lia)ltac:(lia)ZERO')as[PREFIX TAIL].
 assert(TAIL':Mem.loadbytes m sb 282(2+372)=Some(repeat(Byte Byte.zero)(Z.to_nat(2+372))))by exact TAIL.
 destruct(zero_bytes_split m sb 282 2 372 ltac:(lia)ltac:(lia)TAIL')as[_ SUFFIX].
 assert(PREFIX':Mem.loadbytes mf sb 0 282=Some(repeat(Byte Byte.zero)282)).
 { erewrite Mem.loadbytes_store_other by(eauto;right;right;left;lia);exact PREFIX. }
 assert(SUFFIX':Mem.loadbytes mf sb 284 372=Some(repeat(Byte Byte.zero)372)).
 { erewrite Mem.loadbytes_store_other by(eauto;right;right;right;simpl;lia);exact SUFFIX. }
 assert(FILTER:Mem.loadbytes mf sb 282 2=Some[Byte(Byte.repr 255);Byte(Byte.repr 255)]).
 { pose proof(Mem.loadbytes_store_same _ _ _ _ _ _ STORE)as BYTES.
   rewrite any_filter_encoding in BYTES;exact BYTES. }
 assert(NEWTAIL:Mem.loadbytes mf sb 282 374=Some([Byte(Byte.repr 255);Byte(Byte.repr 255)]++repeat(Byte Byte.zero)372)).
 { exact(Mem.loadbytes_concat _ _ _ _ _ _ _ FILTER SUFFIX' ltac:(lia)ltac:(lia)). }
 assert(WHOLE:Mem.loadbytes mf sb 0 656=Some initial_state_contents).
 { exact(Mem.loadbytes_concat _ _ _ _ _ _ _ PREFIX' NEWTAIL ltac:(lia)ltac:(lia)). }
 exists mf;split;[exact STORE|];split;[eapply store_range;eauto|].
 split;[erewrite Mem.load_store_same by eauto;vm_compute;reflexivity|].
 split;[erewrite Mem.load_store_other by(eauto;right;left;simpl;lia);exact STATUS|exact WHOLE].
Qed.
Lemma allocation_writable:forall m m' b,
 Mem.alloc m 0 12=(m',b)->Mem.range_perm m' b 0 12 Cur Writable.
Proof. intros m m' b ALLOC o RANGE;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;eauto|constructor]. Qed.
Lemma range_allocate:forall m lo hi m' b bb a z,
 Mem.alloc m lo hi=(m',b)->Mem.range_perm m bb a z Cur Writable->
 Mem.range_perm m' bb a z Cur Writable.
Proof. intros m lo hi m' b bb a z ALLOC RP o RANGE;eapply Mem.perm_alloc_1;eauto. Qed.

Theorem initial_ready_from_program:forall nx ny nz ex ey ez,
 exists m0 mN mE mNW mEW m sb nsrc esrc,
 Genv.init_mem S.prog=Some m0 /\
 Mem.alloc m0 0 12=(mN,nsrc) /\
 Mem.alloc mN 0 12=(mE,esrc) /\
 store_words mE nsrc nx ny nz=Some mNW /\
 store_words mNW esrc ex ey ez=Some mEW /\
 Mem.store Mint16unsigned mEW sb 282(Vint any_filter)=Some m /\
 InitialReady m sb nsrc esrc nx ny nz ex ey ez.
Proof.
 intros nx ny nz ex ey ez.
 destruct actual_init_mem_exists as[m0 INIT].
 destruct MemoryLayout.common_state_block as[sb[_[_ SYM]]].
 destruct(actual_initial_state _ _ INIT SYM)as[RP[READZERO ZERO]].
 assert(SBVALID:Mem.valid_block m0 sb).
 { eapply Mem.perm_valid_block;apply(RP 0);lia. }
 destruct(Mem.alloc m0 0 12)as[mN nsrc]eqn:AN.
 destruct(Mem.alloc mN 0 12)as[mE esrc]eqn:AE.
 assert(NNE:nsrc<>sb).
 { intro EQ;subst nsrc;eapply(Mem.fresh_block_alloc _ _ _ _ _ AN);exact SBVALID. }
 assert(SBVALIDN:Mem.valid_block mN sb)by(eapply Mem.valid_block_alloc;eauto).
 assert(ENE:esrc<>sb).
 { intro EQ;subst esrc;eapply(Mem.fresh_block_alloc _ _ _ _ _ AE);exact SBVALIDN. }
 assert(NVALID:Mem.valid_block mN nsrc)by(eapply Mem.valid_new_block;eauto).
 assert(NEDIFF:nsrc<>esrc).
 { intro EQ;subst esrc;eapply(Mem.fresh_block_alloc _ _ _ _ _ AE);exact NVALID. }
 assert(NRANGE:Mem.range_perm mE nsrc 0 12 Cur Writable).
 { eapply range_allocate;[exact AE|eapply allocation_writable;exact AN]. }
 assert(ERANGE:Mem.range_perm mE esrc 0 12 Cur Writable)by(eapply allocation_writable;exact AE).
 assert(SRANGE:Mem.range_perm mE sb 0 656 Cur Writable)by(eapply range_allocate;eauto;eapply range_allocate;eauto).
 assert(ZEROE:Mem.loadbytes mE sb 0 656=Some(repeat(Byte Byte.zero)656)).
 { erewrite Mem.loadbytes_alloc_unchanged by(eauto).
   erewrite Mem.loadbytes_alloc_unchanged by(eauto);exact ZERO. }
 assert(STATUS0:Mem.load Mint16unsigned m0 sb 280=Some(Vint Int.zero)).
 { apply(READZERO Mint16unsigned 280);[lia|simpl;lia|exists 140;reflexivity]. }
 assert(STATUSE:Mem.load Mint16unsigned mE sb 280=Some(Vint Int.zero)).
 { eapply Mem.load_alloc_other;[exact AE|eapply Mem.load_alloc_other;[exact AN|exact STATUS0]]. }
 destruct(store_words_exists _ _ nx ny nz NRANGE)as[mNW SN].
 destruct(store_words_spec _ _ _ _ _ _ SN)as[NWORDS[NPERM[NLOAD NBYTES]]].
 assert(ERN:Mem.range_perm mNW esrc 0 12 Cur Writable).
 { intros o RANGE;apply(NPERM esrc o Cur Writable);apply ERANGE;exact RANGE. }
 destruct(store_words_exists _ _ ex ey ez ERN)as[mEW SE].
 destruct(store_words_spec _ _ _ _ _ _ SE)as[EWORDS[EPERM[ELOAD EBYTES]]].
 assert(SRW:Mem.range_perm mEW sb 0 656 Cur Writable).
 { intros o RANGE;apply(EPERM sb o Cur Writable);apply(NPERM sb o Cur Writable);apply SRANGE;exact RANGE. }
 assert(ZEROW:Mem.loadbytes mEW sb 0 656=Some(repeat(Byte Byte.zero)656)).
 { rewrite EBYTES by congruence;rewrite NBYTES by congruence;exact ZEROE. }
 assert(STATUSW:Mem.load Mint16unsigned mEW sb 280=Some(Vint Int.zero)).
 { rewrite ELOAD by congruence;rewrite NLOAD by congruence;exact STATUSE. }
 destruct(set_filter_exists _ _ SRW ZEROW STATUSW)as[m[FILTER[SRFINAL[ANY[STATUS BYTES]]]]].
 exists m0,mN,mE,mNW,mEW,m,sb,nsrc,esrc;repeat split;auto.
 constructor;auto.
 - unfold Words in *;destruct NWORDS as[NX[NY NZ]];repeat split;
   erewrite Mem.load_store_other by(eauto;left;congruence);
   rewrite ELOAD by congruence;assumption.
 - unfold Words in *;destruct EWORDS as[EX[EY EZ]];repeat split;
   erewrite Mem.load_store_other by(eauto;left;congruence);assumption.
 - intros o RANGE;eapply Mem.perm_store_1;[exact FILTER|].
   apply(EPERM nsrc o Cur Writable);apply(NPERM nsrc o Cur Writable);apply NRANGE;exact RANGE.
 - intros o RANGE;eapply Mem.perm_store_1;[exact FILTER|].
   apply(EPERM esrc o Cur Writable);apply ERN;exact RANGE.
Qed.
Theorem initial_ready_exists:forall nx ny nz ex ey ez,
 exists m sb nsrc esrc,InitialReady m sb nsrc esrc nx ny nz ex ey ez.
Proof.
 intros;destruct(initial_ready_from_program nx ny nz ex ey ez)as[m0[mN[mE[mNW[mEW[m[sb[nsrc[esrc[_[_[_[_[_[_ READY]]]]]]]]]]]]]]].
 eauto.
Qed.
Print Assumptions actual_init_mem_exists.
Print Assumptions initial_ready_from_program.
Print Assumptions initial_ready_exists.
