From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Coqlib Integers Floats Values Memory Globalenvs Ctypes.
From FiveQuatRotationSupport Require Import Fixture.
Require FiveQuatVmultCase.Contract.
From FiveQuatRotation Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Definition fb(z:Z):float32:=Float32.of_bits(Int.repr z).
Definition BitCells(m:mem)(b:block)(ofs:Z)(bits:list Z):Prop:=forall i:nat,(i<length bits)%nat->Mem.load Mfloat32 m b(ofs+4*Z.of_nat i)=Some(f32(nth i bits 0)).
Lemma put_access:forall bits m b ofs mf,put m b ofs bits=Some mf->forall ch bb oo p,Mem.valid_access m ch bb oo p->Mem.valid_access mf ch bb oo p.
Proof. induction bits as[|x xs IH];intros m b ofs mf PUT ch bb oo p VA;cbn[put]in PUT.
 - injection PUT as<-;exact VA.
 - destruct(Mem.store Mfloat32 m b ofs(f32 x))as[mm|]eqn:ST;try discriminate;eapply IH;[exact PUT|eapply Mem.store_valid_access_1;eauto]. Qed.
Lemma put_perm:forall bits m b ofs mf,put m b ofs bits=Some mf->forall bb oo k p,Mem.perm m bb oo k p->Mem.perm mf bb oo k p.
Proof. induction bits as[|x xs IH];intros m b ofs mf PUT bb oo k p VA;cbn[put]in PUT.
 - injection PUT as<-;exact VA.
 - destruct(Mem.store Mfloat32 m b ofs(f32 x))as[mm|]eqn:ST;try discriminate;eapply IH;[exact PUT|eapply Mem.perm_store_1;eauto]. Qed.
Lemma put_nextblock:forall bits m b ofs mf,put m b ofs bits=Some mf->Mem.nextblock mf=Mem.nextblock m.
Proof. induction bits as[|x xs IH];intros m b ofs mf PUT;cbn[put]in PUT.
 - injection PUT as<-;reflexivity.
 - destruct(Mem.store Mfloat32 m b ofs(f32 x))as[mm|]eqn:ST;try discriminate;rewrite(IH _ _ _ _ PUT);eapply Mem.nextblock_store;exact ST. Qed.
Lemma put_exists:forall bits m b ofs,
 (forall i:nat,(i<length bits)%nat->Mem.valid_access m Mfloat32 b(ofs+4*Z.of_nat i)Writable)->exists mf,put m b ofs bits=Some mf.
Proof. induction bits as[|x xs IH];intros m b ofs W;[exists m;reflexivity|].
 assert(W0:Mem.valid_access m Mfloat32 b ofs Writable)by(replace ofs with(ofs+4*Z.of_nat 0)by lia;apply W;simpl;lia).
 destruct(Mem.valid_access_store m Mfloat32 b ofs(f32 x)W0)as[mm ST].
 destruct(IH mm b(ofs+4))as[mf PUT].
 - intros i IX;eapply Mem.store_valid_access_1;[exact ST|].
 replace(ofs+4+4*Z.of_nat i)with(ofs+4*Z.of_nat(S i))by(rewrite Nat2Z.inj_succ;lia);apply W;simpl;lia.
 - exists mf;cbn[put];rewrite ST;exact PUT. Qed.
Lemma put_earlier:forall bits m b ofs mf ch bb oo,
 put m b ofs bits=Some mf->(bb<>b\/oo+size_chunk ch<=ofs)->Mem.load ch mf bb oo=Mem.load ch m bb oo.
Proof. induction bits as[|x xs IH];intros m b ofs mf ch bb oo PUT OUT;cbn[put]in PUT.
 - injection PUT as<-;reflexivity.
 - destruct(Mem.store Mfloat32 m b ofs(f32 x))as[mm|]eqn:ST;try discriminate.
 rewrite(IH mm b(ofs+4)mf ch bb oo PUT ltac:(destruct OUT as[NE|B];auto;right;lia)).
 eapply Mem.load_store_other;[exact ST|destruct OUT as[NE|B];auto]. Qed.
