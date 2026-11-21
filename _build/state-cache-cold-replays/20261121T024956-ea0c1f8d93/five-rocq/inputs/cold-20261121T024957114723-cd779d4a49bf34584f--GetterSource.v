
From Stdlib Require Import List Bool Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From StateSpeedGetEcefF Require Import Source Execution.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceSemantics Require Import SemanticsSupport.
From StateSpeedMemory Require Import MemoryBridge.
From StateSpeedGetterSupport Require Import NamedClosure.
Import ListNotations.
Definition ge:=Execution.ge.
Definition allowed(fd:Csyntax.fundef):Prop :=
 fd=Internal Source.f_ecef_of_enu_vect_f \/ fd=Internal Source.f_ecef_of_ned_vect_f \/
 fd=Internal Source.f_stateCalcSpeedEcef_f \/ fd=Internal Source.f_stateGetSpeedEcef_f.
Definition calc_type:=Tfunction[]tvoid cc_default.
Definition ned_type:=Tfunction[tptr(Tstruct Source._EcefCoor_f noattr);tptr(Tstruct Source._LtpDef_f noattr);tptr(Tstruct Source._NedCoor_f noattr)]tvoid cc_default.
Definition enu_type:=Tfunction[tptr(Tstruct Source._EcefCoor_f noattr);tptr(Tstruct Source._LtpDef_f noattr);tptr(Tstruct Source._EnuCoor_f noattr)]tvoid cc_default.
Definition signature_weight(ty:type):nat :=
 if type_eq ty calc_type then 100000 else if type_eq ty ned_type then 10000 else 1000.
Definition budget(ty:type)(fd:Csyntax.fundef):Prop :=
 (MemoryBridge.activation_rank signature_weight fd+2<signature_weight ty)%nat.
Local Notation CS:=(NamedClosure.core_stmt ge allowed budget).
Definition named_function(id:ident)(fd:Csyntax.fundef):Prop :=
 exists b,Genv.find_symbol ge id=Some b /\ Genv.find_funct ge(Vptr b Ptrofs.zero)=Some fd.
Lemma calc_lookup:named_function Source._stateCalcSpeedEcef_f(Internal Source.f_stateCalcSpeedEcef_f).
Proof. eexists;split;lazy;reflexivity. Qed.
Lemma ned_lookup:named_function Source._ecef_of_ned_vect_f(Internal Source.f_ecef_of_ned_vect_f).
Proof. eexists;split;lazy;reflexivity. Qed.
Lemma enu_lookup:named_function Source._ecef_of_enu_vect_f(Internal Source.f_ecef_of_enu_vect_f).
Proof. eexists;split;lazy;reflexivity. Qed.
Lemma calc_budget:budget calc_type(Internal Source.f_stateCalcSpeedEcef_f).
Proof. unfold budget;apply Nat.ltb_lt;vm_compute;reflexivity. Qed.
Lemma ned_budget:budget ned_type(Internal Source.f_ecef_of_ned_vect_f).
Proof. unfold budget;apply Nat.ltb_lt;vm_compute;reflexivity. Qed.
Lemma enu_budget:budget enu_type(Internal Source.f_ecef_of_enu_vect_f).
Proof. unfold budget;apply Nat.ltb_lt;vm_compute;reflexivity. Qed.
Lemma named_safe:forall id fd params ret cc,
 named_function id fd->allowed fd->budget(Tfunction params ret cc)fd->
 NamedClosure.safe_variable ge allowed budget id(Tfunction params ret cc).
Proof.
 intros id fd params ret cc[b[SYM FIND]]ALLOW BUD;right;exists b;split;auto.
 cbn[NamedClosure.safe_location];split;auto.
 cbn[NamedClosure.safe_value classify_fun];intros other LOOK.
 rewrite FIND in LOOK;inversion LOOK;subst;auto.
