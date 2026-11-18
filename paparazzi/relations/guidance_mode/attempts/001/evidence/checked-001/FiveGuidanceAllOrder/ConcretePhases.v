From Stdlib Require Import Bool List ZArith Classical.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Determinism Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import BlockExecution PhaseComposition.
From FiveGuidanceEntry Require Import BigstepSupport.
Require FiveGhSpeed.Source FiveGhAccel.Source.
Require FiveGuidanceEntry.SymbolicPrefix FiveGuidanceEntry.AccelPrefix FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.
Module Speed:=FiveGuidanceEntry.SymbolicPrefix.
Module Accel:=FiveGuidanceEntry.AccelPrefix.
Module SS:=FiveGhSpeed.Source.
Module AS:=FiveGhAccel.Source.
Fixpoint phase_sequence(blocks:list statement)(tail:statement):statement:=
 match blocks with []=>tail|b::rest=>Ssequence b(phase_sequence rest tail)end.
Definition speed_blocks:list statement:=
 [Speed.source_pos_step;Speed.source_speed_step;Speed.pos_conversion SS._x;Speed.pos_conversion SS._y;
 Speed.source_pos_add;Speed.source_speed_add;Speed.error_pair;Speed.raw_pair].
Definition accel_blocks:list statement:=
 [Accel.source_pos_step;Accel.source_speed_step;Accel.pos_conversion AS._x;Accel.pos_conversion AS._y;
 Accel.source_pos_add;Accel.source_speed_add].
Lemma speed_phase_shape:fn_body SS.f_gh_update_ref_from_speed_sp=
 phase_sequence speed_blocks(Ssequence Speed.saturation_call Speed.after_saturation).
Proof. reflexivity. Qed.
Lemma accel_phase_shape:fn_body AS.f_gh_update_ref_from_accel_sp=
 phase_sequence accel_blocks(Ssequence Accel.saturation_call Accel.after_saturation).
Proof. reflexivity. Qed.
Lemma speed_blocks_syntax:Forall(fun b=>block_stmt b=true)speed_blocks.
Proof. repeat constructor;reflexivity. Qed.
Lemma accel_blocks_syntax:Forall(fun b=>block_stmt b=true)accel_blocks.
Proof. repeat constructor;reflexivity. Qed.
Lemma speed_copy_syntax:block_stmt Speed.after_saturation=true.
Proof. reflexivity. Qed.
Lemma accel_copy_syntax:block_stmt Accel.after_saturation=true.
Proof. reflexivity. Qed.
Lemma speed_norm_syntax:block_stmt FiveGuidanceEntry.SaturationBody.norm_statement=true.
Proof. reflexivity. Qed.
Lemma speed_scale_syntax:block_stmt FiveGuidanceEntry.SaturationBody.scale_pair=true.
Proof. reflexivity. Qed.
Lemma accel_norm_syntax:block_stmt FiveGuidanceEntry.SaturationBodyAccel.norm_statement=true.
Proof. reflexivity. Qed.
Lemma accel_scale_syntax:block_stmt FiveGuidanceEntry.SaturationBodyAccel.scale_pair=true.
Proof. reflexivity. Qed.
Lemma normal_statement_path:forall ge e m st mf,
 Cstrategy.exec_stmt ge e m st E0 mf Out_normal ->forall f,
 star Csem.step ge(State f st Kstop e m)E0(State f Sskip Kstop e mf).
Proof.
 intros ge e m st mf EV f.
 destruct(Cstrategy.exec_stmt_to_steps ge e m st E0 mf Out_normal EV f Kstop)as[reached[PATH END]].
 inversion END;subst;apply strategy_star_csem;exact PATH.
Qed.
Inductive phase_chain(ge:genv)(f:function)(e:env):list statement->mem->mem->Prop:=
 | phase_chain_nil:forall m,phase_chain ge f e []m m
 | phase_chain_cons:forall st rest m ma mf,
 block_stmt st=true ->star Csem.step ge(State f st Kstop e m)E0(State f Sskip Kstop e ma) ->
 phase_chain ge f e rest ma mf ->phase_chain ge f e(st::rest)m mf.
