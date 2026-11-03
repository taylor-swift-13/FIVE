From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Floats Values Memory Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveCases.lowpass.model Require Import Source.
From FiveCases.lowpass.model Require Import SourceInvariant.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.proof.support Require Import MemorySpec.
Import ListNotations.

(** The ordinary CompCert C function boundary allocates the parameter/local
    blocks.  These lemmas derive their separation from all existing objects;
    callers are not asked to assume that separation independently. *)
Definition env_fresh (e:env) (caller:mem): Prop :=
  forall id b ty, PTree.get id e = Some (b,ty) -> ~Mem.valid_block caller b.
Definition valid_inclusion (m m':mem): Prop :=
  forall b, Mem.valid_block m b -> Mem.valid_block m' b.

Lemma allocated_valid_inclusion:
  forall ge e m vars e' m', alloc_variables ge e m vars e' m' -> valid_inclusion m m'.
Proof.
  intros ge e m vars e' m' H; induction H; unfold valid_inclusion in *; intros; auto.
  eapply IHalloc_variables. eapply Mem.valid_block_alloc; eauto.
Qed.

Lemma allocated_env_fresh_general:
  forall ge e m vars e' m', alloc_variables ge e m vars e' m' ->
  forall caller, valid_inclusion caller m -> env_fresh e caller -> env_fresh e' caller.
Proof.
  intros ge e m vars e' m' H; induction H; intros caller INCL FRESH; auto.
  eapply IHalloc_variables.
  - unfold valid_inclusion in *; intros b VALID. eapply Mem.valid_block_alloc; eauto.
  - unfold env_fresh in *; intros x bx tx LOOK VALID.
    rewrite PTree.gsspec in LOOK. destruct (peq x id).
    + inversion LOOK; subst. eapply Mem.fresh_block_alloc; [exact H|]. apply INCL; exact VALID.
    + eapply FRESH; eauto.
Qed.

Theorem allocated_private_blocks_are_fresh:
  forall ge m vars e ma, alloc_variables ge empty_env m vars e ma -> env_fresh e m.
Proof.
  intros ge m vars e ma A; eapply allocated_env_fresh_general; eauto.
  - intros b V; exact V.
  - intros id b ty H; rewrite PTree.gempty in H; discriminate.
Qed.

Lemma allocation_preserves_old_load:
  forall ge e m vars e' ma, alloc_variables ge e m vars e' ma ->
  forall chunk b ofs, Mem.valid_block m b -> Mem.load chunk ma b ofs = Mem.load chunk m b ofs.
Proof.
  intros ge e m vars e' ma A; induction A; intros chunk bx ofs VALID; auto.
  rewrite IHA by (eapply Mem.valid_block_alloc; eauto).
  eapply Mem.load_alloc_unchanged; eauto.
Qed.
Lemma allocation_preserves_old_bytes:
  forall ge e m vars e' ma, alloc_variables ge e m vars e' ma ->
  forall b ofs n, Mem.valid_block m b -> Mem.loadbytes ma b ofs n = Mem.loadbytes m b ofs n.
Proof.
  intros ge e m vars e' ma A; induction A; intros bx ofs n VALID; auto.
  rewrite IHA by (eapply Mem.valid_block_alloc; eauto).
  eapply Mem.loadbytes_alloc_unchanged; eauto.
Qed.

Definition scalar_parameters (params:list(ident*type)): Prop :=
  Forall (fun p => exists chunk, access_mode (snd p) = By_value chunk /\ type_is_volatile (snd p) = false) params.

Lemma assign_scalar_store:
  forall ge ty m b ofs v t m' v' chunk,
  access_mode ty = By_value chunk -> type_is_volatile ty = false ->
  assign_loc ge ty m b ofs Full v t m' v' -> Mem.storev chunk m (Vptr b ofs) v = Some m'.
Proof.
  intros ge ty m b ofs v t m' v' chunk MODE VOL A; inversion A; subst; try congruence.
Qed.

Lemma binding_preserves_old_load:
  forall ge e ma params args mb, bind_parameters ge e ma params args mb ->
  scalar_parameters params -> forall caller b,
  env_fresh e caller -> Mem.valid_block caller b ->
  forall chunk ofs, Mem.load chunk mb b ofs = Mem.load chunk ma b ofs.
Proof.
  intros ge e ma params args mb B; induction B; intros SC caller bx FRESH VALID chunk ofs; auto.
  inversion SC; subst. destruct H3 as [storechunk [MODE VOL]].
  rewrite (IHB H4 caller bx FRESH VALID chunk ofs).
  assert (STORE: Mem.storev storechunk m (Vptr b Ptrofs.zero) v1 = Some m1)
    by (eapply assign_scalar_store; eauto).
  unfold Mem.storev in STORE.
  match type of STORE with (if ?C then _ else _) = _ => destruct C; try discriminate end.
  eapply (Mem.load_store_other _ _ _ _ _ _ STORE).
  left; intro EQ; subst bx. eapply FRESH; eauto.
Qed.

Lemma binding_preserves_old_bytes:
  forall ge e ma params args mb, bind_parameters ge e ma params args mb ->
  scalar_parameters params -> forall caller b,
  env_fresh e caller -> Mem.valid_block caller b ->
  forall ofs n, Mem.loadbytes mb b ofs n = Mem.loadbytes ma b ofs n.
Proof.
  intros ge e ma params args mb B; induction B; intros SC caller bx FRESH VALID ofs n; auto.
  inversion SC; subst. destruct H3 as [storechunk [MODE VOL]].
  rewrite (IHB H4 caller bx FRESH VALID ofs n).
  assert (STORE: Mem.storev storechunk m (Vptr b Ptrofs.zero) v1 = Some m1)
    by (eapply assign_scalar_store; eauto).
  unfold Mem.storev in STORE.
  match type of STORE with (if ?C then _ else _) = _ => destruct C; try discriminate end.
  eapply (Mem.loadbytes_store_other _ _ _ _ _ _ STORE).
  left; intro EQ; subst bx. eapply FRESH; eauto.
Qed.

Lemma lowpass_parameters_scalar: scalar_parameters (fn_params lowpass_function).
Proof.
  repeat constructor.
  - exists Mptr; split; reflexivity.
  - exists Mfloat32; split; reflexivity.
Qed.

Theorem lowpass_call_preserves_caller_loads:
  forall m e ma args m0,
  alloc_variables lowpass_ge empty_env m (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function) args m0 ->
  forall chunk b ofs, Mem.valid_block m b -> Mem.load chunk m0 b ofs = Mem.load chunk m b ofs.
Proof.
  intros m e ma args m0 A B chunk b ofs VALID.
  rewrite (binding_preserves_old_load _ _ _ _ _ _ B lowpass_parameters_scalar m b
    (allocated_private_blocks_are_fresh _ _ _ _ _ A) VALID chunk ofs).
  eapply allocation_preserves_old_load; eauto.
Qed.

Theorem lowpass_call_preserves_caller_bytes:
  forall m e ma args m0,
  alloc_variables lowpass_ge empty_env m (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function) args m0 ->
  forall b ofs n, Mem.valid_block m b -> Mem.loadbytes m0 b ofs n = Mem.loadbytes m b ofs n.
Proof.
  intros m e ma args m0 A B b ofs n VALID.
  rewrite (binding_preserves_old_bytes _ _ _ _ _ _ B lowpass_parameters_scalar m b
    (allocated_private_blocks_are_fresh _ _ _ _ _ A) VALID ofs n).
  eapply allocation_preserves_old_bytes; eauto.
Qed.

Theorem allocated_env_excludes_caller_object:
  forall ge m vars e ma b,
  alloc_variables ge empty_env m vars e ma -> Mem.valid_block m b ->
  ~In b (HarnessMemory.private_block_ids (blocks_of_env ge e)).
Proof.
  intros ge m vars e ma b A VALID IN.
  unfold HarnessMemory.private_block_ids, blocks_of_env in IN.
  apply in_map_iff in IN as [binding [EQ IN]].
  apply in_map_iff in IN as [[id [bx ty]] [EB IN]].
  unfold block_of_binding in EB; simpl in EB; subst binding; simpl in EQ; subst bx.
  eapply (allocated_private_blocks_are_fresh _ _ _ _ _ A id b ty); [|exact VALID].
  apply PTree.elements_complete; exact IN.
Qed.

Theorem lowpass_call_preserves_initialized_object:
  forall m e ma args m0 b s,
  alloc_variables lowpass_ge empty_env m (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function) args m0 ->
  Mem.valid_block m b -> HarnessMemory.initialized_state m b s ->
  HarnessMemory.initialized_state m0 b s.
Proof.
  intros m e ma args m0 b s A B VALID INIT.
  unfold HarnessMemory.initialized_state in *.
  repeat rewrite (lowpass_call_preserves_caller_loads _ _ _ _ _ A B _ b _ VALID).
  exact INIT.
Qed.

Lemma allocation_preserves_valid_access:
  forall ge e m vars e' ma, alloc_variables ge e m vars e' ma ->
  forall chunk b ofs p, Mem.valid_access m chunk b ofs p -> Mem.valid_access ma chunk b ofs p.
Proof.
  intros ge e m vars e' ma A; induction A; intros chunk bx ofs p VALID; auto.
  apply IHA. eapply Mem.valid_access_alloc_other; eauto.
Qed.

Lemma binding_preserves_valid_access:
  forall ge e ma params args mb, bind_parameters ge e ma params args mb ->
  scalar_parameters params -> forall chunk b ofs p,
  Mem.valid_access ma chunk b ofs p -> Mem.valid_access mb chunk b ofs p.
Proof.
  intros ge e ma params args mb B; induction B; intros SC chunk bx ofs p VALID; auto.
  inversion SC; subst. destruct H3 as [storechunk [MODE VOL]].
  apply IHB; auto.
  assert (STORE: Mem.storev storechunk m (Vptr b Ptrofs.zero) v1 = Some m1)
    by (eapply assign_scalar_store; eauto).
  unfold Mem.storev in STORE.
  match type of STORE with (if ?C then _ else _) = _ => destruct C; try discriminate end.
  eapply Mem.store_valid_access_1; eauto.
Qed.

Theorem lowpass_call_preserves_valid_access:
  forall m e ma args m0,
  alloc_variables lowpass_ge empty_env m (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function) args m0 ->
  forall chunk b ofs p, Mem.valid_access m chunk b ofs p -> Mem.valid_access m0 chunk b ofs p.
Proof.
  intros m e ma args m0 A B chunk b ofs p VALID.
  eapply binding_preserves_valid_access; eauto using lowpass_parameters_scalar, allocation_preserves_valid_access.
Qed.

Theorem lowpass_allocated_environment:
  forall m e ma,
  alloc_variables lowpass_ge empty_env m (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  exists bp bv bo,
    PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) /\
    PTree.get Source._value e = Some (bv,tfloat) /\
    PTree.get Source._out e = Some (bo,tfloat) /\
    bp <> bv /\ bp <> bo /\ bv <> bo /\ Mem.valid_access ma Mfloat32 bo 0 Freeable.
Proof.
  intros m e ma A.
  change (alloc_variables lowpass_ge empty_env m
    [(Source._filter,tptr (Tstruct Source._SecondOrderLowPass noattr));
     (Source._value,tfloat);(Source._out,tfloat)] e ma) in A.
  inversion A; subst; clear A.
  repeat match goal with T: alloc_variables _ _ _ (_::_) _ _ |- _ => inversion T; subst; clear T end.
  match goal with T: alloc_variables _ _ _ [] _ _ |- _ => inversion T; subst; clear T end.
  match goal with
  | AP: Mem.alloc m _ _ = (?MP,?BP),
    AV: Mem.alloc ?MP _ _ = (?MV,?BV),
    AO: Mem.alloc ?MV _ _ = (ma,?BO) |- _ =>
    assert (D1: BP <> BV) by
      (intro E; pose proof (Mem.valid_new_block _ _ _ _ _ AP) as V;
       rewrite E in V; exact (Mem.fresh_block_alloc _ _ _ _ _ AV V));
    assert (D2: BP <> BO) by
      (intro E; pose proof (Mem.valid_new_block _ _ _ _ _ AP) as V;
       pose proof (Mem.valid_block_alloc _ _ _ _ _ AV BP V) as V';
       rewrite E in V'; exact (Mem.fresh_block_alloc _ _ _ _ _ AO V'));
    assert (D3: BV <> BO) by
      (intro E; pose proof (Mem.valid_new_block _ _ _ _ _ AV) as V;
       rewrite E in V; exact (Mem.fresh_block_alloc _ _ _ _ _ AO V));
    assert (VA: Mem.valid_access ma Mfloat32 BO 0 Freeable) by
      (eapply (Mem.valid_access_alloc_same _ _ _ _ _ AO);
       [lia|change (0+4<=4)%Z; lia|exists 0; reflexivity]);
    exists BP,BV,BO;
    exact (conj eq_refl (conj eq_refl (conj eq_refl (conj D1 (conj D2 (conj D3 VA))))))
  end.
