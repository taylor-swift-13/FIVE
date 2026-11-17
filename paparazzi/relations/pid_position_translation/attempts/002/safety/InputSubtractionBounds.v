From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory.
From PidPositionRunPos Require Import Source.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import MappedEntrySafety.
From CoreCBMC Require Import NumericBounds.
Import ListNotations.
Theorem inputgood_fixed_subtraction_safe:forall(kind:bool)m gh ret axis reference measured,
 InputGood m gh ret ->In axis[Source._x;Source._y] ->
 (if kind then load_path Mint32 m gh gh_type[Source._ref;Source._speed;axis]
 else load_path Mint32 m gh gh_type(ref_pos axis))=Some(Vint reference) ->
 (if kind then load_global Mint32 m Source._state state_type[Source._ned_speed_i;axis]
 else load_global Mint32 m Source._state state_type(measured_pos axis))=Some(Vint measured) ->
 NumericBounds.signed32(Int.signed reference-Int.signed measured).
Proof.
 intros kind m gh ret axis reference measured GOOD AX LR LP.
 assert(EX:exists r p,
 (if kind then load_path Mint32 m gh gh_type[Source._ref;Source._speed;axis]
 else load_path Mint32 m gh gh_type(ref_pos axis))=Some(Vint r) /\
 (if kind then load_global Mint32 m Source._state state_type[Source._ned_speed_i;axis]
 else load_global Mint32 m Source._state state_type(measured_pos axis))=Some(Vint p) /\
 TranslationArithmetic.signed32(Int.signed r-Int.signed p)).
 { destruct kind;[exact(original_speed_subtraction_safe axis m gh ret GOOD AX)|exact(original_position_subtraction_safe axis m gh ret GOOD AX)]. }
 destruct EX as[r[p[ER[EP SAFE]]]].
 rewrite LR in ER;injection ER as RR;subst r.
 rewrite LP in EP;injection EP as PP;subst p.
 exact SAFE.
Qed.
Print Assumptions inputgood_fixed_subtraction_safe.
