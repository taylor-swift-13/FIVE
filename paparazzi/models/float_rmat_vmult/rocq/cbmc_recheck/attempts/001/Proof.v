From Stdlib Require Import List String ZArith Lia.
From compcert Require Import Coqlib Integers Floats Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
From FiveRmatVmult Require Import Execution.
From FiveRmatVmultCase Require Import Contract Call Runtime.
Require FiveRmatVmultNoError.Proof.
From FiveRmatVmultRecheck Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Lemma reads_field_valid:forall m b p n f i,Reads m b p n f->0<=i<n->Spec.FieldValid m b p(4*i)Readable.
Proof.
 intros m b p n f i RD B;unfold Spec.FieldValid;split.
 - exact(read_valid m b p n f ltac:(lia) RD).
 - split;[exact(read_pointer _ _ _ _ _ _ RD B)|]. split.
   + destruct RD as[_[NW _]];lia.
   + eapply Mem.load_valid_access;apply(proj2(proj2 RD));exact B.
Qed.
Lemma writable_field_valid:forall m b p d,writable12 m b p->In d[0;4;8]->Spec.FieldValid m b p d Writable.
Proof.
 intros m b p d W D;unfold Spec.FieldValid;split.
 - eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact(field_access _ _ _ _ W D)|constructor].
 - split;[exact(field_pointer _ _ _ _ W D)|]. split.
   + destruct W as[_[NW _]];destruct D as[<-|[<-|[<-|[]]]];lia.
   + exact(field_access _ _ _ _ W D).
Qed.
Lemma site_facts:forall k,Spec.ValidKind k->Spec.SiteFacts k.
Proof.
 intros k K args m(bo&br&bv&po&pr&pv&f&v&EQ&OR&OV&RV&W&RM&RI).
 exists bo,br,bv,po,pr,pv,f,v;split;[exact EQ|];split;[exact RM|];split;[exact RI|].
 destruct k;simpl in K|-*.
 - eapply writable_field_valid;eauto.
 - split;[exact(read_valid m br pr 9 f ltac:(lia) RM)|]. intros i B;eapply reads_field_valid;eauto.
 - eapply reads_field_valid;eauto.
 - split;[exact K|];eapply reads_field_valid;eauto.
Qed.
Theorem exact_observation:Spec.ExactObservation.
Proof.
 intros m bo br bv po pr pv f v OR OV RV W RM RI.
 destruct(call_summary m bo br bv po pr pv f v OR OV RV W RM RI)as[mf[EV[BYTES[FRAME WR]]]].
 assert(N:normal_state(Execution.entry(Args bo br bv po pr pv)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args bo br bv po pr pv)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 exists mf;split.
 - eapply defined_evaluator_return_exists;eauto.
 - split;[exact BYTES|];split;[exact FRAME|]. intros t vr mr PATH;eapply defined_evaluator_exact_return;eauto.
Qed.
Lemma initial_invariant:forall args m,Contract.Precondition args m->execution_invariant Execution.ge(Execution.entry args m).
Proof.
 intros args m(bo&br&bv&po&pr&pv&f&v&EQ&OR&OV&RV&W&RM&RI);subst args.
 destruct(call_summary m bo br bv po pr pv f v OR OV RV W RM RI)as[mf[EV POST]].
 split;[vm_compute;reflexivity|]. split;[vm_compute;repeat constructor;simpl;intuition discriminate|]. exists(Vundef,mf);exact EV.
Qed.
Theorem runtime_defined:Spec.RuntimeDefined.
Proof.
 split.
 - intros args m P t f a k e mm PATH;eapply invariant_expression_not_stuck;eapply reachable_invariant;[eapply initial_invariant;exact P|exact PATH].
 - split.
   + intros args m P t f k e mm C b p PATH CT;eapply reachable_float_load;[eapply initial_invariant;exact P|exact PATH|exact CT].
   + intros args m P t f k e mm C b p x PATH CT;eapply reachable_float_store;[eapply initial_invariant;exact P|exact PATH|exact CT].
Qed.
Lemma source_occurrences:forall k,Spec.ValidKind k->Spec.SourceOccurrence k.
Proof.
 intros k K;destruct k;simpl in K;unfold Spec.SourceOccurrence.
 - destruct K as[<-|[<-|[<-|[]]]].
   + eapply nth_error_In with(n:=1%nat);reflexivity.
   + eapply nth_error_In with(n:=60%nat);reflexivity.
   + eapply nth_error_In with(n:=119%nat);reflexivity.
 - eapply nth_error_In with(n:=12%nat);reflexivity.
 - assert(C:i=0\/i=1\/i=2)by lia;destruct C as[->|[->| ->]].
   + eapply nth_error_In with(n:=19%nat);reflexivity.
   + eapply nth_error_In with(n:=36%nat);reflexivity.
   + eapply nth_error_In with(n:=53%nat);reflexivity.
 - assert(C:i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia.
   destruct C as[->|[->|[->|[->|[->|[->|[->|[->| ->]]]]]]]].
   + eapply nth_error_In with(n:=9%nat);reflexivity.
   + eapply nth_error_In with(n:=26%nat);reflexivity.
   + eapply nth_error_In with(n:=43%nat);reflexivity.
   + eapply nth_error_In with(n:=68%nat);reflexivity.
   + eapply nth_error_In with(n:=85%nat);reflexivity.
   + eapply nth_error_In with(n:=102%nat);reflexivity.
   + eapply nth_error_In with(n:=127%nat);reflexivity.
   + eapply nth_error_In with(n:=144%nat);reflexivity.
   + eapply nth_error_In with(n:=161%nat);reflexivity.
Qed.
Lemma ledger_kinds:Forall(fun row=>Spec.ValidKind(snd row))Spec.OriginalLedger.
Proof. unfold Spec.OriginalLedger;do 99(apply Forall_cons;[solve[cbn[Spec.ValidKind snd];simpl;intuition lia]|]);constructor. Qed.
Theorem all_original_99_proved:Spec.AllOriginal99.
Proof.
 intros id k IN;pose proof((proj1(Forall_forall _ _))ledger_kinds(id,k)IN)as K.
 split;[exact FiveRmatVmultNoError.Proof.no_error_proved|]. split;[apply site_facts;exact K|].
 split;[apply source_occurrences;exact K|]. split;[exact runtime_defined|exact exact_observation].
Qed.
Print Assumptions runtime_defined.
Print Assumptions exact_observation.
Print Assumptions all_original_99_proved.
