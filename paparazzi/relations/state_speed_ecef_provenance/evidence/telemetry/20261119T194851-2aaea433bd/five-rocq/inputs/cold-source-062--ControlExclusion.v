From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation CallfreeExecution ContinuationLift PhaseComposition PureIfShell FactorShell.
From StateSpeedSetterSupport Require Import MemoryFacts Certificates.
From StateSpeedGetterSupport Require Import Setup Layout Body Calculation Original StoreEffects ZeroCallShell Certificates OwnedExecution.
Require StateSpeedGetterSupport.GetterSource.
Import ListNotations.
Open Scope Z_scope.
Module SC:=StateSpeedSetterSupport.Certificates.
Module GC:=StateSpeedGetterSupport.Certificates.
Module GS:=StateSpeedGetterSupport.GetterSource.
Local Opaque ge E.ge.
Definition calc_control(m mf:mem)(base:cont):Csem.state->Prop:=
 let L:=owned_callee ge base S.f_stateCalcSpeedEcef_f Vundef mf in
 let BR:=PureIfShell.invariant ge S.f_stateCalcSpeedEcef_f empty_env(Kseq marker base)m(status_test 0)conversion_block calc_fallback(Vint Int.one)true in
 let R:=fun s=>s=State S.f_stateCalcSpeedEcef_f calc_rest base empty_env m \/BR s \/L s in
 let FI:=PureIfShell.invariant ge S.f_stateCalcSpeedEcef_f empty_env(Kseq calc_rest base)m(status_test 5)(Sreturn None)Sskip(Vint Int.zero)false in
 let BODYINV:=fun s=>s=State S.f_stateCalcSpeedEcef_f(fn_body S.f_stateCalcSpeedEcef_f)base empty_env m \/FI s \/R s in
 fun s=>s=Callstate(Internal S.f_stateCalcSpeedEcef_f)[]base m \/BODYINV s.
Theorem controlled_calculation_certificate:forall m m1 m2 m3 mf sb x y z base,
 is_call_cont base->Genv.find_symbol ge S._state=Some sb->
 Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 Mem.load Mint32 m sb 296=Some(Vint x)->Mem.load Mint32 m sb 300=Some(Vint y)->Mem.load Mint32 m sb 304=Some(Vint z)->
 Mem.store Mfloat32 m sb 328(Vsingle(decode x))=Some m1->Mem.store Mfloat32 m1 sb 332(Vsingle(decode y))=Some m2->
 Mem.store Mfloat32 m2 sb 336(Vsingle(decode z))=Some m3->Mem.store Mint16unsigned m3 sb 280(Vint(Int.repr 33))=Some mf->
 certificate ge(calc_control m mf base)(Returnstate Vundef base mf) /\calc_control m mf base(Callstate(Internal S.f_stateCalcSpeedEcef_f)[]base m).
