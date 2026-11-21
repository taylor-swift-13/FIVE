From Stdlib Require Import List Bool.
From compcert Require Import AST Values Memory Events Globalenvs Determinism Ctypes Csyntax Csem Cexec Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport.
Import ListNotations.
Definition callback_free_stateb (s:Csem.state) : bool :=
 match s with
 | ExprState _ a _ _ _ => SemanticsSupport.no_builtin a
 | Callstate (External ef _ _ _) _ _ _ => SemanticsSupport.executable_builtin ef
 | _ => true
 end.
Lemma callback_free_stateb_sound : forall s,
 callback_free_stateb s=true -> SemanticsSupport.callback_free_state s.
Proof. destruct s; simpl; auto. destruct fd; simpl; auto. Qed.
Definition is_stuck (s:Csem.state) : bool :=
 match s with Stuckstate => true | _ => false end.
Section WALK.
Variable ge:Csem.genv.
Variable cb asm : string -> signature -> Senv.t -> world -> list val -> mem -> option(world*trace*val*mem).
Variable w:world.
Definition quiet_next (s:Csem.state) : option Csem.state :=
 if callback_free_stateb s then
 match Cexec.do_step ge cb asm w s with
 | TR _ [] dst :: _ => if is_stuck dst then None else Some dst
 | _ => None
 end else None.
Lemma quiet_next_sound : forall s dst,
 quiet_next s=Some dst -> Csem.step ge s E0 dst.
Proof.
 intros s dst H; unfold quiet_next in H.
 destruct(callback_free_stateb s) eqn:CB; try discriminate.
 destruct(Cexec.do_step ge cb asm w s) as [|[rule tr nxt] rest] eqn:ST; try discriminate.
 destruct tr; try discriminate.
 destruct(is_stuck nxt) eqn:NS; try discriminate.
 inversion H; subst dst.
 pose proof(SemanticsSupport.pure_do_step_sound ge cb asm w s rule E0 nxt
  (callback_free_stateb_sound s CB) ltac:(rewrite ST; simpl; auto)) as SOUND.
 destruct SOUND as [OK|[_[BAD _]]]; auto.
 subst nxt; discriminate.
Qed.
Fixpoint quiet_walk (fuel:nat) (s:Csem.state) : Csem.state :=
 match fuel with O => s | S n =>
 match quiet_next s with None=>s | Some dst=>quiet_walk n dst end end.
Theorem quiet_walk_actual_Csem_path : forall fuel s,
 Smallstep.star Csem.step ge s E0 (quiet_walk fuel s).
Proof.
 induction fuel as [|n IH];intro s;simpl;[constructor|].
 destruct(quiet_next s) as [dst|] eqn:N;[|constructor].
 eapply star_step;[exact(quiet_next_sound _ _ N)|apply IH|reflexivity].
Qed.
End WALK.
