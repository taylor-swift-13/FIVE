(** Callable-value provenance for direct named function calls.  Function
    lvalues retain their actual global block.  Local environments contain only
    ordinary data types, so a function-typed variable cannot resolve through a
    local binding of the same type.  This is a proved syntactic invariant of
    the source executions; it imposes no value or memory precondition. *)
From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec.
From FiveGuidanceSemantics Require Import SemanticsSupport.

Scheme expr_core_ind := Induction for expr Sort Prop
with exprlist_core_ind := Induction for exprlist Sort Prop.
Combined Scheme expr_exprlist_ind from expr_core_ind,exprlist_core_ind.
Scheme context_core_ind := Induction for context Sort Prop
with contextlist_core_ind := Induction for contextlist Sort Prop.
Combined Scheme context_contextlist_ind from context_core_ind,contextlist_core_ind.
Section CLOSURE.
Variable ge:genv.
Variable allowed:Csyntax.fundef -> Prop.
Variable call_budget:type -> Csyntax.fundef -> Prop.

Definition nv (ty:type):Prop := type_is_volatile ty=false.
Definition data_type (ty:type):Prop :=
 match classify_fun ty with fun_default=>True|_=>False end.
Definition safe_value (ty:type)(v:val):Prop :=
 match classify_fun ty with
 | fun_default=>True
 | fun_case_f _ _ _=>forall fd,Genv.find_funct ge v=Some fd -> allowed fd /\ call_budget ty fd
 end.
Definition safe_location (ty:type)(b:block)(ofs:ptrofs)(bf:bitfield):Prop :=
 match ty with
 | Tfunction _ _ _=>bf=Full /\ safe_value ty(Vptr b ofs)
 | _=>data_type ty end.
Definition safe_variable (id:ident)(ty:type):Prop :=
 data_type ty \/ exists b,Genv.find_symbol ge id=Some b /\ safe_location ty b Ptrofs.zero Full.
Definition safe_environment(e:env):Prop :=
 forall id b ty,PTree.get id e=Some(b,ty)->data_type ty.
Fixpoint core_expr (a:expr):Prop :=
 match a with
 | Eval v ty=>nv ty /\ safe_value ty v
 | Eloc b ofs bf ty=>nv ty /\ safe_location ty b ofs bf
 | Evar id ty=>nv ty /\ safe_variable id ty
 | Esizeof _ ty | Ealignof _ ty=>nv ty /\ data_type ty
 | Evalof a ty=>nv ty /\ typeof a=ty /\ core_expr a
 | Efield a _ ty | Ederef a ty | Eaddrof a ty
 | Eunop _ a ty | Ecast a ty | Eparen a _ ty=>nv ty /\ data_type ty /\ core_expr a
 | Ebinop _ a b ty | Eassign a b ty | Ecomma a b ty
 | Eseqand a b ty | Eseqor a b ty=>nv ty /\ data_type ty /\ core_expr a /\ core_expr b
 | Eassignop _ a b tyres ty=>nv ty /\ nv tyres /\ data_type ty /\ data_type tyres /\ core_expr a /\ core_expr b
 | Econdition a b c ty=>nv ty /\ data_type ty /\ core_expr a /\ core_expr b /\ core_expr c
 | Ecall a al ty=>nv ty /\ data_type ty /\ core_expr a /\ core_exprlist al
 | Ebuiltin ef _ al ty=>nv ty /\ data_type ty /\ executable_builtin ef=true /\ core_exprlist al
 | _=>False end
with core_exprlist(al:exprlist):Prop :=
 match al with Enil=>True|Econs a al=>core_expr a /\ core_exprlist al end.

Lemma data_value:forall ty v,data_type ty->safe_value ty v.
Proof. unfold data_type,safe_value;intros;destruct(classify_fun ty);auto;contradiction. Qed.
Lemma data_location:forall ty b ofs bf,data_type ty->safe_location ty b ofs bf.
Proof. intros;destruct ty;cbn[safe_location]in *;auto;contradiction. Qed.
Lemma data_variable:forall id ty,data_type ty->safe_variable id ty.
Proof. intros;left;assumption. Qed.
Lemma safe_deref:forall ty b ofs bf m t v,
 safe_location ty b ofs bf->deref_loc ge ty m b ofs bf t v->safe_value ty v.
