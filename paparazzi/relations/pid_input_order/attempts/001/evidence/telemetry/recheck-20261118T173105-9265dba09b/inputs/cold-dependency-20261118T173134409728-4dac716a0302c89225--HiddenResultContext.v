From Stdlib Require Import List.
From compcert Require Import Values Ctypes Csyntax Csyntaxdefs Csem.
Import ListNotations.
Definition hidden_expr(l fn:expr)(args:exprlist)(post:expr)(ty:type):expr:=
 Eassign l(Ecomma(Ecall fn args tvoid)post ty)ty.
Inductive hidden_hole(l fn:expr)(args:exprlist)(post:expr)(ty:type):
 kind->(expr->expr)->expr->Prop:=
 | hh_whole:hidden_hole l fn args post ty RV(fun x=>x)(hidden_expr l fn args post ty)
 | hh_lhs:forall from D a,context from LV D ->l=D a ->
 hidden_hole l fn args post ty from
 (fun x=>Eassign(D x)(Ecomma(Ecall fn args tvoid)post ty)ty)a
 | hh_comma:hidden_hole l fn args post ty RV
 (fun x=>Eassign l x ty)(Ecomma(Ecall fn args tvoid)post ty)
 | hh_call:hidden_hole l fn args post ty RV
 (fun x=>Eassign l(Ecomma x post ty)ty)(Ecall fn args tvoid)
 | hh_function:forall from D a,context from RV D ->fn=D a ->
 hidden_hole l fn args post ty from
 (fun x=>Eassign l(Ecomma(Ecall(D x)args tvoid)post ty)ty)a
 | hh_argument:forall from D a,contextlist from D ->args=D a ->
 hidden_hole l fn args post ty from
 (fun x=>Eassign l(Ecomma(Ecall fn(D x)tvoid)post ty)ty)a.
Lemma hidden_context_decompose:forall from C a l fn args post ty,
 context from RV C ->C a=hidden_expr l fn args post ty ->
 hidden_hole l fn args post ty from C a.
Proof.
 intros from C a l fn args post ty CT EQ;unfold hidden_expr in EQ.
 inversion CT;subst;cbn in EQ;try discriminate.
 - subst a;constructor.
 - inversion EQ;subst;eapply hh_lhs;[eassumption|reflexivity].
 - inversion EQ;subst.
   match goal with CT0:Csem.context _ RV ?D,EQ0:?D a = Ecomma _ _ _ |- _=>
   inversion CT0;subst;cbn in EQ0;try discriminate end.
   + subst a;constructor.
   + match goal with E:Ecomma _ _ _=Ecomma _ _ _ |- _=>inversion E;subst end.
     match goal with CT1:Csem.context _ RV ?D,EQ1:?D a = Ecall _ _ _ |- _=>
     inversion CT1;subst;cbn in EQ1;try discriminate end.
     * subst a;constructor.
     * match goal with E:Ecall _ _ _=Ecall _ _ _ |- _=>inversion E;subst end.
       eapply hh_function;[eassumption|reflexivity].
     * match goal with E:Ecall _ _ _=Ecall _ _ _ |- _=>inversion E;subst end.
       eapply hh_argument;[eassumption|reflexivity].
Qed.
Print Assumptions hidden_context_decompose.
