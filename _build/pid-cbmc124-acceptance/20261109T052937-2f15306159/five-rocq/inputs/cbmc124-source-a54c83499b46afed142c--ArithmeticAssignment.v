From Stdlib Require Import Bool List Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress PhaseComposition CallfreeExecution AtomicDenotation.
From compcert Require Import Integers Cexec Determinism.
From CoreCBMC Require Import ArithmeticAtomic.
From PidPositionTranslationCore Require Import ConditionalPure ConditionalAssignment.
From CoreCBMC Require Import ArithmeticTree ArithmeticConditional.
Lemma assignment_tree_estep:forall ge f e k m l r ty vr t next,
 simple l=true ->conditional_value ge e m r vr ->
 arithmetic_tree ge e m(Eassign l r ty) ->
 Csem.estep ge(ExprState f(Eassign l r ty)k e m)t next ->
 next=Stuckstate \/exists ar mr,next=ExprState f ar k e mr /\arithmetic_tree ge e mr ar.
Proof.
 intros ge f e k m l r ty vr t next SL CV TREE STEP;inversion STEP;subst.
 - right;lazymatch goal with LR:lred ge e ?sub m ?ar ?mr,CT:Csem.context LV RV ?C|-_ =>
   destruct(pure_lred ge e sub m ar mr LR)as[MM[TY[SS EE]]];subst mr;
   exists(C ar),m;split;[reflexivity|];
   eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact EE|rewrite H0;exact TREE|];
   eapply arithmetic_lred;exact LR end.
 - lazymatch goal with RR:rred ge ?sub m ?tr ?ar ?mr,CT:Csem.context RV RV ?C|-_ =>
   destruct(simple sub)eqn:SA;
   [destruct(pure_rred ge e sub m tr ar mr SA RR)as[MM[TT[TY[SS EE]]]];subst mr;
    right;exists(C ar),m;split;[reflexivity|];
    eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact EE|rewrite H0;exact TREE|];
    eapply arithmetic_rred;[eapply arithmetic_context_hole;[exact CT|rewrite H0;exact TREE]|exact RR]
   |destruct(assignment_context_inv RV C l r ty sub CT(eq_sym H0))
     as[[K[ROOT ID]]|[[D[DC[LEFT ID]]]|[D[DC[RIGHT ID]]]]]]
   end.
   + right;subst a;rewrite ID;exists a',m';split;[reflexivity|].
     eapply arithmetic_rred;[exact TREE|exact H6].
   + exfalso;apply Bool.diff_false_true;rewrite <-SA.
     eapply simple_context_hole;[exact DC|rewrite <-LEFT;exact SL].
   + right;lazymatch goal with RR:rred ge ?sub m ?tr ?ar ?mr|-_ =>
     assert(ES:Csem.estep ge(ExprState f r k e m)tr(ExprState f(D ar)k e mr))
      by(rewrite RIGHT;eapply step_rred;[exact RR|exact DC]);
     destruct(conditional_tree_estep ge e m f r k tr _ vr CV(proj2 TREE)ES)as[res[EQ TT]];
     injection EQ as AA MM;subst res mr;
     exists(Eassign l(D ar)ty),m;rewrite ID;split;[reflexivity|];
     cbn[arithmetic_tree];split;[exact(proj1 TREE)|exact TT]end.
 - lazymatch goal with CR:callred ge ?sub m _ _ _,CT:Csem.context RV RV ?C|-_ =>
   destruct(assignment_context_inv RV C l r ty sub CT(eq_sym H0))
    as[[K[ROOT ID]]|[[D[DC[LEFT ID]]]|[D[DC[RIGHT ID]]]]];
   [subst sub;inversion CR|
    assert(SA:simple sub=true)by(eapply simple_context_hole;[exact DC|rewrite <-LEFT;exact SL]);
    inversion CR;subst;discriminate|
    destruct(conditional_context_hole ge e m _ _ _ DC sub vr eq_refl ltac:(rewrite <-RIGHT;exact CV))as[SA|[w CW]];
    inversion CR;subst;[discriminate|inversion CW;discriminate]]end.
 - left;reflexivity.
