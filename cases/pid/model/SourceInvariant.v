From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Builtins Ctypes Cop Csyntax.
From FiveShared.compcert_libc Require Import Library.
From compcert Require Import Csem.
From FiveCases.pid.model Require Import Source.
Import ListNotations.

(** This invariant restricts only syntax reachable in the frozen program.
    Arguments, integer words, floating bits and every memory are arbitrary. *)
Definition nv (ty:type) := negb (type_is_volatile ty).
Fixpoint core_expr (a:expr) : bool :=
 match a with
 | Eval _ ty | Evar _ ty | Eloc _ _ _ ty => nv ty
 | Efield a _ ty | Evalof a ty | Ederef a ty | Eaddrof a ty
 | Eunop _ a ty | Ecast a ty | Eparen a _ ty => nv ty && core_expr a
 | Ebinop _ a b ty | Eassign a b ty
 | Ecomma a b ty | Eseqand a b ty | Eseqor a b ty => nv ty && core_expr a && core_expr b
 | Eassignop _ a b tyres ty => nv ty && nv tyres && core_expr a && core_expr b
 | Econdition a b c ty => nv ty && core_expr a && core_expr b && core_expr c
 | Ecall a args ty => nv ty && core_expr a && core_exprlist args
 | Esizeof _ ty | Ealignof _ ty => nv ty
 | Ebuiltin _ _ _ _ | Epostincr _ _ _ => false
 end
with core_exprlist (args:exprlist) : bool :=
 match args with Enil => true | Econs a args => core_expr a && core_exprlist args end.
Fixpoint core_stmt (s:statement) : bool :=
 match s with
 | Sskip | Sbreak | Scontinue | Sreturn None => true
 | Sdo a | Sreturn (Some a) => core_expr a
 | Ssequence a b => core_stmt a && core_stmt b
 | Sifthenelse a b c => core_expr a && core_stmt b && core_stmt c
 | Swhile a b | Sdowhile a b => core_expr a && core_stmt b
 | Sfor a b c d => core_stmt a && core_expr b && core_stmt c && core_stmt d
 | _ => false
 end.
Definition external_silentb (ef:external_function) : bool :=
 match ef with EF_external _ _ | EF_builtin _ _ | EF_runtime _ _ => true | _ => false end.
Definition core_fd (fd:fundef) : bool :=
 match fd with Internal f => core_stmt (fn_body f)
 | External ef _ _ _ => external_silentb ef end.
Fixpoint core_cont (k:cont) : Prop :=
 match k with
 | Kstop => True
 | Kdo k | Kreturn k => core_cont k
 | Kseq s k => core_stmt s = true /\ core_cont k
 | Kifthenelse s t k => core_stmt s = true /\ core_stmt t = true /\ core_cont k
 | Kwhile1 a s k | Kwhile2 a s k | Kdowhile1 a s k | Kdowhile2 a s k =>
     core_expr a = true /\ core_stmt s = true /\ core_cont k
 | Kfor2 a s t k | Kfor3 a s t k | Kfor4 a s t k =>
     core_expr a = true /\ core_stmt s = true /\ core_stmt t = true /\ core_cont k
 | Kcall f e C ty k => (forall v, core_expr (C (Eval v ty)) = true) /\ core_cont k
 | _ => False
 end.
Definition source_state (s:state) : Prop :=
 match s with
 | State _ stmt k _ _ => core_stmt stmt = true /\ core_cont k
 | ExprState _ a k _ _ => core_expr a = true /\ core_cont k
 | Callstate fd _ k _ => core_fd fd = true /\ core_cont k
 | Returnstate _ k _ => core_cont k
 | Stuckstate => True
 end.
Definition source_ge := globalenv Source.prog.

Ltac unpack := repeat match goal with
 | H: _ && _ = true |- _ => apply andb_true_iff in H; destruct H
 | H: _ /\ _ |- _ => destruct H
 end.
Ltac build := repeat match goal with
 | |- _ && _ = true => apply andb_true_iff; split
 | |- _ /\ _ => split
 end.

Lemma core_context_hole : forall from to C, context from to C -> forall a,
 core_expr (C a) = true -> core_expr a = true
with core_contextlist_hole : forall from C, contextlist from C -> forall a,
 core_exprlist (C a) = true -> core_expr a = true.
Proof.
 induction 1; simpl; intros; unpack; try discriminate; eauto.
 induction 1; simpl; intros; unpack; eauto.
Qed.
Lemma core_context_replace : forall from to C, context from to C -> forall a b,
 core_expr (C a) = true -> core_expr b = true -> core_expr (C b) = true
with core_contextlist_replace : forall from C, contextlist from C -> forall a b,
 core_exprlist (C a) = true -> core_expr b = true -> core_exprlist (C b) = true.
Proof.
 induction 1; simpl; intros; unpack; try discriminate; build; eauto.
 induction 1; simpl; intros; unpack; build; eauto.
Qed.
Lemma core_lred : forall ge e a m a' m',
 core_expr a = true -> lred ge e a m a' m' -> core_expr a' = true.
Proof. intros; inversion H0; subst; simpl in *; unpack; auto. Qed.
Lemma deref_silent : forall ge ty m b ofs bf t v,
 nv ty = true -> deref_loc ge ty m b ofs bf t v -> t = E0.
Proof.
 intros; unfold nv in H; apply negb_true_iff in H.
 inversion H0; subst; auto; congruence.
