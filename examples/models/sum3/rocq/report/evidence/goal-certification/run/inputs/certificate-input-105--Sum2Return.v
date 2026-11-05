From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory
 Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveSum2 Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveSum2Proof Require Import SourceInvariant.
From FiveSum2Proof.support Require Import NormalCorrespondence.
From FiveSum2Proof Require Import PureProgress.
From FiveSum2Proof Require Import Invariant.
Import ListNotations.
Local Open Scope Z_scope.

Lemma read_parameter : forall ge e m id bx f,
 PTree.get id e=Some(bx,tfloat) ->
 Mem.load Mfloat32 m bx 0=Some(Vsingle f) ->
 pure_rval ge e m (Evalof(Evar id tfloat)tfloat)=Some(Vsingle f).
Proof.
 intros ge e m id bx f LOOK LOAD.
 cbn [pure_rval pure_lval]. rewrite LOOK.
 repeat rewrite dec_eq_true.
 assert(D:Cexec.do_deref_loc ge quiet_world tfloat m bx Ptrofs.zero Full=
  Some(quiet_world,E0,Vsingle f)).
 { apply Cexec.do_deref_loc_complete.
   - eapply deref_loc_value;[reflexivity|reflexivity|].
     unfold Mem.loadv. rewrite Ptrofs.unsigned_zero.
     rewrite zle_true.
     + exact LOAD.
     + change(4<=18446744073709551616)%Z;lia.
   - constructor. }
 rewrite D;reflexivity.
Qed.

Lemma pure_single_add : forall ge e m a b x y,
 typeof a=tfloat -> typeof b=tfloat ->
 pure_rval ge e m a=Some(Vsingle x) ->
 pure_rval ge e m b=Some(Vsingle y) ->
 pure_rval ge e m(Ebinop Oadd a b tfloat)=Some(Vsingle(Float32.add x y)).
Proof.
 intros ge e m a b x y TA TB A B.
 change((match pure_rval ge e m a,pure_rval ge e m b with
 |Some v,Some w=>sem_binary_operation ge Oadd v(typeof a)w(typeof b)m
 |_,_=>None end)=Some(Vsingle(Float32.add x y))).
 rewrite A,B,TA,TB;reflexivity.
Qed.

Lemma return_single : forall ge e m a f,
 typeof a=tfloat -> pure_rval ge e m a=Some(Vsingle f) ->
 stmt_eval ge e tfloat(Sreturn(Some a))m=Some(Nreturn(Vsingle f),m).
Proof. intros ge e m a f TY READ;cbn [stmt_eval];rewrite READ,TY;reflexivity. Qed.

Definition frame2 (ba bb : block) : env :=
  PTree.set Source._b (bb,tfloat) (PTree.set Source._a (ba,tfloat) empty_env).

Lemma typed_entry_result2 : forall m (a b : float32),
  exists mf, state_eval sum2_ge (sum2_start (Vsingle a) (Vsingle b) m) =
    Some (Vsingle (Float32.add a b), mf).
