From Stdlib Require Import List Classical.
From compcert Require Import Coqlib Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution PhaseComposition.
Import ListNotations.
Lemma empty_function_unique:forall ge f k m,
 fn_params f=[]->fn_vars f=[]->
 unique_transition ge(Callstate(Internal f)[]k m)(State f(fn_body f)k empty_env m).
Proof.
 intros ge f k m PARAMS VARS;split.
 - right;eapply step_internal_function;rewrite ?PARAMS,?VARS;cbn;constructor.
 - intros t next[ES|SS];[inversion ES|inversion SS;subst].
   match goal with A:alloc_variables _ _ _ _ _ _|-_=>rewrite PARAMS,VARS in A;cbn in A;inversion A;subst end.
   match goal with B:bind_parameters _ _ _ _ _ _|-_=>rewrite PARAMS in B;inversion B;subst end;auto.
Qed.
Lemma join_certificate:forall ge P Q middle target,
 certificate ge P middle->certificate ge Q target->Q middle->certificate ge(fun s=>P s \/Q s)target.
Proof.
 intros ge P Q middle target[PP PC][QP QC]QM;split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[next[STEP PN]]]].
     * subst s;destruct(QP middle QM)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
     * right;eauto.
   + destruct(QP s QS)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
 - intros s t next[PS|QS]NF STEP.
   + destruct(classic(s=middle))as[EQ|NE];[subst s;right;eapply QC;eauto|left;eapply PC;eauto].
   + right;eapply QC;eauto.
Qed.
Print Assumptions empty_function_unique.

Lemma return_evaluates:forall ge f e m a v vc mf,
 pure_rval ge e m a=Some v->Cop.sem_cast v(typeof a)(fn_return f)m=Some vc->
 Mem.free_list m(blocks_of_env ge e)=Some mf->
 state_eval ge(State f(Sreturn(Some a))Kstop e m)=Some(vc,mf).
Proof.
 intros ge f e m a v vc mf VAL CAST FREE.
 cbn[state_eval stmt_eval];rewrite VAL,CAST;cbn[cont_eval];rewrite FREE;reflexivity.
Qed.
