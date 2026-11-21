From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation CallfreeExecution PhaseComposition PureIfShell FactorShell.
From StateSpeedSetterSupport Require Import MemoryFacts Certificates.
From StateSpeedGetterSupport Require Import Setup Layout Body Calculation StoreEffects ZeroCallShell Certificates.
Require StateSpeedGetterSupport.GetterSource.
Import ListNotations.
Open Scope Z_scope.
Module SC:=StateSpeedSetterSupport.Certificates.
Module GC:=StateSpeedGetterSupport.Certificates.
Module GS:=StateSpeedGetterSupport.GetterSource.
Module SE:=StateSpeedGetterSupport.StoreEffects.
Local Opaque ge E.ge.
Lemma returned_pointer_value:forall m sb,
 Genv.find_symbol ge S._state=Some sb->
 pure_rval ge empty_env m(Eaddrof(Efield state_address S._ecef_speed_f(Tstruct S._EcefCoor_f noattr))(tptr(Tstruct S._EcefCoor_f noattr)))=Some(Vptr sb(Ptrofs.repr 328)).
Proof.
 intros m sb SYM.
 change((match pure_lval ge empty_env m(Efield state_address S._ecef_speed_f(Tstruct S._EcefCoor_f noattr))with Some(b,ofs,Full)=>Some(Vptr b ofs)|_=>None end)=Some(Vptr sb(Ptrofs.repr 328))).
 rewrite(state_field_address empty_env m sb S._ecef_speed_f(Tstruct S._EcefCoor_f noattr)328 eq_refl SYM float_layout);reflexivity.
Qed.
Lemma return_state_defined:forall m sb,
 Genv.find_symbol ge S._state=Some sb->
 normal_state(State S.f_stateGetSpeedEcef_f getter_return Kstop empty_env m)=true /\call_names(State S.f_stateGetSpeedEcef_f getter_return Kstop empty_env m) /\state_eval ge(State S.f_stateGetSpeedEcef_f getter_return Kstop empty_env m)=Some(Vptr sb(Ptrofs.repr 328),m).
Proof.
 intros m sb SYM;split;[reflexivity|];split;[exact I|].
 eapply GC.return_evaluates;[apply returned_pointer_value;exact SYM|reflexivity|reflexivity].
Qed.
Theorem original_certificate:forall m m1 m2 m3 mf sb x y z,
 Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 Mem.load Mint32 m sb 296=Some(Vint x)->Mem.load Mint32 m sb 300=Some(Vint y)->Mem.load Mint32 m sb 304=Some(Vint z)->
 Mem.store Mfloat32 m sb 328(Vsingle(decode x))=Some m1->Mem.store Mfloat32 m1 sb 332(Vsingle(decode y))=Some m2->
 Mem.store Mfloat32 m2 sb 336(Vsingle(decode z))=Some m3->Mem.store Mint16unsigned m3 sb 280(Vint(Int.repr 33))=Some mf->
 exists P,certificate ge P(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf) /\P(E.entry[]m).
Proof.
 intros m m1 m2 m3 mf sb x y z SYM STATUS X Y ZS STX STY STZ STS.
 destruct GS.calc_lookup as[bf[FS FF]].
 change(Genv.find_symbol ge S._stateCalcSpeedEcef_f=Some bf)in FS.
 change(Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal S.f_stateCalcSpeedEcef_f))in FF.
 set(k:=Kseq getter_return Kstop).
 set(base:=Kcall S.f_stateGetSpeedEcef_f empty_env(fun q=>q)tvoid(Kdo k)).
 destruct(original_calculation_certificate m m1 m2 m3 mf sb x y z base I SYM STATUS X Y ZS STX STY STZ STS)as[CP[CC CI]].
 set(CALLINV:=ZeroCallShell.invariant empty_env S.f_stateGetSpeedEcef_f k S._stateCalcSpeedEcef_f bf m Vundef mf CP).
 assert(CALLCERT:certificate ge CALLINV(State S.f_stateGetSpeedEcef_f Sskip k empty_env mf)).
 { apply ZeroCallShell.call_certificate with(callee:=Internal S.f_stateCalcSpeedEcef_f);[reflexivity|exact FS|exact FF|reflexivity|exact CC|exact CI]. }
 assert(CALLI:CALLINV(State S.f_stateGetSpeedEcef_f getter_call k empty_env m)).
 { left;rewrite getter_call_shape;reflexivity. }
 set(TAILINV:=fun s=>normal_state s=true /\call_names s /\state_eval ge s=Some(Vptr sb(Ptrofs.repr 328),mf)).
 pose proof(SC.evaluator_certificate ge(Vptr sb(Ptrofs.repr 328))mf)as TAILCERT.
 assert(TAILI:TAILINV(State S.f_stateGetSpeedEcef_f getter_return Kstop empty_env mf)).
 { exact(return_state_defined mf sb SYM). }
 pose proof(chain_certificate ge CALLINV TAILINV _ _ _ CALLCERT TAILCERT(SC.skip_seq_unique ge S.f_stateGetSpeedEcef_f getter_return Kstop empty_env mf)TAILI)as CTC.
 set(IFINV:=PureIfShell.invariant ge S.f_stateGetSpeedEcef_f empty_env k m getter_condition getter_call Sskip(Vint Int.one)true).
 assert(IFCERT:certificate ge IFINV(State S.f_stateGetSpeedEcef_f getter_call k empty_env m)).
 { apply PureIfShell.if_certificate;[reflexivity|apply getter_condition_value with(sb:=sb);[reflexivity|exact SYM|exact STATUS]|reflexivity]. }
 pose proof(GC.join_certificate ge IFINV(fun s=>CALLINV s \/TAILINV s)_ _ IFCERT CTC(or_introl CALLI))as ICC.
 assert(IFI:IFINV(State S.f_stateGetSpeedEcef_f getter_first k empty_env m))by(left;reflexivity).
 set(BODYINV:=fun s=>s=State S.f_stateGetSpeedEcef_f(fn_body S.f_stateGetSpeedEcef_f)Kstop empty_env m \/IFINV s \/CALLINV s \/TAILINV s).
 assert(BC:certificate ge BODYINV(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf)).
 { unfold BODYINV;eapply SC.prepend_certificate;[exact ICC|left;exact IFI|].
   change(unique_transition ge(State S.f_stateGetSpeedEcef_f(Ssequence getter_first getter_return)Kstop empty_env m)(State S.f_stateGetSpeedEcef_f getter_first(Kseq getter_return Kstop)empty_env m));apply SC.sequence_unique. }
 exists(fun s=>s=E.entry[]m \/BODYINV s);split.
 - eapply SC.prepend_certificate;[exact BC|left;reflexivity|apply GC.empty_function_unique;reflexivity].
 - left;reflexivity.
