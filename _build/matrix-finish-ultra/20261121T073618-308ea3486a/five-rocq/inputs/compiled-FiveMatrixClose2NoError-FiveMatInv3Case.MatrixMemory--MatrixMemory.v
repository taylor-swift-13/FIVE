From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata.
Import ListNotations.
Local Open Scope Z_scope.
Definition WriteRegion (m:mem)(b:block)(p:ptrofs)(n:Z):Prop :=
 (4 | Ptrofs.unsigned p) /\ Ptrofs.unsigned p+4*n<=Ptrofs.modulus /\
 Mem.range_perm m b(Ptrofs.unsigned p)(Ptrofs.unsigned p+4*n)Cur Writable.
Definition Reads(m:mem)(b:block)(p:ptrofs)(n:Z)(f:Z->float32):Prop :=
 (4|Ptrofs.unsigned p) /\ Ptrofs.unsigned p+4*n<=Ptrofs.modulus /\
 (forall i,0<=i<n->Mem.load Mfloat32 m b(Ptrofs.unsigned p+4*i)=Some(Vsingle(f i))).
Lemma index_pointer:forall p n i,
 Ptrofs.unsigned p+4*n<=Ptrofs.modulus->0<=i<n->
 Ptrofs.unsigned(Ptrofs.add p(Ptrofs.repr(4*i)))=Ptrofs.unsigned p+4*i.
Proof. intros p n i NW B;rewrite Ptrofs.add_unsigned.
 rewrite(Ptrofs.unsigned_repr(4*i)) by(pose proof(Ptrofs.unsigned_range p);change Ptrofs.max_unsigned with 18446744073709551615;change Ptrofs.modulus with 18446744073709551616 in NW;lia).
 apply Ptrofs.unsigned_repr;pose proof(Ptrofs.unsigned_range p);change Ptrofs.max_unsigned with 18446744073709551615;change Ptrofs.modulus with 18446744073709551616 in NW;lia. Qed.
Lemma writable_access:forall m b p n i,WriteRegion m b p n->0<=i<n->
 Mem.valid_access m Mfloat32 b(Ptrofs.unsigned p+4*i)Writable.
Proof. intros m b p n i[AL[NW RP]]B;split.
 - intros z R;apply RP;cbn[size_chunk]in R;lia.
 - change(4|Ptrofs.unsigned p+4*i);destruct AL as[k K];exists(k+i);lia. Qed.
Lemma writable_store:forall m b p n i x,WriteRegion m b p n->0<=i<n->
 exists mf,Mem.store Mfloat32 m b(Ptrofs.unsigned p+4*i)(Vsingle x)=Some mf.
Proof. intros m b p n i x W B;destruct(Mem.valid_access_store m Mfloat32 b(Ptrofs.unsigned p+4*i)(Vsingle x)(writable_access m b p n i W B))as[mf ST];exists mf;exact ST. Qed.
Lemma writable_store_preserved:forall m b p n ch q z v mf,
 WriteRegion m b p n->Mem.store ch m q z v=Some mf->WriteRegion mf b p n.
Proof. intros m b p n ch q z v mf[AL[NW RP]]ST;repeat split;auto;intros z' B;eapply Mem.perm_store_1;[exact ST|apply RP;exact B]. Qed.
Lemma reads_store_preserved:forall m b p n f ch q z v mf,
 Reads m b p n f->b<>q->Mem.store ch m q z v=Some mf->Reads mf b p n f.
Proof. intros m b p n f ch q z v mf[AL[NW RD]]NE ST;repeat split;auto;intros i B;erewrite Mem.load_store_other by(exact ST||(left;congruence));apply RD;exact B. Qed.
Lemma reads_valid:forall m b p n f,0<n->Reads m b p n f->Mem.valid_block m b.
Proof. intros m b p n f N[_[_ RD]];eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(RD 0 ltac:(lia))|constructor]. Qed.
Lemma writable_valid:forall m b p n,0<n->WriteRegion m b p n->Mem.valid_block m b.
Proof. intros m b p n N W;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact(writable_access m b p n 0 W ltac:(lia))|constructor]. Qed.
Fixpoint Writes(m:mem)(b:block)(base:Z)(xs:list(Z*float32))(mf:mem):Prop :=
 match xs with []=>mf=m|(i,x)::tail=>exists m1,Mem.store Mfloat32 m b(base+4*i)(Vsingle x)=Some m1 /\ Writes m1 b base tail mf end.
