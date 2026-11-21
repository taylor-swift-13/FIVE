From Stdlib Require Import List ZArith Bool Lia.
From PprzTrigRelationSupport Require Import TrigData TrigTrace PackedPrefix.
Import ListNotations.
Open Scope Z_scope.
Definition emission_ok (c:chunk):bool := forallb(fun n=>
 Z.eqb(table_at(count_before c+Z.of_nat n))(value_before c+Z.of_nat n*delta c))
 (seq 0(Z.to_nat(repetitions c))).
Lemma literal_emission_certificate : forallb emission_ok literal_chunks=true.
Proof. vm_compute;reflexivity. Qed.
Lemma literal_emission_at : forall c,In c literal_chunks ->forall j,
 0<=j<repetitions c ->table_at(count_before c+j)=value_before c+j*delta c.
Proof.
 intros c IN j J. pose proof literal_emission_certificate as H.
 apply forallb_forall with(x:=c)in H;auto. unfold emission_ok in H.
 apply forallb_forall with(x:=Z.to_nat j)in H.
 - rewrite Z2Nat.id in H by lia. apply Z.eqb_eq;exact H.
 - apply in_seq;split;[lia|]. cbn [Nat.add].
   apply(proj1(Z2Nat.inj_lt j(repetitions c)ltac:(lia)ltac:(lia)));lia.
Qed.
Lemma literal_chunk_bounds : forall c,In c literal_chunks ->
 0<=pos c /\ pos c+consumed c<=3379 /\
 0<=count_before c /\0<repetitions c<=41 /\count_before c+repetitions c<=6434 /\
 0<=value_before c /\0<=delta c<=7 /\value_before c+repetitions c*delta c<=16383 /\
 0<=first c<=15 /\0<=second c<=15 /\0<=third c<=15.
Proof.
 intros c IN. pose proof literal_prefix_certificate as H.
 apply forallb_forall with(x:=c)in H;auto. unfold chunk_ok in H.
 repeat rewrite andb_true_iff in H.
 repeat match goal with H:_ /\ _ |- _ =>destruct H end.
 repeat match goal with H:Z.leb _ _=true |- _=>apply Z.leb_le in H |H:Z.ltb _ _=true |- _=>apply Z.ltb_lt in H end.
 unfold consumed. tauto.
Qed.
Lemma emitted_prefix_bounds : forall c,In c literal_chunks ->forall j,
 0<=j<=repetitions c ->
 0<=count_before c+j<=6434 /\0<=value_before c+j*delta c<=16383.
Proof.
 intros c IN j J. pose proof(literal_chunk_bounds c IN)as H.
 repeat match goal with H:_ /\ _ |- _=>destruct H end. split;nia.
Qed.
