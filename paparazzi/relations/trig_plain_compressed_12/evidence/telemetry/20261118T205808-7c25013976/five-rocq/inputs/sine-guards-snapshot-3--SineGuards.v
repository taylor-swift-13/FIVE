From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec Smallstep.
Require PprzTrigPlain.Source PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import PlainBody PlainEntry LowSin LowEntry LowDispatcher MachineData TrigData PackedPrefix Total BranchPure PureEval.
From PprzTrigCBMC Require Import TypedGuards SourceObservations.
Import ListNotations.
Local Open Scope Z_scope.
Definition period_expr:=match PlainBody.upper_body with Sdo(Eassignop _ _ r _ _)=>r|_=>Eval Vundef tint end.
Lemma source_normalizer_shapes :
 PlainBody.upper_body=Sdo(Eassignop Osub(Evar PprzTrigPlain.Source._angle tint)period_expr tint tint) /\
 PlainBody.lower_body=Sdo(Eassignop Oadd(Evar PprzTrigPlain.Source._angle tint)period_expr tint tint) /\
 PlainBody.rhs_positive=Ebinop Osub PlainBody.pi_expr PlainBody.read_angle tint /\
 PlainBody.rhs_negative=Ebinop Osub(Eunop Oneg PlainBody.pi_expr tint)PlainBody.read_angle tint /\
 fn_body PprzTrigLow.Source.f_pprz_itrig_sin=Ssequence PlainBody.norm(Ssequence PlainBody.fold_stmt LowSin.low_return_stmt).
Proof. repeat split;reflexivity. Qed.
Lemma period_observation : forall(ge:Csem.genv) e m,source_observation ge e m period_expr(Vint(Int.repr 25735)).
Proof. intros;split;[reflexivity|]. vm_compute;reflexivity. Qed.
Theorem normalized_source_pc_guards : forall(ge:Csem.genv) local m a,
 -12867<=Int.signed a<=12867 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 source_observation ge(angle_env local)m PlainBody.read_angle(Vint a) /\
 source_observation ge(angle_env local)m PlainBody.upper_guard(Vint Int.zero) /\
 source_observation ge(angle_env local)m PlainBody.lower_guard(Vint Int.zero) /\
 source_observation ge(angle_env local)m PlainBody.rhs_positive(Vint(Int.sub(Int.repr 12867)a)) /\
 source_observation ge(angle_env local)m PlainBody.rhs_negative(Vint(Int.sub(Int.repr(-12867))a)) /\
 signed32(Int.signed a-25735) /\signed32(Int.signed a+25735) /\
 signed32(12867-Int.signed a) /\signed32(-12867-Int.signed a).
Proof.
 intros ge local m a RANGE LOAD.
 assert(A:source_observation ge(angle_env local)m PlainBody.read_angle(Vint a)).
 { split;[reflexivity|]. exact(angle_read ge local m a LOAD). }
 assert(U:source_observation ge(angle_env local)m PlainBody.upper_guard(Vint Int.zero)).
 { split;[reflexivity|]. exact(upper_guard_false ge local m a RANGE LOAD). }
 assert(L:source_observation ge(angle_env local)m PlainBody.lower_guard(Vint Int.zero)).
 { split;[reflexivity|]. exact(lower_guard_false ge local m a RANGE LOAD). }
 assert(P:source_observation ge(angle_env local)m PlainBody.rhs_positive(Vint(Int.sub(Int.repr 12867)a))).
 { split;[reflexivity|]. exact(rhs_positive_value ge local m a LOAD). }
 assert(N:source_observation ge(angle_env local)m PlainBody.rhs_negative(Vint(Int.sub(Int.repr(-12867))a))).
 { split;[reflexivity|]. exact(rhs_negative_value ge local m a LOAD). }
 repeat first[assumption|split];unfold signed32;lia.
Qed.
Theorem normalized_source_zero_unwind : forall(ge:Csem.genv) f k local m a,
 -12867<=Int.signed a<=12867 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 expression_prefix ge f k(angle_env local)m PlainBody.upper_guard m(Eval(Vint Int.zero)tint) /\
 expression_prefix ge f k(angle_env local)m PlainBody.lower_guard m(Eval(Vint Int.zero)tint) /\
 (forall mf v ty,expression_prefix ge f k(angle_env local)m PlainBody.upper_guard mf(Eval v ty)->v=Vint Int.zero) /\
 (forall mf v ty,expression_prefix ge f k(angle_env local)m PlainBody.lower_guard mf(Eval v ty)->v=Vint Int.zero).
Proof.
 intros ge f k local m a R L.
 destruct(normalized_source_pc_guards ge local m a R L)as[A[U[D REST]]].
 split;[exact(observation_evaluation_exists ge f k _ _ _ _ U)|]. split;[exact(observation_evaluation_exists ge f k _ _ _ _ D)|]. split.
 - intros mf v ty H;exact(proj2(observation_terminal_unique _ _ _ _ _ _ _ _ _ _ U H)).
 - intros mf v ty H;exact(proj2(observation_terminal_unique _ _ _ _ _ _ _ _ _ _ D H)).
Qed.
Theorem folded_source_index_guards : forall a,-12867<=Int.signed a<=12867 ->
 -6433<=Int.signed(folded a)<=6433 /\signed32(-Int.signed(folded a)) /\
 (0<=Int.signed(folded a)->0<=Int.signed(folded a)<6434) /\
 (Int.signed(folded a)<0->0<= -Int.signed(folded a)<6434).
