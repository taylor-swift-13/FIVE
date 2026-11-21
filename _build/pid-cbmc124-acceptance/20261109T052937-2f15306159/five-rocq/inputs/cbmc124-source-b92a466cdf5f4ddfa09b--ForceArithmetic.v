From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Maps Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureDenotation PureProgress CallfreeExecution PhaseComposition StandaloneCallShell.
From PidPositionSafety Require Import PureCallArguments TaggedCallee.
From CoreCBMC Require Import ArithmeticTree ArithmeticPhases.
Inductive and_hole(left right:expr)(ty:type):kind->(expr->expr)->expr->Prop:=
| ah_whole:and_hole left right ty RV(fun x=>x)(Eseqand left right ty)
| ah_left:forall from D a,context from RV D ->left=D a ->
 and_hole left right ty from(fun x=>Eseqand(D x)right ty)a.
Lemma and_context_decompose:forall from C a left right ty,
 context from RV C ->C a=Eseqand left right ty ->and_hole left right ty from C a.
Proof.
 intros from C a left right ty CT EQ;inversion CT;subst;cbn in EQ;try discriminate.
 - subst;constructor.
 - inversion EQ;subst;eapply ah_left;[eassumption|reflexivity].
Qed.
Lemma simple_tree_lreplace:forall ge e m to C a b mf,
 context LV to C ->simple(C a)=true ->arithmetic_tree ge e m(C a) ->
 lred ge e a m b mf ->arithmetic_tree ge e m(C b).
Proof.
 intros ge e m to C a b mf CT SI TREE RED.
 destruct(pure_lred ge e a m b mf RED)as[MM[TY[SB DEN]]];subst mf.
 eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact DEN|exact TREE|].
 eapply arithmetic_lred;exact RED.
Qed.
Lemma simple_tree_rreplace:forall ge e m to C a b t mf,
 context RV to C ->simple(C a)=true ->arithmetic_tree ge e m(C a) ->
 rred ge a m t b mf ->arithmetic_tree ge e m(C b).
Proof.
 intros ge e m to C a b t mf CT SI TREE RED.
 assert(SA:simple a=true)by(eapply simple_context_hole;[exact CT|exact SI]).
 destruct(pure_rred ge e a m t b mf SA RED)as[MM[TT[TY[SB DEN]]]];subst mf.
 eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact DEN|exact TREE|].
 eapply arithmetic_rred;[eapply arithmetic_context_hole;[exact CT|exact TREE]|exact RED].
Qed.
Section AND.
Variable ge:genv.
Variable f:function.
Variable e:env.
Variable k:cont.
Variable m:mem.
Variable left right:expr.
Variable yes no:statement.
Variable value:val.
Hypothesis left_simple:simple left=true.
Hypothesis left_value:pure_rval ge e m left=Some value.
Hypothesis left_bool:bool_val value(typeof left)m=Some false.
Hypothesis left_tree:arithmetic_tree ge e m left.
Hypothesis right_tree:arithmetic_tree ge e m right.
Definition valid(a:expr):Prop:=typeof a=typeof left/\simple a=true/\pure_rval ge e m a=Some value/\arithmetic_tree ge e m a.
Definition condition(a:expr):expr:=Eseqand a right tint.
Definition target:=State f no k e m.
Definition initial:=State f(Sifthenelse(condition left)yes no)k e m.
Definition phase(a:expr):Csem.state:=ExprState f(condition a)(Kifthenelse yes no k)e m.
Definition finished:=ExprState f(Eval(Vint Int.zero)tint)(Kifthenelse yes no k)e m.
Lemma and_immediate:forall a,valid a ->imm_safe ge e RV(condition a)m.
Proof.
 intros a[TY[SI[PV TREE]]];destruct(literal RV a)eqn:LI.
 - destruct(literal_r_inv a LI)as[v[ty EQ]];subst a;cbn[pure_rval]in PV;injection PV as EQ;subst v.
   eapply imm_safe_rred with(C:=fun x=>x);[apply red_seqand_false;cbn[typeof]in TY;rewrite TY;exact left_bool|constructor].
 - unfold condition;eapply lift_immediate with(from:=RV)(a:=a)(C:=fun x=>Eseqand x right tint).
   + constructor;constructor.
   + exact LI.
   + apply simple_immediate;[exact SI|rewrite PV;discriminate].
Qed.
Lemma and_not_stuck:forall a,valid a ->not_stuck ge e(condition a)m.
Proof.
 intros a VA from C b CT EQ.
 pose proof(and_context_decompose from C b a right tint CT(eq_sym EQ))as HH.
 inversion HH;subst.
 - apply and_immediate;exact VA.
 - destruct VA as[TY[SI[PV TREE]]];eapply big_subexpression_safe;[exact H|exact SI|].
   unfold big_defined;exists value;apply PureProgress.pure_eval_big;[exact SI|exact PV].
Qed.
Lemma and_all_successors:forall a t next,valid a ->
 Csem.step ge(phase a)t next ->
 (exists b,valid b/\next=phase b)\/next=finished.
