From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp.
Import ListNotations.
Open Scope Z_scope.
From CoreCBMC Require Import ArithmeticTree ClampAnnotations ArithmeticExecution.
Theorem command_pair_clamp_annotated:forall e m bp bm maxid x y maximum,
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!maxid=None ->Genv.find_symbol ge maxid=Some bm ->bp<>bm ->
 Mem.load Mint32 m bp 32=Some(Vint x) ->Mem.load Mint32 m bp 36=Some(Vint y) ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 Int.signed maximum<> -2147483648 ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,
 annotated_execution ge e(Ssequence(clamp_assignment(cmd_lvalue S._x)(max_rvalue maxid))(clamp_assignment(cmd_lvalue S._y)(max_rvalue maxid)))m mf /\
 Mem.load Mint32 mf bp 32=Some(Vint(clip_bits x maximum)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(clip_bits y maximum)) /\raw_writes(fun b=>b=bp)m mf /\replay_stores m(clamp_updates bp x y maximum)=Some mf.
Proof.
 intros e m bp bm maxid x y maximum NP SP NM SM DIST LX LY LM NOTMIN AX AY.
 destruct(Mem.valid_access_store m Mint32 bp 32(Vint(clip_bits x maximum))AX)as[m1 ST1].
 assert(AY1:Mem.valid_access m1 Mint32 bp 36 Writable)by(eapply Mem.store_valid_access_1;eauto).
 destruct(Mem.valid_access_store m1 Mint32 bp 36(Vint(clip_bits y maximum))AY1)as[mf ST2].
 exists mf;split.
 - eapply ax_sequence.
   + unfold clamp_assignment;eapply ax_assignment;try reflexivity.
     * eapply command_scalar_clamp with(value:=x)(maximum:=maximum);eauto;left;auto.
     * eapply original_command_clamp_annotation;eassumption.
   + unfold clamp_assignment;eapply ax_assignment;try reflexivity.
     * eapply command_scalar_clamp with(value:=y)(maximum:=maximum);eauto;try(right;auto);scalar_frame;assumption.
     * eapply original_command_clamp_annotation;[exact NM|exact SM|scalar_frame;exact LM|exact NOTMIN].
 - repeat split;try(scalar_frame;reflexivity).
   eapply raw_writes_store;[reflexivity|exact ST1|].
   eapply raw_writes_store;[reflexivity|exact ST2|constructor].
   cbv beta iota zeta delta[clamp_updates replay_stores];rewrite ST1,ST2;reflexivity.
Qed.

Print Assumptions command_pair_clamp_annotated.
