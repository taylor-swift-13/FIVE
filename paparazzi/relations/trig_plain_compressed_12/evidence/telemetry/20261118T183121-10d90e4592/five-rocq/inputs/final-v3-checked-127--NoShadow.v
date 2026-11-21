From Stdlib Require Import List Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Globalenvs Ctypes Csyntax Csem Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import ClosedCalls ModelIdentity.
Import ListNotations.
Definition array_names:list ident :=[PprzTrigPlain.Source._pprz_trig_int;PprzTrigLow.Source._pprz_trig_int_compr;PprzTrigLow.Source._data_buf_12].
Definition protected_names:=array_names++ClosedCalls.direct_ids.
Lemma actual_protected_locals:forall f,ClosedCalls.actual_allowed f ->
 Forall(fun p=>~In(fst p)protected_names)(fn_params f++fn_vars f).
Proof.
 intros f IN;unfold ClosedCalls.actual_allowed,ClosedCalls.internal_functions in IN.
 destruct IN as[EQ|[EQ|[EQ|[EQ|[EQ|[EQ|[]]]]]]];subst f;repeat apply Forall_cons;try constructor;vm_compute;intuition discriminate.
Qed.
Lemma protected_implies_direct:forall e,ClosedCalls.unshadowed protected_names e ->ClosedCalls.unshadowed ClosedCalls.direct_ids e.
Proof. intros e H id IN;apply H;unfold protected_names;apply in_or_app;right;exact IN. Qed.
Lemma actual_protected_bodies:forall f,ClosedCalls.actual_allowed f ->forall e,
 ClosedCalls.unshadowed protected_names e ->ClosedCalls.closed_stmt PprzTrigLow.Execution.ge ClosedCalls.actual_allowed e(fn_body f).
Proof. intros;eapply ClosedCalls.actual_closed_bodies;[exact H|apply protected_implies_direct;exact H0]. Qed.
Definition low_protected:=ClosedCalls.closed_state PprzTrigLow.Execution.ge ClosedCalls.actual_allowed protected_names.
Lemma low_protected_step:forall s t next,low_protected s ->Csem.step PprzTrigLow.Execution.ge s t next ->low_protected next.
Proof. intros;eapply ClosedCalls.closed_step;eauto using actual_protected_locals,actual_protected_bodies. Qed.
Lemma low_protected_star:forall s t next,star Csem.step PprzTrigLow.Execution.ge s t next ->low_protected s ->low_protected next.
Proof. intros s t next PATH;induction PATH;intros;auto;eapply IHPATH;eapply low_protected_step;eauto. Qed.
Lemma protected_start:forall f args m,ClosedCalls.actual_allowed f ->low_protected(Callstate(Internal f)args Kstop m).
Proof. intros;split;[exists f;auto|]. split;[exact I|]. exists empty_env;exact I. Qed.
Theorem low_all_reachable_protected:forall args m prefix s,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s ->low_protected s.
Proof.
 intros;eapply low_protected_star;[exact H|]. apply protected_start.
 unfold ClosedCalls.actual_allowed,ClosedCalls.internal_functions;cbn;auto 12.
Qed.
Theorem init_all_reachable_protected:forall args m prefix s,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix s ->low_protected s.
Proof.
 intros args m prefix s PATH.
 change(star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal PprzTrigLow.Source.f_pprz_trig_int_init)args Kstop m)prefix s)in PATH.
 eapply low_protected_star;[exact PATH|]. apply protected_start.
 unfold ClosedCalls.actual_allowed,ClosedCalls.internal_functions;cbn;auto 12.
Qed.
Definition plain_allowed(f:function):Prop:=f=PprzTrigPlain.Source.f_pprz_itrig_sin.
Lemma plain_protected_locals:forall f,plain_allowed f ->Forall(fun p=>~In(fst p)array_names)(fn_params f++fn_vars f).
Proof. intros f H;unfold plain_allowed in H;subst f;repeat apply Forall_cons;try constructor;vm_compute;intuition discriminate. Qed.
Lemma plain_protected_bodies:forall f,plain_allowed f ->forall e,
 ClosedCalls.unshadowed array_names e ->ClosedCalls.closed_stmt PprzTrigPlain.Execution.ge plain_allowed e(fn_body f).
Proof. intros f H e U;unfold plain_allowed in H;subst f;vm_compute;tauto. Qed.
Definition plain_protected:=ClosedCalls.closed_state PprzTrigPlain.Execution.ge plain_allowed array_names.
Lemma plain_protected_step:forall s t next,plain_protected s ->Csem.step PprzTrigPlain.Execution.ge s t next ->plain_protected next.
Proof. intros;eapply ClosedCalls.closed_step;eauto using plain_protected_locals,plain_protected_bodies. Qed.
Lemma plain_protected_star:forall s t next,star Csem.step PprzTrigPlain.Execution.ge s t next ->plain_protected s ->plain_protected next.
Proof. intros s t next PATH;induction PATH;intros;auto;eapply IHPATH;eapply plain_protected_step;eauto. Qed.
Theorem plain_all_reachable_protected:forall args m prefix s,
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry args m)prefix s ->plain_protected s.
Proof.
 intros;eapply plain_protected_star;[exact H|]. split;[exists PprzTrigPlain.Source.f_pprz_itrig_sin;split;reflexivity|].
 split;[exact I|]. exists empty_env;exact I.
Qed.
Lemma protected_array:forall e,ClosedCalls.unshadowed protected_names e ->forall id,In id array_names ->e!id=None.
Proof. intros e H id IN;apply H;unfold protected_names;apply in_or_app;left;exact IN. Qed.
Theorem low_reachable_array_unshadowed:forall args m prefix f a k e mm id,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix(ExprState f a k e mm) ->
 In id array_names ->e!id=None.
Proof. intros;destruct(low_all_reachable_protected _ _ _ _ H)as[_[U REST]];eapply protected_array;eauto. Qed.
Theorem init_reachable_array_unshadowed:forall args m prefix f a k e mm id,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix(ExprState f a k e mm) ->
 In id array_names ->e!id=None.
Proof. intros;destruct(init_all_reachable_protected _ _ _ _ H)as[_[U REST]];eapply protected_array;eauto. Qed.
Theorem plain_reachable_array_unshadowed:forall args m prefix f a k e mm id,
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry args m)prefix(ExprState f a k e mm) ->
 In id array_names ->e!id=None.
Proof. intros;destruct(plain_all_reachable_protected _ _ _ _ H)as[_[U REST]];exact(U id H0). Qed.
Lemma global_name_reduction:forall(ge:Csem.genv)(e:env)(m:mem)(id:ident)(ty:type)(b:block)(a:expr)(mf:mem),
 e!id=None ->Genv.find_symbol ge id=Some b ->lred ge e(Evar id ty)m a mf ->a=Eloc b Ptrofs.zero Full ty /\mf=m.
Proof. intros;inversion H1;subst;try congruence;split;congruence. Qed.
Print Assumptions low_reachable_array_unshadowed.
Print Assumptions init_reachable_array_unshadowed.
Print Assumptions plain_reachable_array_unshadowed.