Qed.
Lemma assign_silent : forall ge ty m b ofs bf v t m' v',
 nv ty = true -> assign_loc ge ty m b ofs bf v t m' v' -> t = E0.
Proof.
 intros; unfold nv in H; apply negb_true_iff in H.
 inversion H0; subst; auto; congruence.
Qed.
Lemma core_rred : forall ge a m t a' m',
 core_expr a = true -> rred ge a m t a' m' -> t = E0 /\ core_expr a' = true.
Proof.
 intros; inversion H0; subst; simpl in H; unpack; try discriminate;
 split; simpl; build; eauto using deref_silent, assign_silent.
 - destruct b; assumption.
Qed.
Definition check_global (p:ident * globdef fundef type) : bool :=
 match snd p with Gfun fd => core_fd fd | Gvar _ => true end.
Lemma source_globals_core : forallb check_global Source.global_definitions = true.
Proof. reflexivity. Qed.
Local Opaque Genv.globalenv Genv.find_funct.
Lemma find_funct_core : forall v fd,
 Genv.find_funct source_ge v = Some fd -> core_fd fd = true.
Proof.
 intros v fd H.
 cbv beta iota zeta delta [source_ge Csem.globalenv Csem.genv_genv] in H.
 destruct (@Genv.find_funct_inversion fundef type Source.prog v fd H) as [id IN].
 change (In (id,Gfun fd) Source.global_definitions) in IN.
 pose proof source_globals_core as ALL.
 rewrite forallb_forall in ALL.
 exact (ALL (id,Gfun fd) IN).
Qed.
Lemma core_callred : forall a m fd args ty,
 core_expr a = true -> callred source_ge a m fd args ty ->
 core_fd fd = true /\ nv ty = true.
Proof.
 intros; inversion H0; subst; simpl in H; unpack; split; eauto using find_funct_core.
Qed.
Lemma core_call_cont : forall k, core_cont k -> core_cont (call_cont k).
Proof. induction k; simpl; tauto. Qed.
Section ExternalEnvironment.
Context {Henv:Library.environment}.
Lemma external_silent : forall ef ge args m t v m',
 external_silentb ef = true -> Library.external_call ef ge args m t v m' -> t = E0.
Proof.
 intros; destruct ef; simpl in *; try discriminate.
 - eapply Library.named_external_silent; eauto.
 - unfold Library.builtin_or_external_sem, Events.builtin_or_external_sem in H0.
   destruct (lookup_builtin_function name sg); [inversion H0; reflexivity|eapply Library.named_external_silent; eauto].
 - unfold Library.builtin_or_external_sem, Events.builtin_or_external_sem in H0.
   destruct (lookup_builtin_function name sg); [inversion H0; reflexivity|eapply Library.named_external_silent; eauto].
Qed.
Lemma source_estep : forall s t s',
 source_state s -> estep source_ge s t s' -> t = E0 /\ source_state s'.
Proof.
 intros s t s' INV STEP; inversion STEP; subst; simpl in INV; destruct INV as [HA HK].
 - split; auto; simpl; split; auto.
   eapply core_context_replace; [eassumption|exact HA|].
   eapply core_lred; [eapply core_context_hole; eauto|eassumption].
 - assert (HC:core_expr a = true) by (eapply core_context_hole; eauto).
   destruct (core_rred _ _ _ _ _ _ HC H) as [HT HR]; split; auto.
   simpl; split; auto; eapply core_context_replace; eauto.
 - assert (HC:core_expr a = true) by (eapply core_context_hole; eauto).
   destruct (core_callred _ _ _ _ _ HC H) as [FD TY].
   split; auto; simpl; split; auto; split; auto.
   intros v; eapply core_context_replace; [eassumption|exact HA|exact TY].
 - split; auto; exact I.
Qed.
Lemma source_sstep : forall s t s',
 source_state s -> sstep source_ge s t s' -> t = E0 /\ source_state s'.
Proof.
 intros s t s' INV STEP; inversion STEP; subst; simpl in INV;
 unpack; try discriminate; try contradiction; split; auto; simpl;
 try (build; auto; fail).
 all: try (destruct b; split; auto).
 all: try (build; auto; apply andb_true_iff; auto).
 all: try (apply core_call_cont; assumption).
 all: try (eapply external_silent; eauto).
 all: try (split; auto).
Qed.
Theorem source_step_invariant : forall s t s', source_state s ->
 Csem.step source_ge s t s' -> t = E0 /\ source_state s'.
Proof. intros s t s' INV [H|H]; eauto using source_estep, source_sstep. Qed.
Theorem source_silent : forall s, source_state s ->
 forall t s', Csem.step source_ge s t s' -> t = E0.
Proof. intros; exact (proj1 (source_step_invariant _ _ _ H H0)). Qed.


Definition pid_start (pid value dt:val) (m:mem) :=
 Callstate (Internal Source.f_update_pid_f) [pid;value;dt] Kstop m.
Definition pid_wrapper_start (pid value dt:val) (m:mem) :=
 Callstate (Internal Source.f_five_pid_step) [pid;value;dt] Kstop m.
Lemma pid_start_source : forall pid value dt m, source_state (pid_start pid value dt m).
Proof. intros; split; [vm_compute; reflexivity|exact I]. Qed.
Lemma pid_wrapper_start_source : forall pid value dt m, source_state (pid_wrapper_start pid value dt m).
Proof. intros; split; [vm_compute; reflexivity|exact I]. Qed.

End ExternalEnvironment.
