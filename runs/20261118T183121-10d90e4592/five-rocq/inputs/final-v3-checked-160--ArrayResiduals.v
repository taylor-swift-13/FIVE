From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import ArrayBases ProducerContexts ArithmeticCall.
Section ARRAYS.
Variable ge:Csem.genv.
Variable elem:type.
Variable ids:list(ident*Z).
Lemma pointer_lred_context:forall from C,context from RV C->from=LV->
 forall e a m a' mf,array_unshadowed ids e->array_pointer ge elem ids(C a)->lred ge e a m a' mf->array_pointer ge elem ids(C a').
Proof.
 intros from C CT;induction CT;intros KK e a m a' mf ENV PTR RED;try discriminate KK.
 all:try(solve[inversion RED;subst;inversion PTR]).
 all:try(solve[inversion PTR]).
 all:inversion PTR;subst;clear PTR.
 all:try(solve[eapply pointer_add;[eapply base_lred_context;eauto|assumption]]).
 all:try(solve[eapply pointer_add;[eassumption|rewrite(@lred_context_type _ _ _ CT ge e m a a' mf RED);assumption]]).
 all:match goal with |-?G=>idtac "PTR-LR-LEFT" G end.
Qed.
Lemma pointer_rred_context:forall from C,context from RV C->from=RV->
 forall a m t a' mf,array_pointer ge elem ids(C a)->rred ge a m t a' mf->array_pointer ge elem ids(C a').
Proof.
 intros from C CT;induction CT;intros KK a m t a' mf PTR RED;subst.
 all:try(solve[eapply pointer_head_rred;eauto]).
 all:try(solve[inversion RED;subst;inversion PTR]).
 all:try(solve[inversion PTR]).
 all:inversion PTR;subst;clear PTR.
 all:try(solve[eapply pointer_add;[eapply base_rred_context;eauto|assumption]]).
 all:try(solve[eapply pointer_add;[eassumption|rewrite(@rred_context_type _ _ _ CT ge m a a' t mf RED);assumption]]).
Qed.
Lemma lvalue_lred_head:forall e a m a' mf,array_lvalue ge elem ids a->lred ge e a m a' mf->array_lvalue ge elem ids a'.
Proof.
 intros e a m a' mf L RED;inversion L;subst;inversion RED;subst.
 match goal with P:array_pointer _ _ _(Eval _ _)|-_=>inversion P;subst end.
 eapply lvalue_location;eauto.
Qed.
Lemma lvalue_lred_context:forall from C,context from LV C->from=LV->
 forall e a m a' mf,array_unshadowed ids e->array_lvalue ge elem ids(C a)->lred ge e a m a' mf->array_lvalue ge elem ids(C a').
Proof.
 intros from C CT;induction CT;intros KK e a m a' mf ENV L RED;try discriminate KK.
 all:try(solve[eapply lvalue_lred_head;eauto]).
 all:try(solve[inversion RED;subst;inversion L]).
 all:try(solve[inversion L]).
 all:inversion L;subst ty;apply lvalue_deref;eapply pointer_lred_context;eauto.
Qed.
Lemma lvalue_rred_context:forall from C,context from LV C->from=RV->
 forall a m t a' mf,array_lvalue ge elem ids(C a)->rred ge a m t a' mf->array_lvalue ge elem ids(C a').
Proof.
 intros from C CT;induction CT;intros KK a m t a' mf L RED;subst.
 all:try(solve[inversion RED;subst;inversion L]).
 all:try(solve[inversion L]).
 all:inversion L;subst ty;apply lvalue_deref;eapply pointer_rred_context;eauto.
Qed.
Lemma pointer_call_context:forall from C,context from RV C->from=RV->forall fn args ty v,
 array_pointer ge elem ids(C(Ecall fn args ty))->array_pointer ge elem ids(C(Eval v ty)).
Proof.
 intros from C CT;induction CT;intros KK fn args ty0 v P;subst.
 all:try(solve[inversion P]).
 all:inversion P;subst;clear P.
 all:try(solve[exfalso;eapply base_no_call;eauto]).
 all:try(solve[eapply pointer_add;[eassumption|rewrite(@call_context_type _ _ _ CT fn args ty0 v);assumption]]).
Qed.
Lemma lvalue_call_context:forall from C,context from LV C->from=RV->forall fn args ty v,
 array_lvalue ge elem ids(C(Ecall fn args ty))->array_lvalue ge elem ids(C(Eval v ty)).
Proof.
 intros from C CT;induction CT;intros KK fn args ty0 v P;subst.
 all:try(solve[inversion P]).
 all:inversion P;subst ty;apply lvalue_deref;eapply pointer_call_context;eauto.
Qed.
End ARRAYS.





