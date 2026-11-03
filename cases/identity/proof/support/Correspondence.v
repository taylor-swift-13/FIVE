From Coq Require Import ZArith List Lia.
From compcert Require Import Coqlib Maps Integers Floats Values AST Memory Events Smallstep Globalenvs
  Ctypes Cop Csyntax Csyntaxdefs Csem.
From FiveCases.identity.model Require Import Source.
From FiveCases.identity.proof.support Require Import ParameterWitness.
From FiveCases.identity.proof.support Require Import StepFacts.
From FiveCases.identity.proof.support Require Import PathFacts.
Import ListNotations.
Local Open Scope Z_scope.

Definition parameter_env (b : block) : Csem.env :=
  PTree.set Source._x (b, tfloat) Csem.empty_env.

Lemma parameter_lookup : forall b,
  PTree.get Source._x (parameter_env b) = Some (b, tfloat).
Proof. intro; apply PTree.gss. Qed.

Lemma parameter_blocks : forall ge b,
  Csem.blocks_of_env ge (parameter_env b) = [(b, 0, 4)].
Proof. intros; reflexivity. Qed.

Lemma parameter_alloc : forall ge memory allocated b,
  Mem.alloc memory 0 4 = (allocated, b) ->
  Csem.alloc_variables ge Csem.empty_env memory
    (fn_params Source.f_five_identity ++ fn_vars Source.f_five_identity)
    (parameter_env b) allocated.
Proof.
  intros. econstructor; [exact H | constructor].
Qed.

Lemma parameter_bind : forall ge allocated b initialized value,
  Mem.store Mfloat32 allocated b 0 (Vsingle value) = Some initialized ->
  Csem.bind_parameters ge (parameter_env b) allocated
    (fn_params Source.f_five_identity) [Vsingle value] initialized.
Proof.
  intros. econstructor.
  - apply parameter_lookup.
  - eapply Csem.assign_loc_value with (chunk := Mfloat32).
    + reflexivity.
    + reflexivity.
    + unfold Mem.storev. rewrite Ptrofs.unsigned_zero.
      rewrite zle_true; [exact H | change (4 <= 18446744073709551616); lia].
  - constructor.
Qed.

Lemma parameter_release : forall ge b initialized released,
  Mem.free initialized b 0 4 = Some released ->
  Mem.free_list initialized (Csem.blocks_of_env ge (parameter_env b)) = Some released.
Proof. intros; rewrite parameter_blocks. simpl. rewrite H. reflexivity. Qed.

Lemma alloc_single_inv : forall ge e memory id ty e' memory',
  Csem.alloc_variables ge e memory [(id,ty)] e' memory' ->
  exists allocated b,
    Mem.alloc memory 0 (sizeof ge ty) = (allocated,b) /\
    e' = PTree.set id (b,ty) e /\ memory' = allocated.
Proof.
  intros ge e memory id ty e' memory' ALLOCV.
  inversion ALLOCV; subst.
  match goal with H : Csem.alloc_variables _ _ _ [] _ _ |- _ => inversion H; subst end.
  eexists; eexists; repeat split; eauto.
Qed.

Lemma bind_single_inv : forall ge allocated b value initialized,
  Csem.bind_parameters ge (parameter_env b) allocated
    [(Source._x,tfloat)] [Vsingle value] initialized ->
  Mem.store Mfloat32 allocated b 0 (Vsingle value) = Some initialized.
Proof.
  intros ge allocated b value initialized BIND.
  inversion BIND; subst.
  match goal with H : PTree.get _ (parameter_env _) = _ |- _ =>
    rewrite parameter_lookup in H; inversion H; subst end.
  match goal with H : Csem.bind_parameters _ _ _ [] [] _ |- _ => inversion H; subst end.
  match goal with H : Csem.assign_loc _ _ _ _ _ _ _ _ _ _ |- _ =>
    inversion H; subst; try discriminate end.
  match goal with H : access_mode tfloat = By_value ?chunk |- _ =>
    change (By_value Mfloat32 = By_value chunk) in H; inversion H; subst end.
  match goal with H : Mem.storev _ _ _ _ = _ |- _ =>
    unfold Mem.storev in H; rewrite Ptrofs.unsigned_zero in H;
    rewrite zle_true in H by (change (4 <= 18446744073709551616); lia);
    exact H end.
Qed.

