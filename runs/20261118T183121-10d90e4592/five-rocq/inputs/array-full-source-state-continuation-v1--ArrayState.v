From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Globalenvs Ctypes Csyntax Csem Smallstep.
From PprzTrigRelationSupport Require Import ClosedCalls.
From PprzTrigCBMC Require Import ArrayBases ArrayOrigins.
Import ListNotations.
Section ARRAY_STATES.
Variable ge:Csem.genv.
Variable elem:type.
Variable owner:function->list(ident*Z)->Prop.
Fixpoint array_stmt(ids:list(ident*Z))(s:statement):Prop:=match s with
 |Sskip|Sbreak|Scontinue|Sreturn None=>True
 |Sdo a|Sreturn(Some a)=>array_expr ge elem ids a
 |Ssequence a b=>array_stmt ids a/\array_stmt ids b
 |Sifthenelse a yes no=>array_expr ge elem ids a/\array_stmt ids yes/\array_stmt ids no
 |Swhile a body|Sdowhile a body=>array_expr ge elem ids a/\array_stmt ids body
 |Sfor init a advance body=>array_stmt ids init/\array_expr ge elem ids a/\array_stmt ids advance/\array_stmt ids body
 |_=>False end.
Fixpoint array_cont(ids:list(ident*Z))(k:cont):Prop:=match k with
 |Kstop=>True
 |Kdo k|Kreturn k=>array_cont ids k
 |Kseq s k=>array_stmt ids s/\array_cont ids k
 |Kifthenelse yes no k=>array_stmt ids yes/\array_stmt ids no/\array_cont ids k
 |Kwhile1 a body k|Kwhile2 a body k|Kdowhile1 a body k|Kdowhile2 a body k=>array_expr ge elem ids a/\array_stmt ids body/\array_cont ids k
 |Kfor2 a advance body k|Kfor3 a advance body k|Kfor4 a advance body k=>array_expr ge elem ids a/\array_stmt ids advance/\array_stmt ids body/\array_cont ids k
 |Kcall f ec C ty k=>exists caller_ids,owner f caller_ids/\array_unshadowed caller_ids ec/\
    (forall v,array_expr ge elem caller_ids(C(Eval v ty)))/\array_cont caller_ids k
 |_=>False end.
Definition array_state(s:Csem.state):Prop:=match s with
 |State f body k e _=>exists ids,owner f ids/\array_unshadowed ids e/\array_stmt ids body/\array_cont ids k
 |ExprState f a k e _=>exists ids,owner f ids/\array_unshadowed ids e/\array_expr ge elem ids a/\array_cont ids k
 |Callstate fd args k _=>(exists f ids,fd=Internal f/\owner f ids)/\is_call_cont k/\exists ids,array_cont ids k
 |Returnstate _ k _=>exists ids,array_cont ids k
 |Stuckstate=>True end.
Lemma array_cont_call:forall k ids,array_cont ids k->array_cont ids(call_cont k).
Proof. induction k;intros ids H;cbn[array_cont call_cont]in *;intuition eauto. Qed.
Lemma array_cont_call_any:forall k ids,is_call_cont k->array_cont ids k->forall other,array_cont other k.
Proof. destruct k;cbn[array_cont is_call_cont];intros;try contradiction;assumption. Qed.
Lemma array_unshadowed_flat:forall ids e,array_unshadowed ids e->ClosedCalls.unshadowed(map fst ids)e.
Proof.
 intros ids e U id IN;apply in_map_iff in IN as[[name n][E H]];cbn in E;subst name;exact(U id n H).
Qed.
Lemma array_unshadowed_unflat:forall ids e,ClosedCalls.unshadowed(map fst ids)e->array_unshadowed ids e.
Proof. intros ids e U id n IN;apply U;apply in_map_iff;exists(id,n);auto. Qed.
Lemma array_allocation_unshadowed:forall e m vars after mf ids,
 alloc_variables ge e m vars after mf->array_unshadowed ids e ->
 Forall(fun p=>~In(fst p)(map fst ids))vars ->array_unshadowed ids after.
