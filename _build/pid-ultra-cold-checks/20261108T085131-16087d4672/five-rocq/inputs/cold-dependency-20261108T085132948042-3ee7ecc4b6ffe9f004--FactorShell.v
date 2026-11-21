From Stdlib Require Import Bool List ZArith String Classical.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceSemantics Require Import SemanticsSupport SourceClosure.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress AtomicDenotation AtomicProgress CallfreeExecution ContinuationLift BlockExecution.
Import ListNotations.
Inductive read_stage:=Rvar|Rloc|Rval.
Definition read_res(id:ident)(ty:type)(b:block)(v:val)(stage:read_stage):expr :=
 match stage with
 | Rvar=>Evalof(Evar id ty)ty
 | Rloc=>Evalof(Eloc b Ptrofs.zero Full ty)ty
 | Rval=>Eval v ty end.
Definition lhs_res(id:ident)(b:block)(ready:bool):expr :=
 if ready then Eloc b Ptrofs.zero Full tfloat else Evar id tfloat.
Definition leaf_type:=Tfunction[tfloat]tfloat cc_default.
Definition factor_context(l mx:expr):expr->expr :=
 fun hole=>Eassign l(Ebinop Odiv mx hole tfloat)tfloat.
Definition factor_expression(l mx rf arg:expr):expr :=
 factor_context l mx(Ecall rf(Econs arg Enil)tfloat).
Definition null_external(_ : string)(_ : signature)(_ : Senv.t)(_ : world)(_ : list val)(_ : mem)
 :option(world*trace*val*mem):=None.
Section FACTOR.
Variable ge:genv.
Variable e:env.
Variable caller leaf:function.
Variable k:cont.
Variable ifactor imax isqrt inorm:ident.
Variable bfactor bmax bsqrt bnorm:block.
Variable m:mem.
Variable maximum norm:float32.
Hypothesis factor_local:e!ifactor=Some(bfactor,tfloat).
Hypothesis max_global:e!imax=None.
Hypothesis max_symbol:Genv.find_symbol ge imax=Some bmax.
Hypothesis sqrt_global:e!isqrt=None.
Hypothesis sqrt_symbol:Genv.find_symbol ge isqrt=Some bsqrt.
Hypothesis norm_local:e!inorm=Some(bnorm,tfloat).
Hypothesis max_deref:Cexec.do_deref_loc ge quiet_world tfloat m bmax Ptrofs.zero Full=Some(quiet_world,E0,Vsingle maximum).
Hypothesis norm_deref:Cexec.do_deref_loc ge quiet_world tfloat m bnorm Ptrofs.zero Full=Some(quiet_world,E0,Vsingle norm).
Hypothesis leaf_find:Genv.find_funct ge(Vptr bsqrt Ptrofs.zero)=Some(Internal leaf).
Hypothesis leaf_signature:type_of_fundef(Internal leaf)=leaf_type.
Definition pre_expr(lready:bool)(ms rs ns:read_stage):expr :=
 factor_expression(lhs_res ifactor bfactor lready)
 (read_res imax tfloat bmax(Vsingle maximum)ms)
 (read_res isqrt leaf_type bsqrt(Vptr bsqrt Ptrofs.zero)rs)
 (read_res inorm tfloat bnorm(Vsingle norm)ns).
Definition pre_state(lready:bool)(ms rs ns:read_stage):Csem.state :=
 ExprState caller(pre_expr lready ms rs ns)(Kdo k)e m.
Definition leaf_frame(lready:bool)(ms:read_stage):cont :=
 Kcall caller e(factor_context(lhs_res ifactor bfactor lready)
 (read_res imax tfloat bmax(Vsingle maximum)ms))tfloat(Kdo k).
Definition pre_or_call(s:Csem.state):Prop :=
 (exists lready ms rs ns,s=pre_state lready ms rs ns) \/
 (exists lready ms,s=Callstate(Internal leaf)[Vsingle norm](leaf_frame lready ms)m).