Qed.

Theorem lowpass_bound_environment:
  forall m e ma args m0,
  alloc_variables lowpass_ge empty_env m (fn_params lowpass_function ++ fn_vars lowpass_function) e ma ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function) args m0 ->
  exists bp bv bo,
    PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) /\
    PTree.get Source._value e = Some (bv,tfloat) /\
    PTree.get Source._out e = Some (bo,tfloat) /\
    bp <> bv /\ bp <> bo /\ bv <> bo /\ Mem.valid_access m0 Mfloat32 bo 0 Freeable.
Proof.
  intros m e ma args m0 A B.
  destruct (lowpass_allocated_environment _ _ _ A) as [bp[bv[bo[E1[E2[E3[D1[D2[D3 VA]]]]]]]]].
  assert (VA0: Mem.valid_access m0 Mfloat32 bo 0 Freeable) by
    (eapply binding_preserves_valid_access; eauto using lowpass_parameters_scalar).
  exists bp,bv,bo; exact (conj E1 (conj E2 (conj E3 (conj D1 (conj D2 (conj D3 VA0)))))).
Qed.

Theorem lowpass_bound_parameter_values:
  forall e ma m0 bp bv b input,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  PTree.get Source._value e = Some (bv,tfloat) -> bp <> bv ->
  bind_parameters lowpass_ge e ma (fn_params lowpass_function)
    [Vptr b Ptrofs.zero;Vsingle (Float32.of_bits input)] m0 ->
  Mem.load Mptr m0 bp 0 = Some (Vptr b Ptrofs.zero) /\
  Mem.load Mfloat32 m0 bv 0 = Some (Vsingle (Float32.of_bits input)).
