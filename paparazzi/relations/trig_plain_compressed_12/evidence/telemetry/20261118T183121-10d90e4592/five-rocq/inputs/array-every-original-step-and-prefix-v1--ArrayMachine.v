From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Csyntax Csem Smallstep.
From PprzTrigRelationSupport Require Import ClosedCalls.
From PprzTrigCBMC Require Import ArrayBases ArrayOrigins ArrayContexts ArrayState.
Section ARRAY_MACHINE.
Variable ge:Csem.genv.
Variable elem:type.
Variable owner:function->list(ident*Z)->Prop.
Variable allowed:function->Prop.
Variable direct_ids:list ident.
Hypothesis owns:forall f,allowed f->exists ids,owner f ids.
Hypothesis bodies:forall f ids,owner f ids->ArrayState.array_stmt ge elem ids(fn_body f).
Hypothesis locals:forall f ids,owner f ids->Forall(fun p=>~In(fst p)(map fst ids))(fn_params f++fn_vars f).
Lemma original_array_step:forall s t next,
 ClosedCalls.closed_state ge allowed direct_ids s ->ArrayState.array_state ge elem owner s ->
 Csem.step ge s t next ->ArrayState.array_state ge elem owner next.
Proof.
 intros s t next CS A[ES|SS].
 - eapply ArrayState.array_estep with(allowed:=allowed)(direct_ids:=direct_ids).
   + exact owns.
   + intros from C CT KIND ids e a m a' mf UNS EXPR LR.
     exact(@ArrayContexts.array_lred_context ge elem ids from RV C CT KIND e a m a' mf UNS EXPR LR).
   + intros from C CT KIND ids a m tr a' mf EXPR RR.
     exact(@ArrayContexts.array_rred_context ge elem ids from RV C CT KIND a m tr a' mf EXPR RR).
   + intros from C CT KIND ids fn args ty v EXPR.
     exact(@ArrayContexts.array_call_context ge elem ids from RV C CT KIND fn args ty v EXPR).
   + exact CS.
   + exact A.
   + exact ES.
 - eapply ArrayState.array_sstep;[exact bodies|exact locals|exact A|exact SS].
Qed.
Hypothesis closed_preserved:forall s t next,ClosedCalls.closed_state ge allowed direct_ids s ->Csem.step ge s t next ->ClosedCalls.closed_state ge allowed direct_ids next.
Theorem original_array_every_prefix:forall initial prefix s,
 ClosedCalls.closed_state ge allowed direct_ids initial ->ArrayState.array_state ge elem owner initial ->
 star Csem.step ge initial prefix s ->ArrayState.array_state ge elem owner s.
Proof.
 intros initial prefix s CS A PATH;revert CS A;induction PATH;intros;[exact A|].
 eapply IHPATH;[eapply closed_preserved;[exact CS|exact H]|eapply original_array_step;[exact CS|exact A|exact H]].
Qed.
End ARRAY_MACHINE.
Print Assumptions original_array_step.
Print Assumptions original_array_every_prefix.