Lemma put_cells:forall bits m b ofs mf,put m b ofs bits=Some mf->BitCells mf b ofs bits.
Proof. induction bits as[|x xs IH];intros m b ofs mf PUT i IX;[simpl in IX;lia|].
 cbn[put]in PUT;destruct(Mem.store Mfloat32 m b ofs(f32 x))as[mm|]eqn:ST;try discriminate.
 destruct i as[|i].
 - replace(ofs+4*Z.of_nat 0)with ofs by lia;cbn[nth].
 rewrite(put_earlier xs mm b(ofs+4)mf Mfloat32 b ofs PUT ltac:(right;cbn[size_chunk];lia));erewrite Mem.load_store_same by exact ST;reflexivity.
 - replace(ofs+4*Z.of_nat(S i))with(ofs+4+4*Z.of_nat i)by(rewrite Nat2Z.inj_succ;lia);apply(IH mm b(ofs+4)mf PUT i);simpl in IX;lia. Qed.
Lemma range_access:forall m b n i,Mem.range_perm m b 0 n Cur Writable->0<=i->4*i+4<=n->Mem.valid_access m Mfloat32 b(4*i)Writable.
Proof. intros m b n i RP LO HI;split;[intros z Z;apply RP;cbn[size_chunk]in Z;lia|change(4|4*i);exists i;lia]. Qed.
Lemma globals_defined:global_initial=Some base_memory.
Proof.
 destruct(Genv.init_mem_exists FiveQuatVmult.Source.prog)as[m INIT].
 - intros id v IN;change(In(id,Gvar v)FiveQuatVmult.Source.global_definitions)in IN.
   cbn[FiveQuatVmult.Source.global_definitions]in IN;repeat destruct IN as[IN|IN];try contradiction;discriminate.
 - unfold base_memory,global_initial;rewrite INIT;reflexivity. Qed.
Lemma put_bytes_other:forall bits m b ofs mf bx z n,
 put m b ofs bits=Some mf->bx<>b->Mem.loadbytes mf bx z n=Mem.loadbytes m bx z n.
Proof. induction bits as[|x xs IH];intros m b ofs mf bx z n PUT NE;cbn[put]in PUT.
 - injection PUT as<-;reflexivity.
 - destruct(Mem.store Mfloat32 m b ofs(f32 x))as[mm|]eqn:ST;try discriminate.
 rewrite(IH mm b(ofs+4)mf bx z n PUT NE);eapply Mem.loadbytes_store_other;[exact ST|left;exact NE]. Qed.
