From Stdlib Require Import List String ZArith.
From compcert Require Import AST Values Memory Events Globalenvs Determinism Ctypes Csyntax Csem Cexec Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
Import ListNotations.

Definition callback_freeb (s:Csem.state) : bool :=
  match s with
  | ExprState _ a _ _ _ => no_builtin a
  | Callstate (External _ _ _ _) _ _ _ => false
  | _ => true
  end.

Lemma callback_freeb_sound : forall s,
  callback_freeb s = true -> callback_free_state s.
Proof.
  destruct s; simpl; auto. destruct fd; simpl; auto; discriminate.
Qed.

Definition not_stuckb (s:Csem.state) : bool :=
  match s with Stuckstate => false | _ => true end.

Lemma not_stuckb_sound : forall s,
  not_stuckb s = true -> s <> Stuckstate.
Proof. destruct s; simpl; congruence. Qed.

Definition terminalb (s:Csem.state) : bool :=
  match s with Returnstate _ Kstop _ => true | _ => false end.

Definition no_external : string -> signature -> Senv.t -> world -> list val -> mem ->
  option(world*trace*val*mem) := fun _ _ _ _ _ _ => None.
Definition quiet_world : world :=
  World (fun _ _=>None) (fun _ _ _=>None) (fun _ _ _ _=>None).

Section CERTIFICATE.
Variable ge : Csem.genv.

(** Select a real Cexec transition.  Every accepted edge is silent,
    callback-free, and has a non-Stuck successor. *)
Definition next (s:Csem.state) : option Csem.state :=
  if callback_freeb s then
    match Cexec.do_step ge no_external no_external quiet_world s with
    | TR _ [] s' :: _ => if not_stuckb s' then Some s' else None
    | _ => None
    end
  else None.

Lemma next_sound : forall s s', next s = Some s' -> Csem.step ge s E0 s'.
Proof.
  intros s s' H; unfold next in H.
  destruct (callback_freeb s) eqn:CB; try discriminate.
  destruct (Cexec.do_step ge no_external no_external quiet_world s)
    as [|tr rest] eqn:DS; try discriminate.
  destruct tr as [rule t r]. destruct t; try discriminate.
  destruct (not_stuckb r) eqn:NS; try discriminate.
  inversion H; subst s'.
  assert (IN: In (TR rule E0 r)
      (Cexec.do_step ge no_external no_external quiet_world s)).
  { rewrite DS; simpl; auto. }
  pose proof (pure_do_step_sound ge no_external no_external quiet_world
    s rule E0 r (callback_freeb_sound _ CB) IN) as [OK | [_ [BAD _]]].
  - exact OK.
  - exfalso; exact (not_stuckb_sound _ NS BAD).
Qed.

Fixpoint run (fuel:nat) (s:Csem.state) : option Csem.state :=
  if terminalb s then Some s else
  match fuel with
  | O => None
  | S n => match next s with Some s' => run n s' | None => None end
  end.

Theorem run_sound : forall n s sf,
  run n s = Some sf -> Smallstep.star Csem.step ge s E0 sf.
Proof.
  induction n; intros s sf H; cbn [run] in H;
    destruct (terminalb s) eqn:TERM.
  - inversion H; subst; constructor.
  - discriminate.
  - inversion H; subst; constructor.
  - destruct (next s) as [s'|] eqn:NEXT; try discriminate.
    eapply star_step.
    + eapply next_sound; exact NEXT.
    + apply IHn; exact H.
    + reflexivity.
Qed.

Theorem run_terminal : forall n s sf,
  run n s = Some sf -> terminalb sf = true.
Proof.
  induction n; intros s sf H; cbn [run] in H;
    destruct (terminalb s) eqn:TERM.
  - inversion H; subst; exact TERM.
  - discriminate.
  - inversion H; subst; exact TERM.
  - destruct (next s) as [s'|] eqn:NEXT; try discriminate.
    eapply IHn; exact H.
Qed.
End CERTIFICATE.
