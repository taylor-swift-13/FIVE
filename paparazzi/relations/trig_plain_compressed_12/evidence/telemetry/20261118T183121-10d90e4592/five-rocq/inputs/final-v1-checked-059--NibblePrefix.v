From Stdlib Require Import Bool List String ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import PlainCore Total.
From PprzTrigInitSupport Require Import Control SideEffects PostIncrement IntegerFacts.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Definition nibble_arg_type:=Tint I16 Unsigned noattr.
Definition nibble_return_type:=Tint I8 Unsigned noattr.
Definition nibble_fun_type:=Tfunction[nibble_arg_type]nibble_return_type cc_default.
Definition nibble_lhs(stage:nat)(tempid:ident)(bt:block):expr :=
 match stage with O=>Evar tempid short_type|_=>Eloc bt Ptrofs.zero Full short_type end.
Definition nibble_fun(stage:nat)(funid:ident)(bf:block):expr :=
 match stage with
 |O=>Evalof(Evar funid nibble_fun_type)nibble_fun_type
 |S O=>Evalof(Eloc bf Ptrofs.zero Full nibble_fun_type)nibble_fun_type
 |_=>Eval(Vptr bf Ptrofs.zero)nibble_fun_type end.
Definition nibble_arg(stage:nat)(iid:ident)(bi:block)(p:Z):expr :=
 match stage with
 |O=>Epostincr Incr(Evar iid short_type)short_type
 |S O=>Epostincr Incr(Eloc bi Ptrofs.zero Full short_type)short_type
 |S(S O)=>Ecomma(Eassign(Eloc bi Ptrofs.zero Full short_type)
   (Ebinop Oadd(Eval(Vint(Int.repr p))short_type)(Eval(Vint Int.one)type_int32s)(incrdecr_type short_type))short_type)
   (Eval(Vint(Int.repr p))short_type)short_type
 |S(S(S O))=>Ecomma(Eassign(Eloc bi Ptrofs.zero Full short_type)
   (Eval(Vint(Int.repr(p+1)))(incrdecr_type short_type))short_type)(Eval(Vint(Int.repr p))short_type)short_type
 |S(S(S(S O)))=>Ecomma(Eval(Vint(Int.repr(p+1)))short_type)(Eval(Vint(Int.repr p))short_type)short_type
 |_=>Eval(Vint(Int.repr p))short_type end.
Definition nibble_memory(stage:nat)(m mi:mem):mem :=match stage with O|S O|S(S O)|S(S(S O))=>m|_=>mi end.
Definition nibble_stage_expr(t f a:nat)(tempid funid iid:ident)(bt bf bi:block)(p:Z):expr :=
 Eassign(nibble_lhs t tempid bt)(Ecall(nibble_fun f funid bf)(Econs(nibble_arg a iid bi p)Enil)nibble_return_type)short_type.
(** These are names for residual ORIGINAL Csyntax expressions.  Every edge
    below is checked against the complete original Cexec successor list. *)
Theorem nibble_assignment_prefix_total : forall (ge:Csem.genv)Q caller kont e m mi tempid funid iid bt bf bi p,
 0<=p<3379 ->e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol ge funid=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 (forall t,Total.total ge Q(Callstate(Internal PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]
  (Kcall caller e(fun x=>Eassign(nibble_lhs t tempid bt)x short_type)nibble_return_type kont)mi)) ->
 Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m).