Proof.
 intros ty b ofs bf m t v LOC DER;destruct ty;cbn[safe_location]in LOC;
 try(solve[eapply data_value;exact LOC]).
 destruct LOC as[BF SAFE];subst bf;inversion DER;subst;simpl in *;try discriminate;auto.
Qed.

Ltac unpack := repeat match goal with H:_ /\ _ |- _ => destruct H end.
Lemma core_nv: forall a, core_expr a -> nv(typeof a).
Proof. destruct a; simpl; intros; unpack; tauto. Qed.
Lemma core_no_builtin_mut:
 (forall a,core_expr a -> no_builtin a=true) /\
 (forall al,core_exprlist al -> no_builtin_list al=true).
Proof.
 apply expr_exprlist_ind; simpl; intros; unpack; try contradiction;
 repeat match goal with |- _ && _=true => apply Bool.andb_true_iff;split end; auto.
Qed.
Lemma context_type_equal_mut:
 (forall from to C, context from to C -> forall a b,
 typeof a=typeof b -> typeof(C a)=typeof(C b)) /\
 (forall from C, contextlist from C -> True).
Proof.
 apply context_contextlist_ind; simpl; intros; auto.
Qed.

Lemma core_context_mut:
 (forall from to C, context from to C -> forall a b,
 core_expr(C a) -> core_expr a /\
 (typeof a=typeof b -> core_expr b -> core_expr(C b))) /\
 (forall from C, contextlist from C -> forall a b,
 core_exprlist(C a) -> core_expr a /\
 (typeof a=typeof b -> core_expr b -> core_exprlist(C b))).
Proof.
 apply context_contextlist_ind; simpl; intros; unpack; try contradiction;
 try(split;auto;intros;repeat split;auto;fail).
 all: try match goal with IH:forall a b,_ |- _ =>
 specialize(IH a b ltac:(assumption));destruct IH as[HO HR];
 split;auto;intros;repeat split;auto end.
 all: match goal with
 HC:Csem.context _ _ ?C, HT:typeof ?a = typeof ?b, EQ:typeof(?C ?a) = _ |- _ =>
 rewrite <-(proj1 context_type_equal_mut _ _ _ HC a b HT);exact EQ end.
Qed.
Lemma core_context_hole: forall from to C, context from to C -> forall a,
 core_expr(C a) -> core_expr a.
Proof. intros; exact(proj1(proj1 core_context_mut _ _ _ H a a H0)). Qed.
Lemma core_context_replace: forall from to C, context from to C -> forall a b,
 core_expr(C a) -> typeof a=typeof b -> core_expr b -> core_expr(C b).
Proof. intros; eapply(proj2(proj1 core_context_mut _ _ _ H a b H0));eauto. Qed.

Lemma lred_type: forall e a m a' m', lred ge e a m a' m' -> typeof a'=typeof a.
Proof. intros; inversion H; subst; simpl; auto. Qed.
Lemma rred_type: forall a m t a' m', rred ge a m t a' m' -> typeof a'=typeof a.
Proof. intros; inversion H; subst; simpl; auto. Qed.

Lemma core_lred:forall e a m a' m',
 safe_environment e->core_expr a->lred ge e a m a' m'->core_expr a'.
Proof.
 intros e a m a' m' ENV CO RED;inversion RED;subst;simpl in CO;unpack;simpl;split;auto.
 - eapply data_location;eapply ENV;eassumption.
 - destruct H2 as[DATA|[bb[SYM LOC]]];[eapply data_location;exact DATA|].
   assert(bb=b)by congruence;subst;exact LOC.
 - eapply data_location;eassumption.
 - eapply data_location;eassumption.
 - eapply data_location;eassumption.
Qed.
Lemma nv_deref_silent: forall ty m b ofs bf t v,
 nv ty -> deref_loc ge ty m b ofs bf t v -> t=E0.
Proof. intros; inversion H0; subst; unfold nv in *; congruence. Qed.
Lemma nv_assign_silent: forall ty m b ofs bf v t m' v',
 nv ty -> assign_loc ge ty m b ofs bf v t m' v' -> t=E0.
