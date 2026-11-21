From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Ctypes Ctypesdefs Cop Csyntax Csem.
From PprzTrigRelationSupport Require Import PlainBody BranchPure PureEval.
From PprzTrigCBMC Require Import TypedGuards SourceObservations SineGuards MathCoverage.
Local Open Scope Z_scope.
Lemma math_binop : forall ge e m op l r ty vl vr,
 math_guarded ge e m l->math_guarded ge e m r->
 branch_rval ge e m l=Some vl->branch_rval ge e m r=Some vr->binary_math_guard op vl vr->
 math_guarded ge e m(Ebinop op l r ty).
Proof.
 intros ge e m op l r ty vl vr GL GR VL VR G;cbn[math_guarded];split;[exact GL|]. split;[exact GR|].
 intros v w L R;rewrite VL in L;rewrite VR in R;inversion L;inversion R;subst;exact G.
Qed.
Lemma math_unop : forall ge e m op a ty v,
 math_guarded ge e m a->branch_rval ge e m a=Some v->unary_math_guard op v->math_guarded ge e m(Eunop op a ty).
Proof.
 intros ge e m op a ty v GA V G;cbn[math_guarded];split;[exact GA|].
 intros w W;rewrite V in W;inversion W;subst;exact G.
Qed.
Lemma math_multiply : forall ge e m l r ty,
 math_guarded ge e m l->math_guarded ge e m r->math_guarded ge e m(Ebinop Omul l r ty).
Proof.
 intros ge e m l r ty L R;cbn[math_guarded];split;[exact L|]. split;[exact R|].
 intros v w EV EW;destruct v,w;exact I.
Qed.
Definition source_scale:=match PlainBody.pi_expr with Ecast(Ebinop _ _ scale _) _=>scale|_=>Eval Vundef tint end.
Definition source_pi_literal:=match PlainBody.pi_expr with Ecast(Ebinop _ literal _ _) _=>literal|_=>Eval Vundef tint end.
Definition source_halfpi_literal:=match PlainBody.halfpi_expr with Ecast(Ebinop _ literal _ _) _=>literal|_=>Eval Vundef tint end.
Lemma source_scale_math : forall ge e m,math_guarded ge e m source_scale.
Proof.
 intros ge e m;change(math_guarded ge e m(Ebinop Oshl(Eval(Vint(Int.repr 1))tint)(Eval(Vint(Int.repr 12))tint)tint)).
 eapply math_binop;[exact I|exact I|reflexivity|reflexivity|].
 change(0<=1 /\0<=12<32 /\signed32(1*2^12));unfold signed32;cbn;lia.
Qed.
Lemma pi_math : forall ge e m,math_guarded ge e m PlainBody.pi_expr.
Proof.
 intros ge e m;change(math_guarded ge e m(Ebinop Omul source_pi_literal source_scale(Tfloat F64 noattr))).
 apply math_multiply;[exact I|apply source_scale_math].
Qed.
Lemma halfpi_math : forall ge e m,math_guarded ge e m PlainBody.halfpi_expr.
Proof.
 intros ge e m;change(math_guarded ge e m(Ebinop Omul source_halfpi_literal source_scale(Tfloat F64 noattr))).
 apply math_multiply;[exact I|apply source_scale_math].
Qed.
Lemma negative_pi_math : forall ge e m,
 math_guarded ge e m(Eunop Oneg PlainBody.pi_expr tint) /\
 branch_rval ge e m(Eunop Oneg PlainBody.pi_expr tint)=Some(Vint(Int.repr(-12867))).
Proof.
 intros ge e m;split.
 - eapply math_unop;[apply pi_math|exact(PlainBody.pi_expr_value ge e m)|]. change(signed32(-12867));unfold signed32;lia.
 - change(match branch_rval ge e m PlainBody.pi_expr with Some v=>sem_unary_operation Oneg v tint m|_=>None end=Some(Vint(Int.repr(-12867)))).
   change(match pure_rval ge e m PlainBody.pi_expr with Some v=>sem_unary_operation Oneg v tint m|_=>None end=Some(Vint(Int.repr(-12867)))).
   rewrite PlainBody.pi_expr_value;reflexivity.