Proof.
 intros ge Q caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE END.
 pose proof(short_deref ge Control.quiet m bi p LOAD)as DEREF.
 pose proof(short_add_one ge m p ltac:(lia))as ADD.
 pose proof(short_increment_cast m p ltac:(lia))as CAST.
 change(sem_cast(Vint(Int.repr(p+1)))(Tint I32 Signed noattr)short_type m=Some(Vint(Int.repr(p+1))))in CAST.
 pose proof(short_assign ge Control.quiet m bi(p+1)mi STORE)as ASSIGN.
 assert(ARGCAST:sem_cast(Vint(Int.repr p))short_type nibble_arg_type mi=Some(Vint(Int.repr p))).
 { change(Some(Vint(Int.zero_ext 16(Int.repr p)))=Some(Vint(Int.repr p))). rewrite zero_ext16_repr by lia;reflexivity. }
 assert(FADDR0:Cexec.do_deref_loc ge Control.quiet nibble_fun_type m bf Ptrofs.zero Full=Some(Control.quiet,E0,Vptr bf Ptrofs.zero))by reflexivity.
 assert(FADDR1:Cexec.do_deref_loc ge Control.quiet nibble_fun_type mi bf Ptrofs.zero Full=Some(Control.quiet,E0,Vptr bf Ptrofs.zero))by reflexivity.
 Ltac stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END :=
   unfold nibble_stage_expr,nibble_lhs,nibble_fun,nibble_arg,nibble_memory;
   cbn;
   eapply quiet_successors_total;
   [vm_compute;reflexivity|
    repeat(progress(cbn[Cexec.do_step Cexec.step_expr Cexec.step_exprlist Cexec.is_val Cexec.is_loc
     Cexec.is_val_list Cexec.incontext Cexec.incontext2 Cexec.topred Cexec.ret Cexec.expr_final_state
     Cexec.sem_cast_arguments classify_fun typeof type_of_fundef fn_params fn_return
     PprzTrigInit.Source.f_get_nibble nibble_fun_type nibble_arg_type nibble_return_type] ;
     rewrite ?ET,?EI,?EF,?SYM,?FUN,?DEREF,?ADD,?CAST,?ASSIGN,?ARGCAST,?FADDR0,?FADDR1,?dec_eq_true));
     repeat eexists;cbn[Cexec.expr_final_state];first[left;reflexivity|match goal with |- ?G=>idtac G end;fail 1]|
    intros rule trace next IN;
    repeat(progress(cbn[Cexec.do_step Cexec.step_expr Cexec.step_exprlist Cexec.is_val Cexec.is_loc
     Cexec.is_val_list Cexec.incontext Cexec.incontext2 Cexec.topred Cexec.ret Cexec.expr_final_state
     Cexec.sem_cast_arguments classify_fun typeof type_of_fundef fn_params fn_return
     PprzTrigInit.Source.f_get_nibble nibble_fun_type nibble_arg_type nibble_return_type]in IN;
     rewrite ?ET,?EI,?EF,?SYM,?FUN,?DEREF,?ADD,?CAST,?ASSIGN,?ARGCAST,?FADDR0,?FADDR1,?dec_eq_true in IN));
    cbn in IN;repeat match goal with H:_\/_|-_=>destruct H end;try contradiction;
    match goal with H:TR _ _ _=TR _ _ _|-_=>inversion H;subst;clear H end;
    first[exact(END 0%nat)|exact(END 1%nat)|assumption]].
 assert(S125:Total.total ge Q(ExprState caller(nibble_stage_expr 1 2 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S025:Total.total ge Q(ExprState caller(nibble_stage_expr 0 2 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S115:Total.total ge Q(ExprState caller(nibble_stage_expr 1 1 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S124:Total.total ge Q(ExprState caller(nibble_stage_expr 1 2 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S015:Total.total ge Q(ExprState caller(nibble_stage_expr 0 1 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S024:Total.total ge Q(ExprState caller(nibble_stage_expr 0 2 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S105:Total.total ge Q(ExprState caller(nibble_stage_expr 1 0 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S114:Total.total ge Q(ExprState caller(nibble_stage_expr 1 1 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S123:Total.total ge Q(ExprState caller(nibble_stage_expr 1 2 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S005:Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S014:Total.total ge Q(ExprState caller(nibble_stage_expr 0 1 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S023:Total.total ge Q(ExprState caller(nibble_stage_expr 0 2 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S104:Total.total ge Q(ExprState caller(nibble_stage_expr 1 0 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S113:Total.total ge Q(ExprState caller(nibble_stage_expr 1 1 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S122:Total.total ge Q(ExprState caller(nibble_stage_expr 1 2 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S004:Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S013:Total.total ge Q(ExprState caller(nibble_stage_expr 0 1 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S022:Total.total ge Q(ExprState caller(nibble_stage_expr 0 2 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S103:Total.total ge Q(ExprState caller(nibble_stage_expr 1 0 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S112:Total.total ge Q(ExprState caller(nibble_stage_expr 1 1 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S121:Total.total ge Q(ExprState caller(nibble_stage_expr 1 2 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S003:Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S012:Total.total ge Q(ExprState caller(nibble_stage_expr 0 1 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S021:Total.total ge Q(ExprState caller(nibble_stage_expr 0 2 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S102:Total.total ge Q(ExprState caller(nibble_stage_expr 1 0 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S111:Total.total ge Q(ExprState caller(nibble_stage_expr 1 1 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S120:Total.total ge Q(ExprState caller(nibble_stage_expr 1 2 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S002:Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S011:Total.total ge Q(ExprState caller(nibble_stage_expr 0 1 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S020:Total.total ge Q(ExprState caller(nibble_stage_expr 0 2 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S101:Total.total ge Q(ExprState caller(nibble_stage_expr 1 0 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S110:Total.total ge Q(ExprState caller(nibble_stage_expr 1 1 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S001:Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S010:Total.total ge Q(ExprState caller(nibble_stage_expr 0 1 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S100:Total.total ge Q(ExprState caller(nibble_stage_expr 1 0 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S000:Total.total ge Q(ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 exact S000.
Qed.
Print Assumptions nibble_assignment_prefix_total.
