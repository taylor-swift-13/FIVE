from Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import AST Integers.
Require PprzTrigPlain.Source PprzTrigInit.Source.
Import ListNotations.
Open Scope Z_scope.

(** A finite certificate for the ORIGINAL literal source data only.
    It is auxiliary: no C execution or decoder refinement is assumed/proved here. *)
Definition init_Z (d:init_data) : Z :=
 match d with Init_int8 n | Init_int16 n | Init_int32 n => Int.unsigned n | _ => -1 end.
Definition ordinary_values : list Z := map init_Z (gvar_init PprzTrigPlain.Source.v_pprz_trig_int).
Definition compressed_bytes : list Z := map init_Z (gvar_init PprzTrigInit.Source.v_pprz_trig_int_compr).
Definition literal_nibbles : list Z := firstn 3379
 (flat_map (fun b => [Z.land b 15; Z.shiftr b 4]) compressed_bytes).

Record chunk := {
 pos : Z; count_before : Z; value_before : Z;
 multi : bool; first : Z; second : Z; third : Z;
 repetitions : Z; delta : Z
}.
Definition single_chunk i cnt val t :=
 {|pos:=i;count_before:=cnt;value_before:=val;multi:=false;first:=t;second:=0;third:=0;
   repetitions:=t/5+1;delta:=t mod 5|}.
Definition multi_chunk i cnt val t k u :=
 {|pos:=i;count_before:=cnt;value_before:=val;multi:=true;first:=t;second:=k;third:=u;
   repetitions:=Z.lor k (Z.shiftl (Z.land u 8) 1)+10;delta:=Z.land u 7|}.
Fixpoint parse_chunks (fuel:nat) (i cnt val:Z) (ns:list Z) : list chunk :=
 match fuel,ns with
 | O,_ | _,[] => []
 | S n,t::rest =>
   if t <? 15 then
     let c:=single_chunk i cnt val t in
     c::parse_chunks n (i+1) (cnt+repetitions c)
          (val+repetitions c*delta c) rest
   else match rest with
        | k::u::tail => let c:=multi_chunk i cnt val t k u in
          c::parse_chunks n (i+3) (cnt+repetitions c)
            (val+repetitions c*delta c) tail
        | _ => []
        end
 end.
Definition literal_chunks : list chunk := parse_chunks 3379 0 0 0 literal_nibbles.
Fixpoint emit_values (n:nat) (v d:Z) : list Z :=
 match n with O=>[] | S k=>v::emit_values k (v+d) d end.
Definition decoded_values : list Z :=
 flat_map (fun c=>emit_values (Z.to_nat (repetitions c)) (value_before c) (delta c)) literal_chunks.
Definition chunk_ok (c:chunk) : bool :=
 (0 <=? pos c) && (pos c+(if multi c then 3 else 1) <=?3379) &&
 (0 <=? count_before c) && (0 <? repetitions c) && (repetitions c <=?41) &&
 (count_before c+repetitions c <=?6434) &&
 (0 <=? value_before c) && (0 <=? delta c) && (delta c <=?7) &&
 (value_before c+repetitions c*delta c <=?16383) &&
 (0 <=? first c) && (first c <=?15) &&
 (0 <=? second c) && (second c <=?15) &&
 (0 <=? third c) && (third c <=?15).
Definition bounded_value (v:Z) : bool := (0 <=?v) && (v<=?16383).

Lemma original_data_lengths : length ordinary_values=6434%nat /\ length compressed_bytes=1690%nat /\ length literal_nibbles=3379%nat.
Proof. vm_compute; auto. Qed.
Lemma rle_literal_values_equal : decoded_values=ordinary_values.
Proof. vm_compute; reflexivity. Qed.
Lemma literal_prefix_certificate : forallb chunk_ok literal_chunks=true.
Proof. vm_compute; reflexivity. Qed.
Lemma ordinary_values_bounded : forallb bounded_value ordinary_values=true.
Proof. vm_compute; reflexivity. Qed.

Definition low_byte (v:Z):Z := v mod 256.
Definition middle_nibble (v:Z):Z := Z.shiftr (Z.land v 3840) 8.
Fixpoint packed_middle (vs:list Z) : list Z :=
 match vs with
 | a::b::tail => Z.lor (middle_nibble a) (Z.shiftl (middle_nibble b) 4)::packed_middle tail
 | [a] => [middle_nibble a]
 | [] => []
 end.
Definition expected_bytes : list Z := map low_byte ordinary_values ++ packed_middle ordinary_values.
Definition high_bits (i:Z) : Z :=
 if i <? 2145 then (if i <? 1035 then 0 else 4096)
 else (if i <? 3474 then 8192 else 12288).
Definition packed_lookup (i:Z) : Z :=
 Z.lor (Z.lor (high_bits i)
  (Z.land (Z.shiftl (nth (Z.to_nat (6434+Z.shiftr i 1)) expected_bytes 0)
         (if Z.eqb (i mod 2) 0 then 8 else 4)) 3840))
  (nth (Z.to_nat i) expected_bytes 0).
Definition all_packed_lookups : list Z := map (fun n=>packed_lookup (Z.of_nat n)) (seq 0 6434).
Lemma expected_bytes_length : length expected_bytes=9651%nat.
Proof. vm_compute; reflexivity. Qed.
Lemma packed_literal_values_equal : all_packed_lookups=ordinary_values.
Proof. vm_compute; reflexivity. Qed.
Lemma expected_bytes_bounded : forallb (fun b=>(0<=?b)&&(b<=?255)) expected_bytes=true.
Proof. vm_compute; reflexivity. Qed.

Lemma packed_lookup_at : forall i, 0<=i<6434 ->
 packed_lookup i=nth (Z.to_nat i) ordinary_values 0.
Proof.
 intros i I. pose proof packed_literal_values_equal as E.
 apply (f_equal (fun xs=>nth (Z.to_nat i) xs 0)) in E.
 unfold all_packed_lookups in E.
 rewrite map_nth with (d:=0%nat) in E.
 rewrite seq_nth in E by (apply Z2Nat.inj_lt;lia).
 rewrite Nat.add_0_l, Z2Nat.id in E by lia. exact E.
Qed.
Lemma literal_value_at_bounds : forall i, 0<=i<6434 ->
 0<=nth (Z.to_nat i) ordinary_values 0<=16383.
Proof.
 intros i I. pose proof ordinary_values_bounded as B.
 apply forallb_forall with (x:=nth (Z.to_nat i) ordinary_values 0) in B.
 - unfold bounded_value in B. apply andb_true_iff in B as [L U].
   apply Z.leb_le in L;apply Z.leb_le in U;lia.
 - apply nth_In. rewrite (proj1 original_data_lengths). apply Z2Nat.inj_lt;lia.
Qed.