Proof.
 intros;eapply array_unshadowed_unflat;eapply ClosedCalls.unshadowed_alloc;[exact H|apply array_unshadowed_flat;exact H0|exact H1].
Qed.
Variable allowed:function->Prop.
Variable direct_ids:list ident.
Hypothesis owns:forall f,allowed f->exists ids,owner f ids.
Hypothesis expr_lred:forall from C,context from RV C->from=LV->forall ids e a m a' mf,
 array_unshadowed ids e->array_expr ge elem ids(C a)->lred ge e a m a' mf->array_expr ge elem ids(C a').
Hypothesis expr_rred:forall from C,context from RV C->from=RV->forall ids a m t a' mf,
 array_expr ge elem ids(C a)->rred ge a m t a' mf->array_expr ge elem ids(C a').
Hypothesis expr_call:forall from C,context from RV C->from=RV->forall ids fn args ty v,
 array_expr ge elem ids(C(Ecall fn args ty))->array_expr ge elem ids(C(Eval v ty)).
Lemma array_estep:forall s t next,ClosedCalls.closed_state ge allowed direct_ids s ->array_state s ->Csem.estep ge s t next ->array_state next.
Proof.
 intros s t next CLOSED A STEP.
 pose proof(@ClosedCalls.closed_estep ge allowed direct_ids s t next CLOSED STEP)as NCLOSED.
 inversion STEP;subst;cbn[array_state]in A;destruct A as[ids[OWN[ENV[EXPR CONT]]]].
 - exists ids;repeat split;try assumption;eapply expr_lred;eauto.
 - exists ids;repeat split;try assumption;eapply expr_rred;eauto.
 - cbn[ClosedCalls.closed_state]in NCLOSED;destruct NCLOSED as[[callee[FD ALLOWED]][CALL REST]].
   destruct(owns callee ALLOWED)as[callee_ids OWNC].
   split;[exists callee,callee_ids;auto|]. split;[exact CALL|].
   exists callee_ids;cbn[array_cont];exists ids;repeat split;try assumption.
   intro v;inversion H;subst;eapply expr_call;eauto.
 - exact I.
Qed.
Hypothesis bodies:forall f ids,owner f ids->array_stmt ids(fn_body f).
Hypothesis locals:forall f ids,owner f ids->Forall(fun p=>~In(fst p)(map fst ids))(fn_params f++fn_vars f).
Lemma array_sstep:forall s t next,array_state s ->Csem.sstep ge s t next ->array_state next.
Proof.
 intros s t next A STEP;inversion STEP;subst;cbn[array_state]in A.
 all:try(destruct A as[ids[OWN[ENV[ST CONT]]]]).
 all:cbn[array_state array_stmt array_cont]in *.
 all:try(solve[exists ids;intuition eauto]).
 all:try(solve[exists ids;destruct b;intuition eauto]).
 all:try(solve[repeat match goal with H:_\/_|-_=>destruct H;subst end;exists ids;intuition eauto]).
 all:try(solve[exists ids;eapply array_cont_call;tauto]).
 - destruct A as[[target[target_ids[FD OWN]]][CALL[old_ids CONT]]];inversion FD;subst target.
   exists target_ids;split;[exact OWN|]. split.
   + eapply array_allocation_unshadowed;[eassumption|intros id n IN;apply PTree.gempty|apply locals with(f:=f);exact OWN].
   + split;[apply bodies;exact OWN|eapply array_cont_call_any;[exact CALL|exact CONT]].
 - destruct A as[[target[ids[FD OWN]]]REST];discriminate.
 - destruct A as[ids[caller_ids[OWN[ENV[EXPR CONT]]]]];exists caller_ids;repeat split;auto.
Qed.
End ARRAY_STATES.
Print Assumptions array_estep.
Print Assumptions array_sstep.
