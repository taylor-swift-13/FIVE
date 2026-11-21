From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Errors Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From PprzTrigRelationSupport Require Import PlainCore Total InitState.
From PprzTrigInitSupport Require Import Control SideEffects PostIncrement EncoderMemory.
Import ListNotations.
Local Open Scope string_scope.
Definition four_function_type := Tfunction[short_type;short_type;short_type;pointer_type]Tvoid cc_default.
Definition function_stage(fnid:ident)(fb:block)(n:nat):expr :=
  match n with
  | O=>Evalof(Evar fnid four_function_type)four_function_type
  | S O=>Evalof(Eloc fb Ptrofs.zero Full four_function_type)four_function_type
  | _=>Eval(Vptr fb Ptrofs.zero)four_function_type end.
Definition read_stage(id:ident)(b:block)(z:Z)(n:nat):expr :=
  match n with
  | O=>Evalof(Evar id short_type)short_type
  | S O=>Evalof(Eloc b Ptrofs.zero Full short_type)short_type
  | _=>Eval(Vint(Int.repr z))short_type end.
Definition address_stage(id:ident)(b:block)(n:nat):expr :=
  match n with
  | O=>Eaddrof(Evar id short_type)pointer_type
  | S O=>Eaddrof(Eloc b Ptrofs.zero Full short_type)pointer_type
  | _=>Eval(Vptr b Ptrofs.zero)pointer_type end.
Definition four_call(fnid vpid ppid cpid tpid:ident)(fb vb pb cb tb:block)
  (v p c:Z)(s0 s1 s2 s3 s4:nat):expr :=
  Ecall(function_stage fnid fb s0)
    (Econs(read_stage vpid vb v s1)
    (Econs(read_stage ppid pb p s2)
    (Econs(read_stage cpid cb c s3)
    (Econs(address_stage tpid tb s4)Enil))))Tvoid.

Theorem four_argument_call_total : forall (ge:Csem.genv) Q f e m k target fnid vpid ppid cpid tpid
  fb vb pb cb tb v p c,
  e!fnid=None ->e!vpid=Some(vb,short_type) ->e!ppid=Some(pb,short_type) ->
  e!cpid=Some(cb,short_type) ->e!tpid=Some(tb,short_type) ->
  Mem.load Mint16signed m vb 0=Some(Vint(Int.repr v)) ->
  Mem.load Mint16signed m pb 0=Some(Vint(Int.repr p)) ->
  Mem.load Mint16signed m cb 0=Some(Vint(Int.repr c)) ->
  (0<=v<=16383)%Z ->(0<=p<=16383)%Z ->(0<=c<=16383)%Z ->
  Genv.find_symbol ge fnid=Some fb ->
  Genv.find_funct ge(Vptr fb Ptrofs.zero)=Some(Internal target) ->
  type_of_fundef(Internal target)=four_function_type ->
  Total.total ge Q(Callstate(Internal target)
    [Vint(Int.repr v);Vint(Int.repr p);Vint(Int.repr c);Vptr tb Ptrofs.zero]
    (Kcall f e(fun x=>x)Tvoid k)m) ->
  Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 0 0)k e m).
