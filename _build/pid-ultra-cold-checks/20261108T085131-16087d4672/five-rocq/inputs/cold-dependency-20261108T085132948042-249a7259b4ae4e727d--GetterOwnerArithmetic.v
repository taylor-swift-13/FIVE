From Stdlib Require Import Bool List ZArith Classical.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation BlockExecution PhaseComposition FactorShell.
From PidPositionSafety Require Import GetterAssignmentShell GetterArithmeticPost AtomicPhase ObservedReadonly TaggedCallee SubtractionObservation.
From CoreCBMC Require Import NumericBounds ArithmeticAtomic ArithmeticObservation.
Import ListNotations.
Module A:=GetterAssignmentShell.
Module B:=GetterArithmeticPost.
Lemma type_eq_diagonal:forall(A:Type)ty(x y:A),
 (if Ctypes.type_eq ty ty then x else y)=x.
Proof. intros;destruct(Ctypes.type_eq ty ty);auto;contradiction n;reflexivity. Qed.

Section COMPLETE.
Variable ge:genv.
Variable caller leaf owner:function.
Variable e:env.
Variable k:cont.
Variable m mf:mem.
Variable ghid refid vectid nedid axis iref icomponent ierr igh:AST.ident.
Variable berr bparam bgh bcache:block.
Variable dref dcomponent daxis:Z.
Variable cacheofs:ptrofs.
Variable reference measured difference:int.
Definition LRes:=A.lhs_res vectid axis ierr berr daxis.
Definition RRes:=A.ref_res ghid refid vectid axis iref icomponent igh bparam bgh dref dcomponent daxis reference.
Definition post_expr(ls:A.lhs_stage)(rs:A.ref_stage):expr:=
 A.assignment_context nedid axis(LRes ls)(RRes rs)(Eval(Vptr bcache cacheofs)(A.rettype nedid)).
Hypothesis param_local:e!igh=Some(bparam,tptr(A.ghty ghid)).
Hypothesis error_global:e!ierr=None.
Hypothesis error_symbol:Genv.find_symbol ge ierr=Some berr.
Variable ghco refco vecco nedco:composite.
Hypothesis gh_lookup:PTree.get ghid(genv_cenv ge)=Some ghco.
Hypothesis ref_lookup:PTree.get refid(genv_cenv ge)=Some refco.
Hypothesis vec_lookup:PTree.get vectid(genv_cenv ge)=Some vecco.
Hypothesis ned_lookup:PTree.get nedid(genv_cenv ge)=Some nedco.
Hypothesis gh_field:field_offset ge iref(co_members ghco)=OK(dref,Full).
Hypothesis ref_field:field_offset ge icomponent(co_members refco)=OK(dcomponent,Full).
Hypothesis axis_field:field_offset ge axis(co_members vecco)=OK(daxis,Full).
Hypothesis ned_field:field_offset ge axis(co_members nedco)=OK(daxis,Full).
Hypothesis param_deref:Cexec.do_deref_loc ge quiet_world(tptr(A.ghty ghid))m bparam Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr bgh Ptrofs.zero).
Hypothesis scalar_deref:Cexec.do_deref_loc ge quiet_world tint m bgh(A.scalar_offset dref dcomponent daxis)Full=
 Some(quiet_world,E0,Vint reference).
Hypothesis cache_deref:Cexec.do_deref_loc ge quiet_world tint m bcache(Ptrofs.add cacheofs(Ptrofs.repr daxis))Full=
 Some(quiet_world,E0,Vint measured).
Hypothesis sub_value:sem_binary_operation ge Osub(Vint reference)tint(Vint measured)tint m=Some(Vint difference).
Hypothesis store_result:Cexec.do_assign_loc ge quiet_world tint m berr(A.axis_offset daxis)Full(Vint difference)=
 Some(quiet_world,E0,mf,Vint difference).

Hypothesis subtraction_safe:NumericBounds.signed32(Int.signed reference-Int.signed measured).
Hypothesis caller_not_owner:caller<>owner.
Hypothesis leaf_not_owner:leaf<>owner.
Variable igetter:AST.ident.
Variable bgetter:block.
Hypothesis getter_global:e!igetter=None.
Hypothesis getter_symbol:Genv.find_symbol ge igetter=Some bgetter.
Hypothesis leaf_find:Genv.find_funct ge(Vptr bgetter Ptrofs.zero)=Some(Ctypes.Internal leaf).
Hypothesis leaf_signature:type_of_fundef(Ctypes.Internal leaf)=A.function_type nedid.
Hypothesis getter_readonly:forall base,is_call_cont base ->
 exists P,certificate ge P(Returnstate(Vptr bcache cacheofs)base m) /\
 P(Callstate(Ctypes.Internal leaf)[]base m)/\(forall s,P s->function_scope leaf s).
Definition Pre:=A.pre_state caller e k m ghid refid vectid nedid axis iref icomponent ierr igh igetter
 berr bparam bgh bgetter dref dcomponent daxis reference.
Definition Frame:=A.call_frame caller e k ghid refid vectid nedid axis iref icomponent ierr igh
 berr bparam bgh dref dcomponent daxis reference.