Proof.
 intros m m1 m2 m3 mf sb x y z base BASE SYM STATUS X Y ZS STX STY STZ STS.
 pose proof(body_evaluates empty_env m m1 m2 m3 mf sb x y z eq_refl SYM STATUS X Y ZS STX STY STZ STS)as BODY.
 pose proof(selected_state_eval m mf BODY)as EVAL.
 set(L:=owned_callee ge base S.f_stateCalcSpeedEcef_f Vundef mf).
 assert(LC:certificate ge L(Returnstate Vundef base mf)).
 { apply owned_callee_certificate;exact BASE. }
 assert(LI:L(State S.f_stateCalcSpeedEcef_f conversion_block(Kseq marker base)empty_env m)).
 { exists(State S.f_stateCalcSpeedEcef_f conversion_block(Kseq marker Kstop)empty_env m);split;[reflexivity|].
   unfold owned_normal;split;[reflexivity|];split;[exact I|];split;[exact EVAL|reflexivity]. }
 destruct(status_one_tests empty_env m sb eq_refl SYM STATUS)as[TEST5 TEST0].
 set(BR:=PureIfShell.invariant ge S.f_stateCalcSpeedEcef_f empty_env(Kseq marker base)m(status_test 0)conversion_block calc_fallback(Vint Int.one)true).
 assert(BC:certificate ge BR(State S.f_stateCalcSpeedEcef_f conversion_block(Kseq marker base)empty_env m)).
 { apply PureIfShell.if_certificate;[reflexivity|exact TEST0|reflexivity]. }
 pose proof(GC.join_certificate ge BR L _ _ BC LC LI)as BLC.
 assert(BI:BR(State S.f_stateCalcSpeedEcef_f(Sifthenelse(status_test 0)conversion_block calc_fallback)(Kseq marker base)empty_env m))by(left;reflexivity).
 set(R:=fun s=>s=State S.f_stateCalcSpeedEcef_f calc_rest base empty_env m \/BR s \/L s).
 assert(RC:certificate ge R(Returnstate Vundef base mf)).
 { unfold R;eapply SC.prepend_certificate;[exact BLC|left;exact BI|].
   change(unique_transition ge(State S.f_stateCalcSpeedEcef_f(Ssequence(Sifthenelse(status_test 0)conversion_block calc_fallback)marker)base empty_env m)(State S.f_stateCalcSpeedEcef_f(Sifthenelse(status_test 0)conversion_block calc_fallback)(Kseq marker base)empty_env m)).
   apply SC.sequence_unique. }
 assert(RI:R(State S.f_stateCalcSpeedEcef_f calc_rest base empty_env m))by(left;reflexivity).
 set(FI:=PureIfShell.invariant ge S.f_stateCalcSpeedEcef_f empty_env(Kseq calc_rest base)m(status_test 5)(Sreturn None)Sskip(Vint Int.zero)false).
 assert(FC:certificate ge FI(State S.f_stateCalcSpeedEcef_f Sskip(Kseq calc_rest base)empty_env m)).
 { apply PureIfShell.if_certificate;[reflexivity|exact TEST5|reflexivity]. }
 pose proof(chain_certificate ge FI R _ _ _ FC RC(SC.skip_seq_unique ge S.f_stateCalcSpeedEcef_f calc_rest base empty_env m)RI)as FRC.
 assert(FINIT:FI(State S.f_stateCalcSpeedEcef_f calc_first(Kseq calc_rest base)empty_env m))by(left;reflexivity).
 set(BODYINV:=fun s=>s=State S.f_stateCalcSpeedEcef_f(fn_body S.f_stateCalcSpeedEcef_f)base empty_env m \/FI s \/R s).
 assert(BODYCERT:certificate ge BODYINV(Returnstate Vundef base mf)).
 { unfold BODYINV;eapply SC.prepend_certificate;[exact FRC|left;exact FINIT|].
   change(unique_transition ge(State S.f_stateCalcSpeedEcef_f(Ssequence calc_first calc_rest)base empty_env m)(State S.f_stateCalcSpeedEcef_f calc_first(Kseq calc_rest base)empty_env m));apply SC.sequence_unique. }
 change(certificate ge(fun s=>s=Callstate(Internal S.f_stateCalcSpeedEcef_f)[]base m \/BODYINV s)(Returnstate Vundef base mf) /\ (fun s=>s=Callstate(Internal S.f_stateCalcSpeedEcef_f)[]base m \/BODYINV s)(Callstate(Internal S.f_stateCalcSpeedEcef_f)[]base m));split.
 - eapply SC.prepend_certificate;[exact BODYCERT|left;reflexivity|apply GC.empty_function_unique;reflexivity].
 - left;reflexivity.
Qed.
Print Assumptions controlled_calculation_certificate.

Definition getter_control(m mf:mem)(sb bf:block):Csem.state->Prop:=
 let k:=Kseq getter_return Kstop in
 let base:=Kcall S.f_stateGetSpeedEcef_f empty_env(fun q=>q)tvoid(Kdo k)in
 let CP:=calc_control m mf base in
 let CALLINV:=ZeroCallShell.invariant empty_env S.f_stateGetSpeedEcef_f k S._stateCalcSpeedEcef_f bf m Vundef mf CP in
 let TAILINV:=owned_normal ge S.f_stateGetSpeedEcef_f(Vptr sb(Ptrofs.repr 328))mf in
 let IFINV:=PureIfShell.invariant ge S.f_stateGetSpeedEcef_f empty_env k m getter_condition getter_call Sskip(Vint Int.one)true in
 let BODYINV:=fun s=>s=State S.f_stateGetSpeedEcef_f(fn_body S.f_stateGetSpeedEcef_f)Kstop empty_env m \/IFINV s \/CALLINV s \/TAILINV s in
 fun s=>s=E.entry[]m \/BODYINV s.
