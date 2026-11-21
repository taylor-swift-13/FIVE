From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactorySemantics CoreClamp.
From PidPositionSafety Require Import MappedEntrySafety ReachableAccess ReachableCopy.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Transparent FactorySemantics.ge.
Inductive pointer_kind:=PointerNull|PointerInvalid|PointerDeallocated|PointerDead|PointerBounds|PointerInteger.
Definition pointer_check(kind:pointer_kind)(m:mem)(b:block)(ofs:ptrofs)(n:Z):Prop:=
 readable_span m b(Ptrofs.unsigned ofs)n /\
 match kind with
 | PointerNull=>Vptr b ofs<>Vint Int.zero/\Vptr b ofs<>Vlong Int64.zero
 | PointerInvalid=>Mem.valid_pointer m b(Ptrofs.unsigned ofs)=true
 | PointerDeallocated=>Mem.perm m b(Ptrofs.unsigned ofs)Cur Readable
 | PointerDead=>Mem.valid_block m b
 | PointerBounds=>Mem.range_perm m b(Ptrofs.unsigned ofs)(Ptrofs.unsigned ofs+n)Cur Readable
 | PointerInteger=>exists bb oo,Vptr b ofs=Vptr bb oo/\Mem.valid_block m bb
 end.
Lemma span_checks:forall kind m b ofs n,
 readable_span m b(Ptrofs.unsigned ofs)n ->pointer_check kind m b ofs n.
Proof.
 intros kind m b ofs n SP;split;[exact SP|].
 destruct SP as[POS LIVE READ VALID N32 N64];destruct kind;cbn.
 - split;discriminate.
 - exact VALID.
 - apply READ;lia.
 - exact LIVE.
 - exact READ.
 - exists b,ofs;auto.
Qed.
Inductive entry_site:=RefPosX|CachedPosX|RefPosY|CachedPosY|RefSpeedX|CachedSpeedX|RefSpeedY|CachedSpeedY.
Definition site_block(site:entry_site)(gh sb:block):block:=match site with
 | RefPosX|RefPosY|RefSpeedX|RefSpeedY=>gh|_=>sb end.
Definition site_offset(site:entry_site):Z:=match site with
 | RefPosX=>44|RefPosY=>48|RefSpeedX=>52|RefSpeedY=>56
 | CachedPosX=>100|CachedPosY=>104|CachedSpeedX=>296|CachedSpeedY=>300 end.
Definition is_reference(site:entry_site):bool:=match site with
 | RefPosX|RefPosY|RefSpeedX|RefSpeedY=>true|_=>false end.
(** Object extent is mapped at the original input object; the ready scalar
    access below is checked in the actual current execution memory.
    gh->ref has a 24-byte C object, with four-byte scalar field accesses. *)
Definition EntryPointerGoal(site:entry_site)(kind:pointer_kind):Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 forall sb,Genv.find_symbol E.ge S._state=Some sb ->
 forall t C k e ma,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState S.f_guidance_pid_h_run_pos
  (C(ready_read(site_block site gh sb)(Ptrofs.repr(site_offset site))tint))k e ma) ->
 context RV RV C ->
 pointer_check kind ma(site_block site gh sb)(Ptrofs.repr(site_offset site))4 /\
 (if is_reference site then readable_span m gh 44 24 else True).
Theorem original_entry_pointer_at_point:forall site kind,EntryPointerGoal site kind.
Proof.
 intros site kind m gh ret flight GOOD sb STATE t C k e ma PATH CT.
 split.
 - apply span_checks;eapply original_ready_int32_read_span;[exact GOOD|exact PATH|exact CT].
 - destruct site;cbn[is_reference];try exact I;
   exact(proj1(original_entry_pointer_contract m gh ret GOOD)).
