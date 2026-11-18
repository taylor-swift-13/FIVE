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
   intros b IN;cbn[guard_operands]in IN;destruct IN as[<-|IN];try contradiction;exact A.
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
 induction a;intros ids off rho ge le m CHECK ENV LAYOUT REP INIT;cbn[check_expr]in CHECK;try discriminate CHECK.
 - constructor.
 - constructor.
 - cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[A SAFE].
   cbn[expression_trace guard_of];rewrite app_nil_r;apply IHa with(ids:=ids);assumption.
 - pose proof CHECK as WHOLE;cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[AB SAFE];apply andb_true_iff in AB as[A B].
   cbn[expression_trace];apply Forall_app;split.
   + apply Forall_app;split;[eapply IHa1|eapply IHa2];eauto.
   + eapply own_event_at;eauto.
 - pose proof CHECK as WHOLE;cbn[check_expr]in CHECK;apply andb_true_iff in CHECK as[A SAFE].
   cbn[expression_trace];apply Forall_app;split;[eapply IHa;eauto|eapply own_event_at;eauto].
Qed.


Lemma place_trace_empty:forall l p off rho,place_of uid ff uf gamma l=Some p->
 expression_sites l=[] /\expression_trace off rho l=[].
Proof.
 intros l p off rho P;destruct(place_shape uid ff uf gamma l p P)as[_[_ SHAPE]].
 destruct SHAPE as[[_[-> SAME]]|[_[_[[FLOAT ->]|[UINT ->]]]]];split;reflexivity.
Qed.
Lemma assignment_trace_at:forall ids l r ty ids' off rho ge le m,
 check_assign uid ff uf gamma ids l r ty=Some ids'->
 env_matches gamma le->union_layout uid ff uf ge->locals_repr rho le m->initialized_values uid gamma ids rho->
 Forall(event_at ge le m)(expression_trace off rho(Eassign l r ty)).
Proof.
 intros ids l r ty ids' off rho ge le m CHECK ENV LAYOUT REP INIT.
 unfold check_assign in CHECK;destruct(type_eq ty(typeof l));try discriminate.
 destruct(place_of uid ff uf gamma l)as[p|]eqn:P;try discriminate.
 destruct(ce ids r && safe_cast(typeof r)(typeof l))eqn:C;try discriminate.
 apply andb_true_iff in C as[R CAST].
 destruct(place_trace_empty l p off rho P)as[SITES TRACE].
 cbn[expression_trace guard_of];rewrite SITES,TRACE;cbn;rewrite Nat.add_0_r,app_nil_r.
 eapply expression_trace_at;eauto.