Record FixtureFacts(f:fixture)(q v:list Z):Prop:={
 fixture_disjoint:NoDup[qb f;vb f;ab f;rb f;bb f;ca f;cb f];
 fixture_q:BitCells(initial f)(qb f)0 q;
 fixture_v:BitCells(initial f)(vb f)0 v;
 fixture_a:Mem.range_perm(initial f)(ab f)0 12 Cur Writable;
 fixture_r:Mem.range_perm(initial f)(rb f)0 36 Cur Writable;
 fixture_b:Mem.range_perm(initial f)(bb f)0 12 Cur Writable;
 fixture_ca:Mem.range_perm(initial f)(ca f)0 12 Cur Writable;
 fixture_cb:Mem.range_perm(initial f)(cb f)0 12 Cur Writable;
 fixture_anchor:forall old,Mem.valid_block(initial f)old->Pos.le old(cb f);
 fixture_global_frame:forall old z n,Mem.valid_block base_memory old->Mem.loadbytes(initial f)old z n=Mem.loadbytes base_memory old z n
}.
Lemma make_fixture_facts:forall q v,length q=4%nat->length v=3%nat->exists f,make_fixture q v=Some f /\FixtureFacts f q v.
Proof. intros q v QLEN VLEN.
 destruct(Mem.alloc base_memory 0 16)as[m1 bq]eqn:A1.
 destruct(Mem.alloc m1 0 12)as[m2 bv]eqn:A2.
 destruct(Mem.alloc m2 0 12)as[m3 ba]eqn:A3.
 destruct(Mem.alloc m3 0 36)as[m4 br]eqn:A4.
 destruct(Mem.alloc m4 0 12)as[m5 bb]eqn:A5.
 destruct(Mem.alloc m5 0 12)as[m6 bca]eqn:A6.
 destruct(Mem.alloc m6 0 12)as[m7 bcb]eqn:A7.
 assert(B1:bq=Mem.nextblock base_memory)by(eapply Mem.alloc_result;exact A1).
 assert(N1:Mem.nextblock m1=Pos.succ bq).
 { erewrite Mem.nextblock_alloc by exact A1;rewrite<-B1;reflexivity. }
 assert(B2:bv=Mem.nextblock m1)by(eapply Mem.alloc_result;exact A2).
 assert(N2:Mem.nextblock m2=Pos.succ bv).
 { erewrite Mem.nextblock_alloc by exact A2;rewrite<-B2;reflexivity. }
 assert(S2:bv=Pos.succ bq)by(rewrite B2,N1;reflexivity).
 assert(B3:ba=Mem.nextblock m2)by(eapply Mem.alloc_result;exact A3).
 assert(N3:Mem.nextblock m3=Pos.succ ba).
 { erewrite Mem.nextblock_alloc by exact A3;rewrite<-B3;reflexivity. }
 assert(S3:ba=Pos.succ bv)by(rewrite B3,N2;reflexivity).
 assert(B4:br=Mem.nextblock m3)by(eapply Mem.alloc_result;exact A4).
 assert(N4:Mem.nextblock m4=Pos.succ br).
 { erewrite Mem.nextblock_alloc by exact A4;rewrite<-B4;reflexivity. }
 assert(S4:br=Pos.succ ba)by(rewrite B4,N3;reflexivity).
 assert(B5:bb=Mem.nextblock m4)by(eapply Mem.alloc_result;exact A5).
 assert(N5:Mem.nextblock m5=Pos.succ bb).
 { erewrite Mem.nextblock_alloc by exact A5;rewrite<-B5;reflexivity. }
 assert(S5:bb=Pos.succ br)by(rewrite B5,N4;reflexivity).
 assert(B6:bca=Mem.nextblock m5)by(eapply Mem.alloc_result;exact A6).
 assert(N6:Mem.nextblock m6=Pos.succ bca).
 { erewrite Mem.nextblock_alloc by exact A6;rewrite<-B6;reflexivity. }
 assert(S6:bca=Pos.succ bb)by(rewrite B6,N5;reflexivity).
 assert(B7:bcb=Mem.nextblock m6)by(eapply Mem.alloc_result;exact A7).
 assert(N7:Mem.nextblock m7=Pos.succ bcb).
 { erewrite Mem.nextblock_alloc by exact A7;rewrite<-B7;reflexivity. }
 assert(S7:bcb=Pos.succ bca)by(rewrite B7,N6;reflexivity).
 assert(NOD:NoDup[bq;bv;ba;br;bb;bca;bcb])by(repeat constructor;simpl;intuition(subst;zify;lia)).
 assert(P1:Mem.range_perm m7 bq 0 16 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A7|];eapply Mem.perm_alloc_1;[exact A6|];eapply Mem.perm_alloc_1;[exact A5|];eapply Mem.perm_alloc_1;[exact A4|];eapply Mem.perm_alloc_1;[exact A3|];eapply Mem.perm_alloc_1;[exact A2|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A1|exact Z]|constructor]. }
 assert(P2:Mem.range_perm m7 bv 0 12 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A7|];eapply Mem.perm_alloc_1;[exact A6|];eapply Mem.perm_alloc_1;[exact A5|];eapply Mem.perm_alloc_1;[exact A4|];eapply Mem.perm_alloc_1;[exact A3|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A2|exact Z]|constructor]. }
 assert(P3:Mem.range_perm m7 ba 0 12 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A7|];eapply Mem.perm_alloc_1;[exact A6|];eapply Mem.perm_alloc_1;[exact A5|];eapply Mem.perm_alloc_1;[exact A4|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A3|exact Z]|constructor]. }
 assert(P4:Mem.range_perm m7 br 0 36 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A7|];eapply Mem.perm_alloc_1;[exact A6|];eapply Mem.perm_alloc_1;[exact A5|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A4|exact Z]|constructor]. }
 assert(P5:Mem.range_perm m7 bb 0 12 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A7|];eapply Mem.perm_alloc_1;[exact A6|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A5|exact Z]|constructor]. }
 assert(P6:Mem.range_perm m7 bca 0 12 Cur Writable).
 { intros z Z;eapply Mem.perm_alloc_1;[exact A7|];eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A6|exact Z]|constructor]. }
 assert(P7:Mem.range_perm m7 bcb 0 12 Cur Writable).
 { intros z Z;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact A7|exact Z]|constructor]. }
 destruct(put_exists q m7 bq 0)as[m8 PUTQ].
 - intros i IX;replace(0+4*Z.of_nat i)with(4*Z.of_nat i)by lia;apply(range_access m7 bq 16(Z.of_nat i)P1);rewrite QLEN in IX;lia.
 - destruct(put_exists v m8 bv 0)as[m9 PUTV].
 + intros i IX;replace(0+4*Z.of_nat i)with(4*Z.of_nat i)by lia;apply range_access with(n:=12).
 * intros z Z;eapply put_perm;[exact PUTQ|apply P2;exact Z].
 * lia.
 * rewrite VLEN in IX;lia.
 + exists(Fixture m9 bq bv ba br bb bca bcb);split.
 * unfold make_fixture;rewrite A1,A2,A3,A4,A5,A6,A7,PUTQ,PUTV;reflexivity.
 * constructor;cbn[initial qb vb ab rb FiveQuatRotationSupport.Fixture.bb ca cb].
 -- exact NOD.
 -- intros i IX;rewrite(put_earlier v m8 bv 0 m9 Mfloat32 bq(0+4*Z.of_nat i)PUTV ltac:(left;intro EQ;subst;zify;lia));exact(put_cells q m7 bq 0 m8 PUTQ i IX).
 -- exact(put_cells v m8 bv 0 m9 PUTV).
 -- intros z Z;eapply put_perm;[exact PUTV|];eapply put_perm;[exact PUTQ|apply P3;exact Z].
 -- intros z Z;eapply put_perm;[exact PUTV|];eapply put_perm;[exact PUTQ|apply P4;exact Z].
 -- intros z Z;eapply put_perm;[exact PUTV|];eapply put_perm;[exact PUTQ|apply P5;exact Z].
 -- intros z Z;eapply put_perm;[exact PUTV|];eapply put_perm;[exact PUTQ|apply P6;exact Z].
 -- intros z Z;eapply put_perm;[exact PUTV|];eapply put_perm;[exact PUTQ|apply P7;exact Z].
 -- intros old VB;unfold Mem.valid_block in VB.
 rewrite(put_nextblock v m8 bv 0 m9 PUTV),(put_nextblock q m7 bq 0 m8 PUTQ),N7 in VB;unfold Plt in VB;apply Pos.lt_succ_r in VB;exact VB.
 -- intros old z n VB.
 assert(BQ:old<>bq)by(intro EQ;subst old;exact(Mem.fresh_block_alloc _ _ _ _ _ A1 VB)).
 assert(BV:old<>bv).
 { intro EQ;subst old;eapply(Mem.fresh_block_alloc _ _ _ _ _ A2);eapply Mem.valid_block_alloc;[exact A1|exact VB]. }
 rewrite(put_bytes_other v m8 bv 0 m9 old z n PUTV BV),(put_bytes_other q m7 bq 0 m8 old z n PUTQ BQ).
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A7|eapply Mem.valid_block_alloc;[exact A6|];eapply Mem.valid_block_alloc;[exact A5|];eapply Mem.valid_block_alloc;[exact A4|];eapply Mem.valid_block_alloc;[exact A3|];eapply Mem.valid_block_alloc;[exact A2|];eapply Mem.valid_block_alloc;[exact A1|];exact VB].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A6|eapply Mem.valid_block_alloc;[exact A5|];eapply Mem.valid_block_alloc;[exact A4|];eapply Mem.valid_block_alloc;[exact A3|];eapply Mem.valid_block_alloc;[exact A2|];eapply Mem.valid_block_alloc;[exact A1|];exact VB].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A5|eapply Mem.valid_block_alloc;[exact A4|];eapply Mem.valid_block_alloc;[exact A3|];eapply Mem.valid_block_alloc;[exact A2|];eapply Mem.valid_block_alloc;[exact A1|];exact VB].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A4|eapply Mem.valid_block_alloc;[exact A3|];eapply Mem.valid_block_alloc;[exact A2|];eapply Mem.valid_block_alloc;[exact A1|];exact VB].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A3|eapply Mem.valid_block_alloc;[exact A2|];eapply Mem.valid_block_alloc;[exact A1|];exact VB].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A2|eapply Mem.valid_block_alloc;[exact A1|];exact VB].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact A1|exact VB].
 reflexivity.
