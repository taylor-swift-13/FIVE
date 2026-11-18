From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Csem.
From FiveGuidanceEntry Require Import Entry BigstepSupport.
Import ListNotations.
Local Open Scope Z_scope.

Lemma storebytes_preserves_access : forall m b ofs bytes mf,
 Mem.storebytes m b ofs bytes=Some mf -> access_preserved m mf.
Proof.
 intros m b ofs bytes mf ST ch bx ox p [PERM ALIGN];split;[|exact ALIGN].
 intros a A;eapply Mem.perm_storebytes_1;[exact ST|apply PERM;exact A].
Qed.

(** A real Csem by-value struct parameter copies all eight memvals, then
    exposes the two typed binary32 fields.  No floating equality is used. *)
Lemma bind_vector_parameter : forall (ge:Csem.genv) e ty id m dst src o x y,
 sizeof ge ty=8 -> alignof_blockcopy ge ty=4 -> access_mode ty=By_copy ->
 e!id=Some(dst,ty) -> dst<>src ->
 Mem.range_perm m dst 0 8 Cur Writable ->
 Mem.load Mfloat32 m src(Ptrofs.unsigned o)=Some(Vsingle x) ->
 Mem.load Mfloat32 m src(Ptrofs.unsigned o+4)=Some(Vsingle y) ->
 exists mf bytes,
 bind_parameters ge e m [(id,ty)] [Vptr src o] mf /\
 Mem.load Mfloat32 mf dst 0=Some(Vsingle x) /\
 Mem.load Mfloat32 mf dst 4=Some(Vsingle y) /\
 Mem.loadbytes m src(Ptrofs.unsigned o)8=Some bytes /\
 Mem.loadbytes mf dst 0 8=Some bytes /\
 access_preserved m mf /\
 (forall ch b ofs, b<>dst -> Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n, b<>dst -> 0<=n -> Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros ge e ty id m dst src o x y SIZE ALIGN MODE LOOK DIST WR LX LY.
 destruct(Mem.load_loadbytes _ _ _ _ _ LX)as[bx[BX DX]].
 destruct(Mem.load_loadbytes _ _ _ _ _ LY)as[byy[BY DY]].
 change(Mem.loadbytes m src(Ptrofs.unsigned o)4=Some bx)in BX.
 change(Mem.loadbytes m src(Ptrofs.unsigned o+4)4=Some byy)in BY.
 assert(LENX:Z.of_nat(length bx)=4).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ BX)as L;rewrite L;reflexivity. }
 assert(LENY:Z.of_nat(length byy)=4).
 { pose proof(Mem.loadbytes_length _ _ _ _ _ BY)as L;rewrite L;reflexivity. }
 assert(BOTH:Mem.loadbytes m src(Ptrofs.unsigned o)8=Some(bx++byy)).
 { eapply Mem.loadbytes_concat with(n1:=4)(n2:=4);eauto;lia. }
 assert(LEN:Z.of_nat(length(bx++byy))=8)by(rewrite length_app,Nat2Z.inj_add,LENX,LENY;lia).
 destruct(Mem.range_perm_storebytes m dst 0(bx++byy)ltac:(rewrite LEN;exact WR))as[mf ST].
 destruct(Mem.storebytes_split _ _ _ _ _ _ ST)as[mi[SX SY]].
 rewrite LENX in SY.
 assert(POSTX:Mem.loadbytes mf dst 0 4=Some bx).
 { erewrite Mem.loadbytes_storebytes_other;[|exact SY|lia|right;left;lia].
   replace 4 with(Z.of_nat(length bx))by exact LENX.
   eapply Mem.loadbytes_storebytes_same;exact SX. }
 assert(POSTY:Mem.loadbytes mf dst 4 4=Some byy).
 { replace 4 with(Z.of_nat(length byy))at 2 by exact LENY.
   eapply Mem.loadbytes_storebytes_same;exact SY. }
 exists mf,(bx++byy);split.
 - eapply bind_parameters_cons;[exact LOOK| |constructor].
   eapply assign_loc_copy with(bytes:=bx++byy);[exact MODE| | |left;congruence| |].
   + rewrite ALIGN;exact(proj2(Mem.load_valid_access _ _ _ _ _ LX)).
   + rewrite ALIGN,Ptrofs.unsigned_zero;exists 0;reflexivity.
   + rewrite SIZE;exact BOTH.
   + rewrite Ptrofs.unsigned_zero;exact ST.
 - split.
   + rewrite DX;eapply Mem.loadbytes_load;[exact POSTX|exists 0;reflexivity].
   + split.
     * rewrite DY;eapply Mem.loadbytes_load;[exact POSTY|exists 1;reflexivity].
     * split;[exact BOTH|]. split.
       -- replace 8 with(Z.of_nat(length(bx++byy)))by exact LEN.
          eapply Mem.loadbytes_storebytes_same;exact ST.
       -- split;[eapply storebytes_preserves_access;exact ST|]. split.
          ++ intros ch b ofs D;eapply Mem.load_storebytes_other;[exact ST|left;exact D].
          ++ intros b ofs n D N;eapply Mem.loadbytes_storebytes_other;[exact ST|lia|left;exact D].
Qed.
Print Assumptions bind_vector_parameter.

Lemma single_copy_bind_preserves_perm : forall ge e m id ty v mf,
 access_mode ty=By_copy -> bind_parameters ge e m [(id,ty)] [v] mf ->
 forall b ofs k p,Mem.perm m b ofs k p -> Mem.perm mf b ofs k p.
Proof.
 intros ge e m id ty v mf MODE BIND b ofs k p PER.
 inversion BIND;subst.
 match goal with H:bind_parameters _ _ _ [] [] _ |- _=>inversion H;subst end.
 match goal with H:assign_loc _ _ _ _ _ _ _ _ _ _ |- _=>inversion H;subst;try congruence end.
 eapply Mem.perm_storebytes_1;eauto.
Qed.