Proof. intros; inversion H0; subst; unfold nv in *; congruence. Qed.

Lemma core_rred:forall a m t a' m',
 core_expr a->rred ge a m t a' m'->t=E0 /\ core_expr a'.
Proof.
 intros a m t a' m' CO RED;inversion RED;subst;simpl in CO;unpack;
 try contradiction;split;simpl;eauto using nv_deref_silent,nv_assign_silent;
 try(solve[repeat split;eauto using data_value,data_location]).
 - split;[assumption|eapply safe_deref;[eassumption|eassumption]].
 - destruct b;simpl;repeat split;auto.
 - eapply(proj1(executable_builtin_silent _ _ _ _ _ _ _ ltac:(eassumption)ltac:(eassumption))).
Qed.
Lemma core_callred:forall a m fd args ty,
 core_expr a->callred ge a m fd args ty->
 allowed fd /\ call_budget (match a with Ecall fn _ _=>typeof fn|_=>Tvoid end) fd /\ nv ty /\ typeof a=ty.
Proof.
 intros a m fd args ty CO RED;inversion RED;subst;simpl in CO;unpack.
 unfold safe_value in H7;rewrite H2 in H7.
 destruct(H7 fd H)as[ALLOW BUD];repeat split;auto.
Qed.

Fixpoint core_stmt (s:statement):Prop :=
 match s with
 | Sskip | Sreturn None => True
 | Sdo a | Sreturn(Some a) => core_expr a
 | Ssequence a b => core_stmt a /\ core_stmt b
 | Sifthenelse a b c => core_expr a /\ core_stmt b /\ core_stmt c
 | _ => False end.
Inductive core_cont:cont -> Prop :=
 | core_stop: core_cont Kstop
 | core_seq: forall s k, core_stmt s -> core_cont k -> core_cont(Kseq s k)
 | core_do: forall k, core_cont k -> core_cont(Kdo k)
 | core_return: forall k, core_cont k -> core_cont(Kreturn k)
 | core_if: forall a b k, core_stmt a -> core_stmt b -> core_cont k -> core_cont(Kifthenelse a b k)
 | core_call: forall f e C ty k,
   context RV RV C -> nv ty -> data_type ty -> safe_environment e ->
   (forall a, typeof a=ty -> core_expr a -> core_expr(C a)) ->
   core_cont k -> core_cont(Kcall f e C ty k).

Definition source_state (s:Csem.state):Prop :=
 match s with
 | State _ stmt k e _ => core_stmt stmt /\ core_cont k /\ safe_environment e
 | ExprState _ a k e _ => core_expr a /\ core_cont k /\ safe_environment e
 | Callstate fd _ k _ => allowed fd /\ core_cont k
 | Returnstate _ k _ => core_cont k
 | Stuckstate => True end.
Hypothesis internal_body: forall f, allowed(Internal f) -> core_stmt(fn_body f).
Hypothesis internal_variables:forall f,allowed(Internal f)->Forall(fun idty=>data_type(snd idty))(fn_params f++fn_vars f).
Hypothesis external_supported: forall ef args ret cc,
 allowed(External ef args ret cc) -> executable_builtin ef=true.


Lemma safe_empty:safe_environment empty_env.
Proof. intros id b ty H;rewrite PTree.gempty in H;discriminate. Qed.
Lemma safe_environment_set:forall e id b ty,
 safe_environment e->data_type ty->safe_environment(PTree.set id(b,ty)e).
Proof.
 intros e id b ty ENV DT x bx tx GET;rewrite PTree.gsspec in GET.
 destruct(peq x id);inversion GET;subst;auto;eapply ENV;eassumption.
Qed.
Lemma safe_allocate:forall e m vars e' m',
 safe_environment e->Forall(fun idty=>data_type(snd idty))vars->
 alloc_variables ge e m vars e' m'->safe_environment e'.
Proof.
 intros e m vars e' m' ENV VARS ALLOC;revert ENV VARS.
 induction ALLOC;intros ENV VARS;auto;inversion VARS;subst.
 eapply IHALLOC;[eapply safe_environment_set;eauto|eassumption].
