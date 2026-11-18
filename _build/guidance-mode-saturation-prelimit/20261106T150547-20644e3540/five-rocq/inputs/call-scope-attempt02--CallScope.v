From Stdlib Require Import List Bool ZArith Classical.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation CallfreeExecution ContinuationLift BlockExecution PhaseComposition ConcretePhases PhaseWiring PureIfShell FactorShell.
Import ListNotations.
Definition own_return(k:cont)(s:Csem.state):Prop:=exists v m,s=Returnstate v k m.
Inductive bounded_star(ge:genv)(boundary:cont):Csem.state->trace->Csem.state->Prop:=
 |bounded_refl:forall s,bounded_star ge boundary s E0 s
 |bounded_step:forall s t next tail final,
 ~own_return boundary s->Csem.step ge s t next->bounded_star ge boundary next tail final->
 bounded_star ge boundary s(t**tail)final.
Lemma bounded_erases:forall ge k s t sf,bounded_star ge k s t sf->star Csem.step ge s t sf.
Proof. intros ge k s t sf H;induction H;[constructor|eapply star_step;eauto]. Qed.
Lemma bounded_invariant:forall ge k P target initial,
 certificate ge P target->own_return k target->P initial->forall t reached,
 bounded_star ge k initial t reached->P reached.
Proof.
 intros ge k P target initial CERT TARGET INIT t reached PATH;revert INIT;induction PATH;intro INIT;[exact INIT|].
 apply IHPATH;eapply(proj2 CERT);[exact INIT|intro EQ;subst s;contradiction|exact H0].
Qed.
Definition helper_call_ok(leaf:function)(norm:float32)(branch:bool)(s:Csem.state):Prop:=
 forall args k m,s=Callstate(Internal leaf)args k m->branch=true /\args=[Vsingle norm].
Lemma state_call_ok:forall leaf n b f st k e m,helper_call_ok leaf n b(State f st k e m).
Proof. intros leaf n b f st k e m args kc mc EQ;discriminate. Qed.
Lemma expr_call_ok:forall leaf n b f a k e m,helper_call_ok leaf n b(ExprState f a k e m).
Proof. intros leaf n b f a k e m args kc mc EQ;discriminate. Qed.
Lemma return_call_ok:forall leaf n b v k m,helper_call_ok leaf n b(Returnstate v k m).
Proof. intros leaf n b v k m args kc mc EQ;discriminate. Qed.
Lemma normal_plug_no_call_step:forall ge base raw,
 normal_state raw=true->forall t fd args k m,
 Csem.step ge(plug_state base raw)t(Callstate fd args k m)->False.
Proof.
 intros ge base raw NORMAL t fd args k m STEP;destruct STEP as[ES|SS];[|inversion SS].
 destruct raw;cbn[plug_state]in ES;inversion ES;subst;
 eapply normal_no_callred;eauto.
Qed.
Lemma block_state_is_normal:forall s,block_state s=true->normal_state s=true.
Proof.
 destruct s;cbn[block_state normal_state];intros H;try discriminate.
 - apply andb_true_iff in H as[A B];apply andb_true_iff;split;[apply block_stmt_normal;exact A|apply block_cont_normal;exact B].
 - destruct k;cbn in H|-*;try discriminate;core_unpack;core_build;eauto using block_stmt_normal,block_cont_normal.
Qed.
Lemma block_context_call_ok:forall ge base f e mf leaf norm branch s,
 block_context_invariant ge base f e mf s->helper_call_ok leaf norm branch s.
Proof.
 intros ge base f e mf leaf norm branch s[raw[EQ[[BL DEN]OWN]]]args k m CALL;subst s.
 destruct raw;cbn[plug_state]in CALL;try discriminate;cbn[block_state]in BL;discriminate.
Qed.
Lemma callee_step_no_call:forall ge base value mf s t fd args k m,
 callee_invariant ge base value mf s->Csem.step ge s t(Callstate fd args k m)->False.
Proof.
 intros ge base value mf s t fd args k m[raw[EQ[INV DEN]]]STEP;subst s.
 eapply normal_plug_no_call_step;[exact(proj1 INV)|exact STEP].
Qed.
Lemma block_step_no_call:forall ge base f e mf s t fd args k m,
 block_context_invariant ge base f e mf s->Csem.step ge s t(Callstate fd args k m)->False.
Proof.
 intros ge base f e mf s t fd args k m[raw[EQ[[BL DEN]OWN]]]STEP;subst s.
 eapply normal_plug_no_call_step;[apply block_state_is_normal;exact BL|exact STEP].
Qed.
Lemma pure_if_call_ok:forall ge f e k m condition yes no value branch leaf norm taken s,
 PureIfShell.invariant ge f e k m condition yes no value branch s->helper_call_ok leaf norm taken s.
Proof.
 intros ge f e k m condition yes no value branch leaf norm taken s H args kc mc CALL.
 destruct H as[EQ|[[a[EQ REST]]|EQ]];subst s;unfold PureIfShell.target in CALL;discriminate.
