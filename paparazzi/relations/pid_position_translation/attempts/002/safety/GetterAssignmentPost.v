From Stdlib Require Import Bool List ZArith Classical.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation BlockExecution PhaseComposition.
From PidPositionSafety Require Import GetterAssignmentShell AtomicPhase.
Import ListNotations.
Module A:=GetterAssignmentShell.
Lemma type_eq_diagonal:forall(A:Type)ty(x y:A),
 (if Ctypes.type_eq ty ty then x else y)=x.
Proof. intros;destruct(Ctypes.type_eq ty ty);auto;contradiction n;reflexivity. Qed.

Section POST.
Variable ge:genv.
Variable caller:function.
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

Ltac typeeq_self:=
 repeat match goal with
 | |-context[if Ctypes.type_eq ?TY ?TY then _ else _]=>
 destruct(Ctypes.type_eq TY TY)as[TE|NE];[|exfalso;apply NE;reflexivity]
 | H:context[if Ctypes.type_eq ?TY ?TY then _ else _] |- _=>
 destruct(Ctypes.type_eq TY TY)as[TE|NE]in H;[|exfalso;apply NE;reflexivity] end.
Ltac normalize_pure:=
 do 12(
 cbn[LRes RRes A.lhs_res A.ref_res A.axis_load A.component_load A.reference_load A.getter_read
 A.ghty A.refty A.vty A.nedty A.rettype pure_rval pure_lval typeof];
 fold(pure_rval ge e m)(pure_lval ge e m);
 rewrite ?param_local,?error_global,?error_symbol;
 repeat rewrite type_eq_diagonal;cbn beta iota zeta;
 rewrite ?gh_lookup,?ref_lookup,?vec_lookup,?ned_lookup,?gh_field,?ref_field,?axis_field,?ned_field;
 rewrite ?param_deref,?scalar_deref,?cache_deref;
 cbn[Cexec.do_deref_loc A.ghty A.refty A.vty A.nedty A.rettype access_mode type_is_volatile];
 cbn beta iota zeta).
Lemma lhs_type:forall ls,typeof(LRes ls)=tint.
Proof. destruct ls;reflexivity. Qed.
Lemma reference_type:forall rs,typeof(RRes rs)=tint.
Proof. destruct rs;reflexivity. Qed.
Lemma lhs_denotation:forall ls,pure_lval ge e m(LRes ls)=Some(berr,A.axis_offset daxis,Full).
Proof. destruct ls;normalize_pure;reflexivity. Qed.
Lemma reference_denotation:forall rs,pure_rval ge e m(RRes rs)=Some(Vint reference).
Proof.
 destruct rs;normalize_pure;try reflexivity.
 all: change((match Cexec.do_deref_loc ge quiet_world tint m bgh(A.scalar_offset dref dcomponent daxis)Full with
 | Some(_,_,v)=>Some v|None=>None end)=Some(Vint reference)).
 all: rewrite scalar_deref;reflexivity.
Qed.
Lemma getter_result_denotation:
 pure_rval ge e m(A.getter_read nedid axis(Eval(Vptr bcache cacheofs)(A.rettype nedid)))=Some(Vint measured).
Proof.
 normalize_pure;try reflexivity.
 change((match Cexec.do_deref_loc ge quiet_world tint m bcache(Ptrofs.add cacheofs(Ptrofs.repr daxis))Full with
 | Some(_,_,v)=>Some v|None=>None end)=Some(Vint measured)).
 rewrite cache_deref;reflexivity.
Qed.
Lemma post_atomic_syntax:forall ls rs,atomic_expr(post_expr ls rs)=true.
Proof. destruct ls,rs;reflexivity. Qed.
Lemma post_atomic_denotation:forall ls rs,
 atomic_eval ge e m(post_expr ls rs)=Some(Vint difference,mf).
Proof.
 intros ls rs;unfold post_expr,A.assignment_context.
 cbn[atomic_eval];rewrite lhs_type;typeeq_self.
 fold(pure_rval ge e m)(pure_lval ge e m).
 rewrite lhs_denotation.
 change((match
 (match pure_rval ge e m(RRes rs),
 pure_rval ge e m(A.getter_read nedid axis(Eval(Vptr bcache cacheofs)(A.rettype nedid)))with
 | Some v,Some w=>sem_binary_operation ge Osub v(typeof(RRes rs))w tint m
 | _,_=>None end)with
 | Some v=>commit ge m tint(berr,A.axis_offset daxis,Full)v tint
 | None=>None end)=Some(Vint difference,mf)).
 rewrite reference_denotation,getter_result_denotation,reference_type,sub_value.
 change((match Cexec.do_assign_loc ge quiet_world tint m berr(A.axis_offset daxis)Full(Vint difference)with
 | Some(_,_,mout,vf)=>Some(vf,mout)|None=>None end)=Some(Vint difference,mf)).
 rewrite store_result;reflexivity.
Qed.
Theorem post_phase_certificate:forall ls rs,
 certificate ge(block_context_invariant ge k caller e mf)(State caller Sskip k e mf) /\
 block_context_invariant ge k caller e mf(ExprState caller(post_expr ls rs)(Kdo k)e m).
Proof.
 intros;apply(atomic_expression_certificate ge caller e k m mf(post_expr ls rs)(Vint difference)).
 - apply post_atomic_syntax.
 - apply post_atomic_denotation.
Qed.
End POST.
Print Assumptions post_phase_certificate.
