From Stdlib Require Import List String ZArith Lia.
From compcert Require Import Coqlib Integers Floats Values Memory Memdata Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
From FiveRmatVmult Require Import Execution.
From FiveRmatVmultCase Require Import Contract Call.
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
 - split;[eapply read_valid;[lia|exact RM]|]. intros i B;eapply reads_field_valid;eauto.
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
Lemma ledger_kinds:Forall(fun row=>Spec.ValidKind(snd row))Spec.OriginalLedger.
Proof. vm_compute;repeat constructor;intuition lia. Qed.
Theorem all_original_99_proved:Spec.AllOriginal99.
Proof.
 intros id k IN;split;[exact FiveRmatVmultNoError.Proof.no_error_proved|]. split;[|exact exact_observation].
 apply site_facts;apply(Forall_forall _ _ ledger_kinds(id,k)IN).
Qed.
Print Assumptions exact_observation.
Print Assumptions all_original_99_proved.
