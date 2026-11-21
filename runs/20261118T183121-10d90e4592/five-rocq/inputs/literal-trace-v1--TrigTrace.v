From Stdlib Require Import List ZArith Bool Lia.
From PprzTrigRelationSupport Require Import TrigData.
Import ListNotations.
Open Scope Z_scope.
Definition consumed (c:chunk) : Z := if multi c then 3 else 1.
Definition first_chunk := hd (single_chunk 0 0 0 0) literal_chunks.
Definition last_chunk := last literal_chunks (single_chunk 0 0 0 0).
Fixpoint contiguousb (cs:list chunk) : bool :=
 match cs with
 | c::((d::tail) as rest) =>
   Z.eqb (pos d) (pos c+consumed c) &&
   Z.eqb (count_before d) (count_before c+repetitions c) &&
   Z.eqb (value_before d) (value_before c+repetitions c*delta c) && contiguousb rest
 | _ => true
 end.
Definition nibble_matchb (c:chunk):bool :=
 Z.eqb (nth (Z.to_nat (pos c)) literal_nibbles 0) (first c) &&
 (if multi c then
   Z.eqb (first c) 15 &&
   Z.eqb (nth (Z.to_nat (pos c+1)) literal_nibbles 0) (second c) &&
   Z.eqb (nth (Z.to_nat (pos c+2)) literal_nibbles 0) (third c)
  else (first c <?15)).
Lemma literal_trace_endpoints : pos first_chunk=0 /\ count_before first_chunk=0 /\ value_before first_chunk=0 /\
 pos last_chunk+consumed last_chunk=3379 /\ count_before last_chunk+repetitions last_chunk=6434.
Proof. vm_compute; auto. Qed.
Lemma literal_trace_contiguous : contiguousb literal_chunks=true.
Proof. vm_compute; reflexivity. Qed.
Lemma literal_trace_reads : forallb nibble_matchb literal_chunks=true.
Proof. vm_compute; reflexivity. Qed.
Definition byte_nibble (i:Z) : Z :=
 Z.land (Z.shiftr (nth (Z.to_nat (i/2)) compressed_bytes 0) (4*(i mod 2))) 15.
Lemma byte_nibble_list : map (fun n=>byte_nibble (Z.of_nat n)) (seq 0 3379)=literal_nibbles.
Proof. vm_compute; reflexivity. Qed.
Lemma byte_nibble_at : forall i, 0<=i<3379 -> byte_nibble i=nth (Z.to_nat i) literal_nibbles 0.
Proof.
 intros i I. assert (N:(Z.to_nat i<3379)%nat).
 { apply Nat2Z.inj_lt. rewrite Z2Nat.id by lia;cbn;lia. }
 pose proof byte_nibble_list as E. apply (f_equal (fun xs=>nth (Z.to_nat i) xs 0)) in E.
 rewrite map_nth with (d:=0%nat) in E. rewrite seq_nth in E by exact N.
 rewrite Nat.add_0_l,Z2Nat.id in E by lia. exact E.
Qed.
