From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Errors Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigRelationSupport Require Import PlainCore Total.
From PprzTrigInitSupport Require Import Control SideEffects.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigCBMC Require Import TypedGuards MathCoverage GuardedCover.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope string_scope.
Definition negate_expr (neg:bool)(a:expr):expr := if neg then Eunop Oneg a tint else a.
Definition negate_int(neg:bool)(a:int):int := if neg then Int.neg a else a.

Lemma quiet_successors_guarded : forall ge Q f a k e m,
  math_guarded ge e m a->quiet_expr a=true ->
  (exists rule t next,
    In (TR rule t next)
      (Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet
        (ExprState f a k e m))) ->
  (forall rule t next,
    In (TR rule t next)
      (Cexec.do_step ge Control.none_callback Control.none_callback Control.quiet
        (ExprState f a k e m)) -> guarded_covers ge Q next) ->
  guarded_covers ge Q (ExprState f a k e m).
Proof.
  intros ge Q f a k e m MATH QUIET [rule [t [next IN]]] ALL.
  assert (CB: callback_free_state (ExprState f a k e m)).
  { apply quiet_no_builtin; exact QUIET. }
  assert (SIL: silent_state ge (ExprState f a k e m))
    by (apply quiet_expression_silent; exact QUIET).
  apply guarded_next;[exact MATH| |].
  - exists t,next.
    apply (proj1 (pure_do_step_exact ge Control.none_callback Control.none_callback
      Control.quiet _ _ _ CB SIL)); exists rule; exact IN.
  - intros u s STEP.
    destruct (proj2 (pure_do_step_exact ge Control.none_callback Control.none_callback
      Control.quiet _ _ _ CB SIL) STEP) as [r R].
    eapply ALL; exact R.
Qed.


Lemma read_call_guarded : forall (ge:Csem.genv)Q f e m k fnid argid targetty returnty target funblock argblock a castarg neg,
 e!fnid=None -> e!argid=Some(argblock,tint) ->
 Genv.find_symbol ge fnid=Some funblock ->
 Cexec.do_deref_loc ge Control.quiet tint m argblock Ptrofs.zero Full=Some(Control.quiet,E0,Vint a) ->
 Genv.find_funct ge(Vptr funblock Ptrofs.zero)=Some(Internal target) ->
 type_of_fundef(Internal target)=Tfunction[targetty]returnty cc_default ->
 sem_cast(Vint(negate_int neg a))tint targetty m=Some castarg ->
 nv returnty=true ->signed32(-Int.signed a)->
 guarded_covers ge Q(Callstate(Internal target)[castarg]
  (Kcall f e (fun x=>negate_expr neg x) returnty k)m) ->
 guarded_covers ge Q(ExprState f
  (negate_expr neg(Ecall
   (Evalof(Evar fnid(Tfunction[targetty]returnty cc_default))(Tfunction[targetty]returnty cc_default))
   (Econs(negate_expr neg(Evalof(Evar argid tint)tint))Enil)returnty))k e m).
Proof.
 intros ge Q f e m k fnid argid targetty returnty target funblock argblock a castarg neg EF EA SYM ARG FUN TY CAST NV BOUND END.
 assert(FADDR:Cexec.do_deref_loc ge Control.quiet(Tfunction[targetty]returnty cc_default)m funblock Ptrofs.zero Full=
   Some(Control.quiet,E0,Vptr funblock Ptrofs.zero))by reflexivity.
 destruct neg;cbn[negate_expr negate_int]in *.
 all:let rec dag :=
   first[exact END|
    eapply quiet_successors_guarded;
    [cbn[math_guarded math_guarded_list];repeat split;intros;
      repeat progress(cbn[branch_rval branch_lval typeof]in *;rewrite ?EF,?EA,?SYM,?ARG,?FADDR,?dec_eq_true in *);
      try contradiction;try discriminate;repeat match goal with H:Some _=Some _|-_=>inversion H;subst;clear H end;
      try exact BOUND;try exact I|
     cbn[quiet_expr quiet_exprlist nv tint type_is_volatile noattr];rewrite NV;reflexivity|
     repeat(progress(cbn[Cexec.do_step Cexec.step_expr Cexec.step_exprlist Cexec.is_val Cexec.is_loc
      Cexec.is_val_list Cexec.incontext Cexec.incontext2 Cexec.topred Cexec.ret Cexec.expr_final_state
      Cexec.sem_cast_arguments classify_fun typeof];
      rewrite ?EF,?EA,?SYM,?ARG,?FADDR,?FUN,?TY,?CAST,?dec_eq_true));
      repeat eexists;cbn[Cexec.expr_final_state];left;reflexivity|
     intros rule trace next IN;
     repeat(progress(cbn[Cexec.do_step Cexec.step_expr Cexec.step_exprlist Cexec.is_val Cexec.is_loc
      Cexec.is_val_list Cexec.incontext Cexec.incontext2 Cexec.topred Cexec.ret Cexec.expr_final_state
      Cexec.sem_cast_arguments classify_fun typeof]in IN;
      rewrite ?EF,?EA,?SYM,?ARG,?FADDR,?FUN,?TY,?CAST,?dec_eq_true in IN));
     cbn in IN;repeat match goal with H:_ \/ _|-_=>destruct H end;
     try contradiction;match goal with H:TR _ _ _=TR _ _ _|-_=>inversion H;subst;clear H end;dag]]
 in dag.
Qed.