Ltac factor_close :=
 split;[reflexivity|unfold pre_or_call;first[
 left;first[solve[exists true,Rvar,Rvar,Rvar;reflexivity]|solve[exists true,Rvar,Rvar,Rloc;reflexivity]|solve[exists true,Rvar,Rvar,Rval;reflexivity]|solve[exists true,Rvar,Rloc,Rvar;reflexivity]|solve[exists true,Rvar,Rloc,Rloc;reflexivity]|solve[exists true,Rvar,Rloc,Rval;reflexivity]|solve[exists true,Rvar,Rval,Rvar;reflexivity]|solve[exists true,Rvar,Rval,Rloc;reflexivity]|solve[exists true,Rvar,Rval,Rval;reflexivity]|solve[exists true,Rloc,Rvar,Rvar;reflexivity]|solve[exists true,Rloc,Rvar,Rloc;reflexivity]|solve[exists true,Rloc,Rvar,Rval;reflexivity]|solve[exists true,Rloc,Rloc,Rvar;reflexivity]|solve[exists true,Rloc,Rloc,Rloc;reflexivity]|solve[exists true,Rloc,Rloc,Rval;reflexivity]|solve[exists true,Rloc,Rval,Rvar;reflexivity]|solve[exists true,Rloc,Rval,Rloc;reflexivity]|solve[exists true,Rloc,Rval,Rval;reflexivity]|solve[exists true,Rval,Rvar,Rvar;reflexivity]|solve[exists true,Rval,Rvar,Rloc;reflexivity]|solve[exists true,Rval,Rvar,Rval;reflexivity]|solve[exists true,Rval,Rloc,Rvar;reflexivity]|solve[exists true,Rval,Rloc,Rloc;reflexivity]|solve[exists true,Rval,Rloc,Rval;reflexivity]|solve[exists true,Rval,Rval,Rvar;reflexivity]|solve[exists true,Rval,Rval,Rloc;reflexivity]|solve[exists true,Rval,Rval,Rval;reflexivity]|solve[exists false,Rvar,Rvar,Rvar;reflexivity]|solve[exists false,Rvar,Rvar,Rloc;reflexivity]|solve[exists false,Rvar,Rvar,Rval;reflexivity]|solve[exists false,Rvar,Rloc,Rvar;reflexivity]|solve[exists false,Rvar,Rloc,Rloc;reflexivity]|solve[exists false,Rvar,Rloc,Rval;reflexivity]|solve[exists false,Rvar,Rval,Rvar;reflexivity]|solve[exists false,Rvar,Rval,Rloc;reflexivity]|solve[exists false,Rvar,Rval,Rval;reflexivity]|solve[exists false,Rloc,Rvar,Rvar;reflexivity]|solve[exists false,Rloc,Rvar,Rloc;reflexivity]|solve[exists false,Rloc,Rvar,Rval;reflexivity]|solve[exists false,Rloc,Rloc,Rvar;reflexivity]|solve[exists false,Rloc,Rloc,Rloc;reflexivity]|solve[exists false,Rloc,Rloc,Rval;reflexivity]|solve[exists false,Rloc,Rval,Rvar;reflexivity]|solve[exists false,Rloc,Rval,Rloc;reflexivity]|solve[exists false,Rloc,Rval,Rval;reflexivity]|solve[exists false,Rval,Rvar,Rvar;reflexivity]|solve[exists false,Rval,Rvar,Rloc;reflexivity]|solve[exists false,Rval,Rvar,Rval;reflexivity]|solve[exists false,Rval,Rloc,Rvar;reflexivity]|solve[exists false,Rval,Rloc,Rloc;reflexivity]|solve[exists false,Rval,Rloc,Rval;reflexivity]|solve[exists false,Rval,Rval,Rvar;reflexivity]|solve[exists false,Rval,Rval,Rloc;reflexivity]|solve[exists false,Rval,Rval,Rval;reflexivity]]
 |right;first[solve[exists true,Rvar;reflexivity]|solve[exists true,Rloc;reflexivity]|solve[exists true,Rval;reflexivity]|solve[exists false,Rvar;reflexivity]|solve[exists false,Rloc;reflexivity]|solve[exists false,Rval;reflexivity]]]].
Lemma pre_animator_step:forall lr ms rs ns rule t next,
 In(TR rule t next)(Cexec.do_step ge null_external null_external quiet_world(pre_state lr ms rs ns)) ->
 t=E0 /\ pre_or_call next.
