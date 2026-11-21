From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Ctypes Ctypesdefs Cop Csyntax.
Require PprzTrigInit.Source.
Import ListNotations.
Local Open Scope Z_scope.

Fixpoint expression_nodes(a:expr):list expr:=a::
 match a with
 |Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>expression_nodes a
 |Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>expression_nodes a++expression_nodes b
 |Econdition a b c _=>expression_nodes a++expression_nodes b++expression_nodes c
 |Ecall a args _=>expression_nodes a++expression_list_nodes args
 |Ebuiltin _ _ args _=>expression_list_nodes args
 |_=>[]end
with expression_list_nodes(args:exprlist):list expr:=
 match args with Enil=>[]|Econs a tail=>expression_nodes a++expression_list_nodes tail end.
Fixpoint statement_nodes(s:statement):list expr:=
 match s with
 |Sdo a=>expression_nodes a
 |Ssequence a b=>statement_nodes a++statement_nodes b
 |Sifthenelse a yes no=>expression_nodes a++statement_nodes yes++statement_nodes no
 |Swhile a body=>expression_nodes a++statement_nodes body
 |Sdowhile a body=>statement_nodes body++expression_nodes a
 |Sfor first cond advance body=>statement_nodes first++expression_nodes cond++statement_nodes advance++statement_nodes body
 |Sreturn(Some a)=>expression_nodes a
 |Sswitch a cases=>expression_nodes a++labeled_nodes cases
 |Slabel _ body=>statement_nodes body
 |_=>[]end
with labeled_nodes(cases:labeled_statements):list expr:=
 match cases with LSnil=>[]|LScons _ body rest=>statement_nodes body++labeled_nodes rest end.
Definition is_increment(a:expr):bool:=match a with Epostincr _ _ _=>true|_=>false end.
Definition is_add_assign(a:expr):bool:=match a with Eassignop Oadd _ _ _ _=>true|_=>false end.
Definition source_short_increment(id:ident):expr:=Epostincr Incr(Evar id tshort)tshort.
Definition actual_init_increment_nodes:=filter is_increment(statement_nodes(fn_body PprzTrigInit.Source.f_pprz_trig_int_init)).
Lemma initializer_increment_origins : actual_init_increment_nodes=
 [source_short_increment PprzTrigInit.Source._i;source_short_increment PprzTrigInit.Source._j;
 source_short_increment PprzTrigInit.Source._cnt;source_short_increment PprzTrigInit.Source._i;
 source_short_increment PprzTrigInit.Source._i;source_short_increment PprzTrigInit.Source._j;
 source_short_increment PprzTrigInit.Source._cnt].
Proof. reflexivity. Qed.
Definition actual_init_add_assign_nodes:=filter is_add_assign(statement_nodes(fn_body PprzTrigInit.Source.f_pprz_trig_int_init)).
Definition actual_single_add_assign:=Eassignop Oadd(Evar PprzTrigInit.Source._val tshort)
 (Ebinop Omod(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)(Eval(Vint(Int.repr 5))tint)tint)tint tshort.
Definition actual_multi_add_assign:=Eassignop Oadd(Evar PprzTrigInit.Source._val tshort)
 (Ebinop Oand(Evalof(Evar PprzTrigInit.Source._temp tshort)tshort)(Eval(Vint(Int.repr 7))tint)tint)tint tshort.
Lemma initializer_add_assign_origins : actual_init_add_assign_nodes=[actual_single_add_assign;actual_multi_add_assign].
Proof. reflexivity. Qed.
