From Stdlib Require Import List.
From compcert Require Import Coqlib AST Values Memory Events Ctypes Csyntax Csem Cexec Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigInitSupport Require Import Control SideEffects.
Import ListNotations.

(** A proof tree over every edge of the ORIGINAL Csem relation, stopping at
    the first actual Callstate.  Execution models are unchanged. *)
Inductive first_call_certificate(ge:Csem.genv)(target:Csem.state->Prop):Csem.state->Prop:=
| first_call_here:forall s,target s->first_call_certificate ge target s
| first_call_next:forall f a k e m,
 (exists t s',Csem.step ge(ExprState f a k e m)t s') ->
 (forall t s',Csem.step ge(ExprState f a k e m)t s'->first_call_certificate ge target s') ->
 first_call_certificate ge target(ExprState f a k e m).

Lemma quiet_successors_first_call : forall ge target f a k e m,
 quiet_expr a=true ->Cexec.do_step ge none_callback none_callback Control.quiet(ExprState f a k e m)<>[] ->
 (forall rule t next,In(TR rule t next)(Cexec.do_step ge none_callback none_callback Control.quiet(ExprState f a k e m))->
 first_call_certificate ge target next) ->first_call_certificate ge target(ExprState f a k e m).
Proof.
 intros ge target f a k e m QUIET NONEMPTY ALL;apply first_call_next.
 - destruct(Cexec.do_step ge none_callback none_callback Control.quiet(ExprState f a k e m))as[|[rule t next]rest]eqn:STEPS;[contradiction|].
   exists t,next;apply(proj1(@pure_do_step_exact ge none_callback none_callback Control.quiet(ExprState f a k e m)t next
     (quiet_no_builtin _ QUIET)(quiet_expression_silent ge f a k e m QUIET))).
   exists rule;rewrite STEPS;simpl;auto.
 - intros t next STEP;destruct(proj2(@pure_do_step_exact ge none_callback none_callback Control.quiet(ExprState f a k e m)t next
     (quiet_no_builtin _ QUIET)(quiet_expression_silent ge f a k e m QUIET))STEP)as[rule IN].
   exact(ALL rule t next IN).
Qed.

Theorem first_call_execution_exists : forall ge target s,first_call_certificate ge target s ->
 exists t next,star Csem.step ge s t next /\target next.
Proof.
 intros ge target s CERT;induction CERT as[s AT|f a k e m NEXT ALL IH].
 - exists E0,s;split;[constructor|exact AT].
 - destruct NEXT as[t[n STEP]];destruct(IH t n STEP)as[u[next[PATH AT]]].
   exists(t**u),next;split;[eapply star_step;eauto|exact AT].
Qed.

Inductive first_call_prefix(ge:Csem.genv):Csem.state->trace->Csem.state->Prop:=
| first_call_prefix_refl:forall s,first_call_prefix ge s E0 s
| first_call_prefix_step:forall f a k e m t n u last trace,
 Csem.step ge(ExprState f a k e m)t n ->first_call_prefix ge n u last ->trace=t**u ->
 first_call_prefix ge(ExprState f a k e m)trace last.
Definition call_state(s:Csem.state):Prop:=exists fd args k m,s=Callstate fd args k m.
Theorem every_first_call_covered : forall ge target,
 (forall s,target s->call_state s)->forall s t fd args k m,
 first_call_certificate ge target s ->first_call_prefix ge s t(Callstate fd args k m) ->
 target(Callstate fd args k m).
Proof.
 intros ge target TARGET s t fd args k m CERT PREFIX;revert CERT.
 remember(Callstate fd args k m)as last eqn:LAST;induction PREFIX;intros CERT.
 - subst s;inversion CERT;subst;assumption.
 - inversion CERT;subst.
   + destruct(TARGET _ H0)as[fd'[args'[k'[m' EQ]]]];discriminate.
   + eapply IHPREFIX;eauto.
Qed.
