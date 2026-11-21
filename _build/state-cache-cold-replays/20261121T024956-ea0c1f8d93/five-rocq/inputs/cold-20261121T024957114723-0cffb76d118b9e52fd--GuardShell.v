From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress CallfreeExecution PhaseComposition.
Import ListNotations.

Lemma gs_seqor_context : forall from C sub a b ty,
 context from RV C ->C sub=Eseqor a b ty ->
 (from=RV /\sub=Eseqor a b ty /\forall x,C x=x) \/
 exists D,context from RV D /\D sub=a /\forall x,C x=Eseqor(D x)b ty.
Proof.
 intros from C sub a b ty CT EQ;inversion CT;subst;cbn in EQ;try discriminate EQ.
 - left;split;[reflexivity|];split;[exact EQ|intros;reflexivity].
 - inversion EQ;subst;right;eexists;split;[eassumption|];split;[reflexivity|intros;reflexivity].
Qed.
Lemma gs_unop_context : forall from C sub op a ty,
 context from RV C ->C sub=Eunop op a ty ->
 (from=RV /\sub=Eunop op a ty /\forall x,C x=x) \/
 exists D,context from RV D /\D sub=a /\forall x,C x=Eunop op(D x)ty.
Proof.
 intros from C sub op a ty CT EQ;inversion CT;subst;cbn in EQ;try discriminate EQ.
 - left;split;[reflexivity|];split;[exact EQ|intros;reflexivity].
 - inversion EQ;subst;right;eexists;split;[eassumption|];split;[reflexivity|intros;reflexivity].
Qed.
Lemma gs_paren_context : forall from C sub a cast ty,
 context from RV C ->C sub=Eparen a cast ty ->
 (from=RV /\sub=Eparen a cast ty /\forall x,C x=x) \/
 exists D,context from RV D /\D sub=a /\forall x,C x=Eparen(D x)cast ty.
Proof.
 intros from C sub a cast ty CT EQ;inversion CT;subst;cbn in EQ;try discriminate EQ.
 - left;split;[reflexivity|];split;[exact EQ|intros;reflexivity].
 - inversion EQ;subst;right;eexists;split;[eassumption|];split;[reflexivity|intros;reflexivity].
Qed.
Lemma gs_literal_context : forall from C sub v ty,
 context from RV C ->C sub=Eval v ty ->
 from=RV /\sub=Eval v ty /\forall x,C x=x.
Proof.
 intros from C sub v ty CT EQ;inversion CT;subst;cbn in EQ;try discriminate EQ.
 split;[reflexivity|];split;[exact EQ|intros;reflexivity].
Qed.

Lemma gs_seqor_not_stuck : forall ge e m a b ty,
 not_stuck ge e a m ->imm_safe ge e RV(Eseqor a b ty)m ->
 not_stuck ge e(Eseqor a b ty)m.
Proof.
 intros ge e m a b ty NS IMM from C sub CT EQ.
 destruct(gs_seqor_context from C sub a b ty CT(eq_sym EQ))as[(K&SUB&ID)|(D&CD&SUB&EXT)].
 - subst from sub;exact IMM.
 - eapply NS;[exact CD|symmetry;exact SUB].
Qed.
Lemma gs_unop_not_stuck : forall ge e m op a ty,
 not_stuck ge e a m ->imm_safe ge e RV(Eunop op a ty)m ->
 not_stuck ge e(Eunop op a ty)m.
Proof.
 intros ge e m op a ty NS IMM from C sub CT EQ.
 destruct(gs_unop_context from C sub op a ty CT(eq_sym EQ))as[(K&SUB&ID)|(D&CD&SUB&EXT)].
 - subst from sub;exact IMM.
 - eapply NS;[exact CD|symmetry;exact SUB].
Qed.
Lemma gs_paren_not_stuck : forall ge e m a cast ty,
 not_stuck ge e a m ->imm_safe ge e RV(Eparen a cast ty)m ->
 not_stuck ge e(Eparen a cast ty)m.
Proof.
 intros ge e m a cast ty NS IMM from C sub CT EQ.
 destruct(gs_paren_context from C sub a cast ty CT(eq_sym EQ))as[(K&SUB&ID)|(D&CD&SUB&EXT)].
 - subst from sub;exact IMM.
 - eapply NS;[exact CD|symmetry;exact SUB].
