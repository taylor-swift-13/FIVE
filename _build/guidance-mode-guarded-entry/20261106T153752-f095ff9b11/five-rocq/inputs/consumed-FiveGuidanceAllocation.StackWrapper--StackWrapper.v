From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csem Cexec.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry BigstepSupport.
From FiveGuidanceAllocation Require Import Allocation StackAllocation.
Import ListNotations.
Local Open Scope Z_scope.
Lemma prepare_vector_entry : forall (ge:Csem.genv) vars pid vt m s bg bc src o x y,
 sizeof ge vt=8 -> alignof_blockcopy ge vt=4 -> access_mode vt=By_copy ->
 NoDup(map fst((pid,vt)::vars)) -> repr s m bg -> writable m bg ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle fixed_maximum) ->
 Mem.load Mfloat32 m src(Ptrofs.unsigned o)=Some(Vsingle x) ->
 Mem.load Mfloat32 m src(Ptrofs.unsigned o+4)=Some(Vsingle y) ->
 exists e ma mb param,
 alloc_variables ge empty_env m ((pid,vt)::vars)e ma /\
 bind_parameters ge e ma[(pid,vt)][Vptr src o]mb /\
 e!pid=Some(param,vt) /\
 Mem.load Mfloat32 mb param 0=Some(Vsingle x) /\
 Mem.load Mfloat32 mb param 4=Some(Vsingle y) /\
 repr s mb bg /\ writable mb bg /\
 Mem.load Mfloat32 mb bc 0=Some(Vsingle fixed_maximum) /\
 env_separated e /\
 (forall id,~In id(map fst((pid,vt)::vars))->e!id=None) /\
 (forall id ty,In(id,ty)((pid,vt)::vars)->
 exists b,e!id=Some(b,ty) /\ ~Mem.valid_block m b /\
 Mem.range_perm mb b 0(sizeof ge ty)Cur Freeable).
Proof.
 intros ge vars pid vt m s bg bc src o x y SIZE ALIGN MODE ND REP WR CONST LX LY.
 set(decl:=(pid,vt)::vars).
 destruct(Cexec.do_alloc_variables ge empty_env m decl)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables ge empty_env m decl e ma).
 { pose proof(Cexec.do_alloc_variables_sound ge decl empty_env m)as A;rewrite ALLOC in A;exact A. }
 destruct(allocated_variable ge decl empty_env m pid vt ND ltac:(left;reflexivity))as[param[LOOK[FRESH[VB FREE]]]].
 rewrite ALLOC in LOOK,VB,FREE;simpl in LOOK,VB,FREE.
 assert(VALIDSRC:Mem.valid_block m src).
 { eapply Mem.valid_access_valid_block with(chunk:=Mfloat32)(ofs:=Ptrofs.unsigned o).
   eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact LX|constructor]. }
 assert(VALIDG:Mem.valid_block m bg).
 { eapply Mem.perm_valid_block with(ofs:=0)(k:=Cur)(p:=Writable);apply WR;lia. }
 assert(VALIDC:Mem.valid_block m bc).
 { eapply Mem.valid_access_valid_block with(chunk:=Mfloat32)(ofs:=0).
   eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact CONST|constructor]. }
 assert(DS:param<>src)by(intro EQ;subst;contradiction).
 assert(DG:bg<>param)by(intro EQ;subst;contradiction).
 assert(DC:bc<>param)by(intro EQ;subst;contradiction).
 assert(WRP:Mem.range_perm ma param 0 8 Cur Writable).
 { rewrite <- SIZE;intros ofs RNG;eapply Mem.perm_implies;[apply FREE;exact RNG|constructor]. }
 assert(LXA:Mem.load Mfloat32 ma src(Ptrofs.unsigned o)=Some(Vsingle x)).
 { pose proof(allocation_load ge decl empty_env m _ _ _ _ LX)as H;rewrite ALLOC in H;exact H. }
 assert(LYA:Mem.load Mfloat32 ma src(Ptrofs.unsigned o+4)=Some(Vsingle y)).
 { pose proof(allocation_load ge decl empty_env m _ _ _ _ LY)as H;rewrite ALLOC in H;exact H. }
 destruct(bind_vector_parameter ge e vt pid ma param src o x y SIZE ALIGN MODE LOOK DS WRP LXA LYA)
 as[mb[bytes[BIND[PX[PY[BIN[BOUT[ACCESS[FRAME BYTEFRAME]]]]]]]]].
 assert(PERM:forall b ofs k p,Mem.perm ma b ofs k p->Mem.perm mb b ofs k p).
 { eapply single_copy_bind_preserves_perm;[exact MODE|exact BIND]. }
 assert(RA:repr s ma bg).
 { unfold repr in *;repeat match goal with H:_ /\ _ |- _=>destruct H end;repeat split;
   match goal with |- Mem.load ?ch ma bg ?ofs=Some ?v=>
    pose proof(allocation_load ge decl empty_env m ch bg ofs v ltac:(assumption))as POSTLOAD;rewrite ALLOC in POSTLOAD;exact POSTLOAD end. }
 exists e,ma,mb,param;split;[exact AV|]. split;[exact BIND|]. split;[exact LOOK|].
 split;[exact PX|]. split;[exact PY|]. split.
 - unfold repr in *;repeat match goal with H:_ /\ _ |- _=>destruct H end;repeat split;rewrite FRAME by exact DG;assumption.
 - split.
   + intros ofs RNG;apply PERM.
     pose proof(allocation_perm ge decl empty_env m bg ofs Cur Writable(WR ofs RNG))as H;rewrite ALLOC in H;exact H.
   + split.
     * rewrite FRAME by exact DC.
       pose proof(allocation_load ge decl empty_env m _ _ _ _ CONST)as H;rewrite ALLOC in H;exact H.
     * split.
       -- pose proof(allocation_env_separated ge decl empty_env m ltac:(intros id b ty H;discriminate H)ltac:(intros id1 id2 b ty1 ty2 H;discriminate H))as H.
          rewrite ALLOC in H;exact H.
       -- split.
          ++ intros id NOT;pose proof(allocation_keeps_binding ge decl empty_env m id NOT)as H;rewrite ALLOC in H;exact H.
          ++ intros id ty IN.
             destruct(allocated_variable ge decl empty_env m id ty ND IN)as[b[L[F[V P]]]].
             rewrite ALLOC in L,V,P;simpl in L,V,P.
             exists b;split;[exact L|]. split;[exact F|]. intros ofs RNG;apply PERM;apply P;exact RNG.
Qed.
Print Assumptions prepare_vector_entry.