Proof.
 intros lr ms rs ns rule t next.
 destruct lr,ms,rs,ns;
 cbn[pre_state pre_expr factor_expression factor_context lhs_res read_res Cexec.do_step
 Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc Cexec.is_val_list
 Cexec.incontext Cexec.topred Cexec.stuck] ;
 rewrite ?factor_local,?max_global,?max_symbol,?sqrt_global,?sqrt_symbol,?norm_local;
 rewrite ?dec_eq_true;
 rewrite ?max_deref,?norm_deref;
 cbn[Cexec.do_deref_loc access_mode type_is_volatile];
 rewrite ?dec_eq_true.
 all: cbn[leaf_type classify_fun sem_cast_arguments sem_cast];
 rewrite ?leaf_find,?leaf_signature;rewrite ?dec_eq_true;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].
 all: intros IN;simpl in IN;repeat destruct IN as[EQ|IN];try contradiction;
 inversion EQ;subst;factor_close.
Qed.

Lemma pre_callback_free:forall lr ms rs ns,callback_free_state(pre_state lr ms rs ns).
Proof. intros;destruct lr,ms,rs,ns;reflexivity. Qed.
Lemma pre_or_call_not_stuck:forall s,pre_or_call s ->s<>Stuckstate.
Proof. intros s[[lr[ms[rs[ns EQ]]]]|[lr[ms EQ]]];subst;discriminate. Qed.
Lemma pre_core:forall lr ms rs ns,
 SourceClosure.core_expr ge(fun _=>True)(fun _ _=>True)(pre_expr lr ms rs ns).
Proof.
 intros;destruct lr,ms,rs,ns;
 cbn[pre_expr factor_expression factor_context lhs_res read_res leaf_type
 SourceClosure.core_expr SourceClosure.core_exprlist SourceClosure.nv];
 repeat split;try reflexivity;unfold SourceClosure.valid_call;intros;split;exact I.
Qed.
Lemma pre_silent:forall lr ms rs ns,
 silent_state ge(pre_state lr ms rs ns).
Proof.
 intros lr ms rs ns t next STEP.
 pose proof(pre_core lr ms rs ns)as CORE.
 destruct STEP as[ES|SS];[|inversion SS].
 inversion ES;subst;auto.
 match goal with EQ:?C ?A=pre_expr _ _ _ _ |- _=>rewrite <-EQ in CORE end.
 match goal with HC:Csem.context RV RV ?C,RR:rred ge ?a m t ?a' ?m' |- _=>
 pose proof(SourceClosure.core_context_hole ge(fun _=>True)(fun _ _=>True)
 _ _ _ HC a CORE)as CA;
 exact(proj1(SourceClosure.core_rred ge(fun _=>True)(fun _ _=>True)
 a m t a' m' CA RR))end.
Qed.
Theorem pre_all_successors:forall lr ms rs ns t next,
 Csem.step ge(pre_state lr ms rs ns)t next ->t=E0 /\ pre_or_call next.
Proof.
 intros lr ms rs ns t next STEP.
 pose proof(pre_silent lr ms rs ns t next STEP)as TT;subst t.
 destruct(pure_do_step_complete ge null_external null_external quiet_world
 (pre_state lr ms rs ns) E0 next quiet_world (pre_callback_free lr ms rs ns)
 (possible_trace_nil quiet_world) STEP)as[rule IN].
 eapply pre_animator_step;exact IN.
Qed.
Lemma pre_animator_nonempty:forall lr ms rs ns,
 exists rule t next,In(TR rule t next)
 (Cexec.do_step ge null_external null_external quiet_world(pre_state lr ms rs ns)).
Proof.
 intros lr ms rs ns.
 destruct lr,ms,rs,ns;
 cbn[pre_state pre_expr factor_expression factor_context lhs_res read_res Cexec.do_step
 Cexec.is_val Cexec.step_expr Cexec.step_exprlist Cexec.is_loc Cexec.is_val_list
 Cexec.incontext Cexec.topred Cexec.stuck] ;
 rewrite ?factor_local,?max_global,?max_symbol,?sqrt_global,?sqrt_symbol,?norm_local;
 rewrite ?dec_eq_true;
 rewrite ?max_deref,?norm_deref;
 cbn[Cexec.do_deref_loc access_mode type_is_volatile];
 rewrite ?dec_eq_true.
 all: cbn[leaf_type classify_fun sem_cast_arguments sem_cast];
 rewrite ?leaf_find,?leaf_signature;rewrite ?dec_eq_true;
 cbn[Cexec.incontext2 Cexec.incontext Cexec.topred Cexec.expr_final_state map app fst snd].

 all: repeat eexists;apply in_eq.
