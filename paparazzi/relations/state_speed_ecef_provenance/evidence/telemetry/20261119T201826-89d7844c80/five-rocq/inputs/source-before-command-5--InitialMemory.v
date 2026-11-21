
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
Theorem actual_initial_state:forall m sb,
 Genv.init_mem S.prog=Some m->
 Genv.find_symbol E.ge S._state=Some sb->
 Mem.range_perm m sb 0 656 Cur Writable /\
 Genv.read_as_zero m sb 0 656 /\
 Mem.loadbytes m sb 0 656=Some(repeat(Byte Byte.zero)656).
Proof.
 intros m sb INIT SYMBOL.
 destruct(MemoryLayout.actual_state_variable_information sb SYMBOL)as[_[_ INFO]].
 change(Genv.find_var_info(Genv.globalenv S.prog)sb=Some S.v_state)in INFO.
 destruct(Genv.init_mem_characterization S.prog sb INFO INIT)as[PERM[_[ZERO BYTES]]].
 cbn[S.v_state Genv.perm_globvar init_data_list_size]in PERM.
 split;[exact PERM|].
 specialize(ZERO eq_refl);specialize(BYTES eq_refl).
 cbn[S.v_state Genv.load_store_init_data]in ZERO.
 destruct ZERO as[ZERO _];split;[exact ZERO|].
 cbn[S.v_state Genv.bytes_of_init_data_list Genv.bytes_of_init_data]in BYTES.
 rewrite app_nil_r in BYTES;exact BYTES.
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
