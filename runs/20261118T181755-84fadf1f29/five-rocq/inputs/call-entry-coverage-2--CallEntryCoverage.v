From Stdlib Require Import List String.
From compcert Require Import Coqlib AST Values Memory Events Ctypes Csyntax Csem Cexec.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigInitSupport Require Import Control.
Import ListNotations.
Local Open Scope string_scope.

Theorem original_internal_entry_observations : forall ge f args k m e ma mp,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f)) ->
 do_alloc_variables ge empty_env m(fn_params f++fn_vars f)=(e,ma) ->
 sem_bind_parameters ge Control.quiet e ma(fn_params f)args=Some mp ->
 Csem.step ge(Callstate(Internal f)args k m)E0(State f(fn_body f)k e mp) /\
 (forall t next,Csem.step ge(Callstate(Internal f)args k m)t next ->
 t=E0 /\next=State f(fn_body f)k e mp).
Proof.
 intros ge f args k m e ma mp NAMES ALLOC BIND.
 assert(EXEC:Cexec.do_step ge none_callback none_callback Control.quiet(Callstate(Internal f)args k m)=
   [TR "step_internal_function" E0(State f(fn_body f)k e mp)]).
 { cbn[Cexec.do_step]. destruct(list_norepet_dec ident_eq(var_names(fn_params f)++var_names(fn_vars f)))as[YES|NO].
   - rewrite ALLOC,BIND;reflexivity.
   - contradiction. }
 pose proof(@pure_do_step_exact ge none_callback none_callback Control.quiet(Callstate(Internal f)args k m)
  E0(State f(fn_body f)k e mp)I(Control.internal_silent ge f args k m))as EXACT.
 split.
 - apply(proj1 EXACT);exists "step_internal_function";rewrite EXEC;simpl;auto.
 - intros t next STEP.
   destruct(proj2(@pure_do_step_exact ge none_callback none_callback Control.quiet(Callstate(Internal f)args k m)
    t next I(Control.internal_silent ge f args k m))STEP)as[rule MEMBER].
   rewrite EXEC in MEMBER;simpl in MEMBER;destruct MEMBER as[EQ|BAD];[inversion EQ;auto|contradiction].
Qed.