Qed.
Theorem pre_progress:forall lr ms rs ns,
 exists t next,Csem.step ge(pre_state lr ms rs ns)t next /\ pre_or_call next.
Proof.
 intros lr ms rs ns.
 destruct(pre_animator_nonempty lr ms rs ns)as[rule[t[next IN]]].
 pose proof(proj2(pre_animator_step lr ms rs ns rule t next IN))as CLASS.
 exists t,next;split;auto.
 eapply supported_nonstuck_transition;[apply pre_callback_free|exact IN|].
 apply pre_or_call_not_stuck;exact CLASS.
Qed.
Print Assumptions pre_all_successors.
Print Assumptions pre_progress.

Variable root:float32.
Variable leaf_mem final_mem:mem.
Hypothesis max_post_deref:Cexec.do_deref_loc ge quiet_world tfloat leaf_mem bmax Ptrofs.zero Full=
 Some(quiet_world,E0,Vsingle maximum).
Hypothesis factor_store:Cexec.do_assign_loc ge quiet_world tfloat leaf_mem bfactor Ptrofs.zero Full
 (Vsingle(Float32.div maximum root))=
 Some(quiet_world,E0,final_mem,Vsingle(Float32.div maximum root)).
Hypothesis leaf_normal:normal_state(Callstate(Internal leaf)[Vsingle norm]Kstop m)=true.
Hypothesis leaf_names:call_names(Callstate(Internal leaf)[Vsingle norm]Kstop m).
Hypothesis leaf_witness:star Csem.step ge(Callstate(Internal leaf)[Vsingle norm]Kstop m)E0
 (Returnstate(Vsingle root)Kstop leaf_mem).

Definition post_expr(lr:bool)(ms:read_stage):expr :=
 factor_context(lhs_res ifactor bfactor lr)
 (read_res imax tfloat bmax(Vsingle maximum)ms)(Eval(Vsingle root)tfloat).
Lemma post_atomic:forall lr ms,
 atomic_expr(post_expr lr ms)=true /\
 atomic_eval ge e leaf_mem(post_expr lr ms)=
 Some(Vsingle(Float32.div maximum root),final_mem).
Proof.
 intros lr ms;destruct lr,ms;split;try reflexivity;
 cbn[post_expr factor_context lhs_res read_res atomic_eval pure_lval pure_rval typeof];
 rewrite ?factor_local,?max_global,?max_symbol;
 rewrite ?dec_eq_true;rewrite ?max_post_deref;
 cbn[sem_binary_operation sem_div sem_binarith classify_binarith sem_cast classify_cast commit];
 change(match Cexec.do_assign_loc ge quiet_world tfloat leaf_mem bfactor Ptrofs.zero Full(Vsingle(Float32.div maximum root))with
 |Some(_,_,mm,vv)=>Some(vv,mm)|None=>None end=Some(Vsingle(Float32.div maximum root),final_mem));
 rewrite factor_store;reflexivity.
Qed.
Lemma post_certificate:forall lr ms,
 block_context_invariant ge k caller e final_mem
 (ExprState caller(post_expr lr ms)(Kdo k)e leaf_mem).
Proof.
 intros lr ms;exists(ExprState caller(post_expr lr ms)(Kdo Kstop)e leaf_mem).
 split;[reflexivity|];split.
 - split.
   + cbn[block_state];rewrite(proj1(post_atomic lr ms));reflexivity.
   + cbn[block_denotation];rewrite(proj2(post_atomic lr ms));reflexivity.
 - split;reflexivity.
Qed.
Lemma leaf_certificate:forall lr ms,
 callee_invariant ge(leaf_frame lr ms)(Vsingle root)leaf_mem
 (Callstate(Internal leaf)[Vsingle norm](leaf_frame lr ms)m).
Proof.
 intros lr ms;exact(callee_invariant_entry ge(leaf_frame lr ms)
 (Callstate(Internal leaf)[Vsingle norm]Kstop m)E0(Vsingle root)leaf_mem
 leaf_normal leaf_names leaf_witness).
