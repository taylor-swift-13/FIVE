From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution.
From PprzTrigRelationSupport Require Import PlainBody LowSin ClosedCalls.
From PprzTrigRelation Require Import Spec.
From PprzTrigCBMC Require Import SineCutpoints NoWhileTail UnwindCover SineUnwindFront.
Import ListNotations.
Lemma nw_reachable_generic : forall ge allowed ids,
 (forall f,allowed f->Forall(fun p=>~In(fst p)ids)(fn_params f++fn_vars f))->
 (forall f,allowed f->forall e,unshadowed ids e->nw_stmt ge allowed e(fn_body f))->
 forall s t current,nw_state ge allowed ids s->star Csem.step ge s t current->nw_state ge allowed ids current.
Proof.
 intros ge allowed ids LOCALS BODIES s t current INV PATH;induction PATH;[exact INV|apply IHPATH;eapply nw_step;eauto].
Qed.
Lemma nw_state_zero : forall ge allowed ids s,nw_state ge allowed ids s->zero_guard ge s.
Proof.
 intros ge allowed ids s INV;destruct s;try exact I;destruct k;cbn[nw_state nw_cont]in INV;try exact I;tauto.
Qed.
Lemma angle_tail_unshadowed : forall local,unshadowed direct_ids(angle_env local).
Proof.
 intros local id IN;unfold direct_ids in IN;destruct IN as[E|[E|[E|[E|[]]]]];subst id;vm_compute;reflexivity.
Qed.
Theorem plain_every_prefix_zero_unwind : forall m a tr current,
 Spec.normalized_angle a->star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]m)tr current->
 zero_guard PprzTrigPlain.Execution.ge current.
Proof.
 intros m a tr current RANGE PATH.
 eapply zero_covers_all_prefixes with(P:=SineFrontPC PprzTrigPlain.Execution.ge PlainBody.fun_sin return_stmt Kstop a);[apply plain_entry_front_zero_cut;exact RANGE| |exact PATH].
 intros endpoint[local[before[after[EQ REST]]]];subst endpoint;intros t last SUFFIX.
 apply(nw_state_zero PprzTrigPlain.Execution.ge(fun _=>False)[]last).
 eapply nw_reachable_generic;[intros f BAD;contradiction|intros f BAD;contradiction| |exact SUFFIX].
 cbn[nw_state];split;[exact I|]. split;[intros id BAD;contradiction|]. split;[|exact I].
 eapply nw_static_sound with(ids:=[]);[intros id BAD;contradiction|intros id BAD;contradiction|reflexivity].
Qed.
Theorem low_every_prefix_zero_unwind : forall m a tr current,
 Spec.normalized_angle a->star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]m)tr current->
 zero_guard PprzTrigLow.Execution.ge current.
Proof.
 intros m a tr current RANGE PATH.
 eapply zero_covers_all_prefixes with(P:=SineFrontPC PprzTrigLow.Execution.ge LowSin.sin_low low_return_stmt Kstop a);[apply low_entry_front_zero_cut;exact RANGE| |exact PATH].
 intros endpoint[local[before[after[EQ REST]]]];subst endpoint;intros t last SUFFIX.
 apply(nw_state_zero PprzTrigLow.Execution.ge tail_allowed direct_ids last).
 eapply tail_reachable_no_while;[|exact SUFFIX].
 cbn[nw_state];split;[exact I|]. split;[apply angle_tail_unshadowed|]. split;[|exact I].
 apply(nw_static_sound _ _ _ tail_known _ _ (angle_tail_unshadowed local));reflexivity.
Qed.
Theorem plain_normalizer_zero_unwind : forall initial a tr f v ty guard body k e current,
 Spec.normalized_angle a->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint a]initial)tr
 (ExprState f(Eval v ty)(Kwhile1 guard body k)e current)->bool_val v ty current=Some false.
Proof.
 intros;destruct(plain_every_prefix_zero_unwind initial a tr _ H H0)as[w[OBS FALSE]].
 cbn[BranchPure.branch_rval]in OBS;inversion OBS;subst w;exact FALSE.
Qed.
Theorem low_normalizer_zero_unwind : forall initialized a tr f v ty guard body k e current,
 Spec.normalized_angle a->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]initialized)tr
 (ExprState f(Eval v ty)(Kwhile1 guard body k)e current)->bool_val v ty current=Some false.
Proof.
 intros;destruct(low_every_prefix_zero_unwind initialized a tr _ H H0)as[w[OBS FALSE]].
 cbn[BranchPure.branch_rval]in OBS;inversion OBS;subst w;exact FALSE.
Qed.
Print Assumptions plain_normalizer_zero_unwind.
Print Assumptions low_normalizer_zero_unwind.
