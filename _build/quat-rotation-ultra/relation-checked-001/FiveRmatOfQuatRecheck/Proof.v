From Stdlib Require Import List String ZArith Lia.
From compcert Require Import AST Coqlib Integers Floats Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
From FiveRmatOfQuat Require Import Execution.
From FiveRmatOfQuatCase Require Import Base Contract Output CallSummary.
From FiveRmatVmultCase Require Import Runtime.
Require FiveRmatOfQuatNoError.Proof.
From FiveRmatOfQuatRecheck Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Lemma field_valid_load:forall m b delta x,0<=delta<=32->Mem.load Mfloat32 m b delta=Some(Vsingle x)->Spec.FieldValid m b delta Readable.
Proof. intros m b delta x B L;split.
 - eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact L|constructor].
 - split;[|split].
 + apply Ptrofs.unsigned_repr;change(0<=delta<=18446744073709551615);lia.
 + change(delta+4<=18446744073709551616);lia.
 + eapply Mem.load_valid_access;exact L. Qed.
Lemma field_valid_store:forall m b delta,0<=delta<=32->Mem.valid_access m Mfloat32 b delta Writable->Spec.FieldValid m b delta Writable.
Proof. intros m b delta B W;split.
 - eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W|constructor].
 - split;[|split].
 + apply Ptrofs.unsigned_repr;change(0<=delta<=18446744073709551615);lia.
 + change(delta+4<=18446744073709551616);lia.
 + exact W. Qed.
Lemma q_fields:forall m q out qi qx qy qz i,Inputs m q out qi qx qy qz->0<=i<4->Spec.FieldValid m q(4*i)Readable.
Proof. intros m q out qi qx qy qz i IN B;assert(F:i=0\/i=1\/i=2\/i=3)by lia;destruct F as[->|[->|[->| ->]]];eapply field_valid_load;try lia;[exact(lqi _ _ _ _ _ _ _ IN)|exact(lqx _ _ _ _ _ _ _ IN)|exact(lqy _ _ _ _ _ _ _ IN)|exact(lqz _ _ _ _ _ _ _ IN)]. Qed.
Lemma matrix_fields:forall m q out qi qx qy qz i,Inputs m q out qi qx qy qz->0<=i<9->Spec.FieldValid m out(4*i)Writable.
Proof. intros;eapply field_valid_store;[lia|];apply(wout _ _ _ _ _ _ _ H);assert(F:i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;destruct F as[->|[->|[->|[->|[->|[->|[->|[->| ->]]]]]]]];simpl;tauto. Qed.
Lemma site_facts:forall k,Spec.ValidKind k->Spec.SiteFacts k.
Proof. intros k K args m(q&out&qi&qx&qy&qz&EQ&IN);exists q,out,qi,qx,qy,qz;split;[exact EQ|];split;[exact IN|].
 destruct k;simpl in K|-*.
 - eapply q_fields;eauto.
 - split;[exact(proj1(matrix_fields m q out qi qx qy qz 0 IN ltac:(lia)))|intros i B;eapply matrix_fields;eauto].
 - split;[exact K|eapply matrix_fields;eauto]. Qed.
Theorem exact_observation:Spec.ExactObservation.
Proof. intros m q out qi qx qy qz IN;destruct(call_summary m q out qi qx qy qz IN)as[mf[EV[FRAME[BYTES[LOADS ACCESS]]]]].
 assert(N:normal_state(Execution.entry(Args out q)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args out q)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 exists mf;split;[eapply defined_evaluator_return_exists;eauto|].
 split;[exact BYTES|];split;[exact LOADS|];split;[exact FRAME|];split;[exact ACCESS|].
 intros t vr mr PATH;eapply defined_evaluator_exact_return;eauto. Qed.
Lemma initial_invariant:forall args m,Contract.Precondition args m->execution_invariant Execution.ge(Execution.entry args m).
Proof. intros args m(q&out&qi&qx&qy&qz&EQ&IN);subst args;destruct(call_summary m q out qi qx qy qz IN)as[mf[EV POST]].
 split;[vm_compute;reflexivity|];split;[vm_compute;repeat constructor;simpl;intuition discriminate|exists(Vundef,mf);exact EV]. Qed.
Theorem runtime_defined:Spec.RuntimeDefined.
Proof. split.
 - intros args m P t f a k e mm PATH;eapply invariant_expression_not_stuck;eapply reachable_invariant;[eapply initial_invariant;exact P|exact PATH].
 - split.
 + intros args m P t f k e mm C b p PATH CT;eapply reachable_float_load;[eapply initial_invariant;exact P|exact PATH|exact CT].
 + intros args m P t f k e mm C b p x PATH CT;eapply reachable_float_store;[eapply initial_invariant;exact P|exact PATH|exact CT]. Qed.
Lemma source_occurrences:forall k,Spec.ValidKind k->Spec.SourceOccurrence k.
Proof. intros k K;destruct k;simpl in K;unfold Spec.SourceOccurrence.
 - assert(F:i=0\/i=1\/i=2\/i=3)by lia;destruct F as[->|[->|[->| ->]]].
 + eapply nth_error_In with(n:=4%nat);reflexivity.
 + eapply nth_error_In with(n:=14%nat);reflexivity.
 + eapply nth_error_In with(n:=24%nat);reflexivity.
 + eapply nth_error_In with(n:=34%nat);reflexivity.
 - eapply nth_error_In with(n:=94%nat);reflexivity.
 - assert(F:i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;destruct F as[->|[->|[->|[->|[->|[->|[->|[->| ->]]]]]]]].
 + eapply nth_error_In with(n:=92%nat);reflexivity.
 + eapply nth_error_In with(n:=114%nat);reflexivity.
 + eapply nth_error_In with(n:=133%nat);reflexivity.
 + eapply nth_error_In with(n:=152%nat);reflexivity.
 + eapply nth_error_In with(n:=171%nat);reflexivity.
 + eapply nth_error_In with(n:=193%nat);reflexivity.
 + eapply nth_error_In with(n:=212%nat);reflexivity.
 + eapply nth_error_In with(n:=231%nat);reflexivity.
 + eapply nth_error_In with(n:=250%nat);reflexivity.
Qed.
Lemma ledger_kinds:Forall(fun row=>Spec.ValidKind(snd row))Spec.OriginalLedger.
Proof. unfold Spec.OriginalLedger;do 87(apply Forall_cons;[solve[cbn[Spec.ValidKind snd];simpl;intuition lia]|]);constructor. Qed.
Theorem all_original_87_proved:Spec.AllOriginal87.
Proof. intros id k IN;pose proof((proj1(Forall_forall _ _))ledger_kinds(id,k)IN)as K.
 split;[exact FiveRmatOfQuatNoError.Proof.no_error_proved|];split;[apply site_facts;exact K|];split;[apply source_occurrences;exact K|];split;[exact runtime_defined|exact exact_observation]. Qed.
Print Assumptions runtime_defined.
Print Assumptions exact_observation.
Print Assumptions all_original_87_proved.
