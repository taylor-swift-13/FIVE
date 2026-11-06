From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Globalenvs Ctypes Csem.
From FivePaparazziState Require Import State.
Require FiveGhSetOmega.Source FiveGhSetOmega.Execution.
Require FiveGhSetZeta.Source FiveGhSetZeta.Execution.
Definition shared_block : block :=
 match Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref with
 | Some b => b | None => 1%positive end.
Lemma omega_symbol : Genv.find_symbol FiveGhSetOmega.Execution.ge FiveGhSetOmega.Source._gh_ref=Some shared_block.
Proof. reflexivity. Qed.
Lemma zeta_symbol : Genv.find_symbol FiveGhSetZeta.Execution.ge FiveGhSetZeta.Source._gh_ref=Some shared_block.
Proof. reflexivity. Qed.
Definition zero_state : State.state :=
 State.mkstate Float32.zero Float32.zero Float32.zero Float32.zero
 Int64.zero Int64.zero Float32.zero Float32.zero Float32.zero Float32.zero
 Float32.zero Float32.zero Float32.zero Float32.zero.

Import ListNotations.
Local Open Scope Z_scope.
Lemma repeat_from_forall : forall (A:Type)(x:A) xs,
 Forall (eq x) xs -> xs=repeat x (length xs).
Proof. intros A x xs H;induction H;[reflexivity|]. subst x0;simpl;f_equal;exact IHForall. Qed.
Lemma zero_bytes_slice : forall m b ofs n,
 Mem.loadbytes m b 0 64=Some(repeat (Byte Byte.zero) 64%nat) ->
 0<=ofs -> 0<=n -> ofs+n<=64 ->
 Mem.loadbytes m b ofs n=Some(repeat (Byte Byte.zero)(Z.to_nat n)).
Proof.
 intros m b ofs n LD O N HI.
 replace 64 with (ofs+(64-ofs)) in LD by lia.
 destruct(Mem.loadbytes_split m b 0 ofs (64-ofs) _ LD ltac:(lia) ltac:(lia)) as [a[c[A[C EQ]]]].
 replace (0+ofs) with ofs in C by lia.
 replace (64-ofs) with (n+(64-ofs-n)) in C by lia.
 destruct(Mem.loadbytes_split m b ofs n (64-ofs-n) _ C ltac:(lia) ltac:(lia)) as [x[y[X[Y XY]]]].
 assert(ALL:Forall(eq(Byte Byte.zero))(repeat(Byte Byte.zero)64%nat)) by (repeat constructor).
 rewrite EQ in ALL;apply Forall_app in ALL as [_ AC].
 rewrite XY in AC;apply Forall_app in AC as [AX _].
 apply repeat_from_forall in AX.
 pose proof(Mem.loadbytes_length _ _ _ _ _ X)as LEN.
 rewrite LEN in AX;rewrite AX in X;exact X.
Qed.
Lemma concrete_initialized_state : exists m,
 State.repr zero_state m shared_block /\ State.writable m shared_block.
Proof.
 destruct(Genv.init_mem_exists FiveGhSetOmega.Source.prog)as[m INIT].
 { intros id v IN.
   assert(v=FiveGhSetOmega.Source.v_gh_ref).
   { change(In(id,Gvar v)FiveGhSetOmega.Source.global_definitions)in IN.
     simpl in IN;intuition congruence. }
   subst v;split.
   - simpl;split;[exists 0;reflexivity|exact I].
   - simpl;intros i o [H|H];[discriminate|contradiction]. }
 pose proof(Genv.init_mem_characterization FiveGhSetOmega.Source.prog shared_block
 (gv:=FiveGhSetOmega.Source.v_gh_ref) (m:=m) ltac:(reflexivity) INIT)as[W[_[_ BYTES]]].
 assert(B:Mem.loadbytes m shared_block 0 64=Some(repeat(Byte Byte.zero)64%nat)).
 { exact(BYTES eq_refl). }
 exists m;split;[|exact W].
 unfold State.repr,zero_state;simpl.
 repeat split;
 match goal with |- Mem.load ?chunk m shared_block ?ofs=Some ?v =>
   assert(LD:Mem.loadbytes m shared_block ofs (size_chunk chunk)=Some(repeat(Byte Byte.zero)(Z.to_nat(size_chunk chunk)))) by (eapply zero_bytes_slice;eauto;cbn;lia);
   pose proof(Mem.loadbytes_load chunk m shared_block ofs _ LD ltac:(cbn;match goal with |- (?d | ?n)=>exists(n/d);reflexivity end))as L;
   exact L
 end.
Qed.
Print Assumptions concrete_initialized_state.
