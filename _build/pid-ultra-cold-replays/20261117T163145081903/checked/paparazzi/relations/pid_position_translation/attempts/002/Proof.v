From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.

Lemma axis_translation_initialized : forall gh a b axis d,
 AxisTranslation gh a b axis d ->
 (exists r p, load_path Mint32 a gh gh_type (ref_pos axis)=Some(Vint r) /\
 load_global Mint32 a Source._state state_type (measured_pos axis)=Some(Vint p)) /\
 (exists r p, load_path Mint32 b gh gh_type (ref_pos axis)=Some(Vint r) /\
 load_global Mint32 b Source._state state_type (measured_pos axis)=Some(Vint p)).
Proof.
 intros gh a b axis d [ra [pa [rb [pb [RA [PA [RB [PB REST]]]]]]]].
 split; [exists ra,pa|exists rb,pb];auto.
Qed.

Lemma axis_translation_subtractions_safe : forall gh a b axis d,
 AxisTranslation gh a b axis d ->
 (exists r p, load_path Mint32 a gh gh_type (ref_pos axis)=Some(Vint r) /\
 load_global Mint32 a Source._state state_type (measured_pos axis)=Some(Vint p) /\
 signed32(Int.signed r-Int.signed p)) /\
 (exists r p, load_path Mint32 b gh gh_type (ref_pos axis)=Some(Vint r) /\
 load_global Mint32 b Source._state state_type (measured_pos axis)=Some(Vint p) /\
 signed32(Int.signed r-Int.signed p)).
Proof.
 intros gh a b axis d [ra [pa [rb [pb [RA [PA [RB [PB [PHY [RBE PBE]]]]]]]]]].
 destruct PHY as [R [P [D [RD [PD ERR]]]]].
 split.
 - exists ra,pa;auto.
 - exists rb,pb;split;[exact RB|];split;[exact PB|]. rewrite RBE,PBE.
   rewrite common_translation_difference;exact ERR.
Qed.

Definition LegacyInputPair (gh ret:block) (a b:mem) (dx dy:Z) : Prop :=
 InputGoodLegacy a gh ret /\ InputGoodLegacy b gh ret /\
 same_except_positions_and_return gh ret a b /\
 AxisTranslation gh a b Source._x dx /\ AxisTranslation gh a b Source._y dy.

Theorem corrected_relation_domain_unchanged : forall gh ret a b dx dy,
 InputPair gh ret a b dx dy <-> LegacyInputPair gh ret a b dx dy.
Proof.
 intros gh ret a b dx dy;split.
 - intros [[A _] [[B _] REST]];exact(conj A(conj B REST)).
 - intros [A [B [FRAME [X Y]]]].
   assert (INIT : initialized_positions a gh /\ initialized_positions b gh).
   { split;unfold initialized_positions;intros axis AX;
     destruct AX as [<-|[<-|[]]];
     [exact(proj1(axis_translation_initialized _ _ _ _ _ X))|
      exact(proj1(axis_translation_initialized _ _ _ _ _ Y))|
      exact(proj2(axis_translation_initialized _ _ _ _ _ X))|
      exact(proj2(axis_translation_initialized _ _ _ _ _ Y))]. }
   assert (SAFE : position_subtractions_safe a gh /\ position_subtractions_safe b gh).
   { split;unfold position_subtractions_safe;intros axis AX;
     destruct AX as [<-|[<-|[]]];
     [exact(proj1(axis_translation_subtractions_safe _ _ _ _ _ X))|
      exact(proj1(axis_translation_subtractions_safe _ _ _ _ _ Y))|
      exact(proj2(axis_translation_subtractions_safe _ _ _ _ _ X))|
      exact(proj2(axis_translation_subtractions_safe _ _ _ _ _ Y))]. }
   destruct INIT as [IA IB];destruct SAFE as [SA SB].
   exact(conj (conj A(conj IA SA))(conj(conj B(conj IB SB))(conj FRAME(conj X Y)))).
Qed.
Print Assumptions corrected_relation_domain_unchanged.

Theorem axis_translation_machine_difference : forall gh a b axis d ra pa rb pb,
 AxisTranslation gh a b axis d ->
 load_path Mint32 a gh gh_type(ref_pos axis)=Some(Vint ra) ->
 load_global Mint32 a Source._state state_type(measured_pos axis)=Some(Vint pa) ->
 load_path Mint32 b gh gh_type(ref_pos axis)=Some(Vint rb) ->
 load_global Mint32 b Source._state state_type(measured_pos axis)=Some(Vint pb) ->
 Int.sub ra pa=Int.sub rb pb.
Proof.
 intros gh a b axis d ra pa rb pb
 [ra0[pa0[rb0[pb0[RA[PA[RB[PB[PHY[RBE PBE]]]]]]]]]]RA' PA' RB' PB'.
 rewrite RA in RA';inversion RA';subst ra0.
 rewrite PA in PA';inversion PA';subst pa0.
 rewrite RB in RB';inversion RB';subst rb0.
 rewrite PB in PB';inversion PB';subst pb0.
 rewrite!Int.sub_signed;rewrite RBE,PBE,common_translation_difference;reflexivity.
Qed.
Print Assumptions axis_translation_machine_difference.

From PidPositionTranslationAttempt002 Require Import NormalReturn.
Theorem paired_original_normal_returns :
 forall gh ret a b dx dy flight,InputPair gh ret a b dx dy ->
 exists af bf,NormalCall gh ret flight a af /\NormalCall gh ret flight b bf.
Proof.
 intros gh ret a b dx dy flight[A[B REST]].
 destruct(original_entry_normal_return a gh ret flight A)as[af AF].
 destruct(original_entry_normal_return b gh ret flight B)as[bf BF].
 exists af,bf;auto.
Qed.
Print Assumptions paired_original_normal_returns.

From PidPositionTranslationAttempt002 Require Import MainGoals.
Theorem position_translation : PositionTranslationGoal.
Proof. exact MainGoals.proved_position_translation. Qed.
Theorem no_error : NoErrorGoal.
Proof. exact MainGoals.proved_no_error. Qed.
Theorem all_successor_termination : AllSuccessorTerminationGoal.
Proof. exact MainGoals.proved_all_successor_termination. Qed.
Theorem input_nonvacuity : InputNonvacuityGoal.
Proof. exact MainGoals.proved_input_nonvacuity. Qed.
Theorem nonzero_nonvacuity : NonzeroNonvacuityGoal.
Proof. exact MainGoals.proved_nonzero_nonvacuity. Qed.
Print Assumptions position_translation.
Print Assumptions no_error.
Print Assumptions all_successor_termination.

From PidPositionTranslationAttempt002 Require Import FrameRelation.
Theorem relational_frame : RelationalFrameGoal.
Proof. exact FrameRelation.proved_relational_frame. Qed.
Print Assumptions relational_frame.
