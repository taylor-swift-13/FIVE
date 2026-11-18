From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Values Memory Ctypes Csem.
From FiveGuidanceAllocation Require Import StackAllocation.
Import ListNotations.
Local Open Scope Z_scope.
Definition region_block(r:block*Z*Z):block:=let '(b,_,_):=r in b.
Lemma map_norepet_inv:forall(A B:Type)(f:A->B)xs,list_norepet(map f xs)->list_norepet xs.
Proof.
 intros A B f xs;induction xs as[|x xs IH];intros ND;[constructor|].
 inversion ND;subst;constructor.
 - intro IN;match goal with H:~In(f x)(map f xs)|-_=>apply H;apply in_map;exact IN end.
 - apply IH;assumption.
Qed.
Lemma env_blocks_norepet:forall(ge:Csem.genv)e,env_separated e ->list_norepet(map region_block(blocks_of_env ge e)).
Proof.
 intros ge e SEP;unfold blocks_of_env;rewrite map_map.
 apply list_map_norepet.
 - eapply map_norepet_inv;apply PTree.elements_keys_norepet.
 - intros[id1[b1 ty1]][id2[b2 ty2]]IN1 IN2 NE;cbn.
   intro EQ;subst b2;apply NE.
   pose proof(PTree.elements_complete _ _ _ IN1)as L1.
   pose proof(PTree.elements_complete _ _ _ IN2)as L2.
   assert(ID:id1=id2)by(eapply SEP;eauto);subst id2.
   rewrite L1 in L2;injection L2 as TY;subst ty2;reflexivity.
Qed.
Lemma free_regions:forall regions m,
 list_norepet(map region_block regions) ->
 (forall b lo hi,In(b,lo,hi)regions ->Mem.range_perm m b lo hi Cur Freeable) ->
 exists mf,Mem.free_list m regions=Some mf /\
 (forall ch b ofs,~In b(map region_block regions)->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall ch b ofs p,~In b(map region_block regions)->Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p).
Proof.
 intros regions;induction regions as[|[[b lo]hi]regions IH];intros m ND FREE.
 - exists m;split;[reflexivity|split;auto].
 - cbn in ND;inversion ND as[|? ? NOT NDREST];subst.
   destruct(Mem.range_perm_free m b lo hi(FREE b lo hi(or_introl eq_refl)))as[ma F].
   assert(REST:forall bx lox hix,In(bx,lox,hix)regions->Mem.range_perm ma bx lox hix Cur Freeable).
   { intros bx lox hix IN ofs RANGE;eapply Mem.perm_free_1;[exact F| |].
     - left;intro EQ;subst bx;apply NOT;apply in_map with(f:=region_block)in IN;exact IN.
     - apply(FREE bx lox hix);[right;exact IN|exact RANGE]. }
   destruct(IH ma NDREST REST)as[mf[FF[LOAD ACCESS]]].
   exists mf;split;[cbn[Mem.free_list];rewrite F;exact FF|]. split.
   + intros ch bx ofs NP;rewrite LOAD by(cbn in NP;tauto).
     erewrite Mem.load_free by(exact F||(left;cbn in NP;intuition congruence));reflexivity.
   + intros ch bx ofs p NP VA;apply ACCESS;[cbn in NP;tauto|].
     eapply Mem.valid_access_free_1;[exact F|exact VA|left;cbn in NP;intuition congruence].
Qed.
Lemma free_environment:forall(ge:Csem.genv)e m,
 env_separated e ->
 (forall id b ty,e!id=Some(b,ty)->Mem.range_perm m b 0(sizeof ge ty)Cur Freeable) ->
 exists mf,Mem.free_list m(blocks_of_env ge e)=Some mf /\
 (forall ch b ofs,(forall id ty,e!id=Some(b,ty)->False)->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall ch b ofs p,(forall id ty,e!id=Some(b,ty)->False)->Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p).
