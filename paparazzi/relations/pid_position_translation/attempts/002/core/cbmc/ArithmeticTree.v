From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation.
From CoreCBMC Require Import NumericBounds.
Open Scope Z_scope.
Definition binary_safe(op:binary_operation)(ta tb:type)(va vb:val):Prop:=
 match va,vb with
 | Vint a,Vint b=>
   match op with
   | Oadd=>if Ctypes.type_eq ta tint then signed32(Int.signed a+Int.signed b)else True
   | Osub=>if Ctypes.type_eq ta tint then signed32(Int.signed a-Int.signed b)else True
   | Omul=>if Ctypes.type_eq ta tint then signed32(Int.signed a*Int.signed b)else True
   | Oshl=>Int.unsigned b<32 /\
      (if Ctypes.type_eq ta tint then 0<=Int.signed a /\signed32(Int.signed a*two_p(Int.unsigned b))else True)
   | Oshr=>Int.unsigned b<32
   | _=>True end
 | _,_=>True end.
Definition unary_safe(op:unary_operation)(ta:type)(va:val):Prop:=
 match op,va with Oneg,Vint a=>if Ctypes.type_eq ta tint then Int.signed a<> -2147483648 else True|_,_=>True end.
Definition binary_condition(ge:genv)(e:env)(m:mem)(op:binary_operation)(a b:expr):Prop:=
 match pure_rval ge e m a,pure_rval ge e m b with
 | Some va,Some vb=>binary_safe op(typeof a)(typeof b)va vb
 | _,_=>True end.
Definition unary_condition(ge:genv)(e:env)(m:mem)(op:unary_operation)(a:expr):Prop:=
 match pure_rval ge e m a with Some va=>unary_safe op(typeof a)va|None=>True end.
Definition assignop_condition(ge:genv)(e:env)(m:mem)(op:binary_operation)(l r:expr):Prop:=
 match pure_lval ge e m l,pure_rval ge e m r with
 | Some(b,ofs,bf),Some vr=>
   match Cexec.do_deref_loc ge quiet_world(typeof l)m b ofs bf with
   | Some(_,_,vl)=>binary_safe op(typeof l)(typeof r)vl vr
   | None=>True end
 | _,_=>True end.
Fixpoint arithmetic_tree(ge:genv)(e:env)(m:mem)(a:expr):Prop:=
 match a with
 | Eval _ _|Evar _ _|Eloc _ _ _ _|Esizeof _ _|Ealignof _ _=>True
 | Evalof a _|Eaddrof a _|Ederef a _|Efield a _ _|Ecast a _|Eparen a _ _=>arithmetic_tree ge e m a
 | Eunop op a _=>arithmetic_tree ge e m a /\unary_condition ge e m op a
 | Ebinop op a b _=>arithmetic_tree ge e m a /\arithmetic_tree ge e m b /\binary_condition ge e m op a b
 | Eassign a b _|Eseqand a b _|Eseqor a b _|Ecomma a b _=>arithmetic_tree ge e m a /\arithmetic_tree ge e m b
 | Econdition c a b _=>arithmetic_tree ge e m c /\arithmetic_tree ge e m a /\arithmetic_tree ge e m b
 | Eassignop op l r _ _=>arithmetic_tree ge e m l /\arithmetic_tree ge e m r /\nv(typeof l)=true /\assignop_condition ge e m op l r
 | _=>False end.

Lemma arithmetic_context_congr:forall ge e m from to C,
 context from to C ->forall a b,
 typeof a=typeof b ->pure_eq ge e m from a b ->
 arithmetic_tree ge e m(C a) ->arithmetic_tree ge e m b ->
 arithmetic_tree ge e m(C b).
Proof.
 intros ge e m from to C CT;induction CT;intros a b TY VALUE TREE NEW;
 cbn[arithmetic_tree]in *;try contradiction;try tauto.
 all:repeat match goal with H:_ /\ _|-_=>destruct H end.
 all:try solve[eapply IHCT;eauto].
 all:repeat split;try assumption;try solve[eapply IHCT;eauto].
 all:try solve[
  unfold unary_condition,binary_condition,assignop_condition in *;
  pose proof(context_type_eq _ _ _ CT a b TY)as CTY;
  pose proof(pure_context_congr ge e m _ _ _ CT a b TY VALUE)as CE;
  cbn[pure_eq]in CE;
  rewrite <-CTY,<-CE;assumption].
 all:rewrite <-(context_type_eq _ _ _ CT a b TY);assumption.
Qed.

Lemma arithmetic_context_hole:forall ge e m from to C,
 context from to C ->forall a,
 arithmetic_tree ge e m(C a) ->arithmetic_tree ge e m a.
Proof.
 intros ge e m from to C CT;induction CT;intros a TREE;
 cbn[arithmetic_tree]in TREE;try contradiction;try exact TREE;
 repeat match goal with H:_ /\ _|-_=>destruct H end;
 eapply IHCT;eassumption.
