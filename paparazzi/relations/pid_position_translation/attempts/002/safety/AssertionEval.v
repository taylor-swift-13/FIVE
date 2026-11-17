From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactorySemantics.
From PidPositionSafety Require Import AssertionSyntax.
Import ListNotations.
Open Scope Z_scope.
Module E:=PidPositionRunPos.Execution.
Local Transparent FactorySemantics.ge.
Lemma assertion_ge_ce:genv_cenv E.ge=ce.
Proof. exact FactorySemantics.ge_ce. Qed.
Local Opaque E.ge.
Ltac a_cenv :=
 lazymatch goal with |- PTree.get ?id _=Some ?co=>
 unify co(FactorySemantics.co_for id);rewrite assertion_ge_ce;
 apply FactorySemantics.co_for_lookup;vm_compute;reflexivity end.
Ltac a_field :=rewrite assertion_ge_ce;vm_compute;reflexivity.
Ltac a_rv :=
 lazymatch goal with
 | |-eval_simple_rvalue _ _ _(Eval _ _)_=>constructor
 | |-eval_simple_rvalue _ _ _(Ebinop _ _ _ _)_=>
   eapply esr_binop;[a_rv|a_rv|first[apply int32_eq_one|reflexivity]]
 | |-eval_simple_rvalue _ _ _(Evalof ?l ?ty)_=>
   let mode:=eval hnf in(access_mode ty)in
   lazymatch mode with
   | By_copy=>eapply esr_rvalof;[a_lv|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]
   | By_value ?ch=>eapply read_scalar with(chunk:=ch);
     [a_lv|reflexivity|reflexivity|reflexivity|
      lazymatch goal with|-Mem.loadv ?c ?mm(Vptr ?bb ?oo)=Some ?vv=>
       let ox:=eval vm_compute in(Ptrofs.unsigned oo)in
       change(Mem.load c mm bb ox=Some vv);
       match goal with H:Mem.load c mm bb ox=Some _|-_=>exact H end end]
   end
 end
with a_lv :=
 lazymatch goal with
 | |-eval_simple_lvalue _ ?ee _(Evar ?id _) _ _ _=>
   first[eapply esl_var_local;eassumption
   |eapply esl_var_global;[assumption|eassumption]]
 | |-eval_simple_lvalue _ _ _(Efield ?r _ _) _ _ _=>
   let rt:=eval cbv beta iota zeta delta[typeof]in(typeof r)in
   lazymatch rt with
   | Tstruct _ _=>eapply esl_field_struct;[a_rv|reflexivity|a_cenv|a_field]
   | Tunion _ _=>eapply esl_field_union;[a_rv|reflexivity|idtac|a_cenv];a_field
   end
 end.
Lemma assertion_1_true:forall e m bp bs x y,
 e!S._guidance_pid_pos_err=None ->
 Genv.find_symbol E.ge S._guidance_pid_pos_err=Some bp ->
 e!local_err_a=Some(bs,vec_type) ->
 Mem.load Mint32 m bp 0=Some(Vint x) ->Mem.load Mint32 m bp 4=Some(Vint y) ->
 Mem.load Mint32 m bs 0=Some(Vint x) ->Mem.load Mint32 m bs 4=Some(Vint y) ->
 assertion_true E.ge e m assertion_1.
Proof.
 intros;unfold assertion_1;constructor;apply at_simple;[reflexivity| |reflexivity|];
 unfold eq32,vector_axis,object,member,vec_type;a_rv.
Qed.
Lemma assertion_2_true:forall e m bp bs x y,
 e!S._guidance_pid=None ->
 Genv.find_symbol E.ge S._guidance_pid=Some bp ->
 e!local_final_a=Some(bs,pid_type) ->
 Mem.load Mint32 m bp 32=Some(Vint x) ->Mem.load Mint32 m bp 36=Some(Vint y) ->
 Mem.load Mint32 m bs 32=Some(Vint x) ->Mem.load Mint32 m bs 36=Some(Vint y) ->
 assertion_true E.ge e m assertion_2.
Proof.
 intros;unfold assertion_2;constructor;apply at_simple;[reflexivity| |reflexivity|];
 unfold eq32,pid_cmd,vector_axis,object,member,vec_type,pid_type;a_rv.
Qed.
Lemma assertion_3_true:forall e m bp bs x y,
 e!S._guidance_pid_trim_att_integrator=None ->
 Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator=Some bp ->
 e!local_integral_a=Some(bs,vec_type) ->
 Mem.load Mint32 m bp 0=Some(Vint x) ->Mem.load Mint32 m bp 4=Some(Vint y) ->
 Mem.load Mint32 m bs 0=Some(Vint x) ->Mem.load Mint32 m bs 4=Some(Vint y) ->
 assertion_true E.ge e m assertion_3.
Proof.
 intros;unfold assertion_3;constructor;apply at_simple;[reflexivity| |reflexivity|];
 unfold eq32,vector_axis,object,member,vec_type;a_rv.
Qed.
Lemma assertion_4_true:forall e m ba bb tag fmt,
 e!local_ra=Some(ba,sp_type) ->e!local_rb=Some(bb,sp_type) ->
 Mem.load Mint32 m ba 0=Some(Vint tag) ->Mem.load Mint32 m ba 4=Some(Vint fmt) ->
 Mem.load Mint32 m bb 0=Some(Vint tag) ->Mem.load Mint32 m bb 4=Some(Vint fmt) ->
 assertion_true E.ge e m assertion_4.
Proof.
 intros;unfold assertion_4;constructor;apply at_simple;[reflexivity| |reflexivity|];
 unfold eq32,object,member,sp_type;a_rv.
Qed.
Lemma assertion_5_true:forall e m ba bb x y h,
 e!local_ra=Some(ba,sp_type) ->e!local_rb=Some(bb,sp_type) ->
 Mem.load Mint32 m ba 8=Some(Vint x) ->Mem.load Mint32 m ba 12=Some(Vint y) ->Mem.load Mint32 m ba 16=Some(Vint h) ->
 Mem.load Mint32 m bb 8=Some(Vint x) ->Mem.load Mint32 m bb 12=Some(Vint y) ->Mem.load Mint32 m bb 16=Some(Vint h) ->
 assertion_true E.ge e m assertion_5.
Proof.
 intros;unfold assertion_5;constructor;[constructor|];
 apply at_simple;[reflexivity| |reflexivity| |reflexivity|];
 unfold eq32,sp_axis,sp_heading,sp_ltp,vector_axis,object,member,sp_type,vec_type;a_rv.
Qed.
Lemma assertion_6_true:forall e m ba bb bx bdy x y dx dy,
 e!local_a=Some(ba,gh_type) ->e!local_b=Some(bb,gh_type) ->
 e!local_dx=Some(bx,tint) ->e!local_dy=Some(bdy,tint) ->
 Mem.load Mint32 m ba 44=Some(Vint x) ->Mem.load Mint32 m ba 48=Some(Vint y) ->
 Mem.load Mint32 m bb 44=Some(Vint(Int.add x dx)) ->Mem.load Mint32 m bb 48=Some(Vint(Int.add y dy)) ->
 Mem.load Mint32 m bx 0=Some(Vint dx) ->Mem.load Mint32 m bdy 0=Some(Vint dy) ->
 assertion_true E.ge e m assertion_6.
Proof.
 intros;unfold assertion_6;constructor;apply at_simple;[reflexivity| |reflexivity|];
 unfold eq32,gh_pos,vector_axis,object,member,gh_type,vec_type;a_rv.
Qed.
Print Assumptions assertion_1_true.
Print Assumptions assertion_6_true.