Qed.
(** The static type/offset binding for all eight original scalar accesses. *)
Theorem original_entry_scalar_layout:
 path_info gh_type[S._ref;S._pos;S._x]=Some(tint,44) /\
 path_info gh_type[S._ref;S._pos;S._y]=Some(tint,48) /\
 path_info gh_type[S._ref;S._speed;S._x]=Some(tint,52) /\
 path_info gh_type[S._ref;S._speed;S._y]=Some(tint,56) /\
 path_info state_type[S._ned_pos_i;S._x]=Some(tint,100) /\
 path_info state_type[S._ned_pos_i;S._y]=Some(tint,104) /\
 path_info state_type[S._ned_speed_i;S._x]=Some(tint,296) /\
 path_info state_type[S._ned_speed_i;S._y]=Some(tint,300).
Proof. repeat split;reflexivity. Qed.
Definition FactoryPointerGoal(kind:pointer_kind):Prop:=
 forall m gh ret flight,InputGood m gh ret ->
 forall t C k e ma dst src od os,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState S.f_stab_sp_from_ltp_i
 (C(ready_copy dst src od os(Tstruct S._Int32Vect2 noattr)))k e ma) ->
 context RV RV C ->pointer_check kind ma src os 8.
Lemma original_vty_size:sizeof E.ge(Tstruct S._Int32Vect2 noattr)=8.
Proof.
 change(sizeof FactorySemantics.ge(Tstruct S._Int32Vect2 noattr)=8).
 rewrite FactorySemantics.ge_ce;reflexivity.
Qed.
Theorem original_factory_pointer_at_point:forall kind,FactoryPointerGoal kind.
Proof.
 intros kind m gh ret flight GOOD t C k e ma dst src od os PATH CT.
 apply span_checks;rewrite <-original_vty_size.
 eapply original_ready_copy_span;[exact GOOD|exact PATH|exact CT|reflexivity|reflexivity|rewrite original_vty_size;lia].
Qed.
Definition factory_vector_source_statement:=top_statement 2(fn_body S.f_stab_sp_from_ltp_i).
Theorem original_factory_vector_type:
 match factory_vector_source_statement with
 | Sdo(Eassign _ rhs ty)=>typeof rhs=Tstruct S._Int32Vect2 noattr/\ty=Tstruct S._Int32Vect2 noattr
 | _=>False end.
Proof. split;reflexivity. Qed.
Print Assumptions original_entry_pointer_at_point.
Print Assumptions original_factory_pointer_at_point.

Definition entry_pointer_dereference_1 : EntryPointerGoal RefPosX PointerNull :=
 original_entry_pointer_at_point RefPosX PointerNull.

Definition entry_pointer_dereference_2 : EntryPointerGoal RefPosX PointerInvalid :=
 original_entry_pointer_at_point RefPosX PointerInvalid.

Definition entry_pointer_dereference_3 : EntryPointerGoal RefPosX PointerDeallocated :=
 original_entry_pointer_at_point RefPosX PointerDeallocated.

Definition entry_pointer_dereference_4 : EntryPointerGoal RefPosX PointerDead :=
 original_entry_pointer_at_point RefPosX PointerDead.

Definition entry_pointer_dereference_5 : EntryPointerGoal RefPosX PointerBounds :=
 original_entry_pointer_at_point RefPosX PointerBounds.

Definition entry_pointer_dereference_6 : EntryPointerGoal RefPosX PointerInteger :=
 original_entry_pointer_at_point RefPosX PointerInteger.

Definition entry_pointer_dereference_7 : EntryPointerGoal CachedPosX PointerNull :=
 original_entry_pointer_at_point CachedPosX PointerNull.

Definition entry_pointer_dereference_8 : EntryPointerGoal CachedPosX PointerInvalid :=
 original_entry_pointer_at_point CachedPosX PointerInvalid.

Definition entry_pointer_dereference_9 : EntryPointerGoal CachedPosX PointerDeallocated :=
 original_entry_pointer_at_point CachedPosX PointerDeallocated.

