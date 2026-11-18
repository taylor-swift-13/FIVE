From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceSoftwareProof Require Import GuardTrace ValueEvaluator ValueChecker NumericOps LocalMemory FlatStatements ValueSound AssignmentSound ValueStatementSound.
Import ListNotations.
Definition guard_operands(g:integer_guard):list expr:=match g with
 |SignedAdd a b|SignedSub a b=>[a;b]
 |Unsigned32ToSigned a|Unsigned64ToUnsigned32 a|Signed32ToUnsigned a=>[a]end.
Section SOUND.
Variables uid ff uf:ident.
Variable gamma:PTree.t type.
Local Notation ce:=(check_expr uid ff uf gamma).
Definition event_at(ge:Csem.genv)(le:env)(m:mem)(ev:guard_event):Prop:=
 locals_repr(event_env ev)le m /\
 forall a,In a(guard_operands(event_guard ev))->exists v,
 value_expr uid ff uf gamma(event_env ev)a=Some v /\pure_rval ge le m a=Some v.
Lemma guard_operands_checked:forall a ids g,
 ce ids a=true->guard_of a=Some g->forall b,In b(guard_operands g)->ce ids b=true.
Proof.
 intros a ids g CHECK G;destruct a;cbn[guard_of]in G;try discriminate.
 - destruct op;try discriminate;
   destruct(type_eq ty tint);try discriminate;injection G as GG;subst g;
   cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[AB SAFE];apply andb_true_iff in AB as[A B];
   intros b IN;cbn[guard_operands]in IN;destruct IN as[<-|[<-|IN]];try contradiction;assumption.
 - repeat match goal with G:context[if ?test then _ else _]|-_=>destruct test end;
   try discriminate;injection G as GG;subst g;cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[A SAFE];
   intros b IN;cbn[guard_operands]in IN;destruct IN as[<-|IN];[exact A|contradiction].
Qed.
Lemma own_event_at:forall a ids off rho ge le m,
 ce ids a=true->env_matches gamma le->union_layout uid ff uf ge->
 locals_repr rho le m->initialized_values uid gamma ids rho->
 Forall(event_at ge le m)(match guard_of a with
 |Some g=>[GuardEvent(off+length(expression_sites a)-1)g rho]|None=>[]end).
Proof.
 intros a ids off rho ge le m CHECK ENV LAYOUT REP INIT;destruct(guard_of a)as[g|]eqn:G;[|constructor].
 constructor;[|constructor];split;[exact REP|].
 intros b IN;destruct(checked_expr_sound uid ff uf gamma b ids rho ge le m(guard_operands_checked a ids g CHECK G b IN)ENV LAYOUT REP INIT)
 as[v[V[T PURE]]];exists v;split;assumption.
Qed.
Lemma expression_trace_at:forall a ids off rho ge le m,
 ce ids a=true->env_matches gamma le->union_layout uid ff uf ge->
 locals_repr rho le m->initialized_values uid gamma ids rho->
 Forall(event_at ge le m)(expression_trace off rho a).
Proof.
 induction a;intros ids off rho ge le m CHECK ENV LAYOUT REP INIT;try discriminate CHECK.
 - constructor.
 - cbn[check_expr]in CHECK;discriminate.
 - constructor.
 - cbn[check_expr]in CHECK;discriminate.
 - cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[A SAFE].
   cbn[expression_trace guard_of];rewrite app_nil_r;apply IHa with(ids:=ids);assumption.
 - pose proof CHECK as WHOLE;cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[AB SAFE];apply andb_true_iff in AB as[A B].
   cbn[expression_trace];apply Forall_app;split.
   + apply Forall_app;split;[eapply IHa1|eapply IHa2];eauto.
   + eapply own_event_at;eauto.
 - pose proof CHECK as WHOLE;cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[A SAFE].
   cbn[expression_trace];apply Forall_app;split;[eapply IHa;eauto|eapply own_event_at;eauto].
Qed.
End SOUND.