Qed.
Section FACTOR_GUARD.
Variables ge:genv.
Variable e:env.
Variables caller leaf:function.
Variable k:cont.
Variables ifactor imax isqrt inorm:ident.
Variables bfactor bmax bsqrt bnorm:block.
Variable m:mem.
Variables maximum norm root:float32.
Variables leaf_mem final_mem:mem.
Hypotheses (FL:e!ifactor=Some(bfactor,tfloat)) (MG:e!imax=None) (MS:Genv.find_symbol ge imax=Some bmax)
 (SG:e!isqrt=None) (SS:Genv.find_symbol ge isqrt=Some bsqrt) (NL:e!inorm=Some(bnorm,tfloat))
 (MD:Cexec.do_deref_loc ge quiet_world tfloat m bmax Ptrofs.zero Full=Some(quiet_world,E0,Vsingle maximum))
 (ND:Cexec.do_deref_loc ge quiet_world tfloat m bnorm Ptrofs.zero Full=Some(quiet_world,E0,Vsingle norm))
 (FIND:Genv.find_funct ge(Vptr bsqrt Ptrofs.zero)=Some(Internal leaf))
 (TY:type_of_fundef(Internal leaf)=leaf_type).
Definition factor_base_invariant:=factor_invariant ge e caller k ifactor imax isqrt inorm bfactor bmax bsqrt bnorm m maximum norm root leaf_mem final_mem.
Lemma factor_next_helper_argument:forall s t args kc mc,
 factor_base_invariant s->Csem.step ge s t(Callstate(Internal leaf)args kc mc)->args=[Vsingle norm].
Proof.
 intros s t args kc mc H STEP;destruct H as[START|[PRE|[CALLEE|POST]]].
 - subst s;destruct(do_step_unique _ _ _ _ _ _ _ _ STEP)as[TT EQ];discriminate.
 - destruct PRE as[lr[ms[rs[ns EQ]]]];subst s.
   destruct(pre_all_successors ge e caller leaf k ifactor imax isqrt inorm bfactor bmax bsqrt bnorm m maximum norm
    FL MG MS SG SS NL MD ND FIND TY lr ms rs ns t _ STEP)as[TT[PRE|CALL]].
   + destruct PRE as[lr'[ms'[rs'[ns' EQ]]]];discriminate.
   + destruct CALL as[lr'[ms' EQ]];injection EQ;intros;subst;reflexivity.
 - destruct CALLEE as[lr[ms INV]];exfalso;eapply callee_step_no_call;[exact INV|exact STEP].
 - exfalso;eapply block_step_no_call;[exact POST|exact STEP].
Qed.
Lemma factor_next_call_ok:forall s t next,
 factor_base_invariant s->Csem.step ge s t next->helper_call_ok leaf norm true next.
Proof.
 intros s t next FI STEP args kc mc EQ;subst next;split;[reflexivity|].
 eapply factor_next_helper_argument;eauto.
Qed.
Lemma factor_guarded_certificate:
 certificate ge factor_base_invariant(State caller Sskip k e final_mem)->
 certificate ge(fun s=>factor_base_invariant s /\helper_call_ok leaf norm true s)(State caller Sskip k e final_mem).
Proof.
 intros CERT;split.
 - intros s[FI OK];destruct(proj1 CERT s FI)as[EQ|[t[next[STEP FN]]]];[left;exact EQ|].
   right;exists t,next;split;[exact STEP|];split;[exact FN|eapply factor_next_call_ok;eauto].
 - intros s t next[FI OK]NF STEP;split.
   + eapply(proj2 CERT);eauto.
   + eapply factor_next_call_ok;eauto.
Qed.
End FACTOR_GUARD.
Lemma guarded_normal_block_certificate:forall ge f e k m st mf leaf norm branch,
 block_stmt st=true->Cstrategy.exec_stmt ge e m st E0 mf Out_normal->
 exists P,certificate ge P(State f Sskip k e mf) /\P(State f st k e m) /\
 forall s,P s->helper_call_ok leaf norm branch s.
Proof.
 intros ge f e k m st mf leaf norm branch SYN EXEC.
 exists(block_context_invariant ge k f e mf);split.
 - split;[apply block_context_progress|apply block_context_all_successors].
 - split;[eapply block_context_entry;[exact SYN|eapply normal_statement_path;exact EXEC]|].
   intros s H;eapply block_context_call_ok;exact H.
Qed.

Lemma guarded_prepend:forall ge guard initial middle P target,
 unique_transition ge initial middle->certificate ge P target->P middle->
 guard initial->(forall s,P s->guard s)->
 exists Q,certificate ge Q target /\Q initial /\forall s,Q s->guard s.
Proof.
 intros ge guard initial middle P target TRANS CERT PI GI SAFE.
 exists(fun s=>s=initial\/P s);split.
 - eapply chain_certificate with(P:=fun s=>s=initial)(middle:=initial)(initial:=middle);
   [apply singleton_certificate|exact CERT|exact TRANS|exact PI].
 - split;[auto|intros s[->|PS];[exact GI|apply SAFE;exact PS]].
Qed.
Lemma guarded_sequence:forall ge guard f e k m mid first second P Q target,
 certificate ge P(State f Sskip(Kseq second k)e mid)->P(State f first(Kseq second k)e m)->
 certificate ge Q target->Q(State f second k e mid)->
 (forall s,P s->guard s)->(forall s,Q s->guard s)->guard(State f(Ssequence first second)k e m)->
 exists R,certificate ge R target /\R(State f(Ssequence first second)k e m) /\forall s,R s->guard s.
Proof.
 intros ge guard f e k m mid first second P Q target CP PI CQ QI SP SQ START.
 eapply guarded_prepend with(P:=fun s=>P s\/Q s).
 - apply sequence_transition.
 - eapply chain_certificate;[exact CP|exact CQ|apply skip_sequence_transition|exact QI].
 - left;exact PI.
 - exact START.
 - intros s[HP|HQ];[apply SP;exact HP|apply SQ;exact HQ].
Qed.