Proof.
 intros a t next VA[ES|SS].
 - inversion ES;subst.
   + match goal with CT:Csem.context LV RV ?C,EQ:?C ?b=condition a,RED:lred ge e ?b m ?b' ?mm|-_=>
     pose proof(and_context_decompose LV C b a right tint CT EQ)as HH;inversion HH;subst;
     destruct VA as[TY[SI[PV TREE]]];
     pose proof(simple_tree_lreplace ge e m RV D b b' mm H SI TREE RED)as NTREE;
     destruct(pure_replace_lred ge e m RV D b b' mm H SI RED)as[MM[TT[SN DEN]]];subst mm end.
     left;exists(D a');split;[unfold valid;repeat split;[rewrite <-TT;exact TY|exact SN|congruence|exact NTREE]|reflexivity].
   + match goal with CT:Csem.context RV RV ?C,EQ:?C ?b=condition a|-_=>
     pose proof(and_context_decompose RV C b a right tint CT EQ)as HH;inversion HH;subst end.
     * match goal with RED:rred ge _ _ _ _ _|-_=>inversion RED;subst end.
       all:destruct VA as[TY[SI[PV TREE]]];cbn[pure_rval]in PV;injection PV as VV;subst;
       cbn[typeof]in TY;
       match goal with B:bool_val value _ _=Some _|-_=>rewrite TY,left_bool in B;try discriminate end.
       right;reflexivity.
     * destruct VA as[TY[SI[PV TREE]]].
       match goal with RED:rred ge ?b m t ?b' ?mm|-_=>
       pose proof(simple_tree_rreplace ge e m RV D b b' t mm H SI TREE RED)as NTREE;
       destruct(pure_replace_rred ge e m RV D b b' t mm H SI RED)as[MM[TT[TY'[SN DEN]]]];subst mm t end.
       left;exists(D a');split;[unfold valid;repeat split;[rewrite <-TY';exact TY|exact SN|congruence|exact NTREE]|reflexivity].
   + match goal with CT:Csem.context RV RV ?C,EQ:?C ?b=condition a|-_=>
     pose proof(and_context_decompose RV C b a right tint CT EQ)as HH;inversion HH;subst end.
     * match goal with RED:callred ge _ _ _ _ _|-_=>inversion RED end.
     * destruct VA as[TY[SI[PV TREE]]].
       assert(SUB:simple a0=true)by(eapply simple_context_hole;[exact H|exact SI]).
       match goal with RED:callred ge _ _ _ _ _|-_=>inversion RED;subst end;discriminate SUB.
   + exfalso;apply H7;exact(and_not_stuck a VA K C a0 H6(eq_sym H0)).
 - inversion SS.
Qed.
Definition invariant(s:Csem.state):Prop:=
 s=initial\/(exists a,valid a/\s=phase a)\/s=finished\/s=target.
Theorem false_and_if_certificate:certificate ge invariant target.
Proof.
 split.
 - intros s[START|[PRE|[DONE|EXIT]]].
   + subst;right;exists E0,(phase left);split;[right;apply Csem.step_ifthenelse_1|].
     right;left;exists left;split;[unfold valid;auto|reflexivity].
   + destruct PRE as[a[VA EQ]];subst.
     destruct(immediate_has_step ge f(condition a)(Kifthenelse yes no k)e m eq_refl(and_immediate a VA))
     as[t[next STEP]].
     right;exists t,next;split;[exact STEP|].
     destruct(and_all_successors a t next VA STEP)as[P|D];[right;left;exact P|right;right;left;exact D].
   + subst;right;exists E0,target;split;[right;unfold finished,target;apply Csem.step_ifthenelse_2 with(b:=false);reflexivity|right;right;right;reflexivity].
   + left;exact EXIT.
 - intros s t next[START|[PRE|[DONE|EXIT]]]NF STEP.
   + subst;destruct STEP as[ES|SS];[inversion ES|inversion SS;subst].
     all:try(solve[right;left;exists left;split;[unfold valid;auto|reflexivity]]).
     all:repeat match goal with H:_\/_|-_=>destruct H end;discriminate.
   + destruct PRE as[a[VA EQ]];subst.
     destruct(and_all_successors a t next VA STEP)as[P|D];[right;left;exact P|right;right;left;exact D].
   + subst;destruct STEP as[ES|SS].
     * exfalso;eapply StandaloneCallShell.value_estep_none;exact ES.
     * inversion SS;subst.
       match goal with B:bool_val(Vint Int.zero)tint m=Some _|-_=>cbn in B;injection B as EQ;subst end.
       right;right;right;reflexivity.
   + contradiction.
Qed.
Theorem initial_member:invariant initial.
Proof. left;reflexivity. Qed.
Theorem observations:forall s,invariant s ->annotated_state ge f s.
Proof.
 intros s[START|[PRE|[DONE|EXIT]]].
 - subst;split;reflexivity.
 - destruct PRE as[a[[TY[SI[PV TREE]]]EQ]];subst.
   split;[reflexivity|cbn[tree_state condition arithmetic_tree];split;assumption].
 - subst;split;[reflexivity|exact I].
 - subst;split;reflexivity.
Qed.
End AND.
Print Assumptions false_and_if_certificate.
