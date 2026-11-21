From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Errors Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigRelationSupport Require Import PlainCore Total.
From PprzTrigInitSupport Require Import Control SideEffects.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope string_scope.
Definition negate_expr (neg:bool)(a:expr):expr := if neg then Eunop Oneg a tint else a.
Definition negate_int(neg:bool)(a:int):int := if neg then Int.neg a else a.

Lemma read_call_total : forall (ge:Csem.genv)Q f e m k fnid argid targetty returnty target funblock argblock a castarg neg,
 e!fnid=None -> e!argid=Some(argblock,tint) ->
 Genv.find_symbol ge fnid=Some funblock ->
 Cexec.do_deref_loc ge Control.quiet tint m argblock Ptrofs.zero Full=Some(Control.quiet,E0,Vint a) ->
 Genv.find_funct ge(Vptr funblock Ptrofs.zero)=Some(Internal target) ->
 type_of_fundef(Internal target)=Tfunction[targetty]returnty cc_default ->
 sem_cast(Vint(negate_int neg a))tint targetty m=Some castarg ->
 nv returnty=true ->
 Total.total ge Q(Callstate(Internal target)[castarg]
  (Kcall f e (fun x=>negate_expr neg x) returnty k)m) ->
 Total.total ge Q(ExprState f
  (negate_expr neg(Ecall
   (Evalof(Evar fnid(Tfunction[targetty]returnty cc_default))(Tfunction[targetty]returnty cc_default))
   (Econs(negate_expr neg(Evalof(Evar argid tint)tint))Enil)returnty))k e m).
Proof.
 intros ge Q f e m k fnid argid targetty returnty target funblock argblock a castarg neg EF EA SYM ARG FUN TY CAST NV END.
 assert(FADDR:Cexec.do_deref_loc ge Control.quiet(Tfunction[targetty]returnty cc_default)m funblock Ptrofs.zero Full=
   Some(Control.quiet,E0,Vptr funblock Ptrofs.zero))by reflexivity.
 destruct neg;cbn[negate_expr negate_int]in *.
 all:let rec dag :=
   first[exact END|
    eapply quiet_successors_total;
    [cbn[quiet_expr quiet_exprlist nv tint type_is_volatile noattr];rewrite NV;reflexivity|
     repeat(progress(cbn[Cexec.do_step Cexec.step_expr Cexec.step_exprlist Cexec.is_val Cexec.is_loc
      Cexec.is_val_list Cexec.incontext Cexec.incontext2 Cexec.topred Cexec.ret
      Cexec.sem_cast_arguments classify_fun typeof];
      rewrite ?EF,?EA,?SYM,?ARG,?FADDR,?FUN,?TY,?CAST,?dec_eq_true));
      repeat eexists;simpl;eauto|
     intros rule trace next IN;
     repeat(progress(cbn[Cexec.do_step Cexec.step_expr Cexec.step_exprlist Cexec.is_val Cexec.is_loc
      Cexec.is_val_list Cexec.incontext Cexec.incontext2 Cexec.topred Cexec.ret
      Cexec.sem_cast_arguments classify_fun typeof]in IN;
      rewrite ?EF,?EA,?SYM,?ARG,?FADDR,?FUN,?TY,?CAST,?dec_eq_true in IN));
     cbn in IN;repeat match goal with H:_ \/ _|-_=>destruct H end;
     try contradiction;match goal with H:TR _ _ _=TR _ _ _|-_=>inversion H;subst;clear H end;dag]]
 in dag.
Show.
Qed.
