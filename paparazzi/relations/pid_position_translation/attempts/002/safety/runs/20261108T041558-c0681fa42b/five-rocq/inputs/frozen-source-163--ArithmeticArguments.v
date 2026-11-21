From Stdlib Require Import Bool List.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureDenotation.
From PidPositionSafety Require Import PureCallArguments.
From CoreCBMC Require Import ArithmeticTree ArithmeticConditional.
Fixpoint arithmetic_tree_list(ge:genv)(e:env)(m:mem)(al:exprlist):Prop:=
 match al with Enil=>True|Econs a al=>arithmetic_tree ge e m a /\arithmetic_tree_list ge e m al end.
Lemma arithmetic_list_context_congr:forall ge e m from D,
 contextlist from D ->forall a b,
 typeof a=typeof b ->pure_eq ge e m from a b ->
 arithmetic_tree_list ge e m(D a) ->arithmetic_tree ge e m b ->
 arithmetic_tree_list ge e m(D b).
Proof.
 intros ge e m from D CT;induction CT;intros a b TY EQ TREE NEW;cbn[arithmetic_tree_list]in*.
 - destruct TREE as[HEAD TAIL];split;[eapply arithmetic_context_congr;eassumption|exact TAIL].
 - destruct TREE as[HEAD TAIL];split;[exact HEAD|eapply IHCT;eassumption].
Qed.
Lemma arithmetic_list_context_hole:forall ge e m from D,
 contextlist from D ->forall a,arithmetic_tree_list ge e m(D a) ->arithmetic_tree ge e m a.
Proof.
 intros ge e m from D CT;induction CT;intros a TREE;cbn[arithmetic_tree_list]in*.
 - eapply arithmetic_context_hole;[eassumption|exact(proj1 TREE)].
 - apply IHCT;exact(proj2 TREE).
Qed.
Lemma tree_replace_lred:forall ge e m C a b mf,
 context LV RV C ->arithmetic_tree ge e m(C a) ->lred ge e a m b mf ->
 arithmetic_tree ge e m(C b).
Proof.
 intros ge e m C a b mf CT TREE RED.
 destruct(pure_lred ge e a m b mf RED)as[MM[TY[SI DEN]]];subst mf.
 eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact DEN|exact TREE|eapply arithmetic_lred;exact RED].
Qed.
Lemma tree_replace_rred:forall ge e m C a b t mf,
 context RV RV C ->simple(C a)=true ->arithmetic_tree ge e m(C a) ->rred ge a m t b mf ->
 arithmetic_tree ge e m(C b).
Proof.
 intros ge e m C a b t mf CT SI TREE RED.
 assert(SUB:simple a=true)by(eapply simple_context_hole;[exact CT|exact SI]).
 destruct(pure_rred ge e a m t b mf SUB RED)as[MM[TT[TY[SB DEN]]]];subst mf.
 eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact DEN|exact TREE|].
 eapply arithmetic_rred;[eapply arithmetic_context_hole;[exact CT|exact TREE]|exact RED].
Qed.
Lemma list_tree_replace_lred:forall ge e m D a b mf,
 contextlist LV D ->arithmetic_tree_list ge e m(D a) ->lred ge e a m b mf ->
 arithmetic_tree_list ge e m(D b).
Proof.
 intros ge e m D a b mf CT TREE RED.
 destruct(pure_lred ge e a m b mf RED)as[MM[TY[SI DEN]]];subst mf.
 eapply arithmetic_list_context_congr;[exact CT|symmetry;exact TY|exact DEN|exact TREE|eapply arithmetic_lred;exact RED].
Qed.
Lemma list_tree_replace_rred:forall ge e m D a b t mf,
 contextlist RV D ->simplelist(D a)=true ->arithmetic_tree_list ge e m(D a) ->rred ge a m t b mf ->
 arithmetic_tree_list ge e m(D b).
Proof.
 intros ge e m D a b t mf CT SI TREE RED.
 assert(SUB:simple a=true)by(eapply simplelist_hole;[exact CT|exact SI]).
 destruct(pure_rred ge e a m t b mf SUB RED)as[MM[TT[TY[SB DEN]]]];subst mf.
 eapply arithmetic_list_context_congr;[exact CT|symmetry;exact TY|exact DEN|exact TREE|].
 eapply arithmetic_rred;[eapply arithmetic_list_context_hole;[exact CT|exact TREE]|exact RED].
Qed.
Print Assumptions list_tree_replace_rred.
