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