Qed.
Print Assumptions assignment_tree_estep.

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
Hypothesis original_annotation:arithmetic_tree ge e m(Eassign original_l original_r ty).
Definition before_commit(s:Csem.state):Prop:=
 s=State f(Sdo(Eassign original_l original_r ty))k e m \/
 (exists l r,s=ExprState f(Eassign l r ty)(Kdo k)e m /\pending l r /\arithmetic_tree ge e m(Eassign l r ty)) \/
 s=ExprState f(Eval vout ty)(Kdo k)e mf.
Lemma before_commit_successors:forall s t next,
 before_commit s ->s<>ExprState f(Eval vout ty)(Kdo k)e mf ->
 Csem.step ge s t next ->before_commit next.
Proof.
 intros s t next[START|[PENDING|DONE]]NF STEP.
 - subst s;destruct STEP as[ES|SS];[inversion ES|].
   inversion SS;subst;try solve[right;left;exists original_l,original_r;auto].
   all:repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
 - destruct PENDING as[l[r[EQ[PR TREE]]]];subst s.
   destruct STEP as[ES|SS].
   + pose proof(assignment_tree_estep ge f e(Kdo k)m l r ty vr t next(proj1 PR)
       (proj2(proj2(proj2(proj2 PR))))TREE ES)as TS.
     destruct(pending_estep(Kdo k)l r t next PR ES)as[[l'[r'[EQ[TT PP]]]]|[EQ TT]].
     * subst next;right;left;exists l',r';split;[reflexivity|];split;[exact PP|].
       destruct TS as[BAD|[ar[mr[EQ TREE2]]]];[discriminate|].
       injection EQ as AA MM;subst ar mr;exact TREE2.
     * subst next;right;right;reflexivity.
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
 - destruct PENDING as[l[r[EQ[PR TREE]]]];subst s.
   destruct(immediate_has_step ge f(Eassign l r ty)(Kdo k)e m eq_refl
     (pending_immediate l r PR))as[t[next STEP]].
   right;exists t,next;split;[exact STEP|].
   eapply before_commit_successors;[right;left;eauto|discriminate|exact STEP].
 - auto.
Qed.
Definition assignment_arithmetic_invariant(s:Csem.state):Prop:=
 before_commit s \/ArithmeticAtomic.arithmetic_atomic_invariant ge f e k mf vout s.
Theorem conditional_arithmetic_assignment_certificate:
 certificate ge assignment_arithmetic_invariant(State f Sskip k e mf).
Proof.
 unfold assignment_arithmetic_invariant.
 assert(PRE:certificate ge before_commit(ExprState f(Eval vout ty)(Kdo k)e mf)).
 { split;[exact before_commit_progress|exact before_commit_successors]. }
 pose proof(ArithmeticAtomic.arithmetic_atomic_certificate ge f e k mf vout)as POST.
 assert(PIN:ArithmeticAtomic.arithmetic_atomic_invariant ge f e k mf vout
 (ExprState f(Eval vout ty)(Kdo k)e mf)).
 { right;exists(Eval vout ty),mf;repeat split;reflexivity. }
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
Theorem conditional_arithmetic_assignment_initial:
 assignment_arithmetic_invariant(State f(Sdo(Eassign original_l original_r ty))k e m).
Proof. left;left;reflexivity. Qed.
Theorem conditional_arithmetic_assignment_observation:forall f' a k' e' mr,
 assignment_arithmetic_invariant(ExprState f' a k' e' mr) ->arithmetic_tree ge e' mr a.
Proof.
 intros f' a k' e' mr[PRE|POST].
 - destruct PRE as[START|[[l[r[EQ[PR TREE]]]]|DONE]];[discriminate| |].
   + injection EQ as FF AA KK EE MM;subst;exact TREE.
   + injection DONE as FF AA KK EE MM;subst;constructor.
 - eapply ArithmeticAtomic.arithmetic_atomic_observation;exact POST.
Qed.
End ASSIGNMENT.
Print Assumptions conditional_arithmetic_assignment_certificate.