Qed.
Lemma negative_halfpi_math : forall ge e m,
 math_guarded ge e m(Eunop Oneg PlainBody.halfpi_expr tint) /\
 branch_rval ge e m(Eunop Oneg PlainBody.halfpi_expr tint)=Some(Vint(Int.repr(-6433))).
Proof.
 intros ge e m;split.
 - eapply math_unop;[apply halfpi_math|exact(PlainBody.halfpi_expr_value ge e m)|]. change(signed32(-6433));unfold signed32;lia.
 - change(match branch_rval ge e m PlainBody.halfpi_expr with Some v=>sem_unary_operation Oneg v tint m|_=>None end=Some(Vint(Int.repr(-6433)))).
   change(match pure_rval ge e m PlainBody.halfpi_expr with Some v=>sem_unary_operation Oneg v tint m|_=>None end=Some(Vint(Int.repr(-6433)))).
   rewrite PlainBody.halfpi_expr_value;reflexivity.
Qed.
Theorem sine_front_math_guards : forall ge local m a,
 -12867<=Int.signed a<=12867 ->Mem.load Mint32 m local 0=Some(Vint a)->
 math_guarded ge(angle_env local)m upper_guard /\math_guarded ge(angle_env local)m lower_guard /\
 math_guarded ge(angle_env local)m fold_guard /\math_guarded ge(angle_env local)m fold_negative_guard /\
 math_guarded ge(angle_env local)m rhs_positive /\math_guarded ge(angle_env local)m rhs_negative.
Proof.
 intros ge local m a RANGE LOAD.
 assert(READ:branch_rval ge(angle_env local)m read_angle=Some(Vint a))by(exact(angle_read ge local m a LOAD)).
 assert(UP:math_guarded ge(angle_env local)m upper_guard).
 { change(math_guarded ge(angle_env local)m(Ebinop Ogt read_angle pi_expr tint)).
   eapply math_binop;[exact I|apply pi_math|exact READ|exact(pi_expr_value _ _ _)|exact I]. }
 assert(LOW:math_guarded ge(angle_env local)m lower_guard).
 { change(math_guarded ge(angle_env local)m(Ebinop Olt read_angle(Eunop Oneg pi_expr tint)tint)).
   eapply math_binop;[exact I|apply(proj1(negative_pi_math _ _ _))|exact READ|apply(proj2(negative_pi_math _ _ _))|exact I]. }
 assert(FOLD:math_guarded ge(angle_env local)m fold_guard).
 { change(math_guarded ge(angle_env local)m(Ebinop Ogt read_angle halfpi_expr tint)).
   eapply math_binop;[exact I|apply halfpi_math|exact READ|exact(halfpi_expr_value _ _ _)|exact I]. }
 assert(NEG:math_guarded ge(angle_env local)m fold_negative_guard).
 { change(math_guarded ge(angle_env local)m(Ebinop Olt read_angle(Eunop Oneg halfpi_expr tint)tint)).
   eapply math_binop;[exact I|apply(proj1(negative_halfpi_math _ _ _))|exact READ|apply(proj2(negative_halfpi_math _ _ _))|exact I]. }
 assert(POSR:math_guarded ge(angle_env local)m rhs_positive).
 { change(math_guarded ge(angle_env local)m(Ebinop Osub pi_expr read_angle tint)).
   eapply math_binop;[apply pi_math|exact I|exact(pi_expr_value _ _ _)|exact READ|].
   change(signed32(12867-Int.signed a));unfold signed32;lia. }
 assert(NEGR:math_guarded ge(angle_env local)m rhs_negative).
 { change(math_guarded ge(angle_env local)m(Ebinop Osub(Eunop Oneg pi_expr tint)read_angle tint)).
   eapply math_binop;[apply(proj1(negative_pi_math _ _ _))|exact I|apply(proj2(negative_pi_math _ _ _))|exact READ|].
   change(signed32(-12867-Int.signed a));unfold signed32;lia. }
 repeat first[assumption|split].
Qed.
Print Assumptions sine_front_math_guards.