Proof.
 intros ge e m SEP FREE.
 destruct(free_regions(blocks_of_env ge e)m(env_blocks_norepet ge e SEP))as[mf[FF[LOAD ACCESS]]].
 - intros b lo hi IN;unfold blocks_of_env in IN;apply in_map_iff in IN as[[id[bx ty]][EQ IN]].
   cbn in EQ;injection EQ as EB EL EH;subst bx lo hi.
   eapply FREE;eapply PTree.elements_complete;exact IN.
 - exists mf;split;[exact FF|]. split.
   + intros ch b ofs OUT;apply LOAD;intro IN.
     unfold blocks_of_env in IN;rewrite map_map in IN;apply in_map_iff in IN as[[id[bx ty]][EQ IN]].
     cbn in EQ;subst bx;apply(OUT id ty);eapply PTree.elements_complete;exact IN.
   + intros ch b ofs p OUT VA;apply ACCESS;[|exact VA];intro IN.
     unfold blocks_of_env in IN;rewrite map_map in IN;apply in_map_iff in IN as[[id[bx ty]][EQ IN]].
     cbn in EQ;subst bx;apply(OUT id ty);eapply PTree.elements_complete;exact IN.
Qed.
Print Assumptions free_environment.
Lemma range_perm_access_preserved:forall m mf,
 (forall ch b ofs p,Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p)->
 forall b lo hi p,Mem.range_perm m b lo hi Cur p->Mem.range_perm mf b lo hi Cur p.
Proof.
 intros m mf KEEP b lo hi p RANGE ofs BOUNDS.
 assert(VA:Mem.valid_access m Mint8unsigned b ofs p).
 { unfold Mem.valid_access;split.
   - intros x X;apply RANGE;cbn in X;lia.
   - change(1|ofs);exists ofs;lia. }
 pose proof(KEEP _ _ _ _ VA)as VF;apply(proj1 VF);cbn;lia.
Qed.
Lemma free_list_bytes_frame:forall regions m mf,
 Mem.free_list m regions=Some mf ->
 forall b ofs n,~In b(map region_block regions)->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros regions;induction regions as[|[[head lo]hi]regions IH];intros m mf FREE b ofs n OUT.
 - cbn[Mem.free_list]in FREE;injection FREE as<-;reflexivity.
 - cbn[Mem.free_list]in FREE;destruct(Mem.free m head lo hi)as[ma|]eqn:F;try discriminate.
   rewrite(IH ma mf FREE b ofs n)by(cbn in OUT;tauto).
   eapply Mem.loadbytes_free;[exact F|left;cbn in OUT;intuition congruence].
Qed.
Lemma free_environment_bytes_frame:forall ge e m mf,
 Mem.free_list m(blocks_of_env ge e)=Some mf ->
 forall b ofs n,(forall id ty,e!id=Some(b,ty)->False)->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros ge e m mf FREE b ofs n OUT;apply(free_list_bytes_frame _ _ _ FREE);intro IN.
 unfold blocks_of_env in IN;rewrite map_map in IN;apply in_map_iff in IN as[[id[bx ty]][EQ IN]].
 cbn in EQ;subst bx;apply(OUT id ty);eapply PTree.elements_complete;exact IN.
Qed.
Lemma range_perm_access_preserved_block:forall m mf b,
 (forall ch ofs p,Mem.valid_access m ch b ofs p->Mem.valid_access mf ch b ofs p)->
 forall lo hi p,Mem.range_perm m b lo hi Cur p->Mem.range_perm mf b lo hi Cur p.
Proof.
 intros m mf b KEEP lo hi p RANGE ofs BOUNDS.
 assert(VA:Mem.valid_access m Mint8unsigned b ofs p).
 { unfold Mem.valid_access;split;[intros x X;apply RANGE;cbn in X;lia|change(1|ofs);exists ofs;lia]. }
 pose proof(KEEP _ _ _ VA)as VF;apply(proj1 VF);cbn;lia.
Qed.
