From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Errors Maps AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress PhaseComposition.
Import ListNotations.

Section CONDITIONAL.
Variable ge:genv.
Variable e:env.
Variable m:mem.
Inductive conditional_value:expr->val->Prop:=
 | cv_simple:forall a v,simple a=true ->pure_rval ge e m a=Some v ->conditional_value a v
 | cv_condition:forall test yes no ty vt taken vb v,
   simple test=true ->pure_rval ge e m test=Some vt ->
   bool_val vt(typeof test)m=Some taken ->
   conditional_value(if taken then yes else no)vb ->
   sem_cast vb(typeof(if taken then yes else no))ty m=Some v ->
   conditional_value(Econdition test yes no ty)v
 | cv_paren:forall a castty ty va v,
   conditional_value a va ->sem_cast va(typeof a)castty m=Some v ->
   conditional_value(Eparen a castty ty)v.

Lemma conditional_literal:forall v ty w,
 conditional_value(Eval v ty)w ->w=v.
Proof. intros v ty w H;inversion H;subst;cbn[pure_rval]in *;congruence. Qed.

Lemma conditional_immediate:forall a v,
 conditional_value a v ->imm_safe ge e RV a m.
Proof.
 intros a v CV;induction CV.
 - eapply simple_immediate;[exact H|rewrite H0;discriminate].
 - destruct(literal RV test)eqn:LIT.
   + destruct(literal_r_inv _ LIT)as[w[t EQ]];subst test.
     cbn[pure_rval]in H0;injection H0 as EQ;subst vt.
     eapply imm_safe_rred with(C:=fun x=>x);[|constructor].
     apply red_condition;exact H1.
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Econdition x yes no ty);eauto.
     * constructor;constructor.
     * eapply simple_immediate;[exact H|rewrite H0;discriminate].
 - destruct(literal RV a)eqn:LIT.
   + destruct(literal_r_inv _ LIT)as[w[t EQ]];subst a.
     pose proof(conditional_literal _ _ _ CV);subst va.
     eapply imm_safe_rred with(C:=fun x=>x);[|constructor].
     apply red_paren;exact H.
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Eparen x castty ty);eauto.
     constructor;constructor.
Qed.

Lemma conditional_not_stuck:forall a v,
 conditional_value a v ->Csem.not_stuck ge e a m.
Proof.
 intros a v CV;induction CV.
 - eapply pure_not_stuck;eauto.
 - intros kind C sub CT EQ;inversion CT;subst;try discriminate.
   + cbn in EQ;subst sub;eapply conditional_immediate;eapply cv_condition;eauto.
   + inversion EQ;subst.
     match goal with CT:Csem.context _ RV _|-_=>eapply(pure_not_stuck ge e m _ vt H H0);[exact CT|reflexivity]end.
 - intros kind C sub CT EQ;inversion CT;subst;try discriminate.
   + cbn in EQ;subst sub;eapply conditional_immediate;eapply cv_paren;eauto.
   + inversion EQ;subst;eapply IHCV;eauto.
Qed.

Lemma conditional_simple_context:forall from C,
 context from RV C ->forall a b v,
 typeof a=typeof b ->
 (simple a=true ->simple b=true /\pure_eq ge e m from a b) ->
 simple(C a)=true ->pure_rval ge e m(C a)=Some v ->
 conditional_value(C b)v.
Proof.
 intros from C CT a b v TY MAP SI DEN.
 assert(SA:simple a=true)by(eapply simple_context_hole;[exact CT|exact SI]).
 destruct(MAP SA)as[SB EQ].
 apply cv_simple.
 - eapply simple_context_replace;[exact CT|exact TY|exact SI|exact SB].
 - pose proof(pure_context_congr ge e m from RV C CT a b TY EQ)as CE;change(pure_rval ge e m(C a)=pure_rval ge e m(C b))in CE;rewrite <-CE;exact DEN.
Qed.

Lemma conditional_context_congr:forall from to C,
 context from to C ->forall a b,
 typeof a=typeof b ->
 (simple a=true ->simple b=true /\pure_eq ge e m from a b) ->
 (from=RV ->forall v,conditional_value a v ->conditional_value b v) ->
 to=RV ->forall v,conditional_value(C a)v ->conditional_value(C b)v.