Definition entry_pointer_dereference_10 : EntryPointerGoal CachedPosX PointerDead :=
 original_entry_pointer_at_point CachedPosX PointerDead.

Definition entry_pointer_dereference_11 : EntryPointerGoal CachedPosX PointerBounds :=
 original_entry_pointer_at_point CachedPosX PointerBounds.

Definition entry_pointer_dereference_12 : EntryPointerGoal CachedPosX PointerInteger :=
 original_entry_pointer_at_point CachedPosX PointerInteger.

Definition entry_pointer_dereference_13 : EntryPointerGoal RefPosY PointerNull :=
 original_entry_pointer_at_point RefPosY PointerNull.

Definition entry_pointer_dereference_14 : EntryPointerGoal RefPosY PointerInvalid :=
 original_entry_pointer_at_point RefPosY PointerInvalid.

Definition entry_pointer_dereference_15 : EntryPointerGoal RefPosY PointerDeallocated :=
 original_entry_pointer_at_point RefPosY PointerDeallocated.

Definition entry_pointer_dereference_16 : EntryPointerGoal RefPosY PointerDead :=
 original_entry_pointer_at_point RefPosY PointerDead.

Definition entry_pointer_dereference_17 : EntryPointerGoal RefPosY PointerBounds :=
 original_entry_pointer_at_point RefPosY PointerBounds.

Definition entry_pointer_dereference_18 : EntryPointerGoal RefPosY PointerInteger :=
 original_entry_pointer_at_point RefPosY PointerInteger.

Definition entry_pointer_dereference_19 : EntryPointerGoal CachedPosY PointerNull :=
 original_entry_pointer_at_point CachedPosY PointerNull.

Definition entry_pointer_dereference_20 : EntryPointerGoal CachedPosY PointerInvalid :=
 original_entry_pointer_at_point CachedPosY PointerInvalid.

Definition entry_pointer_dereference_21 : EntryPointerGoal CachedPosY PointerDeallocated :=
 original_entry_pointer_at_point CachedPosY PointerDeallocated.

Definition entry_pointer_dereference_22 : EntryPointerGoal CachedPosY PointerDead :=
 original_entry_pointer_at_point CachedPosY PointerDead.

Definition entry_pointer_dereference_23 : EntryPointerGoal CachedPosY PointerBounds :=
 original_entry_pointer_at_point CachedPosY PointerBounds.

Definition entry_pointer_dereference_24 : EntryPointerGoal CachedPosY PointerInteger :=
 original_entry_pointer_at_point CachedPosY PointerInteger.

Definition entry_pointer_dereference_25 : EntryPointerGoal RefSpeedX PointerNull :=
 original_entry_pointer_at_point RefSpeedX PointerNull.

Definition entry_pointer_dereference_26 : EntryPointerGoal RefSpeedX PointerInvalid :=
 original_entry_pointer_at_point RefSpeedX PointerInvalid.

Definition entry_pointer_dereference_27 : EntryPointerGoal RefSpeedX PointerDeallocated :=
 original_entry_pointer_at_point RefSpeedX PointerDeallocated.

Definition entry_pointer_dereference_28 : EntryPointerGoal RefSpeedX PointerDead :=
 original_entry_pointer_at_point RefSpeedX PointerDead.

Definition entry_pointer_dereference_29 : EntryPointerGoal RefSpeedX PointerBounds :=
 original_entry_pointer_at_point RefSpeedX PointerBounds.

Definition entry_pointer_dereference_30 : EntryPointerGoal RefSpeedX PointerInteger :=
 original_entry_pointer_at_point RefSpeedX PointerInteger.

Definition entry_pointer_dereference_31 : EntryPointerGoal CachedSpeedX PointerNull :=
 original_entry_pointer_at_point CachedSpeedX PointerNull.

