From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Globalenvs Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveShared.pure_semantics Require Import SemanticsSupport.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import InitialMemory InitComplete PlainClosed PlainCore PlainBody ClosedCalls ExecutionAlignment ModelIdentity.
From PprzTrigCBMC Require Import GlobalMemory GlobalAccess NoShadow.
Import ListNotations.
Local Open Scope Z_scope.
Lemma source_initial_global_bounds:forall(p:Csyntax.program)m id b(gv:globvar type),
 Genv.init_mem p=Some m ->Genv.find_symbol(Csem.globalenv p)id=Some b ->
 Genv.find_var_info(Csem.globalenv p)b=Some gv ->global_bounds b(init_data_list_size(gvar_init gv))m.
Proof.
 intros p m id b gv INIT SYMBOL VAR.
 pose proof(@Genv.init_mem_characterization Csyntax.fundef Ctypes.type(Ctypes.program_of_program p)b gv m VAR INIT)as H.
 split;[eapply Genv.find_symbol_not_fresh;[exact INIT|exact SYMBOL]|].
 intros ofs PER;exact(proj1(proj1(proj2 H)ofs Max Nonempty PER)).
Qed.
Lemma source_array_sizes:
 init_data_list_size(gvar_init PprzTrigPlain.Source.v_pprz_trig_int)=12868 /\
 init_data_list_size(gvar_init PprzTrigInit.Source.v_pprz_trig_int_compr)=1690 /\
 init_data_list_size(gvar_init PprzTrigInit.Source.v_data_buf_12)=9651.
Proof. vm_compute;auto. Qed.
Local Opaque PprzTrigPlain.Source.prog PprzTrigInit.Source.prog.
Lemma plain_initial_bounds:forall mp b,Spec.initial_plain mp ->
 Genv.find_symbol PprzTrigPlain.Execution.ge PprzTrigPlain.Source._pprz_trig_int=Some b ->global_bounds b 12868 mp.
Proof.
 intros mp b INIT SYMBOL;destruct plain_symbol_info_exists as[bb[S V]].
 change(Genv.find_symbol PprzTrigPlain.Execution.ge PprzTrigPlain.Source._pprz_trig_int=Some bb)in S.
 rewrite SYMBOL in S;injection S as SAME;subst bb.
 pose proof(@source_initial_global_bounds PprzTrigPlain.Source.prog mp PprzTrigPlain.Source._pprz_trig_int b PprzTrigPlain.Source.v_pprz_trig_int INIT SYMBOL V)as B.
 rewrite(proj1 source_array_sizes)in B;exact B.
Qed.
Lemma rom_initial_bounds:forall ml b,Spec.initial_low ml ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some b ->global_bounds b 1690 ml.
Proof.
 intros ml b INIT SYMBOL;destruct compressed_symbol_info_exists as[bb[S V]].
 change(Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some bb)in S.
 rewrite SYMBOL in S;injection S as SAME;subst bb.
 pose proof(@source_initial_global_bounds PprzTrigInit.Source.prog ml PprzTrigInit.Source._pprz_trig_int_compr b PprzTrigInit.Source.v_pprz_trig_int_compr INIT SYMBOL V)as B.
 rewrite(proj1(proj2 source_array_sizes))in B;exact B.
Qed.
Lemma buffer_initial_bounds:forall ml b,Spec.initial_low ml ->Spec.buffer_symbol b ->global_bounds b 9651 ml.
Proof.
 intros ml b INIT SYMBOL;destruct buffer_symbol_info_exists as[bb[S V]].
 change(Spec.buffer_symbol bb)in S;rewrite SYMBOL in S;injection S as SAME;subst bb.
 pose proof(@source_initial_global_bounds PprzTrigInit.Source.prog ml PprzTrigInit.Source._data_buf_12 b PprzTrigInit.Source.v_data_buf_12 INIT SYMBOL V)as B.
 rewrite(proj2(proj2 source_array_sizes))in B;exact B.
Qed.
Lemma initialized_buffer_bounds:forall ml ml' b,Spec.initial_low ml ->Spec.buffer_symbol b ->
 Spec.init_returns ml(Vint Int.zero)ml' ->global_bounds b 9651 ml'.
Proof.
 intros ml ml' b INIT SYMBOL[t PATH].
 exact(global_bounds_reachable PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]ml)b 9651 t _
  (buffer_initial_bounds ml b INIT SYMBOL)PATH).
Qed.
Lemma plain_source_silent:forall args m prefix s,
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry args m)prefix s ->silent_state PprzTrigPlain.Execution.ge s.
Proof. intros;exact(@PlainCore.source_silent PprzTrigPlain.Source.f_pprz_itrig_sin ExecutionAlignment.plain_body_core PprzTrigPlain.Execution.ge s(ExecutionAlignment.plain_reachable_core args m prefix s H)). Qed.
Lemma low_source_silent:forall args m prefix s,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s ->silent_state PprzTrigLow.Execution.ge s.
Proof. intros;exact(@ClosedCalls.closed_silent PprzTrigLow.Execution.ge ClosedCalls.actual_allowed ClosedCalls.direct_ids s(ClosedCalls.low_reachable_closed args m prefix s H)). Qed.
Lemma init_source_silent:forall args m prefix s,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix s ->silent_state PprzTrigInit.Execution.ge s.
Proof. intros;exact(@ClosedCalls.closed_silent PprzTrigLow.Execution.ge ClosedCalls.actual_allowed ClosedCalls.direct_ids s(ClosedCalls.init_reachable_closed args m prefix s H)). Qed.
(** The target is the actual pinned64-bit CompCert architecture.  Recovering
    the source signed offset is justified, rather than assuming pointer wrap
    cannot land in another part of the same array. *)
Lemma signed_offset_nowrap:forall z size,
 -4294967296<=z<=4294967296 ->0<=size<=12868 ->
 0<=Ptrofs.unsigned(Ptrofs.repr z)<size ->0<=z<size.
Proof.
 intros z size ZR SZ PTR.
 assert(S:Ptrofs.min_signed<=z<=Ptrofs.max_signed)by(change(-9223372036854775808<=z<=9223372036854775807);lia).
 assert(U:Ptrofs.unsigned(Ptrofs.repr z)<=Ptrofs.max_signed)by(change(Ptrofs.unsigned(Ptrofs.repr z)<=9223372036854775807);lia).
 pose proof(Ptrofs.signed_repr z S);pose proof(Ptrofs.signed_eq_unsigned(Ptrofs.repr z)U);lia.
Qed.
Corollary ordinary_index_from_pointer_guard:forall i,
 -2147483648<=i<=2147483647 ->0<=Ptrofs.unsigned(Ptrofs.repr(2*i))<12868 ->0<=i<6434.
Proof. intros;pose proof(signed_offset_nowrap(2*i)12868 ltac:(lia)ltac:(lia)H0);lia. Qed.
Corollary byte_index_from_pointer_guard:forall i size,
 -4294967296<=i<=4294967296 ->0<=size<=12868 ->
 0<=Ptrofs.unsigned(Ptrofs.repr i)<size ->0<=i<size.
Proof. exact signed_offset_nowrap. Qed.
Print Assumptions source_initial_global_bounds.
Print Assumptions initialized_buffer_bounds.
Print Assumptions signed_offset_nowrap.