Qed.
Lemma make_fixture_result_facts:forall q v f,length q=4%nat->length v=3%nat->make_fixture q v=Some f->FixtureFacts f q v.
Proof. intros q v f Q V MAKE;destruct(make_fixture_facts q v Q V)as[ff[E F]];rewrite MAKE in E;injection E as<-;exact F. Qed.
Lemma unit_fixture_defined:make_fixture q_unit v_unit=Some unit_fixture.
Proof. destruct(make_fixture_facts q_unit v_unit eq_refl eq_refl)as[f[MAKE FACTS]];unfold unit_fixture,force_fixture;rewrite MAKE;reflexivity. Qed.
Lemma trace_fixture_defined:make_fixture q_trace v_trace=Some trace_fixture.
Proof. destruct(make_fixture_facts q_trace v_trace eq_refl eq_refl)as[f[MAKE FACTS]];unfold trace_fixture,force_fixture;rewrite MAKE;reflexivity. Qed.
Lemma unit_facts:FixtureFacts unit_fixture q_unit v_unit.
Proof. eapply make_fixture_result_facts;[reflexivity|reflexivity|exact unit_fixture_defined]. Qed.
Lemma trace_facts:FixtureFacts trace_fixture q_trace v_trace.
Proof. eapply make_fixture_result_facts;[reflexivity|reflexivity|exact trace_fixture_defined]. Qed.
Lemma facts_inputs:forall f qi qx qy qz vx vy vz,
 FixtureFacts f[qi;qx;qy;qz][vx;vy;vz]->
 FiveQuatVmultCase.Contract.Inputs(initial f)(qb f)(vb f)(ab f)(fb qi)(fb qx)(fb qy)(fb qz)(fb vx)(fb vy)(fb vz).
