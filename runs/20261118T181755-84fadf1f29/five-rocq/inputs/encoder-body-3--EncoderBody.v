From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import PlainCore Total PureEval.
From PprzTrigInitSupport Require Import Control Compound.
Import ListNotations.

Definition encoder_parts :=
  match fn_body Source.f_table_encode_12 with
  | Ssequence (Sdo low)
      (Ssequence (Sifthenelse cond (Sdo even) (Sdo odd))
        (Ssequence (Sdo prev) (Sdo tab))) => (low,cond,even,odd,prev,tab)
  | _ => let bad:=Eval Vundef Tvoid in (bad,bad,bad,bad,bad,bad)
  end.
Definition encode_low := let '(a,_,_,_,_,_):=encoder_parts in a.
Definition encode_cond := let '(_,a,_,_,_,_):=encoder_parts in a.
Definition encode_even := let '(_,_,a,_,_,_):=encoder_parts in a.
Definition encode_odd := let '(_,_,_,a,_,_):=encoder_parts in a.
Definition encode_prev := let '(_,_,_,_,a,_):=encoder_parts in a.
Definition encode_tab := let '(_,_,_,_,_,a):=encoder_parts in a.
Definition encoder_tail := Ssequence (Sdo encode_prev) (Sdo encode_tab).

Lemma encoder_shape : fn_body Source.f_table_encode_12 =
  Ssequence (Sdo encode_low)
    (Ssequence (Sifthenelse encode_cond (Sdo encode_even) (Sdo encode_odd)) encoder_tail).
Proof. reflexivity. Qed.
Lemma encoder_syntax :
  atom_expr encode_low=true /\ core_expr encode_low=true /\
  simple encode_cond=true /\
  atom_expr encode_even=true /\ core_expr encode_even=true /\
  atom_expr encode_odd=true /\ core_expr encode_odd=true /\
  simple encode_prev=true /\ simple encode_tab=true.
Proof. vm_compute; repeat split; reflexivity. Qed.

Lemma do_atom_total : forall ge Q f a k e m v mf,
  atom_expr a=true -> core_expr a=true -> atom_eval ge e m a=Some(v,mf) ->
  Total.total ge Q (State f Sskip k e mf) ->
  Total.total ge Q (State f (Sdo a) k e m).
Proof.
  intros; apply Control.do_total; eapply Compound.atom_prefix_total; eauto.
  apply Control.do_value_total; assumption.
Qed.
Lemma do_pure_total : forall ge Q f a k e m v,
  simple a=true -> pure_rval ge e m a=Some v ->
  Total.total ge Q (State f Sskip k e m) ->
  Total.total ge Q (State f (Sdo a) k e m).
Proof.
  intros; apply Control.do_total; eapply Total.pure_prefix_total; eauto.
  apply Control.do_value_total; assumption.
Qed.

(** This CPS lemma checks the original encoder body.  Its premises are the
    concrete, source-derived read/store equations for the two byte writes;
    no decoded-table invariant or return behavior is assumed. *)
Theorem encoder_body_total : forall Q k e m m1 m2 mf low_result high_result
  condition choice prev_result tab_result,
  atom_eval (Csem.globalenv Source.prog) e m encode_low=Some(low_result,m1) ->
  pure_rval (Csem.globalenv Source.prog) e m1 encode_cond=Some condition ->
  bool_val condition (typeof encode_cond) m1=Some choice ->
  atom_eval (Csem.globalenv Source.prog) e m1
    (if choice then encode_even else encode_odd)=Some(high_result,m2) ->
  pure_rval (Csem.globalenv Source.prog) e m2 encode_prev=Some prev_result ->
  pure_rval (Csem.globalenv Source.prog) e m2 encode_tab=Some tab_result ->
  is_call_cont k ->
  Mem.free_list m2 (blocks_of_env (Csem.globalenv Source.prog) e)=Some mf ->
  Total.total (Csem.globalenv Source.prog) Q (Returnstate Vundef k mf) ->
  Total.total (Csem.globalenv Source.prog) Q
    (State Source.f_table_encode_12 (fn_body Source.f_table_encode_12) k e m).
Proof.
  intros Q k e m m1 m2 mf low_result high_result condition choice prev_result tab_result
    LOW COND BOOL HIGH PREV TAB CALL FREE END.
  destruct encoder_syntax as [SL [CL [SC [SE [CE [SO [CO [SP ST]]]]]]]].
  assert (TAIL: Total.total (Csem.globalenv Source.prog) Q
    (State Source.f_table_encode_12 encoder_tail k e m2)).
  { unfold encoder_tail; apply Control.sequence_total.
    eapply do_pure_total; [exact SP|exact PREV|].
    apply Control.skip_sequence_total.
    eapply do_pure_total; [exact ST|exact TAB|].
    eapply Control.skip_call_total; eauto. }
  rewrite encoder_shape; apply Control.sequence_total.
  eapply do_atom_total; [exact SL|exact CL|exact LOW|].
  apply Control.skip_sequence_total; apply Control.sequence_total.
  eapply Control.if_pure_total; [exact SC|exact COND|exact BOOL|].
  destruct choice; cbn in HIGH |- *;
    eapply do_atom_total; eauto;
    apply Control.skip_sequence_total; exact TAIL.
Qed.

Theorem encoder_call_total : forall Q args k m e m0 m1 m2 m3 mf low_result
  high_result condition choice prev_result tab_result,
  do_alloc_variables (Csem.globalenv Source.prog) empty_env m
    (fn_params Source.f_table_encode_12 ++ fn_vars Source.f_table_encode_12)=(e,m0) ->
  sem_bind_parameters (Csem.globalenv Source.prog) Control.quiet e m0
    (fn_params Source.f_table_encode_12) args=Some m1 ->
  atom_eval (Csem.globalenv Source.prog) e m1 encode_low=Some(low_result,m2) ->
  pure_rval (Csem.globalenv Source.prog) e m2 encode_cond=Some condition ->
  bool_val condition (typeof encode_cond) m2=Some choice ->
  atom_eval (Csem.globalenv Source.prog) e m2
    (if choice then encode_even else encode_odd)=Some(high_result,m3) ->
  pure_rval (Csem.globalenv Source.prog) e m3 encode_prev=Some prev_result ->
  pure_rval (Csem.globalenv Source.prog) e m3 encode_tab=Some tab_result ->
  is_call_cont k ->
  Mem.free_list m3 (blocks_of_env (Csem.globalenv Source.prog) e)=Some mf ->
  Total.total (Csem.globalenv Source.prog) Q (Returnstate Vundef k mf) ->
  Total.total (Csem.globalenv Source.prog) Q
    (Callstate (Internal Source.f_table_encode_12) args k m).
Proof.
  intros; eapply Control.internal_function_total; eauto.
  - vm_compute; repeat constructor; simpl; intuition discriminate.
  - eapply encoder_body_total; eauto.
Qed.