Theorem controlled_getter_certificate:forall m m1 m2 m3 mf sb x y z bf,
 Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 Mem.load Mint32 m sb 296=Some(Vint x)->Mem.load Mint32 m sb 300=Some(Vint y)->Mem.load Mint32 m sb 304=Some(Vint z)->
 Mem.store Mfloat32 m sb 328(Vsingle(decode x))=Some m1->Mem.store Mfloat32 m1 sb 332(Vsingle(decode y))=Some m2->
 Mem.store Mfloat32 m2 sb 336(Vsingle(decode z))=Some m3->Mem.store Mint16unsigned m3 sb 280(Vint(Int.repr 33))=Some mf->
 Genv.find_symbol ge S._stateCalcSpeedEcef_f=Some bf->Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal S.f_stateCalcSpeedEcef_f)->
 certificate ge(getter_control m mf sb bf)(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf) /\getter_control m mf sb bf(E.entry[]m).
Proof.
 intros m m1 m2 m3 mf sb x y z bf SYM STATUS X Y ZS STX STY STZ STS FS FF.
 set(k:=Kseq getter_return Kstop).
 set(base:=Kcall S.f_stateGetSpeedEcef_f empty_env(fun q=>q)tvoid(Kdo k)).
 set(CP:=calc_control m mf base).
 destruct(controlled_calculation_certificate m m1 m2 m3 mf sb x y z base I SYM STATUS X Y ZS STX STY STZ STS)as[CC CI].
 set(CALLINV:=ZeroCallShell.invariant empty_env S.f_stateGetSpeedEcef_f k S._stateCalcSpeedEcef_f bf m Vundef mf CP).
 assert(CALLCERT:certificate ge CALLINV(State S.f_stateGetSpeedEcef_f Sskip k empty_env mf)).
 { apply ZeroCallShell.call_certificate with(callee:=Internal S.f_stateCalcSpeedEcef_f);[reflexivity|exact FS|exact FF|reflexivity|exact CC|exact CI]. }
 assert(CALLI:CALLINV(State S.f_stateGetSpeedEcef_f getter_call k empty_env m)).
 { left;rewrite getter_call_shape;reflexivity. }
 set(TAILINV:=owned_normal ge S.f_stateGetSpeedEcef_f(Vptr sb(Ptrofs.repr 328))mf).
 pose proof(owned_normal_certificate ge S.f_stateGetSpeedEcef_f(Vptr sb(Ptrofs.repr 328))mf)as TAILCERT.
 assert(TAILI:TAILINV(State S.f_stateGetSpeedEcef_f getter_return Kstop empty_env mf)).
 { destruct(return_state_defined mf sb SYM)as[N[CN EV]];exact(conj N(conj CN(conj EV eq_refl))). }
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
 change(certificate ge(fun s=>s=E.entry[]m \/BODYINV s)(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf) /\(fun s=>s=E.entry[]m \/BODYINV s)(E.entry[]m));split.
 - eapply SC.prepend_certificate;[exact BC|left;reflexivity|apply GC.empty_function_unique;reflexivity].
 - left;reflexivity.
Qed.
Print Assumptions controlled_getter_certificate.
Definition zero_parameters(s:Csem.state):Prop:=
 match s with State f _ _ _ _|ExprState f _ _ _ _=>fn_params f=[]
 |Callstate(Internal f)_ _ _=>fn_params f=[]|Callstate(External _ _ _ _)_ _ _=>False|_=>True end.
Lemma owned_normal_zero_parameters:forall ge f v mf s,
 fn_params f=[]->owned_normal ge f v mf s->zero_parameters s.
Proof.
 intros ge0 f v mf s PARAMS[N[CN[EV OWN]]];destruct s;cbn[function_owner]in OWN;try contradiction;subst;exact PARAMS||exact I.