Proof. intros a A;pose proof(folded_bounds a A);unfold signed32;repeat split;lia. Qed.
Theorem plain_positive_lookup_pc : forall(ge:Csem.genv) local m table a v,
 0<=Int.signed a<6434 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->
 Mem.load Mint16signed m table(2*Int.signed a)=Some(Vint v) ->
 source_observation ge(angle_env local)m lookup_expr(Vint v) /\
 0<=Int.signed a<6434 /\signed16(Int.signed v) /\signed32(-Int.signed v).
Proof.
 intros ge local m table a v A L S T.
 pose proof(load_signed16_range m table(2*Int.signed a)v T)as V.
 split;[split;[reflexivity|exact(lookup_value ge local m table a v A L S T)]|].
 unfold signed16 in V;unfold signed32;repeat split;lia.
Qed.
Theorem plain_negative_lookup_pc : forall(ge:Csem.genv) local m table a v,
 -6433<=Int.signed a<0 ->Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge PprzTrigPlain.Source._pprz_trig_int=Some table ->
 Mem.load Mint16signed m table(2* -Int.signed a)=Some(Vint v) ->
 source_observation ge(angle_env local)m lookup_negative_expr(Vint(Int.neg v)) /\
 0<= -Int.signed a<6434 /\signed32(-Int.signed a) /\signed16(Int.signed v) /\signed32(-Int.signed v).
Proof.
 intros ge local m table a v A L S T.
 pose proof(load_signed16_range m table(2* -Int.signed a)v T)as V.
 split;[split;[reflexivity|exact(lookup_negative_value ge local m table a v A L S T)]|].
 unfold signed16 in V;unfold signed32;repeat split;lia.
Qed.
Lemma decoded_result_bound : forall a,0<=Int.signed a<6434 ->0<=Int.signed(machine_lookup a)<=16383.
Proof.
 intros a A;rewrite(proj1(machine_lookup_signed a A)).
 pose proof(literal_value_at_bounds(Int.signed a)A)as B.
 rewrite Int.signed_repr by(change(-2147483648<=table_at(Int.signed a)<=2147483647);lia);exact B.
Qed.
Theorem actual_decoder_return_pc : forall(ge:Csem.genv) m bb a,
 0<=Int.signed a<6434 ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 (exists mf t,star Csem.step ge(Callstate(Internal LowDecoder.decoder)[Vint a]Kstop m)t
 (Returnstate(Vint(machine_lookup a))Kstop mf)) /\
 (forall mf v t,star Csem.step ge(Callstate(Internal LowDecoder.decoder)[Vint a]Kstop m)t(Returnstate v Kstop mf)->
 v=Vint(machine_lookup a)) /\
 0<=Int.signed(machine_lookup a)<=16383 /\signed32(-Int.signed(machine_lookup a)).
Proof.
 intros ge m bb a A S B.
 assert(T:Total.total ge(fun v _=>v=Vint(machine_lookup a))(Callstate(Internal LowDecoder.decoder)[Vint a]Kstop m)).
 { eapply decoder_entry_total;try eassumption;intros;apply Total.total_final;reflexivity. }
 destruct(PlainEntry.total_exists_return _ _ _ T)as[v[mf[t[RUN EQ]]]];subst v.
 pose proof(decoded_result_bound a A)as RB;split;[eauto|]. split.
 - intros;exact(Total.total_result ge _ _ _ _ _ T H).
 - unfold signed32;split;[exact RB|lia].
Qed.
Theorem actual_dispatcher_return_pc : forall(ge:Csem.genv) m bb a funblock,
 0<=Int.signed a<6434 ->Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->buffer_loads m bb ->
 Genv.find_symbol ge PprzTrigLow.Source._pprz_trig_int_12=Some funblock ->
 Genv.find_funct ge(Vptr funblock Ptrofs.zero)=Some(Internal LowDecoder.decoder) ->
 (exists mf t,star Csem.step ge(Callstate(Internal LowDispatcher.dispatcher)[Vint a]Kstop m)t
 (Returnstate(Vint(machine_lookup a))Kstop mf)) /\
 (forall mf v t,star Csem.step ge(Callstate(Internal LowDispatcher.dispatcher)[Vint a]Kstop m)t(Returnstate v Kstop mf)->
 v=Vint(machine_lookup a)) /\signed32(-Int.signed(machine_lookup a)).
Proof.
 intros ge m bb a funblock A S B LINK FUN.
 assert(T:Total.total ge(fun v _=>v=Vint(machine_lookup a))(Callstate(Internal LowDispatcher.dispatcher)[Vint a]Kstop m)).
 { eapply dispatcher_entry_total;try eassumption;intros;apply Total.total_final;reflexivity. }
 destruct(PlainEntry.total_exists_return _ _ _ T)as[v[mf[t[RUN EQ]]]];subst v.
 pose proof(decoded_result_bound a A)as RB;split;[eauto|]. split.
 - intros;exact(Total.total_result ge _ _ _ _ _ T H).
 - unfold signed32;lia.
Qed.
Print Assumptions normalized_source_pc_guards.
Print Assumptions actual_dispatcher_return_pc.