Qed.
Lemma calc_safe:NamedClosure.safe_variable ge allowed budget Source._stateCalcSpeedEcef_f calc_type.
Proof. eapply named_safe;[exact calc_lookup|unfold allowed;auto|exact calc_budget]. Qed.
Lemma ned_safe:NamedClosure.safe_variable ge allowed budget Source._ecef_of_ned_vect_f ned_type.
Proof. eapply named_safe;[exact ned_lookup|unfold allowed;auto|exact ned_budget]. Qed.
Lemma enu_safe:NamedClosure.safe_variable ge allowed budget Source._ecef_of_enu_vect_f enu_type.
Proof. eapply named_safe;[exact enu_lookup|unfold allowed;auto|exact enu_budget]. Qed.
Ltac build_core :=
 repeat match goal with |- _ /\ _=>split end;
 first[reflexivity|exact I|exact calc_safe|exact ned_safe|exact enu_safe|
 solve[apply NamedClosure.data_value;exact I]|
 solve[apply NamedClosure.data_location;exact I]|
 solve[apply NamedClosure.data_variable;exact I]].
Lemma enu_core:CS(fn_body Source.f_ecef_of_enu_vect_f).
Proof. cbn[fn_body Source.f_ecef_of_enu_vect_f NamedClosure.core_stmt NamedClosure.core_expr NamedClosure.core_exprlist NamedClosure.nv];build_core. Qed.
Lemma ned_core:CS(fn_body Source.f_ecef_of_ned_vect_f).
Proof. cbn[fn_body Source.f_ecef_of_ned_vect_f NamedClosure.core_stmt NamedClosure.core_expr NamedClosure.core_exprlist NamedClosure.nv];build_core. Qed.
Lemma calc_core:CS(fn_body Source.f_stateCalcSpeedEcef_f).
Proof. cbn[fn_body Source.f_stateCalcSpeedEcef_f NamedClosure.core_stmt NamedClosure.core_expr NamedClosure.core_exprlist NamedClosure.nv];build_core. Qed.
Lemma getter_core:CS(fn_body Source.f_stateGetSpeedEcef_f).
Proof. cbn[fn_body Source.f_stateGetSpeedEcef_f NamedClosure.core_stmt NamedClosure.core_expr NamedClosure.core_exprlist NamedClosure.nv];build_core. Qed.
Lemma internal_body:forall f,allowed(Internal f)->CS(fn_body f).
Proof.
 intros f[EQ|[EQ|[EQ|EQ]]];inversion EQ;subst;auto using enu_core,ned_core,calc_core,getter_core.
Qed.
Lemma internal_variables:forall f,allowed(Internal f)->
 Forall(fun idty=>NamedClosure.data_type(snd idty))(fn_params f++fn_vars f).
Proof.
 intros f[EQ|[EQ|[EQ|EQ]]];inversion EQ;subst;
 repeat constructor;exact I.
Qed.
Lemma external_supported:forall ef args ret cc,allowed(External ef args ret cc)->executable_builtin ef=true.
Proof. intros ef args ret cc[EQ|[EQ|[EQ|EQ]]];discriminate. Qed.
Definition source_state:=NamedClosure.source_state ge allowed budget.
Theorem entry_source:forall args m,source_state(Execution.entry args m).
Proof. intros;split;[|constructor];unfold allowed;auto. Qed.
Theorem source_step_invariant:forall s t next,source_state s->Csem.step ge s t next->t=E0 /\source_state next.
Proof. exact(NamedClosure.source_step_invariant ge allowed budget internal_body internal_variables external_supported). Qed.
Theorem one_step_correspondence:forall cb asm w s t next,source_state s->
 ((exists rule,In(TR rule t next)(Cexec.do_step ge cb asm w s))<->Csem.step ge s t next).
Proof. exact(NamedClosure.source_do_step_exact ge allowed budget internal_body internal_variables external_supported). Qed.
Theorem source_reachable:forall args m t reached,star Csem.step ge(Execution.entry args m)t reached->source_state reached.
Proof. intros args m t reached PATH;pose proof(entry_source args m)as INIT;induction PATH;auto;apply IHPATH;exact(proj2(source_step_invariant _ _ _ INIT H)). Qed.
Definition closed_step:=Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world.
Theorem whole_execution_correspondence:forall args m t final,
 star closed_step tt(Execution.entry args m)t final<->star Csem.step ge(Execution.entry args m)t final.
