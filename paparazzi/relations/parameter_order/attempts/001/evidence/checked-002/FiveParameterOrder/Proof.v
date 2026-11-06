From Stdlib Require Import List.
From compcert Require Import Values Memory Floats Globalenvs Csem Smallstep.
From FivePaparazziState Require Import State Layout.
From FiveParameterOrder Require Import Spec.
Require FiveGhSetOmegaProof.Entry FiveGhSetZetaProof.Entry.
Import ListNotations.

Theorem normal_completion : NormalCompletion.
Proof.
 unfold NormalCompletion;intros s o z ma mb ba bb IA IB.
 destruct IA as [RA[WA[OA ZA]]];destruct IB as [RB[WB[OB ZB]]].
 destruct(FiveGhSetOmegaProof.Entry.entry_normal s o ma ba OA RA WA)as[ta[mi[PA[RI WI]]]].
 destruct(FiveGhSetZetaProof.Entry.entry_normal (State.set_omega s o) z mi ba ZA RI WI)as[tb[fa[PB[RF WF]]]].
 destruct(FiveGhSetZetaProof.Entry.entry_normal s z mb bb ZB RB WB)as[tc[mj[PC[RJ WJ]]]].
 destruct(FiveGhSetOmegaProof.Entry.entry_normal (State.set_zeta s z) o mj bb OB RJ WJ)as[td[fb[PD[RG WG]]]].
 exists fa,fb;split.
 - exists mi,(Vsingle(State.clamp_omega o)),(Vsingle(State.clamp_zeta z));split;[exists ta|exists tb];assumption.
 - split.
   + exists mj,(Vsingle(State.clamp_zeta z)),(Vsingle(State.clamp_omega o));split;[exists tc|exists td];assumption.
   + split;[exact RF|]. unfold final_state;rewrite State.setters_commute;exact RG.
Qed.

Theorem all_final_state_formula : AllFinalStateFormula.
Proof.
 unfold AllFinalStateFormula;intros s o z ma mb ba bb fa fb IA IB A B.
 destruct IA as [RA[WA[OA ZA]]];destruct IB as [RB[WB[OB ZB]]].
 destruct A as[mi[vo[vz[[ta PA][tb PB]]]]].
 destruct B as[mj[vz1[vo1[[tc PC][td PD]]]]].
 destruct(FiveGhSetOmegaProof.Entry.entry_return_spec s o ma ba ta vo mi OA RA WA PA)as[_[RI WI]].
 destruct(FiveGhSetZetaProof.Entry.entry_return_spec (State.set_omega s o) z mi ba tb vz fa ZA RI WI PB)as[_[RF WF]].
 destruct(FiveGhSetZetaProof.Entry.entry_return_spec s z mb bb tc vz1 mj ZB RB WB PC)as[_[RJ WJ]].
 destruct(FiveGhSetOmegaProof.Entry.entry_return_spec (State.set_zeta s z) o mj bb td vo1 fb OB RJ WJ PD)as[_[RG WG]].
 split;[exact RF|]. unfold final_state;rewrite State.setters_commute;exact RG.
Qed.

Theorem all_final_named_bits : AllFinalNamedBits.
Proof.
 unfold AllFinalNamedBits;intros s o z ma mb ba bb fa fb sa sb IA IB A B SA SB.
 destruct(all_final_state_formula s o z ma mb ba bb fa fb IA IB A B)as[RA RB].
 assert(EA:sa=final_state s o z)by(eapply State.repr_unique;eauto).
 assert(EB:sb=final_state s o z)by(eapply State.repr_unique;eauto).
 rewrite EA,EB;reflexivity.
Qed.
Theorem satisfiable_initial : SatisfiableInitial.
Proof.
 destruct Layout.concrete_initialized_state as[m[R W]].
 exists Layout.zero_state,m,m,Layout.shared_block,Layout.shared_block.
 split;unfold initial;repeat split;try assumption;try exact Layout.omega_symbol;try exact Layout.zeta_symbol.
Qed.
Print Assumptions normal_completion.
Print Assumptions all_final_state_formula.
Print Assumptions all_final_named_bits.
Print Assumptions satisfiable_initial.