Qed.
Inductive instrumented_execution(ge:Csem.genv)(le:env):
 nat->PTree.t val->mem->statement->value_outcome->mem->list guard_event->Prop:=
 |IEskip:forall off rho m,
 locals_repr rho le m->
 Cstrategy.exec_stmt ge le m Sskip E0 m Out_normal->
 instrumented_execution ge le off rho m Sskip(ValueNormal rho)m[]
 |IEassign:forall off rho m l r ty rho' mf,
 locals_repr rho le m->value_assign uid ff uf gamma rho l r ty=Some rho'->
 Forall(event_at ge le m)(expression_trace off rho(Eassign l r ty))->
 Cstrategy.exec_stmt ge le m(Sdo(Eassign l r ty))E0 mf Out_normal->
 instrumented_execution ge le off rho m(Sdo(Eassign l r ty))(ValueNormal rho')mf(expression_trace off rho(Eassign l r ty))
 |IEseq_normal:forall off rho m a b rho1 mi ta o mf tb,
 instrumented_execution ge le off rho m a(ValueNormal rho1)mi ta->
 instrumented_execution ge le(off+length(statement_sites a))rho1 mi b o mf tb->
 Cstrategy.exec_stmt ge le m(Ssequence a b)E0 mf(runtime_outcome o)->
 instrumented_execution ge le off rho m(Ssequence a b)o mf(ta++tb)
 |IEseq_return:forall off rho m a b v ty rho1 mf ta,
 instrumented_execution ge le off rho m a(ValueReturn v ty rho1)mf ta->
 Cstrategy.exec_stmt ge le m(Ssequence a b)E0 mf(Out_return(Some(v,ty)))->
 instrumented_execution ge le off rho m(Ssequence a b)(ValueReturn v ty rho1)mf ta
 |IEif:forall off rho m c yes no v choose o mf t,
 locals_repr rho le m->
 value_expr uid ff uf gamma rho c=Some v->pure_rval ge le m c=Some v->bool_val v(typeof c)m=Some choose->
 Forall(event_at ge le m)(expression_trace off rho c)->
 instrumented_execution ge le(off+length(expression_sites c)+(if choose then 0 else length(statement_sites yes)))rho m(if choose then yes else no)o mf t->
 Cstrategy.exec_stmt ge le m(Sifthenelse c yes no)E0 mf(runtime_outcome o)->
 instrumented_execution ge le off rho m(Sifthenelse c yes no)o mf(expression_trace off rho c++t)
 |IEreturn:forall off rho m a v,
 locals_repr rho le m->value_expr uid ff uf gamma rho a=Some v->pure_rval ge le m a=Some v->
 Forall(event_at ge le m)(expression_trace off rho a)->
 Cstrategy.exec_stmt ge le m(Sreturn(Some a))E0 m(Out_return(Some(v,typeof a)))->
 instrumented_execution ge le off rho m(Sreturn(Some a))(ValueReturn v(typeof a)rho)m(expression_trace off rho a).
Lemma instrumented_erases:forall ge le off rho m s o mf t,
 instrumented_execution ge le off rho m s o mf t->Cstrategy.exec_stmt ge le m s E0 mf(runtime_outcome o).
Proof. intros ge le off rho m s o mf t H;inversion H;subst;assumption. Qed.
Lemma instrumented_events:forall ge le off rho m s o mf t,
 instrumented_execution ge le off rho m s o mf t->
 forall ev,In ev t->exists at_memory,event_at ge le at_memory ev.
Proof.
 intros ge le off rho m s o mf t H;induction H;intros ev IN;try contradiction.
 - exists m;apply Forall_forall with(x:=ev)in H1;assumption.
 - apply in_app_iff in IN as[IN|IN];[apply IHinstrumented_execution1|apply IHinstrumented_execution2];exact IN.
 - apply IHinstrumented_execution;exact IN.
 - apply in_app_iff in IN as[IN|IN].
   + exists m;apply Forall_forall with(x:=ev)in H3;assumption.
   + destruct choose;apply IHinstrumented_execution;exact IN.
 - exists m;apply Forall_forall with(x:=ev)in H2;assumption.
Qed.
Theorem checked_instrumented:forall s ret ids expected off rho ge le m,
 source_statement s=true->check_statement uid ff uf gamma ret ids s=Some expected->
 env_matches gamma le->union_layout uid ff uf ge->env_separated le->
 locals_repr rho le m->locals_writable le m->initialized_values uid gamma ids rho->
 exists o mf t,
 value_statement uid ff uf gamma rho s=Some o /\
 statement_trace uid ff uf gamma off rho s=Some(o,t) /\
 statement_eval ge le s m=Some(runtime_outcome o,mf) /\
 good_value_outcome uid gamma ret expected o /\heap_result le m mf o /\
 instrumented_execution ge le off rho m s o mf t.
Proof.
 induction s;intros ret ids expected off rho ge le m SOURCE CHECK ENV LAYOUT SEP REP W INIT;
 cbn[check_statement]in CHECK;try discriminate.
 - injection CHECK as E;subst expected;exists(ValueNormal rho),m,[];split;[reflexivity|];split;[reflexivity|];split;[reflexivity|];split;[exact INIT|];split;[apply heap_result_refl;assumption|constructor;[exact REP|constructor]].
 - destruct e;try discriminate.
   destruct(check_assign uid ff uf gamma ids e1 e2 ty)as[ids'|]eqn:CA;try discriminate;injection CHECK as E;subst expected.
   destruct(checked_assign_sound uid ff uf gamma ids e1 e2 ty ids' rho ge le m CA ENV LAYOUT SEP REP W INIT)
   as[rho'[mf[VA[EV[INIT'[REP'[W'[ACC HISTORY]]]]]]]].
   exists(ValueNormal rho'),mf,(expression_trace off rho(Eassign e1 e2 ty));split.
   + cbn[value_statement];rewrite VA;reflexivity.
   + split;[cbn[statement_trace];rewrite VA;reflexivity|];split;[exact EV|];split;[exact INIT'|];split.
     * split;[exact REP'|];split;[exact W'|];split;[exact ACC|exact HISTORY].
     * eapply IEassign;[exact REP|exact VA|eapply assignment_trace_at;eauto|eapply statement_eval_sound;eauto].
 - cbn[source_statement]in SOURCE;apply andb_true_iff in SOURCE as[S1 S2].
   destruct(check_statement uid ff uf gamma ret ids s1)as[first|]eqn:C1;try discriminate.
   destruct(IHs1 ret ids first off rho ge le m S1 C1 ENV LAYOUT SEP REP W INIT)as[o1[mi[t1[V1[T1[E1[G1[H1 TREE1]]]]]]]].
   destruct first as[ids1|].
   + destruct o1 as[rho1|v ty rho1].
     * destruct H1 as[R1[W1[A1 HST1]]].
       destruct(IHs2 ret ids1 expected(off+length(statement_sites s1))rho1 ge le mi S2 CHECK ENV LAYOUT SEP R1 W1 G1)
       as[o2[mf[t2[V2[T2[E2[G2[H2 TREE2]]]]]]]].
       assert(E:statement_eval ge le(Ssequence s1 s2)m=Some(runtime_outcome o2,mf))by(cbn[statement_eval];rewrite E1;exact E2).
       exists o2,mf,(t1++t2);split;[cbn[value_statement];rewrite V1;exact V2|];split;[cbn[statement_trace];rewrite T1,T2;reflexivity|];split;[exact E|];split;[exact G2|];split.
       -- eapply heap_result_trans;[split;[exact R1|];split;[exact W1|];split;[exact A1|exact HST1]|exact H2].
       -- eapply IEseq_normal;[exact TREE1|exact TREE2|eapply statement_eval_sound;[cbn[source_statement];rewrite S1,S2;reflexivity|exact E]].
     * assert(E:statement_eval ge le(Ssequence s1 s2)m=Some(Out_return(Some(v,ty)),mi))by(cbn[statement_eval];rewrite E1;reflexivity).
       exists(ValueReturn v ty rho1),mi,t1;split;[cbn[value_statement];rewrite V1;reflexivity|];split;[cbn[statement_trace];rewrite T1;reflexivity|];split;[exact E|];split;[exact G1|];split;[exact H1|].
       eapply IEseq_return;[exact TREE1|eapply statement_eval_sound;[cbn[source_statement];rewrite S1,S2;reflexivity|exact E]].
   + injection CHECK as E;subst expected;destruct o1 as[rho1|v ty rho1];[contradiction G1|].
     assert(E:statement_eval ge le(Ssequence s1 s2)m=Some(Out_return(Some(v,ty)),mi))by(cbn[statement_eval];rewrite E1;reflexivity).
     exists(ValueReturn v ty rho1),mi,t1;split;[cbn[value_statement];rewrite V1;reflexivity|];split;[cbn[statement_trace];rewrite T1;reflexivity|];split;[exact E|];split;[exact G1|];split;[exact H1|].
     eapply IEseq_return;[exact TREE1|eapply statement_eval_sound;[cbn[source_statement];rewrite S1,S2;reflexivity|exact E]].
 - pose proof SOURCE as SOURCEWHOLE;cbn[source_statement]in SOURCE;apply andb_true_iff in SOURCE as[LEFT S2];apply andb_true_iff in LEFT as[COND S1].
   destruct(check_expr uid ff uf gamma ids e)eqn:CE;try discriminate.
   destruct(check_statement uid ff uf gamma ret ids s1)as[a|]eqn:C1;try discriminate.
   destruct(check_statement uid ff uf gamma ret ids s2)as[b|]eqn:C2;try discriminate;injection CHECK as E;subst expected.
   destruct(checked_expr_sound uid ff uf gamma e ids rho ge le m CE ENV LAYOUT REP INIT)as[v[VE[TV PE]]].
   destruct(bool_val_total(typeof e)v TV)as[choose B].
   assert(POINTS:Forall(event_at ge le m)(expression_trace off rho e))by(eapply expression_trace_at;eauto).
   destruct choose.
   + destruct(IHs1 ret ids a(off+length(expression_sites e)+0)rho ge le m S1 C1 ENV LAYOUT SEP REP W INIT)as[o[mf[t[VO[TO[EO[GO[HO TREE]]]]]]]].
     assert(E:statement_eval ge le(Sifthenelse e s1 s2)m=Some(runtime_outcome o,mf))by(cbn[statement_eval];rewrite PE,B;exact EO).
     exists o,mf,(expression_trace off rho e++t);split;[cbn[value_statement];rewrite VE,B;exact VO|];split;[cbn[statement_trace];rewrite VE,B;exact TO|];split;[exact E|];split;[eapply good_join_left;exact GO|];split;[exact HO|].
     eapply IEif with(v:=v)(choose:=true);eauto;[apply B|eapply statement_eval_sound;eauto].
   + destruct(IHs2 ret ids b(off+length(expression_sites e)+length(statement_sites s1))rho ge le m S2 C2 ENV LAYOUT SEP REP W INIT)as[o[mf[t[VO[TO[EO[GO[HO TREE]]]]]]]].
     assert(E:statement_eval ge le(Sifthenelse e s1 s2)m=Some(runtime_outcome o,mf))by(cbn[statement_eval];rewrite PE,B;exact EO).
     exists o,mf,(expression_trace off rho e++t);split;[cbn[value_statement];rewrite VE,B;exact VO|];split;[cbn[statement_trace];rewrite VE,B;exact TO|];split;[exact E|];split;[eapply good_join_right;exact GO|];split;[exact HO|].
     eapply IEif with(v:=v)(choose:=false);eauto;[apply B|eapply statement_eval_sound;eauto].
 - destruct o as[a|];try discriminate.
   destruct(check_expr uid ff uf gamma ids a)eqn:CE;try discriminate;destruct(type_eq(typeof a)ret)as[TY|NE];try discriminate;injection CHECK as E;subst expected.
   destruct(checked_expr_sound uid ff uf gamma a ids rho ge le m CE ENV LAYOUT REP INIT)as[v[VE[TV PE]]].
   assert(E:statement_eval ge le(Sreturn(Some a))m=Some(Out_return(Some(v,typeof a)),m))by(cbn[statement_eval];rewrite PE;reflexivity).
   exists(ValueReturn v(typeof a)rho),m,(expression_trace off rho a);split;[cbn[value_statement];rewrite VE;reflexivity|];split;[cbn[statement_trace];rewrite VE;reflexivity|];split;[exact E|];split.
   + cbn;split;[exact TY|rewrite <- TY;exact TV].
   + split;[apply heap_result_return;assumption|].
     eapply IEreturn;[exact REP|exact VE|exact PE|eapply expression_trace_at;eauto|eapply statement_eval_sound;eauto].
Qed.
End SOUND.
Print Assumptions checked_instrumented.
