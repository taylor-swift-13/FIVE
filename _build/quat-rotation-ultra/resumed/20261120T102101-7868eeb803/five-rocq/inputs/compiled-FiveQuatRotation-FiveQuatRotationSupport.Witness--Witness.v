From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Coqlib Integers Floats Values Memory Memdata.
From FiveQuatRotation Require Import Spec.
From FiveQuatRotationSupport Require Import Fixture Initial Protocol Observer Numerics.
Import ListNotations.
Local Open Scope Z_scope.
Lemma bits_from_cells:forall m b bits,BitCells m b 0 bits->InputBits m b bits.
Proof. intros m b bits H i z N;unfold BitCells in H.
 assert(I:(i<length bits)%nat)by(apply nth_error_Some;rewrite N;discriminate).
 specialize(H i I);rewrite(nth_error_nth _ _ 0 N)in H;exact H. Qed.
Theorem facts_witness:forall f qi qx qy qz vx vy vz lhs rhs,
 FixtureFacts f[qi;qx;qy;qz][vx;vy;vz]->Domain(initial f)(qb f)(vb f)(ab f)(rb f)(bb f)->
 DirectBytes(Initial.fb qi)(Initial.fb qx)(Initial.fb qy)(Initial.fb qz)(Initial.fb vx)(Initial.fb vy)(Initial.fb vz)=WordBytes lhs->
 MatrixPathBytes(Initial.fb qi)(Initial.fb qx)(Initial.fb qy)(Initial.fb qz)(Initial.fb vx)(Initial.fb vy)(Initial.fb vz)=WordBytes rhs->
 ProtocolWitness[qi;qx;qy;qz][vx;vy;vz]lhs rhs.
Proof.
 intros f qi qx qy qz vx vy vz lhs rhs F DOM NL NR.
 pose proof(fixture_disjoint _ _ _ F)as ND.
 assert(ND5:NoDup[qb f;vb f;ab f;rb f;bb f]).
 { change(NoDup([qb f;vb f;ab f;rb f;bb f]++[ca f;cb f]))in ND;exact(NoDup_app_remove_r _ _ ND). }
 assert(WR:WCells(initial f)(rb f)9)by(intros i I;exact(range_access _ _ _ i(fixture_r _ _ _ F)ltac:(lia)ltac:(lia))).
 assert(WB:WCells(initial f)(bb f)3)by(intros i I;exact(range_access _ _ _ i(fixture_b _ _ _ F)ltac:(lia)ltac:(lia))).
 assert(WCA:WCells(initial f)(ca f)3)by(intros i I;exact(range_access _ _ _ i(fixture_ca _ _ _ F)ltac:(lia)ltac:(lia))).
 assert(WCB:WCells(initial f)(cb f)3)by(intros i I;exact(range_access _ _ _ i(fixture_cb _ _ _ F)ltac:(lia)ltac:(lia))).
 destruct(protocol(initial f)(qb f)(vb f)(ab f)(rb f)(bb f)(cb f)(Initial.fb qi)(Initial.fb qx)(Initial.fb qy)(Initial.fb qz)(Initial.fb vx)(Initial.fb vy)(Initial.fb vz)ND5(facts_inputs _ _ _ _ _ _ _ _ F)WR WB WCB(fixture_anchor _ _ _ F))as(md&mr&mf&PATH&LEFT&RIGHT&FRAME&ACCESS).
 rewrite NL in LEFT;rewrite NR in RIGHT.
 assert(OBSSEP:ab f<>ca f /\bb f<>cb f /\bb f<>ca f /\cb f<>ca f).
 { pose proof ND as N;repeat match goal with H:NoDup(_::_)|-_=>inversion H;subst;clear H end;simpl in *;intuition congruence. }
 destruct OBSSEP as[AC[BC[BCA CBCA]]].
 destruct PATH as[CD[CM CR]].
 exists(initial f),(qb f),(vb f),(ab f),(rb f),(bb f),(ca f),(cb f),md,mr,mf.
 split;[exact ND|];split;[exact DOM|];split;[eapply bits_from_cells;exact(fixture_q _ _ _ F)|];split;[eapply bits_from_cells;exact(fixture_v _ _ _ F)|].
 split;[exact CD|];split;[exact CM|];split;[exact CR|];split;[exact LEFT|];split;[exact RIGHT|];split;[exact FRAME|].
 intros se;eapply observer;[exact AC|exact BC|exact BCA|exact CBCA|exact LEFT|exact RIGHT| |].
 - intros i I;apply ACCESS;apply WCA;exact I.
 - intros i I;apply ACCESS;apply WCB;exact I.
Qed.
Theorem unit_witness:UnitWitness.
Proof. apply(facts_witness unit_fixture 1065353216 0 0 0 1065353216 0 0[1065353216;0;0][1065353214;0;0]unit_facts unit_domain).
 - exact(proj1 unit_numerics).
 - exact(proj2 unit_numerics).
Qed.
Theorem actual_trace_witness:ActualTraceWitness.
Proof. apply(facts_witness trace_fixture 3208096458 3191717350 2687829235 268909329 1124089879 1149239296 2382364672[1095327876;1106339776;3280478549][1095327877;1106339776;3280478549]trace_facts trace_domain).
 - exact(proj1 trace_numerics).
 - exact(proj2 trace_numerics).
Qed.
Print Assumptions unit_witness.
Print Assumptions actual_trace_witness.
