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
 induction 1;simpl;intros a H;core_unpack;try discriminate;eauto.
 induction 1;simpl;intros a H;core_unpack;eauto.
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
 - unfold nv. cbn[type_is_volatile incrdecr_type typeconv remove_attributes change_attributes];
   destruct ty;cbn[type_is_volatile incrdecr_type typeconv remove_attributes change_attributes]in *;auto.
Qed.