Lemma source_call_unique : forall ge input memory allocated parameter initialized t next,
  Mem.alloc memory 0 4 = (allocated,parameter) ->
  Mem.store Mfloat32 allocated parameter 0 (Vsingle (Float32.of_bits input)) = Some initialized ->
  Csem.step ge
    (Csem.Callstate (Internal Source.f_five_identity)
      [Vsingle (Float32.of_bits input)] Csem.Kstop memory) t next ->
  t = E0 /\ next = Csem.State Source.f_five_identity
    (fn_body Source.f_five_identity) Csem.Kstop (parameter_env parameter) initialized.
Proof.
  intros ge input memory allocated parameter initialized t next ALLOC STORE [ES|SS].
  - inversion ES.
  - inversion SS; subst.
    match goal with H : Csem.alloc_variables _ _ _ _ _ _ |- _ =>
      destruct (alloc_single_inv _ _ _ _ _ _ _ H)
        as [allocated' [parameter' [A [ENV MEM]]]] end.
    change (Mem.alloc memory 0 4 = (allocated',parameter')) in A.
    rewrite ALLOC in A. inversion A; subst.
    match goal with H : Csem.bind_parameters _ _ _ _ _ _ |- _ =>
      apply bind_single_inv in H; rewrite STORE in H; inversion H; subst end.
    split; reflexivity.
Qed.

Theorem source_execution : forall ge input memory,
  exists released,
    execute input memory = Done (Float32.of_bits input) released /\
    Smallstep.star Csem.step ge
      (Csem.Callstate (Internal Source.f_five_identity)
        [Vsingle (Float32.of_bits input)] Csem.Kstop memory) E0
      (Csem.Returnstate (Vsingle (Float32.of_bits input)) Csem.Kstop released).
Proof.
  intros ge input memory.
  destruct (execution_operations input memory)
    as [allocated [parameter [initialized [released [ALLOC [STORE [LOAD [FREE EXEC]]]]]]]].
  exists released. split; [exact EXEC |].
  eapply star_step with (t1 := E0) (t2 := E0).
  - right. eapply Csem.step_internal_function.
    + repeat constructor; simpl; intuition.
    + eapply parameter_alloc; eauto.
    + eapply parameter_bind; eauto.
  - eapply star_step with (t1 := E0) (t2 := E0).
    + right. apply Csem.step_return_1.
    + eapply star_step with (t1 := E0) (t2 := E0).
      * left. eapply Csem.step_lred with (C := fun a => Evalof a tfloat).
        -- apply Csem.red_var_local. apply parameter_lookup.
        -- apply Csem.ctx_rvalof. apply Csem.ctx_top.
      * eapply star_step with (t1 := E0) (t2 := E0).
        -- left. eapply Csem.step_rred with (C := fun a => a).
           ++ apply Csem.red_rvalof. eapply Csem.deref_loc_value with (chunk := Mfloat32).
              ** reflexivity.
              ** reflexivity.
              ** unfold Mem.loadv. rewrite Ptrofs.unsigned_zero.
                 rewrite zle_true; [exact LOAD | change (4 <= 18446744073709551616); lia].
           ++ apply Csem.ctx_top.
        -- apply star_one. right. eapply Csem.step_return_2.
           ++ reflexivity.
           ++ eapply parameter_release; eauto.
        -- reflexivity.
      * reflexivity.
    + reflexivity.
  - reflexivity.
Qed.

Theorem source_return_bits : forall input memory,
  exists released,
    Smallstep.star Csem.step (Csem.globalenv Source.prog)
      (Csem.Callstate (Internal Source.f_five_identity)
        [Vsingle (Float32.of_bits input)] Csem.Kstop memory) E0
      (Csem.Returnstate (Vsingle (Float32.of_bits input)) Csem.Kstop released) /\
    Float32.to_bits (Float32.of_bits input) = input /\
    Mem.unchanged_on (fun b _ => Mem.valid_block memory b) memory released.
Proof.
  intros input memory.
  destruct (source_execution (Csem.globalenv Source.prog) input memory) as [released [EXEC PATH]].
  exists released. split; [exact PATH |]. split.
  - apply Float32.to_of_bits.
  - eapply execution_frame; eauto.
Qed.

Theorem source_execution_certificate : forall ge input memory,
  exists released,
    execute input memory = Done (Float32.of_bits input) released /\
    certified_path ge
      (Csem.Callstate (Internal Source.f_five_identity)
        [Vsingle (Float32.of_bits input)] Csem.Kstop memory)
      (Csem.Returnstate (Vsingle (Float32.of_bits input)) Csem.Kstop released) 5.