Qed.
Lemma arithmetic_lred:forall ge e m a a' mf,
 lred ge e a m a' mf ->arithmetic_tree ge e mf a'.
Proof. intros;inversion H;subst;constructor. Qed.
Lemma arithmetic_rred:forall ge e m a t a' mf,
 arithmetic_tree ge e m a ->rred ge a m t a' mf ->
 arithmetic_tree ge e mf a'.
Proof.
 intros ge e m a t a' mf TREE RED;inversion RED;subst;cbn[arithmetic_tree]in *;try contradiction;try tauto;try solve[constructor].
 all:try solve[destruct b;tauto].
 - repeat match goal with H:_ /\ _|-_=>destruct H end.
   repeat split;try constructor.
   unfold assignop_condition,binary_condition in *;cbn[pure_lval pure_rval typeof]in *.
   lazymatch goal with DR:deref_loc ge ?ty ?mm ?b ?ofs ?bf ?tr ?vl,NV:nv ?ty=true|-_ =>
    assert(TT:tr=E0)by(eapply deref_loc_silent;eauto);subst tr;
    pose proof(Cexec.do_deref_loc_complete ge quiet_world _ _ _ _ _ quiet_world E0 _ DR(possible_trace_nil _))as D;
    rewrite D in *;assumption end.
Qed.
Lemma arithmetic_binary_head:forall ge e m op va ta vb tb ty,
 arithmetic_tree ge e m(Ebinop op(Eval va ta)(Eval vb tb)ty) ->
 binary_safe op ta tb va vb.
Proof. intros;cbn[arithmetic_tree binary_condition pure_rval typeof]in H;tauto. Qed.
Lemma arithmetic_unary_head:forall ge e m op va ta ty,
 arithmetic_tree ge e m(Eunop op(Eval va ta)ty) ->
 unary_safe op ta va.
Proof. intros;cbn[arithmetic_tree unary_condition pure_rval typeof]in H;tauto. Qed.
Print Assumptions arithmetic_context_congr.
Print Assumptions arithmetic_rred.


Lemma arithmetic_atomic_estep:forall ge f a k e m t next,
 atomic_expr a=true ->arithmetic_tree ge e m a ->
 Csem.estep ge(ExprState f a k e m)t next ->
 next=Stuckstate \/exists a' mf,
 next=ExprState f a' k e mf /\atomic_expr a'=true /\arithmetic_tree ge e mf a'.
Proof.
 intros ge f a k e m t next AT TREE STEP.
 destruct(atomic_estep ge f a k e m t next AT STEP)as[BAD|[a'[mf[EQ[TT[SY DEN]]]]]];[left;exact BAD|].
 right;exists a',mf;split;[exact EQ|];split;[exact SY|].
 subst next;inversion STEP;subst.
 - lazymatch goal with LR:lred ge e ?sub m ?sub' ?mm,CT:Csem.context LV RV ?C|-_ =>
   destruct(pure_lred ge e sub m sub' mm LR)as[MM[TY[SS EE]]];subst mm;
   eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact EE|exact TREE|];
   eapply arithmetic_lred;exact LR end.
 - lazymatch goal with RR:rred ge ?sub m ?tr ?sub' ?mm,CT:Csem.context RV RV ?C|-_ =>
   destruct(simple sub)eqn:SA;
   [destruct(pure_rred ge e sub m tr sub' mm SA RR)as[MM[TT0[TY[SS EE]]]];subst mm;
    eapply arithmetic_context_congr;[exact CT|symmetry;exact TY|exact EE|exact TREE|];
    eapply arithmetic_rred;[eapply arithmetic_context_hole;[exact CT|exact TREE]|exact RR]
   |pose proof(atomic_effect_root C CT sub AT SA)as ID;
    repeat rewrite ID in TREE|-*;eapply arithmetic_rred;[exact TREE|exact RR]]end.
Qed.

Lemma arithmetic_observed_binary:forall ge e m from C op va ta vb tb ty,
 context from RV C ->from=RV ->
 arithmetic_tree ge e m(C(Ebinop op(Eval va ta)(Eval vb tb)ty)) ->
 binary_safe op ta tb va vb.
Proof.
 intros ge e m from C op va ta vb tb ty CT KIND TREE;subst from.
 eapply arithmetic_binary_head;eapply arithmetic_context_hole;[exact CT|exact TREE].
Qed.
Lemma arithmetic_observed_unary:forall ge e m from C op va ta ty,
 context from RV C ->from=RV ->
 arithmetic_tree ge e m(C(Eunop op(Eval va ta)ty)) ->
 unary_safe op ta va.
Proof.
 intros ge e m from C op va ta ty CT KIND TREE;subst from.
 eapply arithmetic_unary_head;eapply arithmetic_context_hole;[exact CT|exact TREE].
Qed.
Print Assumptions arithmetic_atomic_estep.
