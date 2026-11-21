From Stdlib Require Import List String ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import Straightline.
From FiveQuatVmult Require Import Execution.
From FiveQuatVmultCase Require Import Contract Body Call.
From FiveRmatVmultCase Require Import Runtime.
Require FiveQuatVmultNoError.Proof.
From FiveQuatVmultRecheck Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Lemma field_read_valid:forall m b delta x,0<=delta<=12->Mem.load Mfloat32 m b delta=Some(Vsingle x)->Spec.FieldValid m b delta Readable.
Proof.
 intros m b delta x D L;split.
 - eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact L|constructor].
 - split;[apply Ptrofs.unsigned_repr;change(0<=delta<=18446744073709551615);lia|]. split;[change(delta+4<=18446744073709551616);lia|]. eapply Mem.load_valid_access;exact L.
Qed.
Lemma site_facts:forall k,Spec.ValidKind k->Spec.SiteFacts k.
Proof.
 intros k K args m(q&v&out&qi&qx&qy&qz&vx&vy&vz&EQ&IN).
 exists q,v,out,qi,qx,qy,qz,vx,vy,vz;split;[exact EQ|];split;[exact IN|].
 destruct k;simpl in K|-*.
 - destruct K as[<-|[<-|[<-|[<-|[]]]]];eapply field_read_valid;try lia;destruct IN;eassumption.
 - destruct K as[<-|[<-|[<-|[]]]];eapply field_read_valid;try lia;destruct IN;eassumption.
 - pose proof(wout _ _ _ _ _ _ _ _ _ _ _ IN delta K)as W;split.
   + eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W|constructor].
   + split;[apply Ptrofs.unsigned_repr;destruct K as[<-|[<-|[<-|[]]]];compute;lia|]. split;[destruct K as[<-|[<-|[<-|[]]]];compute;lia|exact W].
Qed.
Lemma initial_invariant:forall args m,Contract.Precondition args m->execution_invariant Execution.ge(Execution.entry args m).
Proof.
 intros args m(q&v&out&qi&qx&qy&qz&vx&vy&vz&EQ&IN);subst args.
 destruct(call_summary m q v out qi qx qy qz vx vy vz IN)as[mf[EV POST]].
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
Theorem exact_observation:Spec.ExactObservation.
Proof.
 intros m q v out qi qx qy qz vx vy vz IN.
 destruct(call_summary m q v out qi qx qy qz vx vy vz IN)as[mf[EV[FRAME[BYTES[ACCESS OLD]]]]].
 assert(N:normal_state(Execution.entry(Args out q v)m)=true)by(vm_compute;reflexivity).
 assert(CN:call_names(Execution.entry(Args out q v)m))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 exists mf;split;[eapply defined_evaluator_return_exists;eauto|]. split;[exact BYTES|]. split;[exact FRAME|]. split;[exact ACCESS|].
 intros t vr mr PATH;eapply defined_evaluator_exact_return;eauto.
Qed.
Lemma source_occurrences:forall k,Spec.ValidKind k->Spec.SourceOccurrence k.
Proof.
 intros k K;destruct k;simpl in K.
 - destruct K as[<-|[<-|[<-|[<-|[]]]]].
   + exists 0%nat,5%nat,Body.act0;split;reflexivity.
   + exists 1%nat,10%nat,Body.act1;split;reflexivity.
   + exists 2%nat,10%nat,Body.act2;split;reflexivity.
   + exists 3%nat,10%nat,Body.act3;split;reflexivity.
 - destruct K as[<-|[<-|[<-|[]]]].
   + exists 16%nat,14%nat,Body.act16;split;reflexivity.
   + exists 16%nat,23%nat,Body.act16;split;reflexivity.
   + exists 16%nat,32%nat,Body.act16;split;reflexivity.
 - destruct K as[<-|[<-|[<-|[]]]].
   + exists 16%nat,1%nat,Body.act16;split;reflexivity.
   + exists 17%nat,1%nat,Body.act17;split;reflexivity.
   + exists 18%nat,1%nat,Body.act18;split;reflexivity.
Qed.
Lemma ledger_kinds:Forall(fun row=>Spec.ValidKind(snd row))Spec.OriginalLedger.
Proof. unfold Spec.OriginalLedger;do 96(apply Forall_cons;[solve[cbn[Spec.ValidKind snd];simpl;intuition lia]|]);constructor. Qed.
Theorem all_original_96_proved:Spec.AllOriginal96.
Proof.
 intros id k IN;pose proof((proj1(Forall_forall _ _))ledger_kinds(id,k)IN)as K.
 split;[exact FiveQuatVmultNoError.Proof.no_error_proved|]. split;[apply site_facts;exact K|].
 split;[apply source_occurrences;exact K|]. split;[exact runtime_defined|exact exact_observation].
Qed.
Print Assumptions runtime_defined.
Print Assumptions exact_observation.
Print Assumptions all_original_96_proved.
