From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Maps Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution PhaseComposition.
From StateSpeedSetterSupport Require Import MemoryFacts StoreEffects Certificates GuardShell.
From StateSpeedSetNedISupport Require Import Setup Layout Body Parameters Termination.
From StateSpeedSetNedIExecutionProblem Require Import Closure.
Import ListNotations.
Open Scope Z_scope.
Local Opaque ge E.ge.

Lemma original_trace_empty:forall args m t reached,
 star Csem.step ge(E.entry args m)t reached ->t=E0.
Proof.
 intros args m t reached PATH;pose proof(Closure.entry_source args m)as INIT.
 revert INIT;induction PATH;intros INIT;[reflexivity|].
 destruct(Closure.source_step_invariant _ _ _ INIT H)as[TT NEXT].
 specialize(IHPATH NEXT);subst t1 t2;cbn in *;congruence.
Qed.

Theorem original_certificate:forall m sb src id x y z,
 InputGood m sb src id x y z ->
 exists mf P,certificate ge P(Returnstate Vundef Kstop mf) /\
 P(E.entry(Args id src)m) /\SetterResult m mf sb src x y z.
Proof.
 intros m sb src id x y z GOOD.
 pose proof GOOD as[SYMBOL W FILTER SRC WORDS].
 assert(VS:Mem.valid_block m sb)by(eapply(range_valid m sb 656 Writable);[lia|exact W]).
 assert(VI:Mem.valid_block m src)by(destruct WORDS as[A[B C]];eapply loaded_valid;exact A).
 destruct(parameters_exist m id src)as(e&m0&bi&bp&TRACE&WI&WP&DIST&PTR).
 assert(ENV:e=parameter_env bi bp)by(destruct TRACE as(a&b&c&A&B&C&D&E);exact E).
 destruct(parameter_lookups bi bp)as[IDLOOK[LOOK NONE]].
 rewrite<-ENV in IDLOOK,LOOK,NONE.
 pose proof(parameter_input_good m id src e m0 bi bp TRACE sb x y z GOOD)as GOOD0.
 destruct GOOD0 as[SYMBOL0 W0 FILTER0 SRC0 WORDS0].
 destruct(parameter_fresh m id src e m0 bi bp TRACE sb VS)as[SBI SBP].
 assert(BP:bp<>sb)by congruence.
 destruct(four_stores_exist destination_offset(Int.repr selected_status)m0 sb x y z
 ltac:(unfold destination_offset;lia)ltac:(unfold destination_offset;lia)
 ltac:(unfold destination_offset;exists 74;reflexivity)W0)as[mb[m1[m2[m3[X[Y[ZS ST]]]]]]].
 pose proof(body_evaluates e m0 m1 m2 m3 mb sb bp src x y z NONE SYMBOL0 LOOK BP SRC0 PTR WORDS0 X Y ZS ST)as BODY.
 assert(WIF:Mem.valid_access mb Mint16unsigned bi 0 Freeable).
 { eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact ZS|].
   eapply Mem.store_valid_access_1;[exact Y|];eapply Mem.store_valid_access_1;[exact X|exact WI]. }
 assert(WPF:Mem.valid_access mb Mptr bp 0 Freeable).
 { eapply Mem.store_valid_access_1;[exact ST|];eapply Mem.store_valid_access_1;[exact ZS|].
   eapply Mem.store_valid_access_1;[exact Y|];eapply Mem.store_valid_access_1;[exact X|exact WP]. }
 destruct(release_parameters m id src e m0 bi bp TRACE mb WIF WPF)as[mf[FREE[LOAD[BYTES PERM]]]].
 pose proof(body_defined e m0 mb mf BODY FREE)as BODYINV.
 set(Q:=fun s=>normal_state s=true /\call_names s /\state_eval ge s=Some(Vundef,mf)).
 assert(QC:certificate ge Q(Returnstate Vundef Kstop mf))by(apply evaluator_certificate).
 assert(QI:Q(State f copy_body Kstop e m0))by exact BODYINV.
 destruct(accepted_tests e m0 sb NONE SYMBOL0 FILTER0)as[A0 B1].
 pose proof(guard_false_certificate ge f e m0(Kseq copy_body Kstop)(Sreturn None)Sskip
 first_test second_test third_test eq_refl eq_refl A0 eq_refl eq_refl B1)as GC.
 pose proof(guard_false_initial ge f e m0(Kseq copy_body Kstop)(Sreturn None)Sskip first_test second_test third_test)as GI.
 set(R:=guard_false_invariant ge f e m0(Kseq copy_body Kstop)(Sreturn None)Sskip first_test second_test third_test).
 assert(RC:certificate ge(fun s=>R s \/Q s)(Returnstate Vundef Kstop mf)).
 { eapply chain_certificate;[exact GC|exact QC|apply skip_seq_unique|exact QI]. }
 assert(RI:(fun s=>R s \/Q s)(State f guard(Kseq copy_body Kstop)e m0))by(left;exact GI).
 pose proof(prepend_certificate ge(fun s=>R s \/Q s)(Returnstate Vundef Kstop mf)
 (State f(Ssequence guard copy_body)Kstop e m0)(State f guard(Kseq copy_body Kstop)e m0)
 RC RI(sequence_unique ge f guard copy_body Kstop e m0))as SC.
 assert(SI:(fun s=>s=State f(Ssequence guard copy_body)Kstop e m0 \/R s \/Q s)
 (State f(Ssequence guard copy_body)Kstop e m0))by(left;reflexivity).
 pose proof(parameter_step m id src e m0 bi bp TRACE)as ENTRY;rewrite source_body in ENTRY.
 pose proof(prepend_certificate ge _ (Returnstate Vundef Kstop mf)
 (E.entry(Args id src)m)(State f(Ssequence guard copy_body)Kstop e m0)SC SI ENTRY)as FINAL.
 exists mf,(fun s=>s=E.entry(Args id src)m \/s=State f(Ssequence guard copy_body)Kstop e m0 \/R s \/Q s).
 split;[exact FINAL|];split;[left;reflexivity|].
 assert(COPY:Mem.load Mint32 mb sb destination_offset=Some(Vint x) /\
 Mem.load Mint32 mb sb(destination_offset+4)=Some(Vint y) /\
 Mem.load Mint32 mb sb(destination_offset+8)=Some(Vint z) /\
 Mem.load Mint16unsigned mb sb 280=Some(Vint(Int.repr selected_status))).
 { eapply four_store_words;[unfold destination_offset;lia|exact X|exact Y|exact ZS|exact ST]. }
 destruct COPY as[CX[CY[CZ CS]]].
 assert(BC:Mem.loadbytes mb sb destination_offset 12=Some(typed_bytes x y z)).
 { eapply four_store_bytes;[unfold destination_offset;lia|exact X|exact Y|exact ZS|exact ST]. }
 assert(IC:VecRead mb src x y z).
 { eapply four_store_input;[exact X|exact Y|exact ZS|exact ST|exact SRC0|exact WORDS0]. }
 assert(SPERM:forall b ofs k p,Mem.perm m0 b ofs k p<->Mem.perm mb b ofs k p).
 { intros;eapply four_store_permissions;[exact X|exact Y|exact ZS|exact ST]. }
 constructor.
 - rewrite(LOAD Mint32 sb destination_offset VS);exact CX.
 - rewrite(LOAD Mint32 sb(destination_offset+4)VS);exact CY.
 - rewrite(LOAD Mint32 sb(destination_offset+8)VS);exact CZ.
 - rewrite(LOAD Mint16unsigned sb 280 VS);exact CS.
 - rewrite(BYTES sb destination_offset 12 VS);exact BC.
 - destruct IC as[IX[IY IZ]];unfold VecRead;repeat split;rewrite LOAD by exact VI;assumption.
 - intros b ofs k p VB.
   pose proof(parameter_permissions m id src e m0 bi bp TRACE b ofs k p VB)as PM.
   split;intro P.
   + apply(proj1(PERM b ofs k p VB));apply(proj1(SPERM b ofs k p));apply(proj1 PM);exact P.
   + apply(proj2 PM);apply(proj2(SPERM b ofs k p));apply(proj2(PERM b ofs k p VB));exact P.
 - intros b ofs n VB N MISS;rewrite(BYTES b ofs n VB).
   erewrite four_store_frame;[|exact X|exact Y|exact ZS|exact ST|exact N|exact MISS].
   exact(parameter_bytes_frame m id src e m0 bi bp TRACE b ofs n VB).
