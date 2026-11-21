From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From FiveGuidanceSemantics Require Import SourceClosure.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From PidPositionSafety Require Import GetterAssignmentShell TaggedCallee.
From CoreCBMC Require Import NumericBounds ArithmeticTree ArithmeticAtomic.
Fixpoint no_ready_binary(a:expr):bool:=match a with
| Eval _ _|Evar _ _|Eloc _ _ _ _|Esizeof _ _|Ealignof _ _=>true
| Evalof a _|Ederef a _|Eaddrof a _|Efield a _ _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>no_ready_binary a
| Ebinop _ a b _=>negb(literal RV a&&literal RV b)&&no_ready_binary a&&no_ready_binary b
| Eassign a b _|Eassignop _ a b _ _|Eseqand a b _|Eseqor a b _|Ecomma a b _=>no_ready_binary a&&no_ready_binary b
| Econdition c a b _=>no_ready_binary c&&no_ready_binary a&&no_ready_binary b
| Ecall a al _=>no_ready_binary a&&no_ready_binary_list al
| Ebuiltin _ _ al _=>no_ready_binary_list al
end
with no_ready_binary_list(al:exprlist):bool:=match al with
| Enil=>true|Econs a al=>no_ready_binary a&&no_ready_binary_list al end.
Lemma no_ready_context_mut:
 (forall from to C,context from to C ->forall a,
 no_ready_binary(C a)=true ->no_ready_binary a=true) /\
 (forall from C,contextlist from C ->forall a,
 no_ready_binary_list(C a)=true ->no_ready_binary a=true).
Proof.
 apply SourceClosure.context_contextlist_ind;cbn[no_ready_binary no_ready_binary_list];intros;core_unpack;eauto.
Qed.
Lemma no_ready_context:forall from to C,context from to C ->forall a,
 no_ready_binary(C a)=true ->no_ready_binary a=true.
Proof. exact(proj1 no_ready_context_mut). Qed.
Theorem getter_pre_no_ready:
 forall ghid refid vectid nedid axis iref icomponent ierr igh igetter
 berr bparam bgh bgetter dref dcomponent daxis reference ls rs fs,
 no_ready_binary(GetterAssignmentShell.pre_expr ghid refid vectid nedid axis iref icomponent ierr igh igetter
 berr bparam bgh bgetter dref dcomponent daxis reference ls rs fs)=true.
Proof. intros;destruct ls,rs,fs;reflexivity. Qed.
Definition subtraction_observation(ge:genv)(caller:function)(s:Csem.state):Prop:=
 match s with
 | ExprState f a k e m=>f=caller ->forall C x y,
 context RV RV C ->a=C(Ebinop Osub(Eval(Vint x)tint)(Eval(Vint y)tint)tint) ->
 NumericBounds.signed32(Int.signed x-Int.signed y)
 | _=>True end.
Lemma no_ready_subtraction_observation:forall ge caller f a k e m,
 no_ready_binary a=true ->subtraction_observation ge caller(ExprState f a k e m).
Proof.
 intros ge caller f a k e m NR FF C x y CT EQ;subst a.
 pose proof(no_ready_context RV RV C CT _ NR)as BAD;discriminate BAD.
Qed.
Lemma arithmetic_subtraction_observation:forall ge caller f a k e m,
 arithmetic_tree ge e m a ->subtraction_observation ge caller(ExprState f a k e m).
Proof.
 intros ge caller f a k e m TREE FF C x y CT EQ;subst a.
 pose proof(arithmetic_observed_binary ge e m RV C Osub(Vint x)tint(Vint y)tint tint CT eq_refl TREE)as SAFE.
 cbn[binary_safe]in SAFE;rewrite dec_eq_true in SAFE;exact SAFE.
Qed.
Lemma scope_subtraction_observation:forall ge caller leaf s,
 leaf<>caller ->function_scope leaf s ->subtraction_observation ge caller s.
Proof.
 intros ge caller leaf s DIFF SC;destruct s;cbn[function_scope subtraction_observation]in*;try exact I.
 intros EQ;congruence.
Qed.
Lemma atomic_subtraction_observation:forall ge caller e k mf result s,
 arithmetic_atomic_invariant ge caller e k mf result s ->subtraction_observation ge caller s.
Proof.
 intros ge caller e k mf result s INV;destruct s;try exact I.
 apply arithmetic_subtraction_observation;eapply arithmetic_atomic_observation;exact INV.
Qed.
Print Assumptions getter_pre_no_ready.
Print Assumptions atomic_subtraction_observation.