Lemma execution_phase_chain:forall ge e blocks m mf,
 Forall(fun b=>block_stmt b=true)blocks ->
 Cstrategy.exec_stmt ge e m(phase_sequence blocks Sskip)E0 mf Out_normal ->
 forall f,phase_chain ge f e blocks m mf.
Proof.
 intros ge e blocks;induction blocks as[|st rest IH];intros m mf SYNTAX EV f.
 - cbn[phase_sequence]in EV;inversion EV;subst;constructor.
 - inversion SYNTAX as[|? ? BS REST];subst.
   cbn[phase_sequence]in EV;destruct(sequence_normal_inv ge e _ _ _ _ EV)as[ma[HEAD TAIL]].
   econstructor;[exact BS|eapply normal_statement_path;exact HEAD|eapply IH;eauto].
Qed.
Lemma singleton_certificate:forall ge target,certificate ge(fun s=>s=target)target.
Proof. intros;split;[intros;auto|intros s t next EQ NE;contradiction]. Qed.
Lemma sequence_transition:forall ge f st tail k e m,
 unique_transition ge(State f(Ssequence st tail)k e m)(State f st(Kseq tail k)e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;auto].
 all:repeat match goal with H:_ \/ _|-_=>destruct H end;discriminate.
Qed.
Lemma skip_sequence_transition:forall ge f tail k e m,
 unique_transition ge(State f Sskip(Kseq tail k)e m)(State f tail k e m).
Proof.
 intros;split;[right;constructor|].
 intros t next[ES|SS];[inversion ES|inversion SS;subst;cbn in *;try contradiction;auto].
Qed.
Theorem phase_chain_certificate:forall ge f e blocks m mf,
 phase_chain ge f e blocks m mf ->forall k tail,
 exists P,certificate ge P(State f tail k e mf) /\P(State f(phase_sequence blocks tail)k e m).
Proof.
 intros ge f e blocks m mf CHAIN;induction CHAIN;intros k tail.
 - exists(fun s=>s=State f tail k e m);split;[apply singleton_certificate|reflexivity].
 - destruct(IHCHAIN k tail)as[REST[CERTREST INITREST]].
   set(base:=Kseq(phase_sequence rest tail)k).
   set(BLOCK:=block_context_invariant ge base f e ma).
   assert(CERTBLOCK:certificate ge BLOCK(State f Sskip base e ma)).
   { split;[apply block_context_progress|apply block_context_all_successors]. }
   assert(INITBLOCK:BLOCK(State f st base e m)).
   { eapply block_context_entry;[exact H|exact H0]. }
   pose proof(chain_certificate ge BLOCK REST(State f Sskip base e ma)
   (State f(phase_sequence rest tail)k e ma)(State f tail k e mf)
   CERTBLOCK CERTREST(skip_sequence_transition ge f _ k e ma)INITREST)as TAILCERT.
   exists(fun s=>s=State f(Ssequence st(phase_sequence rest tail))k e m \/BLOCK s \/REST s);split.
   + eapply chain_certificate;[apply singleton_certificate|exact TAILCERT|apply sequence_transition|left;exact INITBLOCK].
   + left;reflexivity.
Qed.
Theorem speed_prefix_certificate:forall e f m mi mf,
 (forall tail out final,Cstrategy.exec_stmt Speed.ge e mi tail E0 final out ->Cstrategy.exec_stmt Speed.ge e m(Speed.integration_context tail)E0 final out) ->
 (forall tail out final,Cstrategy.exec_stmt Speed.ge e mf tail E0 final out ->Cstrategy.exec_stmt Speed.ge e mi(Speed.raw_context tail)E0 final out) ->
 forall k tail,exists P,certificate Speed.ge P(State f tail k e mf) /\
 P(State f(phase_sequence speed_blocks tail)k e m).
Proof.
 intros e f m mi mf INTEGRATE RAW k tail;apply phase_chain_certificate.
 eapply execution_phase_chain;[apply speed_blocks_syntax|].
 change(Cstrategy.exec_stmt Speed.ge e m(Speed.integration_context(Speed.raw_context Sskip))E0 mf Out_normal).
 apply INTEGRATE;apply RAW;constructor.