Proof.
  intros e ma m0 bp bv b input ENVF ENVV DISTINCT BIND.
  change (bind_parameters lowpass_ge e ma
    [(Source._filter,tptr (Tstruct Source._SecondOrderLowPass noattr));(Source._value,tfloat)]
    [Vptr b Ptrofs.zero;Vsingle (Float32.of_bits input)] m0) in BIND.
  inversion BIND as [|mx id ty params vx vl vx' bx mp mf LOOK ASG REST]; subst; clear BIND.
  rewrite ENVF in LOOK; inversion LOOK; subst bx; clear LOOK.
  inversion REST as [|mx2 id2 ty2 params2 vx2 vl2 vx2' bx2 mp2 mf2 LOOK2 ASG2 REST2]; subst; clear REST.
  rewrite ENVV in LOOK2; inversion LOOK2; subst bx2; clear LOOK2.
  inversion REST2; subst; clear REST2.
  assert (SP: Mem.store Mptr ma bp 0 (Vptr b Ptrofs.zero) = Some mp).
  { pose proof (assign_scalar_store lowpass_ge (tptr (Tstruct Source._SecondOrderLowPass noattr))
      ma bp Ptrofs.zero (Vptr b Ptrofs.zero) Events.E0 mp vx' Mptr eq_refl eq_refl ASG) as STORE.
    change (Mem.store Mptr ma bp 0 (Vptr b Ptrofs.zero) = Some mp) in STORE; exact STORE. }
  assert (SV: Mem.store Mfloat32 mp bv 0 (Vsingle (Float32.of_bits input)) = Some m0).
  { pose proof (assign_scalar_store lowpass_ge tfloat mp bv Ptrofs.zero
      (Vsingle (Float32.of_bits input)) Events.E0 m0 vx2' Mfloat32 eq_refl eq_refl ASG2) as STORE.
    change (Mem.store Mfloat32 mp bv 0 (Vsingle (Float32.of_bits input)) = Some m0) in STORE; exact STORE. }
  split.
  - erewrite Mem.load_store_other by (exact SV || (left; exact DISTINCT)).
    erewrite Mem.load_store_same by exact SP; reflexivity.
  - erewrite Mem.load_store_same by exact SV; reflexivity.
Qed.
