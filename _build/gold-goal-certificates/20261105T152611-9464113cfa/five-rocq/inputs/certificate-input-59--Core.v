From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Memory Events Globalenvs
 Determinism Ctypes Csyntax Csem Cexec Smallstep.
From FiveSum3 Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveSum3Proof Require Import SourceInvariant.
From FiveSum3Proof.support Require Import NormalCorrespondence.
From FiveSum3Proof Require Import PureProgress.
From FiveSum3Proof Require Import Invariant.
From FiveSum3Proof Require Import Entry.
Import ListNotations.

(* A calling-interface precondition, not a numeric input restriction. *)
Definition sum3_pre(args:list val):Prop :=
 exists a b c:float32,args=[Vsingle a;Vsingle b;Vsingle c].
Definition entry(args:list val)(m:mem):Csem.state :=
 Callstate(Internal sum3_function)args Kstop m.

Theorem sum3_all_reachable_no_error : forall args m,
 sum3_pre args -> forall t reached,
 star Csem.step sum3_ge(entry args m)t reached -> ~source_error reached.
Proof.
 intros args m [a[b[c EQ]]]t reached PATH;subst args.
 apply invariant_excludes_error.
 eapply reachable_invariant;[apply typed_entry_establishes_invariant|exact PATH].
Qed.

Theorem sum3_all_bits_no_error : forall(a b c:int)m t reached,
 star Csem.step sum3_ge
  (entry[Vsingle(Float32.of_bits a);Vsingle(Float32.of_bits b);Vsingle(Float32.of_bits c)]m)
  t reached -> ~source_error reached.
Proof.
 intros;eapply sum3_all_reachable_no_error;[|eassumption].
 unfold sum3_pre;eauto 7.
Qed.

Theorem sum3_progress_at_every_reachable_state : forall args m,
 sum3_pre args -> forall t reached,
 star Csem.step sum3_ge(entry args m)t reached ->
 normal_return reached \/ exists u next,Csem.step sum3_ge reached u next.
Proof.
 intros args m [a[b[c EQ]]]t reached PATH;subst args.
 apply invariant_progress;eapply reachable_invariant;
 [apply typed_entry_establishes_invariant|exact PATH].
Qed.

Lemma stuck_is_error : source_error Stuckstate.
Proof.
 split.
 - intros[v[m EQ]];discriminate.
 - intros t s STEP;destruct STEP as [S|S];inversion S.
Qed.
Theorem sum3_never_reaches_stuck : forall args m,
 sum3_pre args -> forall t,
 ~star Csem.step sum3_ge(entry args m)t Stuckstate.
Proof.
 intros args m PRE t PATH.
 exact(sum3_all_reachable_no_error args m PRE t Stuckstate PATH stuck_is_error).
Qed.

(* The executable model retains the complete Cexec successor list. *)
Definition no_external (_:string) (_:signature) (_:Senv.t) (_:world)
 (_:list val) (_:mem):option(world*trace*val*mem):=None.
Definition transitions(s:Csem.state):list Cexec.transition :=
 Cexec.do_step sum3_ge no_external no_external quiet_world s.
Definition model_step(_:unit)(s:Csem.state)(t:trace)(s':Csem.state):Prop :=
 exists rule,In(TR rule t s')(transitions s).
Theorem step_exact : forall s t s',source_state s ->
 (model_step tt s t s' <-> Csem.step sum3_ge s t s').
Proof. intros;apply source_do_step_exact;assumption. Qed.

Lemma model_paths_are_source_paths : forall initial t reached,
 source_state initial -> star model_step tt initial t reached ->
 star Csem.step sum3_ge initial t reached.
Proof.
 intros initial t reached SOURCE PATH;revert SOURCE;induction PATH;intros SOURCE.
 - constructor.
 - apply step_exact in H;auto.
   eapply star_step;[exact H| |exact H0].
   apply IHPATH;exact(proj2(source_step_invariant _ _ _ _ SOURCE H)).
Qed.
Theorem sum3_executable_model_all_reachable_no_error : forall args m,
 sum3_pre args -> forall t reached,
 star model_step tt(entry args m)t reached -> ~source_error reached.
Proof.
 intros args m PRE t reached PATH.
 eapply sum3_all_reachable_no_error;[exact PRE|].
 eapply model_paths_are_source_paths;[unfold entry;split;reflexivity|exact PATH].
Qed.
Theorem sum3_model_has_successor_or_returns : forall args m,
 sum3_pre args -> forall t reached,
 star model_step tt(entry args m)t reached ->
 normal_return reached \/ transitions reached<>[].
Proof.
 intros args m PRE t reached PATH.
 pose proof(model_paths_are_source_paths (entry args m) t reached
  ltac:(unfold entry;split;reflexivity) PATH)as SOURCEPATH.
 destruct(sum3_progress_at_every_reachable_state args m PRE t reached SOURCEPATH)
  as [DONE|[u[next STEP]]];[left;exact DONE|right].
 assert(INV:source_state reached).
 { destruct PRE as [a[b[c EQ]]];subst args.
   pose proof(reachable_invariant _ _ _
    (typed_entry_establishes_invariant m a b c) SOURCEPATH)as I.
   exact(proj1 I). }
 apply step_exact in STEP;[|exact INV].
 destruct STEP as [rule IN];intro EMPTY;rewrite EMPTY in IN;contradiction.
Qed.

Theorem precondition_inhabited : sum3_pre[Vsingle Float32.zero;Vsingle Float32.zero;Vsingle Float32.zero].
Proof. unfold sum3_pre;eauto 7. Qed.

(* The raw execution entry still admits invalid calling states. *)
Theorem missing_arguments_error : source_error(entry [] Mem.empty).
Proof.
 split.
 - intros[v[m EQ]];discriminate.
 - intros t s STEP;destruct STEP as [ES|SS];[inversion ES|].
   inversion SS;subst.
   change(Csem.bind_parameters sum3_ge e m1
    [(Source._a,Ctypesdefs.tfloat);(Source._b,Ctypesdefs.tfloat);(Source._c,Ctypesdefs.tfloat)][]m2)in H7.
   inversion H7.
Qed.

Print Assumptions sum3_all_reachable_no_error.
Print Assumptions sum3_all_bits_no_error.
Print Assumptions sum3_executable_model_all_reachable_no_error.
Print Assumptions sum3_model_has_successor_or_returns.
Print Assumptions precondition_inhabited.
Print Assumptions missing_arguments_error.