Qed.
Theorem accel_prefix_certificate:forall e f m mf,
 (forall tail out final,Cstrategy.exec_stmt Accel.ge e mf tail E0 final out ->Cstrategy.exec_stmt Accel.ge e m(Accel.integration_context tail)E0 final out) ->
 forall k tail,exists P,certificate Accel.ge P(State f tail k e mf) /\
 P(State f(phase_sequence accel_blocks tail)k e m).
Proof.
 intros e f m mf INTEGRATE k tail;apply phase_chain_certificate.
 eapply execution_phase_chain;[apply accel_blocks_syntax|].
 change(Cstrategy.exec_stmt Accel.ge e m(Accel.integration_context Sskip)E0 mf Out_normal).
 apply INTEGRATE;constructor.
Qed.
Print Assumptions phase_chain_certificate.
Print Assumptions speed_prefix_certificate.
Print Assumptions accel_prefix_certificate.
Definition phase_world:world:=World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None).
Lemma allocation_deterministic:forall ge env m vars e1 ma1 e2 ma2,
 alloc_variables ge env m vars e1 ma1 ->alloc_variables ge env m vars e2 ma2 ->e1=e2 /\ma1=ma2.
Proof.
 intros ge env m vars e1 ma1 e2 ma2 A1 A2.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A1)as D1.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A2)as D2.
 rewrite D1 in D2;injection D2;auto.
Qed.
Lemma parameters_deterministic:forall ge e m params args mf1 mf2,
 bind_parameters ge e m params args mf1 ->bind_parameters ge e m params args mf2 ->mf1=mf2.
Proof.
 intros ge e m params args mf1 mf2 B1 B2.
 pose proof(Cexec.sem_bind_parameters_complete ge phase_world e m params args mf1 B1)as D1.
 pose proof(Cexec.sem_bind_parameters_complete ge phase_world e m params args mf2 B2)as D2.
 rewrite D1 in D2;injection D2;auto.
Qed.
Lemma internal_dispatch_transition:forall ge f args m e ma mb k,
 list_norepet(var_names(fn_params f)++var_names(fn_vars f)) ->
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e ma ->
 bind_parameters ge e ma(fn_params f)args mb ->
 unique_transition ge(Callstate(Internal f)args k m)(State f(fn_body f)k e mb).
Proof.
 intros ge f args m e ma mb k NAMES ALLOC BIND;split.
 - right;eapply step_internal_function;[exact NAMES|exact ALLOC|exact BIND].
 - intros t next[ES|SS];[inversion ES|].
   inversion SS;subst;split;[reflexivity|].
   match goal with
   |A:alloc_variables ge empty_env m(fn_params f++fn_vars f)?ee ?mx
    |-State _ _ _ ?ee _=_ =>
     destruct(allocation_deterministic ge empty_env m _ e ma ee mx ALLOC A)as[EE MM];subst ee mx end.
   match goal with
   |B:bind_parameters ge e ma(fn_params f)args ?mx |-State _ _ _ _ ?mx=_=>
    pose proof(parameters_deterministic ge e ma(fn_params f)args mb mx BIND B)as EQ;subst mx;reflexivity end.
Qed.
Lemma cleanup_transition:forall ge f k e m mf,
 is_call_cont k ->Mem.free_list m(blocks_of_env ge e)=Some mf ->
 unique_transition ge(State f Sskip k e m)(Returnstate Vundef k mf).
Proof.
 intros ge f k e m mf CALL FREE;split;[right;eapply step_skip_call;eauto|].
 intros t next[ES|SS];[inversion ES|].
 destruct k;cbn in CALL;try contradiction;inversion SS;subst;
 repeat match goal with H:_ \/ _|-_=>destruct H end;try discriminate.
 all:(split;[reflexivity|];
 match goal with F:Mem.free_list _ _=Some ?mx|-Returnstate _ _ ?mx=_=>
 rewrite FREE in F;injection F as EQ;subst mx;reflexivity end).
Qed.
Print Assumptions internal_dispatch_transition.
Print Assumptions cleanup_transition.
