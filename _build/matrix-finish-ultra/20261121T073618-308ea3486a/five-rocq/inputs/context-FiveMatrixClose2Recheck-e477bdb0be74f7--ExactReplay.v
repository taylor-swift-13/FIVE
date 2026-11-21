From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Events Csem Smallstep.
From FiveGuidanceEntry Require Import StackCleanup.
From FiveMatInv3Case Require Import MatrixMemory GuardWitness PairExtend.
From FiveInv2Case Require Import Contract Replay TraceInputs.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.
Lemma extension_reads:forall m0 m,LoadPreserved m0 m->forall b p n f,0<n->Reads m0 b p n f->Reads m b p n f.
Proof. intros m0 m KEEP b p n f N RD;pose proof(reads_valid m0 b p n f N RD)as V;destruct RD as[AL[NW L]];repeat split;auto;intros i B;rewrite KEEP by exact V;apply L;exact B. Qed.
Lemma extension_writable:forall m0 m,AccessPreserved m0 m->forall b p n,WriteRegion m0 b p n->WriteRegion m b p n.
Proof. intros m0 m KEEP b p n[AL[NW RP]];split;[exact AL|];split;[exact NW|];eapply range_perm_access_preserved_block;[intros ch ofs perm VA;exact(KEEP ch b ofs perm VA)|exact RP]. Qed.
Lemma extension_inputs:forall m0 m,LoadPreserved m0 m->AccessPreserved m0 m->forall bo bi po pi f,Inputs m0 bo bi po pi f->Inputs m bo bi po pi f.
Proof. intros m0 m L A bo bi po pi f[NE[W RD]];split;[exact NE|];split;[eapply extension_writable;eauto|eapply extension_reads;eauto;lia]. Qed.
Lemma extension_guarded:forall m0 m,LoadPreserved m0 m->AccessPreserved m0 m->forall bo bi f,Guarded 4 m0 bo bi f->Guarded 4 m bo bi f.
Proof. intros m0 m L A bo bi f[NE[W[RD[OLD[BE AF]]]]].
 pose proof(writable_valid m0 bo(Ptrofs.repr 4)4 ltac:(lia)W)as V.
 split;[exact NE|];split;[eapply extension_writable;eauto|];split;[eapply extension_reads;eauto;lia|];split;[eapply extension_reads;eauto;lia|].
 split;[rewrite L by exact V;exact BE|rewrite L by exact V;exact AF]. Qed.
Definition InitializedLayout(m:mem)(og ig ob ib os is0 ol il:block):Prop:=
 Guarded 4 m og ig trace_input /\Inputs m ob ib Ptrofs.zero Ptrofs.zero base2 /\Inputs m os is0 Ptrofs.zero Ptrofs.zero small2 /\Inputs m ol il Ptrofs.zero Ptrofs.zero large2 /\
 Reads m ob Ptrofs.zero 4 initial_fixture /\Reads m os Ptrofs.zero 4 initial_fixture /\Reads m ol Ptrofs.zero 4 initial_fixture /\Separate og ig ob ib os is0 ol il.
Theorem initialized_layout_inhabited:exists m og ig ob ib os is0 ol il,InitializedLayout m og ig ob ib os is0 ol il.
Proof.
 destruct(matrix4_guarded trace_input)as[m0[og[ig GG]]].
 pose proof GG as[NG[WG[RG RESTG]]].
 pose proof(writable_valid m0 og(Ptrofs.repr 4)4 ltac:(lia)WG)as VG0.
 destruct(pair4_extend m0 base2 initial_fixture)as[m1[ob[ib[NB[WB[RB[OB[FOB[FIB[B1[L1[A1 V1]]]]]]]]]]]].
 assert(IB1:Inputs m1 ob ib Ptrofs.zero Ptrofs.zero base2)by(split;[exact NB|];split;[exact WB|exact RB]).
 pose proof(writable_valid m1 ob Ptrofs.zero 4 ltac:(lia)WB)as VB1.
 pose proof(V1 og VG0)as VG1.
 destruct(pair4_extend m1 small2 initial_fixture)as[m2[os[is0[NS[WS[RS[OS[FOS[FIS[B2[L2[A2 V2]]]]]]]]]]]].
 assert(IS2:Inputs m2 os is0 Ptrofs.zero Ptrofs.zero small2)by(split;[exact NS|];split;[exact WS|exact RS]).
 pose proof(writable_valid m2 os Ptrofs.zero 4 ltac:(lia)WS)as VS2.
 pose proof(V2 og VG1)as VG2;pose proof(V2 ob VB1)as VB2.
 destruct(pair4_extend m2 large2 initial_fixture)as[m3[ol[il[NL[WL[RL[OL[FOL[FIL[B3[L3[A3 V3]]]]]]]]]]]].
 assert(IL3:Inputs m3 ol il Ptrofs.zero Ptrofs.zero large2)by(split;[exact NL|];split;[exact WL|exact RL]).
 exists m3,og,ig,ob,ib,os,is0,ol,il;unfold InitializedLayout;split.
 - eapply extension_guarded;[exact L3|exact A3|];eapply extension_guarded;[exact L2|exact A2|];eapply extension_guarded;eauto.
 - split.
 + eapply extension_inputs;[exact L3|exact A3|];eapply extension_inputs;eauto.
 + split.
 * eapply extension_inputs;eauto.
 * split;[exact IL3|];split.
 -- eapply extension_reads;[exact L3|lia|];eapply extension_reads;eauto;lia.
 -- split;[eapply extension_reads;eauto;lia|];split;[exact OL|].
 constructor;intro EQ;subst;first[exact(FOB VG0)|exact(FIB VG0)|exact(FOS VG1)|exact(FIS VG1)|exact(FOL VG2)|exact(FIL VG2)|exact(FOS VB1)|exact(FIS VB1)|exact(FOL VB2)|exact(FIL VB2)|exact(FOL VS2)|exact(FIL VS2)].
Qed.
Definition TraceNonempty:Prop:=exists m og ig ob ib os is0 ol il ma mb mc md,
 InitializedLayout m og ig ob ib os is0 ol il /\
 NormalCall m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input ma/\Post m ma og ig(Ptrofs.repr 4)Ptrofs.zero trace_input/\
 NormalCall ma ob ib Ptrofs.zero Ptrofs.zero base2 mb/\Post ma mb ob ib Ptrofs.zero Ptrofs.zero base2/\
 NormalCall mb os is0 Ptrofs.zero Ptrofs.zero small2 mc/\Post mb mc os is0 Ptrofs.zero Ptrofs.zero small2/\
 NormalCall mc ol il Ptrofs.zero Ptrofs.zero large2 md/\Post mc md ol il Ptrofs.zero Ptrofs.zero large2.
Theorem original_trace_nonempty:TraceNonempty.
Proof. destruct initialized_layout_inhabited as[m[og[ig[ob[ib[os[is0[ol[il LAYOUT]]]]]]]]].
 pose proof LAYOUT as[GG[IB[IS[IL[OB[OS[OL SEP]]]]]]].
 pose proof GG as[NE[W[RD OTHER]]];assert(IG:Inputs m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input)by(split;[exact NE|];split;[exact W|exact RD]).
 destruct(original_trace_four_calls m og ig ob ib os is0 ol il IG IB IS IL SEP)as[ma[mb[mc[md CALLS]]]].
 exists m,og,ig,ob,ib,os,is0,ol,il,ma,mb,mc,md;split;assumption. Qed.
Print Assumptions initialized_layout_inhabited.
Print Assumptions original_trace_nonempty.
