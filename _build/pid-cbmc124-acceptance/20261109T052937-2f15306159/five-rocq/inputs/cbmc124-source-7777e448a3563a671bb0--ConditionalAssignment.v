From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress PhaseComposition CallfreeExecution AtomicDenotation BlockExecution.
From PidPositionSafety Require Import AtomicPhase.
From PidPositionTranslationCore Require Import ConditionalPure.
Import ListNotations.

Lemma assignment_context_inv:forall from C l r ty sub,
 context from RV C ->Eassign l r ty=C sub ->
 (from=RV /\sub=Eassign l r ty /\forall z,C z=z) \/
 (exists D,context from LV D /\l=D sub /\forall z,C z=Eassign(D z)r ty) \/
 (exists D,context from RV D /\r=D sub /\forall z,C z=Eassign l(D z)ty).
Proof.
 intros from C l r ty sub CT EQ;inversion CT;subst;try discriminate.
 - cbn in EQ;left;repeat split;auto.
 - inversion EQ;subst;right;left;eexists;repeat split;eauto.
 - inversion EQ;subst;right;right;eexists;repeat split;eauto.
Qed.

Section ASSIGNMENT.
Variable ge:genv.
Variable f:function.
Variable e:env.
Variable k:cont.
Variable m mf:mem.
Variable ty rty:type.
Variable b:block.
Variable ofs:ptrofs.
Variable bf:bitfield.
Variable vr vc vout:val.
Hypothesis nonvolatile:nv ty=true.
Hypothesis cast_result:sem_cast vr rty ty m=Some vc.
Hypothesis store_result:Cexec.do_assign_loc ge quiet_world ty m b ofs bf vc=
 Some(quiet_world,E0,mf,vout).
Definition pending(l r:expr):Prop:=
 simple l=true /\typeof l=ty /\pure_lval ge e m l=Some(b,ofs,bf) /\
 typeof r=rty /\conditional_value ge e m r vr.
Lemma pending_immediate:forall l r,pending l r ->
 imm_safe ge e RV(Eassign l r ty)m.
Proof.
 intros l r[SL[TL[LVAL[TR CV]]]].
 destruct(literal LV l)eqn:LL.
 - destruct(literal_l_inv _ LL)as[bl[ol[bfl[tl EQ]]]];subst l.
   cbn[typeof pure_lval]in *;injection LVAL as EB EO EF;subst bl ol bfl tl.
   destruct(literal RV r)eqn:RL.
   + destruct(literal_r_inv _ RL)as[rv[rt EQ]];subst r.
     pose proof(conditional_literal ge e m _ _ _ CV)as EV;subst rv.
     cbn[typeof]in TR;subst rt.
     destruct(Cexec.do_assign_loc_sound _ _ _ _ _ _ _ _ _ _ _ _ store_result)as[AS PT].
     eapply imm_safe_rred with(C:=fun x=>x);[|constructor].
     eapply red_assign;[exact cast_result|exact AS].
   + eapply lift_immediate with(from:=RV)(C:=fun x=>Eassign(Eloc b ofs bf ty)x ty);eauto.
     * constructor;constructor.
     * eapply conditional_immediate;exact CV.
 - eapply lift_immediate with(from:=LV)(C:=fun x=>Eassign x r ty);eauto.
   + constructor;constructor.
   + eapply(proj2(big_immediate ge e m));eapply(proj2(pure_eval_big l ge e m SL));exact LVAL.
Qed.
Lemma pending_not_stuck:forall l r,pending l r ->
 Csem.not_stuck ge e(Eassign l r ty)m.
Proof.
 intros l r PR kind C sub CT EQ.
 destruct(assignment_context_inv kind C l r ty sub CT EQ)as[[K[ROOT ID]]|[[D[DC[LEFT ID]]]|[D[DC[RIGHT ID]]]]].
 - subst kind sub;eapply pending_immediate;exact PR.
 - destruct PR as[SL[TL[LVAL[TR CV]]]];subst l.
   pose proof(proj2(pure_eval_big _ ge e m SL) _ _ _ LVAL)as BE.
   pose proof(big_context_hole _ _ _ DC sub ge e m SL ltac:(unfold big_defined;eauto))as HS.
   destruct kind;unfold big_defined in HS.
   + destruct HS as[bb[oo[bff H]]];eapply(proj2(big_immediate ge e m));exact H.
   + destruct HS as[w H];eapply(proj1(big_immediate ge e m));exact H.
 - destruct PR as[SL[TL[LVAL[TR CV]]]];subst r.
   exact(conditional_not_stuck ge e m _ _ CV _ _ _ DC eq_refl).
Qed.

Lemma pending_estep:forall shell_k l r t next,
 pending l r ->Csem.estep ge(ExprState f(Eassign l r ty)shell_k e m)t next ->
 (exists l' r',next=ExprState f(Eassign l' r' ty)shell_k e m /\t=E0 /\pending l' r') \/
 (next=ExprState f(Eval vout ty)shell_k e mf /\t=E0).
