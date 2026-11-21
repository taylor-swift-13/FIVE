From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Ctypes Cop Csyntax Csem Cstrategy.
From FiveGuidanceSemantics Require Import SourceClosure.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation.
From PidPositionSafety Require Import SubtractionObservation.
Fixpoint no_sub(a:expr):bool:=
 match a with
 | Eval _ _|Evar _ _|Eloc _ _ _ _|Esizeof _ _|Ealignof _ _=>true
 | Evalof a _|Ederef a _|Eaddrof a _|Efield a _ _|Eunop _ a _|Ecast a _|Eparen a _ _=>no_sub a
 | Epostincr _ _ _|Eassignop _ _ _ _ _=>false
 | Ebinop Osub _ _ _=>false
 | Ebinop _ a b _|Eassign a b _|Eseqand a b _|Eseqor a b _|Ecomma a b _=>no_sub a&&no_sub b
 | Econdition c a b _=>no_sub c&&no_sub a&&no_sub b
 | Ecall a al _=>no_sub a&&no_sub_list al
 | Ebuiltin _ _ al _=>no_sub_list al
 end
with no_sub_list(al:exprlist):bool:=match al with
 | Enil=>true|Econs a al=>no_sub a&&no_sub_list al end.
Ltac nosub_boolean :=
 repeat rewrite Bool.andb_true_iff in *;
 repeat match goal with H:_ /\ _|-_=>destruct H end;
 try discriminate;repeat split;eauto 3.
Lemma no_sub_context_congr_mut:
 (forall from to C,context from to C ->forall a b,
 no_sub(C a)=true ->no_sub b=true ->no_sub(C b)=true) /\
 (forall from C,contextlist from C ->forall a b,
 no_sub_list(C a)=true ->no_sub b=true ->no_sub_list(C b)=true).
Proof.
 apply SourceClosure.context_contextlist_ind;intros;
 try match goal with op:binary_operation|-_=>destruct op end;
 cbn[no_sub no_sub_list]in*;nosub_boolean.
Qed.
Lemma no_sub_context_congr:forall from to C,context from to C ->forall a b,
 no_sub(C a)=true ->no_sub b=true ->no_sub(C b)=true.
Proof. exact(proj1 no_sub_context_congr_mut). Qed.
Lemma no_sub_context_hole_mut:
 (forall from to C,context from to C ->forall a,no_sub(C a)=true ->no_sub a=true) /\
 (forall from C,contextlist from C ->forall a,no_sub_list(C a)=true ->no_sub a=true).
Proof.
 apply SourceClosure.context_contextlist_ind;intros;
 try match goal with op:binary_operation|-_=>destruct op end;
 cbn[no_sub no_sub_list]in*;nosub_boolean.
Qed.
Lemma no_sub_context_hole:forall from to C,context from to C ->forall a,
 no_sub(C a)=true ->no_sub a=true.
Proof. exact(proj1 no_sub_context_hole_mut). Qed.
Lemma no_sub_lred:forall ge e a m b mf,lred ge e a m b mf ->no_sub b=true.
Proof. intros;inversion H;reflexivity. Qed.
Lemma no_sub_rred:forall ge a m t b mf,
 no_sub a=true ->rred ge a m t b mf ->no_sub b=true.
Proof.
 intros ge a m t b mf NS RED;inversion RED;subst;cbn[no_sub]in*;nosub_boolean.
 all:repeat match goal with|-context[if ?b then _ else _]=>destruct b;cbn[no_sub]in*;nosub_boolean end.
Qed.
Definition expr_no_sub(s:Csem.state):Prop:=match s with
 | ExprState _ a _ _ _=>no_sub a=true|_=>True end.
Lemma no_sub_estep:forall ge f a k e m t next,
 no_sub a=true ->Csem.estep ge(ExprState f a k e m)t next ->expr_no_sub next.
Proof.
 intros ge f a k e m t next NS STEP;inversion STEP;subst;cbn[expr_no_sub];try exact I.
 - eapply no_sub_context_congr;[eassumption|exact NS|eapply no_sub_lred;eassumption].
 - eapply no_sub_context_congr;[eassumption|exact NS|].
   eapply no_sub_rred;[eapply no_sub_context_hole;[eassumption|exact NS]|eassumption].
Qed.
Lemma no_sub_subtraction_observation:forall ge caller f a k e m,
 no_sub a=true ->subtraction_observation ge caller(ExprState f a k e m).
Proof.
 intros ge caller f a k e m NS FF C x y CT EQ;subst a.
 pose proof(no_sub_context_hole RV RV C CT _ NS)as BAD;discriminate BAD.
Qed.
Print Assumptions no_sub_estep.