Proof. intros f qi qx qy qz vx vy vz F.
 pose proof(fixture_disjoint _ _ _ F)as ND;inversion ND as[|x xs NQ NDV];subst;inversion NDV as[|y ys NV NDA];subst.
 constructor.
 - intro EQ;apply NQ;simpl;left;symmetry;exact EQ.
 - intro EQ;apply NQ;simpl;right;left;symmetry;exact EQ.
 - intro EQ;apply NV;simpl;left;symmetry;exact EQ.
 - exact(fixture_q _ _ _ F 0%nat ltac:(simpl;lia)).
 - exact(fixture_q _ _ _ F 1%nat ltac:(simpl;lia)).
 - exact(fixture_q _ _ _ F 2%nat ltac:(simpl;lia)).
 - exact(fixture_q _ _ _ F 3%nat ltac:(simpl;lia)).
 - exact(fixture_v _ _ _ F 0%nat ltac:(simpl;lia)).
 - exact(fixture_v _ _ _ F 1%nat ltac:(simpl;lia)).
 - exact(fixture_v _ _ _ F 2%nat ltac:(simpl;lia)).
 - intros ofs IX;destruct IX as[<-|[<-|[<-|[]]]];
   [exact(range_access _ _ _ 0(fixture_a _ _ _ F)ltac:(lia)ltac:(lia))|
    exact(range_access _ _ _ 1(fixture_a _ _ _ F)ltac:(lia)ltac:(lia))|
    exact(range_access _ _ _ 2(fixture_a _ _ _ F)ltac:(lia)ltac:(lia))]. Qed.
Lemma unit_inputs:FiveQuatVmultCase.Contract.Inputs(initial unit_fixture)(qb unit_fixture)(vb unit_fixture)(ab unit_fixture)(fb 1065353216)(fb 0)(fb 0)(fb 0)(fb 1065353216)(fb 0)(fb 0).
Proof. exact(facts_inputs unit_fixture 1065353216 0 0 0 1065353216 0 0 unit_facts). Qed.
Lemma trace_inputs:FiveQuatVmultCase.Contract.Inputs(initial trace_fixture)(qb trace_fixture)(vb trace_fixture)(ab trace_fixture)(fb 3208096458)(fb 3191717350)(fb 2687829235)(fb 268909329)(fb 1124089879)(fb 1149239296)(fb 2382364672).
Proof. exact(facts_inputs trace_fixture 3208096458 3191717350 2687829235 268909329 1124089879 1149239296 2382364672 trace_facts). Qed.
Lemma facts_domain:forall f q v,
 FixtureFacts f q v->length q=4%nat->length v=3%nat->
 (forall i:nat,(i<4)%nat->Float32.cmp Cle(Float32.neg(fb 1065353216))(fb(nth i q 0))=true /\Float32.cmp Cle(fb(nth i q 0))(fb 1065353216)=true)->
 (forall i:nat,(i<3)%nat->Float32.cmp Cle(fb 3296722944)(fb(nth i v 0))=true /\Float32.cmp Cle(fb(nth i v 0))(fb 1149239296)=true)->
 Spec.Domain(initial f)(qb f)(vb f)(ab f)(rb f)(bb f).