Qed.
Print Assumptions original_certificate.
Lemma source_path_silent:forall args m t reached,
 star Csem.step ge(E.entry args m)t reached->t=E0.
Proof.
 intros args m t reached PATH;pose proof(GS.entry_source args m)as INIT.
 revert INIT;induction PATH;intros INV;[reflexivity|].
 destruct(GS.source_step_invariant _ _ _ INV H)as[TT NEXT];rewrite TT,(IHPATH NEXT);reflexivity.
Qed.
Lemma four_stores_result:forall m m1 m2 m3 mf sb x y z,
 Mem.store Mfloat32 m sb 328(Vsingle(decode x))=Some m1->Mem.store Mfloat32 m1 sb 332(Vsingle(decode y))=Some m2->
 Mem.store Mfloat32 m2 sb 336(Vsingle(decode z))=Some m3->Mem.store Mint16unsigned m3 sb 280(Vint(Int.repr 33))=Some mf->
 GetterResult m mf sb x y z.
Proof.
 intros m m1 m2 m3 mf sb x y z X Y ZS ST.
 assert(WORDS:Mem.load Mfloat32 mf sb 328=Some(Vsingle(decode x)) /\Mem.load Mfloat32 mf sb 332=Some(Vsingle(decode y)) /\Mem.load Mfloat32 mf sb 336=Some(Vsingle(decode z)) /\Mem.load Mint16unsigned mf sb 280=Some(Val.load_result Mint16unsigned(Vint(Int.repr 33)))).
 { eapply SE.four_store_words;eauto;lia. }
 destruct WORDS as[RX[RY[RZ RS]]];constructor;try assumption.
 - change(Mem.loadbytes mf sb 328 12=Some(SE.vector_bytes(decode x)(decode y)(decode z)));eapply SE.four_store_bytes;eauto;lia.
 - intros;eapply SE.four_store_permissions;eauto.
 - intros b ofs n N MISS;eapply SE.four_store_frame;eauto;lia.
Qed.
Theorem original_normal_result:forall m sb x y z,
 InputGood m sb x y z->exists mf,NormalCall m mf sb /\GetterResult m mf sb x y z / (forall t v mf2,star Csem.step ge(E.entry[]m)t(Returnstate v Kstop mf2)->v=Vptr sb(Ptrofs.repr 328) /\mf2=mf).
Proof.
 intros m sb x y z[SYM[WR[STATUS[X[Y ZS]]]]].
 destruct(SE.four_stores_exist 328(Int.repr 33)m sb(decode x)(decode y)(decode z)ltac:(lia)ltac:(lia)ltac:(exists 82;reflexivity)WR)as[mf[m1[m2[m3[STX[STY[STZ STS]]]]]]].
 destruct(original_certificate m m1 m2 m3 mf sb x y z SYM STATUS X Y ZS STX STY STZ STS)as[P[CERT PI]].
 destruct(SC.certificate_has_return ge P _ _ CERT PI(GS.all_successor_termination[]m))as[t PATH].
 pose proof(source_path_silent[]m t _ PATH)as TT;subst t.
 exists mf;split;[exact PATH|];split;[eapply four_stores_result;eauto|].
 intros t v mf2 PATH2;eapply certificate_normal_unique;eauto.
Qed.
Theorem original_no_error:forall m sb x y z,
 InputGood m sb x y z->no_error ge(E.entry[]m).
Proof.
 intros m sb x y z[SYM[WR[STATUS[X[Y ZS]]]]].
 destruct(SE.four_stores_exist 328(Int.repr 33)m sb(decode x)(decode y)(decode z)ltac:(lia)ltac:(lia)ltac:(exists 82;reflexivity)WR)as[mf[m1[m2[m3[STX[STY[STZ STS]]]]]]].
 destruct(original_certificate m m1 m2 m3 mf sb x y z SYM STATUS X Y ZS STX STY STZ STS)as[P[CERT PI]].
 assert(STOP:nostep Csem.step ge(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 intros t reached PATH[NR NS].
 destruct(certificate_no_error ge P _ _ CERT PI STOP t reached PATH)as[EQ|[tr[next STEP]]].
 - subst reached;apply NR;exists(Vptr sb(Ptrofs.repr 328)),mf;reflexivity.
 - exact(NS tr next STEP).
Qed.
Print Assumptions original_normal_result.
Print Assumptions original_no_error.