Qed.
Lemma gs_pure_immediate : forall ge e m a v,
 simple a=true ->pure_rval ge e m a=Some v ->imm_safe ge e RV a m.
Proof. intros;apply simple_immediate;[assumption|rewrite H0;discriminate]. Qed.
Lemma gs_seqor_immediate : forall ge e m a b ty v flag,
 simple a=true ->pure_rval ge e m a=Some v ->
 bool_val v(typeof a)m=Some flag ->imm_safe ge e RV(Eseqor a b ty)m.
Proof.
 intros ge e m a b ty v flag S EV BV.
 destruct(literal RV a)eqn:LIT.
 - destruct(literal_r_inv _ LIT)as[w[t EQ]];subst a.
   cbn[pure_rval]in EV;injection EV as EQ;subst w.
   destruct flag.
   + eapply imm_safe_rred with(C:=fun x=>x);[eapply red_seqor_true;exact BV|constructor].
   + eapply imm_safe_rred with(C:=fun x=>x);[eapply red_seqor_false;exact BV|constructor].
 - eapply lift_immediate with(from:=RV)(C:=fun x=>Eseqor x b ty).
   + constructor;constructor.
   + exact LIT.
   + eapply gs_pure_immediate;eauto.
Qed.
Lemma gs_unop_wrap : forall ge e m op a ty,
 literal RV a=false ->not_stuck ge e a m ->imm_safe ge e RV a m ->
 imm_safe ge e RV(Eunop op a ty)m /\not_stuck ge e(Eunop op a ty)m.
Proof.
 intros ge e m op a ty NL NS IM.
 assert(WRAP:imm_safe ge e RV(Eunop op a ty)m).
 { eapply lift_immediate with(from:=RV)(C:=fun x=>Eunop op x ty);[constructor;constructor|exact NL|exact IM]. }
 split;[exact WRAP|apply gs_unop_not_stuck;assumption].
Qed.
Lemma gs_paren_wrap : forall ge e m a cast ty,
 literal RV a=false ->not_stuck ge e a m ->imm_safe ge e RV a m ->
 imm_safe ge e RV(Eparen a cast ty)m /\not_stuck ge e(Eparen a cast ty)m.
Proof.
 intros ge e m a cast ty NL NS IM.
 assert(WRAP:imm_safe ge e RV(Eparen a cast ty)m).
 { eapply lift_immediate with(from:=RV)(C:=fun x=>Eparen x cast ty);[constructor;constructor|exact NL|exact IM]. }
 split;[exact WRAP|apply gs_paren_not_stuck;assumption].
Qed.