Qed.
Lemma owned_callee_zero_parameters:forall ge base f v mf s,
 fn_params f=[]->owned_callee ge base f v mf s->zero_parameters s.
Proof.
 intros ge0 base f v mf s PARAMS[raw[EQ[N[CN[EV OWN]]]]];subst s.
 destruct raw;cbn[function_owner]in OWN;try contradiction;subst;cbn[plug_state zero_parameters];exact PARAMS||exact I.
Qed.
Lemma if_zero_parameters:forall ge f e k m condition yes no value taken s,
 fn_params f=[]->PureIfShell.invariant ge f e k m condition yes no value taken s->zero_parameters s.
Proof.
 intros ge0 f e k m condition yes no value taken s PARAMS[EQ|[[a[EQ REST]]|EQ]];subst s;try exact PARAMS.
 unfold PureIfShell.target;destruct taken;exact PARAMS.
Qed.
Lemma calc_control_zero_parameters:forall m mf base s,calc_control m mf base s->zero_parameters s.
Proof.
 intros m mf base s INV;unfold calc_control in INV.
 destruct INV as[ENTRY|[BODY|[FIRST|[REST|[BRANCH|LEAF]]]]].
 - subst s;reflexivity.
 - subst s;reflexivity.
 - eapply if_zero_parameters;[reflexivity|exact FIRST].
 - subst s;reflexivity.
 - eapply if_zero_parameters;[reflexivity|exact BRANCH].
 - eapply owned_callee_zero_parameters;[reflexivity|exact LEAF].
Qed.
Lemma getter_control_zero_parameters:forall m mf sb bf s,getter_control m mf sb bf s->zero_parameters s.
Proof.
 intros m mf sb bf s INV;unfold getter_control in INV.
 destruct INV as[ENTRY|[BODY|[IF|[CALL|TAIL]]]].
 - subst s;reflexivity.
 - subst s;reflexivity.
 - eapply if_zero_parameters;[reflexivity|exact IF].
 - unfold ZeroCallShell.invariant in CALL;destruct CALL as[START|[[rs PRE]|[CALC|[POST|DONE]]]].
   + subst s;reflexivity.
   + subst s;reflexivity.
   + eapply calc_control_zero_parameters;exact CALC.
   + subst s;reflexivity.
   + subst s;reflexivity.
 - eapply owned_normal_zero_parameters;[reflexivity|exact TAIL].
Qed.
Theorem getter_control_reachable:forall m sb x y z,InputGood m sb x y z->
 exists mf bf,forall t reached,star Csem.step ge(E.entry[]m)t reached->getter_control m mf sb bf reached.
Proof.
 intros m sb x y z[SYM[WR[STATUS[X[Y ZS]]]]].
 destruct(StoreEffects.four_stores_exist 328(Int.repr 33)m sb(decode x)(decode y)(decode z)ltac:(lia)ltac:(lia)ltac:(exists 82;reflexivity)WR)as[mf[m1[m2[m3[STX[STY[STZ STS]]]]]]].
 destruct GS.calc_lookup as[bf[FS FF]].
 change(Genv.find_symbol ge S._stateCalcSpeedEcef_f=Some bf)in FS.
 change(Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal S.f_stateCalcSpeedEcef_f))in FF.
 destruct(controlled_getter_certificate m m1 m2 m3 mf sb x y z bf SYM STATUS X Y ZS STX STY STZ STS FS FF)as[CERT PI].
 assert(STOP:nostep Csem.step ge(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf)).
 { intros tr next[ES|SS];inversion ES||inversion SS. }
 exists mf,bf;intros t reached PATH;eapply certificate_reachable;[exact CERT|exact PI|exact STOP|exact PATH].
Qed.
Theorem all_reachable_zero_parameter_functions:forall m sb x y z,
 InputGood m sb x y z->forall t reached,star Csem.step ge(E.entry[]m)t reached->zero_parameters reached.
Proof.
 intros m sb x y z GOOD t reached PATH.
 destruct(getter_control_reachable m sb x y z GOOD)as[mf[bf CONTROL]].
 eapply getter_control_zero_parameters;exact(CONTROL t reached PATH).
Qed.
Print Assumptions getter_control_reachable.
Print Assumptions all_reachable_zero_parameter_functions.
