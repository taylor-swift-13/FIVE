From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Integers Floats AST Values Memory Memdata Events Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From FiveRmatVmultCase Require Import Memcpy.
Import ListNotations.
Local Open Scope Z_scope.
Definition WordAt(b:block)(ofs:Z):expr:=Evalof(Eloc b(Ptrofs.repr ofs)Full tuint)tuint.
Definition WordEq(a b:block)(ofs:Z):expr:=Ebinop Oeq(WordAt a ofs)(WordAt b ofs)tint.
(* Original harness operator structure, after array-address resolution:
   ab[0]==bb[0] && ab[1]==bb[1] && ab[2]==bb[2], left associative. *)
Definition ThreeWordAssertion(a b:block):expr:=
 Eseqand(Eseqand(WordEq a b 0)(WordEq a b 4)tint)(WordEq a b 8)tint.
Lemma load_uint32_at_zero:forall ge m b x,
 Mem.load Mint32 m b 0=Some(Vint x)->
 deref_loc ge tuint m b Ptrofs.zero Full E0(Vint x).
Proof. intros ge m b x LOAD;eapply deref_loc_value;[reflexivity|reflexivity|].
 unfold Mem.loadv;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact LOAD|change(4<=18446744073709551616);lia]. Qed.
Theorem first_word_false_shortcircuit:forall ge f e m a b x y tail1 tail2,
 Mem.load Mint32 m a 0=Some(Vint x)->Mem.load Mint32 m b 0=Some(Vint y)->Int.eq x y=false->
 star Csem.step ge
 (ExprState f(Eseqand(Eseqand(WordEq a b 0)tail1 tint)tail2 tint)Kstop e m)E0
 (ExprState f(Eval(Vint Int.zero)tint)Kstop e m).
Proof.
 intros ge f e m a b x y tail1 tail2 LA LB NE;unfold WordEq,WordAt.
 eapply star_step with(s2:=ExprState f
 (Eseqand(Eseqand(Ebinop Oeq(Eval(Vint x)tuint)(Evalof(Eloc b Ptrofs.zero Full tuint)tuint)tint)tail1 tint)tail2 tint)Kstop e m)(t1:=E0)(t2:=E0).
 - left;eapply step_rred with(C:=fun w=>Eseqand(Eseqand(Ebinop Oeq w(Evalof(Eloc b Ptrofs.zero Full tuint)tuint)tint)tail1 tint)tail2 tint).
 + apply red_rvalof;apply load_uint32_at_zero;exact LA.
 + apply ctx_seqand;apply ctx_seqand;apply ctx_binop_left;apply ctx_top.
 - eapply star_step with(s2:=ExprState f
 (Eseqand(Eseqand(Ebinop Oeq(Eval(Vint x)tuint)(Eval(Vint y)tuint)tint)tail1 tint)tail2 tint)Kstop e m)(t1:=E0)(t2:=E0).
 + left;eapply step_rred with(C:=fun w=>Eseqand(Eseqand(Ebinop Oeq(Eval(Vint x)tuint)w tint)tail1 tint)tail2 tint).
 * apply red_rvalof;apply load_uint32_at_zero;exact LB.
 * apply ctx_seqand;apply ctx_seqand;apply ctx_binop_right;apply ctx_top.
 + eapply star_step with(s2:=ExprState f
 (Eseqand(Eseqand(Eval(Vint Int.zero)tint)tail1 tint)tail2 tint)Kstop e m)(t1:=E0)(t2:=E0).
 * left;eapply step_rred with(C:=fun w=>Eseqand(Eseqand w tail1 tint)tail2 tint).
 -- apply red_binop;change(Some(if Int.eq x y then Vint Int.one else Vint Int.zero)=Some(Vint Int.zero));rewrite NE;reflexivity.
 -- apply ctx_seqand;apply ctx_seqand;apply ctx_top.
 * eapply star_step with(s2:=ExprState f(Eseqand(Eval(Vint Int.zero)tint)tail2 tint)Kstop e m)(t1:=E0)(t2:=E0).
 -- left;eapply step_rred with(C:=fun w=>Eseqand w tail2 tint);[apply red_seqand_false;reflexivity|apply ctx_seqand;apply ctx_top].
 -- eapply star_step with(s2:=ExprState f(Eval(Vint Int.zero)tint)Kstop e m)(t1:=E0)(t2:=E0).
 ++ left;eapply step_rred with(C:=fun w=>w);[apply red_seqand_false;reflexivity|apply ctx_top].
 ++ constructor.
 ++ reflexivity.
 -- reflexivity.
 * reflexivity.
 + reflexivity.
 - reflexivity.
Qed.
Theorem assertion_false_steps:forall ge f e m a b x y,
 Mem.load Mint32 m a 0=Some(Vint x)->Mem.load Mint32 m b 0=Some(Vint y)->Int.eq x y=false->
 star Csem.step ge(ExprState f(ThreeWordAssertion a b)Kstop e m)E0
 (ExprState f(Eval(Vint Int.zero)tint)Kstop e m).
Proof. intros;unfold ThreeWordAssertion;eapply first_word_false_shortcircuit;eauto. Qed.
Theorem uint32_vector_firstword:forall m b x y z,
 Mem.loadbytes m b 0 12=Some(encode_val Mint32(Vint x)++encode_val Mint32(Vint y)++encode_val Mint32(Vint z))->
 Mem.load Mint32 m b 0=Some(Vint x).
Proof.
 intros m b x y z BYTES.
 destruct(Mem.loadbytes_split m b 0 4 8 _ BYTES ltac:(lia)ltac:(lia))as[a[rest[A[REST EQ]]]].
 pose proof(Mem.loadbytes_length _ _ _ _ _ A)as LA.
 assert(LX:length(encode_val Mint32(Vint x))=4%nat)by(rewrite encode_val_length;reflexivity).
 destruct(append_cut _ a rest(encode_val Mint32(Vint x))(encode_val Mint32(Vint y)++encode_val Mint32(Vint z))ltac:(change(length a=4%nat)in LA;lia)(eq_sym EQ))as[-> EREST].
 pose proof(Mem.loadbytes_load Mint32 m b 0 _ A(ex_intro _ 0 eq_refl))as LD.
 pose proof(decode_encode_val_general(Vint x)Mint32 Mint32)as DX.
 change(decode_val Mint32(encode_val Mint32(Vint x))=Vint x)in DX;rewrite DX in LD;exact LD.
Qed.
Lemma single_bytes_as_uint32:forall x,encode_val Mfloat32(Vsingle x)=encode_val Mint32(Vint(Float32.to_bits x)).
Proof. intros;reflexivity. Qed.
Theorem float_vector_firstword:forall m b x y z,
 Mem.loadbytes m b 0 12=Some(encode_val Mfloat32(Vsingle x)++encode_val Mfloat32(Vsingle y)++encode_val Mfloat32(Vsingle z))->
 Mem.load Mint32 m b 0=Some(Vint(Float32.to_bits x)).
Proof. intros;repeat rewrite single_bytes_as_uint32 in H;eapply uint32_vector_firstword;exact H. Qed.
Print Assumptions assertion_false_steps.
Print Assumptions uint32_vector_firstword.
Print Assumptions float_vector_firstword.
