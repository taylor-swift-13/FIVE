From Stdlib Require Import Bool List String ZArith.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Smallstep.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From PprzTrigRelationSupport Require Import PlainCore.
From PprzTrigInitSupport Require Import SideEffects.
Import ListNotations.

(** Syntax closure only.  No input value, memory permission, initialized byte,
    numerical range, successful call, or program outcome is assumed here. *)
Fixpoint qexpr(a:expr):bool :=
 match a with
 |Eval _ ty|Evar _ ty|Eloc _ _ _ ty|Esizeof _ ty|Ealignof _ ty=>nv ty
 |Efield a _ ty|Evalof a ty|Ederef a ty|Eaddrof a ty|Eunop _ a ty|Ecast a ty
 |Eparen a _ ty=>nv ty&&qexpr a
 |Ebinop _ a b ty|Eseqand a b ty|Eseqor a b ty|Eassign a b ty|Ecomma a b ty=>nv ty&&qexpr a&&qexpr b
 |Eassignop _ a b tyres ty=>nv ty&&nv tyres&&qexpr a&&qexpr b
 |Epostincr _ a ty=>nv ty&&nv(incrdecr_type ty)&&qexpr a
 |Econdition a b c ty=>nv ty&&qexpr a&&qexpr b&&qexpr c
 |Ecall a args ty=>nv ty&&qexpr a&&qexprlist args
 |Ebuiltin _ _ _ _=>false
 end
with qexprlist(args:exprlist):bool :=match args with Enil=>true|Econs a tail=>qexpr a&&qexprlist tail end.
Lemma qexpr_quiet : forall a,qexpr a=true->quiet_expr a=true
with qexprlist_quiet : forall args,qexprlist args=true->quiet_exprlist args=true.
Proof.
 induction a;simpl;intros H;core_unpack;try discriminate;core_build;eauto using qexprlist_quiet.
 induction args;simpl;intros H;core_unpack;core_build;eauto using qexpr_quiet.
Qed.
Lemma qcontext_hole : forall from to C,Csem.context from to C->forall a,qexpr(C a)=true->qexpr a=true
with qcontextlist_hole : forall from C,Csem.contextlist from C->forall a,qexprlist(C a)=true->qexpr a=true.
Proof.
 induction 1;simpl;intros a QUIET;core_unpack;try discriminate;eauto.
 induction 1;simpl;intros a QUIET;core_unpack;eauto.
Qed.
Lemma qcontext_replace : forall from to C,Csem.context from to C->forall a b,
 qexpr(C a)=true->qexpr b=true->qexpr(C b)=true
with qcontextlist_replace : forall from C,Csem.contextlist from C->forall a b,
 qexprlist(C a)=true->qexpr b=true->qexprlist(C b)=true.
Proof.
 induction 1;simpl;intros a b A B;core_unpack;try discriminate;core_build;eauto.
 induction 1;simpl;intros a b A B;core_unpack;core_build;eauto.
Qed.
Lemma q_lred : forall ge e a m a' m',qexpr a=true->lred ge e a m a' m'->qexpr a'=true.
Proof. intros;inversion H0;subst;simpl in *;core_unpack;auto. Qed.
Lemma q_rred : forall ge a m t a' m',qexpr a=true->rred ge a m t a' m'->qexpr a'=true.
Proof.
 intros;inversion H0;subst;simpl in *;core_unpack;try discriminate;core_build;auto.
 - destruct b;assumption.
Qed.

Definition leaf_expr(a:expr):bool :=match a with Eval _ _|Evar _ _|Eloc _ _ _ _=>true|_=>false end.
Lemma leaf_context : forall from to C,Csem.context from to C ->forall a leaf,
 leaf_expr leaf=true ->C a=leaf ->from=to /\a=leaf /\forall z,C z=z.
Proof.
 intros from to C CT a leaf LE EQ;destruct leaf;try discriminate LE;
 inversion CT;subst;cbn in EQ;try discriminate;repeat split;auto.
