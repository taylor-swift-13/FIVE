From Stdlib Require Import List.
From compcert Require Import Integers Floats AST Values Memory.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
Import ListNotations.

Lemma vector_bits_injective : forall a b,
 vector_bits a=vector_bits b -> a=b.
Proof.
 intros [ax ay] [bx byy] H; unfold vector_bits in H; simpl in H.
 pose proof(f_equal (fun xs:list int => hd Int.zero xs) H)as HX.
 pose proof(f_equal (fun xs:list int => hd Int.zero (tl xs)) H)as HY.
 change(Float32.to_bits ax=Float32.to_bits bx)in HX.
 change(Float32.to_bits ay=Float32.to_bits byy)in HY.
 apply float32_bits_inj in HX; apply float32_bits_inj in HY; subst; reflexivity.
Qed.
Lemma matching_command_exact : forall s sp a si,
 MatchingCommand s sp a -> integrate s=Some si -> a=raw_speed_accel si sp.
Proof.
 intros s sp a si (expected & INT & BITS) I.
 rewrite I in INT; injection INT as EQ; subst expected; apply vector_bits_injective; exact BITS.
Qed.
Lemma matching_updates : forall maximum s sp a,
 MatchingCommand s sp a -> speed_update maximum s sp=accel_update maximum s a.
Proof.
 intros maximum s sp a M; destruct M as (si & INT & BITS).
 apply vector_bits_injective in BITS; subst a.
 apply matching_accel_after_integration; exact INT.
Qed.
Lemma final_bits_from_formula : AllFinalStateFormula -> AllFinalNamedBits.
Proof.
 intros F; unfold AllFinalNamedBits.
 intros s sp a ma mb ba bb pa pb oa ob fa fb sa sb IA IB MATCH A B RA RB.
 destruct(F s sp a ma mb ba bb pa pb oa ob fa fb IA IB MATCH A B)as(sf & UPDATE & SA & SB).
 assert(EA:sa=sf)by(eapply State.repr_unique;eauto).
 assert(EB:sb=sf)by(eapply State.repr_unique;eauto).
 rewrite EA,EB;reflexivity.
Qed.
Print Assumptions vector_bits_injective.
Print Assumptions matching_updates.
Print Assumptions final_bits_from_formula.