Proof. intros f q v F QLEN VLEN QB VB;unfold Spec.Domain;split.
 - pose proof(fixture_disjoint _ _ _ F)as ND.
   change(NoDup([qb f;vb f;ab f;rb f;bb f]++[ca f;cb f]))in ND;exact(NoDup_app_remove_r _ _ ND).
 - split.
 + intros i IX;exists(fb(nth i q 0));replace(4*Z.of_nat i)with(0+4*Z.of_nat i)by lia;apply(fixture_q _ _ _ F i);rewrite QLEN;exact IX.
 + split.
 * intros i IX;exists(fb(nth i v 0));replace(4*Z.of_nat i)with(0+4*Z.of_nat i)by lia;apply(fixture_v _ _ _ F i);rewrite VLEN;exact IX.
 * split;[exact(fixture_a _ _ _ F)|];split;[exact(fixture_r _ _ _ F)|];split;[exact(fixture_b _ _ _ F)|];split.
 -- intros i IX;exists(fb(nth i q 0));split;[replace(4*Z.of_nat i)with(0+4*Z.of_nat i)by lia;apply(fixture_q _ _ _ F i);rewrite QLEN;exact IX|exact(QB i IX)].
 -- intros i IX;exists(fb(nth i v 0));split;[replace(4*Z.of_nat i)with(0+4*Z.of_nat i)by lia;apply(fixture_v _ _ _ F i);rewrite VLEN;exact IX|exact(VB i IX)]. Qed.
Lemma unit_domain:Spec.Domain(initial unit_fixture)(qb unit_fixture)(vb unit_fixture)(ab unit_fixture)(rb unit_fixture)(bb unit_fixture).
Proof. eapply facts_domain;[exact unit_facts|reflexivity|reflexivity| |].
 - intros i IX;do 4(destruct i as[|i];[vm_compute;split;reflexivity|]);lia.
 - intros i IX;do 3(destruct i as[|i];[vm_compute;split;reflexivity|]);lia. Qed.
Lemma trace_domain:Spec.Domain(initial trace_fixture)(qb trace_fixture)(vb trace_fixture)(ab trace_fixture)(rb trace_fixture)(bb trace_fixture).
Proof. eapply facts_domain;[exact trace_facts|reflexivity|reflexivity| |].
 - intros i IX;do 4(destruct i as[|i];[vm_compute;split;reflexivity|]);lia.
 - intros i IX;do 3(destruct i as[|i];[vm_compute;split;reflexivity|]);lia. Qed.
Lemma unit_anchor:forall old,Mem.valid_block(initial unit_fixture)old->Pos.le old(cb unit_fixture).
Proof. exact(fixture_anchor _ _ _ unit_facts). Qed.
Lemma trace_anchor:forall old,Mem.valid_block(initial trace_fixture)old->Pos.le old(cb trace_fixture).
Proof. exact(fixture_anchor _ _ _ trace_facts). Qed.
Print Assumptions globals_defined.
Print Assumptions unit_fixture_defined.
Print Assumptions trace_fixture_defined.
Print Assumptions unit_inputs.
Print Assumptions trace_inputs.
Print Assumptions unit_domain.
Print Assumptions trace_domain.
Lemma facts_r_cells:forall f q v,FixtureFacts f q v->forall i,0<=i<9->Mem.valid_access(initial f)Mfloat32(rb f)(4*i)Writable.
Proof. intros;eapply range_access;[exact(fixture_r _ _ _ H)|lia|lia]. Qed.
Lemma facts_b_cells:forall f q v,FixtureFacts f q v->forall i,0<=i<3->Mem.valid_access(initial f)Mfloat32(bb f)(4*i)Writable.
Proof. intros;eapply range_access;[exact(fixture_b _ _ _ H)|lia|lia]. Qed.
Lemma facts_ca_cells:forall f q v,FixtureFacts f q v->forall i,0<=i<3->Mem.valid_access(initial f)Mfloat32(ca f)(4*i)Writable.
Proof. intros;eapply range_access;[exact(fixture_ca _ _ _ H)|lia|lia]. Qed.
Lemma facts_cb_cells:forall f q v,FixtureFacts f q v->forall i,0<=i<3->Mem.valid_access(initial f)Mfloat32(cb f)(4*i)Writable.
Proof. intros;eapply range_access;[exact(fixture_cb _ _ _ H)|lia|lia]. Qed.
Print Assumptions make_fixture_facts.
Print Assumptions unit_facts.
Print Assumptions trace_facts.