Qed.
Section ORIGINS.
Variable ge:Csem.genv.
Variable allowed:function->Prop.
Inductive designator(e:env):expr->Prop :=
| des_name : forall id args ret cc b target,
 e!id=None ->Genv.find_symbol ge id=Some b ->
 Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target) ->allowed target ->
 designator e(Evalof(Evar id(Tfunction args ret cc))(Tfunction args ret cc))
| des_loc : forall args ret cc b target,
 Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target) ->allowed target ->
 designator e(Evalof(Eloc b Ptrofs.zero Full(Tfunction args ret cc))(Tfunction args ret cc))
| des_value : forall args ret cc b target,
 Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target) ->allowed target ->
 designator e(Eval(Vptr b Ptrofs.zero)(Tfunction args ret cc)).
Lemma designator_head_rred : forall e a m t a' m',designator e a ->rred ge a m t a' m' ->designator e a'.
Proof.
 intros e a m t a' m' DES RR;inversion DES;subst;inversion RR;subst.
 match goal with D:deref_loc _ _ _ _ _ _ _ _|-_=>inversion D;subst;cbn[access_mode]in *;try discriminate end.
 eapply des_value;eauto.
Qed.
Lemma designator_lred_context : forall e from C a m a' m',
 Csem.context from RV C ->from=LV ->designator e(C a) ->lred ge e a m a' m' ->designator e(C a').
Proof.
 intros e from C a m a' m' CT KIND DES LR;subst from.
 remember(C a)as whole eqn:EQ;inversion DES;subst whole;
 inversion CT;subst C;try discriminate.
 all:match goal with E:Evalof ?LEAF ?TF=Evalof(?C ?A)?TY,SUB:Csem.context LV LV ?C|-_=>
  inversion E;subst TY;
  destruct(leaf_context _ _ _ SUB A LEAF eq_refl ltac:(congruence))as[KK[AA ID]];
  try(rewrite AA in LR);repeat rewrite ID end.
 all:inversion LR;subst;try congruence.
 eapply des_loc;eauto;congruence.
Qed.
Lemma designator_rred_context : forall e C a m t a' m',
 Csem.context RV RV C ->designator e(C a) ->rred ge a m t a' m' ->designator e(C a').
Proof.
 intros e C a m t a' m' CT DES RR.
 remember(C a)as whole eqn:EQ;inversion DES;subst whole;
 inversion CT;subst C;try discriminate.
 all:try(solve[eapply designator_head_rred;eauto]).
 all:match goal with E:Evalof ?LEAF ?TF=Evalof(?C ?A)?TY,SUB:Csem.context RV LV ?C|-_=>
  inversion E;subst TY;
  destruct(leaf_context _ _ _ SUB A LEAF eq_refl ltac:(congruence))as[BAD _];discriminate end.
Qed.
Fixpoint origin_expr(e:env)(a:expr):Prop :=
 match a with
 |Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>origin_expr e a
 |Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>origin_expr e a/\origin_expr e b
 |Econdition a b c _=>origin_expr e a/\origin_expr e b/\origin_expr e c
 |Ecall a args _=>designator e a/\origin_exprlist e args
 |Ebuiltin _ _ args _=>origin_exprlist e args
 |_=>True end
with origin_exprlist(e:env)(args:exprlist):Prop :=match args with Enil=>True|Econs a tail=>origin_expr e a/\origin_exprlist e tail end.
Lemma designator_origin : forall e a,designator e a ->origin_expr e a.
Proof. intros e a H;inversion H;subst;exact I. Qed.
Lemma origin_context_hole : forall from to C,Csem.context from to C->forall e a,
 origin_expr e(C a)->origin_expr e a
with origin_contextlist_hole : forall from C,Csem.contextlist from C->forall e a,
 origin_exprlist e(C a)->origin_expr e a.
Proof.
 induction 1;simpl;intros e a O;intuition eauto using designator_origin.
 induction 1;simpl;intros e a O;intuition eauto.
Qed.

Lemma origin_lred_head : forall e a m a' m',origin_expr e a ->lred ge e a m a' m' ->origin_expr e a'.
Proof. intros;inversion H0;subst;exact I. Qed.
Lemma origin_rred_head : forall e a m t a' m',origin_expr e a ->rred ge a m t a' m' ->origin_expr e a'.
Proof. intros;inversion H0;subst;simpl in *;try tauto;destruct b;tauto. Qed.
Lemma origin_lred_context : forall from to C,Csem.context from to C ->from=LV ->forall e a m a' m',
 origin_expr e(C a)->lred ge e a m a' m' ->origin_expr e(C a')
with origin_lred_list : forall from C,Csem.contextlist from C ->from=LV ->forall e a m a' m',
 origin_exprlist e(C a)->lred ge e a m a' m' ->origin_exprlist e(C a').
Proof.
 induction 1;simpl;intros;subst;intuition eauto using origin_lred_head,designator_lred_context.
 induction 1;simpl;intros;subst;intuition eauto.
Qed.
Lemma origin_rred_context : forall from to C,Csem.context from to C ->from=RV ->forall e a m t a' m',
 origin_expr e(C a)->rred ge a m t a' m' ->origin_expr e(C a')
with origin_rred_list : forall from C,Csem.contextlist from C ->from=RV ->forall e a m t a' m',
 origin_exprlist e(C a)->rred ge a m t a' m' ->origin_exprlist e(C a').
Proof.
 induction 1;simpl;intros;subst;intuition eauto using origin_rred_head,designator_rred_context.
 induction 1;simpl;intros;subst;intuition eauto.
Qed.
Fixpoint no_calls(a:expr):bool :=
 match a with
 |Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>no_calls a
 |Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>no_calls a&&no_calls b
 |Econdition a b c _=>no_calls a&&no_calls b&&no_calls c
 |Ecall _ _ _=>false|Ebuiltin _ _ args _=>no_calls_list args|_=>true end
with no_calls_list(args:exprlist):bool :=match args with Enil=>true|Econs a tail=>no_calls a&&no_calls_list tail end.
Lemma no_calls_hole : forall from to C,Csem.context from to C ->forall a,no_calls(C a)=true->no_calls a=true
with no_calls_list_hole : forall from C,Csem.contextlist from C ->forall a,no_calls_list(C a)=true->no_calls a=true.
Proof.
 induction 1;simpl;intros a NC;core_unpack;try discriminate;eauto.
 induction 1;simpl;intros a NC;core_unpack;eauto.
Qed.
Lemma designator_no_calls : forall e a,designator e a->no_calls a=true.
Proof. intros;inversion H;reflexivity. Qed.
Lemma designator_no_call_context : forall e from C fn args ty,
 Csem.context from RV C ->designator e(C(Ecall fn args ty))->False.
Proof.
 intros e from C fn args ty CT D;pose proof(designator_no_calls _ _ D)as NC.
 pose proof(no_calls_hole _ _ _ CT _ NC);discriminate.
Qed.
Lemma origin_call_replace : forall from to C,Csem.context from to C ->from=RV ->forall e fn args ty v,
 origin_expr e(C(Ecall fn args ty))->origin_expr e(C(Eval v ty))
with origin_call_list_replace : forall from C,Csem.contextlist from C ->from=RV ->forall e fn args ty v,
 origin_exprlist e(C(Ecall fn args ty))->origin_exprlist e(C(Eval v ty)).
Proof.
 induction 1;simpl;intros;subst;intuition eauto using designator_no_call_context.
 exfalso;eapply designator_no_call_context;eauto.
 induction 1;simpl;intros;subst;intuition eauto.
Qed.
Lemma origin_call_internal : forall e a m fd args ty,
 origin_expr e a->callred ge a m fd args ty->exists f,fd=Internal f/\allowed f.
Proof.
 intros e a m fd args ty OR CR;inversion CR;subst;cbn[origin_expr]in OR;destruct OR as[DES REST].
 inversion DES;subst;exists target;split;[congruence|assumption].
Qed.

Variable ids:list ident.
Definition unshadowed(e:env):Prop :=forall id,In id ids->e!id=None.
Definition closed_expr(e:env)(a:expr):Prop :=qexpr a=true/\origin_expr e a.
Fixpoint closed_stmt(e:env)(s:statement):Prop :=
 match s with
 |Sskip|Sbreak|Scontinue|Sreturn None=>True
 |Sdo a|Sreturn(Some a)=>closed_expr e a
 |Ssequence a b=>closed_stmt e a/\closed_stmt e b
 |Sifthenelse a yes no=>closed_expr e a/\closed_stmt e yes/\closed_stmt e no
 |Swhile a body|Sdowhile a body=>closed_expr e a/\closed_stmt e body
 |Sfor init a advance body=>closed_stmt e init/\closed_expr e a/\closed_stmt e advance/\closed_stmt e body
 |_=>False end.
Fixpoint closed_cont(e:env)(k:cont):Prop :=
 match k with
 |Kstop=>True
 |Kdo k|Kreturn k=>closed_cont e k
 |Kseq s k=>closed_stmt e s/\closed_cont e k
 |Kifthenelse yes no k=>closed_stmt e yes/\closed_stmt e no/\closed_cont e k
 |Kwhile1 a body k|Kwhile2 a body k|Kdowhile1 a body k|Kdowhile2 a body k=>closed_expr e a/\closed_stmt e body/\closed_cont e k
 |Kfor2 a advance body k|Kfor3 a advance body k|Kfor4 a advance body k=>
   closed_expr e a/\closed_stmt e advance/\closed_stmt e body/\closed_cont e k
 |Kcall f ec C ty k=>allowed f/\unshadowed ec/\(forall v,closed_expr ec(C(Eval v ty)))/\closed_cont ec k
 |_=>False end.
Definition closed_state(S:Csem.state):Prop :=
 match S with
 |State f s k e _=>allowed f/\unshadowed e/\closed_stmt e s/\closed_cont e k
 |ExprState f a k e _=>allowed f/\unshadowed e/\closed_expr e a/\closed_cont e k
 |Callstate fd _ k _=>(exists f,fd=Internal f/\allowed f)/\is_call_cont k/\(exists e,closed_cont e k)
 |Returnstate _ k _=>exists e,closed_cont e k
 |Stuckstate=>True end.
Lemma closed_cont_call : forall k e,closed_cont e k->closed_cont e(call_cont k).
Proof. induction k;intros current_env H;simpl in *;intuition eauto. Qed.
Lemma closed_cont_call_any : forall k e,is_call_cont k->closed_cont e k->forall e',closed_cont e' k.
Proof. destruct k;simpl;intros;try contradiction;auto. Qed.
Lemma closed_callback_free : forall S,closed_state S->callback_free_state S.
Proof.
 destruct S;simpl;intros H;repeat match goal with H:_/\_|-_=>destruct H end;auto.
 - destruct H1 as[Q O];apply quiet_no_builtin;apply qexpr_quiet;exact Q.
 - destruct H as[f[EQ A]];subst;exact I.
Qed.
Lemma closed_silent : forall S,closed_state S->silent_state ge S.
Proof.
 intros S CS;destruct S;simpl in CS;repeat match goal with H:_/\_|-_=>destruct H end.
 - intros t next[E|T];inversion E||inversion T;reflexivity.
 - apply quiet_expression_silent;apply qexpr_quiet;unfold closed_expr in *;tauto.
 - destruct H as[f[EQ A]];subst;intros t next[E|T];inversion E||inversion T;reflexivity.
 - intros t next[E|T];inversion E||inversion T;reflexivity.
 - intros t next[E|T];inversion E||inversion T.
Qed.
Lemma closed_estep : forall S t S',closed_state S->Csem.estep ge S t S'->closed_state S'.
Proof.
 intros S t S' CS STEP;inversion STEP;subst;cbn[closed_state]in CS;
 destruct CS as[AF[ENV[[QUIET ORIGIN]CONT]]].
 - cbn[closed_state];repeat split;auto.
   + eapply(qcontext_replace _ _ _ H0 a a' QUIET).
     eapply q_lred;[exact(qcontext_hole _ _ _ H0 a QUIET)|exact H].
   + exact(origin_lred_context _ _ _ H0 eq_refl e a m a' m' ORIGIN H).
 - cbn[closed_state];repeat split;auto.
   + eapply(qcontext_replace _ _ _ H0 a a' QUIET).
     eapply q_rred;[exact(qcontext_hole _ _ _ H0 a QUIET)|exact H].
   + exact(origin_rred_context _ _ _ H0 eq_refl e a m t a' m' ORIGIN H).
 - assert(HOLE:origin_expr e a)by(eapply origin_context_hole;eauto).
   destruct(origin_call_internal _ _ _ _ _ _ HOLE H)as[target[FD AT]];subst fd.
   split;[exists target;auto|]. split;[exact I|]. exists empty_env.
   cbn[closed_cont]. split;[exact AF|]. split;[exact ENV|].
   split;[|exact CONT]. intro v;unfold closed_expr;split.
   + eapply(qcontext_replace _ _ _ H0 a(Eval v ty)QUIET).
     assert(Q:qexpr a=true)by(eapply qcontext_hole;eauto).
     inversion H;subst;cbn[qexpr]in Q;core_unpack;assumption.
   + inversion H;subst;eapply(origin_call_replace _ _ _ H0 eq_refl);eauto.
 - exact I.
Qed.
Hypothesis allowed_locals : forall f,allowed f->Forall(fun p=>~In(fst p)ids)(fn_params f++fn_vars f).
Hypothesis allowed_bodies : forall f,allowed f->forall e,unshadowed e->closed_stmt e(fn_body f).
Lemma unshadowed_empty : unshadowed empty_env.
Proof. intros id IN;apply PTree.gempty. Qed.
Lemma unshadowed_alloc : forall env0 m vars e m',alloc_variables ge env0 m vars e m'->
 unshadowed env0->Forall(fun p=>~In(fst p)ids)vars->unshadowed e.
Proof.
 intros env0 m vars e m' AL;induction AL;intros ENV FRESH;auto.
 inversion FRESH;subst;apply IHAL;auto.
 intros function_id IN;rewrite PTree.gso;[apply ENV;exact IN|intro EQ;subst;contradiction].
Qed.
Lemma closed_sstep : forall S t S',closed_state S->Csem.sstep ge S t S'->closed_state S'.
Proof.
 intros S t S' CS STEP;inversion STEP;subst;cbn[closed_state closed_stmt closed_cont]in CS;
 repeat match goal with H:_/\_|-_=>destruct H end;try contradiction;
 cbn[closed_state closed_stmt closed_cont];try(solve[tauto]).
 all:try(solve[destruct b;tauto]).
 all:try(solve[repeat match goal with H:_\/_|-_=>destruct H;subst end;tauto]).
 all:try(solve[eexists;eapply closed_cont_call;eauto]).
 all:try(solve[eexists;eassumption]).
 - destruct H2 as[target[FD AT]];inversion FD;subst.
   destruct H4 as[ec CONT].
   assert(ENV:unshadowed e)by(eapply unshadowed_alloc;eauto using unshadowed_empty,allowed_locals).
   split;[exact AT|]. split;[exact ENV|]. split;[apply allowed_bodies;auto|].
   eapply closed_cont_call_any;eauto.
 - destruct CS as[e0[AF[ENV[EXPR CONT]]]].
   split;[exact AF|]. split;[exact ENV|]. split;[apply EXPR|exact CONT].
Qed.
Theorem closed_step : forall S t S',closed_state S->Csem.step ge S t S'->closed_state S'.
Proof. intros S t S' C[E|T];eauto using closed_estep,closed_sstep. Qed.
Theorem closed_do_step_exact : forall cb asm w S t S',closed_state S->
 ((exists rule,In(TR rule t S')(Cexec.do_step ge cb asm w S))<->Csem.step ge S t S').
Proof. intros;apply pure_do_step_exact;eauto using closed_callback_free,closed_silent. Qed.
End ORIGINS.

Definition static_designator(ids:list ident)(a:expr):bool :=
 match a with
 |Evalof(Evar id tf)tf'=>match tf with
   |Tfunction args ret cc=>if type_eq tf tf' then if in_dec ident_eq id ids then true else false else false
   |_=>false end|_=>false end.
Fixpoint static_expr(ids:list ident)(a:expr):bool :=
 match a with
 |Efield a _ _|Evalof a _|Ederef a _|Eaddrof a _|Eunop _ a _|Ecast a _|Epostincr _ a _|Eparen a _ _=>static_expr ids a
 |Ebinop _ a b _|Eseqand a b _|Eseqor a b _|Eassign a b _|Eassignop _ a b _ _|Ecomma a b _=>static_expr ids a&&static_expr ids b
 |Econdition a b c _=>static_expr ids a&&static_expr ids b&&static_expr ids c
 |Ecall a args _=>static_designator ids a&&static_exprlist ids args
 |Ebuiltin _ _ args _=>static_exprlist ids args|_=>true end
with static_exprlist(ids:list ident)(args:exprlist):bool :=match args with
 |Enil=>true|Econs a tail=>static_expr ids a&&static_exprlist ids tail end.
Fixpoint static_stmt(ids:list ident)(s:statement):bool :=
 match s with
 |Sskip|Sbreak|Scontinue|Sreturn None=>true
 |Sdo a|Sreturn(Some a)=>qexpr a&&static_expr ids a
 |Ssequence a b=>static_stmt ids a&&static_stmt ids b
 |Sifthenelse a yes no=>qexpr a&&static_expr ids a&&static_stmt ids yes&&static_stmt ids no
 |Swhile a body|Sdowhile a body=>qexpr a&&static_expr ids a&&static_stmt ids body
 |Sfor init a advance body=>static_stmt ids init&&qexpr a&&static_expr ids a&&static_stmt ids advance&&static_stmt ids body
 |_=>false end.
Section STATIC_SOUND.
Variable ge:Csem.genv.
Variable allowed:function->Prop.
Variable ids:list ident.
Hypothesis known : forall id,In id ids->exists b target,
 Genv.find_symbol ge id=Some b /\Genv.find_funct ge(Vptr b Ptrofs.zero)=Some(Internal target)/\allowed target.
Lemma static_designator_sound : forall e a,unshadowed ids e->static_designator ids a=true->designator ge allowed e a.
Proof.
 intros e a ENV ST;destruct a;try discriminate ST;destruct a;try discriminate ST;
 destruct ty0;try discriminate ST;cbn[static_designator]in ST.
 match type of ST with context[type_eq ?TF ?TY]=>destruct(type_eq TF TY)as[EQ|BAD];try discriminate;subst TY end.
 destruct(in_dec ident_eq x ids)as[IN|OUT];try discriminate.
 destruct(known _ IN)as[b[target[SYM[FUN AF]]]];eapply des_name;eauto.
Qed.
Lemma static_expr_sound : forall a e,unshadowed ids e->static_expr ids a=true->origin_expr ge allowed e a
with static_exprlist_sound : forall args e,unshadowed ids e->static_exprlist ids args=true->origin_exprlist ge allowed e args.
Proof.
 induction a;simpl;intros e ENV ST;core_unpack;try discriminate;intuition eauto using static_designator_sound,static_exprlist_sound.
 induction args;simpl;intros e ENV ST;core_unpack;intuition eauto using static_expr_sound.
Qed.
Lemma static_stmt_sound : forall s e,unshadowed ids e->static_stmt ids s=true->closed_stmt ge allowed e s.
Proof.
 induction s;simpl;intros current_env ENV ST;core_unpack;try discriminate;unfold closed_expr;
 intuition eauto using static_expr_sound.
 all:match goal with o:option expr|-_=>destruct o;simpl in *;core_unpack;intuition eauto using static_expr_sound end.
Qed.
End STATIC_SOUND.

Require PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import LowDispatcher ModelIdentity.
Definition direct_ids:list ident :=[PprzTrigLow.Source._pprz_trig_int_f;PprzTrigLow.Source._pprz_trig_int_12;
 PprzTrigLow.Source._get_nibble;PprzTrigLow.Source._table_encode_12].
Definition internal_functions:list function :=[PprzTrigLow.Source.f_pprz_itrig_sin;PprzTrigLow.Source.f_pprz_trig_int_f;
 PprzTrigLow.Source.f_pprz_trig_int_12;PprzTrigLow.Source.f_pprz_trig_int_init;
 PprzTrigLow.Source.f_get_nibble;PprzTrigLow.Source.f_table_encode_12].
Definition actual_allowed(f:function):Prop :=In f internal_functions.
Lemma actual_static_bodies : forall f,actual_allowed f->static_stmt direct_ids(fn_body f)=true.
Proof.
 intros f IN;unfold actual_allowed,internal_functions in IN;
 destruct IN as[EQ|[EQ|[EQ|[EQ|[EQ|[EQ|[]]]]]]];subst f;vm_compute;reflexivity.
Qed.
Lemma actual_static_locals : forall f,actual_allowed f->Forall(fun p=>~In(fst p)direct_ids)(fn_params f++fn_vars f).
Proof.
 intros f IN;unfold actual_allowed,internal_functions in IN;
 destruct IN as[EQ|[EQ|[EQ|[EQ|[EQ|[EQ|[]]]]]]];subst f;
 cbn[PprzTrigLow.Source.f_pprz_itrig_sin PprzTrigLow.Source.f_pprz_trig_int_f
  PprzTrigLow.Source.f_pprz_trig_int_12 PprzTrigLow.Source.f_pprz_trig_int_init
  PprzTrigLow.Source.f_get_nibble PprzTrigLow.Source.f_table_encode_12 fn_params fn_vars];
 repeat apply Forall_cons;try constructor;
 unfold direct_ids;cbn;intros[E|[E|[E|[E|[]]]]];vm_compute in E;discriminate.
Qed.
Lemma actual_known_functions : forall id,In id direct_ids->exists b target,
 Genv.find_symbol PprzTrigLow.Execution.ge id=Some b /\
 Genv.find_funct PprzTrigLow.Execution.ge(Vptr b Ptrofs.zero)=Some(Internal target)/\actual_allowed target.
Proof.
 intros id IN;unfold direct_ids in IN;destruct IN as[E|[E|[E|[E|[]]]]];subst id.
 - destruct dispatcher_link as[b[SYM FUN]];exists b,PprzTrigLow.Source.f_pprz_trig_int_f;repeat split;auto.
   unfold actual_allowed,internal_functions;cbn;auto 12.
 - destruct decoder_link as[b[SYM FUN]];exists b,PprzTrigLow.Source.f_pprz_trig_int_12;repeat split;auto.
   unfold actual_allowed,internal_functions;cbn;auto 12.
 - assert(L:exists b,Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._get_nibble=Some b/\
   Genv.find_funct PprzTrigLow.Execution.ge(Vptr b Ptrofs.zero)=Some(Internal PprzTrigLow.Source.f_get_nibble)).
   { apply(source_function_link PprzTrigLow.Source.prog PprzTrigLow.Source._get_nibble PprzTrigLow.Source.f_get_nibble);vm_compute;reflexivity. }
   destruct L as[b[SYM FUN]];exists b,PprzTrigLow.Source.f_get_nibble;repeat split;auto.
   unfold actual_allowed,internal_functions;cbn;auto 12.
 - assert(L:exists b,Genv.find_symbol PprzTrigLow.Execution.ge PprzTrigLow.Source._table_encode_12=Some b/\
   Genv.find_funct PprzTrigLow.Execution.ge(Vptr b Ptrofs.zero)=Some(Internal PprzTrigLow.Source.f_table_encode_12)).
   { apply(source_function_link PprzTrigLow.Source.prog PprzTrigLow.Source._table_encode_12 PprzTrigLow.Source.f_table_encode_12);vm_compute;reflexivity. }
   destruct L as[b[SYM FUN]];exists b,PprzTrigLow.Source.f_table_encode_12;repeat split;auto.
   unfold actual_allowed,internal_functions;cbn;auto 12.
Qed.
Lemma actual_closed_bodies : forall f,actual_allowed f->forall e,unshadowed direct_ids e->
 closed_stmt PprzTrigLow.Execution.ge actual_allowed e(fn_body f).
Proof. intros;eapply static_stmt_sound;eauto using actual_known_functions,actual_static_bodies. Qed.
Definition actual_closed:=closed_state PprzTrigLow.Execution.ge actual_allowed direct_ids.
Lemma actual_step_closed : forall s t s',actual_closed s->Csem.step PprzTrigLow.Execution.ge s t s'->actual_closed s'.
Proof. intros;eapply closed_step;eauto using actual_static_locals,actual_closed_bodies. Qed.
Lemma allowed_start_closed : forall f args m,actual_allowed f->
 actual_closed(Callstate(Internal f)args Kstop m).
Proof. intros;split;[exists f;auto|]. split;[exact I|]. exists empty_env;exact I. Qed.
Lemma actual_star_closed : forall s t s',star Csem.step PprzTrigLow.Execution.ge s t s'->actual_closed s->actual_closed s'.
Proof. intros s t s' PATH;induction PATH;intros;auto;apply IHPATH;eauto using actual_step_closed. Qed.
Theorem low_reachable_closed : forall args m t s,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)t s->actual_closed s.
Proof.
 intros args m t s PATH;eapply actual_star_closed;[exact PATH|].
 apply allowed_start_closed;unfold actual_allowed,internal_functions;cbn;auto 12.
Qed.
Theorem init_reachable_closed : forall args m t s,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)t s->actual_closed s.
Proof.
 intros args m t s PATH.
 change(star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal PprzTrigLow.Source.f_pprz_trig_int_init)args Kstop m)t s)in PATH.
 eapply actual_star_closed;[exact PATH|].
 apply allowed_start_closed;unfold actual_allowed,internal_functions;cbn;auto 12.
Qed.
Theorem low_all_domain_exact : forall args m prefix s cb asm w t next,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s->
 ((exists rule,In(TR rule t next)(Cexec.do_step PprzTrigLow.Execution.ge cb asm w s))<->
 Csem.step PprzTrigLow.Execution.ge s t next).
Proof. intros;eapply closed_do_step_exact;apply low_reachable_closed with(args:=args)(m:=m)(t:=prefix);assumption. Qed.
Theorem init_all_domain_exact : forall args m prefix s cb asm w t next,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix s->
 ((exists rule,In(TR rule t next)(Cexec.do_step PprzTrigInit.Execution.ge cb asm w s))<->
 Csem.step PprzTrigInit.Execution.ge s t next).
Proof. intros;eapply closed_do_step_exact;apply init_reachable_closed with(args:=args)(m:=m)(t:=prefix);assumption. Qed.
Print Assumptions low_all_domain_exact.
Print Assumptions init_all_domain_exact.