Lemma gs_lred_plug : forall ge e m C a a' mf v,
 context LV RV C ->simple(C a)=true ->pure_rval ge e m(C a)=Some v ->
 lred ge e a m a' mf ->
 mf=m /\simple(C a')=true /\typeof(C a')=typeof(C a) /\pure_rval ge e m(C a')=Some v.
Proof.
 intros ge e m C a a' mf v CT S EV RED.
 destruct(pure_lred ge e a m a' mf RED)as[MM[TY[SA EQ]]];subst mf.
 split;[reflexivity|];split.
 - exact(simple_context_replace _ _ _ CT a a'(eq_sym TY)S SA).
 - split;[exact(context_type_eq _ _ _ CT a' a TY)|].
   pose proof(pure_context_congr ge e m _ _ _ CT a a'(eq_sym TY)EQ)as DEN.
   change(pure_rval ge e m(C a)=pure_rval ge e m(C a'))in DEN.
   rewrite<-DEN;exact EV.
Qed.
Lemma gs_rred_plug : forall ge e m C a a' mf t v,
 context RV RV C ->simple(C a)=true ->pure_rval ge e m(C a)=Some v ->
 rred ge a m t a' mf ->
 mf=m /\simple(C a')=true /\typeof(C a')=typeof(C a) /\pure_rval ge e m(C a')=Some v.
Proof.
 intros ge e m C a a' mf t v CT S EV RED.
 assert(SA:simple a=true)by(exact(simple_context_hole _ _ _ CT a S)).
 destruct(pure_rred ge e a m t a' mf SA RED)as[MM[TRACE[TY[SN EQ]]]];subst mf.
 split;[reflexivity|];split.
 - exact(simple_context_replace _ _ _ CT a a'(eq_sym TY)S SN).
 - split;[exact(context_type_eq _ _ _ CT a' a TY)|].
   pose proof(pure_context_congr ge e m _ _ _ CT a a'(eq_sym TY)EQ)as DEN.
   change(pure_rval ge e m(C a)=pure_rval ge e m(C a'))in DEN.
   rewrite<-DEN;exact EV.
Qed.
Lemma gs_simple_no_call : forall ge C sub m fd args ty,
 context RV RV C ->simple(C sub)=true ->callred ge sub m fd args ty ->False.
Proof.
 intros ge C sub m fd args ty CT S RED.
 pose proof(simple_context_hole _ _ _ CT sub S)as SS.
 inversion RED;subst;discriminate SS.
Qed.

Definition guard_expr(a b c:expr):expr:=
 Eseqor a(Eunop Onotbool(Eseqor b c tint)tint)tint.
Inductive guard_phase(ge:genv)(e:env)(m:mem)(b c:expr):expr->Prop:=
 | guard_phase_a:forall a,simple a=true ->typeof a=tint ->
     pure_rval ge e m a=Some(Vint Int.zero) ->guard_phase ge e m b c(guard_expr a b c)
 | guard_phase_b:forall a,simple a=true ->typeof a=tint ->
     pure_rval ge e m a=Some(Vint Int.one) ->
     guard_phase ge e m b c(Eparen(Eunop Onotbool(Eseqor a c tint)tint)type_bool tint)
 | guard_phase_c:guard_phase ge e m b c(Eparen(Eunop Onotbool(Eval(Vint Int.one)tint)tint)type_bool tint)
 | guard_phase_d:guard_phase ge e m b c(Eparen(Eval(Vint Int.zero)tint)type_bool tint)
 | guard_phase_e:guard_phase ge e m b c(Eval(Vint Int.zero)tint).

Lemma guard_phase_not_stuck : forall ge e m b c r,
 guard_phase ge e m b c r ->not_stuck ge e r m.
Proof.
 intros ge e m b c r PH;destruct PH as[a SA TA VA|a SA TA VA| | |].
 - unfold guard_expr;apply gs_seqor_not_stuck.
   + eapply pure_not_stuck;[exact SA|exact VA].
   + eapply gs_seqor_immediate with(v:=Vint Int.zero)(flag:=false);[exact SA|exact VA|rewrite TA;reflexivity].
 - assert(IM:imm_safe ge e RV(Eseqor a c tint)m).
   { eapply gs_seqor_immediate with(v:=Vint Int.one)(flag:=true);[exact SA|exact VA|rewrite TA;reflexivity]. }
   assert(NS:not_stuck ge e(Eseqor a c tint)m).
   { apply gs_seqor_not_stuck;[eapply pure_not_stuck;[exact SA|exact VA]|exact IM]. }
   destruct(gs_unop_wrap ge e m Onotbool(Eseqor a c tint)tint eq_refl NS IM)as[UI UN].
   exact(proj2(gs_paren_wrap ge e m(Eunop Onotbool(Eseqor a c tint)tint)type_bool tint eq_refl UN UI)).
 - assert(SU:simple(Eunop Onotbool(Eval(Vint Int.one)tint)tint)=true)by reflexivity.
   assert(VU:pure_rval ge e m(Eunop Onotbool(Eval(Vint Int.one)tint)tint)=Some(Vint Int.zero))by reflexivity.
   exact(proj2(gs_paren_wrap ge e m(Eunop Onotbool(Eval(Vint Int.one)tint)tint)type_bool tint eq_refl
     (pure_not_stuck ge e m _ _ SU VU)(gs_pure_immediate ge e m _ _ SU VU))).
 - apply gs_paren_not_stuck.
   + eapply pure_not_stuck;[reflexivity|reflexivity].
   + eapply imm_safe_rred with(C:=fun x=>x);[eapply red_paren;reflexivity|constructor].
 - eapply pure_not_stuck;[reflexivity|reflexivity].
Qed.


Lemma guard_phase_lred : forall ge e m b c r C sub sub' mf,
 guard_phase ge e m b c r ->context LV RV C ->C sub=r ->
 lred ge e sub m sub' mf ->mf=m /\guard_phase ge e m b c(C sub').
Proof.
 intros ge e m b c r C sub sub' mf PH CT EQ RED.
 destruct PH as[a SA TA VA|a SA TA VA| | |].
 - unfold guard_expr in EQ.
   destruct(gs_seqor_context LV C sub a(Eunop Onotbool(Eseqor b c tint)tint)tint CT EQ)
     as[(BAD&SUB&ID)|(D&CD&SUB&EXT)];[discriminate BAD|].
   assert(S:simple(D sub)=true)by(rewrite SUB;exact SA).
   assert(V:pure_rval ge e m(D sub)=Some(Vint Int.zero))by(rewrite SUB;exact VA).
   destruct(gs_lred_plug ge e m D sub sub' mf(Vint Int.zero)CD S V RED)as[MM[SS[TT VV]]].
   split;[exact MM|];rewrite EXT;apply guard_phase_a;[exact SS|rewrite TT,SUB;exact TA|exact VV].
 - destruct(gs_paren_context LV C sub(Eunop Onotbool(Eseqor a c tint)tint)type_bool tint CT EQ)
     as[(BAD&SUB&ID)|(DP&CP&SP&XP)];[discriminate BAD|].
   destruct(gs_unop_context LV DP sub Onotbool(Eseqor a c tint)tint CP SP)
     as[(BAD&SUB&ID)|(DU&CU&SU&XU)];[discriminate BAD|].
   destruct(gs_seqor_context LV DU sub a c tint CU SU)
     as[(BAD&SUB&ID)|(D&CD&SUB&EXT)];[discriminate BAD|].
   assert(S:simple(D sub)=true)by(rewrite SUB;exact SA).
   assert(V:pure_rval ge e m(D sub)=Some(Vint Int.one))by(rewrite SUB;exact VA).
   destruct(gs_lred_plug ge e m D sub sub' mf(Vint Int.one)CD S V RED)as[MM[SS[TT VV]]].
   split;[exact MM|];rewrite XP,XU,EXT;apply guard_phase_b;[exact SS|rewrite TT,SUB;exact TA|exact VV].
 - destruct(gs_paren_context LV C sub(Eunop Onotbool(Eval(Vint Int.one)tint)tint)type_bool tint CT EQ)
     as[(BAD&SUB&ID)|(DP&CP&SP&XP)];[discriminate BAD|].
   destruct(gs_unop_context LV DP sub Onotbool(Eval(Vint Int.one)tint)tint CP SP)
     as[(BAD&SUB&ID)|(DU&CU&SU&XU)];[discriminate BAD|].
   destruct(gs_literal_context LV DU sub(Vint Int.one)tint CU SU)as[BAD REST];discriminate BAD.
 - destruct(gs_paren_context LV C sub(Eval(Vint Int.zero)tint)type_bool tint CT EQ)
     as[(BAD&SUB&ID)|(D&CD&SUB&EXT)];[discriminate BAD|].
   destruct(gs_literal_context LV D sub(Vint Int.zero)tint CD SUB)as[BAD REST];discriminate BAD.
 - destruct(gs_literal_context LV C sub(Vint Int.zero)tint CT EQ)as[BAD REST];discriminate BAD.
Qed.

Lemma guard_phase_rred : forall ge e m b c r C sub sub' mf t,
 simple b=true ->typeof b=tint ->pure_rval ge e m b=Some(Vint Int.one) ->
 guard_phase ge e m b c r ->context RV RV C ->C sub=r ->
 rred ge sub m t sub' mf ->mf=m /\guard_phase ge e m b c(C sub').
Proof.
 intros ge e m b c r C sub sub' mf t SB TB VB PH CT EQ RED.
 destruct PH as[a SA TA VA|a SA TA VA| | |].
 - unfold guard_expr in EQ.
   destruct(gs_seqor_context RV C sub a(Eunop Onotbool(Eseqor b c tint)tint)tint CT EQ)
     as[(K&SUB&ID)|(D&CD&SUB&EXT)].
   + subst sub;inversion RED;subst;
       cbn[pure_rval typeof]in VA,TA;injection VA as VALUE;subst;
       try lazymatch goal with H:bool_val(Vint Int.zero)tint _=Some true |- _=>discriminate H end.
     split;[reflexivity|];rewrite ID;apply guard_phase_b;assumption.
   + assert(S:simple(D sub)=true)by(rewrite SUB;exact SA).
     assert(V:pure_rval ge e m(D sub)=Some(Vint Int.zero))by(rewrite SUB;exact VA).
     destruct(gs_rred_plug ge e m D sub sub' mf t(Vint Int.zero)CD S V RED)as[MM[SS[TT VV]]].
     split;[exact MM|];rewrite EXT;apply guard_phase_a;[exact SS|rewrite TT,SUB;exact TA|exact VV].
 - destruct(gs_paren_context RV C sub(Eunop Onotbool(Eseqor a c tint)tint)type_bool tint CT EQ)
     as[(K&SUB&ID)|(DP&CP&SP&XP)].
   + subst sub;inversion RED.
   + destruct(gs_unop_context RV DP sub Onotbool(Eseqor a c tint)tint CP SP)
       as[(K&SUB&ID)|(DU&CU&SU&XU)].
     * subst sub;inversion RED.
     * destruct(gs_seqor_context RV DU sub a c tint CU SU)
         as[(K&SUB&ID)|(D&CD&SUB&EXT)].
       -- subst sub;inversion RED;subst;
            cbn[pure_rval typeof]in VA,TA;injection VA as VALUE;subst;
            try lazymatch goal with H:bool_val(Vint Int.one)tint _=Some false |- _=>discriminate H end.
          split;[reflexivity|];rewrite XP,XU,ID;apply guard_phase_c.
       -- assert(S:simple(D sub)=true)by(rewrite SUB;exact SA).
          assert(V:pure_rval ge e m(D sub)=Some(Vint Int.one))by(rewrite SUB;exact VA).
          destruct(gs_rred_plug ge e m D sub sub' mf t(Vint Int.one)CD S V RED)as[MM[SS[TT VV]]].
          split;[exact MM|];rewrite XP,XU,EXT;apply guard_phase_b;[exact SS|rewrite TT,SUB;exact TA|exact VV].
 - destruct(gs_paren_context RV C sub(Eunop Onotbool(Eval(Vint Int.one)tint)tint)type_bool tint CT EQ)
     as[(K&SUB&ID)|(DP&CP&SP&XP)].
   + subst sub;inversion RED.
   + destruct(gs_unop_context RV DP sub Onotbool(Eval(Vint Int.one)tint)tint CP SP)
       as[(K&SUB&ID)|(DU&CU&SU&XU)].
     * subst sub;inversion RED;subst.
       lazymatch goal with H:sem_unary_operation Onotbool(Vint Int.one)tint _=Some ?v |- _=>
         change(Some(Vint Int.zero)=Some v)in H;injection H as VALUE;subst v end.
       split;[reflexivity|];rewrite XP,ID;apply guard_phase_d.
     * destruct(gs_literal_context RV DU sub(Vint Int.one)tint CU SU)as[K[SUB ID]].
       subst sub;inversion RED.
 - destruct(gs_paren_context RV C sub(Eval(Vint Int.zero)tint)type_bool tint CT EQ)
     as[(K&SUB&ID)|(D&CD&SUB&EXT)].
   + subst sub;inversion RED;subst.
     lazymatch goal with H:sem_cast(Vint Int.zero)tint type_bool _=Some ?v |- _=>
       change(Some(Vint Int.zero)=Some v)in H;injection H as VALUE;subst v end.
     split;[reflexivity|];rewrite ID;apply guard_phase_e.
   + destruct(gs_literal_context RV D sub(Vint Int.zero)tint CD SUB)as[K[SUB0 ID]].
     subst sub;inversion RED.
 - destruct(gs_literal_context RV C sub(Vint Int.zero)tint CT EQ)as[K[SUB ID]].
   subst sub;inversion RED.
Qed.

Lemma guard_phase_no_call : forall ge e m b c r C sub fd args ty,
 guard_phase ge e m b c r ->context RV RV C ->C sub=r ->
 callred ge sub m fd args ty ->False.
Proof.
 intros ge e m b c r C sub fd args ty PH CT EQ RED.
 destruct PH as[a SA TA VA|a SA TA VA| | |].
 - unfold guard_expr in EQ.
   destruct(gs_seqor_context RV C sub a(Eunop Onotbool(Eseqor b c tint)tint)tint CT EQ)
     as[(K&SUB&ID)|(D&CD&SUB&EXT)].
   + subst sub;inversion RED.
   + eapply gs_simple_no_call;[exact CD|rewrite SUB;exact SA|exact RED].
 - destruct(gs_paren_context RV C sub(Eunop Onotbool(Eseqor a c tint)tint)type_bool tint CT EQ)
     as[(K&SUB&ID)|(DP&CP&SP&XP)].
   + subst sub;inversion RED.
   + destruct(gs_unop_context RV DP sub Onotbool(Eseqor a c tint)tint CP SP)
       as[(K&SUB&ID)|(DU&CU&SU&XU)].
     * subst sub;inversion RED.
     * destruct(gs_seqor_context RV DU sub a c tint CU SU)
         as[(K&SUB&ID)|(D&CD&SUB&EXT)].
       -- subst sub;inversion RED.
       -- eapply gs_simple_no_call;[exact CD|rewrite SUB;exact SA|exact RED].
 - destruct(gs_paren_context RV C sub(Eunop Onotbool(Eval(Vint Int.one)tint)tint)type_bool tint CT EQ)
     as[(K&SUB&ID)|(DP&CP&SP&XP)].
   + subst sub;inversion RED.
   + destruct(gs_unop_context RV DP sub Onotbool(Eval(Vint Int.one)tint)tint CP SP)
       as[(K&SUB&ID)|(DU&CU&SU&XU)].
     * subst sub;inversion RED.
     * destruct(gs_literal_context RV DU sub(Vint Int.one)tint CU SU)as[K[SUB ID]];subst sub;inversion RED.
 - destruct(gs_paren_context RV C sub(Eval(Vint Int.zero)tint)type_bool tint CT EQ)
     as[(K&SUB&ID)|(D&CD&SUB&EXT)].
   + subst sub;inversion RED.
   + destruct(gs_literal_context RV D sub(Vint Int.zero)tint CD SUB)as[K[SUB0 ID]];subst sub;inversion RED.
 - destruct(gs_literal_context RV C sub(Vint Int.zero)tint CT EQ)as[K[SUB ID]];subst sub;inversion RED.
Qed.


Lemma guard_phase_estep : forall ge f e m k b c r t next,
 simple b=true ->typeof b=tint ->pure_rval ge e m b=Some(Vint Int.one) ->
 guard_phase ge e m b c r ->Csem.estep ge(ExprState f r k e m)t next ->
 exists r',next=ExprState f r' k e m /\guard_phase ge e m b c r'.
Proof.
 intros ge f e m k b c r t next SB TB VB PH STEP;inversion STEP;subst.
 - lazymatch goal with
   | LR:lred ge e ?a m ?a' ?mf,CT:Csem.context LV RV ?C |- _=>
     destruct(guard_phase_lred ge e m b c(C a)C a a' mf PH CT eq_refl LR)as[MM GP];
     subst mf;exists(C a');split;[reflexivity|exact GP]
   end.
 - lazymatch goal with
   | RR:rred ge ?a m t ?a' ?mf,CT:Csem.context RV RV ?C |- _=>
     destruct(guard_phase_rred ge e m b c(C a)C a a' mf t SB TB VB PH CT eq_refl RR)as[MM GP];
     subst mf;exists(C a');split;[reflexivity|exact GP]
   end.
 - exfalso;lazymatch goal with
   | CR:callred ge ?a m ?fd ?args ?ty,CT:Csem.context RV RV ?C |- _=>
     exact(guard_phase_no_call ge e m b c(C a)C a fd args ty PH CT eq_refl CR)
   end.
 - exfalso;lazymatch goal with
   | BAD:~imm_safe ge e ?from ?sub m,CT:Csem.context ?from RV ?C |- _=>
     apply BAD;exact(guard_phase_not_stuck ge e m b c(C sub)PH from C sub CT eq_refl)
   end.
Qed.

Definition guard_false_invariant(ge:genv)(f:function)(e:env)(m:mem)(k:cont)
 (yes no:statement)(a b c:expr)(s:Csem.state):Prop:=
 s=State f(Sifthenelse(guard_expr a b c)yes no)k e m \/
 s=State f no k e m \/
 exists r,guard_phase ge e m b c r /\s=ExprState f r(Kifthenelse yes no k)e m.

Lemma guard_false_step_closed : forall ge f e m k yes no a b c,
 simple a=true ->typeof a=tint ->pure_rval ge e m a=Some(Vint Int.zero) ->
 simple b=true ->typeof b=tint ->pure_rval ge e m b=Some(Vint Int.one) ->
 forall s t next,guard_false_invariant ge f e m k yes no a b c s ->
 s<>State f no k e m ->Csem.step ge s t next ->
 guard_false_invariant ge f e m k yes no a b c next.
Proof.
 intros ge f e m k yes no a b c SA TA VA SB TB VB s t next INV NF STEP.
 destruct INV as[EQ|[EQ|[r[PH EQ]]]].
 - subst s;destruct STEP as[ES|SS];[inversion ES|].
   inversion SS;subst;try solve[match goal with H:_\/ _ |- _=>destruct H as[H|H];discriminate H end].
   right;right;exists(guard_expr a b c);split;[apply guard_phase_a;assumption|reflexivity].
 - subst s;contradiction.
 - subst s;destruct STEP as[ES|SS].
   + destruct(guard_phase_estep ge f e m(Kifthenelse yes no k)b c r t next SB TB VB PH ES)
       as[r'[EQ GP]].
     right;right;exists r';split;assumption.
   + inversion SS;subst;inversion PH;subst.
     lazymatch goal with H:bool_val(Vint Int.zero)tint _=Some ?flag |- _=>
       change(Some false=Some flag)in H;injection H as BOOL;subst flag end.
     right;left;reflexivity.
Qed.

Theorem guard_false_certificate : forall ge f e m k yes no a b c,
 simple a=true ->typeof a=tint ->pure_rval ge e m a=Some(Vint Int.zero) ->
 simple b=true ->typeof b=tint ->pure_rval ge e m b=Some(Vint Int.one) ->
 certificate ge(guard_false_invariant ge f e m k yes no a b c)(State f no k e m).
Proof.
 intros ge f e m k yes no a b c SA TA VA SB TB VB;split.
 - intros s INV;destruct INV as[EQ|[EQ|[r[PH EQ]]]].
   + subst s;right;exists E0,(ExprState f(guard_expr a b c)(Kifthenelse yes no k)e m);split.
     * right;apply Csem.step_ifthenelse_1.
     * right;right;exists(guard_expr a b c);split;[apply guard_phase_a;assumption|reflexivity].
   + subst s;left;reflexivity.
   + subst s;destruct(literal RV r)eqn:LIT.
     * destruct(literal_r_inv _ LIT)as[v[ty EQ]];subst r;inversion PH;subst.
       right;exists E0,(State f no k e m);split.
       -- right;apply Csem.step_ifthenelse_2 with(b:=false);reflexivity.
       -- right;left;reflexivity.
     * pose proof(guard_phase_not_stuck ge e m b c r PH)as NS.
       destruct(immediate_has_step ge f r(Kifthenelse yes no k)e m LIT
         (NS RV(fun x=>x)r(ctx_top RV)eq_refl))as[t[next STEP]].
       right;exists t,next;split;[exact STEP|].
       eapply guard_false_step_closed with(s:=ExprState f r(Kifthenelse yes no k)e m)(t:=t);[exact SA|exact TA|exact VA|exact SB|exact TB|exact VB| |discriminate|exact STEP].
       right;right;exists r;split;[exact PH|reflexivity].
 - exact(guard_false_step_closed ge f e m k yes no a b c SA TA VA SB TB VB).
Qed.

Lemma guard_false_initial : forall ge f e m k yes no a b c,
 guard_false_invariant ge f e m k yes no a b c
   (State f(Sifthenelse(guard_expr a b c)yes no)k e m).
Proof. intros;left;reflexivity. Qed.
Lemma guard_false_initial_expr : forall ge f e m k yes no a b c,
 simple a=true ->typeof a=tint ->pure_rval ge e m a=Some(Vint Int.zero) ->
 guard_false_invariant ge f e m k yes no a b c
   (ExprState f(guard_expr a b c)(Kifthenelse yes no k)e m).
Proof.
 intros;right;right;exists(guard_expr a b c);split;[apply guard_phase_a;assumption|reflexivity].
Qed.
Print Assumptions guard_false_certificate.
Print Assumptions guard_false_initial_expr.
