From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Csyntax Csem Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import LowDecoder.
From PprzTrigCBMC Require Import ArrayOwners ArrayEvents ArrayPrograms.
Local Open Scope Z_scope.
Definition NamedBound(ge:Csem.genv)(id:ident)(n scale:Z)(b:block)(ofs:ptrofs):Prop:=
 Genv.find_symbol ge id=Some b/\exists index,ofs=Ptrofs.repr(scale*Int.signed index)/\0<=Int.signed index<n.
Lemma plain_bound_named:forall b ofs,EventBound PprzTrigPlain.Execution.ge tshort plain_array_owner
 PprzTrigPlain.Source.f_pprz_itrig_sin b ofs ->NamedBound PprzTrigPlain.Execution.ge PprzTrigPlain.Source._pprz_trig_int 6434 2 b ofs.
Proof.
 intros b ofs[ids[id[n[index[[FF ID][IN[SYMBOL[OFFSET RANGE]]]]]]]];subst ids.
 cbn[plain_descriptor]in IN;destruct IN as[EQ|[]];inversion EQ;subst id n.
 split;[exact SYMBOL|exists index;split;[first[exact OFFSET|reflexivity]|exact RANGE]].
Qed.
Lemma encoder_bound_named:forall b ofs,EventBound PprzTrigInit.Execution.ge tuchar low_array_owner
 PprzTrigInit.Source.f_table_encode_12 b ofs ->NamedBound PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12 9651 1 b ofs.
Proof.
 intros b ofs[ids[id[n[index[OWN[IN[SYMBOL[OFFSET RANGE]]]]]]]].
 inversion OWN;subst;cbn[buffer_descriptor rom_descriptor]in IN;try contradiction;try discriminate;
 destruct IN as[EQ|[]];inversion EQ;subst id n.
 split;[exact SYMBOL|exists index;split;[first[exact OFFSET|reflexivity]|exact RANGE]].
Qed.
Lemma nibble_bound_named:forall b ofs,EventBound PprzTrigInit.Execution.ge tuchar low_array_owner
 PprzTrigInit.Source.f_get_nibble b ofs ->NamedBound PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr 1690 1 b ofs.
Proof.
 intros b ofs[ids[id[n[index[OWN[IN[SYMBOL[OFFSET RANGE]]]]]]]].
 inversion OWN;subst;cbn[buffer_descriptor rom_descriptor]in IN;try contradiction;try discriminate;
 destruct IN as[EQ|[]];inversion EQ;subst id n.
 split;[exact SYMBOL|exists index;split;[first[exact OFFSET|reflexivity]|exact RANGE]].
Qed.
Lemma decoder_bound_named:forall b ofs,EventBound PprzTrigLow.Execution.ge tuchar low_array_owner
 PprzTrigLow.Source.f_pprz_trig_int_12 b ofs ->NamedBound PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12 9651 1 b ofs.
Proof.
 intros b ofs[ids[id[n[index[OWN[IN[SYMBOL[OFFSET RANGE]]]]]]]].
 inversion OWN;subst;cbn[buffer_descriptor rom_descriptor]in IN;try contradiction;try discriminate;
 destruct IN as[EQ|[]];inversion EQ;subst id n.
 split;[exact SYMBOL|exists index;split;[first[exact OFFSET|reflexivity]|exact RANGE]].
Qed.
Definition PlainArrayBounds:Prop:=forall initial input prefix a k e m b ofs,
 Spec.initial_plain initial->Spec.normalized_angle input->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry(Vint input::nil)initial)prefix
 (ExprState PprzTrigPlain.Source.f_pprz_itrig_sin a k e m)->ArrayEvent tshort a b ofs ->
 NamedBound PprzTrigPlain.Execution.ge PprzTrigPlain.Source._pprz_trig_int 6434 2 b ofs.
Theorem prove_PlainArrayBounds:PlainArrayBounds.
Proof. intros;apply plain_bound_named;eapply every_plain_array_event;eauto. Qed.
Definition InitRomBounds:Prop:=forall initial prefix a k e m b ofs,
 Spec.initial_low initial->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry nil initial)prefix
 (ExprState PprzTrigInit.Source.f_get_nibble a k e m)->ArrayEvent tuchar a b ofs ->
 NamedBound PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr 1690 1 b ofs.
Theorem prove_InitRomBounds:InitRomBounds.
Proof. intros;apply nibble_bound_named;eapply every_initialized_array_event;eauto. Qed.
Definition InitBufferBounds:Prop:=forall initial prefix a k e m b ofs,
 Spec.initial_low initial->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry nil initial)prefix
 (ExprState PprzTrigInit.Source.f_table_encode_12 a k e m)->ArrayEvent tuchar a b ofs ->
 NamedBound PprzTrigInit.Execution.ge PprzTrigInit.Source._data_buf_12 9651 1 b ofs.
Theorem prove_InitBufferBounds:InitBufferBounds.
Proof. intros;apply encoder_bound_named;eapply every_initialized_array_event;eauto. Qed.
Definition LowBufferBounds:Prop:=forall initial after input prefix a k e m b ofs,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after->Spec.normalized_angle input->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry(Vint input::nil)after)prefix
 (ExprState PprzTrigLow.Source.f_pprz_trig_int_12 a k e m)->ArrayEvent tuchar a b ofs ->
 NamedBound PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12 9651 1 b ofs.
Theorem prove_LowBufferBounds:LowBufferBounds.
Proof. intros;apply decoder_bound_named;eapply every_low_array_event;eauto. Qed.
Definition InitializedDecoderBounds:Prop:=forall initial after index prefix a k e m b ofs,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after->0<=Int.signed index<6434->
 star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal LowDecoder.decoder)(Vint index::nil)Kstop after)prefix
 (ExprState PprzTrigLow.Source.f_pprz_trig_int_12 a k e m)->ArrayEvent tuchar a b ofs ->
 NamedBound PprzTrigLow.Execution.ge PprzTrigLow.Source._data_buf_12 9651 1 b ofs.
Theorem prove_InitializedDecoderBounds:InitializedDecoderBounds.
Proof. intros;apply decoder_bound_named;eapply every_initialized_decoder_array_event;eauto. Qed.
Print Assumptions prove_PlainArrayBounds.
Print Assumptions prove_InitRomBounds.
Print Assumptions prove_InitBufferBounds.
Print Assumptions prove_LowBufferBounds.
Print Assumptions prove_InitializedDecoderBounds.