Proof.
  intros ge Q f e m k target fnid vpid ppid cpid tpid fb vb pb cb tb v p c
    EF EV EP EC ET LV LP LC BV BP BC SYM FUN TY END.
  assert(FADDR:Cexec.do_deref_loc ge Control.quiet four_function_type m fb Ptrofs.zero Full=
    Some(Control.quiet,E0,Vptr fb Ptrofs.zero))by reflexivity.
  pose proof(short_deref ge Control.quiet m vb v LV)as RV.
  pose proof(short_deref ge Control.quiet m pb p LP)as RP.
  pose proof(short_deref ge Control.quiet m cb c LC)as RC.
  assert(CV:sem_cast(Vint(Int.repr v))short_type short_type m=Some(Vint(Int.repr v))).
  { change (Some (Vint (Int.sign_ext 16 (Int.repr v))) = Some (Vint (Int.repr v))).
    rewrite nonnegative_short_cast by exact BV;reflexivity. }
  assert(CP:sem_cast(Vint(Int.repr p))short_type short_type m=Some(Vint(Int.repr p))).
  { change (Some (Vint (Int.sign_ext 16 (Int.repr p))) = Some (Vint (Int.repr p))).
    rewrite nonnegative_short_cast by exact BP;reflexivity. }
  assert(CC:sem_cast(Vint(Int.repr c))short_type short_type m=Some(Vint(Int.repr c))).
  { change (Some (Vint (Int.sign_ext 16 (Int.repr c))) = Some (Vint (Int.repr c))).
    rewrite nonnegative_short_cast by exact BC;reflexivity. }
  assert(CT:sem_cast(Vptr tb Ptrofs.zero)pointer_type pointer_type m=Some(Vptr tb Ptrofs.zero))by reflexivity.
  let edge :=
    eapply quiet_successors_total;
    [cbn[four_call function_stage read_stage address_stage quiet_expr quiet_exprlist
      nv short_type pointer_type four_function_type type_is_volatile noattr];reflexivity|
     repeat(progress(cbn[four_call four_function_type function_stage read_stage address_stage Cexec.do_step Cexec.step_expr
       Cexec.step_exprlist Cexec.is_val Cexec.is_loc Cexec.is_val_list Cexec.incontext Cexec.incontext2
       Cexec.topred Cexec.ret Cexec.expr_final_state Cexec.sem_cast_arguments classify_fun typeof];
       rewrite ?EF,?EV,?EP,?EC,?ET,?SYM,?RV,?RP,?RC,?FADDR,?FUN,?TY,?CV,?CP,?CC,?CT,?dec_eq_true));
       repeat eexists;cbn[Cexec.expr_final_state];left;reflexivity|
     intros rule trace next IN;
     repeat(progress(cbn[four_call four_function_type function_stage read_stage address_stage Cexec.do_step Cexec.step_expr
       Cexec.step_exprlist Cexec.is_val Cexec.is_loc Cexec.is_val_list Cexec.incontext Cexec.incontext2
       Cexec.topred Cexec.ret Cexec.expr_final_state Cexec.sem_cast_arguments classify_fun typeof]in IN;
       rewrite ?EF,?EV,?EP,?EC,?ET,?SYM,?RV,?RP,?RC,?FADDR,?FUN,?TY,?CV,?CP,?CC,?CT,?dec_eq_true in IN));
     cbn in IN;repeat match goal with H:_ \/ _|-_=>destruct H end;try contradiction;
     match goal with H:TR _ _ _=TR _ _ _|-_=>inversion H;subst;clear H end;
     cbv beta iota zeta delta[fst snd];first[exact END|eassumption]] in
  assert(J_22222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 2 2)k e m))by edge;
  assert(J_22221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 2 1)k e m))by edge;
  assert(J_22212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 1 2)k e m))by edge;
  assert(J_22122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 2 2)k e m))by edge;
  assert(J_21222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 2 2)k e m))by edge;
  assert(J_12222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 2 2)k e m))by edge;
  assert(J_22220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 2 0)k e m))by edge;
  assert(J_22211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 1 1)k e m))by edge;
  assert(J_22202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 0 2)k e m))by edge;
  assert(J_22121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 2 1)k e m))by edge;
  assert(J_22112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 1 2)k e m))by edge;
  assert(J_22022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 2 2)k e m))by edge;
  assert(J_21221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 2 1)k e m))by edge;
  assert(J_21212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 1 2)k e m))by edge;
  assert(J_21122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 2 2)k e m))by edge;
  assert(J_20222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 2 2)k e m))by edge;
  assert(J_12221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 2 1)k e m))by edge;
  assert(J_12212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 1 2)k e m))by edge;
  assert(J_12122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 2 2)k e m))by edge;
  assert(J_11222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 2 2)k e m))by edge;
  assert(J_02222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 2 2)k e m))by edge;
  assert(J_22210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 1 0)k e m))by edge;
  assert(J_22201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 0 1)k e m))by edge;
  assert(J_22120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 2 0)k e m))by edge;
  assert(J_22111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 1 1)k e m))by edge;
  assert(J_22102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 0 2)k e m))by edge;
  assert(J_22021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 2 1)k e m))by edge;
  assert(J_22012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 1 2)k e m))by edge;
  assert(J_21220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 2 0)k e m))by edge;
  assert(J_21211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 1 1)k e m))by edge;
  assert(J_21202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 0 2)k e m))by edge;
  assert(J_21121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 2 1)k e m))by edge;
  assert(J_21112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 1 2)k e m))by edge;
  assert(J_21022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 2 2)k e m))by edge;
  assert(J_20221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 2 1)k e m))by edge;
  assert(J_20212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 1 2)k e m))by edge;
  assert(J_20122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 2 2)k e m))by edge;
  assert(J_12220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 2 0)k e m))by edge;
  assert(J_12211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 1 1)k e m))by edge;
  assert(J_12202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 0 2)k e m))by edge;
  assert(J_12121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 2 1)k e m))by edge;
  assert(J_12112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 1 2)k e m))by edge;
  assert(J_12022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 2 2)k e m))by edge;
  assert(J_11221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 2 1)k e m))by edge;
  assert(J_11212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 1 2)k e m))by edge;
  assert(J_11122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 2 2)k e m))by edge;
  assert(J_10222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 2 2)k e m))by edge;
  assert(J_02221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 2 1)k e m))by edge;
  assert(J_02212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 1 2)k e m))by edge;
  assert(J_02122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 2 2)k e m))by edge;
  assert(J_01222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 2 2)k e m))by edge;
  assert(J_22200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 2 0 0)k e m))by edge;
  assert(J_22110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 1 0)k e m))by edge;
  assert(J_22101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 0 1)k e m))by edge;
  assert(J_22020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 2 0)k e m))by edge;
  assert(J_22011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 1 1)k e m))by edge;
  assert(J_22002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 0 2)k e m))by edge;
  assert(J_21210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 1 0)k e m))by edge;
  assert(J_21201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 0 1)k e m))by edge;
  assert(J_21120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 2 0)k e m))by edge;
  assert(J_21111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 1 1)k e m))by edge;
  assert(J_21102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 0 2)k e m))by edge;
  assert(J_21021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 2 1)k e m))by edge;
  assert(J_21012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 1 2)k e m))by edge;
  assert(J_20220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 2 0)k e m))by edge;
  assert(J_20211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 1 1)k e m))by edge;
  assert(J_20202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 0 2)k e m))by edge;
  assert(J_20121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 2 1)k e m))by edge;
  assert(J_20112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 1 2)k e m))by edge;
  assert(J_20022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 2 2)k e m))by edge;
  assert(J_12210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 1 0)k e m))by edge;
  assert(J_12201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 0 1)k e m))by edge;
  assert(J_12120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 2 0)k e m))by edge;
  assert(J_12111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 1 1)k e m))by edge;
  assert(J_12102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 0 2)k e m))by edge;
  assert(J_12021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 2 1)k e m))by edge;
  assert(J_12012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 1 2)k e m))by edge;
  assert(J_11220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 2 0)k e m))by edge;
  assert(J_11211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 1 1)k e m))by edge;
  assert(J_11202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 0 2)k e m))by edge;
  assert(J_11121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 2 1)k e m))by edge;
  assert(J_11112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 1 2)k e m))by edge;
  assert(J_11022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 2 2)k e m))by edge;
  assert(J_10221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 2 1)k e m))by edge;
  assert(J_10212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 1 2)k e m))by edge;
  assert(J_10122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 2 2)k e m))by edge;
  assert(J_02220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 2 0)k e m))by edge;
  assert(J_02211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 1 1)k e m))by edge;
  assert(J_02202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 0 2)k e m))by edge;
  assert(J_02121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 2 1)k e m))by edge;
  assert(J_02112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 1 2)k e m))by edge;
  assert(J_02022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 2 2)k e m))by edge;
  assert(J_01221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 2 1)k e m))by edge;
  assert(J_01212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 1 2)k e m))by edge;
  assert(J_01122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 2 2)k e m))by edge;
  assert(J_00222:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 2 2)k e m))by edge;
  assert(J_22100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 1 0 0)k e m))by edge;
  assert(J_22010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 1 0)k e m))by edge;
  assert(J_22001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 0 1)k e m))by edge;
  assert(J_21200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 2 0 0)k e m))by edge;
  assert(J_21110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 1 0)k e m))by edge;
  assert(J_21101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 0 1)k e m))by edge;
  assert(J_21020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 2 0)k e m))by edge;
  assert(J_21011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 1 1)k e m))by edge;
  assert(J_21002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 0 2)k e m))by edge;
  assert(J_20210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 1 0)k e m))by edge;
  assert(J_20201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 0 1)k e m))by edge;
  assert(J_20120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 2 0)k e m))by edge;
  assert(J_20111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 1 1)k e m))by edge;
  assert(J_20102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 0 2)k e m))by edge;
  assert(J_20021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 2 1)k e m))by edge;
  assert(J_20012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 1 2)k e m))by edge;
  assert(J_12200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 2 0 0)k e m))by edge;
  assert(J_12110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 1 0)k e m))by edge;
  assert(J_12101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 0 1)k e m))by edge;
  assert(J_12020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 2 0)k e m))by edge;
  assert(J_12011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 1 1)k e m))by edge;
  assert(J_12002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 0 2)k e m))by edge;
  assert(J_11210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 1 0)k e m))by edge;
  assert(J_11201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 0 1)k e m))by edge;
  assert(J_11120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 2 0)k e m))by edge;
  assert(J_11111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 1 1)k e m))by edge;
  assert(J_11102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 0 2)k e m))by edge;
  assert(J_11021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 2 1)k e m))by edge;
  assert(J_11012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 1 2)k e m))by edge;
  assert(J_10220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 2 0)k e m))by edge;
  assert(J_10211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 1 1)k e m))by edge;
  assert(J_10202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 0 2)k e m))by edge;
  assert(J_10121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 2 1)k e m))by edge;
  assert(J_10112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 1 2)k e m))by edge;
  assert(J_10022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 2 2)k e m))by edge;
  assert(J_02210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 1 0)k e m))by edge;
  assert(J_02201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 0 1)k e m))by edge;
  assert(J_02120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 2 0)k e m))by edge;
  assert(J_02111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 1 1)k e m))by edge;
  assert(J_02102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 0 2)k e m))by edge;
  assert(J_02021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 2 1)k e m))by edge;
  assert(J_02012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 1 2)k e m))by edge;
  assert(J_01220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 2 0)k e m))by edge;
  assert(J_01211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 1 1)k e m))by edge;
  assert(J_01202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 0 2)k e m))by edge;
  assert(J_01121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 2 1)k e m))by edge;
  assert(J_01112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 1 2)k e m))by edge;
  assert(J_01022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 2 2)k e m))by edge;
  assert(J_00221:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 2 1)k e m))by edge;
  assert(J_00212:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 1 2)k e m))by edge;
  assert(J_00122:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 2 2)k e m))by edge;
  assert(J_22000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 2 0 0 0)k e m))by edge;
  assert(J_21100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 1 0 0)k e m))by edge;
  assert(J_21010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 1 0)k e m))by edge;
  assert(J_21001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 0 1)k e m))by edge;
  assert(J_20200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 2 0 0)k e m))by edge;
  assert(J_20110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 1 0)k e m))by edge;
  assert(J_20101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 0 1)k e m))by edge;
  assert(J_20020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 2 0)k e m))by edge;
  assert(J_20011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 1 1)k e m))by edge;
  assert(J_20002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 0 2)k e m))by edge;
  assert(J_12100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 1 0 0)k e m))by edge;
  assert(J_12010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 1 0)k e m))by edge;
  assert(J_12001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 0 1)k e m))by edge;
  assert(J_11200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 2 0 0)k e m))by edge;
  assert(J_11110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 1 0)k e m))by edge;
  assert(J_11101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 0 1)k e m))by edge;
  assert(J_11020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 2 0)k e m))by edge;
  assert(J_11011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 1 1)k e m))by edge;
  assert(J_11002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 0 2)k e m))by edge;
  assert(J_10210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 1 0)k e m))by edge;
  assert(J_10201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 0 1)k e m))by edge;
  assert(J_10120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 2 0)k e m))by edge;
  assert(J_10111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 1 1)k e m))by edge;
  assert(J_10102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 0 2)k e m))by edge;
  assert(J_10021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 2 1)k e m))by edge;
  assert(J_10012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 1 2)k e m))by edge;
  assert(J_02200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 2 0 0)k e m))by edge;
  assert(J_02110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 1 0)k e m))by edge;
  assert(J_02101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 0 1)k e m))by edge;
  assert(J_02020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 2 0)k e m))by edge;
  assert(J_02011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 1 1)k e m))by edge;
  assert(J_02002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 0 2)k e m))by edge;
  assert(J_01210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 1 0)k e m))by edge;
  assert(J_01201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 0 1)k e m))by edge;
  assert(J_01120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 2 0)k e m))by edge;
  assert(J_01111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 1 1)k e m))by edge;
  assert(J_01102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 0 2)k e m))by edge;
  assert(J_01021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 2 1)k e m))by edge;
  assert(J_01012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 1 2)k e m))by edge;
  assert(J_00220:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 2 0)k e m))by edge;
  assert(J_00211:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 1 1)k e m))by edge;
  assert(J_00202:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 0 2)k e m))by edge;
  assert(J_00121:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 2 1)k e m))by edge;
  assert(J_00112:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 1 2)k e m))by edge;
  assert(J_00022:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 2 2)k e m))by edge;
  assert(J_21000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 1 0 0 0)k e m))by edge;
  assert(J_20100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 1 0 0)k e m))by edge;
  assert(J_20010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 1 0)k e m))by edge;
  assert(J_20001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 0 1)k e m))by edge;
  assert(J_12000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 2 0 0 0)k e m))by edge;
  assert(J_11100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 1 0 0)k e m))by edge;
  assert(J_11010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 1 0)k e m))by edge;
  assert(J_11001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 0 1)k e m))by edge;
  assert(J_10200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 2 0 0)k e m))by edge;
  assert(J_10110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 1 0)k e m))by edge;
  assert(J_10101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 0 1)k e m))by edge;
  assert(J_10020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 2 0)k e m))by edge;
  assert(J_10011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 1 1)k e m))by edge;
  assert(J_10002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 0 2)k e m))by edge;
  assert(J_02100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 1 0 0)k e m))by edge;
  assert(J_02010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 1 0)k e m))by edge;
  assert(J_02001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 0 1)k e m))by edge;
  assert(J_01200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 2 0 0)k e m))by edge;
  assert(J_01110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 1 0)k e m))by edge;
  assert(J_01101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 0 1)k e m))by edge;
  assert(J_01020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 2 0)k e m))by edge;
  assert(J_01011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 1 1)k e m))by edge;
  assert(J_01002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 0 2)k e m))by edge;
  assert(J_00210:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 1 0)k e m))by edge;
  assert(J_00201:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 0 1)k e m))by edge;
  assert(J_00120:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 2 0)k e m))by edge;
  assert(J_00111:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 1 1)k e m))by edge;
  assert(J_00102:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 0 2)k e m))by edge;
  assert(J_00021:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 2 1)k e m))by edge;
  assert(J_00012:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 1 2)k e m))by edge;
  assert(J_20000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 2 0 0 0 0)k e m))by edge;
  assert(J_11000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 1 0 0 0)k e m))by edge;
  assert(J_10100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 1 0 0)k e m))by edge;
  assert(J_10010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 1 0)k e m))by edge;
  assert(J_10001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 0 1)k e m))by edge;
  assert(J_02000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 2 0 0 0)k e m))by edge;
  assert(J_01100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 1 0 0)k e m))by edge;
  assert(J_01010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 1 0)k e m))by edge;
  assert(J_01001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 0 1)k e m))by edge;
  assert(J_00200:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 2 0 0)k e m))by edge;
  assert(J_00110:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 1 0)k e m))by edge;
  assert(J_00101:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 0 1)k e m))by edge;
  assert(J_00020:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 2 0)k e m))by edge;
  assert(J_00011:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 1 1)k e m))by edge;
  assert(J_00002:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 0 2)k e m))by edge;
  assert(J_10000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 1 0 0 0 0)k e m))by edge;
  assert(J_01000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 1 0 0 0)k e m))by edge;
  assert(J_00100:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 1 0 0)k e m))by edge;
  assert(J_00010:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 1 0)k e m))by edge;
  assert(J_00001:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 0 1)k e m))by edge;
  assert(J_00000:Total.total ge Q(ExprState f(four_call fnid vpid ppid cpid tpid fb vb pb cb tb v p c 0 0 0 0 0)k e m))by edge;
  exact J_00000.
Qed.
