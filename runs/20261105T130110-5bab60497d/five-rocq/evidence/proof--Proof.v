From FiveSum2Proof.support Require Import NormalCorrespondence.
From Stdlib Require Import ZArith List Wellfounded Lia.
From compcert Require Import Integers Floats Values Memory Maps AST Coqlib Cop Ctypes Csyntaxdefs Csem Smallstep Events.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveShared.verification Require Import Obligations.
From FiveSum2Proof Require Import SourceInvariant Invariant Entry Termination RecheckSpec.

Theorem main_assertion_1 : RecheckSpec.AssertionGoal.
Proof.
 unfold RecheckSpec.AssertionGoal. intros m t v mf PATH.
 pose proof (sum2_return_value _ _ _ _ _ _ PATH) as RETURN.
 rewrite RETURN. exists (Float32.add input_large input_one).
 split; [reflexivity|]. split; vm_compute; reflexivity.
Qed.

Lemma invariant_return_exists : forall s,
 Acc (successor sum2_ge) s -> execution_invariant s ->
 exists t v mf, star Csem.step sum2_ge s t (Returnstate v Kstop mf).
Proof.
 intros s ACCESS; induction ACCESS as [s ACCESS IH]; intros INV.
 destruct (invariant_progress _ INV) as [[v [mf EQ]] | [t [next STEP]]].
 - subst s. exists E0, v, mf. constructor.
 - destruct (IH next (ex_intro _ t STEP) (invariant_preserved _ _ _ INV STEP)) as [tr [v [mf PATH]]].
   exists (t ** tr), v, mf. eapply star_step; [exact STEP|exact PATH|reflexivity].
Qed.

Lemma typed_invariant : forall m (a b:float32),
 execution_invariant (sum2_start (Vsingle a) (Vsingle b) m).
Proof.
 intros. split; [apply sum2_start_source|]. split; [reflexivity|].
 destruct (typed_entry_result2 m a b) as [mf H]. eexists; exact H.
Qed.

Theorem arbitrary_call_returns : RecheckSpec.ReturnExistsGoal.
Proof.
 unfold RecheckSpec.ReturnExistsGoal. intros m a b.
 apply invariant_return_exists.
 - apply source_accessible. apply sum2_start_source.
 - apply typed_invariant.
Qed.

Theorem arbitrary_call_safe : RecheckSpec.ArbitrarySafetyGoal.
Proof.
 unfold RecheckSpec.ArbitrarySafetyGoal. intros m a b t s PATH.
 apply invariant_excludes_error. eapply reachable_invariant; [apply typed_invariant|exact PATH].
Qed.

Print Assumptions main_assertion_1.
Print Assumptions arbitrary_call_returns.
Print Assumptions arbitrary_call_safe.


Lemma local_assertion_steps : forall br mr f,
 Mem.load Mfloat32 mr br 0 = Some (Vsingle f) ->
 sem_binary_operation sum2_ge Oeq (Vsingle f) tfloat (Vsingle expected) tfloat mr = Some (Vint Int.one) ->
 star Csem.step sum2_ge
   (ExprState sum2_function local_assertion Kstop (local_env br) mr) E0
   (ExprState sum2_function (Csyntax.Eval (Vint Int.one) tint) Kstop (local_env br) mr).
Proof.
 intros br mr f LOAD EQ.
 unfold local_assertion.
 eapply star_step with
  (s2:=ExprState sum2_function
   (Csyntax.Ebinop Oeq (Csyntax.Evalof (Csyntax.Eloc br Ptrofs.zero Full tfloat) tfloat)
    (Csyntax.Eval (Vsingle expected) tfloat) tint) Kstop (local_env br) mr)
  (t1:=E0) (t2:=E0).
 - left. eapply step_lred with
   (C:=fun a=>Csyntax.Ebinop Oeq (Csyntax.Evalof a tfloat) (Csyntax.Eval (Vsingle expected) tfloat) tint).
   + apply red_var_local. unfold local_env;apply PTree.gss.
   + apply ctx_binop_left. apply ctx_rvalof. apply ctx_top.
 - eapply star_step with
   (s2:=ExprState sum2_function
    (Csyntax.Ebinop Oeq (Csyntax.Eval (Vsingle f) tfloat)
     (Csyntax.Eval (Vsingle expected) tfloat) tint) Kstop (local_env br) mr)
   (t1:=E0) (t2:=E0).
   + left. eapply step_rred with
     (C:=fun a=>Csyntax.Ebinop Oeq a (Csyntax.Eval (Vsingle expected) tfloat) tint).
     * apply red_rvalof. eapply deref_loc_value;[reflexivity|reflexivity|].
       unfold Mem.loadv. rewrite Ptrofs.unsigned_zero. rewrite zle_true.
       -- exact LOAD.
       -- change (4<=18446744073709551616)%Z;lia.
     * apply ctx_binop_left. apply ctx_top.
   + eapply star_step with (t1:=E0) (t2:=E0).
     * left. eapply step_rred with (C:=fun a=>a).
       -- apply red_binop. exact EQ.
       -- apply ctx_top.
     * constructor.
     * reflexivity.
   + reflexivity.
 - reflexivity.
Qed.

Theorem full_main_assertion_1 : RecheckSpec.FullAssertionGoal.
Proof.
 unfold RecheckSpec.FullAssertionGoal. intros m t v mf PATH.
 destruct (main_assertion_1 m t v mf PATH) as [f [RETURN [BITS ASSERT]]].
 subst v. destruct (Mem.alloc mf 0 4) as [ma br] eqn:ALLOC.
 assert (ACCESS:Mem.valid_access ma Mfloat32 br 0 Writable).
 { eapply Mem.valid_access_implies.
   - eapply Mem.valid_access_alloc_same; [exact ALLOC|lia|change (0+4<=4);lia|exists 0;reflexivity].
   - constructor. }
 destruct (Mem.valid_access_store ma Mfloat32 br 0 (Vsingle f) ACCESS) as [mr STORE].
 assert (LOAD:Mem.load Mfloat32 mr br 0 = Some (Vsingle f)).
 { erewrite Mem.load_store_same by exact STORE;reflexivity. }
 unfold RecheckSpec.LocalObservation. exists ma, br, mr.
 split; [exact ALLOC|]. split; [reflexivity|]. split; [exact STORE|]. split; [exact LOAD|]. split.
 - assert (READ:pure_rval sum2_ge (local_env br) mr
   (Csyntax.Evalof (Csyntax.Evar local_r tfloat) tfloat) = Some (Vsingle f)).
 { eapply read_parameter with (bx:=br); [unfold local_env;apply PTree.gss|exact LOAD]. }
 change ((match pure_rval sum2_ge (local_env br) mr
    (Csyntax.Evalof (Csyntax.Evar local_r tfloat) tfloat) with
  | Some x => sem_binary_operation sum2_ge Oeq x tfloat (Vsingle expected) tfloat mr
  | None => None end) = Some (Vint Int.one)).
 rewrite READ. pose proof (sum2_return_value _ _ _ _ _ _ PATH) as R.
 inversion R;subst f. vm_compute;reflexivity.
 - apply local_assertion_steps with (f:=f);[exact LOAD|].
   pose proof (sum2_return_value _ _ _ _ _ _ PATH) as R.
   inversion R;subst f. vm_compute;reflexivity.
Qed.
Print Assumptions full_main_assertion_1.
