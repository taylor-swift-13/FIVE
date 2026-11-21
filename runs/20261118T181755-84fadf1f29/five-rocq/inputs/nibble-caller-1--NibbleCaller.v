From Stdlib Require Import Bool List String ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import PlainCore.
From PprzTrigInitSupport Require Import Control SideEffects PostIncrement IntegerFacts NibblePrefix.
From PprzTrigCBMC Require Import FirstCall.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Theorem nibble_caller_certificate : forall (ge:Csem.genv)(TARGET:Csem.state->Prop) caller kont e m mi tempid funid iid bt bf bi p,
 0<=p<3379 ->e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol ge funid=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 (forall t,first_call_certificate ge TARGET(Callstate(Internal PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]
  (Kcall caller e(fun x=>Eassign(nibble_lhs t tempid bt)x short_type)nibble_return_type kont)mi)) ->
 first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m).
Proof.
 intros ge TARGET caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE END.
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
   eapply quiet_successors_first_call;
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
 assert(S125:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 2 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S025:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 2 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S115:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 1 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S124:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 2 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S015:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 1 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S024:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 2 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S105:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 0 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S114:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 1 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S123:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 2 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S005:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 5 tempid funid iid bt bf bi p)kont e(nibble_memory 5 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S014:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 1 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S023:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 2 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S104:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 0 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S113:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 1 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S122:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 2 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S004:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 4 tempid funid iid bt bf bi p)kont e(nibble_memory 4 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S013:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 1 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S022:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 2 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S103:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 0 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S112:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 1 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S121:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 2 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S003:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 3 tempid funid iid bt bf bi p)kont e(nibble_memory 3 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S012:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 1 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S021:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 2 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S102:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 0 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S111:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 1 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S120:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 2 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S002:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 2 tempid funid iid bt bf bi p)kont e(nibble_memory 2 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S011:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 1 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S020:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 2 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S101:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 0 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S110:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 1 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S001:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 1 tempid funid iid bt bf bi p)kont e(nibble_memory 1 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S010:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 1 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S100:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 1 0 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 assert(S000:first_call_certificate ge TARGET(ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e(nibble_memory 0 m mi))).
 { stage_step ET EI EF SYM FUN DEREF ADD CAST ASSIGN ARGCAST FADDR0 FADDR1 END. }
 exact S000.
Qed.

Definition expected_nibble_call(caller:function)(kont:cont)(e:env)(mi:mem)
 (tempid:ident)(bt:block)(p:Z)(s:Csem.state):Prop:=exists t,
 s=Callstate(Internal PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]
 (Kcall caller e(fun x=>Eassign(nibble_lhs t tempid bt)x short_type)nibble_return_type kont)mi.
Theorem nibble_caller_exact_first_call : forall ge caller kont e m mi tempid funid iid bt bf bi p,
 0<=p<3379 ->e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol ge funid=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 first_call_certificate ge(expected_nibble_call caller kont e mi tempid bt p)
 (ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m).
Proof.
 intros ge caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE.
 eapply nibble_caller_certificate;try eassumption.
 intro t;apply first_call_here;exists t;reflexivity.
Qed.
Theorem every_nibble_caller_first_call : forall ge caller kont e m mi tempid funid iid bt bf bi p,
 0<=p<3379 ->e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol ge funid=Some bf ->
 Genv.find_funct ge(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 (exists trace next,star Csem.step ge
   (ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m)trace next /\
   expected_nibble_call caller kont e mi tempid bt p next) /\
 (forall trace fd args k mc,first_call_prefix ge
   (ExprState caller(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p)kont e m)trace(Callstate fd args k mc) ->
   expected_nibble_call caller kont e mi tempid bt p(Callstate fd args k mc)).
Proof.
 intros ge caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE.
 pose proof(@nibble_caller_exact_first_call ge caller kont e m mi tempid funid iid bt bf bi p RANGE ET EI EF SYM FUN LOAD STORE)as CERT.
 split;[exact(@first_call_execution_exists _ _ _ CERT)|].
 intros trace fd args k mc PREFIX;eapply every_first_call_covered;[|exact CERT|exact PREFIX].
 intros s[t EQ];subst s;repeat eexists;reflexivity.
Qed.
