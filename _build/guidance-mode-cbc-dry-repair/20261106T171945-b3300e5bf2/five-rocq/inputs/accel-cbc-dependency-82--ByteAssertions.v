From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Integers Floats AST Values Memory Events Csem.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceCbmcAdapters Require Import BitsAdapter.
Require FiveGuidanceCbmcAdapters.ManualAssertions.
Module Logical:=FiveGuidanceCbmcAdapters.ManualAssertions.
Import ListNotations.
Local Open Scope Z_scope.
Definition OldFrame(m mf:mem):Prop:=
 (forall ch b ofs,Mem.valid_block m b->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b->0<=n->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n) /\
 (forall b,Mem.valid_block m b->Mem.valid_block mf b).
Lemma bits_frame:forall ge x m mf v,BitsRun ge x m mf v->OldFrame m mf.
Proof. intros ge x m mf v RUN;destruct(bits_run_old_frame ge x m mf v RUN)as[L B];split;[exact L|];split;[exact B|exact(bits_run_old_valid ge x m mf v RUN)]. Qed.
Lemma old_frame_trans:forall m m1 mf,OldFrame m m1->OldFrame m1 mf->OldFrame m mf.
Proof.
 intros m m1 mf[L1[B1 V1]][L2[B2 V2]];split.
 - intros ch b ofs VB;rewrite L2 by(apply V1;exact VB);apply L1;exact VB.
 - split;[intros b ofs n VB N;rewrite B2 by(auto);apply B1;auto|auto].
Qed.
Lemma float_load_valid:forall m b ofs x,Mem.load Mfloat32 m b ofs=Some(Vsingle x)->Mem.valid_block m b.
Proof. intros;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact H|constructor]. Qed.
Definition FloatTestRun(ge:genv)(b:block)(ofs:Z)(expected:float32)(actual_first:bool)(m mf:mem):Prop:=
 exists actual m1,
 (if actual_first then
   Mem.load Mfloat32 m b ofs=Some(Vsingle actual) /\
   BitsRun ge actual m m1(Float32.to_bits actual) /\BitsRun ge expected m1 mf(Float32.to_bits expected)
  else BitsRun ge expected m m1(Float32.to_bits expected) /\
   Mem.load Mfloat32 m1 b ofs=Some(Vsingle actual) /\BitsRun ge actual m1 mf(Float32.to_bits actual)) /\
 Int32AssertionTrue ge(Float32.to_bits actual)(Float32.to_bits expected)mf /\OldFrame m mf.
Lemma float_test_exists:forall ge m b ofs expected,
 Logical.float_bits_load m b ofs expected->forall order,exists mf,FloatTestRun ge b ofs expected order m mf.
Proof.
 intros ge m b ofs expected[actual[LOAD EQ]]order;destruct order.
 - destruct(bits_run_exists ge actual m)as[m1 A];destruct(bits_run_exists ge expected m1)as[mf B].
   exists mf,actual,m1;split;[auto|]. split;[apply int32_assertion_true;exact EQ|].
   eapply old_frame_trans;[eapply bits_frame;exact A|eapply bits_frame;exact B].
 - destruct(bits_run_exists ge expected m)as[m1 A];destruct(bits_run_exists ge actual m1)as[mf B].
   assert(VB:Mem.valid_block m b)by(eapply float_load_valid;exact LOAD).
   pose proof(bits_frame ge expected m m1 _ A)as F.
   assert(LOAD1:Mem.load Mfloat32 m1 b ofs=Some(Vsingle actual))by(rewrite(proj1 F)by exact VB;exact LOAD).
   exists mf,actual,m1;split;[auto|]. split;[apply int32_assertion_true;exact EQ|].
   eapply old_frame_trans;[exact F|eapply bits_frame;exact B].
Qed.
Inductive FloatTestsRun(ge:genv)(b:block):list(Z*float32)->list bool->mem->mem->Prop:=
 | tests_nil:forall m,FloatTestsRun ge b[][]m m
 | tests_cons:forall ofs x tests order orders m m1 mf,
   FloatTestRun ge b ofs x order m m1->FloatTestsRun ge b tests orders m1 mf->
   FloatTestsRun ge b((ofs,x)::tests)(order::orders)m mf.
Definition ThreadedTests(ge:genv)(tests:list(Z*float32))(m:mem)(b:block):Prop:=
 forall orders,length orders=length tests->exists mf,FloatTestsRun ge b tests orders m mf.
Lemma observations_frame:forall tests m m1 b,
 OldFrame m m1->Forall(fun p=>Logical.float_bits_load m b(fst p)(snd p))tests->
 Forall(fun p=>Logical.float_bits_load m1 b(fst p)(snd p))tests.
Proof.
 intros tests m m1 b[L REST]OBS;induction OBS;constructor;auto.
 destruct H as[a[LOAD EQ]];exists a;split;[rewrite L;[exact LOAD|eapply float_load_valid;exact LOAD]|exact EQ].
Qed.
Lemma threaded_tests_exists:forall ge tests m b,
 Forall(fun p=>Logical.float_bits_load m b(fst p)(snd p))tests->ThreadedTests ge tests m b.