Proof.
 intros shell_k l r t next PR STEP.
 destruct PR as[SL[TL[LVAL[TR CV]]]].
 inversion STEP;subst.
 - lazymatch goal with LR:lred ge e ?sub m ?sub' ?mm,CT:Csem.context LV RV ?C|-_ =>
   destruct(assignment_context_inv LV C l r ty sub CT(eq_sym H0))as[[BAD REST]|[[D[DC[LEFT ID]]]|[D[DC[RIGHT ID]]]]];
   [discriminate| |]end.
   + lazymatch goal with LR:lred ge e ?sub m ?sub' ?mm|-_ =>
     destruct(pure_lred ge e sub m sub' mm LR)as[MM[TY[SS EE]]];subst mm;
     left;exists(D sub'),r;rewrite ID;split;[reflexivity|];split;[reflexivity|];
     unfold pending;split;
     [rewrite LEFT in SL;eapply simple_context_replace;[exact DC|symmetry;exact TY|exact SL|exact SS]
     |split;[rewrite LEFT in TL;rewrite(context_type_eq _ _ _ DC sub' sub TY);exact TL|];
      split;[pose proof(pure_context_congr ge e m LV LV D DC sub sub'(eq_sym TY)EE)as EQ;
             change(pure_lval ge e m(D sub)=pure_lval ge e m(D sub'))in EQ;
             rewrite <-EQ,<-LEFT;exact LVAL|auto]]end.
   + lazymatch goal with LR:lred ge e ?sub m ?sub' ?mm|-_ =>
     assert(ES:Csem.estep ge(ExprState f r shell_k e m)E0(ExprState f(D sub')shell_k e mm))
      by(rewrite RIGHT;eapply step_lred;[exact LR|exact DC]);
     destruct(conditional_estep ge e m f r shell_k E0 _ vr CV ES)as[residual[EQ[TT[TY VV]]]];
     injection EQ as AA MM;subst residual mm;
     left;exists l,(D sub');rewrite ID;split;[reflexivity|];split;[reflexivity|];
     unfold pending;repeat split;try assumption;try(rewrite TY;exact TR)end.
 - lazymatch goal with RR:rred ge ?sub m t ?sub' ?mm,CT:Csem.context RV RV ?C|-_ =>
   destruct(assignment_context_inv RV C l r ty sub CT(eq_sym H0))as[[K[ROOT ID]]|[[D[DC[LEFT ID]]]|[D[DC[RIGHT ID]]]]]
   end.
   + subst a;inversion H6;subst.
     cbn[typeof pure_lval]in *.
     injection LVAL as EB EO EF;subst.
     pose proof(conditional_literal ge e m _ _ _ CV)as EV;subst.
     cbn[typeof]in *;subst.
     assert(TT:t=E0)by(eapply assign_loc_silent;[exact nonvolatile|eassumption]);subst t.
     lazymatch goal with AS:assign_loc ge ty m b ofs bf _ E0 _ _|-_ =>
       assert(VC:v=vc)by congruence;subst v;
       pose proof(Cexec.do_assign_loc_complete ge quiet_world _ _ _ _ _ _ quiet_world E0 _ _ AS(possible_trace_nil _))as DS;
       rewrite store_result in DS;injection DS as MM VV;subst end.
     right;split;[rewrite ID;reflexivity|reflexivity].
   + lazymatch goal with RR:rred ge ?sub m t ?sub' ?mm|-_ =>
     assert(SA:simple sub=true)by(eapply simple_context_hole;[exact DC|rewrite <-LEFT;exact SL]);
     destruct(pure_rred ge e sub m t sub' mm SA RR)as[MM[TT[TY[SS EE]]]];subst mm;
     left;exists(D sub'),r;rewrite ID;split;[reflexivity|];split;[exact TT|];
     unfold pending;split;
     [rewrite LEFT in SL;eapply simple_context_replace;[exact DC|symmetry;exact TY|exact SL|exact SS]
     |split;[rewrite LEFT in TL;rewrite(context_type_eq _ _ _ DC sub' sub TY);exact TL|];
      split;[pose proof(pure_context_congr ge e m RV LV D DC sub sub'(eq_sym TY)EE)as EQ;
             change(pure_lval ge e m(D sub)=pure_lval ge e m(D sub'))in EQ;
             rewrite <-EQ,<-LEFT;exact LVAL|auto]]end.
   + lazymatch goal with RR:rred ge ?sub m t ?sub' ?mm|-_ =>
     assert(ES:Csem.estep ge(ExprState f r shell_k e m)t(ExprState f(D sub')shell_k e mm))
      by(rewrite RIGHT;eapply step_rred;[exact RR|exact DC]);
     destruct(conditional_estep ge e m f r shell_k t _ vr CV ES)as[residual[EQ[TT[TY VV]]]];
     injection EQ as AA MM;subst residual mm;
     left;exists l,(D sub');rewrite ID;split;[reflexivity|];split;[exact TT|];
     unfold pending;repeat split;try assumption;try(rewrite TY;exact TR)end.
 - lazymatch goal with CR:callred ge ?sub m _ _ _,CT:Csem.context RV RV ?C|-_ =>
   destruct(assignment_context_inv RV C l r ty sub CT(eq_sym H0))as[[K[ROOT ID]]|[[D[DC[LEFT ID]]]|[D[DC[RIGHT ID]]]]];
   [subst sub;inversion CR|
    assert(SA:simple sub=true)by(eapply simple_context_hole;[exact DC|rewrite <-LEFT;exact SL]);inversion CR;subst;discriminate|
    destruct(conditional_context_hole ge e m _ _ _ DC sub vr eq_refl ltac:(rewrite <-RIGHT;exact CV))as[SA|[w CW]];
    inversion CR;subst;[discriminate|inversion CW;discriminate]]end.
 - exfalso;lazymatch goal with BAD:~imm_safe ge e ?kind ?sub m,CT:Csem.context ?kind RV ?C|-_ =>
   apply BAD;eapply pending_not_stuck;[unfold pending;repeat split;eassumption|exact CT|symmetry;exact H0]end.
Qed.
Variables original_l original_r:expr.
Hypothesis original_pending:pending original_l original_r.
Definition before_commit(s:Csem.state):Prop:=
 s=State f(Sdo(Eassign original_l original_r ty))k e m \/
 (exists l r,s=ExprState f(Eassign l r ty)(Kdo k)e m /\pending l r) \/
 s=ExprState f(Eval vout ty)(Kdo k)e mf.
Lemma before_commit_successors:forall s t next,
 before_commit s ->s<>ExprState f(Eval vout ty)(Kdo k)e mf ->
 Csem.step ge s t next ->before_commit next.
Proof.
 intros s t next[START|[PENDING|DONE]]NF STEP.
 - subst s;destruct STEP as[ES|SS];[inversion ES|].
   inversion SS;subst;try solve[right;left;exists original_l,original_r;auto].
   all:repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
 - destruct PENDING as[l[r[EQ PR]]];subst s.
   destruct STEP as[ES|SS].
   + destruct(pending_estep(Kdo k)l r t next PR ES)as[[l'[r'[EQ[TT PP]]]]|[EQ TT]];
     subst next;[right;left;eauto|right;right;reflexivity].
   + inversion SS.
 - contradiction.
Qed.
Lemma before_commit_progress:forall s,before_commit s ->
 s=ExprState f(Eval vout ty)(Kdo k)e mf \/
 exists t next,Csem.step ge s t next /\before_commit next.
Proof.
 intros s[START|[PENDING|DONE]].
 - subst s;right;exists E0,(ExprState f(Eassign original_l original_r ty)(Kdo k)e m);split.
   + right;constructor.
   + right;left;exists original_l,original_r;auto.
 - destruct PENDING as[l[r[EQ PR]]];subst s.
   destruct(immediate_has_step ge f(Eassign l r ty)(Kdo k)e m eq_refl
     (pending_immediate l r PR))as[t[next STEP]].
   right;exists t,next;split;[exact STEP|].
   eapply before_commit_successors;[right;left;eauto|discriminate|exact STEP].
 - auto.
Qed.
Theorem conditional_assignment_certificate:
 exists P,certificate ge P(State f Sskip k e mf) /\
 P(State f(Sdo(Eassign original_l original_r ty))k e m).
Proof.
 assert(PRE:certificate ge before_commit(ExprState f(Eval vout ty)(Kdo k)e mf)).
 { split;[exact before_commit_progress|exact before_commit_successors]. }
 destruct(atomic_expression_certificate ge f e k mf mf(Eval vout ty)vout eq_refl eq_refl)
 as[POST PIN].
 exists(fun s=>before_commit s \/block_context_invariant ge k f e mf s);split;[|left;left;reflexivity].
 destruct PRE as[PP PC];destruct POST as[QP QC];split.
 - intros s[PS|QS].
   + destruct(PP s PS)as[EQ|[t[next[STEP PN]]]].
     * subst s;destruct(QP _ PIN)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
     * right;eauto.
   + destruct(QP s QS)as[EQ|[t[next[STEP QN]]]];[auto|right;eauto].
 - intros s t next[PS|QS]NF STEP.
   + destruct(classic(s=ExprState f(Eval vout ty)(Kdo k)e mf))as[EQ|NE].
     * subst s;right;eapply QC;eauto.
     * left;eapply PC;eauto.
   + right;eapply QC;eauto.
Qed.
End ASSIGNMENT.
Print Assumptions conditional_assignment_certificate.