Definition entry_pointer_dereference_32 : EntryPointerGoal CachedSpeedX PointerInvalid :=
 original_entry_pointer_at_point CachedSpeedX PointerInvalid.

Definition entry_pointer_dereference_33 : EntryPointerGoal CachedSpeedX PointerDeallocated :=
 original_entry_pointer_at_point CachedSpeedX PointerDeallocated.

Definition entry_pointer_dereference_34 : EntryPointerGoal CachedSpeedX PointerDead :=
 original_entry_pointer_at_point CachedSpeedX PointerDead.

Definition entry_pointer_dereference_35 : EntryPointerGoal CachedSpeedX PointerBounds :=
 original_entry_pointer_at_point CachedSpeedX PointerBounds.

Definition entry_pointer_dereference_36 : EntryPointerGoal CachedSpeedX PointerInteger :=
 original_entry_pointer_at_point CachedSpeedX PointerInteger.

Definition entry_pointer_dereference_37 : EntryPointerGoal RefSpeedY PointerNull :=
 original_entry_pointer_at_point RefSpeedY PointerNull.

Definition entry_pointer_dereference_38 : EntryPointerGoal RefSpeedY PointerInvalid :=
 original_entry_pointer_at_point RefSpeedY PointerInvalid.

Definition entry_pointer_dereference_39 : EntryPointerGoal RefSpeedY PointerDeallocated :=
 original_entry_pointer_at_point RefSpeedY PointerDeallocated.

Definition entry_pointer_dereference_40 : EntryPointerGoal RefSpeedY PointerDead :=
 original_entry_pointer_at_point RefSpeedY PointerDead.

Definition entry_pointer_dereference_41 : EntryPointerGoal RefSpeedY PointerBounds :=
 original_entry_pointer_at_point RefSpeedY PointerBounds.

Definition entry_pointer_dereference_42 : EntryPointerGoal RefSpeedY PointerInteger :=
 original_entry_pointer_at_point RefSpeedY PointerInteger.

Definition entry_pointer_dereference_43 : EntryPointerGoal CachedSpeedY PointerNull :=
 original_entry_pointer_at_point CachedSpeedY PointerNull.

Definition entry_pointer_dereference_44 : EntryPointerGoal CachedSpeedY PointerInvalid :=
 original_entry_pointer_at_point CachedSpeedY PointerInvalid.

Definition entry_pointer_dereference_45 : EntryPointerGoal CachedSpeedY PointerDeallocated :=
 original_entry_pointer_at_point CachedSpeedY PointerDeallocated.

Definition entry_pointer_dereference_46 : EntryPointerGoal CachedSpeedY PointerDead :=
 original_entry_pointer_at_point CachedSpeedY PointerDead.

Definition entry_pointer_dereference_47 : EntryPointerGoal CachedSpeedY PointerBounds :=
 original_entry_pointer_at_point CachedSpeedY PointerBounds.

Definition entry_pointer_dereference_48 : EntryPointerGoal CachedSpeedY PointerInteger :=
 original_entry_pointer_at_point CachedSpeedY PointerInteger.

Definition factory_pointer_dereference_1 : FactoryPointerGoal PointerNull :=
 original_factory_pointer_at_point PointerNull.

Definition factory_pointer_dereference_2 : FactoryPointerGoal PointerInvalid :=
 original_factory_pointer_at_point PointerInvalid.

Definition factory_pointer_dereference_3 : FactoryPointerGoal PointerDeallocated :=
 original_factory_pointer_at_point PointerDeallocated.

Definition factory_pointer_dereference_4 : FactoryPointerGoal PointerDead :=
 original_factory_pointer_at_point PointerDead.

Definition factory_pointer_dereference_5 : FactoryPointerGoal PointerBounds :=
 original_factory_pointer_at_point PointerBounds.

Definition factory_pointer_dereference_6 : FactoryPointerGoal PointerInteger :=
 original_factory_pointer_at_point PointerInteger.