Qed.
Lemma do_step_unique:forall ge f a k e m t next,
 Csem.step ge(State f(Sdo a)k e m)t next ->
 t=E0 /\ next=ExprState f a(Kdo k)e m.
Proof.
 intros ge0 f a k0 e0 m0 t next[ES|SS];[inversion ES|].
 inversion SS;subst;auto;
 repeat match goal with H:_\/_ |- _=>destruct H end;discriminate.
Qed.
Lemma return_call_step_unique:forall ge v f e C ty k m t next,
 Csem.step ge(Returnstate v(Kcall f e C ty k)m)t next ->
 t=E0 /\ next=ExprState f(C(Eval v ty))k e m.
Proof. intros ge0 v f e0 C ty k0 m0 t next[ES|SS];[inversion ES|inversion SS;subst;auto]. Qed.
Definition factor_invariant(s:Csem.state):Prop :=
 (s=State caller(Sdo(pre_expr false Rvar Rvar Rvar))k e m) \/
 (exists lr ms rs ns,s=pre_state lr ms rs ns) \/
 (exists lr ms,callee_invariant ge(leaf_frame lr ms)(Vsingle root)leaf_mem s) \/
 block_context_invariant ge k caller e final_mem s.

Theorem factor_all_successors:forall s t next,
 factor_invariant s ->s<>State caller Sskip k e final_mem ->
 Csem.step ge s t next ->factor_invariant next.
Proof.
 intros s t next[START|[PRE|[CALLEE|POST]]]NF STEP.
 - subst s;destruct(do_step_unique _ _ _ _ _ _ _ _ STEP)as[TT EQ];subst next.
   right;left;exists false,Rvar,Rvar,Rvar;reflexivity.
 - destruct PRE as[lr[ms[rs[ns EQ]]]];subst s.
   destruct(pre_all_successors lr ms rs ns t next STEP)as[TT[PRE|CALL]].
   + right;left;exact PRE.
   + destruct CALL as[lr'[ms' EQ]];subst next.
     right;right;left;exists lr',ms';apply leaf_certificate.
 - destruct CALLEE as[lr[ms CERT]].
   destruct(classic(s=Returnstate(Vsingle root)(leaf_frame lr ms)leaf_mem))as[RET|NR].
   + subst s;destruct(return_call_step_unique _ _ _ _ _ _ _ _ _ _ STEP)as[TT EQ];subst next.
     right;right;right;apply post_certificate.
   + right;right;left;exists lr,ms.
     eapply callee_invariant_all_successors;[exact I|exact CERT|exact NR|exact STEP].
 - right;right;right;eapply block_context_all_successors;eauto.
Qed.
Theorem factor_progress:forall s,
 factor_invariant s ->
 s=State caller Sskip k e final_mem \/
 exists t next,Csem.step ge s t next /\ factor_invariant next.
Proof.
 intros s[START|[PRE|[CALLEE|POST]]].
 - subst s;right;exists E0,(pre_state false Rvar Rvar Rvar);split.
   + right;apply step_do_1.
   + right;left;exists false,Rvar,Rvar,Rvar;reflexivity.
 - destruct PRE as[lr[ms[rs[ns EQ]]]];subst s.
   destruct(pre_progress lr ms rs ns)as[t[next[STEP CLASS]]].
   right;exists t,next;split;auto.
   destruct CLASS as[PRE|[lr'[ms' EQ]]].
   + right;left;exact PRE.
   + subst next;right;right;left;exists lr',ms';apply leaf_certificate.
 - destruct CALLEE as[lr[ms CERT]].
   destruct(callee_invariant_progress ge(leaf_frame lr ms)(Vsingle root)leaf_mem s I CERT)
    as[RET|[t[next[STEP CERT']]]].
   + subst s;right;exists E0,(ExprState caller(post_expr lr ms)(Kdo k)e leaf_mem);split.
     * right;apply step_returnstate.
     * right;right;right;apply post_certificate.
   + right;exists t,next;split;auto;right;right;left;eauto.
 - destruct(block_context_progress ge k caller e final_mem s POST)as[DONE|[t[next[STEP CERT]]]].
   + auto.
   + right;exists t,next;split;auto;right;right;right;exact CERT.
Qed.
Print Assumptions factor_all_successors.
Print Assumptions factor_progress.
End FACTOR.
