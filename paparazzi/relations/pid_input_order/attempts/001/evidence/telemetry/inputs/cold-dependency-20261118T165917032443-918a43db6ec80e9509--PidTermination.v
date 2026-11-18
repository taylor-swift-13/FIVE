From Stdlib Require Import List Bool Arith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Smallstep Csyntaxdefs.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceSemantics Require Import TableSupport.
From PidPositionRunPos Require Import Source Execution.
From PidPositionSafety Require Import TargetTermination.
Import ListNotations.
Local Open Scope nat_scope.
Module T := TargetTermination.
Definition ge := Execution.ge.
Definition ast_prog:AST.program Csyntax.fundef type :=
 {| AST.prog_defs:=Source.global_definitions;
    AST.prog_public:=Source.public_idents;AST.prog_main:=Source._main |}.
Lemma source_ast:program_of_program Source.prog=ast_prog.
Proof.
 unfold Source.prog,Csyntaxdefs.mkprogram,program_of_program.
 destruct(Csyntaxdefs.build_composite_env' Source.composites I);reflexivity.
Qed.
Lemma ge_base:genv_genv ge=Genv.globalenv ast_prog.
Proof.
 unfold ge,Execution.ge,Csem.globalenv.
 cbv beta iota zeta delta [genv_genv];rewrite source_ast;reflexivity.
Qed.
Global Opaque ge Execution.ge.

Definition symbol_block(id:ident):block :=
 match Genv.find_symbol(Genv.globalenv ast_prog)id with Some b=>b|None=>1%positive end.
Definition block_cost(b:block):nat :=
 if Pos.eqb b(symbol_block Source._guidance_pid_h_run_pos) then 50000 else
 if Pos.eqb b(symbol_block Source._guidance_pid_h_run) then 10000 else
 if Pos.eqb b(symbol_block Source._stab_sp_from_ltp_i) then 1000 else
 if Pos.eqb b(symbol_block Source._stateGetPositionNed_i) then 100 else
 if Pos.eqb b(symbol_block Source._stateGetSpeedNed_i) then 100 else 10.
Definition symbol_cost(id:ident):nat :=
 match Genv.find_symbol(Genv.globalenv ast_prog)id with Some b=>block_cost b|None=>0 end.
Lemma symbol_cost_binding:forall id b,Genv.find_symbol ge id=Some b ->
 symbol_cost id=block_cost b.
Proof.
 intros id b FIND;unfold symbol_cost;rewrite ge_base in FIND;rewrite FIND;reflexivity.
Qed.
Definition allowed(fd:Csyntax.fundef):Prop :=
 exists id,In(id,Gfun fd)Source.global_definitions.
Definition no_function_declarations(vars:list(ident*type)):Prop :=
 forall id ps ret cc,~In(id,Tfunction ps ret cc)vars.
Lemma env_set_no_functions:forall e id b ty,
 T.env_no_functions e ->
 (forall ps ret cc,ty<>Tfunction ps ret cc) ->
 T.env_no_functions(PTree.set id(b,ty)e).
Proof.
 intros e id b ty EN NT;unfold T.env_no_functions;intros id' b' ps ret cc.
 rewrite PTree.gsspec;destruct(peq id' id);subst.
 - intro EQ;inversion EQ;subst;eapply NT;reflexivity.
 - apply EN.
Qed.
Lemma allocation_no_functions:forall e m vars e' m',
 alloc_variables ge e m vars e' m' ->
 no_function_declarations vars -> T.env_no_functions e -> T.env_no_functions e'.
Proof.
 intros e m vars e' m' AL;induction AL;intros NF EN;auto.
 apply IHAL.
 - intros id' ps ret cc IN;apply(NF id' ps ret cc);right;exact IN.
 - apply env_set_no_functions;auto.
   intros ps ret cc EQ;subst ty;apply(NF id ps ret cc);left;reflexivity.
Qed.
Lemma allowed_call:forall v fd,Genv.find_funct ge v=Some fd -> allowed fd.
Proof. intros v fd FIND;rewrite ge_base in FIND;exact(Genv.find_funct_inversion ast_prog v FIND). Qed.
Lemma internal_cases:forall f,allowed(Internal f) ->
 In f[Source.f_stateGetPositionNed_i;Source.f_stateGetSpeedNed_i;
 Source.f_stab_sp_from_ltp_i;Source.f_guidance_pid_h_run;Source.f_guidance_pid_h_run_pos].
Proof.
 intros f[id IN];exact(TableSupport.internal_functions_in _ _ _ IN).
Qed.
Ltac cases_function :=
 intros f AL;destruct(internal_cases f AL)as[EQ|[EQ|[EQ|[EQ|[EQ|BAD]]]]];
 try contradiction;subst f.
Lemma internal_body:forall f,allowed(Internal f) -> T.core_stmt(fn_body f).
Proof.
 cases_function;cbn[fn_body Source.f_stateGetPositionNed_i Source.f_stateGetSpeedNed_i
 Source.f_stab_sp_from_ltp_i Source.f_guidance_pid_h_run Source.f_guidance_pid_h_run_pos
 T.core_stmt T.core_expr T.core_exprlist];
 repeat split;try exact I;repeat constructor.
Qed.
Lemma internal_no_function_declarations:forall f,allowed(Internal f) ->
 no_function_declarations(fn_params f++fn_vars f).
Proof.
 cases_function;unfold no_function_declarations;intros id ps ret cc;
 cbn[fn_params fn_vars Source.f_stateGetPositionNed_i Source.f_stateGetSpeedNed_i
 Source.f_stab_sp_from_ltp_i Source.f_guidance_pid_h_run Source.f_guidance_pid_h_run_pos List.app In];
 intros BAD;repeat destruct BAD as[BAD|BAD];try contradiction;discriminate BAD.
Qed.
Lemma internal_env:forall f,allowed(Internal f) -> forall m e m',
 alloc_variables ge empty_env m(fn_params f++fn_vars f)e m' -> T.env_no_functions e.
Proof.
 intros f AL m e m' A;apply(allocation_no_functions _ _ _ _ _ A).
 - apply internal_no_function_declarations;exact AL.
 - intros id b ps ret cc;rewrite PTree.gempty;discriminate.
Qed.
Definition checked_budgets:bool :=
 forallb(fun pair=>match snd pair with
 | Gfun fd=>Nat.ltb(T.activation_rank block_cost symbol_cost fd+2)(1+block_cost(fst pair))
 | Gvar _=>true end)(PTree.elements(Genv.genv_defs(Genv.globalenv ast_prog))).
Lemma budgets_checked:checked_budgets=true.
Proof. vm_compute;reflexivity. Qed.
Local Opaque ast_prog block_cost symbol_cost.
Lemma call_budget:forall v fd,Genv.find_funct ge v=Some fd ->
 T.activation_rank block_cost symbol_cost fd+2<1+T.pointer_cost block_cost v.
Proof.
 intros v fd FIND;rewrite ge_base in FIND;destruct v;cbn[Genv.find_funct]in FIND;try discriminate.
 destruct(Ptrofs.eq_dec i Ptrofs.zero);try discriminate.
 apply Genv.find_funct_ptr_iff in FIND.
 pose proof(budgets_checked)as CHECK;unfold checked_budgets in CHECK.
 apply forallb_forall with(x:=(b,Gfun fd))in CHECK.
 - apply Nat.ltb_lt in CHECK;exact CHECK.
 - unfold Genv.find_def in FIND.
   exact(@PTree.elements_correct _ (Genv.genv_defs(Genv.globalenv ast_prog)) b (Gfun fd) FIND).
Qed.
Theorem source_entry:forall args m,
 T.source_state block_cost symbol_cost allowed(Execution.entry args m).
Proof.
 intros;split;[|constructor].
 exists Source._guidance_pid_h_run_pos;cbn[Source.global_definitions In].
 repeat first[left;reflexivity|right].
Qed.
Theorem all_successor_termination:forall args m,
 Acc(successor ge)(Execution.entry args m).
Proof.
 intros;apply(T.all_successors_accessible ge block_cost symbol_cost symbol_cost_binding allowed allowed_call internal_body internal_env call_budget).
 apply source_entry.
Qed.
Print Assumptions all_successor_termination.
Print Assumptions internal_body.
Print Assumptions budgets_checked.
