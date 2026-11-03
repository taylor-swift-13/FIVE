From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveCases.lowpass.model Require Import Source.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From FiveCases.lowpass.model Require Import SourceInvariant.
From FiveCases.lowpass.proof.support Require Import NormalCorrespondence.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.proof.support Require Import MemorySpec.
From FiveCases.lowpass.proof.support Require Import ConcreteBody.
From FiveCases.lowpass.proof.support Require Import SourceFunctional.
From FiveCases.lowpass.proof.support Require Import StandardBody.
From FiveCases.lowpass.proof.support Require Import CallBoundary.
From FiveCases.lowpass.model Require Import ExecutionModel.
From FiveCases.lowpass.proof Require Import PureProgress.
From FiveCases.lowpass.proof Require Import Invariant.
Import ListNotations.
Local Open Scope Z_scope.

Record lowpass_pre (m:mem) (b:block) (s:filter_state) : Prop := {
 pre_live : Mem.valid_block m b;
 pre_initialized : HarnessMemory.initialized_state m b s;
 pre_writes : forall ofs,In ofs [16;20;24;28] ->
   Mem.valid_access m Mfloat32 b ofs Writable
}.

Definition frame_env (bp bv bo:block) : env :=
 PTree.set Source._out (bo,tfloat)
 (PTree.set Source._value (bv,tfloat)
 (PTree.set Source._filter (bp,tptr(Tstruct Source._SecondOrderLowPass noattr)) empty_env)).

Lemma frame_lookup : forall bp bv bo,
 PTree.get Source._filter (frame_env bp bv bo)=Some(bp,tptr(Tstruct Source._SecondOrderLowPass noattr)) /\
 PTree.get Source._value (frame_env bp bv bo)=Some(bv,tfloat) /\
 PTree.get Source._out (frame_env bp bv bo)=Some(bo,tfloat).
Proof. intros;repeat split;reflexivity. Qed.

Lemma frame_blocks : forall bp bv bo,
 blocks_of_env lowpass_ge (frame_env bp bv bo)=[(bo,0,4);(bp,0,8);(bv,0,4)].
Proof. reflexivity. Qed.

Lemma free_frame_exists : forall m bp bv bo,
 bp<>bv -> bp<>bo -> bv<>bo ->
 Mem.valid_access m Mptr bp 0 Freeable ->
 Mem.valid_access m Mfloat32 bv 0 Freeable ->
 Mem.valid_access m Mfloat32 bo 0 Freeable ->
 exists mf,Mem.free_list m (blocks_of_env lowpass_ge (frame_env bp bv bo))=Some mf.
Proof.
 intros m bp bv bo PB PO VO WP WV WO.
 destruct(Mem.range_perm_free m bo 0 4 (proj1 WO))as [m1 F1].
 assert(WP1:Mem.valid_access m1 Mptr bp 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F1|exact WP|left;congruence]. }
 assert(WV1:Mem.valid_access m1 Mfloat32 bv 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F1|exact WV|left;congruence]. }
 destruct(Mem.range_perm_free m1 bp 0 8 (proj1 WP1))as [m2 F2].
 assert(WV2:Mem.valid_access m2 Mfloat32 bv 0 Freeable).
 { eapply Mem.valid_access_free_1;[exact F2|exact WV1|left;congruence]. }
 destruct(Mem.range_perm_free m2 bv 0 4 (proj1 WV2))as [mf F3].
 exists mf;rewrite frame_blocks.
 change((match Mem.free m bo 0 4 with
  |Some m1=>match Mem.free m1 bp 0 8 with
    |Some m2=>match Mem.free m2 bv 0 4 with Some mf=>Some mf|None=>None end
    |None=>None end
  |None=>None end)=Some mf).
 rewrite F1,F2,F3;reflexivity.
Qed.

Theorem structural_pre_establishes_invariant : forall m b fs input,
 lowpass_pre m b fs ->
 execution_invariant(lowpass_start(Vptr b Ptrofs.zero)(Vsingle(Float32.of_bits input))m).