Definition Call(ls:A.lhs_stage)(rs:A.ref_stage):Csem.state:=
 Callstate(Ctypes.Internal leaf)[](Frame ls rs)m.
Definition Post(ls:A.lhs_stage)(rs:A.ref_stage):Csem.state:=
 ExprState caller(post_expr ls rs)(Kdo k)e m.
Definition Initial:=State caller
 (Sdo(A.pre_expr ghid refid vectid nedid axis iref icomponent ierr igh igetter
 berr bparam bgh bgetter dref dcomponent daxis reference A.L0 A.R0 A.F0))k e m.

Theorem original_getter_owner_arithmetic_certificate:
 exists P,certificate ge P(State caller Sskip k e mf) /\P Initial /\
 (forall s,P s->arithmetic_observation ge owner s).
Proof.
 assert(PP:forall ls rs fs,exists t next,Csem.step ge(Pre ls rs fs)t next /\
 ObservedReadonly.pre_or_call A.lhs_stage A.ref_stage A.fn_stage Pre Call next).
 { intros ls rs fs.
 exact(A.pre_progress ge caller leaf e k m
 ghid refid vectid nedid axis iref icomponent ierr igh igetter berr bparam bgh bgetter
 dref dcomponent daxis reference param_local error_global error_symbol getter_global getter_symbol
 ghco refco vecco gh_lookup ref_lookup vec_lookup gh_field ref_field axis_field param_deref scalar_deref
 leaf_find leaf_signature ls rs fs). }
 assert(PC:forall ls rs fs t next,Csem.step ge(Pre ls rs fs)t next ->
 ObservedReadonly.pre_or_call A.lhs_stage A.ref_stage A.fn_stage Pre Call next).
 { intros ls rs fs t next STEP.
 exact(proj2(A.pre_all_successors ge caller leaf e k m
 ghid refid vectid nedid axis iref icomponent ierr igh igetter berr bparam bgh bgetter
 dref dcomponent daxis reference param_local error_global error_symbol getter_global getter_symbol
 ghco refco vecco gh_lookup ref_lookup vec_lookup gh_field ref_field axis_field param_deref scalar_deref
 leaf_find leaf_signature ls rs fs t next STEP)). }
 assert(CAL:forall ls rs,exists P,
 certificate ge P(Returnstate(Vptr bcache cacheofs)(Frame ls rs)m) /\P(Call ls rs)/\
 (forall s,P s->arithmetic_observation ge owner s)).
 { intros;destruct(getter_readonly(Frame ls rs)I)as[P[C[IN SC]]].
   exists P;split;[exact C|];split;[exact IN|];intros s PS.
   apply scope_other_observation with(leaf:=leaf);[apply SC;exact PS|exact leaf_not_owner]. }
 assert(RET:forall ls rs,unique_transition ge
 (Returnstate(Vptr bcache cacheofs)(Frame ls rs)m)(Post ls rs)).
 { intros;unfold Frame,Post,A.call_frame,post_expr,LRes,RRes.
 split;[right;apply Csem.step_returnstate|].
 intros t next STEP;eapply FactorShell.return_call_step_unique;exact STEP. }
 assert(POST:forall ls rs,exists Q,certificate ge Q(State caller Sskip k e mf) /\Q(Post ls rs)/\
 (forall s,Q s->arithmetic_observation ge owner s)).
 { intros ls rs.
 destruct(B.post_arithmetic_certificate ge caller e k m mf
 ghid refid vectid nedid axis iref icomponent ierr igh berr bparam bgh bcache
 dref dcomponent daxis cacheofs reference measured difference
 param_local error_global error_symbol ghco refco vecco nedco
 gh_lookup ref_lookup vec_lookup ned_lookup gh_field ref_field axis_field ned_field
 param_deref scalar_deref cache_deref sub_value store_result subtraction_safe ls rs)as[C I].
 exists(arithmetic_atomic_invariant ge caller e k mf(Vint difference));split;[exact C|];split;[exact I|].
   intros s IN;destruct s;cbn[arithmetic_observation];try exact Logic.I.
   intros _;apply tree_ready_safe;eapply arithmetic_atomic_observation;exact IN. }
 eexists;split.
 - eapply ObservedReadonly.readonly_assignment_certificate
 with(pre:=Pre)(call:=Call)(frame:=Frame)(post:=Post)
 (initial:=Initial)(observe:=arithmetic_observation ge owner)(result:=Vptr bcache cacheofs)(m:=m)
 (l0:=A.L0)(r0:=A.R0)(f0:=A.F0).
   + exact PP.
   + exact PC.
   + unfold Initial,Pre,A.pre_state;split;[right;apply Csem.step_do_1|].
     intros t next STEP;eapply FactorShell.do_step_unique;exact STEP.
   + exact CAL.
   + exact RET.
   + exact POST.
 - split;[left;reflexivity|].
   intros s IN;eapply ObservedReadonly.observations with(initial:=Initial)(pre:=Pre);[exact I| |exact IN].
   intros ls rs fs EQ;exfalso;apply caller_not_owner;exact EQ.
Qed.
End COMPLETE.
Print Assumptions original_getter_owner_arithmetic_certificate.
