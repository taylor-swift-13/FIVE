From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
Import ListNotations.
Module S:=PidPositionRunPos.Source.
Definition local_err_a:ident:=100001%positive.
Definition local_final_a:ident:=100002%positive.
Definition local_integral_a:ident:=100003%positive.
Definition local_ra:ident:=100004%positive.
Definition local_rb:ident:=100005%positive.
Definition local_a:ident:=100006%positive.
Definition local_b:ident:=100007%positive.
Definition local_dx:ident:=100008%positive.
Definition local_dy:ident:=100009%positive.
Definition object(id:ident)(ty:type):expr:=Evalof(Evar id ty)ty.
Definition member(base:expr)(id:ident)(ty:type):expr:=Evalof(Efield base id ty)ty.
Definition vector_axis(base:expr)(axis:ident):expr:=member base axis tint.
Definition pid_cmd(id axis:ident):expr:=vector_axis(member(object id pid_type)S._cmd_earth vec_type)axis.
Definition sp_ltp(id:ident):expr:=member(member(object id sp_type)S._sp(Tunion S.__1097 noattr))S._ltp_i(Tstruct S.__1098 noattr).
Definition sp_axis(id axis:ident):expr:=vector_axis(member(sp_ltp id)S._vect vec_type)axis.
Definition sp_heading(id:ident):expr:=member(sp_ltp id)S._heading tint.
Definition gh_pos(id axis:ident):expr:=
 vector_axis(member(member(object id gh_type)S._ref(Tstruct S._HorizontalGuidanceReference noattr))S._pos vec_type)axis.
Definition eq32(a b:expr):expr:=Ebinop Oeq a b tint.
Definition both(a b:expr):expr:=Eseqand a b tint.
(** These are the six original harness assertion arguments. Only the
    harness local identifiers are alpha-renamed; source global identifiers,
    field identifiers, aggregate/union types and short-circuit nesting remain. *)
Definition assertion_1:=both
 (eq32(vector_axis(object S._guidance_pid_pos_err vec_type)S._x)(vector_axis(object local_err_a vec_type)S._x))
 (eq32(vector_axis(object S._guidance_pid_pos_err vec_type)S._y)(vector_axis(object local_err_a vec_type)S._y)).
Definition assertion_2:=both(eq32(pid_cmd S._guidance_pid S._x)(pid_cmd local_final_a S._x))
 (eq32(pid_cmd S._guidance_pid S._y)(pid_cmd local_final_a S._y)).
Definition assertion_3:=both
 (eq32(vector_axis(object S._guidance_pid_trim_att_integrator vec_type)S._x)(vector_axis(object local_integral_a vec_type)S._x))
 (eq32(vector_axis(object S._guidance_pid_trim_att_integrator vec_type)S._y)(vector_axis(object local_integral_a vec_type)S._y)).
Definition assertion_4:=both
 (eq32(member(object local_ra sp_type)S._type tint)(member(object local_rb sp_type)S._type tint))
 (eq32(member(object local_ra sp_type)S._format tint)(member(object local_rb sp_type)S._format tint)).
Definition assertion_5:=both
 (both(eq32(sp_axis local_ra S._x)(sp_axis local_rb S._x))
      (eq32(sp_axis local_ra S._y)(sp_axis local_rb S._y)))
 (eq32(sp_heading local_ra)(sp_heading local_rb)).
Definition assertion_6:=both
 (eq32(Ebinop Oadd(gh_pos local_a S._x)(object local_dx tint)tint)(gh_pos local_b S._x))
 (eq32(Ebinop Oadd(gh_pos local_a S._y)(object local_dy tint)tint)(gh_pos local_b S._y)).
Inductive assertion_true(ge:genv)(e:env)(m:mem):expr->Prop:=
| at_simple:forall a,typeof a=tint ->eval_simple_rvalue ge e m a(Vint Int.one) ->assertion_true ge e m a
| at_both:forall a b,assertion_true ge e m a ->assertion_true ge e m b ->assertion_true ge e m(both a b).
Lemma assertion_true_type:forall ge e m a,assertion_true ge e m a ->typeof a=tint.
Proof. intros;inversion H;subst;assumption||reflexivity. Qed.
Theorem assertion_true_steps:forall ge e m a,
 assertion_true ge e m a ->forall f k C,context RV RV C ->
 star Csem.step ge(ExprState f(C a)k e m)E0
 (ExprState f(C(Eval(Vint Int.one)tint))k e m).
Proof.
 intros ge e m a TRUE;induction TRUE;intros f k C CT.
 - rewrite <-H;apply(Cstrategy.eval_simple_rvalue_steps ge f k e m a(Vint Int.one)H0 C CT).
 - pose proof(assertion_true_type _ _ _ _ TRUE1)as TA.
   pose proof(assertion_true_type _ _ _ _ TRUE2)as TB.
   eapply star_trans with(s2:=ExprState f(C(Eseqand(Eval(Vint Int.one)tint)b tint))k e m)(t1:=E0)(t2:=E0).
   + apply(IHTRUE1 f k(fun x=>C(Eseqand x b tint))). apply context_compose with(k2:=RV);[exact CT|constructor;constructor].
   + eapply star_step with(s2:=ExprState f(C(Eparen b type_bool tint))k e m)(t1:=E0)(t2:=E0).
     * left;eapply step_rred;[apply red_seqand_true;reflexivity|exact CT].
     * eapply star_trans with(s2:=ExprState f(C(Eparen(Eval(Vint Int.one)tint)type_bool tint))k e m)(t1:=E0)(t2:=E0).
       -- apply(IHTRUE2 f k(fun x=>C(Eparen x type_bool tint))). apply context_compose with(k2:=RV);[exact CT|constructor;constructor].
       -- apply star_one;left;eapply step_rred;[apply red_paren;reflexivity|exact CT].
       -- reflexivity.
     * reflexivity.
   + reflexivity.
Qed.
Lemma int32_eq_one:forall(ge:genv)m x,
 sem_binary_operation ge Oeq(Vint x)tint(Vint x)tint m=Some(Vint Int.one).
Proof. intros;change(Some(Val.of_bool(Int.eq x x))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity. Qed.
Print Assumptions assertion_true_steps.
