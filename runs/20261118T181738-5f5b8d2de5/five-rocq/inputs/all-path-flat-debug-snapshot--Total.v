From Stdlib Require Import Bool List Arith Lia Wellfounded.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveShared.verification Require Import Obligations.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress.
Import ListNotations.

(** A finite all-successor proof tree over the ORIGINAL Csem relation.  Its
    constructor requires every Csem edge, including every evaluation order.
    It is a proof device, not a replacement execution relation. *)
Section TOTAL.
Variable ge : Csem.genv.
Variable Q : val -> mem -> Prop.
Inductive total : Csem.state -> Prop :=
| total_final : forall v m, Q v m -> total (Returnstate v Kstop m)
| total_next : forall s,
    (exists t s', Csem.step ge s t s') ->
    (forall t s', Csem.step ge s t s' -> total s') -> total s.

Lemma final_nostep : forall v m, nostep Csem.step ge (Returnstate v Kstop m).
Proof. intros v m t s [E|S]; inversion E || inversion S. Qed.
Lemma total_one : forall s t s', total s -> Csem.step ge s t s' -> total s'.
Proof.
 intros s t s' T E; inversion T; subst; eauto.
 exfalso; eapply final_nostep; exact E.
Qed.
Lemma total_reachable : forall s t s', total s -> star Csem.step ge s t s' -> total s'.
Proof. intros s t s' T H; induction H; auto; apply IHstar; eauto using total_one. Qed.
Lemma total_progress : forall s, total s -> normal_return s \/ exists t s', Csem.step ge s t s'.
Proof. intros s T; inversion T; subst; [left;red;eauto|right;auto]. Qed.
Theorem total_no_error : forall s, total s -> no_error ge s.
Proof.
 intros s T t s' E. pose proof(total_reachable _ _ _ T E) as R.
 destruct(total_progress _ R) as [F|[u[n N]]]; intros [NF NS]; [contradiction|eapply NS;eauto].
Qed.
Theorem total_termination : forall s, total s -> terminates ge s.
Proof.
 intros s T; unfold terminates; induction T.
 - constructor;intros n[t E];exfalso;eapply final_nostep;exact E.
 - constructor;intros n[t E];eauto.
Qed.
Theorem total_result : forall s v m t,
 total s -> star Csem.step ge s t (Returnstate v Kstop m) -> Q v m.
Proof.
 intros s v m t T E; pose proof(total_reachable _ _ _ T E) as R.
 inversion R; subst; auto. destruct H as [u[n N]]. exfalso;eapply final_nostep;exact N.
Qed.
End TOTAL.
Local Open Scope nat_scope.

Fixpoint expr_rank (a:expr) : nat :=
 match a with
 | Eval _ _ | Eloc _ _ _ _ => 0
 | Evar _ _ | Esizeof _ _ | Ealignof _ _ => 1
 | Evalof a _ | Efield a _ _ | Ederef a _ | Eaddrof a _
 | Eunop _ a _ | Ecast a _ | Eparen a _ _ => S(expr_rank a)
 | Ebinop _ a b _ | Eassign a b _ => S(expr_rank a+expr_rank b)
 | _=>0 end.
Lemma simple_rank_lred : forall ge e a m a' m',
 lred ge e a m a' m' -> expr_rank a' < expr_rank a.
Proof. intros;inversion H;subst;simpl;lia. Qed.
Lemma simple_rank_rred : forall ge a m t a' m',
 simple a=true -> rred ge a m t a' m' -> expr_rank a'<expr_rank a.
Proof. intros;inversion H0;subst;simpl in *;core_unpack;try discriminate;lia. Qed.
Lemma simple_rank_context : forall from to C, context from to C -> forall a b,
 simple(C a)=true -> expr_rank b<expr_rank a -> expr_rank(C b)<expr_rank(C a).
Proof.
 induction 1;simpl;intros;core_unpack;try discriminate;try lia;
 match goal with IH:forall a b,_ |- _=>specialize(IH a b ltac:(assumption) ltac:(assumption));lia end.
Qed.
Lemma simple_estep_not_stuck : forall ge f a k e m t s' v,
 simple a=true -> pure_rval ge e m a=Some v ->
 Csem.estep ge (ExprState f a k e m) t s' -> s'<>Stuckstate.
Proof.
 intros ge f a k e m t s' v SA PV ES EQ;subst s';inversion ES;subst.
 pose proof(pure_not_stuck _ _ _ _ _ SA PV) as NS.
 match goal with H: ~Csem.imm_safe _ _ _ _ _ |- _ => apply H;eapply NS;eauto end.
Qed.
Lemma simple_estep_rank : forall ge f a k e m t a',
 simple a=true -> Csem.estep ge (ExprState f a k e m) t (ExprState f a' k e m) ->
 expr_rank a'<expr_rank a.
Proof.
 intros ge f a k e m t a' SA ES;inversion ES;subst.
 - eapply simple_rank_context; eauto using simple_rank_lred.
 - eapply simple_rank_context; eauto using simple_rank_rred,simple_context_hole.
Qed.
Lemma simple_nonvalue_progress : forall ge f a k e m v,
 simple a=true -> pure_rval ge e m a=Some v ->
 (forall w ty,a<>Eval w ty) -> exists t s', Csem.step ge (ExprState f a k e m) t s'.
Proof.
 intros ge f a k e m v SA PV NV.
 pose proof(simple_immediate _ _ _ _ SA ltac:(rewrite PV;discriminate)) as IM.
 inversion IM;subst.
 - exfalso;eapply NV;reflexivity.
 - eexists;eexists;left;eapply Csem.step_lred;eauto.
 - eexists;eexists;left;eapply Csem.step_rred;eauto.
 - assert (BAD:simple e0=true) by (eapply simple_context_hole;eauto).
   inversion H;subst;discriminate.
Qed.

(** Evaluate a pure expression in every legal C evaluation order and then
    continue with an already established all-successor execution. *)
Theorem pure_prefix_total : forall ge Q f e m k a v,
 simple a=true -> pure_rval ge e m a=Some v ->
 total ge Q (ExprState f (Eval v (typeof a)) k e m) ->
 total ge Q (ExprState f a k e m).
Proof.
 intros ge Q f e m k.
 apply (well_founded_induction (well_founded_ltof _ expr_rank)
   (fun a=>forall v, simple a=true -> pure_rval ge e m a=Some v ->
    total ge Q (ExprState f (Eval v (typeof a)) k e m) ->
    total ge Q (ExprState f a k e m))).
 intros a IH v SA PV END.
 destruct a eqn:EA;try discriminate SA;try discriminate PV.
 all: try (simpl in PV;inversion PV;subst;exact END).
 all: apply total_next.
 all: try (eapply simple_nonvalue_progress;eauto;intros;discriminate).
 all: intros t next STEP;destruct STEP as [ES|SS].
 all: try (inversion SS;subst;discriminate).
 all: destruct(simple_estep _ _ _ _ _ _ _ _ SA ES) as [BAD|[a'[EQ[TY[SA' PV']]]]].
 all: try (exfalso;eapply(simple_estep_not_stuck _ _ _ _ _ _ _ _ _ SA PV ES);exact BAD).
 all: subst next;apply IH with(v:=v);auto.
 all: try (unfold ltof;eapply simple_estep_rank;eauto).
 all: try (rewrite <- PV';exact PV).
 all: try (rewrite TY;exact END).
Qed.

Lemma flat_rank_context : forall from to C, Csem.context from to C -> forall a b,
 flat_expr(C a)=true -> expr_rank b<expr_rank a -> expr_rank(C b)<expr_rank(C a).
Proof.
 induction 1;simpl;intros;core_unpack;try discriminate;try lia;
 match goal with IH:forall a b,_ |- _=>
   assert(D:expr_rank(C b)<expr_rank(C a)) by (apply IH; eauto using flat_of_simple);lia end.
Qed.
Lemma flat_rank_rred : forall ge a m t a' m',
 flat_expr a=true -> rred ge a m t a' m' -> expr_rank a'<expr_rank a.
Proof. intros;inversion H0;subst;simpl in *;core_unpack;try discriminate;lia. Qed.
Lemma flat_estep_not_stuck : forall ge f a k e m t s' v mf,
 flat_expr a=true -> flat_eval ge e m a=Some(v,mf) ->
 Csem.estep ge (ExprState f a k e m) t s' -> s'<>Stuckstate.
Proof.
 intros ge f a k e m t s' v mf SA PV ES EQ;subst s';inversion ES;subst.
 pose proof(flat_not_stuck _ _ _ _ _ _ SA PV) as NS.
 match goal with H: ~Csem.imm_safe _ _ _ _ _ |- _ => apply H;eapply NS;eauto end.
Qed.
Lemma flat_estep_rank : forall ge f a k e m t a' m',
 flat_expr a=true -> Csem.estep ge (ExprState f a k e m) t (ExprState f a' k e m') ->
 expr_rank a'<expr_rank a.
Proof.
 intros ge f a k e m t a' m' SA ES;inversion ES;subst.
 - eapply flat_rank_context;eauto using simple_rank_lred.
 - eapply flat_rank_context;eauto using flat_rank_rred,flat_context_hole.
Qed.
Lemma flat_nonvalue_progress : forall ge f a k e m v mf,
 flat_expr a=true -> flat_eval ge e m a=Some(v,mf) ->
 (forall w ty,a<>Eval w ty) -> exists t s',Csem.step ge (ExprState f a k e m) t s'.
Proof.
 intros ge f a k e m v mf SA PV NV.
 pose proof(flat_immediate _ _ _ _ _ _ SA PV) as IM.
 inversion IM;subst.
 - exfalso;eapply NV;reflexivity.
 - eexists;eexists;left;eapply Csem.step_lred;eauto.
 - eexists;eexists;left;eapply Csem.step_rred;eauto.
 - assert(BAD:flat_expr e0=true) by (eapply flat_context_hole;eauto).
   inversion H;subst;discriminate.
Qed.
Lemma flat_estep : forall ge f a k e m t next,
 flat_expr a=true -> core_expr a=true ->
 Csem.estep ge (ExprState f a k e m) t next ->
 next=Stuckstate \/ exists a' m',next=ExprState f a' k e m' /\
 typeof a'=typeof a /\ flat_expr a'=true /\ core_expr a'=true /\
 flat_eval ge e m a=flat_eval ge e m' a'.
Proof.
 intros ge f a k e m t next FL CO ES;inversion ES;subst.
 - Show.
   match goal with LR:lred ge e ?A m ?A' ?M',HC:Csem.context LV RV ?C |- _=>
   destruct(flat_lred_context ge e m A A' M' LV C HC eq_refl FL LR) as[HM[NF EQ]];
   destruct(pure_lred ge e A m A' M' LR) as[_[TY[_ _]]];
   subst M';right;exists(C A'),m;repeat split;auto;
   [exact(context_type_eq _ _ _ HC _ _ TY)|
    eapply core_context_replace;eauto;eapply core_lred;eauto;eapply core_context_hole;eauto] end.
 - match goal with RR:rred ge ?A m t ?A' ?M',HC:Csem.context RV RV ?C |- _=>
   destruct(flat_rred_context ge e m A A' t M' C HC FL CO RR) as[NF EQ];
   right;exists(C A'),M';repeat split;auto end.
   + eapply context_type_eq;eauto. match goal with RR:rred _ _ _ _ _ _|-_=>inversion RR;subst;simpl;auto end.
   + eapply core_context_replace;eauto.
     eapply (proj2(core_rred _ _ _ _ _ _ ltac:(eapply core_context_hole;eauto) ltac:(eassumption))).
 - exfalso;eapply core_no_callred;[eapply core_context_hole;eauto|eassumption].
 - left;reflexivity.
Qed.
Theorem flat_prefix_total : forall ge Q f e k a m v mf,
 flat_expr a=true -> core_expr a=true -> flat_eval ge e m a=Some(v,mf) ->
 total ge Q (ExprState f (Eval v (typeof a)) k e mf) ->
 total ge Q (ExprState f a k e m).
Proof.
 intros ge Q f e k.
 apply(well_founded_induction(well_founded_ltof _ expr_rank)
  (fun a=>forall m v mf,flat_expr a=true -> core_expr a=true ->
   flat_eval ge e m a=Some(v,mf) ->
   total ge Q (ExprState f (Eval v (typeof a)) k e mf) -> total ge Q (ExprState f a k e m))).
 intros a IH m v mf FL CO EV END.
 destruct a eqn:EA;try discriminate FL.
 all: try (simpl in EV;inversion EV;subst;exact END).
 all: apply total_next.
 all: try (eapply flat_nonvalue_progress;eauto;intros;discriminate).
 all: intros t next STEP;destruct STEP as[ES|SS].
 all: try(inversion SS;subst;discriminate).
 all: destruct(flat_estep _ _ _ _ _ _ _ _ FL CO ES) as[BAD|[a'[m'[EQ[TY[FL'[CO' EV']]]]]]].
 all: try(exfalso;eapply(flat_estep_not_stuck _ _ _ _ _ _ _ _ _ _ FL EV ES);exact BAD).
 all: subst next;apply IH with(v:=v)(mf:=mf);auto.
 all: try(unfold ltof;eapply flat_estep_rank;eauto).
 all: try(rewrite <-EV';exact EV).
 all: rewrite TY;exact END.
Qed.
