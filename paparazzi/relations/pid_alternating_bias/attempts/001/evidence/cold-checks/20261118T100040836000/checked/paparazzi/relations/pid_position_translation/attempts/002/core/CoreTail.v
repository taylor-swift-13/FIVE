From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics.
Import ListNotations.
Open Scope Z_scope.
Definition force_statement:=top_statement 6(fn_body S.f_guidance_pid_h_run).
Theorem original_force_false_skips:forall e m bp,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 Mem.load Mint8unsigned m bp 44=Some(Vint Int.zero) ->
 exec_stmt ge e m force_statement E0 m Out_normal.
Proof.
 intros e m bp NP SP APPROX.
 assert(LV:eval_simple_lvalue ge e m
 (Efield(Evalof(Evar S._guidance_pid(Tstruct S._GuidancePID noattr))(Tstruct S._GuidancePID noattr))S._approx_force_by_thrust tbool)
 bp(Ptrofs.add Ptrofs.zero(Ptrofs.repr 44))Full).
 { core_lv I I I NP I I SP I I I I I I. }
 assert(RV:eval_simple_rvalue ge e m
 (Evalof(Efield(Evalof(Evar S._guidance_pid(Tstruct S._GuidancePID noattr))(Tstruct S._GuidancePID noattr))S._approx_force_by_thrust tbool)tbool)(Vint Int.zero)).
 { eapply read_scalar with(chunk:=Mbool);[exact LV|reflexivity|reflexivity|reflexivity|].
   change(Mem.load Mbool m bp 44=Some(Vint Int.zero));rewrite Mem.load_bool_int8_unsigned,APPROX;reflexivity. }
 unfold force_statement;cbn[top_statement S.f_guidance_pid_h_run fn_body].
 eapply exec_Sifthenelse with(v1:=Vint Int.zero)(b:=false)(m1:=m)(t1:=E0)(t2:=E0).
 - eapply eval_expression_intro with(a':=Eval(Vint Int.zero)tint);[|constructor].
   eapply eval_seqand_false.
   + eapply(proj1(simple_eval_expr_refl ge e m));[exact RV|reflexivity].
   + exact RV.
   + reflexivity.
 - reflexivity.
 - constructor.
Qed.
Corollary original_total_clamp_normal:forall e m bp bm x y maximum,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!S._total_max_bank=None ->Genv.find_symbol ge S._total_max_bank=Some bm ->bp<>bm ->
 Mem.load Mint32 m bp 32=Some(Vint x) ->Mem.load Mint32 m bp 36=Some(Vint y) ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,exec_stmt ge e m total_clamp E0 mf Out_normal /\
 Mem.load Mint32 mf bp 32=Some(Vint(clip_bits x maximum)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(clip_bits y maximum)) /\raw_writes(fun b=>b=bp)m mf /\replay_stores m(clamp_updates bp x y maximum)=Some mf.
Proof. intros;rewrite total_clamp_source;eapply command_pair_clamp_normal;eauto. Qed.
Fixpoint drop_statements(n:nat)(s:statement):statement:=
 match n with O=>s|Datatypes.S n=>match s with Ssequence _ b=>drop_statements n b|_=>Sskip end end.
Lemma execution_splice_prefix:forall n s e m ma mf out,
 exec_stmt ge e m(first_statements n s)E0 ma Out_normal ->
 exec_stmt ge e ma(drop_statements n s)E0 mf out ->
 exec_stmt ge e m s E0 mf out.
Proof.
 induction n;intros s e m ma mf out A B.
 - cbn[first_statements]in A;inversion A;subst;exact B.
 - destruct s;cbn[first_statements drop_statements]in A,B;
   try(solve[inversion B;subst;exact A]).
   destruct(sequence_normal_inv _ _ _ _ _ _ A)as[mid[HEAD REST]].
   eapply sequence_normal;[exact HEAD|eapply IHn;eauto].
Qed.
Print Assumptions original_force_false_skips.
Print Assumptions original_total_clamp_normal.
Print Assumptions execution_splice_prefix.