Proof.
  intros m a b.
  destruct (Mem.alloc m 0 4) as [ma ba] eqn:AA.
  destruct (Mem.alloc ma 0 4) as [mb bb] eqn:AB.
  set (e := frame2 ba bb).
  assert (EA : PTree.get Source._a e = Some (ba,tfloat)) by reflexivity.
  assert (EB : PTree.get Source._b e = Some (bb,tfloat)) by reflexivity.
  assert (ALLOC : alloc_variables sum2_ge empty_env m
    (fn_params sum2_function ++ fn_vars sum2_function) e mb).
  { change (alloc_variables sum2_ge empty_env m [(Source._a,tfloat);(Source._b,tfloat)] e mb).
    eapply alloc_variables_cons; [exact AA|].
    eapply alloc_variables_cons; [exact AB|constructor]. }
  assert (DIST : ba <> bb).
  { intro EQ. pose proof (Mem.valid_new_block _ _ _ _ _ AA) as V.
    rewrite EQ in V. exact (Mem.fresh_block_alloc _ _ _ _ _ AB V). }
  assert (WA : Mem.valid_access mb Mfloat32 ba 0 Freeable).
  { eapply Mem.valid_access_alloc_other; [exact AB|].
    eapply Mem.valid_access_alloc_same; [exact AA|lia|change (0+4<=4);lia|exists 0;reflexivity]. }
  assert (WB : Mem.valid_access mb Mfloat32 bb 0 Freeable).
  { eapply Mem.valid_access_alloc_same; [exact AB|lia|change (0+4<=4);lia|exists 0;reflexivity]. }
  assert (WAW : Mem.valid_access mb Mfloat32 ba 0 Writable)
    by (eapply Mem.valid_access_freeable_any; exact WA).
  destruct (Mem.valid_access_store mb Mfloat32 ba 0 (Vsingle a) WAW) as [m1 SA].
  assert (WBW : Mem.valid_access m1 Mfloat32 bb 0 Writable).
  { eapply Mem.store_valid_access_1; [exact SA|]. eapply Mem.valid_access_freeable_any; exact WB. }
  destruct (Mem.valid_access_store m1 Mfloat32 bb 0 (Vsingle b) WBW) as [m2 SB].
  assert (BIND : bind_parameters sum2_ge e mb (fn_params sum2_function) [Vsingle a;Vsingle b] m2).
  { change (bind_parameters sum2_ge e mb [(Source._a,tfloat);(Source._b,tfloat)] [Vsingle a;Vsingle b] m2).
    eapply bind_parameters_cons with (m1:=m1); [exact EA| |].
    - eapply assign_loc_value; [reflexivity|reflexivity|exact SA].
    - eapply bind_parameters_cons with (m1:=m2); [exact EB| |constructor].
      eapply assign_loc_value; [reflexivity|reflexivity|exact SB]. }
  assert (LA : Mem.load Mfloat32 m2 ba 0 = Some (Vsingle a)).
  { erewrite Mem.load_store_other by (exact SB || (left; exact DIST)).
    erewrite Mem.load_store_same by exact SA; reflexivity. }
  assert (LB : Mem.load Mfloat32 m2 bb 0 = Some (Vsingle b)).
  { erewrite Mem.load_store_same by exact SB; reflexivity. }
  assert (BODY : stmt_eval sum2_ge e tfloat (fn_body sum2_function) m2 =
    Some (Nreturn (Vsingle (Float32.add a b)), m2)).
  { apply return_single; [reflexivity|].
    eapply pure_single_add; [reflexivity|reflexivity| |]; eapply read_parameter; eauto. }
  assert (KEEP : forall b, Mem.valid_access mb Mfloat32 b 0 Freeable ->
    Mem.valid_access m2 Mfloat32 b 0 Freeable).
  { intros bx H. eapply Mem.store_valid_access_1; [exact SB|].
    eapply Mem.store_valid_access_1; [exact SA|exact H]. }
  destruct (Mem.range_perm_free m2 ba 0 4 (proj1 (KEEP _ WA))) as [m3 FA].
  assert (WBF : Mem.valid_access m3 Mfloat32 bb 0 Freeable).
  { eapply Mem.valid_access_free_1; [exact FA|exact (KEEP _ WB)|left; congruence]. }
  destruct (Mem.range_perm_free m3 bb 0 4 (proj1 WBF)) as [mf FB].
  exists mf. cbn [state_eval sum2_start].
  rewrite (do_alloc_variables_complete sum2_ge _ _ _ _ _ ALLOC).
  rewrite (sem_bind_parameters_complete sum2_ge quiet_world _ _ _ _ _ BIND).
  change ((match stmt_eval sum2_ge e tfloat (fn_body sum2_function) m2 with
    | Some (out,mx) => cont_eval sum2_ge e tfloat Kstop out mx | None => None end) = Some (Vsingle (Float32.add a b), mf)).
  rewrite BODY.
  change ((match Mem.free_list m2 [(ba,0,4);(bb,0,4)] with
    | Some mx => Some (Vsingle (Float32.add a b),mx) | None => None end) = Some (Vsingle (Float32.add a b), mf)).
  cbn [Mem.free_list]. rewrite FA,FB. reflexivity.
Qed.

Lemma result_step : forall s t s' result,
 execution_invariant s -> state_eval sum2_ge s = Some result ->
 Csem.step sum2_ge s t s' -> state_eval sum2_ge s' = Some result.
Proof.
 intros s t s' result [SOURCE [NORMAL [old OLD]]] EVAL STEP.
 destruct STEP as [ES|SS].
 - destruct s as [f stmt k e m|f a k e m|fd args k m|v k m|]; try solve[inversion ES].
   exact (normal_estep_forward sum2_ge f a k e m t s' result SOURCE NORMAL EVAL ES).
 - rewrite <- (normal_sstep_denotation _ _ _ _ SOURCE NORMAL SS); exact EVAL.
Qed.

Theorem sum2_return_value : forall m (a b:float32) t v mf,
 star Csem.step sum2_ge (sum2_start (Vsingle a) (Vsingle b) m) t (Returnstate v Kstop mf) ->
 v = Vsingle (Float32.add a b).
Proof.
 intros m a b t v mf PATH.
 destruct (typed_entry_result2 m a b) as [expected INIT].
 assert (INV: execution_invariant (sum2_start (Vsingle a) (Vsingle b) m)). { split; [apply sum2_start_source|]. split; [reflexivity|]. eexists; exact INIT. }
 assert (END: state_eval sum2_ge (Returnstate v Kstop mf) =
              Some (Vsingle (Float32.add a b), expected)).
 { revert INIT INV; induction PATH; intros INIT INV; auto.
   apply IHPATH; [eapply result_step; eauto | eapply invariant_preserved; eauto]. }
 cbn [state_eval] in END; inversion END; reflexivity.
Qed.
Print Assumptions sum2_return_value.