Proof.
 intros args m t final;split;intro PATH;pose proof(entry_source args m)as INIT;
 revert INIT;induction PATH;intros INV;[constructor| |constructor|].
 - pose proof(proj1(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV)H)as STEP.
   eapply star_step;[exact STEP|apply IHPATH;exact(proj2(source_step_invariant _ _ _ INV STEP))|assumption].
 - eapply star_step.
   + apply(proj2(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact H.
   + apply IHPATH;exact(proj2(source_step_invariant _ _ _ INV H)).
   + assumption.
Qed.
Theorem invalid_operation_correspondence:forall args m t reached,
 star Csem.step ge(Execution.entry args m)t reached->
 (Execution.source_error reached<->~Execution.normal_return reached /\nostep closed_step tt reached).
Proof.
 intros args m t reached PATH;pose proof(source_reachable _ _ _ _ PATH)as INV.
 unfold Execution.source_error;split;intros[N STOP];split;auto;intros tr nxt STEP;apply(STOP tr nxt).
 - apply(proj1(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact STEP.
 - apply(proj2(one_step_correspondence Execution.no_external Execution.no_external Execution.quiet_world _ _ _ INV));exact STEP.
Qed.
Print Assumptions entry_source.
Print Assumptions one_step_correspondence.
Print Assumptions whole_execution_correspondence.
Print Assumptions invalid_operation_correspondence.


Lemma core_statement_finite:forall stmt,CS stmt->MemoryBridge.finite_statement stmt=true.
Proof.
 induction stmt;cbn[NamedClosure.core_stmt MemoryBridge.finite_statement];intros CO;try contradiction;
 repeat match goal with H:_ /\ _|-_=>destruct H end;try reflexivity;
 apply andb_true_iff;split;auto.
Qed.
Lemma core_continuation_finite:forall k,
 NamedClosure.core_cont ge allowed budget k->MemoryBridge.finite_continuation k.
Proof. induction 1;constructor;auto using core_statement_finite. Qed.
Lemma source_finite:forall s,source_state s->MemoryBridge.finite_state s.
Proof.
 destruct s;cbn[source_state NamedClosure.source_state MemoryBridge.finite_state];intros CO;
 repeat match goal with H:_ /\ _|-_=>destruct H end;
 auto using core_continuation_finite;
 split;auto using core_statement_finite,core_continuation_finite.
Qed.
Lemma source_budget:forall s,source_state s->
 MemoryBridge.calls_within_budget signature_weight ge s.
Proof.
 destruct s as[f stmt k e m|f original k e m|fd args k m|v k m|];
 cbn[MemoryBridge.calls_within_budget];intros INV;try exact I.
 cbn[source_state NamedClosure.source_state]in INV;destruct INV as[CORE[CONT ENV]].
 intros C a fd args ty HC EQ RED;subst original.
 pose proof(NamedClosure.core_context_hole ge allowed budget _ _ _ HC a CORE)as CO.
 destruct(NamedClosure.core_callred ge allowed budget _ _ _ _ _ CO RED)as[ALLOW[BUD[NV TY]]].
 inversion RED;subst;simpl in BUD;unfold budget in BUD;
 cbn[MemoryBridge.expression_rank typeof];lia.
Qed.
Theorem source_all_successors_accessible:forall s,source_state s->Acc(successor ge)s.
Proof.
 apply(MemoryBridge.all_successors_accessible signature_weight ge source_state source_finite source_budget).
 intros s t next INV STEP;exact(proj2(source_step_invariant _ _ _ INV STEP)).
Qed.
Theorem all_successors_termination:forall args m,Acc(successor ge)(Execution.entry args m).
Proof. intros;eapply source_all_successors_accessible;apply entry_source. Qed.
Theorem all_successor_termination:forall args m,Acc(successor ge)(Execution.entry args m).
Proof. exact all_successors_termination. Qed.
Theorem reachable_all_successors_termination:forall args m t reached,
 star Csem.step ge(Execution.entry args m)t reached->Acc(successor ge)reached.
Proof. intros;eapply source_all_successors_accessible;eapply source_reachable;eauto. Qed.
Print Assumptions all_successors_termination.
Print Assumptions reachable_all_successors_termination.

Print Assumptions calc_lookup.
Print Assumptions ned_lookup.
Print Assumptions enu_lookup.
Print Assumptions all_successor_termination.