Proof.
 intros from to C CT;pose proof CT as WHOLE;induction CT;intros a b TY SIMPLE COND KIND v CV;try discriminate.
 all: try solve[cbn in *;apply COND;[exact KIND|exact CV]].
 all: try solve[
  inversion CV;subst;try discriminate;
  match goal with
  MAP:(simple ?aa=true ->simple ?bb=true /\_),
  SI:simple ?whole=true,DEN:pure_rval ge e m ?whole=Some ?vv|-_ =>
  exact(conditional_simple_context _ _ WHOLE aa bb vv TY MAP SI DEN)
  end].
 - inversion CV;subst;try discriminate.
   assert(SA:simple a=true)by(eapply simple_context_hole;[exact CT|exact H3]).
   destruct(SIMPLE SA)as[SB EQ].
   eapply cv_condition;[| | |exact H7|exact H8].
   + eapply simple_context_replace;[exact CT|exact TY|exact H3|exact SB].
   + pose proof(pure_context_congr ge e m _ RV C CT a b TY EQ)as CE;
     change(pure_rval ge e m(C a)=pure_rval ge e m(C b))in CE;rewrite <-CE;exact H4.
   + rewrite <-(context_type_eq _ _ _ CT a b TY);exact H6.
 - inversion CV;subst;try discriminate.
   eapply cv_paren.
   + eapply IHCT;eauto.
   + rewrite <-(context_type_eq _ _ _ CT a b TY);assumption.
Qed.

Lemma conditional_rred:forall a v t a' mf,
 conditional_value a v ->rred ge a m t a' mf ->
 mf=m /\t=E0 /\typeof a'=typeof a /\conditional_value a' v.
Proof.
 intros a v t a' mf CV HR;inversion CV;subst.
 - destruct(pure_rred ge e a m t a' mf H HR)as[MM[TT[TY[SI DEN]]]].
   subst mf;repeat split;auto;apply cv_simple;[exact SI|rewrite <-DEN;exact H0].
 - inversion HR;subst.
   cbn[pure_rval]in H0;injection H0 as EQ;subst vt.
   cbn[typeof]in H1.
   assert(b=taken)by congruence;subst b.
   repeat split;auto;eapply cv_paren;eauto.
 - inversion HR;subst.
   pose proof(conditional_literal _ _ _ H);subst va.
   cbn[typeof]in *.
   assert(v0=v)by congruence;subst v0.
   repeat split;auto;apply cv_simple;reflexivity.
Qed.
Lemma conditional_context_hole:forall from to C,
 context from to C ->forall a v,to=RV ->conditional_value(C a)v ->
 simple a=true \/exists w,conditional_value a w.
Proof.
 intros from to C CT;pose proof CT as WHOLE;induction CT;intros a v KIND CV;try discriminate.
 all:try solve[right;exists v;exact CV].
 all:inversion CV;subst;try discriminate.
 all:try solve[left;eapply simple_context_hole;[exact WHOLE|eassumption]].
 - left;eapply simple_context_hole;[exact CT|eassumption].
 - eapply IHCT;eauto.
Qed.

Lemma conditional_estep:forall f a k t next v,
 conditional_value a v ->Csem.estep ge(ExprState f a k e m)t next ->
 exists a',next=ExprState f a' k e m /\t=E0 /\
 typeof a'=typeof a /\conditional_value a' v.
Proof.
 intros f a k t next v CV STEP;inversion STEP;subst.
 - match goal with LR:lred ge e ?sub m ?sub' ?mf,CT:Csem.context LV RV ?C|-_ =>
   destruct(pure_lred ge e sub m sub' mf LR)as[MM[TY[SI EQ]]];subst mf;
   exists(C sub');repeat split;auto;
   [exact(context_type_eq _ _ _ CT sub' sub TY)
   |eapply conditional_context_congr;[exact CT|symmetry;exact TY| |intros BAD;discriminate|reflexivity|exact CV];
    intros SA;split;assumption]end.
 - assert(INFO:m'=m /\t=E0 /\typeof a'=typeof a0).
   { destruct(conditional_context_hole _ _ _ H7 a0 v eq_refl CV)as[SA|[w CW]].
     - destruct(pure_rred ge e a0 m t a' m' SA H6)as[MM[TT[TY REST]]];auto.
     - destruct(conditional_rred a0 w t a' m' CW H6)as[MM[TT[TY REST]]];auto. }
   destruct INFO as[MM[TT TY]];subst m'.
   exists(C a');split;[reflexivity|];split;[exact TT|];split.
   + exact(context_type_eq _ _ _ H7 a' a0 TY).
   + eapply conditional_context_congr with(from:=RV)(C:=C)(a:=a0)(b:=a');
     [exact H7|symmetry;exact TY| | |reflexivity|exact CV].
     * intros SI;destruct(pure_rred ge e a0 m t a' m SI H6)as[_[_[_[SS EE]]]];split;assumption.
     * intros _ value VALUE;exact(proj2(proj2(proj2(conditional_rred a0 value t a' m VALUE H6)))).
 - match goal with CR:callred ge ?sub m _ _ _,CT:Csem.context RV RV ?C|-_ =>
   destruct(conditional_context_hole _ _ _ CT sub v eq_refl CV)as[SA|[w CW]];
   inversion CR;subst;[discriminate|inversion CW;discriminate]end.
 - exfalso;match goal with BAD:~imm_safe ge e ?kind ?sub m,CT:Csem.context ?kind RV ?C|-_ =>
   apply BAD;exact(conditional_not_stuck _ _ CV _ _ _ CT eq_refl)end.
Qed.
End CONDITIONAL.
Print Assumptions conditional_estep.

