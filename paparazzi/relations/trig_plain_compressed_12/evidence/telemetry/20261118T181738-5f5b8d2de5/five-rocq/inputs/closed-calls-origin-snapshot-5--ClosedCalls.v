From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore.
From PprzTrigInitSupport Require Import SideEffects.
Import ListNotations.

(** Syntax closure only.  No input value, memory permission, initialized byte,
    numerical range, successful call, or program outcome is assumed here. *)
Fixpoint qexpr(a:expr):bool :=
 match a with
 |Eval _ ty|Evar _ ty|Eloc _ _ _ ty|Esizeof _ ty|Ealignof _ ty=>nv ty
 |Efield a _ ty|Evalof a ty|Ederef a ty|Eaddrof a ty|Eunop _ a ty|Ecast a ty
 |Eparen a _ ty=>nv ty&&qexpr a
 |Ebinop _ a b ty|Eseqand a b ty|Eseqor a b ty|Eassign a b ty|Ecomma a b ty=>nv ty&&qexpr a&&qexpr b
 |Eassignop _ a b tyres ty=>nv ty&&nv tyres&&qexpr a&&qexpr b
 |Epostincr _ a ty=>nv ty&&nv(incrdecr_type ty)&&qexpr a
 |Econdition a b c ty=>nv ty&&qexpr a&&qexpr b&&qexpr c
 |Ecall a args ty=>nv ty&&qexpr a&&qexprlist args
 |Ebuiltin _ _ _ _=>false
 end
with qexprlist(args:exprlist):bool :=match args with Enil=>true|Econs a tail=>qexpr a&&qexprlist tail end.
Lemma qexpr_quiet : forall a,qexpr a=true->quiet_expr a=true
with qexprlist_quiet : forall args,qexprlist args=true->quiet_exprlist args=true.
Proof.
 induction a;simpl;intros H;core_unpack;try discriminate;core_build;eauto using qexprlist_quiet.
 induction args;simpl;intros H;core_unpack;core_build;eauto using qexpr_quiet.
Qed.
Lemma qcontext_hole : forall from to C,Csem.context from to C->forall a,qexpr(C a)=true->qexpr a=true
with qcontextlist_hole : forall from C,Csem.contextlist from C->forall a,qexprlist(C a)=true->qexpr a=true.
Proof.
 induction 1;simpl;intros a QUIET;core_unpack;try discriminate;eauto.
 induction 1;simpl;intros a QUIET;core_unpack;eauto.
Qed.
Lemma qcontext_replace : forall from to C,Csem.context from to C->forall a b,
 qexpr(C a)=true->qexpr b=true->qexpr(C b)=true
with qcontextlist_replace : forall from C,Csem.contextlist from C->forall a b,
 qexprlist(C a)=true->qexpr b=true->qexprlist(C b)=true.
Proof.
 induction 1;simpl;intros a b A B;core_unpack;try discriminate;core_build;eauto.
 induction 1;simpl;intros a b A B;core_unpack;core_build;eauto.
Qed.
Lemma q_lred : forall ge e a m a' m',qexpr a=true->lred ge e a m a' m'->qexpr a'=true.
Proof. intros;inversion H0;subst;simpl in *;core_unpack;auto. Qed.
Lemma q_rred : forall ge a m t a' m',qexpr a=true->rred ge a m t a' m'->qexpr a'=true.
Proof.
 intros;inversion H0;subst;simpl in *;core_unpack;try discriminate;core_build;auto.
 - destruct b;assumption.
Qed.

Definition leaf_expr(a:expr):bool :=match a with Eval _ _|Evar _ _|Eloc _ _ _ _=>true|_=>false end.
Lemma leaf_context : forall from to C,Csem.context from to C ->forall a leaf,
 leaf_expr leaf=true ->C a=leaf ->from=to /\a=leaf /\forall z,C z=z.
Proof.
 intros from to C CT a leaf LE EQ;destruct leaf;try discriminate LE;
 inversion CT;subst;cbn in EQ;try discriminate;repeat split;auto.
