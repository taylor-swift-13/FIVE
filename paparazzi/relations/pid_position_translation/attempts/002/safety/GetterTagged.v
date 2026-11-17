From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution PhaseComposition.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import GetterSemantics MemoryLayout.
From PidPositionSafety Require Import PureSound TaggedGuarded TaggedCallee.
Import ListNotations.
Open Scope Z_scope.
Module G:=GetterSemantics.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.
Lemma getter_tail_normal:forall f m field b delta,
 fn_return f=G.ned_ptr ->
 eval_simple_rvalue E.ge empty_env m(G.getter_address field)(Vptr b(Ptrofs.repr delta)) ->
 star Csem.step E.ge(State f(Sreturn(Some(G.getter_address field)))Kstop empty_env m)E0
 (Returnstate(Vptr b(Ptrofs.repr delta))Kstop m).
Proof.
 intros f m field b delta RT EV.
 eapply star_step with(t1:=E0)(t2:=E0).
 - right;apply Csem.step_return_1.
 - eapply star_trans with(t1:=E0)(t2:=E0).
   + eapply Cstrategy.eval_simple_rvalue_steps with(C:=fun x=>x);[exact EV|constructor].
   + apply star_one;right;eapply Csem.step_return_2.
     * rewrite RT;reflexivity.
     * reflexivity.
   + reflexivity.
 - reflexivity.
Qed.
Theorem cached_getter_tagged_certificate:forall f m b co field flags statusofs nedfield delta,
 fn_params f=[] ->fn_vars f=[] ->fn_return f=G.ned_ptr ->
 fn_body f=Ssequence
 (Sifthenelse(G.cache_expr field)
 (Sdo(Ecall(Evalof(Evar
 (if Pos.eqb field S._pos_status then S._stateCalcPositionNed_i else S._stateCalcSpeedNed_i)
 (Tfunction []tvoid cc_default))(Tfunction []tvoid cc_default))Enil tvoid))Sskip)
 (Sreturn(Some(G.getter_address nedfield))) ->
 Genv.find_symbol E.ge S._state=Some b ->
 PTree.get S._State(genv_cenv E.ge)=Some co ->
 field_offset E.ge field(co_members co)=OK(statusofs,Full) ->
 field_offset E.ge nedfield(co_members co)=OK(delta,Full) ->
 Mem.loadv Mint16unsigned m(Vptr b(Ptrofs.repr statusofs))=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 forall base,is_call_cont base ->
 exists P,certificate E.ge P(Returnstate(Vptr b(Ptrofs.repr delta))base m) /\
 P(Callstate(Internal f)[]base m)/\(forall s,P s->function_scope f s).
Proof.
 intros f m b co field flags statusofs nedfield delta PA VA RT BODY SYM CO OFF NED LOAD VALID.
 assert(CE:eval_simple_rvalue E.ge empty_env m(G.cache_expr field)(Vint Int.zero)).
 { eapply G.cache_expression_false;eauto. }
 assert(RE:eval_simple_rvalue E.ge empty_env m(G.getter_address nedfield)(Vptr b(Ptrofs.repr delta))).
 { eapply G.getter_return_expression;eauto. }
 assert(SI:simple(G.cache_expr field)=true)by reflexivity.
 assert(PV:pure_rval E.ge empty_env m(G.cache_expr field)=Some(Vint Int.zero)).
 { exact(proj1(simple_big_denotation E.ge empty_env m)(G.cache_expr field)(Vint Int.zero)CE SI). }
 assert(NT:normal_stmt(Sreturn(Some(G.getter_address nedfield)))=true)by reflexivity.
 assert(TAIL:star Csem.step E.ge
 (State f(Sreturn(Some(G.getter_address nedfield)))Kstop empty_env m)E0
 (Returnstate(Vptr b(Ptrofs.repr delta))Kstop m)).
 { apply getter_tail_normal;[exact RT|exact RE]. }
 exact(tagged_guarded_callee_certificate E.ge f m(G.cache_expr field)
 (Sdo(Ecall(Evalof(Evar
 (if Pos.eqb field S._pos_status then S._stateCalcPositionNed_i else S._stateCalcSpeedNed_i)
 (Tfunction []tvoid cc_default))(Tfunction []tvoid cc_default))Enil tvoid))
 (Sreturn(Some(G.getter_address nedfield)))(Vint Int.zero)(Vptr b(Ptrofs.repr delta))
 PA VA BODY SI PV eq_refl NT TAIL).
Qed.
Theorem original_position_getter_tagged_certificate:forall m b co flags delta,
 Genv.find_symbol E.ge S._state=Some b ->
 PTree.get S._State(genv_cenv E.ge)=Some co ->
 field_offset E.ge S._pos_status(co_members co)=OK(2,Full) ->
 field_offset E.ge S._ned_pos_i(co_members co)=OK(delta,Full) ->
 Mem.loadv Mint16unsigned m(Vptr b(Ptrofs.repr 2))=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 forall base,is_call_cont base ->
 exists P,certificate E.ge P(Returnstate(Vptr b(Ptrofs.repr delta))base m) /\
 P(Callstate(Internal S.f_stateGetPositionNed_i)[]base m)/\
 (forall s,P s->function_scope S.f_stateGetPositionNed_i s).
Proof.
 intros;eapply cached_getter_tagged_certificate with(field:=S._pos_status)(statusofs:=2)
 (nedfield:=S._ned_pos_i);eauto;reflexivity.
Qed.
Theorem original_speed_getter_tagged_certificate:forall m b co flags statusofs delta,
 Genv.find_symbol E.ge S._state=Some b ->
 PTree.get S._State(genv_cenv E.ge)=Some co ->
 field_offset E.ge S._speed_status(co_members co)=OK(statusofs,Full) ->
 field_offset E.ge S._ned_speed_i(co_members co)=OK(delta,Full) ->
 Mem.loadv Mint16unsigned m(Vptr b(Ptrofs.repr statusofs))=Some(Vint flags) ->
 Int.and flags(Int.repr 2)=Int.repr 2 ->
 forall base,is_call_cont base ->
 exists P,certificate E.ge P(Returnstate(Vptr b(Ptrofs.repr delta))base m) /\
 P(Callstate(Internal S.f_stateGetSpeedNed_i)[]base m)/\
 (forall s,P s->function_scope S.f_stateGetSpeedNed_i s).
Proof.
 intros;eapply cached_getter_tagged_certificate with(field:=S._speed_status)(statusofs:=statusofs)
 (nedfield:=S._ned_speed_i);eauto;reflexivity.
Qed.
Print Assumptions original_position_getter_tagged_certificate.
Print Assumptions original_speed_getter_tagged_certificate.
