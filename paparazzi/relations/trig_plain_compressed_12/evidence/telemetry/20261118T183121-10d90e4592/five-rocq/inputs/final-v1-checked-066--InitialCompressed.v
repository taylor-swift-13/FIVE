From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes Csyntax Csem.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import TrigData InitialMemory PackedPrefix.
Open Scope Z_scope.
Lemma compressed_bytes_bounds : Forall(fun z=>0<=z<256)compressed_bytes.
Proof.
 assert(B:forallb(fun z=>(0<=?z)&&(z<=?255))compressed_bytes=true)by(vm_compute;reflexivity).
 apply Forall_forall;intros z IN. apply forallb_forall with(x:=z)in B;auto.
 apply andb_true_iff in B as[L U]. apply Z.leb_le in L;apply Z.leb_le in U;lia.
Qed.
Lemma data8_load_at : forall(F V:Type)(ge:Genv.t F V)xs m b p,
 Forall(fun z=>0<=z<256)xs ->Genv.load_store_init_data ge m b p(data8 xs) ->
 forall n,(n<length xs)%nat ->Mem.load Mint8unsigned m b(p+Z.of_nat n)=Some(Vint(Int.repr(nth n xs 0))).
Proof.
 intros F V ge xs;induction xs as[|x xs IH];intros m b p B LOAD n N;destruct n;try(cbn in N;lia).
 - inversion B as[|? ? BX BS];subst. cbn [data8 map Genv.load_store_init_data]in LOAD. destruct LOAD as[L _].
   replace(p+Z.of_nat 0)with p by lia. rewrite byte_extension in L by exact BX;exact L.
 - inversion B as[|? ? BX BS];subst. cbn [data8 map Genv.load_store_init_data]in LOAD. destruct LOAD as[_ LS].
   rewrite Nat2Z.inj_succ. replace(p+Z.succ(Z.of_nat n))with((p+1)+Z.of_nat n)by lia.
   apply IH;auto. cbn in N;lia.
Qed.
Local Opaque PprzTrigInit.Source.prog PprzTrigInit.Source.v_pprz_trig_int_compr compressed_bytes.
Lemma compressed_literal_loads : forall m b,
 Genv.init_mem PprzTrigInit.Source.prog=Some m ->
 Genv.find_var_info(Csem.globalenv PprzTrigInit.Source.prog)b=Some PprzTrigInit.Source.v_pprz_trig_int_compr ->
 forall i,0<=i<1690 ->Mem.load Mint8unsigned m b i=Some(Vint(Int.repr(nth(Z.to_nat i)compressed_bytes 0))).
Proof.
 intros m b INIT VAR i I.
 pose proof(source_initial_data PprzTrigInit.Source.prog m b PprzTrigInit.Source.v_pprz_trig_int_compr INIT VAR eq_refl)as LOAD.
 rewrite compressed_data_reified in LOAD.
 replace i with(0+Z.of_nat(Z.to_nat i))at 1 by(rewrite Z2Nat.id by lia;lia).
 eapply data8_load_at with(xs:=compressed_bytes)(ge:=Genv.globalenv(Ctypes.program_of_program PprzTrigInit.Source.prog)).
 - exact compressed_bytes_bounds.
 - exact LOAD.
 - rewrite(proj1(proj2 original_data_lengths)). apply Nat2Z.inj_lt;rewrite Z2Nat.id by lia;cbn;lia.
Qed.
Local Transparent PprzTrigInit.Source.v_pprz_trig_int_compr.
Lemma compressed_buffer_distinct : forall bc bb,
 Genv.find_var_info(Csem.globalenv PprzTrigInit.Source.prog)bc=Some PprzTrigInit.Source.v_pprz_trig_int_compr ->
 Genv.find_var_info(Csem.globalenv PprzTrigInit.Source.prog)bb=Some PprzTrigInit.Source.v_data_buf_12 ->bc<>bb.
Proof.
 intros bc bb C B E;subst bb;rewrite C in B.
 change(Some PprzTrigInit.Source.v_pprz_trig_int_compr=Some PprzTrigInit.Source.v_data_buf_12)in B.
 injection B as E. discriminate.
Qed.