Lemma writes_exist:forall xs m b p n,WriteRegion m b p n->(forall i x,In(i,x)xs->0<=i<n)->exists mf,Writes m b(Ptrofs.unsigned p)xs mf.
Proof. induction xs as[|[i x]xs IH];intros m b p n W B;[exists m;reflexivity|].
 destruct(writable_store m b p n i x W(B i x(or_introl eq_refl)))as[m1 ST].
 destruct(IH m1 b p n(writable_store_preserved _ _ _ _ _ _ _ _ _ W ST)ltac:(intros j y IN;apply B with y;right;exact IN))as[mf REST].
 exists mf,m1;auto.
Qed.

Lemma writes_permissions:forall xs m b base mf,Writes m b base xs mf->
 forall q z k perm,Mem.perm m q z k perm->Mem.perm mf q z k perm.
Proof. induction xs as[|[i x]xs IH];intros m b base mf WR q z k perm P;cbn[Writes]in WR;[subst mf;exact P|].
 destruct WR as[m1[ST REST]];eapply IH;[exact REST|];eapply Mem.perm_store_1;eauto. Qed.
Lemma writes_access:forall xs m b base mf,Writes m b base xs mf->
 forall ch q z perm,Mem.valid_access m ch q z perm->Mem.valid_access mf ch q z perm.
Proof. intros xs m b base mf WR ch q z perm[P AL];split;auto;intros off B;eapply writes_permissions;[exact WR|];apply P;exact B. Qed.
Lemma writes_writable:forall xs m b base mf p n,Writes m b base xs mf->
 WriteRegion m b p n->WriteRegion mf b p n.
Proof. intros xs m b base mf p n WR[AL[NW RP]];repeat split;auto;intros z B;eapply writes_permissions;[exact WR|apply RP;exact B]. Qed.
Lemma writes_unaffected:forall xs m b base mf,Writes m b base xs mf->
 forall q z n,(forall i x,In(i,x)xs->q<>b \/ z+n<=base+4*i \/ base+4*i+4<=z)->
 Mem.loadbytes mf q z n=Mem.loadbytes m q z n.
Proof. induction xs as[|[i x]xs IH];intros m b base mf WR q z n OUT;cbn[Writes]in WR;[subst mf;reflexivity|].
 destruct WR as[m1[ST REST]].
 rewrite(IH m1 b base mf REST q z n ltac:(intros j y IN;apply OUT with y;right;exact IN)).
 eapply Mem.loadbytes_store_other;[exact ST|];pose proof(OUT i x(or_introl eq_refl));cbn[size_chunk];tauto. Qed.
Lemma writes_frame:forall xs m b p n mf,Writes m b(Ptrofs.unsigned p)xs mf->
 (forall i x,In(i,x)xs->0<=i<n)->forall q z count,
 q<>b \/ z+count<=Ptrofs.unsigned p \/ Ptrofs.unsigned p+4*n<=z->
 Mem.loadbytes mf q z count=Mem.loadbytes m q z count.
Proof. intros xs m b p n mf WR B q z count OUT;eapply writes_unaffected;[exact WR|].
 intros i x IN;specialize(B i x IN);destruct OUT as[NE|[L|R]];[left;exact NE|right;left;lia|right;right;lia]. Qed.
Lemma writes_bytes:forall xs m b base mf,Writes m b base xs mf->NoDup(map fst xs)->
 forall i x,In(i,x)xs->Mem.loadbytes mf b(base+4*i)4=Some(encode_val Mfloat32(Vsingle x)).
Proof. induction xs as[|[j y]xs IH];intros m b base mf WR ND i x IN;[contradiction|].
 destruct WR as[m1[ST REST]];inversion ND as[|head tail NIN ND'];subst;destruct IN as[EQ|IN].
 - inversion EQ;subst j y.
   rewrite(writes_unaffected xs m1 b base mf REST b(base+4*i)4).
   + exact(Mem.loadbytes_store_same _ _ _ _ _ _ ST).
   + intros j y IN;assert(j<>i)by(intro EJI;subst j;apply NIN;apply in_map with (f:=@fst Z float32) in IN;exact IN).
     right;destruct(Z_lt_ge_dec i j);[left|right];lia.
 - eapply IH;eauto.
Qed.
Lemma writes_reads_other:forall xs m b base mf,Writes m b base xs mf->
 forall q p n f,Reads m q p n f->q<>b->Reads mf q p n f.
Proof. induction xs as[|[i x]xs IH];intros m b base mf WR q p n f RD NE;cbn[Writes]in WR;[subst mf;exact RD|].
 destruct WR as[m1[ST REST]];eapply IH;[exact REST|eapply reads_store_preserved;eauto|exact NE]. Qed.
Print Assumptions writes_bytes.
Print Assumptions writes_frame.