Proof.
 intros m b fs input [LIVE INIT WRITE].
 destruct(Mem.alloc m 0 8)as [mp bp]eqn:AP.
 destruct(Mem.alloc mp 0 4)as [mv bv]eqn:AV.
 destruct(Mem.alloc mv 0 4)as [ma bo]eqn:AO.
 set(e:=frame_env bp bv bo).
 destruct(frame_lookup bp bv bo)as [EF[EV EO]].
 assert(ALLOC:alloc_variables lowpass_ge empty_env m
  (fn_params lowpass_function++fn_vars lowpass_function)e ma).
 { change(alloc_variables lowpass_ge empty_env m
   [(Source._filter,tptr(Tstruct Source._SecondOrderLowPass noattr));
    (Source._value,tfloat);(Source._out,tfloat)] e ma).
   eapply alloc_variables_cons;[exact AP|].
   eapply alloc_variables_cons;[exact AV|].
   eapply alloc_variables_cons;[exact AO| ]. constructor. }
 assert(WP:Mem.valid_access ma Mptr bp 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AO|].
   eapply Mem.valid_access_alloc_other;[exact AV|].
   eapply Mem.valid_access_alloc_same;[exact AP|lia|change(0+8<=8);lia|exists 0;reflexivity]. }
 assert(WV:Mem.valid_access ma Mfloat32 bv 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact AO|].
   eapply Mem.valid_access_alloc_same;[exact AV|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 assert(WO:Mem.valid_access ma Mfloat32 bo 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact AO|lia|change(0+4<=4);lia|exists 0;reflexivity]. }
 destruct(lowpass_allocated_environment _ _ _ ALLOC)
  as [bp'[bv'[bo'[EF'[EV'[EO'[PV[PO[VO WOO]]]]]]]]].
 unfold e in EF',EV',EO'.
 rewrite EF in EF';inversion EF';subst bp'.
 rewrite EV in EV';inversion EV';subst bv'.
 rewrite EO in EO';inversion EO';subst bo'.
 assert(PB:bp<>b).
 { intro EQ;subst bp;eapply(allocated_private_blocks_are_fresh _ _ _ _ _ ALLOC Source._filter b _);eauto. }
 assert(VB:bv<>b).
 { intro EQ;subst bv;eapply(allocated_private_blocks_are_fresh _ _ _ _ _ ALLOC Source._value b _);eauto. }
 assert(OB:bo<>b).
 { intro EQ;subst bo;eapply(allocated_private_blocks_are_fresh _ _ _ _ _ ALLOC Source._out b _);eauto. }
 assert(WPW:Mem.valid_access ma Mptr bp 0 Writable)by(eapply Mem.valid_access_freeable_any;exact WP).
 destruct(Mem.valid_access_store ma Mptr bp 0(Vptr b Ptrofs.zero) WPW)as [mb SP].
 assert(WVW:Mem.valid_access mb Mfloat32 bv 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SP|];eapply Mem.valid_access_freeable_any;exact WV. }
 destruct(Mem.valid_access_store mb Mfloat32 bv 0(Vsingle(Float32.of_bits input)) WVW)as [m0 SV].
 assert(BIND:bind_parameters lowpass_ge e ma(fn_params lowpass_function)
  [Vptr b Ptrofs.zero;Vsingle(Float32.of_bits input)] m0).
 { change(bind_parameters lowpass_ge e ma
   [(Source._filter,tptr(Tstruct Source._SecondOrderLowPass noattr));(Source._value,tfloat)]
   [Vptr b Ptrofs.zero;Vsingle(Float32.of_bits input)]m0).
   eapply bind_parameters_cons with(m1:=mb);[exact EF| |].
   - eapply assign_loc_value;[reflexivity|reflexivity| ]. change(Mem.store Mptr ma bp 0(Vptr b Ptrofs.zero)=Some mb);exact SP.
   - eapply bind_parameters_cons with(m1:=m0);[exact EV| |].
     + eapply assign_loc_value;[reflexivity|reflexivity|].
       change(Mem.store Mfloat32 mb bv 0(Vsingle(Float32.of_bits input))=Some m0);exact SV.
     + constructor. }
 destruct(lowpass_bound_parameter_values e ma m0 bp bv b input EF EV PV BIND)as [PTR VALUE].
 assert(INIT0:HarnessMemory.initialized_state m0 b fs)
  by(eapply lowpass_call_preserves_initialized_object;eauto).
 assert(WBO:Mem.valid_access m0 Mfloat32 bo 0 Writable).
 { eapply binding_preserves_valid_access;[exact BIND|apply lowpass_parameters_scalar|].
   eapply Mem.valid_access_freeable_any;exact WO. }
 assert(WW:forall ofs,In ofs [16;20;24;28] -> Mem.valid_access m0 Mfloat32 b ofs Writable).
 { intros ofs IN;eapply lowpass_call_preserves_valid_access;eauto. }
 destruct(five_writable_stores_exist m0 bo b fs input WBO
  (WW 20 ltac:(simpl;auto))(WW 16 ltac:(simpl;auto))
  (WW 28 ltac:(simpl;auto))(WW 24 ltac:(simpl;auto)))
  as [m1[m2[m3[m4[m5[S0[S1[S2[S3 S4]]]]]]]]].
 assert(CERT:source_body_certificate e fs input bo b m0 m1 m2 m3 m4 m5)
  by(eapply standard_memory_constructs_body_certificate;eauto).
 assert(KEEP:forall chunk bx ofs p,Mem.valid_access ma chunk bx ofs p -> Mem.valid_access m5 chunk bx ofs p).
 { intros chunk bx ofs p ACCESS.
   eapply Mem.store_valid_access_1;[exact S4|].
   eapply Mem.store_valid_access_1;[exact S3|].
   eapply Mem.store_valid_access_1;[exact S2|].
   eapply Mem.store_valid_access_1;[exact S1|].
   eapply Mem.store_valid_access_1;[exact S0|].
   eapply Mem.store_valid_access_1;[exact SV|].
   eapply Mem.store_valid_access_1;[exact SP|exact ACCESS]. }
 destruct(free_frame_exists m5 bp bv bo PV PO VO
  (KEEP _ _ _ _ WP)(KEEP _ _ _ _ WV)(KEEP _ _ _ _ WO))as [mf FREE].
 split;[apply lowpass_start_source| ]. split;[reflexivity|].
 exists(Vsingle(Float32.of_bits(calc_out fs input)),mf).
 eapply source_entry_denotation;eauto.
Qed.