Proof.
  intros ge input memory.
  destruct (execution_operations input memory)
    as [allocated [parameter [initialized [released [ALLOC [STORE [LOAD [FREE EXEC]]]]]]]].
  exists released. split; [exact EXEC |].
  eapply cp_step.
  - right. eapply Csem.step_internal_function.
    + repeat constructor; simpl; intuition.
    + eapply parameter_alloc; eauto.
    + eapply parameter_bind; eauto.
  - intros. eapply source_call_unique; eauto.
  - eapply cp_step.
    + right. apply Csem.step_return_1.
    + intros. eapply step_return1_unique; eauto.
    + eapply cp_step.
      * left. eapply Csem.step_lred with (C := fun a => Evalof a tfloat).
        -- apply Csem.red_var_local. apply parameter_lookup.
        -- apply Csem.ctx_rvalof. apply Csem.ctx_top.
      * intros. eapply step_evalof_var_unique; eauto. apply parameter_lookup.
      * eapply cp_step.
        -- left. eapply Csem.step_rred with (C := fun a => a).
           ++ apply Csem.red_rvalof. eapply Csem.deref_loc_value with (chunk := Mfloat32).
              ** reflexivity.
              ** reflexivity.
              ** unfold Mem.loadv. rewrite Ptrofs.unsigned_zero.
                 rewrite zle_true; [exact LOAD | change (4 <= 18446744073709551616); lia].
           ++ apply Csem.ctx_top.
        -- intros. eapply step_evalof_float_unique; eauto.
           unfold Mem.loadv. rewrite Ptrofs.unsigned_zero.
           rewrite zle_true; [exact LOAD | change (4 <= 18446744073709551616); lia].
        -- eapply cp_step.
           ++ right. eapply Csem.step_return_2.
              ** reflexivity.
              ** eapply parameter_release; eauto.
           ++ intros. eapply step_return2_unique; eauto.
              ** reflexivity.
              ** eapply parameter_release; eauto.
           ++ apply cp_done. intros. eapply no_step_Returnstate_Kstop; eauto.
Qed.

Theorem source_normal_result_unique : forall ge input memory output released trace,
  Smallstep.star Csem.step ge
    (Csem.Callstate (Internal Source.f_five_identity)
      [Vsingle (Float32.of_bits input)] Csem.Kstop memory) trace
    (Csem.Returnstate output Csem.Kstop released) ->
  output = Vsingle (Float32.of_bits input) /\ trace = E0 /\
  execute input memory = Done (Float32.of_bits input) released.
Proof.
  intros ge input memory output released trace RUN.
  destruct (source_execution_certificate ge input memory) as [released' [EXEC CERT]].
  destruct (certificate_maximal _ _ _ _ CERT _ _ RUN)
    as [EQ TRACE].
  - unfold Smallstep.nostep. intros t next HS. eapply no_step_Returnstate_Kstop; eauto.
  - inversion EQ; subst. auto.
Qed.

Theorem source_never_stuck : forall ge input memory trace,
  ~ Smallstep.star Csem.step ge
    (Csem.Callstate (Internal Source.f_five_identity)
      [Vsingle (Float32.of_bits input)] Csem.Kstop memory) trace Csem.Stuckstate.
Proof.
  intros ge input memory trace RUN.
  destruct (source_execution_certificate ge input memory) as [released [EXEC CERT]].
  destruct (certificate_maximal _ _ _ _ CERT _ _ RUN) as [EQ TRACE].
  - unfold Smallstep.nostep. intros t next [ES|SS]; inversion ES || inversion SS.
  - discriminate EQ.
Qed.

Theorem source_no_divergence : forall ge input memory infinite_trace,
  ~ Smallstep.forever Csem.step ge
    (Csem.Callstate (Internal Source.f_five_identity)
      [Vsingle (Float32.of_bits input)] Csem.Kstop memory) infinite_trace.
Proof.
  intros ge input memory infinite_trace.
  destruct (source_execution_certificate ge input memory) as [released [EXEC CERT]].
  eapply certificate_no_forever; eauto.
Qed.

Theorem source_step_bound : forall ge input memory steps trace reached,
  Smallstep.starN Csem.step ge steps
    (Csem.Callstate (Internal Source.f_five_identity)
      [Vsingle (Float32.of_bits input)] Csem.Kstop memory) trace reached ->
  (steps <= 5)%nat.
Proof.
  intros ge input memory steps trace reached RUN.
  destruct (source_execution_certificate ge input memory) as [released [EXEC CERT]].
  eapply certificate_starN_bounded; eauto.
Qed.

Example actual_source_symbol : exists b,
  Genv.find_symbol (Csem.globalenv Source.prog) Source._five_identity = Some b /\
  Genv.find_funct_ptr (Csem.globalenv Source.prog) b = Some (Internal Source.f_five_identity).
Proof. eexists; split; vm_compute; reflexivity. Qed.
