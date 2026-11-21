From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps AST Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Ctyping.
From PprzTrigCBMC Require Import ArrayBases ProducerContexts.
Section ARRAYS.
Variable ge:Csem.genv.
Variable elem:type.
Variable ids:list(ident*Z).
Definition array_head(a:expr):Prop:=match a with
|Evar _ ty=>ty=elem->False
|Efield _ _ _=>False
|Eloc _ _ _ ty=>ty=elem->array_lvalue ge elem ids a
|Evalof l ty=>ty=elem->array_lvalue ge elem ids l
|Ederef p ty=>ty=elem->array_pointer ge elem ids p
|Ebinop Oadd l r ty=>ty=Tpointer elem noattr->exists n,array_base ge elem ids l n/\typeconv(typeof r)=tint
|Eassign l r ty=>ty=elem->array_lvalue ge elem ids l
|Eassignop _ l r tyres ty=>(ty=elem->array_lvalue ge elem ids l)/\tyres<>Tpointer elem noattr
|Epostincr _ l ty=>(ty=elem->array_lvalue ge elem ids l)/\incrdecr_type ty<>Tpointer elem noattr
|_=>True end.
Fixpoint array_expr(a:expr):Prop:=array_head a/\match a with
|Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>array_expr a
|Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>array_expr a/\array_expr b
|Econdition a b c _=>array_expr a/\array_expr b/\array_expr c
|Ecall a args _=>array_expr a/\array_exprlist args
|Ebuiltin _ _ args _=>array_exprlist args
|_=>True end
with array_exprlist(args:exprlist):Prop:=match args with
|Enil=>True|Econs a rest=>array_expr a/\array_exprlist rest end.
Lemma array_expr_head:forall a,array_expr a->array_head a.
Proof. destruct a;intros H;exact(proj1 H). Qed.
Lemma array_eval:forall v ty,array_expr(Eval v ty).
Proof. intros;split;exact I. Qed.
End ARRAYS.