Proof.
 intros ge tests;induction tests as[|[ofs x]tests IH];intros m b OBS orders LEN.
 - destruct orders;cbn in LEN;try discriminate;exists m;constructor.
 - inversion OBS;subst;destruct orders as[|order orders];cbn in LEN;try discriminate.
   destruct(float_test_exists ge m b ofs x H1 order)as[m1 RUN].
   assert(FRAME:OldFrame m m1)by(destruct RUN as[a[mm[REST[BOOL FRAME]]]];exact FRAME).
   destruct(IH m1 b(observations_frame tests m m1 b FRAME H2)orders ltac:(lia))as[mf REST].
   exists mf;econstructor;eauto.
Qed.
Definition parameter_tests(s:state):list(Z*float32):=
 [(32,tau s);(36,omega s);(40,zeta s);(44,max_speed s);(48,zeta_omega s);(52,omega_2 s);(56,inv_tau s);(60,dt s)].
Definition ByteObservation(ge:genv)(index:nat)(old expected:state)(m:mem)(b:block):Prop:=
 match index with
 |1%nat=>Mem.load Mint64 m b 16=Some(Vlong(pos_x expected)) /\Int64AssertionTrue ge(pos_x expected)(pos_x expected)m
 |2%nat=>ThreadedTests ge[(8,speed_x expected)]m b
 |3%nat=>ThreadedTests ge[(0,accel_x expected)]m b
 |4%nat=>Mem.load Mint64 m b 24=Some(Vlong(pos_y expected)) /\Int64AssertionTrue ge(pos_y expected)(pos_y expected)m
 |5%nat=>ThreadedTests ge[(12,speed_y expected)]m b
 |6%nat=>ThreadedTests ge[(4,accel_y expected)]m b
 |7%nat=>ThreadedTests ge(parameter_tests old)m b
 |_=>False end.
Lemma logical_to_bytes:forall ge index old expected m b,
 Logical.manual_observation index old expected m b->ByteObservation ge index old expected m b.
Proof.
 intros ge index old expected m b OBS;destruct index as[|[|[|[|[|[|[|[|n]]]]]]]];cbn[Logical.manual_observation ByteObservation]in *;try contradiction.
 - split;[exact OBS|apply int64_assertion_true;reflexivity].
 - apply threaded_tests_exists;constructor;[exact OBS|constructor].
 - apply threaded_tests_exists;constructor;[exact OBS|constructor].
 - split;[exact OBS|apply int64_assertion_true;reflexivity].
 - apply threaded_tests_exists;constructor;[exact OBS|constructor].
 - apply threaded_tests_exists;constructor;[exact OBS|constructor].
 - unfold Logical.parameter_memory_bits in OBS;destruct OBS as[A[B[C[D[E[F[G H]]]]]]].
   apply threaded_tests_exists;unfold parameter_tests;repeat constructor;assumption.
Qed.
Definition manual_speed_id(index:nat):Prop:=
 (1<=index<=14)%nat /\Logical.manual_speed_id index /\
 forall s m bg src o,speed_initial s(Logical.speed_scenario index)m bg src o->
 exists mf,speed_call m src o mf /\
 ByteObservation FiveGhSpeed.Execution.ge(Logical.observation_index index)s(Logical.speed_expected s(Logical.speed_scenario index))mf bg /\
 forall final,speed_call m src o final->ByteObservation FiveGhSpeed.Execution.ge(Logical.observation_index index)s(Logical.speed_expected s(Logical.speed_scenario index))final bg.
Definition manual_accel_id(index:nat):Prop:=
 (1<=index<=14)%nat /\Logical.manual_accel_id index /\
 forall s m bg src o,accel_initial s(Logical.accel_scenario index)m bg src o->
 exists mf,accel_call m src o mf /\
 ByteObservation FiveGhAccel.Execution.ge(Logical.observation_index index)s(Logical.accel_expected s(Logical.accel_scenario index))mf bg /\
 forall final,accel_call m src o final->ByteObservation FiveGhAccel.Execution.ge(Logical.observation_index index)s(Logical.accel_expected s(Logical.accel_scenario index))final bg.
Theorem manual_speed_assertions:forall n,(1<=n<=14)%nat->manual_speed_id n.
Proof.
 intros n R;pose proof(Logical.manual_speed_assertions n R)as P;split;[exact R|]. split;[exact P|].
 intros s m bg src o INIT;destruct(P s m bg src o INIT)as[mf[CALL[OBS ALL]]].
 exists mf;split;[exact CALL|]. split;[apply logical_to_bytes;exact OBS|].
 intros final RET;apply logical_to_bytes;apply ALL;exact RET.
Qed.
Theorem manual_accel_assertions:forall n,(1<=n<=14)%nat->manual_accel_id n.
Proof.
 intros n R;pose proof(Logical.manual_accel_assertions n R)as P;split;[exact R|]. split;[exact P|].
 intros s m bg src o INIT;destruct(P s m bg src o INIT)as[mf[CALL[OBS ALL]]].
 exists mf;split;[exact CALL|]. split;[apply logical_to_bytes;exact OBS|].
 intros final RET;apply logical_to_bytes;apply ALL;exact RET.
Qed.
Print Assumptions manual_speed_assertions.
Print Assumptions manual_accel_assertions.
