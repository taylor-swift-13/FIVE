From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Values Memory Ctypes Csem.
From FiveGuidanceEntry Require Import StackCleanup.
Import ListNotations.
Lemma free_list_permissions:forall regions m mf,
 Mem.free_list m regions=Some mf ->forall b,
 ~In b(map region_block regions) ->forall ofs k p,
 Mem.perm m b ofs k p<->Mem.perm mf b ofs k p.
Proof.
 intros regions;induction regions as[|[[head lo]hi]regions IH];intros m mf FREE b OUT ofs k p.
 - cbn[Mem.free_list]in FREE;injection FREE as<-;reflexivity.
 - cbn[Mem.free_list]in FREE;destruct(Mem.free m head lo hi)as[ma|]eqn:F;try discriminate.
   rewrite<-(IH ma mf FREE b ltac:(cbn in OUT;tauto)ofs k p).
   split;intros PERM.
   + eapply Mem.perm_free_1;[exact F|left;cbn in OUT;intuition congruence|exact PERM].
   + eapply Mem.perm_free_3;[exact F|exact PERM].
Qed.
Lemma free_environment_permissions:forall ge e m mf,
 Mem.free_list m(blocks_of_env ge e)=Some mf ->forall b,
 (forall id ty,e!id=Some(b,ty)->False) ->forall ofs k p,
 Mem.perm m b ofs k p<->Mem.perm mf b ofs k p.
Proof.
 intros ge e m mf FREE b OUT ofs k p;apply(free_list_permissions _ _ _ FREE b);intro IN.
 unfold blocks_of_env in IN;rewrite map_map in IN.
 apply in_map_iff in IN as[[id[bx ty]][EQ IN]];cbn in EQ;subst bx.
 apply(OUT id ty);eapply PTree.elements_complete;exact IN.
Qed.
Print Assumptions free_environment_permissions.
