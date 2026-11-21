From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Memdata Globalenvs Ctypes Csem Smallstep.
From FiveShared.verification Require Import Obligations.
Require PprzTrigLow.Source PprzTrigLow.Execution.
From PprzTrigRelationSupport Require Import TrigData PackedPrefix MachineData PlainBody PlainEntry PlainClosed LowEntry LowDispatcher LowSin Total ModelIdentity.
From PprzTrigInitSupport Require Import ByteObservation.
From PprzTrigRelation Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Lemma expected_byte_bounds : forall i,0<=i<9651 ->0<=nth(Z.to_nat i)expected_bytes 0<=255.
Proof.
 intros i I;pose proof expected_bytes_bounded as ALL.
 apply forallb_forall with(x:=nth(Z.to_nat i)expected_bytes 0)in ALL.
 - apply andb_true_iff in ALL as[L H];apply Z.leb_le in L;apply Z.leb_le in H;lia.
 - apply nth_In;rewrite expected_bytes_length.
   change(Z.to_nat i<Z.to_nat 9651)%nat;apply(proj1(Z2Nat.inj_lt i 9651 ltac:(lia)ltac:(lia)));lia.
Qed.
Lemma buffer_loads_from_packed : forall m bb,Spec.packed_state bb m ->buffer_loads m bb.
Proof.
 intros m bb PACKED i I.
 assert(BYTES:Mem.loadbytes m bb 0(Z.of_nat(length(map Byte.repr expected_bytes)))=
  Some(map Byte(map Byte.repr expected_bytes))).
 { rewrite map_length,expected_bytes_length,map_map;exact PACKED. }
 pose proof(whole_bytes_load_unsigned m bb 0(map Byte.repr expected_bytes)i BYTES
  ltac:(rewrite map_length,expected_bytes_length;exact I))as LOAD.
 cbn[Z.add]in LOAD.
 rewrite map_nth with(d:=0)in LOAD.
 rewrite Byte.unsigned_repr in LOAD by(change(0<=nth(Z.to_nat i)expected_bytes 0<=255);apply expected_byte_bounds;exact I).
 exact LOAD.
Qed.
Lemma low_machine_result_literal : forall a,-6433<=Int.signed a<=6433 ->
 low_result a=table_result literal_lookup a.
Proof.
 intros a B;unfold low_result,table_result;destruct(Int.cmp Cge a Int.zero)eqn:POS.
 - assert(NB:0<=Int.signed a<6434)by(apply cmp_nonneg in POS;lia).
   exact(proj1(machine_lookup_signed a NB)).
 - assert(N:Int.signed a<0).
   { destruct(Z_le_gt_dec 0(Int.signed a));[|lia].
     assert(C:Int.cmp Cge a Int.zero=true)by(apply cmp_nonneg;lia);congruence. }
   assert(NB:0<=Int.signed(Int.neg a)<6434)by(rewrite neg_signed_small by exact B;lia).
   pose proof(proj1(machine_lookup_signed(Int.neg a)NB))as M.
   rewrite neg_signed_small in M by exact B.
   f_equal;exact M.
Qed.
Lemma low_machine_equals_plain : forall a,Spec.normalized_angle a ->low_result(folded a)=literal_result a.
Proof. intros a B;apply low_machine_result_literal;apply folded_bounds;exact B. Qed.
Theorem low_total_packed : forall m bb a,
 Spec.normalized_angle a ->Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12=Some bb ->
 Spec.packed_state bb m ->
 Total.total PprzTrigLow.Execution.ge
  (fun v mf=>v=Vint(literal_result a)/\Spec.existing_frame m mf)
  (PprzTrigLow.Execution.entry[Vint a]m).
Proof.
 intros m bb a RANGE SYM PACKED.
 destruct decoder_link as[db[DS DF]];destruct dispatcher_link as[fb[FS FF]].
 pose proof(low_entry_total PprzTrigLow.Execution.ge m bb a db fb RANGE SYM
  (buffer_loads_from_packed _ _ PACKED)DS DF FS FF)as T.
 rewrite low_machine_equals_plain in T by exact RANGE;exact T.
Qed.
Theorem low_total_from_packed : forall m bb a,
 Spec.normalized_angle a ->Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12=Some bb ->
 Spec.packed_state bb m ->safe_termination PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint a]m).
Proof.
 intros m bb a RANGE SYM PACKED;pose proof(low_total_packed _ _ _ RANGE SYM PACKED)as T.
 split;[eapply Total.total_no_error|eapply Total.total_termination];exact T.
Qed.
Theorem low_returns_packed : forall m bb a,
 Spec.normalized_angle a ->Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12=Some bb ->
 Spec.packed_state bb m ->
 exists mf,Spec.Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry[Vint a]m(Vint(literal_result a))mf.
Proof.
 intros m bb a RANGE SYM PACKED.
 destruct(total_exists_return _ _ _ (low_total_packed _ _ _ RANGE SYM PACKED))as[v[mf[t[PATH[VALUE FRAME]]]]].
 subst v;exists mf,t;exact PATH.
Qed.
Theorem low_normal_returns_value_and_frame : forall m bb a v mf,
 Spec.normalized_angle a ->Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12=Some bb ->
 Spec.packed_state bb m ->
 Spec.Returns PprzTrigLow.Execution.ge PprzTrigLow.Execution.entry[Vint a]m v mf ->
 v=Vint(literal_result a)/\Spec.existing_frame m mf.
Proof.
 intros m bb a v mf RANGE SYM PACKED[t PATH].
 eapply(Total.total_result PprzTrigLow.Execution.ge
  (fun vv mm=>vv=Vint(literal_result a)/\Spec.existing_frame m mm)
  (PprzTrigLow.Execution.entry[Vint a]m)v mf t).
 - apply low_total_packed with(bb:=bb);auto.
 - exact PATH.
Qed.
Print Assumptions low_total_packed.
Print Assumptions low_returns_packed.
Print Assumptions low_normal_returns_value_and_frame.