Qed.

Lemma source_callback_free: forall s,source_state s -> callback_free_state s.
Proof.
 destruct s; simpl; intros; unpack; auto.
 - eapply(proj1 core_no_builtin_mut);eauto.
 - destruct fd; simpl;auto;eauto.
Qed.
Lemma core_call_cont: forall k,core_cont k -> core_cont(call_cont k).
Proof. induction 1;simpl;auto using core_cont. Qed.
Lemma source_estep: forall s t s',source_state s -> estep ge s t s' -> t=E0 /\ source_state s'.
Proof.
 intros s t s' INV STEP; inversion STEP; subst; simpl in INV;unpack.
 - split;auto;simpl;repeat split;auto.
   eapply core_context_replace;[eassumption|eassumption|symmetry;eapply lred_type;eauto|].
   eapply core_lred;[eassumption|eapply core_context_hole;eauto|eauto].
 - pose proof(core_context_hole _ _ _ H0 _ H1) as CA.
   destruct(core_rred _ _ _ _ _ CA H) as [TR CO];split;auto;simpl;repeat split;auto.
   eapply core_context_replace;[eassumption|eassumption|symmetry;eapply rred_type;eauto|eauto].
 - pose proof(core_context_hole _ _ _ H0 _ H1) as CA.
   destruct(core_callred _ _ _ _ _ CA H) as [ALLOW [BUD [NV TY]]].
   assert(DATA:data_type ty)by(inversion H;subst;simpl in CA;tauto).
   split;auto;simpl;repeat split;auto.
   eapply core_call;[eassumption|exact NV|exact DATA|eassumption| |eassumption].
   intros a0 HT CO;eapply core_context_replace;[eassumption|eassumption|congruence|eassumption].
 - split;auto;exact I.
Qed.
Lemma source_sstep: forall s t s',source_state s -> sstep ge s t s' -> t=E0 /\ source_state s'.
Proof.
 intros s t s' INV STEP;inversion STEP;subst;simpl in INV;unpack;try contradiction;
 split;auto;simpl;try (repeat split;eauto using core_cont,core_call_cont,internal_body,safe_empty,safe_allocate,internal_variables;fail).
 all: try match goal with CC:core_cont(Kseq _ _) |- _ => inversion CC;subst;auto end.
 all: try match goal with CC:core_cont(Kdo _) |- _ => inversion CC;subst;auto end.
 all: try match goal with CC:core_cont(Kifthenelse _ _ _) |- _ => inversion CC;subst;auto end.
 all: try match goal with CC:core_cont(Kreturn _) |- _ => inversion CC;subst;eauto using core_call_cont end.
 all: try match goal with CC:core_cont(Kcall _ _ _ _ _) |- _ => inversion CC;subst;auto end.
 all: try match goal with CC:core_cont ?K |- _ => tryif is_var K then fail else (inversion CC;subst;auto) end.
 - destruct b;auto.
 - eapply(proj1(executable_builtin_silent _ _ _ _ _ _ _ ltac:(eapply external_supported;eauto) ltac:(eassumption))).
- repeat split;auto.
   match goal with CT:forall a, typeof a=_ -> core_expr a -> core_expr(C a) |- _ =>
   apply CT;[reflexivity|simpl;split;eauto using data_value] end.
Qed.
Theorem source_step_invariant: forall s t s',source_state s -> Csem.step ge s t s' -> t=E0 /\ source_state s'.
Proof. intros s t s' INV [ES|SS];eauto using source_estep,source_sstep. Qed.
Theorem source_silent:forall s,source_state s -> silent_state ge s.
Proof. intros s INV t s' STEP;exact(proj1(source_step_invariant _ _ _ INV STEP)). Qed.
Theorem source_do_step_exact:forall cb asm w s t s',source_state s ->
 ((exists rule, In(TR rule t s')(Cexec.do_step ge cb asm w s)) <-> Csem.step ge s t s').
Proof. intros;apply pure_do_step_exact;eauto using source_callback_free,source_silent. Qed.
End CLOSURE.
Print Assumptions source_step_invariant.
Print Assumptions source_do_step_exact.
