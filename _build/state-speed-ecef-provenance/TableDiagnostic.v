From Stdlib Require Import List Bool Lia.
From compcert Require Import Coqlib AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From StateSpeedGetEcefF Require Import Source Execution.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure TableSupport.
Import ListNotations.
Definition ge:=Execution.ge.
Definition allowed:=TableSupport.allowed Source.global_definitions.
Definition budget:type->Csyntax.fundef->Prop:=fun _ _=>True.
Local Notation CS:=(SourceClosure.core_stmt ge allowed budget).
Definition check_signature(sig:type)(gd:ident*globdef Csyntax.fundef type):bool:=
 match snd gd with Gfun fd=>
 if type_eq(type_of_fundef fd)sig then
 match fd with Internal _=>true|External ef _ _ _=>executable_builtin ef end
 else true|_=>true end.
Lemma checked_calls:forall params result conv out,
 forallb(check_signature(Tfunction params result conv))Source.global_definitions=true ->
 SourceClosure.valid_call ge allowed budget(Tfunction params result conv)out.
Proof.
 intros params result conv out CHECK vf fd tys ret cc FIND CLASS TY.
 cbn[classify_fun]in CLASS;inversion CLASS;subst.
 destruct(TableSupport.global_function_in Source.prog vf fd FIND)as[id IN].
 apply forallb_forall with(x:=(id,Gfun fd))in CHECK;[|exact IN].
 unfold check_signature in CHECK;cbn[snd]in CHECK;rewrite TY in CHECK.
 rewrite dec_eq_true in CHECK.
 split;[destruct fd;cbn[allowed TableSupport.allowed]in *;[exists id;exact IN|exact CHECK]|exact I].
Qed.
Eval vm_compute in (filter(fun gd=>negb(check_signature(Tfunction[]tvoid cc_default)gd))Source.global_definitions).