Qed.
Section ORIGINS.
Variable ge:Csem.genv.
Variable allowed:function->Prop.
Inductive designator(e:env):expr->Prop :=
| des_name : forall id args ret cc b target,
 e!id=None ->Genv.find_symbol ge id=Some b ->
 Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target) ->allowed target ->
 designator e(Evalof(Evar id(Tfunction args ret cc))(Tfunction args ret cc))
| des_loc : forall args ret cc b target,
 Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target) ->allowed target ->
 designator e(Evalof(Eloc b Ptrofs.zero Full(Tfunction args ret cc))(Tfunction args ret cc))
| des_value : forall args ret cc b target,
 Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target) ->allowed target ->
 designator e(Eval(Vptr b Ptrofs.zero)(Tfunction args ret cc)).
Lemma designator_head_rred : forall e a m t a' m',designator e a ->rred ge a m t a' m' ->designator e a'.
Proof.
 intros e a m t a' m' DES RR;inversion DES;subst;inversion RR;subst.
 match goal with D:deref_loc _ _ _ _ _ _ _ _|-_=>inversion D;subst;cbn[access_mode]in *;try discriminate end.
 eapply des_value;eauto.
Qed.
Lemma designator_lred_context : forall e from C a m a' m',
 Csem.context from RV C ->from=LV ->designator e(C a) ->lred ge e a m a' m' ->designator e(C a').
Proof.
 intros e from C a m a' m' CT KIND DES LR;subst from.
 remember(C a)as whole eqn:EQ;inversion DES;subst whole;
 inversion CT;subst C;try discriminate.
 all:match goal with E:Evalof ?LEAF ?TF=Evalof(?C ?A)?TY,SUB:Csem.context LV LV ?C|-_=>
  inversion E;subst TY;
  destruct(leaf_context _ _ _ SUB A LEAF eq_refl ltac:(congruence))as[KK[AA ID]];
  try(rewrite AA in LR);repeat rewrite ID end.
 all:inversion LR;subst;try congruence.
 eapply des_loc;eauto;congruence.
Qed.
Lemma designator_rred_context : forall e C a m t a' m',
 Csem.context RV RV C ->designator e(C a) ->rred ge a m t a' m' ->designator e(C a').
Proof.
 intros e C a m t a' m' CT DES RR.
 remember(C a)as whole eqn:EQ;inversion DES;subst whole;
 inversion CT;subst C;try discriminate.
 all:try(solve[eapply designator_head_rred;eauto]).
 all:match goal with E:Evalof ?LEAF ?TF=Evalof(?C ?A)?TY,SUB:Csem.context RV LV ?C|-_=>
  inversion E;subst TY;
  destruct(leaf_context _ _ _ SUB A LEAF eq_refl ltac:(congruence))as[BAD _];discriminate end.
Qed.
Fixpoint origin_expr(e:env)(a:expr):Prop :=
 match a with
 |Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>origin_expr e a
 |Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>origin_expr e a/\origin_expr e b
 |Econdition a b c _=>origin_expr e a/\origin_expr e b/\origin_expr e c
 |Ecall a args _=>designator e a/\origin_exprlist e args
 |Ebuiltin _ _ args _=>origin_exprlist e args
 |_=>True end
with origin_exprlist(e:env)(args:exprlist):Prop :=match args with Enil=>True|Econs a tail=>origin_expr e a/\origin_exprlist e tail end.
Lemma designator_origin : forall e a,designator e a ->origin_expr e a.
Proof. intros e a H;inversion H;subst;exact I. Qed.
Lemma origin_context_hole : forall from to C,Csem.context from to C->forall e a,
 origin_expr e(C a)->origin_expr e a
with origin_contextlist_hole : forall from C,Csem.contextlist from C->forall e a,
 origin_exprlist e(C a)->origin_expr e a.
Proof.
 induction 1;simpl;intros e a O;intuition eauto using designator_origin.
 induction 1;simpl;intros e a O;intuition eauto.
Qed.