Qed.

Theorem original_normal_result:forall m sb src id x y z,
 InputGood m sb src id x y z ->exists mf,
 NormalCall id src m mf /\SetterResult m mf sb src x y z /\
 (forall mf',NormalCall id src m mf' ->mf'=mf).
Proof.
 intros m sb src id x y z GOOD;destruct(original_certificate m sb src id x y z GOOD)as(mf&P&CERT&INIT&POST).
 destruct(certificate_has_return ge P(Returnstate Vundef Kstop mf)(E.entry(Args id src)m)CERT INIT
 (all_successor_termination(Args id src)m))as[t PATH].
 pose proof(original_trace_empty _ _ _ _ PATH)as TT;subst t.
 exists mf;split;[exact PATH|];split;[exact POST|].
 intros mf' CALL;exact(proj2(certificate_normal_unique ge P Vundef mf(E.entry(Args id src)m)CERT INIT E0 Vundef mf' CALL)).
Qed.
Theorem original_no_error:forall m sb src id x y z,
 InputGood m sb src id x y z ->Obligations.no_error ge(E.entry(Args id src)m).
Proof.
 intros m sb src id x y z GOOD;destruct(original_certificate m sb src id x y z GOOD)as(mf&P&CERT&INIT&POST).
 unfold Obligations.no_error;intros t reached PATH[NR STOP].
 assert(TERMINAL:nostep Csem.step ge(Returnstate Vundef Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 destruct(certificate_no_error ge P _ _ CERT INIT TERMINAL t reached PATH)as[EQ|[tr[next STEP]]].
 - subst reached;apply NR;exists Vundef,mf;reflexivity.
 - exact(STOP tr next STEP).
Qed.
Print Assumptions original_normal_result.
Print Assumptions original_no_error.
